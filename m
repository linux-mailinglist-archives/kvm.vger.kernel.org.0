Return-Path: <kvm+bounces-37742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 005E1A2FC4E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D50E1881EE6
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1653F254B18;
	Mon, 10 Feb 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lMnD5CEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFE12512EC
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223378; cv=none; b=CPubRRSnNtsKgq5n1Q7D7IGuAWy6YxGtEhIdv2xtrQID+y2gicP8MIzCOrP/RET8+wugR3OqSRvDNvEzbsvXcRk/XMKCCdz8afU9FNkcC3+1hJu1Wtj+dMuL6jMR24VJe2JNbidMeDWEdxSDu3crQKAaIThDJ3AFflOJJ+7jxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223378; c=relaxed/simple;
	bh=B4l5ww4xM3ybuxVDnFD7O4s6SCugiqPi0tOYv0B/adg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kq3jBf7JKXHB2ps4NgdMK59gFQ0WK+dtHTDs0ocMb1UYiyMctv7BM0WWmw/gJJc8DmcB5FhrvUz04LpOTvf9ljswDbK5j7kSwK81et7uXj7Dh+tZO4mMqKE58w5afQaMzm0ZVLuN70nBYa9+AJfGB7K/zr1r97eGz6Gz7xBLv9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lMnD5CEG; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso10927395e9.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223373; x=1739828173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9Vwlc46bZsQyt2QxW9m2l1M9vTOam7Mm6HyDDfLEZk=;
        b=lMnD5CEGFmwiNpSSMeoO/Ijj/7bK4sm+7xlJhbqHB46ItuSs7YjGvWsRNeqtq+F7gU
         8kazmQuKtzPzM84J2JMdTCIwzHWHPsaloE3AvmZHNnJWFEoXLZThW1k9yI/DOJ4Uktgd
         SGkpLKKsF7mONDnKPyp4LDutV65sFEahCgvWLW4+PebcS780PaGFlyekCr6JPbc1qlGJ
         FfK3ftWt025K7F8L+t44FdUjC9hfnz0F18ep0z3epCdy7VdK62pAmapa1xg4kd+U1yHU
         XVIm6rUw6quQ/Y59o1zqZY0loMfzEPfUj03Rkz1/3XaWNPEE2sLd9KyEg/IFkEiL/EVx
         11Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223373; x=1739828173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9Vwlc46bZsQyt2QxW9m2l1M9vTOam7Mm6HyDDfLEZk=;
        b=uHoNktFHafZwKvVbwbzdNfvbtFhdMavxY5I6mI/IGMQZNG1JlfWb7aWSEv2zRQkK3r
         LiToLbXCSK2wg3TtekccP6Bo9hjrOMqH/Ih3jHIfifNkQxPua5Fi8vRVVnA5bART7Ksk
         KmHrV++fMjAUy2rb5zh74OTCRT/ucvx+NFCRA2BVvpkVDoVK7ij6CfN1c/5p9wE0CQW9
         SXAMnJn+dP6sPP00RDB7LIOaurfCUisEEjQlg82Mf5izczIgVT6svx7dwWLhreetpqU1
         VnXSEVTsoU9Tw58RxbYg5hnLs7N26LLZjV4d4dimTwb2dLzYnGIsrA+gwlMPgeShJfZ5
         cCsA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2y4cUwz9C9eY3rK/K2CSDytvJ5yu2XG9tRcunOWuXdpjjdLmyvnPbg140GLBfwyRWKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ7KlUPyY5vI1sZk4EL5mzQRhdH7YHOi8OiBvzQr5ShsESfphU
	P7TcZceOHYeBqao8c8oiErZ0SRkbC5Dj0kMO0U9BmfVx3vJec9WVYwssT7OvT3c=
