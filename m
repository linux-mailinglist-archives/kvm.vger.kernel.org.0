Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D2F54DD60
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376523AbiFPItH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376395AbiFPIsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518545DE75;
        Thu, 16 Jun 2022 01:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369269; x=1686905269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7f++4irz+MftuwUCaj4ppD4AhCBg8dypPeUQuLNrFYQ=;
  b=CZPdHNG2MLrnH4Cz1KXviKnv7TKGd+WzAv/Rxf3i5fXiZ31YbuZhmq3k
   ZffYkWwt2sGq/bmz/av4RTqnO+OPfMrHF1iPnVwrNAqVgb7ILj+BKWMMj
   2DjiRq0KJ6pbiGWa4/q1DR1LwI35tuUR0Jm/pLO/XZ0152Lqd+4lfQGl4
   q3/9I9thHihe4l6jzvdpHoHmBuAlHJMg9cDUVl32u4MogQIvQcoBnmoFA
   42oXuBA1g3+lQwO34M6JwUEEvwruX1H8Xrtg2zHDKQVkAFGhO9C5qChTp
   sFr4xVPRnhnDLiI3AP7geiGsf2Y9qzViMnW89u3t8WPpLwOFJIBHFIblT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259055235"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259055235"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083184"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH 19/19] KVM: x86: Enable supervisor IBT support for guest
Date:   Thu, 16 Jun 2022 04:46:43 -0400
Message-Id: <20220616084643.19564-20-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mainline kernel now supports supervisor IBT for kernel code,
to make s-IBT work in guest(nested guest), pass through
MSR_IA32_S_CET to guest(nested guest) if host kernel and KVM
enabled IBT. Note, s-IBT can work independent to host xsaves
support because guest MSR_IA32_S_CET can be stored/loaded from
specific VMCS field.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.h      |  5 +++++
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++++++++++++---
 arch/x86/kvm/x86.c        | 13 ++++++++++++-
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index ac72aabba981..c67c1e2fc11a 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -230,4 +230,9 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+static __always_inline bool cet_kernel_ibt_supported(void)
+{
+	return HAS_KERNEL_IBT && kvm_cpu_cap_has(X86_FEATURE_IBT);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f31f3d394507..d394136891d0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -688,6 +688,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_U_CET, MSR_TYPE_RW);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 00782d1750a5..6e7e596c0147 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -585,6 +585,7 @@ static bool is_valid_passthrough_msr(u32 msr)
 		return true;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_IA32_S_CET:
 		return true;
 	}
 
@@ -1773,7 +1774,8 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 				  struct msr_data *msr)
 {
-	if (!kvm_cet_user_supported())
+	if (!kvm_cet_user_supported() &&
+	    !cet_kernel_ibt_supported())
 		return false;
 
 	if (msr->host_initiated)
@@ -1783,6 +1785,10 @@ static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
+	if (msr->index == MSR_IA32_S_CET &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return true;
+
 	if ((msr->index == MSR_IA32_PL3_SSP ||
 	     msr->index == MSR_KVM_GUEST_SSP) &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
@@ -1933,10 +1939,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_S_CET:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (msr_info->index == MSR_KVM_GUEST_SSP)
 			msr_info->data = vmcs_readl(GUEST_SSP);
+		else if (msr_info->index == MSR_IA32_S_CET)
+			msr_info->data = vmcs_readl(GUEST_S_CET);
 		else
 			kvm_get_xsave_msr(msr_info);
 		break;
@@ -2273,12 +2282,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
 	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(9, 6)) ||
 		    is_noncanonical_address(data, vcpu))
 			return 1;
-		kvm_set_xsave_msr(msr_info);
+		if (msr_index == MSR_IA32_S_CET)
+			vmcs_writel(GUEST_S_CET, data);
+		else
+			kvm_set_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
@@ -7615,6 +7628,9 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 
 	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
+
+	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -7680,7 +7696,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 
-	if (kvm_cet_user_supported())
+	if (kvm_cet_user_supported() || cet_kernel_ibt_supported())
 		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
@@ -7743,6 +7759,11 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 #endif
 
+#ifndef CONFIG_X86_KERNEL_IBT
+	if (boot_cpu_has(X86_FEATURE_IBT))
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+#endif
+
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe049d0e5ecc..c0118b33806a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1463,6 +1463,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
 	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
+	MSR_IA32_S_CET,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6823,6 +6824,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cet_user_supported())
 				continue;
 			break;
+		case MSR_IA32_S_CET:
+			if (!cet_kernel_ibt_supported())
+				continue;
+			break;
 		default:
 			break;
 		}
@@ -11830,7 +11835,13 @@ int kvm_arch_hardware_setup(void *opaque)
 	/* Update CET features now as kvm_caps.supported_xss is finalized. */
 	if (!kvm_cet_user_supported()) {
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		/* If CET user bit is disabled due to cmdline option such as
+		 * noxsaves, but kernel IBT is on, this means we can expose
+		 * kernel IBT alone to guest since CET user mode msrs are not
+		 * passed through to guest.
+		 */
+		if (!cet_kernel_ibt_supported())
+			kvm_cpu_cap_clear(X86_FEATURE_IBT);
 	}
 
 	/*
-- 
2.27.0

