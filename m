Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395F3451E36
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344300AbhKPAf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:35:27 -0500
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:35681
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344671AbhKOTZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJyqpBflY9B1lv4xEqA63gs/xtzYFJ4i7P4qTgjpi7HQDIGl9tCL8VGEgYuYKtwaP42J7hHwZby4w+xnLuv+lmP+z3II9rFpxrRzkzs1TXGpyDVQ+Sm7YTpBdzk+3ofaY1QgMM5FLVpVzOTfEKeZZYFHP/SPsLh/PbFtSbd0H9TUyfgV0FbZ8zhiZcXREygmgljff3+LMKkTQ/Tu7ylgW4TjG34kl+7b8OviIcd62xEr6hj33tHRjjwN+oUdIjLGvaUI8w1BWjkLstNwOaPYWWDH0P0Y7BQN/J8AdyFKUZunlUjMgd8bTVDTIWF6SfoXQBOb3xV9pD5I5MnnHXZ7cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUzBFqVMgB+dn0n+Zrb4b9tgRRCrs+wZRG78G9DZvGM=;
 b=H+Z6Q8Q3XU9J2j9+Rk1n8zDNjta1na6cMaxG3fHwg9PfshdsbLDV+2SDQo7kGH65YGT94rNH/FcYUqE3XJK6gFGzJQIGaGMDkEXeXheGiOWNmNiy826uh//mL1H/XwS9idgyIop4lq5EHMONkucRTX4GmVpOPG9SXM2+qOC4rkX1XIGW1E7ds9fxsKT1/lE73ZQzLqd4OaHUf3zLeupWsny3se//OfuKimK0p9HPYotGr8cMmgkTOGDigwtsHnm582IvP1bK4Ed8uez0y26hFASgbIvdz1iWD2SZE7qU+QucYKMN4ehOTK1O5dp5jAlWpK4D5mMsgCExShZsY+aAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUzBFqVMgB+dn0n+Zrb4b9tgRRCrs+wZRG78G9DZvGM=;
 b=seKAYpFxB6PKMGgdU2J8pqgQBm54B5cxQM7RAdWYhIAyE0gaOnsvY48EiY2k0tfKnYnXS3WffUGBc8+aWqDhadAd8+4nEaubm1hCICwgaZBNiR1FNPwRivHlcW0Ztx2KpPhaic112TZ1LZWVFYs2NkalJGbJmSr0/nzrRkpzeeWypShgar7oi3Baz6BdqCpyKcRanQC0YYsf8XOEhq3MT3opNN+6/KOykZqfjCLw+KSW0SycoorOVfrwdzx2FkNnBimsljtYrrcr0X6G8lJVBzkwJfRIlkWUMDOZCIi3JLb60ydisEBEkzv55jH1e7GDIdbIbc+PGX5jGLchWeUx0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 19:22:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 19:22:14 +0000
Date:   Mon, 15 Nov 2021 15:22:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211115192212.GQ2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
 <YZJe1jquP+osF+Wn@infradead.org>
 <20211115133107.GB2379906@nvidia.com>
 <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
 <20211115161756.GP2105516@nvidia.com>
 <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
