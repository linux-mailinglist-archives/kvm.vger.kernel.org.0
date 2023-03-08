Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EC26B100A
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCHRPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCHROq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:14:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A856510
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 09:13:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c18so10256846wmr.3
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 09:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678295622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mosdFsrcIEkA46HQNIyXRd63tpdvn/eB+TgfpH3JfkU=;
        b=GXJVfUESLDZAK0xOv0SYSEf9LQ5T16o6gGb1FkoALpEemM1Fs//0/fqwck3ZqatW3/
         /AfdGaA0kmWGzUJaVqxZN4q5q0ueGZ16l3Bt9dDWZ3gahFPg0wg5E514BO1wfBcLTYhe
         dpEnknBEG1vY2HRr+RVtqzgiDPODtACoolF94h2BUI8hLdXAmY6ZXl2LR01j1QQRt10N
         V3xRHWh6VE/gyPEwdCSnuXeyo68hz/BVrETSrlH5HhgA+ZdB4DYtQELW2Ue5cJIWXMm6
         OeT34T96MjMKjHUSkprbwJOkznAh6W1hY2ylov4fT7ehbcipe8w0q9vVQ64mNcO+9RiZ
         JOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mosdFsrcIEkA46HQNIyXRd63tpdvn/eB+TgfpH3JfkU=;
        b=u31mqVc9VlaJPM5MPv4KPOf5fIo4d8H/bai6t/MRAUccxxq4KI4yweB7R8FZusV2CW
         0fre1+9EB430pMku9k4exS0g3WeUba8rNpsCP6sp0A9qW+1Ry0PeMwq0SOHIeb/w/MfK
         jD9mp9Fid8zSd5GDq6ryq/yqjoFLf9yPwf75cegW+mFUtMYq/nvlbnXVD4ha8SKaaLcR
         iEU85fFvth9C6FuOjj526aBgM0S33mWpopsWGfzKDsVhjl8Qe4sX0gQ2M4cCa7XAh1Kc
         ZQlrVTY4cUDlQ29/8q3aibfwfK55zTcoausg9Chyi713slDzGJn3DT6jnX4N/BXcJG3N
         OcAQ==
X-Gm-Message-State: AO0yUKUm0gGZmSAZb0smOQpSKv8eN9M2rz5jaNBXyWttFi/xlSMgu/yc
        d55Q5j5e6nZFJ6Z0g6YPVG0F/Q==
X-Google-Smtp-Source: AK7set/S7MYh0ogOnZeTTceMqUOxg9FOMLMCIrj3ZxPePxHv8doCChoKpcH0BfVFreXSwsaFmpVEFw==
X-Received: by 2002:a05:600c:3548:b0:3dc:5390:6499 with SMTP id i8-20020a05600c354800b003dc53906499mr17651652wmq.1.1678295622120;
        Wed, 08 Mar 2023 09:13:42 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:fe40:3ba4:afe4:4609])
        by smtp.gmail.com with ESMTPSA id l15-20020a1c790f000000b003e0238d9101sm11668wme.31.2023.03.08.09.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:13:41 -0800 (PST)
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v14 12/12] x86/smpboot: Allow parallel bringup for SEV-ES
Date:   Wed,  8 Mar 2023 17:13:28 +0000
Message-Id: <20230308171328.1562857-13-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308171328.1562857-1-usama.arif@bytedance.com>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/sev-common.h |  3 +++
 arch/x86/include/asm/sev.h        |  5 +++++
 arch/x86/include/asm/smp.h        |  5 ++++-
 arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c         | 31 +++++++++++++++++++++++++------
 5 files changed, 67 insertions(+), 7 deletions(-)

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
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ebc271bb6d8e..d687a586cafa 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -135,6 +135,10 @@ struct snp_secrets_page_layout {
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
+static inline bool sev_es_active(void)
+{
+	return static_branch_unlikely(&sev_es_enable_key);
+}
 extern void __sev_es_ist_enter(struct pt_regs *regs);
 extern void __sev_es_ist_exit(void);
 static __always_inline void sev_es_ist_enter(struct pt_regs *regs)
@@ -198,6 +202,7 @@ bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 #else
+static inline bool sev_es_active(void) { return false; }
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
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
index c35f7c173832..714c2afdbd9a 100644
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
index 0dc123a536ab..b4265c5b46da 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1515,15 +1515,29 @@ void __init smp_prepare_cpus_common(void)
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
+	bool has_sev_es = sev_es_active();
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
+	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) && !has_sev_es) {
+		pr_info("Disabling parallel bringup due to guest memory encryption\n");
+		return false;
+	}
+
+	if (x2apic_mode || has_sev_es) {
 		if (boot_cpu_data.cpuid_level < 0x0b)
 			return false;
 
@@ -1532,8 +1546,13 @@ static bool prepare_parallel_bringup(void)
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

