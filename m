Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB14EAC4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFUOeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfFUOeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C968886676;
        Fri, 21 Jun 2019 14:34:23 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 738965B689;
        Fri, 21 Jun 2019 14:34:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 11/14] vfio-ccw: Skip second copy of guest cp to host
Date:   Fri, 21 Jun 2019 16:33:52 +0200
Message-Id: <20190621143355.29175-12-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 21 Jun 2019 14:34:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

We already pinned/copied/unpinned 2K (256 CCWs) of guest memory
to the host space anchored off vfio_ccw_private.  There's no need
to do that again once we have the length calculated, when we could
just copy the section we need to the "permanent" space for the I/O.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190618202352.39702-3-farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index f358502376be..37d513e86530 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -444,7 +444,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain,
 static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 {
 	struct ccwchain *chain;
-	int len, ret;
+	int len;
 
 	/* Copy the chain from cda to cp, and count the CCWs in it */
 	len = ccwchain_calc_length(cda, cp);
@@ -457,12 +457,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 		return -ENOMEM;
 	chain->ch_iova = cda;
 
-	/* Copy the new chain from user. */
-	ret = copy_ccw_from_iova(cp, chain->ch_ccw, cda, len);
-	if (ret) {
-		ccwchain_free(chain);
-		return ret;
-	}
+	/* Copy the actual CCWs into the new chain */
+	memcpy(chain->ch_ccw, cp->guest_cp, len * sizeof(struct ccw1));
 
 	/* Loop for tics on this new chain. */
 	return ccwchain_loop_tic(chain, cp);
-- 
2.20.1

