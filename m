Return-Path: <kvm+bounces-25272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83608962D8B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5A051C222FE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E921A3BC2;
	Wed, 28 Aug 2024 16:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qppVa1oU"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DAA1A2C16
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862129; cv=none; b=EZ7kU8/a9FzBHKPvVjzkBso28OADq44/gQ9bt+Sw0DGcIe/va46RNqc36AUzWWFlYRw9jZe4nQWRP8sKEw+t5BOGX6iry5pgSSXOGSOCwOOQ/2+alwJVTp6pHPrIrDBNozGLEx29+/3CVM4RmGrnE1oYqen95LPT2+mTOxjOP3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862129; c=relaxed/simple;
	bh=op8tgKlw6PxfilzQc16gLL4Uyi5FveP7/vwX2qooka8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iuaIDnaJH2//fxGTZu9p4dPykNlxp+y8Gzinb7PWZtGGRqIql6v0hypnLT9TsBMxA0619CPas6mpW5UrRWwyuSmZkObNtGeXGdxqSpFTkBAtGYOI+Rbn42eC1lSMAr6bdhoek6tXPIuX6hpAG4spJwnZW97STOLA/mvR+kHEl/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qppVa1oU; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724862124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gbAAqlkkSkEx9hntJRg0mXNL2tRLxhiR2gRjV7r9a3k=;
	b=qppVa1oUorSKKGmyrhhEFEri03Ra2BedWF2mPZ6IIw2qUnaLMP6V3W0AfItklkTPzvHpYZ
	qUaBYdx+SeGz2usFM2gUuUqD8d4SxSVCZrupV2rylmS46UcwLmdjp4OQxxezksUMSFidx0
	Awr05F65noWI6EFglsmRKDasT8qButo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/3] riscv: Timer support
Date: Wed, 28 Aug 2024 18:22:01 +0200
Message-ID: <20240828162200.1384696-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We already have some timer / delay support but we leave a lot to
the unit test authors for deciding what timer to use (SBI vs. Sstc)
and setting it. Provide an API that prefers Sstc and falls back to
SBI.

This found a bug in QEMU's Sstc that I'll try to find time to fix.
If we start a timer with a long delay and then stop it before it has
expired, QEMU still delivers the interrupt. The only way to avoid
getting it on QEMU is to disable the timer irq. The BPI, which also
has Sstc, behaves as expected though, i.e. even with the timer irq
always enabled we won't get a timer irq if we stop it before it had
a chance to expire. Disabling Sstc on QEMU, which falls back to SBI
TIME, also behaves as expected.

Andrew Jones (3):
  riscv: Introduce local_timer_init
  riscv: Share sbi_time_ecall with framework
  riscv: Provide timer_start and timer_stop

 lib/riscv/asm/sbi.h   |  1 +
 lib/riscv/asm/timer.h |  3 +++
 lib/riscv/sbi.c       |  5 +++++
 lib/riscv/setup.c     |  2 ++
 lib/riscv/smp.c       |  2 ++
 lib/riscv/timer.c     | 46 +++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c           | 18 ++++-------------
 7 files changed, 63 insertions(+), 14 deletions(-)

-- 
2.45.2


