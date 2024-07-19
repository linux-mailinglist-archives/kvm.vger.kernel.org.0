Return-Path: <kvm+bounces-21943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EFE937A6E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF342829EA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273C7147C91;
	Fri, 19 Jul 2024 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DL1yZ5uq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F366A1474BF
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405381; cv=none; b=lJqXmwBpBF5vd/xevxZWgSQiT39m7ha8Es0tGqaFXQQPX+lCQKq+9Z2DhaupyYmNWzxFLAdVHJR7vjEO0dBYfE9r58HXh0nVCThlRK7ZdgYejpD9CzMoOIBd4rwAnrGAKaRpmnGXbSFiAGZCc2zR60O5MmWsCnXoGcI2pN0vMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405381; c=relaxed/simple;
	bh=/L+seQCf+RMScOQVgYb8NRrgsh3FL8CgiZqmAcI09qE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQjhK2X8CjvPMVX0ckOldd7tUS9aRWDohqvTZcFUW21EOsfp4TuaeDng920dUsIc0sjNqz7W2RZNhCrOJlmhkoaeSP1q8eg9DTHmbXT4EwO4oU813O+NuMIFZwap6ZGU0a9gBHZErv7uaQKz/so1caflEP7JSqPOg6IobKoqU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DL1yZ5uq; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fc56fd4de1so16472745ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405379; x=1722010179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmGpyKIpsYjD2Un1YAAjNQazrOZv5LQO9NnpLjromTA=;
        b=DL1yZ5uqfSmbJG2Pnfx3iyyKbWzfJhldXPM450mrNYFKDy/BdG+EXinv8eZBh3p0rE
         dqKZL+39pW0X57eTzCnMt/BVNfWuYud1J9Gg1oQXx4c/7678QxzvOGqv/rv2mePvUURc
         3ogSj8loN2LOTnsNjK54zAIJ3NtcimyIWS/LmxsyyE/WhS99hk9BHF62B6jbs63D6SAT
         tepJ/XnN4YHtJKPS+IWXnQ0s9194eQscXvfyWjFBGyiPlqAzPr7Th+P7fC/BgtsMbLPe
         ewrpnCHtQpJapxfzJZe9PjDnVldS5R92nYfbzImZx6FXSsfOOL9CT1DccXxGEdAr5vI3
         w2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405379; x=1722010179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmGpyKIpsYjD2Un1YAAjNQazrOZv5LQO9NnpLjromTA=;
        b=MwG/SfQqU2coDs+a31ZMAf3aOJNnQVnh4cKbVY8yddPW5DuF22HOOJA8Bl82rCLPX7
         ewGbsAlxh6A8SXa1zn5A77pVJsFdB6ZCOGZNs8lzx6OOwrfAfB0RqVcXOgEYyJvTpZfV
         7P+s/qqqdaZOqxaBxCwTVxz4wGJgJsI7EWk7URuXRgAISrI0+Ds9b+8E25x3DtBRQ+VB
         Qf9uGy0RvykXuA50JKO/CKNZFbWoDOPgrhYZWR8zARmGVmTNgoAXuw7cNLd6bKihka/l
         Lo7CME7USqgafysvkuJM9ud56mfu+YwYL6jhZ65RqIvxk3f+A0GcCo7zxM3P4gvUtYUp
         4SPg==
X-Forwarded-Encrypted: i=1; AJvYcCWbHFbz/0KAzbskM6akcyg3jiP3TFmcompF3Tk/E/B34PqdgQXHWar277ieMCQxsJ93VbMmcs6gBqcXDVzHPFeuO0LS
X-Gm-Message-State: AOJu0Yx73/EuJjL/7HGh05mWC1o6V51UZJ9vPRfmxuWYdUFDCTYk0a6q
	Y3dCoXQtq4R1sK1ojSPJupYek429GlG0z49r2E0kqJIvZGaJCbfgAjxbnVxxR9M=
X-Google-Smtp-Source: AGHT+IEx43SWMSduBJ80D+hDqdhh6L1kpIV5ped9Bm8n1yHsWnthT/wrpUHAZQLMRgacJBPbKhUTgw==
X-Received: by 2002:a17:902:f651:b0:1fb:5f9c:a86c with SMTP id d9443c01a7336-1fd74cfeddamr2369965ad.3.1721405378979;
        Fri, 19 Jul 2024 09:09:38 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:38 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 04/13] RISC-V: KVM: Break down the __kvm_riscv_switch_to() into macros
