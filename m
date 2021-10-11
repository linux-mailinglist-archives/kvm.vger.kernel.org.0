Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA79C429720
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 20:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhJKSvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:51:21 -0400
Received: from mail-mw2nam08on2086.outbound.protection.outlook.com ([40.107.101.86]:52577
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233476AbhJKSvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 14:51:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVay2KnCxjEIVGPDVS0b6UPqtSxQr14lPxEX/5TUX4y8CCuGzpJQ1+hN2NtF1lSlQnhJEhLH5cNScbXMKt6e8xCdvO4c2++e5aeRAdpdMwBnqp69+x//FAdqifHADtnBmXqBTZwDVC7ceEPpA1AUUGA9U0Y7cf/anDQ2/n634ZKhRlIBrvJG2k0fi1tet3zglttn+hhqmkIWc2I0AMy581v0C/MMbge0FuGW7mflpYpQGorGvLXsNg6WpzRLJqLqMvZQZwX7tZocNwlw6ha6tuTdmkvew2DpAapdZNjsYDQNgLJcYoDmBInc/VFmNuPOqd24aofTAsXtyo29/pqqYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ca1lcFhRp7++DlLgqyAdbbQM5ToO6s/ufUkNavVx2Cg=;
 b=eymXmYDuQavAbxRr0sOnkk33WChf7aOd6xe91ab6qOZPPii7Gm5yooRUdNSCuw2krkdNa6qEfXUmiL+kgKjAMaiMYybDtRgDotLdEqbX1eUzNZDdRldwvCEU7en8SHtGjfMFbg+/H4eTxutDldqTyUIRE8ku2HotiFldlI4v2+mdGcQHSwHwLx37wjZnGwPaOuuhR2UkxpyNyBJtIxgdFsEW1BrUI9DhWNS191nHnbbrWxU6i6m8vUPzyNqDxuL6nUc3nISEVgLvEYwva0hSZv6EHaZqrq8+dv3ufjjjPgzPWGvYM6fkBMj0jOa8kJMKrX6LFjbwIakNVEe8eWcI2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca1lcFhRp7++DlLgqyAdbbQM5ToO6s/ufUkNavVx2Cg=;
 b=GIQW2sQxnQUIi9k4V4V+hIQlOYggEpWvpYTFvs7m7mTJRqoh4JsysrfpAer4NQs7iAWtQQwPm7zY2p9vNg6iZGVPx9KhKboxCfBdx6KfSDhJmgO/gVASkli/7+XhO2R8gaQpYaznL5gBpKGHSLkx4nDsJQt2igK9LErP/aUQCzcRl21BVvNWZ0lJ3a0Z9/wJ8xscjntZDyjBnSjNWrEJtJua9YoJJbR24aSiCrqh1IkelpNbTgsNtwp6WA46rJDJO50luUHYS5KIjxGvMfLLuMGgF/QA75HYSLbWcyL0Vwc0AeOoxq29APJlPGMhacK6bWSVPuMZc/eGRe1cTj87sQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 18:49:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 18:49:16 +0000
Date:   Mon, 11 Oct 2021 15:49:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20211011184914.GQ2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com>
 <YWPTWdHhoI4k0Ksc@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWPTWdHhoI4k0Ksc@yekko>
X-ClientProxiedBy: MN2PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:208:134::48) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:208:134::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Mon, 11 Oct 2021 18:49:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ma0MM-00DgKv-NW; Mon, 11 Oct 2021 15:49:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5970907-6719-4376-6752-08d98ce7d36a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5334:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5334E6AD040F729974117510C2B59@BL1PR12MB5334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtZpDQ+6Q6/bOvSnDYU5mjCVsYqDqUX6ZnpRwjUlEVOd5s06Fo9coQdom6g2DAJ6HJXXE+LT8yToAAEp7J7vUOGHrLTAvvoL99Z+yFncT1wSuID899LyCRX/v34+YJUD4gWF9gBKPQQkNYn8D7VelvxLpJ2Q48snCF47RvKYGMe/hohlJwr2duX93rXJQOTXFkOGxUSWH7bPX+PZmYFRDTfFcIgXVMN4ICTh2qEtPLZ/DCd9615mbhs3T6b88mh5nuiuaL2/KJLbzDZx93D2yVvAR7xYqb1l8awuuUpzXdwDfUjxATqX89mK+hW68QSZMKlXijPhOp9PaXWgSKmm9knQW53549wGPfkY4iY+/c409ooybuE9f8j2gtseirMv44VOe8HTmBJVhIE6xEtTpk0jLkTqz8vfNHYEa/TpiMoOCRM/ibSBRBsjNFgXVN2d1QZsW7CQS910dI/6UjLYmINFsSAemZ5lDjbvsIwCAEFCPS/kXSMqHRxlWcknxitCxEQ9bj72X2t7jW84nqOMeponbEhP8sWAPWh1rLhtHh8w4deUH0xYCZqQBTI1o+nMLsG0VXxZOK06k2PVsdkP4IX3ERLNnqxHW5G0XZFvr1Iuhl+8T9PYmE81viH3bQG+hUpcUSYl9VW8ROyzhDhrYQas0XvAbiRfZO4gN2qU22gSTAEnqPITYWI8+hgiS0bbci+MUYP7WYeVGGd51ozbjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(9746002)(38100700002)(26005)(5660300002)(508600001)(2616005)(8936002)(186003)(36756003)(9786002)(83380400001)(107886003)(8676002)(66946007)(426003)(316002)(2906002)(7416002)(4326008)(1076003)(86362001)(6916009)(33656002)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vhd93vahL3b2H5YptcZ6v276Yjd++WuRtj/i4CjEZ+3cQi/fNS29tNHk0yyq?=
 =?us-ascii?Q?PuHVuip4VIgeTbOrGAxA6n8IRK0i7hoeTpns+w3irb8IiNxfscKhhBsXdHK1?=
 =?us-ascii?Q?D3BWz2BNPOabTIbeVM01oFVLm86YHgqLgMRq6Ydg3ln+qCPbtJv3pBHH9vI1?=
 =?us-ascii?Q?bzH4yDMVGl2P/C8GfWJ2xR2EyPkOilLc+7LiVuUasL0bDX6NVZziwFFbJc9y?=
 =?us-ascii?Q?qrjj/FIw827uFRCK6kyiBf8kaduZiJXuEtAi3IFedDU+pr4BgF6cSo/iOFNC?=
 =?us-ascii?Q?9gL+4pGJ90jEfjXwnDaffwoJ7dxJdiZDyS2CbaL6ezz00B2/WSFm5ZiWVDYU?=
 =?us-ascii?Q?BHS2NB9ikk9+sseCZre8TLUACyV1g+mT57JkcRp6TnpD/8OvLW2sKSauq0Y+?=
 =?us-ascii?Q?O796kATNedM0cZdEUeTnl2Op8rEPGgZFfgkL9F5bFxY7aNj+Ql8mSIFcmrda?=
 =?us-ascii?Q?hq0XKJGiqjU1jrU03AigPO12sXDI38CIM9o38pq4Dlmmjo0zZztXHzNS2luC?=
 =?us-ascii?Q?cfvrLPamUi61Ma877g4c6HtM0B/8ah8J3IYF1hgLxQXUYUBYGfyelN1Q5aRN?=
 =?us-ascii?Q?H5QEDmvU0tw2AKhVpmJ/nhTC3qOSabxg04YpJtV4ulGFidrKR3EyFw9wBF5H?=
 =?us-ascii?Q?j+yEzAro6TQuVBVxyOhsgBgviPvDWI1OofRCvvWSCjGDP7pj8EXoWINJovVI?=
 =?us-ascii?Q?90ITffM3O4iwEtkzsEAmzlwXczJDz+8IG5Dy8iUtgRA0yXgbEVrBP7/sKnkN?=
 =?us-ascii?Q?PZHXIvVlKGdcA8aJCKxjzDkCWDgzKh68cVuAnMIRlvOZ6/zQwnY4+tY2aqxY?=
 =?us-ascii?Q?AOD+fN/Veo4gQInjLkkFaKgYG462Id8XeGi5RRkv42nLHwKGM4w5AtSoKJD5?=
 =?us-ascii?Q?8SBxfNiCj2VlRTCXs8Jvww2vh5wEo9oE4H7aHtREWPJc2rumRP3Vl/NyrUGL?=
 =?us-ascii?Q?/J+BOWu3MhmXaE3JHo/od1PRrz2VdDXW7ir59PRSKRR60FYtN1B+PVfvMxe4?=
 =?us-ascii?Q?jR6TO+ZmBQ5Z79bx2zmLtWFGgThKHCjqp5hb1+nYOQVSQBuiP3w5xIz7XwEr?=
 =?us-ascii?Q?hELivWRag+Vn7pqYLwTR0uxM9TxcvrYK9FRtvpqWtK/B4JU2znydZRjtnXr1?=
 =?us-ascii?Q?A/FMxNsojNF4PsFSckjOdNBhIEWsCztOUZl1kVKnwgZW2oTCE7oNejqr3uJ4?=
 =?us-ascii?Q?qHtgbz+lA7h8vsGIcAY8a4wfQVbq5ZbGFG6YgbHNbTxxNpYz1LmqIigsezw7?=
 =?us-ascii?Q?cobigKB2GztDwtD2ZjAjFqW5PwlqCsdTD5SnvsOjtce20SiS/9boIyaGG4X8?=
 =?us-ascii?Q?YfduqyMwJJBZbkXY3jEyjXyZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5970907-6719-4376-6752-08d98ce7d36a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 18:49:16.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQdS5YanDvU1MaAi65PXDTDx0/I6DBHDf1BeSMBe/kM5przweucJyZaOddovADwF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 05:02:01PM +1100, David Gibson wrote:

> > This means we cannot define an input that has a magic HW specific
> > value.
> 
> I'm not entirely sure what you mean by that.

I mean if you make a general property 'foo' that userspace must
specify correctly then your API isn't general anymore. Userspace must
know if it is A or B HW to set foo=A or foo=B.

Supported IOVA ranges are easially like that as every IOMMU is
different. So DPDK shouldn't provide such specific or binding
information.

> No, I don't think that needs to be a condition.  I think it's
> perfectly reasonable for a constraint to be given, and for the host
> IOMMU to just say "no, I can't do that".  But that does mean that each
> of these values has to have an explicit way of userspace specifying "I
> don't care", so that the kernel will select a suitable value for those
> instead - that's what DPDK or other userspace would use nearly all the
> time.

My feeling is that qemu should be dealing with the host != target
case, not the kernel.

The kernel's job should be to expose the IOMMU HW it has, with all
features accessible, to userspace.

Qemu's job should be to have a userspace driver for each kernel IOMMU
and the internal infrastructure to make accelerated emulations for all
supported target IOMMUs.

In other words, it is not the kernel's job to provide target IOMMU
emulation.

The kernel should provide truely generic "works everywhere" interface
that qemu/etc can rely on to implement the least accelerated emulation
path.

So when I see proposals to have "generic" interfaces that actually
require very HW specific setup, and cannot be used by a generic qemu
userpace driver, I think it breaks this model. If qemu needs to know
it is on PPC (as it does today with VFIO's PPC specific API) then it
may as well speak PPC specific language and forget about pretending to
be generic.

This approach is grounded in 15 years of trying to build these
user/kernel split HW subsystems (particularly RDMA) where it has
become painfully obvious that the kernel is the worst place to try and
wrangle really divergent HW into a "common" uAPI.

This is because the kernel/user boundary is fixed. Introducing
anything generic here requires a lot of time, thought, arguing and
risk. Usually it ends up being done wrong (like the PPC specific
ioctls, for instance) and when this happens we can't learn and adapt,
we are stuck with stable uABI forever.

Exposing a device's native programming interface is much simpler. Each
device is fixed, defined and someone can sit down and figure out how
to expose it. Then that is it, it doesn't need revisiting, it doesn't
need harmonizing with a future slightly different device, it just
stays as is.

The cost, is that there must be a userspace driver component for each
HW piece - which we are already paying here!

> Ideally the host /dev/iommu will say "ok!", since both those ranges
> are within the 0..2^60 translated range of the host IOMMU, and don't
> touch the IO hole.  When the guest calls the IO mapping hypercalls,
> qemu translates those into DMA_MAP operations, and since they're all
> within the previously verified windows, they should work fine.

For instance, we are going to see HW with nested page tables, user
space owned page tables and even kernel-bypass fast IOTLB
invalidation.

In that world does it even make sense for qmeu to use slow DMA_MAP
ioctls for emulation?

A userspace framework in qemu can make these optimizations and is
also necessarily HW specific as the host page table is HW specific..

Jason
