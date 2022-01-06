Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6148681F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 18:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbiAFRGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 12:06:13 -0500
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:15595
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241500AbiAFRGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 12:06:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXk2r9xYFNLxvlk7/AAo8Ls77zQ6WaTBIDqENYibt7nB1IdBgULGJB+jB2heNsitkItZGDvnktPrheaWqGxSIquPsEAJ1PbKux2DErPTjP0oReL0BAQrjvHQPJhxfgNgNbgfmLZJOgHAQhBvLJxsT1J4zktcDmvdDz/s/0iDab0MxxiRR6UbKNaC/PKxme5h7xoa8s9gKRxpdRubTAwVHFfG++14yfz/NYCyWhQg5ttsDiGRma72t3OKHTqjplDjdVdSIhR5pw82h19FSLzjaFZtL1viZ5LBMeLEG6tkRfPseq3/ZvBz0puMAMY3q+jadh7qSpn4iZvhdpe7JQc3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ysKE/w9/wTjfrhNi27h9c3SdhKzczQ4LaUmH0DzTjs=;
 b=jFPWA+yNY0ebaIh9Z10x7fIBd0u3rA3xC0aSEkZ6i0Pmrh3fGRLDemfVS1El7KQdv4/ffwYZMYY8qKBo+8vC4nX5PheDU2uKMtPnqPMRktaydIgAthUMYn1QUw9IzNw3aHwGixFeedn6K01N//8TAyTMIiNbzFgfLKlfBdwOak4JwRh1zRUxRhreZIVgDeqqsXWvroEolI2AEvm8pRDniLA0mhteHPOs7j7UGvRjV64IMri4tKpU1kKUIVKuYqRCi5wc9z3+5qP32J5lzd/otzYHhcHw+9TajMAW9psZz0VDT7HZp7HqXb5abLKkvOD6zFF+ypPNBxhuudPwjdLLAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ysKE/w9/wTjfrhNi27h9c3SdhKzczQ4LaUmH0DzTjs=;
 b=Yndn8ENvSPbfpDoOnRW9UD7kDm83/QoWCVoq3a9SaK2NqWQ6PhN/+kb+C8T/IFrbOCKp3Yzaqbar+jn51UVTlgyDfxdooi2ruOMTRdA4upZSOpb+muJE9Pf77ji0tnDpVGBhSsz4UhzCT13+3mZFH4kvBN85nWvaAdUegATa3/hYeJgLRkAloV2JC5GW9fcEo32NRv/w0rhV7FfTMGv6v3zBZCj//7AlrIkti6ab/Ei+XVAyhZaEkVwMKvQcvfw57GaondnMJPfQuQIxW4z3Ul36GIkXWs4qDDSDARS3cUPwAmRckYuj/JdqQy9PTwl4bbhA/hW0qszeW+LVGoQU8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 17:06:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 17:06:10 +0000
