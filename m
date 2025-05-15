Return-Path: <kvm+bounces-46668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2517AB809A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B9E11BA8304
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4AF298C27;
	Thu, 15 May 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="P6rSOHf4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482F298275
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297444; cv=none; b=aypwqlgyh/68MuVe7Uu2FGQplEOOEDwlQ2YAScePB6zNKYdB30ghjw/pvA/zdDX0CNYeKB67/ckwmOvCKybZO7xA7NlArWcQ704Z5kNySJUzVuMl6YZkp8WM8SC/PgNchXNJLqT+y3bI8yQJytTLNcTqS94HhylQzt7QlBYWWfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297444; c=relaxed/simple;
	bh=wG4jSd8CN6FwtzgDKxT0M5vr7EjYV2+jFHLq7+TPn04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YdKDoLORurrJLRKtmE816mRnA61mVRUWRvFgASH1ou+hQzrS8T9G9uPGPtvqJQU4d8qifdrASbq2V/X0AdjOFpz1xdr/EFFUTZkQ0q/TOELlzhyIITcEgEBPmb4Q2WobyQal/+/4eglxhskin5NpTAfNRhv/6Nw+MDxSaxAA9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=P6rSOHf4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-442ea341570so3957405e9.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297441; x=1747902241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2HRRvwQZR7OY0o40CF4iX42SSRrEHUJjKFBagu/MDOQ=;
        b=P6rSOHf4XFz3hFZ++OLZYVX/IcEe7laXu7/0HmAw5KPJ+fSSEm0nGzYbwvdRFV7nBP
         /UtBknM5XK1darwGv1FKqmIy5tdFQGR7UXv01+95Mgmyw1aMQ8c3kLZHYioKg7ameXwV
         EtRWaXN2dwtx+qJd8OGkVSFyYQ1iHbuGMXE3GDHIOv38BWqrxc8BSS2WTodYs+cPnLZX
         CrD97dg4yiZ5qfxDfW0T8PaLP0cxOAUgRfFaQ53JisImOIs9M8XNgZZJ3nrSCDwj7QO0
         koP5V2EoDO4Me2sWADdLRZYYfV4bKTXvlMS0svFHr+CbBk3tM36mTcrdSy5Dx1WtC8Fl
         /01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297441; x=1747902241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2HRRvwQZR7OY0o40CF4iX42SSRrEHUJjKFBagu/MDOQ=;
        b=g9sHxa8N5Ym169gBIAQX7F0+cdTTmsjlGo4jegfolXMEGR7HXDhyjEOCIe+3Mmmw2o
         N/KYD96/K43CtMxlLyb9xUctvSK5LqbU9JSXT0h/Kt10dtGesmW6tN1njIzd3WyT5EKv
         7XWddFDn9lapd+EqXo8r5B0txdgWvyUhcepVRsAf65nISfy/pPJdEoWLnUcTxk+G3rD8
         59oL7JhakiOi/zcXMgykaKN3aKN7cWSLXU90k533x5EYlcLIuCoa9b1Pg7a5SmrYp6qp
         dNoy5picjVzgjp4B0aY+cNu4TR+2YPo3qp3hyGA20g7oIeqC+KdiVvY5pmvWZk6VNjPX
         HUjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQYj0OyUd8CgQJyGjIK35l19tdua9wJoaD7trRSa4bIm7OpE6FtQYORlMNl4+DQOwJvVg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt0MPwZNXtEwijmWC6aCYEGXqSts3bli+MY3DHhnRjt/0QjQqR
	G4/NHW1PZyBzP1vRfHtyRbsroutaKq/4DOm/MPg1KoRPrI4tbLUM6eC3SeTMGMk=
X-Gm-Gg: ASbGnctP4xbG03fsGg20G7uFMj4fvd0PnYa80a/uMG+Q5opUlS2fAkLxhllLytZSCot
	HEEgR68C/vusTz3g7ci0u+dVGbxFL6+7LEZAL2KcggQXYxCl0Y8e0YvVpRQgijAPh8Yl/ZWMzd2
	/C37Aj8DW2O3PSR5c578FToRwfbqhRrslSjYcLYBY3AuQ6iT+tefyNbANstgqW91VWuHMVj4xHz
	UDFxIRugWPU0bgvg2ftOCirXumbbi+Im/BLSQezCyFk32GwmmCtLphmjYKvaH/N1BBuM1TQWh5I
	BqVa3rDCNIR3uGVcQbXsBzZZpUyXmX7A4834Bvt46jYzg4BGp4365naZi/uJzw==
X-Google-Smtp-Source: AGHT+IEl4xkkhRV/6rqGgqq8GhxlIIH1Zsk+aKdZ8qLIk9sfmfbfHiVPZ4lcOrwQMJaY11G/EM+wbA==
X-Received: by 2002:a05:600c:3f0f:b0:43d:fa58:8378 with SMTP id 5b1f17b1804b1-442f9714e8amr13194375e9.33.1747297440668;
        Thu, 15 May 2025 01:24:00 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:59 -0700 (PDT)
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
Subject: [PATCH v7 14/14] RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
Date: Thu, 15 May 2025 10:22:15 +0200
Message-ID: <20250515082217.433227-15-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
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
 arch/riscv/kvm/vcpu_sbi_fwft.c | 41 ++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index b0f66c7bf010..6770c043bbcb 100644
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
@@ -68,7 +70,46 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
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
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	if (value == 1) {
+		cfg->hedeleg |= MIS_DELEG;
+		csr_set(CSR_HEDELEG, MIS_DELEG);
+	} else if (value == 0) {
+		cfg->hedeleg &= ~MIS_DELEG;
+		csr_clear(CSR_HEDELEG, MIS_DELEG);
+	} else {
+		return SBI_ERR_INVALID_PARAM;
+	}
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


