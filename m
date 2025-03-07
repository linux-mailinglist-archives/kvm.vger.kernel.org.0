Return-Path: <kvm+bounces-40346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48861A56D53
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A2C6172956
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6C823BCF2;
	Fri,  7 Mar 2025 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kMcI5Rax"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B65F23AE66
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364160; cv=none; b=Rr1vUbyFjD3U67NDN/QCiaiF7QbveO8B/wV90p/fJ9Pwkln8egJ/dTZ1YKNeZaZahl7YpXGnLcIuIJ/70wJP9kf2T2fJJTiC6nk/oFpCmKdy+/wlodBqjoeHdNCQrgbv4DcAyBDN7AdQr7V6ySRGWFGTZNwlB3mq0U4cFLTSkHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364160; c=relaxed/simple;
	bh=2HnFK5/Qhr15peEjtFesKrEiqrALMeMpB1gNvKkT6dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6X9kr24wDhzwG7pGpPpZJddg1dsbcysz7Uqx+eL/sNeb7LLzmt/ye6wBYG+chOktYcnwSO7Qg/zMpwHOXobXJY1pPk9332NnN7UL0Cjq6vWkxqisqsYI2/k8t7Mb33yN2mmbQIxJNF44HEDQyJlu6tcm8PhfyaSSCJvt3IvnJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kMcI5Rax; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3912baafc58so1378488f8f.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 08:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741364156; x=1741968956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEnadjkXdfJ/Wyi24C/siwRXIpKyA4zX4ZpFhHe2Glo=;
        b=kMcI5Rax0Oysq+TF1Oy/Xn2w1jXb8hH/jw88Ap7WMVt6UQAZECfSSznp5O+4o4FkFx
         ON937fJy7qhNG1nLanlGwlbtcujM93S77y+m7L0Y1KPOtQrdQzZz2e0eDmRexBKe2OOF
         ls/732AErKONfI8Xrc324i8VGmAs9ThGuq58Z3mGbu+D1XOnMGGY6Qcev/WZ209XfdSk
         X/QtsYHYt69CeHyAO6Zuug4HW0geXj+88tsXGEed7KPxMp95O6315taZczeXsdoW/Om/
         iQT4DcE2wR3ZCe3IDNMrqxga0Amadpi5h0ulWuL7KKhBWZNtobql7lvBOegHQ5SVyrIJ
         Bclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364156; x=1741968956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEnadjkXdfJ/Wyi24C/siwRXIpKyA4zX4ZpFhHe2Glo=;
        b=kZHv3X9OSq4zVbU6ygbuhr+3zRKoNHR68+K40PSfoapwcPRJU36r3VJJvI5L79xsoF
         fhhLxYLjafRJQX584on6k6DsN3aFp6kIxRcQ/RLblDbfQqhzU5tHD6Jea2VpCRPy1K42
         wHUJwFt9Lw8AtbFVbn8j4uJtiB+HXHV3oKwcvpmLr6jB3iClp7g6MX8x30Hk8bum5MC9
         SHCmAoZMKZJVsijtxxlmHNmGqkCXpxL0ntHAn/+PtwKxFaNXS2oFThisE5Ne2US9ucAr
         xGy6MNshaNY3F8sPzVHbTc/ffKRdsQz9CEVicH2h2+QL9xIWBH3YaNqqA4JMk+DXg7Zq
         u41g==
X-Gm-Message-State: AOJu0YzpJZQw+BlHHTYoC8ehlwZkp/8E554QdpjUrrrHDJ4SpL0q1BXL
	wkDJrcxHMDnVzzSOPU351K2CEkGNjIV4xmNbEodMpwpt+uitS+ucXtCKAsQt/k6LKvbePpV88Sd
	Z
X-Gm-Gg: ASbGncs0RVTYvHrEV7hwP4YONdAg287b54TG2rsrBjSb9fIKBC8NXvIFPfzuwKY9I8K
	/viZTwI0L5BDzDmX4etdOQIbbcLuDgLvleo4OOHoNUt4Gp/JHYiIRZBadarQ/PJme9HlPX8LXXl
	fu/Mn0QyWXfQt5LrMqIaQCL/dcBHjVOkqBFRoRpXawQBGPmhbBCdCrzNU6I6xzAiJxb8TgJvWxK
	JbpEwpeIoatLErK1jF979IFbAd4XroDs7CamZBdQGuMNGLptpF+dR5HfCMWS4n633kb+rRZo/Bn
	ATAdGBtMnXSr6hJZd1ZvzI/023L4UiTCMBxGZZCnxFKMDQ==
X-Google-Smtp-Source: AGHT+IFvS9NJZFLvIztECb1WSTlOmEQTqeqFagerajLozaZgx6rA8DsqzXSXRF2Ng1vQXPz20xT7fw==
X-Received: by 2002:adf:8b1d:0:b0:391:1652:f0bf with SMTP id ffacd0b85a97d-39132d8dc66mr2172407f8f.33.1741364155712;
        Fri, 07 Mar 2025 08:15:55 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8daadbsm55496245e9.21.2025.03.07.08.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:15:55 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v8 4/6] riscv: lib: Add SBI SSE extension definitions
Date: Fri,  7 Mar 2025 17:15:46 +0100
Message-ID: <20250307161549.1873770-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250307161549.1873770-1-cleger@rivosinc.com>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
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


