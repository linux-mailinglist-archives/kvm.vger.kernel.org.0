Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A032841C507
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbhI2M7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:59:03 -0400
Received: from mail-bn1nam07on2070.outbound.protection.outlook.com ([40.107.212.70]:13715
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343889AbhI2M7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:59:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6ecOLbpVQxNG953LprbWIzKC0MD7EpCd//fzzqipZSibJOk8STNcMU8ZxClK4/hQhdELzxwIva0c7OQrfn4d7B0uolo3D3MJBJxXKG7/VG2EObWvJDozqiMmFdOfIm91GS6t5UegCidME7GYow0ri4Wb9jnw7X+vaniPj/QBnHUrGNRbR4fpADrq8/dbky6ve+fO2OhrooQ39wxdcVyDvRts6/E0ooX5IIcGdQ5Bv9Nqu5tmBtnp75opyAqZ+crLVb2pWXZLdXvKlKtJ7YgBxHZSod2pFpE29lqUbl+1Gx+pEeEkkKF4mMMEFAMGGTWf3W81FOwSZzSu0T4FOmHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rX4TXLuXw+yooRObJYd3j/ZDqBlPx8Mm2momtaQlArg=;
 b=CCSuq1Qe/w0ObvTbf5mk9KArMv0jC9GyZNYZcPI2TuXn4DsX3n26W9+3a48SL8zRx/EIH2J5OawaDyX1uxUjY+nW9/TTezXa261rpaw7iTE09xStnYvXXGNGQ9pNRrNlSQDNS4u0Fvej46wnu/N1xWemSMKgCJ+OJMw/tAgUra4JqpO9RGc4d8sVgdujabr5+P1iyPRs5vQPwuFXJf9SNIWoDBZtlmmL2XJRbRa9U4SyLNtHPEcStVnVUTtNXm+Re649G/KnM735rKQ/1GFDE6vciFUuoeTKbrwTxFrbwmDXP4p+TWRwrSiwobHU9kcQTg1jExjl3bssXhPTnlFNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rX4TXLuXw+yooRObJYd3j/ZDqBlPx8Mm2momtaQlArg=;
 b=glyV6sDpZz/r1dG8OoKWsXcdLsm8eYwyOqn1xH20I/M2KbEu2InzsPc51FzFV9GzRcH9DaNIdOA1B/WRuvFZ9ZHlwyZwV5QUFI+B/+G3ARSWRFb5COE6kBVX9rB7In7hgxhukSDH71iYlOb/PB9L9Tuin4qy49qc9BE+3RcYlMiUqvkoMcyjc4cnwD4BXis9Py1Mu3j9k9tUO9dfF5wPnDI2GJrkrqM1zs/g0JHkSnB5mPp3/sVJPkC6vaq/lEJWtuA5FLsFyZRpas5NYRbv+BKjmBWZz1suXqGvzF1ZxSEWHNWhmOYfmEOtAq4fEkznw6dge9Rb7VZSuwqo6uLySA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 12:57:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 12:57:18 +0000
Date:   Wed, 29 Sep 2021 09:57:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
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
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210929125716.GT964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVQJJ/ZlRoJbAt0+@yekko>
X-ClientProxiedBy: MN2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:208:178::39) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:208:178::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 29 Sep 2021 12:57:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVZ9A-007ZCy-OA; Wed, 29 Sep 2021 09:57:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 868303c5-d073-4098-7a6c-08d98348aaf0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5255298DC340C74AB14BC4F6C2A99@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCZ2VoPELQ1P85VMnTG1y0dPXyK4J8zYZrLaytBrUmpdi0QRjcloICxXG4ktUKduFH7g4MGWzh4XKLa/ipBZ+GyTCeI25QLSPDrDfDMJZEQZpfRGCJYPPWKMmjs44qxXniKU+60JM5+I64IXyTl4P40a3UU9Gc6xhzWKoatjbOrmRB7AKIvjIjMuWQuRuD0jmSAf8hdmZ98oaE1F6hqxuUne3Q9eLLvZwEy2MrbcLpvK9mO3aXIefHhTnb2IfTZx782IL5RAnGRgDxXScTDO4/jyFvoINbQqByYBD6L6qetDRS6MoW/o0AKUH1KM6mot7Bht7B+98BEIbujwGxnRcHOKpmT2FulukUNG65NembyQiD1/n82eudlVAtORT/lUOWtFHkJWqWf8AuAoImL1Wb7YnryiZuup+JwqX0z6tbZUUjoPgMIubN2ROrU9ErwJf2ZoBftN0cWVdRssU0/Sjd0X1BldiWUya5m9K85y16+/PI3HmtiSDueK/fZOTZbSWXewL+rGXvp+HB/GMCHgHoGGYSS9xMMYjViP/JvuEUiSBYgXkpTXaf1DB6uU2vI0Z8l0eIxXZv5xVkwFeY45sObuOKQ6mljatW0Jq2S+wiZ81l7aiXloHJJRPB8ljFrrnAeb4kUB9oELu56dRZH0g52/zWvmz/k3WvsPlEaCdsFvHHyTiX7Dzn9jUlb+4IzHB+BTYvCXoK0055S/XaUx4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(5660300002)(8936002)(6916009)(2906002)(36756003)(186003)(4326008)(2616005)(26005)(86362001)(8676002)(7416002)(33656002)(426003)(83380400001)(66946007)(9746002)(107886003)(38100700002)(316002)(9786002)(66476007)(508600001)(54906003)(66556008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?glY2xia3sWO87yJJrCvWO/cehJo7qOkowrkSO+QyJGkCvbawRpfZbdrPGzdt?=
 =?us-ascii?Q?k7f/nCiNC0Hd0fLr3RgJQuY89MSf1quIm6af1mQTyjNDg7Z+d+38ketR28CT?=
 =?us-ascii?Q?EAYXJFIZy9vX7ipZaZyo8k63lcQHgn1mPYW/GsTllYwoRJ2YUxh6//rXF2Dh?=
 =?us-ascii?Q?d3si4rJ4zHiX4p6EvTHuOfv+knP+JW5VkX1gHTLcBFd7rsb4hua2a594Drfi?=
 =?us-ascii?Q?aLf2kbt3abKGdM0jUEuhJyKQ5154Pn17SWG05JuHUxAXxxLW5yIatdUHkXZa?=
 =?us-ascii?Q?0xECt2bQUdrK7YKzacsRKN7CPfa3PJUvq6iFwWOOtIjw1YtSkP0HGc2gd+oZ?=
 =?us-ascii?Q?d03DqISVCWQZ4FI6tGO3lKdNxaEy+x5EE9YBA7uSfIRxXZl4jYYTeZrbSzY8?=
 =?us-ascii?Q?38oIkc+SwZrXw4bnFXuLJczQnOGrBA+2imIQ7FTGuQKDj7aIIpY0jYDKKlUy?=
 =?us-ascii?Q?G1E//XIIAMGi3NKcR1P69di9a+XIxaYKansPhM9ZHQabhDLjESwGVh6uNyaI?=
 =?us-ascii?Q?SC/fh3HOIGjuVyTH8MIMl/u0eLl//RraMUhD6zI2+Gn1kc8t7g7Ke+gaxMMf?=
 =?us-ascii?Q?HzVEYTmkbKAu2ySYymwsCl7t6pcwKDt0d6OnXFmmvDdG0OgEapqbPr2QaXw4?=
 =?us-ascii?Q?Qrs2ngocD0LdTGQ1dj/L2srdY2qG6+7JnE01zoalUmuUxVYwAM8HI964byrb?=
 =?us-ascii?Q?kv6N6+Tvs/nso0SyD4RKFLhVAjL5cpkYvuG+bA0R7/uoRFswp3Ax9ykPsQbZ?=
 =?us-ascii?Q?ddcdPwRBNMwC7DrTWiwqm6cX9hba90o/8HvlHKdCDoM3QO8Ahs8m7TBMqi2f?=
 =?us-ascii?Q?FEwtV4eUl32BoPFiN2xNM3NuOETZQE0ElrMM1gaYwig/Cc0ii/nea0pShnXY?=
 =?us-ascii?Q?zvUwDAiPDvVFQHfwJUMk/9w5dAEqnStl5fuOkVjBOx/KEDktsaeLXT7byeHK?=
 =?us-ascii?Q?Y6ACG9tS4PrB00IdSqj6ZJZOouai5jZhAcsqw8PYXGIbeR9WqlQfsFQnhnen?=
 =?us-ascii?Q?K1lgpspzn4n6bxWzHSAn7S3DSkImrldJJwhFf5NwWYkpHEvK0pRO/1CgUxHL?=
 =?us-ascii?Q?TR6iqxwgxAb7RkFBN0PmkkyjunRbXi7n25uGsHStMTvfyeMJ6aaimZVR+P7Z?=
 =?us-ascii?Q?maPXh+cI12PtkEuDHdDIOQoCZyvY0aJTuc3IV3KMIlNJ9ILbpdVckLXYQZZg?=
 =?us-ascii?Q?4gCH8tlnMQqtntfBvFsG6gDlWS4ikMCGfMkY9F0pY86kg/Zp1BWuRJ1/B5P2?=
 =?us-ascii?Q?BDg27mWj49w2NpS+g6jd3kp/M4ScfosbGnyTI5BzuH8w3Q9gaxNTF6IhdxvE?=
 =?us-ascii?Q?Qnz7XNmrLxyrRgoK5IhE8RH8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 868303c5-d073-4098-7a6c-08d98348aaf0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 12:57:18.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zak4DiiFYnlhHCRWjV72TgzLGk8D0j0ABc8kRYY7PCrt3k5ZpAuh8riLZr80HkOG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 04:35:19PM +1000, David Gibson wrote:

> Yes, exactly.  And with a group interface it's obvious it has to
> understand it.  With the non-group interface, you can get to this
> stage in ignorance of groups.  It will even work as long as you are
> lucky enough only to try with singleton-group devices.  Then you try
> it with two devices in the one group and doing (3) on device A will
> implicitly change the DMA environment of device B.

The security model here says this is fine.

This idea to put the iommu code in charge of security is quite clean,
as I said in the other mail drivers attached to 'struct devices *'
tell the iommu layer what they are are doing:

   iommu_set_device_dma_owner(dev, DMA_OWNER_KERNEL, NULL)
   iommu_set_device_dma_owner(dev, DMA_OWNER_SHARED, NULL)
   iommu_set_device_dma_owner(dev, DMA_OWNER_USERSPACE, group_file/iommu_file)

And it decides if it is allowed.

If device A is allowed to go to userspace then security wise it is
deemed fine that B is impacted. That is what we have defined already
today.

This proposal does not free userpace from having to understand this!
The iommu_group sysfs is still there and still must be understood.

The *admin* the one responsible to understand the groups, not the
applications. The admin has no idea what a group FD is - they should
be looking at the sysfs and seeing the iommu_group directories.

Jason
