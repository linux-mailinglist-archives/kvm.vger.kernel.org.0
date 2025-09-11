Return-Path: <kvm+bounces-57346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50329B53B83
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E679B1CC65AD
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC4936CDE4;
	Thu, 11 Sep 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jEdu7mJz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D783C36C06A;
	Thu, 11 Sep 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615598; cv=none; b=jlWRnYptbP2I19hVZGKY4g5AubQEHATYw6Lv/tEZIp62InMVXzXw3DHgK0NGMCCTgnYqSa+iN9M+p6uoarEm6+KLvL4yYml67Nq87nHYaz4UNH8kHfiz3gMxs7cpalvE8GGWpuAWcMBPOce1CS5zxk5fyGglhT8jW2nX0Lcb26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615598; c=relaxed/simple;
	bh=CRFypiDshZQc5tqdcgYif87R8KFZSyq2U5WddA5Orck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtC5iLW8uTj2Uka/KpglTXNRMFyMPaXWKCjy36iQBRjrzxlhP75FaT8LKpAKk6yX9U9l98yx3h22r7wd/A9q4uTUAwps+7tLjQxKSxz+Szd/L+gxsRiRcx3EP7whPsZ8Tmf+nY/WcxI2e7JIvyXQGEq21ZtipCzv3gpmNKyGmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jEdu7mJz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDTN9P025033;
	Thu, 11 Sep 2025 18:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zjZiV8Hj6I7WyQ3jH
	AOZSNNkP5uu8kVo+lPuflgkoiM=; b=jEdu7mJz+6qBMGhIwDvEixjdYDXWZiWqC
	drc3vHFOWBjbWUbv1OnC4j3pCwtlLEheMUkoWyPikKsGiWUGxwjq27xYn3TGf9H3
	XzrijGeEQX+zIOLlGzlao/WAxhOX/DcQmtPsw+dnmlUh2UZHpCClNOX5Wg39Uv9v
	9Zh2cTVX63/h8ZcQDLJ3vicoob56MN7pgST4kLYwn5Papls9xNnPZbn57R3WXoWK
	Lgn6sxxTcoPt8SEFVLsi6B/ghavIg7jWaHJBIxvV/SD5PN4UDcxInq8vVgHEGXTS
	mumtpnHo3FBUgG/7ch9TOhPu6xAqTLLPTMX1WkBWyb5rpS2GG1fqg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xydbgbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHZtOL010613;
	Thu, 11 Sep 2025 18:33:11 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn76nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:11 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXAHS26673806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:10 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16DF958057;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5597F58058;
	Thu, 11 Sep 2025 18:33:09 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:09 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 02/10] PCI: Add additional checks for flr reset
Date: Thu, 11 Sep 2025 11:32:59 -0700
Message-ID: <20250911183307.1910-3-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 6WPPhbVhyCMxPWi0itOdS486Ru7FlZPM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX7ACWFLMwwG3t
 L9k6MKZb/VEg9/Z/1lZ2NsbKAdA5nBVwXAnQlGcLEdMPt//II/r4tVkbS3MYdfqb+/GybzLOvk1
 ad6VqMPxx2YY+YQij53dQi1gZhA0Q/EWUk2PYOq2ymdI6fimRPFIhwicd6hnjTgb7EFZcmik9w0
 uMwl2aCI0dapDcAGNlR21/QyTg3/GAN0huCyY5ILaJgFkdxh3NmTQ5j8eUMZl1PZkx82FOn8J36
 Yn5Ag9pxUOZVPByhHCIqGGp0xqbQYAERIr5KZAS4Y7RQ4nKJfsalndQXGlhx3YUkIc9iI3JZ9QC
 Dqp0QVZ2BbFeFWdd2XSiNTD6AohwMlm2iYTgrfBG0sR+i+t/qxYF/5SnCRGwJx7hhdswsnaw7P/
 LRu8GKj4
X-Proofpoint-GUID: 6WPPhbVhyCMxPWi0itOdS486Ru7FlZPM
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c315e8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=8GLQ0EcgPjaQrAEZ2hkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

If a device is in an error state, then any reads of device registers can
return error value. Add addtional checks to validate if a device is in an
error state before doing an flr reset.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4b67d22faf0a..3994fa82df68 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4580,12 +4580,19 @@ EXPORT_SYMBOL_GPL(pcie_flr);
  */
 int pcie_reset_flr(struct pci_dev *dev, bool probe)
 {
+	u32 reg;
+
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return -ENOTTY;
 
 	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
 		return -ENOTTY;
 
+	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg)) {
+		pci_warn(dev, "Device unable to do an FLR\n");
+		return -ENOTTY;
+	}
+
 	if (probe)
 		return 0;
 
-- 
2.43.0


