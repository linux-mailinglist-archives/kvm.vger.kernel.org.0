Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB51A4ABA2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbfFRUYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 16:24:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730577AbfFRUYD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 16:24:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IKI89F007405
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:01 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t75ky3vtt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 18 Jun 2019 21:23:59 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 21:23:56 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IKNkpX36241814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:23:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56E1CAE059;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C520AE051;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C957BE0215; Tue, 18 Jun 2019 22:23:53 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 1/5] vfio-ccw: Move guest_cp storage into common struct
Date:   Tue, 18 Jun 2019 22:23:48 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618202352.39702-1-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061820-0016-0000-0000-0000028A3755
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061820-0017-0000-0000-000032E78A61
Message-Id: <20190618202352.39702-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
Conny, your suggestion [1] did not go unnoticed.  :)

[1] https://patchwork.kernel.org/comment/22312659/
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
2.17.1

