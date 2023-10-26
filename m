Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B917D8789
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344887AbjJZR0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjJZR0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:26:32 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095301A6;
        Thu, 26 Oct 2023 10:26:29 -0700 (PDT)
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39QHPUFg208880
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 26 Oct 2023 10:25:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39QHPUFg208880
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698341135;
        bh=glvWDkY8U3bRDuFQ/suv80YTPZCTB7LdRK2W5T++R+c=;
        h=From:To:Cc:Subject:Date:From;
        b=pvEk7eMhZFa01d6arAyrwlPXioRoX56GXnB5sC5sjAUktCywE8fipiK14vGVY0Ynh
         rV78sISxbzt7yQGmb674DIEGybPg5u8Ve7F+0EW3yV6RAhkkT1jFvlhZtqITghl+DH
         Y3c5JkzEa+5tNPONAmT72Ohw1Hf7GLqUBwmGnOkXiaZ5BbJH6VK+ZzFebpLpwRv2G6
         e4R7MD6PHtyC5KSTdygy7z/lQiAf+WYrGup9IxnD32W6akzig0meEA3UqbujnFIdJC
         RaMz9OLI/ubZBgEn+HPVyjvwWc1TlMUxBsaOLAPjVn7RLjrQ/2aIuIEvdLQxKA4/Us
         xrYeDZ3Hth9mA==
From:   "Xin Li (Intel)" <xin@zytor.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, weijiang.yang@intel.com
Subject: [PATCH v2 1/2] KVM: VMX: Cleanup VMX basic information defines and usages
Date:   Thu, 26 Oct 2023 10:25:29 -0700
Message-Id: <20231026172530.208867-1-xin@zytor.com>
X-Mailer: git-send-email 2.40.1
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

Define VMX basic information fields with BIT_ULL()/GENMASK_ULL(), and
replace hardcoded VMX basic numbers with these macros.

Per Sean's ask, read MSR_IA32_VMX_BASIC into an u64 to get rid of the
hi/lo crud.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v1:
* Don't add field shift macros unless it's really needed, extra layer
  of indirect makes it harder to read (Sean Christopherson).
* Add a static_assert() to ensure that VMX_BASIC_FEATURES_MASK doesn't
  overlap with VMX_BASIC_RESERVED_BITS (Sean Christopherson).
* read MSR_IA32_VMX_BASIC into an u64 rather than 2 u32 (Sean
  Christopherson).
* Add 2 new functions for extracting fields from VMX basic (Sean
  Christopherson).
* Drop the tools header update (Sean Christopherson).
* Move VMX basic field macros to arch/x86/include/asm/vmx.h.
---
 arch/x86/include/asm/msr-index.h |  9 ---------
 arch/x86/include/asm/vmx.h       | 16 ++++++++++++++++
 arch/x86/kvm/vmx/nested.c        | 25 ++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c           | 22 ++++++++++------------
 4 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 8bcbebb56b8f..d83195f53e33 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1084,15 +1084,6 @@
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
-/* VMX_BASIC bits and bitmasks */
-#define VMX_BASIC_VMCS_SIZE_SHIFT	32
-#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
-#define VMX_BASIC_64		0x0001000000000000LLU
-#define VMX_BASIC_MEM_TYPE_SHIFT	50
-#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
-#define VMX_BASIC_INOUT		0x0040000000000000LLU
-
 /* Resctrl MSRs: */
 /* - Intel: */
 #define MSR_IA32_L3_QOS_CFG		0xc81
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..f919397900f1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -120,6 +120,12 @@
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
+/* VMX_BASIC bits and bitmasks */
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
+#define VMX_BASIC_MEM_TYPE_WB			6LLU
+#define VMX_BASIC_INOUT				BIT_ULL(54)
+
+/* VMX_MISC bits and bitmasks */
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 #define VMX_MISC_ACTIVITY_HLT			0x00000040
@@ -143,6 +149,16 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_vmcs_basic_cap(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(63, 45)) >> 32;
+}
+
+static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ba46e1b29d2..274d480d9071 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1201,23 +1201,34 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 	return (superset | subset) == superset;
 }
 
+#define VMX_BASIC_VMCS_SIZE_SHIFT		32
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
+#define VMX_BASIC_MEM_TYPE_SHIFT		50
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+
+#define VMX_BASIC_FEATURES_MASK			\
+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
+	 VMX_BASIC_INOUT |			\
+	 VMX_BASIC_TRUE_CTLS)
+
+#define VMX_BASIC_RESERVED_BITS			\
+	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))
+
 static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved =
-		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
-		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
 	u64 vmx_basic = vmcs_config.nested.basic;
 
-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
+	static_assert(!(VMX_BASIC_FEATURES_MASK & VMX_BASIC_RESERVED_BITS));
+
+	if (!is_bitwise_subset(vmx_basic, data,
+			       VMX_BASIC_FEATURES_MASK | VMX_BASIC_RESERVED_BITS))
 		return -EINVAL;
 
 	/*
 	 * KVM does not emulate a version of VMX that constrains physical
 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
 	 */
-	if (data & BIT_ULL(48))
+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EINVAL;
 
 	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4c3a70f26b42..b68d54f6e9f8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2568,14 +2568,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
-	u64 misc_msr;
+	u64 vmx_basic;
 	int i;
 
 	/*
@@ -2693,28 +2692,26 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, vmx_basic);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if ((vmx_basic_vmcs_size(vmx_basic) > PAGE_SIZE))
 		return -EIO;
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	if (vmx_basic & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (vmx_basic_vmcs_mem_type(vmx_basic) != VMX_BASIC_MEM_TYPE_WB)
 		return -EIO;
 
-	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
-
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
+	vmcs_conf->size = vmx_basic_vmcs_size(vmx_basic);
+	vmcs_conf->basic_cap = vmx_basic_vmcs_basic_cap(vmx_basic);
 
-	vmcs_conf->revision_id = vmx_msr_low;
+	vmcs_conf->revision_id = vmx_basic_vmcs_revision_id(vmx_basic);
 
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
@@ -2722,7 +2719,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
-	vmcs_conf->misc	= misc_msr;
+
+	rdmsrl(MSR_IA32_VMX_MISC, vmcs_conf->misc);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (enlightened_vmcs)
-- 
2.40.1

