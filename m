Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F5A47C6DF
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbhLUSqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 13:46:14 -0500
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:27905
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231534AbhLUSqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 13:46:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHzK7Qnx1eqtDdPWgGcX3Dn0dvQ3Q+PUFWOKQGPw+MuJ//L9XXbNSi9K/QKJk2cGhJ8/xfsZmRd2zW4VMbRr9mky9QAkTfmxbrdKQHeQDdZ8K+To6ncA/nkm/BTdNZVVAJh9brivLU9I7D4opScLfiCNtI9K+XNLcLAv1HXK+3fGhlNUvgUb58rtUAC2dxj1VuVH6S46GM268t+hqKpWo4zK3vmne3URoi8iyapftXhjjzCvJvdCqgv2x+WeoRDbkZmpsUJlRC+LvDr54ZHa1ZG2u45AId9jrNNYSWcfZK0VaX4R1Z3fowyWTJ998qUwbF3yaIJ1xYPLbqY5f2EiFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzQEMiqfdSZJmpm/hrPfGgTjlDc95xpvzfrxToFyjJQ=;
 b=Jv6meejEzIrsRcLEbr8XSyOQbPJeyXWCumGiRJd4vd+tddLMvCmC4wdH6VwilFdkqZ1GSdIB97khIvIpHvlnXoj9iKbwqjSbbtVFKjDUO0fRf9f4bI7hpX5iLeix4niyQLEtWuniN6mE1QFXM+BBM5hT35RoiqfPheofNk56+EcUBGaSMCdyFyyYSu0LHunxhmRKc8QB47JwCYV3nTejv+rRUFCi+ee/DnEwzzR5aZnJZUfXvRTgPfP+rRwDriego4E5rHOPoYGxOdPPuGIPy+7o+VG0dbcJ8nIhtZQVcgsbxg0tV6/wxte7+Oysb/gqMrt1cMncVCfH2lGpN108Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzQEMiqfdSZJmpm/hrPfGgTjlDc95xpvzfrxToFyjJQ=;
 b=U5Vvojwm95Nqsp23Pu/IlTsu0DfLSYtU69SfQeW1McG9Bb3djZyhCCF7HZtKUV2Jg3Rn6YwVuWSekBuRvdFbXP8JWbLNjzxus29t1LyW2y5z1/epuNnXMs5JbjCDigG2bnZlDgp7lnIfv5dLSpGObFMKsCZsVD3OwQXZD5wn6/db1zWzrih2fzGam/0TG9GLuhKH2NaPWc/gxHJHGkWawCWsPsVBGgL+WBKN7DBmH8KpXeGJu0hyciSdY3X2pEG5VvLGaLv+tNC/Eh8E78pzmf5/iS5+vQ82lpTIljcchxrpuIICQX8+OV8nX1e223gRNyXt+epbM4Jx7SuKH7IZzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 18:46:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.017; Tue, 21 Dec 2021
 18:46:11 +0000
