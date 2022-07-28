Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5EF58474F
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiG1U5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiG1U5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:57:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AA774CCC;
        Thu, 28 Jul 2022 13:57:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKqhtW006627;
        Thu, 28 Jul 2022 20:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qB68A5QY/wbdDNHTOiddBzK7bcdlG86Y2WXVCoS+teg=;
 b=DVNrfmZzqL/xrc6QSignjkkBxNLT8tuBGy94t9g26wvdJNa39yXzfdOTyhK6yLiza8VO
 0L+io93SjKP+h4z0Uog2+y6sYJ6HYuoA6g5yXPWsJ0Q3eGT7VcOArK9va5abzntmOJOz
 dnlqRblGrdrhL16OZJRK/oOdWzMwthkpVErdGJjFdB+slRs0DGGndEF/8JcFd2wLq1/F
 LdltZQ7nXixgTwmuGADf0z1wxyWfgAMO2Wl+v6JJX9p56UD+pqEpRJDimsu5uvuSFHiR
 IHBLWqJgo5aznxobYfWAtBDwNEeElqMNLkAHr/Opg3vOK1+UPldc7nO0VTcud5rcWt64 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1vm824k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SKqlvh006728;
        Thu, 28 Jul 2022 20:57:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1vm823m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SKpCkU017511;
        Thu, 28 Jul 2022 20:57:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97terxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SKv4XV26411462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 20:57:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9344652054;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8207E52051;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 0C112E0984; Thu, 28 Jul 2022 22:49:16 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 2/3] vfio/ccw: Remove FSM Close from remove handlers
Date:   Thu, 28 Jul 2022 22:49:13 +0200
Message-Id: <20220728204914.2420989-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728204914.2420989-1-farman@linux.ibm.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QvqYrv0iNXl0bfD1eKaf3GRV2sFICLv8
X-Proofpoint-ORIG-GUID: jY4dnPdJTUYokdJgaeCzGE7YQGjbXJso
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that neither vfio_ccw_sch_probe() nor vfio_ccw_mdev_probe()
affect the FSM state, it doesn't make sense for their _remove()
counterparts try to revert things in this way. Since the FSM open
and close are handled alongside MDEV open/close, these are
unnecessary.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 1 -
 drivers/s390/cio/vfio_ccw_ops.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 4804101ccb0f..86d9e428357b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -241,7 +241,6 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	mdev_unregister_device(&sch->dev);
 
 	dev_set_drvdata(&sch->dev, NULL);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 3f67fa103c7f..4a806a2273b5 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -130,8 +130,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&private->vdev);
 
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
-
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
 }
-- 
2.34.1

