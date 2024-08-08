Return-Path: <kvm+bounces-23635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD2994C1A5
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C6A21F23895
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3418818F2D6;
	Thu,  8 Aug 2024 15:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pGIVHZ+Y"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F119E18F2F4
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131750; cv=none; b=NRdpYCnjcr6IfH62/B8MxPfVyhq3Jb2cT8S/xGHfZRBBOKmbG0k1Dks7wNQim3fkmxjM654sYOX9jYRviI0k/Mv/+NUBvI8hn69vj01maHRsSfYsS9Trc1XrhWLhqtCs3uGn554BUtlF6+FdGkR3tfKGTAc53RTQxMshdFQmq+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131750; c=relaxed/simple;
	bh=yyS1asuN9QC+MVBR6e4UOnJEch6K06W0kjI9LS2Fenk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jk1zw18JE9LOhfIGUVz9KxWW5oh1A9YNui4NHNNYQzSQB6F0oPgz3fPDc6RB7e/DtR2DYZwq5tFsuNEorgZU6xzoGVwXS+btzzVjthAC/ooV8MxJzGNpdC1UmPNrLn6jVKziO0DonmBa5G+lDsVO4yeNbnBV90N9ZJgMuwKh8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pGIVHZ+Y; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=35ViX2P13ptNPHdHiexWkYROJBgxLth+QieDSF/IaJg=;
	b=pGIVHZ+YVaT6+y8KQOfWdnzXqnrMzB3Irk5apZSwkTE7FUUkwakzQ7ASvPHuvWJTiCGfRZ
	TsnTlzTuo1Z5HG/bw7hdYZqQ4jMa3iXZbnZIPYKJEsvCa2PfUgHkPLjVigbJj2foy2r9x2
	7EVrW7P6ovHrDSwqXmcL14icCsN4W+k=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 0/4] riscv: Extend CI
Date: Thu,  8 Aug 2024 17:42:24 +0200
Message-ID: <20240808154223.79686-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

So far we were only building and testing 64-bit, non-efi in the CI for
riscv. I had mistakenly thought Fedora's riscv compiler could only build
64-bit, but it's multilib so we just need to add some CFLAGS to get it
to work. To preserve building with a 32-bit-only riscv compiler we need
to introduce limits.h to our tiny libc. And, while adding 32-bit builds
to CI we also add EFI builds so now we test 32-bit, 64-bit, and 64-bit
EFI. And, since Fedora has been udpated, bringing in a later QEMU, we
can now do the testing with the 'max' cpu type.

v2:
 - *Actually* test out-of-tree builds in the rv32 CI (I was missing
   a few important lines, like 'cd build'...
 - Add another patch to fix out-of-tree builds for riscv
 - Added some indentation in the new limits.h

Andrew Jones (4):
  lib: Add limits.h
  riscv: Build with explicit ABI
  riscv: Fix out-of-tree builds
  riscv: Extend gitlab CI

 .gitlab-ci.yml | 36 +++++++++++++++++++++++++++++++-----
 configure      |  8 ++++++--
 lib/limits.h   | 43 +++++++++++++++++++++++++++++++++++++++++++
 riscv/Makefile | 12 +++++++-----
 4 files changed, 87 insertions(+), 12 deletions(-)
 create mode 100644 lib/limits.h

-- 
2.45.2


