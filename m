Return-Path: <kvm+bounces-47412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA70AAC1591
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62C925037F1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F9223E340;
	Thu, 22 May 2025 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SESnrkhQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960F23AE95
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946143; cv=none; b=MfHdM6njSsoqNjSre8Sxc8bbJiWTYJjWPB+EpKO8ghBUya/Yj+zAKsujddEjc3OAv5JMuM4a60ZZiO7ykulF058+Ae8yIzZjwdMwmYKvTtYquNGiJIlgGuvfTh+lW0ksDvGvEVF4LEtgFfdt+YktrRoGd2NJO/lRoeVsJ5b3mHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946143; c=relaxed/simple;
	bh=LSgyb36sQWDSbDvQ0g/qxWY7gx9lY/2NHbvCnZ4+FcI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gbWhsjTI4f9f86YOUfN6Ug6d8h5x0V4MCLMl7c7CwzibDJgZ57K6EC9LiXOl9r2IpDZ9gEoaY//lsTZTOoCKdMtTzTOF3OoDwWjC0w6ULHfHi7yqe1NzSYl1H5c0V+QwPtZaZJlzNvlbyAT2bdgmyuzHERD/JwvNWgIATZfY69M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SESnrkhQ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso9243412a12.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946140; x=1748550940; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6M4N3dwNsXzDfzq+X21m8iWPwOjiKI12kvM05IYIXOY=;
        b=SESnrkhQFLZRX17/PMBjNsriuLPsMA/QFOUqQQqYxJAcwJNPVUnbqfjovzDjjrmrh3
         x6ihPD7YkPQKmtBewV+5q6y82oyB/g2Fo9rSR2jzI8hJeKiqFZAZvnRMFSIp4pYeE37x
         4NRH0TVlUBeV7KjnmmjrwwOgw2+5hUXMtmDtkeC1i/y7j+AXYzcwptucFl36nxEHN6J5
         4KkQ7ara1sopZvbX60bZVW+dJpLPconJR+mgyU5oveLG9h35boGkaZhM8FCKbt856OOH
         rhSzq4MhmGt2ValeJvDcptasGoLf8OVjcoGtysRBkoqrDXhZDBZJJBrWLSZPwGdICXiA
         g6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946140; x=1748550940;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6M4N3dwNsXzDfzq+X21m8iWPwOjiKI12kvM05IYIXOY=;
        b=BQIevldpZp0dLzRcUlUXAci7j0ODEa3h29D4uEjxlMzfIIvdFfujtGb8KMnWDUl75x
         FepwVmW3EScBdMQBCs/wZPOVjbTytvWWLU2anDuoJLudqxp7bR1yo/4MDLg63vy3kmm6
         ApdDYfQxSfqtMxRPvKh4jXkyMwHxhSIWg2A0xborswD7u/byhoNTFblhdiuopx5qWDFc
         vAHcerUUYDYJiCyxc0o/mXZrXfbtX8xVMMBtkHSzGbgtmxtwIxk6ekceoujQI/9baN1r
         DG4GvmaNuNgTnPat1CvtzcFwYn3tlZeh4zh9U3/0pT7rr7BYEtpO3XbGuwwmOetOTdvO
         8lZA==
X-Gm-Message-State: AOJu0YzXib/lrGfPfgi4urnQCDspfqifXYBPNSRd0Z2uJ8mHvDHYoMKr
	GIRmmMTZ4PExwVMk6vCAmnZ/qFFyZ6RyovrCh25PtCsPp1Uh+fdImSdkNxT7pfOWZis=
X-Gm-Gg: ASbGncucH97K424XPzg4yvCMQXqHJIsAzgLLNATXSQt7ZzDClz/N0ZJdkZjUd9YPHF2
	UeC8M0uq3X8vfN7FxJPeRmfcQhi9rmFkZJpQ1K4dVFxwoVbbYyt9aHtWX5RgUtiB8Fdhf73m7Jc
	KYDDzIPvZrMMN4fL9UJpvuoz26VINLh5SgG5qLTa1FcCxEZCF+yQabdAlHSDnAA16RcVMH68Orh
	SvtAGEq6013X6aqjjvDtmIQYDW3BcIYECXVcrueyVCY4kjJJyBKtto+Cl1W53mtOMFOGAOnLNtV
	Fc1UAe6vBPSGzSGl1QaPbfWxd8dP6Q0tBxO5/atnx8mMqH8ku7HepPz4Ik9ehvTY
X-Google-Smtp-Source: AGHT+IEPv0Jsk9/CNfphfSQDZY9W54shdTdCOSDBaPAfZ6W//0FD3oLt9iY0h2MagdZeDpunR5yq+Q==
X-Received: by 2002:a17:902:e54e:b0:22e:4b74:5f67 with SMTP id d9443c01a7336-231de376f05mr364633155ad.31.1747946140619;
        Thu, 22 May 2025 13:35:40 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:40 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 13:35:28 -0700
Subject: [PATCH v2 4/5] RISC-V: KVM: Enable envcfg and sstateen bits lazily
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-4-b7a84991f1c4@rivosinc.com>
References: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
In-Reply-To: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

SENVCFG and SSTATEEN CSRs are controlled by HSENVCFG(62) and
SSTATEEN0(63) bits in hstateen. Enable them lazily at runtime
instead of bootime.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_insn.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index ef4fcb641f1c..6f2bba7533cf 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -265,9 +265,37 @@ int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm_vcpu *vcpu, unsigned int csr_
 	return KVM_INSN_CONTINUE_SAME_SEPC;
 }
 
+static int kvm_riscv_vcpu_hstateen_enable_senvcfg(struct kvm_vcpu *vcpu,
+						  unsigned int csr_num,
+						  unsigned long *val,
+						  unsigned long new_val,
+						  unsigned long wr_mask)
+{
+	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_HSENVCFG);
+}
+
+static int kvm_riscv_vcpu_hstateen_enable_stateen(struct kvm_vcpu *vcpu,
+						  unsigned int csr_num,
+						  unsigned long *val,
+						  unsigned long new_val,
+						  unsigned long wr_mask)
+{
+	const unsigned long *isa = vcpu->arch.isa;
+
+	if (riscv_isa_extension_available(isa, SMSTATEEN))
+		return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_SSTATEEN0);
+	else
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+}
+
+#define KVM_RISCV_VCPU_STATEEN_CSR_FUNCS \
+{ .base = CSR_SENVCFG,    .count = 1, .func = kvm_riscv_vcpu_hstateen_enable_senvcfg }, \
+{ .base = CSR_SSTATEEN0,  .count = 1, .func = kvm_riscv_vcpu_hstateen_enable_stateen },\
+
 static const struct csr_func csr_funcs[] = {
 	KVM_RISCV_VCPU_AIA_CSR_FUNCS
 	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
+	KVM_RISCV_VCPU_STATEEN_CSR_FUNCS
 	{ .base = CSR_SEED, .count = 1, .func = seed_csr_rmw },
 #ifdef CONFIG_32BIT
 	KVM_RISCV_VCPU_AIA_CSR_32BIT_FUNCS

-- 
2.43.0


