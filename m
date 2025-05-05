Return-Path: <kvm+bounces-45471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5A2AA9E45
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5BF51A81634
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F6C2777E3;
	Mon,  5 May 2025 21:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gFpycmdh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9B41922DC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 21:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746481181; cv=none; b=MuczBOkEMQ/zKMJN17t4b+0hQjQWHR0biEmMb7Y8B04SluKJZpz6Y8Uews1LgoL4oPCni0E9bFQV7XQbTQi27y9v0LIaOP7x6Rr4Sm+1VQFf0FxOwGHhO4G/OkuVVYWq83Wz7ujdegxMZ5FJHzPlwgjO0OfjUCcVGd3C1MvXTI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746481181; c=relaxed/simple;
	bh=jhp/61im/NHYvFzN/JEXw6pD0pJy0Hk/tmvWDBz/SFM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ER4mc+uqaQXBqFLzXg4fCwRDcxClsbLzhDLmQe7w6iFAK551+REKfkr99e1nxEMhWLKWMRRVs3qShzJ4A0/yYpfEh6ayHhPcKl4mwMEeh8oxBK90qjVPf2xeNdWQBNdBS+unway1Wag8QeUW2pZbGLQczuE83SipNulwCAqA9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gFpycmdh; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2243803b776so366685ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 14:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746481179; x=1747085979; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBkYMTmSl4PimBL1H4hWSadeldBIQV0hA1hHqFFVE6E=;
        b=gFpycmdh43qMf4a1ik6oAS3vDg61v0R8M/JeDgndL26gLENsgCoK3p747btYo/jxsg
         9IqLoBGljp/2IBwFvjaqxBsP6AGJuSF+Y2vCVZvTFHGEqotcI7P68EB8VMcnPQsDTk+y
         bNRqUw2rXBB+LA4DXrXWXBIzg2AYoq6fvxN/ZKTNDqyVhiKPFX+CtTt0Ulnv8AlSjUsr
         gSb5oJ5wB8lza+wqkVGi4o89YjUx0Z+U8inLnKgqXhfrjHJVHjz6QVLtTIPL+YUd0sv1
         Vxxf59N5CTgJowP9wiD1/sxy0hIyoK59bTaxwigpJSHjG5PatCmsH+XpycB32oj70S+w
         QvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746481179; x=1747085979;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBkYMTmSl4PimBL1H4hWSadeldBIQV0hA1hHqFFVE6E=;
        b=cqMjU9rxxDvmPj45U5Q4K2BO0n8S3VhoXN/glp3EFEIVK7dMP3DadMV3DBliqGqjfp
         gOZPlzstqkUZS9l0k60zWsc5+8yc7GM3gJh707ayUVEO/qBe2DhPklref90XWCpNjpb/
         bL6FMs/UoL/CT0KQiFDE52xhGGQhBK8JseTQHKO647h9XxbL4RIrW36rAnRIVMajSvn6
         VQQ188Qq/AEm+0Sl7J0qNrrDrPvKbSt4mae1aJ4NaqwtNEiBoZVIr4kUt/NH0YbSYLoL
         /scDmmCRvHqXtI/yPyJw6JgnYPhsMALS75lXWCLW103MWuoGnZ/APb5WcvdKPdtRsjSN
         1cYg==
X-Gm-Message-State: AOJu0YzApmNsOw+9ABXIoWwcDwROqVzsnro59Uu2pCIhrdnuGz62WzLN
	ALSPuMNkBArpulohSUM+36Dxj21dNE35wzUEYoIFKkyTDwoM3iJpHiYkpTTslvXnkdvyRL1oB2o
	K
X-Gm-Gg: ASbGnctKdxMAsVM8qlU2T07+h/9et9M1aLLwtMw/mU206P3NHjyaTibquic1C7GBBca
	edkyhWPb1hlqN4QBWzzkQhiAxvREHp+AcjDJorWBsEpbmcT7ZrkAhH8E586yJbgDdW9dTwQcPR4
	MGDy/aYGZ8fICBdEkjg3sfxdVMhevTBbiFwrCTSWqItGx5/XskS+SZ1Sv5BHD9sM39K8+IYyMVV
	Hyy8S5BUVL1quUFqVh/TZgJqbWt9EKE2qgIYHL2HEaa8Hot92CCiNSFqAfT80kFDJzpXikph0EH
	iHXuf5/h5ujo+Kpvoi3hh7apSjOXTNi1Vggai8elP9XLufLdP1tpIQ==
