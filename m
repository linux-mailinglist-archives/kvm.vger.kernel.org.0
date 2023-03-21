Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6397C6C3AE0
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjCUTlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCUTll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:41:41 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C0BDF8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:41:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t15so14874938wrz.7
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679427642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3gQK6+MXZzclW4d0GGLnTn3p9hIu0ffrS0A+Sd8IEM=;
        b=iDIMZpNVu/rJq2uyMdfotQHp+XfP7xkWQekYnCD7Mpayj6O5zMcoQHrk2DVTxASKAf
         WFIrUo72HOrWyBGizUQkIydoteGJDnDt6pVL8Q9Hmee1ZnkGR6PA+KRBQqgB0sDendod
         I9iUk3S02eV9sWO5GDS4kWCFiwfLf3JN3iO/MK8vIIq4ZcmVqIrUY/r/8ythxjfz2lLC
         X9cfoGa0pKOBUlBjmq8KK6B8nZFkKLqUbvybSbx7J7P0xzxdDvNmmhN0KDqab6tBmyof
         a8InYJmLone6yIGk1ZEHbHK2HsAJDO98363Iyfc6eMehMiiptxIk4tTU15ym77+l1ipJ
         T9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3gQK6+MXZzclW4d0GGLnTn3p9hIu0ffrS0A+Sd8IEM=;
        b=RmMmLBP5UVGgf+OQMGCmN+dOSZfTx2K8ORhPnzAMCcBdSBbxgH0omSwIBwLFg2i3lY
         /d2/6rZ4SmPZaFqaSZX99zxCXHBp80Zqwuz7eYEo7t4opEyCPeVCiMbVguPvCtozlBAK
         XJACfp3n4mhl3aEm6wX8yowZLX7NNGpk4mJnVub33f7Ygv/1WHNCq1bhM4sSJ48KVI+j
         Gz0E1g1H3tIAK3xwDW2hD2LZkYWoIYOep9N7OfUEpImqE3bOf2XIeeoMI9hHT7kYVeaZ
         2gF0LRfmThk9yMbv9YC7D/OiAlncfUbL3301kMDqzZ9FLCsVS3xvXLwjeIDeTkX9xzsp
         XuTA==
X-Gm-Message-State: AO0yUKUsuof5GRynESsDok9G/yCy5n7HRmkZdYfAEb7zkHINmRdrScxA
        mu3EqF+/lxDAbHUBgnh7z8Xchw==
X-Google-Smtp-Source: AK7set8Ot2u7wWUY3fdyWt52iZMsQS29pWpcolU1w9rIj2OionVKzWNCYTP3cUghkBhiKatWSzynew==
X-Received: by 2002:adf:db86:0:b0:2d5:5610:e7b4 with SMTP id u6-20020adfdb86000000b002d55610e7b4mr3135776wri.64.1679427642103;
        Tue, 21 Mar 2023 12:40:42 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7a8a:d679:ba4e:61cf])
        by smtp.gmail.com with ESMTPSA id a3-20020adffb83000000b002c561805a4csm12005026wrr.45.2023.03.21.12.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:40:41 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Date:   Tue, 21 Mar 2023 19:40:08 +0000
Message-Id: <20230321194008.785922-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321194008.785922-1-usama.arif@bytedance.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Enable parallel bringup for SEV-ES guests. The APs can't actually
execute the CPUID instruction directly during early startup, but they
can make the GHCB call directly instead, just as the VC trap handler
would do.

Thanks to Sabin for talking me through the way this works.

Suggested-by: Sabin Rapan <sabrapan@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/core.c              |  5 ++++
 arch/x86/include/asm/coco.h       |  1 +
 arch/x86/include/asm/sev-common.h |  3 +++
 arch/x86/include/asm/smp.h        |  5 +++-
 arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c         | 39 ++++++++++++++++++++++++++-----
 6 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f881484..0bab38efb15a 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -129,6 +129,11 @@ u64 cc_mkdec(u64 val)
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
 
