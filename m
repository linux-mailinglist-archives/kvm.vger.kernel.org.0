Return-Path: <kvm+bounces-31284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A168B9C20CD
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EC9D1F24F38
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8BE21B421;
	Fri,  8 Nov 2024 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZqnJ2nVv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7BA1EF0BD;
	Fri,  8 Nov 2024 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080539; cv=fail; b=PJQ/Gm81IeFJ757htMgbBbskKHYmocKjyprYNKVk42x8Jm9ZyLqv2c+up/FGhWJXr3clpEVtPoQLVMSqgRWZOq8xu5aIO/V2ILBja+nSQvrvgqca+7tGkS2M1QuOxZmJHAOi7Mx5P2D2/TxctbZqZJFkjakt6HmRhuqXm/3UUJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080539; c=relaxed/simple;
	bh=00ryfGZLVh3ggYRd5WYPXy0VU7Rt0zHOIVGjGgMb8/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JITG8oVCpYyVETgZxhSg7AGvO8iZx5uot2Qbp0MNcITYLy1U8i0Cxr+PTtW85tjd9xx4VlFtWgo9iDDsdjvk9bWI+zaL5JBu8Bk74M8KqZ28pEvTx3ZAv7euC8XPaVtkVpDmEduxUdCi+3Y4EIJUQTg62ATGO+zyg4RCh4D4lK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZqnJ2nVv; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=crAxj6wy6aFzBeApGcK0z/XlN+L7Zkr8PpxH/kXcJEb0dDLcngmPQvvqVeiNeHv6in7YQXTy3veFVxYOV1cJ/6ARF5666OguwTgWSQ7/1PY0UwfnBgiqlcPWFo87QON5A+RLrfblhVEDj/SS9xJZ5wHpxZTpa7CP5JVFlOAhrmTRuKlnGfOLt9uAg2yCjaLPNX9VLchCfes0RXJPRYsqkwFd0dg2OJyZ+AFjxa9nTRaydD8DsfKq4ro4idSIs2KBhgWkMylyXabF7y9igxt/gQX8K4Ar6oZfcWE4ZdmvvCgYdBHuB8rH1NaYA+eWHaVgHywVfBJ1Y7OrEqvy7SO2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJzTmXqAiD1Y+VEiH1a/Db7uajTkL2muZ1N0kmwDKiA=;
 b=VDIFU1UgV8IPKxYsboJnJ20hbKoS/lgwi9BJYFmvrl9qU/A34wlHdFcaUMqdZXbYEhe689bPslitCBvEK4euiVYs3noP5Jp6yM+k1zcKwBaQEADR+QyezWx8zkiwR3CObh710fE3DrDhLEhtjB4b76xeXnvN3okB5dndv1zorKZLU9pRjAjjy72aaphfrEKb/VRMQ9ol5w1XVUgSIMTLnRBIz1VCN5BaE6qnEnjc5xpYRp7aqIf9RrKefdImjmewbrlOkY+HWA2Lv+Pwi5iK7CA0Lfu6QJKIDWguNlagiqqu7QlVYRUmfctdANoj4V7WFBNkFAyxHGb6w7fH1NZbtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJzTmXqAiD1Y+VEiH1a/Db7uajTkL2muZ1N0kmwDKiA=;
 b=ZqnJ2nVvRzpKRtxxRdnORNq8FxfXfvcjai0q2yDpj7kxKtQ+dHIeZ4VfOHKhV3RMMQC0nNmRdES06jxgGphdsi+VkeNdePge+Tix7biFYcRDrTlhzKqXhIGNMDdP3iQooV2baGS1Dz/8xIH92Utny9gTlryITWVvyy8WEJ0U2ARXJHrOqdj82AFe08Yrbd8ix7zXd3GYgO3YzSIjwIKVpNSEL0VIQncF0PprGmADIubfPtjZbUed6YNmGftyIKl4K0FkIoNcNJsnVlxfk4ljMvkWPvLvyi7d1regNMDQQ6fAyEjdEC1X8lgac7qbsis8+KXDUecwt71OaRQDYQyWqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7322.namprd12.prod.outlook.com (2603:10b6:806:299::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Fri, 8 Nov
 2024 15:42:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.021; Fri, 8 Nov 2024
 15:42:13 +0000
Date: Fri, 8 Nov 2024 11:42:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241108154211.GH539304@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
 <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
 <20241107023506.GC520535@nvidia.com>
 <20241108145320.GA17325@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108145320.GA17325@willie-the-truck>
X-ClientProxiedBy: BL1PR13CA0447.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d63609c-f103-4efb-9504-08dd000bea0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mXqy0z0p6A6xvkwiVFD6ZwFt042Ak7CWubQuXwdlTMHPhur7dCjooCwl2XOH?=
 =?us-ascii?Q?ve5F4YPzuPUSJsWqi7wsWnevIjRK6bffHnVPp3TcLXZrye9C7pDt95XpLUKq?=
 =?us-ascii?Q?4wtM8e/m3Zc0HOixyCq6/C7TY7X/LnRcMO3g6IN3mBDica3sDMrO9atNf6IB?=
 =?us-ascii?Q?y6H+4ptf8JLE46c9J7D8qpSuD4phJT7L1w33AnkiolWfVpyp6fqAmanQBBkP?=
 =?us-ascii?Q?CtbKNfAy6Oj6GjPnTmIh0U4vMg6nPMaUJw/fwIXTYyI2t3O+TswnzTyLnv+M?=
 =?us-ascii?Q?mgDYbGiATrXKYwxBojRm3/rrfNt89RJ/1KWh8I1RuhaiTwQiuTOygEsmI6oG?=
 =?us-ascii?Q?hwPGveagz/Dkr0Jdjm2mQNTMHBX/QDk1X7YEsbhOJHpQx6eBn4iDS9BEhYtL?=
 =?us-ascii?Q?F/0CVSJWvPAdIOAJFSxVA7fOwaW8d5kGA1VP5RmO5qv15wMiN8H8iRhf5o6C?=
 =?us-ascii?Q?hKlfhoG3bqNwf6TVIRaG9wLXm4iDyYBqj+yuJ1zyfa/CDvxk6szM8Z/+YG8R?=
 =?us-ascii?Q?GtEU8QHKvTfgRvGIGNQzOuZzjJVAns7g9Wqm4sC3H2xHM/96YpFTa+gBYPr1?=
 =?us-ascii?Q?44VLcva6Iwxt32cIRWkNXu39gxg2DjSxT0JftOxTDl8A+9eyVuL6t1rUT+41?=
 =?us-ascii?Q?sVYq7kVGwx0OiJdPSpj94TUe6QRbnOKLvIvZmSItWzgBgrSaMS8CkFZTb7j4?=
 =?us-ascii?Q?cW8KpcK6YcNHoSpLdWe4jg+CpUDjZdEGzcbVfRv6zJ1q4v/67qR3tddLxbt+?=
 =?us-ascii?Q?2Q5AB2nQLAX0DMvy/3T0ogFu78pCqrJ2oDhWPJGjvOBCye3Eiek4lVN3NeN6?=
 =?us-ascii?Q?4ZsqhuAExD9C2g/yZMIYEiwuHJ4vkSp5i/CuvNT9UhGieWzqv6yF6m3AkmYz?=
 =?us-ascii?Q?hNsUTWF3R14V9i/8nnE4fA2Eyh7YipZIBMu+VvZvp/j2Dl96dRBwBQPdfrHA?=
 =?us-ascii?Q?7LdOzmZ5TI02BbLUGsDvSX3B0xK4+8RVhev3VeLmBWJm5GwZlbfyXPzBP8uR?=
 =?us-ascii?Q?1q45vqSm+oaYCOmT0TRWLMwzwwHUM9p+5OjvvSAW7wZhh0NSiT6YjvVuVw+l?=
 =?us-ascii?Q?prWTdhcPC3wGD0z1QAxPzbirqqkq/XPE1J+01mQadPii8AnuJDKmnGCoJM8w?=
 =?us-ascii?Q?eaT46Hp9AsSq5FYlCqUckaoqoN2UhvYvkABIeQtb7mRNYXtGupL+a3eKmYI8?=
 =?us-ascii?Q?oC+z0drvXBT3xLvC5mqrComsUBIWJokhheBWDR8wiNzcQf8ER+HgY6bjZ5w6?=
 =?us-ascii?Q?XHjitQN33p+OGTNAUNBYoWhtdBsF2W32Px1WbJolJo8q8XN8cWiK6NahKibM?=
 =?us-ascii?Q?xnxGJzfWdWt8dfeu3+s/4xDG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M/Qn7Q4lPY1xDLW1uLfttgxSsixMsjtO41TX0m4pHRdev32ley1h84wdd6yT?=
 =?us-ascii?Q?7BsmAx1oGtXcZhhe1h2i5aZSTokKayJW+/xYtAT/NPvOJDMAwtsYL6VrVX0L?=
 =?us-ascii?Q?l7QkQxOythlD6ThlypJGnbEm88/Yg7CnuLL1Qn6msMlOZ1eEx2BK78c444rm?=
 =?us-ascii?Q?QFrJjm9rLTlyOLYwaCD4Ao6F4VxhS3JfF+OUt/Rth7HGPucYPOID0iAFLY8r?=
 =?us-ascii?Q?t48wuG4pLFC5gwZFvjpM2L6Dx089LSwPYOQOVbzYnCE64CiCasADRi6hWnty?=
 =?us-ascii?Q?n2ZKY2N802mt1xRW0x8ETD6XGV/T2EHeSTA0e1cgjPwCNgYHoG5OS1FHMs36?=
 =?us-ascii?Q?0HPrHnkZ3zye/rtZhULdtoeSw5ChCd1kJHty7dYZ+dQx4ZHacOWIFtCt0qxQ?=
 =?us-ascii?Q?eoo02ag1r1UHAodqtnYWQIvpHDAsmD0HxBL7dSNl3nAR/6uxuKvHKqoJqBn3?=
 =?us-ascii?Q?3CvJXUGtpxdtWeeKN6S89muvtX0GIMqkw2qY/zFJjO4A+Z9GEPnuGFHSxqVk?=
 =?us-ascii?Q?ZJglfkzjk5e1LopzBqc9rdaqoqKc1eyde8swhwKnNDakgolheibVBBERZS1R?=
 =?us-ascii?Q?BjQY8+93rL6FrkpBh5T2/J6+X/nassXqNT8VSZtIe/I/2/7Xac1swVDgb4Yg?=
 =?us-ascii?Q?dL8i6oCjiv56QXhGUuiYgDhS/oWyfQKpI2Cf0+3Boi9P6OyU6ce3Oz9TXVtq?=
 =?us-ascii?Q?Itji78jvepH/0E+jOeaXutPZb9slXsvG20Lz0s55jqixtxFlCbB94rjTD+9p?=
 =?us-ascii?Q?YzyLMlI8IO0b+74TCO2j3OoUo9KbE31sCzrdljU8uTiuEusBvSNLfFCKKYVd?=
 =?us-ascii?Q?rAi2yaaKVvU+TOvL2Urt4dRuyRRibr9Fx+zMeSECwsusvEENxoeYqTnfGsBF?=
 =?us-ascii?Q?fdAg/lZmYUfrLh/A6JqT+NTt/50vcfKCd8L5E3QdrRIOjksfOfwiGJomwce1?=
 =?us-ascii?Q?5vXl//BIpbrV4pV9vS4Bq74KLhTXARjSzQxAQsBKqOQxvB/FwEo0RQ+cWvvj?=
 =?us-ascii?Q?AscGJZEogQ62previwewxxhkc2PP5zNEKlf55wGvxgLMosf+I4tdQ4bMzzPb?=
 =?us-ascii?Q?6EtVWkQ76dy8nPIOGwfL6vf4bXRtGzP5N5o2hglvJhZRuwQHUHJTjZuiarHa?=
 =?us-ascii?Q?eW/HMPRn2EB9SBM7p3zoGLH6FdlGLNJ04sojbCaZ4exOT1/OSdk/1mr0bJPd?=
 =?us-ascii?Q?ndpN3mSAgU53vJjUhsCUeMKGAlSAI/Plsdm8sVYifUUnfmGIbn64/uiJ5QgI?=
 =?us-ascii?Q?IbjniZt14pNcpwYjkPWOijhjUB69GjHh1VqvT/mgAXl2tCWP5PxXqtgvIr5F?=
 =?us-ascii?Q?SLeP4o09DxbR5gL+GVXgz5YCxotAcI7XrETmpgyylAGIeTsjxvaRSQElRqFf?=
 =?us-ascii?Q?/iVjBCseaCmtOdNcLCudPDEgBM6EU4ytkT5r7IgZfok2Tnypp2xZ+fYp6Ivl?=
 =?us-ascii?Q?dkd2riFBBAhQvDw7LzmdPXxehjsWtQrTXu27GWqdS2W8JFdTzWdW3WrXa/8F?=
 =?us-ascii?Q?oaswBokMyVJeuR/Afqy4W1o+dqn1cp6B2Tm9qPJeYTItDH0GyyJ1RFZB1C+6?=
 =?us-ascii?Q?8JfZ0p8RAK1Zs0DFb5M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d63609c-f103-4efb-9504-08dd000bea0d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 15:42:13.0476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HoAmUUUZAlizUQrw7PjzaMIb7Q2fZyWk8y1WjFpov534VSffHvY/oxVK7x7FpgFZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7322

On Fri, Nov 08, 2024 at 02:53:22PM +0000, Will Deacon wrote:

> So, given where we are in the cycle, I think the pragmatic thing to do
> is to land this change now and enable the ongoing IOMMUFD work to
> continue. We still have over two months to resolve any major problems
> with the interface (and even unplug it entirely from the driver if we
> really get stuck) but for now I think it's "fine".

Thanks Will, this all eloquently captures my line of reasoning also.

I will add that after going through the exercise with Nicolin, to
write down all the fields the VMM is allowed to touch, it seems we do
have a list of future fields that likely do not require any host
support (E0PD, AIE, PBHA, D128, DS). We also have ones that will (BTM)
and then the fwspec weirdo of HTTU.

Given those ratios I feel pretty good about showing that data to the
userspace, expecting that down the road we will "turn it on" for
E0PD/etc without any kernel change, and BTM/HTTU will not use idr for
discovery.

The biggest risk is the VMM's badly muck it up. I now think it was a
lazy shortcut to not enumerate all the fields in the kdoc. Now that
we've done that we see that the (unreviewed) RFC qemu patches did miss
some things and it is being corrected. 

Nicolin and I had some discussion if we should go ahead and include
E0PD/etc in the documentation right now, but we both felt some
uncertainty that we really understood those features deeply enough to
be confident, and have no way to test.

There is also the nanny option of zeroing everything not in the
approved list, but I feel like it is already so hard to write a VMM
vSMMU3 that is too nannyish. Hoepfully time will not show that my
opinion of VMM authors is too high. :\

Jason

