Return-Path: <kvm+bounces-25852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA3296BA44
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98012285B96
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D70C1D5CDD;
	Wed,  4 Sep 2024 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYN45JZe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70641D097B
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448736; cv=none; b=doIXO6QqauJU1Ha8ya1XmLZ9oFnkZfHoaqIXxZScVt01e2QhY5RWDnxRJWqPLAzttD9HztXzuWAdpQGS9oU+k/fTnl1nL+Y8HBRURiYBi+1wvJlCp5XFUjJS4vwYubgu/vaRwNqxoMtCvP+334SLXXa63yixRtUz+fq11353ON8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448736; c=relaxed/simple;
	bh=HJCmp4vGgK6uM2PzH3CurSu7ZuwAnvX5q+ygCclbIaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=fefLt5DKIRPORJdp51no6Z83d172ty2BI4uSqVwSVHxwxGZJU+nMs7INZ/edr+bOS+sbcgaQkZsCu13cXYhB3ikKzT/bQ4GqfP0VLd9/yHGX1uBO+fShB5qY3Zkq6LMDq1DTZFG/CFo4Tgd6MlYr5MV0YOOtO4fIoV5BYjJNkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYN45JZe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krwGcnbmK4mJojLce1YySOaQMl7POMJC2LkjDvFBIHA=;
	b=CYN45JZeR2kZ46wL6Ocxc48rWYeseg3Dpu4KqoLOE9nFNuq+v4FdX3OSeCvTyaLrJvtvaf
	SxHSCrMenz0h7knaeVojL0/ukVxKIV2tr1cAUWcSzR2Ew3F4jgsh0Dt3A/aEy0turvmwMH
	2QHdTx7yjDpnhIPT+3rpwckUt6lT51U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-UFBGwjXIN7CxdUb05skooA-1; Wed,
 04 Sep 2024 07:18:52 -0400
X-MC-Unique: UFBGwjXIN7CxdUb05skooA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEBEF19560B2;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F7FE1955F44;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E475921E66CD; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 19/19] qapi/vfio: Rename VfioMigrationState to Qapi*, and drop prefix
Date: Wed,  4 Sep 2024 13:18:36 +0200
Message-ID: <20240904111836.3273842-20-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

VfioMigrationState has a 'prefix' that overrides the generated
enumeration constants' prefix to QAPI_VFIO_MIGRATION_STATE.

We could simply drop 'prefix', but then the enumeration constants
would look as if they came from kernel header linux/vfio.h.

Rename the type to QapiVfioMigrationState instead, so that 'prefix' is
not needed.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/vfio.json      | 9 ++++-----
 hw/vfio/migration.c | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/qapi/vfio.json b/qapi/vfio.json
index eccca82068..b53b7caecd 100644
--- a/qapi/vfio.json
+++ b/qapi/vfio.json
@@ -7,7 +7,7 @@
 ##
 
 ##
-# @VfioMigrationState:
+# @QapiVfioMigrationState:
 #
 # An enumeration of the VFIO device migration states.
 #
@@ -32,10 +32,9 @@
 #
 # Since: 9.1
 ##
-{ 'enum': 'VfioMigrationState',
+{ 'enum': 'QapiVfioMigrationState',
   'data': [ 'stop', 'running', 'stop-copy', 'resuming', 'running-p2p',
-            'pre-copy', 'pre-copy-p2p' ],
-  'prefix': 'QAPI_VFIO_MIGRATION_STATE' }
+            'pre-copy', 'pre-copy-p2p' ] }
 
 ##
 # @VFIO_MIGRATION:
@@ -63,5 +62,5 @@
   'data': {
       'device-id': 'str',
       'qom-path': 'str',
-      'device-state': 'VfioMigrationState'
+      'device-state': 'QapiVfioMigrationState'
   } }
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index 262d42a46e..17199b73ae 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -81,7 +81,7 @@ static const char *mig_state_to_str(enum vfio_device_mig_state state)
     }
 }
 
-static VfioMigrationState
+static QapiVfioMigrationState
 mig_state_to_qapi_state(enum vfio_device_mig_state state)
 {
     switch (state) {
-- 
2.46.0