Date: Fri, 19 Jul 2024 21:39:04 +0530
Message-Id: <20240719160913.342027-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Break down the __kvm_riscv_switch_to() function into macros so that
these macros can be later re-used by SBI NACL extension based low-level
switch function.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_switch.S | 52 +++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 3f8cbc21a644..9f13e5ce6a18 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -11,11 +11,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/csr.h>
 
-	.text
-	.altmacro
-	.option norelax
-
-SYM_FUNC_START(__kvm_riscv_switch_to)
+.macro SAVE_HOST_GPRS
 	/* Save Host GPRs (except A0 and T0-T6) */
 	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
 	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
@@ -40,10 +36,12 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_S	s9, (KVM_ARCH_HOST_S9)(a0)
 	REG_S	s10, (KVM_ARCH_HOST_S10)(a0)
 	REG_S	s11, (KVM_ARCH_HOST_S11)(a0)
+.endm
 
+.macro SAVE_HOST_AND_RESTORE_GUEST_CSRS __resume_addr
 	/* Load Guest CSR values */
 	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
-	la	t1, .Lkvm_switch_return
+	la	t1, \__resume_addr
 	REG_L	t2, (KVM_ARCH_GUEST_SEPC)(a0)
 
 	/* Save Host and Restore Guest SSTATUS */
@@ -62,7 +60,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
 	REG_S	t1, (KVM_ARCH_HOST_STVEC)(a0)
 	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
+.endm
 
+.macro RESTORE_GUEST_GPRS
 	/* Restore Guest GPRs (except A0) */
 	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
 	REG_L	sp, (KVM_ARCH_GUEST_SP)(a0)
@@ -97,13 +97,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 
 	/* Restore Guest A0 */
 	REG_L	a0, (KVM_ARCH_GUEST_A0)(a0)
+.endm
 
-	/* Resume Guest */
-	sret
-
-	/* Back to Host */
-	.align 2
-.Lkvm_switch_return:
+.macro SAVE_GUEST_GPRS
 	/* Swap Guest A0 with SSCRATCH */
 	csrrw	a0, CSR_SSCRATCH, a0
 
@@ -138,7 +134,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_S	t4, (KVM_ARCH_GUEST_T4)(a0)
 	REG_S	t5, (KVM_ARCH_GUEST_T5)(a0)
 	REG_S	t6, (KVM_ARCH_GUEST_T6)(a0)
+.endm
 
+.macro SAVE_GUEST_AND_RESTORE_HOST_CSRS
 	/* Load Host CSR values */
 	REG_L	t0, (KVM_ARCH_HOST_STVEC)(a0)
 	REG_L	t1, (KVM_ARCH_HOST_SSCRATCH)(a0)
@@ -160,7 +158,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_S	t1, (KVM_ARCH_GUEST_A0)(a0)
 	REG_S	t2, (KVM_ARCH_GUEST_SSTATUS)(a0)
 	REG_S	t3, (KVM_ARCH_GUEST_SEPC)(a0)
+.endm
 
+.macro RESTORE_HOST_GPRS
 	/* Restore Host GPRs (except A0 and T0-T6) */
 	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
 	REG_L	sp, (KVM_ARCH_HOST_SP)(a0)
@@ -185,6 +185,34 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_L	s9, (KVM_ARCH_HOST_S9)(a0)
 	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
 	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
+.endm
+
+	.text
+	.altmacro
+	.option norelax
+
+	/*
+	 * Parameters:
+	 * A0 <= Pointer to struct kvm_vcpu_arch
+	 */
+SYM_FUNC_START(__kvm_riscv_switch_to)
+	SAVE_HOST_GPRS
+
+	SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_switch_return
+
+	RESTORE_GUEST_GPRS
+
+	/* Resume Guest using SRET */
+	sret
+
+	/* Back to Host */
+	.align 2
+.Lkvm_switch_return:
+	SAVE_GUEST_GPRS
+
+	SAVE_GUEST_AND_RESTORE_HOST_CSRS
+
+	RESTORE_HOST_GPRS
 
 	/* Return to C code */
 	ret
-- 
2.34.1


