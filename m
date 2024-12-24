Return-Path: <kvm+bounces-34367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 756E69FC276
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 22:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A05D1162855
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 21:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D34213221;
	Tue, 24 Dec 2024 21:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tYv8Kdju"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48B18E373
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735074302; cv=none; b=YuTt68aJLZZhufDqh+9TY4jvY4to5sepEQbK51yfuqbTdwt1SBkCE3g/dc4v+uk2qQJO3SCrLgaW1xTDeIUxVqCaRngbCxvFCS2088IQHkpQC4glAJeq/Aq7fHG2ySZ9KF/XGFuUS6/cP7yjaOpUdQmt6Q2WwoHZ+oNulF4T4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735074302; c=relaxed/simple;
	bh=WU2PoBjHti3mLNEWEzbZTbMwK9e9FEOuAWEzakWaEUw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bQXgzgdLFe2t2OqGj4ARqh4vkQ0n2zA/Z/3vhqDEccMDo34odaeJtV9Rep43xjp51lXRxBNzH2WUh5PogLyRNvGZ4OkUxVuzVJpMq+RxYg1b0t5CJarwMUAKUUHQQSfnxgV6KPTU2CQQHb/lCkzVuosZFApl97uLD+H0gN8Ov3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tYv8Kdju; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216401de828so55240125ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 13:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1735074300; x=1735679100; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wyrUQMinm9VfIkz//Zqi5azyB73CtB0XBmp3HQwwuxA=;
        b=tYv8Kdjulq8Ma/sQYLJcAfSeK/NMisT4/Z3r8lt/8xlPQonlqpK7//khyOg+jMFiJW
         0kI7xqwJTBrGYFx51lwchfc9EWc/QU2W7MD188S+Xgdv9kRatT6X1FWMTxv8HqAVR5ex
         IAEUmdKbDiNeIp662A1zEJ9vmDlU7BqwSIyjHMXYUquus1JaFG+qUxF9mFPlMYUhsOO+
         zVlXXPa8Mh3XJP1ShOvrUP7UV/KSEDS8sYZeS5pWltLr0SHV5EPVEdVLl83wXBlPqsMX
         nOSTZL/P7H3q83iqJJyC8bhdsKGfopnEOeTDR1BuRf+tVMZ4HJ4PYxlTugT+tpiwfDoH
         9VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735074300; x=1735679100;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyrUQMinm9VfIkz//Zqi5azyB73CtB0XBmp3HQwwuxA=;
        b=tTAcwBaQX9ROJBxQdFk8aN9b+YfaRQhM7qdNiucB8PGUJzRF5ttQFv+sjIeBtZkMQD
         li4c4+Ywxn1OTcrhupHMz4KqOwg0BqBhUfjZc/YIj4rofAtYIALwVKoI47PyUeCIY4Ft
         MIcw0dvW5RJss/o2eHltTC10hYxpcxKi0icJKbIHZBkl07ovcGA8ENdazDCEQwxVvrXQ
         wdsE5DxH9MXO0daz8rJ5EHm/J+XUA6Ael1CJivIFQwpaH38rhTNRuGMSVvZGMnDoqKa6
         1lfTtfjugw38GiLzNfnmods8eu7OlPEolVy0PdlyyVC64DnNSQp1wBb8aZ/bBKabpGwc
         TdDg==
X-Gm-Message-State: AOJu0Ywbj46QJrxs4NgzqrTR22JdgSMkGvyJWdaFPXYxMjqCJXyhwg6e
	Ohfc/nHtWDBm2ipKk2D0Ic0K/FstImy0TEwAA2Kq0g9HNZ2jc5VIfJdwV1BSRwE=
X-Gm-Gg: ASbGncsGaYg0Z7B4maR5seigyOMxuRowe4pw0LinB/3IWsN2VZQfgk9wosn+jLr4y+F
	GKVlVFIc7NLll+D4m6eWdjOvCXd4DaZj5lQRvFw2EOVz6xu9HXdIUOFdPzWz+gGYvjpmxflRWKK
	SaQd0X03Pb2evXeLmPKg4InRabe3zKOBc/Cd4bMe2L17EQtPUCaME8EBLYXmaXS18X5OeXEoMTF
	aKv3nL/3PvJqbvAP2TfQ5ADQbiVJR+hG0CdEVuLQGxDXCiC/HtzTGQliEfHiTbRejmMGg==
X-Google-Smtp-Source: AGHT+IFDnCQ0fa4NqS6VnWu4yH1L9kNVbzZkBTsq+P+df9RDRyuUZJOIb8A9T8ylvjy7lFyFnN1bzg==
X-Received: by 2002:a05:6a21:7e8a:b0:1e1:ae9a:6316 with SMTP id adf61e73a8af0-1e606dfe621mr13695856637.35.1735074300205;
        Tue, 24 Dec 2024 13:05:00 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c344sm10445925b3a.186.2024.12.24.13.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:04:59 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 24 Dec 2024 13:04:54 -0800
Subject: [PATCH v2 2/3] RISC-V: KVM: Update firmware counters for various
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241224-kvm_guest_stat-v2-2-08a77ac36b02@rivosinc.com>
References: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
In-Reply-To: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

SBI PMU specification defines few firmware counters which can be
used by the guests to collect the statstics about various traps
occurred in the host.

Update these counters whenever a corresponding trap is taken

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_exit.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index c9f8b2094554..acdcd619797e 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -165,6 +165,17 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 	vcpu->arch.guest_context.sstatus |= SR_SPP;
 }
 
+static inline int vcpu_redirect(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap)
+{
+	int ret = -EFAULT;
+
+	if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
+		kvm_riscv_vcpu_trap_redirect(vcpu, trap);
+		ret = 1;
+	}
+	return ret;
+}
+
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -183,15 +194,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
 	case EXC_INST_ILLEGAL:
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN);
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	case EXC_LOAD_MISALIGNED:
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LOAD);
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	case EXC_STORE_MISALIGNED:
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_STORE);
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	case EXC_LOAD_ACCESS:
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	case EXC_STORE_ACCESS:
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE);
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	case EXC_INST_ACCESS:
-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
-			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
-			ret = 1;
-		}
+		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_VIRTUAL_INST_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)

-- 
2.34.1


