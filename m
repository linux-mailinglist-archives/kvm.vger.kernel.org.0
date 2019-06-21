Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286594EAB2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFUOeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfFUOeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42374A405A;
        Fri, 21 Jun 2019 14:34:06 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C74335D772;
        Fri, 21 Jun 2019 14:34:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 02/14] s390/cio: Refactor the routine that handles TIC CCWs
Date:   Fri, 21 Jun 2019 16:33:43 +0200
Message-Id: <20190621143355.29175-3-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 21 Jun 2019 14:34:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Extract the "does the target of this TIC already exist?" check from
ccwchain_handle_tic(), so that it's easier to refactor that function
into one that cp_init() is able to use.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-3-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 47cd7f94f42f..628daf1a8f9a 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -502,10 +502,6 @@ static int ccwchain_handle_tic(struct ccw1 *tic, struct channel_program *cp)
 	struct ccwchain *chain;
 	int len, ret;
 
-	/* May transfer to an existing chain. */
-	if (tic_target_chain_exists(tic, cp))
-		return 0;
-
 	/* Get chain length. */
 	len = ccwchain_calc_length(tic->cda, cp);
 	if (len < 0)
@@ -540,6 +536,10 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 		if (!ccw_is_tic(tic))
 			continue;
 
+		/* May transfer to an existing chain. */
+		if (tic_target_chain_exists(tic, cp))
+			continue;
+
 		ret = ccwchain_handle_tic(tic, cp);
 		if (ret)
 			return ret;
-- 
2.20.1

