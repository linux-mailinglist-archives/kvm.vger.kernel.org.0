Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854DF7B0F79
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 01:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjI0XIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 19:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjI0XIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 19:08:47 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF8711D;
        Wed, 27 Sep 2023 16:08:45 -0700 (PDT)
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 38RN8CFU2997456
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 27 Sep 2023 16:08:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 38RN8CFU2997456
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023091101; t=1695856097;
        bh=eyHrfW092qMIhkVJG2hY2QkV3rxNt7+sisTQhZMfnmc=;
        h=From:To:Cc:Subject:Date:From;
        b=cSLk8sUI6bfOtX2sVxLsom98RfAdN8bu8/i5732izQhc3l/fVQMhMeKRF04869YPW
         Qcl1OxBEcc/1pcSpcOTOSiMnSWZYtVZrdm9dA/1jKeW941jzPL8OkNC5OkR3EOmial
         Nr/sjRSnN5ckN8Rnn6tAqrt3DMG7HjJ0/ziQd8ZcSUXdmLCyyxHvXUzE8Kb4DKqmux
         mXEidLs/sgoF+ztRM13CJTuR9uBtiNEpDuZKZYgp/ZqimNj2Eq0jT8xNi5j8s5BeVX
         Rh0VuUmjnygfy5Dil79sW/U8CX0F1amlZy02DNIkU0+muqnpDH1uFL+cscrd8LKYM2
         6EfwAc1xpFisQ==
From:   "Xin Li (Intel)" <xin@zytor.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, weijiang.yang@intel.com
Subject: [PATCH 1/1] KVM: VMX: Cleanup VMX basic information defines and usages
Date:   Wed, 27 Sep 2023 16:08:11 -0700
Message-Id: <20230927230811.2997443-1-xin@zytor.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xin Li <xin3.li@intel.com>

Add IA32_VMX_BASIC MSR bitfield shift macros and use them to define VMX
basic information bitfields.

Add VMX_BASIC_FEATURES and VMX_BASIC_RESERVED_BITS to form a valid bitmask
of IA32_VMX_BASIC MSR. As a result, to add a new VMX basic feature bit,
just change the 2 new macros in the header file.

Also replace hardcoded VMX basic numbers with the new VMX basic macros.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 31 ++++++++++++++++++++------
 arch/x86/kvm/vmx/nested.c              | 10 +++------
 arch/x86/kvm/vmx/vmx.c                 |  2 +-
 tools/arch/x86/include/asm/msr-index.h | 31 ++++++++++++++++++++------
 4 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..4607448ff805 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1084,13 +1084,30 @@
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
 /* VMX_BASIC bits and bitmasks */
-#define VMX_BASIC_VMCS_SIZE_SHIFT	32
-#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
-#define VMX_BASIC_64		0x0001000000000000LLU
-#define VMX_BASIC_MEM_TYPE_SHIFT	50
-#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
-#define VMX_BASIC_INOUT		0x0040000000000000LLU
+#define VMX_BASIC_VMCS_SIZE_SHIFT		32
+#define VMX_BASIC_ALWAYS_0			BIT_ULL(31)
+#define VMX_BASIC_RESERVED_RANGE_1		GENMASK_ULL(47, 45)
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT	48
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT)
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT	49
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT)
+#define VMX_BASIC_MEM_TYPE_SHIFT		50
+#define VMX_BASIC_MEM_TYPE_WB			6LLU
+#define VMX_BASIC_INOUT_SHIFT			54
+#define VMX_BASIC_INOUT				BIT_ULL(VMX_BASIC_INOUT_SHIFT)
+#define VMX_BASIC_TRUE_CTLS_SHIFT		55
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(VMX_BASIC_TRUE_CTLS_SHIFT)
+#define VMX_BASIC_RESERVED_RANGE_2		GENMASK_ULL(63, 56)
+
+#define VMX_BASIC_FEATURES			\
+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
+	 VMX_BASIC_INOUT |			\
+	 VMX_BASIC_TRUE_CTLS)
+
+#define VMX_BASIC_RESERVED_BITS			\
+	(VMX_BASIC_ALWAYS_0 |			\
+	 VMX_BASIC_RESERVED_RANGE_1 |		\
+	 VMX_BASIC_RESERVED_RANGE_2)
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..5280ba944c87 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1203,21 +1203,17 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 
 static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved =
-		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
-		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
 	u64 vmx_basic = vmcs_config.nested.basic;
 
-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
+	if (!is_bitwise_subset(vmx_basic, data,
+			       VMX_BASIC_FEATURES | VMX_BASIC_RESERVED_BITS))
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
index 72e3943f3693..f597243d6a72 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2701,7 +2701,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	if (vmx_msr_high & (1u << (VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT - 32)))
 		return -EIO;
 #endif
 
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 1d111350197f..4607448ff805 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -1084,13 +1084,30 @@
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
 /* VMX_BASIC bits and bitmasks */
-#define VMX_BASIC_VMCS_SIZE_SHIFT	32
-#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
-#define VMX_BASIC_64		0x0001000000000000LLU
-#define VMX_BASIC_MEM_TYPE_SHIFT	50
-#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
-#define VMX_BASIC_INOUT		0x0040000000000000LLU
+#define VMX_BASIC_VMCS_SIZE_SHIFT		32
+#define VMX_BASIC_ALWAYS_0			BIT_ULL(31)
+#define VMX_BASIC_RESERVED_RANGE_1		GENMASK_ULL(47, 45)
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT	48
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT)
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT	49
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT)
+#define VMX_BASIC_MEM_TYPE_SHIFT		50
+#define VMX_BASIC_MEM_TYPE_WB			6LLU
+#define VMX_BASIC_INOUT_SHIFT			54
+#define VMX_BASIC_INOUT				BIT_ULL(VMX_BASIC_INOUT_SHIFT)
+#define VMX_BASIC_TRUE_CTLS_SHIFT		55
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(VMX_BASIC_TRUE_CTLS_SHIFT)
+#define VMX_BASIC_RESERVED_RANGE_2		GENMASK_ULL(63, 56)
+
+#define VMX_BASIC_FEATURES			\
+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
+	 VMX_BASIC_INOUT |			\
+	 VMX_BASIC_TRUE_CTLS)
+
+#define VMX_BASIC_RESERVED_BITS			\
+	(VMX_BASIC_ALWAYS_0 |			\
+	 VMX_BASIC_RESERVED_RANGE_1 |		\
+	 VMX_BASIC_RESERVED_RANGE_2)
 
 /* Resctrl MSRs: */
 /* - Intel: */
-- 
2.40.1