Date:   Tue, 21 Dec 2021 14:46:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
Message-ID: <20211221184609.GF1432915@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
X-ClientProxiedBy: YT3PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f78fb51-f10b-44a3-2525-08d9c4b22843
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362418157FE9BFE51E666ABC27C9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oeki23Tsg6rSw3f/wdkC0I34GF2dh1C2Ob433mWHSoBjB+mt3zKLR26mNNbiPdT75RG0NFYvGT9Cro5yiS2l6/sxP6XCEdc8i045v9dIzh+fHL1kxfNa4cF29RW/jOfTrNFMFgTRphr5DAvPCWxXLpWTqTDFT74BD83dkbKpsam/FhQ8ptv0Xat8Q2V993xtr/qsBmwiMpzX71un68GSUhCDPMTW7TNQHGl7M5y3fGlEPX7UB0xiNf38T95/9y38gVKXZxmXOZA5StK9knZTrde7NwYGi8jwZ0nLYRnNaWRDPhsdBADlaijRV6VTwnlHw6f2mFogpWH21LrrhOrB/5bwf1v/FTr5LtaRFH+Qca/dPcWKjbe9wAsCzNp/kSJRk2IcCyfl36lqpKomcmHoc2S6qXLdgtBBEgSLWwtQX/boPxjqFROAKlP0fG7VEE0c5GFiPa/ePSCPfs69Rge1gOOnMUXrYZNMUmUGfNHqkgHHj5Pc/cke+Y82Whfea+PJcs8xgEAlMLmWbyqHz9jZOjRHwmW8Y2D7pECASDDnyXmcFCsPapQqkqMDD/dQRdoGYD/79VbXLCB9rlWPWxS4gyrCvEJT1e5BMzEyuUjwejP83DvnbEtGqIK4o6lcm6rQUfrlK61rbZZ4mWSCpjAntg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(54906003)(7416002)(508600001)(4326008)(66476007)(6916009)(8936002)(8676002)(2906002)(6486002)(66946007)(2616005)(66556008)(33656002)(1076003)(6506007)(83380400001)(86362001)(5660300002)(38100700002)(36756003)(26005)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtmW5BN4sSlkcd+tOWRBM1mrNPkVAJwJCn3JDsrhpoubGNXS4AwLSmJfx5gY?=
 =?us-ascii?Q?fbxDU7OhlEjJOAYBVnzWA/VbFDRIg3G0TkwIJe0LUi1CAT03o75y45BFCEAK?=
 =?us-ascii?Q?IjN+qAh+bUWIND2SlOj/F5fVg6OGrXKMoaWCXGp/uPppvwrq+PyyRX6byEaz?=
 =?us-ascii?Q?vDP9MR/Y4vUudPetRJMtuuPwL3V/A3cQ+n6VEwc2b+HRXbEZkbHJe8gaLGMj?=
 =?us-ascii?Q?aRhm4Kw9Ypx/Ao9BC/B2YFfZePvNkEi0LvwX9FTQ2XpwcXp+dtmhfwtWlyEX?=
 =?us-ascii?Q?96y344kIEj6qkegltUvRmNWgCk+efeiClv0rcd2bicJzunVxKbjnOigy8eA/?=
 =?us-ascii?Q?byieo1l1OFtqLdEW6VsaEJrDvdZSMTrzwDR4Jpmrl51jnm4RJjNRtd4ym69s?=
 =?us-ascii?Q?ejkgAFvgJLaHxQdLaPwHPg0avsjyw6vFIWyya+K/XvcR/Lu35Ie5ui4VOgt8?=
 =?us-ascii?Q?zbHPt93zGLjzZKAKxJkzPgCU4lowzNyvLuSs2+EGm4PE3okZ9N+GVdPzSJxk?=
 =?us-ascii?Q?GQAxwa9fUXLs3i5ZVCf4GKW8lJKlRVY361dI8mGWjwI4EJblAQhgxH25QRD/?=
 =?us-ascii?Q?jt6EtRYKFzoU/WH5MbUI9exRzphU8GTw3ucXNue3kEZk1xXYL1MivEVf799O?=
 =?us-ascii?Q?SBQLYFRUGGwUnDAdruifyXzP4y5cB12rUVZlYe/0mkslJtuntSLd943ZT9Lf?=
 =?us-ascii?Q?dBcf6f300/wOQ7r/kcq1UjffiGvRRKOw8WOt+ODZ/wubxyTUPfuY/yOu5Ec0?=
 =?us-ascii?Q?S4/J5QwSN8iC2gl9OWzfnx/Y0rrGCWR5u8DNCYGSXa//VYyXTU+/kF7eDT7g?=
 =?us-ascii?Q?jIy2gAC9NYesNjecL//GdbV4Hd7G94nxneL2OInrhl3ncLTgG0bIVrM7qSiH?=
 =?us-ascii?Q?URQkEqOSlG+BAp1QYY0RYRvmGyMGlrwKe96BVMDZ54oZzBiQBp2FtYBfn8DN?=
 =?us-ascii?Q?XQNFw2k8BqExyf8dcZDjFTWZ7u/8SWZJTyQBgchjB3NY5evRxwjNyLb6lVc0?=
 =?us-ascii?Q?llupLQOBUdzvdLNKoUfHPZf+Jg5ao3LyWUGek3Qkefn4o9hfFiSaDLgerklw?=
 =?us-ascii?Q?O6WtPdEo93xj8wlyu60lrwHCS9wqrkwWITY+uTXCVtIsZbVmS9vwf6Mlwwp8?=
 =?us-ascii?Q?+FEUz+f/X85ryviN23j30WFPwHvXHYMxGcynBZfOJf531V62+Rl9SRM5guIy?=
 =?us-ascii?Q?kd4rX83JGlpwcfzXoRlJpgpRJ4ZZoFJhPfz+kqQJL97d0uxbXGBQDkEm6oB1?=
 =?us-ascii?Q?X4ofmK/IGwgAA0EHkr23HpolDBYfbGlRZ9Ux35OT3hQNy3718zexnWfWV1rC?=
 =?us-ascii?Q?aGNLpZHuuEtz5NPQp6G13hxYmDhmLZPAm+YnhPJRBH6L5lFOfipNcYLRe9cn?=
 =?us-ascii?Q?E/MH8NHbLw+8Oi851jojfakNEtKB2H5mz4qP6pi484p2eMxZ10qYfYwzIGVn?=
 =?us-ascii?Q?hTKveSo3gxrhPN3f0yqU9YQkOn1dBr1tQnlKVUMVjEKtRvOT8zaf4dleTBca?=
 =?us-ascii?Q?kL2tJRZJUsMjQpSZQMKFcMXr8SSi9B52ZxftV8EtB7D8CRpLwZxU0411S1mk?=
 =?us-ascii?Q?FKnAQvG1w8MzySu/5bE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f78fb51-f10b-44a3-2525-08d9c4b22843
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 18:46:11.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fpmm8iPBDm8Hj9rKamr0x7nLUlsHaxUvfY0p8zJiLso0vpIirvGY78ZAfm76nC5a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 04:50:56PM +0000, Robin Murphy wrote:

