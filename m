Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299E81F024A
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgFEVma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:42:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729071AbgFEVm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:42:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LZpZc117290;
        Fri, 5 Jun 2020 17:42:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f90jtunu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:42:25 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LgPFV142732;
        Fri, 5 Jun 2020 17:42:25 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f90jtuja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:42:24 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055La6xB019638;
        Fri, 5 Jun 2020 21:41:19 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 31bf4bje2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:41:19 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeHVN8979232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:17 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE06AC059;
        Fri,  5 Jun 2020 21:40:17 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33EE4AC065;
        Fri,  5 Jun 2020 21:40:17 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:17 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 16/16] s390/vfio-ap: handle probe/remove not due to host AP config changes
Date:   Fri,  5 Jun 2020 17:40:04 -0400
Message-Id: <20200605214004.14270-17-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 cotscore=-2147483648 priorityscore=1501 mlxscore=0 impostorscore=0
 adultscore=0 suspectscore=3 malwarescore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050157
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
index cfe93ff9cc8c..5ee60dac7ad1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1681,6 +1681,15 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 	}
 }
 
+void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
+{
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	if (vfio_ap_mdev_config_shadow_apcb(q->matrix_mdev))
+		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1694,11 +1703,35 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
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
@@ -1706,6 +1739,11 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 
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