X-ClientProxiedBy: YT1PR01CA0067.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0067.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 19:22:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmhYT-00AaFD-0O; Mon, 15 Nov 2021 15:22:13 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 094bc879-e05f-483c-4167-08d9a86d3ae8
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539AFFF92508A83809DAA7DC2989@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSuZ0Ew74lddXEUEyhSIZ8Ufbxi927+TEq6jdLrDpenJcU+X4D8q0OFuatYt9K36tSr3wayeeKEMIyj5nf9pU5oZwIZyIt6dw1EkfWgJPqs+UJi5Bz5bSv6spCSgGTbSMBm5vfF+0//tjDt0VGGXcvHA0uNlh8wuUpuvqkLnvi9X4LObSNKmqi4Qw/OJCJ9w5gG/H7HsLxgm7E/UkzLwmvyzziQ4E7kwKy0e5/CRd65s7kV70FRCt98TA7EwXj2UnlO25umPLVmx9UY04H5ZTm3cgg7BBh6TbdT4yqNwcN8+UcOGfhuRppQMEROE29Umph0t9UK/i99cMXQJj/BREZmOY3wcFjPuE+XwEqDcnKyOyPyLL8h8cwPpnrdD6XN+NrC8VuZEL0h3y0a0NLgg+/XnXTkEcqJprjhHY4pEtC2Se1Hcj/2/JhKpnnZHS7MZdXFqVrMNIGxGVJMbJRcGBWYoZtzRcXuttuvNUZa9RL6DsiWCq0elfwmAAJUcFJ2ONmlemr4njzuS8jV2PN99JNTXw0rsfc0SWXUG6THEd90DxtUKlgIdFP/pakoqPmZXQH0e4DfUK69pRHh7U5pO6Z3S0xJzESK0v+wMLts4tBVvmYz8gDLeSyL8UmHGE+3Pt8O+n2hQVNo7Tkl7Hhrx3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6916009)(9786002)(9746002)(2906002)(316002)(426003)(1076003)(36756003)(8936002)(2616005)(4326008)(26005)(66946007)(86362001)(66556008)(66476007)(186003)(7416002)(508600001)(4001150100001)(33656002)(38100700002)(83380400001)(54906003)(5660300002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?90SnRZgAye/mZacCS+wXsD6+0V+cX2nh+rH6xaRrkTpgxQNy392viD1phjTh?=
 =?us-ascii?Q?gN4Na1Qi5EyG1zX77ln4zXZPwM7xh/79RtFc8WmCGo7XUgjeWqXg3nRoKxXy?=
 =?us-ascii?Q?qNgbZ5ImLipySkB9TKkuNZt/4SlGwpCMJPANJNhXVo+t/AN1zE6NjN7TBIjn?=
 =?us-ascii?Q?OWYxUzn2QP6AssJ/zjl/NwggPzGjYz2QKRuSCukfUXwD53qzucYPNZT4iKv7?=
 =?us-ascii?Q?XShNTkae6vU4l/cnkdtLa1iw2lq5IWkEM9LvMTKKkgOb2AAsWWQu0BXr7mqy?=
 =?us-ascii?Q?fCBzFNnWoJptp2Mc1TYleKnohgkiF9Y4oTxlY+kT2cgqwkdT+jdo2fZmcvi6?=
 =?us-ascii?Q?E1nUPZ1qFl+gsESrYdJQVCyaCI8FlpTYM2bGgQCxsf0fiYUbPk5B3Ey9kUgZ?=
 =?us-ascii?Q?eZCR+NxSpZzm5Y2RC1rT/CgWL5n2wF6LB+HP5EfGFYaJnWEMyVlKpHPXHSJj?=
 =?us-ascii?Q?dySHi0h803tS+R5ishgsrpreRUo1H0zj7CosL1wS57BRPAXPZ/YiyE3AXede?=
 =?us-ascii?Q?HXzXOmjCj+dDTIOWciKyhdw87W4hIWLCad7MCKe+xN+1dzzbS5mAJv61mzhs?=
 =?us-ascii?Q?meg6asp9Xq1g8adHs52C6f7jwfkWnTq3uijp6JyQM9vkhkVdzSGDgmCgUeBR?=
 =?us-ascii?Q?Ph3Et+o5ea4DqqCy0a3IPb3AI6yoCooNCu8Bk5jp+SZvdSQ/SH3u03ZjXu1T?=
 =?us-ascii?Q?1xRr94nSPmp562fC/+fgIFJpHZxA5vjLlto+vPaq9RBjlYaUNGrZ8kMal8U2?=
 =?us-ascii?Q?sJKSTC8YpUy6CCC6q5SipC4QJWOg8GexN7Bazi37hcAaW27qeXZxEudGBFPj?=
 =?us-ascii?Q?bSA1zR18qrmzGOfZVKvx/EouQRFNsQnnty3JLKgiqqxcpaNJxKXkXLB533DE?=
 =?us-ascii?Q?6JVnIy77Evq2mD/jEZAamBlM0cvuXuv7WYEMeSEHPbGVuz7JSSsVhRM/RK65?=
 =?us-ascii?Q?ba/b3SXSUqBBrWJ/u10NKy7SKDCOoejEKSHqiY5630NuwcY6IX/uYGuRKrH0?=
 =?us-ascii?Q?/TASHboVD0Rt7suoGMqTceHMhgBOOjyNQP0pnpbaUyDlq54CV+OIVyco2gcZ?=
 =?us-ascii?Q?tqzdZ0UBANQlYtMpesxoISdO/lo7a1AxYOQSR0F6F5K5BBlyJjPuIycEAq8Q?=
 =?us-ascii?Q?G2SGq4xNd2FxGL1kxdBbcPC+0xh+JM6iy3lbGsTEdDClJI3Wimp+98+SsiCc?=
 =?us-ascii?Q?8HQs//eOIKfEQcL3F3T6qFzOf0gxVPphm6OVLVoBKXAKvV+2krRGtSu5DkpV?=
 =?us-ascii?Q?tkFBtOLbNAbBkPPbwFcSxsIz2+sowbF0WavonlpgVVKe6I0NqonQ2Qu4+AcE?=
 =?us-ascii?Q?wL/GzgWzMCjbu/T/hXQf6XOspy7IrjgGX1FbLDiUoOzM7gPGs7AvRLEuZIBI?=
 =?us-ascii?Q?76OF0z43BKb6pXsnllnVzatjxx49faaNlqkPk7HxgN49SHe21ZZclIFr3Grm?=
 =?us-ascii?Q?6vPUwWFb2Xvxa1GMZ6cbLrJQ5ScADevnyB15R7MfvxG4wBLUcrDwlt1dD7q7?=
 =?us-ascii?Q?4qNm50q1aWPj3DtXx7XfCzhuq68A5vjmhYHtUUkCTONe5yXqDP7NvV8PPhwR?=
 =?us-ascii?Q?8GBihs1aIpc+pRx5d54=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094bc879-e05f-483c-4167-08d9a86d3ae8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 19:22:14.4469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIvsX1tA00jenrUehCbyMLI07JpATg9iHYlcm3Fu3IM5fmTxxL2loge5CX7jy/yM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 05:54:42PM +0000, Robin Murphy wrote:
