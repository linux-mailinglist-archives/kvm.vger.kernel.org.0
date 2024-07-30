Return-Path: <kvm+bounces-22583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 491B094082A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AA791C2298F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982CA18A951;
	Tue, 30 Jul 2024 06:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sw6P6wH3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974216B39F
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320309; cv=none; b=mK85o95Op4jkHf5tnhtO53xVwbciQDVN1b5tNdn3h/0YoGx/wcIOnHEHvgcdRvw3CDxD0supwutmaVeRbTwtn1Q1/b3H7bzuTdglyNLcEZx/2a4a1K4gixDebcJ2HDZfYRvLJGTeYMbNJRtMQfNrAK7Qex0yeYCkhEc6G2X59h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320309; c=relaxed/simple;
	bh=EYU79rvSPOqD6SNRSV0A//mBxw31vR7MJC4BCG/+Tbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W/u2DS+OzmsZhkNrBoQ+fO+4c/Hwjump8PzsVxp81npQmD5zZ6JVhvLeq2FmsrZxtnkbzOYiF4RK+8DEiSGIR9E7Lq6Lf+w6wD6Ivb+MC7euwXUuUCbBXXXHkVx6XWKBj1QdTJwS/4P4SHN9396kMdtYmRDcIdoZeOwjWfvzjIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sw6P6wH3; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7163489149eso3075214a12.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320307; x=1722925107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=24nePhLp8mZKML3Q2ug+oSc7JTP3rQZADXmYTif9x44=;
        b=Sw6P6wH3S6hYdD55W+qsvpk6cijIaQViyjKYjvioTEqWklhZyGfz/8r39nimCCzCML
         3THkW0OW1SB163Z2DmF71vPRpHa+CjLg1W37W0THWQsIbRc69amM/eXMadk7OLAgsn1I
         rrispyfwzvPbNMAiiNLxUW6imZ9qShEuPhLCiJlQlm8DiLbKQlaf2L1K7pLijWJLYPr5
         pc1XLfPRliNm+ASlhvHaFIsraKqpMplnuIuKrylUsqe2cI2zIcum2CTk8KEoug/JcUTC
         NQ8cnyN0d0o2eIFGzwHtAGdJRqKJkUg5476/BIBDKEipeyMqAggOD379ufBKoTqBgGwj
         PDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320307; x=1722925107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=24nePhLp8mZKML3Q2ug+oSc7JTP3rQZADXmYTif9x44=;
        b=Mb+5c8b9F5qX4P50DDisYA8sOHpzWAaOrgAEALmwdvE9209ClvUz9cCDyOHoRhUtze
         gc3hMXIuEaC7k9h8fk0gvGDk7yZHZv90vDbldpcdIXQuFZntTBPbWaLxs/U6rftju3qN
         6Wt/y2Cx8Bb2uKnB6WHNhsMs+2HRmNlg94HPwmLQJBq2n6PH5yJ6icXpUgRFUMs+6HkH
         /OAcelcWtVHRSbpFoBuShKN+XRF1tVgu0PlnozoTOV73g/mmZWKiVdSz2HmRP2XznIrY
         2nA4fjsmMe+gegP8S1blUKg14EUbSPF9NWYk3pO0q1Xn16aKhp4Pj4kynMLfgC+V3UWV
         VVhA==
X-Gm-Message-State: AOJu0YxUPUMMZPg/nTImZyR5dCmMCWoPXMGWI9YuiQiQSeZA5RGGn45x
	++p84a4k+rx9deIg47vND7GBNEIW2GKw5zLYY6aSZHeXSbIEcWczPwFe2CBTuE0=
X-Google-Smtp-Source: AGHT+IER7yIjkKgPAUQNwQa0DpQdD5Ko+giTovrwEunU+4zct8tBkODIxHfDEuMr7sFzTc60VftaxQ==
X-Received: by 2002:a05:6a21:339d:b0:1c0:e1ed:1e9 with SMTP id adf61e73a8af0-1c4a1178e4emr14705676637.6.1722320306653;
        Mon, 29 Jul 2024 23:18:26 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:25 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 0/5] riscv: sbi: Add support to test timer extension
Date: Tue, 30 Jul 2024 14:18:15 +0800
Message-ID: <20240730061821.43811-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing the timer extension as
defined in the RISC-V SBI specification. The first 2 patches add
infrastructural support for handling interrupts, the next 2 patches add
some helper routines that can be used by SBI extension tests, while the
last patch adds the actual test for the timer extension.

v6:
- Addressed all of Andrew's comments on v5.

v5:
- Addressed all of Andrew's comments on v4.
- Updated the test to check if `sip.STIP` is cleared for both cases of
  setting the timer to -1 and masking the timer irq as per the spec.
- Updated the test to check if `sie.STIE` is writable for the mask irq
  test.

v4:
- Addressed all of Andrew's comments on v3.

v3:
- Addressed all of Andrew's comments on v2.
- Added 2 new patches to add sbi_probe and the delay and timer routines.

v2:
- Addressed all of the previous comments from Andrew.
- Updated the test to get the timer frequency value from the device tree
  and allow the test parameters to be specified in microseconds instead of
  cycles.

Andrew Jones (1):
  riscv: Extend exception handling support for interrupts

James Raphael Tiovalen (4):
  riscv: Update exception cause list
  riscv: Add method to probe for SBI extensions
  riscv: Add some delay and timer routines
  riscv: sbi: Add test for timer extension

 riscv/Makefile            |   2 +
 lib/riscv/asm/csr.h       |  21 +++++++
 lib/riscv/asm/delay.h     |  16 +++++
 lib/riscv/asm/processor.h |  15 ++++-
 lib/riscv/asm/sbi.h       |   6 ++
 lib/riscv/asm/setup.h     |   1 +
 lib/riscv/asm/timer.h     |  24 +++++++
 lib/riscv/delay.c         |  21 +++++++
 lib/riscv/processor.c     |  27 ++++++--
 lib/riscv/sbi.c           |  13 ++++
 lib/riscv/setup.c         |   4 ++
 lib/riscv/timer.c         |  28 +++++++++
 riscv/sbi.c               | 127 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 300 insertions(+), 5 deletions(-)
 create mode 100644 lib/riscv/asm/delay.h
 create mode 100644 lib/riscv/asm/timer.h
 create mode 100644 lib/riscv/delay.c
 create mode 100644 lib/riscv/timer.c

--
2.43.0


