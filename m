Return-Path: <kvm+bounces-47411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76521AC1590
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3365AA21CB0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F9023C50D;
	Thu, 22 May 2025 20:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fYdRAPVX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BC9239E76
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946142; cv=none; b=PH1swFlWUAcyNLP7I0b1VD+nbKsE8SVZ7xFx0vvuOlrSm9S3nMcJU+yX2dCC6WakxmwkUeV55McTu0arSTi7bSErSrsvzNj2fGnkxGjt87is9yR8OPNLOM6a3v8zwBI7EHXfXCuY6suERxbSxnNkmDmnJdFzUmSTOxBgED827CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946142; c=relaxed/simple;
	bh=7mDtsgyySwkRziza7x9PbAf9WF1pkgbuZLDuvpNfiiM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nrWtM3EG39SHMfky1ca0cTrZSxG56DH6zxk6s32TV5mFJEEKTQxKBESVrX02yLb1oM92VwHJ/sX20XpMXK4Nj4heN9Cau/Pei5rqs0m4qAx4BDR01ariOuy7aWr2ECNqUOKBRad4Ic4Mu1yd5SBWGF6N1/u4hojP21dmfrQX0MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fYdRAPVX; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-30ea8b7c5c2so5453642a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946140; x=1748550940; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlpsjtQ1jfPZ6A9TfjhS6qtbiSt0LuxjR82iYs+98kk=;
        b=fYdRAPVX4NHf9fuQDtQ1lV0uf4Iuz0nTnL1SZLLWFoH3MvH3ue8MH+KFuhlM7ZzwIV
         GJBHmHKRNDZ2meruxyVseZdDHV97In4+TX/ZSe9MJWSTme3lu9UYtCuG8+X78P81V5I3
         EIO3Sps+CQQ6HlSIFKOOLkpJeSne4Q0P391SOhmtRupY1yBPtu3FGCy9yggatBEM+TfW
         0VAKEyCPYWqk74l78vBVwmjXyXb3Y50YuVSIJdLl4+YVOHPOqrSET6AklZ89aAWh8n/9
         o/LkrxEPNlnq5yKea3ko4pxP/MBfW6ZBybPjV03b2+G7RzZV3opM+gJWwW66ScNg4kmV
         X4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946140; x=1748550940;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hlpsjtQ1jfPZ6A9TfjhS6qtbiSt0LuxjR82iYs+98kk=;
        b=fGoRPzcdWFIrbRE5S3pMHenK7sQwDwor11XkdU3R931ZbMczs+kIEe+LrIJ9uFCiNS
         J9cAO2MecDI0u63gVC3NpIpGe/PJUkrDiA3N/S0eJ0q9h44yRtuqebgD773AEFww3BrI
         hf7WwUyekda2bK9Pzk8E0jUmLaaqbic9ea5Ew8RsIBDxHRZHIOtdyEP2VXTGxG8p3D7T
         DfzK7NMtJ4YNlrZr3ZgSqlxx1+C88HfyFm7NqbcOVOYMdO3IykP+J/HjJZba3MgOJgyt
         mevBEvA+WaejXqToAPOclZJEiQ626pdgJDBkrHGgw59UWp0+CLioqgG6F9cjpScMkGSm
         8CRg==
X-Gm-Message-State: AOJu0YysoeXU0rfDwqrITof0bwTJ42T+731/nF71g1RtNVhDIkY55pEX
	FiGE4u4ZlhKxtUpQ3Mb2XMepON47y+6LZzIDq+rGsqy+OaQJJbau7gd1A33xHBmURuw=
X-Gm-Gg: ASbGncv5KBlbG+OLWzlP55ypWkqewPw/vkyvR80MPBu3F2nLB1Mt7JRnuIMHVBRuk15
	1f6iXDnMMaILgk+BrG+TcdKFN/hSFfFF64kesYTlxJJ8lMOVJJk+OnbzsVrXeNgxkSXx4zbxHU5
	6WnDTaoLCJ03dzwC8KcRY70uykcOtE/iYWoqw9i9b6Ka31K1GPX8KmvvTycqDvFckL7jgTGXKvn
	1c2iViTvV2L8s10Vx1/IM96NYF4/mzs22uXfiE0lzbZZS0FSU0PeMWc8uhFBerrr5gfASMbtnzc
	e4VdYLWIPKZ8nYdvmKd0xQLFBlyQe/neJYZOxow+nH8F4DdznrMTB2GAD+pPQlgy
X-Google-Smtp-Source: AGHT+IGCOYKh0vp5GpK/3nS4xafj8YOx8BCMj+SatngsU14XSWFqRaCBH400PBoR5UfD0rXZqAojdA==
X-Received: by 2002:a17:90a:e706:b0:30e:5c7f:5d26 with SMTP id 98e67ed59e1d1-30e7d5aca67mr42085164a91.24.1747946139700;
        Thu, 22 May 2025 13:35:39 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:39 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 13:35:27 -0700
Subject: [PATCH v2 3/5] RISC-V: KVM: Support lazy enabling of siselect and
 aia bits
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-3-b7a84991f1c4@rivosinc.com>
References: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
In-Reply-To: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
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
index 0a7e229cfd34..ef4fcb641f1c 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -269,6 +269,9 @@ static const struct csr_func csr_funcs[] = {
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


