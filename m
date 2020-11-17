Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE52B57CB
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 04:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgKQDVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 22:21:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbgKQDVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 22:21:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH31eYK183733;
        Mon, 16 Nov 2020 22:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=wi95DkoN/LqptZ2D70P+Xd4mjTpxpQUTFHnIc74W7zs=;
 b=PwQ5HxQSUN19p2VJcE1qckunYVpr6vQYX32UQs9E99mwWvK6Hdy44sVI2ZDmt7FQvaRS
 8N5jU7idq5SQX8RHf0TIK9+I4AjS7Wjoni/4/N3ayz2OOKAmQEr9xuW+Tr62S1Gp4trX
 SQtVPx5Pq5MUgPWca1WxzWSGrOEAD8/+lNLH7s2uQVWMt76v4eeq8r/KoCFaAYlt4riF
 9BH6RbRiIYogQ8K/2Fm67cfSzIq5pBh95cpZJHi3GtUDth61evxjnylRiO5BiOXBMRET
 Zj/f5aFZklnO0azVEKg7iTJRKVmgdnbZgoPDssBrqJ9Q1WC9H7DEaebQKopW3u5K3uZK gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v6348knc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AH3JI9n043858;
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v6348kmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:45 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AH38G6Q003024;
        Tue, 17 Nov 2020 03:21:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh2ppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 03:21:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AH3LeBs55837146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:21:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51804204B;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2AC742045;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 64D8BE0661; Tue, 17 Nov 2020 04:21:40 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev parent
Date:   Tue, 17 Nov 2020 04:21:38 +0100
Message-Id: <20201117032139.50988-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117032139.50988-1-farman@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170020
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

Let's wire in the request call back to the mdev device, so that a hot
unplug can be (gracefully?) handled by the parent device at the time
the device is being removed.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 11 +++++++++++
 include/linux/mdev.h          |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0a28..2dd243f73945 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -98,6 +98,16 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
+static void vfio_mdev_request(void *device_data, unsigned int count)
+{
+	struct mdev_device *mdev = device_data;
+	struct mdev_parent *parent = mdev->parent;
+
+	if (unlikely(!parent->ops->request))
+		return;
+	parent->ops->request(mdev, count);
+}
+
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.name		= "vfio-mdev",
 	.open		= vfio_mdev_open,
@@ -106,6 +116,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.read		= vfio_mdev_read,
 	.write		= vfio_mdev_write,
 	.mmap		= vfio_mdev_mmap,
+	.request	= vfio_mdev_request,
 };
 
 static int vfio_mdev_probe(struct device *dev)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..0ed88be1f4bb 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
  * @mmap:		mmap callback
  *			@mdev: mediated device structure
  *			@vma: vma structure
+ * @request:		request callback
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

