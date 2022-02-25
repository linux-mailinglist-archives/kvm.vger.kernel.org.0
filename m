Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A734C4FE0
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiBYUpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiBYUpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:45:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F15D1B45DE;
        Fri, 25 Feb 2022 12:44:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXGFN2lOeMItwOFdsY+xGfonhilIaqtAAsgTDCCOvabNgYWCaaYZm3ZAYMV5nV+t2gMeda633BnryZAocf0voieA7SNWt2BdSJ/8SMTZmlo3DhfcHCSBwBLbq+6HoOUbkInwejJ99hQMQSZlvpd65TbsE2GkbNtA20HIDZ2ToPeaRPu8pkgQ4KPrYJm1fa4j1SZhtv7SmADc/bScmCbvnry9toCWL3WMKi6pMhEZZ/gW69Ft9uakTo8PWhaW0CAbvg3sJiQr51VmqiLV+ofggGILHD4FjtqoM5jltKvFV/LpS5lnIFXSJUPEgyIhgp9I6B0YZBpuP4N6o9BsFzpV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WE+x4qMgDuXIeaIuXMpE/8i1pIMcdBvUbU0XIPy/Oc=;
 b=jl0D5/5gCo7aBqI4h5/mVd3FMuwEZMgd5DgQqWrFiSe+NejmsjTKTMLn3JBXmCEXIpus9Y5W1ELU3Z39NEdt3ZSC5XPepip49UeIfrA+wLogQNp5WwCWOWaDjomrej4am7KpJJC9NeSKo8jRTAFcwtKFQ3ThOf0wwX1DN2Qx2Ggd2aIbJx3QzXQUzpyJz2v2c9EWMqsG+q+I+88jpSy3Y8PHXpOmc7nT34b1bRvE0Ni5O3x0Ec3wXpmNucpUbpORp2+JFESdNvepRpp/km9AyLUTHVgXBKq4H40VaEKAfQPVkjR6kNYroR7O7xhED8vtBYGmARdkeSQUdYHDX9tuBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WE+x4qMgDuXIeaIuXMpE/8i1pIMcdBvUbU0XIPy/Oc=;
 b=mLMBRy9VjrTsKn1LBBgmm8z/e5ypGJdFw5M8hrrLYwmu/cA0HyEA245N+xPi0dNPuxOFchm+X14y012tTNbU4YfoQSjupbqvBOIdA1MMVJUf1yfsqEbj84MPTUdh7/IbPE28OZz/xGZvpYZLHpZbCtiON/6omyGfqkmjCfA3NRRN1uOYURiQLQefFhsHxT52x/mS3JqMvIim8Ubn47gycXdtYa3Ki9+3Bc3B+4OlLmQ/fygm/YqE49pjum83E/9cX3pgm8WBJM1lX3NFF0BCWwdnR46m/eO3XrzdJFinYh090mlkH9qY2RZzW6LWiuqrUKEEIKnJ76+k7/jRRYEF0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4026.namprd12.prod.outlook.com (2603:10b6:5:1cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 20:44:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 20:44:25 +0000
Date:   Fri, 25 Feb 2022 16:44:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220225204424.GA219866@nvidia.com>
References: <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
X-ClientProxiedBy: BL0PR02CA0120.namprd02.prod.outlook.com
 (2603:10b6:208:35::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a970486b-195b-4a0a-0913-08d9f89f9c38
X-MS-TrafficTypeDiagnostic: DM6PR12MB4026:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB40260A7231BD7E9D83AEEDAFC23E9@DM6PR12MB4026.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGs10FAas4UZYzN0rVxkXg8J5pYkTRJR2uf9n6yuPHeM4rtGRRC0dyJGh/ENDtUybDsTo27+cFtHccQxqkeTWpc7osfzHWGaj/rE6caWcSnhaT/M1UWVi04g+p4PRZkh5nbCON9TNVir8iv9oZaPXvI/gZvGs2vJJrthNsGg/Kf9KTQDS5ftvPfhcGyPsMRQUGZtfu4hFYWK7ge6uMuDOknQchVwgTzKcaDH3IGTcbDAk1v2a7dgAZ24dqO1cJDAnmF5stJRyIIaPwrFfLARX+sMMQNTcOP/oPvxmny+mrYCI6pl7kiVY8uGnbqCNONK9BOD3noEiE2gTc3yMXP/iN2Ju6cygbioCjcqat/d67kLjzWnMMwR0yuclgDnG4ObUdYb74gU67Ayo3haHhPcSsZiWfgHjFxUohYOE9+D3D+PknxqsHbxdPoGxScz4CBvDlfy/DjA7ZmNFE5+kvD84hZashstxSkCDMKtS4bf//XCcPbanvEgQZXM8ZtUHBC/95zErcvueTKVZ1Lyn8q/h5j+vlQFZutK8xVmXb/xtgjcn16CTtOaMzNAuZI1Jaoq3pJWIFreeHgki5EfXFBQMaAvZFYbjen4wbXfCAesIKnB1iEItOR7bpmu7ixssxXONKVlswdNo6b9KzGA94+d6J2DfzXdJN3NgYcQR8hZWIMDckDQIxSatJyunK7cN2qM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(86362001)(66556008)(8676002)(36756003)(4326008)(2906002)(316002)(83380400001)(2616005)(38100700002)(6916009)(33656002)(54906003)(1076003)(186003)(26005)(6512007)(8936002)(7416002)(5660300002)(53546011)(6506007)(6486002)(508600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?POiM7fIwavhfqNESiES5gEt+PQmHtQbbsnzO8PXjfEXe5/R+ALHKXWoPH6Kk?=
 =?us-ascii?Q?HP1pR4KTyB9kASY6/7JvUKEEMnLNycNESzFMhNnRI+xteueKweHL94utpOvj?=
 =?us-ascii?Q?JJAxsM4yMXQbjQY2zhpKbDbexPwBvuby4wUep//JZPkH72E24EhL6zVCn+sC?=
 =?us-ascii?Q?fq3vyR4iLaoJ9bm1GeCkAKjUJ93VqaIIk1EIGgxxYUqYcXd1jA41B2KApUck?=
 =?us-ascii?Q?lfuo+78ASDkAjj19LWMJ4XEHxXJOat51dwKMmJUGhrzafW2SW0ZsuH4ZOHEE?=
 =?us-ascii?Q?16pROBmyn7GWIdH3rJOX4aEEGCJ25YM+aCl5LGqi29x6RHu1DODx/eUgjv/u?=
 =?us-ascii?Q?Vwqt0hyNyW+sW1C5JQ2Rk2FfoG57LSgRFj/todvR8A6zrFysLOkafZ9m4x/g?=
 =?us-ascii?Q?fs6WB0yD/NRkpGZDyJ/ysrMCMb3AGeoK6+VohREUSueaxzdeds8aNjUZQIMH?=
 =?us-ascii?Q?AyimlGVucu7A5LSDZBxc76bc69OhK2n4QimS5iZbp3HZY0vB2S3Vem0UHyZa?=
 =?us-ascii?Q?Tbs/m+zEw8eddIa6pqecSKZ1DidJib5qB1vO3ih/QBJ4Pgju/YWRLUlxJaVP?=
 =?us-ascii?Q?cmcmjiW2j1ZcVR29PTJR1WKsCeE5OQRaS/nt4PmoRJKXFtT597h8kIiBso59?=
 =?us-ascii?Q?81mpZcTaFu4PcZKYCRJHw6wxCi9jo7BFkXXiUIm+2MkWOnhsa7dhtC5DtgpN?=
 =?us-ascii?Q?uBhHSlcPkDdWM06KOuo9v5OOkyfYQHq1wsbnsEkg1RPVaiyXZUqqO54HFboh?=
 =?us-ascii?Q?xcEIk1oiv2ADf83d4kbhRqiMy3U5TmhjdNGMJRg6l1R276MjsI1Cq6VRim0q?=
 =?us-ascii?Q?p6qxrbP4aUQOR6jxSuYO4dXFQSCvNoyt8w2Ew0FKlGncQq9rsBOai4AUDKuO?=
 =?us-ascii?Q?VxiyG93+PTqcsLE/YiswU4+vUNEmJTU7Jn96BsEhKr8LYVEWrgai9ehO+2ig?=
 =?us-ascii?Q?IF4BBSbFNOoT4cSqSTv6Ajob5z2kT0jevZqJL62wKm8GwWaXxEMc3tPJwcqr?=
 =?us-ascii?Q?jcgR+qmy5P2or1ufLVVMghOyWOSLIKx+FFbKiI9FD9pVFCyu7EfoSyBQJSff?=
 =?us-ascii?Q?Wsz+C6K/g9q36KIPIrBRefOLoCmSRSSX11tWTihzlKNqMDCEvd0KX/vJS282?=
 =?us-ascii?Q?x5JBKBUdmJBvfN/+GSOMrKaL/PODukgHrqSQ3NchGgmCAnywxMmZf8D0Laq7?=
 =?us-ascii?Q?Yq9OFYcn4resNytWE/NAA1V75H3I7fVAgDkD7y/dth46x0bloNzyON37Qwyp?=
 =?us-ascii?Q?j+MNjg0vWVu4IYm5LJqaeMASRMPmZ+MiarvJCEVKksvNK4TGefVh2+lTlrHF?=
 =?us-ascii?Q?jnRCZBNiX4+n14eTrRLJLaUcD6hiFp7lQ1QhHSEVMwiZDQSimcPftSIAxaUn?=
 =?us-ascii?Q?MlAkUJtV/G7SY/hzly/ecWaz3oSK89QSDDLkm7tIcf0XqJaHK6ME9DcNiFBR?=
 =?us-ascii?Q?4mxQxZSRngJYg+emHeXk7zV106zCf2kZHdXDWKmxmQzDVV8ZwGTOv/wZh6q3?=
 =?us-ascii?Q?JF2SqKJYDtL/IbDVJTWkIrBovK6lBhsUZBmZd8O/EqpgtXZgb0S5kWNAEWkn?=
 =?us-ascii?Q?eU8BjHHUu3CJHzfCHi4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a970486b-195b-4a0a-0913-08d9f89f9c38
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 20:44:25.5604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1y3Mj9xSOKlXhFJgMFzfrydBX/KCzUQap6MlxDlnnAfEiohE5J6HgqfBgwlUjauw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4026
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
> On 2/23/22 01:03, Jason Gunthorpe wrote:
> > On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
> >>>> If by conclusion you mean the whole thing to be merged, how can the work be
> >>>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
> >>>> in terms of direction...
> >>>
> >>> I think go ahead and build it on top of iommufd, start working out the
> >>> API details, etc. I think once the direction is concluded the new APIs
> >>> will go forward.
> >>>
> >> /me nods, will do. Looking at your repository it is looking good.
> > 
> > I would like to come with some plan for dirty tracking on iommufd and
> > combine that with a plan for dirty tracking inside the new migration
> > drivers.
> > 
> I had a few things going on my end over the past weeks, albeit it is
> getting a bit better now and I will be coming back to this topic. I hope/want
> to give you a more concrete update/feedback over the coming week or two wrt
> to dirty-tracking+iommufd+amd.
> 
> So far, I am not particularly concerned that this will affect overall iommufd
> design. The main thing is really lookups to get vendor iopte, upon on what might
> be a iommu_sync_dirty_bitmap(domain, iova, size) API. For toggling
> the tracking,

I'm not very keen on these multiplexer interfaces. I think you should
just add a new ops to the new iommu_domain_ops 'set_dirty_tracking'
'read_dirty_bits'

NULL op means not supported.

IMHO we don't need a kapi wrapper if only iommufd is going to call the
op.

> I'll be simplifying the interface in the other type1 series I had and making it
> a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
> enable/disable over a domain. Perhaps same trick could be expanded to other
> features to have a bit more control on what userspace is allowed to use. I think
> this just needs to set/clear a feature bit in the domain, for VFIO or userspace
> to have full control during the different stages of migration of dirty tracking.
> In all of the IOMMU implementations/manuals I read it means setting a protection
> domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
> the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
> (albeit past work had also it always-on).
> 
> Provided the iommufd does /separately/ more finer granularity on what we can
> do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
> at will as separate operations, before and after migration respectivally. That logic
> would probably be better to be in separate iommufd ioctls(), as that it's going to be
> expensive.

This all sounds right to me

Questions I have:
 - Do we need ranges for some reason? You mentioned ARM SMMU wants
   ranges? how/what/why?

 - What about the unmap and read dirty without races operation that
   vfio has?

> >> I, too, have been wondering what that is going to look like -- and how do we
> >> convey the setup of dirty tracking versus the steering of it.
> > 
> > What I suggested was to just split them.
> > 
> > Some ioctl toward IOMMUFD will turn on the system iommu tracker - this
> > would be on a per-domain basis, not on the ioas.
> > 
> > Some ioctl toward the vfio device will turn on the device's tracker.
> > 
> In the activation/fetching-data of either trackers I see some things in common in
> terms of UAPI with the difference that whether a device or a list of devices are passed on
> as an argument of exiting dirty-track vfio ioctls(). (At least that's how I am reading
> your suggestion)

I was thinking a VFIO_DEVICE ioctl located on the device FD
implemented in the end VFIO driver (like mlx5_vfio). No lists..

As you say the driver should just take in the request to set dirty
tracking and take core of it somehow. There is no value the core VFIO
code can add here.

> Albeit perhaps the main difference is going to be that one needs to
> setup with hardware interface with the device tracker and how we
> carry the regions of memory that want to be tracked i.e. GPA/IOVA
> ranges that the device should track. The tracking-GPA space is not
> linear GPA space sadly. But at the same point perhaps the internal
> VFIO API between core-VFIO and vendor-VFIO is just reading the @dma
> ranges we mapped.

Yes, this is a point that needs some answering. One option is to pass
in the tracking range list from userspace. Another is to query it in
the driver from the currently mapped areas in IOAS.

I know devices have limitations here in terms of how many/how big the
ranges can be, and devices probably can't track dynamic changes.

> In IOMMU this is sort of cheap and 'stateless', but on the setup of the
> device tracker might mean giving all the IOVA ranges to the PF (once?).
> Perhaps leaving to the vendor driver to pick when to register the IOVA space to
> be tracked, or perhaps when you turn on the device's tracker. But on all cases,
> the driver needs some form of awareness of and convey that to the PF for
> tracking purposes.

Yes, this is right
 
> Yeap. The high cost is scanning vendor-iommu ioptes and marshaling to a bitmap,
> following by a smaller cost copying back to userspace (which KVM does too, when it's using
> a bitmap, same as VFIO today). Maybe could be optimized to either avoid the copy
> (gup as you mentioned earlier in the thread), or just copying based on the input bitmap
> (from PF) number of leading zeroes within some threshold.

What I would probably strive for is an API that deliberately OR's in
the dirty bits. So GUP and kmap a 4k page then call the driver to 'or
in your dirty data', then do the next page. etc. That is 134M of IOVA
per chunk which seems OK.

> > This makes qemu more complicated because it has to decide what
> > trackers to turn on, but that is also the point because we do want
> > userspace to be able to decide.
> > 
> If the interface wants extending to pass a device or an array of devices (if I understood
> you correctly), it would free/simplify VFIO from having to concatenate potentially
> different devices bitmaps into one. Albeit would require optimizing the marshalling a bit
> more to avoid performing too much copying.

Yes. Currently VFIO maintains its own bitmap so it also saves that
memory by keeping the dirty bits stored in the IOPTEs until read out.
 
> > The other idea that has some possible interest is to allow the
> > trackers to dump their dirty bits into the existing kvm tracker, then
> > userspace just does a single kvm centric dirty pass.
> 
> That would probably limit certain more modern options of ring based dirty tracking,
> as that kvm dirty bitmap is mutually exclusive with kvm dirty ring. Or at least,
> would require KVM to always use a bitmap during migration/dirty-rate-estimation with
> the presence of vfio/vdpa devices. It's a nice idea, though. It would require making
> core-iommu aware of bitmap as external storage for tracking (that is not iommufd as
> it's a module).

Yes, I don't know enough about kvm to say if that is a great idea or
not. The fact the CPUs seem to be going to logging instead of bitmaps
suggests it isn't. I don't think DMA devices can work effectively with
logging..

Jason
