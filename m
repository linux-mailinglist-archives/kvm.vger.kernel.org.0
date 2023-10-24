Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2AA7D51F0
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbjJXNha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbjJXNhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:37:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2F26A6F
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-408cd9660b8so7314665e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698154072; x=1698758872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4z9AP2iQVC31RTW8tbQwzOlL7n1TMeVDZcHcLiCfbZc=;
        b=gEvSiIHWCpuBh7LG/QSILPIdKi2KUfeQPnlSNmePJT4mRYiXsckznXkIP/YzCBHvhw
         EHjXwCwAYp34szfDqZPZr+0O6Ra4FLy8N8M6lOBpr67EEqX1hfKIJ9QBgwXAWHgICag+
         gsPvvM8Iep4f8hr3GShcTK40FH1nkQxc+CKNZlHEiOma6Ynz0thQ8NvdWL21kWoD+Lon
         OZyoSRzIf9Tie1nJVNbj9mYMwRF4+zxloDAkS2NzMwzvcUqXiuTKqB3bKmQo3+1M8ymJ
         EXYvYAxRPn7LW5WrKSQoRTc577jg80wk8dunL2J0OWgx5FgiXmJ+wW/HXyv3h+b9OTEt
         fI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698154072; x=1698758872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4z9AP2iQVC31RTW8tbQwzOlL7n1TMeVDZcHcLiCfbZc=;
        b=cjnIRNnj2guI033zzFBjDET6tYlF78GRGeBXk48N0WIajbBhYUA55cvSWWnJYC9bdt
         /uFcsjtvdxkg7H/oPj7UE+jmNSTcZdgnIB6tCTBc9/ZsChdFHIM4XOuYVnb9V3a/UmUb
         7Ip0u0EgLMiFa3MwGWerBsZbpMCKnYoWa6z5XV/wrdyfFgqd+vltNxNfmFWEDQOJIN8B
         caR4YLDINJCAyvVHPKAooN0GMBYgmP2c18b2oxl5YyeGfVOkcMUv21ZdKthynAb+MSiz
         MwTCP9IBAa8f+P3RxP8JLJinfrSKBlfewGN1y1hgpDYLDCOlYyqjCHQdnhxkkvABK2xq
         1fYA==
X-Gm-Message-State: AOJu0Yy94yhQzIktK0w0NTyuFsLCc4nElo+QuTjw5VUVA3Ee2IQcwF/G
        jCPdsvk2sPZtM/ReIpd2wiv31g==
X-Google-Smtp-Source: AGHT+IHS0yyEmpgO9XUg4c+Jkt5mm60gvI3rFitpwlZoAUrUmMmN3OCiICsCrKNP5hkxOaHwLXTe3Q==
X-Received: by 2002:adf:f38e:0:b0:32f:505d:b251 with SMTP id m14-20020adff38e000000b0032f505db251mr1231093wro.3.1698154072035;
        Tue, 24 Oct 2023 06:27:52 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:597d:e2c5:6741:bac9])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4151000000b0032d87b13240sm10034964wrq.73.2023.10.24.06.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 06:27:51 -0700 (PDT)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 1/5] riscv: use ".L" local labels in assembly when applicable
Date:   Tue, 24 Oct 2023 15:26:51 +0200
Message-ID: <20231024132655.730417-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024132655.730417-1-cleger@rivosinc.com>
References: <20231024132655.730417-1-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the sake of coherency, use local labels in assembly when
applicable. This also avoid kprobes being confused when applying a
kprobe since the size of function is computed by checking where the
next visible symbol is located. This might end up in computing some
function size to be way shorter than expected and thus failing to apply
kprobes to the specified offset.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/entry.S  | 10 +++----
 arch/riscv/kernel/head.S   | 18 ++++++-------
 arch/riscv/kernel/mcount.S | 10 +++----
 arch/riscv/lib/memmove.S   | 54 +++++++++++++++++++-------------------
 4 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 143a2bb3e697..64ac0dd6176b 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -21,9 +21,9 @@ SYM_CODE_START(handle_exception)
 	 * register will contain 0, and we should continue on the current TP.
 	 */
 	csrrw tp, CSR_SCRATCH, tp