> On 2021-11-15 16:17, Jason Gunthorpe wrote:
> > On Mon, Nov 15, 2021 at 03:14:49PM +0000, Robin Murphy wrote:
> > 
> > > > If userspace has control of device A and can cause A to issue DMA to
> > > > arbitary DMA addresses then there are certain PCI topologies where A
> > > > can now issue peer to peer DMA and manipulate the MMMIO registers in
> > > > device B.
> > > > 
> > > > A kernel driver on device B is thus subjected to concurrent
> > > > manipulation of the device registers from userspace.
> > > > 
> > > > So, a 'safe' kernel driver is one that can tolerate this, and an
> > > > 'unsafe' driver is one where userspace can break kernel integrity.
> > > 
> > > You mean in the case where the kernel driver is trying to use device B in a
> > > purely PIO mode, such that userspace might potentially be able to interfere
> > > with data being transferred in and out of the kernel?
> > 
> > s/PIO/MMIO, but yes basically. And not just data trasnfer but
> > userspace can interfere with the device state as well.
> 
> Sure, but unexpected changes in device state could happen for any number of
> reasons - uncorrected ECC error, surprise removal, etc. - so if that can
> affect "kernel integrity" I'm considering it an independent problem.

There is a big difference in my mind between a device/HW attacking the
kernel and userspace can attack the kernel. They are both valid cases,
and I know people are also working on the device/HW attacks the kernel
problem.

This series is only about user attacks kernel.

> > > Perhaps it's not so clear to put that under a notion of "DMA
> > > ownership", since device B's DMA is irrelevant and it's really much
> > > more equivalent to /dev/mem access or mmaping BARs to userspace
> > > while a driver is bound.
> > 
> > It is DMA ownership because device A's DMA is what is relevant
> > here. device A's DMA compromises device B. So device A asserts it has
> > USER ownership for DMA.
> > 
> > Any device in a group with USER ownership is incompatible with a
> > kernel driver.
> 
> I can see the argument from that angle, but you can equally look at it
> another way and say that a device with kernel ownership is incompatible with
> a kernel driver, if userspace can call write() on "/sys/devices/B/resource0"
> such that device A's kernel driver DMAs all over it. Maybe that particular
> example lands firmly under "just don't do that", but I'd like to figure out
> where exactly we should draw the line between "DMA" and "ability to mess
> with a device".

The above scenarios are already blocked by the kernel with
LOCKDOWN_DEV_MEM - yes there are historical ways to violate kernel
integrity, and these days they almost all have mitigation. I would
consider any kernel integrity violation to be a bug today if
LOCKDOWN_INTEGRITY_MAX is enabled.

I don't know why you bring this up?

> > That has a nice symmetry with iommu_attach_device() already requiring
> > that the group has a single device. For a driver to use these APIs it
> > must ensure security, one way or another.
> 
> iommu_attach_device() is supposed to be deprecated and eventually going
> away; I wouldn't look at it too much.

What is the preference then? This is the only working API today,
right?

> Indeed I wasn't imagining it changing any ownership, just preventing a group
> from being attached to a non-default domain if it contains devices bound to
> different incompatible drivers. 

So this could solve just the domain/DMA API problem, but it leaves the
MMIO peer-to-peer issue unsolved, and it gives no tools to solve it in
a layered way. 

This seems like half an idea, do you have a solution for the rest?

The concept of DMA USER is important here, and it is more than just
which domain is attached.

> Basically just taking the existing check that VFIO tries to enforce
> and formalising it into the core API. It's not too far off what we
> already have around changing the default domain type, so there seems
> to be room for it to all fit together quite nicely.

VFIO also has logic related to the file

> Tying it in to userspace and FDs just muddies the water far more
> than necessary.

It isn't muddying the water, it is providing common security code that
is easy to undertand.

*Which* userspace FD/process owns the iommu_group is important
security information because we can't have process A do DMA attacks on
some other process B.

Before userspace can be allowed to touch the MMIO registers it must
ensure ownership. This is also why the split API makes sense.

Jason
