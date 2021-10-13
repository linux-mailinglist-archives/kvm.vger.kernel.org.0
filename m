Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDAC42C629
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhJMQUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:20:46 -0400
Received: from mail-mw2nam08on2057.outbound.protection.outlook.com ([40.107.101.57]:26593
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237700AbhJMQUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 12:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKcFL5odvw0GUbR5wvsl7b5TWSag01kHv3VHMBHqf99L0FvqWgOEj7lbmeSHQ2WMz1kxnOfsxwzgoYyrR7nx7GsLwhJG1clQtnDMnmaJtixrUS7p/7ZE0woVAVxyB25Rx0Vcs+80mXTF03z0gXiAmetavhoRDryFlABn19YkcjBBk2PO9U/knecTDN8yiq6K2lugHFGEFUmPKF0M/TJwwkCAVrJki5YSIIEIJSa9wYb1X9SlLiu0qHMoaws/EXtK1jvIEa5zmQjNWN6Pp2fYBRgeuMFnDUDZHVhXTRi1JfFECPFu0YRAV5/3lTUPkNqEXv5KzgQEgR9D94C4m4lNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwX+kchcnWkoIR3+ePaMgMlQ6k8qzHb0YcWrrhgQzw8=;
 b=G1bJSpWDb9wC+Acv5OOCWDhm8LwwbFNpfLemtOn6vGxOG6FJC/29rmSQiHpB0EYW5PxP+XPpLTaqc8iEgkU318aVrndWtAqiuONaehPfcafHxoaugzlScoxQG/4gxWHVxP1VgABivYgRorLE0DIGDh7zKjlsP+niF+yKQef/6LdG14HlT8a1PAWIrpwLkWL8oVgMfZQj6DQSmD30iU/1i70oZ1JjhBOiP1A3KiMbuuZzpIRtJ4TeGtL5QvuEw97YvMmG0JF0OtXOFJLcUS6x13y066yMfTEY4HQOs6MV6n9vWlP7XMHMztKK6rkQB+lQsg8FldUZvrejyaUPv0NuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwX+kchcnWkoIR3+ePaMgMlQ6k8qzHb0YcWrrhgQzw8=;
 b=I7gfQBTahElNHspQMiEpCVQ55J1ShYLmKHZe2jSjqgj/xWaiJlUCtn4UlTFwEJWhhJmiUdyzQMToJj/bkQleVmYqP2MDHxdTwhwQdkgOh1qDmXNaQyR+mqJ49uEaxpWsDGCzKbiFHqH5x7tjrWO564hbcWLEkv/oVdLdnFSzi3LPJVd23d2lRzOI9ziTWkyxIqgi/Do/95QcXLw4twDt63P7pKqioNBO1JikX+Y4gEHPQopt8J8k+FcVNtFtYE2OwH210s0UEr1LBwcglwWD2kWIsfGxTCmyswtg2DvZcvtSswjeE5290Wikeb1b4hY4MnyW9Qou00MYrX0SM5PyKg==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 16:18:38 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 16:18:38 +0000
Date:   Wed, 13 Oct 2021 13:18:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211013161836.GH2744544@nvidia.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <3-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <20211013160910.GC1327@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013160910.GC1327@lst.de>
X-ClientProxiedBy: MN2PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:208:134::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:208:134::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 16:18:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1magxg-00EWzv-H2; Wed, 13 Oct 2021 13:18:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9de2dc4c-b705-47cd-02a2-08d98e651cfd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51111A0A0F74A8E5E8E12164C2B79@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NcnjAthVp+K/iK3RgLfdCGFZ22VqOyv4XG+auBdFZz+s8OD9uTqZ5VS1qwy+MWd6z6iPdUlJNwTNZI3inZERNT/ltotovkKYdDfk3g8TpxptC/lmV00lMAWsDfnxTfZW8DIj3uMv4FyKjEeGMKofHgIvMcAReg1/beyMYGni64drH6kbWYTFaYWt7SWDT1pYQuPr9ddWKocfDnfucZPOq2FevopYZKFZQBO0Hn/rAV4+Ur1mxemK/VJrgx95RJmf2B1FE73tF8iQZmSmRlfQayIe5gExxbaHk/5g3jW3k7wtLtmTwPMxxcZN1EDpoA6SDRY4Vxw55k7K8TxWGHE+EwisJynRj/Qs1xuOpJECcfpFYeWB8t+gWmaZIvIMoP+6RdxKptihEuF2VIzVILKQnbj4CZssWXFv2nw3NQhUEkWkFzzH1Po5qdtLY+XaXol7aE2t7wJI5ShIcKAZb1KXCNM67IGTKk6X4fFwmD/1E8jEcM6s3QNCtZndofmcOzwIVp03/alkyrSg3STtgu6hfYGA4tzgXf8W8OG27SRVtFnR1IT5Jg0b7vAuh5x7n3pr6jI7H7mRm4B1U6DHSrYVxBch4i9R+6Tt+SO0YkG5qbEiNvtol25anYNmVDHlH0Q7+ybLUCbX/newbWoiimit3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66946007)(66556008)(66476007)(508600001)(36756003)(4326008)(6916009)(5660300002)(38100700002)(426003)(2906002)(26005)(316002)(33656002)(8936002)(9786002)(9746002)(4744005)(54906003)(186003)(86362001)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cp/ERq5Idid/6jJSCLuwKEZzkfm+z8FnjwIy/8VW+bTgR8JlHHpT7Ls9/D8Q?=
 =?us-ascii?Q?Ddhw8cTa1u/hKgXu7IsWNtpx5i5UgUmGmOE7NyTq8Di3p7p1MI9Xqco21bg/?=
 =?us-ascii?Q?eZkA/T65nhcKZ14FvVSb8XxnlHHmf9TPRMIFC0W9Qs0ZJJN4we8WrpSE1i+n?=
 =?us-ascii?Q?ooo0Fjf+r+TJX/WLncel6RUsiS5y6LhqU+15mnG4Wy/4jmUgg9q23NJjfTu3?=
 =?us-ascii?Q?ZHH24SVeFedP9kJ4EA+trFvngM/+yCTrBIf3irO7sN04Ovo6hh2eZ3ucqzCw?=
 =?us-ascii?Q?JTaIV/IqwzPmW9eH2mFXZpqaz033TPcwOKeyJ3dwFm6YQPsf/RvPw3MhXATg?=
 =?us-ascii?Q?VDS+Is0jjoO5grEEk/+K7f0bWFI7GseT4ykIzRCpDkhNnpPhlkvPq6oo4Feg?=
 =?us-ascii?Q?U2ImdFKJV9tPKnmD/dwyTQpt2Cf14EY75jQVc6uveSPnP9Y27YHTrklCeUSt?=
 =?us-ascii?Q?B1ChrTJCriAdJbnP1CEh3O7qh7cHG+sF4Ybo0yXQ5Xz+p6LCw42TztvykhBY?=
 =?us-ascii?Q?n76ep5rzQf5G71Aw4azIChELtyFM98lGB/XrVRIbl359bg1CZ/MC/AUAIEj8?=
 =?us-ascii?Q?7r7wvrnEDecJl9e4HlisZakSXgtSv8Iw1tL7aNeMeqgaDf88frLea9jQJcSD?=
 =?us-ascii?Q?i0YIkGvRIaK7hgcc1G2f/TYJ6V9pMrmVSYFNDul6nlKrlOjJzV+mTzw7PTnd?=
 =?us-ascii?Q?E1Jzubwz7iDQA3lsjh8abIbRkXwe7sUq9Qjt6CeQEhPySGiOlqh/NSPln2UX?=
 =?us-ascii?Q?ZXehXEUgvuhWGYmDjdWf2Y3HRAEwPv9tl8g+5wDa4cYGnY4uEmO6yZVdJ1YA?=
 =?us-ascii?Q?UpvFoWATeH92dwvtrbqy2GCVIAMZh4BXrrOTCpOXT9FiX5fZZ/KBAib2kmbF?=
 =?us-ascii?Q?qWLzhB3LZpkxeDJchCQxHGl2OcLxEHjKXoedOVMuIDJrtAQCF7jTLDR9ZMD8?=
 =?us-ascii?Q?npd5Yyc6CJSYr1Et4zm16XfGKk+g4TF4APZgPXm4v+aOu76HpDBmI3cveB5o?=
 =?us-ascii?Q?LfdDVdVc27RrJemaDqqsYSYgHME4v+4MO4c0PL2/1TNu+KsQehsS7r358j9i?=
 =?us-ascii?Q?e8jXnTbee4x4anBQ8zw6Dxhy2Rsy7J71HMDopWUaXtzimWQicTZgTbXJm+1/?=
 =?us-ascii?Q?BWZEPA07Kuq1qvqVkm6m1ibuIasYEqX7FeIo/TrJWw7ukPPeMBhX67KMCen4?=
 =?us-ascii?Q?kaG+LBz0R0ptdV/+WxaolidSRPTSgDU0rzeLSEOlDOCtedcsTdoNvZex9Dou?=
 =?us-ascii?Q?vU+7QvGN/MLklMCPtYQzaf1NpZm4YG7CdtyGP/dB5TadSqnaMKkcpb6+QSs+?=
 =?us-ascii?Q?0KkMxrlmJcWwghEEQAewXc8f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de2dc4c-b705-47cd-02a2-08d98e651cfd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 16:18:37.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LehbW5nQz7tabhrPtx1iS9FbAQm6W+d139PoyEVzNQgDSFBY+r4TxlSwhZaVcb8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 06:09:10PM +0200, Christoph Hellwig wrote:
> > @@ -775,12 +776,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> >  	if (group)
> >  		goto out_put;
> >  
> > -	/* a newly created vfio_group keeps the reference. */
> >  	group = vfio_create_group(iommu_group, VFIO_IOMMU);
> > -	if (IS_ERR(group))
> > -		goto out_put;
> > -	return group;
> > -
> >  out_put:
> >  	iommu_group_put(iommu_group);
> >  	return group;
> 
> I'd simplify this down to:
> 
> 	group = vfio_group_get_from_iommu(iommu_group);
> 	if (!group)
> 		group = vfio_create_group(iommu_group, VFIO_IOMMU);

Yes, OK,  I changed it into this:

	group = vfio_group_get_from_iommu(iommu_group);
	if (!group)
		group = vfio_create_group(iommu_group, VFIO_IOMMU);

	/* The vfio_group holds a reference to the iommu_group */
	iommu_group_put(iommu_group);
	return group;
}

Which I think is clearer on the comment too

Thanks,
Jason
