Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6193C7491
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhGMQfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:35:43 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:46172
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhGMQfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUSJKpoi/oP1qfWi8jNlThMjEQ3W52wXq8BM9VsDiGTNrKJOsdU/ePW2i/UITJ02th9bMu0WYWuDOhNt7bg19lS6yTZBGWkY/hjvSNMvTMMYOJhfCzaA3Kpo+ELeTPXf/hMTRgAv8YJH1lJkMncWxb71fzvw+MQHHUHIJNCIHGTYxWM2Ladq5NgQZcidonWQWzhkyshpsGNVrplfciEYpyztaT6t3pQPyNmYktFCWKPcc/omXc6zlF7fueu/YeXoRwt4u2l/SyZL9mgnkEtw75qYlmuaeMg+8lF1bTIbCiALZFS0fbo8pFS89u73rKB85audpc7X9V8Af9EyvF7sfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YkBvhxGlJbPl2VRciGfAaLYc66yVgfb2dtSmUKg+4g=;
 b=SbM9R8ydVcjgyYY3q19+yx4N6Ywh/ELvO6iLq2uGhRPqBaUHhBg4yYOfw0PBPTUKGAQjcUXyqq0r1IUtNh2TcCTa1dZefmzuGigArDZCw2VrrlGmukSxyWi6YFTGZyDKpeIAl0a0LdtVU2UYe4avopngcMqmYe/bUfliJmi/l4cX3D9x4GuqIhuzuYbZrnz/Nca+CLjlnLmgsf0Htcy+N+SLfOlW3Ke6N8I4EBjlXzivr5K3s4G2GhUouDIt2Raa0NDWNI78JMjbWawrisqdVqTNb80txjrFe+dEDzDnJQuhE1vrmtBP/hFvRAW36ipQF9H8bITBAcF4bCwnMGWrmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YkBvhxGlJbPl2VRciGfAaLYc66yVgfb2dtSmUKg+4g=;
 b=DPLwGJBHrmt1PaSY1FpXoxJUeMYx+ECgiPhyDRk3I1or/5jzmiLWV856NsbphFYNsKz8RHZBTNDYXvcw2kNZUR3rDF3ds7rJnrr70hcXJsn8UY2Xr+ilOEHB4qbCKbmr49pVq/wnDcpXVVZXuxpTv7HCwZTNHteumcANmoLb9ZPiJb/yCZDVa634aSx2pGT5NoH02238Ce/iRzOzD9ToMr9gwQLw/PQ8zsUra5r5JdwKP4syYbAsNL6uOC9IUilehOJhfF0MS7TbxPy9+W/u/o1OPiBiqcGi1QaNhs6PGHRHDHEGlrSNfkVi4v/UzSrlG248O6HnQlepWCQKUL22uA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 16:32:51 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 16:32:51 +0000
