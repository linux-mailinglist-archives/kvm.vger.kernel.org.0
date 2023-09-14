Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A67A0061
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbjINJip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbjINJi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323691FC6;
        Thu, 14 Sep 2023 02:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684301; x=1726220301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlHnWyHRSXxxRhVYMCd0RGmIeUUDEFAPvADSMDz/aBU=;
  b=fpU2R+va+0unNcE5frrR2g6O+qIlBIG9i4RYfEq15BkcmR/Z89oUs3iJ
   apkzLFCbBRnTJBjuPEH3m5DjGAQI3WAzbSpHyzFJiom1ux8EEPCb7lkuu
   KFImlQnT5SBM+1komwCLnYsOHKoEO+o1dpbER6xGRn8NMY3uDCmuGvYE2
   673uV+fhOOZAOsF5U+eGtX0ByR7CGFr2ZXK0NR618vjajN/e15R6NyEQ6
   zNB4JS02LMJRlo7/LmqLHTAkRTE6gMtQLZmqfnnejXXl4DI3tWKKNRyE1
   ErLoMdeHZL2gJ5BiZ6t1JjQ9asG7hCar25TKhGnp9Z/mqFrn015LxPMQY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857385"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857385"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656260"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656260"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:20 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
Date:   Thu, 14 Sep 2023 02:33:14 -0400
Message-Id: <20230914063325.85503-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Load the guest's FPU state if userspace is accessing MSRs whose values
are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
to facilitate access to such kind of MSRs.

If MSRs supported in kvm_caps.supported_xss are passed through to guest,
the guest MSRs are swapped with host's before vCPU exits to userspace and
after it re-enters kernel before next VM-entry.

Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
explicitly check @vcpu is non-null before attempting to load guest state.
The XSS supporting MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed to
access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66edbed25db8..a091764bf1d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -4372,6 +4375,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+static const u32 xstate_msrs[] = {
+	MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
+	MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
+};
+
+static bool is_xstate_msr(u32 index)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
+		if (index == xstate_msrs[i])
+			return true;
+	}
+	return false;
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -4382,11 +4401,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
+		    is_xstate_msr(entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..9a8e3a84eaf4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -540,4 +540,28 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+/*
+ * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
+ * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
+ * guest FPU should have been loaded already.
+ */
+
+static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
+{
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+	kvm_fpu_get();
+	rdmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
+{
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+	kvm_fpu_get();
+	wrmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
 #endif
-- 
2.27.0

