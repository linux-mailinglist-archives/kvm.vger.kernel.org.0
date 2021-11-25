Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04A45D1DA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353911AbhKYA0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:24 -0500
Received: from mga12.intel.com ([192.55.52.136]:16285 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353052AbhKYAYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432276"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432276"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:29 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042418"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:28 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 56/59] KVM: TDX: Protect private mapping related SEAMCALLs with spinlock
Date:   Wed, 24 Nov 2021 16:20:39 -0800
Message-Id: <119fa4aa735e3185d62988893e242b62204641e7.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@intel.com>

Unlike legacy MMU, TDP MMU runs page fault handler concurrently.
However, TDX private mapping related SEAMCALLs cannot run concurrently
even they operate on different pages, because they need to acquire
exclusive access to secure EPT table.  Protect those SEAMCALLs with
spinlock, so they won't run concurrently even under TDP MMU.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 111 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h |   7 +++
 2 files changed, 108 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 64b2841064c4..53fc01f3bab1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -519,6 +519,8 @@ int tdx_vm_init(struct kvm *kvm)
 		tdx_add_td_page(&kvm_tdx->tdcs[i]);
 	}
 
+	spin_lock_init(&kvm_tdx->seamcall_lock);
+
 	/*
 	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
 	 * ioctl() to define the configure CPUID values for the TD.
@@ -1187,8 +1189,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
 	}
 }
 
-static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-				      enum pg_level level, kvm_pfn_t pfn)
+static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn << PAGE_SHIFT;
@@ -1215,6 +1217,15 @@ static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		return;
 	}
 
+	/*
+	 * In case of TDP MMU, fault handler can run concurrently.  Note
+	 * 'source_pa' is a TD scope variable, meaning if there are multiple
+	 * threads reaching here with all needing to access 'source_pa', it
+	 * will break.  However fortunately this won't happen, because below
+	 * TDH_MEM_PAGE_ADD code path is only used when VM is being created
+	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl (which
+	 * always uses vcpu 0's page table and protected by vcpu->mutex).
+	 */
 	WARN_ON(kvm_tdx->source_pa == INVALID_PAGE);
 	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
 
@@ -1227,8 +1238,25 @@ static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	kvm_tdx->source_pa = INVALID_PAGE;
 }
 
-static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				       kvm_pfn_t pfn)
+static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/*
+	 * Only TDP MMU needs to use spinlock, however for simplicity,
+	 * just always use spinlock for seamcall, regardless whether
+	 * legacy MMU or TDP MMU is being used.  For legacy MMU it
+	 * should not have noticeable performance impact since taking
+	 * spinlock w/o needing to wait should be fast.
+	 */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	__tdx_sept_set_private_spte(kvm, gfn, level, pfn);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+}
+
+static void __tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+					kvm_pfn_t pfn)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1262,8 +1290,19 @@ static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 	put_page(pfn_to_page(pfn));
 }
 
-static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
-				    enum pg_level level, void *sept_page)
+static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				       kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	__tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+}
+
+static int __tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *sept_page)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1281,7 +1320,22 @@ static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level)
+static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
+				    enum pg_level level, void *sept_page)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int ret;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	ret = __tdx_sept_link_private_sp(kvm, gfn, level, sept_page);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	return ret;
+}
+
+static void __tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1294,7 +1348,19 @@ static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &ex_ret);
 }
 
-static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level)
+static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	__tdx_sept_zap_private_spte(kvm, gfn, level);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+}
+
+static void __tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+					  enum pg_level level)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1307,8 +1373,19 @@ static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_leve
 		pr_tdx_error(TDH_MEM_RANGE_UNBLOCK, err, &ex_ret);
 }
 
-static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				    void *sept_page)
+static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	__tdx_sept_unzap_private_spte(kvm, gfn, level);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+}
+
+static int __tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				      void *sept_page)
 {
 	/*
 	 * free_private_sp() is (obviously) called when a shadow page is being
@@ -1320,6 +1397,20 @@ static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level le
 	return tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page));
 }
 
+static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    void *sept_page)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int ret;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	ret = __tdx_sept_free_private_sp(kvm, gfn, level, sept_page);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	return ret;
+}
+
 static int tdx_sept_tlb_remote_flush(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 39853a260e06..3b1a1e2878c2 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -37,6 +37,13 @@ struct kvm_tdx {
 	hpa_t source_pa;
 
 	u64 tsc_offset;
+
+	/*
+	 * Lock to prevent seamcalls from running concurrently
+	 * when TDP MMU is enabled, because TDP fault handler
+	 * runs concurrently.
+	 */
+	spinlock_t seamcall_lock;
 };
 
 union tdx_exit_reason {
-- 
2.25.1

