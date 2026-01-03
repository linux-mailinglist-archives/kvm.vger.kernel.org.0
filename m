Return-Path: <kvm+bounces-66972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9D0CF01D0
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D08F6305E3FC
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D3F30F522;
	Sat,  3 Jan 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K3P6EBuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818BC30E848
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767453875; cv=none; b=jRilCbpB069ACR4n36I16PUeHdINc3MdGA/Rwvp9d/bDEFIL1kcSlKlh0/id2jilMxgQnlCFIBdECzMRfslJAugYNqBlPOPB/npl6AAeGC27pdpEF5mBgY/RhSeWh/NKeg9MaBfFdNMRYuSWiMecNrDlpt1Mg36jkhZ/oM/L91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767453875; c=relaxed/simple;
	bh=7eJ6OYjTg8naQ1BSuXx/9safQEXenDmq3eBCbZ6CO0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H642dHLyly5JUtQW07ZE+rEj5RyELmC538Di671dEp2uT7W0qxFSDB1VB0NGK/qnwFDRNE034ZjgFnCdfEFDdaOpiSZ7guw4eYqMdxJ5lpltrHFxw5hnvJZBHDYCCbbajtrRwzaZg/5vbtk3pspaMNkyMQtqL7KLBHA7nCr40F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K3P6EBuJ; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34f2a0c4574so3239283a91.1
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767453873; x=1768058673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbTfmd3NSnTt9lXFsPx3VDeaOg/UBFYzN+h8hVF3FMQ=;
        b=K3P6EBuJdKh4NsNhxOdih8wAEyeO61Xf5RI4WjmqxUZ89FtT1oxadcKDOYw8Bm8FFB
         JgIHWnTY8ZuMmqNhwwC1waErrDDdYzeSnX/xCA8pv2jlwuzknrRSbfxwG26L7D3aKO76
         O8geyOHL0c7I5MrQLX1DyVFEZ5aD0Hgk7r+5Pk9vRdHAcRELrYqL4oD8LJ7S9yYgVfy9
         2SM4ep7nNZpt6d2ciQlnhDYKE2rwwZu+kF78q2iqLjSfNwiyh/3ZhWNQqiLjPursOLI+
         iDqjn2+KZk+3xbh7Rc8i/lU7OgKZhIBgJJO/9djkgdcOI+UpijEkqVeU7AbJr2Ph/nP0
         LUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767453873; x=1768058673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZbTfmd3NSnTt9lXFsPx3VDeaOg/UBFYzN+h8hVF3FMQ=;
        b=dd6y99g9xZK4q574EkEbCHpC7tOf89QOkAB0yQjxgUsnXt6BFyGjEWlh4LjKMe8JsD
         JTE17Lr/Iq/lX3EUn95Hi03i2BFnyaOBo/kzddLTCcdscEoAqSj2Hvptqqvo591zB4Y4
         v7QxQpxlZKt1kXR96TZ6tt2yGmW6ho7cQ+7KcMWAg41YiqoRo/UnAUAInbANrxCBRFdx
         a7UK04ewuOoHK4gqPBQvFnDLxqgRcP1OB8mLrIXFunD1ZnW37t7YJUNTeHzGTbxe1lTm
         c68ftfVGLgTMryTtAMZFjnvSWLXT6KFZiAMlGCOi0b6iUtQA62+cmu4KlHkjQezSaHMt
         R8Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUwWqre5aaaNKKgw8BOjOX9P1Opo7T7armzr0YSJ4iqp1NAPRTQrel5fcM2ztxfOydD12o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkPYYxAXLp2M1+MEWyRgYzKHluwvwWNFb11knyLgyz7ucFFu2J
	2Czf5eSTjMX8tYYLhw4LaMdxH8BccARiJAA/Gxhs+8qa5Xl8vM2U/dlD
X-Gm-Gg: AY/fxX4klRN3R7dmSPzKvmRaLLaHA+vZS8MXFoK0cFwYbQ9WmxUDQ7TibYe7Z3loXmb
	YFNxSdXD9l/YgEsi+JPYNuYjIAz8CP3mkYc6GNKqzk0bgc3CwzcFrltN3dkHvSEQHxJealc4lH8
	HSoIFD6DJuGIa+rrcSL/Rq1YsC8i6UA8mpQcUPiRXJP5xxonqQt+nzrD61ubvwl8TQkyFSD4dif
	x1hLs/7PfkIOZ8l8RJ0IFbxvdIQvCZZuDVX1p3Foa3BrMSqPTxzLOK2QrolKD0LnvOPd7wa01C/
	chRPtM28tQCu3X8fy9BLOYSSjtiQKV3lUT7ZgVhWrT/AsuxBC1z6NjUnkPdx/566GV0wekqtSXm
	HfBnPY/bpg0MJ7Q5lr69DqEpv12PERW5kfCmKtjEqC1mBxIJaIET5Pw4dZ3ehXggeOSWOGu1d+I
	N9NDuxen6dJ3DMVN1vWPnVVfBEhP93xCEr4wVru5XFpuqz3wGGpFDu6M3Bzin7GB6C
X-Google-Smtp-Source: AGHT+IFAqFIt8xnOvelgL+iXx2mpTPUOQaCU3Q7/FdJxFlUC1bycD0YxqtWt/Ab1RF9sp9aze5LfoQ==
X-Received: by 2002:a17:90b:4c45:b0:34c:fbf0:fa55 with SMTP id 98e67ed59e1d1-34e921beaf0mr39991715a91.21.1767453872679;
        Sat, 03 Jan 2026 07:24:32 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f4770a256sm2107802a91.12.2026.01.03.07.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 07:24:32 -0800 (PST)
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
Subject: [PATCH v2 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 00:23:59 +0900
Message-Id: <20260103152400.552-3-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260103152400.552-1-naohiko.shimizu@gmail.com>
References: <20260103152400.552-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

riscv: fix timer register update hazard on RV32

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


