Return-Path: <kvm+bounces-41691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58285A6C0B1
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24E77173DE4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF4B22D7BC;
	Fri, 21 Mar 2025 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WODrA0ko"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295A22D4D6
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576055; cv=none; b=p0fhj2XJc2ieTjToEcApL5RR1jaUx5vgyg04++QqtYkv2CLEEbyRWniuSyuRuRoTr1H2V+a4JKjJ78MKBUcTW0zy7b1qUuRQo8GA/dWcuhZ6z86t4D5ykgz2WdiqLD+hn+3jN0c4Ma2U+5x551eTknAA6zH3yguG/GtveqvdSmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576055; c=relaxed/simple;
	bh=OGE8kt6MfbuF3Hu26rhXJmwMkThif3/mPHycuMvDAZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bTpz+d7bDGG429GHDTvZf781iN5uxJYp9ZN3kU13KaJFWlN+le7FajuV+e/plBQDmOIVjyNrFx5Uu8wDSi+MJFIxEhBK8+qN0WvlYWdo5apmRZHd6GrsAQQkwFsdsvhJd2X/DwJ48CJrclZHI8jx3qwol94fKjPuLW0OKfoqGJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WODrA0ko; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742576047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L3tpVZTaN9sVjI7OLORjQOfubtoVtkOjlP2FWLr44QQ=;
	b=WODrA0koflENMXWf1U+GKQnX0dwxABSkeCNbSX9qDFyX00GsjoYfkvcp3Gnzn6d1K7eEaH
	7qt5/cnuWivGVH1KPd+Cq/VQ6cYOpWwc4X0u2jRqa13lSW6X5yUzKDh/qWZSXBNxhxZnQ5
	vvsazHvXLvjl6V4cmXaD1hAn7hk31Ho=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: cleger@rivosinc.com,
	atishp@rivosinc.com,
	akshaybehl231@gmail.com
Subject: [kvm-unit-tests PATCH 0/3] riscv: sbi: Ensure we can pass with any opensbi
Date: Fri, 21 Mar 2025 17:54:04 +0100
Message-ID: <20250321165403.57859-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

At some point CI will update the version of QEMU it uses. If the version
selected includes an opensbi that doesn't have all the fixes for current
tests, then CI will start failing for riscv. Guard against that by using
kfail for known opensbi failures. We only kfail for opensbi and for its
versions less than 1.7, though, as we expect everything to be fixed then.

Andrew Jones (3):
  lib/riscv: Also provide sbiret impl functions
  riscv: sbi: Add kfail versions of sbiret_report functions
  riscv: sbi: Use kfail for known opensbi failures

 lib/riscv/asm/sbi.h |  6 ++++--
 lib/riscv/sbi.c     | 18 ++++++++++++++----
 riscv/sbi-fwft.c    | 20 +++++++++++++-------
 riscv/sbi-sse.c     |  4 ++--
 riscv/sbi-tests.h   | 20 +++++++++++++++-----
 riscv/sbi.c         |  6 ++++--
 6 files changed, 52 insertions(+), 22 deletions(-)

-- 
2.48.1


