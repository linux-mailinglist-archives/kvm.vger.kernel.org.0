Return-Path: <kvm+bounces-40669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CAFA59981
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2E313AAC31
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8920823099F;
	Mon, 10 Mar 2025 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="phyKIH0L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366DA22E3FA
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619644; cv=none; b=WQFIQ9C9vO1NsWTV/eI4so0rRmPMyyiHrapEmullq2CdiQq8QoyHXtlDzBZ8y6X3FuwnlA4t5E3RprJqzs5iy4ACODXYe+Yp9q1S4xTNQzYlXY8RI9wVzuPT4kHby2aGlepqR7yDA7JzhK7InoCKtwwhh233VybeTJLNxCGo4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619644; c=relaxed/simple;
	bh=B4l5ww4xM3ybuxVDnFD7O4s6SCugiqPi0tOYv0B/adg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6N/X8UwZJOgZS6Jdv7x8MxQuTeitRbHJ1N3xUZcqP4E/7jSyGR7e2hzW8XC74uE21hVeU9/s4TTeOiwmCb2EucR3UO6/3pKM2Mffd/ppDMg1TRezYKZaQ/l1udAS0hsEjGU7WxXu9eNjV0HOEL7oFmwn9G0yaKyZbC/j0t4RpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=phyKIH0L; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224100e9a5cso80779745ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619642; x=1742224442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9Vwlc46bZsQyt2QxW9m2l1M9vTOam7Mm6HyDDfLEZk=;
        b=phyKIH0LB85yJ+LguS7wKtU89NW1nV7XXxzNvx9aR+JVuimcTKgh1gW7BD+Qb8tM7P
         kFXzFlnt2iMQJMvrt1wmretsUcNW/Q3G4gIovHKC9kYALAIw7xGZiuFLoTkjgXipYm8E
         whBOyPY8lGh/D/lRk0QpQJAsiOWhpGvxFvpwYsy00ieeJUFDbWxx9gsJgxbI7j++ANhY
         /IzdOnBb+m8CsqYjjuOgIwoYfGdb/9KNs20lvaFsJGK7wYtpSGjFVi5ffjaFDIQ1eoEo
         9Sxqf7E+iOFYsuB8xshlSYOrRX5lms7JPrfx1rNBagNwCLap4PrKxSoxtI+h2CF5jCnl
         wYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619642; x=1742224442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9Vwlc46bZsQyt2QxW9m2l1M9vTOam7Mm6HyDDfLEZk=;
        b=l3wO54jj0QLTnCQ0njBbJcf2RVwggwMDaPV5Q1Vw2DgLxkGQ9hvk0Gujbi/9V/pmNN
         jzL2igOntcGipGbU2MSCggo7wWCo4ROR5Gzd5af84TdU8lDsc+/5VtUrneDqoPSEmdYS
         72BqbEWbxVZWSgaaFoHr+PaVAGOYFk+Hh1iSOlgIq4gP6jAPNDAymGU0flyhg5QZ6hNQ
         dsIHzKGbvWVJQgOXo/K6tqBV5mbJ4FBfgf2T4ko0PnuX5L5DeH++lwdFbmt9yNSO20TX
         GLa6TmOR70LAvO3ClvQXT8t7bCQXKcHjkTsv1JExOeg3Nfzw8rJNOm6zkZlecGP9Xdj8
         msBw==
X-Forwarded-Encrypted: i=1; AJvYcCXCVqCRB0Zt3B0/Qy+IXA2DWF/V9Co9IiWSosExIPwD/3XM5iOq3PXtbLyHKNhOd7r+BUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzY3xHKCOK+zUTMMeDF1J0K8nI46paAcMmyRiW8oLrF1mpga4t
	EU1mjG40u9/RWrLvdLOGjMDegGn7YkeFANc6lXbjMjkHEByAU9s6TeYniJBlcy4=
X-Gm-Gg: ASbGncsloxeeapej27e7plUBJscGXt4UoIIoMNhjQBRFS13XnPyohH3ztaiibPiL3Il
	sn1fEvkMVHmnhVEgeLNW3qDz9IPldJMaIAohaIj7pYGzWRJlo2tfCqJxESUK2zLVrbrrPqI1hLG
	JtpR6CRbKvYKzK67bS25EThnJd+0iRRc7f9oTqRD1D4JkZCxX/bQ5BDVPvO9OEt0ZCCQU+ASMAH
	19B/mQjHjNoH9aFyrbtxvrZEbjmvnMBrX9rhggqR6mUuzuU1tS36Uzcf2laSb5ftyNND9dvmCOn
	Vp2YVg+zVMZIkwWmNx7LbHYrNFjLriNjpniIXx2o+c+x6Q==
X-Google-Smtp-Source: AGHT+IE/Wftdkd3zlZdL/ywUH78DLaDAVcrFF4WfEuA9Q1JYQZM9C8xhDZMPOQ9HkccIr+uMejIbbw==
X-Received: by 2002:a17:903:298b:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22428c221dbmr239345965ad.49.1741619642512;
        Mon, 10 Mar 2025 08:14:02 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:14:02 -0700 (PDT)
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
Subject: [PATCH v3 09/17] riscv: misaligned: factorize trap handling
Date: Mon, 10 Mar 2025 16:12:16 +0100
Message-ID: <20250310151229.2365992-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
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


