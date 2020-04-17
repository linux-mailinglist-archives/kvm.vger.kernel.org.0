Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94051AD476
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 04:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgDQCaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 22:30:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728364AbgDQCaI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 22:30:08 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H24JPj073548
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:07 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f198kefm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:06 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 17 Apr 2020 03:29:45 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 03:29:44 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H2SuXB26542402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 02:28:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33427A4051;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 226FEA4040;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id B60C1E02D9; Fri, 17 Apr 2020 04:30:01 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 3/8] vfio-ccw: Refactor the unregister of the async regions
Date:   Fri, 17 Apr 2020 04:29:56 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417023001.65006-1-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20041702-0012-0000-0000-000003A5E6CE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041702-0013-0000-0000-000021E32913
Message-Id: <20200417023001.65006-4-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_10:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 mlxlogscore=870 suspectscore=2 bulkscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170010
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

