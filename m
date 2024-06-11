Return-Path: <kvm+bounces-19321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A5B903BEF
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E02B6B25C3A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E8017C7A8;
	Tue, 11 Jun 2024 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ADVbWCdw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9017BB1B;
	Tue, 11 Jun 2024 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718109032; cv=none; b=Xe5CRNmgNcmy5cj/TamuxMGfernlnSw/HMpzc3b9U6zvSdUKZS0jDqGVIDs2odPzii69cmmLijpqpEJNIBn4ratwovUHxocDRRl/73Un2tBdA0T3HLt7vDU6xAFAMGcNH7P4ornHyVDBdrqm48uQzTM2UL8d7RmfmHKXAyM66NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718109032; c=relaxed/simple;
	bh=d030uywmqoc8ZrqaZgp0Y40mSx7AhB6mo7WAUY6xtds=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJ7qIAKj2w0+uQz6dhNT7XK7fZSsKZCowlanVkE5LrPrTIJf9OQUnS9cXkhGFhQL3vZJ6ggS/GlBBszSnvvO9ZWyDoqyFJtl1Qj9kEqogTlkejLeD8udQQgtlxC7hyuhznjh7B4q6L01npAa3VJRpkiF6JCEWIaGvi4HHC2cfTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ADVbWCdw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BBUqZS017562;
	Tue, 11 Jun 2024 12:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	HkP+tbp3uLxf4WdcO3PBJNiNRxX/u4/TYB8X5ieVVYo=; b=ADVbWCdwNj837qmE
	g7+sCAFMELK65LREIfXhsON4FJCSvTbHqNYkRPRY1M0XwW60Pkhi3LdV39mem7iK
	zahy1CEi+QNhnbRNIjHpcJGkvgUUO4xz68876u8TiJnAK5mYnPwHNET2W3A+KmAf
	OEn/UkvwBpnH9Z6qIJbd8d4y2xFyyMK0uQ0wATeZ4u/kitaYkwGVP4KsKmvJ0jXC
	VRcW/eo/P6ttewUOiGtjPZdbbLw1KLHcIH3YqWXI0Cq7aFUenEvoUvBt22klwU6e
	pksZ2kw1hJBYo6wF+xNYxM0O/sYUbpzRLTJSqV/I/4Tm8/MOvJFZKcNnbKAw7OPm
	JZZrfQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr1r3w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:30:14 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BCUEfC007296;
	Tue, 11 Jun 2024 12:30:14 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr1r3vt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:30:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BB7OEl020069;
	Tue, 11 Jun 2024 12:30:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn34mwn09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:30:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BCU6CC38011254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 12:30:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C15EA20040;
	Tue, 11 Jun 2024 12:30:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 990F32004F;
	Tue, 11 Jun 2024 12:30:03 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 12:30:03 +0000 (GMT)
Subject: [PATCH v3 5/6] powerpc/iommu: Move dev_has_iommu_table() to iommu.c
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
Date: Tue, 11 Jun 2024 12:30:03 +0000
Message-ID: <171810899821.1721.10732893379752118244.stgit@linux.ibm.com>
In-Reply-To: <171810893836.1721.2640631616827396553.stgit@linux.ibm.com>
References: <171810893836.1721.2640631616827396553.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: r58SjdmH83sxctc4WSafK16X9KeYhAqV
X-Proofpoint-GUID: OBh89jiXphfSmQ29BoMDVmL18ATobfrv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=980 priorityscore=1501 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406110092

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



