Return-Path: <kvm+bounces-15106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 389918A9D15
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06501B24A3F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D7116D4C1;
	Thu, 18 Apr 2024 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="K9MDlXGl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCEE16ABFF
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450437; cv=none; b=BtK8kh/EYdpXF1ZkKidweiWO3OX/IOI7JCGQIREYsuyaFzZBdi035KlbAadPsPgTGKsFYWzKnRblFQKGAcKzqYqlIzus0PaqLiWIgnvKPUtHL2tJcPmgR8t/k0WjM6kw9IfPENPHtwQXmC7fUZ4kYmbF9CUb6JaC1hYeNr0e9P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450437; c=relaxed/simple;
	bh=n26bGGJNXdZkz4TRas8Z8PR3vR2k7ylQj5DGZP8ph5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSUunUcpJ4DZFjuedkAt5jAdB2jYeSK60EV8fPcxNp7u7JimwPlM5v9b2CLwHF7sUdA6k8WzJs0Jol4agh/QmlOX3HN0NF+PNH1jJpdUNQ/tn8vt63IANKsWAOh1Qu7kVVOUXz/m9NTU0XiAkPwGOXehe6rO630ybyRF306Zp6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=K9MDlXGl; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-349a35aba9dso167607f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450434; x=1714055234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/abrO6aRdYSwYEiniLJTSjXDsMHpzNjwZUI0bHiQJI=;
        b=K9MDlXGlRteIDLHFQYLS22vAZQ5DJHbVUSZgobSzh6f221PtEQGNsE2BT0kn379ra5
         hMpM3gr/09Kmm7VCKfm96Q1IFHKN9RKg+gmb7kfMq9D5qYHPF9HJk2EQK+6r3In3Milq
         MnMtNX791XrIOMBzAON8dVEd+7uwDwhCydWdNGEvVkuHoP4PNSZP85kWkTie96snTmpP
         x/fmMsJNk8obEIbeb7IOWKP5M22NmFVB7PGey4f+WL/QRMOBYhFVzf4WQkn+oZJEb9G7
         9GXc6qogXtAHbOdVbz9ChKbBmRQVOkwC1WO3DkM9DyVeGCRv1oA12e4GxCKqsRBPl32T
         VTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450434; x=1714055234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/abrO6aRdYSwYEiniLJTSjXDsMHpzNjwZUI0bHiQJI=;
        b=r76W9tG3PodaK2zDjUpNCxnAt36gvfEuTZ1Js//tWmGCNHOcnzgwUKG+ZBNCvJemRz
         1wBUEhqnZn32faB4G22EFXJB2neUQCX5bToGiYKDKwFKR5scC0vUnFWWGbWaY4vq5y70
         AY1prUxYUZzJveqk0wy2MHdUSw65e/PHLKhUDHNAIQhT/pQ+cjDFILbVePnueSG3yJ43
         kz02oEqj/t6ukSPtT6J7RLzEDD7PeauNakxk9oJz9nJxDXbMYs1JwUeifflyrPnNyp3l
         oeYti8zpR7uebEo/Gsw22VvOs1TQW0a4feOK7zgaMlyQBFkr9xBEIRGrKMRL4j7g7uy+
         qm3w==
X-Forwarded-Encrypted: i=1; AJvYcCXYD575SvMKtm99RgNzhYPq02x6KNm6mdX4IhU4KWWqxeQ/f21djX1i/4yiGmJCtHCeUS5fYIliULUTb36vbkslWmpg
X-Gm-Message-State: AOJu0YyxcuBmipyQ3ex/i+kI/0uQHYQdA1ooikRMJ+5j5/pCOiHz0/zl
	sQOCXFnWLOs4qgUasj/uIvCqXxCBXpgh6u2xYgkgwGclydsaqhbe7udEg+vwdL4=
X-Google-Smtp-Source: AGHT+IEkGDIAezbeIVZmmrT9rlRCJjcxopA8THm4S/C75RtVNLUvN35X394KK2J0KQ/iPXZ6II3FvA==
X-Received: by 2002:a05:600c:4f8a:b0:418:f770:ba0 with SMTP id n10-20020a05600c4f8a00b00418f7700ba0mr505923wmq.0.1713450434242;
        Thu, 18 Apr 2024 07:27:14 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 4/7] riscv: handle Ssdbltrp mstatus SDT bit
Date: Thu, 18 Apr 2024 16:26:43 +0200
Message-ID: <20240418142701.1493091-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When Ssdbltrp is enabled, we must take care of clearing SDT after
sensitive phases are over to avoid generating a double trap. This
is mainly about exceptions handling so clear SDT once we have
saved enough information (critical CSRs) but also clears it during SATP
mode detection which generates an "inline" trap and thus sets SDT
implicitely.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/csr.h  |  1 +
 arch/riscv/kernel/entry.S     | 52 ++++++++++++++++++++---------------
 arch/riscv/kernel/head.S      |  4 +++
 arch/riscv/kernel/sse_entry.S |  4 +--
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 5528159b3d5d..905cdf894a57 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -17,6 +17,7 @@
 #define SR_SPP		_AC(0x00000100, UL) /* Previously Supervisor */
 #define SR_MPP		_AC(0x00001800, UL) /* Previously Machine */
 #define SR_SUM		_AC(0x00040000, UL) /* Supervisor User Memory Access */
