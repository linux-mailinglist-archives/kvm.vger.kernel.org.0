Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120EA7A96FF
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjIURK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjIURKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:10:20 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1ED902F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ6ORCJONLquTpW0EsikzWZVoi4PeFtR7G0oWYpSzCo9zyUBSgxombIBoO8X+BXnILFTqmTJfVGzjIoSVrkOOgNQ1+mqEhTvYdhcDvfCNnSzUarFNNzhaH2GbGo2JUqEZZQUbzMnJ59CoFPAKSACpwOrXx/Bs0z6gFOEHI/MUjEdlJaVyrOQaRye1FokIy41yWJ99+Wx6oB3BylU1oy65Tq9wzcUPDKh+6/DgaKXC/pQFZJlDt7UZTNb6XxTPFoLvrxH+ZHldT1u4Fz3MpRR/Hg04VYM4rV857W8NBwbMHH2WXgVppwXhDhVhN61UObU15b7O34lwAFCziTzjj1tMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpEZ0Q+tfVGLwS6iO7hgNZpSAM88QoPQVcGjpMVYti8=;
 b=dZdqAsEU6P29StnEqRt/oEW3cp2274qz/NLEYH01IdNF1IH52yGiYR/vmgLbt8Zenjr+60L9GY1UU1Y0BuJggRm2KliYMkS7sSfXpH8iCX0n6vhOoDM0qJSt5VwBegoEMBuqQZ8Wu0tdvE5vsWjyWciAUJjmejt6fVrwl2a0AmnMgM7l2On802wGY+OaD+RMeyZSoNrwew5Unbd0LVXC0OIUhC16g1wx123qo24T+95rrd3xy9BVUZu2w05TnrHJUlNWGYbGrDLIfiXFl1drtEdXXKWI7FYtmb2/9vdSOMCe8Qma9w8baYz7L8zUjLS2jwr9AF5Nzz5OlAC3d6CY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpEZ0Q+tfVGLwS6iO7hgNZpSAM88QoPQVcGjpMVYti8=;
 b=YzvMSP1ZxGyR1qXmFl6sWCrI/Fn4GG+Gbkplrjm/GZCMVM5WTW4GADtyVGD4kTFKzoLcw1mhlY4F+oRavtj4heXZG07wwP9ebQv2zemsaO6Bz0dw5vf6y1lp5Qs4BMYw0Vg3hJRTaNf/2aJ2jBWIZ1DPdfdnI1eP9SCWSJUWCOuo9EO54z1nMDqBgxdKc2BxlkcnC2GPpxoaeRvQW/x1blVIf4rCKjcz1axQnOGUBWcvtq3ZgxqGLk8JpILSX9alIar8rx2OdUc5+8zHBfXwmB2FtesIq/c5uJtK4+EfJCbvcqDpLb44aQS3T473/v1P8p8NV9FNZEUC+FPzEgYEZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4921.namprd12.prod.outlook.com (2603:10b6:610:62::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 14:11:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 14:11:26 +0000
Date:   Thu, 21 Sep 2023 11:11:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921141125.GM13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921090844-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: CH0PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:610:32::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 76184c52-2c7c-4d66-dc74-08dbbaaca4e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuaGgVbH8rOrnCjBGcoDkovxISk3IoHtpkrMGMasDoBNW/Dq81TQbQnVBJWilDvHUGTxxYiqTCRkEr1KauMIuH7dHuCPKPigXBFuxKPCLLneUj6Bb/l7t1bat2OUcyDCBlHRF+ObYNTSo73TSjegJLHva2+QmBbLXZ2wtqDP3Mkz2KALgLdokCc6Omz1hX4MhPZ4HAT8SaiNdUjKpQDdSfdhesBWT9yeF5hlxbK8REiaX+IXxJVhE7Nl4l/YhqKCpm9qj+Vq3Irl/dlrNZHVIFvGZkQaVeXpYWuMtGR22fbL1PFYVcvJEoGenUJO1JlvmmNMvAFRH7YKSWKcsoheKPfdn5b5cg/uw54YejzZDx8tKukL+Y+vTWnKp1NYJmakM44tSJAG7pJdn1RP/9h6IFiRqA5u9tDCep7RRtvi2e7LkzFelXXQ4HCkS2NH8Tt8muXHwy/FEIA9gauBscfsauGo/YhrfIqlYzeWuc1yyrMvPzU1jGn0GzfIYHwdoyQ2aoK7FWQSdL/wjhHueWx4zRb7PjOvBiv782W+/x8Bl3odL5biiI83FU5q7KBm79aZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(136003)(396003)(376002)(1800799009)(186009)(451199024)(6512007)(2616005)(6486002)(6506007)(86362001)(33656002)(38100700002)(36756003)(107886003)(26005)(6916009)(66556008)(66476007)(66946007)(316002)(41300700001)(2906002)(5660300002)(8676002)(8936002)(4326008)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clQBUIeEM5f/3Uqx7VsVnUT3FpEC5Gk7knr+LmdZBiT5qYEQ+PKDo8GASiJb?=
 =?us-ascii?Q?u6yQ9tGsX/K+3ku+HGYgBNBkzz20p9YT+nb07cMKNEBZ2g9VTGj11fyPBsE4?=
 =?us-ascii?Q?6I4tlISPEWDKQ34Y2Gh+QjaxDqy/iVL9erw5vnYoZRloAlB7RlnASwnmLhUG?=
 =?us-ascii?Q?Mz5jEW4X+jsKsXe7skoB03jHKQWyLzfxzFtZOdQaDGIjZUoT022R9P81xa0X?=
 =?us-ascii?Q?dWB8LmSsV+YIjfYdBJ7DnD6PeovasRcHqGObHXGhHhMIQAYoks7KOj8l41XI?=
 =?us-ascii?Q?ef7tXzlOQALZjgZKdBm475hQkqGaOu+Ti1yM2KQWPIeFjrcMdNw5Nhb0TLq7?=
 =?us-ascii?Q?LAHQhcR1IbFvTRdsNS2nMlKvKfMUYNMXR2JdJ5xmeTx4LAKzXdiq/g974nIe?=
 =?us-ascii?Q?E0ISb5J6gThFpTodyPBMKg5CqVLA8qS7IgM3C6iwVomQqav/7TZ406bhcu1w?=
 =?us-ascii?Q?zdiuiKdALPEsj5NHiF2qZCn3WyvXgzvjhPROMx91qlszwK5eH0zt5rB8yhoX?=
 =?us-ascii?Q?VzlMa0AKPwF5mzcuJnt1SogjtWIDvXdzOzMcCck1iUhtnbc2AjOLApUt1m72?=
 =?us-ascii?Q?2SrsTlIafTzt/PslgYLEG3wIwD0ci3I+OIeNxHLbfLIZh97vm8Yvp0Variio?=
 =?us-ascii?Q?f4SYDFDwQvoMs/HMWdWoglXH/czAJl3evrT2hduwsI8MPUi6Ji9vA2uPLVrY?=
 =?us-ascii?Q?MraHwV2e75NKrrra1K+mXe4HQNJ9b4Ct8aFCrtObkQrrWGE+ynYD/yUDBZ/t?=
 =?us-ascii?Q?0l7S3tIXSCOywVAZa1O9PZmuA2dBOegst4nV8KCiNw+hrQRqLRbAAmPO461O?=
 =?us-ascii?Q?BmqZrv4lsRajdpr1yGDoHEs406wxYVqI0zQUcCpDNFMfpuUcyoj1XTQwR03Y?=
 =?us-ascii?Q?wxZMlCszcIhl7ZAzt+8g9sn/US1U6zIN6R2bPVuxfJSLOjYLMyT09RgmW/FS?=
 =?us-ascii?Q?Z2REUHZUAnkj7MWpSC+SKFSZtt0V1SZ9LxTByF5plI2TvVanPCdRnBJ1zgTf?=
 =?us-ascii?Q?mCFQWTnu3UUIBCgkbXv6+Mx1utPFUTd6v9wD6cCzWItAw+wWUDqi/C0U7+j9?=
 =?us-ascii?Q?RhiCY810tSTd0fj6Z3t+Sydgys8Ub2TVLYobRXYvYPNKDHPuk4xra87mRG86?=
 =?us-ascii?Q?OBKnpfoSd4gPy37Wb9HgJg8lc1KAjS5u1hiXx8imZuoysjmTkiR5PUFSNR93?=
 =?us-ascii?Q?7Z3nSNlVA8V/71QKs1k/Cy1/pqPs3mkzIljeargNlvoVBTa+LPKGwqy5HrhA?=
 =?us-ascii?Q?XPiV7CyZ8SEZUr/m0C4/kjoF6ZEKeH0Q4g461vfyd6XtO+kHxr2UAQiUeCZR?=
 =?us-ascii?Q?0IcKm4LBMDbTt/2v4OaJEDeoh+omZ2ylvZuOvuWMwsRcLi+wldE2IP/AQNH9?=
 =?us-ascii?Q?DI/rvZPE+JFTL+4i4ZaGnpKHDeWrogqzUXfWxt74RycozqAo4KLmXNHNWBP1?=
 =?us-ascii?Q?N3tdyxT/+imcRBdg8OajCJhQeWQfuopdIG3S526ec9h7d89Lie4KOVtFA11H?=
 =?us-ascii?Q?sc7Vo0kC7X/Lub8epceuBIO7E9BiC3VObVCJ68XceK2JIFeouiWSN0JkRCLh?=
 =?us-ascii?Q?dJao3vyBsqvX9N9NrclEpuvN+mv/TFwUOvAVg6uq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76184c52-2c7c-4d66-dc74-08dbbaaca4e6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 14:11:26.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCXP6QZdXKyyUj92r4s18G2IjkGjMW1r5LlJ7f55ElsKY6RPqFD8AsMWg4//RKyK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4921
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 09:16:21AM -0400, Michael S. Tsirkin wrote:

> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index bf0f54c24f81..5098418c8389 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/vfio/pci/mlx5/
> >  
> > +VFIO VIRTIO PCI DRIVER
> > +M:	Yishai Hadas <yishaih@nvidia.com>
> > +L:	kvm@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/vfio/pci/virtio
> > +
> >  VFIO PCI DEVICE SPECIFIC DRIVERS
> >  R:	Jason Gunthorpe <jgg@nvidia.com>
> >  R:	Yishai Hadas <yishaih@nvidia.com>
> 
> Tying two subsystems together like this is going to cause pain when
> merging. God forbid there's something e.g. virtio net specific
> (and there's going to be for sure) - now we are talking 3
> subsystems.

Cross subsystem stuff is normal in the kernel. Drivers should be
placed in their most logical spot - this driver exposes a VFIO
interface so it belongs here.

Your exact argument works the same from the VFIO perspective, someone
has to have code that belongs to them outside their little sphere
here.

> Case in point all other virtio drivers are nicely grouped, have a common
> mailing list etc etc.  This one is completely separate to the point
> where people won't even remember to copy the virtio mailing list.

The virtio mailing list should probably be added to the maintainers
enry

Jason
