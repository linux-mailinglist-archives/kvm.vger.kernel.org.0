Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308C26FEC97
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbjEKHQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237625AbjEKHPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:15:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD5BA5CC;
        Thu, 11 May 2023 00:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789275; x=1715325275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mK53r6YiSNjTM8Iq2DJUiKNRLNWiYAEdm4DYvtOj8+c=;
  b=T09nLY+VJqyiIv8slJtOCwmUC50N4tR7TibCnRSkTBVCHp/6iyX6D5ds
   SDDpH/2lXobUTEArgxLzZofCWztkOuynVMjHA9y8W5Wqsj4MJ69JGIBGx
   Eh2uQTJnf7vKsQKCuLBnujG7Xqi1mHeC3KzQ1XlYV5v1MhbWmd9A5xv9e
   9PZsmBJNWLzuD4xu/LaiSGyqc/S4X+6kG6USk06G3g6e6rnZoKpyqfblZ
   eq/ArAuOkBb+98xFB4GiG4tUkapBjGecw5FRgIkrUF3cUp5BcJgiWio0N
   qJtXkTyf4f9c/ZrSiTL5jttM9xUFvpCkN9PfH685kk1hItkftR0gI9N3K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896713"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896713"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512395"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512395"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:27 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v3 20/21] KVM:x86: Enable kernel IBT support for guest
Date:   Thu, 11 May 2023 00:08:56 -0400
Message-Id: <20230511040857.6094-21-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable MSR_IA32_S_CET access for guest kernel IBT.

Mainline Linux kernel now supports supervisor IBT for kernel code,
to make s-IBT work in guest(nested guest), pass through MSR_IA32_S_CET
to guest(nested guest) if host kernel and KVM enabled IBT.

Note, s-IBT can work independent to host xsaves support because guest
MSR_IA32_S_CET is {stored|loaded} from VMCS GUEST_S_CET field.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 39 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c        |  7 ++++++-
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 522ac27d2534..bf690827bfee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -664,6 +664,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_U_CET, MSR_TYPE_RW);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a2494156902d..1d0151f9e575 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -711,6 +711,7 @@ static bool is_valid_passthrough_msr(u32 msr)
 		return true;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_IA32_S_CET:
 		return true;
 	}
 
@@ -2097,14 +2098,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
 	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
-		if (msr_info->index == MSR_KVM_GUEST_SSP)
+		if (msr_info->index == MSR_KVM_GUEST_SSP) {
 			msr_info->data = vmcs_readl(GUEST_SSP);
-		else
+		} else if (msr_info->index == MSR_IA32_S_CET) {
+			msr_info->data = vmcs_readl(GUEST_S_CET);
+		} else {
 			kvm_get_xsave_msr(msr_info);
+		}
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
@@ -2419,6 +2424,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
 	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
@@ -2430,10 +2436,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if ((msr_index == MSR_IA32_PL3_SSP ||
 		     msr_index == MSR_KVM_GUEST_SSP) && (data & GENMASK(2, 0)))
 			return 1;
-		if (msr_index == MSR_KVM_GUEST_SSP)
+		if (msr_index == MSR_KVM_GUEST_SSP) {
 			vmcs_writel(GUEST_SSP, data);
-		else
+		} else if (msr_index == MSR_IA32_S_CET) {
+			vmcs_writel(GUEST_S_CET, data);
+		} else {
 			kvm_set_xsave_msr(msr_info);
+		}
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
@@ -7322,6 +7331,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_wait_lapic_expire(vcpu);
 
+	/*
+	 * Save host MSR_IA32_S_CET so that it can be reloaded at vm_exit.
+	 * No need to save the other two vmcs fields as supervisor SHSTK
+	 * are not enabled on Intel platform now.
+	 */
+	if (IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
+	    (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_CET_STATE)) {
+		u64 msr;
+
+		rdmsrl(MSR_IA32_S_CET, msr);
+		vmcs_writel(HOST_S_CET, msr);
+	}
+
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
 
@@ -7735,6 +7757,13 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 
 	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
+
+	/*
+	 * If IBT is available to guest, then passthrough S_CET MSR too since
+	 * kernel IBT is already in mainline kernel tree.
+	 */
+	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -7805,7 +7834,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 
-	if (kvm_cet_user_supported())
+	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
 		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 858cb68e781a..b450361b94ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1471,6 +1471,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
 	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
+	MSR_IA32_S_CET,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -13652,7 +13653,8 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
 bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (!kvm_cet_user_supported())
+	if (!kvm_cet_user_supported() &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
 		return false;
 
 	if (msr->host_initiated)
@@ -13666,6 +13668,9 @@ bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	if (msr->index == MSR_KVM_GUEST_SSP)
 		return false;
 
+	if (msr->index == MSR_IA32_S_CET)
+		return guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+
 	if (msr->index == MSR_IA32_PL3_SSP &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
-- 
2.27.0

