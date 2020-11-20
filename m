Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD12BB21D
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 19:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgKTSHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:07:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729284AbgKTSHw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:07:52 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKI47DT006530;
        Fri, 20 Nov 2020 13:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7eJtt7jySeBBBAuHDda7603FpWhcUCOIkSBdm6WMkrs=;
 b=VpOlQaN9t82XWI5+nGR77tnwI2iwnYF3BC6VKxIUcwhkKrDg+aOIcaxleOPDycd4tn8k
 ogY4f22GJj1rxb9u/8rQTotqGaaiD0ZVCq7CJd0khp52kPCEIa7P10pbh9GA9ZclCoek
 yRLsU9HuHmFRRcD6jYb5Fvk4QKOPSuNsYk5LRj97ZYMshyaP6x+F42McXf8Fhwdin4D0
 daxHFVEKQaHqMSE4jhtckjLbMP6wVc47BjlffbP9CdLdizWhCs2KknW7fYSF5vam/RBs
 VWMXfGBVSJNXDrhJRNuXY2vnj6ZS6wp9YksiJkiW/WHwNiDeFtL8+MykNBbmjy2hi0Ax Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xgu84e4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 13:07:49 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AKI7Mep021171;
        Fri, 20 Nov 2020 13:07:48 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xgu84e37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 13:07:48 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKI7kxn030282;
        Fri, 20 Nov 2020 18:07:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34w4yfjc53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 18:07:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKI7hYD62062850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 18:07:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 799E5A405F;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6274CA4062;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 20 Nov 2020 18:07:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 10407E23B2; Fri, 20 Nov 2020 19:07:43 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 1/2] vfio-mdev: Wire in a request handler for mdev parent
Date:   Fri, 20 Nov 2020 19:07:39 +0100
Message-Id: <20201120180740.87837-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120180740.87837-1-farman@linux.ibm.com>
References: <20201120180740.87837-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_09:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While performing some destructive tests with vfio-ccw, where the
paths to a device are forcible removed and thus the device itself
is unreachable, it is rather easy to end up in an endless loop in
vfio_del_group_dev() due to the lack of a request callback for the
associated device.

In this example, one MDEV (77c) is used by a guest, while another
(77b) is not. The symptom is that the iommu is detached from the
mdev for 77b, but not 77c, until that guest is shutdown:

    [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
    [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
    [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
    [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
    ...silence...

Let's wire in the request call back to the mdev device, so that a
device being physically removed from the host can be (gracefully?)
handled by the parent device at the time the device is removed.

Add a message when registering the device if a driver doesn't
provide this callback, so a clue is given that this same loop
may be encountered in a similar situation.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/vfio/mdev/mdev_core.c |  4 ++++
 drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
 include/linux/mdev.h          |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..6de97d25a3f8 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -154,6 +154,10 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	if (!dev)
 		return -EINVAL;
 
+	/* Not mandatory, but its absence could be a problem */
+	if (!ops->request)
+		dev_info(dev, "Driver cannot be asked to release device\n");
+
 	mutex_lock(&parent_list_lock);
 
 	/* Check for duplicate */
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0a28..06d8fc4a6d72 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -98,6 +98,15 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
+static void vfio_mdev_request(void *device_data, unsigned int count)
+{
+	struct mdev_device *mdev = device_data;
+	struct mdev_parent *parent = mdev->parent;
+
+	if (parent->ops->request)
+		parent->ops->request(mdev, count);
+}
+
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.name		= "vfio-mdev",
 	.open		= vfio_mdev_open,
@@ -106,6 +115,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.read		= vfio_mdev_read,
 	.write		= vfio_mdev_write,
 	.mmap		= vfio_mdev_mmap,
+	.request	= vfio_mdev_request,
 };
 
 static int vfio_mdev_probe(struct device *dev)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..9004375c462e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
  * @mmap:		mmap callback
  *			@mdev: mediated device structure
  *			@vma: vma structure
+ * @request:		request callback to release device
+ *			@mdev: mediated device structure
+ *			@count: request sequence number
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -92,6 +95,7 @@ struct mdev_parent_ops {
 	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
 			 unsigned long arg);
 	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+	void	(*request)(struct mdev_device *mdev, unsigned int count);
 };
 
 /* interface for exporting mdev supported type attributes */
-- 
2.17.1

