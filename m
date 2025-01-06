Return-Path: <kvm+bounces-34610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2BEA02C22
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C43AC1656B2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C870A1DF25C;
	Mon,  6 Jan 2025 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IEYo6nVS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859A1DF240
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178587; cv=none; b=rfy/vceWOWXclL61BKvb1sZykhLSLVGBlt9QIfVJG5UeZm5n/YYl1MemKamrEVV2vd4IPQgNcSt/gq6GQ+sFyLmMpCMmmNJ84ouNN3rh1mAFl0HKntzfZmiPqCChpgfM3sb5dBcFy5HcmKMMJ2wNUbfCEmCIa7WY67gI7t58HDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178587; c=relaxed/simple;
	bh=V1YlIcuVQQaREOmCPGx43j3enQKqJFZ4VquEsvSJlW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oY6av5lLo6BGvE7+Tkj9cI4ZcQU/E5Eon8wh7T+bhaf0/DMKpMSLwntljt29fHWTDEedJfAa5qBM4BHXt8QYrCEncRZhRlbof1WbytVlFAzB4INxA223ZfmS/jYizMQoIxmSEq17jww6Pf64hW96qVK8IrVsAYbpijIzo94eK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IEYo6nVS; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21636268e43so26720655ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178584; x=1736783384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZted/4cRJuHwsNYAobqssxEi0f1evq9XJsjrZaPJkE=;
        b=IEYo6nVS0g5DPNqbj0KQleNcwXYlrALOpqN6WKgfHTLQaIo0+oB2Z/UsGtCFmxNPob
         88QVc9opNCsOPBbJNZPoe4bSGTNPhyQQ4kIfZO12VFZcngiL8UZt1vhtMZrWPuRVtXiq
         dHdoh1GuLAvrYx+luSgifC7cPTTLHjp9Rq+OdwEbIJ3idabu6DQImr8kFk2384KDimtA
         xpzWiOyEKI/6T3zd2ZQ74YJ4EIjEhBtIV800XyMA0UFKQBcSV+PoRDGDHlm7B9oxdr49
         1pz6bTRaD1pJWlJsRV7RspITcYzNRewlaUQ1ppheLJ0t5pWJC/k9Tm14JITJi+TyUZT1
         3xpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178584; x=1736783384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZted/4cRJuHwsNYAobqssxEi0f1evq9XJsjrZaPJkE=;
        b=jeEQLJSJ+4FFlEbd8cFgYjZVT28vpopkna9Ns/kjucr+R+tsyeD6LCAgNjKBesZepu
         aCqQVhVujAvOTV8+1NnKCl1E4+LvOVwrxgVgtTbAkaST0RO/ROpyDYjy3SN4nnBMK73s
         qub53NRwhVvXRFnRihTNoHwr6QRL8/LCf1pFOVrJwFdF+5+Y+l+crOfP4Fk35lENQCxq
         eE5FOql87Bsqbz0SN+raiQSDBEkj2V65u7AJxt9deUtfSwTAQfuof+83Pcvo02tefJ3N
         Efzz2Ksvrnqfll+ZNjJbajhgNO0kbBgpzflS0aUWuZTbRhiLXtaLBEJad91KO5tpqRvV
         FMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXC6jbS7Ey7RWsnwAu4Z3QDkd8DN5pYPfCrAE4+/6kHh6+fDDr01ljJgcBv5nDrOwr7oS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQDSzClU6d/fdqO8JkDQPURjyMccnimUDga4F8xrutNnvCMw/Y
	4LGDXx+0ysTclj4JJ9RnySBOWQ0R9AGLQ30y4SpF6YP5hP4pO0tdOfBIQeQA2ik=
X-Gm-Gg: ASbGncvxlVMV67sEMPA0bdItJMKDqmAoFv0+nNOQBTpxW4VJSA6ZIfhutW01nKslH57
	bkwg6HB0ePDhxqNK6hAxjzMcSWaitOzHy47t3S7kuHHhhChaDdPf+XKP4t50QEoWR6OcbG9DedC
	sgqC9MC+6j2O7SeyUvGLXNY17KsLTjaMzpdMfmoQFC3OohnX8HD/omSvK9+2dnKoEthg6TZxmAb
	U0cehP1AJUwHiBgYLNtS7Q1EiLtzCPU2Nf5SdYJS/2Z34o1znXlNAkarA==
X-Google-Smtp-Source: AGHT+IEOmk52vJbM/lir6EnXzGo8rHZx0c8SdsX59VoQTeStIErxbb+u7Tg8JzB4+OJAm4+54IkSXg==
X-Received: by 2002:a17:902:e886:b0:216:5e6e:68cb with SMTP id d9443c01a7336-219e6e9fd95mr868563935ad.16.1736178584085;
        Mon, 06 Jan 2025 07:49:44 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:43 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 6/6] RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
Date: Mon,  6 Jan 2025 16:48:43 +0100
Message-ID: <20250106154847.1100344-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
misaligned load/store exceptions. Save and restore it during CPU
load/put.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c          |  3 +++
 arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3420a4a62c94..bb6f788d46f5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -641,6 +641,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
 	vcpu->cpu = -1;
 
@@ -666,6 +667,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
 		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
 		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
+		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
 	} else {
 		csr->vsstatus = csr_read(CSR_VSSTATUS);
 		csr->vsie = csr_read(CSR_VSIE);
@@ -676,6 +678,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		csr->vstval = csr_read(CSR_VSTVAL);
 		csr->hvip = csr_read(CSR_HVIP);
 		csr->vsatp = csr_read(CSR_VSATP);
+		cfg->hedeleg = csr_read(CSR_HEDELEG);
 	}
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 55433e805baa..1e85ff6666af 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -14,6 +14,8 @@
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_sbi_fwft.h>
 
+#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
+
 static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
 	SBI_FWFT_MISALIGNED_EXC_DELEG,
 	SBI_FWFT_LANDING_PAD,
@@ -35,7 +37,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
 	return false;
 }
 
+static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
+{
+	if (!unaligned_ctl_available())
+		return false;
+
+	return true;
+}
+
+static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long value)
+{
+	if (value == 1)
+		csr_set(CSR_HEDELEG, MIS_DELEG);
+	else if (value == 0)
+		csr_clear(CSR_HEDELEG, MIS_DELEG);
+	else
+		return SBI_ERR_INVALID_PARAM;
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long *value)
+{
+	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
+
+	return SBI_SUCCESS;
+}
+
 static const struct kvm_sbi_fwft_feature features[] = {
+	{
+		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
+		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
+		.set = kvm_sbi_fwft_set_misaligned_delegation,
+		.get = kvm_sbi_fwft_get_misaligned_delegation,
+	}
 };
 
 static struct kvm_sbi_fwft_config *
-- 
2.47.1


