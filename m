Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B9E3D7E3B
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhG0TDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 15:03:22 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:16047
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230136AbhG0TDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 15:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mENs7yBmUzirUIZZEY2hkYFYwVAgxRH82sGcfOpFcD8kT5NnK3aASAoEL0s32U/OjiuEi6eEemkxcIbWz+In27r4jB29IMAi6X9vAuOLHFMcf7aApIIkcqhsqmkbh9jB3Ro96I8lfzgTptNphSfOT70PxWxWOeKln/I/teeJQHejKXoKE17mHZrUP1nP+zpgBbEBOq3VGjDu5AvxUU5JtVrEFAsHb+llJGxdVN9tnes4m4c731zQkWaK5yEx1zIs+P8Kk1P1vyoD5nUDUMNJ9ZcctBfuwtaf7ZDdAWqn9FtXPSqE1hU8DCVfFLQNujkr+caemzvqiVyGhVjLiTqsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P88uJkv6jYTbKQVMWhRCk6CtYxCf/Xt4Cw4kFYly0UE=;
 b=fiDf91bI5GqLjlTEL1p5b9nMPzVY/L8qpU81ojQKQfwpx2tl3BgrXVMso9YMWo36VpObIoPjWFCb3hM1MP5Rjl53Zih8peDmpmUTEqEGGCacq39qV2R1bFM/l0ycdbajiklAkuJlMdm3waYUmVBEhVFp2Ghoq/Y6MqRQRH8AtH3mXRYnyrhsgiavnvZKzqM+3AdOqLmi28xghEYdIpNAIgLV2UgikcoLxaFzX/r3M5ab3KalAGop8hazHAAisyjf9AXcxuyOh5yYYzHHCcPPsq+yPht+y4A/ty/BUrQ2ZlHBV3EURt2v6mQIHAUMKOnsE1Tgja34qm/7mV9VmAu7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P88uJkv6jYTbKQVMWhRCk6CtYxCf/Xt4Cw4kFYly0UE=;
 b=Q/nN+Lollq/vB1qufeoQUPMMoAWVfQhPBIQl1bWrZuuipxTQDceuo9mxiPfR5YyyWwQJ0PUdbp6/Yc7ktzzLG1JVb3Qaq42w4FdcZCCeIc5gtQ9trSZZUghktiDj2wEkJl5WIu3qZfNIG/rqnKnA/+6OpM0YtIUlkIBxbIZOyYwmsFX2CXmgAhz56JPTzlhGDsytKPljmdw0ArSbEYHNkvIqEBgoQV19YUrpILHdi3Zo+G14FwnT+8+//f2uM2J5mCM/K/cUbWFnIoho+o6xfGfPEjsWIM8UsKiYQXLp4cFym1F75smRORjBdDCOiup4SMfVF5YwXo/XY4Cct2ybAA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 19:03:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 19:03:19 +0000
