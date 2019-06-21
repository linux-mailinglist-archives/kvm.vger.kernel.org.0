Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48414EAC3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfFUOeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfFUOeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:22 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E63FB30C31B9;
        Fri, 21 Jun 2019 14:34:21 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FF38601B6;
        Fri, 21 Jun 2019 14:34:21 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 10/14] vfio-ccw: Move guest_cp storage into common struct
Date:   Fri, 21 Jun 2019 16:33:51 +0200
Message-Id: <20190621143355.29175-11-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 21 Jun 2019 14:34:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Rather than allocating/freeing a piece of memory every time
we try to figure out how long a CCW chain is, let's use a piece
of memory allocated for each device.

The io_mutex added with commit 4f76617378ee9 ("vfio-ccw: protect
the I/O region") is held for the duration of the VFIO_CCW_EVENT_IO_REQ
event that accesses/uses this space, so there should be no race
concerns with another CPU attempting an (unexpected) SSCH for the
same device.

Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190618202352.39702-2-farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c  | 23 ++++-------------------
 drivers/s390/cio/vfio_ccw_cp.h  |  7 +++++++
 drivers/s390/cio/vfio_ccw_drv.c |  7 +++++++
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 90d86e1354c1..f358502376be 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -16,12 +16,6 @@
 
 #include "vfio_ccw_cp.h"
 
-/*
- * Max length for ccw chain.
- * XXX: Limit to 256, need to check more?
- */
-#define CCWCHAIN_LEN_MAX	256
-
 struct pfn_array {
 	/* Starting guest physical I/O address. */
 	unsigned long		pa_iova;
@@ -386,7 +380,7 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
  */
 static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 {
-	struct ccw1 *ccw, *p;
+	struct ccw1 *ccw = cp->guest_cp;
 	int cnt;
 
 	/*
@@ -394,15 +388,9 @@ static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 	 * Currently the chain length is limited to CCWCHAIN_LEN_MAX (256).
 	 * So copying 2K is enough (safe).
 	 */
-	p = ccw = kcalloc(CCWCHAIN_LEN_MAX, sizeof(*ccw), GFP_KERNEL);
-	if (!ccw)
-		return -ENOMEM;
-
 	cnt = copy_ccw_from_iova(cp, ccw, iova, CCWCHAIN_LEN_MAX);
-	if (cnt) {
-		kfree(ccw);
+	if (cnt)
 		return cnt;
-	}
 
 	cnt = 0;
 	do {
@@ -413,10 +401,8 @@ static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 		 * orb specified one of the unsupported formats, we defer
 		 * checking for IDAWs in unsupported formats to here.
 		 */
-		if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw)) {
-			kfree(p);
+		if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw))
 			return -EOPNOTSUPP;
-		}
 
 		/*
 		 * We want to keep counting if the current CCW has the
@@ -435,7 +421,6 @@ static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 	if (cnt == CCWCHAIN_LEN_MAX + 1)
 		cnt = -EINVAL;
 
-	kfree(p);
 	return cnt;
 }
 
@@ -461,7 +446,7 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	struct ccwchain *chain;
 	int len, ret;
 
-	/* Get chain length. */
+	/* Copy the chain from cda to cp, and count the CCWs in it */
 	len = ccwchain_calc_length(cda, cp);
 	if (len < 0)
 		return len;
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index 3c20cd208da5..7cdc38049033 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -16,6 +16,12 @@
 
 #include "orb.h"
 
+/*
+ * Max length for ccw chain.
+ * XXX: Limit to 256, need to check more?
+ */
+#define CCWCHAIN_LEN_MAX	256
+
 /**
  * struct channel_program - manage information for channel program
  * @ccwchain_list: list head of ccwchains
@@ -32,6 +38,7 @@ struct channel_program {
 	union orb orb;
 	struct device *mdev;
 	bool initialized;
+	struct ccw1 *guest_cp;
 };
 
 extern int cp_init(struct channel_program *cp, struct device *mdev,
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 66a66ac1f3d1..34a9a5e3fd36 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -129,6 +129,11 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (!private)
 		return -ENOMEM;
 
+	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
+				       GFP_KERNEL);
+	if (!private->cp.guest_cp)
+		goto out_free;
+
 	private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
 					       GFP_KERNEL | GFP_DMA);
 	if (!private->io_region)
@@ -169,6 +174,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
 	if (private->io_region)
 		kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	kfree(private->cp.guest_cp);
 	kfree(private);
 	return ret;
 }
@@ -185,6 +191,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 
 	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
 	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	kfree(private->cp.guest_cp);
 	kfree(private);
 
 	return 0;
-- 
2.20.1

