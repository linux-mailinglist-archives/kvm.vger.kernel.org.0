Return-Path: <kvm+bounces-43245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF236A884AC
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABDD3BF4CA
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6EC28BA8B;
	Mon, 14 Apr 2025 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pFzfqlWO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAE728B50E
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744638405; cv=fail; b=r7efvLB0rvpRvNhT8NE8sEwjVthcKcrjIRx/rN8N4jb1AwFYAb4CMX0PXIhlU2J1l0e++FgmUor57baLvfypo5kwgoKjfzaUQ6ZUwtVSbhAzNQ9p4x4cb7QsrdopyRuR9NbcWojN/UK3I/Qoxre7PL+9muSGYJkHG+oGpxEIKAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744638405; c=relaxed/simple;
	bh=SevLo+j0nYuooirX7YoPoYcpHsPtuKFHGFTBA+lSeKE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=R5+n1o2YT/tbo6eH3fAhUVkkNtu9LQLloMRihQKtw79N+a6CnUr4QE4GTG1bptOTFRFV1JqEZo1b/eDSstSj3hjp2izqHaMYF4fQLrzABCXZ9m5yzFyzAdSRLJ/Ax9xTE/PbsB3vTxBpHy34Y8Ws72C0MKUaQ2yb9Yi752zfdMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pFzfqlWO; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCDw/oDkZQCyhL8FX1EXyVC6V99Ak7R8FB+x2OmDCUXC4hHVu7pV4teNW9bcbgLEaLg33JK1fp0/q4HLKT/s1sGlaVAlBmhlc1o7Ard1AJgp/NnPHpPABrqooA2bW1SfZU58oaeEWEcFI0orC8YyjaaUpK0OgpSMzj29C04tKPW+uQWNsdc16T1c6KZp2Yhv/Kj596zWgUbbPJ6wcoloJfagHx1kbjojZ8PJbCCqm9Gv0ExTeJoA5qMmGOkcoHC5KJC8vWaGCnU8eEC3cPuoFtHCOghOPFpLqXc/p+GvB+oiDcUYkC3Yz1cnm+9Y9Uu6JrLw2GXaNQ0Iy0FvC/QvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bOu3j4WsKe6sN5KLWXopDWsdaJps79ElDUkXzHVQUg=;
 b=F2QCFnfh2zTBY7Mu3B33wHf+vZ9VqMjkxf5OUM1PqpV8DhWMi8Qbg0p//l/OFEJvmfRa5YeZcCwWBCPm041Xk1PS4hLOVBRs3mdbHr6NY4vczVlqf3LRnW2Tut0C6x5QbsJloW+lmxOD4SyxDMcUYx7dVuK/hKVWaO9lCum5ONG80s0wff9CIQRPxG27E37NjUVj7Pi2CQ5rjOEKPEslbfoVihijyTz8blpIVswoy6f7D+ZkrQBvh/CMpqk3DwQ6eey6KaHswz9DkP9ABz59zmSPrKHkAOWTpz3ssDmQdkQ5kCPjH+p5Yb05su1ndv5xMK0taHa4gWgLUE/p2egI8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bOu3j4WsKe6sN5KLWXopDWsdaJps79ElDUkXzHVQUg=;
 b=pFzfqlWObx/ghAM9i5u/19CunWb7mdyvJPjgitjOyF0+9qCFcX/dD4ZAD2V67l3MQZf0IvA8NF1GtRuDsO4S4aoKwQQJfKNhLBZ1uQWX1VcdNpxtzEbbQ1HvIeUEp7peLoPw3b3MzfDh7XcvZ3JMm529Nd9Z+Pb3miV/KLxZyzdNeOeGCdbu9xU4jxJoB3Q7YoojzffXvd2v2Hq78fPtqbRN0H5eDHCO9jEh8+b6bVU3RKJR48J9yGTgaq5hyPAjQRVhzLqJwtmZa1k+66kvr+FRVBJeBh1+tRWfn4JwkfFHb15Ce1+bqMoFswwvaHJALeNqd4toAXttfPL7KhDfdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7807.namprd12.prod.outlook.com (2603:10b6:806:304::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Mon, 14 Apr
 2025 13:46:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 13:46:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Subject: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
Date: Mon, 14 Apr 2025 10:46:39 -0300
Message-ID: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:52c::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c9c55c-8165-40c6-9926-08dd7b5ac8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jGFymj3W0mmKk8iUlkHb2sMaqZpbh/yF1VdcajzPsGKKh6HO+IeQ0J2NpT7g?=
 =?us-ascii?Q?IRzkhSGxP/UKhS7ZmnrckjxkggVBT0BThBzwNyOywTQNgTaMDZfeDHJE3EkH?=
 =?us-ascii?Q?pH1pN+rU8N2AsBVPOh2vJ1AqHXxJ9119UeAhBDLET2Uk1jENkW7YFiT0t4sb?=
 =?us-ascii?Q?CIeaSLxEH7sUhfaQsnyas5MQYGpVlK/hxK9tBho5H0HJXh4a4jRLDIAIru6Q?=
 =?us-ascii?Q?0ftAky3NwXEZ97x28VDMbrap2IkHXeqmEDbKQeaIEGerKAdSnXie2T9tU+35?=
 =?us-ascii?Q?oFY4dZdXv+Lz8/VFBr7BmsPBcsYad8sdeNqdCjIA6XpYYrdFHrxfYYMLK40g?=
 =?us-ascii?Q?Kip+8D2PzKPeSo+HrMaBFOIVNDHL++sbKZ2aVaOpMSUbzm35tjkgP4V3/K4W?=
 =?us-ascii?Q?bDPDtz6z+ULFzNs4OR2bkbyQE3B5eLhtiaMtpXIsYiYab+glptFmdIOge786?=
 =?us-ascii?Q?6kwNEAq5PIxWoEurz8FDFqSkOHurK7IcOcNjzsOJRCQWZUnCH7A73m/q82ko?=
 =?us-ascii?Q?eVMkwUCc/OXCi3rZSUvPmp93qBYWSACW99Q73GIB6WFvZK9KIeayCnD7hMWu?=
 =?us-ascii?Q?jEjMoKrrC76+iZ+7Cpy7z9D/9VmBXEFZQERTyEVGeGWYx2AFGD/togVgMZG1?=
 =?us-ascii?Q?+svlm9up30Q250EXt+NYf8NoIT3y5pohSyFLRjdI7NKX4wsInrP9F8gtmouS?=
 =?us-ascii?Q?adSQcYL5Bn2QgqYJT87AgS+PoVF4bBq47kRdfKHFObdEy8RJ4PFNbuYhS6Ph?=
 =?us-ascii?Q?cQfBsODit+XbA0/KFjol7TDbwDe5hMbaaelO0ACqTvqMPNdySaCsQNh9tgHv?=
 =?us-ascii?Q?5X11RIz5VW9OGBYAqXkVBYzZki2xOahNyZ8tgVI0Pn5GL4tgIVEKD2w0SPoM?=
 =?us-ascii?Q?OW2A1iEz22RHx5xkODRs+1t1Kj+CnzvlqF/Y+ycuAr3edETl9kQ5YXjmnK5j?=
 =?us-ascii?Q?d6UmYcl2CtmUM2v5AbH/iEZAqB8sb6qHNrbfomcY705CbB6Lm2WJGll0n9bE?=
 =?us-ascii?Q?Leky9ITlHJic4ksEWS2V1ttrjnkpjYCcwgo8RRQYaLwwjWnU+0U6tL7G/xpz?=
 =?us-ascii?Q?ILgSYhJaEUfv0iNz/ygkyArBD6BDNe3SjiDP20bX3m8AFSYAQ75Kx7nkvp93?=
 =?us-ascii?Q?4Kbd3lRPOgBiYhDnvbTubKIbmjwaOtxrD/bQ+XXK58cQhDS7GwUsM75vSGv5?=
 =?us-ascii?Q?pob/PnDfbt2dC4XRI5rauoiqFYhQ1dx9lxrizi/RKprSF0ehMJZ06Do85CK3?=
 =?us-ascii?Q?/eOCKgKq3EUQiLteLHAgFccFj6c3FqFeUPGGHu1Cgq+cQTwQdZvU0W4lF0FT?=
 =?us-ascii?Q?/jOehXlsIck3Rcj2iFo9kU0V+/uZh7/Wcngtz3SnnQwqlX+Cwzmo2Mdt1BWR?=
 =?us-ascii?Q?oK4j2J/TzMQN5MAB4BFA2xHNl5wejMHv+DhbGtRwUyrNNmlQ4OqZWEcVzhVm?=
 =?us-ascii?Q?gJS3oIWynZI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4Idf6B3ZS/r0HaqpW/T0cpuEBM+9/yZq0IGwbjFFTyhWZ5skR2EQA9ADmk4j?=
 =?us-ascii?Q?ahPnbiNXQg838dbrdvq9QTFux3KXZ9VUHjH3b/0Hwgn9DE/Wg3pAvXSbRhs0?=
 =?us-ascii?Q?1xKmiWIRnbzhll0OifTMjFAVsxwMeGpPjoXeOUlSR0RA7N9c/HW5Ve2AyFUy?=
 =?us-ascii?Q?IJolUfHVYa0bmGx1XoUg+xgu1Zl6F0oIFqDz/IR3W+l/o7TjUpzL8+GVMXlD?=
 =?us-ascii?Q?stWR5IYSpy8ZGoSf+aQHD8IhLSJ3IMMCJGUNJ52sjrOoTHPUJlk4ywvwhNWT?=
 =?us-ascii?Q?s/gUs8eRZHjLl9mKq4m2IoP5Blfv36bQXVroXR20/f5MMhoYhn6N8nIncFI1?=
 =?us-ascii?Q?b8X+yk+w+XHnYBoKPag9uz2sNots4+90/86JRCLwcEznKQICsHWwq+OgYWL4?=
 =?us-ascii?Q?XAxE9t0NuR45k5hskje8ip1YcXYqoHhYogjdmIzC3IfA6tDJwX0aKyGG6can?=
 =?us-ascii?Q?qVVi2sHxiV/hEdmtYhtDyENVc0QVXrY30digE2LTYn5S0LxRCoO0vRjl4Cf7?=
 =?us-ascii?Q?Ln1YMOoixGMybTKLUDeIYEgiAQOzZogcb5rxEvsQbSEGUSSMOVfETh56O5eJ?=
 =?us-ascii?Q?DHFvEIY6YUlJ9If02usOH54MCzihBrx5dWGbtRGjY6A/nkfseAuR2oosmZl2?=
 =?us-ascii?Q?D3SP0Z48lgnTh3THcR4rRrVZPImwdxqltjDncaUYguPJEWO9ZVuDVy594fYJ?=
 =?us-ascii?Q?H+H667ddxfvrsNp5RwTWKAKsFd5w8Fe2/8jG1JWIiGwuiu/udx3BA9336cc/?=
 =?us-ascii?Q?2k13AnViKVt4AIqmKwB0GftfofEZg5PXcmiwU+gHuwdhrfjAxONt7ivK61Rc?=
 =?us-ascii?Q?oqaz9OBIN0gDS+5mDE9CcJvAL/Sw+PU1OhivxIGfEPUIHG6pEhj+lviLhsfS?=
 =?us-ascii?Q?D0sSyivhFbTe+UzCdlr3yXeWkhx/gJeal5BX+uOkH0bgEpbe4CT6z54p9xlp?=
 =?us-ascii?Q?bW+eBYEAXfHrgzkKL0JmIGTtmoHUu03haiEYiBY4r/GAE0bbGPLuIbuve+40?=
 =?us-ascii?Q?X2dexQLA7KvwgZz5PmHhNMy1SDQoAxBgvXjakJSVY4WEo5FlUkzzEWUdj72D?=
 =?us-ascii?Q?paMXFWSO2BOQHBhs5dN1ZVlwsl/zsxM9dEI+iPNhfH1qtYE/AKE1s/YX9vfx?=
 =?us-ascii?Q?L49GdmE3aDxaOekOLiyFnVDh099cWh5N6eChttiqNYBQeuiDd5DoC8ggEiPd?=
 =?us-ascii?Q?F3SfcXp2DfMNFHflSLankiodS9MbW+Zo8OMu/F3wYdIjsRqXR9+FN1o5ClzO?=
 =?us-ascii?Q?falY2cENoNIhxe3rBQtBnC7Mzyt8yLiSpFY5VqrSrNpextIYnzovSK47WX+S?=
 =?us-ascii?Q?Hm+2hpq5Gw6dA+yZs0bcGuxCV8Efov4m/X43TZVKzLFTi8UvyYhJNWUtzBcl?=
 =?us-ascii?Q?j3rQyUc9biodAIWUPmPMvFAUyRN9oV0dQE/zjfzP0r+avl3wFxrT+kT7IYCh?=
 =?us-ascii?Q?LJpOXFzZxsDRwusmQ1FrvPyC0Mr0J0RuvkZ0qc7n17XWl+sANP/+/CTpRaE/?=
 =?us-ascii?Q?j3yxMvJlwG/DHHt7kuKHG8K0kCq9QCPnOygrnZ4JTSjcwGZ73YrBnhPl7g4a?=
 =?us-ascii?Q?G35eji3tkFLm8a2VwykfQERRW3ycg8znntT7KBtV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c9c55c-8165-40c6-9926-08dd7b5ac8d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 13:46:40.7502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TesaVri2mUXx9LY9MveXZ2bTrVsC+Urw9oCY+YWmmN6U0c6SyNY+UoQXUMyz1SV6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7807

VFIO is looking to enable an optimization where it can rely on a fast
unmap operation that returned the size of a larger IOPTE.

Due to how the test was constructed this would only ever succeed on the
AMDv1 page table that supported an 8k contiguous size. Nothing else
supports this.

Alex says the performance win was fairly minor, so lets remove this
code. Always use iommu_iova_to_phys() to extent contiguous pages.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 49 +--------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

v2:
 - Just remove all the fgsp support
v1: https://patch.msgid.link/r/0-v1-0eed68063e59+93d-vfio_fgsp_jgg@nvidia.com

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f23..afc1449335c308 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -80,7 +80,6 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	bool			fgsp : 1;	/* Fine-grained super pages */
 	bool			enforce_cache_coherency : 1;
 };
 
