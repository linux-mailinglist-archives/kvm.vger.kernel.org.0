Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B95145096A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhKOQVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:21:03 -0500
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:36704
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236656AbhKOQU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:20:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4TL/fEqblqcPME6MbeQ6IrLmIhRk9pN1xGaFH2VZYxs4LDr+j4jUTSfJHFCs51XZ10ggbgXjkq6HFqdXH9nXBIdGawFUzlOzxh/T4H0iI1kFqCmChKy2tT6NNtRW0yRl9Zbce2wez+QsDHAXQkOL3Jhg63U7fhE4nMrJWwUeFDIE5qdwCXc0NM1203b+jRVB0uu9L4bv7ikqpTyrdoKyi7VYVwXVNZgR75+LaVNQSi4c9G7utPk2b0Qw33bYfFFX4ChJjN6DaQiiYzOQBWcU55K/qpK4wVJUynWdUQQ6cg4PGu0SH6+0tNAGebaB5uqFZTXQ0y9BXVKbiLWQ3cZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7u6I72VA86inSpslU8RfEuvmcDMb3jjxoffhhv+53eg=;
 b=FyzbRGpdrNkZYera4eP5H5VZrIVxTNNo3yM5cuJxkObyfoxv6BCRsNJvLiKJalzGslth4/tSTmE7xNg4iaxiyz0moqyFpLjgezUTZYJJggtZ0yI6IJiBBVyLc5DV4p4iqxfMUkmgIXOs0BPlJ1gx7nB/bTFrOeIJiFo7F4vEkMPXOuqjY2DLBLu+iwDaQ0b5arzs0OXytIUvHRmWbG4mkWzyyxueZO0fQWAe137SAJejL9pH9lQrOAm60dyOch+o+tggZytai9XqkDbeGpnhb0xPJTXwhCRJPZDPqxZK11XUM5iMrl20exZd0xdZDSvxWldDuRXeJWWkVDp02sZ8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7u6I72VA86inSpslU8RfEuvmcDMb3jjxoffhhv+53eg=;
 b=QgHpZL5gIhvD5bVrG1GnquJX+ISErQa8ScVjiU6MZliAHcD8hDCVso7nyXACPr5JizE0YIe5M+LgEP/a7RwIrB2GFjkZcosOKPG29TjJ8D/VsY50h7s4V1pScnouILvYBxTd/X4CBautjW8EfhIU9sww8fZi0zFfFwmgzRXRPC1cqjcbTUG8rwVXe3fiKLxpVtY+/ndh4H8dXm6RbJTZhTUoSku8CX/H52/edf16b4IfDpJaREGUHsHmJ58bDYIXLzIX1N6/20SaM6tbpt1Fl0Y4H65pSTitbG7q10cddhtTXhB2J+SBwa045qpEuB8CjrgyntdHxia19GBd9Oz4vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 16:17:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 16:17:58 +0000
Date:   Mon, 15 Nov 2021 12:17:56 -0400
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
Message-ID: <20211115161756.GP2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
 <YZJe1jquP+osF+Wn@infradead.org>
 <20211115133107.GB2379906@nvidia.com>
 <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
