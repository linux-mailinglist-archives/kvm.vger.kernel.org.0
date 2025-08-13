Return-Path: <kvm+bounces-54600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D57B251D5
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B22D51C82643
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE7A2FE588;
	Wed, 13 Aug 2025 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y0jvKmOo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783862E8DF1;
	Wed, 13 Aug 2025 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104915; cv=none; b=MK+LwCZLM4cyVaLtH4N+6qk5CUnUgeU2XV51HgUcpn3mNmZUSquokih6zxChSyTADhorAx0KhmfaAWm1CywcxHHaTaK9um8kgP350nBELDEsPwE/WKtAVt8zgsW6LAveoue3qDMc0JCdgtE/uioRxf9DtZTYGrKUEGCwCylKXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104915; c=relaxed/simple;
	bh=H0olbHu3gddiL94/NLGS2A4nkln3us/u5UpnT6aTIRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgcO8+03lAKzFT5sJMP32DPKWAnTtEaXeV6Q7BO/hswRyZy8A6xoDVFiuFNKqQKLj/WBdQ/qbbzCOf38SE9IMLLc3uugZx3w0dimI9KkeDdG2t3aYeoBhzy5oNqWL/7NcLQg4DFNLLe5Wcxi5g4LJIebgSqzReFhfR/NuKZfQDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y0jvKmOo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DC2bkI016022;
	Wed, 13 Aug 2025 17:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=s4+QvAyAU4T2LjJZy
	CrXzDCEwplunuIPbU5pr6wVxMw=; b=Y0jvKmOoFhzALRfQWmF2jGT7/zP9B6rcj
	j4yd2VsKDgaIWI1baIOAENCARJyq96ReE/lhTZBQ6Z11pfl0mIkDbGOKnGuGMv6r
	5h95C1aX7jlHWPUJ49zUEXg2Sxd9tZnJjelkKRbNYI723SMujF3HnUzOhbEENSw8
	GcfjQR1Q4uqREmUJv1eWTr5mZFvpjsYW7tVxYlXB3Ck04VsLDKDA0c/Dbj/sTVlT
	zjBkpFcbFlJbLAwZDSTRecX8gN7tgpmIDFGPot9zu+jKuz2WMOPn+wdecxVD9kU8
	CRY0UbGFaFx5XDEWfsrghY87k5xTNiPN/7OWSriJL+JoI13zcDPIA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14nr0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DFWO34026270;
	Wed, 13 Aug 2025 17:08:28 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh218ej5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:28 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DH8RTm6619648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:08:27 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8503F5805F;
	Wed, 13 Aug 2025 17:08:27 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC7BB58054;
	Wed, 13 Aug 2025 17:08:26 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.61])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:08:26 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v1 4/6] vfio-pci/zdev: Setup a zpci memory region for error information
Date: Wed, 13 Aug 2025 10:08:18 -0700
Message-ID: <20250813170821.1115-5-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250813170821.1115-1-alifm@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J8QleAuRj_xwqWXR5g6_Qvacnq8rWzrI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX7R3ik6QwyMcK
 LFRSS1427xSogpnLpPF/n3gX6nbqQpQHNqjVTwciWRp2UEbOF7BLINnDGnGGOTRq9zRfsG2Xugz
 dvRq86HBW3eXsaCGxudQWtixpCZzz87GnLocLtcrhw31cSNhMsC2Exl9Mc99oYJH/Roahdu2shl
 Oov4lHKMPgp/ye8FBI412VWMFlsMvaUQntWupxAMBt9iVhIW3gvAiNExKdp0eg0Q1FJAnNkqGgb
 FfJFgbBUIp6ihJakFS93qRg0jwJC0u1qbG9SvcwYWR+0uamp1XGR5M4Zm84EJoDsrx2QBxoGjaK
 Sda8jxwR5UcJxcw27a1vN56IpBGXf5XlsrpnACzJygD2mFvsq+exQUxf4sniTk2Cw4mChnKl+aT
 pPjMTiJw
X-Proofpoint-GUID: J8QleAuRj_xwqWXR5g6_Qvacnq8rWzrI
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689cc68e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=F78Kq7YD1iUH8MtYH0wA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

For zpci devices, we have platform specific error information.
To enable recovery for passthrough devices, we want to expose
this error information to user space. We can expose this information
via a device specific (read only) memory region.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 76 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        |  2 +
 include/uapi/linux/vfio_zdev.h   |  5 +++
 3 files changed, 83 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2be37eab9279..818235b28caa 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -141,15 +141,91 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static ssize_t vfio_pci_zdev_read_err_region(struct vfio_pci_core_device *vdev,
+					    char __user *buf, size_t count,
+					    loff_t *ppos, bool iswrite)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	struct zpci_ccdf_err err;
+	struct vfio_device_zpci_err_region *region;
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	int head = 0;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	region = vdev->region[i].data;
+
+	if (!zdev)
+		return -ENODEV;
+
+	if (pos + count > vdev->region[i].size || iswrite)
+		return -EINVAL;
+
+	mutex_lock(&zdev->pending_errs_lock);
+	if (zdev->pending_errs.count) {
+		head = zdev->pending_errs.head % ZPCI_ERR_PENDING_MAX;
+		err = zdev->pending_errs.err[head];
+		region->pec = err.pec;
+		zdev->pending_errs.head++;
+		zdev->pending_errs.count--;
+		region->pending_errors = zdev->pending_errs.count;
+	}
+	mutex_unlock(&zdev->pending_errs_lock);
+
+	if (copy_to_user(buf, (void *)region + pos, count))
+		count = -EFAULT;
+
+	return count;
+}
+
+static void vfio_pci_zdev_release_err_region(struct vfio_pci_core_device *vdev,
+					     struct vfio_pci_region *region)
+{
+	struct vfio_device_zpci_err_region *err_region = region->data;
+
+	kfree(err_region);
+}
+
+static const struct vfio_pci_regops vfio_pci_zdev_err_regops = {
+	.rw = vfio_pci_zdev_read_err_region,
+	.release = vfio_pci_zdev_release_err_region
+};
+
+static int vfio_pci_zdev_setup_err_region(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_device_zpci_err_region *region;
+	int ret = 0;
+
+	region = kzalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+
+	ret = vfio_pci_core_register_dev_region(vdev,
+		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+		VFIO_REGION_SUBTYPE_IBM_ZPCI_ERROR_REGION,
+		&vfio_pci_zdev_err_regops,
+		sizeof(*region), VFIO_REGION_INFO_FLAG_READ, region);
+
+	if (ret)
+		kfree(region);
+
+
+	return ret;
+}
+
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	int ret;
 
 	if (!zdev)
 		return -ENODEV;
 
 	zdev->mediated_recovery = true;
 
+	ret = vfio_pci_zdev_setup_err_region(vdev);
+	if (ret)
+		return ret;
+
 	if (!vdev->vdev.kvm)
 		return 0;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009ba..452b87f3672e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -369,6 +369,8 @@ struct vfio_region_info_cap_type {
  */
 #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
 
+#define VFIO_REGION_SUBTYPE_IBM_ZPCI_ERROR_REGION (2)
+
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index 77f2aff1f27e..bcd06f334a42 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -82,4 +82,9 @@ struct vfio_device_info_cap_zpci_pfip {
 	__u8 pfip[];
 };
 
+struct vfio_device_zpci_err_region {
+	__u16 pec;
+	int pending_errors;
+};
+
 #endif
-- 
2.43.0