+enum cc_vendor cc_get_vendor(void)
+{
+	return vendor;
+}
+
 __init void cc_set_vendor(enum cc_vendor v)
 {
 	vendor = v;
diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
index 3d98c3a60d34..0428d9712c96 100644
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -12,6 +12,7 @@ enum cc_vendor {
 };
 
 void cc_set_vendor(enum cc_vendor v);
+enum cc_vendor cc_get_vendor(void);
 void cc_set_mask(u64 mask);
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b63be696b776..0abf8a39cee1 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -70,6 +70,7 @@
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
 
+#ifndef __ASSEMBLY__
 /*
  * SNP Page State Change Operation
  *
@@ -161,6 +162,8 @@ struct snp_psc_desc {
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+#endif /* __ASSEMBLY__ */
+
 /*
  * Error codes related to GHCB input that can be communicated back to the guest
  * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index defe76ee9e64..1584f04a7007 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -204,7 +204,10 @@ extern unsigned int smpboot_control;
 /* Control bits for startup_64 */
 #define STARTUP_APICID_CPUID_0B	0x80000000
 #define STARTUP_APICID_CPUID_01	0x40000000
+#define STARTUP_APICID_SEV_ES	0x20000000
 
-#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
+#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | \
+			       STARTUP_APICID_CPUID_0B | \
+			       STARTUP_APICID_SEV_ES)
 
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index ff3a5f008d8a..9c38849fcac8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -26,6 +26,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
 #include <asm/smp.h>
+#include <asm/sev-common.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -242,6 +243,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 *
 	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
 	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
+	 * Bit 29	STARTUP_APICID_SEV_ES flag (CPUID 0x0b via GHCB MSR)
 	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
 	 */
 	movl	smpboot_control(%rip), %ecx
@@ -249,6 +251,10 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	jnz	.Luse_cpuid_0b
 	testl	$STARTUP_APICID_CPUID_01, %ecx
 	jnz	.Luse_cpuid_01
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	testl	$STARTUP_APICID_SEV_ES, %ecx
+	jnz	.Luse_sev_cpuid_0b
+#endif
 	andl	$0x0FFFFFFF, %ecx
 	jmp	.Lsetup_cpu
 
@@ -259,6 +265,30 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	shr	$24, %edx
 	jmp	.Lsetup_AP
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+.Luse_sev_cpuid_0b:
+	/* Set the GHCB MSR to request CPUID 0xB_EDX */
+	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
+	movl	$(GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ, %eax
+	movl	$0x0B, %edx
+	wrmsr
+
+	/* Perform GHCB MSR protocol */
+	rep; vmmcall		/* vmgexit */
+
+	/*
+	 * Get the result. After the RDMSR:
+	 *   EAX should be 0xc0000005
+	 *   EDX should have the CPUID register value and since EDX
+	 *   is the target register, no need to move the result.
+	 */
+	rdmsr
+	andl	$GHCB_MSR_INFO_MASK, %eax
+	cmpl	$GHCB_MSR_CPUID_RESP, %eax
+	jne	1f
+	jmp	.Lsetup_AP
+#endif
+
 .Luse_cpuid_0b:
 	mov	$0x0B, %eax
 	xorl	%ecx, %ecx
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0dba5c247be0..ef37356ab695 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -85,6 +85,7 @@
 #include <asm/hw_irq.h>
 #include <asm/stackprotector.h>
 #include <asm/sev.h>
+#include <asm/coco.h>
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
@@ -1513,15 +1514,36 @@ void __init smp_prepare_cpus_common(void)
  * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
  * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
  * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
- * hard. And not for SEV-ES guests because they can't use CPUID that
- * early.
+ * hard.
  */
 static bool prepare_parallel_bringup(void)
 {
-	if (IS_ENABLED(CONFIG_X86_32) || cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+	bool has_sev_es = false;
+
+	if (IS_ENABLED(CONFIG_X86_32))
 		return false;
 
-	if (x2apic_mode) {
+	/*
+	 * Encrypted guests other than SEV-ES (in the future) will need to
+	 * implement an early way of finding the APIC ID, since they will
+	 * presumably block direct CPUID too. Be kind to our future selves
+	 * by warning here instead of just letting them break. Parallel
+	 * startup doesn't have to be in the first round of enabling patches
+	 * for any such technology.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
+		switch (cc_get_vendor()) {
+		case CC_VENDOR_AMD:
+			has_sev_es = true;
+			break;
+
+		default:
+			pr_info("Disabling parallel bringup due to guest state encryption\n");
+			return false;
+		}
+	}
+
+	if (x2apic_mode || has_sev_es) {
 		if (boot_cpu_data.cpuid_level < 0x0b)
 			return false;
 
@@ -1530,8 +1552,13 @@ static bool prepare_parallel_bringup(void)
 			return false;
 		}
 
-		pr_debug("Using CPUID 0xb for parallel CPU startup\n");
-		smpboot_control = STARTUP_APICID_CPUID_0B;
+		if (has_sev_es) {
+			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
+			smpboot_control = STARTUP_APICID_SEV_ES;
+		} else {
+			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
+			smpboot_control = STARTUP_APICID_CPUID_0B;
+		}
 	} else {
 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
 		if (boot_cpu_data.cpuid_level < 0x01)
-- 
2.25.1

