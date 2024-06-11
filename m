Return-Path: <kvm+bounces-19319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD990903BE9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5181F252DC
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8555117C7B8;
	Tue, 11 Jun 2024 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s+deGGYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32E17C216;
	Tue, 11 Jun 2024 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718109009; cv=none; b=ZYVi+vy7Zs9MEfdysX0zdtX8Vi9j5LQvjyKeVUS7u97cPaLM3ZuCkmRfKYAsQleQH+i2EJ5Jm+Sr6Prc7kkq7RTIFYa6HL8Yy5IM1DaItseNbRQ7eBaAN7kukwtVk+ZKSon0AIp5LUv+z2cDIxuMB+ypqH+NX3IcJMG1VuhTBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718109009; c=relaxed/simple;
	bh=qDDEb8Fiagaf7nWvXTgWsswZ+FWZ+a8G69HA9ieBzAI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXYyXbGAuG2CdYXxllMrdbhcPrTi1lEMBjLg9G+Oc3fXDL+FnJLv9sUvR9/d9H0GT/iIWRiIatE3zYJJUChAX9uX3YNTWXtdxsVzZMATBGmHaLCzM0j8XRmlMm+Ec0YxOOEj2smvsBMwC/SlD6/rkC/cTSZI7LiNmpcIS/AmfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s+deGGYJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BBviMX023876;
	Tue, 11 Jun 2024 12:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	2DLsf+SvHScMTHZelGi6oM+GObwA5scUy8yfncQmirM=; b=s+deGGYJQRUNfZnM
	cNilhRDdEeNsztPuuyDnPnDObbl4cmg8nxgBBmTAU9f36AM9pO2VcGytIVVEOn9U
	TsnN8617bU0yKh1yInkOQ6X5gJJInUXpkJOsJY1CwDynqbidkbtIvK3fyH0dU7ew
	amJDz9hNnISYaILzkxQ5ChD9bWODeXSaicDEiQdcs5nH0vMgR1sWEs7mRRWHQbyj
	qoRS4y14AgpoFGsZvWXge6ekHSHldwY1XiSeEJuK+UXm1iF1mGJtNONpI74WLqqu
	TI4J3jvC7EZYA0O0d4glymeUSuXyNjtuCkVel3CDU11gsEtJ0s1jm80qoMRY+KZU
	LFiTCw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypmv4889k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:37 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BCTaAW008352;
	Tue, 11 Jun 2024 12:29:36 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypmv4889g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45B8uYes008700;
	Tue, 11 Jun 2024 12:29:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yn4b3582q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BCTS4o34472524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 12:29:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84D8E20043;
	Tue, 11 Jun 2024 12:29:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 378B32004B;
	Tue, 11 Jun 2024 12:29:25 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 12:29:25 +0000 (GMT)
Subject: [PATCH v3 2/6] powerpc/pseries/iommu: Fix the
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
Date: Tue, 11 Jun 2024 12:29:24 +0000
Message-ID: <171810896158.1721.16660200341736554023.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: TM-1FaRYAglYpddfHXR_EamtVPzKPP4o
X-Proofpoint-GUID: x37BXsL4o7u1lZdU2TdmLo88SWkqhZwT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110092

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
index 330c69830660..eebb8296d431 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -865,13 +865,6 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
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
 
@@ -1623,6 +1616,71 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
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
@@ -1662,13 +1720,6 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
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
@@ -1677,6 +1728,8 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 		pr_debug("  found DMA window, table: %p\n", pci->table_group);
 	}
 
+	spapr_tce_init_table_group(dev, pdn, prop);
+
 	set_iommu_table_base(&dev->dev, pci->table_group->tables[0]);
 	iommu_add_device(pci->table_group, &dev->dev);
 }



