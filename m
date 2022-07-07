Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0B56A4B8
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiGGN64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiGGN5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345B821E18;
        Thu,  7 Jul 2022 06:57:48 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Da7kO015791;
        Thu, 7 Jul 2022 13:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fshv2UGR/4uJNuNe0Q6RLqKwvtEIF/eE87+ASMqiGQA=;
 b=hmR6ilwX+BBumFmNbUcnlD/qzoiOEPoVwxwiuA0Q0++/QlaXC0Z9h+Xz6vYlC9F9DXfm
 +oEy5Ldbmd5uSGiMGpWjeQE9Klkt2Im+I8wkxTKGExKFxaCSt0FrQF3C3+keJ7JyEqFD
 bYI9oE0tD8wugZmCdhBGODwdm+JAp4aKz5fnw+DC1vy5ET7pu87Wy1wwIq8hQ/8HarKo
 1EnrB89CRdFFBemB0L4Sa0/MQdBiyK+D9T/LWMYXkj+lY6dB3CTOB0SCHKzgLfTcsFf/
 EiGXyM2axGHfHkKVT6sFjy0lJkqhBMtOyEoL+u5iw8x2wlTb5IwdPK3unqTE06rBVW8F RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5wy6dnk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DaWBv017165;
        Thu, 7 Jul 2022 13:57:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5wy6dnj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267DuIZq000891;
        Thu, 7 Jul 2022 13:57:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3h4v4jtnsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267DvdGt23331078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:57:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BF6E11C054;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5960D11C050;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1D332E024A; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 04/11] vfio/ccw: Remove private->mdev
Date:   Thu,  7 Jul 2022 15:57:30 +0200
Message-Id: <20220707135737.720765-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0KaJoP65UYFrIZsyX2euYCPoLRNBfFlL
X-Proofpoint-GUID: pJNm876R-hk0hZvzeJDwOTpAUbUV7umT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no remaining users of private->mdev. Remove it.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_async.c   | 1 -
 drivers/s390/cio/vfio_ccw_ops.c     | 3 ---
 drivers/s390/cio/vfio_ccw_private.h | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_async.c b/drivers/s390/cio/vfio_ccw_async.c
index 7a838e3d7c0f..420d89ba7f83 100644
--- a/drivers/s390/cio/vfio_ccw_async.c
+++ b/drivers/s390/cio/vfio_ccw_async.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/vfio.h>
-#include <linux/mdev.h>
 
 #include "vfio_ccw_private.h"
 
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9a05dadcbb75..81377270d4a7 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -128,7 +128,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	vfio_init_group_dev(&private->vdev, &mdev->dev,
 			    &vfio_ccw_dev_ops);
 
-	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
@@ -145,7 +144,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 err_atomic:
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
-	private->mdev = NULL;
 	private->state = VFIO_CCW_STATE_STANDBY;
 	return ret;
 }
@@ -170,7 +168,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 
 	vfio_uninit_group_dev(&private->vdev);
 	cp_free(&private->cp);
-	private->mdev = NULL;
 	atomic_inc(&private->avail);
 }
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b7163bac8cc7..4d11ef48333e 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -73,7 +73,6 @@ struct vfio_ccw_crw {
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
  * @avail: available for creating a mediated device
- * @mdev: pointer to the mediated device
  * @nb: notifier for vfio events
  * @io_region: MMIO region to input/output I/O arguments/results
  * @io_mutex: protect against concurrent update of I/O regions
@@ -97,7 +96,6 @@ struct vfio_ccw_private {
 	int			state;
 	struct completion	*completion;
 	atomic_t		avail;
-	struct mdev_device	*mdev;
 	struct notifier_block	nb;
 	struct ccw_io_region	*io_region;
 	struct mutex		io_mutex;
-- 
2.34.1

