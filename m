Return-Path: <kvm+bounces-19878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8029990DAB3
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C224B236FB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8B0143C7D;
	Tue, 18 Jun 2024 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCdwp/zC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86E91304A3
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731938; cv=none; b=sEqG1mMQPdPZrXXmLjkbSd/BaV1+Ije+G9NP9dK1MZu5tRMFNFmjZE9oHxgaHC/hA0iSWKMaSrB5WKWJCoBlT4iL6zZJbdDXmQTjjmzlA2chQgQu7dd1D6H+yRP6xNULQz0LhUR/P1yksy1A2VVVtAxGfShU/oPDHDrrPY7tGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731938; c=relaxed/simple;
	bh=o+IjckYTKM2m4XRX3zT6LEPiyHDyEC4nRWkC6iwBhjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0is6X6IJ1EujVwS4VrvENo2i5TRA9tL+YT4snsm5uXPCc9iEp4ht7yvjJzN8d9Ijb+7cziz9pgBJJkmCpdx7DnJVfwxnTGkP42jwaIGAcVRa50LKaLYmpsgnmnobA2oeymdr6rbvKpVY5zvbuorQtucNLfVx1ODea3ear2tyBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCdwp/zC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f6a045d476so4481868b3a.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731936; x=1719336736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AHkQkvnEJGJQcm9JOuvQiIjQ3vgPLErsVo+lxlWJgig=;
        b=CCdwp/zC3M6CNJGskaoZsji7kDIpZ+3rTT17ac6Pg6OZPMjDxLF7qu4P+bM5mE3bMO
         KgbRHNGxtzzUCveilKaM0dUimUSLAKP+8bLsJphfjq9HIH1+foWvrLdCGLC+ZAu6FpEI
         q8EzLXFnjrKTOAomvhYVNW5JgmIbZXN6ztFdLEvfLUAJRC28JBd/zI9DPPMdAiWkHRL/
         0Ej5Gl2j/U7mcuZuhL2ql+NJMfzREGAnhmh20v0Ga1PHiyD+QALtpBWGjfT3S9bpPhtl
         apipCX5a7BlzAEU+iBF4SJql4FjLYAdEz2/m8NUoUrCpZ/AwE9rUAuFm7JeEyobeCD7l
         q9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731936; x=1719336736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AHkQkvnEJGJQcm9JOuvQiIjQ3vgPLErsVo+lxlWJgig=;
        b=s9R2wmUQ9pUxCZf2roGUlym5GVZkeAdhxWB9EH9YEVaJHSRzq99DvZmNL6N0u8SIj+
         7rjw2PaaHNdrX6QiUfd9dsVGHDlvBpTtD36QxN+a+O05s/FoTrUx3B2yJ7sShRERsBZH
         K6rVpbGDPoeV/OrlrKQnmKg5ya9w0VBm64wL3DA/YPbrHjTvRUqTEWrBWH78QiOytJ58
         0CqJAmP192kKNaFIVLwubwTaX32fQTv4cFVa5EseiG2UArtUqt2UN65QfAaE7B9XtZ4q
         dLQdP4SI5zkixZZYxHi4ut4zoR5reZ2wctR6N3Kgm4xHNvBwJ4W8LfF5Om9nVWuo8+Ur
         SlYw==
X-Gm-Message-State: AOJu0YyJfbw3O92XCEwMslZSuaCGX3ybaLPpVlhjUZghuf6YwdcSf5O5
	cSO4GnyAsyVIMVSuZV9ue8U+DkJgZSCbgvU+mL2mepmaFy+Cm7Fmrt7T1QY1
X-Google-Smtp-Source: AGHT+IGNpr17javtgMjTB9N198Pw8dHXa4VE+KUmezCnRDwFljNpm47kl3RPHWnYDO2QLlEOGP+iPA==
X-Received: by 2002:a17:90b:a02:b0:2c3:e8b:e0f8 with SMTP id 98e67ed59e1d1-2c7b5c98302mr388512a91.20.1718731935510;
        Tue, 18 Jun 2024 10:32:15 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ee5a5sm13529305a91.17.2024.06.18.10.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:32:15 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 0/4] riscv: sbi: Add support to test timer extension
Date: Wed, 19 Jun 2024 01:30:49 +0800
Message-ID: <20240618173053.364776-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing the timer extension as
defined in the RISC-V SBI specification. The first 3 patches add
infrastructural support for handling interrupts, while the last patch
adds the actual test for the timer extension.

James Raphael Tiovalen (4):
  riscv: Extend exception handling support for interrupts
  riscv: Update exception cause list
  riscv: Add methods to toggle interrupt enable bits
  riscv: sbi: Add test for timer extension

 riscv/Makefile            |  1 +
 lib/riscv/asm/csr.h       | 30 +++++++++++---
 lib/riscv/asm/interrupt.h | 12 ++++++
 lib/riscv/asm/processor.h | 15 ++++++-
 lib/riscv/asm/sbi.h       |  5 +++
 lib/riscv/interrupt.c     | 39 ++++++++++++++++++
 lib/riscv/processor.c     | 27 ++++++++++--
 riscv/sbi.c               | 87 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 205 insertions(+), 11 deletions(-)
 create mode 100644 lib/riscv/asm/interrupt.h
 create mode 100644 lib/riscv/interrupt.c

--
2.43.0


