Return-Path: <kvm+bounces-32467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 173089D8A80
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D5CBB3CE8A
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2A71B415D;
	Mon, 25 Nov 2024 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lt9GgqQf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A401B415A
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551762; cv=none; b=NI2L2aNRJMeRNWcgoA5Za2CbWYKB5mBn3VJnnKcQklerQWTfLz4dB0JdEZ3Qtudkze9V6FkMS7NvIpZbTGM7DwNgWoSkJ83IYrSc/tv0ojtMPWy6GkJv8olMnvFiEdpV60Yq/IEGRLjTt9Y4g5sGgwzuEV2f5xLZW46rsU5otN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551762; c=relaxed/simple;
	bh=nplEEoLV2HngDcGXzjVOuimzFCJcv19DvjtoZdMHtHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9kLbCYaTa/949+CvcYlbye8DO3yGuqHGwMuI1ooYN4G2xckBCYH+XHenhsTX3SaEPDhS43lfBg4It2rtYuGckKt2T4/2lRqQzaBN9U1QpNie+htyLEWBCM/egM1x8le8qjOrt4rzU5ok4LChAL/aNrppc17rdAssjiJ2i8hyZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lt9GgqQf; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a76fd74099so20101855ab.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551759; x=1733156559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vi5sa+0SE55SSelu2nXwwk++SgzwgJ8mWQoJsNjE5c=;
        b=lt9GgqQf9L/+2yrAzwDitFETFgb11SV9Zys/W05pcWLJxO9SqECgO+WBpPU1zYxMpE
         xva0voO3ygoR3Gh8ZzTrPYzbfhIStsbEe6HmxhIettWpgp3Q/oiGVuOfvNiYNxxUX9Tp
         fIGVDvmN0aEtybPXyKamb4CZmVolQzCcsGOm9vqSm8vm6QDpS8/mWTkCNyRkp8Wdr1yJ
         jiEVvMhoFUOe57hmefFrawXVdv69F28oC9iI+hm/dtvsbBxY+KzmzyQV1K5uACI4uJZe
         1p98U+vMuauvmJtNJR4jw2+HmZFF1mH5PcHQxh/OUbfUr+Mnq138NMVrhPjHuEWYw2Y1
         DaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551759; x=1733156559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6vi5sa+0SE55SSelu2nXwwk++SgzwgJ8mWQoJsNjE5c=;
        b=L/9Z/3P9u7rRrjMJQwa1ZlicTLCpQqCl1Bxc+6VBLdDYTd7oi/dTTjDe7hNUbeH5G7
         sq6uV+FVvWmPV8Sd0cUlLLe/E1HeLdmtvwSeGDYrXWnvQom5OLdWT1dMWA3QdEyskiZO
         vBO9W406U9yDynejTqoq/WxiQp2ppE6cdzkGDSxMabh9MhU8/J8PxPqrFwcglh6m7uHS
         o3Sq+q2b4E2A7mzAzXEPCT3ZkaRXKJFk+snqseS+kf0ZHF/b4peELR/IoI6okoMlafEK
         sLpz06INriesomhUUBQLfa04fMfohrn6huDkdJ54Z59keCJ41yVpeWiV9E3yzaWsk292
         ad+A==
X-Gm-Message-State: AOJu0Yw3pgzMOw9ecuXAGNGFeYkoyTAe01dDH28++38/TpZdHctJnjNr
	Ohi8ciDQT8Xu6fxjkH1RTJ+cxHC1qZCvYx7Z6zMEMbeKG9owqmM3kmNRvkp/N36CVKcO1PrnS0T
	o
X-Gm-Gg: ASbGncuRQPXum4RwJ0UuhyERse/UR1CSqqaBUrRCoHia0LJPWhWg1emY6tyQgB4/p1I
	MN8XIz8sin39w3oPXXWYaeKSS5oYKjG5GLrtl4847IYw+wHDKRcbvF122UNEyDB7IgPhnEU14RH
	q9XW1IuC4tdgy/yo9Okuk3xfe8wmBCrq4G7Pyf/8PkiqJ0fpp4KmYbndGgxQqMDf/J6cfYqp58V
	2lQnbj30i9mg2zdOSBLXn2yL3GwLfv9FDBVd/30p4mZdEs8wls=