X-Google-Smtp-Source: AGHT+IFSjl7ZZTm9sRdhzbga0ISTzjUyoYmypOpH2UHF3JUrUhm15fO1yXOvC7GyT9L7318UQ6VTkw==
X-Received: by 2002:a17:902:ecc1:b0:224:c76:5e57 with SMTP id d9443c01a7336-22e3637e732mr7765845ad.39.1746481178982;
        Mon, 05 May 2025 14:39:38 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df12d8sm7388599b3a.78.2025.05.05.14.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 14:39:38 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 05 May 2025 14:39:28 -0700
Subject: [PATCH 3/5] RISC-V: KVM: Support lazy enabling of siselect and aia
 bits
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250505-kvm_lazy_enable_stateen-v1-3-3bfc4008373c@rivosinc.com>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
In-Reply-To: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Smstateen extension controls the SISELECT and SIPH/SIEH register
through hstateen.AIA bit (58). Add lazy enabling support for those
bits.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_aia.h | 13 ++++++++++++-
 arch/riscv/kvm/aia.c             | 34 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_insn.c       |  3 +++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 760a1aef09f7..9e39b0e15169 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -142,12 +142,23 @@ int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
 				 unsigned long *val,
 				 unsigned long new_val,
 				 unsigned long wr_mask);
+int kvm_riscv_vcpu_aia_hstateen_enable(struct kvm_vcpu *vcpu,
+				       unsigned int csr_num, unsigned long *val,
+				       unsigned long new_val, unsigned long wr_mask);
+int kvm_riscv_vcpu_aia_rmw_isel(struct kvm_vcpu *vcpu, unsigned int csr_num, unsigned long *val,
+				unsigned long new_val, unsigned long wr_mask);
 int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask);
 #define KVM_RISCV_VCPU_AIA_CSR_FUNCS \
 { .base = CSR_SIREG,      .count = 1, .func = kvm_riscv_vcpu_aia_rmw_ireg }, \
-{ .base = CSR_STOPEI,     .count = 1, .func = kvm_riscv_vcpu_aia_rmw_topei },
+{ .base = CSR_SISELECT,   .count = 1, .func = kvm_riscv_vcpu_aia_rmw_isel }, \
+{ .base = CSR_STOPEI,     .count = 1, .func = kvm_riscv_vcpu_aia_rmw_topei }, \
+{ .base = CSR_STOPI,      .count = 1, .func = kvm_riscv_vcpu_aia_hstateen_enable }, \
+
+#define KVM_RISCV_VCPU_AIA_CSR_32BIT_FUNCS \
+{ .base = CSR_SIPH,	  .count = 1, .func = kvm_riscv_vcpu_aia_hstateen_enable }, \
+{ .base = CSR_SIEH,	  .count = 1, .func = kvm_riscv_vcpu_aia_hstateen_enable }, \
 
 int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 1e0d2217ade7..3dfabf51a4d2 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -235,6 +235,40 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_riscv_vcpu_aia_hstateen_enable(struct kvm_vcpu *vcpu,
+				       unsigned int csr_num,
+				       unsigned long *val,
+				       unsigned long new_val,
+				       unsigned long wr_mask)
+{
+	/* If AIA not available then redirect trap */
+	if (!kvm_riscv_aia_available())
+		return KVM_INSN_ILLEGAL_TRAP;
+
+	/* If AIA not initialized then forward to user space */
+	if (!kvm_riscv_aia_initialized(vcpu->kvm))
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_AIA);
+}
+
+int kvm_riscv_vcpu_aia_rmw_isel(struct kvm_vcpu *vcpu,
+				unsigned int csr_num,
+				unsigned long *val,
+				unsigned long new_val,
+				unsigned long wr_mask)
+{
+	/* If AIA not available then redirect trap */
+	if (!kvm_riscv_aia_available())
+		return KVM_INSN_ILLEGAL_TRAP;
+
+	/* If AIA not initialized then forward to user space */
+	if (!kvm_riscv_aia_initialized(vcpu->kvm))
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_AIA_ISEL);
+}
+
 int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
 				 unsigned int csr_num,
 				 unsigned long *val,
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 3bc39572b79d..c46907bfe42f 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -260,6 +260,9 @@ static const struct csr_func csr_funcs[] = {
 	KVM_RISCV_VCPU_AIA_CSR_FUNCS
 	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
 	{ .base = CSR_SEED, .count = 1, .func = seed_csr_rmw },
+#ifdef CONFIG_32BIT
+	KVM_RISCV_VCPU_AIA_CSR_32BIT_FUNCS
+#endif
 };
 
 /**

-- 
2.43.0


