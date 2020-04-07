Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD71A15BF
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgDGTUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:20:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12518 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727611AbgDGTUr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:47 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J4SMi117309;
        Tue, 7 Apr 2020 15:20:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306n25knud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:43 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J4YB8117562;
        Tue, 7 Apr 2020 15:20:43 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306n25knu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:43 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKV8m011500;
        Tue, 7 Apr 2020 19:20:42 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 306hv6s2dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:42 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKe5S54460704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:40 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 753312805A;
        Tue,  7 Apr 2020 19:20:40 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA15728058;
        Tue,  7 Apr 2020 19:20:39 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 15/15] s390/vfio-ap: handle probe/remove not due to host AP config changes
Date:   Tue,  7 Apr 2020 15:20:15 -0400
Message-Id: <20200407192015.19887-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=3 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AP queue devices are probed or removed for reasons other than changes
to the host AP configuration:

* Each queue device associated with a card device will get created and
  probed when the state of the AP adapter represented by the card device
  dynamically changes from standby to online.

* Each queue device associated with a card device will get removed
  when the state of the AP adapter to which the queue represented by the
  queue device dynamically changes from online to standby.

* Each queue device associated with a card device will get removed
  when the type of the AP adapter to which the queue represented by the
  queue device dynamically changes.

* Each queue device associated with a card device will get removed
  when the status of the queue represented by the queue device changes
  from operating to check stop.

* AP queue devices can be manually bound to or unbound from the vfio_ap
  device driver by a root user via the sysfs bind/unbind attributes of the
  driver.

In response to a queue device probe or remove that is not the result of a
change to the host's AP configuration, if a KVM guest is using the matrix
mdev to which the APQN of the queue device is assigned, the vfio_ap device
driver must respond accordingly. In an ideal world, the queue corresponding
to the queue device being probed would be hot plugged into the guest.
Likewise, the queue corresponding to the queue device being removed would
be hot unplugged from the guest. Unfortunately, the AP architecture
precludes plugging or unplugging individual queues, so let's handle
the probe or remove of an AP queue device as follows:

Handling Probe
--------------
There are two requirements that must be met in order to give a
guest access to the queue corresponding to the queue device being probed:

* Each APQN derived from the APID of the queue device and the APQIs of the
  domains already assigned to the guest's AP configuration must reference
  a queue device bound to the vfio_ap device driver.

* Each APQN derived from the APQI of the queue device and the APIDs of the
  adapters assigned to the guest's AP configuration must reference a queue
  device bound to the vfio_ap device driver.

If the above conditions are met, the APQN will be assigned to the guest's
AP configuration and the guest will be given access to the queue.

Handling Remove
---------------
Since the AP architecture precludes us from taking access to an individual
queue from a guest, we are left with the choice of taking access away from
either the adapter or the domain to which the queue is connected. Access to
the adapter will be taken away because it is likely that most of the time,
the remove callback will be invoked because the adapter state has
transitioned from online to standby. In such a case, no queue connected
to the adapter will be available to access.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 38 +++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ccc58daf82f6..918b735d5d56 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1601,6 +1601,15 @@ static void vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
 	}
 }
 
+void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
+{
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	if (vfio_ap_mdev_configure_crycb(q->matrix_mdev))
+		vfio_ap_mdev_commit_crycb(q->matrix_mdev);
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1615,11 +1624,35 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_mdev_for_queue(q);
 	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
+	/* Make sure we're not in the middle of an AP configuration change. */
+	if (!(matrix_dev->flags & AP_MATRIX_CFG_CHG))
+		vfio_ap_mdev_hot_plug_queue(q);
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
 
+void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	/*
+	 * If the APQN is assigned to the guest, then let's
+	 * go ahead and unplug the adapter since the
+	 * architecture does not provide a means to unplug
+	 * an individual queue.
+	 */
+	if (test_bit_inv(apid, q->matrix_mdev->shadow_crycb.apm) &&
+	    test_bit_inv(apqi, q->matrix_mdev->shadow_crycb.aqm)) {
+		if (vfio_ap_mdev_unassign_guest_apid(q->matrix_mdev, apid))
+			vfio_ap_mdev_commit_crycb(q->matrix_mdev);
+	}
+}
+
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1627,6 +1660,11 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&queue->ap_dev.device);
+
+	/* Make sure we're not in the middle of an AP configuration change. */
+	if (!(matrix_dev->flags & AP_MATRIX_CFG_CHG))
+		vfio_ap_mdev_hot_unplug_queue(q);
+
 	dev_set_drvdata(&queue->ap_dev.device, NULL);
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
-- 
2.21.1

