Return-Path: <kvm+bounces-58682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2196DB9B053
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5884C7D58
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAEB31CA7F;
	Wed, 24 Sep 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="scCu2Ntu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B02531A7FE;
	Wed, 24 Sep 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734207; cv=none; b=YSR13kv+NtoPDkGDHwdsQsVDt2RtvJndstkvloOczO+XrhgJactlAMVhYD1kaUPHD3/lne6fQ12w5Et+j8fwoOFjUrZu/IzvI6fma5Asd73QY/0YuHFLzlWgdyLjAOjY/3JQdp81UDrMY6h+gJCqJgj+DWdv892+TSUhM7+d18o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734207; c=relaxed/simple;
	bh=7f1tPgGaOdUema3daP0tIwh/qEBb+lZsUgVn6G7qQIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTLDM0i3DxXTAAOhKgzdJOfRFALH9qGp7JqAMkIFW82PLjh8IHUw1ohoH5fVmFbejsp7Muuk6hm0g5iQ9cfhvKB4+hmZ4ErHVCA2a3C80jfmCjNODMGyA2h9SkYON2xkLMFsWXQeymDSORv3TfJke4GS/b7uXx3CVYigNEP3fPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=scCu2Ntu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OC0iLU025570;
	Wed, 24 Sep 2025 17:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=OZlRmUsoVE25Fkj72
	3JgZQlQAimm2Ubmq5yCrK6J0m0=; b=scCu2Ntu1nc1ku4e3jOARspkMWax3VgFx
	GDinmUFCB8wE32/UjwSpzVSAw/CrhqbIXmOxbMYAlQd4ihcqRkc1Zo/R2qTUmG+P
	nYorzhRKHRW7SZ8lGME7oqW6WRShczZ2S+lA7QXkruHFz9kqeW6+lJJ5OIAHl3KX
	r8N28V7LcU8XxPv4G27CYZmBvxNWqyfBA3a1o5AQXNSdvYV7cGD/77W2yVfuS2py
	XyBtOYwMCajTvcbTjrUroaTTtVSWWJNGEec2Ite0ykHsgIlu8a00It0AkCm24lBI
	uy0L0cLhcqGU1fzflyLeZaAeS2CSZQnasTvU8YVEcHXuvhpxXWz4A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpkgb41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OEm7ha030336;
	Wed, 24 Sep 2025 17:16:40 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a9a19f4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:40 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGc6k54133046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:38 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35E5858063;
	Wed, 24 Sep 2025 17:16:38 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7116F58056;
	Wed, 24 Sep 2025 17:16:37 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:37 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 06/10] s390/pci: Update the logic for detecting passthrough device
Date: Wed, 24 Sep 2025 10:16:24 -0700
Message-ID: <20250924171628.826-7-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924171628.826-1-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=L50dQ/T8 c=1 sm=1 tr=0 ts=68d42779 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=MtaQWmmsotiDqj5H3ecA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMCBTYWx0ZWRfX7eql0a1R+kyt
 MMu2Roq5/CXaQdzLnLb4U4Icprod3C7n2BczXY8su2Gpbfw9cuOO6WyKztFWqL3KSgMwK2sMyRj
 f6psg33/x0Gx38dzXW75G5xlzDIpKO3HULGechliq43IRHY/MsRTuDsADmlJ851cLIgjzUbJnY+
 ELIcSD7uIiCdil+xnkJEycQqOllJsEDyBvLoHvLUahnKqvmxOsR3LMHRMzzlDd+UUsIRA1zLutP
 Zs3yNqaIig/aPxevHCn2AzfEyWEJKR/MgjLwPW94Ll8sYH8ZLb6eEpXjwdpysFUzNrR44GpaFLJ
 ApngdQ5FOFNkm26m4p7easdmjATlux0lPQQKILL4qAA7VX4g0yDqgRvuKulh70r9gU67BNOsqlH
 VZpRNaQr
X-Proofpoint-ORIG-GUID: 3vei9bZDTqjT46VOIIaOSgfcA2qWBcsy
X-Proofpoint-GUID: 3vei9bZDTqjT46VOIIaOSgfcA2qWBcsy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200010

We can now have userspace drivers (vfio-pci based) on s390x. The userspace
drivers will not have any KVM fd and so no kzdev associated with them. So
we need to update the logic for detecting passthrough devices to not depend
on struct kvm_zdev.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
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


