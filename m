Return-Path: <kvm+bounces-41199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2004A649C8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDD3A3A7C67
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA4523F39B;
	Mon, 17 Mar 2025 10:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tF7SHZRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746D123770D
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206819; cv=none; b=uGK/Lg+nyoXVgoIkKWzbkhIGHCt22HiqMHc55ZsRMIiNjoc/aP/B/YU/GcZ9F181kE8ct3uqA1faMMMAOXdT0trYbm/dk2vUiiM7dtn/fMkCIi85TH3GMvU6TZ0ZXaYzMTuacj7wF7+gS/hhAkx+t0ld2d8EJaHbaC+6MCZcWeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206819; c=relaxed/simple;
	bh=cKnEez7Gk/TSmhSwaleFFo409iNRluGPLkv0smXhz3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YN0kY3GAcYVHXy2iPJpkYAiRyLjS7frbI5QpqWGvW6nlS23Q/+KYhOk4QNMFuqfPVgOQDUndKP1NQP9E09Zf/ITCigzPVJMw3qJAZZ829g+6CJio+g+n1IcethDmPohz0CxvV4C8vpo8n/39935s20zmFe29RMD807bZ5qx4BYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tF7SHZRO; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3995ff6b066so691114f8f.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206814; x=1742811614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iXowGTGBn1KzgCO/uIRhcWDCtcAcoXXG4ILg2vbKIM=;
        b=tF7SHZROJww0OaL43ishwUBgf+XBn0WAwHJ674aXCLipuqZvyX3G9jLeutIOTt1PXo
         ktA7jbK97h/PxMID1dXvoz+nyy6OBOMnwhEUcJV8UIPiOdGPyo3dXwlyfaQ+jn5SahIZ
         f0YKWJGphoeEdZDrj/UEI1oePg4lZeEmV4dzp5UrfWwowLS6d+5WwYZzgFtCtrkG1jlj
         YZfNkITadzPfhx3z5/KR04jKVLsqFY4c+F6e+GIH6Z7Ek+W2f/BGrDjkHknGlCZTJdB/
         yyJgcOU2GcqgCFi4T8a4xMyJNlit9/KvdS9FLwBpVOrEnkBmd/vjJHA+B34aPACCDdr0
         ZSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206814; x=1742811614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1iXowGTGBn1KzgCO/uIRhcWDCtcAcoXXG4ILg2vbKIM=;
        b=NePk/o+3vvcPpJ9YG88SpH8UE6D/GZ83ldGBRX8ZBnGPDQvxbjV79oGz/f+7zr+hVU
         YH593U/KLSGRGusSuGVSgaXKygpq0/XVAieeX0JFJFLjf+2qw5/WYjAnBbasra8hs2Rc
         urlQ/uv2HV2FxgQFVktfOx5bOjg0lYhUgGGgT85uCIpwpDkFB2H5bJTWI/+8StTZZFZ2
         Gcp8DDs+w+sZLjlAPeFFy/BBixDujNuauTuJhOvpQcZBXArLDtPVMdiWmR3BOg0CiiW/
         xrCC+uxhmoDhe50PgUoHLJK8dCmee2nSQlxnaHa7zQKm7+o+tAm3slcWTL7jN7vv9Zc+
         FKzg==
X-Gm-Message-State: AOJu0YxOdjeKqzEMA8yjBYnPpC1WC08E4btMR9biUzdC3IUVm30yAUZ4
	pV4W4bpZJhejaqEqRDq5t4Idz4P9MZUkiYwbHsEIC13kK/tDuT0DqPh7Kl274CzFo6RP662PfuR
	b3lY=
X-Gm-Gg: ASbGncvEpj5rVLjswlTbrptgSZ3vGDU31/XD8Uf1K68cmhQ9pDCAMGPZlyU0bP5BOf4
	vIioN9iCLFzdptTgH0gsmS6Yfv0aZ0NRlinuSE7U8cR+eysG2fdFF1MHy+GagAHHVnx6PZWu7UP
	glnXaF0z23FIJvI6btWN2k2lSj/b54pObxlVr5hthuWNRcv/1i8od7fLiigOCSe79tDAA1RUDfY
	NG/V3gjnO5Bc9eD+fgvVAMyaQTBOiNWHrIV8elRLb7z1hrXY2XOO6kxodLGLf/w85D+dUQYMF74
	BvHhY41o6oPbsJr3QqySYAVBzbdhiDRC4TMyJBRhH8gbFA==
X-Google-Smtp-Source: AGHT+IFPBYBDODlWslIoDz1PMoZSZvMRRrso5WGvECxXn2zkBH+2lcjxyx6qxUmwSqNHHoWv7qACfQ==
X-Received: by 2002:a5d:6da2:0:b0:390:f394:6271 with SMTP id ffacd0b85a97d-39720966395mr12658005f8f.43.1742206814442;
        Mon, 17 Mar 2025 03:20:14 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v10 5/8] lib: riscv: add functions to get implementer ID and version
Date: Mon, 17 Mar 2025 11:19:51 +0100
Message-ID: <20250317101956.526834-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These function will be used by SSE tests to check for a specific opensbi
version. sbi_impl_check() is an helper allowing to check for a specific
SBI implementor without needing to check for ret.error.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 30 ++++++++++++++++++++++++++++++
 lib/riscv/sbi.c     | 10 ++++++++++
 2 files changed, 40 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 197288c7..06bcec16 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,19 @@
 #define SBI_ERR_IO			-13
 #define SBI_ERR_DENIED_LOCKED		-14
 
+#define SBI_IMPL_BBL		0
+#define SBI_IMPL_OPENSBI	1
+#define SBI_IMPL_XVISOR		2
+#define SBI_IMPL_KVM		3
+#define SBI_IMPL_RUSTSBI	4
+#define SBI_IMPL_DIOSIX		5
+#define SBI_IMPL_COFFER		6
+#define SBI_IMPL_XEN Project	7
+#define SBI_IMPL_POLARFIRE_HSS	8
+#define SBI_IMPL_COREBOOT	9
+#define SBI_IMPL_OREBOOT	10
+#define SBI_IMPL_BHYVE		11
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
@@ -123,6 +136,10 @@ static inline unsigned long sbi_mk_version(unsigned long major, unsigned long mi
 		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
 }
 
+static inline unsigned long sbi_impl_opensbi_mk_version(unsigned long major, unsigned long minor)
+{
+	return ((major << 16) | (minor));
+}
 
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
@@ -139,7 +156,20 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
 struct sbiret sbi_get_spec_version(void);
+struct sbiret sbi_get_imp_version(void);
+struct sbiret sbi_get_imp_id(void);
 long sbi_probe(int ext);
 
+static inline bool sbi_check_impl(unsigned long impl)
+{
+	struct sbiret ret;
+
+	ret = sbi_get_imp_id();
+	if (ret.error)
+		return false;
+
+	return ret.value == impl;
+}
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 3c395cff..9cb5757e 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,6 +107,16 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_get_imp_version(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_get_imp_id(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
+}
+
 struct sbiret sbi_get_spec_version(void)
 {
 	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-- 
2.47.2


