Return-Path: <kvm+bounces-47408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A62BAC158A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55EBD1B66464
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C89C23A9A8;
	Thu, 22 May 2025 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="p9PYFjVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CEE238C35
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946140; cv=none; b=EtXa5utofg2hBeFODLaa/FI+A9t6plXLw2hC/IVfSskTSYtF2TNWGULF/pfS5VVaXXW2OayWbCCGckS48z3kimAwXNHFKBBzgnFJ3aI1nP0JxNUW00Qzp2tCfKmAslT3b1AIkX1VLlKP7EC6JMhZ/jXN8dQ/P7dEbFLvL0o0oCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946140; c=relaxed/simple;
	bh=5PhR4Cke8yMwoA4uPKJBWa65xrmcQt00CtfyS9bPFCo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hIeCPTDpxItpCNHSzjYIqPbJA2jY3igGk2svoTBLKp6U4+BGJM5rWrOVK7arnBV6uIVC6SvWnM8Ipir6MqPibLQFZKEB343ND8Da8zV03s7ld7ATkslx2w/jwZfvzna8blTwmZmzQTzNxLrVZPcT0sMfOYWecZ9aeSpxx6MgDoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=p9PYFjVp; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so5382282a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946138; x=1748550938; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GuR/z1GpxuJ9rGb2JSweVgvKX4SVj6nkkUnTCjHYUz4=;
        b=p9PYFjVpWX9JdpITTcooJzggyOMBFTxu2a/wfBC0DuCYsToyDhCgYNcqnbo5TCnvLp
         1edNhMSKNBhyx04BV+hNQI7JPwa2t8eXRXCMcCk7jciWt/slwS0XNXLCsA+TOU3Y3aX7
         fW0SaZ5lL1GRVRkl3bGxt/cgyFgvvysCmhdxbZA4ttS4Gfj7WGpqWfHC5Dhqto2vl4lQ
         zJIM1DnMp5Lin5xehfLYQvjh9V1cTsfiXnJk0XF/W5sPGxeLD5eMOIu42hkE4umZgLyf
         TCyR5ZRF8wniQNYtx0vjuCiYGCRhuDBjSQnp6QFAJC0q4OoxDC5QWzVRWxOUYr2pJgmx
         aFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946138; x=1748550938;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuR/z1GpxuJ9rGb2JSweVgvKX4SVj6nkkUnTCjHYUz4=;
        b=uFqxyJ69e7GYmiuyxl/oCB7ZOA6RCon5DwgXnhtySRlhc370us22WZ06Nzr2Lj5IAo
         JHbuy704f1KgzlEG++2YWPjhOuSd+sDEDyP3PltDjGIQmSSJU44LS8kZ1dqE7SxZaQgr
         klneaAT/yDnuePojgDFrsPFBmscVRl7EFdpdCyyaceZ7AG+NiU19J5IxgVlY/o6UKps4
         DNN26wvA0BznRa8ly8rGX4WyJRFTVmQKwWfT6znMGieBuYVevFaHHVi3DGToAweo/E5g
         04fOMJ8rZNGICewn2oPAaXMByVyrIbsdPAxU1+GIuj4wfcoq0VdnXFtMirbqWkaln2Mw
         rDzw==
X-Gm-Message-State: AOJu0Yw+Xs5usPv0EiBzBjPnOTGWuedJKbDwmm/8gkbD0E4GbBvWXnt6
	lqCWAdZarlvn/g6PwlrZ/6PQUnwQyTd5nqsJcxZddH4cp9JdvprHvx7oAmQ4QiljUUI=
X-Gm-Gg: ASbGncseG3zpOCavjvSOo6Xca7rdVoqWamDCwj0GDOm0hPQI/VpVGtSMC5cIf8x+l8b
	hzUw7vFmz7UvIJ+K/99criYlBnrYh18uVWUqz//aHzEoVl57ip1p811qjD0Yg+VbXa3upLrgoT7
	tKFdnuOw6xNYdzruMAnsAHSHixiPN4tBRb0aWhAUpxG0T5CHCX8KXkISAwIFUCl+NukkAXaOXFy
	5TIgUBvvK2XoMTVkbs1Z0SOEDwHOOIAXsNrktjyGI2+RmScBY7PtLGb+CPaTUhh9qVR+sILEUfn
	38aJAg/9S3HZXGZws1w+Xd3HB+/ZVF6QSb/DpD9R4hG/LHqCIuwc3j7DuBoKYccB
X-Google-Smtp-Source: AGHT+IF8umjnswXbCK9h2ygGRuvFLfM+6wDcV4ZgplnSPknSDclMZnijppDTERnvVHLPyJpY/CvMbw==
X-Received: by 2002:a17:90b:1dc9:b0:30a:3e8e:492c with SMTP id 98e67ed59e1d1-30e7d5be2ccmr33662120a91.32.1747946137764;
        Thu, 22 May 2025 13:35:37 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:37 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 13:35:25 -0700
