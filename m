Return-Path: <kvm+bounces-36768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7218A20BD4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3A1A3A32CB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10331A4F1B;
	Tue, 28 Jan 2025 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rVMol1jC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223FDBE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738073787; cv=none; b=pw5qAWsGPrnacgL2m0GEkNXTkS7XiW2NVpg1gTFoflTJV2hacwljCzSXxj2wGq5SCK8l0gfu12jzsj+vE9zvmpFqluIq88Iyn1TwJEDmrdm57UNPQPnGhO95DHocxJ4Fhk6Nw1LeV+A8HJnwgqZiIoGG2HEzcWCD5X9ipqnnM8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738073787; c=relaxed/simple;
	bh=nV5yvxOXL+Dmgbe6958RbHxwS1sRYWqTC6dMuwDr3GE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nmT1CBy/lCF1SVFiKoyAnNWKbQvmV8vo1FVngD67z5nXvrZLDU/10QRQCWcJD/Hjqy+W2z57al10HXBuO5HEDrpaMIu/bW++7mSV7LT+9DJgUlKgJkGAMoD2RTkErYzP5yK1IO5g90N/sGErDZJqWSHJVqZO8nJCIbc6AkQjtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rVMol1jC; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43690d4605dso38456975e9.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738073783; x=1738678583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=affeeBrgh4ORX38d2oGXA54lH/oPzlNyTsePW0I63Z4=;
        b=rVMol1jCFgbbbUBXp4fjJNB45V4vF5YZ1bzwNiGow/tRkggg8FXhdvBasT5ZCwKsmo
         B3Bsa+WJdA7KMHMh/VIyDrmR72006PLj7NkoHszBJIKZ5CHXwz7dUZPt3qr1IoiTD4AI
         QWorBWdZaoshpb08i1mxQ0XsxkpcuO1rKch9zPhofYVTbBOKVxPS8EggGQlbzUUp380N
         yrEgGwhQ6pMDh9Hl3THEZ70/kkL4G1u758zfkeWKzp+Yp43TAsCpQvHrEZi4oyiPd41E
         w2sJaWpmfPkuPaRZwun76kKh6Re3+swboRmgHYg8o7QYlL6kBwuvvZfeEu+jHlRqTv+g
         v7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738073783; x=1738678583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=affeeBrgh4ORX38d2oGXA54lH/oPzlNyTsePW0I63Z4=;
        b=QG9f4v96cZKcRUBvchxnGthFH7Xk5NAKHtQIhebsog6dlHYdeaiU4W/eDrPH/JLDV9
         FFrenq02bCzgeiJh9bBAHQqriPpSYwSm2W2+rAoEHBtHnhNEQhWitUMi/QIpsk43KWk1
         3uE8lt5dLMDCm7PBvkTbIPPdO4r3aJe67jCt7hQtC7vq3pVYYsDzuI2s9Ck6aHFJoUU8
         4JHc4GsIBGVPbSXE6BRySlD5L3fc3WzcRd7L/5UQeYZDncql8EIo6AILqBrF47c1Y/AD
         ZckrR+lKx41douo+XnjDUjnsLAq+Hc1pzkjR/4nQN89JcGoQxg41q3J4dvbItCLbpp9+
         05pg==
X-Gm-Message-State: AOJu0YwVzMREvSNDWA5wCoDrFAY5jq/+RpRDp/qF5ArGpdNVxnvCudzM
	qbj1pWcC9kjNH8z6owKZCtLa6AZp+VFhENbputT96/OYEpgbEl97LNLGRuVOhWXDrcI0pS6ylXO
	F+Io=
X-Gm-Gg: ASbGncsUPz4o6gW2QzA7aHpQ8NJqR7BAhilW/LF7SRj0lMp2/Gjhmc816EExVc7sOvn
	8cGOQMSozfeS20tKEJVDTRZy5nvHNiQss8aJe1BAlCrkWcKNCdlsn4cIMBwOHDvYhl2U1Hm2x/a
	Vs4fAExXVwVuZ76u4Tm1+6ji5K7caXGXKmWudP+oXJnoataMMcc+pL4cPGVtV6dBMG9qtFTwUTH
	poZ7Y/icyTn0hzwQ5g1GapC1BWv7bROVeWCaN8d8fuUJ96RlJMJwmB9RbPzfCf5g7uNr3TG9X7N
	j7A+KTA0g3Wxzlnu
X-Google-Smtp-Source: AGHT+IHtVj6Pq44tPaAWtdP99xnUKZD6nDdtqS+LHs53TT7+RI454gvtIJUV4uw4jyVc1HKtWOIXhA==
X-Received: by 2002:adf:f402:0:b0:385:f7a3:fea6 with SMTP id ffacd0b85a97d-38bf56628f0mr33487958f8f.13.1738073783085;
        Tue, 28 Jan 2025 06:16:23 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c402esm14435772f8f.97.2025.01.28.06.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 06:16:22 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 0/2] Add support for SBI FWFT extension testing
Date: Tue, 28 Jan 2025 15:15:40 +0100
Message-ID: <20250128141543.1338677-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds a minimal set of tests for the FWFT extension. Reserved
range as well as misaligned exception delegation. A commit coming from
the SSE tests series is also included in this series to add -deps
makefile notation.

---

V3:
 - Rebase on top of andrew/riscv/sbi
 - Use sbiret_report_error()
 - Add helpers for MISALIGNED_EXC_DELEG fwft set/get
 - Add a comment on misaligned trap handling

V2:
 - Added fwft_{get/set}_raw() to test invalid > 32 bits ids
 - Added test for invalid flags/value > 32 bits
 - Added test for lock feature
 - Use and enum for FWFT functions
 - Replace hardcoded 1 << with BIT()
 - Fix fwft_get/set return value
 - Split set/get tests for reserved ranges
 - Added push/pop to arch -c option
 - Remove leftover of manual probing code

Clément Léger (2):
  riscv: Add "-deps" handling for tests
  riscv: Add tests for SBI FWFT extension

 riscv/Makefile      |   8 +-
 lib/riscv/asm/sbi.h |  34 ++++++++
 riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 232 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-fwft.c

-- 
2.47.1


