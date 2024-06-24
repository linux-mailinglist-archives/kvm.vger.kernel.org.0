Return-Path: <kvm+bounces-20399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0561D914A5E
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B7B3B23B9A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1990613DBAC;
	Mon, 24 Jun 2024 12:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YqjnrMyd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C413C9D5;
	Mon, 24 Jun 2024 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719232778; cv=none; b=jp8a1llwFKRpifYY7pUuOyHuiRpr/Vk57G2eb29Lq9tdLVVb+gP9hSWGvi95KLZwMhHPWT9dbMAIqsOr4BdNaAthzWFHj8zOULLYG/t0oINrfvlDWBbRfKf2ufSQQI/XL2eKPsaV2db0jy1Ep/ofEJhAXPEB/uxilwPcxIynD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719232778; c=relaxed/simple;
	bh=Qj+EjbdWIxvH4b3fRncMjvaBMLevK8K6CGzbyp4nwys=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tW5YVHNjQGr+a871i6HtyT1OrSrwMbLQxO7EzmyvwYxlr1eTiCxvLVouSLQcfmLzDDEEwhLAYrr3NCFrUjnFggkfgHwyCVBzdtfV7RMX7yObTFcpOowy3e67Gm8jurXuD6u7HuuPK5P0KztY1gzZtjM7FanUrZ+JfOrT1qTuytA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YqjnrMyd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OBwbsP032681;
	Mon, 24 Jun 2024 12:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	lr6e1+vfNrPfM49ecKxEgIZrNV9dBE4qOg6iv/LnnZI=; b=YqjnrMydEz96VdO8
	JR2jCtaMzjLHzbNtWiP1W1ltER6BmWB6oTSk6ZmW7iLVfcvfDxlr7aIvTkWScF6Y
	prHaeGww+c1SrSL2ixNWBT2Kap1EhU2EyCmUI+/pbc09RUeO2xlul38y09OgKvyU
	/DKSE9JDvmjWNPG3NhUoOWfLHcGQpPELM4uZpG5tVT1oanwNeyxNiTNvqweJnwlf
	qdEJPrxY1Rp23kRX0nFD9UUiO4F1P/7c8pmsj4PXAh5KnssY3JAKCgVfch/lJ9WT
	MrWL8J0dqoYLgFz7OyibiQi6qJpTWeUeVLr+QEZIGUEFZkuJzPmtyRHDu6GgZuF9
	KrxXrg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy8d1r3nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:39:21 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45OCdLF1013018;
	Mon, 24 Jun 2024 12:39:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy8d1r3np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:39:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45OAkMb4020074;
	Mon, 24 Jun 2024 12:39:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5m8eyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:39:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45OCdEjj26542668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 12:39:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69B2820043;
	Mon, 24 Jun 2024 12:39:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E775820040;
	Mon, 24 Jun 2024 12:39:10 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Jun 2024 12:39:10 +0000 (GMT)
Subject: [PATCH v4 5/6] powerpc/iommu: Move dev_has_iommu_table() to iommu.c
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        sanastasio@raptorengineering.com, linux-kernel@vger.kernel.org,
        joel@jms.id.au, kvm@vger.kernel.org, msuchanek@suse.de,
        oohall@gmail.com, mahesh@linux.ibm.com, jroedel@suse.de,
        vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Mon, 24 Jun 2024 12:39:10 +0000
Message-ID: <171923274748.1397.6274953248403106679.stgit@linux.ibm.com>
In-Reply-To: <171923268781.1397.8871195514893204050.stgit@linux.ibm.com>
References: <171923268781.1397.8871195514893204050.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9JEEWZzPW53U3nD_tLiZYnN8dE_qvGz6
X-Proofpoint-GUID: nsfg4u1k5BCy2KW3yklqppQJEs4TpS_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_09,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=976 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406240099

Move function dev_has_iommu_table() to powerpc/kernel/iommu.c
as it is going to be used by machine specific iommu code as
well in subsequent patches.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/include/asm/iommu.h |    6 ++++++
 arch/powerpc/kernel/eeh.c        |   16 ----------------
 arch/powerpc/kernel/iommu.c      |   17 +++++++++++++++++
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 744cc5fc22d3..b2fe6e7f81d6 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -220,6 +220,7 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 		enum dma_data_direction *direction);
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
+int dev_has_iommu_table(struct device *dev, void *data);
 
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
@@ -233,6 +234,11 @@ static inline int iommu_add_device(struct iommu_table_group *table_group,
 {
 	return 0;
 }
+
+static inline int dev_has_iommu_table(struct device *dev, void *data)
+{
+	return 0;
+}
 #endif /* !CONFIG_IOMMU_API */
 
 u64 dma_iommu_get_required_mask(struct device *dev);
diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 6670063a7a6c..d03f17987fca 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1273,22 +1273,6 @@ EXPORT_SYMBOL(eeh_dev_release);
 
 #ifdef CONFIG_IOMMU_API
 
-static int dev_has_iommu_table(struct device *dev, void *data)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_dev **ppdev = data;
-
-	if (!dev)
-		return 0;
-
-	if (device_iommu_mapped(dev)) {
-		*ppdev = pdev;
-		return 1;
-	}
-
-	return 0;
-}
-
 /**
  * eeh_iommu_group_to_pe - Convert IOMMU group to EEH PE
  * @group: IOMMU group
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b5febc6c7a5e..ed8204cfa319 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -988,6 +988,23 @@ unsigned long iommu_direction_to_tce_perm(enum dma_data_direction dir)
 EXPORT_SYMBOL_GPL(iommu_direction_to_tce_perm);
 
 #ifdef CONFIG_IOMMU_API
+
+int dev_has_iommu_table(struct device *dev, void *data)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev **ppdev = data;
+
+	if (!dev)
+		return 0;
+
+	if (device_iommu_mapped(dev)) {
+		*ppdev = pdev;
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * SPAPR TCE API
  */



