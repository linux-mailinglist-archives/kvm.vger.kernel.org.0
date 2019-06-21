Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233D04EAB6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfFUOeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfFUOeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F187B30821FF;
        Fri, 21 Jun 2019 14:34:09 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B992608E4;
        Fri, 21 Jun 2019 14:34:09 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 04/14] s390/cio: Use generalized CCW handler in cp_init()
Date:   Fri, 21 Jun 2019 16:33:45 +0200
Message-Id: <20190621143355.29175-5-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 21 Jun 2019 14:34:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

It is now pretty apparent that ccwchain_handle_ccw()
(nee ccwchain_handle_tic()) does everything that cp_init()
wants to do.

Let's remove that duplicated code from cp_init() and let
ccwchain_handle_ccw() handle it itself.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-5-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 52735cdb0270..5b98bea433b7 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -744,9 +744,7 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
  */
 int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 {
-	u64 iova = orb->cmd.cpa;
-	struct ccwchain *chain;
-	int len, ret;
+	int ret;
 
 	/*
 	 * XXX:
@@ -759,28 +757,11 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	memcpy(&cp->orb, orb, sizeof(*orb));
 	cp->mdev = mdev;
 
-	/* Get chain length. */
-	len = ccwchain_calc_length(iova, cp);
-	if (len < 0)
-		return len;
-
-	/* Alloc mem for the head chain. */
-	chain = ccwchain_alloc(cp, len);
-	if (!chain)
-		return -ENOMEM;
-	chain->ch_iova = iova;
-
-	/* Copy the head chain from guest. */
-	ret = copy_ccw_from_iova(cp, chain->ch_ccw, iova, len);
-	if (ret) {
-		ccwchain_free(chain);
-		return ret;
-	}
-
-	/* Now loop for its TICs. */
-	ret = ccwchain_loop_tic(chain, cp);
+	/* Build a ccwchain for the first CCW segment */
+	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
 	if (ret)
 		cp_free(cp);
+
 	/* It is safe to force: if not set but idals used
 	 * ccwchain_calc_length returns an error.
 	 */
-- 
2.20.1

