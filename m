Return-Path: <kvm+bounces-23856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0E094EF41
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A84B1283726
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5922917E44F;
	Mon, 12 Aug 2024 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvDY2tiA"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E1C17DE35
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472044; cv=none; b=E6fybkwoOpcq14UZzXrfeN4Vok7nlo7UjuUHzrHA8rabw0QLzEmb6V6T8gQtMyoBGqrYoZlViinpPZDsHVR/WfkvQHWnXZftiV2wVOaVhX9Cm7mPtnKZBnLB+SZqfWohTLQmDEKuo2NHv4CWCZCrrIusnxpw9ADiMuJRk9V7RSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472044; c=relaxed/simple;
	bh=dIO9w/ls8Kz/QrcG6XOZjG5IjSA6xd7CqUwRdhm+3Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mGuYE8pINVAFSCFOE2ZFcuZBthDo/4/jUatSCtab+D1j2pbAaimadyJ47DDuhgbHbK+RlFeyEA6/Eyf3mOFvv4ABrvlGgWKGOjA8lKI7nGImbUW+eVeRcNNUmeu90PZSiOyFZ5Go/vYDHb+aFBUopFKiF1tweqX66LcFH7anbNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvDY2tiA; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YPYcxentyOZDwdEQwW+j6u1n/8cpn6KAf2Ch+mYVYb8=;
	b=vvDY2tiACT3Fk6iamrktBe+Y0OnNfBF7fP9VyB8FtNPwtMgKOdw1aOmbhbDRdcm8K6Rj59
	q+1RcPuwzcSQFg348eyCR6uI7Z/S7ClcCxqLRAOWJFcn+7bmWz0D1D4TDnaTdQd792CpVV
	Hf65oZatoEknR7LZHdFfLTZ5fKH3Hzw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/4] riscv: sbi: More DBCN tests
Date: Mon, 12 Aug 2024 16:13:55 +0200
Message-ID: <20240812141354.119889-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The current DBCN tests found a several bugs and with high address
support for rv32 we were able to find even more. Add the new tests
which checks high use page boundary crossing. The first three patches
a various improvements to the SBI tests.

Based on riscv/queue, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fqueue

Andrew Jones (4):
  riscv: sbi: dbcn: Output return values
  riscv: sbi: Use strtoul to avoid overflow
  riscv: sbi: Prefix several environment variables with SBI
  riscv: sbi: dbcn: Add high address tests

 riscv/sbi.c | 163 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 131 insertions(+), 32 deletions(-)

-- 
2.45.2


