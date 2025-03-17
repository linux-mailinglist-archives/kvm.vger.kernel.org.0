Return-Path: <kvm+bounces-41197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD31AA6499E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2D287A83CD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D1723C8CB;
	Mon, 17 Mar 2025 10:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="QFAIXOSt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA22376F4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206818; cv=none; b=iKSmTXmtQpJ91psYugiOKugVela6GkUsZ97vzXj1SO3bxDGjZaomrody8UbHtbcSe3LOQHDkDwwrPKt0RIfoFEms0WBS/oyEGsNsaHcFvSaOEYF7JJyKr6Jff6PtIfJLrgFCcX5kNKtxX58v83/j6OfWbUzD0ZJ0ZaTi9e56njo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206818; c=relaxed/simple;
	bh=AFNnGSZ6a5n9MnqCZhhi4hR9gITJtKzHGFhiNrMeHL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khzvGuDF1RhX/bFrdZOLf/uwyhmXfrNss2dhkmVl9EJX3XeGKgPiEfAfAKiC0LbdKf7pVGjyQbw3LeUl4vpBmdbosyzmh7GwcOp/TEhlM/E5Aa+fr+jDHBs0FmLECH5O5ViZo72Izp/A2IP25ItqEqMsq/cgFndA59qI0/caI9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=QFAIXOSt; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cf257158fso12268905e9.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206813; x=1742811613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x65kZaxSIijsZG5VBXjklrs/7EqQHDlN3oWwpF6Pt8I=;
        b=QFAIXOStg2VinOZkTSNUAt35mtlCpPC7KgJpAGYA7hS/xsgmAfhjAKwNJrPv/ywqRn
         vVN/ccmkif3Iv1e9LiX9D76CgcPPGpoESYwmBqj2CWcV3JK/5C76TcW+owoFuMsVVV63
         Ful1ukLYiO0rPEMxnX0yNQj7+M+SPhUgTKZUHwBm+iGLh6vV4nc2a8kxEFz6jHbh2L3M
         TcsjwSDghxeQ1d+mWgWNngHIWd0qU2+M+IvAhXkUneEmYVVcKV3VywUna6FABb33UNxc
         NefWnZW/YihDANfZJURppJCzy29sgDsfHIGuq/uWm39FtCXbQmy0kV9U1lOg0FgV7BlQ
         u5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206813; x=1742811613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x65kZaxSIijsZG5VBXjklrs/7EqQHDlN3oWwpF6Pt8I=;
        b=E9VM5QU5A/9Ejm7QhcCKag4nnTdkZvLdiatKGhxAxA6G3ngeJCwbiqaPbxb+tqqpyL
         FX6E2fywucpf03w53YdRr0iYajjCXMBcxo9Cg4A0vuyszA+1D7UZGc/s0zG20SKrgVcH
         V8drdYG+lhuJmG1eip2n7ESskH5DlfexMfTSZjGwf8DnZVCUnTrg7EPp24OBVnNKcL82
         ZIQV+aL+4F3RYkR3hpMzfwL1c41FTqHdqAXKsP1SoFGnfuI4sXbAfxUbsPKW6/1PdNi7
         W0H43AmFEUoDfrOthlg+ALVZNq7CmuLht58As1dwJCFuhdiVUKK6dExSUqkt/EpKqv/z
         qhqQ==
X-Gm-Message-State: AOJu0YzOTQ2neWOlHo69IydKNv7ANbLyIvDDGft58dHwXay1yyMkrORE
	uDQqzCyHttaq+kQrO0kk9MEUbBktrUaxZZIv+nvSZMqsa7VkKeHMuLx0AEymQvgnIAFPAg6vNkD
	ckvs=
X-Gm-Gg: ASbGncvZ04drREq5Zz1OGesLYTwSxK6p3O/6p6ZNWv4/hw2/G2b0xoTJCxKqmHTUfiL
	HaNBB4O1ukScY8DUKn+KEtOM//ExsWknRjw0yB8Y7dSHbtRv6Nip7Wi+i77aan4OCv58BY1Hx4W
	qM+GB/a1/ecHcZwzsXAhxhyrOlpGGyVtmAx3FTWoITPOWXbb1558HO7QRGyNGIsP2jNi3Y9qOA3
	G360zRQPgjtHndRsLsrmspdD4gEo6YzEIbUFF3vt9GKfQMLxD8la+eOGbZE0gpHssw37ka6xIIM
	gb53vQT/LABB63nPG17+z+oFdnU2Y0egBwJoX7D6FYdxLA==
X-Google-Smtp-Source: AGHT+IEbcyQe7XpHejxjDOXGd+NqRN+5zlpUdzS734x8KqDMINCTJIPGWCi6CEfM2jEoc6GpaLiKBA==
X-Received: by 2002:a5d:5f93:0:b0:38f:355b:13e9 with SMTP id ffacd0b85a97d-3971d42ae27mr14801518f8f.15.1742206813611;
        Mon, 17 Mar 2025 03:20:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v10 4/8] riscv: sbi: Add functions for version checking
Date: Mon, 17 Mar 2025 11:19:50 +0100
Message-ID: <20250317101956.526834-5-cleger@rivosinc.com>
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

Version checking was done using some custom hardcoded values, backport a
few SBI function and defines from Linux to do that cleanly.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 15 +++++++++++++++
 lib/riscv/sbi.c     |  9 +++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 2f4d91ef..197288c7 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,12 @@
 #define SBI_ERR_IO			-13
 #define SBI_ERR_DENIED_LOCKED		-14
 
+/* SBI spec version fields */
+#define SBI_SPEC_VERSION_DEFAULT	0x1
+#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
+#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
+
 #ifndef __ASSEMBLER__
 #include <cpumask.h>
 
@@ -110,6 +116,14 @@ struct sbiret {
 	long value;
 };
 
+/* Make SBI version */
+static inline unsigned long sbi_mk_version(unsigned long major, unsigned long minor)
+{
+	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT)
+		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
+}
+
+
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -124,6 +138,7 @@ struct sbiret sbi_send_ipi_cpu(int cpu);
 struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
+struct sbiret sbi_get_spec_version(void);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLER__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 02dd338c..3c395cff 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,12 +107,17 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_get_spec_version(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
+}
+
 long sbi_probe(int ext)
 {
 	struct sbiret ret;
 
-	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
+	ret = sbi_get_spec_version();
+	assert(!ret.error && ret.value >= sbi_mk_version(2, 0));
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
 	assert(!ret.error);
-- 
2.47.2


