Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A892262DB
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgGTPEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:04:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726675AbgGTPEi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 11:04:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KF4LK4171685;
        Mon, 20 Jul 2020 11:04:37 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d2m3arsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:36 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KF4RI7172033;
        Mon, 20 Jul 2020 11:04:28 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d2m3armh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:27 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEk1x6006386;
        Mon, 20 Jul 2020 15:04:15 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 32d5dpm8vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 15:04:15 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KF4BJo44695902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:04:11 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B690C6E04E;
        Mon, 20 Jul 2020 15:04:11 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E23E6E054;
        Mon, 20 Jul 2020 15:04:10 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.188.6])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 15:04:10 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v9 15/15] s390/vfio-ap: handle probe/remove not due to host AP config changes
Date:   Mon, 20 Jul 2020 11:03:44 -0400
Message-Id: <20200720150344.24488-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200720150344.24488-1-akrowiak@linux.ibm.com>
References: <20200720150344.24488-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 suspectscore=3 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AP queue devices are probed or removed for reasons other than changes
to the host AP configuration. For example:

* The state of an AP adapter can be dynamically changed from standby to
  online via the SE or by execution of the SCLP Configure AP command. When
  the state changes, each queue device associated with the card device
  representing the adapter will get created and probed.

* The state of an AP adapter can be dynamically changed from online to
  standby via the SE or by execution of the SCLP Deconfigure AP command.
  When the state changes, each queue device associated with the card device
  representing the adapter will get removed.

* Each queue device associated with a card device will get removed
  when the type of the AP adapter represented by the card device
  dynamically changes.

* Each queue device associated with a card device will get removed
  when the status of the queue represented by the queue device changes
  from operating to check stop.

* AP queue devices can be manually bound to or unbound from the vfio_ap
  device driver by a root user via the sysfs bind/unbind attributes of the
  driver.

In response to a queue device probe or remove that is not the result of a
change to the host's AP configuration, if a KVM guest is using the matrix
mdev to which the APQN of the queue device is assigned, the vfio_ap device
driver must respond accordingly. In an ideal world, the queue device being
probed would be hot plugged into the guest. Likewise, the queue
corresponding to the queue device being removed would
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
 drivers/s390/crypto/vfio_ap_ops.c | 84 +++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e6480f31a42b..b6a1e280991d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1682,6 +1682,61 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 	}
 }
 
+static bool vfio_ap_mdev_assign_shadow_apid(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
+			     matrix_mdev->shadow_apcb.aqm_max + 1) {
+		if (!vfio_ap_get_queue(AP_MKQID(apid, apqi)))
+			return false;
+	}
+
+	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
+	return true;
+}
+
+static bool vfio_ap_mdev_assign_shadow_apqi(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apqi)
+{
+	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
+			     matrix_mdev->shadow_apcb.apm_max + 1) {
+		if (!vfio_ap_get_queue(AP_MKQID(apid, apqi)))
+			return false;
+	}
+
+	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
+	return true;
+}
+
+static void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
+{
+	bool commit = false;
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	if (!test_bit_inv(apid, q->matrix_mdev->matrix.apm) ||
+	    !test_bit_inv(apqi, q->matrix_mdev->matrix.aqm))
+		return;
+
+	if (!test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
+		commit |= vfio_ap_mdev_assign_shadow_apid(q->matrix_mdev, apid);
+
+	if (!test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm))
+		commit |= vfio_ap_mdev_assign_shadow_apqi(q->matrix_mdev, apqi);
+
+	if (commit)
+		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1695,11 +1750,35 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
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
+	if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) &&
+	    test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm)) {
+		if (vfio_ap_mdev_unassign_guest_apid(q->matrix_mdev, apid))
+			vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+	}
+}
+
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1707,6 +1786,11 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 
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