-	bnez tp, _save_context
+	bnez tp, .Lsave_context
 
-_restore_kernel_tpsp:
+.Lrestore_kernel_tpsp:
 	csrr tp, CSR_SCRATCH
 	REG_S sp, TASK_TI_KERNEL_SP(tp)
 
@@ -35,7 +35,7 @@ _restore_kernel_tpsp:
 	REG_L sp, TASK_TI_KERNEL_SP(tp)
 #endif
 
-_save_context:
+.Lsave_context:
 	REG_S sp, TASK_TI_USER_SP(tp)
 	REG_L sp, TASK_TI_KERNEL_SP(tp)
 	addi sp, sp, -(PT_SIZE_ON_STACK)
@@ -205,10 +205,10 @@ SYM_CODE_START_LOCAL(handle_kernel_stack_overflow)
 	REG_S x30, PT_T5(sp)
 	REG_S x31, PT_T6(sp)
 
-	la ra, restore_caller_reg
+	la ra, .Lrestore_caller_reg
 	tail get_overflow_stack
 
-restore_caller_reg:
+.Lrestore_caller_reg:
 	//save per-cpu overflow stack
 	REG_S a0, -8(sp)
 	//restore caller register from shadow_stack
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 3710ea5d160f..7e1b83f18a50 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -168,12 +168,12 @@ secondary_start_sbi:
 	XIP_FIXUP_OFFSET a0
 	call relocate_enable_mmu
 #endif
-	call setup_trap_vector
+	call .Lsetup_trap_vector
 	tail smp_callin
 #endif /* CONFIG_SMP */
 
 .align 2
-setup_trap_vector:
+.Lsetup_trap_vector:
 	/* Set trap vector to exception handler */
 	la a0, handle_exception
 	csrw CSR_TVEC, a0
@@ -210,7 +210,7 @@ ENTRY(_start_kernel)
 	 * not implement PMPs, so we set up a quick trap handler to just skip
 	 * touching the PMPs on any trap.
 	 */
-	la a0, pmp_done
+	la a0, .Lpmp_done
 	csrw CSR_TVEC, a0
 
 	li a0, -1
@@ -218,7 +218,7 @@ ENTRY(_start_kernel)
 	li a0, (PMP_A_NAPOT | PMP_R | PMP_W | PMP_X)
 	csrw CSR_PMPCFG0, a0
 .align 2
-pmp_done:
+.Lpmp_done:
 
 	/*
 	 * The hartid in a0 is expected later on, and we have no firmware
@@ -282,12 +282,12 @@ pmp_done:
 	/* Clear BSS for flat non-ELF images */
 	la a3, __bss_start
 	la a4, __bss_stop
-	ble a4, a3, clear_bss_done
-clear_bss:
+	ble a4, a3, .Lclear_bss_done
+.Lclear_bss:
 	REG_S zero, (a3)
 	add a3, a3, RISCV_SZPTR
-	blt a3, a4, clear_bss
-clear_bss_done:
+	blt a3, a4, .Lclear_bss
+.Lclear_bss_done:
 #endif
 	la a2, boot_cpu_hartid
 	XIP_FIXUP_OFFSET a2
@@ -311,7 +311,7 @@ clear_bss_done:
 	call relocate_enable_mmu
 #endif /* CONFIG_MMU */
 
-	call setup_trap_vector
+	call .Lsetup_trap_vector
 	/* Restore C environment */
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
index 8818a8fa9ff3..ab4dd0594fe7 100644
--- a/arch/riscv/kernel/mcount.S
+++ b/arch/riscv/kernel/mcount.S
@@ -85,16 +85,16 @@ ENTRY(MCOUNT_NAME)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	la	t0, ftrace_graph_return
 	REG_L	t1, 0(t0)
