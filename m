Return-Path: <kvm+bounces-20397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 517A1914A56
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 063E0280EFF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5DD13D62A;
	Mon, 24 Jun 2024 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XL9lThaf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB313D24C;
	Mon, 24 Jun 2024 12:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719232758; cv=none; b=hjjmlAOop0WICQFcked74lOTGmQyoA5TnqpG5xH+fnUoVTzWgEUobLNKRDST8hXWwII5QCsoBhBfR8rXFYitQXRdmSdpDiBwKf0IINNHHfQCrPSM4U4QaKKvYqUT7X0FHfvTzgyQnbpxB93NPWcMEherh4om7knZuJxHxjoOkZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719232758; c=relaxed/simple;
	bh=csIOidFbK9g0l4zoRHI5iNtf/AxhpMIfdrawPnTEYDk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lexVdcDPx5pupPgNpx+AUgzvFwKDw74WVoTC88kmmlBEtbftktgk8+n6EFK8tw6D9U2bBmagdpHiqJfzQzi7+vUv7fmXJsYbFhxqpb2G0No2YwU6nfDXXSq+9j4UPU0N6jlFmnZ4kWVKdazcJxdU7S4PYErimlafyuX4cTaVeXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XL9lThaf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OBwbsJ032681;
	Mon, 24 Jun 2024 12:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	nqsZiY+nwGHdS7f7Tvj9s9qjRvXJEGZNaAFiWBYtykA=; b=XL9lThafpmvOxWwI
	HJOBEg5YPMdyEB0J2EIeXEU3QBhaeFP1LFREbSXYhklt0RMkqqspQ5F8i80MXGSF
	mPoy8NZbgq6GC552HJU4bX48aHdDh2Zmon5G/fcVfA8/nkIZympO3CBjOC8yPynx
	+VQhI56xzKRUAUUr9LBmUkyUBSwiBxYgxiRzArHsdnirLSGOZFxMJkv4ETd/ovg4
	KOOhiEMSRh5IabNDMjNfiPVpdFbIGjXC9oAG7tcM00Pekw4iDklQz7qdolvYRV92
	g88/OCtsEwr+gFR2HK8mF5t12IWE3dMDTuwMVVF06EMx9e857RtHbiXkU+EL5+UA
	3fcWSw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy8d1r3k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:57 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45OCcux1011518;
	Mon, 24 Jun 2024 12:38:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy8d1r3jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45OBJY8c000402;
	Mon, 24 Jun 2024 12:38:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxbn30aqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45OCcoNm22217148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 12:38:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33DBA20043;
	Mon, 24 Jun 2024 12:38:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA15E20040;
	Mon, 24 Jun 2024 12:38:46 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Jun 2024 12:38:46 +0000 (GMT)
Subject: [PATCH v4 3/6] powerpc/pseries/iommu: Use the iommu table[0] for IOV
 VF's DDW
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
Date: Mon, 24 Jun 2024 12:38:46 +0000
Message-ID: <171923272328.1397.1817843961216868850.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 8ZDvxGqDFe7tSfPQjmVzxf2E6LzVreo3
X-Proofpoint-GUID: virIjsEmh2ekjJyw7d7Kk7Wodf8KGzpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_09,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=898 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406240099

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
index 97b9a4e6bf8a..d2ac6c19cf9b 100644
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