Date:   Tue, 13 Jul 2021 13:32:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210713163249.GE136586@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713102607.3a886fee.alex.williamson@redhat.com>
X-ClientProxiedBy: YTBPR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0009.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 16:32:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m3LKz-001Sd0-AN; Tue, 13 Jul 2021 13:32:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a50fd77-ca1e-4051-4d46-08d9461bdb9a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52546CB269D8994151BEB58CC2149@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuFyiLNu38Sfb32NIsr1923YM7EuOkbWzP5ejctilpdMi2rGtDZ1u6q9US4wYuR4h20m+mkwDlXjUAvscnYqPCwa5E7wPnEXqWYqvqBEzLI5rBb/ICBEAEokMmwCz7h9ND6rXmOWmas7kivDAzwH9z0hzOMKZwL4UaZKW8s/6dmaASg0QZjSp+rLTWhBr64goZOL6C4LjRSWrTV2OXvXKSorO5+QujksndhiMPhPRLh0DVy5oE4IHx1xnInfQhf7It26LqJm9vSzpDSS+WhhlmQyZPwufbqi5My67aCGQMkav9PU7E4iBajL1Zvn/z7re1SrNQiHkcqpq4wS1xRG0FqVROqhZW40zPR32O8mptcIzn10bUya68Zr6WC+D6XK2esSipTR8WCAG0C9j5hXoT1LVG3FZzztNEtrcED0Qqg/QvX7ME0HJx7fWbFtoq5fmtr8fGIWTRz9OGBmYXbqvyvT7imZP49HY1HuGm93la7+FIfRTYmFT0nwnNeVKAh4lcDc7qmnqhdgNMadLipTzLyiiMutpjARa6L1A/FkLSCAT0bsGhMBV9dAGQpF8DHuuBQLfrmwJHS3bKm7LqicLGpo0Vbil+ooe+Awdpn1X3HXQyOJweEU2+Yh3W1t071xGt3FG9KDHI7LAbUCoG/JURAhfaQuvNNmLkxb909MwxutdjxH3qsygc26AI6wS5SNRvjOwRoJ4xNj9NsAQNgAsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(36756003)(26005)(86362001)(4326008)(33656002)(186003)(5660300002)(66476007)(6916009)(8676002)(9786002)(54906003)(7416002)(478600001)(316002)(9746002)(8936002)(2616005)(38100700002)(66556008)(66946007)(426003)(83380400001)(1076003)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wBE9QEKNDFuIMMIEPFyMrCO4ETPSbvkdts0acPeRuMMXlvOkvPjF4KC9mMbw?=
 =?us-ascii?Q?LVk295kbEjXtk4nkUx+lIOjX/Qg1cWgcbV/MvU0WoX/FaLeBtKgYdDEEKIvm?=
 =?us-ascii?Q?ZXO9bgktY+DJ3IVQkVnsTvGUTODR36MVu1bO7kCbeObInTfaKE3Q27wk1Nzm?=
 =?us-ascii?Q?bDkVcoVPjF4+APwvYikMxWvsQzL2RQXy4T//YmcAYR+LE/ogk2xGL95Jym2+?=
 =?us-ascii?Q?4bEBX5VWhAG3d/dKRm+ZA5WiroEZ2pgMDk5ga4gLLTCGemWe1IVsCX6/fsvS?=
 =?us-ascii?Q?wBciA6YeO++vrW2Kuvwgm62Gs/gyODZTDUCQuWzgDtmNdgVtYqGXi9UkxmlT?=
 =?us-ascii?Q?JrvBMRm3OB1bIHn6NAdKUyjZMZjInWZQhvisb63S2srPI1tvOk4g+5GeMhwS?=
 =?us-ascii?Q?avQ7gsBgMJOBEROIDaMzbR1j+KcDHtr00iGokXX2vVBSJb/8hnFZ1M70x1Bb?=
 =?us-ascii?Q?Vk20uPlvWNyZoLJfcFSyO17BZk/2oGy7Ceoi1tH/i/7Ena0gfvOMZ3rUlYPH?=
 =?us-ascii?Q?pUv+wsRw0RVq5BrmCDJNtURKFNuKyl3HAqnTJsQK/ZvtjSSPazrbCNLC4z5V?=
 =?us-ascii?Q?h4PlfvwC3X3tvB/qkoozFgmepbkRc7JhlJ6Fr0Hm4y6gCT9D9OjakeOEDWI6?=
 =?us-ascii?Q?HK3KakS+/btDxyWR2Q3uFnX/WzH6mpwfW6PdD9xsaqCnDFyzGPt1edJvCBzr?=
 =?us-ascii?Q?rLXZyujwfxCOvT838axLqqH52AIIjmdn5P7Nrar+/+vVtU3A35UjOF6nbMoM?=
 =?us-ascii?Q?f6NWj2ESdMTswraP7GPlejNF6gwQnkwmZUFIjXUtWcfs8J9f4L2V2fI+ueEt?=
 =?us-ascii?Q?Ot8pYu0UfP4IBy66rhunGxUO9gUckssI+wU3Mxntnpz65m0ghbvr3BscE8ya?=
 =?us-ascii?Q?11A2BCURaCwetCZ830ZhuYXmrUsv7sWzxCj0lFg4piEkQSM2ZO6HkKQm7AZ5?=
 =?us-ascii?Q?UyMps6Msp40S4iKcX2vE/LG7Nz8wi5dvTNGtLXUZZ7l7y4/2VmDSmwzJk08c?=
 =?us-ascii?Q?iwqqKpmmMMe8O6HVhxTRgwLdalFzUN6i2VlmqgWSK2rXiFwSrXwHfNZzd8YG?=
 =?us-ascii?Q?XgiQ+abu53rP2a9/a3AOAMrWSYCyRnXI1EFiiZwdQo1897/UIj9e/93kz35e?=
 =?us-ascii?Q?ZgB8Xpe1pLG6JePBfEjGiiq/FhRvaat0eoeK9WDKq7MP2IycqjR4oo0H4LXF?=
 =?us-ascii?Q?HKuaQjFDGSDgBRb236yz+bctl36m+SN/nwm5NVty4d+RaoQvFQROaNaowL8A?=
 =?us-ascii?Q?MjXVgingF+qR1xJVPqV05bwzo/dgShHc5zum9+gAoiCDWeX++9uqM+blG5YV?=
 =?us-ascii?Q?M2+xF5u50566wO1Wadzxlsot?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a50fd77-ca1e-4051-4d46-08d9461bdb9a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 16:32:51.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYcGaS17mR95e0tJHPVFX9d3LTkpIxGKXG7fN66lW0Z3Dm8Iew13svzBhZc17L6K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 10:26:07AM -0600, Alex Williamson wrote:
> Quoting this proposal again:
> 
> > 1)  A successful binding call for the first device in the group creates 
> >     the security context for the entire group, by:
> > 
> >     * Verifying group viability in a similar way as VFIO does;
> > 
> >     * Calling IOMMU-API to move the group into a block-dma state,
> >       which makes all devices in the group attached to an block-dma
> >       domain with an empty I/O page table;
> > 
> >     VFIO should not allow the user to mmap the MMIO bar of the bound
> >     device until the binding call succeeds.
> 
> The attach step is irrelevant to my question, the bind step is where
> the device/group gets into a secure state for device access.

Binding is similar to attach, it will need to indicate the drivers
intention and a SW driver will not attach to the PCI device underneath
it.

> AIUI the operation of VFIO_DEVICE_BIND_IOMMU_FD looks like this:
> 
> 	iommu_ctx = iommu_ctx_fdget(iommu_fd);
> 
> 	mdev = mdev_from_dev(vdev->dev);
> 	dev = mdev ? mdev_parent_dev(mdev) : vdev->dev;
> 
> 	iommu_dev = iommu_register_device(iommu_ctx, dev, cookie);

A default of binding to vdev->dev might turn out to be OK, but this
needs to be an overridable op in vfio_device and the SW mdevs will
have to do some 'iommu_register_sw_device()' and not pass in a dev at
all.

Jason