Date:   Tue, 27 Jul 2021 16:03:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Message-ID: <20210727190317.GJ1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de>
 <87zgu93sxz.fsf@redhat.com>
 <20210726230906.GD1721383@nvidia.com>
 <20210726172831.3a7978fd.alex.williamson@redhat.com>
 <87wnpc47j3.fsf@redhat.com>
 <20210727173209.GG1721383@nvidia.com>
 <20210727125309.292b30c0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727125309.292b30c0.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0124.namprd02.prod.outlook.com
 (2603:10b6:208:35::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0124.namprd02.prod.outlook.com (2603:10b6:208:35::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 27 Jul 2021 19:03:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8SMH-009BSW-9Q; Tue, 27 Jul 2021 16:03:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff71bc90-efaf-487e-c83f-08d95131322c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51271DC51578E00C9CF5CDD0C2E99@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6xQ3Ye3G2UAxznusFflUu7xnnhbkGEa17o+N3TTKO5Z+o1lDgo9/ZlvyOao2eC+QzXpYAzlIpkwS6q6O1K91cRxnV+3X7AS7KBdF3pTzLhzcLjNlvjNXWsGslqMM2DhBbGgoaGNO+J+MKcXg6+EOYfu+HyE14VwbHZKIxLAK/v6fQLshoxKmx80juGvsp7pPReF25KeYLZ9iVdv88Gj/xUXYZ/vrlAd+p5GtV2zP9bbhfE6EkbYphYzFMmzB+jTKZl8u3H3+dskIG++7CYaVsVdVAqnZEHGufIwFiQe6N+GvfqYNH0Sqhv89vqMw/nzNoEbQ8hyddOQ+ZTsAW8xtiPF1k3teBK1Zr/PALNKdTWdUKBAWz77n3I+0j1B7kLZsxTYD8HUkQSPOrS3X39nhmZuSGu/zpR0NBKPG6ANbp3bIBnU59EuaNPu1Za7rVi2DrgJKwOBQuSrVikNEUh2e7JTDpzBc6w9FL7M9WyiThyLJCc7m6RHa5VZnDzmtcZycpMuuvB9bIDWF6uCoiRz4TBDNXrVP53GUcRmqAkRd4StDCm3QeEiGIpspu3foNLY1PL1ms6hb7DOz4CUQ7xwuiEYKxqpsLvdvV/V1Snk4Ba9wzkeLijgoKY8R0K0DHb6PWRgG6Qdc+ZdL0l9SKn/Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(83380400001)(6916009)(316002)(186003)(2616005)(54906003)(86362001)(4326008)(36756003)(5660300002)(38100700002)(66946007)(426003)(26005)(9746002)(66476007)(9786002)(66556008)(478600001)(1076003)(2906002)(33656002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yhQa93qWaJ0PybL9MB4FYyzV4zLbbGr3TTRqHAqE3JCVBsyIdG3fL7RDTVZj?=
 =?us-ascii?Q?DCsOnC/nLYtRRU3yh2NCMFsNjAedanb0Rj+FDQN28wFHVtt8CHcKzBG8pvUR?=
 =?us-ascii?Q?ny5HpmT4D6+7UKMkXVD1Sg21Bzu1BBmhW6JiVy11FCljkmbZGsLIlkcOHxQG?=
 =?us-ascii?Q?dXewAO6BZHVUweOFHoL8cXyep/HYBMMqcS1U1X7V+6Qc8RwFkhYs0oOov8CC?=
 =?us-ascii?Q?ioCnpC0Iya9SSwsBg9itAy010TpaMM9vrqX33IF8zcdRTXj0a32H2+ezCior?=
 =?us-ascii?Q?myhaTkbbosdiqbbjc3626PhpvY2RioNmsrcCbRCk57Z2iraOfgZ7ihPEbG7C?=
 =?us-ascii?Q?Y/Wk3v676UqQaNHAHsMyjd8W1ZPbkwO8UV4K6a8nIpIe1NdnxQmzpieP9oxD?=
 =?us-ascii?Q?AO/lU46atJ/1dnNIiY5wQ3YpDXprR2RahwDVWJUKJZ1Tk9ZlLpRL+N0ir6R5?=
 =?us-ascii?Q?c+mt7HC6sPOTE/ghUhGN2i4TCHZgGu0L7r53IM+wM6Uk2MkpdHroUgDke7t/?=
 =?us-ascii?Q?pnSqdgN8ZIpHsxG3SBBjb14Bzt7mIfl2CWotuLcCtWoLICxJKWxJsQirlFlZ?=
 =?us-ascii?Q?49BBTnxxBw5ex4OGW07uDuM+YKjWXeVywxQWYkFy6EwubC2UtrLoCbvZW6Ri?=
 =?us-ascii?Q?VXGg3L5+KUNZoOTp+lO8bW9vmUglaVszXVmFBNvhD7qwVpOBIAL+z9IvQXv/?=
 =?us-ascii?Q?E5hwOCFxTKRonFlGLj1mWmlKAauBknQnCBTYAW8GXqSfwajCCaExxH4pjCFY?=
 =?us-ascii?Q?78kOCvn/tWLPAzQ6MYLFea3k6pv6jg50jvEgd5dwW+q0KkwyYGlrvzQ4QClh?=
 =?us-ascii?Q?QFjb/5dUGcpNZNwfGVHppvKk+JIT9evxr7Fq4PfhSlBHKK6ZdiKJ3wRXE+Qm?=
 =?us-ascii?Q?8dNsxZdeB7X8G8l65hlWO8y0Oc775Fr+8s+ZRZfRWSjophB5Z6kClTRO6gXl?=
 =?us-ascii?Q?wS3jAVD0E5Hrj8x17yX9wQi1K6VZCs+ycmhl6hzj7QMuOvtJqLXWh4eXct9N?=
 =?us-ascii?Q?MQWTEoCm444kpImSOzAoqxoW2nqXu9KbiKEBWl9VznOL5VHT004E5/7MLUF1?=
 =?us-ascii?Q?22aL1d/Z3hv8z0J/Ts5VapnS/KJKQgQe8qYWX1wpp1EtZ/Cw+5bw2b3U8Pgb?=
 =?us-ascii?Q?jMB08BwHpreB4i9r0BvJpijgZEQBSHBUIfuNI7riD4Y1hMei2UC5PEG2oq4L?=
 =?us-ascii?Q?FvO2RIXiLeXXCMBWK1fC9HkrKrxB6OBVqC0Tnf0fl82UY+pAMvJgqCbsUBcM?=
 =?us-ascii?Q?2zxGO9d5zjMgOWUTTLIOcKRsfhJCQCSF9Jn/WrgQaUYTOPQN/+05h9vr6u+v?=
 =?us-ascii?Q?5e235FpYy2jq9gpIjpSg06O0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff71bc90-efaf-487e-c83f-08d95131322c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 19:03:18.9207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT9G5O6qUZI+OsxLGpGSyYPHeEIvUd4zm15uP/qoNYzb2eLiPjpNys1xatj+Bvkh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 12:53:09PM -0600, Alex Williamson wrote:
> On Tue, 27 Jul 2021 14:32:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jul 27, 2021 at 08:04:16AM +0200, Cornelia Huck wrote:
> > > On Mon, Jul 26 2021, Alex Williamson <alex.williamson@redhat.com> wrote:
> > >   
> > > > On Mon, 26 Jul 2021 20:09:06 -0300
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >  
> > > >> On Mon, Jul 26, 2021 at 07:07:04PM +0200, Cornelia Huck wrote:
> > > >>   
> > > >> > But I wonder why nobody else implements this? Lack of surprise removal?    
> > > >> 
> > > >> The only implementation triggers an eventfd that seems to be the same
> > > >> eventfd as the interrupt..
> > > >> 
> > > >> Do you know how this works in userspace? I'm surprised that the
> > > >> interrupt eventfd can trigger an observation that the kernel driver
> > > >> wants to be unplugged?  
> > > >
> > > > I think we're talking about ccw, but I see QEMU registering separate
> > > > eventfds for each of the 3 IRQ indexes and the mdev driver specifically
> > > > triggering the req_trigger...?  Thanks,
> > > >
> > > > Alex  
> > > 
> > > Exactly, ccw has a trigger for normal I/O interrupts, CRW (machine
> > > checks), and this one.  
> > 
> > If it is a dedicated eventfd for 'device being removed' why is it in
> > the CCW implementation and not core code?
> 
> The CCW implementation (likewise the vfio-pci implementation) owns
> the IRQ index address space and the decision to make this a signal
> to userspace rather than perhaps some handling a device might be
> able to do internally. 

The core code holds the vfio_device_get() so long as the FD is
open. There is no way to pass the wait_for_completion without
userspace closing the FD, so there isn't really much choice for the
drivers to do beyond signal to userpace to close the FD??

> For instance an alternate vfio-pci implementation might zap all
> mmaps, block all r/w access, and turn this into a surprise removal.

This is nice, but wouldn't close the FD, so needs core changes
anyhow..

> Another implementation might be more aggressive to sending SIGKILL
> to the user process.

We don't try to revoke FDs from the kernel, it is racy, dangerous and
unreliable.

> This was the thought behind why vfio-core triggers the driver
> request callback with a counter, leaving the policy to the driver.

IMHO subsystem policy does not belong in drivers. Down that road lies
a mess for userspace.

Jason
