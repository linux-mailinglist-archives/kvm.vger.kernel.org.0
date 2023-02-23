Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF66A1068
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjBWTOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjBWTNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:13:19 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1C38029
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:32 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bw19so928595wrb.13
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwjBftfc3L0BBR8aaJYAfM/W208AZmDnuvLkbcbpYBc=;
        b=D6yXbUB9sco4X1VpFV6XERHwY2Jrdg2C/gnoW/DRwjyLLVrrxI1ywrohxmZRrJm091
         pyvN1Hju8nZVLvJpgR9MegSvJlbBhzhD4yTgTKONC35c++3h/vbAyqsGVIcCxYjtPJb/
         tggWnyVAoBa94JfCwJ6wYvG1/pp2c2t+m2b+McHBtAG54vrfvV8PsUW/GRtA+Wlg1RBV
         GBLI60u93gjpV6vPweKG3CwxbRegUHgsMZ2+2kfjBBN4dujoujM87ABiPwktktjExmO7
         B/4Xuz+/aG30TSdTs0orGRkS9Bv/ooYZTvwdgfM4oBWX7zEfFUxgbwLY3cQKWTXxUFA3
         Sjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwjBftfc3L0BBR8aaJYAfM/W208AZmDnuvLkbcbpYBc=;
        b=AuRUNNO/c9kU9t2mttpAHFyk3JzmhIjn/PavxOiqhZifXkT83EjafMm1lBWd5+RCrG
         IZG827eXVBXIZk74rCGCW7q9bFrYGJSA2zLi0S8g2137OWQ5llKtiNPNndGnn8gxrrFT
         TPqlupycmhhkfPAPhLzOhBEG+jrOlhKWVUudiDN1yNECexTv0JPeiY81z0lHrtHZsQpH
         50pMuLwuVkt3k+DRzEQiN19daAbLFkPmRCrT1ocnDWAMRlOG9A/jpLzEcRSuRfLDYzWZ
         1KhAxeHiv7bnS7eRSh32bAQjx60VdcxdFwTD/SF9Pi1eJ+excvlktsVwxcuvt8Li2vjU
         57Ow==
X-Gm-Message-State: AO0yUKVoD4sAnmC4nTOX8PMyee+4RsTPlPsnlTqSoMEoFoLeuzsGbZzl
        u6lJdCEV5zh+Qnc7OMabI7sF+Q==
X-Google-Smtp-Source: AK7set/xfHojBdkCYIcXYqx9p8jYtcp9WgACEXYQEfIv8c7VVeVZ//shfgMfiUhm9UPrfDfWqNl2hw==
X-Received: by 2002:a5d:6743:0:b0:2c7:a3b:4e76 with SMTP id l3-20020a5d6743000000b002c70a3b4e76mr5897330wrw.6.1677179513936;
        Thu, 23 Feb 2023 11:11:53 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:53 -0800 (PST)
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
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v11 12/12] x86/smpboot: Simplify boot CPU setup
Date:   Thu, 23 Feb 2023 19:11:40 +0000
Message-Id: <20230223191140.4155012-13-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230223191140.4155012-1-usama.arif@bytedance.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Now that the per-cpu GSBASE, stack, and GDT descriptor can be derived
dynamically by CPU number, the boot CPU can use a fixed CPU number and
take the same path as secondary CPUs.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/include/asm/smp.h |  5 ++---
 arch/x86/kernel/head_64.S  | 25 +++++++------------------
 arch/x86/kernel/smpboot.c  |  6 +++---
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b4b29e052b6e..97a36d029b0e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -202,8 +202,7 @@ extern unsigned int smpboot_control;
 #endif /* !__ASSEMBLY__ */
 
 /* Control bits for startup_64 */
-#define STARTUP_SECONDARY	0x80000000
-#define STARTUP_APICID_CPUID_0B	0x40000000
-#define STARTUP_APICID_CPUID_01	0x20000000
+#define STARTUP_APICID_CPUID_0B	0x80000000
+#define STARTUP_APICID_CPUID_01	0x40000000
 
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 9ed87ba0609f..949c13b26811 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -235,28 +235,22 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR // above
 
 #ifdef CONFIG_SMP
-	/* Is this the boot CPU coming up? */
-	movl	smpboot_control(%rip), %edx
-	testl	$STARTUP_SECONDARY, %edx
-	jz	.Linit_cpu0_data
-
 	/*
 	 * For parallel boot, the APIC ID is retrieved from CPUID, and then
 	 * used to look up the CPU number.  For booting a single CPU, the
 	 * CPU number is encoded in smpboot_control.
 	 *
-	 * Bit 31	STARTUP_SECONDARY flag (checked above)
 	 * Bit 30	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
 	 * Bit 29	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
 	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
 	 */
-	testl	$STARTUP_APICID_CPUID_0B, %edx
+	movl	smpboot_control(%rip), %ecx
+	testl	$STARTUP_APICID_CPUID_0B, %ecx
 	jnz	.Luse_cpuid_0b
-	testl	$STARTUP_APICID_CPUID_01, %edx
+	testl	$STARTUP_APICID_CPUID_01, %ecx
 	jnz	.Luse_cpuid_01
-	andl	$0x0FFFFFFF, %edx
-	movl	%edx, %ecx
-	jmp	.Linit_cpu_data
+	andl	$0x0FFFFFFF, %ecx
+	jmp	.Lsetup_cpu
 
 .Luse_cpuid_01:
 	mov	$0x01, %eax
@@ -277,7 +271,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 
 .Lfind_cpunr:
 	cmpl	(%rbx,%rcx,4), %edx
-	jz	.Linit_cpu_data
+	jz	.Lsetup_cpu
 	inc	%ecx
 	cmpl	nr_cpu_ids(%rip), %ecx
 	jb	.Lfind_cpunr
@@ -291,18 +285,13 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	hlt
 	jmp	1b
 
-.Linit_cpu0_data:
-	movq	__per_cpu_offset(%rip), %rdx
-	jmp	.Lsetup_cpu
-
-.Linit_cpu_data:
+.Lsetup_cpu:
 	/* Get the per cpu offset for the given CPU# which is in ECX */
 	movq	__per_cpu_offset(,%rcx,8), %rdx
 #else
 	xorl	%edx, %edx
 #endif /* CONFIG_SMP */
 
-.Lsetup_cpu:
 	/*
 	 * Setup a boot time stack - Any secondary CPU will have lost its stack
 	 * by now because the cr3-switch above unmaps the real-mode stack
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 69ef0860feea..9d956571ecc1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1140,7 +1140,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 		initial_stack  = idle->thread.sp;
 	} else if (!do_parallel_bringup) {
-		smpboot_control = STARTUP_SECONDARY | cpu;
+		smpboot_control = cpu;
 	}
 
 	/* Enable the espfix hack for this CPU */
@@ -1580,7 +1580,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		 */
 		if (eax) {
 			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
-			smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_0B;
+			smpboot_control = STARTUP_APICID_CPUID_0B;
 		} else {
 			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
 			do_parallel_bringup = false;
@@ -1588,7 +1588,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	} else if (do_parallel_bringup) {
 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
 		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
-		smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_01;
+		smpboot_control = STARTUP_APICID_CPUID_01;
 	}
 
 	if (do_parallel_bringup) {
-- 
2.25.1

