Return-Path: <kvm+bounces-57354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5DDB53B9F
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 794FEA06DE6
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB8F2DC798;
	Thu, 11 Sep 2025 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gcb/4Lc3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB7A2DC770;
	Thu, 11 Sep 2025 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615622; cv=none; b=QXQj1bWKRkyvtgwpp5ngf5LzKBo11JShuzikj5mCDfv/vjA0y1spGmoZXA9d9vxUDtJNqXX26ZKQmyc0llVXRQfwKpqeQ/AELDhZvs5wiP5fSWfGy9f5Z/gSay+u/SFqi6e76Xe2gXyC0FU/uThUG1xPIklu8xrt1Oo9bEiVHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615622; c=relaxed/simple;
	bh=HvTt5221H5DQ1X+GZWXY3QkHHnBA6eW/stRkoiAL7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZLRuzneqGbGVLuwfnQHPu8g5WkKyFP0JU9g6Vr8qefCsdSTItd3dBnhOz6dpfqPQIKU/KdYo0RmuMF50+KVp0rPRRMTyaeIeNnnr8Pi2EcTarNIi4kp59DcXuG818hMO7WiyGCxVMA4j87xlwCfYUDOpd7fz2+HyjPSHmML+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gcb/4Lc3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BA1afJ013271;
	Thu, 11 Sep 2025 18:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+c2kHIW89fFxZMF7i
	igDqHKPq5NHEczv6HmG2G6s5GY=; b=gcb/4Lc3+ItXqNSeu6FlwZIQ9ORO7Xb7Y
	s+qmEWxKeaUIKqqD5bShw2HB3OvbXc0zNrBqyxFXehc0wj0ZkJ8tWkXqMhdNpknQ
	T3fbR+repueFwdTN8cNukLYFiexdqy463ZtriDTF/AvsAEtjQWjaTsxNkFWVjcxd
	JPvqNooy3oka/AdUyz6ujD64atDDA8NUhL6phaHFyAQWvCHDmAT50oLxS5LAxnfJ
	NBM7KpB3ZF5BF3Ey9tezNaRc0wXB+sev8gEru40o7V2g9z3jW9NV0GH0SeiVHcy8
	W9hDd7y5vqYavJF5ZAw2xQsgf5UFodc1ug9I2y0FfP2sfOQUPR3sA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xydbgbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BIK3a0001163;
	Thu, 11 Sep 2025 18:33:18 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203q0b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:18 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXGYP35455596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:16 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7508C58058;
	Thu, 11 Sep 2025 18:33:16 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C467658057;
	Thu, 11 Sep 2025 18:33:15 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:15 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 10/10] vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX
Date: Thu, 11 Sep 2025 11:33:07 -0700
Message-ID: <20250911183307.1910-11-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250911183307.1910-1-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lGVpjyA4ijHYw0BA5iwJdXUm3XqB5caw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX94FDKZeZib8W
 N1zlDk3GxjoPxR/TFgIUd68U0rQuWOGtTuhE4jbOK6r6f2HsQ1CwvkyMHsix1SCVCQFZMpVpBj9
 4LJacXV4Amrq3kDNhZU1tFFqArVkK8TyvzGmRzJ2rZZQBi+zLaHyrR5GlVk1lV5/XUG2OwemcSD
 X4WbTa74VxBWOHK36YujNk8pUh9sexdOqlKXb/31+by7pn/gaeX/KjIgGlkTR+lnmCITAUWRpgR
 pyYI13za69i3ecwmJ3GoO18Pel6uazJiHhoynmGz3sZcVk15zjh10jIHvT/8EF4WLLfAM89hdQV
 oWrk+X7b6e51YwVV33pRK69pXJL07IJZDWIA/5ZCqw5ePYqHujmMOqLCOXrUZmCUDzc+V+ejB+3
 jbCbkJGY
X-Proofpoint-GUID: lGVpjyA4ijHYw0BA5iwJdXUm3XqB5caw
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c315ef cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=gONGJyW3jwFs4LhXXOUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

We are configuring the error signaling on the vast majority of devices and
it's extremely rare that it fires anyway. This allows userspace to be
notified on errors for legacy PCI devices. The Internal Share Memory (ISM)
device on s390x is one such device. For PCI devices on IBM s390x error
recovery involves platform firmware and notification to operating system
is done by architecture specific way. So the ISM device can still be
recovered when notified of an error.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 6 ++----
 drivers/vfio/pci/vfio_pci_intrs.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f2fcb81b3e69..d125471fd5ea 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -749,8 +749,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
 	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
-		if (pci_is_pcie(vdev->pdev))
-			return 1;
+		return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
 	}
@@ -1150,8 +1149,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	case VFIO_PCI_REQ_IRQ_INDEX:
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
-		if (pci_is_pcie(vdev->pdev))
-			break;
+		break;
 		fallthrough;
 	default:
 		return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..f2d13b6eb28f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -838,8 +838,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (pci_is_pcie(vdev->pdev))
-				func = vfio_pci_set_err_trigger;
+			func = vfio_pci_set_err_trigger;
 			break;
 		}
 		break;
-- 
2.43.0


