Return-Path: <kvm+bounces-48100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E833AC8D30
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 13:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1FDE7B11A8
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 11:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3BE22A1FA;
	Fri, 30 May 2025 11:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ukur5sHL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A595202981
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748605947; cv=none; b=GQIa1oV0FspRw3V1U78fzB5KQiulV6PMrnEaW8MJ+lOIkJv9sMbZnushVPOcDn6FjdDx+fP3NuYfAyZ095cqvZ6nphrY1vVumk2FwsLqrGkAg/UEl7b1WU0QySZDwob9PFgXIAaN34De+76M/URgqyYCGebiN8FvGAelBx8uTgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748605947; c=relaxed/simple;
	bh=lRyvv/eKHTw6tyGs21HD2Fv3cfPVMOfFNJUj7x/DDYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eT48SKdYWOQ8ejGR5lYMyMH0dOkPZqgjoAC24ZvM0dIbEjToRit3In/ormjXThpG1F1v2MxiUNrzJzvFUx+WA3QhxSdorPNKxzRPCX2LcdbIxQDnIAd+loU0WEfGF1M3PRfMiuODFRYs1lcsdOALnUyWFqD8U0cKgjY8ocLvM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ukur5sHL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748605944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3LU2B6rexWZRHFbqLb76nsy3rAu9/QOa+G5VgFAN66E=;
	b=Ukur5sHLTceNL7X6EGP2+EDH7c1JQA28w2GIdlaO4vHk0Aqld/yl9N8+PHrIJX/HjThiny
	34N8D/7EPhd7caSyGXHdTNVUaZUFXNeHVsX3VP7Wf9MUtRj5WulgmaSOGJOZhfB2o+nRoB
	QM5oSIPF1kYYkN7CmPhjuGNkAvq6mpY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-pFPj--UyMfK-g-5FL1nIxA-1; Fri,
 30 May 2025 07:52:22 -0400
X-MC-Unique: pFPj--UyMfK-g-5FL1nIxA-1
X-Mimecast-MFC-AGG-ID: pFPj--UyMfK-g-5FL1nIxA_1748605940
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0953197730F
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:52:18 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.33.76])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CDB7A18003FC;
	Fri, 30 May 2025 11:52:16 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] travis.yml: Remove the aarch64 job
Date: Fri, 30 May 2025 13:52:14 +0200
Message-ID: <20250530115214.187348-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Thomas Huth <thuth@redhat.com>

According to:

 https://docs.travis-ci.com/user/billing-overview/#partner-queue-solution

only s390x and ppc64le are still part of the free OSS tier in Travis.
aarch64 has been removed sometime during the last year. Thus remove
the aarch64 job from our .travis.yml file now to avoid that someone
burns non-OSS CI credits with this job by accident now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 99d55c5f..799a186b 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -8,16 +8,6 @@ git:
 jobs:
   include:
 
-    - arch: arm64
-      addons:
-        apt_packages: qemu-system-aarch64
-      env:
-      - CONFIG="--arch=arm64 --cc=clang"
-      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi
-          pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr
-          selftest-setup selftest-smp selftest-vectors-kernel
-          selftest-vectors-user timer"
-
     - arch: ppc64le
       addons:
         apt_packages: clang qemu-system-ppc
-- 
2.49.0


