Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A3E4EAC9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfFUOe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfFUOe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A1E7308429B;
        Fri, 21 Jun 2019 14:34:27 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3654E5C22B;
        Fri, 21 Jun 2019 14:34:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 13/14] vfio-ccw: Factor out the ccw0-to-ccw1 transition
Date:   Fri, 21 Jun 2019 16:33:54 +0200
Message-Id: <20190621143355.29175-14-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 21 Jun 2019 14:34:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

This is a really useful function, but it's buried in the
copy_ccw_from_iova() routine so that ccwchain_calc_length()
can just work with Format-1 CCWs while doing its counting.
But it means we're translating a full 2K of "CCWs" to Format-1,
when in reality there's probably far fewer in that space.

Let's factor it out, so maybe we can do something with it later.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190618202352.39702-5-farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 48 ++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index a55f8d110920..9a8bf06281e0 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -161,6 +161,27 @@ static inline void pfn_array_idal_create_words(
 	idaws[0] += pa->pa_iova & (PAGE_SIZE - 1);
 }
 
+void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
+{
+	struct ccw0 ccw0;
+	struct ccw1 *pccw1 = source;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		ccw0 = *(struct ccw0 *)pccw1;
+		if ((pccw1->cmd_code & 0x0f) == CCW_CMD_TIC) {
+			pccw1->cmd_code = CCW_CMD_TIC;
+			pccw1->flags = 0;
+			pccw1->count = 0;
+		} else {
+			pccw1->cmd_code = ccw0.cmd_code;
+			pccw1->flags = ccw0.flags;
+			pccw1->count = ccw0.count;
+		}
+		pccw1->cda = ccw0.cda;
+		pccw1++;
+	}
+}
 
 /*
  * Within the domain (@mdev), copy @n bytes from a guest physical
@@ -211,32 +232,9 @@ static long copy_ccw_from_iova(struct channel_program *cp,
 			       struct ccw1 *to, u64 iova,
 			       unsigned long len)
 {
-	struct ccw0 ccw0;
-	struct ccw1 *pccw1;
 	int ret;
-	int i;
 
 	ret = copy_from_iova(cp->mdev, to, iova, len * sizeof(struct ccw1));
-	if (ret)
-		return ret;
-
-	if (!cp->orb.cmd.fmt) {
-		pccw1 = to;
-		for (i = 0; i < len; i++) {
-			ccw0 = *(struct ccw0 *)pccw1;
-			if ((pccw1->cmd_code & 0x0f) == CCW_CMD_TIC) {
-				pccw1->cmd_code = CCW_CMD_TIC;
-				pccw1->flags = 0;
-				pccw1->count = 0;
-			} else {
-				pccw1->cmd_code = ccw0.cmd_code;
-				pccw1->flags = ccw0.flags;
-				pccw1->count = ccw0.count;
-			}
-			pccw1->cda = ccw0.cda;
-			pccw1++;
-		}
-	}
 
 	return ret;
 }
@@ -441,6 +439,10 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	if (len)
 		return len;
 
+	/* Convert any Format-0 CCWs to Format-1 */
+	if (!cp->orb.cmd.fmt)
+		convert_ccw0_to_ccw1(cp->guest_cp, len);
+
 	/* Count the CCWs in the current chain */
 	len = ccwchain_calc_length(cda, cp);
 	if (len < 0)
-- 
2.20.1

