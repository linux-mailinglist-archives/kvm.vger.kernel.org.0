Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A641B193
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 16:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240916AbhI1OI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 10:08:56 -0400
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:48682
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240658AbhI1OIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 10:08:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbNlqdF37vnAjM9VVArjtE9lmZkfkKBmxNgAd6iC/nMQmt/HUtMzhDPxE/SXJ06Fu9yI9nVVEHYwwBYsyxeUZnV5SbLZ1090yPswYpM3J44y1fOjoJi2BghgfHH8dFpNa48eO2rF+s7k6Ugs7r63ubfeMO9cUn7dYByYGVvbTFVbqQ6NG9VwkWsfpubXvbazh0zm7wWWd1OHQuanj0CDIsJMfUHYYE0s96HZhs2QMd0pO7aB8VdlAyEmIfxtmFvPwgYVxaCiWi/3ca/T4+MylYjKWCcRWmQEMub0ZI1GqOFnkywZ5/jVlutklEch9XigAE34foyfGq6m4OY2BWPwwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/xUDRrP0vl1Cluw9TFrH3F2MPLeW2SWaQdkld1YTxww=;
 b=lrTRrT9IboCJyRQc8paNe+gdiwxAcJUVCTASG3hIlHz5GGnF2joXuzTTxq/mnn+dIJGBoEkC07RYODh0USzuqrgVlt4gONIrtaQSDu0MN2DW1r021q9nPuDje5SkomnlppjuG6EUcwcUSKAVdkYsILm3xGiJ0GsbxXHyBnSc2rCsWMxp+0TYThkiHiFxHSNcx/x6FI+mky9w5TLGO6XG4N2j/UuU2lrk9pgAdUkksnAV1jX45uKYiCpBt8aTIDvt6OcHrjcYIL0kPTwuoSv9V83h7rUpPwx6iODx0PCp2PuTvBBWiACryCGhNUUyNiJu4FlVUgDUdBaObKDG5z+u9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xUDRrP0vl1Cluw9TFrH3F2MPLeW2SWaQdkld1YTxww=;
 b=HMd4DnKytJF9w8RyCs53IWdNo08NcpADe3cUdgafKbYF5o3u/d/dIyWQTfPJ8xzIx6N7blpf5tJVK8c2wjtB8LD5wlglzg6wGtzijpRxkTN9w/WA8PAGt8TLZFZlLwb8GqHga0oNLfMNtsoxkLcfjzGSPRMy7AL2iQbqayZPzm7tLAOu3htZAwxdeqx4vg1XapOZsZ3tTA2sG+dLPrsOL3nbeGNtfk2D11H+koUFfvhRElSqy7Zdlx3eRlptEweBR04d7RoqtRXFx4GjAlrXAUBoJi7J/xkFXpO1qdtBLy/rAjiGIVjDuM1znfgLjDJ35ngnULI+/BoPrqC2xDVqTw==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Tue, 28 Sep 2021 14:07:14 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:07:14 +0000
Date:   Tue, 28 Sep 2021 11:07:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210928140712.GL964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
 <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
