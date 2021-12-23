Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C50247E44D
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348737AbhLWODF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 09:03:05 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:6465
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243728AbhLWODE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 09:03:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeeKonCrB91d0kZS3BMC+4JpncN3QgMPHgff0Iw6mAdit/ITKBW8hv83Yw42yefdEbz1x35rSGkIEkChEW5jH1ZvvGqA8bu5xeyU/0HUmaiujJgMDXQtRGZXIZPoAk0Ridk/WuMxSGKER4lnLturdzPB4w4o3JlNS2lQ4NpXxS6d99jZSI9fPVrfy9vk4XVPumE8AZsPIS2hKSw5T6zDPB7/lk1GcU9vqDjFlQ6OWJb+DlnEocASnqmZntE2PGFG4zvVH2H9bZHVnm1exsayAm8XvN9pHMoLbNuZpT9aG88JBScOMu9kMrUX9kYRZvwn9bOH9n7RwKUVPq61BnwfhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncrc9DKuzH7smImnKaJYgEnMaj6Pylz0JXufSOJel1E=;
 b=Ytc0tM8pQpI0wCoGqzTu1rfmfUhhw7ZVzNAQDYLEaaaUDzcffRYI0aJbT7tw101TgLVCsUPolAcAaKYbXkYoDHFhvhVaj1SGfyifxWKzdxvL0YO6Y3QjSekisDMkbWyskxWTFgEaFnA+9CDCV5VBHz4PJveFg7bfhnRipxFPOBGAp13oVPmsnNE8FFEXEsgxHpwLGQSNGE0mS9B6roMQL+4vv2/MWQ5AJuSFP1tQ7G+SXrd/PsYKEkeoNguVEm8139gPmaeGu2TeznM9QzYQADMDGB9hEJjyc7E0K7drB6X72FztGVhExxNu+ytit8FOlbwbmNfHXON8yXHeQFh9Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncrc9DKuzH7smImnKaJYgEnMaj6Pylz0JXufSOJel1E=;
 b=JThMjNrIQ3ANJsYa9Oze09ZK/bpQ1k/AxALORG0HuGB0nBKUkiZ4Rcl/WgCL3oWNcXOsYsni6q3Z3qh4UZTfdzErp9DliyIJH/GU9EACm9Tj6Sjsi+tbxu+d0qDzs/VdiPh4x7VoT4hKMHnPgMO8EO85h114aQUe40EmlHonjiiEFi1wUdwkHRY1b93eVAZjRuNPKivN2M5LM+wWZT07onchAn56BD1MdyXZj9+Du3ablWIAypvhEAm2CiXv/+jq4l23sdIXG8XISjmWMNAdHkaWkptWTz60va7LUFr2YjAu3ddDsWNZF3edk3fBnPk8yiz9RdkBaOKsP5LSayJ2RA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 14:03:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 14:03:01 +0000
