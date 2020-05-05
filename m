Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0887D1C5570
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgEEMaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:30:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727090AbgEEMaY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:30:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CTk3A082602;
        Tue, 5 May 2020 08:30:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50gju29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:30:19 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045CUF79085430;
        Tue, 5 May 2020 08:30:16 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50gjsfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:30:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CQBgI025404;
        Tue, 5 May 2020 12:27:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5py2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:27:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045CRjOR9765354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 12:27:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74F3C11C054;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61BB011C04A;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1DAF8E06AF; Tue,  5 May 2020 14:27:45 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 3/8] vfio-ccw: Refactor the unregister of the async regions
Date:   Tue,  5 May 2020 14:27:40 +0200
Message-Id: <20200505122745.53208-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505122745.53208-1-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_07:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is mostly for the purposes of a later patch, since
we'll need to do the same thing later.

While we are at it, move the resulting function call to ahead
of the unregistering of the IOMMU notifier, so that it's done
in the reverse order of how it was created.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---

Notes:
    v1->v2:
     - Add Conny's r-b

 drivers/s390/cio/vfio_ccw_ops.c     | 20 ++++++++++++--------
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f0d71ab77c50..d4fc84b8867f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -181,7 +181,6 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
-	int i;
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
@@ -191,15 +190,9 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 	}
 
 	cp_free(&private->cp);
+	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);
-
-	for (i = 0; i < private->num_regions; i++)
-		private->region[i].ops->release(private, &private->region[i]);
-
-	private->num_regions = 0;
-	kfree(private->region);
-	private->region = NULL;
 }
 
 static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
@@ -482,6 +475,17 @@ int vfio_ccw_register_dev_region(struct vfio_ccw_private *private,
 	return 0;
 }
 
+void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private)
+{
+	int i;
+
+	for (i = 0; i < private->num_regions; i++)
+		private->region[i].ops->release(private, &private->region[i]);
+	private->num_regions = 0;
+	kfree(private->region);
+	private->region = NULL;
+}
+
 static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 				   unsigned int cmd,
 				   unsigned long arg)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 9b9bb4982972..ce3834159d98 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -53,6 +53,7 @@ int vfio_ccw_register_dev_region(struct vfio_ccw_private *private,
 				 unsigned int subtype,
 				 const struct vfio_ccw_regops *ops,
 				 size_t size, u32 flags, void *data);
+void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private);
 
 int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
 
-- 
2.17.1

