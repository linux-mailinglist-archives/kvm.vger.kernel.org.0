Return-Path: <kvm+bounces-16274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB698B812A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 22:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71484B2544B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8661A1A38F3;
	Tue, 30 Apr 2024 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RdxBPSWT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6B199EA1;
	Tue, 30 Apr 2024 20:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714507631; cv=none; b=VO2FVNWIabLAkRNXvHy7rqsHN4tyLobIGl3Elqh30zzMglp5MZ6aA4z8WOEVfREM91rkym+eVILiv2HYqN3zjRhEp9A4VWZvgFJCjAfEe3l6SD+uLCFOnX5twdeeSY7A3Nsh+5wMks/t59KNOc1Ceqzu7Su9uTNIUlCvmgosiCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714507631; c=relaxed/simple;
	bh=xGULEwv/blIbYux+OCcl4aI00VXn/8RrY5tJ2plnBeY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDpzHjvZnvMhlkSJjmeUoNvpSJ8U6d+ISsGCWo1ERbXDK1Y+utNaFRcmFrMxGBvJkhZPICaO6A1b7r00OAP9iTEW477pDaq4pUHGQuRhtZVg1EBQu1AEbkycnYFogH/4Hi5O21kgInsqj8/eeIciRrWI5/EawjV4VnqlUSvzGKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RdxBPSWT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UK2XpQ007507;
	Tue, 30 Apr 2024 20:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Taq1ZO/iSE0JjUDIEg6XKqVv4GvsjOtU0Oo8ZhnxC8Y=;
 b=RdxBPSWTTWu0GzyDCl1fAP0C6i1ycL46W9XXxnUPO4/HyDc+/XsNvflMaXGHRZSpILQl
 sp6GY1TluOTKK7QaEKAeHTgSpUW+W61VaFO/f37e0d81y1D5YuZtAWBqmLK6eb122lWo
 djgwAXuMhHgOO/WrP4tUy+RqbyyQDu8Q7xYX94jlyzSOqE3zQCkpRB+pp8jT0d73joiw
 iiXQc5yCB47QQibygAQKt3Dt6mpSqKkZo7gIOPWXBFRGvPdYjk2N6ryyivC/pNmvOl8p
 Cp2PES4/bHNU04ZkQ2cQI9HflumzVHtqtChg+PQahz9Uvlf2IMTkAouM/CHyqcMTTPZL Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7aw80ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:53 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UK6qpQ013797;
	Tue, 30 Apr 2024 20:06:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7aw80eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:52 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43UItCsl001461;
	Tue, 30 Apr 2024 20:06:51 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xsbpty7dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:51 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UK6kpq16318796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 20:06:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E68220043;
	Tue, 30 Apr 2024 20:06:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAD8320040;
	Tue, 30 Apr 2024 20:06:42 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Apr 2024 20:06:42 +0000 (GMT)
Subject: [RFC PATCH v2 5/6] powerpc/iommu: Move dev_has_iommu_table() to
 iommu.c
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org,
        msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com,
        jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Tue, 30 Apr 2024 15:06:42 -0500
Message-ID: <171450759893.10851.5001066111916146610.stgit@linux.ibm.com>
In-Reply-To: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RoMVJVrhsKWDLPL4xuf0_X_36FK2NBZS
X-Proofpoint-GUID: o04C_gBA-Lo2NGUzKL0dFsYlIf6nZ9Nr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300144

Move function dev_has_iommu_table() to powerpc/kernel/iommu.c
as it is going to be used by machine specific iommu code as
well in subsequent patches.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/include/asm/iommu.h |    1 +
 arch/powerpc/kernel/eeh.c        |   16 ----------------
 arch/powerpc/kernel/iommu.c      |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 744cc5fc22d3..784809e34abe 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -220,6 +220,7 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 		enum dma_data_direction *direction);
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
+int dev_has_iommu_table(struct device *dev, void *data);
 
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index ab316e155ea9..37bfbef929b5 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1264,22 +1264,6 @@ EXPORT_SYMBOL(eeh_dev_release);
 
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
index bc4584e73061..31dc663be0cc 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -987,6 +987,23 @@ unsigned long iommu_direction_to_tce_perm(enum dma_data_direction dir)
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



