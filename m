Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89BE3DBB5E
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhG3Ove (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:51:34 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:63905
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239030AbhG3Ovd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:51:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqLP5SasGleBUBjT2sjyu8srzowoKWAXCnuVQpfgw5x4ny+f34uq4kJ01FJQbtLQ0dQvPMb/xSnPQIz3M15ahC4Z4yiFYFBIGqxrt/npXJCf8PTWrVnhk1p35TwKsa4skXdwdT9O3Rl4/xPcOj0L9CqM7XX96bfiUuuSRYUbrEVi3CKNi0rzIWb7tX8OCy14fQiNL9QTLjOsIUpz355mAC7gcaoabQmH1ghMszOd6sb9Nl3J7hRLedC8ozpePa/VJop5X1AKWZJd/ZdXZ57YbW7PD3aiLoz23OoHiXpR+rVpb6XoQhZgykeL1wwnFhDIu23sKyWjoVF5fHeY91xM2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2T0TtuTtkMU/Ere5q51XYXdhhrPKqVQF5ty5Kkcuc=;
 b=EyGIzGBeBNE9edWRs01ewki5HWyX/MnKr7oBe0qgQ6ygngGmmikgULc/yb6JijFiZO0OwdYtksTiOs67lP6PyY681nIzmDhVDoVm9uXuGpogi1N5hMLNNEnK3/WOGpqcwFCy+O2He2Npd9wYlALp4v1+p87dSDjjA1iBt24WqcWoOpYscia3yh6VyDfqYjRlXK9oF79QAfxQ0T1v4nYh+FwBklzvws2389dw28zVPb8DgpTCGnueh4ZWGTnvSoNSXah51NmkUF3QYwk1CiulytnJpaEPLq3H5GxETiRQwHBfDel6XDpWbx5MFAQKu7PgdeK1qKuc5CKxsokC16iiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2T0TtuTtkMU/Ere5q51XYXdhhrPKqVQF5ty5Kkcuc=;
 b=BxRi4X97QUmPDY/RS3hPW7/ksYcdJEtm9igu/2amuNutmp3uXHuAlyajL/UqD3kV+vIYkrzasNQZCxkPYyhs/O1+WVosZw9wrefdfZvPh9y1AztU5zCh7jcQGEqW0KolEp/pXh+0lpCVX2HjpHQo+hFrT+NOKF1U28J5Pcxgfb9rH4RClGxE6lytPb3yH0BXJhP3M19RIJt35nz9Qz+05GeswCA+YLHcV2DV+Ja5w1VSCK9cwcejZotdhuvh/3hzS6XG/uMotnvvZ/zFe25zPhzkQkCZEd2YqZ095M9tjNLpqK2S6gLYA73tidw//Di4H2S51d+J0reM5QLFMF+98Q==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 14:51:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 14:51:25 +0000
Date:   Fri, 30 Jul 2021 11:51:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
Message-ID: <20210730145123.GW1721383@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP4/KJoYfbaf5U94@yekko>
X-ClientProxiedBy: YT1PR01CA0092.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0092.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 14:51:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9Tr9-00AmVg-3Z; Fri, 30 Jul 2021 11:51:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 602a5d39-f6f5-4ede-09ea-08d9536980c9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53618A9707DEEBD2C336886EC2EC9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQp4ITE1BdE16Eabph3SGea6gUuSr7NeJ3Uu9XZztAJB5XRkRp0YbrUD0oW+B/jlehw4PDlMREzrqI7q1Y1KSMM9yOdd/tOhlpBbf50RchaPasWX4wgrCBX5XyK6D9UgBfgUka0mJQ7V3HorIw8hJRfsT4U2jtRW8e6AvJd++Qbzk+avXhii+WSy4fZ8+YsmkAqSLLfCK2RfAwTOiwKAKdlW8hCL9U+ZFdtYu3miZd+Kf6EA/ZnR81kZ4XKxyzmlq2NY8L9LBYCMxQWlxYT3tmduah2L2JAIpwW9TEaR1+9kf5foigIhScUSgsvATcSnBm1WsiLlQDOFWM8tn1KdJf03/Fep6+MajiIs/qpGKUwMLGq3wmRhK47Pj+pc03mEU9Ylsyjl3cJn3LBlEv5d00jAR2+DhDiblzJV1MTaXsJOIuuzUYBBWrryl5WVyfT4UnMlE3ZFM/rn4OMyb+FhtApaLCW0hxf7quGwcYX1gRN85mFAHCN8GgdDrFAnjj30m964JPlxOImcQIknMSY4DJDI29O0WOt/WOh8NSZAJCx1LEQpRMLuvpkEZyccm9yfM87yk4jrzNp+3lD7bnd4bvAfyK0Jv1jq9X8LN0BJ0eovPmCxvjlilPO1gnyoPZUGqpbeVquGpeoT7oVPDpVoCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9746002)(66476007)(66946007)(8676002)(33656002)(54906003)(86362001)(9786002)(8936002)(38100700002)(66556008)(36756003)(6916009)(2906002)(426003)(316002)(2616005)(7416002)(5660300002)(186003)(508600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?POF29io2QgWfk1VEXnxDumoUicrMsX6I+F5lKUMy8Fxq49guv6juVSDf7ktR?=
 =?us-ascii?Q?lkyOAwSP26Sv0NexcPI7pARgHGJOhFN2YS7gQ+RMdQ1Gjs2+h484cT0Sc1VI?=
 =?us-ascii?Q?Yn1lBbg1d+eZ4rYP7TdMfX+jU4c1vIJOFi65ZNJHmfU2htq/ipuq85rjnYlh?=
 =?us-ascii?Q?yqQm6lDHBZvCU35dlgbOog0RrIU3dDSTLfSnacyZgP5Uu7QKGDAaiR1WubtM?=
 =?us-ascii?Q?rPGca0SLQxhlUN51c6GE3eiyO1hm+mIAbQwCDfQmh7AZzCOHF7oxkfsS1fIu?=
 =?us-ascii?Q?XAwxLPCeLkR/+KM7IyUtRK6rx2hT9Tw27hlCMbrqEZ9C2TQITrj1GEsxTMQX?=
 =?us-ascii?Q?NbdsBeqf26Pa5SF2hAWDvb9GbsZYU5e9ML8JTi7wytmnrWIXcgvj/FTTST36?=
 =?us-ascii?Q?/VOFNEaTiTdwUQcx6/+IjWSlNRae39/0PAUFzEfPFJuQo3cqkCwm93M1yNtL?=
 =?us-ascii?Q?f+kA5u8AnG+gz8Q5NCMgl0Y4QD7bf20qiUEftXtVi7YCr1JEPSlUBAx/dJyf?=
 =?us-ascii?Q?pLebIn86jzf9VkOIZI8mFiZNc5GxHs8E1MHRJqYqkUvu2ThMv/aJG6UJG3oT?=
 =?us-ascii?Q?ehz1lrzEik2lBg7keSp9+gVHjJWd0jH7R0MBmX1Ncw9vOM0h9ZK3GpZypVMU?=
 =?us-ascii?Q?Qmq2da+k9lDCkTX53MexI0ZxwL5FZ0Z/SD4XkOqEgPReW494zrqh1CIW1Vmq?=
 =?us-ascii?Q?+csxbQabbSev9UVkQ3uL+8Ai4fL7ci6kJwVY35cW0WHQH+UzsffbjdSwTJE5?=
 =?us-ascii?Q?kr3ryacmbtFa9DI5TAwaK0dc1n5w/yIFS3mSpkiRlVIVjSb5OCW9JoyeQl6K?=
 =?us-ascii?Q?gIzTHaVvWlUF0EMyhDffH+6Fki/oBY7ymiptpSdflt9bn+lPFAD4Z+Nu5Y/f?=
 =?us-ascii?Q?iMs9u1YX/8aDZ1Psih/hDyqhhQgsP2P2Deqc8QygxjkRG85O/KSGJe5PcUQS?=
 =?us-ascii?Q?ameVF17afHb8p7FHtFXkZR3EnFvjPvWTpbu2XK2j0WqPtWQ3tCcKMBFviYAe?=
 =?us-ascii?Q?EfTyTkdXxnWV6cr5MTBHTc8odIKIKpJ8iy886ho2gsdjuaeVj0GX1wOHm9dj?=
 =?us-ascii?Q?4jduTYGnu6ftt83iXf5fBHVA1zFT6gW8I6Jm/jKy4HY/3sMthXECr1UmCvJl?=
 =?us-ascii?Q?/ua2KnXDBhkgbvaDg3EsCkneaajtcxIP+h0r9UUji38Cr5F/sBGfqbHgyZnp?=
 =?us-ascii?Q?qCvnqlDWRuIw47H48q9S5wXgbbUtRVIrnby86FhXhMEG2cKj0GjZ0KcwG5BP?=
 =?us-ascii?Q?5JgiQyeSlg/TtrSg0Gpmuv09h4aBTYrO48NGrJVVTWThWeFM6IjDeNuABbs8?=
 =?us-ascii?Q?PRoXCjb5LaWvI9rP/M/sMdO7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 602a5d39-f6f5-4ede-09ea-08d9536980c9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 14:51:25.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uD3qQjL4hjpfk8daGVuRU5LAp6uLNyZDL0MioUlXhaySnBJw6ZEh7xstaBCu11LU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 02:50:48PM +1000, David Gibson wrote:

> That said, I'm still finding the various ways a device can attach to
> an ioasid pretty confusing.  Here are some thoughts on some extra
> concepts that might make it easier to handle [note, I haven't thought
> this all the way through so far, so there might be fatal problems with
> this approach].

I think you've summarized how I've been viewing this problem. All the
concepts you pointed to should show through in the various APIs at the
end, one way or another.

How much we need to expose to userspace, I don't know.

Does userspace need to care how the system labels traffic between DMA
endpoint and the IOASID? At some point maybe yes since stuff like
PASID does leak out in various spots

> /dev/iommu would work entirely (or nearly so) in terms of endpoint
> handles, not device handles.  Endpoints are what get bound to an IOAS,
> and endpoints are what get the user chosen endpoint cookie.

While an accurate modeling of groups, it feels like an
overcomplication at this point in history where new HW largely doesn't
need it. The user interface VFIO and others presents is device
centric, inserting a new endpoint object is going going back to some
kind of group centric view of the world.

I'd rather deduce the endpoint from a collection of devices than the
other way around...

Jason
