Return-Path: <kvm+bounces-41263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4578A65A14
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853F41886D4D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4031B0424;
	Mon, 17 Mar 2025 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vlSOjrou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA9187876
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231291; cv=none; b=XJ9v/3gFrBbW7YECSBLHaH2b8hnQZBFKzxfhTKuDXj6WwfGWXkCeHw7vghg0XpOD7RpqSzb1kkTxnSt9UyHhDeE+L3hB/b/B5WODm66I5aSgfgPoYGv8qB1oT5u7Tdfh8lJuEXTVb/fPrtLP4LOs8xrTy/E+At90pdtES4MJXAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231291; c=relaxed/simple;
	bh=gMTbJG/v304/RzgyXF89VuN8yMkVW4//gJ2IFBZulAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1N2GGFMU1VIVUoxqlBgUv7MSh+cHVdFL+pWFwfA0sIkwaCpql11V1UAnpfKdxBnWnzIAOLRT8Z8Ycebz9IywR1aIKNJ+X6uCp3BZ06RCrsdtRvHn3Fvu5OXSykq0Z9eq4NMqhl697zcJG6URQMoQ+jx9RHIlB5nG3vGu2T0RU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vlSOjrou; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso16728215e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231288; x=1742836088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVImGrzi7Si4eY1ElT4GTBjapJa7KEDVy79wJkwRK9M=;
        b=vlSOjrouJL51ciijdwZGFojk6POOm3owvskqTivEWyPbJGLQBUPyx8mt5+6UxUnvxE
         1MtYZMTXp5F8WTbpi+hnS/rZnA0LpaovyoMK4+hZNmppauxAdcYX6RaZc6D1ca7n2rqc
         xelubx6mBl/as7//VNlbWan9QKd9Z/rB8jumEfoKSOtVmT6JRpXIDeyLeo7/E4ygYNm0
         zG2Lkd/mVinBXdWq5NPt5VZwDmpVZyv9iQPVRmvBmqEcFvk5Hfq+R5A3gcj8zRkU7TOl
         RAfehYGaXIXgGQ4I/0e1Kjgv+H1AoPwmhrA/rElKHzxBkT9CqltR1c4f9uJUX1DnXrCT
         M17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231288; x=1742836088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVImGrzi7Si4eY1ElT4GTBjapJa7KEDVy79wJkwRK9M=;
        b=JgHorzEsaHa2fdkCtM0QObo16lH0tzaGS0FJTgcU1Vs+nDyrWI1YsSRKBxLuTHuUjz
         eGnSK59/cZxeCtfwstJEfJuuXtPwp2xAfV3dFFvbHCpZafenK174twbpzrD6pG/63+fr
         KshpURAsa4ryrGiJrfQUzN2ls2AutD+WqP7cNIj6YaslQO4ErKfz7tJs/COcBRfNFuoV
         bVcBnqYswbLNz+QhmktK5PlplpjEhh70DMuVmA6zAK+zmKTyH7d/yOb8nqzsx4wjb0/o
         UktyElLa78Mp8M4bMleJ6e63acgLf3vm442QOc9dUBMf6TKU9TuJB6cEykZU+8WtS+pz
         UtAw==
X-Forwarded-Encrypted: i=1; AJvYcCU8nbmltsAaoLYRFOmkwiwZhrQjh7hxBp+Kr/yo4t8ze72dfMChYEB4hXgHEKAAf31gt8w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx0DRNy+2qKw4apfWyn79HSboOlJGeLqCFdqrX7MBm4dIo6BH6
	FQJOS+k3lBdTJg67+yW87yQE86XssAsag4VURXIDLjGjC88bvaQNnLRaU/5OGfA=
X-Gm-Gg: ASbGncvE/o6aJxmW8lTM8D+twjgX4goU3ti9vRFMLu6kISlUSymikV0HjhUUvS/voQo
	jyU+0CA4VbwJy5+TUy5xJ8qxfcMPS5cFK9SwNkHZPhGqAiu/R6EFHAQmlvyRFSHhO5r6x3QOWqP
	rvT+6wFIVepZHbdlRVeBCy0IOWmSQ8iwEU4gBbYZcpMIrtykOSg68P8Ssh89jDRzqYrB2eO+NO1
	B0JSvaE1Z4mBBf2YLAwWCg2es1+6bYLjZ7qwX/TnwDUvMJyLnDAraldedQvTnPwyaAKctpzV9PD
	dio82ZQe7w7xHANc9cD3Ka/99xj1XVmR75sIYkkiWvIM8g==
X-Google-Smtp-Source: AGHT+IHKMm/vFlG6UDlvbMz7uYFJ/kE1+rhH+pJF0OJXqGvzOjYrzfvpGlP18pd4myenVCv8U+eYbw==
X-Received: by 2002:a05:600c:4ed2:b0:43d:cc9:b0a3 with SMTP id 5b1f17b1804b1-43d1ed000fdmr113482925e9.22.1742231287574;
        Mon, 17 Mar 2025 10:08:07 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:06 -0700 (PDT)
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
Subject: [PATCH v4 01/18] riscv: add Firmware Feature (FWFT) SBI extensions definitions
Date: Mon, 17 Mar 2025 18:06:07 +0100
Message-ID: <20250317170625.1142870-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
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
2.47.2


