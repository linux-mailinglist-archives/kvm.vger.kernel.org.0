Return-Path: <kvm+bounces-16272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BCA8B811F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 22:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA9921F22457
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8171A38C1;
	Tue, 30 Apr 2024 20:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nr3J5OY5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57564199EA9;
	Tue, 30 Apr 2024 20:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714507592; cv=none; b=EgGxmneVhOh2LdIqMyL8XXXGNh9y4+2Z33Ns7CPIk5U65Y0cNOHIwlmpgpb1QBFgIP9cLRSjRcgPgvvVvKI//D8oOLSmXfzQ4qoY4EI/6mIgAbBx3A6M+CYiCNhicQrDQwKL32RS1YvzgdidJQ12x4Rz17Sk1sdQSwZlNhT9bf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714507592; c=relaxed/simple;
	bh=IC8S7/sW2KD/gDmHJ1YkVCcsmhmtcLIzhm1/34isYs0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFTTXQ8KATcFUFxeGTvv7w/ufX1das0CBpeYfS055F9WrEUkHPlo1M6pGH9nTfAEGGHjZZZqs7P8OmNPN6OUHYG7jmMTUO1pkN1y//GLYdfh71oKqNhBxh+BXVovrjs81dM/14tgW/pCZAmiCktkwrkayNUCx+1T2it2DS0JbW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Nr3J5OY5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UK3SQC029147;
	Tue, 30 Apr 2024 20:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JrbI4lOpMxmvIiPocxSNVGm890kat/saN0h3NBpy3Q8=;
 b=Nr3J5OY5mtWNjuvKUC+GfdALHMWDvQwYPZf+GGx2gRsHdkWjgRwtMP0a3+j4WANoUDtV
 NumsBkhIDrlN1w1qD8yfIfI/jdryLHsi6X9k1rnH+04D4REpHvmYCtVaJzViqPAEqTsv
 tuWQ2n/1xqsWUhj1zhTw6Xxm6VFsTaZygioSDFtSyKyWRkWbWV79I6sJ/Eept6XCN5q8
 DWo50ToHZQNUSY8j4XqhcmPiaC/x33m60BQLkLDq5rm3VAoGXl3JhA7R3HbnhkqpddFU
 xZMCVAzKRFUVcCP2uTh8d+pqgsQ9556jvMun+sYFsOVpx7nQgNTY3nQwHlX0npo/s8o1 IA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7bc808u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:14 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UK6ESM000347;
	Tue, 30 Apr 2024 20:06:14 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu7bc808q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:13 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43UI02Zt011821;
	Tue, 30 Apr 2024 20:06:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xsdwm6njj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UK68U943057612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 20:06:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4D552004B;
	Tue, 30 Apr 2024 20:06:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4018A20040;
	Tue, 30 Apr 2024 20:06:04 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Apr 2024 20:06:04 +0000 (GMT)
Subject: [RFC PATCH v2 2/6] powerpc/pseries/iommu: Fix the
 VFIO_IOMMU_SPAPR_TCE_GET_INFO ioctl output
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
Date: Tue, 30 Apr 2024 15:06:03 -0500
Message-ID: <171450755957.10851.14173120513261213226.stgit@linux.ibm.com>
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
X-Proofpoint-GUID: 7pOFL_kU0oVCqDruBwNbbfpNerrnPYpY
X-Proofpoint-ORIG-GUID: i0BVB1hs9SkC0gvOCHSPT_xCl5kckEd7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300143

The ioctl VFIO_IOMMU_SPAPR_TCE_GET_INFO is not reporting the
actuals on the platform as not all the details are correctly
collected during the platform probe/scan into the iommu_table_group.

Collect the information during the device setup time as the DMA
window property is already looked up on parent nodes anyway.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   81 ++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index c6850ec1919a..5b68a4918d63 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -857,13 +857,6 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 				be32_to_cpu(prop.tce_shift), NULL,
 				&iommu_table_lpar_multi_ops);
 