Subject: [PATCH v2 1/5] RISC-V: KVM: Lazy enable hstateen IMSIC & ISEL bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-1-b7a84991f1c4@rivosinc.com>
References: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
In-Reply-To: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Currently, we enable the smstateen bit at vcpu configure time by
only checking the presence of required ISA extensions.

These bits are not required to be enabled if the guest never uses
the corresponding architectural state. Enable the smstaeen bits
at runtime lazily upon first access.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_aia.h |  1 +
 arch/riscv/kvm/aia.c             | 43 ++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/aia_imsic.c       |  8 ++++++++
 3 files changed, 52 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 1f37b600ca47..760a1aef09f7 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -112,6 +112,7 @@ int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type);
 int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level);
 int kvm_riscv_aia_aplic_init(struct kvm *kvm);
 void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm);
+bool kvm_riscv_aia_imsic_state_hw_backed(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_32BIT
 void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 19afd1f23537..1e0d2217ade7 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -241,6 +241,8 @@ int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
 				 unsigned long new_val,
 				 unsigned long wr_mask)
 {
+	bool vsfile_present = kvm_riscv_aia_imsic_state_hw_backed(vcpu);
+
 	/* If AIA not available then redirect trap */
 	if (!kvm_riscv_aia_available())
 		return KVM_INSN_ILLEGAL_TRAP;
@@ -249,6 +251,26 @@ int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
 	if (!kvm_riscv_aia_initialized(vcpu->kvm))
 		return KVM_INSN_EXIT_TO_USER_SPACE;
 
+	/* Continue if smstaeen is not present */
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN))
+		goto skip_hstateen;
+
+	/* Enable the bit in hstateen0 lazily upon first access */
+	if (!(vcpu->arch.cfg.hstateen0 & SMSTATEEN0_AIA_IMSIC)) {
+		vcpu->arch.cfg.hstateen0 |= SMSTATEEN0_AIA_IMSIC;
+		if (IS_ENABLED(CONFIG_32BIT))
+			csr_set(CSR_HSTATEEN0H, SMSTATEEN0_AIA_IMSIC >> 32);
+		else
+			csr_set(CSR_HSTATEEN0, SMSTATEEN0_AIA_IMSIC);
+		if (vsfile_present)
+			return KVM_INSN_CONTINUE_SAME_SEPC;
+	} else if (vsfile_present) {
+		pr_err("Unexpected trap for CSR [%x] with hstateen0 enabled and valid vsfile\n",
+		       csr_num);
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+	}
+
+skip_hstateen:
 	return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, KVM_RISCV_AIA_IMSIC_TOPEI,
 					    val, new_val, wr_mask);
 }
@@ -400,11 +422,32 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long wr_mask)
 {
 	unsigned int isel;
+	bool vsfile_present = kvm_riscv_aia_imsic_state_hw_backed(vcpu);
 
 	/* If AIA not available then redirect trap */
 	if (!kvm_riscv_aia_available())
 		return KVM_INSN_ILLEGAL_TRAP;
 
+	/* Continue if smstaeen is not present */
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN))
+		goto skip_hstateen;
+
+	/* Enable the bit in hstateen0 lazily upon first access */
+	if (!(vcpu->arch.cfg.hstateen0 & SMSTATEEN0_AIA_ISEL)) {
+		vcpu->arch.cfg.hstateen0 |= SMSTATEEN0_AIA_ISEL;
+		if (IS_ENABLED(CONFIG_32BIT))
+			csr_set(CSR_HSTATEEN0H, SMSTATEEN0_AIA_ISEL >> 32);
+		else
+			csr_set(CSR_HSTATEEN0, SMSTATEEN0_AIA_ISEL);
+		if (vsfile_present)
+			return KVM_INSN_CONTINUE_SAME_SEPC;
+	} else if (vsfile_present) {
+		pr_err("Unexpected trap for CSR [%x] with hstateen0 enabled and valid vsfile\n",
+		       csr_num);
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+	}
+
+skip_hstateen:
 	/* First try to emulate in kernel space */
 	isel = ncsr_read(CSR_VSISELECT) & ISELECT_MASK;
 	if (isel >= ISELECT_IPRIO0 && isel <= ISELECT_IPRIO15)
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 29ef9c2133a9..d8e6f14850c0 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -361,6 +361,14 @@ static int imsic_mrif_rmw(struct imsic_mrif *mrif, u32 nr_eix,
 	return 0;
 }
 
+bool kvm_riscv_aia_imsic_state_hw_backed(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
+	struct imsic *imsic = vaia->imsic_state;
+
+	return imsic && imsic->vsfile_cpu >= 0;
+}
+
 struct imsic_vsfile_read_data {
 	int hgei;
 	u32 nr_eix;

-- 
2.43.0


