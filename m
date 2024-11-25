Return-Path: <kvm+bounces-32426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D82899D84E2
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 609A7162A52
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BEE19E990;
	Mon, 25 Nov 2024 11:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vSCjPNGT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17294187553
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535750; cv=none; b=pHKp8bZ0An6AoFEJxmmu3INw5EkEW/WzxYYp0vuaZ9Fds54EJT2NphnYwwK+8zvRbr98K+zA14zxAoBsdP797wdTIYcuVV+YtubmQMHd9nGswXBBX//tbTcPzJIdyVWxA/3pQZBsjluLYHbr25PZRrmp2Bgk8Sydnv9hqhX4wTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535750; c=relaxed/simple;
	bh=/8UdF1CcqsWMTBCP/8awGLd4+ltP/g7U6DQ83xBuVMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jlsm6dGdNX/dQFxs9HVB6uDGxkWNxZHdQc8seN5Ycxrqt9MiPpgkFngLfgPa/gImeXf5Y6Gh8iNDwavr6cC6b6atys5DcmXOTI38qWvH8UtlhyjSH2Dy+Va06+5AVydX+GlWVBsgf+8q0VPX7HYhyFl1rBoJcPuiFBi7GuIcLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vSCjPNGT; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43152b79d25so39619685e9.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732535746; x=1733140546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AuN3jt2kvHAoYQ+T9+1Bb/039QjwXbOGdxCl73sHAk=;
        b=vSCjPNGTPmTvWSYgBrXvmInKP7kStwg8Zyj1LVPFNkNDDlY0ISvYNrjpuvHuxTmbwU
         ZimKO1mHXJd+TPm/UnxFqSR+HRVwYikVG18L3B9mGdwb0nlNwDljcWg32DKunwdYxqWw
         scevN8Og61jpye8mdafuWmXrAnx3RbsgV24Qgx/CwkGR5aV6OskdUo56dk9By/uyFpuz
         s+M6A+vokSAkrF0ceCNBjoZrZmIOdHmduA/xztabf/tAEfaCD7TLtIhlzQncTEGps7GB
         iRUvGGav6rbboVE6lI+lCky3jKsb28IWAL11UjUfsXgatnGRobbSAI14PFuxVo21thIZ
         ekDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535746; x=1733140546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7AuN3jt2kvHAoYQ+T9+1Bb/039QjwXbOGdxCl73sHAk=;
        b=r45aq22Ub5uSwVh5HZVef6UzOpCQnhf7Cn8f0nOqOCgZbaUaIcaVqKegKYJJQ+qR/Y
         DggfI1jasv5Q6fXMurt9sza2sbVB7jKTLhSE2FQY8TTmqfWX54YSfgWVqjrKf3mR9nKC
         QzsWNvMyhlXQ6FA4Zsez/geHQ2fDeuijodE+mX5RGWTZ3VDEhAqT9KNdi5id6kHi/qvV
         8PROL4ME7QuAF6GdoDs07nNEH5fx3x83lUdixxI1JNloNPkcmkGel5RIg3Oe4wyzbUyd
         9+/V8/8R6ncioqRzbP3+IlPKvmdP3rzXxq5UACrxV2gNdc+ZA20N+CQJ1//FFjljT/3N
         ZBzw==
X-Gm-Message-State: AOJu0YwZETASct3E3ThiaMe7dnb5GS36NThMrDrdvXJTUtm2rrEJ1e06
	1Z4mDx9U5UsGa5rJZLNsvRHUZkPKsEppzO8ckra3UjRRqig1+ACrsmcSZU7Y+ZvUP43dS8c5tcZ
	R
X-Gm-Gg: ASbGncto1r7sTQfJqwNgtMQBU5+UgqKcrgU1o/x3PS04rcDrTbd0f0eilSDRMwuCJg4
	uOKDC0Evc5I+TaAX2GcpZRDqu5YBmxe9D65t9rW5H9iGIXx0MmeVdJxtv6dTy+Ips3R2eXnn2id
	nWVYTHt5fb64THl2EU5sixD4+TeZ+HGMYfdrbDaGJcBe0DRxa540k3+96NEeRoZXwtjVd2ZPXmF
	/7x5XR9qcdFtDo8PcA5IjfwHET5AHNYIb0jsiRzoVYBnpyiNPk=
X-Google-Smtp-Source: AGHT+IFpLU5tCmHwOO1amkNYJxdjFh8cYczZNMSI4fxFbxTF/ip4wFuiUrcjHfGc1vbj6mGL2QzHVQ==
X-Received: by 2002:a05:6000:144e:b0:382:49ad:54df with SMTP id ffacd0b85a97d-38260b48514mr10448174f8f.2.1732535745506;
        Mon, 25 Nov 2024 03:55:45 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3dfasm10546938f8f.76.2024.11.25.03.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 03:55:44 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 2/4] riscv: lib: Add SBI SSE extension definitions
Date: Mon, 25 Nov 2024 12:54:46 +0100
Message-ID: <20241125115452.1255745-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115452.1255745-1-cleger@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
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
index 98a9b097..f2494a50 100644
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
 
+enum sbi_ext_ss_fid {
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


