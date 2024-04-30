Return-Path: <kvm+bounces-16273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A19988B8121
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 22:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C1A728A510
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB28519DF47;
	Tue, 30 Apr 2024 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QQKPJXcb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD14199E9B;
	Tue, 30 Apr 2024 20:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714507607; cv=none; b=jshxRpQDbQ/yC6W+YgRRlZ/B6dS4F5bhC8adBj3j8SvurXT1ekqcyBBEwYr1KBr6iW4vYyaQZpAsoZrBGejU4WxI3bkNC3HJspj0laIymPW22A7kSGEpHVK4mlpX+jSjps7iZExioFH4gCEGk7GHlJ6FeHYd/y1ED89qobECIV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714507607; c=relaxed/simple;
	bh=UGUeKEUQ1nBBsRp8hnt0EXyp3mGbhUhQXTX/Q6dpar4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSCoS5qihBHNy9kcj04S9YyhBDczfhgDhk9clmyZEZQ/XrGVFF6NkXvD/dL3jNpN1ee/ZJ95F8lzQgeqGiqiXB8IZYGp/suUG71ahJpxBoqiUyWXGvprxtdz3P6P/CctUJkuEBf1/JTakz9OXard1dT5L79Vpai2VmdfE3p8cxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QQKPJXcb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UK2KVI014595;
	Tue, 30 Apr 2024 20:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gfHCx0QonruGjPUxFkWAYoB+5yJ1TnNAcZXRms41D74=;
 b=QQKPJXcbIQx/79gIVHv5z1XV47ss7pklLxwDmBDBiufJFvTSpT9KkTG20+OdFaIC586u
 /cW+6gfuq/0O1+1kRlLcPsykvd8yXpxryc2EsstdgqYe86nGAp1d2Q+e2o0dk2bzH27L
 BicdFs76OhKs8W9fuCCOYoifNtSEMpotjJeg2DSptc+wIC750cmRoYJ2dtYBHW0T1wRU
 nBPgmd8XqpAQ6WfaF73TdWmy4B3/F+I6th6tdMty6Aq1xVpx/3mbXWJ+gXUcFD6e+SFp
 6X/trMn1h1++OzzjsPC3iDULzuNeoL/Oj++xpVy+h2PueUVnXmnsC3WSOTvzXkArH3yL fg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7axg0dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:28 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UK6Sar021485;
	Tue, 30 Apr 2024 20:06:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7axg0dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:27 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43UH4uj7022182;
	Tue, 30 Apr 2024 20:06:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsd6mpuh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UK6LK832440962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 20:06:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB5452004D;
	Tue, 30 Apr 2024 20:06:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52F6520040;
	Tue, 30 Apr 2024 20:06:17 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Apr 2024 20:06:17 +0000 (GMT)
Subject: [RFC PATCH v2 3/6] powerpc/pseries/iommu: Use the iommu table[0] for
 IOV VF's DDW
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
Date: Tue, 30 Apr 2024 15:06:16 -0500
Message-ID: <171450757310.10851.13545072850696605337.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RK6fm06hRTZ8sq-gLswmyNIFdYveIDJ2
X-Proofpoint-GUID: hRlu20WOBcqxXW-Q_QNn6-PyJu6vJiEf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=974 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300144

This patch basically brings consistency with PowerNV approach
to use the first freely available iommu table when the default
window is removed.

The pSeries iommu code convention has been that the table[0] is
for the default 32 bit DMA window and the table[1] is for the
64 bit DDW.

With VFs having only 1 DMA window, the default has to be removed
for creating the larger DMA window. The existing code uses the
table[1] for that, while marking the table[0] as NULL. This is
fine as long as the host driver itself uses the device.

For the VFIO user, on pSeries there is no way to skip table[0]
as the VFIO subdriver uses the first freely available table.
The window 0, when created as 64-bit DDW in that context would
still be on table[0], as the maximum number of windows is 1.

This won't have any impact for the host driver as the table is
fetched from the device's iommu_table_base.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 5b68a4918d63..e701255560a6 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -155,7 +155,7 @@ static void iommu_pseries_free_group(struct iommu_table_group *table_group,
 #endif
 
 	/* Default DMA window table is at index 0, while DDW at 1. SR-IOV
-	 * adapters only have table on index 1.
+	 * adapters only have table on index 0(if not direct mapped).
 	 */
 	if (table_group->tables[0])
 		iommu_tce_table_put(table_group->tables[0]);
@@ -1519,6 +1519,11 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 			clean_dma_window(pdn, win64->value);
 			goto out_del_list;
 		}
+		if (default_win_removed) {
+			iommu_tce_table_put(pci->table_group->tables[0]);
+			pci->table_group->tables[0] = NULL;
+			set_iommu_table_base(&dev->dev, NULL);
+		}
 	} else {
 		struct iommu_table *newtbl;
 		int i;
@@ -1548,15 +1553,12 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 					    1UL << len, page_shift, NULL, &iommu_table_lpar_multi_ops);
 		iommu_init_table(newtbl, pci->phb->node, start, end);
 
-		pci->table_group->tables[1] = newtbl;
+		pci->table_group->tables[default_win_removed ? 0 : 1] = newtbl;
 
 		set_iommu_table_base(&dev->dev, newtbl);
 	}
 
 	if (default_win_removed) {
-		iommu_tce_table_put(pci->table_group->tables[0]);
-		pci->table_group->tables[0] = NULL;
-
 		/* default_win is valid here because default_win_removed == true */
 		of_remove_property(pdn, default_win);
 		dev_info(&dev->dev, "Removed default DMA window for %pOF\n", pdn);



