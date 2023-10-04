Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8658F7B826D
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbjJDOez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbjJDOew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 10:34:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93707C9
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 07:34:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-406532c49dcso4962885e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1696430086; x=1697034886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXaQMk+JK+X4zHvl3kz5vwePkrXa+tZKqfSL/BnIpXk=;
        b=CjdUiRYnAKSV411/i9j9BL+R+nTjnXgGTcWRkNRA4tgoMjY9pbFc2Y1p1XW5OyFHqv
         BCbszCvBARE5pyHJGJQPBo7HzKdxWAAGJJYivVnzJy0zDN2KB596hEC3FBnkGj40SGbu
         psDoWgHFnKFuEusIuYYyOSxexy38tQQ0FfTkXydVXbTW2K4SNlpkdwawct1FRRadCmRr
         cwsaDc7w4gEuMQV0QqFH+oLGDl9gRoe8OovD9VZLcFR85Sulhv4C6ha9SfIhlXGkctEs
         fM6d+EhSrrsqe2YqDVfgSlkHJfAeHW/mgQts9zgu4u6ImeY551WP32BiNOnNjwMMDA56
         TkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696430086; x=1697034886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXaQMk+JK+X4zHvl3kz5vwePkrXa+tZKqfSL/BnIpXk=;
        b=Ch5bT/Sfe8Cxx5sMlv1j3rVRI1DvsL0LdTIk2UNbzhtcnCssLvLlTwYd20WAYAQjzE
         iOsuK4OdQmP9ipx/uemSU1/RsfuGWadkfCgEsRtLzfAItJqOwxmAJG2aF5EvmZ6HkzMF
         z+oisT5Lj6uPTVYDSSG7lkpF9YxmuGOw3lhilD/w1hc18+MFWfW8o9hWVLhhvz7ZS3e9
         TiivUgF/JtlypZZPvnxfgftnb6MiCooW4iVkOc/4ovsmqmN/ltQ4EBAKOn87B3FuWhhf
         vJa6TqXz1nJ6UTHlAp2FPdXbhI4N3EpsHEBT1eYWwVUyy21fhnhe7zoa/OnMJGGc4RSl
         iTbg==
X-Gm-Message-State: AOJu0YyU68PUQqWgsRpiv3e7FjIR+JM8wBrx/TO4LLrNl4ayV9gTJmkN
        kF3zL/94UL8pD77bCAT5byS0Kw==
X-Google-Smtp-Source: AGHT+IHeHQizcr6bYBpFTLOBtKJ/gLmCeLQ799Wow3B1XmwQI4OLxlf76vgvP+Md1mxcPz4/Hf1iDQ==
X-Received: by 2002:a05:600c:1c1f:b0:405:38d1:621 with SMTP id j31-20020a05600c1c1f00b0040538d10621mr2495809wms.3.1696430085709;
        Wed, 04 Oct 2023 07:34:45 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:9474:8d75:5115:42cb])
        by smtp.gmail.com with ESMTPSA id t20-20020a1c7714000000b00401e32b25adsm1686205wmi.4.2023.10.04.07.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 07:34:45 -0700 (PDT)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH 2/5] riscv: Use SYM_*() assembly macros instead of deprecated ones
Date:   Wed,  4 Oct 2023 16:30:51 +0200
Message-ID: <20231004143054.482091-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004143054.482091-1-cleger@rivosinc.com>
References: <20231004143054.482091-1-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ENTRY()/END()/WEAK() macros are deprecated and we should make use of the
new SYM_*() macros [1] for better annotation of symbols. Replace the
deprecated ones with the new ones and fix wrong usage of END()/ENDPROC()
to correctly describe the symbols.

[1] https://docs.kernel.org/core-api/asm-annotations.html

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/copy-unaligned.S            |  8 ++++----
 arch/riscv/kernel/fpu.S                       |  8 ++++----
 arch/riscv/kernel/head.S                      | 12 +++++------
 arch/riscv/kernel/hibernate-asm.S             | 12 +++++------
 arch/riscv/kernel/mcount-dyn.S                | 20 ++++++++-----------
 arch/riscv/kernel/mcount.S                    |  8 ++++----
 arch/riscv/kernel/probes/rethook_trampoline.S |  4 ++--
 arch/riscv/kernel/suspend_entry.S             |  4 ++--
 arch/riscv/kernel/vdso/flush_icache.S         |  4 ++--
 arch/riscv/kernel/vdso/getcpu.S               |  4 ++--
 arch/riscv/kernel/vdso/rt_sigreturn.S         |  4 ++--
 arch/riscv/kernel/vdso/sys_hwprobe.S          |  4 ++--
 arch/riscv/lib/memcpy.S                       |  6 +++---
 arch/riscv/lib/memmove.S                      |  2 +-
 arch/riscv/lib/memset.S                       |  6 +++---
 arch/riscv/lib/uaccess.S                      | 11 +++++-----
 arch/riscv/purgatory/entry.S                  | 16 +++++----------
 17 files changed, 61 insertions(+), 72 deletions(-)

