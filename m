Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE6486859
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 18:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiAFRWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 12:22:55 -0500
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:62499
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241633AbiAFRWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 12:22:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpiB77ntcxFS6xrkz0LJaTIjX8oUe5DdteT3CYtu+STqCVuhKO5UiFHwBh3bV21mYXtGtSkocHwil1oMOEhOf75kdUc+o1rFQM0z4P3QAZhC2Ol4YbwK+zaL+wDnM6ARBFsJL5Xr6r7uswD3FKuKfHA6uQ+9IFO30QqOJMjz0wY6PmKPORjz9vb3vkZJuosmVizZYQz8o12DSm+9SkGK3vboFc6brFRLPiV0uyDPhAUivgLZCLVrptRgqsxUJmuqOiVOvg6FB4C7YD5Z9aAj5mdRcplro+0oOtTIyCRhJgcwB5pXGKhW1A/zJWCQIeppCUAuJxsG0lMZKpZiIQzRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO3ZX4/IJuvy6YJB7dKW1EEoy/wEJ9lxPQERUhZtvDY=;
 b=i5CZjCzw5fkNxqWGLHMcBcgY0aLv2ozfkGzsgcGwYwIIevALfZGccaUX6MSGbYM8KDHsdjoG3tO1dcq4i22bnK3IJldn/vv/DjkorP9/GUR0gdmv8DvHJ1WKu4pNX8IoNLIJjCxhdjjDi8wq8m9XYc56o4cygea0ECmZsYIPH7GzNds6XimRfKqvRg8spbFLzDIM8M6ipXAmzjpg8yxObEaLOfHLtlNEj6s9Onbm2NCpbx3GZJNd9V7spzlA+i3AHtJUFY/fBwLqzm3phKSEmdpncaJOO7Qmq+wPLTTdOVNZw7W2u/q9y8+JsQJBF4Gl+xESE8EkEfv6CT5z7pXy5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3ZX4/IJuvy6YJB7dKW1EEoy/wEJ9lxPQERUhZtvDY=;
 b=Q+uRr8D0epIrcB3lxDuIDQClUYY8mlwn+VGzNqv+eLUeSHhB4hVrdSdhrT3O/seBj6A/Ya1mB2NXlMeIJPsFBD4uj2FmnD0pQJnxe0CKra7UD1oH1Dvmkr+ceY6lqOATxDfOe0EaZGsldjacqfhDoESci0Gn+wqrnBcaiG5jHBBwZza498srZL674M/zOPK4tpJ3pdZ2p8BZBsEImnM188T2Qv0qeKzeJEMGP/ZnBBkWvw9kXMbq/7RPL2gykY95youmn1MKl6liAOmQe/7sNI3wFhSaJuHBWY9/jzUuZRa/SiphVEITtOxy4ijQQ8jtUqXadl1x+MAlpnN7LYtGJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 17:22:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 17:22:52 +0000
