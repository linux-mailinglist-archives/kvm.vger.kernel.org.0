Return-Path: <kvm+bounces-19318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6957B903BE7
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7691F252C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709BB17C7A9;
	Tue, 11 Jun 2024 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GvaO4GGM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079D217BB05;
	Tue, 11 Jun 2024 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718109009; cv=none; b=DGevyI3RM0FbSxiUYhkEy+2/Sl3tbn5cm4J8518yYpzEBrB2yGx8Nga7Xdl0vaWBuput6OLzXhlWqEBigMHK2f8wmRLYuoH5RMXcdyoSMdPD/GqX+hrL0uyqMDlG0Qa9G2L99CPjPaEPMrDvzpBYawGcnr9kTo3Dhwhfj1kXo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718109009; c=relaxed/simple;
	bh=+sxy9OJ4Z8Q+mxtLmjMGvtjUajYmNdbcYkCday/yO4U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=einXb/VqUCxk4rZkElsEaD6a6h2+8Gr8XfEdCo2KjC3BoFW1HMBdRVspEgCY8znhumJei/4L37ZVq5KqtY4UsYpGoFwJ/gA4rpbEc5XX1aWCgXzV+ezQhOVmBZ2Ku1z6obv4Jloa1ThBqGWxxDHOlhufF0PC8XjYi3QxbWbul0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GvaO4GGM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BCRHbN028122;
	Tue, 11 Jun 2024 12:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	Ie3B94Z/ucL+3HCaOf6G6Yji6qwBDT76JQ3WdI2p8qQ=; b=GvaO4GGMip9b2rMl
	bBakHYz/x1l97COnc3FStPCW2ErFRYxbddchLsmwYEtTv0kZlJwGDjQR4pc2XVPf
	SwZgfaIwSTkTcNbZb4lrTVHeuvDX2RrEIzVicmUCJshj7QChFDLKUeg6LHfBr2ms
	Y4LLTbSG4ZnRoDuzq1+6zRW8mKVHshAo5RbkCLTW6awhoqjy5R33tbiWCZxD2l96
	pLkcIuN67xfzAxyoIj9riFiXy6x5U/bWF1m2J7gFQwyIhW+93ClcaWIFI+Mx8oRZ
	SKSeHffS8DG2PcnT2a8pqUCh7M3VgvXHu0JJZ38yx0IWV7YOQF78n5300ofMFzMB
	iSHx3Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypp6b81xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BCTlin000923;
	Tue, 11 Jun 2024 12:29:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypp6b81xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BAhaJL003886;
	Tue, 11 Jun 2024 12:29:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mpnqwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BCTe4638207958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 12:29:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92F0620040;
	Tue, 11 Jun 2024 12:29:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 274B92004B;
	Tue, 11 Jun 2024 12:29:37 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 12:29:36 +0000 (GMT)
Subject: [PATCH v3 3/6] powerpc/pseries/iommu: Use the iommu table[0] for IOV
 VF's DDW
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
Date: Tue, 11 Jun 2024 12:29:36 +0000
Message-ID: <171810897369.1721.17385606620745647086.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: -nOlKHuQPCnz6pvz4eNsKBDjdReWlMKO
X-Proofpoint-GUID: ArpSHXlhUNqbnrJKlgbxfYcgkDU2nDFx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=905
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406110092

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
index eebb8296d431..cffa64cf60e7 100644
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
@@ -1527,6 +1527,11 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
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
@@ -1556,15 +1561,12 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
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



