Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC317D8788
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344767AbjJZR0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjJZR0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:26:32 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A51AA;
        Thu, 26 Oct 2023 10:26:30 -0700 (PDT)
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39QHPUFh208880
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 26 Oct 2023 10:25:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39QHPUFh208880
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698341136;
        bh=+soeWjokAr6koOw8jyJylom0FYuC2ojwR4+8JV/w0LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9ptqjsxSG9IJBXK8ZGLXnoYLH5EsFkaEtTEDnZBkPUMQE+iklr378FIZTTW0FxtY
         d+WHwmY9RaBfpDXvIg3nwaNl8BluvrtqV+CjSXsI3TzHHVh/Kzxm6a/CR7BMv4LDYL
         KEcAaZ6Zd27ujUscR9VKX3mLVfgtjUZIaA5UHRszKuxN2ICZaOebt43h1y/1KHxgyh
         xuqOvDbNlu+9ql99/+P0VI6AhibHK917u0uHZLDGVs9Xf8DU1a7+Wqp27fxzSwF4/O
         2EpYgRwpJbHsFdETRID+HHrabBVzplsQG7b7N7jpoSvnrIscthA76lBjbNqgZLzoYF
         JpCvvh3CSPDlw==
From:   "Xin Li (Intel)" <xin@zytor.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, weijiang.yang@intel.com
Subject: [PATCH v2 2/2] KVM: VMX: Cleanup VMX misc information defines and usages
Date:   Thu, 26 Oct 2023 10:25:30 -0700
Message-Id: <20231026172530.208867-2-xin@zytor.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231026172530.208867-1-xin@zytor.com>
References: <20231026172530.208867-1-xin@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xin Li <xin3.li@intel.com>

Define VMX misc information fields with BIT_ULL()/GENMASK_ULL(), and move
VMX misc field macros to vmx.h if used in multiple files or where they are
used only once.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h |  4 ----
 arch/x86/include/asm/vmx.h       | 10 ++++------
 arch/x86/kvm/vmx/capabilities.h  |  4 ++--
 arch/x86/kvm/vmx/nested.c        | 34 ++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  2 +-
 6 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d83195f53e33..181366f1512c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1100,10 +1100,6 @@
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
-/* MSR_IA32_VMX_MISC bits */
-#define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
-#define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
-#define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
 /* AMD-V MSRs */
 
 #define MSR_VM_CR                       0xc0010114
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f919397900f1..6afda61429e6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -126,12 +126,10 @@
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 
 /* VMX_MISC bits and bitmasks */
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
-#define VMX_MISC_SAVE_EFER_LMA			0x00000020
-#define VMX_MISC_ACTIVITY_HLT			0x00000040
-#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
-#define VMX_MISC_ZERO_LEN_INS			0x40000000
-#define VMX_MISC_MSR_LIST_MULTIPLIER		512
+#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
+#define VMX_MISC_INTEL_PT			BIT_ULL(14)
+#define VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	BIT_ULL(29)
+#define VMX_MISC_ZERO_LEN_INS			BIT_ULL(30)
 
 /* VMFUNC functions */
 #define VMFUNC_CONTROL_BIT(x)	BIT((VMX_FEATURE_##x & 0x1f) - 28)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..c88e33a13ae1 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -225,7 +225,7 @@ static inline bool cpu_has_vmx_vmfunc(void)
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
 	/* check if the cpu supports writing r/o exit information fields */
-	if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
+	if (!(vmcs_config.misc & VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
 		return false;
 
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -367,7 +367,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
+	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 274d480d9071..40dd77c76565 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -886,6 +886,8 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#define VMX_MISC_MSR_LIST_MULTIPLIER	512
+
 static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1295,18 +1297,34 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	return 0;
 }
 
+#define VMX_MISC_SAVE_EFER_LMA		BIT_ULL(5)
+#define VMX_MISC_ACTIVITY_STATE_BITMAP	GENMASK_ULL(8, 6)
+#define VMX_MISC_ACTIVITY_HLT		BIT_ULL(6)
+#define VMX_MISC_ACTIVITY_WAIT_SIPI	BIT_ULL(8)
+#define VMX_MISC_RDMSR_IN_SMM		BIT_ULL(15)
+#define VMX_MISC_VMXOFF_BLOCK_SMI	BIT_ULL(28)
+
+#define VMX_MISC_FEATURES_MASK			\
+	(VMX_MISC_SAVE_EFER_LMA |		\
+	 VMX_MISC_ACTIVITY_STATE_BITMAP |	\
+	 VMX_MISC_INTEL_PT |			\
+	 VMX_MISC_RDMSR_IN_SMM |		\
+	 VMX_MISC_VMXOFF_BLOCK_SMI |		\
+	 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |	\
+	 VMX_MISC_ZERO_LEN_INS)
+
+#define VMX_MISC_RESERVED_BITS			\
+	(BIT_ULL(31) | GENMASK_ULL(13, 9))
+
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved_bits =
-		/* feature */
-		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
-		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
-		/* reserved */
-		GENMASK_ULL(13, 9) | BIT_ULL(31);
 	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
 				       vmcs_config.nested.misc_high);
 
-	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
+	static_assert(!(VMX_MISC_FEATURES_MASK & VMX_MISC_RESERVED_BITS));
+
+	if (!is_bitwise_subset(vmx_misc, data,
+			       VMX_MISC_FEATURES_MASK | VMX_MISC_RESERVED_BITS))
 		return -EINVAL;
 
 	if ((vmx->nested.msrs.pinbased_ctls_high &
@@ -6961,7 +6979,7 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
 {
 	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
 		VMX_MISC_ACTIVITY_HLT |
 		VMX_MISC_ACTIVITY_WAIT_SIPI;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b4b9d51438c6..24ff4df509b6 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -108,7 +108,7 @@ static inline unsigned nested_cpu_vmx_misc_cr3_count(struct kvm_vcpu *vcpu)
 static inline bool nested_cpu_has_vmwrite_any_field(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.msrs.misc_low &
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
 }
 
 static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b68d54f6e9f8..6bb96515185b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8602,7 +8602,7 @@ static __init int hardware_setup(void)
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
 		cpu_preemption_timer_multi =
-			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmx_misc_preemption_timer_rate(vmcs_config.misc);
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.40.1

