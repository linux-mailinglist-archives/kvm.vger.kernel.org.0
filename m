Return-Path: <kvm+bounces-30922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E04499BE5C0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DEE7B229E5
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEE51DEFF7;
	Wed,  6 Nov 2024 11:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WNj4L8Y0"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397BD1DE4C2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893103; cv=none; b=XK/hMERMDjy59gOwUn/jbE2GfOGnEeSWzvRSF054ngVo87ND3a76xqxcuPmgSWldruSJTa7Z+k9J/IapP6jqH5NdVALXInrMAJzKjNR+byM41B0g3bAID1N+31ipVd5Ki4xK4eTYOyoSErgiXYTEf0qcb7qNjw/Z8mze9SQrALQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893103; c=relaxed/simple;
	bh=BmL2PtS9NkguTRoUY6oWPYZUJPh04irbNrKfBNsRVhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VbYuoNXVsG96OojENLXm296BcmQZLaUqGS2GBLRayGVIDdjA1ssFuwf0ZWHh5+es6o/nVNoha4M/Izxf5kxrHW5CQGuHVaK5JM9k+fYuSH+6wsJbAqfo1g7491kLEW2v+GB2VI0V0byo2Qi6TntOlkt4SGHvYqHFlWe7G6E8Y9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WNj4L8Y0; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730893098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y7sY1LDtKg624mZKhUOGLiQ4e59QK+4btWX3E9hDTbA=;
	b=WNj4L8Y0a+QLXnhtiEYte6AvRYLidaN/grjHlNDwtfyxIMC2BlgPl3BGiQQecALtHpiIwJ
	+ISCbYs9Pmu+ac2s7EQ/0sBif7Jh75p2abvB+X21WjvIoswt6u1InBOhmqnB+Qgw9Jz7K6
	JsjnwRb8gM21ASio8N9IL+hp+9/3EYI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 0/3] riscv: sbi: Add IPI tests
Date: Wed,  6 Nov 2024 12:38:15 +0100
Message-ID: <20241106113814.42992-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Repost Cade's IPI test patch[1] with all the changes pointed out in the
last review and more.

Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

[1] https://lore.kernel.org/all/20240826065106.20281-1-cade.richard@berkeley.edu/

v2:
 - Rebased on latest riscv/sbi
 - Improved ipi done checking by introducing cpumask_equal
 - Added a patch for another IPI test case


Andrew Jones (2):
  riscv: Add sbi_send_ipi_broadcast
  riscv: sbi: Add two in hart_mask IPI test

Cade Richard (1):
  riscv: sbi: Add IPI extension tests

 lib/cpumask.h       |  13 ++++
 lib/riscv/asm/sbi.h |   1 +
 lib/riscv/sbi.c     |   7 +-
 riscv/sbi.c         | 184 +++++++++++++++++++++++++++++++++++++++++++-
 riscv/unittests.cfg |   1 +
 5 files changed, 203 insertions(+), 3 deletions(-)

-- 
2.47.0


