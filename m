Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032F34C7B3F
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 22:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiB1VCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 16:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiB1VCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 16:02:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8923BD8870;
        Mon, 28 Feb 2022 13:01:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLOZgbuQzHiS6QZVpT1PgEWOlc7KbPjy5zKYY7gA0bNnSg9SsxqpoHGOZ4wJZhy6vVNEAI+rrnbH9POhJ1h7C6bINqU3RsBjtNVnURgSGTArIcP+m9NJjH46nfq3xrn1y/EqwHXiNlw88Kh3mzudSNsIxxN2NXbz47OF4fblc6+CxWm6cc/PS12uWWYZLk1cnMBPskSHNX2NjznT9TaecwnRqUPdG/unHaOe9Bn0qTNatV4G5P2E4m44soq4VdpI3MGop7KduD6oZKNS054URvY0YwlNyj59DpNphrUyjEqunh7WIq232B2pw2jdIfGVaCVlxWedYUCBzJFLlUYa4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bph2M9MlLKwMvj23ruPChKuizmQ5VHWG/6EF6TZEMYE=;
 b=j5sKwUAaILynpezYpqq47jd8eUq6gFvV08hlyZKPNPC4IvhE0BXopW/Hbo84g/4CT5qL0B8F1opXTZ26EuhMEkFynergYoLwO42s3EjXSBltOPgT+PM1oKXCsVc3xUP+q2FYR8C2VOHsXGNBbiqsgVLQ8lYK84Fw64X2dogUp1tJ5AhAE9sfBpl2OdfqbDCDQuVAkdyngo1NweM/AJKdSasf53chLFIpmKOK13qNQJ5onnGW10f8zwElOJILR0Rv1fBG2kKp7FeNZ4l13rgK/CY19C+X+ZEU9bKpeAwAH9YoxygrmaDPHMwtFQzixNLTUBexZtAyACdXB2xl3pb1tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bph2M9MlLKwMvj23ruPChKuizmQ5VHWG/6EF6TZEMYE=;
 b=GqxEj0CL4Mq/U7RBRAhVfHiCa1s8vAVdiTVTt7Sai9jeSveb0xGLv+X9N8w6QCcpg3+Y6w0flrB46qa0Z8zAVbwdCc3jNkorhKJzuepeo353fql34SbT3P3nqKebITqeh/XR3YawaXi1GhkrY6E2c1wgW2a9cXUyxQwcAXHkf1V7fUs3My/AQIGl3zmSUJ66Ed4eEEL2DQpOpWO1uz5Ll6kZ3A3cY3sc8rMwH8PKbUULj28wXr7pNiBT7lGBMnsKMIiwjmM07/m9yYi00gShjvyA0dV6VpV33WQCnF44yc6UDcgbtfKfIZGf9k/BkRQWeULTjBF9F9ZTakjV5jh0VQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6009.namprd12.prod.outlook.com (2603:10b6:8:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 21:01:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 21:01:33 +0000
Date:   Mon, 28 Feb 2022 17:01:32 -0400
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
Message-ID: <20220228210132.GT219866@nvidia.com>
References: <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
X-ClientProxiedBy: MN2PR01CA0030.prod.exchangelabs.com (2603:10b6:208:10c::43)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b68c0573-f929-4f72-8767-08d9fafd7ff1
X-MS-TrafficTypeDiagnostic: DM4PR12MB6009:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB60093E10B1C21198DCDA965BC2019@DM4PR12MB6009.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNkksJY9V9u0BaEiFlpjZoZs4SMKIaeAVsejWwMCVvFqDmHQJerWDtKv0oz209Ukl23lh9RL9doxeBXGGTf+IKfILzVuYOvonRVl/RCFefnMkirm1jVewHsW74oV3RzECrOEbGbPW1C1fgvt0A7XzdS+a5ir8KQPAQXYENuNW6dkA/f12nxklBmD5nEPgdwTqvE0lSDd1fBWuKlPzZjzbSzOa3wPi66+oglzJuJgzz57FdMa0UF1eacOBZacLa6Cn2pBmgo0Mfr6ugPHX+/YLTpiljluYw7UboTlQ0i5FVZ3Iq3dwprTASPUgXbyJXQvzLieZ90uwX51xWYGonYgJIiiNnDYT7A5idn0C1fpAizvLA8KcXVSKTmN3nkguXhfrBZ6WLCMos46PFO/jfHZfUO08SSUzo8DrCWGHPSkhC30FhlVKwZIE78fBdjgFtXgNZVOTFVK6aaAZXs4JRNtFqH+JprUiRyrPCsoqtlHKr7E/lC0mLWg6cy6s+k4SCxeHyAh1znDFOmJcT0G+x5s7P90QxjgntuKwOAZM3ZrOeVyjl6Xoh5sb0MMe4YhohXTB2XsYHOk7bD24WbRfGEHemVyleEUNcBFZUb74wkyGhGnZ6ru5xa2/UsaC+7mElRI+a+q6oljaz/h0Y6GGzBmHAQRIub+6xcfYkJcKRNGL3VXZ+Mx4bo4nRmDIZh509FQuEmgGu5rZRJPifCNlbXWbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(1076003)(4326008)(33656002)(5660300002)(8676002)(2906002)(66476007)(66946007)(2616005)(86362001)(66556008)(6512007)(6506007)(53546011)(6916009)(316002)(54906003)(36756003)(7416002)(8936002)(83380400001)(508600001)(38100700002)(6486002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFta0MADC9rgoYQIcAPO8ONhGbJz04MT2ldxzErZrhGfvq8VsDcUdPAoDGSP?=
 =?us-ascii?Q?oVj7fCwbDAPupuMKQyrGA1SmzSo97sK3u8EwziaT5We1ivL8xFtmd8UjH1D3?=
 =?us-ascii?Q?MFyxe2OZl22YaSx/3HAz01GnkoCv4pWRlE+dNHqmwES97ic/6Hzhi06ZmWUZ?=
 =?us-ascii?Q?9YTqjcrRUX2NdPh70nw1WVJ7WMrMw4NS5cdK4vZC9PaiDpUKIn+9ty+qDbVE?=
 =?us-ascii?Q?2RFZgBd+UKEWHjWZbWrRnnjbQtMLQ1geGvJeR84EDRm8kngerfYZG/801zF1?=
 =?us-ascii?Q?PEc/WHLqQ3jKfIFFo8MbCgGq2nXUYqjFe5HcKgiv5ztkX73H5i5UIOZs3UJt?=
 =?us-ascii?Q?X3cobQ6sJYGzrbVFm7r96EbaTTSlauv7b7t9sRwdLz15TvjhjrNor2+PC4vL?=
 =?us-ascii?Q?PP5NkFSh9sQI5Ay7K81Bqs9Ssy/ZEfu6V2J7vp3xqMcFMqncgkUEWVHkp40s?=
 =?us-ascii?Q?+ot2kIKw3l1t/rHGGN/ruiPCAoOX4f0hqZnEbfRmrKX8JcNHsnqL9GSjINuE?=
 =?us-ascii?Q?LRsf8yLoie4KjxWNLAqEde86LiXqCGi46rLQMShtkyPEKRiQgQw4cZptfpD5?=
 =?us-ascii?Q?xM+6ZOQ0ab9I7cPNRizsYmIXtz+b1ArBXQzPCV31oZ/8wNVyyoBMqYzFeM/5?=
 =?us-ascii?Q?w34sgZ5zEJ/jn7LUVc4YH7fztgWalyyrHBMzAYrwY0epYLtQiaJEaqQYwLCQ?=
 =?us-ascii?Q?3S4U3yBiHBRpkrC82cF97GgH/tfo+VmVSObzM5BgUdiAAddPHGOx7REJC2Uz?=
 =?us-ascii?Q?Ko1M9V8N2sS9QN37ZePkLKVm9bP6E6ubTJ+TZdkWzZruIHxTOLyAwCr9kFgX?=
 =?us-ascii?Q?oJTIgIGE5Fa6QPyAJt5QVeEbnQVntLVFkc8pfJcljg52Saa7/WjskujPMuuV?=
 =?us-ascii?Q?QemRfOoA+xxh1cRRY7MWbGn4jinudJI3hEafiF2tuQMhPPL3ffOTIkRgYGYq?=
 =?us-ascii?Q?kls8U0Rv+epudCNb+9dHsxfPKENvLppA4T3Sgs3b0he8GMb3NGiQY9UjYBuV?=
 =?us-ascii?Q?Xtc4yS2P61pkUkDPkT+U5XFR1GdwD3l9SqZIom+SzCoUnlwqr+kPwt6tpOW9?=
 =?us-ascii?Q?0Qj79qZ06/3lbWiCf2ifcE8NMobH3V5ABsOwEJwFEdzZN9a6cW+jtdZ0D2+O?=
 =?us-ascii?Q?8HQWpEdb6sQ//ORd/49Hn3zyL6OLVA+DSD8KGKZe5XiXGTwqrnI8peuDamM8?=
 =?us-ascii?Q?V07z665atery+clp0CrXsoBl1BHMk/44aN4BGxMRGZHpQqIzyd5o12Uso2qy?=
 =?us-ascii?Q?X9HljK+yfrckrUZu3icIol8KwuPJmZFrpFIo+W6n1uXuzpnBx+aA6kpawXjq?=
 =?us-ascii?Q?ZfrlDlHVEBrq+wwaTqCJ6OoUEuLbK9sETZl1NTA03WSTZH52fU98RNuxtwZb?=
 =?us-ascii?Q?7WbSxzU9DWDvTfZs+OWVMb0e/Bc7FJvU8qbAD7Ezf6jgN0rAbsR7mNdPq+h+?=
 =?us-ascii?Q?J9uuWrurIia/Q2ja/9HAzSAwWKE2NeObMGGy4jHh0lkAwW1VHurZ5sQCyMRz?=
 =?us-ascii?Q?SQF/XOWcK+pnxl2jiA/hMQjm68TxcpNwEdmP+fq/BOSVfuC5BGAhJmVMDg2N?=
 =?us-ascii?Q?XzR6JGJFInoAArtLQLM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68c0573-f929-4f72-8767-08d9fafd7ff1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 21:01:33.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1INLrEzhj98i/4zRBuSvP0iQS2eRMqSYQLxvWq9lP1p9vIN8v9bEKshSdqXOSHgT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6009
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 01:01:39PM +0000, Joao Martins wrote:
> On 2/25/22 20:44, Jason Gunthorpe wrote:
> > On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
> >> On 2/23/22 01:03, Jason Gunthorpe wrote:
> >>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
> >>>>>> If by conclusion you mean the whole thing to be merged, how can the work be
> >>>>>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
> >>>>>> in terms of direction...
> >>>>>
> >>>>> I think go ahead and build it on top of iommufd, start working out the
> >>>>> API details, etc. I think once the direction is concluded the new APIs
> >>>>> will go forward.
> >>>>>
> >>>> /me nods, will do. Looking at your repository it is looking good.
> >>>
> >>> I would like to come with some plan for dirty tracking on iommufd and
> >>> combine that with a plan for dirty tracking inside the new migration
> >>> drivers.
> >>>
> >> I had a few things going on my end over the past weeks, albeit it is
> >> getting a bit better now and I will be coming back to this topic. I hope/want
> >> to give you a more concrete update/feedback over the coming week or two wrt
> >> to dirty-tracking+iommufd+amd.
> >>
> >> So far, I am not particularly concerned that this will affect overall iommufd
> >> design. The main thing is really lookups to get vendor iopte, upon on what might
> >> be a iommu_sync_dirty_bitmap(domain, iova, size) API. For toggling
> >> the tracking,
> > 
> > I'm not very keen on these multiplexer interfaces. I think you should
> > just add a new ops to the new iommu_domain_ops 'set_dirty_tracking'
> > 'read_dirty_bits'
> > 
> > NULL op means not supported.
> > 
> > IMHO we don't need a kapi wrapper if only iommufd is going to call the
> > op.
> > 
> 
> OK, good point.
> 
> Even without a kapi wrapper I am still wondering whether the iommu op needs to
> be something like a generic iommu feature toggling (e.g. .set_feature()), rather
> than one that sits "hardcoded" as set_dirty(). Unless dirty right now is about
> the only feature we will change out-of-band in the protection-domain.
> I guess I can stay with set_ad_tracking/set_dirty_tracking and if should
> need arise we will expand with a generic .set_feature(dom, IOMMU_DIRTY | IOMMU_ACCESS).

I just generally dislike multiplexers like this. We are already
calling through a function pointer struct, why should the driver
implement another switch/case just to find out which function pointer
the caller really ment to use? It doesn't make things faster, it
doesn't make things smaller, it doesn't use less LOC. Why do it?

> Regarding the dirty 'data' that's one that I am wondering about. I called it 'sync'
> because the sync() doesn't only read, but also "writes" to root pagetable to update
> the dirty bit (and then IOTLB flush). And that's about what VFIO current interface
> does (i.e. there's only a GET_BITMAP in the ioctl) and no explicit interface to clear.

'read and clear' is what I'd suggest

> And TBH, the question on whether we need a clear op isn't immediately obvious: reading
> the access/dirty bit is cheap for the IOMMU, the problem OTOH is the expensive
> io page table walk thus expensive in sw. The clear-dirty part, though, is precise on what
> it wants to clear (in principle cheaper on io-page-table walk as you just iterate over
> sets of bits to clear) but then it incurs a DMA perf hit given that we need to flush the
> IOTLBs. Given the IOTLB flush is batched (over a course of a dirty updates) perhaps this
> isn't immediately clear that is a problem in terms of total overall ioctl cost. Hence my
> thinking in merging both in one sync_dirty_bitmap() as opposed to more KVM-style of
> get_dirty_bitmap() and clear_dirty_ditmap().

Yes, I wouldn't split them.

> > Questions I have:
> >  - Do we need ranges for some reason? You mentioned ARM SMMU wants
> >    ranges? how/what/why?
> > 
> Ignore that. I got mislead by the implementation and when I read the SDM
> I realized that the implementation was doing the same thing I was
> doing

Ok

> >  - What about the unmap and read dirty without races operation that
> >    vfio has?
> > 
> I am afraid that might need a new unmap iommu op that reads the dirty bit
> after clearing the page table entry. It's marshalling the bits from
> iopte into a bitmap as opposed to some logic added on top. As far as I
> looked for AMD this isn't difficult to add, (same for Intel) it can
> *I think* reuse all of the unmap code.

Ok. It feels necessary to be complete

> > Yes, this is a point that needs some answering. One option is to pass
> > in the tracking range list from userspace. Another is to query it in
> > the driver from the currently mapped areas in IOAS.
> > 
> I sort of like the second given that we de-duplicate info that is already
> tracked by IOAS -- it would be mostly internal and then it would be a
> matter of when does this device tracker is set up, and whether we should
> differentiate tracker "start"/"stop" vs "setup"/"teardown".

One problem with this is that devices that don't support dynamic
tracking are stuck in vIOMMU cases where the IOAS will have some tiny
set of all memory mapped. 

So I'd probably say qemu should forward the entire guest CPU memory
space, as well as any future memory hotplug area, as ranges and not
rely on the IOAS already mapping anything.

> > I know devices have limitations here in terms of how many/how big the
> > ranges can be, and devices probably can't track dynamic changes.
> > 
> /me nods
> 
> Should this be some sort of capability perhaps? Given that this may limit
> how many concurrent VFs can be migrated and how much ranges it can store,
> for example.
> 
> (interestingly and speaking of VF capabilities, it's yet another thing to
> tackle in the migration stream between src and dst hosts)

I don't know what to do with these limitations right now..

Jason