+#define SR_SDT		_AC(0x01000000, UL) /* Supervisor Double Trap */
 
 #define SR_FS		_AC(0x00006000, UL) /* Floating-point Status */
 #define SR_FS_OFF	_AC(0x00000000, UL)
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 1591e0781569..07da91080839 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -49,23 +49,12 @@ SYM_CODE_START(handle_exception)
 	REG_S x5,  PT_T0(sp)
 	save_from_x6_to_x31
 
-	/*
-	 * Disable user-mode memory access as it should only be set in the
-	 * actual user copy routines.
-	 *
-	 * Disable the FPU/Vector to detect illegal usage of floating point
-	 * or vector in kernel space.
-	 */
-	li t0, SR_SUM | SR_FS_VS
-
 	REG_L s0, TASK_TI_USER_SP(tp)
-	csrrc s1, CSR_STATUS, t0
 	csrr s2, CSR_EPC
 	csrr s3, CSR_TVAL
 	csrr s4, CSR_CAUSE
 	csrr s5, CSR_SCRATCH
 	REG_S s0, PT_SP(sp)
-	REG_S s1, PT_STATUS(sp)
 	REG_S s2, PT_EPC(sp)
 	REG_S s3, PT_BADADDR(sp)
 	REG_S s4, PT_CAUSE(sp)
@@ -77,6 +66,21 @@ SYM_CODE_START(handle_exception)
 	 */
 	csrw CSR_SCRATCH, x0
 
+	/*
+	 * Disable user-mode memory access as it should only be set in the
+	 * actual user copy routines.
+	 *
+	 * Disable the FPU/Vector to detect illegal usage of floating point
+	 * or vector in kernel space.
+	 *
+	 * Clear supervisor double trap bit as all trap context is saved and we
+	 * can handle another one
+	 */
+	li t0, SR_SUM | SR_FS_VS | SR_SDT
+
+	csrrc s1, CSR_STATUS, t0
+	REG_S s1, PT_STATUS(sp)
+
 	/* Load the global pointer */
 	load_global_pointer
 
@@ -123,15 +127,25 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 #ifdef CONFIG_RISCV_M_MODE
 	/* the MPP value is too large to be used as an immediate arg for addi */
 	li t0, SR_MPP
-	and s0, s0, t0
+	and t1, s0, t0
 #else
-	andi s0, s0, SR_SPP
+	andi t1, s0, SR_SPP
+#endif
+
+#ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
+	move a0, sp
+	call riscv_v_context_nesting_end
 #endif
-	bnez s0, 1f
+	/*
+	 * Restore STATUS now to set supervisor double trap bit which means that
+	 * from now on, we can not handle an exception up to "sret"
+	 */
+	csrw CSR_STATUS, s0
+	bnez t1, 1f
 
 	/* Save unwound kernel stack pointer in thread_info */
-	addi s0, sp, PT_SIZE_ON_STACK
-	REG_S s0, TASK_TI_KERNEL_SP(tp)
+	addi t1, sp, PT_SIZE_ON_STACK
+	REG_S t1, TASK_TI_KERNEL_SP(tp)
 
 	/* Save the kernel shadow call stack pointer */
 	scs_save_current
@@ -142,11 +156,6 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	 */
 	csrw CSR_SCRATCH, tp
 1:
-#ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
-	move a0, sp
-	call riscv_v_context_nesting_end
-#endif
-	REG_L a0, PT_STATUS(sp)
 	/*
 	 * The current load reservation is effectively part of the processor's
 	 * state, in the sense that load reservations cannot be shared between
@@ -167,7 +176,6 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	REG_L  a2, PT_EPC(sp)
 	REG_SC x0, a2, PT_EPC(sp)
 
-	csrw CSR_STATUS, a0
 	csrw CSR_EPC, a2
 
 	REG_L x1,  PT_RA(sp)
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4236a69c35cb..bcc2b6678f40 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -106,6 +106,10 @@ relocate_enable_mmu:
 	csrw CSR_SATP, a0
 .align 2
 1:
+	/* A trap potentially set the SDT flag, clear it */
+	li t0, SR_SDT
+	csrc CSR_STATUS, t0
+
 	/* Set trap vector to spin forever to help debug */
 	la a0, .Lsecondary_park
 	csrw CSR_TVEC, a0
diff --git a/arch/riscv/kernel/sse_entry.S b/arch/riscv/kernel/sse_entry.S
index d3c7286f3372..e69d386e36e9 100644
--- a/arch/riscv/kernel/sse_entry.S
+++ b/arch/riscv/kernel/sse_entry.S
@@ -65,7 +65,7 @@ SYM_CODE_START(handle_sse)
 	REG_S a4, PT_SP(sp)
 
 	/* Disable user memory access and floating/vector computing */
-	li t0, SR_SUM | SR_FS_VS
+	li t0, SR_SUM | SR_FS_VS | SR_SDT
 	csrc CSR_STATUS, t0
 
 	load_global_pointer
@@ -131,8 +131,8 @@ SYM_CODE_START(handle_sse)
 
 SYM_INNER_LABEL(ret_from_sse, SYM_L_GLOBAL)
 	/* Restore saved CSRs */
-	csrw CSR_SSCRATCH, s4
 	csrw CSR_SSTATUS, s5
+	csrw CSR_SSCRATCH, s4
 
 #ifdef CONFIG_FRAME_POINTER
 	/* Frame pointer is created only when kernel is interrupted */
-- 
2.43.0


