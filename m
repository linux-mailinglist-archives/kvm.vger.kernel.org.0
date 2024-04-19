Return-Path: <kvm+bounces-15212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D488AAA39
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 757C01C21DE7
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 08:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA31152F62;
	Fri, 19 Apr 2024 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lo99pQsU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A23E4C8A
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515598; cv=none; b=Gb2Lqz2wkUS7dDtnUd0LCcQQd+yzQoHXsETXaCOH0d+ZW/kIB2y0OdOTHOIQR1rmty9vSWm0s9L5KGOs8DvUHHrGqg9P72g5yhZgbpD5/JUEfXzeklJKKYQ8uvxEeW/6yti8k+dGu81ngoCkKAkc/02ww7vqfpIXoEWqPWTurmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515598; c=relaxed/simple;
	bh=3F8M/b3umOmheVE3AC2bLg70lLYvJTqipbGc1XiPzK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s21m4S+wXmU7x9LFscqmRukwp385k1Sh2SIHVGgOL9jvrwnHA9jH1CqbO4ZWbNv4DsOBKAD/VA3WWnBhZXP6G9Wrx9XEcRxKwF7y5mY0Ib597/mgcoh7nurWJaohbqDIt2aXxMI8pCU2ag/nDECNSOvtocLAxJkt0d4MaCvJd18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lo99pQsU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713515596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pUplKqcxcLE8UsYziYXsxwkS4bn1JEk0la8q0MzD0S0=;
	b=Lo99pQsUqIrhJI3vS8//uxQ2eAhj0n3e0j8SSTR5FBM9ZBrW5i3nBh9Rr/1nlr0xjb/CKC
	2hmv0nME2HlHDZfpHPkKvmX3nxAU0qLsH6CGA+OyCCWNvlh0AU/wPMtqU1joWlBxb8xCvk
	FbB2jgpDM5ADXNkwBj6Vb+ON6l6aXEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-v4FD9tbZPTuB0nPJ9BLftQ-1; Fri, 19 Apr 2024 04:33:12 -0400
X-MC-Unique: v4FD9tbZPTuB0nPJ9BLftQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D55818065B2;
	Fri, 19 Apr 2024 08:33:12 +0000 (UTC)
Received: from jarichte.redhat.com (unknown [10.45.226.75])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BEEC40005B;
	Fri, 19 Apr 2024 08:33:11 +0000 (UTC)
From: Jan Richter <jarichte@redhat.com>
To: kvm@vger.kernel.org
Cc: thuth@redhat.com,
	andrew.jones@linux.dev,
	Jan Richter <jarichte@redhat.com>
Subject: [kvm-unit-tests PATCH v2] test_migrate_unmapped_collection test fails during skip
Date: Fri, 19 Apr 2024 10:13:18 +0200
Message-ID: <20240419083104.158311-1-jarichte@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The test_migrate_unmapped_collection test fails when the errata
requirements are not met and the test should be skipped. Instead of
being skipped, the test returns `ERROR: Test exit before migration
point.`

This is caused by changes in commit fa8914bccc22 ("migration: Add a
migrate_skip command") which changes the behaviour of skipped migration
tests. This fixes this issue by adding migrate_skip() method to
test_migrate_unmapped_collection.

Fixes: fa8914bccc22 ("migration: Add a migrate_skip command")
Signed-off-by: Jan Richter <jarichte@redhat.com>
---
Changes from v1->v2:
1. typo fix meet/met
2. commit reference changed
3. Fixes tag added

 arm/gic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arm/gic.c b/arm/gic.c
index bbf828f1..256dd80d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -829,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
 	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
 		report_skip("Skipping test, as this test hangs without the fix. "
 			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
+		migrate_skip();
 		return;
 	}
 
-- 
2.44.0


