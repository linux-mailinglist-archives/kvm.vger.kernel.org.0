Return-Path: <kvm+bounces-29213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A22BF9A5674
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14C10B227C3
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1691991C8;
	Sun, 20 Oct 2024 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WyGg1wgL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD89198E65
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453672; cv=none; b=KJhdFiyAGHY8q4REtf770laZ19dDsL7+pk8n31yNwrseZpKlyOO0XoFrjC7KKyG4/z7H/gBOtIK4XtGYgLWoKyGjw5iaxKXAE72s74J86o4KkAvoewjjD1/eJza/GLCjnfJaTqvOaMqlUGFiKgvaX6xd1FodCh0Q+fCrFKfXjFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453672; c=relaxed/simple;
	bh=6bWzSmvGfg7VcnSp11hW4tETYIx01Z9YISaX0exgR0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgXD9KYR0KnU7R5Up9q1XalZaCiqPK4nWXG38P5ctd7jlHyw92XmBzBqt/peRiKi/XF8wyNo5NnM0VcOdg9lE100v4rqgbhIU1Cimb0c0kqmaHNl60rV2c8lZmhUTX22uLuCwBGjSEeC3LBZutxu1cfn8ijAlpw7JE5sweP/6/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WyGg1wgL; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e2eb9dde40so3073801a91.0
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453670; x=1730058470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjxqRhm7xrGjz8Ovok1N736zyKzdvbsEt213nSnt+BI=;
        b=WyGg1wgL7JOXHRMvab/ikKg8sYLdbO1Us56Zyil8Xnc0W/ozeBycJHhZgaUFDH4P97
         yYmSkk/uSdzFAcMAxFEbio8/sIbTwUGiBu2c4+e5JMUIwjXflAKB3vuWUYZzHjUa34vF
         AmAOc/RthluvkNh8t9mm94AtP/xsqAt4ybUAFbV1k0owdGHTVX6oSEJDa7XIJdfBXRfN
         7R3KwmFzT60ElOlxWjd8+FEOcf6/UEq5pWYqEfjeOMRp1BM94YL8KDrqG65Tbb2Dwiir
         bVJxMenx48g0Y8PxbfKeCZqCL7lsNzSRM4vj+KAAnb71VxH8a6Vi95+qgH+DceMZBZlI
         Bk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453670; x=1730058470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjxqRhm7xrGjz8Ovok1N736zyKzdvbsEt213nSnt+BI=;
        b=FB71WIVEESWITCiilAUiijm1kA2an6qRI9f9agBKa9Rwx8p4H63RohVXbid9M5In8l
         Jkg7bQDCElNfreUHbbBbCS/lVkr234v/lFaQxAvCXswKLbWZhJt1VFDxLnpIJeOUYfXH
         +sgJAk1MqdrB9NS+1wH7L4rrf4WGcjD3MYg/UTdCfgAcaXED43qgLuz4jLBdrRj81iSd
         2ZKcmoxaNhHBlInI8NZkP4ObQ+8UnkpSn+Phw42VXfUCq0LG/HEM+0S3iBdQ6e6wzroJ
         zMnNGockVOKLHoOEYxgiiVwp1hyIYiOgC7ocLYLKLnXcxC+N9SHN4Hb9PoQUKOgWrptP
         ObpA==
X-Forwarded-Encrypted: i=1; AJvYcCWxEfxhaUXCcA7hBAGgp3iEmFZukIKdGYNmq8ohpoCtrw64R/953kqAhPvEIJqvz321SSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbXr5slkOSiA35k73QDG241c2RJtGKPpx/kg9oqLLT+s7goBLy
	Aawhoqm/2enc0lwUpopPoQJi9+D4tmZBtszvQ2crYeTlB9WGIoUN+C0AsqYNVjY=
X-Google-Smtp-Source: AGHT+IGSbrFfEsCiKKrMtJuowc85sYHNI6rlNZmFsVNLUA0j4KKYlpfFIvbCLDM9xKhydrTr8zEK0Q==
X-Received: by 2002:a17:90a:7086:b0:2e2:c421:894b with SMTP id 98e67ed59e1d1-2e561726f19mr11200428a91.14.1729453669660;
        Sun, 20 Oct 2024 12:47:49 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:47:48 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 03/13] RISC-V: KVM: Save/restore SCOUNTEREN in C source
