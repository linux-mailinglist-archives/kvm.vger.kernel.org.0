Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289FE56242A
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiF3Ug7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbiF3Ug6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:36:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8844D3ED3D;
        Thu, 30 Jun 2022 13:36:57 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UKS3XT016618;
        Thu, 30 Jun 2022 20:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i8sZm2519Uz9CcX3hB1tPR0O4n8Jj/FQGkJrR8FBA88=;
 b=CBlHdCYX3z7LZu3vxTtmbfJwCnek3rtkhxIKQ/NFRRZxr7RK0iq8kmwEbdXoYyAggtQl
 A8j9koy4bCufJJ171l6u1VNl1PKufInVGcw7PwWTx5dLfp8QCEnZaEOyQkR1GvUqtoZp
 u6zFHtvXH9pIJk0UK0mbtHjmMe41vuvG5g1Vulfy0g1IOR6PzcZZuBj3QfwOqefLh2Ax
 fOW6xlXpYqYdok2pBIr0wi8Dqgut7RCCEGTcDt9feuKb+9hOohdg1dTebbTm9ntGgpdI
 jAWe0Q5BPmUqk1xJYupMIT+DQyhTgCAnxSnnpeXiXRuklwovy74BvH6ryceCV/hI3sVn zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jw3858u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UKUD0g020765;
        Thu, 30 Jun 2022 20:36:54 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jw38586-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UKKu1s002731;
        Thu, 30 Jun 2022 20:36:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhxgbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKandh14614920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:36:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FBB6AE051;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F19CAAE04D;
        Thu, 30 Jun 2022 20:36:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 20:36:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id F3482E0293; Thu, 30 Jun 2022 22:36:48 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 04/11] vfio/ccw: Remove private->mdev
Date:   Thu, 30 Jun 2022 22:36:40 +0200
Message-Id: <20220630203647.2529815-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220630203647.2529815-1-farman@linux.ibm.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XO49SR00nQorSrjuS-cU7VBJ3pLowwM9
X-Proofpoint-GUID: P8mvCygpZQAtjYTFV2OCnVysEPmdjzni
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300077
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
index 7272eb788612..12b5537d478f 100644
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
2.32.0