Date:   Thu, 23 Dec 2021 10:03:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
Message-ID: <20211223140300.GC1779224@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
 <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67026b30-c8b4-4e1e-e508-08d9c61ceeb0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5063F8B3DFABF4D2EE527D91C27E9@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8If+2Mpz6QYd/d6yX00tpAzo2WTuRWtmG0BmW7AkU0KV6uJ/p7CUKgAdS8Q1ugV459ZIgnw5Ytym8QBYOR/aMQZVoevEbh7xL5HNM04R0Gw4WpKB8HEgrmchJqMcIEyXCNCkw6fWUC05qBrYsguEnCRWoohGy3mYo9qw3AeORrAiGown59i3w60UgEpolft/088cJwqi/qxZlALFbDqMMNOd2wc0IcT6sm1BVK38pVr2V+nwuRn2pjvvRlyt7Tcixc6gsf9zxVqtqirPWb3RN2h6LeTrXMSsPjXj3nOuqJ2SX72sqD0z+p2X5myYlIBB+tq/TMCVHkVe71CW0q31riRO0vkntKPkyhOyk81yGdHp+2Ar02L+9lRSBWAPMHCKGXXNNeKxeUgTb4kYgUlfdQNz1PTIblY8ilJ6l2AcsPnwwIaFZwn/yU6UL/XeG9jXb0uH0f2oPxQeehPMOgBHidulABZ6I+Liw4uviTMqfVoXAril3hEKUN5cQq3yognpXIwnfAVziMVhGlZXjNYxrTP3QT+e9nTnaaCOxpdNlR5uqXqiNFMcdPTcuggBqcKcVl0RuCPrVRu6ypsdH6tads/ohXhHxgstkTvUUBK/N07BPgvitC8IhV/3WQJaejvNfT7FSrXH4diQ7F7T5OwNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(83380400001)(66556008)(6486002)(66946007)(86362001)(2616005)(6916009)(7416002)(26005)(66476007)(2906002)(186003)(1076003)(8676002)(8936002)(33656002)(54906003)(38100700002)(36756003)(4326008)(5660300002)(6512007)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZkNu4U0sTy68P/Id7TxbzgUxJvoTQs3i8I8EAUL19xjAlq/x6vzzPA8oUvcY?=
 =?us-ascii?Q?8/ttlgI6n+L/UiVQbVpNEtTuUwJupSnjItspNtKuH9D/s18T1k+darKlv+vr?=
 =?us-ascii?Q?cBLsYg1795HF55/yYIejY8+hAgpzyQf5b/iRUtEKcKBi4qdNQscwP3gOHs//?=
 =?us-ascii?Q?lMqiGpwgQpJyE7AtlNJa670+yExU48PachrjB714cvd2iIaISAh3Kc+TytqB?=
 =?us-ascii?Q?9GBt2xsGTbjhDPaH2ijBK+7CbfGrRuXcOtAktP1lqLWDHfLNbYdh6Le6cAZX?=
 =?us-ascii?Q?tFJ80TnEJfJdfbeBnWhAeqyEjT6gv2eVvPzO/2QzTORbHS8uklS8IOIb4zZQ?=
 =?us-ascii?Q?Gu6Y7aX2mq5UjU7+/Z0FAN7MoIgmJJkWQ0Cj6i3+gdSHZ6KPoqkfVV4WgWU9?=
 =?us-ascii?Q?DJi7awVdAjmxp7qw3AS9IvSPWveSMhF66cyRoZxMSFULmIxtMrNXMVSAkmtk?=
 =?us-ascii?Q?6i8MbRMJrOvGZ1vWkNhB1Y6lU30ioxafcvOtbM90uroiezFmtj0WOOSpeZwx?=
 =?us-ascii?Q?W412zrWXRsaaH6w2Hohw8QCiRCd+N+7ztAaYmc9fZ7XRnKWTLsRvsoe+7j9t?=
 =?us-ascii?Q?M6S7XTvj+Rug7m+t9TAl6uzp7MKHm3R4s5B2Oy6HRjP8LubFs68rMRUPOv3k?=
 =?us-ascii?Q?HMaVmv9f+2SvD/NT/26mQ/XvbsXg9eif46zbo4hHjP1uVd1Ba9pXeHKfP4zc?=
 =?us-ascii?Q?1bH3E90adon5c7gHBBJAlBrwrT3aLFMwYp5ulqB/2G0a7GvASQMn/iaZfMHr?=
 =?us-ascii?Q?E1rHzQ60P79RktMvm0hvCwOqrjExh4YeIf5GZEKTeBuxxO0GQcr5336JDXd2?=
 =?us-ascii?Q?71venvIiJzy0ISrcrZVNZ9AEeWFwMRuSE3WBb34BAyav8DgfGCHkapWy8nNJ?=
 =?us-ascii?Q?bewg1OzQHUmHy6E0PxWjTOjrMJSbWkDGF/dYoRT9KmXfqiOHfC9cJkKJKqXK?=
 =?us-ascii?Q?m+BBhpBYjxRQlbaKyQ8r2PRC6KXEF4JOLJ27jZjTcF18E2orhn4f6vIB0YXX?=
 =?us-ascii?Q?7TzkJMQbrc5qRHJJ6ugJhfin0c3DIjSNXvl18pZk+O7xDi3qDXefXUCqHMd5?=
 =?us-ascii?Q?xsNddSWcWMZmed7d5uBnka2+HxcDHE1vvs3CqXew2UffVn3CH9aeTsyGko3N?=
 =?us-ascii?Q?5/2kLP5wddogwUXWWPg/h1vhZZuQQJ6RKp+WFZKyunE4ZUYbcdJwg6n0k58p?=
 =?us-ascii?Q?WRiU6Nq3o4Mz5rvY3ucp14qW+EoovRg51uQWYmhVuWVPaJjnlOiZgY+Pl+fB?=
 =?us-ascii?Q?2nzZby/3LRRzTXMo3P9MzXFRKuVTQMaGG/8mkllJmtzfCGRZ44v4JfynasII?=
 =?us-ascii?Q?EVpst8jnRCFSgb2wGiPXX4lvFmn4mmjV9kcMh0Gt/HoPldwDRs4kHsYnxxnS?=
 =?us-ascii?Q?ZuThwDclWqLK+rbyJ44rTtCicDV5ut691HDITntRfOnUkJXq/bhFfTwlQC/f?=
 =?us-ascii?Q?UE7K4WjNTSDUUjmRSw/BC7vxfG/qpw8Da0DPQz+i5uWPKLkOZ/r2iepLBE3g?=
 =?us-ascii?Q?ANRC2b4fpAnFL+B81OtzV5sUYH5IVG1HHJXfLJ+xcNSwzS/nOlW7ngxZ82/a?=
 =?us-ascii?Q?6pEJhdSucLLDvdP1/Vc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67026b30-c8b4-4e1e-e508-08d9c61ceeb0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 14:03:01.7308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQ5ZA/jT+Fw+VcSdZO+goXM+eCCerwR/E6l3JE977WZTEDyhFHJsu8R6hsYOnLuv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 01:53:24PM +0800, Lu Baolu wrote:

