Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610A24323E4
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 18:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhJRQez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 12:34:55 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:10208
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231896AbhJRQew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 12:34:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFn3zHCROyBHiEbRJkRD2xUna3lJ17DjixvlMKnPY0FrZH375xt9McGaNXcyJv4L5Ng355U8LhdlNesbq5+wtPNSVSE1b8MinORZk/KOs/JD50hSg92TVcwdS3t+3d/3uYoWUtRw4cX8lItykx2m5wxSTopu7R4ehj3v9oorrQN191ecKQWEFHrQxKvVRFj24EiBu/QOkNtE06YeRI0r+XL1f/Cpr0vAR1Rs4t9awHpXNcK0jRReRlyLcP0NMx8USDVIdPGVcunQHv0YB6I0kTjBZ9VjNOQC9S3GEkBgNwtuK0mZZ2YbALZo7NWe3NndJrsAL+pUgaWT/unnveMkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nApis2aZVIrtzFuEXVjWa3t4o12OGFGmqXe8A9/+uWg=;
 b=UkiAek+1SQN/1tDgCJ9gEg/u8RJKAm/pm/lMgJVb4SAbcxRcLSwyfnDQXXJAmF3tHeU8RIwZzZQh7neECMp6t2etrPcvqW1SfGHuGiw9H5e6McJwp5T/j7PhyjFPa69h7tGpfLhELT2lnyGoA7Czxa6SXeEgyLRoYNQm8zv/CyaqXQcSsC0giHHdxR2i9USavRscLktBbUaeZCIfPI+eweHJsArtemj57rHLH9g3yKOm1c/h3M4kypwXpM0VISZJCedCeOBKUsc3rFbefSWSX+3kBexwQuhHTPRkf8JJZZ3z2XwAqFBJ1z8EY+HEQFHaXjNHxuXqCb+1Ma61Ps50mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nApis2aZVIrtzFuEXVjWa3t4o12OGFGmqXe8A9/+uWg=;
 b=k4jiOcsOqBGrxWhBaY5KNkCnS16YQ3yi2KkaSnzxtK1v98lnnAaA9sTo49l3Wgo8nvWP00ln4tcEsxwcbKCcEcFeeIhRwk2wa//+KeWnE2ZJIhWr9s1W5RDW8q5yFScoPJ3QpGWnu9Ln6LVvOjv0HvQNs0zGriCmDOK212F+t8WbwjRjJfylAxh8N23jhnyE1/+2nmlJQJiBn2D8ZYIc83OEnQTfipTIDql/vExxFmGMnXtjCwO/lyoAKa5Ag9vrRELigIHUWdzN+WA5SwQq3eSlXPIzf8TYueSB/ncV7PD5avR9BqyQxFqAGiIJKwh+UydE3ibTLL9/TiQau9hBaQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 16:32:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 16:32:40 +0000
