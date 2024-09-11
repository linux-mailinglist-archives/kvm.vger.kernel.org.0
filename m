Return-Path: <kvm+bounces-26501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 516829750E4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 848F31C22AEC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACD613B580;
	Wed, 11 Sep 2024 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I5Vd3qHB"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F925191493
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726054428; cv=none; b=PB1B+QsLpX/SIjkTBYKajRxdFkhUe2RmW2l8AhhxG6goAd6SN/vDaSVBV2Vjf/kpdS5DQle2RCl5mpiYvg9ovUyRW9RdIgGTpZG3Tk4l1zU3BHYcmsezUPH116EN5dDdGSwdTS2ZHFY6QlT+lEy/t5BxEcob+XpOopYw1VTWJ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726054428; c=relaxed/simple;
	bh=IWFH4Cy+m7uhVhtBHVAnZgmXbaF9vhwznaO8RzVJ2UE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TG5pMDH157MBcVXarnm8olVf7FT1TVd7QtNO4Kxca6mUCsmIRsFgvGxoFQvfHQbMsH5UcZ6TD0HeYarJH4wJlCGIQzLJ6Nf/h73eiOnXTkMimRIaBSQ0iUiD7TbKESNvWbDkA/3Ya8hnqOuYzCoRAHf59yj3oly0DJ14UCAl0T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I5Vd3qHB; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726054422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9wyHmYfKynFtv3rllHb3UNi054EA5pCxB3j7zh6eSY8=;
	b=I5Vd3qHBWe4ET8jr5S+Xf5YPOq/spqKpkVFBr46nZbfeQhU7fXlP5oYLkGGmKymg/THZUO
	lJAmFxUGEkdo0INLBNZ2hQY9oOyNWiCnnYuQTBETK8LS5VWoBitMn9A7p9YcfIURAHu2ys
	QjjvjoBLk/T8LkRJSNwt0I5JKG4flQQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/2] riscv: sbi: Improve DBCN and BASE
Date: Wed, 11 Sep 2024 13:33:39 +0200
Message-ID: <20240911113338.156844-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Improve the tests for DBCN and BASE. For DBCN, use xfail when for failed
highmem tests when we know the SBI implementation doesn't support
highmem (such as 32-bit OpenSBI). For BASE, per the spec, ensure the bit
31 is zero and ensure we always treat bits 63:32 as UNKNOWN.


Andrew Jones (2):
  riscv: sbi: Highmem isn't always supported
  riscv: sbi: Improve spec version test

 lib/riscv/sbi.c |  2 +-
 riscv/sbi.c     | 38 ++++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 13 deletions(-)

-- 
2.46.0


