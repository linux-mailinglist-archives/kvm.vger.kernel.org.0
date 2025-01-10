Return-Path: <kvm+bounces-35007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B42D9A08ABB
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34AD97A3D4B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CBA209F5C;
	Fri, 10 Jan 2025 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ykh8KCre"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB2209F46
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499248; cv=none; b=R7y/39jiDVBqiFaX/1sAlOx8ufZJ5EunmkwY9g8bVZs/DW36jsWM8H6w9dFWY6RDNlciDigpgunlT4/DhqgL2xStK4FIaT0PrAyeQoFnDjPOLwzF0Vj4/cfbQrUPoTNBn5Af0FFpopM74UZ1GbvXxnfKgZ/4UDxjKeU0/Md55rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499248; c=relaxed/simple;
	bh=v1XsW1WnggH149v6+WTn2vwZdiiPZjkex0NQNrd2nqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EB6y4ddYm/gDmV7QMVeBbeviDGn4Do0rrFMgETgLYSrGQ7D8rtxkTB8OwaPzV2feWV9lQsyVgGCBzWDnWfBSiVZGxLfuGfwAE6n1rZIapcPchvV/ymSNf8e46OqqysegzRyJP/qI1zvCvLHC7PxSoEg0LuXIZhP7o1cEYLuJF/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ykh8KCre; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3862f32a33eso811720f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736499244; x=1737104044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYths4OMC2TtlQTz0sJIMvagsGZNGflHSOzs+WkBihc=;
        b=Ykh8KCre52LJnOgbC0/3a6t7aCeNQdZkbab37LMHM3LsOc+0E2AuSd5MgeMVLU12ps
         o9CJd39NyXz8t5sXNiDFjZm9eJjqGmEbVIIKcaBR1kZ5QXeQy6cQTtTomq/ogi2ODzGN
         jkDCkd2no2I9gAzwjVy49FjLklp6E7Zoz7vp0r64Ip22OXcYiOivY6Fm8VrLsooudjLP
         LVWPL9uQV5tOBRDWMWV3HNxaxhBmJJptIkrGTJcwz8dSZfed9z+bldghoYu7pYWRCxfa
         5j9pMtJa3l6QD5lWVN7aYxnistn4xYXX+rMLW1/cTULyX5gcczmoaiTxnsH7JFERq68n
         eBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499244; x=1737104044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYths4OMC2TtlQTz0sJIMvagsGZNGflHSOzs+WkBihc=;
        b=IaQykqxhxIWB2YQSlhV41yJbUi5CFbjh3yDpcmes9Wtg98sIdj84mpPl2Dp7nVZd3j
         jYWeHcx9raT+7LaBxbpe0dpz7DV/26L854g7VPSO8bkWjmntEhJslIuSLQWb8PPuKopQ
         BH1CEqTnaHYfaqZkpwJryydi1LvHNthJk1u+3M7qy07+GlTJ/GcLh4/zQUSKGJax2MCt
         +1pZl/wSyek+ROqVh4bUe0AWZilWRgUOYOC8DGYnW9YS+DNBnAgL7QaW2nNxpkfScPB9
         y/H+vVUFVUDNr/O4T2zMl7yPZGDp8Maf8km4gqX/wXaPRmsWISwc2x2/j9YoHQ2IJS5l
         WnUg==
X-Gm-Message-State: AOJu0YxBF6GeNe8nH5sYpHJbgkU5npEZhIMYoSkQP5HsAKp/wbzEuWc7
	BdMFWYctxlD9JlUr1FywXqD2qsHg+qB+G1JoFX4fkB0J+xLI5XyKzBSZb/Hcs1D8ccHHGGxtVIg
	J
X-Gm-Gg: ASbGncvVSTk9xfyybvT/MZapzitJi/8pxWfLL58M3y1UDS3QEV/+X4MYP8YxWr1mO7D
	tkpqLcdHI6r2zgkq6x3hs9VgMMvpD+4h4G973WSNTb1/3RgTDFSi81iEe8uk0FSSnqFEj388Sd1
	OApzG7bd7SxIxGqceBVWnB1CQJSWSEVxg1DesqJrIpK/QXlhqeMn3hoYKvA3QU8ZR41ar6AYDBH
	dTRu92ALLLdzKRXXnRgy3waxuxrmfusBijN01C9rlekIJEDFm884mQMlQ==
X-Google-Smtp-Source: AGHT+IFwJqLqwRp+XoQxBs0dLbf526Lfqu8DjEu8T9JCkOVk5p2EcS8j3h9b56GpMYwQWHROSK/1FA==
X-Received: by 2002:a05:6000:1acf:b0:385:e2c4:1f8d with SMTP id ffacd0b85a97d-38a87303f90mr7084185f8f.19.1736499244157;
        Fri, 10 Jan 2025 00:54:04 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1ce5sm4009283f8f.94.2025.01.10.00.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:54:03 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v5 4/5] riscv: lib: Add SBI SSE extension definitions
Date: Fri, 10 Jan 2025 09:51:17 +0100
Message-ID: <20250110085120.2643853-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110085120.2643853-1-cleger@rivosinc.com>
References: <20250110085120.2643853-1-cleger@rivosinc.com>
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
 lib/riscv/asm/sbi.h | 89 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 98a9b097..83bdfb82 100644
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
@@ -71,6 +77,89 @@ enum sbi_ext_dbcn_fid {
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
+#define SBI_SSE_ATTR_CONFIG_ONESHOT		BIT(0)
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
+/* Range 0x00000000 - 0x0000ffff */
+#define SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS	0x00000000
+#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP		0x00000001
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS	0x00008000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
+
+/* Range 0x00010000 - 0x0001ffff */
+#define SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW	0x00010000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+/* Range 0x00100000 - 0x0010ffff */
+#define SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS	0x00100000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00104000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00107fff
+#define SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS	0x00108000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0010c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0010ffff
+
+/* Range 0xffff0000 - 0xffffffff */
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
+
+#define SBI_SSE_EVENT_PLATFORM_BIT		BIT(14)
+#define SBI_SSE_EVENT_GLOBAL_BIT		BIT(15)
+
 struct sbiret {
 	long error;
 	long value;
-- 
2.47.1


