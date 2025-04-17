Return-Path: <kvm+bounces-43568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE0EA91BDD
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 107D57AE105
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D81245006;
	Thu, 17 Apr 2025 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="UUaIr5Vv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46F824169C
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892651; cv=none; b=WipRj2wZ+NVkao+Lrtw6PqAD3i8eBvIdvLgy/vu6QQ6RZvvFH2uXVLVis0UYM55gsDosXrXAGFDLxYZpewAO7+x7kJp5ij74dnfIzyBqoG1r7Im7gXv8pfslNDaSNePUVvv63lEr+u19IPiXpw0K9Gx5N52IedT5hK9K0wpbOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892651; c=relaxed/simple;
	bh=aFqX3fLDtG8cy76aRcSSCxbszjtqQl817f+Kcc6ZMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1tPkeylwrpOPa78cUYvSF7pU/IKERR5IQJpXDv4HIfJCgySCML8lzy3Hx6jJdblJsSt2mt6BeV7XifE2R4/neagffpUpc/CeMvp9RUoklTEHcbmn4b9jqziXSs/t8RB2CGvCexCMLSUkJzcJIqAGFIFGjKuqPxriA/slVd0C3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=UUaIr5Vv; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2241053582dso9939155ad.1
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892649; x=1745497449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqV/L1fucoXh0zEq3ZbEkv0iZBTOf63rS7eOzOMDARE=;
        b=UUaIr5VvnqnpwxR3b4Zv8M4q8rfT3fUQA3CCrOcZX7gn8rcfGVmlM7/Zyw6bsU/G/f
         szDiK5M+YjiZoofXT3zdJn3IVDmvZOHmvsTeidxVrwM1eS7833q9ME/pa3F0hXzwCx8a
         7GkyvMsrEOKxDb7hc58I+VRxeDxykDrkMYGHNYO6Y5eJDMmdgGi+JH5MEj6E2ukp7Jk9
         Z+ng5rJ1MaACj7AwJjEu+Z6t2aetDcOyew9nnYYE12M4cp9cjj6/D0UqfcRWrLAu6VCV
         xWrx+qYTu3EuF5Zl2jt/OA3bwwt4ROg6Qc8UnV0toQTQtnSLBTPxrG9iKBOgsliJDDtU
         8jtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892649; x=1745497449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqV/L1fucoXh0zEq3ZbEkv0iZBTOf63rS7eOzOMDARE=;
        b=be3GGYVTEElGuiGBTNZgCLn04hOI5uEWTNSKe8aNlfSveJP6TF1BDP7xttIqAi9HsX
         Y7OQtn4rIR+DmbQ/CyYlzuIJeDHfr1qg+gUSo3dnQL6TzBFUbyh/ph4oXhs67AzXQYrZ
         h1VfrUhyKDPkG46gaL9m50hhurjQS0SL1Ie90rfX9EwDlgcllXNjeQF6Sw/wC8HpdKtD
         NJUTfdKZfpfWD/cUL4zkeOhAVUrAcuAkhazsNFk2Sr6uPRpFE2zIklfiJztvZKdx7tmj
         yC1WUg0DrhxgYVA/wUPZZf6IKLarppsDKtmo8Ttrn6cwv5bdsTYRLFPjVy+SDZeUY4oT
         f9EA==
X-Forwarded-Encrypted: i=1; AJvYcCWToGQsPWTNNYxzCv4rnm5RLVNAvC6c9N8obVXj/GARfmoz8loWKXgzR1HuX0VCZnNgUY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYaOcIGeiH1K38xeElzFKBN1+hrPXnhLvhD5/dM043krEpwrha
	APyeyxxApRjBfe3Bf3fj7N4/mqGMyyDLB6B1RpjlQaJA0qwdw5r69SVW8Io+U/A=
X-Gm-Gg: ASbGncsD2EcPfAOlmu53xufQqth8YntbT7J1aAD6cP0Doth+lSgtk7zko7DSa+fujWh
	2AT1fCQvGQKuSJN2Wizg+0Z9MYA3NFFE7raKePUvu2HeBlHKLoi9inSY54bgPXc+Ll57JvTDKXS
	ByzH0maSDD8u0p7soXge3le4H9VedlIicmr04pg63SuqEBSAHSUyeFMflkgaQnsYBhghy76rOIe
	Ufa5CXS+t7ThkLiOUGz13I7LUqKnVo7FkF0Ggwp51Yz4FVuWuJj3mShzbek3X5soHj1wWlbQ2Cv
	LfiPROcSGXLQcQp2RvQHrBiPXnyWFPqHTC7ZRBtcVg==
X-Google-Smtp-Source: AGHT+IFVHOWJJRAXEzH6mdZNYusO/nzJmHfPymZgz+gveEEgUfllUOzI6Ji7vwcW5uJ8Q3EqmqJGfw==
X-Received: by 2002:a17:902:e542:b0:21f:f3d:d533 with SMTP id d9443c01a7336-22c358c542fmr78901385ad.2.1744892648939;
        Thu, 17 Apr 2025 05:24:08 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:24:08 -0700 (PDT)
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
Subject: [PATCH v5 01/13] riscv: sbi: add Firmware Feature (FWFT) SBI extensions definitions
Date: Thu, 17 Apr 2025 14:19:48 +0200
Message-ID: <20250417122337.547969-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Firmware Features extension (FWFT) was added as part of the SBI 3.0
specification. Add SBI definitions to use this extension.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..bb077d0c912f 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -35,6 +35,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_FWFT = 0x46574654,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -402,6 +403,33 @@ enum sbi_ext_nacl_feature {
 #define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
 #define SBI_NACL_SHMEM_SRET_X_LAST		31
 
+/* SBI function IDs for FW feature extension */
+#define SBI_EXT_FWFT_SET		0x0
+#define SBI_EXT_FWFT_GET		0x1
+
+enum sbi_fwft_feature_t {
+	SBI_FWFT_MISALIGNED_EXC_DELEG		= 0x0,
+	SBI_FWFT_LANDING_PAD			= 0x1,
+	SBI_FWFT_SHADOW_STACK			= 0x2,
+	SBI_FWFT_DOUBLE_TRAP			= 0x3,
+	SBI_FWFT_PTE_AD_HW_UPDATING		= 0x4,
+	SBI_FWFT_POINTER_MASKING_PMLEN		= 0x5,
+	SBI_FWFT_LOCAL_RESERVED_START		= 0x6,
+	SBI_FWFT_LOCAL_RESERVED_END		= 0x3fffffff,
+	SBI_FWFT_LOCAL_PLATFORM_START		= 0x40000000,
+	SBI_FWFT_LOCAL_PLATFORM_END		= 0x7fffffff,
+
+	SBI_FWFT_GLOBAL_RESERVED_START		= 0x80000000,
+	SBI_FWFT_GLOBAL_RESERVED_END		= 0xbfffffff,
+	SBI_FWFT_GLOBAL_PLATFORM_START		= 0xc0000000,
+	SBI_FWFT_GLOBAL_PLATFORM_END		= 0xffffffff,
+};
+
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
@@ -419,6 +447,11 @@ enum sbi_ext_nacl_feature {
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
 #define SBI_ERR_NO_SHMEM	-9
+#define SBI_ERR_INVALID_STATE	-10
+#define SBI_ERR_BAD_RANGE	-11
+#define SBI_ERR_TIMEOUT		-12
+#define SBI_ERR_IO		-13
+#define SBI_ERR_DENIED_LOCKED	-14
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.49.0