@@ -1095,8 +1094,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
 		 */
-		for (len = PAGE_SIZE;
-		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
+		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
@@ -1833,49 +1831,6 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	return ret;
 }
 
-/*
- * We change our unmap behavior slightly depending on whether the IOMMU
- * supports fine-grained superpages.  IOMMUs like AMD-Vi will use a superpage
- * for practically any contiguous power-of-two mapping we give it.  This means
- * we don't need to look for contiguous chunks ourselves to make unmapping
- * more efficient.  On IOMMUs with coarse-grained super pages, like Intel VT-d
- * with discrete 2M/1G/512G/1T superpages, identifying contiguous chunks
- * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
- * hugetlbfs is in use.
- */
-static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
-{
-	int ret, order = get_order(PAGE_SIZE * 2);
-	struct vfio_iova *region;
-	struct page *pages;
-	dma_addr_t start;
-
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
-	if (!pages)
-		return;
-
-	list_for_each_entry(region, regions, list) {
-		start = ALIGN(region->start, PAGE_SIZE * 2);
-		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
-			continue;
-
-		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
-				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE,
-				GFP_KERNEL_ACCOUNT);
-		if (!ret) {
-			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
-
-			if (unmapped == PAGE_SIZE)
-				iommu_unmap(domain->domain, start + PAGE_SIZE, PAGE_SIZE);
-			else
-				domain->fgsp = true;
-		}
-		break;
-	}
-
-	__free_pages(pages, order);
-}
-
 static struct vfio_iommu_group *find_iommu_group(struct vfio_domain *domain,
 						 struct iommu_group *iommu_group)
 {
@@ -2314,8 +2269,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain, &iova_copy);
-
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
 	if (ret)

base-commit: c4a104a53e4f7ba76f6372c5034125a24fd7f137
-- 
2.43.0


