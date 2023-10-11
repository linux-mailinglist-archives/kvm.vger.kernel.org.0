Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E337C5403
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjJKMby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbjJKMSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:18:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BC9E3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lue0qiahHGj+tqR7XhusVongg8+X5N+Kt0gWL0gyUCe4ZQ4/XYCg3C/gc3k5bxgx1asuTvuMPaZfizkAYs+tu5FdGJ6rezXbvj0bhLZZzsVjphWjTtEdzkBbOcUH01TtoPtha4VW+3IzAlsu28yujEZKnUN6sbs9k/WUHJ8Kyk6jifYQ+yTj3y3FbjV/VWTzREV79FWnSt2dclrnvz0nGO8DcCGUX1e3BCXfObvvDrP0FC5Dyp3PueQ+Wab7S41sHXc2j44on8c4V583y2oDMoTGSahxfrzrVV+pO34oNaQTwBTAyDIMxH6eltojIxPQKLNI3J+YRlDXVibMyFmh+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uJLLjW5Zwywgzup8JHT5TwRzzuKdGdYDrvLBGYuAr8=;
 b=FAmVBm5hx0OTgNiCvDdSp6qHTxtXcjHn1ox3IwhARLr8LLu0Yw+aUsGMQSD9PZpDKqObc9XoMhJeVZk7lvFsRlfGywZLzC/3L6alVVtPEpg9fLDHxKfumlo6mfB37nCSHMSnVER9WUtDFgUppcCZOAW+xodU0W86NkM05pDoD5KVoh3KmXOYNu6GycKimVW6W+Xjt4bUjQVSMAEhCORd5SQk+yfEcu3j7f6RM+ElD1TbWuZuKs7c+ZRAibPCT5LuOTCP7owr3BHf4EZxY8Nw9MlCeBwPy+CJUXfc+jqltsZ/wLh5D54uZFeSIfl27M+/fpXnOSpQWdGBOhwq3Zw+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uJLLjW5Zwywgzup8JHT5TwRzzuKdGdYDrvLBGYuAr8=;
 b=f4N9v8qXZcuyQPOuCp5RmhDJqkJyOz79qjCseQQKHtR/Xs1ws0eJslBhKvmxh7p2b5FyBzEd8X5GXKSRjvqReP2vR7RZhI4wVeS0Sb4pnExqi9Rp1kF2Es7eGoFWXoIcGVKcIsRWoVWEWrvg6CWxARctpl73xzhoXwg5ZN27vJFWDuWydlQVRQ2+gJ544LtUxxQmXSXrV+U9v+6+y2E3rVf6HiTyZYiOjBA5RAHzFQjseWkzkK9jvwPsBWxVI14It1M2r17uCiuo2FKCGSxH5tg29iiUnXZZj+kBPWDehoL/7FAXvUDxlm1HWhNPdbjrhxF1xKeRswDj50B77ifh+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5424.namprd12.prod.outlook.com (2603:10b6:a03:300::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 12:18:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 12:18:50 +0000
Date:   Wed, 11 Oct 2023 09:18:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011121849.GV3952@nvidia.com>
References: <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231011040331-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011040331-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BLAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:208:335::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ace117-d4e2-4214-80c2-08dbca5439ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSIyXoSRx3y+iyWL8ljAwU4vmyRJQpMut6lzBq/Ed0Nf0GuzoV6c/h+zQhc1HTMv1r9LJQ4hX6nfdtME7QDvjANmp/UmKr0+LVBDUOyj7mPYpVj6Z8YxcTl/wNRKsM2v+wge0mNeiG/f88A825K1uEnpfOyQNiOl4VFJ4s2hP3f5BPhzuKlYXgMVCEtRxdiphNdc6PAJEUy6ENEcLYB9ia+ZV3KqBCnVkXZn/aUuQCIl963MTuUNrpHunHqdLNyeL0J8A6r1KBBPqIUJ5DEHiKOK3EI78Cxpc4qxRtQOZuojWFj7CbhS+mTS5/ylHnN3+0vbbDQrNVxhZrQ6ZFIK9Ip3L5ToM7AVEoyyyfk1rJO+Efia5nO+GJcVtuFKXvIu/nPKJmZCYrp0pp47+KTB8rf8cRXh/Q2FBqKFayciLtD97F4iHXR+wXRGqzOg/6ZtFYi6fYMIkJRKB5KaFk1rrVy4l0HwGTjP7XbN4tKXdFQxWdHOY7gGfY4l2rHhmEEDdJMnv1d48X8ZP83/8CggLmSXpH57nCV4VkNM01uSef4lUIsBJD5VywW7h6to59Vx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(107886003)(36756003)(478600001)(6512007)(6506007)(38100700002)(54906003)(66556008)(6486002)(1076003)(26005)(2616005)(66946007)(66476007)(6916009)(316002)(8936002)(41300700001)(4326008)(8676002)(5660300002)(2906002)(33656002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sxtujt91J8H+rXiT3myLxFGEVXfC8QBqMMtyVD6CQ2gh5/qX98dKerhw0+1V?=
 =?us-ascii?Q?JSRzwp1SonSgp2ORJP5ygPM5KsUjzJUBccf3kp/oD7zz1WbHOyDiUkTmhKq4?=
 =?us-ascii?Q?OzRtwvN9i+vBgfxWr5C1deKTMgBOyQ7hwGseIBiRknOhOvJjBt6EuvGFYQBZ?=
 =?us-ascii?Q?tYVn4qG/gxMF1crBCXZKf54ug5zmN6MXLCmMiHkqHtBAN2rkFDd7claQqtQ/?=
 =?us-ascii?Q?mHJ3ZQzzJB/TSnBuYZd1cYGMtJo88nGpGA1tku/4w9ib9RhvZS9ibOmNKcb4?=
 =?us-ascii?Q?hobeXNBJgqNcsXa1mNCARszrxbMszOH+MsUuXXq2GMID2g8iSsiIm7h3NtuM?=
 =?us-ascii?Q?3Jv/hx7aAHnfa0IvRsEicIazFxJAkl6IA08CHI0P1saaI2a2sZFZEWs9//OI?=
 =?us-ascii?Q?y8ygt4vez1028zhgNC8UuX4/sAeX7jkaZFI7XC3iEy21YqMoENxUkL/d/v34?=
 =?us-ascii?Q?08cCnYXfZJNCd3RpWLHWhITnCk6R2SJkbcIYgZiSe2DNrjCTHI3q/NRaAOWq?=
 =?us-ascii?Q?4Qetz1N9efysi65/XDSLLxozffOwhBOt/hNRVntREX05rJ30hVUq65Gn35aA?=
 =?us-ascii?Q?fmi4d+zPaHMh4vFFaPu3g3n5JUIe6FGjj1AWH1RkqlWuOUrBQPJgMDjDmSnZ?=
 =?us-ascii?Q?7kKgrMnjKtVwkpn87PMC4AlHbL3XZkaRXOyvA2/0nVWMGMMs7fhHTIXXwzSG?=
 =?us-ascii?Q?Tk9cHIQf4YZTa1qCIGU4Ykokv3AJegowfsuE44xYnySoO9B+1BQS+jHJVmtR?=
 =?us-ascii?Q?sPVV0EX+54HIeHSw/0ZLfy1TFFayFYhiS3/Qh+NgRrkNtIhk2LNSwXzVAyhK?=
 =?us-ascii?Q?Bw/5mhMYmQXv1PthYB7CYhtz57TNkX5MIZEGssNxFuWAGoCocmWTX3qsG7U/?=
 =?us-ascii?Q?Fiy8rghXgJmXADg4UvveIwvksIF/JQNUhzQl6L15zHuC3gg6RoJip9rO0gS8?=
 =?us-ascii?Q?4ADN7lcHcdVvHEFA75kTaUprZ4mXLHLNjCEjLqo0Kvj9zTRbLETYx7CH/Tta?=
 =?us-ascii?Q?NVXz1hRz9Ri0TFpDWCoCmOyDhPuEdVy3FrbcNWJqQb0FeC59aSfx/izVrMcj?=
 =?us-ascii?Q?SXa7/DeA3yWpTj7nk7cqi4Qe2gm6zDQ8HkWZ9LM4I0oGzWARjH2q2HEan75V?=
 =?us-ascii?Q?ejlCgkNlqwXHFIs2vbPWa7v18JhENUHdiLfG5U3U2EOn0XvRWCs7HPTfFZJ7?=
 =?us-ascii?Q?fg3DeDCurhw+Yis+RzNqeceOKAz52tYZk5ThZ+wgHISWUgKvqkb4F1r6pyu4?=
 =?us-ascii?Q?/CqHJGWOXwW9p9c2dp9CwSY2BXGxF07fap9G7Vi5qBVQa3v1oIOZ+2cpNMHq?=
 =?us-ascii?Q?dvjpOZF4PTxR55xylbMaebpWhhIlf5NRpTS9/YsKP4V2i9nblSv6YfwkUKnq?=
 =?us-ascii?Q?S+TyE4HgIkAgmboW1FO9bCtMkY/EtXRVE+dJMJ3igxoEcLrCazV1YuM2jZVC?=
 =?us-ascii?Q?M4DJOShUOrfQHzYIZ+cY3wDC7WeFjyuD4VX2l1V7beKL/ZHMCoivOWUn7xM2?=
 =?us-ascii?Q?jO3adm8VhlRTkqNgRQA4HykN8/3IdvhjOqlsypBxJgucj0CnqLv/bO3Ujl96?=
 =?us-ascii?Q?UoyVhUfcsAy1hdiXgwZmh+7jtFdh4pCC5PjtMhQL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ace117-d4e2-4214-80c2-08dbca5439ec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 12:18:50.2873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIIiV3j1hefymNZbpDdu6962gQb38WEIlTMZY5Ke+q4m+n88GebqmVXhc8E3W8Vr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5424
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 04:10:58AM -0400, Michael S. Tsirkin wrote:
> On Wed, Oct 11, 2023 at 08:00:57AM +0000, Parav Pandit wrote:
> > Hi Christoph,
> > 
> > > From: Christoph Hellwig <hch@infradead.org>
> > > Sent: Wednesday, October 11, 2023 12:29 PM
> > > 
> > > On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
> > > > > Btw, what is that intel thing everyone is talking about?  And why
> > > > > would the virtio core support vendor specific behavior like that?
> > > >
> > > > It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
> > > > that implemented vdpa support and so Zhu Lingshan from intel is
> > > > working on vdpa and has also proposed virtio spec extensions for migration.
> > > > intel's driver is called ifcvf.  vdpa composes all this stuff that is
> > > > added to vfio in userspace, so it's a different approach.
> > > 
> > > Well, so let's call it virtio live migration instead of intel.
> > > 
> > > And please work all together in the virtio committee that you have one way of
> > > communication between controlling and controlled functions.
> > > If one extension does it one way and the other a different way that's just
> > > creating a giant mess.
> > 
> > We in virtio committee are working on VF device migration where:
> > VF = controlled function
> > PF = controlling function
> > 
> > The second proposal is what Michael mentioned from Intel that somehow combine controlled and controlling function as single entity on VF.
> > 
> > The main reasons I find it weird are:
> > 1. it must always need to do mediation to do fake the device reset, and flr flows
> > 2. dma cannot work as you explained for complex device state
> > 3. it needs constant knowledge of each tiny things for each virtio device type
> > 
> > Such single entity appears a bit very weird to me but maybe it is just me.
> 
> Yea it appears to include everyone from nvidia. Others are used to it -
> this is exactly what happens with virtio generally. E.g. vhost
> processes fast path in the kernel and control path is in userspace.
> vdpa has been largely modeled after that, for better or worse.

As Parav says, you can't use DMA for any migration flows, and you open
a single VF scheme up to PCI P2P attacks from the VM. It is a pretty
bad design.

vfio reviewers will reject things like this that are not secure - we
just did for Intel E800, for instance.

With VDPA doing the same stuff as vfio I'm not sure who is auditing it
for security.

The simple way to be sure is to never touch the PCI function that has
DMA assigned to a VM from the hypervisor, except through config space.

Beyond that.. Well, think carefully about security.

IMHO the single-VF approach is not suitable for standardization.

Jason
