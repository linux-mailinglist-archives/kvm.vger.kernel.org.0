Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681156BDB82
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCPWVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCPWVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:21:43 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BC1B3729
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:19 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o7so2872095wrg.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FULGw2JzzQsOYOrWK/IeWDfn0l3ZyQtosjohoUs52UM=;
        b=XJkZiiYe6qukEyVX/ujwP5etOZk592Q68jftwrVXpL4JMdoU251Sic4GKKxqoURB75
         gfXMd+jOXjW5LK3dYpkUe8S2pEZcRggenTmD9+KE8eZgb7yDzwQ3EMBwGdAl5IPg5Svn
         1adM4NXK26p396oaoPI2OcwyTLd5TOZ1YG6WQ6WmrT6yfgHUpju2g8gPjeQRxBtKMwN6
         f/t0MCNQSMV0DnRW6aFDulqBtXy3RiaUMqnmpi5FlWc+3X8EyGqzmzqkqNLeFBvPnhqe
         IFrtkO2JXGZY1L74uXsj4Kv61nAuvl270HxBVyJPFpasxMgN+NUXU8heKCaGYPurMp14
         C9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FULGw2JzzQsOYOrWK/IeWDfn0l3ZyQtosjohoUs52UM=;
        b=5Mh8s+bAvGDRTS19F1K1PFsWqflZKM/mQCqgors4TuDetKccTxqEfoa3VEvXR3ZrbJ
         28ebmv7vMvOo5xi2fVt373fyA9BYZw+KCgZ3xiqGK1Nj264KNswU/gbGj0cgBW/uziy3
         FVScf7/97RW53Q1zf2/sQnsWlKhcMAh88i8QYNkqgigrQUuBdgoFEx8h3Fqqj2r17bmy
         FUPcqvBzfNilnmXOzv752bpdtwWe3za02f3KGfoORfZ3x1lDn/oGp1Dz9Fg23BVrtIgN
         NDrprxxzihPjAJ+YCa6iK4RGAtfZJQjdQCcIlwKygSO/BTJaRiFXbz/QJteZv9wtLoVZ
         xy5g==
X-Gm-Message-State: AO0yUKUuPmENyxj3ZXcE86YuSRzSjZSeXhePEyfSySfyFVb8Khv3qnSj
        aYW7x7iwYMzVfBZp/fnuB2AQdw==
X-Google-Smtp-Source: AK7set8t15sN4HACJlKDCZ3X/2n31Q8swA79q5+uZ+pUX6XrJ1YC59/G0zfyM+RQjP4WInYY4t29mA==
X-Received: by 2002:adf:dc0f:0:b0:2cf:f0c3:79ba with SMTP id t15-20020adfdc0f000000b002cff0c379bamr5429317wri.67.1679005279217;
        Thu, 16 Mar 2023 15:21:19 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:18 -0700 (PDT)
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
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v15 08/12] x86/smpboot: Remove initial_gs
Date:   Thu, 16 Mar 2023 22:21:05 +0000
Message-Id: <20230316222109.1940300-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
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

Given its CPU#, each CPU can find its own per-cpu offset, and directly set
GSBASE accordingly. The global variable can be eliminated.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/include/asm/realmode.h |  1 -
 arch/x86/kernel/acpi/sleep.c    |  1 -
 arch/x86/kernel/head_64.S       | 22 ++++++++--------------
 arch/x86/kernel/smpboot.c       |  2 --
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index a336feef0af1..f6a1737c77be 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -59,7 +59,6 @@ extern struct real_mode_header *real_mode_header;
 extern unsigned char real_mode_blob_end[];
 
 extern unsigned long initial_code;
-extern unsigned long initial_gs;
 extern unsigned long initial_stack;
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern unsigned long initial_vc_handler;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index de89bb4719d0..1328c221af30 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -127,7 +127,6 @@ int x86_acpi_suspend_lowlevel(void)
 	 * value is in the actual %rsp register.
 	 */
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	initial_gs = per_cpu_offset(smp_processor_id());
 	smpboot_control = smp_processor_id();
 #endif
 	initial_code = (unsigned long)wakeup_long64;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a5b46c2fba05..6a8238702eab 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -66,18 +66,10 @@ SYM_CODE_START_NOALIGN(startup_64)
 
 	leaq	_text(%rip), %rdi
 
-	/*
-	 * initial_gs points to initial fixed_percpu_data struct with storage for
-	 * the stack protector canary. Global pointer fixups are needed at this
-	 * stage, so apply them as is done in fixup_pointer(), and initialize %gs
-	 * such that the canary can be accessed at %gs:40 for subsequent C calls.
-	 */
+	/* Setup GSBASE to allow stack canary access for C code */
 	movl	$MSR_GS_BASE, %ecx
-	movq	initial_gs(%rip), %rax
-	movq	$_text, %rdx
-	subq	%rdx, %rax
-	addq	%rdi, %rax
-	movq	%rax, %rdx
+	leaq	INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
+	movl	%edx, %eax
 	shrq	$32,  %rdx
 	wrmsr
 
@@ -294,8 +286,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 * the per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-	movl	initial_gs(%rip),%eax
-	movl	initial_gs+4(%rip),%edx
+#ifndef CONFIG_SMP
+	leaq	INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
+#endif
+	movl	%edx, %eax
+	shrq	$32, %rdx
 	wrmsr
 
 	/* Setup and Load IDT */
@@ -437,7 +432,6 @@ SYM_CODE_END(vc_boot_ghcb)
 	__REFDATA
 	.balign	8
 SYM_DATA(initial_code,	.quad x86_64_start_kernel)
-SYM_DATA(initial_gs,	.quad INIT_PER_CPU_VAR(fixed_percpu_data))
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 67224e61310c..28d1643eee99 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1084,8 +1084,6 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	per_cpu(pcpu_hot.top_of_stack, cpu) = task_top_of_stack(idle);
-#else
-	initial_gs = per_cpu_offset(cpu);
 #endif
 	return 0;
 }
-- 
2.25.1