X-Gm-Gg: ASbGncuRNBgBYGzz1aOEfh1vPqQM14mopeZaIvJMmkXd34fNr52D5tqQKimW337bq03
	uU6csy7pqLWmPYO0bRsBCsY//yuEQ9w1ovh7y0KD41SbJ8Ck/jUCYSCfhFJg/e2mdZO2Ig8eRSn
	15BFXLwlJ9faoU640i2cEnYxDZn3AwuaE5F426OZeG0dlvte6HSY0MzwQJg9uaE2H1mR4AZyOo6
	oEaFMuX/tVdwrc0rJ2MKaw0cQ+NyReo4/V9ixWK2jY3aHFsz6W536KAFpYXugHjwQvaCkC8SS41
	pnmzsYZ2KfQeNP46
X-Google-Smtp-Source: AGHT+IFIy2UHszvgSyStziow4xh4NgDeIiWhARHb24tahmr62iRvzSTuU8RezdSX8BLezNfYx/izdg==
X-Received: by 2002:a05:600c:1da8:b0:431:5c3d:1700 with SMTP id 5b1f17b1804b1-439249a7534mr117351975e9.21.1739223372921;
        Mon, 10 Feb 2025 13:36:12 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:12 -0800 (PST)
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
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 07/15] riscv: misaligned: factorize trap handling
Date: Mon, 10 Feb 2025 22:35:40 +0100
Message-ID: <20250210213549.1867704-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

misaligned accesses traps are not nmi and should be treated as normal
one using irqentry_enter()/exit(). Since both load/store and user/kernel
should use almost the same path and that we are going to add some code
around that, factorize it.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps.c | 49 ++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 8ff8e8b36524..55d9f3450398 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -198,47 +198,38 @@ asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_regs *re
 DO_ERROR_INFO(do_trap_load_fault,
 	SIGSEGV, SEGV_ACCERR, "load access fault");
 
-asmlinkage __visible __trap_section void do_trap_load_misaligned(struct pt_regs *regs)
+enum misaligned_access_type {
+	MISALIGNED_STORE,
+	MISALIGNED_LOAD,
+};
+
+static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type type)
 {
-	if (user_mode(regs)) {
-		irqentry_enter_from_user_mode(regs);
+	irqentry_state_t state = irqentry_enter(regs);
 
+	if (type ==  MISALIGNED_LOAD) {
 		if (handle_misaligned_load(regs))
 			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-			      "Oops - load address misaligned");
-
-		irqentry_exit_to_user_mode(regs);
+				      "Oops - load address misaligned");
 	} else {
-		irqentry_state_t state = irqentry_nmi_enter(regs);
-
-		if (handle_misaligned_load(regs))
+		if (handle_misaligned_store(regs))
 			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-			      "Oops - load address misaligned");
-
-		irqentry_nmi_exit(regs, state);
+				      "Oops - store (or AMO) address misaligned");
 	}
+
+	irqentry_exit(regs, state);
 }
 
-asmlinkage __visible __trap_section void do_trap_store_misaligned(struct pt_regs *regs)
+asmlinkage __visible __trap_section void do_trap_load_misaligned(struct pt_regs *regs)
 {
-	if (user_mode(regs)) {
-		irqentry_enter_from_user_mode(regs);
-
-		if (handle_misaligned_store(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-				"Oops - store (or AMO) address misaligned");
-
-		irqentry_exit_to_user_mode(regs);
-	} else {
-		irqentry_state_t state = irqentry_nmi_enter(regs);
-
-		if (handle_misaligned_store(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-				"Oops - store (or AMO) address misaligned");
+	do_trap_misaligned(regs, MISALIGNED_LOAD);
+}
 
-		irqentry_nmi_exit(regs, state);
-	}
+asmlinkage __visible __trap_section void do_trap_store_misaligned(struct pt_regs *regs)
+{
+	do_trap_misaligned(regs, MISALIGNED_STORE);
 }
+
 DO_ERROR_INFO(do_trap_store_fault,
 	SIGSEGV, SEGV_ACCERR, "store (or AMO) access fault");
 DO_ERROR_INFO(do_trap_ecall_s,
-- 
2.47.2


