Return-Path: <kvm+bounces-41045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A60F8A60FA5
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC3344609C9
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76E31FDE1E;
	Fri, 14 Mar 2025 11:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="FVgPOxb0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E737D1FDA8D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950644; cv=none; b=GoLE0LWYkgrywih2zllggtzlvft5KHZ2TRyqtyzgxUi/Dj9ieJ28vTIlf6XyyDlYZ4+uewEyJbr1akPJmKc2LT96C1yEJ+zqKGGLRYA2U003iOlfDBChPxC08ZE+2pimmwinOJBzU9S4YNzVC4VtrcyQ5Od9uf5Y491AikYC44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950644; c=relaxed/simple;
	bh=2HnFK5/Qhr15peEjtFesKrEiqrALMeMpB1gNvKkT6dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPrvhrYgEXDCARovUXaMceUmmWggbtYD2pmBj1k126OaCQm5OjnME1lcBUYlqNvYSHkvlK1aPupMRgJtAtV6mKH+F1iqDIH4UhVOVgpVbNUHVdGyJlyW2uXBOH6IJvgbAFZun9VpXWYE58CgdWq5sDzfRcGUrntcyOFzmpjmiOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=FVgPOxb0; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3913d129c1aso1564843f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741950641; x=1742555441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEnadjkXdfJ/Wyi24C/siwRXIpKyA4zX4ZpFhHe2Glo=;
        b=FVgPOxb0Jylk3A6St0d/zZwaMVwbzbpETg8FUCIcWlutloi7ddNB1jS0oE0EhiemIX
         L8EGLY3C/wrFZuZyTAix+gjq+4FsLqhkUdUtnsTXOMigbYMT6PS10QgAeVD36ncraODk
         pAdYsxf7X/wkTeW42Fi10/RQJBfs6UrEEFORkn6wqWrxC7bnxsewgj/Jdww8sS1x+GXD
         sJhUmVcjn8VsKETrUYR/HqSudznnFTtwYjuHOfPwD3rDVo6NOfFqLUESPMWW98E+adCy
         Mtp0C6stHmz5LPqYyF0gr0oYhJsTUppfOT6ZNAGapWGe3GGFNwH03cIs+GLOn8FbluOm
         +adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741950641; x=1742555441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEnadjkXdfJ/Wyi24C/siwRXIpKyA4zX4ZpFhHe2Glo=;
        b=ZgZt5zAE8Ej1Xu7ACYH/ftqOcwFg9+uWxQgoL4HYPwVnePDWMR2uycDJM9bVlzWB3u
         hqce2HwZJVjkoCamXZ5WueXtl6vLWP5kHtYHVM7d3JTNnhaKsX60tDhlhe7bT5SAGFci
         8oNXBNyjAbxdhaef+UucgRXcwaKG4SBoHcIbbykclO6qKULdxT9O9V2idPq2bw0+R6Ci
         kxGcVwpTPmaWb0djJsghpnbVdwbcx+rAzdlR31WzuHK6Mk5uj/UcLn5gtxy9azvukJsl
         eQRcVb/UJJOpjRZype1MObDQ7vrRzgNb9B95U1EjXnaE+HshpwlP0y9CYSX8qNhhdw2l
         wwWw==
X-Gm-Message-State: AOJu0YxshmVSGBuQsEIuTykMh8Z3GqD4HoZWYXkckxAs9VsE+Sfyqf2j
	jDke3tdfyiTmN5/lskYZgRevvFVBunQHIVM3yqAhPm28FPl+u5FEKRVYINiKrHjVuyTgvmxwmCr
	oD0Q=
X-Gm-Gg: ASbGncv4nDgNRiwPHCvTsvt9aYiZXODGSKkY8q4fpj2lKeeevXjQTX7qxUoiMWr325A
	LSrQtIV+OkNXgYA3yvGztbgbCr+EUz0g2NgWpBSgnoRO+sbhqFJ/OVIK53ruFCDEN0MHWKzjpry
	Ps/jOCFYpM4XmGRA/2kJ5POB4iwq3Ys2kDfnsLSgEgVSdGJ1CibmBEQ5D8tZKU09ywmeqFQJiN6
	9rhWJRKPaG3fyBjxRFtWxZArmVcrgSH+dD5A4pPjESgCkRw7c6GNzeZ6pt5YnUs13FYkIjhLEsQ
	Jw1IcSoRxa+9OXMPtkd3f3K9i4w3CTwVEc0m0Vpu/ZEC8A==
X-Google-Smtp-Source: AGHT+IH+UgD9+rQY1r1Z6nIHKl6HkEXuOtXPmIM+xM3JrBx9oj3bC1hZb1PaVvizxhxRY1r/9PcOWw==
X-Received: by 2002:a5d:47cc:0:b0:391:2eaf:eca1 with SMTP id ffacd0b85a97d-395b71ac4b5mr5869107f8f.2.1741950640781;
        Fri, 14 Mar 2025 04:10:40 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb3188e8sm5299203f8f.65.2025.03.14.04.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 04:10:40 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v9 4/6] riscv: lib: Add SBI SSE extension definitions
Date: Fri, 14 Mar 2025 12:10:27 +0100
Message-ID: <20250314111030.3728671-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250314111030.3728671-1-cleger@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h | 106 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 2f4d91ef..780c9edd 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -30,6 +30,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
 	SBI_EXT_FWFT = 0x46574654,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -78,7 +79,6 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
-
 enum sbi_ext_fwft_fid {
 	SBI_EXT_FWFT_SET = 0,
 	SBI_EXT_FWFT_GET,
@@ -105,6 +105,110 @@ enum sbi_ext_fwft_fid {
 
 #define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
 
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
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPELP	BIT(4)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT	BIT(5)
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
+#define SBI_SSE_EVENT_LOCAL_RESERVED_0_START	0x00000002
+#define SBI_SSE_EVENT_LOCAL_RESERVED_0_END	0x00003fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS	0x00008000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_0_START	0x00008001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_0_END	0x0000bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
+
+/* Range 0x00010000 - 0x0001ffff */
+#define SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW	0x00010000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_1_START	0x00010001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_1_END	0x00013fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_1_START	0x00018000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_1_END	0x0001bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+/* Range 0x00100000 - 0x0010ffff */
+#define SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS	0x00100000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_2_START	0x00100001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_2_END	0x00103fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00104000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00107fff
+
+#define SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS	0x00108000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_2_START	0x00108001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_2_END	0x0010bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0010c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0010ffff
+
+/* Range 0xffff0000 - 0xffffffff */
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_3_START	0xffff0001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_3_END	0xffff3fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_3_START	0xffff8001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_3_END	0xffffbfff
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
2.47.2


