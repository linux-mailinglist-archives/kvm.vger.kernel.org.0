Return-Path: <kvm+bounces-11688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F41879B1F
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 19:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC5271C22579
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 18:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7D4139594;
	Tue, 12 Mar 2024 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tq59OYoF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052C913957D;
	Tue, 12 Mar 2024 18:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710267303; cv=none; b=Rqmj/wIhM85VHpfRhjz568pNRwk3ACR9b8pW6yN6JeysIUOpXNlInMwVYYTFnLTQb0qABSrdMcJc/dZFU/2W2axs7WA1XwE2XIPhFrRLpzvMyzWkxxuzOswbjupgH26xuoGVzf1FNVwLaiKqs2ZWl98iUe70Cl/wE1VzcmFt+T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710267303; c=relaxed/simple;
	bh=Q9lR3Qc4aZyC79bNu2JhyhHRNGYRw7S0CjSfhzbIwYM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3HTQaMVp4MnndAgz+Ay2NkA9/IHJDbbknCHkoAEqINUp4xvtXUP0rkzwOZeAElpd4TmBtih0fkKrEuSLJrksDUf1jZo1s4oVFRzFvL2bQVj5VHn3HWnAYkUf+6vb3Fk1nIC3d9MI6zuO+2bdlGEpY2vgoPOXbcvQkGT7/QBS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tq59OYoF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42CI0VUR032729;
	Tue, 12 Mar 2024 18:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uszZoHUScvfpeeagNwfFGLg8tvqjaAxDDkFYoQOnBbw=;
 b=tq59OYoFryHBMRfr8jnsahJNUT+fpLCEv1kLdtL7ZBBTiTY0tRQlXwav41eH7nuWrWYp
 tx+PZKvKYAMrDUiY4TJ0oHmIW7/2Ry84XWSoSTU7MZupFGZW0uBlGHRipxZ9hUxGoMr6
 9AilEQY0fvpHT6gAot/2qNdoZZj0Dj1Xnx/6ewfpp0fYn2zEvVrO0ErIFT/KugyG6K0y
 lXd9W1hluC0e86YAratmluxhs89OAKyHdhJcEIHR2JvD0jzrSrMmuuUWBWFuDMOOlpN8
 OkND/bDX8DWSr061/Ozzqutrc7XDI/usciDdnYg4PVnkyS/oZB9oXm8XD14DYwjMLyjZ mA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wturh8chr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:31 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42CI6VSX019017;
	Tue, 12 Mar 2024 18:14:30 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wturh8chd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:30 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42CFSEoY020423;
	Tue, 12 Mar 2024 18:14:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ws3km0m4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42CIEN3G37945740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 18:14:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 681D920049;
	Tue, 12 Mar 2024 18:14:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B169020040;
	Tue, 12 Mar 2024 18:14:20 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Mar 2024 18:14:20 +0000 (GMT)
Subject: [RFC PATCH 1/3] powerpc/pseries/iommu: Bring back userspace view for
 single level TCE tables
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: tpearson@raptorengineering.com, alex.williamson@redhat.com,
        linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com,
        gbatra@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sbhat@linux.ibm.com, aik@ozlabs.ru, jgg@ziepe.ca, robh@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aik@amd.com,
        msuchanek@suse.de, jroedel@suse.de, vaibhav@linux.ibm.com,
        svaidy@linux.ibm.com
Date: Tue, 12 Mar 2024 13:14:20 -0500
Message-ID: <171026725393.8367.17497620074051138306.stgit@linux.ibm.com>
In-Reply-To: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 5-fhysGSE_e6smelR3AT1kYjih6oe9_C
X-Proofpoint-GUID: 7cKbR36YwbMJnTzz3TDT8ElrmbaqRYBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-12_11,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403120138

