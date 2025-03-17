Return-Path: <kvm+bounces-41255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F25A65940
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E5C318947F0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8FA200120;
	Mon, 17 Mar 2025 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Mpt9JgUO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D2C1FC7CB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230188; cv=none; b=DU+9oMGPCFVW383K35tuhrUWEuuv/XkMcfw/UlVmbuAKDydSYQnDwjvXN8/zBW68VY4JTgskQyvISpl47K4HIhG4Ul11pP7NuOEPrDY0GNJOBonQtw9cXvyy78Rej/BQ+6YiIUdGSEjMkue2cZNfnX7M16jS4pHcfVZWCMpnAGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230188; c=relaxed/simple;
	bh=AuSxiBekET23dQOzC2X8zzY0Vmo4GQHh7ESqeCMugPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ua4JhIffDUUnxN4ZqOa7S+FVHXWlnL4lOEGNj/SPckCybL6dZ3o5oW1Qcp5Iz26UO3hbIvH0xHWz0acJfGa7Pt7gNBbF/5xtWZ1EV4+6qzdG1jE2AHhoomUdkhXwrRfUhyfppyHGACU9yy+4mm1he+aXXouXFAlW5U5aql2tEJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Mpt9JgUO; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39143200ddaso2956376f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230184; x=1742834984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ac4id5hSISxos5SLaSTPfSDdA9W2x70GWFXr8C4vItU=;
        b=Mpt9JgUOq557dVrF5SFwSY+z7sdf2StUg5YURmfJx1DNJtoCj/Ho5rj+6QiruD3ith
         QnhqikvKSkrj8un5O7fPfQLuj0Q6OwpXFnNLLuERRYhaVyNS1jJk0zLhzWxjiAjYkFYZ
         9ElVsZ2wRQ0sN94etVNXZ36FDii6+mLskkO+aMXJTRLNkesf0a6qm4IQsNO0HfLvwrUX
         5bKn98djgOqGn1ByCJbscTFfDDj5c5RgV498mZKcoAugND+3jXvr891mH2fk4iECplrp
         w8I4qvyou7tVItWw/eb/TWub81l/ntP+etOqDmfVmK/HtWh+p77q5rC6wi7+u87Zycfc
         FDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230184; x=1742834984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ac4id5hSISxos5SLaSTPfSDdA9W2x70GWFXr8C4vItU=;
        b=T1tAHFJeNFErSBSAQo2F2QbCYvFA79iEgy0GNvOGxZ6OusItl7MGkvLgU3fh4e1AWZ
         XmvneDmqgIvCo4h9oCRvZTsghQLVluyIkdwx65VQjgFOUSZxYFkjDqFb2vfaFdNN3HW6
         Tx/OcRmWbLogUGaYSrgbpZCgEY7JTUCy5a0lxBBilE+OOSrQfSwALFx75Qk2SVNQP9nF
         PLRjwMt8z5DA8t6Y1nKSHqMwS4dRbypqI85p/YWBvFUa2IygwbT8hcTSgJAWYX+EFhBC
         ujXL+YnvfCmztDeELlUpEnaF5ia6b+Rb8r20/ediCK3l8iOzKY3fJ6NbrmQ7H9kBX7TU
         OvOQ==
X-Gm-Message-State: AOJu0YxNpP7AiOEyqMCq849h7fxqDZU/XGUx0kH0ekPRv5Zo+zoa1CWY
	OsmfMxWXEKwHHR7l1Dox0UlFnojEfkNj9Z8G2P11j8jkBj7Yx87Wak/hsiB0d0CVRiz6MoxxSvn
	hU+c=
X-Gm-Gg: ASbGncsjTwby6CFuFQJsHkZVqH4qKLBTHa2uswl3Re6P56sq2vdEfRtmKnXHNvhsdec
	S3ppeFdq/QsnIN5YmRf6jQWNhdakYxyqHEKYG5SnT0+Qyi427YRxmGmrNQE8q56OYoH0NpAzKFk
	zjAqhsj3iATVAhiWjnT0pvnyUAMNWCdbFmX/gtcoKWo6l5l74V36mkMyBaGwaqGkqGTjbh8gr+z
	BhD8yz7okbm4EdvvXjzEfLUjtZDKG9TpR2YqUREr7qPUsIZiDTjad3oPio6C95ie39MXPwxHcdt
	mvssxIrTIAldgOM8PlTG0SApl1mKleLAleB9KZ71PrM41ZWTWmTDcEmt
X-Google-Smtp-Source: AGHT+IFxGB2HEt7tWD2EIPz8g0Jh6dWFoJLX0eEiNIEdFz0bnbQ4fXPWzTCxjGXoW8XKNwExeJ1oJA==
X-Received: by 2002:a05:6000:4020:b0:390:f902:f973 with SMTP id ffacd0b85a97d-3971d13629bmr13479067f8f.8.1742230184507;
        Mon, 17 Mar 2025 09:49:44 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:43 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v11 6/8] riscv: lib: Add SBI SSE extension definitions
Date: Mon, 17 Mar 2025 17:46:51 +0100
Message-ID: <20250317164655.1120015-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
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
index 90111628..887a4cd4 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -50,6 +50,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
 	SBI_EXT_FWFT = 0x46574654,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -98,7 +99,6 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
-
 enum sbi_ext_fwft_fid {
 	SBI_EXT_FWFT_SET = 0,
 	SBI_EXT_FWFT_GET,
@@ -125,6 +125,110 @@ enum sbi_ext_fwft_fid {
 
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