X-Google-Smtp-Source: AGHT+IEHq1+uU+suH4oB7XVB3zKza7n8U0URBewWl2Yw49pkGcCDTnQlc75YJ/+b9MnhmkvtqNWnIQ==
X-Received: by 2002:a05:6e02:1c83:b0:3a7:7f3f:dfba with SMTP id e9e14a558f8ab-3a79afda063mr123396895ab.22.1732551759353;
        Mon, 25 Nov 2024 08:22:39 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:38 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v4 4/5] riscv: lib: Add SBI SSE extension definitions
Date: Mon, 25 Nov 2024 17:21:53 +0100
Message-ID: <20241125162200.1630845-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125162200.1630845-1-cleger@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add SBI SSE extension definitions in sbi.h

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 83 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 98a9b097..a751d0c3 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,11 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
+#define SBI_ERR_TIMEOUT			-12
+#define SBI_ERR_IO			-13
 
 #ifndef __ASSEMBLY__
 #include <cpumask.h>
@@ -23,6 +28,7 @@ enum sbi_ext_id {
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -71,6 +77,83 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
+enum sbi_ext_sse_fid {
+	SBI_EXT_SSE_READ_ATTRS = 0,
+	SBI_EXT_SSE_WRITE_ATTRS,
+	SBI_EXT_SSE_REGISTER,
+	SBI_EXT_SSE_UNREGISTER,
+	SBI_EXT_SSE_ENABLE,
+	SBI_EXT_SSE_DISABLE,
+	SBI_EXT_SSE_COMPLETE,
+	SBI_EXT_SSE_INJECT,
+	SBI_EXT_SSE_HART_UNMASK,
+	SBI_EXT_SSE_HART_MASK,
+};
+
+/* SBI SSE Event Attributes. */
+enum sbi_sse_attr_id {
+	SBI_SSE_ATTR_STATUS		= 0x00000000,
+	SBI_SSE_ATTR_PRIORITY		= 0x00000001,
+	SBI_SSE_ATTR_CONFIG		= 0x00000002,
+	SBI_SSE_ATTR_PREFERRED_HART	= 0x00000003,
+	SBI_SSE_ATTR_ENTRY_PC		= 0x00000004,
+	SBI_SSE_ATTR_ENTRY_ARG		= 0x00000005,
+	SBI_SSE_ATTR_INTERRUPTED_SEPC	= 0x00000006,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS	= 0x00000007,
+	SBI_SSE_ATTR_INTERRUPTED_A6	= 0x00000008,
+	SBI_SSE_ATTR_INTERRUPTED_A7	= 0x00000009,
+};
+
+#define SBI_SSE_ATTR_STATUS_STATE_OFFSET	0
+#define SBI_SSE_ATTR_STATUS_STATE_MASK		0x3
+#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET	2
+#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET	3
+
+#define SBI_SSE_ATTR_CONFIG_ONESHOT	(1 << 0)
+
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP	BIT(0)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE	BIT(1)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
+
+enum sbi_sse_state {
+	SBI_SSE_STATE_UNUSED		= 0,
+	SBI_SSE_STATE_REGISTERED	= 1,
+	SBI_SSE_STATE_ENABLED		= 2,
+	SBI_SSE_STATE_RUNNING		= 3,
+};
+
+/* SBI SSE Event IDs. */
+#define SBI_SSE_EVENT_LOCAL_RAS			0x00000000
+#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP		0x00000001
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_GLOBAL_RAS		0x00008000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
+
+#define SBI_SSE_EVENT_LOCAL_PMU			0x00010000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00024000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00027fff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0002c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0002ffff
+
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
+
+#define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)
+#define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)
+
 struct sbiret {
 	long error;
 	long value;
-- 
2.45.2