The commit 090bad39b237a ("powerpc/powernv: Add indirect levels to
it_userspace") which implemented the tce indirect levels
support for PowerNV ended up removing the single level support
which existed by default(generic tce_iommu_userspace_view_alloc/free()
calls). On pSeries the TCEs are single level, and the allocation
of userspace view is lost with the removal of generic code.

The patch attempts to bring it back for pseries on the refactored
code base.

On pSeries, the windows/tables are "borrowed", so the it_ops->free()
is not called during the container detach or the tce release call paths
as the table is not really freed. So, decoupling the userspace view
array free and alloc from table's it_ops just the way it was before.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   19 ++++++++++--
 drivers/vfio/vfio_iommu_spapr_tce.c    |   51 ++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index e8c4129697b1..40de8d55faef 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -143,7 +143,7 @@ static int tce_build_pSeries(struct iommu_table *tbl, long index,
 }
 
 
-static void tce_free_pSeries(struct iommu_table *tbl, long index, long npages)
+static void tce_clear_pSeries(struct iommu_table *tbl, long index, long npages)
 {
 	__be64 *tcep;
 
@@ -162,6 +162,11 @@ static unsigned long tce_get_pseries(struct iommu_table *tbl, long index)
 	return be64_to_cpu(*tcep);
 }
 
+static void tce_free_pSeries(struct iommu_table *tbl)
+{
+	/* Do nothing. */
+}
+
 static void tce_free_pSeriesLP(unsigned long liobn, long, long, long);
 static void tce_freemulti_pSeriesLP(struct iommu_table*, long, long);
 
@@ -576,7 +581,7 @@ struct iommu_table_ops iommu_table_lpar_multi_ops;
 
 struct iommu_table_ops iommu_table_pseries_ops = {
 	.set = tce_build_pSeries,
-	.clear = tce_free_pSeries,
+	.clear = tce_clear_pSeries,
 	.get = tce_get_pseries
 };
 
@@ -685,15 +690,23 @@ static int tce_exchange_pseries(struct iommu_table *tbl, long index, unsigned
 
 	return rc;
 }
+
+static __be64 *tce_useraddr_pSeriesLP(struct iommu_table *tbl, long index,
+				      bool __always_unused alloc)
+{
+	return tbl->it_userspace ? &tbl->it_userspace[index - tbl->it_offset] : NULL;
+}
 #endif
 
 struct iommu_table_ops iommu_table_lpar_multi_ops = {
 	.set = tce_buildmulti_pSeriesLP,
 #ifdef CONFIG_IOMMU_API
 	.xchg_no_kill = tce_exchange_pseries,
+	.useraddrptr = tce_useraddr_pSeriesLP,
 #endif
 	.clear = tce_freemulti_pSeriesLP,
-	.get = tce_get_pSeriesLP
+	.get = tce_get_pSeriesLP,
+	.free = tce_free_pSeries
 };
 
 /*
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index a94ec6225d31..1cf36d687559 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -177,6 +177,50 @@ static long tce_iommu_register_pages(struct tce_container *container,
 	return ret;
 }
 
+static long tce_iommu_userspace_view_alloc(struct iommu_table *tbl,
+		struct mm_struct *mm)
+{
+	unsigned long cb = ALIGN(sizeof(tbl->it_userspace[0]) *
+			tbl->it_size, PAGE_SIZE);
+	unsigned long *uas;
+	long ret;
+
+	if (tbl->it_indirect_levels)
+		return 0;
+
+	WARN_ON(tbl->it_userspace);
+
+	ret = account_locked_vm(mm, cb >> PAGE_SHIFT, true);
+	if (ret)
+		return ret;
+
+	uas = vzalloc(cb);
+	if (!uas) {
+		account_locked_vm(mm, cb >> PAGE_SHIFT, false);
+		return -ENOMEM;
+	}
+	tbl->it_userspace = (__be64 *) uas;
+
+	return 0;
+}
+
+static void tce_iommu_userspace_view_free(struct iommu_table *tbl,
+		struct mm_struct *mm)
+{
+	unsigned long cb = ALIGN(sizeof(tbl->it_userspace[0]) *
+			tbl->it_size, PAGE_SIZE);
+
+	if (!tbl->it_userspace)
+		return;
+
+	if (tbl->it_indirect_levels)
+		return;
+
+	vfree(tbl->it_userspace);
+	tbl->it_userspace = NULL;
+	account_locked_vm(mm, cb >> PAGE_SHIFT, false);
+}
+
 static bool tce_page_is_contained(struct mm_struct *mm, unsigned long hpa,
 		unsigned int it_page_shift)
 {
@@ -554,6 +598,12 @@ static long tce_iommu_build_v2(struct tce_container *container,
 	unsigned long hpa;
 	enum dma_data_direction dirtmp;
 
+	if (!tbl->it_userspace) {
+		ret = tce_iommu_userspace_view_alloc(tbl, container->mm);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; i < pages; ++i) {
 		struct mm_iommu_table_group_mem_t *mem = NULL;
 		__be64 *pua = IOMMU_TABLE_USERSPACE_ENTRY(tbl, entry + i);
@@ -637,6 +687,7 @@ static void tce_iommu_free_table(struct tce_container *container,
 {
 	unsigned long pages = tbl->it_allocated_size >> PAGE_SHIFT;
 
+	tce_iommu_userspace_view_free(tbl, container->mm);
 	iommu_tce_table_put(tbl);
 	account_locked_vm(container->mm, pages, false);
 }



