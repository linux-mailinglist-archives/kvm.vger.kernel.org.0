Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE1B6E1CA2
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjDNG3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDNG3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:29:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480AA6E81;
        Thu, 13 Apr 2023 23:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453716; x=1712989716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+s5KvYMusSaBPhAswQRMb5rkzIBy2Ox8RpqDXltBT8=;
  b=IEzHSEe3d/CopVstLY62k53YuWPXjo/qzmd77IJ/HAC3Ik2L3Iw/+qUl
   K+GYEvM/fm5Xck2ik8Lz9mGiEkXBzktzHz3BKGZCUazjlh0exmUNxYnEJ
   sEArMMN42ENJRAJQiD5LPHsTyY1dPBFa1mn86c9i/T+z6zMFbNMVe9Iuu
   hytmuzTLGK9zb4RSxJKYm8aFyVtF1krfqwlP28vwXQoQ+9U/m4/uNtMub
   6Qe6qoTyWf2AqnPrIim0/ycZfihgeoiba0yE1OCvz+BiblE5BLSLNyPUS
   6bbN+W1TcF5GR+pakP4pQ1cMVUmB0LkXtREWPS5mQr1LFFauZb9AfXoc6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892825"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892825"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885943"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885943"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:28 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 06/11] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM support
Date:   Fri, 14 Apr 2023 14:25:27 +0800
Message-Id: <20230414062545.270178-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Chen <chen.zhang@intel.com>

Bit 63 of IA32_ARCH_CAPABILITIES MSR indicates availablility of the
VIRTUAL_ENUMERATION_MSR (index 0x50000000) that enumerates features like
e.g., mitigation enumeration which is used for guest to hint VMMs the
software mitigations in use.

Advertise ARCH_CAP_VIRTUAL_ENUM support for VMX and emulate read/write
of the VIRTUAL_ENUMERATION_MSR. Now VIRTUAL_ENUMERATION_MSR is always 0.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 arch/x86/kvm/x86.c     | 16 +++++++++++++++-
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 57f241c5a371..195d0cf9309a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4093,6 +4093,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_VIRTUAL_ENUMERATION:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9f6919bec2b3..85419137decb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1943,6 +1943,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
+#define VIRTUAL_ENUMERATION_VALID_BITS	0ULL
+
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
@@ -1950,6 +1952,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
+	case MSR_VIRTUAL_ENUMERATION:
+		msr->data = VIRTUAL_ENUMERATION_VALID_BITS;
+		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
@@ -2096,6 +2101,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (!msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
+			return 1;
+		msr_info->data = vmx->msr_virtual_enumeration;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2437,6 +2448,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (data & ~VIRTUAL_ENUMERATION_VALID_BITS)
+			return 1;
+
+		vmx->msr_virtual_enumeration = data;
+		break;
 
 	default:
 	find_uret_msr:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 021d86b52e18..a7faaf9fdc26 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -292,6 +292,7 @@ struct vcpu_vmx {
 
 	u64		      spec_ctrl;
 	u64		      guest_spec_ctrl;
+	u64		      msr_virtual_enumeration;
 	u32		      msr_ia32_umwait_control;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c58dbae7b4c..a1bc52bebdcc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1537,6 +1537,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_VIRTUAL_ENUMERATION,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -1570,6 +1571,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
+	MSR_VIRTUAL_ENUMERATION,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
@@ -1591,7 +1593,8 @@ static unsigned int num_msr_based_features;
 	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
 	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
 	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
-	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
+	 ARCH_CAP_VIRTUAL_ENUM)
 
 static u64 kvm_get_arch_capabilities(void)
 {
@@ -1610,6 +1613,17 @@ static u64 kvm_get_arch_capabilities(void)
 	 */
 	data |= ARCH_CAP_PSCHANGE_MC_NO;
 
+	/*
+	 * Virtual enumeration is a paravirt feature. The only usage for now
+	 * is to bridge the gap caused by microarchitecture changes between
+	 * different Intel processors. And its usage is linked to "virtualize
+	 * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can benefit
+	 * from the same usage and how to implement it is still unclear. Limit
+	 * virtual enumeration to VMX.
+	 */
+	if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUMERATION))
+		data |= ARCH_CAP_VIRTUAL_ENUM;
+
 	/*
 	 * If we're doing cache flushes (either "always" or "cond")
 	 * we will do one whenever the guest does a vmlaunch/vmresume.
-- 
2.40.0