-	bne	t1, t4, do_ftrace_graph_caller
+	bne	t1, t4, .Ldo_ftrace_graph_caller
 
 	la	t3, ftrace_graph_entry
 	REG_L	t2, 0(t3)
 	la	t6, ftrace_graph_entry_stub
-	bne	t2, t6, do_ftrace_graph_caller
+	bne	t2, t6, .Ldo_ftrace_graph_caller
 #endif
 	la	t3, ftrace_trace_function
 	REG_L	t5, 0(t3)
-	bne	t5, t4, do_trace
+	bne	t5, t4, .Ldo_trace
 	ret
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -102,7 +102,7 @@ ENTRY(MCOUNT_NAME)
  * A pseudo representation for the function graph tracer:
  * prepare_to_return(&ra_to_caller_of_caller, ra_to_caller)
  */
-do_ftrace_graph_caller:
+.Ldo_ftrace_graph_caller:
 	addi	a0, s0, -SZREG
 	mv	a1, ra
 #ifdef HAVE_FUNCTION_GRAPH_FP_TEST
@@ -118,7 +118,7 @@ do_ftrace_graph_caller:
  * A pseudo representation for the function tracer:
  * (*ftrace_trace_function)(ra_to_caller, ra_to_caller_of_caller)
  */
-do_trace:
+.Ldo_trace:
 	REG_L	a1, -SZREG(s0)
 	mv	a0, ra
 
diff --git a/arch/riscv/lib/memmove.S b/arch/riscv/lib/memmove.S
index 838ff2022fe3..1930b388c3a0 100644
--- a/arch/riscv/lib/memmove.S
+++ b/arch/riscv/lib/memmove.S
@@ -26,8 +26,8 @@ SYM_FUNC_START_WEAK(memmove)
 	 */
 
 	/* Return if nothing to do */
-	beq a0, a1, return_from_memmove
-	beqz a2, return_from_memmove
+	beq a0, a1, .Lreturn_from_memmove
+	beqz a2, .Lreturn_from_memmove
 
 	/*
 	 * Register Uses
@@ -60,7 +60,7 @@ SYM_FUNC_START_WEAK(memmove)
 	 * small enough not to bother.
 	 */
 	andi t0, a2, -(2 * SZREG)
-	beqz t0, byte_copy
+	beqz t0, .Lbyte_copy
 
 	/*
 	 * Now solve for t5 and t6.
@@ -87,14 +87,14 @@ SYM_FUNC_START_WEAK(memmove)
 	 */
 	xor  t0, a0, a1
 	andi t1, t0, (SZREG - 1)
-	beqz t1, coaligned_copy
+	beqz t1, .Lcoaligned_copy
 	/* Fall through to misaligned fixup copy */
 
-misaligned_fixup_copy:
-	bltu a1, a0, misaligned_fixup_copy_reverse
+.Lmisaligned_fixup_copy:
+	bltu a1, a0, .Lmisaligned_fixup_copy_reverse
 
-misaligned_fixup_copy_forward:
-	jal  t0, byte_copy_until_aligned_forward
+.Lmisaligned_fixup_copy_forward:
+	jal  t0, .Lbyte_copy_until_aligned_forward
 
 	andi a5, a1, (SZREG - 1) /* Find the alignment offset of src (a1) */
 	slli a6, a5, 3 /* Multiply by 8 to convert that to bits to shift */
@@ -153,10 +153,10 @@ misaligned_fixup_copy_forward:
 	mv    t3, t6 /* Fix the dest pointer in case the loop was broken */
 
 	add  a1, t3, a5 /* Restore the src pointer */
-	j byte_copy_forward /* Copy any remaining bytes */
+	j .Lbyte_copy_forward /* Copy any remaining bytes */
 
