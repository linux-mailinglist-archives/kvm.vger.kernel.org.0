Return-Path: <kvm+bounces-32424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8ED9D861C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B902CB29357
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E670816C687;
	Mon, 25 Nov 2024 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xfTorT1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72330376E0
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535747; cv=none; b=LDwu+h68rfpColRxZ+kx1Srf2svxMznmnHXionOtZskqLNfwzroDshcZuK9nHQxR1QuWhbq1YpEF+vcrKd4qx1HjnqN5nGS7BN79u9qgcQC/Xgkp85OmNekzSr20Mq+MnMUptJGJakvQ+6PpUlCoOlJQfdL7bKHPIcbAe2saCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535747; c=relaxed/simple;
	bh=mdgN82C3wfeqNSR4fY6DwHG8qzHAJQamjwY8crLIj0M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=puEaNI09nzr9biHuS0M0nO70Sd+JJNQdRp7naJWLB1EKaeW0jkL2D4R27igpY4PglpCneN4XMFqO2a343Ns7mSKaF2R3Izoxs0YCCnm75WBydU0bzRjVQ14Rpr3o9b/B4vHl5jxPcwLfZrCWqni0RZAjE3GOJjMwA5ltmkzI/dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xfTorT1t; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3823cf963f1so2704753f8f.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732535743; x=1733140543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5eQyiH1a3h4VU7cWijpQcNhZ2sAGuclXbkzlbPisVcY=;
        b=xfTorT1trkeo9ux/3Nhblniub1VMqhTou82DjS9BeKYvdevxr/08G4Kym2gEn4fZgv
         R4kg/lQVucT9U7sEa3bm/lK1kgRDDQa3tR/wHpIC18INptr/lk+M9reTHPNStlvyYPPQ
         oWObB8a3v6ErivLpSWwQG3UlaYfOjCXLtWHkZQ6FU/rGU9ul4WO70EQL0C7aptYLgZGY
         XywRvL5n801luneWSkk5JJh4ZRKXps4L5FniCZFntWogMJwN9YRBfRx1ZvGg80GzvE2+
         /yXkPn/BNwmyvtEqaQTK0tkPkJB5Na+wJnGAhGL9yrjjpCmyjpiLhtfAfKXzU+QFdG4F
         7SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535743; x=1733140543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eQyiH1a3h4VU7cWijpQcNhZ2sAGuclXbkzlbPisVcY=;
        b=FJBo/Qs5UU4OKfKCniKXHG/uPwmnxvkHvfMJn1i4xquUx1KnYYirRrHMgpv46BpQS7
         qbGKE6KedZDoal/kKUt0WjlsKRRIp5BNL/5YP2QmgwkphocNbmV4xCHfwHLhbV23jPuq
         yYNX5rNIIP9OJacfXbnigTR57osyjOM6GKAErr6erNRZHF1O6JjCe5OxFQmdQUiZ1a2z
         uB9P3hlkbOsTzIc3IbaZpQd8cm9ro7kfSfdw46eZdVWvcs8k0Jfmu3XjZwTqGKxQfRTQ
         ueRbtW047mFwixIPoOfsvTPmoYq5RWplu6HrmphtIXHqT9kZHMTBma3RPEPo9qTgj+Yr
         O2gQ==
X-Gm-Message-State: AOJu0YzjWlFq1lgLPYkaS4F0eOlL3xCTDrfc5qSqLQ4qvWVWiZgCAGGz
	tENGUj3Z5VckT95td/zvZa5ZONLkRIdkJvOOiY11yFKLzQfRV9Gdj1wBYCiSEVD9WpLgvFKwTl+
	a
X-Gm-Gg: ASbGnctP5sMHvPY/OKja7+iJeDfcdBTQigi8oyET+sivPeXFPahS5GetuMw1Iu73L1x
	pPmJQ39N1HaxUUqQa9vNT9/D6MWSD4/X0HtojAhbLCmN79LCRinIN5NQ6LOxn/4SlGMBqgEuol9
	WbBSIR5Q2Iyo8gNMDVL4GP65CKFV5JZfLOZYE3ZVgHkUZugJf8gvS2pnzm2HUFPqRYirC/GtMSQ
	oBg8kNjpCYfLcv4HyYpu7EmaJlL2snwRzRZR274zO6aBSPS+wo=
X-Google-Smtp-Source: AGHT+IF7onHDJrQcdr1WtqC0tYleyl357WjaCg48KACkSd/jIdX+dpwZinBEWQbW02eE2+QLxUUC4Q==
X-Received: by 2002:a05:6000:188c:b0:382:3c22:e894 with SMTP id ffacd0b85a97d-38260bcc585mr10071477f8f.37.1732535743242;
        Mon, 25 Nov 2024 03:55:43 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3dfasm10546938f8f.76.2024.11.25.03.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 03:55:42 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 0/4] riscv: add SBI SSE extension tests
Date: Mon, 25 Nov 2024 12:54:44 +0100
Message-ID: <20241125115452.1255745-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds an individual test for SBI SSE extension as well as
needed infrastructure for SSE support.

---

V3:
 - Add -deps variable for test specific dependencies
 - Fix formatting errors/typo in sbi.h
 - Add missing double trap event
 - Alphabetize sbi-sse.c includes
 - Fix a6 content after unmasking event
 - Add SSE HART_MASK/UNMASK test
 - Use mv instead of move
 - move sbi_check_sse() definition in sbi.c
 - Remove sbi_sse test from unitests.cfg

V2:
 - Rebased on origin/master and integrate it into sbi.c tests

Clément Léger (4):
  riscv: Add "-deps" handling for tests
  riscv: lib: Add SBI SSE extension definitions
  riscv: lib: Add SSE assembly entry handling
  riscv: sbi: Add SSE extension tests

 riscv/Makefile          |    9 +-
 lib/riscv/asm/csr.h     |    2 +
 lib/riscv/asm/sbi.h     |   83 ++++
 lib/riscv/asm/sse.h     |   16 +
 lib/riscv/sse-entry.S   |  100 ++++
 lib/riscv/asm-offsets.c |    9 +
 riscv/sbi-sse.c         | 1043 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    3 +
 8 files changed, 1262 insertions(+), 3 deletions(-)
 create mode 100644 lib/riscv/asm/sse.h
 create mode 100644 lib/riscv/sse-entry.S
 create mode 100644 riscv/sbi-sse.c

-- 
2.45.2