Date: Mon, 21 Oct 2024 01:17:24 +0530
Message-ID: <20241020194734.58686-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241020194734.58686-1-apatel@ventanamicro.com>
References: <20241020194734.58686-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SCOUNTEREN CSR need not be saved/restored in the low-level
__kvm_riscv_switch_to() function hence move the SCOUNTEREN CSR
save/restore to the kvm_riscv_vcpu_swap_in_guest_state() and
kvm_riscv_vcpu_swap_in_host_state() functions in C sources.

Also, re-arrange the CSR save/restore and related GPR usage in
the low-level __kvm_riscv_switch_to() low-level function.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c        |  2 ++
 arch/riscv/kvm/vcpu_switch.S | 52 +++++++++++++++---------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 53ee29490c7f..a972dd46e7e4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -702,6 +702,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_guest_state(struct kvm_vcpu *
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	vcpu->arch.host_scounteren = csr_swap(CSR_SCOUNTEREN, csr->scounteren);
 	vcpu->arch.host_senvcfg = csr_swap(CSR_SENVCFG, csr->senvcfg);
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN) &&
 	    (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
@@ -715,6 +716,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	csr->scounteren = csr_swap(CSR_SCOUNTEREN, vcpu->arch.host_scounteren);
 	csr->senvcfg = csr_swap(CSR_SENVCFG, vcpu->arch.host_senvcfg);
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN) &&
 	    (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index f83643c4fdb9..3f8cbc21a644 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -43,30 +43,25 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 
 	/* Load Guest CSR values */
 	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
-	REG_L	t1, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
-	la	t3, .Lkvm_switch_return
-	REG_L	t4, (KVM_ARCH_GUEST_SEPC)(a0)
+	la	t1, .Lkvm_switch_return
+	REG_L	t2, (KVM_ARCH_GUEST_SEPC)(a0)
 
 	/* Save Host and Restore Guest SSTATUS */
 	csrrw	t0, CSR_SSTATUS, t0
 
-	/* Save Host and Restore Guest SCOUNTEREN */
-	csrrw	t1, CSR_SCOUNTEREN, t1
-
 	/* Save Host STVEC and change it to return path */
-	csrrw	t3, CSR_STVEC, t3
-
-	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
-	csrrw	t2, CSR_SSCRATCH, a0
+	csrrw	t1, CSR_STVEC, t1
 
 	/* Restore Guest SEPC */
-	csrw	CSR_SEPC, t4
+	csrw	CSR_SEPC, t2
+
+	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
+	csrrw	t3, CSR_SSCRATCH, a0
 
 	/* Store Host CSR values */
 	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
-	REG_S	t1, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
-	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
-	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
+	REG_S	t1, (KVM_ARCH_HOST_STVEC)(a0)
+	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
 
 	/* Restore Guest GPRs (except A0) */
 	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
@@ -145,31 +140,26 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_S	t6, (KVM_ARCH_GUEST_T6)(a0)
 
 	/* Load Host CSR values */
-	REG_L	t1, (KVM_ARCH_HOST_STVEC)(a0)
-	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
-	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
-	REG_L	t4, (KVM_ARCH_HOST_SSTATUS)(a0)
-
-	/* Save Guest SEPC */
-	csrr	t0, CSR_SEPC
+	REG_L	t0, (KVM_ARCH_HOST_STVEC)(a0)
+	REG_L	t1, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	REG_L	t2, (KVM_ARCH_HOST_SSTATUS)(a0)
 
 	/* Save Guest A0 and Restore Host SSCRATCH */
-	csrrw	t2, CSR_SSCRATCH, t2
+	csrrw	t1, CSR_SSCRATCH, t1
 
-	/* Restore Host STVEC */
-	csrw	CSR_STVEC, t1
+	/* Save Guest SEPC */
+	csrr	t3, CSR_SEPC
 
-	/* Save Guest and Restore Host SCOUNTEREN */
-	csrrw	t3, CSR_SCOUNTEREN, t3
+	/* Restore Host STVEC */
+	csrw	CSR_STVEC, t0
 
 	/* Save Guest and Restore Host SSTATUS */
-	csrrw	t4, CSR_SSTATUS, t4
+	csrrw	t2, CSR_SSTATUS, t2
 
 	/* Store Guest CSR values */
-	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
-	REG_S	t2, (KVM_ARCH_GUEST_A0)(a0)
-	REG_S	t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
-	REG_S	t4, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	REG_S	t1, (KVM_ARCH_GUEST_A0)(a0)
+	REG_S	t2, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	REG_S	t3, (KVM_ARCH_GUEST_SEPC)(a0)
 
 	/* Restore Host GPRs (except A0 and T0-T6) */
 	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
-- 
2.43.0


