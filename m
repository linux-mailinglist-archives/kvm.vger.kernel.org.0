Return-Path: <kvm+bounces-66991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 857F7CF10D2
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 15:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8AACB3002D38
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 14:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FA819D092;
	Sun,  4 Jan 2026 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwd2jAOx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B072AE99
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767535221; cv=none; b=TYsR2QgCzqPoeeg3UowI+GsJvy+60MxuYWUzCP7eF9mVefoBpOPPVG0lZ9njtKAsfHbj4LzJTEOCw85yNfAYcNkdYCHG8Ikm5gF031K1UfzyyqyEqOGS/ggUR50P1An+sQjlGRNfahD2zUWorjhNeYzc0rQBNfqADzD40PrPVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767535221; c=relaxed/simple;
	bh=smLKmAbNA+Lg2DxKtUMzNvxFdylFJ6K1oRlbE5gn/dA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MyIdqgLP4YyQy9iSq6p1QnzxDW2yWfGnkpOD7fXo+GgPNrFNCR3EPDFe3a26QlUw/8lWRusURQNcJFC6iGTxcZfofDK+y+whVcmvb3ouBgBPLkSXad8bIG5gJjedoH95iMqQG3kRa/Hzx0yq0ua2gGRne6PrcIwL3Tvu3CPCKkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwd2jAOx; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0bb2f093aso133559685ad.3
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 06:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767535219; x=1768140019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqmQmaFNmFjEy7S54wIHblwNMJ9e6UGwg3T65EY/Hjg=;
        b=hwd2jAOxW2xI41oyKa1XRrSNjRbA/Y/Vlo5XdM9e0RSYwP3h4R8K50TU1sbNfDOKnu
         +D+exPSq0RT0Eq2Bn8MOOjvD2icR1kOOaIMQe5b3VgbzJbHyF6WLzJtY1Sj7kSFh3/gl
         qnf9KdkaX6TqTGCv15TUTS1Zf2U5VQgs5zPMMV6ThS0Ut+JXWHoXSrOGqmu2QC0Vdjdy
         uHQKned6gexHGgF311kyycSgqSdpRrxlGadAXL5lK6ZOcXefa2Mq2iSdZHYS7Wno17GU
         CRXVY+4+WeyQnbfAtXzn4ndTxbBL/b/z/3Qt1Aa2HUtjvFXjjo50/H5IMfSphw9F5kNa
         NYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767535219; x=1768140019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qqmQmaFNmFjEy7S54wIHblwNMJ9e6UGwg3T65EY/Hjg=;
        b=ZqxZPul3IdnkkcVnNFpR/XaE4TU7THtAKfyy+5f0Wr3SdSgZ2qceo5fbcSzF1NSJYm
         3WcTyZNGD5+5/4/LTO3ebvQvq+u22OAHrr69bbuBhWpF3EpTGjYnYWQUYKqfKyZFOWZa
         xR7jCKE1urXPm4XXxZPQmDP1GBHJzfqa5IIhk9DeT6Ys36aQggTArftWVrVF7fgM5puR
         VYGSk0ni5zyF7urQ1rm8HMjPmy2C/GAh6+bhCGHg0xszZ0UNuH4fXnVj8ysDuhfhSOGx
         iYbSDU8M3ftwvCpYz2RqVn1mpfbxeb7qI/PnEtWU1WzHAN2tU9pKlUrAtqoWOGQG62xl
         cbXA==
X-Forwarded-Encrypted: i=1; AJvYcCUpJJkB4IMmQot6+AtMaEzGpiO2sEIIsT5tf4imaguV7X3VrTX2TRpG47J1rWaiZens6ks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3sfhkOd5kkfqCDZf63Yd03k0JnGyG1Uo3GEbJqLpOPXvNJ1Y9
	vARYCg7N5XdRpGi8SnSA+GK1bSLa+Hq2Na2Y6arUA9dCnlr3r0E8ElL6
X-Gm-Gg: AY/fxX5GpwBLfwWCMr0fgJx/L1V7QM2WGCZBZP5t4DzAPJUUpbORL8TLlZmwAvoIjGo
	IfIJ9rFjOBXziA2/sTkMh0ZRu6zR4SSk/if1DLWpgH5h3aynRAURLUNR7FinvMZx1jdmiv9U8+G
	WgQCwdChQNBfxyBVDAbRjfTsdzLHqE7QNXAPQVZQaUBC3L/W7PxyiPfTWVPn3KnSna1RMD2rfB7
	r0QPnFKcq6SZbCED1gXB4SVgMCUluru/sQJXZZCJuSL/TJGeJsWy+YEuMHtWMHLASW+XDten20i
	jhynU5s4hZHsuf3Vgpgd0PCPMes34UAQwqBArbBRXfe9FTtFUK4uQebIIIwaTBcr7EiAXBJLIsU
	lEci0WBeSBzDL3v38SuOdY5lg6MXXRJwLK23HOqd/rM1gu0kDWqrupLi2ysPoiTIT0c0tz+WKve
	cYtQCcvC2FfQixHcUTpD8vGRpzcUHwUBIrpLq0tPUVUZPIosKksAsdwJ9/dR5p4mWl
X-Google-Smtp-Source: AGHT+IFF0zPQhAdEGQIhG511RClUe4pVQFBGTYZnIh7qDrj28ymiDIGxnpivMIor8szJu6tv6fbZ2A==
X-Received: by 2002:a17:902:f546:b0:2a0:c84f:412c with SMTP id d9443c01a7336-2a2f2a3be72mr478366475ad.57.1767535219101;
        Sun, 04 Jan 2026 06:00:19 -0800 (PST)
Received: from localhost.localdomain (g163-131-201-140.scn-net.ne.jp. [163.131.201.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb25sm432327535ad.56.2026.01.04.06.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 06:00:18 -0800 (PST)
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
Subject: [PATCH v3 3/3] riscv: suspend: Fix stimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 22:59:38 +0900
Message-Id: <20260104135938.524-4-naohiko.shimizu@gmail.com>
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

Fixes: ffef54ad4110 ("riscv: Add stimecmp save and restore")
Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
---
 arch/riscv/kernel/suspend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/suspend.c b/arch/riscv/kernel/suspend.c
index 24b3f57d467f..aff93090c4ef 100644
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -51,10 +51,11 @@ void suspend_restore_csrs(struct suspend_context *context)
 
 #ifdef CONFIG_MMU
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SSTC)) {
-		csr_write(CSR_STIMECMP, context->stimecmp);
 #if __riscv_xlen < 64
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, context->stimecmph);
 #endif
+		csr_write(CSR_STIMECMP, context->stimecmp);
 	}
 
 	csr_write(CSR_SATP, context->satp);
-- 
2.39.5


