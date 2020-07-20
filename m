Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA4A2262C6
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 17:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgGTPEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:04:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbgGTPEI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 11:04:08 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KF3nom191673;
        Mon, 20 Jul 2020 11:04:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5h7r0v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KF46oQ193655;
        Mon, 20 Jul 2020 11:04:06 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5h7r0pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:06 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEjVQi007070;
        Mon, 20 Jul 2020 15:04:01 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 32brq8j0gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 15:04:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KF3uAH60358930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:03:56 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7272F6E052;
        Mon, 20 Jul 2020 15:03:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C6CD6E04E;
        Mon, 20 Jul 2020 15:03:57 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.188.6])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 15:03:57 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v9 05/15] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Mon, 20 Jul 2020 11:03:34 -0400
Message-Id: <20200720150344.24488-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200720150344.24488-1-akrowiak@linux.ibm.com>
References: <20200720150344.24488-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=3
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the callback to indicate when an APQN
is in use by the vfio_ap device driver. The callback is
invoked whenever a change to the apmask or aqmask would
result in one or more queue devices being removed from the driver. The
vfio_ap device driver will indicate a resource is in use
if the APQN of any of the queue devices to be removed are assigned to
any of the matrix mdevs under the driver's control.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 68 ++++++++++++++++++++-------
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 24cdef60039a..aae5b3d8e3fa 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -175,6 +175,7 @@ static int __init vfio_ap_init(void)
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
 	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
 	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2e37ee82e422..fc1aa6f947eb 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -515,18 +515,36 @@ vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
+			 "already assigned to %s"
+
+static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
+					 unsigned long *apm,
+					 unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES)
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
+			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);
+}
+
 /**
  * vfio_ap_mdev_verify_no_sharing
  *
  * Verifies that the APQNs derived from the cross product of the AP adapter IDs
- * and AP queue indexes comprising the AP matrix are not configured for another
+ * and AP queue indexes comprising an AP matrix are not assigned to another
  * mediated device. AP queue sharing is not allowed.
  *
  * @matrix_mdev: the mediated matrix device
+ * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
+ * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
  *
  * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
  */
-static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
+					  unsigned long *mdev_apm,
+					  unsigned long *mdev_aqm)
 {
 	struct ap_matrix_mdev *lstdev;
 	DECLARE_BITMAP(apm, AP_DEVICES);
@@ -543,14 +561,15 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
-				lstdev->matrix.apm, AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				lstdev->matrix.aqm, AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
 			continue;
 
+		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
+					     apm, aqm);
+
 		return -EADDRINUSE;
 	}
 
@@ -676,6 +695,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm, AP_DEVICES);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -701,18 +721,18 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto done;
 
-	set_bit_inv(apid, matrix_mdev->matrix.apm);
+	memset(apm, 0, sizeof(apm));
+	set_bit_inv(apid, apm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
+	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
+					     matrix_mdev->matrix.aqm);
 	if (ret)
-		goto share_err;
+		goto done;
 
+	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
 	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apid, matrix_mdev->matrix.apm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
@@ -824,6 +844,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
@@ -844,18 +865,18 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto done;
 
-	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
+	memset(aqm, 0, sizeof(aqm));
+	set_bit_inv(apqi, aqm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
+	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev,
+					     matrix_mdev->matrix.apm, aqm);
 	if (ret)
-		goto share_err;
+		goto done;
 
+	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
 	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1434,3 +1455,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
+
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	bool in_use;
+
+	mutex_lock(&matrix_dev->lock);
+	in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return in_use;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 57da703b549a..0c796ef11426 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -105,4 +105,6 @@ struct vfio_ap_queue {
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