diff --git a/arch/riscv/kernel/copy-unaligned.S b/arch/riscv/kernel/copy-unaligned.S
index cfdecfbaad62..2b3d9398c113 100644
--- a/arch/riscv/kernel/copy-unaligned.S
+++ b/arch/riscv/kernel/copy-unaligned.S
@@ -9,7 +9,7 @@
 /* void __riscv_copy_words_unaligned(void *, const void *, size_t) */
 /* Performs a memcpy without aligning buffers, using word loads and stores. */
 /* Note: The size is truncated to a multiple of 8 * SZREG */
-ENTRY(__riscv_copy_words_unaligned)
+SYM_FUNC_START(__riscv_copy_words_unaligned)
 	andi  a4, a2, ~((8*SZREG)-1)
 	beqz  a4, 2f
 	add   a3, a1, a4
@@ -36,12 +36,12 @@ ENTRY(__riscv_copy_words_unaligned)
 
 2:
 	ret
-END(__riscv_copy_words_unaligned)
+SYM_FUNC_END(__riscv_copy_words_unaligned)
 
 /* void __riscv_copy_bytes_unaligned(void *, const void *, size_t) */
 /* Performs a memcpy without aligning buffers, using only byte accesses. */
 /* Note: The size is truncated to a multiple of 8 */
-ENTRY(__riscv_copy_bytes_unaligned)
+SYM_FUNC_START(__riscv_copy_bytes_unaligned)
 	andi a4, a2, ~(8-1)
 	beqz a4, 2f
 	add  a3, a1, a4
@@ -68,4 +68,4 @@ ENTRY(__riscv_copy_bytes_unaligned)
 
 2:
 	ret
-END(__riscv_copy_bytes_unaligned)
+SYM_FUNC_END(__riscv_copy_bytes_unaligned)
diff --git a/arch/riscv/kernel/fpu.S b/arch/riscv/kernel/fpu.S
index dd2205473de7..6201afcd6b45 100644
--- a/arch/riscv/kernel/fpu.S
+++ b/arch/riscv/kernel/fpu.S
@@ -19,7 +19,7 @@
 #include <asm/csr.h>
 #include <asm/asm-offsets.h>
 
-ENTRY(__fstate_save)
+SYM_FUNC_START(__fstate_save)
 	li  a2,  TASK_THREAD_F0
 	add a0, a0, a2
 	li t1, SR_FS
@@ -60,9 +60,9 @@ ENTRY(__fstate_save)
 	sw t0, TASK_THREAD_FCSR_F0(a0)
 	csrc CSR_STATUS, t1
 	ret
-ENDPROC(__fstate_save)
+SYM_FUNC_END(__fstate_save)
 
-ENTRY(__fstate_restore)
+SYM_FUNC_START(__fstate_restore)
 	li  a2,  TASK_THREAD_F0
 	add a0, a0, a2
 	li t1, SR_FS
@@ -103,4 +103,4 @@ ENTRY(__fstate_restore)
 	fscsr t0
 	csrc CSR_STATUS, t1
 	ret
-ENDPROC(__fstate_restore)
+SYM_FUNC_END(__fstate_restore)
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 7e1b83f18a50..56f78ec304c6 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -18,7 +18,7 @@
 #include "efi-header.S"
 
 __HEAD
-ENTRY(_start)
+SYM_CODE_START(_start)
 	/*
 	 * Image header expected by Linux boot-loaders. The image header data
 	 * structure is described in asm/image.h.
@@ -191,9 +191,9 @@ secondary_start_sbi:
 	wfi
 	j .Lsecondary_park
 
-END(_start)
+SYM_CODE_END(_start)
 
-ENTRY(_start_kernel)
+SYM_CODE_START(_start_kernel)
 	/* Mask all interrupts */
 	csrw CSR_IE, zero
 	csrw CSR_IP, zero
