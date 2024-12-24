Return-Path: <kvm+bounces-34369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6559FC27A
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 22:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB8037A0F89
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 21:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CED2135A4;
	Tue, 24 Dec 2024 21:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2cXJ4suo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36A5191F6A
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 21:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735074303; cv=none; b=pY3c20OMY6rHaNO7dHKP2kghCaQiN3bpG8e1WjNtUaKSGJRmO38sH7W3OyoxGPd0uh85yZP3NG9oQ06LKq3Jp7jJjid54ZE8RINjWBjEdavH0iiSiJzQyXjC0rX4pp0HmNYhZnec2vJGj54a+kCHyOg+RZpyKbv9gsnQe9W89Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735074303; c=relaxed/simple;
	bh=gObRHf7nO/muFv+WFkNrw+716r/n4euNFqf4Yqsnx7A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tGTa8rDP3VepYv6+0l5QZiD5m+rQLFZYUeYeyqWUwRJXLGZzx8QCuotZysUKrHCmbO2/etwA3vbXck8DA1wP7KM4IuBNRsgVnGp4WzH+wiG8mzNanJZMDczYbGa0JoUjw5HAm8mK9KRoedjIFU2clGh5yb+5wYR25VZOwndY1nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2cXJ4suo; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-216634dd574so40264295ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 13:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1735074301; x=1735679101; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlUmPcZY4TN/RdMqQ8PaLtNf3W/Wbsw1dLdhHB5EEeA=;
        b=2cXJ4suoHepRRVOoXVz+o684aHnCR9Clrq1UaccPnclA9db+2iw4QrJWq58BeiGHNB
         hpaHeL9Kdk+x09i+8SiVKR5cJnTwIo9F4ZGnfKDPOuubxa+rgoXqiAF3TOGy6TLYCM5D
         8FR5RgTT5/o9TkJ0fXFey8g9bI9/yZuN1j3y/J2n/9o53Unca+tX1e4ngpmnSe249SrY
         TiM50EZe6C/fHePLl6TTTHpPSNIHkzWdfLZgziVNDVUVkOobvYG7ll7H4ACaJlNp/bIY
         A1czJDvP21+QYfrM4uZm0RHkgAsFqWzDXqVh439uDHmA9MMqWtyjGt0CmpurIOT+cNjl
         2pzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735074301; x=1735679101;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JlUmPcZY4TN/RdMqQ8PaLtNf3W/Wbsw1dLdhHB5EEeA=;
        b=Ed0K+uBIdTVskzGjOaH1XuZ9DxgN0cfiaz+qsyHZFJ2Zo4m3SbgMkkBHAdv0ZQgs1M
         dvJ8OKr5VaRbsagiqHg5xOVvjtRp3joMdEF0Jiiy0D5CsCTg3/s2+JJgt9Z+IQTokDtb
         dIPVuT3DL1Jg2ES2UpFT8YkA5dnqsEn2geQoDTj7mcLcImVT7gDcl7sGb27ClYCSCKMr
         ONRSnFTChBNXEukssoPdzXfJHGICnx97w75seDeZ3uUHwYlcGAq2RbKXcA6GoqO+OkNg
         w91lsRJMPmSB+GXB6O4WUE4iKBwSKJPfYTx8eQnMXS6ayknEIIjQKAN3/6geujN3ueT+
         vvlQ==
X-Gm-Message-State: AOJu0Yzsx939+EDuP5Yc5WlEg/iln1tMCSJfKjDoAq5AtoUaejgrI5CS
	yFTttl5fZJPt49HcKnGCfDFVqQl+ZKyVQoqsZbCATDXKgHL+SerZAxZGVndNucU=
X-Gm-Gg: ASbGncuba9IkZReyi8dje9+FH8aRoXVgFE4mIUhkLf8Sg0wLQtUNaBjzNELpjR8xe11
	Tg6Pe9Fy6bBNlBjZu+UKWnbM8ausrOuc1F6eVwtjOIsDT97BSlGviuFYP3RVBJ86pqylxvlskHF
	FPkUSyGUjinE/qJKWds/W2AKg3lyaAs2kBfgGCE7cbWr9opaPkBpQSmkFOVDY9/seroxccP6+qy
	pV2D6txahScUS5x9c4zWflDGW4q53pGxl+0F6xawG13MKcq3E67qydRsgUCyjGj8qKOQg==
X-Google-Smtp-Source: AGHT+IFkAvBUy0y2QznmiDw5xGryBuSrbox2rOO+r9dXtaG1Z1Twj1tRDQZutMEwjnEXldms1wIZJA==
X-Received: by 2002:a05:6a20:a121:b0:1db:ebf4:2cb8 with SMTP id adf61e73a8af0-1e5e081c839mr30524444637.38.1735074301156;
        Tue, 24 Dec 2024 13:05:01 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c344sm10445925b3a.186.2024.12.24.13.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:05:00 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 24 Dec 2024 13:04:55 -0800
Subject: [PATCH v2 3/3] RISC-V: KVM: Add new exit statstics for redirected
 traps
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241224-kvm_guest_stat-v2-3-08a77ac36b02@rivosinc.com>
References: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
In-Reply-To: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Currently, kvm doesn't delegate the few traps such as misaligned
load/store, illegal instruction and load/store access faults because it
is not expected to occur in the guest very frequently. Thus, kvm gets a
chance to act upon it or collect statistics about it before redirecting
the traps to the guest.

Collect both guest and host visible statistics during the traps.
Enable them so that both guest and host can collect the stats about
them if required.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h | 5 +++++
 arch/riscv/kvm/vcpu.c             | 7 ++++++-
 arch/riscv/kvm/vcpu_exit.c        | 5 +++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 35eab6e0f4ae..cc33e35cd628 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -87,6 +87,11 @@ struct kvm_vcpu_stat {
 	u64 csr_exit_kernel;
 	u64 signal_exits;
 	u64 exits;
+	u64 instr_illegal_exits;
+	u64 load_misaligned_exits;
+	u64 store_misaligned_exits;
+	u64 load_access_exits;
+	u64 store_access_exits;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e048dcc6e65e..60d684c76c58 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -34,7 +34,12 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, csr_exit_user),
 	STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
-	STATS_DESC_COUNTER(VCPU, exits)
+	STATS_DESC_COUNTER(VCPU, exits),
+	STATS_DESC_COUNTER(VCPU, instr_illegal_exits),
+	STATS_DESC_COUNTER(VCPU, load_misaligned_exits),
+	STATS_DESC_COUNTER(VCPU, store_misaligned_exits),
+	STATS_DESC_COUNTER(VCPU, load_access_exits),
+	STATS_DESC_COUNTER(VCPU, store_access_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index acdcd619797e..6e0c18412795 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -195,22 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (trap->scause) {
 	case EXC_INST_ILLEGAL:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN);
+		vcpu->stat.instr_illegal_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LOAD);
+		vcpu->stat.load_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_STORE);
+		vcpu->stat.store_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
+		vcpu->stat.load_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE);
+		vcpu->stat.store_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_INST_ACCESS:

-- 
2.34.1