> this proposal is the worst of both worlds, in that drivers still have to be
> just as aware of groups in order to know whether to call the _shared
> interface or not, except it's now entirely implicit and non-obvious.

Drivers are not aware of groups, where did you see that?

Drivers have to indicate their intention, based entirely on their own
internal design. If groups are present, or not is irrelevant to the
driver.

If the driver uses a single struct device (which is most) then it uses
iommu_attach_device().

If the driver uses multiple struct devices and intends to connect them
all to the same domain then it uses the _shared variant. The only
difference between the two is the _shared varient lacks some of the
protections against driver abuse of the API.

Nothing uses the group interface except for VFIO and stuff inside
drivers/iommu. VFIO has a uAPI tied to the group interface and it
is stuck with it.

> Otherwise just add the housekeeping stuff to iommu_{attach,detach}_group() -
> there's no way we want *three* attach/detach interfaces all with different
> semantics.

I'm not sure why you think 3 APIs is bad thing. Threes APIs, with
clearly intended purposes is a lot better than one giant API with a
bunch of parameters that tries to do everything.

In this case, it is not simple to 'add the housekeeping' to
iommu_attach_group() in a way that is useful to both tegra and
VFIO. What tegra wants is what the _shared API implements, and that
logic should not be open coded in drivers.

VFIO does not want exactly that, it has its own logic to deal directly
with groups tied to its uAPI. Due to the uAPI it doesn't even have a
struct device, unfortunately.

The reason there are three APIs is because there are three different
use-cases. It is not bad thing to have APIs designed for the use cases
they serve.

> It's worth taking a step back and realising that overall, this is really
> just a more generalised and finer-grained extension of what 426a273834ea
> already did for non-group-aware code, so it makes little sense *not* to
> integrate it into the existing interfaces.

This is taking 426a to it's logical conclusion and *removing* the
group API from the drivers entirely. This is desirable because drivers
cannot do anything sane with the group.

The drivers have struct devices, and so we provide APIs that work in
terms of struct devices to cover both driver use cases today, and do
so more safely than what is already implemented.

Do not mix up VFIO with the driver interface, these are different
things. It is better VFIO stay on its own and not complicate the
driver world.

Jason