@@ -353,10 +353,10 @@ ENTRY(_start_kernel)
 	tail .Lsecondary_start_common
 #endif /* CONFIG_RISCV_BOOT_SPINWAIT */
 
-END(_start_kernel)
+SYM_CODE_END(_start_kernel)
 
 #ifdef CONFIG_RISCV_M_MODE
-ENTRY(reset_regs)
+SYM_CODE_START_LOCAL(reset_regs)
 	li	sp, 0
 	li	gp, 0
 	li	tp, 0
@@ -454,5 +454,5 @@ ENTRY(reset_regs)
 .Lreset_regs_done_vector:
 #endif /* CONFIG_RISCV_ISA_V */
 	ret
-END(reset_regs)
+SYM_CODE_END(reset_regs)
 #endif /* CONFIG_RISCV_M_MODE */
diff --git a/arch/riscv/kernel/hibernate-asm.S b/arch/riscv/kernel/hibernate-asm.S
index d698dd7df637..d040dcf4add4 100644
--- a/arch/riscv/kernel/hibernate-asm.S
+++ b/arch/riscv/kernel/hibernate-asm.S
@@ -21,7 +21,7 @@
  *
  * Always returns 0
  */
-ENTRY(__hibernate_cpu_resume)
+SYM_FUNC_START(__hibernate_cpu_resume)
 	/* switch to hibernated image's page table. */
 	csrw CSR_SATP, s0
 	sfence.vma
@@ -34,7 +34,7 @@ ENTRY(__hibernate_cpu_resume)
 	mv	a0, zero
 
 	ret
-END(__hibernate_cpu_resume)
+SYM_FUNC_END(__hibernate_cpu_resume)
 
 /*
  * Prepare to restore the image.
@@ -42,7 +42,7 @@ END(__hibernate_cpu_resume)
  * a1: satp of temporary page tables.
  * a2: cpu_resume.
  */
-ENTRY(hibernate_restore_image)
+SYM_FUNC_START(hibernate_restore_image)
 	mv	s0, a0
 	mv	s1, a1
 	mv	s2, a2
@@ -50,7 +50,7 @@ ENTRY(hibernate_restore_image)
 	REG_L	a1, relocated_restore_code
 
 	jr	a1
-END(hibernate_restore_image)
+SYM_FUNC_END(hibernate_restore_image)
 
 /*
  * The below code will be executed from a 'safe' page.
@@ -58,7 +58,7 @@ END(hibernate_restore_image)
  * back to the original memory location. Finally, it jumps to __hibernate_cpu_resume()
  * to restore the CPU context.
  */
-ENTRY(hibernate_core_restore_code)
+SYM_FUNC_START(hibernate_core_restore_code)
 	/* switch to temp page table. */
 	csrw satp, s1
 	sfence.vma
@@ -73,4 +73,4 @@ ENTRY(hibernate_core_restore_code)
 	bnez	s4, .Lcopy
 
 	jr	s2
-END(hibernate_core_restore_code)
+SYM_FUNC_END(hibernate_core_restore_code)
diff --git a/arch/riscv/kernel/mcount-dyn.S b/arch/riscv/kernel/mcount-dyn.S
index 669b8697aa38..58dd96a2a153 100644
--- a/arch/riscv/kernel/mcount-dyn.S
+++ b/arch/riscv/kernel/mcount-dyn.S
@@ -82,7 +82,7 @@
 	.endm
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
-ENTRY(ftrace_caller)
+SYM_FUNC_START(ftrace_caller)
 	SAVE_ABI
 
 	addi	a0, t0, -FENTRY_RA_OFFSET
@@ -91,8 +91,7 @@ ENTRY(ftrace_caller)
 	mv	a1, ra
 	mv	a3, sp
 
-ftrace_call:
-	.global ftrace_call
+SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	call	ftrace_stub
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -102,16 +101,15 @@ ftrace_call:
 #ifdef HAVE_FUNCTION_GRAPH_FP_TEST
 	mv	a2, s0
 #endif
-ftrace_graph_call:
-	.global ftrace_graph_call
+SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
 	call	ftrace_stub
 #endif
 	RESTORE_ABI
 	jr t0
-ENDPROC(ftrace_caller)
+SYM_FUNC_END(ftrace_caller)
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
-ENTRY(ftrace_regs_caller)
+SYM_FUNC_START(ftrace_regs_caller)
 	SAVE_ALL
 
 	addi	a0, t0, -FENTRY_RA_OFFSET