X-ClientProxiedBy: YTOPR0101CA0008.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0008.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 16:17:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmeg8-00A1pv-NG; Mon, 15 Nov 2021 12:17:56 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a49121b-c1fa-4fcc-728f-08d9a8537ce9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5159AF0A43A63737A4943A49C2989@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J++W6ry/Kpg7sRNsUsLfNXxHYePW2FpHm+oF0ajZdOlZitUtUWIESrFj/vZx0dzxdNafyHgsPLobo8RKjR1o7iT2A8Dl7AgL5BUUACl7/e+Oyy/NMA0Lbbl+VXig83n+9h5f3ZQwXFZ7hd8HgLikMxbVr0MXzVN7x8UEQdUyArxxjnhnTRnPQmyM5Jn1U/VtEGPLho6b8T1h18E+x1NvLiOPQH+kqCpGuZYPEkllHAXFccq9sARh7KHTu93fgamC/pxGf1/Xni29lkHN3oE+H46y0DOipoDvIvkhpyz9PVObDRHuQhQNGMLnphKfuxs/6YVU49IUwCNMtJAjU4ExlZCpG/48z0rI49cT745p2iPu2EAWppBfLiQ8YmpiOl2emoK+IzhZ8rLKJ3VjB3So5X4J7w6AYOTzsX8+iPEUGGe8fyTTDEkOicvcHYGKEAxsQmad+Si9+XZSgmcKWmdrhaDXwna+GNYNtGx+9gtA3ewKsb8PFn55pJKxROaQUo21j7RyjQHHat8XhlMp6VKsFPDgIQ64W6gQXy1xtBxlnboxV1/jhp+BfWlSvjFiojE1jJuR+u1nKhWheJLIqy4bDMGBh1f95TvchUmUJaXgpYKAbn1ijtrehHkb8Sm9btpog8MD6QrmGbpcoeiDHBZ/eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(2616005)(54906003)(5660300002)(508600001)(38100700002)(2906002)(86362001)(1076003)(186003)(426003)(8936002)(6916009)(83380400001)(4326008)(26005)(9746002)(66556008)(66476007)(9786002)(8676002)(7416002)(66946007)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mmmgaWLdcAw7nT1ACPaWrZq2Wb/x+zbIk3U0Ai79HgdVf6DM5gqVSEXTyHNn?=
 =?us-ascii?Q?t6Efqtr3avr+MyqYv5ivHncpjG6+6Wgu5WW3C+8xhKt4fvF2sGJPAq8+dATy?=
 =?us-ascii?Q?Ur9I8OqPLPDiDM3YXKwWGFayioVXNnX0bPY5g0P8tKZr2mVFajws86cINP9Y?=
 =?us-ascii?Q?tAU2bDQOqqgvk0yD7HYnqncmrlCg64+eTNoWIQAPfzaZKQuC0zzEDaJf1xjm?=
 =?us-ascii?Q?YsBgdc8aetMSOGybXbCfrsw+4MKukK3Sc402qSc+nIsFGH371P3/Fx/aYep6?=
 =?us-ascii?Q?Pto7KRqlh5bvQLyph80aXmAXzAR3t/pbNwz4hgPca7Z9NV6DC/rXHlgssE93?=
 =?us-ascii?Q?uFRhXumk0UKRkrZF92lk8jHRzuY/jagQtielRdWu4zhxmnMQOtB8nHqQZgZm?=
 =?us-ascii?Q?wwjgHAG0fT+aTjDCHgSe/yCmLXoPMAWhX4cj7Y80s0MaBiOYx8eU0Cxrjvcc?=
 =?us-ascii?Q?Z9/gDIja9e9b1iAvLlbQrHmxd5VzDKGXahML5Xz0sJmxoxivgMXHXiFARU2A?=
 =?us-ascii?Q?/Mz1vkMeRLwDMRxhCMEvHkllIpMazd61Xd1lE7bIRDgAnrsW9mPZCqvI6KXI?=
 =?us-ascii?Q?0X4JYFHB7xT1x73DyaITzAGDWIxF0D/IcTn50ibYhcRqDBGCJys9OwdLnBZl?=
 =?us-ascii?Q?2I9xS+kvbNYPRcRDTo8PrRCND5t0y3bH6PwDb3Nt1anSUJ4hYHICRVXbt/x9?=
 =?us-ascii?Q?ng/WdPYea2FmFQxhiYojY0JeDPQVcxaAbwwcZt1nZB14hXYdl2fdH0W+WngO?=
 =?us-ascii?Q?1s6F+iJWPTySGr6v5PAa9hWB3jPHmK8okx3kNfup689I07wjIqrFv2wVrwCW?=
 =?us-ascii?Q?zSfyA49EECGPuFpv+LC1LmPEjfNOFZ0Jg3uhO0eHApDBiYJnW88c3YPRPi2/?=
 =?us-ascii?Q?Q/vkR+sM9o1yg6182wSce1JL9NHTSUvaRN526oTQtO7l/aJ+bEyWjN52vCHe?=
 =?us-ascii?Q?qODQkQtI1G6YXkSD8LNmYEGsRB0M1KWVSZ8Esd0mfIrRn9ChIY/5bhOnszW8?=
 =?us-ascii?Q?4WIwkH6LSPXnTjA2cRRa27YLr+qwHIKS4YsOa51u0o2GYjQylNvztuaEopor?=
 =?us-ascii?Q?3JVT41Kjicvdrr5Dr3NgMdAdK3uAls7c9ONvhYr8+SkD575IqvpjMntGJzHR?=
 =?us-ascii?Q?x2UWzMVihZzUvA+yjfPUmRy+NJnjJFKLfofT4zTEh4geZ9OmUxdvvGIa55Lf?=
 =?us-ascii?Q?NeBUlKRvhp1xeG3tzfzGHACOzPEtCTy8PKAVrCljJYZaaHbNYQyfbuDbpZTN?=
 =?us-ascii?Q?LFw5APgioDPtMquIUZUpM/+BbNPaqkI2pczOg4YX14cevskD0Q8TxCyd2Uyx?=
 =?us-ascii?Q?hvRqyQGf++rFtvP1oMeMfThjhVJGCcF1zUR41AX2sA6F44ALuXLhdP3Hn4+9?=
 =?us-ascii?Q?G/OFXFwO5pH2GTBVwRg/l5jofRDKHsjfnARTcJ4YdF21brwHUFkkgCVlEejP?=
 =?us-ascii?Q?F1fMNHG8ak7hd4O3/AiJYVAoWSbO+wnwoFYKZoGctHXqrQLZSzpFE/OCMbvk?=
 =?us-ascii?Q?0ZivRPF/WIR1kLy9krKgAL0YCNo7TdXKRT8q3VlSx1a++YbuxsEcsKmSuStO?=
 =?us-ascii?Q?SbGyF5ZcLY78uAnLVGc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a49121b-c1fa-4fcc-728f-08d9a8537ce9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 16:17:58.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ps1ntis6aLGPuhdcX5bYEG+WZqFK0408ZiHnjxeRsSj5rL/pYTuqdhttgwx5flD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 03:14:49PM +0000, Robin Murphy wrote:

