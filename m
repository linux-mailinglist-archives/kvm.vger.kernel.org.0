Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B32076E1C3
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjHCHh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjHCHgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:11 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAB849E0;
        Thu,  3 Aug 2023 00:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047941; x=1722583941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwU1VFqu3usr+HP49DlB/+X38Ghi5qAmy1D4scHrxkA=;
  b=D1Qg06nDEioHG+a5I2LwNpH5aK2mBrMBsnlQW/6DqEtHDRPYslQ3EHq+
   Vn+/nF/9iE1Lk3g1fWTNHZLA9MLguK8vP8Q48bqrWvNHNp4hHrT4ze83f
   Wf/3QCuRat6bud698nfoQh/IIucoo/UW9kep5k5lKuQY0iIM1vmfk1A2l
   jiNX6vRDhIKA9lFEwwBEW8QdkbSKK+FYtZQ8N+eMmCFPytFp9bT1Cyj6O
   85RlKWKziTB5MXISVQX6JVcFnsCwkPgSt5L9qCD8iohy+Mgm0QXiLwpLX
   /CJ/txgf6tIu/MoSrpWPANrKFl2qPJZ5OqX6O+GAUxQR5cEEKyt9jtzAo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708158"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708158"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888514"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888514"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 15/19] KVM:x86: Optimize CET supervisor SSP save/reload
Date:   Thu,  3 Aug 2023 00:27:28 -0400
Message-Id: <20230803042732.88515-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
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

Make PL{0,1,2}_SSP as write-intercepted to detect whether
guest is using these MSRs. Disable intercept to the MSRs
if they're written with non-zero values. KVM does save/
reload for the MSRs only if they're used by guest.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 31 ++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  8 ++++++--
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69cbc9d9b277..c50b555234fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	bool xfd_no_write_intercept;
+	bool cet_sss_active;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99bf63b2a779..96e22515ed13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2152,6 +2152,18 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static void vmx_disable_write_intercept_sss_msr(struct kvm_vcpu *vcpu)
+{
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+					  MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+					  MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+					  MSR_TYPE_RW, false);
+	}
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2420,6 +2432,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+		if (kvm_set_msr_common(vcpu, msr_info))
+			return 1;
+		if (data) {
+			vmx_disable_write_intercept_sss_msr(vcpu);
+			wrmsrl(msr_index, data);
+		}
+		break;
 	case MSR_IA32_S_CET:
 	case MSR_KVM_GUEST_SSP:
 	case MSR_IA32_INT_SSP_TAB:
@@ -7777,12 +7797,17 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 					  MSR_TYPE_RW, incpt);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
 					  MSR_TYPE_RW, incpt);
+		/*
+		 * Supervisor shadow stack MSRs are intercepted until
+		 * they're written by guest, this is designed to
+		 * optimize the save/restore overhead.
+		 */
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
-					  MSR_TYPE_RW, incpt);
+					  MSR_TYPE_R, incpt);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
-					  MSR_TYPE_RW, incpt);
+					  MSR_TYPE_R, incpt);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
-					  MSR_TYPE_RW, incpt);
+					  MSR_TYPE_R, incpt);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
 					  MSR_TYPE_RW, incpt);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01b4f10fa8ab..fa3e7f7c639f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4060,6 +4060,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
 		    msr == MSR_IA32_PL2_SSP) {
 			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
+			if (!vcpu->arch.cet_sss_active && data)
+				vcpu->arch.cet_sss_active = true;
 		} else if (msr == MSR_IA32_PL3_SSP) {
 			kvm_set_xsave_msr(msr_info);
 		}
@@ -11241,7 +11243,8 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		     vcpu->arch.cet_sss_active)) {
 		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
 		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
 		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
@@ -11256,7 +11259,8 @@ EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
 
 void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		     vcpu->arch.cet_sss_active)) {
 		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
 		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
 		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
-- 
2.27.0

