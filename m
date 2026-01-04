Return-Path: <kvm+bounces-66990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 92790CF10D8
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 15:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA8DC302424A
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 14:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBF31DF963;
	Sun,  4 Jan 2026 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVbZsM+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFD8176ADE
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767535218; cv=none; b=OLDI/eQZLs10QkXsCOG1yo46QeGrGMjfeBMSxlmjVIJlfvYmtrcD5CQ16j/hqUQVH8N/4ypMDTwKjDnJtzCndCe1jeiICPeRD1+o8PR4DxXISlt6kDYNJja+sEkQ7tKUYAvj1g1k1qyBEbEXJdvvq02R07wqU/Zq5EpIWy/Omvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767535218; c=relaxed/simple;
	bh=mlSQR4TVYtAE0buXP9RYEyWgOci8JJdg/d+zuqGHUyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H918KAmZA2UhU74YKbR7dbyjgW3gISkff04kdHzXEr1+xwh+5/1jAN8CptWQJOd3M3u1izv8Fes+s5grW1mg94p8mrCddD1UFj++dcp2ZQhxJ5r0Ppx4EK56pLlvb7BF/NnfB74vTDzNTor6s+Yczops4wqbuz6WPKMAtP8UY4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVbZsM+Z; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a081c163b0so119898065ad.0
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 06:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767535216; x=1768140016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKWm2q1i1+0+Z99C46AW9QGvFUwK/OoedXO5dcU1Nq0=;
        b=PVbZsM+ZxySRgWr2PXMWb4HWo2nXoaJteP1W8TTtSMjyS5toiOqepYx+Jl/H2/SoMW
         iPHO0L2/b/qTnqzkH944xJMHV4btG99IkjcA3b1af2KR9UyUH5vY+1xt/HFXTRCe4HEZ
         hpSZqNhs/c8B+4ZepOUlNIdgvUkZ2GOHTEH3zbvNolT3Xv3+mICRB/ogTa7zN1K5MafE
         putf5FipCywIbXeFLq1ZsV9GAQCQooTO/VqQCSq1Kh2KDaM7dOwdQizAjXK+OkLCNhQq
         YOJW5lUARQN71bLI+Okq1hNrxIoBufVg910eiXpwma/ZyNnVeq0C4kuHeOEVEEg1vJg1
         o+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767535216; x=1768140016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WKWm2q1i1+0+Z99C46AW9QGvFUwK/OoedXO5dcU1Nq0=;
        b=O4WmK66xuaJvn563PdeYRR6eJMrj5BHPAdyUD7TXqxL8v6BYPa7TL+07EZbTs8bCbh
         a2ZvZBfK1TTUCZ24fq8rMRdCPSotkdDSEvICUuTG34hvlWrwzVwoN/7BoGDrGScLpSEa
         S5cZsbQLrKyuTzhOrJolwlON/tLbqkotq4n6PsyoqQYGkP/iRwDn11HPoz5p1IqjwJ3E
         R20nAyjM6+nDMYESWtx9MYkE4KLZDG8+7DNochLRPmr3+eC0qwsRxpfwG/99xLmd16x/
         fscr+S8IuvpXjSHTlOU7EGrlmAv6XVPqR+Sa42f3yX4iUfLrY8YJJck4ZWe0qH33dbvJ
         /riQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRKvPF5UgEn+Xqyoph4S+Cd3fwAnBWkpr/iJ+j57IgSbWNfqpqVtK3zDCKWGiZ414KVfk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3IZ8xAp3BqGXJgI4GdihRu7M/ScDCQP9fGYkGV2DEL4S9eTKK
	SJW7OfcR3ayHYhcZ7Uwb10S2nHti9F4fmQBMG0vFWFCsm3ZMDdc2WdfO
X-Gm-Gg: AY/fxX7nMmjuKb8hb9EdcOEABW7+ms2wIe+CCTxPr5cYweJ/So1qxr2JnnnLLyBkIP9
	tyrMaT2HmB7830Huw1IB6op80lqT5c/Bu7kA5JhXhZIs8Hyj3fCnZgaO+eIJfVfkVvrOV/XOWVw
	ZHvKvRBu+eifaxLJFNsD4c1zXuSoPDvZdNd564bZk2pNh5J2E+OvgCvtEludv+CYxwW39FD/+W9
	FeAyTq85Flh6ED0SKeIw72u7q0yZmhimdM228bl/KNh1y1/lWMCKlPbtv/lxknYHbC8BsUp2NFD
	Stm5zhsOaiXPHYrI+A4y8hAMkHxGXjhtNour3AUt9n6xo//rq3+l2rIwBUS60Qu9c6m5sY9Prv8
	P2arzZn9y3OMKt96g87SFBCfghPcKL1AVreAG+6KM4ZvhFDzDkGvnyYqVZLv3vIgnhpOca8rXXn
	8zB/S3gefVTULFnqtugy9vFgptfbGaKZF9NiAfI5UxDqTBYT9YF6oi4ur3EzebxofJ
X-Google-Smtp-Source: AGHT+IFmQkAn76a6jPoUFSWskVsApd4EjT9EaQS9Lmch2wXWsdjxCu1JoZ0JGs1XSVlb+dqOkzOctw==
X-Received: by 2002:a17:903:32cf:b0:2a2:dc3f:be4c with SMTP id d9443c01a7336-2a2f220d883mr423015965ad.10.1767535215342;
        Sun, 04 Jan 2026 06:00:15 -0800 (PST)
Received: from localhost.localdomain (g163-131-201-140.scn-net.ne.jp. [163.131.201.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb25sm432327535ad.56.2026.01.04.06.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 06:00:14 -0800 (PST)
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	daniel.lezcano@linaro.org,
	tglx@linutronix.de,
	nick.hu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>
Subject: [PATCH v3 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 22:59:37 +0900
Message-Id: <20260104135938.524-3-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260104135938.524-1-naohiko.shimizu@gmail.com>
References: <20260104135938.524-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
separate 32-bit writes. A race condition exists if the timer triggers
during these two writes.

The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
recommends a specific 3-step sequence to avoid spurious interrupts
when updating 64-bit comparison registers on 32-bit systems:

1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
2. Set the high-order bits (stimecmph) to the desired value.
3. Set the low-order bits (stimecmp) to the desired value.

Current implementation writes the LSB first without ensuring a future
value, which may lead to a transient state where the 64-bit comparison
is incorrectly evaluated as "expired" by the hardware. This results in
spurious timer interrupts.

This patch adopts the spec-recommended 3-step sequence to ensure the
intermediate 64-bit state is never smaller than the current time.

Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
---
 arch/riscv/kvm/vcpu_timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 85a7262115e1..f36247e4c783 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -72,8 +72,9 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
 static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 ncycles)
 {
 #if defined(CONFIG_32BIT)
-	ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
+	ncsr_write(CSR_VSTIMECMP,  ULONG_MAX);
 	ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
+	ncsr_write(CSR_VSTIMECMP, (u32)ncycles);
 #else
 	ncsr_write(CSR_VSTIMECMP, ncycles);
 #endif
@@ -307,8 +308,9 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 		return;
 
 #if defined(CONFIG_32BIT)
-	ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
+	ncsr_write(CSR_VSTIMECMP, ULONG_MAX);
 	ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
+	ncsr_write(CSR_VSTIMECMP, (u32)(t->next_cycles));
 #else
 	ncsr_write(CSR_VSTIMECMP, t->next_cycles);
 #endif
-- 
2.39.5


