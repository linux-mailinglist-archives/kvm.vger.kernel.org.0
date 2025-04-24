Return-Path: <kvm+bounces-44216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C63A9B579
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B0839A550E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19F8290BB9;
	Thu, 24 Apr 2025 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vEeoYmpk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403228E601
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516144; cv=none; b=UDq1EpwIUeRTEK34F94m6kWposCETOVCwy0hypiRO99Z89NL/aA4k3NWTbQcIAkna8V/HhBwo7krlAEm8WxD/kFKEtZHXHu1qjNOG9G0DMX6UMy2qE8fbdbhdaVq8CZN0S7qpWujfJaMXM+P4vfYXvC1iDv77tqts3F/4V2BDtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516144; c=relaxed/simple;
	bh=FDpWismWIQ/RNrzoV9koqJ7IGLL3azpnw2PSMJkenmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvMGvOA1iBmlpoZgyH81pIN56lklRMS2OgAcejkCh1K9yHv4R/lspH8ya8DGM+/Gmw5k3GOVD5ZDC59yuizpbhvKmsh/hT8IIQ5gPSgS+U45piPCKb7NqBvQzx36W1RYFHAMBnXtS6+1irdWYn3hJV47xJCMY7LV8eH0OqR+LsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vEeoYmpk; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22da3b26532so13605425ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516143; x=1746120943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXzCvVqwD1xQeGWZCz1UsZh6myMoBDUQY0JAsLX+Wro=;
        b=vEeoYmpk7lI/woi+wsbxwFNIBK3WE/c6Mp4RL0kxvA+j0tjrQKC6mTF7fP2jQWrl4k
         YhHx4LEP81Wva60VgsTEXvLGMH1EVJjPB0micbyBiEh5LHyuv2JI8/0VSmeGENpoDj8/
         ioTg35vIN7xUzW7OqdX9/taSQXoSoq5gycTSNI8mXXA4aMJmFRmCL0IimPQnO+Wt/9wR
         Dy6fTfwM2l/6eRgN5eTqCaQwQ12MddAvn8QG9pyht7lZwi6v93LfaGvy22khf74T8GNu
         43K4cb2KNHSA/X+sG1M5nKyCMoAaXPCnoeulypB++h7lAB0nF7ct6NbMvLGmGyMeARYv
         H6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516143; x=1746120943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXzCvVqwD1xQeGWZCz1UsZh6myMoBDUQY0JAsLX+Wro=;
        b=gXr0FWuScDBFnykICoSsjVj8tSPVNN0NgC910OwR+3zsj66R6p5nZqwxmfsRf5jQ8w
         r65Gm3/QqEUytG3GWpFEkKx8fOE8ZJt6w+kY4+283wyqs37itnt3cpieNAoz4BKipMuD
         +J2gptRH5zT+moKffmeGBpIfRNbI0rchRNDmSmob33Xc3yGBf8hBP7FutcxF5RqmEddF
         vFLCkwazG4qJANnnPgucpfENmZpuOvCAlDExbvcXV07fCkxTUbId+4fE6neg9ZrHQ/Zm
         0egRxp4azL199ArP62iyk1NwfUeYJHSBnnxxU0Ppdfwi3XTMkI2fTr2X653H8n7t5DQY
         ysOA==
X-Forwarded-Encrypted: i=1; AJvYcCUBrCHNi4rfiX+al0NeEB83N8gHaD0814Rq4YekQdzz5NPNhQS9BTWiRxIguUglGJkTKlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIusYUDIiLivD/5IrGaWgmht2SNHz65jg1I2aFByls4AtAzu+M
	+HTOy3qIS9JeOoocyzgLleSkkWKiectnuqOBPHR9xh4iPFXrijC4wNIHgNrFUo0=
X-Gm-Gg: ASbGncv+WLAdihadTtm903iAINdKBiDUO3h/T6TGK3H85J6NdVyRQeKp5gStCM93Nzn
	DGNbEzme5jd6oe87ztREanDRr+W2jRWbSOJ44RyyPRkLQikif3RZymmwzHb5hBOZgMO40cta2mU
	oJdpA7NYQl9iXNfs0ZRIwGz4hKHLm52kzT7QBZwZ/5wADhY8I2Ddt8HzPtpTAAajU7jDC1ZlShM
	9wDesodbDuNkFXnXovu3q6uUQ7/ejr69X7/LpgJIx2mbi0eDjhS3xR6kbd92Rz1eBwgwMIw6m0G
	/loCBONmndUEoLD2HnIpHqklSUfpNFYdFaRvys9WAQ==
X-Google-Smtp-Source: AGHT+IFqCoNXysJ8Uz6w7sA2JzHDg11kuHB44+WTgIOUFofZxJnqgRWWiibGSTc2Np3Gu4COYQqeSg==
X-Received: by 2002:a17:902:f683:b0:220:ce37:e31f with SMTP id d9443c01a7336-22db3bdb6bemr46068695ad.17.1745516142601;
        Thu, 24 Apr 2025 10:35:42 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:35:41 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v6 14/14] RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
Date: Thu, 24 Apr 2025 19:32:01 +0200
Message-ID: <20250424173204.1948385-15-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
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
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c          |  3 +++
 arch/riscv/kvm/vcpu_sbi_fwft.c | 36 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 542747e2c7f5..d98e379945c3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -646,6 +646,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	void *nsh;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
 	vcpu->cpu = -1;
 
@@ -671,6 +672,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
 		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
 		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
+		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
 	} else {
 		csr->vsstatus = csr_read(CSR_VSSTATUS);
 		csr->vsie = csr_read(CSR_VSIE);
@@ -681,6 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		csr->vstval = csr_read(CSR_VSTVAL);
 		csr->hvip = csr_read(CSR_HVIP);
 		csr->vsatp = csr_read(CSR_VSATP);
+		cfg->hedeleg = csr_read(CSR_HEDELEG);
 	}
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index b0f66c7bf010..d16ee477042f 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -14,6 +14,8 @@
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_sbi_fwft.h>
 
+#define MIS_DELEG (BIT_ULL(EXC_LOAD_MISALIGNED) | BIT_ULL(EXC_STORE_MISALIGNED))
+
 struct kvm_sbi_fwft_feature {
 	/**
 	 * @id: Feature ID
@@ -68,7 +70,41 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
 	return false;
 }
 
+static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
+{
+	return misaligned_traps_can_delegate();
+}
+
+static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
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
+static long kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long *value)
+{
+	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) == MIS_DELEG;
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
+	},
 };
 
 static struct kvm_sbi_fwft_config *
-- 
2.49.0