-misaligned_fixup_copy_reverse:
-	jal  t0, byte_copy_until_aligned_reverse
+.Lmisaligned_fixup_copy_reverse:
+	jal  t0, .Lbyte_copy_until_aligned_reverse
 
 	andi a5, a4, (SZREG - 1) /* Find the alignment offset of src (a4) */
 	slli a6, a5, 3 /* Multiply by 8 to convert that to bits to shift */
@@ -215,18 +215,18 @@ misaligned_fixup_copy_reverse:
 	mv    t4, t5 /* Fix the dest pointer in case the loop was broken */
 
 	add  a4, t4, a5 /* Restore the src pointer */
-	j byte_copy_reverse /* Copy any remaining bytes */
+	j .Lbyte_copy_reverse /* Copy any remaining bytes */
 
 /*
  * Simple copy loops for SZREG co-aligned memory locations.
  * These also make calls to do byte copies for any unaligned
  * data at their terminations.
  */
-coaligned_copy:
-	bltu a1, a0, coaligned_copy_reverse
+.Lcoaligned_copy:
+	bltu a1, a0, .Lcoaligned_copy_reverse
 
-coaligned_copy_forward:
-	jal t0, byte_copy_until_aligned_forward
+.Lcoaligned_copy_forward:
+	jal t0, .Lbyte_copy_until_aligned_forward
 
 	1:
 	REG_L t1, ( 0 * SZREG)(a1)
@@ -235,10 +235,10 @@ coaligned_copy_forward:
 	REG_S t1, (-1 * SZREG)(t3)
 	bne   t3, t6, 1b
 
-	j byte_copy_forward /* Copy any remaining bytes */
+	j .Lbyte_copy_forward /* Copy any remaining bytes */
 
-coaligned_copy_reverse:
-	jal t0, byte_copy_until_aligned_reverse
+.Lcoaligned_copy_reverse:
+	jal t0, .Lbyte_copy_until_aligned_reverse
 
 	1:
 	REG_L t1, (-1 * SZREG)(a4)
@@ -247,7 +247,7 @@ coaligned_copy_reverse:
 	REG_S t1, ( 0 * SZREG)(t4)
 	bne   t4, t5, 1b
 
-	j byte_copy_reverse /* Copy any remaining bytes */
+	j .Lbyte_copy_reverse /* Copy any remaining bytes */
 
 /*
  * These are basically sub-functions within the function.  They
@@ -258,7 +258,7 @@ coaligned_copy_reverse:
  * up from where they were left and we avoid code duplication
  * without any overhead except the call in and return jumps.
  */
-byte_copy_until_aligned_forward:
+.Lbyte_copy_until_aligned_forward:
 	beq  t3, t5, 2f
 	1:
 	lb   t1,  0(a1)
@@ -269,7 +269,7 @@ byte_copy_until_aligned_forward:
 	2:
 	jalr zero, 0x0(t0) /* Return to multibyte copy loop */
 
-byte_copy_until_aligned_reverse:
+.Lbyte_copy_until_aligned_reverse:
 	beq  t4, t6, 2f
 	1:
 	lb   t1, -1(a4)
@@ -285,10 +285,10 @@ byte_copy_until_aligned_reverse:
  * These will byte copy until they reach the end of data to copy.
  * At that point, they will call to return from memmove.
  */
-byte_copy:
-	bltu a1, a0, byte_copy_reverse
+.Lbyte_copy:
+	bltu a1, a0, .Lbyte_copy_reverse
 
-byte_copy_forward:
+.Lbyte_copy_forward:
 	beq  t3, t4, 2f
 	1:
 	lb   t1,  0(a1)
@@ -299,7 +299,7 @@ byte_copy_forward:
 	2:
 	ret
 
-byte_copy_reverse:
+.Lbyte_copy_reverse:
 	beq  t4, t3, 2f
 	1:
 	lb   t1, -1(a4)
@@ -309,7 +309,7 @@ byte_copy_reverse:
 	bne  t4, t3, 1b
 	2:
 
-return_from_memmove:
+.Lreturn_from_memmove:
 	ret
 
 SYM_FUNC_END(memmove)
-- 
2.42.0

