Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9956A1057
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjBWTM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjBWTMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:12:51 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1835D44A
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:28 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bw19so928551wrb.13
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ef9SnPny8CPfpZmm6N0jiCHwpvy9x8nd/PRiLPI7xag=;
        b=XrQnR2cfEdgLwqJ0o6NE4oQo94jXmalIs45LryMzC+zupXpNrQFyQaJDH9RhoY4NO/
         X/U5UAZk9WIGO8WHqPCfOQy+GntieRIMVjX2CQO+K+o5U5aUtGC7UKKBzKuMbm21D8lp
         u0cZi//QcFT5PIFqhoirDUIPE4UgvBV1nDVlTma2g2xOeU/86sFo7mb1nakDRvdHP19X
         b6Hy4TfrowFaRJqrFtRTUHv3cCDJZXsk3yJr4KG4iRmgLGfdgrVmlvq6hEmItm3DhhlW
         um39DZUjO4+pDqLuLxhSJqXCoyrzn21aC2w8ZXkjEK+FWBK2QkpLgcwgQVEbVKEkuKEt
         bN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ef9SnPny8CPfpZmm6N0jiCHwpvy9x8nd/PRiLPI7xag=;
        b=kNfZ/syJkWwuuYys5vQ8aj2OY5+C6HUhHEuw5nyMqzSi+bvVRRuBgALx1T2l8nubcc
         ZRIte5Oi189ckulTj1TqCXCXmXl2UL0jIqSQczNDkVCmMY4r62Jf9hHxELI1Ckylkys1
         bOGZFpTR6Wwf++1PLMbt/bAN9l0C7ChkxF5MozH35tek4YYqOfvtE+q6QzLM3+XrZ8RL
         uYIjHJmE/QT8XoKLZoQCUThZ0sJYs26Y51R1dSQ0F6WBlL/uO/IJtmoLxg4usVfrTEKY
         ywolZC0NGAzCKiAzyS9hSsup/qMc0nkfbn/Qz4ZXO4RbRz9Zfa4orUtCewfXYLRwD2nz
         vwlw==
X-Gm-Message-State: AO0yUKX4SSvMXlv1yNIACqAByBizN/vtxqCGd9IzkeLfNQjaBay4NfyA
        q/gc8u1oAu7lSW3UpkXBrnRRzw==
X-Google-Smtp-Source: AK7set98tD0e8cEXZx0hdoDPqzv1pTcwpHGVhaE8HSWqaC4eiTYx1JWNklrl/RcXYo0eJXOCliLKFg==
X-Received: by 2002:a5d:410b:0:b0:2c5:58f5:3c40 with SMTP id l11-20020a5d410b000000b002c558f53c40mr9571433wrp.47.1677179513058;
        Thu, 23 Feb 2023 11:11:53 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:52 -0800 (PST)
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
Subject: [PATCH v11 11/12] x86/smpboot: Remove initial_gs
Date:   Thu, 23 Feb 2023 19:11:39 +0000
Message-Id: <20230223191140.4155012-12-usama.arif@bytedance.com>
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

Use the percpu offset directly to set GSBASE.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/include/asm/realmode.h |  1 -
 arch/x86/kernel/acpi/sleep.c    |  1 -
 arch/x86/kernel/head_64.S       | 34 ++++++++++-----------------------
 3 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index f0357cfe2fb0..87e5482acd0d 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -60,7 +60,6 @@ extern struct real_mode_header *real_mode_header;
 extern unsigned char real_mode_blob_end[];
 
 extern unsigned long initial_code;
-extern unsigned long initial_gs;
 extern unsigned long initial_stack;
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern unsigned long initial_vc_handler;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 6538ddb55f28..214dd4a79860 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -114,7 +114,6 @@ int x86_acpi_suspend_lowlevel(void)
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	initial_gs = per_cpu_offset(smp_processor_id());
 	/* Force the startup into boot mode */
 	saved_smpboot_ctrl = xchg(&smpboot_control, 0);
 #endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 0dd57d573a0e..9ed87ba0609f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -67,18 +67,10 @@ SYM_CODE_START_NOALIGN(startup_64)
 
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
 
@@ -243,10 +235,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR // above
 
 #ifdef CONFIG_SMP
-	/*
-	 * Is this the boot CPU coming up? If so everything is available
-	 * in initial_gs.
-	 */
+	/* Is this the boot CPU coming up? */
 	movl	smpboot_control(%rip), %edx
 	testl	$STARTUP_SECONDARY, %edx
 	jz	.Linit_cpu0_data
@@ -308,12 +297,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 
 .Linit_cpu_data:
 	/* Get the per cpu offset for the given CPU# which is in ECX */
-	leaq	__per_cpu_offset(%rip), %rbx
-	movq	(%rbx,%rcx,8), %rbx
-	/* Save it for GS BASE setup */
-	movq	%rbx, initial_gs(%rip)
-
-	movq	%rbx, %rdx
+	movq	__per_cpu_offset(,%rcx,8), %rdx
 #else
 	xorl	%edx, %edx
 #endif /* CONFIG_SMP */
@@ -363,8 +347,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
 
 	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
@@ -514,7 +501,6 @@ SYM_CODE_END(vc_boot_ghcb)
 	__REFDATA
 	.balign	8
 SYM_DATA(initial_code,	.quad x86_64_start_kernel)
-SYM_DATA(initial_gs,	.quad INIT_PER_CPU_VAR(fixed_percpu_data))
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
 #endif
-- 
2.25.1