-		/* Only for normal boot with default window. Doesn't matter even
-		 * if we set these with DDW which is 64bit during kdump, since
-		 * these will not be used during kdump.
-		 */
-		ppci->table_group->tce32_start = be64_to_cpu(prop.dma_base);
-		ppci->table_group->tce32_size = 1 << be32_to_cpu(prop.window_shift);
-
 		if (!iommu_init_table(tbl, ppci->phb->node, 0, 0))
 			panic("Failed to initialize iommu table");
 
@@ -1615,6 +1608,71 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	return direct_mapping;
 }
 
+static __u64 query_page_size_to_mask(u32 query_page_size)
+{
+	const long shift[] = {
+		(SZ_4K),   (SZ_64K), (SZ_16M),
+		(SZ_32M),  (SZ_64M), (SZ_128M),
+		(SZ_256M), (SZ_16G), (SZ_2M)
+	};
+	int i, ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(shift); i++) {
+		if (query_page_size & (1 << i))
+			ret |= shift[i];
+	}
+
+	return ret;
+}
+
+static void spapr_tce_init_table_group(struct pci_dev *pdev,
+				       struct device_node *pdn,
+				       struct dynamic_dma_window_prop prop)
+{
+	struct iommu_table_group  *table_group = PCI_DN(pdn)->table_group;
+	u32 ddw_avail[DDW_APPLICABLE_SIZE];
+
+	struct ddw_query_response query;
+	int ret;
+
+	/* Only for normal boot with default window. Doesn't matter during
+	 * kdump, since these will not be used during kdump.
+	 */
+	if (is_kdump_kernel())
+		return;
+
+	if (table_group->max_dynamic_windows_supported != 0)
+		return; /* already initialized */
+
+	table_group->tce32_start = be64_to_cpu(prop.dma_base);
+	table_group->tce32_size = 1 << be32_to_cpu(prop.window_shift);
+
+	if (!of_find_property(pdn, "ibm,dma-window", NULL))
+		dev_err(&pdev->dev, "default dma window missing!\n");
+
+	ret = of_property_read_u32_array(pdn, "ibm,ddw-applicable",
+			&ddw_avail[0], DDW_APPLICABLE_SIZE);
+	if (ret) {
+		table_group->max_dynamic_windows_supported = -1;
+		return;
+	}
+
+	ret = query_ddw(pdev, ddw_avail, &query, pdn);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: query_ddw failed\n", __func__);
+		table_group->max_dynamic_windows_supported = -1;
+		return;
+	}
+
+	if (query.windows_available == 0)
+		table_group->max_dynamic_windows_supported = 1;
+	else
+		table_group->max_dynamic_windows_supported = IOMMU_TABLE_GROUP_MAX_TABLES;
+
+	table_group->max_levels = 1;
+	table_group->pgsizes |= query_page_size_to_mask(query.page_size);
+}
+
 static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 {
 	struct device_node *pdn, *dn;
@@ -1654,13 +1712,6 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 				be32_to_cpu(prop.tce_shift), NULL,
 				&iommu_table_lpar_multi_ops);
 
-		/* Only for normal boot with default window. Doesn't matter even
-		 * if we set these with DDW which is 64bit during kdump, since
-		 * these will not be used during kdump.
-		 */
-		pci->table_group->tce32_start = be64_to_cpu(prop.dma_base);
-		pci->table_group->tce32_size = 1 << be32_to_cpu(prop.window_shift);
-
 		iommu_init_table(tbl, pci->phb->node, 0, 0);
 		iommu_register_group(pci->table_group,
 				pci_domain_nr(pci->phb->bus), 0);
@@ -1669,6 +1720,8 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 		pr_debug("  found DMA window, table: %p\n", pci->table_group);
 	}
 
+	spapr_tce_init_table_group(dev, pdn, prop);
+
 	set_iommu_table_base(&dev->dev, pci->table_group->tables[0]);
 	iommu_add_device(pci->table_group, &dev->dev);
 }



