Return-Path: <kvm+bounces-55657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC99EB34859
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D102174149
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F1326E175;
	Mon, 25 Aug 2025 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aFiv2eDY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BCE3019B0;
	Mon, 25 Aug 2025 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141962; cv=none; b=XZu/wa9IY4GKLThsgOmd07x129sPcOJbEgdO+jLSRschV38n8jo7BNmVYy1e7d5glyGQa04GP1n+K6qu9OsRmAqkBtuHCfnDCUiMydjQShgSLwBJzfdXQAHl7j5JihX8urOzghvRvCp5JReZOtB79BY0A19K4r/Cz5mUHLAo730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141962; c=relaxed/simple;
	bh=ap8ZqAi3Gc/07bdX4XFTd8UIRfw9aj7EXhsR7evPuIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvgXNg721YddINAYux+My3Lx4vkkkbbO+zaNLDMIM8UKyuvbu6j6XkpMJYvOyuz6yWpsq484FUWa2nj9xA/QylWEGKE5XoRMP5DhL7VPd4uqn4lYWJCYzNz5m8omiCfavZnR05ALZUFWGLsYTabeDj6KmB8S/ym5LasG5T6jIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aFiv2eDY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PGXDc0021533;
	Mon, 25 Aug 2025 17:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qRiIPFXEObypK9lpw
	Whjwg8ySQsldPVM2VwQexmFjXM=; b=aFiv2eDYNFaR8/shXjLYiYNDYooRWeovx
	hs9qPtwXQJy1/O/uTvBJ7CyaNr7IaNf+HNhajuNDG7LuXv5Z4JxKJ0563WvvTmRv
	7ETzESvyMeHXflDNW1L0G7IzUZ125Lj/uV5B4Oc9mAim53B1GiBpUEEO+elPBpRQ
	/HBSUGApY/UyIpHQ9R+syAAUoLsQF/uEgPAT4Yl5CoEyehtbtqIZ5Qqngo4CvhbI
	nWZUYYkLgTywu11WZvtI9T/vZV+HFydeEGg6KOuO7D1yLXMubDORE8bXDjGcxYLk
	8K3jAAvO/LaU/slcNQz3gjq4NLhWhk1/loF83VQEh0/rA/3o+Ln+Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q42htapx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PE9S2r002531;
	Mon, 25 Aug 2025 17:12:35 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qrypex8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:34 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCXG323397110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:33 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4106558068;
	Mon, 25 Aug 2025 17:12:33 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3709858055;
	Mon, 25 Aug 2025 17:12:32 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:32 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 4/9] s390/pci: Restore airq unconditionally for the zPCI device
Date: Mon, 25 Aug 2025 10:12:21 -0700
Message-ID: <20250825171226.1602-5-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825171226.1602-1-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMCBTYWx0ZWRfXyAChJSIpk7qg
 mxqFFhJ8D3rzNKjZfLLkoM5edi27yIrfEkikIG8GNeBOWJD/pXH5qy0Dv+PLwhqvIc/SNMdEhFx
 Xlya6l9NKva5AO5KchG9e2Kam8GkgLEG7ZMrXL3KgeNjb2GfH6P/jwv6hvXlH5LvLv8p3UvGy3z
 ZzrJEhWE0fX+elmJJr8VrUg/t1eC97UBG2vqwKcOnPR8yzCmFiGr1IDt8b6k5JvxJ9uHTkWsysU
 Cu7p0Z5a0CXpECUHGlV20IZ2XwCBZKVhZtsmP0n8CBU0M6hIkvE9v4lo1hnYkFktLwZgBU+rQrp
 kKbZvezmtMnFmJna4K13GaAnDlfVFJXFfpWlYcFo69BxRGHKhJEy2Y0xIvw5FemAmxpSahcTu40
 JD1uv4JX
X-Proofpoint-ORIG-GUID: Bk8qRFMIwf-GQuUGUgcfDPsMK4lQKeSC
X-Proofpoint-GUID: Bk8qRFMIwf-GQuUGUgcfDPsMK4lQKeSC
X-Authority-Analysis: v=2.4 cv=evffzppX c=1 sm=1 tr=0 ts=68ac9983 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=gAMvz2k-Oe9gsD3n2XQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230010

Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
resetting a zPCI device.

Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
mentions zpci_clear_irq() being called in the path for zpci_hot_reset_device().
But that is not the case anymore and these functions are not called
outside of this file.

However after a CLP disable/enable reset (zpci_hot_reset_device),the airq
setup of the device will need to be restored. Since we are no longer
calling zpci_clear_airq() in the reset path, we should restore the airq for
device unconditionally.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/include/asm/pci.h | 1 -
 arch/s390/pci/pci_irq.c     | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 41f900f693d9..aed19a1aa9d7 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -145,7 +145,6 @@ struct zpci_dev {
 	u8		has_resources	: 1;
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
-	u8		irqs_registered	: 1;
 	u8		tid_avail	: 1;
 	u8		rtr_avail	: 1; /* Relaxed translation allowed */
 	unsigned int	devfn;		/* DEVFN part of the RID*/
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 84482a921332..e73be96ce5fe 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -107,9 +107,6 @@ static int zpci_set_irq(struct zpci_dev *zdev)
 	else
 		rc = zpci_set_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 1;
-
 	return rc;
 }
 
@@ -123,9 +120,6 @@ static int zpci_clear_irq(struct zpci_dev *zdev)
 	else
 		rc = zpci_clear_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 0;
-
 	return rc;
 }
 
@@ -427,8 +421,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
-	if (!zdev->irqs_registered)
-		zpci_set_irq(zdev);
+	zpci_set_irq(zdev);
 	return true;
 }
 
-- 
2.43.0