X-ClientProxiedBy: MN2PR12CA0015.namprd12.prod.outlook.com
 (2603:10b6:208:a8::28) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0015.namprd12.prod.outlook.com (2603:10b6:208:a8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 14:07:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVDlI-006zHe-CF; Tue, 28 Sep 2021 11:07:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70dadfc1-89b8-4b94-3a62-08d982894599
X-MS-TrafficTypeDiagnostic: DM4PR12MB5342:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB53424268FF0796B77A8EB46FC2A89@DM4PR12MB5342.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3qu2CEv2kntfuGkv+dun0yHg8MeOcMAdxjN1cwg5x3J626lgDlKrejK0yPPuQR/X7PQbOVHYxC26Cj6OxfHR7jzwffVP32TX+TT7WUf17azihBS0Aed54FFIwf6xpOzLMwTgYS58EC0GDJrn3I4V+jYF0D7LM7thOOBAdVJP67CqLrhmUY4nM3I8Tu2jJ7K0hAQeobHrHWbjPeXaNGo4H158BYkFI5vS/d3XPGvCby0wB5DhY7+NycydcEnQwJnWJxI4FwLbMRNXS/xYrofEAgWAgG5SvhjEJARLVdnE3r5/tb+/wLdGwdpYYwrKqHBO9rHLbQXLQzofNDIg9sMGe2fh/9nsOCfT/MSLmJZ1/ZdJ9swiPK1jovxK6L2Qgv4lx71Mf7UmuCGumqM00PLM4Ir10T854dVq4dd02dATNpJy8n56BpxG67j0uhrqchVeCDQ79UDe/PJTFiTXe5/r54IHjhZh7tSJhho+KgM7ItT1juAfHC//4QNcwaj5sZ+cfVHtGrviEM89KmbOfwKjqPQhLu6nXUk61Swapt9P6Ww9TknwB1oPeyksP5yFwdfkubYTKQwJXcLfTpYlToFHDgsXeOYtONYpbSRrCjW93/SB67jNWlQ2TLRdZzVWrozGKD346tWtUSLp/HN8H1nn1x2Ef1Ko0R5kKZhTOpVgaHcXm/9Pm19EY1wx0h8xyRkhOKsV0W1cB4Df2jVKS2WDaD5vN+TtaXQiOjX4WqD6bV/91R4hVdUoD6D78zMaCdKw+GRS6jgJvZw15VDnhk2kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(36756003)(66556008)(66476007)(26005)(2906002)(7416002)(66946007)(86362001)(83380400001)(966005)(508600001)(5660300002)(1076003)(38100700002)(8676002)(9746002)(6916009)(9786002)(33656002)(107886003)(54906003)(4326008)(426003)(8936002)(316002)(2616005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kayAifRObtxiaoI6hmG/wPYclvAc8R5M/sylqShrgleNHDWmOHj4FUOKKP8k?=
 =?us-ascii?Q?wDNQxfzB/49p0+D41JNrqJ7kOA/mwX855wrEbzBx2waIFPyrHKWFr9j7Eq0U?=
 =?us-ascii?Q?IYkfU+7WOkDo6W2/J7WnE1K8HFbyNndjHFk871K2b8Q6UPxDewDIt4MpPiGu?=
 =?us-ascii?Q?CJ03l9d9WXi7GozO/MWXf4Bxc3klcRUbF9HDdY8Sh2ObfIukN9PofcWbMvpj?=
 =?us-ascii?Q?X8xiOfFCUyb4FM9iyBQcBHN6nc9PFR5v7bqTXyy7MPNYpoqGxzgk0FC/wNEh?=
 =?us-ascii?Q?PUkN0JesSQ+bEdJXreaCiiBEgpB/StHX16g1EfLbtBhio8JVIo7vBJhcTQJL?=
 =?us-ascii?Q?AmuRFN+ZQAzpMNLhVxTYTarAwjfnZUtU9JBGoQeOZJQL2QjTPOPGLcQmdhgD?=
 =?us-ascii?Q?3FWjQY9m4TueUtweFquqBlEsJidxcnNmJnfH6pG9RpYfuQs8T5adKSpYVPQp?=
 =?us-ascii?Q?Ml4TnuB4EhOcPURa5OGbCTwqlQ966hYVXH9DZTyCmeslgtxSN4wR1SZH0jsQ?=
 =?us-ascii?Q?r1YuyXjFBb+DxD4Y8/FufEmyx0l61zoNuRJHwlv1P5OCZf+MROpdKNQWtwqh?=
 =?us-ascii?Q?4DywKiVjy/lNPO/xNWw/klMxwtj30sOdaFjyHvP+7WNK0v5Fw5ssl0qbBTvC?=
 =?us-ascii?Q?ny1QJiuTg8JsYvJq9kIotFd92JJ73S9rKSmtCoHYs3eMZ0d5jbd/Nv1CnerA?=
 =?us-ascii?Q?kM1YUxudTN2cM/Af9FaT94H0zaHjJRgYApkL8BGsleHuVCxNIN4XpKRmYGh8?=
 =?us-ascii?Q?9sZGO0OCe958k9GmUMEdssLGJy+Qy6n+6TfEltKxFjsgv8ZLX9YKLKdFmbaQ?=
 =?us-ascii?Q?9kLQx8P2UYHhVk45lK6NwWZDQkCEQM8vROWeBMntqZid9qEEPnmjLQXcXPoT?=
 =?us-ascii?Q?FVSeaAAG0gPsc9ENwlj+vAbwzURdLXB124h9/SP6nLd6e0+2Z432IByhMx0U?=
 =?us-ascii?Q?FjKnDi2mNWUGIgZpYk9xH5Of2al+xP8G/8R7C8nQhnSzfoJOcV3Tu3aNtH+h?=
 =?us-ascii?Q?nUAMdfOgI0tmd31TgWlGWyTQ+7l7SBdh0sx8S2SxgOggoAn0GqVNcyLomy44?=
 =?us-ascii?Q?F5v+IB8dvUzevYpSbWcvEqjtB+HnX7MfTmoX+hIB20M9xza1iPw6Z4ndyeRB?=
 =?us-ascii?Q?Mfb1v/IeohY6HKcS/CQzSr2eD4+r+Y4lJVJpLlq6MYyoPPaWR4Yd1i/4C68q?=
 =?us-ascii?Q?uquDhzgr0IB8CzRYRBsrqGYDFBboAYc0RXP8i1ffo5UQbcaNHIH8pxXPav6D?=
 =?us-ascii?Q?7JGwEYXxQVuqu93JXBMGjAb01jtiMTdaZCV9wxiuJA+uFfv8oRGwhk42CPAX?=
 =?us-ascii?Q?/iRgPvku+NjNf9imnOR40dfB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70dadfc1-89b8-4b94-3a62-08d982894599
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:07:14.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sr/0q+2sGf/OGKshFMlDE8vRk7cBNRZuKhBMN/J5Gk79/Ev5AVVzrsUoJOCvOSwt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 09:35:05PM +0800, Lu Baolu wrote:
> Another issue is, when putting a device into user-dma mode, all devices
> belonging to the same iommu group shouldn't be bound with a kernel-dma
> driver. Kevin's prototype checks this by READ_ONCE(dev->driver). This is
> not lock safe as discussed below,
> 
> https://lore.kernel.org/linux-iommu/20210927130935.GZ964074@nvidia.com/
> 
> Any guidance on this?

Something like this?


int iommu_set_device_dma_owner(struct device *dev, enum device_dma_owner mode,
			       struct file *user_owner)
{
	struct iommu_group *group = group_from_dev(dev);

	spin_lock(&iommu_group->dma_owner_lock);
	switch (mode) {
		case DMA_OWNER_KERNEL:
			if (iommu_group->dma_users[DMA_OWNER_USERSPACE])
				return -EBUSY;
			break;
		case DMA_OWNER_SHARED:
			break;
		case DMA_OWNER_USERSPACE:
			if (iommu_group->dma_users[DMA_OWNER_KERNEL])
				return -EBUSY;
			if (iommu_group->dma_owner_file != user_owner) {
				if (iommu_group->dma_users[DMA_OWNER_USERSPACE])
					return -EPERM;
				get_file(user_owner);
				iommu_group->dma_owner_file = user_owner;
			}
			break;
		default:
			spin_unlock(&iommu_group->dma_owner_lock);
			return -EINVAL;
	}
	iommu_group->dma_users[mode]++;
	spin_unlock(&iommu_group->dma_owner_lock);
	return 0;
}

int iommu_release_device_dma_owner(struct device *dev,
				   enum device_dma_owner mode)
{
	struct iommu_group *group = group_from_dev(dev);

	spin_lock(&iommu_group->dma_owner_lock);
	if (WARN_ON(!iommu_group->dma_users[mode]))
		goto err_unlock;
	if (!iommu_group->dma_users[mode]--) {
		if (mode == DMA_OWNER_USERSPACE) {
			fput(iommu_group->dma_owner_file);
			iommu_group->dma_owner_file = NULL;
		}
	}
err_unlock:
	spin_unlock(&iommu_group->dma_owner_lock);
}


Where, the driver core does before probe:

   iommu_set_device_dma_owner(dev, DMA_OWNER_KERNEL, NULL)

pci_stub/etc does in their probe func:

   iommu_set_device_dma_owner(dev, DMA_OWNER_SHARED, NULL)

And vfio/iommfd does when a struct vfio_device FD is attached:

   iommu_set_device_dma_owner(dev, DMA_OWNER_USERSPACE, group_file/iommu_file)

Jason