Date:   Thu, 6 Jan 2022 13:22:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <20220106172249.GJ2328285@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022053.2406748-4-baolu.lu@linux.intel.com>
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa0ac544-07c2-4ab2-c7bf-08d9d1392b7a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52561791D90A755292839434C24C9@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e7vzGJeBsAYCbPKdWM2I2uz100L6d8Hpo+HAvRSnfZg5qozCrw27JOZey6QGyVzFOupEmSwLbF5ffU1suWAEzYoGKS5R3xvOYnkNypxSUZKxUfNrE5zm2UWzkdJ27006G0yrz/1/G0eV4AjorU8W6r6WRV8SnJwhGxqmTvNJwwisQrlvP2m1GAHJDps/GJWm12pc5uctNZm7+kFqWi+wwZVT2nTnQG4nVp8scs5fbTZXt9SSk7+i65qHHeZ2vLrpC2aL+GQ137J8FoV/7jJWcIptgpmU9HEEAIoCkyXZFKN2H1YFbHF32s61ky9jSg/b9wwWZvk1TivTwPy+bDKSQLXFUPiAYFsqSOWoIunSMtpVCiYRUGzF7CnZlgoa1/ty+LzKUZ47jT1bYyj2LkcWvzbHnAXT2j6ivVaJd5B8Fc9KTHG8RBIoyONeRjFYnT/pvNAM8V73FcsHzTX+/BwLbdQ/utbhFIvLz1gBk52bDxihKxRSP0somvHnjYrYQemw0VFk+irTi2D9MBcxLVgPVO8xcpxJSCzE3J/OORte6XiMHnQ/XjWyS8vubUHh+2r5jI+HlTrZ39mW/+lBQIyb+nPn76JSe4/2xZj2e8fxslnMca1uxWLJE8NM2UIiZ4SEgrzWux+CdUx/bBE0HWYuew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8676002)(38100700002)(2616005)(54906003)(7416002)(6506007)(4326008)(1076003)(66946007)(5660300002)(8936002)(6916009)(66476007)(66556008)(33656002)(83380400001)(316002)(6486002)(6666004)(6512007)(26005)(186003)(508600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0m6kuAdIIIMZMmc/lNxDGarbup1AP/dUEOX+FwIV9iA5f92737Sbj2ID39gN?=
 =?us-ascii?Q?pllP0bcXD9QUA4Dd8Xt33TIH7wc8UknsESCd6S6UTAucF4eVqD93h0lxFbVQ?=
 =?us-ascii?Q?DUUMEgFpHFCQZHYaqTVYnjnKZjMueHEv7jsiou/+BJVTLNdFUdCpNqySLDcH?=
 =?us-ascii?Q?WF2c5FF+nbb8E3yDnBmUKn25nuE1NTIcovPzje4sMiCz0cP/dHm3J8wMSxdf?=
 =?us-ascii?Q?sF6wvVVDSP1bTPVcsC8A3eAk2yX6BoFg5qg63erHRSGYRPe9FOyYsPpCdSxh?=
 =?us-ascii?Q?zAoWuy32GoHNGpGktGgyuDAdlFSu9CmkyxLwLh9wM76FPYpMyXqNv2g8eZfj?=
 =?us-ascii?Q?zYVGq/XQdwY/pEWSr5CWLFNsAkUIb+HxDUb/PTN1gxi2X/GdZIj1k2hU4uLH?=
 =?us-ascii?Q?ptaTAe8Blw2x8xyXOhn3ThV0Fp0PmsaCQigbgkmVK0t87fAsv45VOhBuukfR?=
 =?us-ascii?Q?JppTVAh39ggTN41vX8FpQtVgYV6Ytv5C4zaHF2CyAES0huFPoAtRZax5NiNE?=
 =?us-ascii?Q?3w5uSNqtX728zmGBPETcEqAlaD6HmgruQa2hkYytk/dNweNWPSWak9nT9DQN?=
 =?us-ascii?Q?wrPviKMDbM14RTB23z3HVFrVN6p8FEOw1WRtWGV6pyPB7LUNeO2c5Hufq3II?=
 =?us-ascii?Q?b9DgwarcZrt8RgAScg5eVx3MAnWLY9fY/co9Zgs2DmbWyo4gOiJDdkfDRqp8?=
 =?us-ascii?Q?rubs9V1teQSSsG1HlXF5lQfcAp0OUVI1pZzyT+h4hrUY9g5htpjgLultnsFr?=
 =?us-ascii?Q?rQ7+ruD2pIyTx8sABqUApneBLErIcyMD9zZc4h3p2pPcq24YXIasr7m64xvc?=
 =?us-ascii?Q?dVhSdHr15KDHlYMCLiUjRfMZGnMthA/iVHMifxKp2SPL+pWarST3f7Eybx9I?=
 =?us-ascii?Q?zAuYqkxROJPvlFBHpSyKz5P/cViI9APPvVhaSSfSIZOJbPmXHd6qVsAqU30C?=
 =?us-ascii?Q?uLT4OKxuaif40IJfjkoRR+mNbU02td+anPPA/Naq/HDoUGQOfimb/Wlu0U5e?=
 =?us-ascii?Q?bds4ABIWSbMn6uU9hxQMByd26PPo4086DIkfjXDiK81Sg/Wyh/ui7tLz6IPo?=
 =?us-ascii?Q?wTSYfoLZkdpOAne9qJTCTnPcJDT3emdOz/NzpSW1IjI7E95lDw8Z328ZaeQk?=
 =?us-ascii?Q?pJbMkTcuRLsMkF1BvQmgXahJjT+Jb91q89misfc0gYxRaIDgZW8RN75yXiwI?=
 =?us-ascii?Q?94iIF7Ml7i+w19BNDy3XXJ0097aq5JhiCEuw5c6MgueYaqSDyrJTOAmNwNEL?=
 =?us-ascii?Q?ZN66QOaJLNz1fT0HdxVJz9sJ/TMWxZMkTleX4Sh8XGo53xiUzLlYG0rxiwoS?=
 =?us-ascii?Q?USuCm0cx/G+WR3xBDZ56G+Anjc8VLJd6JIG4gno1TAgsPxywQNZ2k1ayloqB?=
 =?us-ascii?Q?t4E9jT3+1R8uK4okCm8kOMW6j4yfZ3bCQTxrV3ecdE12Gk/ncE2MZa+lk/5I?=
 =?us-ascii?Q?iHdsKw7vIdsgiIjx5fKfy2DdHn35dwjnagLvY/+UHnXfSXmrCKfK7uRjdXaW?=
 =?us-ascii?Q?KiW20IY70nmZI4qFI30kAjFdhCL1OSor6vawFISTP6llGh4+4bmGc59TJOM1?=
 =?us-ascii?Q?zYapY2qXGK5pBZk/z4w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0ac544-07c2-4ab2-c7bf-08d9d1392b7a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 17:22:52.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rgfx+GwePA8y6nHiwhc6tgDS47aO9pkJ4hfiCYlysFwgY0g/70xqvPJ4wmdK9++
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 10:20:48AM +0800, Lu Baolu wrote:
> The iommu_attach/detach_device() interfaces were exposed for the device
> drivers to attach/detach their own domains. The commit <426a273834eae>
> ("iommu: Limit iommu_attach/detach_device to device with their own group")
> restricted them to singleton groups to avoid different device in a group
> attaching different domain.
> 
> As we've introduced device DMA ownership into the iommu core. We can now
> extend these interfaces for muliple-device groups, and "all devices are in
> the same address space" is still guaranteed.
> 
> For multiple devices belonging to a same group, iommu_device_use_dma_api()
> and iommu_attach_device() are exclusive. Therefore, when drivers decide to
> use iommu_attach_domain(), they cannot call iommu_device_use_dma_api() at
> the same time.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>  drivers/iommu/iommu.c | 79 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ab8ab95969f5..2c9efd85e447 100644
> +++ b/drivers/iommu/iommu.c
> @@ -47,6 +47,7 @@ struct iommu_group {
>  	struct iommu_domain *domain;
>  	struct list_head entry;
>  	unsigned int owner_cnt;
> +	unsigned int attach_cnt;

Why did we suddenly need another counter? None of the prior versions
needed this. I suppose this is being used a some flag to indicate if
owner_cnt == 1 or owner_cnt == 0 should restore the default domain?
Would rather a flag 'auto_no_kernel_dma_api_compat' or something


> +/**
> + * iommu_attach_device() - attach external or UNMANAGED domain to device
> + * @domain: the domain about to attach
> + * @dev: the device about to be attached
> + *
> + * For devices belonging to the same group, iommu_device_use_dma_api() and
> + * iommu_attach_device() are exclusive. Therefore, when drivers decide to
> + * use iommu_attach_domain(), they cannot call iommu_device_use_dma_api()
> + * at the same time.
> + */
>  int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>  {
>  	struct iommu_group *group;
> +	int ret = 0;
> +
> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
> +		return -EINVAL;
>  
>  	group = iommu_group_get(dev);
>  	if (!group)
>  		return -ENODEV;
>  
> +	if (group->owner_cnt) {
> +		/*
> +		 * Group has been used for kernel-api dma or claimed explicitly
> +		 * for exclusive occupation. For backward compatibility, device
> +		 * in a singleton group is allowed to ignore setting the
> +		 * drv.no_kernel_api_dma field.

BTW why is this call 'no kernel api dma' ? That reads backwards 'no
kernel dma api' right?

Aother appeal of putting no_kernel_api_dma in the struct device_driver
is that this could could simply do 'dev->driver->no_kernel_api_dma' to
figure out how it is being called and avoid this messy implicitness.

Once we know our calling context we can always automatic switch from
DMA API mode to another domain without any trouble or special
counters:

if (!dev->driver->no_kernel_api_dma) {
    if (group->owner_cnt > 1 || group->owner)
        return -EBUSY;
    return __iommu_attach_group(domain, group);
}

if (!group->owner_cnt) {
    ret = __iommu_attach_group(domain, group);
    if (ret)
        return ret;
} else if (group->owner || group->domain != domain)
    return -EBUSY;
group->owner_cnt++;

Right?

> +	if (!group->attach_cnt) {
> +		ret = __iommu_attach_group(domain, group);

How come we don't have to detatch the default domain here? Doesn't
that mean that the iommu_replace_group could also just call attach
directly without going through detatch?

Jason
