Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BE7D151
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbfGaWli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 18:41:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729527AbfGaWlg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Jul 2019 18:41:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VMfZpa105468
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 18:41:35 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u3hcrnuu1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 18:41:35 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Wed, 31 Jul 2019 23:41:30 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 31 Jul 2019 23:41:27 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VMfO5E51184120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 22:41:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 508A928058;
        Wed, 31 Jul 2019 22:41:24 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 878A028059;
        Wed, 31 Jul 2019 22:41:23 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.130.145])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 31 Jul 2019 22:41:23 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v5 3/7] s390: vfio-ap: implement in-use callback for vfio_ap driver
Date:   Wed, 31 Jul 2019 18:41:13 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19073122-0064-0000-0000-000004051B3C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011531; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01240262; UDB=6.00654007; IPR=6.01021683;
 MB=3.00027986; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-31 22:41:29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19073122-0065-0000-0000-00003E7E76AC
Message-Id: <1564612877-7598-4-git-send-email-akrowiak@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310226
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
 drivers/s390/crypto/vfio_ap_drv.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 9e61d4c6e6b5..d8da520ae1fa 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -158,6 +158,34 @@ static void vfio_ap_matrix_dev_destroy(void)
 	root_device_unregister(root_device);
 }
 
+static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	bool in_use = false;
+	struct ap_matrix_mdev *matrix_mdev;
+	DECLARE_BITMAP(apm_intrsctn, AP_DEVICES);
+	DECLARE_BITMAP(aqm_intrsctn, AP_DOMAINS);
+
+	mutex_lock(&matrix_dev->lock);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		bitmap_and(apm_intrsctn, apm, matrix_mdev->matrix.apm,
+			   AP_DEVICES);
+		if (find_first_bit_inv(apm_intrsctn, AP_DEVICES) == AP_DEVICES)
+			continue;
+
+		bitmap_and(aqm_intrsctn, aqm, matrix_mdev->matrix.aqm,
+			   AP_DOMAINS);
+		if (find_first_bit_inv(aqm_intrsctn, AP_DEVICES) == AP_DOMAINS)
+			continue;
+
+		in_use = true;
+	}
+
+	mutex_unlock(&matrix_dev->lock);
+
+	return in_use;
+}
+
 static int __init vfio_ap_init(void)
 {
 	int ret;
@@ -173,7 +201,9 @@ static int __init vfio_ap_init(void)
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
 	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
 	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.in_use = vfio_ap_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
+	vfio_ap_drv.driver.suppress_bind_attrs = true;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
-- 
2.7.4

