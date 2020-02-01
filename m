Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE23A14F99D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgBASwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:11279 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgBASwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075601"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 57/61] KVM: x86/mmu: Merge kvm_{enable,disable}_tdp() into a common function
Date:   Sat,  1 Feb 2020 10:52:14 -0800
Message-Id: <20200201185218.24473-58-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Combine kvm_enable_tdp() and kvm_disable_tdp() into a single function,
kvm_configure_mmu(), in preparation for doing additional configuration
during hardware setup.  And because having separate helpers is silly.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/mmu/mmu.c          | 13 +++----------
 arch/x86/kvm/svm.c              |  5 +----
 arch/x86/kvm/vmx/vmx.c          |  4 +---
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a8bae9d88bce..1a13a53bbaeb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1494,8 +1494,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
 
-void kvm_enable_tdp(void);
-void kvm_disable_tdp(void);
+void kvm_configure_mmu(bool enable_tdp);
 
 static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 				  struct x86_exception *exception)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84eeb61d06aa..08c80c7c88d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5541,18 +5541,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
-void kvm_enable_tdp(void)
+void kvm_configure_mmu(bool enable_tdp)
 {
-	tdp_enabled = true;
+	tdp_enabled = enable_tdp;
 }
-EXPORT_SYMBOL_GPL(kvm_enable_tdp);
-
-void kvm_disable_tdp(void)
-{
-	tdp_enabled = false;
-}
-EXPORT_SYMBOL_GPL(kvm_disable_tdp);
-
+EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
 typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_head);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 80962c1eea8f..19dc74ae1efb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1443,10 +1443,7 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled && !npt)
 		npt_enabled = false;
 
-	if (npt_enabled)
-		kvm_enable_tdp();
-	else
-		kvm_disable_tdp();
+	kvm_configure_mmu(npt_enabled);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6284b6aac56..59206c22b5e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5295,7 +5295,6 @@ static void vmx_enable_tdp(void)
 		VMX_EPT_RWX_MASK, 0ull);
 
 	ept_set_mmio_spte_mask();
-	kvm_enable_tdp();
 }
 
 /*
@@ -7678,8 +7677,7 @@ static __init int hardware_setup(void)
 
 	if (enable_ept)
 		vmx_enable_tdp();
-	else
-		kvm_disable_tdp();
+	kvm_configure_mmu(enable_ept);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
-- 
2.24.1

