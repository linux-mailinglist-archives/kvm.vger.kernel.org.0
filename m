Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A243432A3
	for <lists+kvm@lfdr.de>; Sun, 21 Mar 2021 13:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCUM6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Mar 2021 08:58:31 -0400
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:30839
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229784AbhCUM6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Mar 2021 08:58:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4mGdA3Yvkqe7B+t/gN0zBdp5wPxt3rM2CDl5B3dEX+Us79/TEJW+b8hINDq/5O7mWImK3kJhS1dB7G9lxZgtpzG4YXQd8vvE9Q/izWhAGR0n8uBhtELqfSriyp/Jr8Jd4TdD7EMhdwpa3lrPui48mD5hNRsuyCUT6jTdM+n8357nYR1kOT3y//cfI+S2I/KK/iH9loHrHXKi4dGwvxUxdS5D1GdOqDvAGxclKgn90qYW5EepZcz2dSnGwK90M08AlfBb19KA6XBhicBhKR51PQgDvyBQ7sPHWbUCTosG1Sk6y3DtsRGJeRrhwUccVXUK5wPmvx2bGdBHd+4WF1R0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZBh4f0K+nkwsRu0ojmqyRdv8OWESDZJCOP+bQWb6Qg=;
 b=HQ8UICmIIexEBMU/M1wxiFYsA5Er7AGT0hYSmFBFlVFJctUTO1nrH2f9oZiqaGutQmq6EznIqUWKYuQVwJ7eiad0m0bg8M10W1lqo5SQYLoLwF8nAQ2910DBXbLVNqzVkSyO0i1iCqWcijZXW+8aVrMYybDZgVNx88UFB+BSf+fL6RbvpDN4/56jup91imPhmd4NwDPevOt+IpjxsK9dE3ELWYtzN0gp4jIDHgk3MzGEqaCeMqUVyQ5uMczUhsSzDoPTGIB3y0JOb0737PiiYyCLcdp9LpmS6MIbhrNG6Ht6m+vMheLCou9aymsuR7PZqtQRU9ZKDNHtNEu4P6SxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZBh4f0K+nkwsRu0ojmqyRdv8OWESDZJCOP+bQWb6Qg=;
 b=gcw0/Fd9QhwO58/U1WyKsesc14hGJ2nt2RtCXL//rA2RW5SLt1O6uG2vGpkubIyOZqN2rHiFoMlnz0dXPQgPkNNpOiWdnnPQaw0A91/K6N48viIEQja/S5j//DR1TWsjo4Q332jKpgvauuF2HycVKhJi9NAE6k95MVaYT6LvID9jF2+J5DzyR8zejvTcODSYmgMrfbUt31yOUG9wfRCQtbHaHwMit6MEghra1U+FAfepKLfEgMomeWe8bo6g7gsIGdoN4sujONqtV7tEKTgJ8Y9X8eafKSfs2iZtJDQyZYlkVLzEt5tXWNBM7ITltb9ZGLaYz7MhyQKz/vhi3dahnA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2809.namprd12.prod.outlook.com (2603:10b6:5:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Sun, 21 Mar
 2021 12:58:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.025; Sun, 21 Mar 2021
 12:58:20 +0000
