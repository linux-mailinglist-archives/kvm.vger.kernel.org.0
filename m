Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2821AE4B7
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 20:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgDQS13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 14:27:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730407AbgDQS12 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 14:27:28 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HI3e5H132186;
        Fri, 17 Apr 2020 14:27:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ffwsba02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 14:27:28 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03HI4BFj134177;
        Fri, 17 Apr 2020 14:27:27 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ffwsb9yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 14:27:27 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03HIQdOs032697;
        Fri, 17 Apr 2020 18:27:26 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 30b5h7sad2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 18:27:26 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03HIRQ3E52167122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 18:27:26 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F7E7AE05F;
        Fri, 17 Apr 2020 18:27:26 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9DCAE064;
        Fri, 17 Apr 2020 18:27:25 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.151.210])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 18:27:25 +0000 (GMT)
From:   Jared Rossi <jrossi@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Date:   Fri, 17 Apr 2020 14:29:39 -0400
Message-Id: <20200417182939.11460-2-jrossi@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200417182939.11460-1-jrossi@linux.ibm.com>
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_08:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=2
 impostorscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit prefetch check when using vfio-ccw devices.
This check is not needed as all Linux channel programs are intended
to use prefetch and will be executed in the same way regardless.

Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c  | 16 ++++------------
 drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
 drivers/s390/cio/vfio_ccw_fsm.c |  6 +++---
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3645d1720c4b..5b47ecbb4baa 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -625,9 +625,8 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
  * the target channel program from @orb->cmd.iova to the new ccwchain(s).
  *
  * Limitations:
- * 1. Supports only prefetch enabled mode.
- * 2. Supports idal(c64) ccw chaining.
- * 3. Supports 4k idaw.
+ * 1. Supports idal(c64) ccw chaining.
+ * 2. Supports 4k idaw.
  *
  * Returns:
  *   %0 on success and a negative error value on failure.
@@ -636,13 +635,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 {
 	int ret;
 
-	/*
-	 * XXX:
-	 * Only support prefetch enable mode now.
-	 */
-	if (!orb->cmd.pfch)
-		return -EOPNOTSUPP;
-
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
 	cp->mdev = mdev;
@@ -690,7 +682,7 @@ void cp_free(struct channel_program *cp)
 }
 
 /**
- * cp_prefetch() - translate a guest physical address channel program to
+ * cp_fetch() - translate a guest physical address channel program to
  *                 a real-device runnable channel program.
  * @cp: channel_program on which to perform the operation
  *
@@ -726,7 +718,7 @@ void cp_free(struct channel_program *cp)
  * Returns:
  *   %0 on success and a negative error value on failure.
  */
-int cp_prefetch(struct channel_program *cp)
+int cp_fetch(struct channel_program *cp)
 {
 	struct ccwchain *chain;
 	int len, idx, ret;
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index ba31240ce965..a226f6e99d04 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -45,7 +45,7 @@ struct channel_program {
 extern int cp_init(struct channel_program *cp, struct device *mdev,
 		   union orb *orb);
 extern void cp_free(struct channel_program *cp);
-extern int cp_prefetch(struct channel_program *cp);
+extern int cp_fetch(struct channel_program *cp);
 extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
 extern void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
 extern bool cp_iova_pinned(struct channel_program *cp, u64 iova);
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23e61aa638e4..446f9186d070 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -274,14 +274,14 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 			goto err_out;
 		}
 
-		io_region->ret_code = cp_prefetch(&private->cp);
+		io_region->ret_code = cp_fetch(&private->cp);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
+					   "%pUl (%x.%x.%04x): cp_fetch=%d\n",
 					   mdev_uuid(mdev), schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
-			errstr = "cp prefetch";
+			errstr = "cp fetch";
 			cp_free(&private->cp);
 			goto err_out;
 		}
-- 
2.17.0

