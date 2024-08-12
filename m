Return-Path: <kvm+bounces-23845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AEB94EE94
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6A5FB23F1B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1F617C9FE;
	Mon, 12 Aug 2024 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mqSj+LJJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61B1183CAC
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470299; cv=none; b=iKaJ2MqDBcStfUeMO0lzo5FE2RX9Q96Lc805OpAASPF2LJT4BUIuVoPKvFHhPxfh4hNeBU9Qz2NOhSwZcS4NkZ6xdiYsNiUeqsUVZoasakV5sWa2LLKhNqe/WFQRg7mm5xrs5ssxdB7G6AR2c9LNh8e6kaFEdNKNxe7qOtbUuRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470299; c=relaxed/simple;
	bh=OKbm5I6QJDVw1IuNrEW632i7TI5l8AwPzYErEnFdXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bdWpJuR1ddtPt5xlxQV6M3+HZfbVLaTBBNHyg8gCC3YKGnNkRE/73K+9skxcLwM3EJSg8g5TP1kzkcHTnzQGaFpduLjVxV70IxpnB6Gc3i+H8HfNk221lJ/8HE/UXqfWDGpjltUhwTlUCARIEoNU9BHmY65ODx10KFED+mt/r0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mqSj+LJJ; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=72Y9eaiGhN5FJ+yCar5srGHK6/EE3RZuTyHhJAi3Dio=;
	b=mqSj+LJJiuaid86w6Eok6G2yX5h2z5qyJKyvrZ3ZerL8mmDEf4jnZCqe7mdmVy1ThXOXWd
	zEg7c+nrYT1uIebHJFiOXr+Wq1r2ov4H3bp01xfOHu6LJN1bQshHJVij45AccQFheFBi+U
	Eh4iINex2lOLwjHoOHNem/nevomREE0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 0/7] riscv: 32-bit should use phys_addr_t
Date: Mon, 12 Aug 2024 15:44:52 +0200
Message-ID: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For v2 not only do we use phys_addr_t where we should to allow unit tests
to pretend like high words matter on rv32, but we actually get it to work
by adding a few more patches. Some new DBCN tests will make use of it.

Andrew Jones (7):
  riscv: Fix virt_to_phys again
  riscv: setup: Apply VA_BASE check to rv64
  riscv: Support up to 34-bit physical addresses on rv32, sort of
  riscv: Track memory above 3G
  riscv: mmu: Sanity check input physical addresses
  riscv: Define and use PHYS_PAGE_MASK
  riscv: mmu: Ensure order of PTE update and sfence

 lib/memregions.h    |  1 +
 lib/riscv/asm/io.h  |  4 ++--
 lib/riscv/asm/mmu.h |  3 +++
 lib/riscv/mmu.c     | 45 +++++++++++++++++++++++++++++----------------
 lib/riscv/setup.c   | 19 +++++++++++++------
 lib/riscv/smp.c     |  7 ++++++-
 6 files changed, 54 insertions(+), 25 deletions(-)

-- 
2.45.2


