Return-Path: <kvm+bounces-57350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F62B53BBA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB0967A7AC8
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1548D37428C;
	Thu, 11 Sep 2025 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="evVwYmY+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE23705B0;
	Thu, 11 Sep 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615602; cv=none; b=lyFAhy6gEvi4CPfkBND51+by4nNu9MdUmeZdKjD8ila0ZsDJhn3twAQqH45hfpQSMqvyC5g6XEy+MHifzxdqnlBhfr+OgVFi9O/XTMemQqAyAnDpGfbMYvhEquGdlYP33NjogSr+f7A6YO+vR2M88ZNacnik88PAHRK+hAGoIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615602; c=relaxed/simple;
	bh=HiF8yIXpdsl3GpcWw1U7Xg6P+sqRjiRYAkEPz33XzDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu8NMcOHVaEkMW9UD+aWc/WQKDTNs5juPdw1EQsk9EVBDZhW0TkoEzR8NGqO568NX9GgEhZKF+zTM8EHqd5njrI3oBOjHelHVFLq33mp+/bzlmFdYTyt8VwIFwqP5eX9TspdWa+K3IZD1kQJO5R1Q4ffCRg7C7j0Jp8lyhxdZLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=evVwYmY+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFlX61017992;
	Thu, 11 Sep 2025 18:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mmVlLOIe9nYcrSc3r
	Rudb0uYz3qoo02ifUZ1lexk/NU=; b=evVwYmY+XpcPy8hk54Jwnb5k2kgzhDcWb
	9XKiEcxICJUGh4B/xst7Iu/tHXUpJycZpzweT4Uckxeoi+8kBH4NwFrkGmTmaRTA
	kPxQZsmEFssMC2DYM5RlvzNOEwIFrMYOkqJGC1MW3F9t56vL2ahsZ/LDl9am5PWQ
	+mAi+39s/aj/J/habHwm7zI4IVMEWBwUnz1XhXMCbqV9LDFw3x8XhUpRG3yAdlMQ
	Vkbe2oeNGxvLc+XZ6WWyewOW7FLCveJggzV0OcRvI4BlaO97BMwB3eXulmMFZHxW
	PatWslDLLs7Mqa4H32Iv7CaRXDT9KE4mc3AMJhVoQ6UFnpRRgRmvQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukeu8jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHVSKV010666;
	Thu, 11 Sep 2025 18:33:14 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn76np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:14 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXDav26870456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:13 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41A0958057;
	Thu, 11 Sep 2025 18:33:13 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F48958059;
	Thu, 11 Sep 2025 18:33:12 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:12 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 06/10] s390/pci: Update the logic for detecting passthrough device
Date: Thu, 11 Sep 2025 11:33:03 -0700
Message-ID: <20250911183307.1910-7-alifm@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX45OE/jcCkoyO
 Rs4L9ICMbkk1DDP1gRSqU/5DOo1kMHYLigtxl7IV+xjBjqtsDLf72PGmtmJwB4AReb11+27sWW7
 8RAThjivKVA+EKTYvV2Gmd56zph83ZZBc4YCBmhLzMCuowK/cJ1rTI9+7L2tBx3IxlQiGPGXPBQ
 hpO+7T2v4sWOH9RJTZPfNDd16Jufr0bQLBRX3S1ZJ1FoodPHcHgVcKPHmwY0+7iXuu9Bqm2SsRZ
 uXfpHT/aATNmRYT2zz2/zEMwaGRFnOlD1cVAMfnZnWtw13HnaBYVlb8yT6ezxmikxpM0KZNz4eY
 Ir5JA97kJu/HChjco1qvvK0u9bHaOCsgCuNNHEDPiW4nMdpUaJ/+8JydYAfZ40mqaXH/KKdRiry
 Fx/WoQ8c
X-Proofpoint-ORIG-GUID: 82Exv7zzQ8yPjI-U5MYAJzU4W-FBQZDq
X-Proofpoint-GUID: 82Exv7zzQ8yPjI-U5MYAJzU4W-FBQZDq
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c315eb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=MtaQWmmsotiDqj5H3ecA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

We can now have userspace drivers (vfio-pci based) on s390x. The userspace
drivers will not have any KVM fd and so no kzdev associated with them. So
we need to update the logic for detecting passthrough devices to not depend
on struct kvm_zdev.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      |  1 +
 arch/s390/pci/pci_event.c        | 14 ++++----------
 drivers/vfio/pci/vfio_pci_zdev.c |  9 ++++++++-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index aed19a1aa9d7..f47f62fc3bfd 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -169,6 +169,7 @@ struct zpci_dev {
 
 	char res_name[16];
 	bool mio_capable;
+	bool mediated_recovery;
 	struct zpci_bar_struct bars[PCI_STD_NUM_BARS];
 
 	u64		start_dma;	/* Start of available DMA addresses */
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index d930416d4c90..541d536be052 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -61,16 +61,10 @@ static inline bool ers_result_indicates_abort(pci_ers_result_t ers_res)
 	}
 }
 
-static bool is_passed_through(struct pci_dev *pdev)
+static bool needs_mediated_recovery(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
-	bool ret;
-
-	mutex_lock(&zdev->kzdev_lock);
-	ret = !!zdev->kzdev;
-	mutex_unlock(&zdev->kzdev_lock);
-
-	return ret;
+	return zdev->mediated_recovery;
 }
 
 static bool is_driver_supported(struct pci_driver *driver)
@@ -194,7 +188,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 	}
 	pdev->error_state = pci_channel_io_frozen;
 
-	if (is_passed_through(pdev)) {
+	if (needs_mediated_recovery(pdev)) {
 		pr_info("%s: Cannot be recovered in the host because it is a pass-through device\n",
 			pci_name(pdev));
 		status_str = "failed (pass-through)";
@@ -277,7 +271,7 @@ static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es)
 	 * we will inject the error event and let the guest recover the device
 	 * itself.
 	 */
-	if (is_passed_through(pdev))
+	if (needs_mediated_recovery(pdev))
 		goto out;
 	driver = to_pci_driver(pdev->dev.driver);
 	if (driver && driver->err_handler && driver->err_handler->error_detected)
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 0990fdb146b7..a7bc23ce8483 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -148,6 +148,8 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 	if (!zdev)
 		return -ENODEV;
 
+	zdev->mediated_recovery = true;
+
 	if (!vdev->vdev.kvm)
 		return 0;
 
@@ -161,7 +163,12 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
 
-	if (!zdev || !vdev->vdev.kvm)
+	if (!zdev)
+		return;
+
+	zdev->mediated_recovery = false;
+
+	if (!vdev->vdev.kvm)
 		return;
 
 	if (zpci_kvm_hook.kvm_unregister)
-- 
2.43.0


