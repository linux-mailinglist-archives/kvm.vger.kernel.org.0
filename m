Return-Path: <kvm+bounces-37142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A489A26202
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05FEF3A6F88
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8CB20D516;
	Mon,  3 Feb 2025 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ofa4kCMt"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5620B807
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606246; cv=none; b=Ycyf9EZXvuv72pW5GhpZnJwZGRpxDQd1+D4Ajlzt6xzGKNAqjDBUP4kE9aY/c6Er6Y1NSTlaDi5gbyj+nL+J67cgsGj/0Ecpmz3TxvQ6Pj8Ix+ukbaXK8Ob8uF3HGDvkLRK6d9panfIv69Y/8w39Yk5XCbby4F8f/95jgcHsKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606246; c=relaxed/simple;
	bh=ho3d6fVLgrviPwBvnqL34Nxeur65MzBGNAN2yziZ6HQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uI8G3HZ7/rDoUz+q1udixRm80w2Ift0/aUyLC9tZm8gVhKiLNNghkRctg54yrV4okAJCCtEavVB3UQCRc+P0Mj8BVqNm2WctHQJo9c53k+GomiZaK3opggsSwc8+1CnELvnqcPVUSZCqE4VILaCf/uvFSCRWneR3xr/j47xqtN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ofa4kCMt; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738606236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e369Jpd9wPQ4GpElGKCHjESBmU67aDzaobWVmnI1uJ8=;
	b=ofa4kCMtiparBCe4boLmjE+S/1U89CstG73zch3eEWzQFZ+niK/Jbe1/GAeaHaUeu5a37s
	V540zPGIAuQT4mFe6tQxp4O+V+lqnJmpa2GJ2Ae/gyPLUfCL6KNjYCIuGxwazrNweJEUcv
	GUHiTpJNG4qUzpnaIdWyGWTdhedaHNU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH] arm: pmu: Actually use counter 0 in test_event_counter_config()
Date: Mon,  3 Feb 2025 10:10:26 -0800
Message-Id: <20250203181026.159721-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

test_event_counter_config() checks that there is at least one event
counter but mistakenly uses counter 1 for part of the test.

Most implementations have more than a single event counter which is
probably why this went unnoticed. However, due to limitations of the
underlying hardware, KVM's PMUv3 emulation on Apple silicon can only
provide 1 event counter.

Consistenly use counter 0 throughout the test, matching the precondition
and allowing the test to pass on Apple parts.

Cc: Eric Auger <eric.auger@redhat.com>
Fixes: 4ce2a804 ("arm: pmu: Basic event counter Tests")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 9ff7a301..2dc0822b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -396,13 +396,13 @@ static void test_event_counter_config(void)
 	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
 	 * select counter 0
 	 */
-	write_sysreg(1, PMSELR_EL0);
+	write_sysreg(0, PMSELR_EL0);
 	/* program this counter to count unsupported event */
 	write_sysreg(0xEA, PMXEVTYPER_EL0);
 	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
-	report((read_regn_el0(pmevtyper, 1) & 0xFFF) == 0xEA,
+	report((read_regn_el0(pmevtyper, 0) & 0xFFF) == 0xEA,
 		"PMESELR/PMXEVTYPER/PMEVTYPERn");
-	report((read_regn_el0(pmevcntr, 1) == 0xdeadbeef),
+	report((read_regn_el0(pmevcntr, 0) == 0xdeadbeef),
 		"PMESELR/PMXEVCNTR/PMEVCNTRn");
 
 	/* try to configure an unsupported event within the range [0x0, 0x3F] */

base-commit: 1f08a91a41402b0e032ecce8ed1b5952cbfca0ea
-- 
2.39.5