Date:   Mon, 18 Oct 2021 13:32:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <20211018163238.GO2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWzwmAQDB9Qwu2uQ@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWzwmAQDB9Qwu2uQ@yekko>
X-ClientProxiedBy: MN2PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:23a::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR03CA0023.namprd03.prod.outlook.com (2603:10b6:208:23a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 16:32:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcVZ0-00GJcA-JT; Mon, 18 Oct 2021 13:32:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22787174-f942-44c2-a9dd-08d99254e6c1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB518954087AE09A8ADDCCB1B9C2BC9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7bXNmdrVx0st7HfqR7kqaFO9H9NXiqLGjWYyLVViX1Oshwlul+q/PEzCGGBcZFnIy+8qZmgDrHiQpFcWaINT32HzcHMwcbweUS90wIg78NNf+xph382n9st9x2bVw5TWnwx/+JEHda3JpJkyNGHdWr5OkkTSomr4IATLR1FMdsYtyRU6ysMXWkNTFFPGV3VYKDrwAXXb8ahsAnirZQ8qURPGKr5E7IiHNISCCSl0z4WvsyStwsIOIYIeC74iP3yB6OJ2Fe5zSXIafFFISjbnxzAFb78WPLqqEVjwX/8bQDa0SDy/DGtgK+wdIHdS4mEs8jpKmqCgWS5iabx05AavICddhP7I7IHKM8caXaUwETChlCUJhsqrI+OADSfrbnbaMF5P3Is4hB95/2b7FMF/wRbBriybbOjqqYygpEu1rtJ1kQbZwaoCROxPwtqB2tLqokEsbb9SWBO449ucyn7JA+IRFKQnZ5sXUL7OwvE2X7m23iJRcNu1kG7bRW8GxKZocj2gkxFsdHCndr/0krLFUjCM+z2S0GZwrESFVSM1pQUOY+V1IDOS8D6BCplr5Iqz53h78zBh+kfgKl+BeU33iEEpmrdZlrAlJOOQcO932hmsxDIKiGhNt4lMKn/u+4pWy5o7ohBMw2QPS5CWgapyKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(9746002)(9786002)(54906003)(8936002)(107886003)(7416002)(38100700002)(426003)(86362001)(2616005)(5660300002)(6916009)(8676002)(508600001)(33656002)(4326008)(186003)(1076003)(36756003)(26005)(66946007)(4744005)(316002)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TqxMH6n+Uz6DHoQTOoxfQk6bDDxkLV1G6uvtN+OG0FJfYxM1YHiZCVtsOwU4?=
 =?us-ascii?Q?XmSfcstbWPjOpMx6yImgAcRS/iwirWEsGhLUenb5s42JlVcp75dJ/JMOaX/M?=
 =?us-ascii?Q?QXLjuNpYtfI8W6HANghEndf2BOZavYbYcCIUcKxXdTrHLoJ6raSpeeE/yNgj?=
 =?us-ascii?Q?F7qTscnNp2MpoGvY+PYZ9JAml98dwjj29Vygn3frqHkPnQCug+e+qQqr46cS?=
 =?us-ascii?Q?JQGEAy27vhTfvrFbrgofxhQY0mgvPnY+MdSGw/grBtkRib8AlSCo49LvwZHt?=
 =?us-ascii?Q?xvKv7SU1crSAnOQLC5he9JAP9Kkq+i0kF/Kw8a1GjbuE8d+oJjWuPQoP9lFF?=
 =?us-ascii?Q?2mepulUnjK8PTAqQbn3ccVjRe+y2tMd4abax+18ta7jP0BPeN7IytjYf4M+p?=
 =?us-ascii?Q?FXLs67agaaV+D0hTpDABx/VSOyZeIXUAKkkhoXL6YE5nhhLhm/X0YB9ICwCx?=
 =?us-ascii?Q?yE5+49N/Bf7QwZX4I4UxvXGxKqSVh2Jkls6Pp7JOI5C9uZqhFcXDH2iMdZas?=
 =?us-ascii?Q?aTL2gfqR2bO6GH4HqFpN4FdsHBINlZ4cGM1IFjXgp+K6AmlIHsGw896MllRJ?=
 =?us-ascii?Q?0V0giDcSV1m1/YexGHPUeDXnl0U27kIbclKr7CmF/ZcPIzMR6r8ndneaY1//?=
 =?us-ascii?Q?Fmk6D35oir0iEHMwOgkSCgYpKoMNYmPNxOdxbWxO1R8Xxk1pQxByJvVuIZdl?=
 =?us-ascii?Q?4oba7IsQ2F6wVVjOk0mhGq4+ArI0TMj33pZrOklYSnMoyUMldZ8bzoCS6ffr?=
 =?us-ascii?Q?HVDIydxoyUPPrAI1Zvnd+kmfaDz/gjNt0k9dh3lPIGZy5OqKAca1DdGJTvlb?=
 =?us-ascii?Q?zMN8o1cxjYf4P1RPp01SWxyJr2kcRjpwjXco1bVexEcME9uc9/LWrVQJTbLC?=
 =?us-ascii?Q?p0dFF00LQ42jeB3lJISs2GWTSHFz4cu+uSjuPaV4PymstRrVpexb5A+6A8aE?=
 =?us-ascii?Q?NF7pKvnl4V9yRnRJZ0tL5b7eLE68vnaAAfGvcGnMnmkpfqVPhcCLXLDssZ8M?=
 =?us-ascii?Q?NFqnPmJ7EJCIoYsHwLSQkCCBWbOyB0DfI5D3Fz4N9OhJlrlKo4IZgWiExMMm?=
 =?us-ascii?Q?Q/s7lVyVq3NGYWkWWzNGPvoCkzDCUUHSHm2IE2gosXfXJwUsfV7yyNhPRKne?=
 =?us-ascii?Q?UXo8Sj6bF1t3+xDbc7C8wlYllCNGHBIigRtfqbmdjRnnxiuVp+qiGfc8M2sr?=
 =?us-ascii?Q?M7qSOrMn45ioDlSnYm+X4cH8ATq+vqvd6FRNEloOjfMnByYuDMx5ua2+rqAa?=
 =?us-ascii?Q?Nz0jtcpsR0+wu5AygrDADIzClrl7Z3QMNMquWxdvbWrqm8e3O5Gk+vraH+L9?=
 =?us-ascii?Q?YKygxlb13conmEvAXrXvY31J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22787174-f942-44c2-a9dd-08d99254e6c1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 16:32:39.8514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AO5IyDUDMAt2GkyZCNVlv7xvSOPKhRmbrkrX3ioCknIA4n661umvtjne0vUerUbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 02:57:12PM +1100, David Gibson wrote:

> The first user might read this.  Subsequent users are likely to just
> copy paste examples from earlier things without fully understanding
> them.  In general documenting restrictions somewhere is never as
> effective as making those restrictions part of the interface signature
> itself.

I'd think this argument would hold more water if you could point to
someplace in existing userspace that cares about the VFIO grouping.

From what I see the applications do what the admin tells them to do -
and if the admin says to use a certain VFIO device then that is
excatly what they do. I don't know of any applications that ask the
admin to tell them group information.

What I see is aligning what the kernel provides to the APIs the
applications have already built.

Jason
