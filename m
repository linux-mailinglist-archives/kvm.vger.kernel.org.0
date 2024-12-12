Return-Path: <kvm+bounces-33664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB739EFDB7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7B0D188D6B4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397FA1D6182;
	Thu, 12 Dec 2024 20:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="d+Q8SSrs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0401B1D61
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037022; cv=none; b=pjRgei6jgC5uNVJD17ZF6roerR+07qEAyEIjM+BfoX6VEqFOw+PmjowGugWRuljJ237tgQDPo4EaGKuYthhgNv9qQMFfRQulJjQgPbthiI1HFeY7GNWlSMuHExj7yN5hfmLP/JrcvdXTb22glPceP7c0ut6VkvkrotV+LUAZocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037022; c=relaxed/simple;
	bh=aB7frMBfUTuHgeG2iqJQRR7h5YH7OQziiHAZLJcCY3M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ulGm3E7rLSKaIP4uM5qtEW1gpzrmOaKxexGeOVD00gX3/+LQ2QFfPiuP1iaJkbdqLnKoo1T4QRIUzrzU7+MMzro7iq+MtxKDyLTZ3pXysnRZD7GIe6Flb9rDQqiE0G87m9NGDtTCZ11K0+l9lf7E2JCyyTWgajsb7bM+j7N42b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=d+Q8SSrs; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2163b0c09afso10114745ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 12:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1734037020; x=1734641820; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PaPMD+BdCyI5hLi3/kV/S6HLELSeYS1h2xBFfdAEcTQ=;
        b=d+Q8SSrsINXoShh+rKMAzeMdQY1OXx2224FD6ttzuoN81TfnIiUkbd2SalstFDhMrg
         vhVMAosz+DXP4dFkEXQqq2zJyhEseFgAoqS/fKP2aJKwwKsjIq5PEdLs5yuDw9Ru63S8
         AQvkPfUbnfpXSCO0dyevNW74nHrWYWKQ2e0pfGKJMem0zLd+ip8pOk+Ay+wzjqi9fmyr
         CsGaSxK3S0IT5P200d7+8oYCKY7nxYVUzFq4OCAWAYp8pOkZPSbXbgSYx4XsGi6/GMn7
         LUbeMntVtq3le9xl6/4f2QmZ+4DzxK8Ia06XC5gg66vptQbmGgVBrPvTplTBAAO9zTik
         tNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734037020; x=1734641820;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PaPMD+BdCyI5hLi3/kV/S6HLELSeYS1h2xBFfdAEcTQ=;
        b=Vc0g0kP0M7HyVj+UGDiOIGaEn20J7+HcnSvSpk+VrLWg/cYQbZLYSPT1bzH91YCK5U
         nJtntUxDpZC37qEOjYP2ZVF+Js4Aa9twRWiPHBHJf6vNYfaFvgvAKUm9DfmkpN6wpiX1
         YUuASQXO8J0cAwld4hBmzA5QS72iU8/aY0z2Wv56DDyYVTjLHKxfcXPpuI6zxy3nanrK
         4A31+crQowM0pflUQ7ErJ5bImCc9norrZfVmZwTjBmgSTRLZ1kIJEvCuln/s4sbDvPVC
         BpEtI4jv5T1ixET4lXIqSsqTdzAEVkb0wrsQ3JskRvfr67YWtMlUek9ZDC1jK5mT9XaC
         dhpQ==
X-Gm-Message-State: AOJu0YzEzn33S+79ZxWRo4A3fP2bHzBUZxRXRD38sYRjcHYB0GSlpf/C
	wikA0MpBFY4uoemTTO+vf8rmyoPs6XjdGOH2mZwSn+X/mCb0645WMvvDGaaGjKKNARMrAVqxlJK
	E
X-Gm-Gg: ASbGncsJVcI+h5BNLhDtXwXrSVpXFycDxZm+wWWZT89wzBZDtW0bBFJFhcuhD/uaDBK
	iUmYBVA6LRpzKVRNTkdS5lIboFXA5HScMGV1HU1eaHtatSm1hxOdAr6R3nhVZ0jiu5mXJ6kj2nq
	Xuu9kosG1nnf1MZDNaem0K3YRit2p7059bU5h2yreg9zLZjQxoIZcsNpwArGL6cyvSmfq61Vz5L
	Z2ZAwpRpRhtE6BnqE889LJc4tqw3nMpx8S9eRD2yjRcXzhoPf++4bFHo5ANYHgAIB5Mbg==
X-Google-Smtp-Source: AGHT+IGLXA772pUTt0BVGAPXfaZJ5WaJQ7JivmCyvoMmFNjKdV2TZP6t/5GpHJeWN5LeMnNdr4yhBA==
X-Received: by 2002:a17:902:f908:b0:216:69ca:7714 with SMTP id d9443c01a7336-21892980b8dmr2076045ad.11.1734037020131;
        Thu, 12 Dec 2024 12:57:00 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2162e53798asm94019785ad.60.2024.12.12.12.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 12:56:59 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 12 Dec 2024 12:56:55 -0800
Subject: [PATCH 2/3] RISC-V: KVM: Update firmware counters for various
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241212-kvm_guest_stat-v1-2-d1a6d0c862d5@rivosinc.com>
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
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


