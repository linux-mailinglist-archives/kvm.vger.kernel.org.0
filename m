Return-Path: <kvm+bounces-23546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3AE94AC8E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6901C21C99
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E525F8172A;
	Wed,  7 Aug 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xe14NimC"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2933CD2
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043805; cv=none; b=eiO3CI2cmgFWOlnvmMTC0xJpiJAb5C3H6bYkLpo+0P5Fe5qqe/EtgMHYeXQbzTuIx1hl0PHU2qgCrhiuDWN23W1ATrdQ1HNmtoqO0WoZ7MTdfV0+rkYTNUKHeC6UrY2yZTNm9XOtKXuvvm6abp5w2gpOK5AgjdMqDTTo5CrYwxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043805; c=relaxed/simple;
	bh=OCzcILnatO63fu7xVVBWiTzczPWuhH/aBHOPFwJ/2no=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQsVvGZt1dNMriBppnjcV3lR0YUIjHhHUq3qZuCA3cLvtXC41sMNTYB3xqT9zfyX5XWy0jIswdxfB3No6ub2xH0DGNKGNa/yYuptbRneBK208a8HCoPraWOWupmUPX4+ebpXpTOoMq1VWmQAEhI+r5BlfMFPXqXnU+IS6dauguc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xe14NimC; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723043799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bzbBRp8sXybiEAUAaGR7WsoeXBEA1TVvkm4o0DEGpuU=;
	b=xe14NimCAJuqXkTAiK9ZW3LQlEBeDvOU9/vWUaJVST2F++S0qsfXnB5NAyMiQ9C7AAQ4k9
	U8fGnUXbWvehh2q9Q6o3/A9tO63eK3rf9v+ArW+lmyiyUSgQDqr2HAQWKMOC/8DjTdJ5DT
	uJrUUOfcJK6yTLY6MgEos6Q4ICvCx58=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/3] riscv: 32-bit should use phys_addr_t
Date: Wed,  7 Aug 2024 17:16:30 +0200
Message-ID: <20240807151629.144168-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't really expect to test 32-bit RISC-V with physical addresses
larger than 32 bits (at least not any time too soon), but the spec
says 32-bit RISC-V can have up to 34-bit wide physical addresses and the
SBI testing wants to pretend like there's a chance the high words may be
nonzero (since SBI calls require high words as parameters). This series
ensures we use phys_addr_t where it makes sense to do so. The first couple
patches are fixes for issues found while preparing the third.

Thanks,
drew

Andrew Jones (3):
  riscv: Fix virt_to_phys again
  riscv: setup: Apply VA_BASE check to rv64
  riscv: Support up to 34-bit physical addresses on rv32, sort of

 lib/riscv/asm/io.h |  4 ++--
 lib/riscv/mmu.c    | 32 ++++++++++++++++++++------------
 lib/riscv/setup.c  |  2 +-
 lib/riscv/smp.c    |  7 ++++++-
 4 files changed, 29 insertions(+), 16 deletions(-)

-- 
2.45.2


