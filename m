Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713716E1CA4
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjDNG3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjDNG3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:29:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480847D83;
        Thu, 13 Apr 2023 23:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453725; x=1712989725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jN0Hzne3tYzZM0LZp9SZV2+qR7XpaLOF/E8FJ2yQai4=;
  b=UvgD2XH12cOZ+up+K34vdXnfMNtHt2bzgQuOs53gqEIJnJMTUyTMGsUR
   yHp5kMosXIhSNN8SH+PBcCOnH2nja2X89V+G7ITNJStxVzH7ygvVf0Vd2
   HOOtHpUnb/J8LxgYUV/BzNxP5mO4OV84Cgr/Q+wFvNxnVEngTagLYadm6
   SWkpOS2zz/N7bFYil0jb7XCIzMsZJxpGEF/gmzcGJ+LbAHxbYBAJ/RZYM
   KfvhSMni/644hI5qwAVIG6wfCwBgpA3j6+PdTacPCPRyWX4qePi/aHZ8h
   0TiPvZBToJEDix+VbIHVid+HvqbLaBNr2DZ1XIDfF87qyJnEohb3kBi5B
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892849"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892849"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885954"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885954"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:33 -0700
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
Subject: [RFC PATCH v2 07/11] KVM: VMX: Advertise MITIGATION_CTRL support
Date:   Fri, 14 Apr 2023 14:25:28 +0800
Message-Id: <20230414062545.270178-8-chao.gao@intel.com>
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

Advertise MITIGATION_CTRL support and emulate accesses to two associated
MSRs.

MITIGATION_CTRL is enumerated by bit 0 of MSR_VIRTUAL_ENUMERATION. If
supported, two virtual MSRs MSR_VIRTUAL_MITIGATION_ENUM(0x50000001) and
MSR_VIRTUAL_MITIGATION_CTRL(0x50000002) are available.

The two MSRs are used to for guest to report software mitigation status.
Such information is preserved across live migration, therefore KVM can
leverage the information to deploy necessary hardware mitigation for
guests to guarantee guests maintain the same security level after
migration.

Note that MSR_VIRTUAL_MITIGATION_ENUM is also a feature MSR since each
bit in the MSR represents a software mitigation that the underlying VMM
understands.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h |  2 ++
 arch/x86/kvm/x86.c     |  3 +++
 4 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 195d0cf9309a..80bb7a62e9b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4094,6 +4094,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_VIRTUAL_ENUMERATION:
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+	case MSR_VIRTUAL_MITIGATION_CTRL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85419137decb..980498c4c30c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1943,7 +1943,9 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-#define VIRTUAL_ENUMERATION_VALID_BITS	0ULL
+#define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
+#define MITI_ENUM_VALID_BITS		0ULL
+#define MITI_CTRL_VALID_BITS		0ULL
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -1955,6 +1957,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	case MSR_VIRTUAL_ENUMERATION:
 		msr->data = VIRTUAL_ENUMERATION_VALID_BITS;
 		return 0;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		msr->data = MITI_ENUM_VALID_BITS;
+		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
@@ -2107,6 +2112,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmx->msr_virtual_enumeration;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_enum;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_ctrl;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2456,7 +2473,23 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vmx->msr_virtual_enumeration = data;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (data & ~MITI_ENUM_VALID_BITS)
+			return 1;
+
+		vmx->msr_virtual_mitigation_enum = data;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		if (data & ~MITI_CTRL_VALID_BITS)
+			return 1;
 
+		vmx->msr_virtual_mitigation_ctrl = data;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -4852,6 +4885,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->rmode.vm86_active = 0;
 	vmx_set_spec_ctrl_mask(vmx, 0);
 	vmx_set_guest_spec_ctrl(vmx, 0);
+	vmx->msr_virtual_mitigation_ctrl = 0;
 
 	vmx->msr_ia32_umwait_control = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a7faaf9fdc26..b81480c879b5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -293,6 +293,8 @@ struct vcpu_vmx {
 	u64		      spec_ctrl;
 	u64		      guest_spec_ctrl;
 	u64		      msr_virtual_enumeration;
+	u64		      msr_virtual_mitigation_enum;
+	u64		      msr_virtual_mitigation_ctrl;
 	u32		      msr_ia32_umwait_control;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1bc52bebdcc..3b567dc03b27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1538,6 +1538,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
+	MSR_VIRTUAL_MITIGATION_CTRL,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -1572,6 +1574,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
-- 
2.40.0

