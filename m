Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ECC41EC96
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 13:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354140AbhJALxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 07:53:25 -0400
Received: from mail-sn1anam02on2059.outbound.protection.outlook.com ([40.107.96.59]:11825
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354134AbhJALxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 07:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejWsLEHO154N8YrhdL0HBwaidfxYcXyfKHhZYikB2XtVJVMPny9c8keBBiqXKjZg6fnMCGbetHLZmR37C/ALEfFUIJ3vuF4lNZA4ECk7LvzLwEJQOJ/1+WMLbfZlBozaJ/5o3z3I+K+XSFaQJ5UnsjmcsHLi2Tulm6O6yxYK6abWvLPvnmDNosaVxw3TWcHiPLsI2fjFlOVAMI/qlQ+r/g+cu3ouzTOr356VKyVoFYd5sg21g2s9k6CVxnsfNW8EhWJ5mai4NDtkZOXBF1Mw0AvU/TOuvNZME7NkjsYXn4vZp0z53VakbZUuSTTKcKp/fbn6dav2vv3i3HbqgD1jhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urxvcP9rWP+KV0NrBCyYTVNeGqsig4G2wH8FrYb7SJ8=;
 b=C+WD5RQ9pA2rOy95qOOExq6Z2ffQ8dZBsJsy7um/tLY/8Uff05u119eESY4a/xunmttNKz57uvXI3iOQgmZ1w+gbblt75XH2lcqLrbWmTnd3jKBQL7NBE+8zgDakcnle5SkPPR++YKg4wL+p5M81k9lEIbwn9FWsIRCYTduv4BfCeI1QVNuQaaqiHB6uYO5Wltyv6g+C9669M8PQs/fbbNIw2/2Q0vJ1hkU3g2x0xbZbYY3thqgUOis5JITIbNoqtOM6u1LdczNwGVz7doH/z+1eycAXinSpf/10+53O4N4G9AQDZxjSszbVsDLN6/PANNoeJnQTty9m7EhAk+crEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urxvcP9rWP+KV0NrBCyYTVNeGqsig4G2wH8FrYb7SJ8=;
 b=LP807anSJ/JEAxlDruiP+Uhz9WF7dIbWim6P2K5YnMJodBrXiWQluUyibjKeXyzomts+NdVfJP3dYnwVgTb8ALshKava5IH2aLEXz7viBpyMdTN4Gegrrvt25SYZk2VpIsE9vVhDJNexDsqGP9kgxVhoFGu3GsFYYgg//wW7uJFxqdNAvV3LGIuasNTE2zwSCpI+PhowL4RTB3G3E7WeCm9UQeJJOTikqX1DGLxkD5csEs+oO1Jmj+ll7Uc5tWg0AW7jo2B0Rxd1O+EcK+D44J/smHZOXinoKyRBrfb3+Xf6f2pXYmTsHndRGd0UQVqAL68L1dJpEajeW0U5X1Bqaw==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 11:51:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 11:51:39 +0000
Date:   Fri, 1 Oct 2021 08:51:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     kernel test robot <lkp@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [vfio:next 33/38] drivers/gpu/drm/i915/i915_pci.c:975:2:
 warning: missing field 'override_only' initializer
Message-ID: <20211001115137.GJ964074@nvidia.com>
References: <20210827153409.GV1721383@nvidia.com>
 <878rzdt3a3.fsf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rzdt3a3.fsf@intel.com>
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:91::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Fri, 1 Oct 2021 11:51:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWH4j-008Ore-GI; Fri, 01 Oct 2021 08:51:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ef60a27-f92e-4040-6750-08d984d1d403
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB520554846615E9A50542FDCDC2AB9@BL1PR12MB5205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:36;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gCF7xf9fQiWyk/xqHCuyUrqCia/q8x25W6b6E/f7TNyqjE0/jGVz5H9LakLHBL+7shb8l2mZ3teDI73g7TPN33XaH+/XDxSM53EjPB1R5hbfD/XkKhIjiKq+gzEhH98P3tbmsvi1TklbOkRXabHXQwVxztw9XRBOvc56jNSoDSsz+oVsY1kRUcoT6IffI+IkZ1EDpyeZfnQxkV+H19thZBDxqzs+bR6nM4mVDtLKaAiOntOP49wZ8HuEhsY3K3itaizV7Sj/fUJOq5C75Z5Cnz4wiPYnNxPhA/6flNcwaedyJOzRDYBs3pMYFVPbEkee7rNseRWmBIi5TywwlV36nKovqFZWx/kDLZ/3xTT7na6htj7U2wF7Hj7uYcIQFOjStkUBZZh3vZSsqtEKdwjCtOKJ1D0ULrS8O2myHcUE1QRqsKgDdmYuoMJxU0x0AAuYgBVHLGt5rI3F0cvrBKdKws0wmvVMTYH8A57UUyP+arhUb03bmxNKibK+F2WEMq4mHBCcupKWc6HwoMuCLxKcFbUsv0t5A43WF5JizMrx0kAYRIrEOQIsUrGPGlIJv8KdgSGsmqjM3YlC6SxoQuzImxqYoxj6Qz56TQNaNeMcpfkzloSCD8zqhLKNwBAOcrqnJ1AL5Dwnze8g5AEVf0TJ0/zwGUfPqL1gmDs6D6W8VHiuwVpmY+rYamOArBmK635TczILpw5mjDUX+4642/pge/gGoiuwaF4ixdX84je2H8BLEDwt0PxhPZDkNUUvRMJZ7z8WW2wiBc9t8p+C34ljdgA6XCiNvcrUbH5CsAAKmqe7xdEy/k0GG3o7snr9Qlih
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(316002)(4326008)(186003)(54906003)(36756003)(83380400001)(9786002)(9746002)(38100700002)(33656002)(26005)(66946007)(5660300002)(66556008)(66476007)(86362001)(2906002)(2616005)(508600001)(966005)(1076003)(8936002)(426003)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2oRZ+uc/gNQMgydc96GR4nigvZiABmTgINFqhZBw1oEtngyspxERh9i3Tr2R?=
 =?us-ascii?Q?mw/0N5iEfpYWdiccaeYPojvcMPIg6y5Uka2bAXnE+lOGAOmOKd1nkoAXNsQP?=
 =?us-ascii?Q?h9FpgQ1DT6+164fT4uHp/R0X9EDLcKlVO5Hjf7/+x2YIA7Eth9bM4wqjLS1S?=
 =?us-ascii?Q?+Y+LJ3XypsQhoeTeFWuMEwwiIJry2eupZNeOxaXwxehks85raWtGIftJuMot?=
 =?us-ascii?Q?GAk00/7fLB5Lnr/HjWB3vnxkBe9t2j+J5PXzi9eHRXp5zWgeK5DPpjjge1kM?=
 =?us-ascii?Q?ywT7KBWMHKAFBS80RunxAmxaoD55goefJ2AZKnvpjul1Dkvel3LOPW8RllY8?=
 =?us-ascii?Q?f+a0cbuL9zx0xyC3wUXCNP6IBu448L7hiZWsPm1+FvCwMWapqd3aME+BZ1Tu?=
 =?us-ascii?Q?snniSZvVwKBXx7sXdTlMThINnAyjxKPlIZMvEcr9JLoFYECkcuhGHEmofrus?=
 =?us-ascii?Q?J4W/Ikn6dIgjON/xG6P0qT+yLlnnEWq/VUcsQwX+jehfgIPP8Ckzx+dTfoDs?=
 =?us-ascii?Q?L8pO5Q/Ukf33BMlqXDlSOLjyPBicLSMu/qXGi4EyOnAz/44H6ZUYNryoAVqB?=
 =?us-ascii?Q?syzZUZUYnGZTwwEIcp5OfK7uccoOZJfYeDqOGMDg8OxDvklZjX/NOHzq9Fqr?=
 =?us-ascii?Q?j1mZrFZpx4M8eYoDmmG5vGf6stWcCA2QNcPrvsGcgNa0wY56C2W2XYBcCgrn?=
 =?us-ascii?Q?DA6VO+JCcch3caK9BHNkgMoF2K+lrNeDE8Y7NZivhth4MTeg1AtSM6M1tsez?=
 =?us-ascii?Q?f6lkaFmN3zldef3tvirjbDI4jyY8JEfCe29QNBIbVR/SyIJ88d0Il/mjSauN?=
 =?us-ascii?Q?8MNyLmxTjOMRU69LMZIZuLnrwiTBoJ9BpMxYERq86JN/gc5WD+NwHfBCXM/b?=
 =?us-ascii?Q?VzDs78XgdywJPK0Q1T60icJNanLfoGxkWy5MGBXB1ZyXWCtn7sVzHAWoulzC?=
 =?us-ascii?Q?IRSi6aIFzdk5JRYYg4567Xs9EaYnQcHKMhnaHyRyhDntpUAeLfoac/OCtRnN?=
 =?us-ascii?Q?FlJeHIW3CxXakwcprG2Rpj3WJdj1b0ZyMFvp0SH1zqrzteHmRfhw9SW4NZ07?=
 =?us-ascii?Q?il9hSx8Gh3L+sqQMeT0zL3oznlqDRHVxyUGEE6L47ZX7aYSrUnfYwI9YZNES?=
 =?us-ascii?Q?AYx0kfwd5SwOazJWQMfmNKPdga5rcOtfEn5F9t3VgA9eO7/JbhAmS8twijzd?=
 =?us-ascii?Q?jx/WmqvSZwVfaWwiKQjaBLHozRgCj81anKStFdSB40le5P3DjjbJu3vy9Sp/?=
 =?us-ascii?Q?btriO3zIuF3dQmJeQy6uyKdikVCmnMvJloyO6nbZtQlYhmezVAZrHoK/qWNY?=
 =?us-ascii?Q?c6dO3DX/zEzU76RuKySWAz3H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef60a27-f92e-4040-6750-08d984d1d403
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:51:39.1302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpO+yyAKD11SWpCr4c46Sm+gVYSJb5TvWA5aWV/OyVbBX1gBXrc81xnIXQa/d/6I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 02:04:04PM +0300, Jani Nikula wrote:
> On Fri, 27 Aug 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > On Fri, Aug 27, 2021 at 03:12:36PM +0000, kernel test robot wrote:
> >> tree:   https://github.com/awilliam/linux-vfio.git next
> >> head:   ea870730d83fc13a5fa2bd0e175176d7ac8a400a
> >> commit: 343b7258687ecfbb363bfda8833a7cf641aac524 [33/38] PCI: Add 'override_only' field to struct pci_device_id
> >> config: i386-randconfig-a004-20210827 (attached as .config)
> >> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 1076082a0d97bd5c16a25ee7cf3dbb6ee4b5a9fe)
> >> reproduce (this is a W=1 build):
> >>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >>         chmod +x ~/bin/make.cross
> >>         # https://github.com/awilliam/linux-vfio/commit/343b7258687ecfbb363bfda8833a7cf641aac524
> >>         git remote add vfio https://github.com/awilliam/linux-vfio.git
> >>         git fetch --no-tags vfio next
> >>         git checkout 343b7258687ecfbb363bfda8833a7cf641aac524
> >>         # save the attached .config to linux build tree
> >>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=i386 
> >> 
> >> If you fix the issue, kindly add following tag as appropriate
> >> Reported-by: kernel test robot <lkp@intel.com>
> >
> > Ugh, this is due to this code:
> >
> > #define INTEL_VGA_DEVICE(id, info) {		\
> > 	0x8086,	id,				\
> > 	~0, ~0,					\
> > 	0x030000, 0xff0000,			\
> > 	(unsigned long) info }
> >
> > #define INTEL_QUANTA_VGA_DEVICE(info) {		\
> > 	0x8086,	0x16a,				\
> > 	0x152d,	0x8990,				\
> > 	0x030000, 0xff0000,			\
> > 	(unsigned long) info }
> >
> >
> > Which really should be using the normal pattern for defining these
> > structs:
> >
> > #define PCI_DEVICE_CLASS(dev_class,dev_class_mask) \
> >         .class = (dev_class), .class_mask = (dev_class_mask), \
> >         .vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
> >         .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
> >
> > The warning is also not a real issue, just clang being overzealous.
> 
> Stumbled upon this old report, sorry for the delayed response.
> 
> The reason it's not using designated initializers is that the same file
> gets synced to some userspace projects (at least libdrm and
> igt-gpu-tools) which use the macros to initialize slightly different
> structs. For example, igt uses struct pci_id_match from libpciaccess-dev
> (/usr/include/pciaccess.h) and can't easily adapt to different member
> names.

Do it like this:


#ifdef __KERNEL__
#define INTEL_VGA_DEVICE(..)
#endif


And userspace does

#define INTEL_VGA_DEVICE(..)
#include <foo.h>

> Anyway, we've got
> 
> subdir-ccflags-y += $(call cc-disable-warning, missing-field-initializers)
> subdir-ccflags-y += $(call cc-disable-warning, initializer-overrides)
> 
> in drivers/gpu/drm/i915/Makefile, so I wonder why they're not respected.

Disabling kernel warnings because some userspace wants to copy a
kernel header is horrific, don't do that.

Jason
