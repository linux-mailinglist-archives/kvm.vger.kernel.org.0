Return-Path: <kvm+bounces-15113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5BD8A9F3C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 17:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F2C281CA8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA2616F837;
	Thu, 18 Apr 2024 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEdEnE6s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6599A16F29A
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713455795; cv=none; b=UaVdLSrOmWW1Itili4CDYDrUtAC1pm8PEGgWopnKWaA7RT0/sQ7pM8lXUH2efs45u53ZzQgqUG07ZWzsSgRHcHOhn8ngjYjp5gzJSW/azg+q5ErrdRwWGugiMjauzxDGk55hkYRGvFQds+CX+yGhW/BdwTRQcMZgyZypfppFKag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713455795; c=relaxed/simple;
	bh=N5VuYszWyUgXUWeOkieq13Ynz0WJjlr/4zuifki1+o8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aET8dHNn95oR49BoS+2tYhRNTwVCxZdfUlryun3KlFjFp1Ru4he4+RXA+fyfOxPHJe+o/K1Et5P/FJ1gG5t/4tlGn+UU1mZlZXjE/ii6rAu8/w6PlWsZPZk+jnLpX5L6O+bxhsRgWLZtvTOH88pNkFKaR7d2ypxFBZZ5bKK/BNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEdEnE6s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713455790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sxP9uT0Y76HJtxDBA6HeF0BlZ6lJI3BGybLIqaxuaCk=;
	b=JEdEnE6sLCX3ZorIJd6hUGDFEmGS3mMoe3Radh8Kz8XxsPTuM9yuUObkofQIZJpG+0v2PM
	hPjdhuL8IVpPh+eIGEJtoZLg6UBFApfRjiDbY/2E8egwCL8d0eqJAvsb6S55MtyM55nOm0
	QHYQElWrAQOn+fJai00STXymxLAlEjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-vSIAKvLrOr2rCMFFoMPWiA-1; Thu, 18 Apr 2024 11:56:29 -0400
X-MC-Unique: vSIAKvLrOr2rCMFFoMPWiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C77B38E7D41
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 15:56:28 +0000 (UTC)
Received: from jarichte.redhat.com (unknown [10.45.226.75])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3092249102;
	Thu, 18 Apr 2024 15:56:28 +0000 (UTC)
From: Jan Richter <jarichte@redhat.com>
To: thuth@redhat.com
Cc: kvm@vger.kernel.org,
	Jan Richter <jarichte@redhat.com>
Subject: [kvm-unit-tests PATCH] test_migrate_unmapped_collection test fails during skip
Date: Thu, 18 Apr 2024 17:55:49 +0200
Message-ID: <20240418155549.71374-1-jarichte@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

The test_migrate_unmapped_collection test fails when the errata
requirements are not meet and the test should be skipped. Instead of
being skipped, the test returns `ERROR: Test exit before migration
point.`

This is caused by changes in fa8914bccc226db86bd70d71bfd6022db252fc78
which changes the behaviour of skipped migration tests. This fixes this
issue by adding migrate_skip() method to
test_migrate_unmapped_collection.

Signed-off-by: Jan Richter <jarichte@redhat.com>
---
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


