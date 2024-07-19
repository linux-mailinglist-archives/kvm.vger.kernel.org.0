Return-Path: <kvm+bounces-21942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7C1937A6B
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75AE7282D48
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D40E1474AF;
	Fri, 19 Jul 2024 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JTrUH9Sp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80D146D54
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405378; cv=none; b=lpSjPbZPdpWouWp1MazMx6I0zHNtXvF+k1yXL278nGy9wv04DN6HVqZ4FDo8bpIBlhUQ4/4jhfwDADIorGwzDKx/0J+4BwlM2SZ8LdI6hvLJtvFGpjyIWYvanKm/PdG+YS/Sq6NsoLGO/pBdPhXXCtOC6OwYe/5vgMzEIw9mWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405378; c=relaxed/simple;
	bh=Mb0AIfTjMhZS2Wy+2NAQ5fSKiNxamRzFM6pV8JyJzbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aZDjwxXpzxLnVjWvHdspXYiLV/UllmCdfRqtAFQiFQsB+xJcXapxl036FGGPXx7T6PoZHsw86noCQARQWMh9TQny3jo1/DXGiIdj2mv8LjzrO6VXEElRF/bP9mtnu533v5sWBYedpwDIyofHZ75M+e1IyrcRjqIyhBNCbQP57hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JTrUH9Sp; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70af22a9c19so823413b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405376; x=1722010176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3NWlthcoywMVunFB4+gvIDJc/eJtmciuSUTOqnPM9U=;
        b=JTrUH9Spfj3S3l+RcXu1nMU9ol+edYyOryD/UpUp20p5Pa5FFPcE28/8mBhgcOJ9hx
         v3vJpk1GJaVMtEtkOp2UClz2z2PvW1n/b8qu3DhjpW4LeFllSROmP+O39gP1zA54OX2q
         x8SRU3U2DyJSS52/jBNOh4LE7Fwn0EbwGkcpLzRm5zJbLgDVshtp1ZlcaPszoCt6nUIZ
         kj8GwmL9rLkGhotpGzLG9tnaYEDkmsn7T+yIJIVxEJ97c+gkOs/QcVv/dHuKtl31Rvqx
         /D2UAe4KLyKyEnUopxAiK70rDg2OA0XoHIx2/ECKgnhm7nRlIXCp+Tz0bJ7bZR+1ifob
         AoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405376; x=1722010176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3NWlthcoywMVunFB4+gvIDJc/eJtmciuSUTOqnPM9U=;
        b=bci0zbU5dmtAf/TrrmfpJN90e7qLurzCcvUpQ/EsxE2V5PDtzPrc78ly/ETsxxPxQL
         pcJ6EZWxxqyalLJU/u4HuegN9nkhIdIZHxrsBV/EuL8J4VL++fTxj5UmKD7wwebuz0wY
         X8nKwSJo/Ikf0LDGkXCCQ9RliPOcexolW2aglGOdoBzdx8L1KnHTOoS1Tx5bJcUn7NZU
         85cnHBHYtZI6pCOisZKRfE0jFX3OZW2dTub7ZNNpFRt9mYoFwM7FzFmvA0KoiUurDxbi
         Av125jrV6qbbm0/sCMIz0yrysFzQQHlzj18FRiCU+poeukoKKaivoydlAaJNMn683jI7
         JWgw==
X-Forwarded-Encrypted: i=1; AJvYcCWeoLiQRRJBxKq1e4/6Xs3RyVYsz13m7kFwVIf7GI8w6UaNm2lH26VGR7tMPXwFTPXS6gi3AD2dp4UZeSowrQdZO8B9
X-Gm-Message-State: AOJu0YyWZ3U394xnJJv70agHUsehzppvOPs3cAKikqTKmHwJag0h8bm+
	gFQzV3Z1zQLTwtg3De75sQZ0sz21oQXjLkVOlsl0ZMqQmFe3QVKD09fewB9Xajg=
X-Google-Smtp-Source: AGHT+IHSyLP6BUKo5Y6kcqhYNpaqUtXlIEUBiGZ3Sff8ZSea+zDXaY9Z5yRlxXFAYJK3pPW05CR8DA==
X-Received: by 2002:a05:6a20:9145:b0:1c0:f1cb:c4b2 with SMTP id adf61e73a8af0-1c3fdcbfff9mr10900609637.4.1721405375471;
        Fri, 19 Jul 2024 09:09:35 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:34 -0700 (PDT)
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
Subject: [PATCH 03/13] RISC-V: KVM: Save/restore SCOUNTEREN in C source
Date: Fri, 19 Jul 2024 21:39:03 +0530
Message-Id: <20240719160913.342027-4-apatel@ventanamicro.com>
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

The SCOUNTEREN CSR need not be saved/restored in the low-level
__kvm_riscv_switch_to() function hence move the SCOUNTEREN CSR
save/restore to the kvm_riscv_vcpu_swap_in_guest_state() and
kvm_riscv_vcpu_swap_in_host_state() functions in C sources.

Also, re-arrange the CSR save/restore and related GPR usage in
the low-level __kvm_riscv_switch_to() low-level function.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c        |  2 ++
 arch/riscv/kvm/vcpu_switch.S | 52 +++++++++++++++---------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 93b1ce043482..957e1a5e081b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -691,6 +691,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_guest_state(struct kvm_vcpu *
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	vcpu->arch.host_scounteren = csr_swap(CSR_SCOUNTEREN, csr->scounteren);
 	vcpu->arch.host_senvcfg = csr_swap(CSR_SENVCFG, csr->senvcfg);
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN) &&
 	    (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
@@ -704,6 +705,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
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
2.34.1