@@ -120,8 +118,7 @@ ENTRY(ftrace_regs_caller)
 	mv	a1, ra
 	mv	a3, sp
 
-ftrace_regs_call:
-	.global ftrace_regs_call
+SYM_INNER_LABEL(ftrace_regs_call, SYM_L_GLOBAL)
 	call	ftrace_stub
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -131,12 +128,11 @@ ftrace_regs_call:
 #ifdef HAVE_FUNCTION_GRAPH_FP_TEST
 	mv	a2, s0
 #endif
-ftrace_graph_regs_call:
-	.global ftrace_graph_regs_call
+SYM_INNER_LABEL(ftrace_graph_regs_call, SYM_L_GLOBAL)
 	call	ftrace_stub
 #endif
 
 	RESTORE_ALL
 	jr t0
-ENDPROC(ftrace_regs_caller)
+SYM_FUNC_END(ftrace_regs_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
index ab4dd0594fe7..b4dd9ed6849e 100644
--- a/arch/riscv/kernel/mcount.S
+++ b/arch/riscv/kernel/mcount.S
@@ -61,7 +61,7 @@ SYM_TYPED_FUNC_START(ftrace_stub_graph)
 	ret
 SYM_FUNC_END(ftrace_stub_graph)
 
-ENTRY(return_to_handler)
+SYM_FUNC_START(return_to_handler)
 /*
  * On implementing the frame point test, the ideal way is to compare the
  * s0 (frame pointer, if enabled) on entry and the sp (stack pointer) on return.
@@ -76,11 +76,11 @@ ENTRY(return_to_handler)
 	mv	a2, a0
 	RESTORE_RET_ABI_STATE
 	jalr	a2
-ENDPROC(return_to_handler)
+SYM_FUNC_END(return_to_handler)
 #endif
 
 #ifndef CONFIG_DYNAMIC_FTRACE
-ENTRY(MCOUNT_NAME)
+SYM_FUNC_START(MCOUNT_NAME)
 	la	t4, ftrace_stub
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	la	t0, ftrace_graph_return
@@ -126,6 +126,6 @@ ENTRY(MCOUNT_NAME)
 	jalr	t5
 	RESTORE_ABI_STATE
 	ret
-ENDPROC(MCOUNT_NAME)
+SYM_FUNC_END(MCOUNT_NAME)
 #endif
 EXPORT_SYMBOL(MCOUNT_NAME)
diff --git a/arch/riscv/kernel/probes/rethook_trampoline.S b/arch/riscv/kernel/probes/rethook_trampoline.S
index 21bac92a170a..f2cd83d9b0f0 100644
--- a/arch/riscv/kernel/probes/rethook_trampoline.S
+++ b/arch/riscv/kernel/probes/rethook_trampoline.S
@@ -75,7 +75,7 @@
 	REG_L x31, PT_T6(sp)
 	.endm
 
-ENTRY(arch_rethook_trampoline)
+SYM_CODE_START(arch_rethook_trampoline)
 	addi sp, sp, -(PT_SIZE_ON_STACK)
 	save_all_base_regs
 
@@ -90,4 +90,4 @@ ENTRY(arch_rethook_trampoline)
 	addi sp, sp, PT_SIZE_ON_STACK
 
 	ret
-ENDPROC(arch_rethook_trampoline)
+SYM_CODE_END(arch_rethook_trampoline)
diff --git a/arch/riscv/kernel/suspend_entry.S b/arch/riscv/kernel/suspend_entry.S
index f7960c7c5f9e..a59c4c903696 100644
--- a/arch/riscv/kernel/suspend_entry.S
+++ b/arch/riscv/kernel/suspend_entry.S
@@ -16,7 +16,7 @@
 	.altmacro
 	.option norelax
 
-ENTRY(__cpu_suspend_enter)
+SYM_FUNC_START(__cpu_suspend_enter)
 	/* Save registers (except A0 and T0-T6) */
 	REG_S	ra, (SUSPEND_CONTEXT_REGS + PT_RA)(a0)
 	REG_S	sp, (SUSPEND_CONTEXT_REGS + PT_SP)(a0)
@@ -57,7 +57,7 @@ ENTRY(__cpu_suspend_enter)
 
 	/* Return to C code */
 	ret
-END(__cpu_suspend_enter)
+SYM_FUNC_END(__cpu_suspend_enter)
 
 SYM_TYPED_FUNC_START(__cpu_resume_enter)
 	/* Load the global pointer */
diff --git a/arch/riscv/kernel/vdso/flush_icache.S b/arch/riscv/kernel/vdso/flush_icache.S
index 82f97d67c23e..8f884227e8bc 100644
--- a/arch/riscv/kernel/vdso/flush_icache.S
+++ b/arch/riscv/kernel/vdso/flush_icache.S
@@ -8,7 +8,7 @@
 
 	.text
 /* int __vdso_flush_icache(void *start, void *end, unsigned long flags); */
-ENTRY(__vdso_flush_icache)
+SYM_FUNC_START(__vdso_flush_icache)
 	.cfi_startproc
 #ifdef CONFIG_SMP
 	li a7, __NR_riscv_flush_icache
@@ -19,4 +19,4 @@ ENTRY(__vdso_flush_icache)
 #endif
 	ret
 	.cfi_endproc
-ENDPROC(__vdso_flush_icache)
+SYM_FUNC_END(__vdso_flush_icache)
diff --git a/arch/riscv/kernel/vdso/getcpu.S b/arch/riscv/kernel/vdso/getcpu.S
index bb0c05e2ffba..9c1bd531907f 100644
--- a/arch/riscv/kernel/vdso/getcpu.S
+++ b/arch/riscv/kernel/vdso/getcpu.S
@@ -8,11 +8,11 @@
 
 	.text
 /* int __vdso_getcpu(unsigned *cpu, unsigned *node, void *unused); */
-ENTRY(__vdso_getcpu)
+SYM_FUNC_START(__vdso_getcpu)
 	.cfi_startproc
 	/* For now, just do the syscall. */
 	li a7, __NR_getcpu
 	ecall
 	ret
 	.cfi_endproc
-ENDPROC(__vdso_getcpu)
+SYM_FUNC_END(__vdso_getcpu)
diff --git a/arch/riscv/kernel/vdso/rt_sigreturn.S b/arch/riscv/kernel/vdso/rt_sigreturn.S
index 10438c7c626a..3dc022aa8931 100644
--- a/arch/riscv/kernel/vdso/rt_sigreturn.S
+++ b/arch/riscv/kernel/vdso/rt_sigreturn.S
@@ -7,10 +7,10 @@
 #include <asm/unistd.h>
 
 	.text
-ENTRY(__vdso_rt_sigreturn)
+SYM_FUNC_START(__vdso_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
 	li a7, __NR_rt_sigreturn
 	ecall
 	.cfi_endproc
-ENDPROC(__vdso_rt_sigreturn)
+SYM_FUNC_END(__vdso_rt_sigreturn)
diff --git a/arch/riscv/kernel/vdso/sys_hwprobe.S b/arch/riscv/kernel/vdso/sys_hwprobe.S
index 4e704146c77a..77e57f830521 100644
--- a/arch/riscv/kernel/vdso/sys_hwprobe.S
+++ b/arch/riscv/kernel/vdso/sys_hwprobe.S
@@ -5,11 +5,11 @@
 #include <asm/unistd.h>
 
 .text
-ENTRY(riscv_hwprobe)
+SYM_FUNC_START(riscv_hwprobe)
 	.cfi_startproc
 	li a7, __NR_riscv_hwprobe
 	ecall
 	ret
 
 	.cfi_endproc
-ENDPROC(riscv_hwprobe)
+SYM_FUNC_END(riscv_hwprobe)
diff --git a/arch/riscv/lib/memcpy.S b/arch/riscv/lib/memcpy.S
index 1a40d01a9543..44e009ec5fef 100644
--- a/arch/riscv/lib/memcpy.S
+++ b/arch/riscv/lib/memcpy.S
@@ -7,8 +7,7 @@
 #include <asm/asm.h>
 
 /* void *memcpy(void *, const void *, size_t) */
-ENTRY(__memcpy)
-WEAK(memcpy)
+SYM_FUNC_START(__memcpy)
 	move t6, a0  /* Preserve return value */
 
 	/* Defer to byte-oriented copy for small sizes */
@@ -105,6 +104,7 @@ WEAK(memcpy)
 	bltu a1, a3, 5b
 6:
 	ret
-END(__memcpy)
+SYM_FUNC_END(__memcpy)
+SYM_FUNC_ALIAS_WEAK(memcpy, __memcpy)
 SYM_FUNC_ALIAS(__pi_memcpy, __memcpy)
 SYM_FUNC_ALIAS(__pi___memcpy, __memcpy)
diff --git a/arch/riscv/lib/memmove.S b/arch/riscv/lib/memmove.S
index 1930b388c3a0..5130033e3e02 100644
--- a/arch/riscv/lib/memmove.S
+++ b/arch/riscv/lib/memmove.S
@@ -7,7 +7,6 @@
 #include <asm/asm.h>
 
 SYM_FUNC_START(__memmove)
-SYM_FUNC_START_WEAK(memmove)
 	/*
 	 * Returns
 	 *   a0 - dest
@@ -314,5 +313,6 @@ SYM_FUNC_START_WEAK(memmove)
 
 SYM_FUNC_END(memmove)
 SYM_FUNC_END(__memmove)
+SYM_FUNC_ALIAS_WEAK(memmove, __memmove)
 SYM_FUNC_ALIAS(__pi_memmove, __memmove)
 SYM_FUNC_ALIAS(__pi___memmove, __memmove)
diff --git a/arch/riscv/lib/memset.S b/arch/riscv/lib/memset.S
index 34c5360c6705..35f358e70bdb 100644
--- a/arch/riscv/lib/memset.S
+++ b/arch/riscv/lib/memset.S
@@ -8,8 +8,7 @@
 #include <asm/asm.h>
 
 /* void *memset(void *, int, size_t) */
-ENTRY(__memset)
-WEAK(memset)
+SYM_FUNC_START(__memset)
 	move t0, a0  /* Preserve return value */
 
 	/* Defer to byte-oriented fill for small sizes */
@@ -110,4 +109,5 @@ WEAK(memset)
 	bltu t0, a3, 5b
 6:
 	ret
-END(__memset)
+SYM_FUNC_END(__memset)
+SYM_FUNC_ALIAS_WEAK(memset, __memset)
diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 09b47ebacf2e..3ab438f30d13 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -10,8 +10,7 @@
 	_asm_extable	100b, \lbl
 	.endm
 
-ENTRY(__asm_copy_to_user)
-ENTRY(__asm_copy_from_user)
+SYM_FUNC_START(__asm_copy_to_user)
 
 	/* Enable access to user memory */
 	li t6, SR_SUM
@@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
 	csrc CSR_STATUS, t6
 	sub a0, t5, a0
 	ret
-ENDPROC(__asm_copy_to_user)
-ENDPROC(__asm_copy_from_user)
+SYM_FUNC_END(__asm_copy_to_user)
 EXPORT_SYMBOL(__asm_copy_to_user)
+SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)
 EXPORT_SYMBOL(__asm_copy_from_user)
 
 
-ENTRY(__clear_user)
+SYM_FUNC_START(__clear_user)
 
 	/* Enable access to user memory */
 	li t6, SR_SUM
@@ -233,5 +232,5 @@ ENTRY(__clear_user)
 	csrc CSR_STATUS, t6
 	sub a0, a3, a0
 	ret
-ENDPROC(__clear_user)
+SYM_FUNC_END(__clear_user)
 EXPORT_SYMBOL(__clear_user)
diff --git a/arch/riscv/purgatory/entry.S b/arch/riscv/purgatory/entry.S
index 0194f4554130..7befa276fb01 100644
--- a/arch/riscv/purgatory/entry.S
+++ b/arch/riscv/purgatory/entry.S
@@ -7,15 +7,11 @@
  * Author: Li Zhengyu (lizhengyu3@huawei.com)
  *
  */
-
-.macro	size, sym:req
-	.size \sym, . - \sym
-.endm
+#include <linux/linkage.h>
 
 .text
 
-.globl purgatory_start
-purgatory_start:
+SYM_CODE_START(purgatory_start)
 
 	lla	sp, .Lstack
 	mv	s0, a0	/* The hartid of the current hart */
@@ -28,8 +24,7 @@ purgatory_start:
 	mv	a1, s1
 	ld	a2, riscv_kernel_entry
 	jr	a2
-
-size purgatory_start
+SYM_CODE_END(purgatory_start)
 
 .align 4
 	.rept	256
@@ -39,9 +34,8 @@ size purgatory_start
 
 .data
 
-.globl riscv_kernel_entry
-riscv_kernel_entry:
+SYM_DATA_START(riscv_kernel_entry)
 	.quad	0
-size riscv_kernel_entry
+SYM_DATA_END(riscv_kernel_entry)
 
 .end
-- 
2.42.0

