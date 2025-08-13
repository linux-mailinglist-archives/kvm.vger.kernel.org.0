Return-Path: <kvm+bounces-54599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC88B251D2
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C1831C27D4C
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6281A2FA0F2;
	Wed, 13 Aug 2025 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mvsBEYhM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F222E5B0D;
	Wed, 13 Aug 2025 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104914; cv=none; b=mIVfzJ2iFvHxCmxqPHp/N6LRudSCk5Rf0BRwyqKWMnP4bmegUQlinBqtYHEdhD2iB/DuDci8uuj0UsCTbjnFIRwOiN+S1zYCMIoRuba9MogfvJwKOSMoDbKSPyTdJIRtBZi8WwpQxcRMpyjUreyI0k3Fm7q0LBpFkpSGZ4csZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104914; c=relaxed/simple;
	bh=3T7kuQCYzVkhAWp2iffagprx/aWKjjw5I1uGWW0oPrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpGE9e1uDGEzeX+ws/AmbT/HRevxooP/2sP3catD4LrZ7d/S9nE37HmPfJ19UAq883RkoqkJh4OftaalyGSI0vvp4wAK9Y77vl0np2/7h9qMrPIixGpojVDUy5klfPpEloTLnQN1gZiM+jMoQJm3HKhNSZIQJ8163D/J9D7U94w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mvsBEYhM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCeGP1015905;
	Wed, 13 Aug 2025 17:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6I9xSlQZgHAPcXdDL
	CXKu6L5Y+dGMZZl+x9bmedetxw=; b=mvsBEYhMOf5xzYSM4E/NCJFosy6WUp/g8
	Wy+hgX1TyNGz8qrzYafsY8ZIQi4Rj3zIeJFL52hZRHVZVCJdIlNfDUQSvZtoHvXJ
	a3A9EXqjJmynCy4yY4XAUXll5sMi/D3W6Ebax0Kb4i8RDNYs+EhT9Us2hVR/ytzW
	B3ie2lIBi0Gc8Eo1crBDaZTpbNVE8iZOpmim5pOeJe06Limra6uHDZygyel7Alfd
	qnncKUqS9b8sVYkDrk23cOV7rpXYLxNRIUO5rwlQAw8fIxmqQmHu+PBYaYkngioe
	8MSWeDFiL/gzVFXetCd1QGrSQ8tsXb5Fc84X3x/5BG0IlikQkYoMA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp5hqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DG5hin028629;
	Wed, 13 Aug 2025 17:08:30 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5n871x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:30 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DH8SjO5571164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:08:29 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D91CC58054;
	Wed, 13 Aug 2025 17:08:28 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B183958066;
	Wed, 13 Aug 2025 17:08:27 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.61])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:08:27 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function reset for zPCI
Date: Wed, 13 Aug 2025 10:08:19 -0700
Message-ID: <20250813170821.1115-6-alifm@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIxOSBTYWx0ZWRfXzfOY+vlojcEJ
 4PN57fdy4ybEZdBQJRmY6a3Cp//Vh006IGyPwGOQMmR0tfZ70wp/c/wjkPqY5JXWlM+nnVxA0oD
 7PIlIpCb0zWV4JC8NwXgs3cWbQiudfLYnjD1NaYM//MIeqHSY5MtxORIkdf6gkUYhGXyhQk1MDo
 a+O1WVeq0yK4YBK9pOEi87hDAEZSuMYM9j2vlIPEknN19Stfv/URpPOiFglf3MsyI2rB++1nofX
 0Z+PnBb8CdykavMy3vdwXYpm2tvuBsQ2KEeEPGu50H1QExTa0D6YM2n8+QrNDBDNPyull9xO8Kr
 6IMLTMAuh4WQa9q304ljiq3PvQH7caZBqrY0KPBp6hiZytEXywo/19bHXMEGduxVAgV/1uYTp0w
 XIsjB1PV
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=689cc68e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=JRqH6569gI3gnDwHsrMA:9
X-Proofpoint-GUID: rxwv5PeXgM7_w2I8l-of36dC8Ju2r9DO
X-Proofpoint-ORIG-GUID: rxwv5PeXgM7_w2I8l-of36dC8Ju2r9DO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120219

For zPCI devices we should drive a platform specific function reset
as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
in error state.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/pci/pci.c              |  1 +
 drivers/vfio/pci/vfio_pci_core.c |  4 ++++
 drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
 drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index f795e05b5001..860a64993b58 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -788,6 +788,7 @@ int zpci_hot_reset_device(struct zpci_dev *zdev)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_hot_reset_device);
 
 /**
  * zpci_create_device() - Create a new zpci_dev and add it to the zbus
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..7220a22135a9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1227,6 +1227,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	 */
 	vfio_pci_set_power_state(vdev, PCI_D0);
 
+	ret = vfio_pci_zdev_reset(vdev);
+	if (ret && ret != -ENODEV)
+		return ret;
+
 	ret = pci_try_reset_function(vdev->pdev);
 	up_write(&vdev->memory_lock);
 
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index a9972eacb293..5288577b3170 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -86,6 +86,7 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				struct vfio_info_cap *caps);
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
+int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
@@ -100,6 +101,10 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 
 static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 {}
+int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
+{
+	return -ENODEV;
+}
 #endif
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 818235b28caa..dd1919ccb3be 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -212,6 +212,45 @@ static int vfio_pci_zdev_setup_err_region(struct vfio_pci_core_device *vdev)
 	return ret;
 }
 
+int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	int rc = -EIO;
+
+	if (!zdev)
+		return -ENODEV;
+
+	/*
+	 * If we can't get the zdev->state_lock the device state is
+	 * currently undergoing a transition and we bail out - just
+	 * the same as if the device's state is not configured at all.
+	 */
+	if (!mutex_trylock(&zdev->state_lock))
+		return rc;
+
+	/* We can reset only if the function is configured */
+	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
+		goto out;
+
+	rc = zpci_hot_reset_device(zdev);
+	if (rc != 0)
+		goto out;
+
+	if (!vdev->pci_saved_state) {
+		pci_err(vdev->pdev, "No saved available for the device");
+		rc = -EIO;
+		goto out;
+	}
+
+	pci_dev_lock(vdev->pdev);
+	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
+	pci_restore_state(vdev->pdev);
+	pci_dev_unlock(vdev->pdev);
+out:
+	mutex_unlock(&zdev->state_lock);
+	return rc;
+}
+
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
-- 
2.43.0


