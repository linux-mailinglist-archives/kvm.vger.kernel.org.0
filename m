Return-Path: <kvm+bounces-24140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 651A4951BB4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C708FB2417B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1DA1879;
	Wed, 14 Aug 2024 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ISSAJsax"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDCF1AC43E;
	Wed, 14 Aug 2024 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723641642; cv=fail; b=LrZLRrcEml/eM0L2L4WMGRx2CvH7WEcx6TR06L/jBpN2pPIUtl2sGA5Pi1tUu1BMtD48gtEaOEo/K1a82Ij2sKGeUkBjPVKgXI7A/sukJa6SM79f4R6j8sY5FBUEAe01izQVMej2rBWppFr5xQNfvpabRMqjFKo0UXDhoKa6gMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723641642; c=relaxed/simple;
	bh=4h04wFQOTyyWaMqTyppXiShp0gn2uQ71EOjHLLk9PS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yh30uEDKJtGpH5b8od1qxHXVLxtAemDsYLirEVesINHx17kY3QjHK6EV57D74ToadqSdy1e1scEMi+ekyMrbOlriv5Py9hGvxNBQZKZpLmW2Ep781a2Qcb9TwMxXY4arWWWbtdP7PHxKPPfaUnZAbRgLr/FAlt/vcbJOMHlkBVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ISSAJsax; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gk7zrtTSZMLSHnWPtTfku0NpssrW8T4Xl2qzzPQfpywQRGwGwFSycUoqQhoGnr0YYObSUrwNOHQHSrOWO9poIX5jWMcq0TcH/TwP8mSr+d95xjpX51zOgtk4lB4L0OAGYQ4P820cbzu2wkJ7LfytGL9KH2wGQEKO9sbb/RhMEoFjDUk36fr68IcVWgr/JFtqi7qiAzovqmKqCqNaWzaHNU4vijquwBIL6rGlkPR9MTtFKLozdG7Ss5Ga6obOXWFxrSC7DhEpP7RwuMzK7lEg2TiaIsvpzaJbh8/M1d/IJsnVKDClNqsNUsaWxs/iCYv9aCQbnTiLWUVZ+ou0tcOt0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhjEI9XnLzDTI1s3KgIC835uFlkIFPzaAdgFqTyaDD0=;
 b=vlHSuojn8uQftaO7VVtDRmYSZ9BgOKdB3SbnVG0OQpSYIPg7iqD3fHfkLvquerqDqxsvf+N1kcnvEC476PVyfyYz45IBt3MoSGKLlFkGk9DmQ4ewUkOhgm77HMvjwAHMQsuUkJ6LJCR0QmBe5PGhioWijJkJtWdFu8zyEWCrp8eSSoqpUhThNJ+F1hUW6hETbX+NTp9VLrSTfudvqRZ9apce61fVFBQLhmvwPPBh7i66TQ8Zc/+/NuQlmkkvHaDKC97/5II7q+/fU2QtZf2MkgU2OnV39W/qp/NDaSH5G+EUo2HPoWzqgy/wMuLENTnKeTveMUYfldyrdk5GQP4QQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhjEI9XnLzDTI1s3KgIC835uFlkIFPzaAdgFqTyaDD0=;
 b=ISSAJsaxVoNx3x920CsZif5bDjxksszsx9024kadll2boF1sCa4NKO2jssfIQF0aie2L6Jr8Abo/4IMsfk24WNc1sE0B6l+T3p7JSLWZRcDL3zCq8+tYfyi/igdoNBtOC1gBEb74zvo40gcAvq7ACcIX0zNBD8e6v/vCPJkvqbg+3WvRRZlAL64lHSS/PRC4e7lKcgrmmfbKn5nwNVqFNNNRh20bSC3CRR7XyLHvJeoE196KWo90zGSRjwbCQ5Re1mHYMKpbUpXS1jU1UQeRPR8YZQN49V9dAWfpZuoJblJLenQENCtHoDBSAiX+xeNyplTMwZAeFg7SDDxFu5oTYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by MW6PR12MB8736.namprd12.prod.outlook.com (2603:10b6:303:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 13:20:37 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:20:37 +0000
Date: Wed, 14 Aug 2024 10:20:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/19] vfio: Use the new follow_pfnmap API
Message-ID: <20240814132036.GL2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-14-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-14-peterx@redhat.com>
X-ClientProxiedBy: BN1PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:408:e0::7) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|MW6PR12MB8736:EE_
X-MS-Office365-Filtering-Correlation-Id: 33263c42-893b-44b5-b286-08dcbc63e2bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	NBaqJqK8MAH3FnYVvLnbi8YI9HdsxguYIrCzkNB59qg+j2jxymhi0+Rkql0zW+CT7cgoTC7o+1C2bPAIcUpraCO0xgPzFjrDuMv5/qwuTKx4z28YAZ+Kef/JULW+OfEWZkEBFIxFdZ5V1kO28RVVXvMY7AejOv1jNvZR6ZVNYc+fU499XIhs2cZTyOWtF1lADhnNDYGoKLrgCqHBYU1H/wgll/yFBu1qHYrDCnnHQVTOPybjuvjD7UHHXRlb8XwYRC8MS5B5mKn+epmrGC5EapceMp07b3wqxcdEEX84Ht2+KtSjBWDT5ruVqrhumWWhdcTM7GfXZJyoO9Zr5cA357aXLoecf0MaafTUEDIwHpqw/mYJ9rJdh3x1H0CEMOYnvExQQpqaK/MN++HTGWV5pzZ6kb0UX3h0NZym8neyWw5iEfrV6EyAS0c05ZvgjQtR9ZOxpRQrBQz15byL6iOnOVg+heUZtRN7+CHbCMufsyeZ5nWIB3Tz8+Fgl68mzgJL+Y8f6B+yzXVJ1D7+alcM+96XShcrd5ZqfUGgSz7OZ9QbPlEmvI1US89r9R4ZA4jfG46ah2/lrGhK4H8WBcqUxTsH5fe0/Ora0qr1aF7ckwpnFn5C/P4H+/e7VkCxGjLUWznLpEZ2KFrM9j8WPLzE7GX9HJlMwxmmLgR9e/FqmJA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yJBw/vmPHkzishbFt7a03uw7s5NmKL6hh1Pcz645dofuA7CP3uLLxnjIaZDU?=
 =?us-ascii?Q?8fQAuRFmQKYaYZDYoQ3230Tjc29Rucr8NTNmesosunI0TOwJvSLMJg3mtibM?=
 =?us-ascii?Q?r2+I9SAfFWsMhcReT0zMGqln3fAqW1EzeKWFMRwSds1ut3UI3fBl4wYKXtxZ?=
 =?us-ascii?Q?YE7Hj6ErzHnp2T/utHCs1BZTl/BZqMnigHKFZgTOt+EDNmQeU0s8gyhmVRBV?=
 =?us-ascii?Q?f2jXLnsWW6bteMHfyylvWMoIyOLifEldXe5sAtRwHLzuFW8CNEt1nkcaFXME?=
 =?us-ascii?Q?mXoNdrdcJUzsNh699ifOyvKIrwvMBPYi6kYJzaw4Sx4xPjxtnq1al3I4Ahci?=
 =?us-ascii?Q?Qbt7xOf051SefDu1X1iZwN8a6+YbY92xj9Z5rB+FYmEN64eNuJ2xlNPynMSW?=
 =?us-ascii?Q?P7c7UTUyHPZkgchTQ3l8Vy+e4xZC2fxWZplZSUR37CVu7EeimDOZ6KTxWeC1?=
 =?us-ascii?Q?KEsIoB9H7QHyIL5B6rO8x8qcka7MDgYmTkxyAGHXEmNWRERpk+60XLPAyZqF?=
 =?us-ascii?Q?i6OaP1pCt9tDgWHx7RXIGx/YfewMMc28n/jNlP7A0zdxyDY88d7sdZmbaFT3?=
 =?us-ascii?Q?HAvmsTp3ZtpyxDpGXamvcEppwqzBgyFBcBa7iFXtsC+4/qJKo4BsPXlRPCkv?=
 =?us-ascii?Q?GbYGg15dTqXH8ZvXBm5ptF9l5cIT36q9+mdJmhx7LcJk8jg8CiCzRIZnzUq4?=
 =?us-ascii?Q?ktXB4KC+ghCwtxhhpNkAs66c+c/HhGyQJpSwO183pcsgRAGUHb7wkoByMp9+?=
 =?us-ascii?Q?sr1RaAcOcIA5Zo6BovJF4EHYJ/4PYpHCg8IROBWxqS4SMNam+fxsBjmMlSBp?=
 =?us-ascii?Q?oh0dzY+3chrAG8J9pq4v1r7N5Bh8pIyT7myxza8Rvvi64rCyejg7hfQRUkMX?=
 =?us-ascii?Q?xx9zmIcUhV1InmhgiIV1VO88rcWBpPVCWJFhpTOzl5CvhfoHe8P6Apk8F2e+?=
 =?us-ascii?Q?wSWMtvnN1u2QWQYdbTnmPeKPIHNUFrHuNkSpB7bEIDg9doeoJoFVoj9m5P2k?=
 =?us-ascii?Q?8UovdZogvqNuhWoqcUfjjLPUqgfUnLUJxAY/u3nQ7TBiHfp8XtBhV4Rak99K?=
 =?us-ascii?Q?7PE2TZXVzu6aEcWKcp9YaQi5oi6Vdf8PZD4UAn3QVU9IAGc8l3hYekmqtKJP?=
 =?us-ascii?Q?SrgkKje3OVviKLvQDHNR9iB1Xx0Df6hPymdhdApbOkR0MD4FZor7AD0d0O2Q?=
 =?us-ascii?Q?BWrYUPYESWUNNueDwSoiTD5EdumfJz90/B20rmeY2A4br5FcpnBq7XAbYmDN?=
 =?us-ascii?Q?e+AHpxU3DmZo+s4Tnb1ZuWczRwc1mL0yYIh+F5yxVloJA0mYuBgXW7160siq?=
 =?us-ascii?Q?MkuPUjqY9ejsHzgpHdMlPqzJjdxDAUGvoKD/rJOHc4415ztIzzSSd/zK4i/x?=
 =?us-ascii?Q?Nvtge6qsyVnE8GpUzdF8TESx/WiQQR1YyFrMDemqFOEH3bi3Lf9eMY5X/7G5?=
 =?us-ascii?Q?Ba5iGTZfT1xzN1sI7Scc2iFA4yt7zxONIXVdcpy+xw7w8PDOiezX3x+sctoL?=
 =?us-ascii?Q?3rW5NTRbXynlrYaTBa3GrCxMwmw6mQqB/hIYo+snQSPLM/VLrpcBIPur7Tq6?=
 =?us-ascii?Q?G5jVG8WuhjNVDzZZmuouSuvvcqxbqfBi/ivpSa0Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33263c42-893b-44b5-b286-08dcbc63e2bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:20:37.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNQ65InAT+cgnAgYb1ExQH9KV7LHBiF4xZQZPlePbpOokDh0YkXX/S6bPXx1Lw5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8736

On Fri, Aug 09, 2024 at 12:09:03PM -0400, Peter Xu wrote:
> Use the new API that can understand huge pfn mappings.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0960699e7554..bf391b40e576 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -513,12 +513,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			    unsigned long vaddr, unsigned long *pfn,
>  			    bool write_fault)
>  {
> -	pte_t *ptep;
> -	pte_t pte;
> -	spinlock_t *ptl;
> +	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
>  	int ret;
>  
> -	ret = follow_pte(vma, vaddr, &ptep, &ptl);
> +	ret = follow_pfnmap_start(&args);

Let's add a comment here that this is not locked properly to
discourage anyone from copying it.

Jason

