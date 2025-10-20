Return-Path: <kvm+bounces-60551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1F7BF258F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3FB3834DF13
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3A52874E0;
	Mon, 20 Oct 2025 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ejj7qNPH"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6AC21B9DA;
	Mon, 20 Oct 2025 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976925; cv=fail; b=jeFKKNSrCxhxD30NMa/IVH9ufG578JSZexX9lOhAK3O/3zA57N/sJdHGsl9xaE1ZMvpN6MUfbWn+etHMnd1nJzWNbu5Huxcq5qMT32/CkbN+ui+OIwQSfJCgu7/Fa5GOq9HI7yc46l68WC2zsy7P3BK6enhFL91LOx8OwRT8w9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976925; c=relaxed/simple;
	bh=QogIN3pZdo4/KV3St/aeT6llcpen/pJkpvrzfIMPqvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NusU2i/V7gIwVRorqqWlfUcvpj9Ef9wzXmnm/QPLo5JvbogE57BKVs0ESU5TwjdRky4FS6rEFu0P7wNtNHs5SxVER6j4sc7aSud5q8+oEV0RSs9GuduE6OUC6sYbK4PL8NXrsaEabqzsDziWUCvicbyV3uxlNcsmckxrOfgQ/20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ejj7qNPH; arc=fail smtp.client-ip=40.107.209.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAEHSMCczvkRZJV8nX+6Be9Y5k8NXHEiW+p7b/iVLnONxcqSix5S8Qw6M8oe2Z4nHTYhO6GG+p51dMyb2/gqlAeelkvwD9sfcEdTDChLmiT0MU1tTwrUV8XAVjvcFDcikJ73RkWVtlchp2840JYs0Yuzh9uLzThRM5DtsQku52c3OEX7Inc/zvbJDJz/3JNBcrFMFBUfsarbQTVC4A/5QQ/DOWSFifnW69TI/hGWMqXmTDC+Z4/eOR3HasQmMQHu1Vkm3oAS4nJ6qFIYSWIAGe1UjDmLRfTrJOwFmc+/qu/3/9El+j+tPM23VHdhLZTHKG0LMg6oMTFtlc45oeRVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41BckvWFoxtxO3VDpMnCNqa2ITtixMnH9ptSvTm8t7E=;
 b=jJe8rog/cAN6fvJYVr33+fJBf94ysvg2bKsK5rcylyWYvzv7X74sOwzYp9sKLHK6RoauR13iS7ihHm0o1mTJX1glvMfDf1NNW8liA2XwtA4lWe4P4JDtQ3umaDp0STmT59BA6n01ZRJJYomp2iQdt+FxeBup9DSsyLvzAPv0DwvbM/g8QCptFYZTVyVdmBwCDATdsiiuv7KAJRWVKKwBmf0Zpuz2WJITgN/lP7kpI204S7lQFDJ46o59iizt4DIhRBdph6/nfGz6T3ijyXX47lFCPs8gNnLIZUIFLrLIAam0zvPhCQFn6LznVNorcdla5XsRG4JAo/g0R3dI2nlFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41BckvWFoxtxO3VDpMnCNqa2ITtixMnH9ptSvTm8t7E=;
 b=ejj7qNPHzIFwhnmBmbnaXhMyHoLXBIvph4BHmiZgwARsZqDDDFTRUbaRSHHGNk+gUzop/xOziHPGhsnoc9beN6yGQgdvyt90QMG01/iBAVPmlYQjH6a7E/CAoXbhOUruUuRf7AjfEphtypLp2ljm81tOA5vVTnpbLtSQlKaPiWCFHqC8vSjI5NfCG5BlBpdOarytKsNWXoFGJ4i7MshOhJ+m4xszZP7N3a3riPGq801qK3+x5+m66KnDTBWLouMdUydeOdWtGPseQWb2Qwm8/01Zb9ZzqcH4+WIuLrJz+Z3xU1hpfMjTCtw4QV82OhW+kCXV0XIN7tKiH8b0kvLM9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6116.namprd12.prod.outlook.com (2603:10b6:208:3e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.15; Mon, 20 Oct
 2025 16:15:18 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 16:15:18 +0000
Date: Mon, 20 Oct 2025 13:15:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251020161516.GU316284@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
 <20251017161358.GC6199@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017161358.GC6199@unreal>
X-ClientProxiedBy: SN1PR12CA0102.namprd12.prod.outlook.com
 (2603:10b6:802:21::37) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 22484875-c16f-4d04-0dc6-08de0ff3dc7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WCibGPCoML6CUG4RAp6YCyNBe9v0/WqeKC+0MgzqAUyzcbL4aM0fw+IxiOUt?=
 =?us-ascii?Q?LytaloekNIqNtc7Pmxuyjb5uoliN9J8G8R2rWGyvaLDWOocyttOAt0xvN1NM?=
 =?us-ascii?Q?sRRb0Q5hNK1l9zUSjtEP9C0rf9t5VnThYDosQJ9Vxyfb2xwLeEcqkkA6MYuX?=
 =?us-ascii?Q?gLoiWwOUl0SIWj2AU0Z2DabiPkKp/7L0fxtCnBTGWvmd0O7rTSxqxeQyMhoD?=
 =?us-ascii?Q?1naVvUfqrZxI3KqN2TDtb0qSMVA8QXwt0pLRtmqbWJ+V1oUYrqaZREon3qLS?=
 =?us-ascii?Q?W5VSbYPeMlsMCMw9Rh6xa0f12Scjdk62z1WTb3SeqkZj7WPQFROHC4K8g3zE?=
 =?us-ascii?Q?L9A53sSuk8C1FxvTRq3kTG/oq+0heB4mF8zxy4E51BrjLZrVfL6f3hL5vViu?=
 =?us-ascii?Q?mozC0HOTiPoZdkHb3nwHYTENVq4b2zhIWIwTgID7KaI1cWoz7R4I66tvNdQx?=
 =?us-ascii?Q?hZpxarEDE/ETtxQpGVNTq4oiv9lB73O9IdVWsGkq8Ro3W/dIV0NLY4u2SL1h?=
 =?us-ascii?Q?mbD9ZZKnUj0PskcjT6i+ziSvMraM22TiObuRWah0bQt3iOvC1/MvcdIDG8j0?=
 =?us-ascii?Q?aKym556WhWEWBGZVyYtmb0aVDw3Abbej2Qzbzuj45kWp1v/TTyQIcEMfxp9j?=
 =?us-ascii?Q?Vv3RGEuzrRHKwqtRiT/AiG8OSn7aIZGECLlNKlvDIqDvP0jln2JGYHtGs0PO?=
 =?us-ascii?Q?5h1PF1GnhGs+da2GklE5YZTYQsuBNl44cEeIb8nbSIkJSDPRMKo9PyV5VQQd?=
 =?us-ascii?Q?rkwuk9RxV174nStoGOjp6hHAaBbLIDTM0N2/maj6d3aWo0ScSgIm+c7HN1Xc?=
 =?us-ascii?Q?SHuSx/XAkKqXL0tSCpfrlYK8eVmmW54bZYWjfA/LoFq4Ae83avfTK812HoFy?=
 =?us-ascii?Q?FzH6Ut5/WSXsyzznlA4LBsrgxxGos1unjlurARR+2+nZi+Tr0d/oZx3W6qoC?=
 =?us-ascii?Q?PGrPPMukgiH4S2mmuC8GBpYCsX7xta4snast8+Zx7TyoBSZS+HkUm6Uf+pUP?=
 =?us-ascii?Q?lzilcTaV8JOQkcnh09rKHP37Xx/R/3bXTkOEoeozLFoaGU9hwyLyjU4GrGaX?=
 =?us-ascii?Q?LmK8CiVp5si0GgR6qkLqhEJbJIe/KfCcyW+0ImfZFW6VLArIDbyh3QozJp/g?=
 =?us-ascii?Q?qE9j+UnA6RFvI5tC93qAjK2Kkd8YCMqYPAhO3e62eSs/u2iAnd6+IFFgDsXf?=
 =?us-ascii?Q?s6WkOA7JwuEgQ5jbUilfkd+JfvtXoSM3XSU87+LS0YW4aC6oUnJyMJwupsjR?=
 =?us-ascii?Q?suWUUccS4ryjSZuCsMTcopyR4o8a31tysGlIoZvvOl6FDV+uIbZA8O5yMuwa?=
 =?us-ascii?Q?VCAXCiuW7oR4JqWvGbPzmvgws3B2gTDTfuPsrf+VBFGaz/IlpIe5Ebba2PR1?=
 =?us-ascii?Q?BkwCjSggH9T03Fh2kmEvNZAa9fuBMnPo2WOu5V2jUtn49REmEiQdnB9UJYlp?=
 =?us-ascii?Q?cy3384ai+Zgh6d9yFYBPhkAMcNAIqF2v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fnHtS5OGX+sJVKxIRNbBNm5l/e12Uv6f423Aq171zzthSjLrpDH33clq+k4r?=
 =?us-ascii?Q?DrVt4j7CO8+LCO5uW4pGV+zr+vRvStk/t0uwzkwYMRbXksEgiASXmxAIGJq8?=
 =?us-ascii?Q?kPvsVmNkCu5tCDuxkPxg/z+mLdfYUZIw+QUXpceAHvf9TQPSwBuwRe5NemV4?=
 =?us-ascii?Q?0V0xPLQ/qc2CPitoQJwVxpgtEGletx+g4SHr9R/X5wIulacul1UdbNjymPOt?=
 =?us-ascii?Q?663tinKt2XeIXCwSmiZnVnn73NZAiCZhVUUnlhRMdoP8ZoFauw+NcUsNP58d?=
 =?us-ascii?Q?F/jlOORuiOd5CXN/pOsdHVUyl+GcV3DbS1FC+8vNEaHNZHVXgHKHTALBRkSE?=
 =?us-ascii?Q?dtzIxfcqTQXQij83r9hhi5SY44mPLu2Nd6isuE2krXtH7eqfO266bbylPWPm?=
 =?us-ascii?Q?Vo9cn55bAf+ITx+V++Mpn1ZakO+1G3GZbEwfbNHeWb8NhRFv8xp/AWykNBM1?=
 =?us-ascii?Q?DMXvJ6EsDYjWKEq8inmU8gowNkdJKW3C2tNe9N2KYERhkiMGtjn7Fen6EAtR?=
 =?us-ascii?Q?rz1T/DJYcfVXXZkP1lygcvSY40V0HZA8+l1VuhbY69ei6/b7cHaej6dgGh1m?=
 =?us-ascii?Q?yH+PnJjcz2dpN9htLYL4alEN8hCz7uVuMkeiBHkNwa6hep36wPQogc0ZYx4t?=
 =?us-ascii?Q?73mru0a3tPDxTnJadKtVEfg5CbJXonJ46miARm4A7rMbfwt6XSb6QaXoOO8b?=
 =?us-ascii?Q?xLY02OPo2GI4D76QhdOqHlG4EToCzuKq/v2qzPJ/7N2zBbR3CyEzJU9U/Qok?=
 =?us-ascii?Q?BqPlkgr+9rmhucc9MkZZobXnusK3XI7vUgTGJcj+fZZ8KqAJ9KZvPxLKrLfu?=
 =?us-ascii?Q?okSDsbtrg5QVkqfJnuancVxLlyrUWfP2ORu91Q7M7rAzEOmqW5n2PKmu7FMg?=
 =?us-ascii?Q?usx15tIyl5vjdNB26f5Z0FkGN+eg+Mqz9mW3b48WkB4Y4xxOEJtDiFpny704?=
 =?us-ascii?Q?rStJhsFCZdOEaYVDKgWGouePPULikv1loFTWK/OkGflZUfrY22PNuVWBSMDt?=
 =?us-ascii?Q?m967dagyUfCLC2V1IuNbgf/GjF0ucYKvz4j+mcBExzjn1ltWdHhhACvIIMGa?=
 =?us-ascii?Q?8/57UBUeEYM3VqX7zNagkINKadUFop5KvYmxmoLpEW7cPipWohCy9SlMUpz5?=
 =?us-ascii?Q?2bgHhiHVj8GySMbI4FFlKPZeQf/l9GIuiwa/8ENO7/+w7KuGEjV33Hb9fhJm?=
 =?us-ascii?Q?njjfTPU6eNaynTS1Nb+yt9OWo0c1884T7GAKh70h2cZ5JryHZ94YF0Bebx4q?=
 =?us-ascii?Q?8SUByLglMhhwAG9wYYN+s54qBGvOWM50XZ593Wzgv8WpFC28ahMbvxHzjvAO?=
 =?us-ascii?Q?TBvxyxw0pg2+GaQwTF5+xWZQA6F40DBdtibWQrQ6GuNl1S0drNNJnwwSUi5t?=
 =?us-ascii?Q?FMDcKvUlpkso0+LG8u//Rpez+hYyNkugo6HGl7v2O6KZhNHe414rrNdCK1XR?=
 =?us-ascii?Q?thjacfPxnTm6HCPe4aB7UESL1d8mQMYT5FyDrfCZjQR+p8959v0b/Y1WjKat?=
 =?us-ascii?Q?Nwu1X4LrrVfL9njXEMBX2KjmElgQPyY6Ml5zT6CJepy1GX1HJ3/GoseSrlHG?=
 =?us-ascii?Q?32JSIfiUGA2VUQ0iVhahvRzzicul4SAE5C0dtjTF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22484875-c16f-4d04-0dc6-08de0ff3dc7e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 16:15:18.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiL/HSY102ZKuwLeHYbLe5MeOv9HdJPOOFtLl6XMpQkPlXzaeAj9hdnAzpCw6x+U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6116

On Fri, Oct 17, 2025 at 07:13:58PM +0300, Leon Romanovsky wrote:
> > static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > 				  struct vfio_device_feature_dma_buf *dma_buf,
> > 				  struct vfio_region_dma_range *dma_ranges,
> > 				  struct p2pdma_provider *provider)
> > {
> > 	struct pci_dev *pdev = priv->vdev->pdev;
> > 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> > 	phys_addr_t pci_start;
> > 	phys_addr_t pci_last;
> > 	u32 i;
> > 
> > 	if (!len)
> > 		return -EINVAL;
> > 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > 	pci_last = pci_start + len - 1;
> > 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > 		phys_addr_t last;
> > 
> > 		if (!dma_ranges[i].length)
> > 			return -EINVAL;
> > 
> > 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> > 				       &priv->phys_vec[i].paddr) ||
> > 		    check_add_overflow(priv->phys_vec[i].paddr,
> > 				       dma_ranges[i].length - 1, &last))
> > 			return -EOVERFLOW;
> > 		if (last > pci_last)
> > 			return -EINVAL;
> > 
> > 		priv->phys_vec[i].len = dma_ranges[i].length;
> > 		priv->size += priv->phys_vec[i].len;
> > 	}
> > 	priv->nr_ranges = dma_buf->nr_ranges;
> > 	priv->provider = provider;
> > 	return 0;
> > }
> 
> I have these checks in validate_dmabuf_input(). 
> Do you think that I need to add extra checks?

I think they work better in this function, so I'd move them here.

Jason

