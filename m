Return-Path: <kvm+bounces-54601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53674B25183
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88AE57BD1CE
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC96D2FF179;
	Wed, 13 Aug 2025 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b0Fp/qNT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346D9303C95;
	Wed, 13 Aug 2025 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104916; cv=none; b=BuruKfqGoKR8/aDAdPsjVRZCBQtG5WZZuveDwdDYv6G1nWc49jR13XBkJL5lqN2A5zm0QWB5c3HXQbIgLH2YKDThUVW3qLjHII3T2LitEWd2dnipqLP5UOAVVJlWgC2S8ft+5MkDINkSFK2MWMPQlICWtip2NWNgLDR41CsS1kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104916; c=relaxed/simple;
	bh=xJeRrWUQX76AoRMTTqmxE3aohZSDfsAJ1LOzJ/NRqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR7FGp2dvLS+7fH7xnZV0Wdkt3hrRJcF9daTeI1gdXO3zjCfgbMuLgOE2BjvbuH0uFMtfe5HrWCSrZ4COoUw7yW11ZN+/GZ0SUCl2k2VVClrwXxXtzsa4sl6sfmsCIagm7nwhyZhgl8GWvSz/QWY3fuXyeyb6veC+cM7KV7BlLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b0Fp/qNT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DBFb24025093;
	Wed, 13 Aug 2025 17:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=++097ZMnQ+6MhsbVK
	0nfUKxQ9lpRaw6uDyOGWFXg2r8=; b=b0Fp/qNTToGs0m1odCWdUiCE3QC3/Llo9
	Tppp+iPCMURVyjg1CmYsvOQrpzJMccCEceOOZeOT+BQ3+tqY2mJI7B6c42rxg4Da
	eEPVs2SgHKX2TcRbDMzWIBB6cNYBhU/NNfyBF1zuBILdJBS5CFwEi0yJdBOuzZR0
	VwPluwZmSLg+LJBQesdaWwiw04peXYN2FwvTvKCKGbHflACp2ZRAFYmgJRSgFyyJ
	YzOl0Bono6YR93FG/osdtyF69OAERzNaUaS4a1+WXka39h2iLeb2iWrkTZFlK7nE
	rFpgw5srTs8xC2gfNRLV5n78ipruoH4qN7ND3qwIUz2OAwNnFqOrg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaaa0ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DGKolU028647;
	Wed, 13 Aug 2025 17:08:31 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5n8720-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:31 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DH8TFx18547278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:08:30 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E03C75805D;
	Wed, 13 Aug 2025 17:08:29 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10CCD5805A;
	Wed, 13 Aug 2025 17:08:29 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.61])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:08:28 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v1 6/6] vfio: Allow error notification and recovery for ISM device
Date: Wed, 13 Aug 2025 10:08:20 -0700
Message-ID: <20250813170821.1115-7-alifm@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=KPRaDEFo c=1 sm=1 tr=0 ts=689cc690 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=J_xkUs42lnTNXtJNwgwA:9
X-Proofpoint-ORIG-GUID: kTGjPGO53TDTmXq7EoQmN7QUWz69COI6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX18FvEKhl1O2Q
 9oWjALYTTUhlauptBeuq/uT3sRfe/tFF2zYUOp4WgerJH7eYBZXz7A+vKBfuhSlQ61bVHfOdWaa
 ELtAwTFLId85SCqxy5C9Hs/KJmEPVBh7UyvaxbiYQyp0j5nCCWflMNk/RwgahcVANmiWBaoXTpp
 eZx7lCJIXIMN5DwrYeI/0sSJXs0CxYJdfnWdUFFSEGGKt6CnoFTDDe/16qzaF+qhMgrM0eBYWJb
 GOqLLG2IEpei40m31StbC2xHw3kjCRjkYdowZELdeYrI54iOZ7udfyvemz6rxS0avDXnXfnnhyM
 +kiOOYauStUWW2F4/kBGDXN6oSdKDqzVLNYO9t6r6MwrioDOVsUJNHiBbX0DaKP0iIcpqXIgpfb
 2axUG9SQ
X-Proofpoint-GUID: kTGjPGO53TDTmXq7EoQmN7QUWz69COI6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120224

VFIO allows error recovery and notification for devices that
are PCIe (and thus AER) capable. But for PCI devices on IBM
s390 error recovery involves platform firmware and
notification to operating system is done by architecture
specific way. The Internal Shared Memory(ISM) device is a legacy
PCI device (so not PCIe capable), but can still be recovered
when notified of an error.

Relax the PCIe only requirement for ISM devices, so passthrough
ISM devices can be notified and recovered on error.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 18 ++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c |  2 +-
 drivers/vfio/pci/vfio_pci_priv.h  |  3 +++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7220a22135a9..1faab80139c6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -723,6 +723,20 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
+bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	if (pci_is_pcie(pdev))
+		return true;
+
+	if (pdev->vendor == PCI_VENDOR_ID_IBM &&
+			pdev->device == PCI_DEVICE_ID_IBM_ISM)
+		return true;
+
+	return false;
+}
+
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
@@ -749,7 +763,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
 	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
-		if (pci_is_pcie(vdev->pdev))
+		if (vfio_pci_device_can_recover(vdev))
 			return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
@@ -1150,7 +1164,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	case VFIO_PCI_REQ_IRQ_INDEX:
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
-		if (pci_is_pcie(vdev->pdev))
+		if (vfio_pci_device_can_recover(vdev))
 			break;
 		fallthrough;
 	default:
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..f5384086ac45 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -838,7 +838,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (pci_is_pcie(vdev->pdev))
+			if (vfio_pci_device_can_recover(vdev))
 				func = vfio_pci_set_err_trigger;
 			break;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5288577b3170..93c1e29fbbbb 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -36,6 +36,9 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite);
 
+bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev);
+
+
 #ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite);
-- 
2.43.0