> > If userspace has control of device A and can cause A to issue DMA to
> > arbitary DMA addresses then there are certain PCI topologies where A
> > can now issue peer to peer DMA and manipulate the MMMIO registers in
> > device B.
> > 
> > A kernel driver on device B is thus subjected to concurrent
> > manipulation of the device registers from userspace.
> > 
> > So, a 'safe' kernel driver is one that can tolerate this, and an
> > 'unsafe' driver is one where userspace can break kernel integrity.
> 
> You mean in the case where the kernel driver is trying to use device B in a
> purely PIO mode, such that userspace might potentially be able to interfere
> with data being transferred in and out of the kernel?

s/PIO/MMIO, but yes basically. And not just data trasnfer but
userspace can interfere with the device state as well.

> Perhaps it's not so clear to put that under a notion of "DMA
> ownership", since device B's DMA is irrelevant and it's really much
> more equivalent to /dev/mem access or mmaping BARs to userspace
> while a driver is bound.

It is DMA ownership because device A's DMA is what is relevant
here. device A's DMA compromises device B. So device A asserts it has
USER ownership for DMA.

Any device in a group with USER ownership is incompatible with a
kernel driver.

> > The second issue is DMA - because there is only one iommu_domain
> > underlying many devices if we give that iommu_domain to userspace it
> > means the kernel DMA API on other devices no longer works.
> 
> Actually, the DMA API itself via iommu-dma will "work" just fine in the
> sense that it will still successfully perform all its operations in the
> unattached default domain, it's just that if the driver then programs the
> device to access the returned DMA address, the device is likely to get a
> nasty surprise.

A DMA API that returns an dma_ddr_t that does not result in data
transfer to the specified buffers is not working, in my book - it
breaks the API contract.

> > So no kernel driver doing DMA can work at all, under any PCI topology,
> > if userspace owns the IO page table.
> 
> This isn't really about userspace at all - it's true of any case where a
> kernel driver wants to attach a grouped device to its own unmanaged
> domain.

This is true for the dma api issue in isolation.

I think if we have a user someday it would make sense to add another
API DMA_OWNER_DRIVER_DOMAIN that captures how the dma API doesn't work
but DMA MMIO attacks are not possible.

> The fact that the VFIO kernel driver uses its unmanaged domains to map user
> pages upon user requests is merely a VFIO detail, and VFIO happens to be the
> only common case where unmanaged domains and non-singleton groups intersect.
> I'd say that, logically, if you want to put policy on mutual driver/usage
> compatibility anywhere it should be in iommu_attach_group().

It would make sense for iommu_attach_group() to require that the
DMA_OWNERSHIP is USER or DRIVER_DOMAIN.

That has a nice symmetry with iommu_attach_device() already requiring
that the group has a single device. For a driver to use these APIs it
must ensure security, one way or another.

That is a good idea, but requires understanding what tegra is
doing. Maybe tegra is that DMA_OWNER_DRIVER_DOMAIN user?

I wouldn't want to see iommu_attach_group() change the DMA_OWNERSHIP,
I think ownership is cleaner as a dedicated API. Adding a file * and
probably the enum to iommu_attach_group() feels weird.

We need the dedicated API for the dma_configure op, and keeping
ownership split from the current domain makes more sense with the
design in the iommfd RFC.

Thanks,
Jason
