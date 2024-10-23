Return-Path: <kvm+bounces-29512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 064249ACB14
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B20A41F215B5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8861A1AD9C3;
	Wed, 23 Oct 2024 13:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BMe3gApH"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB201ABEA7
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689696; cv=none; b=O6755DWExpfRw+6sgXmnTElHaAjflu0rCrnZApqgl9Rta5aBaAzGBGyNL+JZY+wwDauyuPZBulanW0Uaz1kmRz3UP+6cPUWWgvP9eTn3/CVdB+h8L4FB67wHV7TvGw4/0KKRhb16ofIPFn0wGGa6wbG10Nb8omR4ktSX7yyxiW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689696; c=relaxed/simple;
	bh=DgZLeGNuLyT65tOkTKimAZXabDQCcjq7GyL6/exoJvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=saChvT9GAXnyRD286OUgmD+IBulSfKDnLJPG7IWI0GYkukfgKyhP6u8mJCCChucQy2E8Qs1VOK2u1nKFpfsGa+6dxH5vu+rAHEPjGCbE1mOfAr0mhZEemTV9rX16EQvoJB+Z2I8puW+ZFO7tEeRBt+uvsxG/FySFCdL6zZCbBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BMe3gApH; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZWAge5DwWpyd6zDBAXhwrsb7ZOmrngnHmH6FH9aj9r8=;
	b=BMe3gApHxER/v0b18qrEfrX9/Vxy8hKbZkuS2SVATk/jkDjOoGyPC1rvsIWXrVHIFl8reP
	vr0LeT9PPoU9t8r4txmHGIQLyHDNtlg51hFkeGj0dcKFZEXXWhITUXvf3E8mvGtuRM3P3s
	jnYR7Wb3e10sXXwB0eAqfWXSlFR1b4E=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/4] riscv: A few SMP fixes
Date: Wed, 23 Oct 2024 15:21:31 +0200
Message-ID: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

tl;dr - these patches are improvement to the riscv framework to better
support the SBI HSM tests.

The first patch is a simpler alternative to [1] and [2] which doesn't
require us to decide how best to make the number configurable. The
second patch just adds sanity checking to make sure we can expect the
SBI implementation to accept all hartids mapped from the present mask.
The third patch was already posted once before[3] with a slightly
different summary. It and the last patch improve smp_boot_secondary()
since the SBI HSM tests were attempting to make workarounds for odd
behaviors.

[1] https://lore.kernel.org/all/20240820170150.377580-2-andrew.jones@linux.dev/
[2] https://lore.kernel.org/all/20240903143946.834864-6-andrew.jones@linux.dev/
[3] https://lore.kernel.org/all/20240904120812.1798715-2-andrew.jones@linux.dev/

Andrew Jones (4):
  riscv: Bump NR_CPUS to 256
  riscv: Filter unmanaged harts from present mask
  riscv: Fix secondary_entry
  riscv: Rework smp_boot_secondary

 lib/riscv/asm/processor.h |  1 +
 lib/riscv/asm/setup.h     |  2 +-
 lib/riscv/setup.c         | 11 ++++++---
 lib/riscv/smp.c           | 49 +++++++++++++++++++++++++++------------
 riscv/cstart.S            |  7 +++---
 5 files changed, 48 insertions(+), 22 deletions(-)

-- 
2.47.0


