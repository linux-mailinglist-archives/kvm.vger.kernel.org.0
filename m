Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED44B2747
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 23:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbfIMV13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 17:27:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387637AbfIMV1M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Sep 2019 17:27:12 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8DLGtkX021357;
        Fri, 13 Sep 2019 17:27:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v0jsygfdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 17:27:11 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8DLIJGr024320;
        Fri, 13 Sep 2019 17:27:10 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v0jsygfdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 17:27:10 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8DLK8N1005405;
        Fri, 13 Sep 2019 21:27:09 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2uyvqqk165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 21:27:09 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8DLR7me23069092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 21:27:07 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1ED928058;
        Fri, 13 Sep 2019 21:27:07 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B93F28059;
        Fri, 13 Sep 2019 21:27:07 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.152.57])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 13 Sep 2019 21:27:07 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v6 08/10] s390: vfio-ap: implement in-use callback for vfio_ap driver
Date:   Fri, 13 Sep 2019 17:26:56 -0400
Message-Id: <1568410018-10833-9-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
References: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-13_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909130213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the callback to indicate when an APQN
is in use by the vfio_ap device driver. The callback is
invoked whenever a change to the apmask or aqmask may
result in one or APQNs being removed from the driver. The
vfio_ap device driver will indicate a resource is in use
if any of the removed APQNs are assigned to any of the matrix
mdev devices.

To ensure that the AP bus apmask/aqmask interfaces are used to control
which AP queues get manually bound to or unbound from the
vfio_ap device driver, the bind/unbind sysfs interfaces will
be disabled for the vfio_ap device driver. The reasons for this are:

* To prevent unbinding an AP queue device from the vfio_ap device
  driver representing a queue that is assigned to an mdev device.

* To enforce the policy that the the AP resources must first be
  unassigned from the mdev device - which will hot unplug them from a
  guest using the mdev device - before changing ownership of APQNs
  from the vfio_ap driver to a zcrypt driver. This ensures that private
  crypto data intended for the guest will never be accessible from the
  host.

* It takes advantage of the AP architecture to prevent dynamic changes
  to the LPAR configuration using the SE or SCLP commands from
  compromising the guest crypto devices. For example:

  * Even if an adapter is configured off, if and when it is configured
    back on, the queue devices associated with the adapter will be bound
    back to the vfio_ap driver and the queues will automatically be
    available to a guest using the mdev to which the APQN of the queue
    device is assigned.

  * If adapters or domains are dynamically unassigned from the LPAR
    in which the linux guest is running, effective masking will
    prevent access to the AP resources by a guest using them.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  2 ++
 drivers/s390/crypto/vfio_ap_ops.c     | 11 +++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 9e61d4c6e6b5..477218e39289 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -173,7 +173,9 @@ static int __init vfio_ap_init(void)
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
 	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
 	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
+	vfio_ap_drv.driver.suppress_bind_attrs = true;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f3332424670f..d06fd9f0db23 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1431,3 +1431,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	vfio_ap_irq_disable(q);
 	kfree(q);
 }
+
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	bool in_use;
+
+	mutex_lock(&matrix_dev->lock);
+	in_use = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm) ? true : false;
+	mutex_unlock(&matrix_dev->lock);
+
+	return in_use;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 4a4e2c11fdf2..21546bb90240 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -104,4 +104,6 @@ struct vfio_ap_queue {
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.7.4

