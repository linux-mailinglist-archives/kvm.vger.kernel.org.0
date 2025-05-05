Return-Path: <kvm+bounces-45468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B72AAA9E40
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82C43B6A56
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E252274FF4;
	Mon,  5 May 2025 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ohzy+g+6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C327465B
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 21:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746481180; cv=none; b=o00UJ65dqWpRS1MslETYDtRXcJfmxZMvFB6jOVDR88LM+H1ZQdMNauAmk94T1dnQX1elqgpF51+yLd/2Ms6r/4nBQUm4OHLd8fUbpIWyNzS5ahKu4pdnCz2IKLm9HEw6LS8axUrtjnVB0RpjYnwKw1ElThldQIOjHBuHlohoe/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746481180; c=relaxed/simple;
	bh=5PhR4Cke8yMwoA4uPKJBWa65xrmcQt00CtfyS9bPFCo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kdw0FZ4C3DdNckRuZTCg+7mVTz46sqF1CF1V8woERn/FtzfWaLtprzDtAEJVcjTaGdlIWzO5k1rSsG+iCrsi+QQSNCTSs49Uj2MT/6ap5+UhStWIyK95sH7dR2vRAz6yQcLzd+EJlk+XPqN3mYIYYzfOjeDdm5+EBPzYkhiT/O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ohzy+g+6; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2241053582dso74327955ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 14:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746481177; x=1747085977; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GuR/z1GpxuJ9rGb2JSweVgvKX4SVj6nkkUnTCjHYUz4=;
        b=Ohzy+g+6hZbJQLRJRHPr0TQ1O87bk+3sRgUZgcxEGSqaxMSjogksq+h3OWw88VRZVh
         6Nsry3GiWf32vLrFmWfuuSh/HCHo6cr+QhyoNAT9SPhnM6Xbaj2hB4EAY2+zfeX3LDDC
         TrTFikHt0hzLHYFBwJ+yej6uVo/zPH6abIZqd40MIK13EzG3aPTaPCaVtGGfwEWBxIGM
         KXvx/YKEL91ea3kHPKRagtDf9f+ge5MFN95eQQhx3N9zrvTWx3eGgXy8lFnYteUBzicA
         EdK71MhRIsjs7ptcJ6p710nRUpWkJsabWNmsFOlHeJUR9wXoGQGuJ7CrSEL0X2Cz86v1
         8BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746481177; x=1747085977;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuR/z1GpxuJ9rGb2JSweVgvKX4SVj6nkkUnTCjHYUz4=;
        b=LDgHtCjcBWGj/Wsvqs9G8sG8HuKB7AH2MRjw68Yla9sZ7pDpY1GVHt5h0PeGaM4mq9
         GuMieCjEC2+WTxWsIC4iW0ZbVSd/dcQFgGWQwWTvASH6UKhIyTqUc9PjnA4ox/Wd9XaW
         1YCfF2rJe279QaqOsga04Zs0Tqy4eXd4haqwm2ueP7kxOAFPFY1CVLmgBIlIeNuZqXTb
         /TE651a1xH2h9XrwNdZ8jFr5B6fdhNRj3TNYIryoRUq2BtBtjzlMOVaakifWh9wZvrij
         KRL+uU02te62W/DizkVXY1oiUbMcn8Rmdx0UDLOveTB0qkh3QMPMeVb7qE973unaeE8K
         Q3mg==
X-Gm-Message-State: AOJu0YwfTpRtljvhH9Cy3ZsThAqjgLYqeBh1NSpnAQg6rUwzIobOSZr/
	c8BImpf3Wqxhj9TyddAc83t1ixCgecmzJqOYa1gyuAWtJCjiyLDS9VUbL6Mzf6M=
X-Gm-Gg: ASbGncsg5ZQkc4wTUAR+PTfe+xgbpYMWDYvkPi8KU51b14G5RCjb6V9BqP2dz64JjeT
	fOey2wS88gy6DikkixypXqRXfjDYS1CktxCRnAyA9OeUg1KGo8HHgzHfB2NZX6DAzfk6Lcrg5+u
	Rg1B/sFfs/9lY9rDjzaIlkPiIDh4VaYJt0TM27ArlEQ0HE5zpSTiSEYQ6m++U1osVOw4GWAtplK
	elu1n2Xeg6VzDejA2tOTxBb9ydEJB9j1QRtglWMJ4X5Ezt5HNqDMdXkKR/ial3jV0vEzAkTkx/C
	9GNSdT6MFgFt497PFcXUim/NueU5b7TpsOevECCIgWNoxDlFKrzIcw==
X-Google-Smtp-Source: AGHT+IGhry+0GqEK0QENhdqzpXsxfdR/JgSEWuVPvlQK1RPcseXdT65lptZT2IHTz8U/93rQIvZwKw==
X-Received: by 2002:a17:903:41cb:b0:220:e1e6:4472 with SMTP id d9443c01a7336-22e328cf92emr13304615ad.13.1746481177225;
        Mon, 05 May 2025 14:39:37 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df12d8sm7388599b3a.78.2025.05.05.14.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 14:39:36 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 05 May 2025 14:39:26 -0700
Subject: [PATCH 1/5] RISC-V: KVM: Lazy enable hstateen IMSIC & ISEL bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250505-kvm_lazy_enable_stateen-v1-1-3bfc4008373c@rivosinc.com>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
In-Reply-To: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
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


