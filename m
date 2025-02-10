Return-Path: <kvm+bounces-37741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA15A2FC4D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20D0A18828E0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70739254AF5;
	Mon, 10 Feb 2025 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ITFlHvtE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB075253332
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223378; cv=none; b=B05fZNVBCeBO+9UqKBtwunkjk6cJLUGahsDn/gIf2ptUhio5s/EDs9j0RZM4h8MdTHzh9bPNKuh+qkoj/THhD3fhHi6X6rZqCS3BWmKSGb9ZDVV1ynprt1xO+ydsSJKKgGqhkBhP+PJFzcTx5y5YKYZtvuZ1NiH6x+BseM7zHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223378; c=relaxed/simple;
	bh=o8LicozigsBJPUxfw0UjH/+haPfd2EDEodthfJ8bhLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jgd260PRAOK4hra+NqY0TcVncIUBGRZBBAFn6ownsnQ6WDZmaWnObDoTxhw89kPSPtSDJFFVr/vquw6eiPsVetO3dXdvJP0zNGRL3OEj3ndwI+FJEp0jevqGsDMzK0SHVz9CjxS9vf4CiD235KbqqWtRaxmx3U8unyil3nignvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ITFlHvtE; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38dc9f3cc80so1290647f8f.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223374; x=1739828174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTEMNxwWUDdJDHTSWR5BaYosnBDapUg7Ev6g031TeV8=;
        b=ITFlHvtE9yI34d5cje450muBPt/uRI0f9R13H4R0RygM0vIL/8Xr2ysMO8unqgYTbL
         ilwAb+1ia1vprAdNB+fNCPkd5qonAVLvZVCX2Br8Fm4V+SoAaOpCsh54e72jSUdPHbes
         01iBiW6k0H/dIX1t0423EJjcZY8OqljAgf5P50pxRi+df2jBcTN5l55YapSlJ/eQfrld
         fpZsQO4LG/uT2O9nulvkbEDsd/2M9frh9SU3Zle1aI5iz4CEWzdSQMHonhxzL8z1n+SK
         pVAJHfF2Sc3cPaED4zc52foMO+cuFm7Jt9yDbI7D0QtcjgwQcWUtftPkuVEJ828wWWuh
         gHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223374; x=1739828174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTEMNxwWUDdJDHTSWR5BaYosnBDapUg7Ev6g031TeV8=;
        b=mz0W0gSmoy8xZGhTeD57ChIkKf5mwpLeft0tf0jRnTIZ69qIv2zNG6cCvALFzH1uPO
         S6VIuWPPa5rkqHPHE73v3E+YpVzPSF3lkfI7tFZQEbeBm8T86s45hkoAHfsTLVq3HzOk
         lR7CKeqVky7vpuSEf9cr+RbOm+SYflQ6j1x1KchncoZjTVPc2lqBo2Z/nJ1VVGhhg52m
         5kyxu8Db4ZTLpFZYJBrcrlYBS/MyI/pCkuZHBu0Dj/62sxZeBSqtVxDv0aY+k4UCZxKh
         4YB9a4umHHhr52u5o7ItuVgWJLkt2ak1Yzz020HgYZKeYDEH3FF4FY95T5++0HC4Epbj
         dCWA==
X-Forwarded-Encrypted: i=1; AJvYcCVyllv2YX94DvkP8PsR8vRbgnXJ9vo0dLIzRWZ2ZwwIJfcAkMyvdtzB4RehTDq/Mr1PK54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz3liVXKDvMQzGwzgvF54Sq+xHHtaJBn9X98RnSGrbrs/gRMax
	8g9x0VktRWIf/QEHMf+7D5tnP/IrNkQWvvcwA/3+zyicJiJ9UXzjAmIJiHJ9vlo=
X-Gm-Gg: ASbGncuISDXdySCzFp53RA2Xq3kX8G8/tPJ/CxgY/KsVzbQWoZHjPn6m8yCohIhUjPI
	EqbCIeOKNunpnvjf2RigHxjnKtaZUseJF1OBwvTRs672fPx+jYaPvKukWR0irY6c93KMeBEZEuT
	c1oPnhJibIRRhuwJkC014B6QX9BUYcbnyIhS9CrtifVLpEC4tPHRleJrHLZwpYZ+4RNwADE5pn7
	kiys7zDwtVb1yGLRAw8PuDK5H7fFee0PlRaJSKTDzybXJXpIIaF2+Ow0DmXsosUI2eykIpe/KUn
	3Cdx3JZFCnueHVKG
X-Google-Smtp-Source: AGHT+IFeyF81bBn0bup3UjkgQ031iOdpi9/jVXiALJpdAtVQDgUVud0mvsDq+oa8j9/bPhnXjupeow==
X-Received: by 2002:a5d:5552:0:b0:38d:c2d7:b5a1 with SMTP id ffacd0b85a97d-38dc8dddd9amr9308427f8f.19.1739223374260;
        Mon, 10 Feb 2025 13:36:14 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:13 -0800 (PST)
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
Subject: [PATCH v2 08/15] riscv: misaligned: enable IRQs while handling misaligned accesses
Date: Mon, 10 Feb 2025 22:35:41 +0100
Message-ID: <20250210213549.1867704-9-cleger@rivosinc.com>
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

We can safely reenable IRQs if they were enabled in the previous
context. This allows to access user memory that could potentially
trigger a page fault.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 55d9f3450398..3eecc2addc41 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -206,6 +206,11 @@ enum misaligned_access_type {
 static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type type)
 {
 	irqentry_state_t state = irqentry_enter(regs);
+	bool enable_irqs = !regs_irqs_disabled(regs);
+
+	/* Enable interrupts if they were enabled in the interrupted context. */
+	if (enable_irqs)
+		local_irq_enable();
 
 	if (type ==  MISALIGNED_LOAD) {
 		if (handle_misaligned_load(regs))
@@ -217,6 +222,9 @@ static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type
 				      "Oops - store (or AMO) address misaligned");
 	}
 
+	if (enable_irqs)
+		local_irq_disable();
+
 	irqentry_exit(regs, state);
 }
 
-- 
2.47.2


