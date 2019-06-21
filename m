Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94CD4EAC7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfFUOe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfFUOeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8A5B22386E;
        Fri, 21 Jun 2019 14:34:25 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 558BD5C225;
        Fri, 21 Jun 2019 14:34:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 12/14] vfio-ccw: Copy CCW data outside length calculation
Date:   Fri, 21 Jun 2019 16:33:53 +0200
Message-Id: <20190621143355.29175-13-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 21 Jun 2019 14:34:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

It doesn't make much sense to "hide" the copy to the channel_program
struct inside a routine that calculates the length of the chain.

Let's move it to the calling routine, which will later copy from
channel_program to the memory it allocated itself.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190618202352.39702-4-farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 37d513e86530..a55f8d110920 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -381,18 +381,8 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 {
 	struct ccw1 *ccw = cp->guest_cp;
-	int cnt;
+	int cnt = 0;
 
-	/*
-	 * Copy current chain from guest to host kernel.
-	 * Currently the chain length is limited to CCWCHAIN_LEN_MAX (256).
-	 * So copying 2K is enough (safe).
-	 */
-	cnt = copy_ccw_from_iova(cp, ccw, iova, CCWCHAIN_LEN_MAX);
-	if (cnt)
-		return cnt;
-
-	cnt = 0;
 	do {
 		cnt++;
 
@@ -446,7 +436,12 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	struct ccwchain *chain;
 	int len;
 
-	/* Copy the chain from cda to cp, and count the CCWs in it */
+	/* Copy 2K (the most we support today) of possible CCWs */
+	len = copy_ccw_from_iova(cp, cp->guest_cp, cda, CCWCHAIN_LEN_MAX);
+	if (len)
+		return len;
+
+	/* Count the CCWs in the current chain */
 	len = ccwchain_calc_length(cda, cp);
 	if (len < 0)
 		return len;
-- 
2.20.1

