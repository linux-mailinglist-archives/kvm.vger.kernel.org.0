Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E385C4EACB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFUOea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfFUOe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:29 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70D3B75726;
        Fri, 21 Jun 2019 14:34:29 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18043601B6;
        Fri, 21 Jun 2019 14:34:28 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 14/14] vfio-ccw: Remove copy_ccw_from_iova()
Date:   Fri, 21 Jun 2019 16:33:55 +0200
Message-Id: <20190621143355.29175-15-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 21 Jun 2019 14:34:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Just to keep things tidy.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190618202352.39702-6-farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9a8bf06281e0..9cddc1288059 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -228,17 +228,6 @@ static long copy_from_iova(struct device *mdev,
 	return l;
 }
 
-static long copy_ccw_from_iova(struct channel_program *cp,
-			       struct ccw1 *to, u64 iova,
-			       unsigned long len)
-{
-	int ret;
-
-	ret = copy_from_iova(cp->mdev, to, iova, len * sizeof(struct ccw1));
-
-	return ret;
-}
-
 /*
  * Helpers to operate ccwchain.
  */
@@ -435,7 +424,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	int len;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
-	len = copy_ccw_from_iova(cp, cp->guest_cp, cda, CCWCHAIN_LEN_MAX);
+	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
+			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
 	if (len)
 		return len;
 
-- 
2.20.1