> > This series is going in the direction of eliminating
> > iommu_attach_group() as part of the driver
> > interface. iommu_attach_group() is repurposed to only be useful for
> > VFIO.
> 
> We can also remove iommu_attach_group() in VFIO because it is
> essentially equivalent to
> 
> 	iommu_group_for_each_dev(group, iommu_attach_device(dev))

Trying to do this would be subtly buggy, remeber the group list is
dynamic so when it is time to detatch this won't reliably balance.

It is the same problem with randomly picking a device inside the group
as the groups 'handle'. There is no guarentee that will work. Only
devices from a driver should be used with the device API.

> > As for why does DMA_OWNER_PRIVATE_DOMAIN_USER exist? VFIO doesn't have
> > an iommu_domain at this point but it still needs the iommu core to
> > detatch the default domain. This is what the _USER does.
> 
> There is also a contract that after the USER ownership is claimed the
> device could be accessed by userspace through the MMIO registers. So,
> a device could be accessible by userspace before a user-space I/O
> address is attached.

If we had an IOMMU domain we could solve this by just assigning the
correct domain. The core issue that motivates USER is the lack of an
iommu_domain.


> > I think it would be clear why iommu_group_set_dma_owner(), which
> > actually does detatch, is not the same thing as iommu_attach_device().
> 
> iommu_device_set_dma_owner() will eventually call
> iommu_group_set_dma_owner(). I didn't get why
> iommu_group_set_dma_owner() is special and need to keep.

Not quite, they would not call each other, they have different
implementations:

int iommu_device_use_dma_api(struct device *device)
{
	struct iommu_group *group = device->iommu_group;

	if (!group)
		return 0;

	mutex_lock(&group->mutex);
	if (group->owner_cnt != 0 ||
	    group->domain != group->default_domain) {
		mutex_unlock(&group->mutex);
		return -EBUSY;
	}
	group->owner_cnt = 1;
	group->owner = NULL;
	mutex_unlock(&group->mutex);
	return 0;
}

int iommu_group_set_dma_owner(struct iommu_group *group, struct file *owner)
{
	mutex_lock(&group->mutex);
	if (group->owner_cnt != 0) {
		if (group->owner != owner)
			goto err_unlock;
		group->owner_cnt++;
		mutex_unlock(&group->mutex);
		return 0;
	}
	if (group->domain && group->domain != group->default_domain)
		goto err_unlock;

	__iommu_detach_group(group->domain, group);
	group->owner_cnt = 1;
	group->owner = owner;
	mutex_unlock(&group->mutex);
	return 0;

err_unlock;
	mutex_unlock(&group->mutex);
	return -EBUSY;
}

It is the same as how we ended up putting the refcounting logic
directly into the iommu_attach_device().

See, we get rid of the enum as a multiplexor parameter, each API does
only wnat it needs, they don't call each other.

We don't need _USER anymore because iommu_group_set_dma_owner() always
does detatch, and iommu_replace_group_domain() avoids ever reassigning
default_domain. The sepecial USER behavior falls out automatically.

Jason