Date:   Thu, 6 Jan 2022 13:06:08 -0400
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
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Message-ID: <20220106170608.GI2328285@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022053.2406748-2-baolu.lu@linux.intel.com>
X-ClientProxiedBy: CH0PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:610:118::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1053064c-5cc7-4327-7b93-08d9d136d642
X-MS-TrafficTypeDiagnostic: BL0PR12MB5508:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55080D1690B14FDE9F121EAEC24C9@BL0PR12MB5508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8rB8XNFRkzR0kdmqwihZ+B18+O+0gU3kFdp/r1+pDb1uaX/qMgfZiDVk/zUFbKjbtS9f8yhtB6uUh+kguJt1q6EAcaZxD2YvJPVK+aVaNmGP575KIfVyVP7p3uHQP/0rF70MdqASP4Q5beMAn7B6uuIP1VlMbd9fC1j4n9MD68wj0XEW84+uVc2q+GKSGqgFa9faGbTzhW7CexNX4ckgVxrrzXH8m6geHKkjtjrsbr3+H3MqW0QnjUfNZUUXUW87H72pLrcj7ruo9YgjO97KZtCEPmmlnmGDRLWB+0KnKojZQH6cXEH7ato0zPRQeXNTbWcvcZXJdeaxlBYG5+695dTyIjE+E50W/U+sXVFYith4Ijmf2iqy4X5S8TM3jRxpJ76nIEHtVkacRAd5sdknr9zvOcfBz0s5GjQzDrqLGrZb5TMvljPo/oKtjVgudStkucHkU4qVEHWNpeWVSE7rQ7O47cw9gNGaTy14MY8qfJyBuOJRp5E3ntw1jjimbDG0vYxoJI4EALP/ZxQa2DJHEduLmm8KCBCTyk/qGjAB59Djf70J3vJAqs3cM2WBecjO44qcAoToFsuRdApQgNlYQKO6qNPvFCCuzwQ8IS1LpAOu9vnrSIwVO1VukI2ckPRf+jQ/0jbpD2AsaAAOJIgV4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(33656002)(6486002)(8936002)(508600001)(5660300002)(186003)(2906002)(38100700002)(8676002)(26005)(4326008)(66946007)(6512007)(7416002)(66476007)(6506007)(2616005)(86362001)(1076003)(83380400001)(36756003)(6916009)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kJbI9KLTDBTVVI4yqx99S3VkI5YkQYTPo43BbR8C0GHOToZSA33pzh3zJtUj?=
 =?us-ascii?Q?y2ha9ng3/tTIPejoZCy2/IGb0cYIgsiRpwu6meqThVguoalNEPeg/ThMdAFW?=
 =?us-ascii?Q?Zm13MuuB8kdXyL9eXQFS+kuXMfJbAFIA8okmzLSPuH/Q8hVqAaqonLeQpujI?=
 =?us-ascii?Q?VKKufpNWuGE4L12vr5XVKqO8EKM5t449R57Mc8VWC+5G+jQojsW8IqxZGD9/?=
 =?us-ascii?Q?SClS84j0M0u7/rvRX2q2aMXh6fDc1DblE7IC50hiDVWq2OnMWfJR2k4kgeCt?=
 =?us-ascii?Q?rz2vjGIiHCbNR/fJdR6FatU6LmlYjrIeb1+BjJMiAgKlZSHIPyd9Fpw+AcCY?=
 =?us-ascii?Q?Bn4yywDjyozGaA4Ehfs8OFvapzppzQtc4cm/vA9QHdB5UdRFR9PCBtoNnjY2?=
 =?us-ascii?Q?VpbGa0LmTMZpuPajA/vDFb65V3sJA7Lzyg8kb6GRL9ogk0FAgYhIMX/UqNZF?=
 =?us-ascii?Q?WtHtW3gfwZn/iEDNHLtZhzEQPQ8nLoRMIGhUQ55jMm/hNCuLyt/Ame689usJ?=
 =?us-ascii?Q?14Op0VqhsuLipf4UOdlHXpARgM3nW2fIga7GI1FB6ZOmOlDU2akndCdLvxK9?=
 =?us-ascii?Q?/olAM9GE45985ZsMs8p0rfbU4bDfibw4mHX3GwJFAND+IHgXRcsR45DgPPpT?=
 =?us-ascii?Q?6/VDIhw8qxwqUrY1ywTKJPW+8BDWYMIDpo/BN3xjh5mI4Oay4Q6rwDzgXEsT?=
 =?us-ascii?Q?0YkTlb5cRnOsQgP4ANk4HDJCVpqYrrkuEBJCDC7IPPowF05pG8R0HCBxVv/X?=
 =?us-ascii?Q?NT6SXWCrycD+1lRa2GF3kYNbPfeURPE0iFMcgG1KgIKfnFyH2MoktRIPm/R6?=
 =?us-ascii?Q?D5ezWzp4XWSe28pvDtEGaVqNBbhnvHym8y8DrTIwViCJR8BlnZ5cQ2s13tyA?=
 =?us-ascii?Q?l7r46H0eeQayVTHPZt0l7Toz4l7nOf8JoseabVG75h1iC+l6Jw0OjiJkaMlM?=
 =?us-ascii?Q?wJ0RvghMgZc2qGMDE6i0ZMLCHknYk6Sw+NMIh22yB/GnmgnU34KpNZJu7ynO?=
 =?us-ascii?Q?rc7yPWGytUQZFHzacv9i6ZXv0fIQ4yEuGTuzIpECCPtTVKlB2jHtp9BMBpkD?=
 =?us-ascii?Q?JHNfEVZCK9X2bXLoMUogoNLzbSSdkPW1xN0fXxMIuELz0T/sNOf+nd0zpHLg?=
 =?us-ascii?Q?D3xI2ZuT/ik00rknil/Ho4b19QbY4yEEnZNKqBG1VNT85LblqGCsZl1nAWK5?=
 =?us-ascii?Q?c9YLPylge9Q9LxwXCjhWSA+7gkclhJnbZskN2UAEjVAyqkThUNK9GCtQsHOE?=
 =?us-ascii?Q?lXII0EVlYVyvkTxjN4/d+P5Y6nyKX2aKyCyYJuzKA4Sjdd90LPL1CPOkcahs?=
 =?us-ascii?Q?3WJJoJ5DZSqJoQBVPhQhdwXzxFQoMeoEdLrn5xvyET8G8ZJCVJIDQ8t0AYPX?=
 =?us-ascii?Q?WH1FCL3PT+c02CHMyoO8Okwz63bMUOsFs6tBmppRl0PBeQhp1SbKQ0nk2rSi?=
 =?us-ascii?Q?keVIb2Xh7yDpDNIVGHiHB7uk5K7+t8blNsSmqct96MkGYBYbpgXRXpWIDkbl?=
 =?us-ascii?Q?d2w/uy/QqpkIfYj3mSOphp2jdkB1J/Tgae9AHoWS+xHklg59vf1I14+b+wns?=
 =?us-ascii?Q?j9ZlfQdvATyiinmh4gc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1053064c-5cc7-4327-7b93-08d9d136d642
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 17:06:10.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYbmpdyGFota9hUPWkUDQ/udmdPirjV5yq1elHp3oD5jayzHraTtIiB5ynXnpIRz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 10:20:46AM +0800, Lu Baolu wrote:
> Expose an interface to replace the domain of an iommu group for frameworks
> like vfio which claims the ownership of the whole iommu group.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>  include/linux/iommu.h | 10 ++++++++++
>  drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 408a6d2b3034..66ebce3d1e11 100644
> +++ b/include/linux/iommu.h
> @@ -677,6 +677,9 @@ void iommu_device_unuse_dma_api(struct device *dev);
>  int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
>  void iommu_group_release_dma_owner(struct iommu_group *group);
>  bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> +int iommu_group_replace_domain(struct iommu_group *group,
> +			       struct iommu_domain *old,
> +			       struct iommu_domain *new);
>  
>  #else /* CONFIG_IOMMU_API */
>  
> @@ -1090,6 +1093,13 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>  {
>  	return false;
>  }
> +
> +static inline int
> +iommu_group_replace_domain(struct iommu_group *group, struct iommu_domain *old,
> +			   struct iommu_domain *new)
> +{
> +	return -ENODEV;
> +}
>  #endif /* CONFIG_IOMMU_API */
>  
>  /**
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 72a95dea688e..ab8ab95969f5 100644
> +++ b/drivers/iommu/iommu.c
> @@ -3431,3 +3431,40 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>  	return user;
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
> +
> +/**
> + * iommu_group_replace_domain() - Replace group's domain
> + * @group: The group.
> + * @old: The previous attached domain. NULL for none.
> + * @new: The new domain about to be attached.
> + *
> + * This is to support backward compatibility for vfio which manages the dma
> + * ownership in iommu_group level.

This should mention it can only be used with iommu_group_set_dma_owner()

> +	if (old)
> +		__iommu_detach_group(old, group);
> +
> +	if (new) {
> +		ret = __iommu_attach_group(new, group);
> +		if (ret && old)
> +			__iommu_attach_group(old, group);
> +	}

The sketchy error unwind here gives me some pause for sure. Maybe we
should define that on error this leaves the domain as NULL

Complicates vfio a tiny bit to cope with this failure but seems
cleaner than leaving it indeterminate.

Jason
