Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB62D6BDB80
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCPWVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCPWVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:21:46 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E6B7193
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j2so2863723wrh.9
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/pc8Fr19lZeoT7q7aaMJd1wTCs0Rtv3VmfL+mjQqn4Q=;
        b=F/pB0cmPjqelnxt+mi/Zlr5KL9GUCOiNpfTq70y8JbScgxcD8gwHy50I3vtgFZCfDc
         bWO6LjVQr8TzFMPsstU3ti6ksZNXSJQyoaapyKVEWD5xn8LUt8rYmn/B2Lnp2BMvBWBk
         SmiIDi1Na/x6DGh2AIhenDkOCjWxESZD6aD1SLnaufjCgEYPrd1rXLRczw/yXnecdoA3
         81G7GHTCd/lpSWzu7hS3/EGzq7vRCYHbBRLE8o3jqxMfTPavhji+rCY2P/UDGBRzRHxM
         nOWkJt6XtT2rwVF7p665nvPeFaiKbsigW6DAoRj0R8nMiq+xhD/0HXfpGn1pz9MTOcu/
         1jSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pc8Fr19lZeoT7q7aaMJd1wTCs0Rtv3VmfL+mjQqn4Q=;
        b=0xG5SiohO5Jn0VU+wd1i/UEsCZGVLjBWq10Bsu6ZvWfeITDqtgjAIcJlNteTEtYfCP
         L9QW9qtLN4H7hg+4KDKlVpy5LnKj/KqdZZFkHrrpyFCUIPFO84/7M1zhqv2go6Nh0+oV
         TZuuvJ8nxMu2BbBaubPoxH7siJZBf3Qm2YzlmWXtVMOuG4eeGL2FY8Y24xP6YkhodPOD
         +pguWpaYmkviwoLavF2qqyPOiNbdS+LD0YP+eVqal6ejVISfbhRDtHGqAzqEb0Cb+QUI
         Pgw6CTrwOUl+0bP5aCTl2Ha1ECq7ScgIYR63ykgP1Gpp1YYu7xM4dUaQkWA91s7jbRZX
         prcQ==
X-Gm-Message-State: AO0yUKW3I/g0oBDv0UgtB/U6aZ5fHXu+TMQMTxzpl14F3N4WaC03Io/u
        YEeKs6d/7JQ+GdEJ0L5UVhkocw==
X-Google-Smtp-Source: AK7set9sgYkXCSMibbmvUe4RIhgLUEVfl1WsyGvgeX/18PAc8Ybuy/aqYjjAtNxSEsRxhO/vFHCADQ==
X-Received: by 2002:adf:dc0f:0:b0:2cf:f0c3:79ba with SMTP id t15-20020adfdc0f000000b002cff0c379bamr5429379wri.67.1679005283474;
        Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
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
Subject: [PATCH v15 12/12] x86/smpboot: Allow parallel bringup for SEV-ES
Date:   Thu, 16 Mar 2023 22:21:09 +0000
Message-Id: <20230316222109.1940300-13-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
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
index b8357d6ecd47..f25df4bd318e 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -70,6 +70,7 @@
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
 
+#ifndef __ASSEMBLY__
 /*
  * SNP Page State Change Operation
  *
@@ -160,6 +161,8 @@ struct snp_psc_desc {
 
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
index 65bca47d84a1..79a17e705f4e 100644
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
index 0960fdec43c2..895395787afc 100644
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

