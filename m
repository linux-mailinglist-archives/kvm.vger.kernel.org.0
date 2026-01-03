Return-Path: <kvm+bounces-66971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BA6CF01CA
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 710BB304638A
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA2C30E844;
	Sat,  3 Jan 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JV59QbbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E06030EF63
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767453872; cv=none; b=CjbKh6PpWri7dHgnc+DuBFjtrKZQIKGP3TF6zWEbPK+x4ULem1i8g7iHSH2gYI8OKf3wMHC5CA8miJSknSdLzro0sVi/bP4Prp0N3uYJYRKDb6sgrAGuzfVFo50wMv5/MNy1fWK6paEzVr/r9Nm0l/BWjoVocxSd9yeHHNaJaJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767453872; c=relaxed/simple;
	bh=66AeqSMa9PNTEYjXoFNL2B9ycnhwGzMh5GoWHyfpaPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BnI3m6geoxpQSuiia1molAyh+U39TWyvZ34xsAkmeh2maBwr1K5mxalU36clkQId1jeOy08CoiRMWPlrYo+0g3YuQ3Lqz8VN75ndqpdueTPTlq9A05ZXwh7dGwfgO3gwSeQUCtXyaSNctjWcWBz/Ni67Olj4N5q4NvZsbp9a3VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JV59QbbQ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a102494058so3052975ad.0
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767453869; x=1768058669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rY+1CqHRW6wgOOvSa/xPbABDm4UWS4wzkJXrx4Ok40o=;
        b=JV59QbbQhwEc7gBnq5kz64TUi+3ZEvih5i1UI12hRRn5fjsPoNKdpBo5Iu+khqPzFQ
         p4MS6RPso+WJlBHrcvxVRpXfYlK8Ya7ay6nZe6ahK+qJoH7KU6Ryd0DhZx8HKeVMvfbV
         bOzRFUYy67p//2H0bXm9fpGoJoTKnx7zueeY0FtptC0MbkvjLbixnk2mlt4bESrS4I8V
         zdfGSySE9c8zblXY8xSG+EGiY163Z06sxm8QHy16rzqgCyr/zP6B560kBF34fTgyYyVB
         9UKDaDsLMwid44D6keiC0h8h/iIwEV+fvZgA1M/z5GIQprF2oUCmgkjm+deSZ/3OEUVf
         Gutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767453869; x=1768058669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rY+1CqHRW6wgOOvSa/xPbABDm4UWS4wzkJXrx4Ok40o=;
        b=dx1gZvx2yHNFVkFEgUDPhWittx0iviS8VH7PGrciJpVJMSEVLnA1o3ynV8XhhqStYC
         RUJQiY2cEvQOQ/iGFIbrUvnshHl+HhDdTdWEDr9Ax3qwnq6CooDJJhnbE7sy4Rcfb5CM
         pz92984w8yW7v8EEx2Bf492V92dRpBLoCMpkc6C0jjtiY1rkaAUfkWgOqFcZMdXIxzyy
         0Mfvf9vEfuv2sUGfbNmcRkNn8Uzt5txFSjjz7PEtj6uKrn4kCF3kOO1NMjRgrJk9vnQ5
         XBuOUk20Q65F57ZYP/KmyhKLq6K7VU671yXmD9RClDdaiXZQOEicqZUIcJ08EWW3QWdk
         r5lg==
X-Forwarded-Encrypted: i=1; AJvYcCXYT7QvL4y055G1e3Kn8iF88HIge/JMB9N/di3aNiTuzufchdXv6DSSAwyiQx1ITSVl4pk=@vger.kernel.org
X-Gm-Message-State: AOJu0YysvhbO4peTafAI0n8pOXDTYqAK12axfA5NwXw5gfJn/flnyvCs
	hj5WFUrzwUo0ArgB5hRI9YO25qBsVEulKtRYdk3/y/4J5LlVIll6frxm
X-Gm-Gg: AY/fxX4fJPNjfyC7Fo0CfiNnNBLpH9g4C3fCTm2UNqkhPIY+z2rgtoarvdPtk/QYvx/
	rhO0vIsvc+jO4yzItxuR33XIHL+kA946kcs3eJKuDA+1giY0seuOloWo7CvBkq3w78wLV3j9VJg
	6mPHmpFhilNwh3LxHaCjn5F2EjH9oDTVfEk//kz03sptVz67YKSGxF7JvBx9ZViMPHCtsG4XBkH
	4HDfueORFgtmfm04vEqyB/+kxJjszK34Wej7687h5vy9CvFbaetnsJjv4AgwTHG+A8GAaFqDpTj
	xHyoLDTEahPFPyxO6wX9VD7dUyQjuKGRxzl79QN1wgRPG6bNp6aULXjNZEOJ838XgwBWHrjefUW
	DGol8GD833wdnofcD/RCplr8ZMgipxUsKsLP7YotAerPgCPkytPaYhz3EdPgu4OtUmewVV5279/
	0iPLPNKcsZAiHr0F+DhEREy32f7Rt1r9DJRd2L9M7Dt+jtuUwZCrlEdsWZZFyMc5uqj94NXTweg
	GI=
X-Google-Smtp-Source: AGHT+IHlp9HPsn8fm7xK5iwgx3KOKWhA+7VN2RCvm7LTYT1W4zfwOzZOihBwzvrzDg7BywoDL8XQrw==
X-Received: by 2002:a17:90b:3c8b:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-34f4537da08mr1903713a91.5.1767453869180;
        Sat, 03 Jan 2026 07:24:29 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f4770a256sm2107802a91.12.2026.01.03.07.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 07:24:28 -0800 (PST)
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
Subject: [PATCH v2 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 00:23:58 +0900
Message-Id: <20260103152400.552-2-naohiko.shimizu@gmail.com>
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
 drivers/clocksource/timer-riscv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 4d7cf338824a..cfc4d83c42c0 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta,
 
 	if (static_branch_likely(&riscv_sstc_available)) {
 #if defined(CONFIG_32BIT)
-		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, next_tval >> 32);
+		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
 #else
 		csr_write(CSR_STIMECMP, next_tval);
 #endif
-- 
2.39.5


