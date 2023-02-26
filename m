Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1156A2F32
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBZLIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBZLIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:38 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3EDDBDF
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:13 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t15so3426812wrz.7
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=za/stY7P8yIh6gy9AN/5+S8qqKjzCyWV7DseUMDJu98=;
        b=eAVHKTnLEeB14Wc5pfNkSl1OrH8vejr5IQp1Q9N1Y4vZJFP0xp99Li2rnJCubHUJeQ
         ljStYlOADy9RtcDYg272MDzTvSN7sJK0ZQGd1YTZigBGB4akIv1g8QOiYsId5dKmVogC
         2M+L0TdHIgkT+xtNpWN80XLz6OXE06FDk/2ma8WavWQjezPo785AJ5Uj33riYUxwknDt
         UaNvFteJ2GZfAR6qtH6+8BYTRvjDjvDgpdThPbfTjHQgRLsYaNUUneKoFKNPuPy7/G7S
         nKoG/Oq3vd1oB9snhdAV0EC5U0w/vYlXD2nSjG7D4/fluqjGdOJjyhs2dN8mh5gieV0M
         lMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=za/stY7P8yIh6gy9AN/5+S8qqKjzCyWV7DseUMDJu98=;
        b=SxYo+1ElAHIKQgNtBu1mdBISZOAiLUYHlSclVamt4obBsnwcFVeiI5DLgu/Dl4Ditu
         tZcBEPGz/XOtenYBkU+wYCBly20/ni+s/Tvu601LB+7XGb/74sxxiME6v/rUoV6Jnehk
         fruvu29x6gcHwrIfOhRAVt3DACzpqKiqv+9ViYB3YFcaY6PpVR6KrqG5vo0Bne1w9c6l
         juaW+DwD5sWAoxk8Aq7buptyFDjf2NLRImpI6VExtU+xMcISeyjLzJYGSzk9/Tsl/4HX
         9WLKyAAXwRRH4TpuM9aC4Jru5tWCNMKbJm9V7nAUvtVlWgeFt8KDlWmyWlOjBPsT7Vo9
         gyyw==
X-Gm-Message-State: AO0yUKXI7bfIF9pe6AWCBFyzIiYRHXHQfdM0D/97Gb2PWx4cLlVQ//ZX
        HzwWUW6c13WsGwH5oLAVTko9/Q==
X-Google-Smtp-Source: AK7set+OEh1glJr1ki0yvrDdO0pAYmxGutVReznGFcjzHoJqqHbLX1g8+oMb8To83Ju+W/gdUtVRXA==
X-Received: by 2002:adf:ea06:0:b0:2cb:3deb:c014 with SMTP id q6-20020adfea06000000b002cb3debc014mr430612wrm.28.1677409692009;
        Sun, 26 Feb 2023 03:08:12 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:11 -0800 (PST)
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
Subject: [PATCH v12 08/11] x86/smpboot: Remove initial_gs
Date:   Sun, 26 Feb 2023 11:07:59 +0000
Message-Id: <20230226110802.103134-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
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
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
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
index 236f2423454d..9d2d88424c77 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -112,7 +112,6 @@ int x86_acpi_suspend_lowlevel(void)
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	initial_gs = per_cpu_offset(smp_processor_id());
 	smpboot_control = smp_processor_id();
 #endif
 	initial_code = (unsigned long)wakeup_long64;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 0ccca297e90e..069191e33490 100644
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
index a22460a07cf8..b04520085582 100644
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

