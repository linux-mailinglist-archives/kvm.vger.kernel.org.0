Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D2C6A632
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 12:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfGPKJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 06:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731732AbfGPKJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 06:09:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A431300CB08;
        Tue, 16 Jul 2019 10:09:14 +0000 (UTC)
Received: from localhost (ovpn-117-180.ams2.redhat.com [10.36.117.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECF8C60C67;
        Tue, 16 Jul 2019 10:09:13 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/5] vfio-ccw: Fix misleading comment when setting orb.cmd.c64
Date:   Tue, 16 Jul 2019 12:09:04 +0200
Message-Id: <20190716100908.3460-2-cohuck@redhat.com>
In-Reply-To: <20190716100908.3460-1-cohuck@redhat.com>
References: <20190716100908.3460-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 16 Jul 2019 10:09:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

The comment is misleading because it tells us that
we should set orb.cmd.c64 before calling ccwchain_calc_length,
otherwise the function ccwchain_calc_length would return an
error. This is not completely accurate.

We want to allow an orb without cmd.c64, and this is fine
as long as the channel program does not use IDALs. But we do
want to reject any channel program that uses IDALs and does
not set the flag, which is what we do in ccwchain_calc_length.

After we have done the ccw processing, we need to set cmd.c64,
as we use IDALs for all translated channel programs.

Also for better code readability let's move the setting of
cmd.c64 within the non error path.

Fixes: fb9e7880af35 ("vfio: ccw: push down unsupported IDA check")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <f68636106aef0faeb6ce9712584d102d1b315ff8.1562854091.git.alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 1d4c893ead23..46967c664c0f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -645,14 +645,15 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	if (ret)
 		cp_free(cp);
 
-	/* It is safe to force: if not set but idals used
-	 * ccwchain_calc_length returns an error.
-	 */
-	cp->orb.cmd.c64 = 1;
-
-	if (!ret)
+	if (!ret) {
 		cp->initialized = true;
 
+		/* It is safe to force: if it was not set but idals used
+		 * ccwchain_calc_length would have returned an error.
+		 */
+		cp->orb.cmd.c64 = 1;
+	}
+
 	return ret;
 }
 
-- 
2.20.1