Date:   Sun, 21 Mar 2021 09:58:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210321125818.GM2356281@nvidia.com>
References: <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210319150809.31bcd292@omen.home.shazbot.org>
 <20210319225943.GH2356281@nvidia.com>
 <20210319224028.51b01435@x1.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319224028.51b01435@x1.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0267.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0267.namprd13.prod.outlook.com (2603:10b6:208:2ba::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Sun, 21 Mar 2021 12:58:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNxet-000XLV-0Q; Sun, 21 Mar 2021 09:58:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62e85f52-6756-4624-7d14-08d8ec6900e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2809:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2809540A80031F11DD5CE41EC2669@DM6PR12MB2809.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFSTdlTxUUu5KbcWuB+WQ3i7zhyoSl/T5piEP0BUELJi7seHW6/QCzqXNstvq5sfJh0Rk5cbfJvGMyz1v6WGrrYZrVV+2BvWNAgEDgCQXyazXEOpH2Ima+0ZUS38b0KHtQDEg8FV/EursQPpHbpafXARu0L9WPlUsrI88L1eNmpkRGSJbKuw55VVZDoFyRabAk/63LLVU6vTRcvArzQoOHHlNflrxbYU6BkAYoV8GYyMDeEo5k+RgW8J3x7psNRJ5QmbfOYUDxruRdQ6HJgbpJqz4Bjn13+pKSrKrltL62Xi+CG21+usTud8pteEobdGsEAUCSO/T7JC8Sm3xL+GSHaPsc0RgBfFPnB+U4/nZLtondkJwaTjGdBs8nygMXWMmYjCE0z+cF5m8LOuhRxP6fZIO4tWHQbQD39nNYX8jvgl1GsXzyv7SptddlL35zuvXwMKp3NYIvtk/vjIiRBWID/1V1Y5+CtnS3zhiIxnKTH8dEH9h7qayAFkXcEXcbshN9ggHpXMPJ43gsS5GZJxacXg/EwPUojSqioS9p4hsKBGB06zkvD53GSM6sv6Mo46tTx/kIQc5Ptls1e/cv2+ZRdWi3w9TQo5kRNEmhlmJSaIsnjvN6T7ZMlrHNCk01CYkUkV2yfwbZFrx4z2tRFmULbarZUi6wb+rzfq8KjyWUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(8676002)(8936002)(36756003)(4326008)(5660300002)(2616005)(6916009)(426003)(478600001)(33656002)(54906003)(2906002)(26005)(186003)(316002)(83380400001)(86362001)(9746002)(66476007)(9786002)(66946007)(38100700001)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QEqBFGfTGQVY/54W1xbY40m74uW9RDjBCCeZIrmesWDViEwqXOOE+wbEM2Vw?=
 =?us-ascii?Q?W0NrhRPQGuKG3j3sY3iX6lhAYfJK0hO1ZVunIVikV3GTQH6T4D4hJ7sjGap2?=
 =?us-ascii?Q?WDS2K2NzXw0/qjSLtb4FC0cxiAZ5IHWcwrylhF2yuffa36MTL9wDBa3Wf0h7?=
 =?us-ascii?Q?47cwkrHPvnTxxsY5L33t0ISNEF1peFVVT18EkvgXyRRZGxLrsDhCBYoBY2de?=
 =?us-ascii?Q?t+QE5njOaNxoOtgld9pd3L8AAz0QJuH9YHEi/X2giP0Z/BRIY1Vor0BEC/uS?=
 =?us-ascii?Q?XrVXoPJA1iB6tJGFsO0fJekVogtxVNB10NvoIWF0GD1t6iLqt+YWvKstUY8/?=
 =?us-ascii?Q?0hIrJs3pWObSfxldc8PB1eHIU/ZA8eTzH2lUDPxh817rH3YXskUT7B2ODIFE?=
 =?us-ascii?Q?l8Lq+Y2gHkAV6sI9CvYumd7SYD5gO2FJOD8xdfGgE+meFLh20VtptcRlTfiC?=
 =?us-ascii?Q?ZnO/sDB+S+Tc6p/Q63k8DWlDnoefe//qA28uN8cW8ZNXBcwSRUHn4UdsmbXU?=
 =?us-ascii?Q?JNiVZGOTr3QcicRQ7Ew8xZaUvUfvObxKKdMvA1exjBifjCT8D39mq+NbPcog?=
 =?us-ascii?Q?ILVMmMoZ3wjcQVFfQ8MeOaREeh+KgrliQciaRoC+vC/2qrWrpgAnjP7tJhiK?=
 =?us-ascii?Q?0bX6CC+NrAuDk5nSBexpEqhdnVqnj7gAiWlKnep6TIJ6stbyoEdC7UPAOmPG?=
 =?us-ascii?Q?JhP/M521oIMx6pC5KQg1SseSvdx0HmdfHvSVZYqNDMvCNmV9bN68/YSrcTbe?=
 =?us-ascii?Q?PP5BiAOzb7qoXY5dHhm8G2vaeX64tOaPZnLr5UwcyH9wx6M+YVH8nFhX/Wn2?=
 =?us-ascii?Q?YkWw2/5umNd2HBb2QTHIQ6bLrYs0QPjzwUqGlsiVTCVfYr/QsA1pMSsmj1fJ?=
 =?us-ascii?Q?bqmXe+OPp4hW73DVzMszQBWN5/HRwn/upjXWJjVp3ufJmTj0HdYW6/m/mHVS?=
 =?us-ascii?Q?MIomMprH2RuWx5WJMiftUdGJa9gumTFHuD0o3wEVpcbyo1Fk8V/6FcDYYpTv?=
 =?us-ascii?Q?je2bU4JSvFdbcqRg5Uvx9FBWXIfxKVUCJVDFnS4bZA/Nfvk/CTDlLJwDGVga?=
 =?us-ascii?Q?BHwkvDi/dumWylFEam5mvVvqe1qphK92GgDIzIYb8Z/yeAIP9aBdcni54fG3?=
 =?us-ascii?Q?anSBn4dV2M8Tb9OdUG1xIqFCWpi/WaK/INhjG7u1uMMsU+eiK3Bha/YNANka?=
 =?us-ascii?Q?HEfxgFwNMCoCi4CDrQVfBt5d84vhRml1Bh8H8BiDVjaSTyWQ7wUg0E01YaVL?=
 =?us-ascii?Q?KUQpQdJbpUahZ7tGQRgKuDoqTCE7Y6nxkbBEjztVQg5FjhHdHSQyuuRUJai/?=
 =?us-ascii?Q?ZQLZ2+HB/mebeEVZKQzkwqS8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e85f52-6756-4624-7d14-08d8ec6900e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2021 12:58:20.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NUIvCgxu7btiGNDt8W27tc+I19oMbJpwQcb6vQ4Y+ZOD9nq1ijf2W0IftZQwJpr/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2809
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 10:40:28PM -0600, Alex Williamson wrote:

> > Well, today we don't, but Max here adds id_table's to the special
> > devices and a MODULE_DEVICE_TABLE would come too if we do the flavours
> > thing below.
> 
> I think the id_tables are the wrong approach for IGD and NVLink
> variants.

I really disagree with this. Checking for some random bits in firmware
and assuming that every device made forever into the future works with
this check is not a good way to do compatibility. Christoph made the
same point.

We have good processes to maintain id tables, I don't see this as a
problem.

> > As-is driver_override seems dangerous as overriding the matching table
> > could surely allow root userspace to crash the machine. In situations
> > with trusted boot/signed modules this shouldn't be.
> 
> When we're dealing with meta-drivers that can bind to anything, we
> shouldn't rely on the match, but should instead verify the driver is
> appropriate in the probe callback.  Even without driver_override,
> there's the new_id mechanism.  Either method allows the root user to
> break driver binding.  Greg has previously stated something to the
> effect that users get to keep all the pieces when they break something
> by manipulating driver binding.

Yes, but that is a view where root is allowed to break the kernel, we
now have this optional other world where that is not allowed and root
access to lots of dangerous things are now disabled.

new_id and driver_override should probably be in that disable list
too..

> > While that might not seem too bad with these simple drivers, at least
> > the mlx5 migration driver will have a large dependency tree and pull
> > in lots of other modules. Even Max's sample from v1 pulls in mlx5_core.ko
> > and a bunch of other stuff in its orbit.
> 
> Luckily the mlx5 driver doesn't need to be covered by compatibility
> support, so we don't need to set a softdep for it and the module could
> be named such that a wildcard driver_override of vfio_pci* shouldn't
> logically include that driver.  Users can manually create their own
> modprobe.d softdep entry if they'd like to include it.  Otherwise
> userspace would need to know to bind to it specifically.

But now you are giving up on the whole point, which was to
automatically load the correct specific module without special admin
involvement!

> > This is why I want to try for fine grained autoloading first. It
> > really is the elegant solution if we can work it out.
> 
> I just don't see how we create a manageable change to userspace.

I'm not sure I understand. Even if we add a new sysfs to set some
flavour then that is a pretty trivial change for userspace to move
from driver_override?

> > I don't think we should over-focus on these two firmware triggered
> > examples. I looked at the Intel GPU driver and it already only reads
> > the firmware thing for certain PCI ID's, we can absolutely generate a
> > narrow match table for it. Same is true for the NVIDIA GPU.
> 
> I'm not sure we can make this assertion, both only care about the type
> of device and existence of associated firmware tables.  

Well, I read through the Intel GPU driver and this is how I felt it
works. It doesn't even check the firmware bit unless certain PCI IDs
are matched first.

For NVIDIA GPU Max checked internally and we saw it looks very much
like how Intel GPU works. Only some PCI IDs trigger checking on the
feature the firmware thing is linked to.

My point is: the actual *drivers* consuming these firmware features do
*not* blindly match every PCI device and check for the firmware
bit. They all have narrow matches and further only try to use the
firmware thing for some subset of PCI IDs that the entire driver
supports.

Given that the actual drivers work this way there is no technical
reason vfio-pci can't do this as well.

We don't have to change them of course, they can stay as is if people
feel really strongly.

> > Even so, I'm not *so* worried about "over matching" - if IGD or the
> > nvidia stuff load on a wide set of devices then they can just not
> > enable their extended stuff. It wastes some kernel memory, but it is
> > OK.
> 
> I'd rather they bind to the base vfio-pci driver if their extended
> features are not available.

Sure it would be nice, but functionally it is no different.

> > And if some driver *really* gets stuck here the true answer is to
> > improve the driver core match capability.
> > 
> > > devices in the deny-list and non-endpoint devices.  Many drivers
> > > clearly place implicit trust in their id_table, others don't.  In the
> > > case of meta drivers, I think it's fair to make use of the latter
> > > approach.  
> > 
> > Well, AFAIK, the driver core doesn't have a 'try probe, if it fails
> > then try another driver' approach. One device, one driver. Am I
> > missing something?
> 
> If the driver probe callback fails, really_probe() returns 0 with the
> comment:
> 
>         /*
>          * Ignore errors returned by ->probe so that the next driver can try
>          * its luck.
>          */
>         ret = 0;
> 
> That allows bus_for_each_drv() to continue to iterate.

Er, but we have no reliable way to order drivers in the list so this
still assumes the system has exactly one driver match (even if some of
the match is now in code).

It won't work with a "universal" driver without more changes.

(and I couldn't find out why Cornelia added this long ago, or how or
even if it actually ended up being used)

> > I also think the softdep/implicit loading/ordering will not be
> > welcomed, it feels weird to me.
> 
> AFAICT, it works within the existing driver-core, it's largely an
> extension to pci-core driver_override support to enable wildcard
> matching, ideally along with adding the same for all buses that support
> driver_override.  Thanks,

It is the implicit ordering of module loading that is trouble.

Regards,
Jason
