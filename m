Return-Path: <kvm+bounces-23622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A7C94BE1C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DA028A04A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BB818CBF7;
	Thu,  8 Aug 2024 13:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I1azTnPM"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BA718B462
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122162; cv=none; b=cuFm6XSY2vYhFURAx0Cdw2/zPgWUNi1Hjqz3rID1DseMmZL97EwTzWb9R4QrhQmh4q6FZO2fHrpJkNm+EN/jCuGBWgLXuC3I93XdNGdJ1B2gKnftVphlYYEOc1BDTuN29oRnUejG4aB4egFSoZUyONB8rlxt7L3AcxLPH6gyqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122162; c=relaxed/simple;
	bh=IJeMqDVYuzSEeuTRNhdmUTmSXGImxwLKo5QxBoWQv/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pTilILDFH9f/DvwTG40jrXpMBQowlySgLpWtU1B6EDxt73y9eic8yGZrvkoBrj3dgG1XuOjlhxdY/1+5C/GkJwGUVcGwK4guq4LWwPbwnRiJwqrZti7zO1UiA4sDSiPxTuB4zvKLR9KvAHdgmy/06/B/tqLcG/AyiJTcgKH9fwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I1azTnPM; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723122155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XRXc8mVnLJ9OJRxUhrcqpKXwK3sYS9BYNH87+2uhg7E=;
	b=I1azTnPMkce/rR50t5eAMiuLbfUcK6o+bEFYGQrxr9mRj0ghh/j02GWZLAM1ZPsvk9/dN7
	bpFTQJcvw85X4gzjIl1ORVD7HeQZ4Rei52zLOScfH0wiv6vrKIhYOqZRLIxK3HQIpR2AtL
	nYjoEG8RyumW3bEjySYEUoOpgXHMOPo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/3] riscv: Extend CI
Date: Thu,  8 Aug 2024 15:02:30 +0200
Message-ID: <20240808130229.47415-5-andrew.jones@linux.dev>
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

Andrew Jones (3):
  lib: Add limits.h
  riscv: Build with explicit ABI
  riscv: Extend gitlab CI

 .gitlab-ci.yml | 34 +++++++++++++++++++++++++++++-----
 lib/limits.h   | 43 +++++++++++++++++++++++++++++++++++++++++++
 riscv/Makefile | 10 ++++++----
 3 files changed, 78 insertions(+), 9 deletions(-)
 create mode 100644 lib/limits.h

-- 
2.45.2


