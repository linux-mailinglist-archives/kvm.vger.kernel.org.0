Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852EC6A3C81
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjB0IZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjB0IYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:50 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8568C1ACE1;
        Mon, 27 Feb 2023 00:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486254; x=1709022254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tznujyOV/xWUCOerVv7HhNu3v4jxWrzWup7DnAlogmI=;
  b=FU5wC84IVBNBDqeNz6fAL3OaocU/Spr0CWjRTuwenBWqd3ugaI3s1dI0
   8p6gefkpY90QtPCGlxRpWzPPUPmTZanlUXpphRSs94u7VLCk0D8WTNkiy
   MBZmz4iN3kT20193g3DgeXNIDtT4gHmNpt8L0uCsHlHqDkumzvfNs+ovR
   gv1vk0bnSk+IjzzCKM0Mgtpli2Q0mwqdRdVjQZKcENoji/EXK0Lr9ilep
   yqTbHbWOYSu+D3jG0TrD7YMQuTq5HR596Zlt6b9UsNEQAxHtTOrt89pd3
   mBpJLkaJnPehZ3iLbSqlop+Z2xhaPK/P7yc05fiHCCV0M3EdcPWZ9Y6ad
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608755"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608755"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242112"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242112"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v12 022/106] KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
Date:   Mon, 27 Feb 2023 00:22:21 -0800
Message-Id: <859cd56a7d059d5549536e88f2882b8495940e6b.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
GPA.shared is set, GPA is covered by the existing conventional EPT pointed
by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
VMM has to issue SEAMCALLs to operate.

Add a member to remember GPA shared bit for each guest TDs, add address
conversion functions between private GPA and shared GPA and test if GPA
is private.

Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
the new member to remember GPA shared bit is guaranteed to be zero with
this patch unless it's initialized explicitly.

Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c          |  5 +++++
 3 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bc8d40572238..e8506b48b97c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1448,6 +1448,10 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	gfn_t gfn_shared_mask;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 168c46fd8dd1..951b14079602 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -278,4 +278,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	return kvm->arch.gfn_shared_mask;
+#else
+	return 0;
+#endif
+}
+
+static inline gfn_t kvm_gfn_shared(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn | kvm_gfn_shared_mask(kvm);
+}
+
+static inline gfn_t kvm_gfn_private(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & ~kvm_gfn_shared_mask(kvm);
+}
+
+static inline gpa_t kvm_gpa_private(const struct kvm *kvm, gpa_t gpa)
+{
+	return gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(kvm));
+}
+
+static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
+{
+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ae7acf78631f..3f61cdc53c57 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -851,6 +851,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
+
 out:
 	/* kfree() accepts NULL. */
 	kfree(init_vm);
-- 
2.25.1

