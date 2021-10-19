Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB1433CD7
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJSRAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:00:05 -0400
Received: from mail-bn1nam07on2059.outbound.protection.outlook.com ([40.107.212.59]:58689
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229774AbhJSRAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 13:00:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG31EihRD+szcb2rLOhtHWVMeT7McXKbi/Xt+/VQYl6rLt9d0HLOYrGMl7MVCbloz9veeFd8KrmDSb8xckDhoV278HQAtqOyIlOHbJ2ifwwiFMvI7oYdeGefRqCC3jYf4Uo256q5OTnIoSjlOgSBHIjo6or5rKQNPtzI0V9EOyT8A2fiz/uFqwzA9Ue9mSvFBfEFqFeRkcTDGOHhKhHHZzfMotQ0NdbHHyZGPSiwHTEqSLO0gHkRC1I87vXRtkCN+Y2bNjqGvI+AyVzHaaZokqLIH4BJhSFX99STk5PlOAYSbSRzvGM4DiG5AwOwyafqWqBfhVTQ4GFFFxpviHG2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEn2TYUim02u5JRBzUQwOk9Uwn3bmXG8J/rLxUFX5Z0=;
 b=FFaWGoJ1KNDZNtgA1wAgr53pGsssNS0mQS5GlAknGCYMwimrO+9AVC8ZMUcBFt/BFDk+RfzRqck5sEeJRfDKs1IsUcrsZCFBVgb2IlRE9SP+/3qo6DbWDur67j6NtPLec/skq32ba+A/z3ZETaORs6WbJ9p1MzBRqA3VPH8csTcDi4ZWw8AMLwFMe/tpJJPaeUJeEHSUSYQ9FRcBOlDPc0zjrk+RQQqbMdhg+ss7J0Kedcse3wSFkpLs9j9dECYxoAZVDibGFJvzrJKJSgEf676iUPqJV5QMW/zocd/CJPHj/tHBwVjdjYXJuI/ue+FQYpcRdI6x1xJyVqlDIXz04A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEn2TYUim02u5JRBzUQwOk9Uwn3bmXG8J/rLxUFX5Z0=;
 b=FGfmt4Oq8WtDYHFl1SpvhCBN86K3JkTyKyUYR7K8an3EDNGMF8baAq1quP9Em8ZKd6ftlkkzLBHAEkPxXkSD/cewlUN4av29wFox7yR87qFejeSusuHUqGoTllFR7OsYpzy6k3Trp6/OwNcIYMPfMML6FvH1ccTHKF9wPDbxE7g7R1AYgaE35xknBhdp+aqtVqwB4hzE9Hd2QGqogk6phvA8roIGDsleyPLngcUdsYuP+NcpbQVQ0FtJ1e70doJuDBMTPUoWCP3oH+UUwEB4erT7b/1xk8/7QdbE5Qg9x1c9HrE3blHLFGMdWOfStrZxRZMsS5I6uQDiK5QpFAiCBw==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 16:57:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 16:57:49 +0000
Date:   Tue, 19 Oct 2021 13:57:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20211019165747.GU2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211015111807.GD2744544@nvidia.com>
 <20211019095734.2a3fb785@jacob-builder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019095734.2a3fb785@jacob-builder>
X-ClientProxiedBy: MN2PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:208:15e::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR17CA0010.namprd17.prod.outlook.com (2603:10b6:208:15e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 16:57:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcsQt-00Gk5s-BG; Tue, 19 Oct 2021 13:57:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c9bc708-49b6-48e0-dceb-08d9932194cd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5352D5B8F795A369EA394C4FC2BD9@BL1PR12MB5352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1njDKQYoDRICrF9gPtaXJCG7BMSx6Ko5A/B4ITOm0q6sanReuYLWzjWLh3+P2VeQPhfIa5A+kJ9JvvJuI6Mlpu3AI3QglnpgDkHY1mZFsP6nkgq+UHKfqetre23pjnySDK2dYI9fpleUHrFpa+1PaPUodbBpcpUtFYd1A3/nyaiissS8t1x1sbvL0WEFSldV2I3jact2tsmO9am48jtNEtfpRULd6HzA3SQrjKpmBxkDGX0ivK4IHtm3uv96iRH20hVM+V+Vc/Ww1McE2jkMfbw7iElzwav+ZQDAcCQoIO4+EAhsCxE6RyTDe4W63lP64dSoVAwkpgPXhMxDM3urTKciVQUCvJXAq12KqSmLEeMUZO2NdQUVZTNw0zzvoGAeYhrLI5MyixkrLYYBeYzrf0Vjdd1+S/tKAAMF54Iql0IDSDz6dYjhIxHfQXVvXCLJD4CQ/H2bA+seUPxYIaq55wJ4n++BU6UtxGatfFoLM02z7AVn7j6n8JSL6cbEm0vSl1v4ROKzh2uQ1Z/LyE2/db+dqJcexTakbZTq5PhZ8/C9zSBFX0K11ZzmFlDoldnCi1aXOHCX/b7moThAAE3NzTBu9FKE5JSiS3bvunLi4kbrvRsMhYY4Q288hdrRfUgncU8yrneeif7G0K3VcEjkuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(107886003)(66476007)(26005)(4744005)(9746002)(83380400001)(508600001)(54906003)(186003)(426003)(5660300002)(2906002)(1076003)(7416002)(2616005)(86362001)(316002)(38100700002)(8936002)(6916009)(36756003)(9786002)(66946007)(8676002)(4326008)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NJPGg9J+VCrVfZ6BjI06qQGLV7SDKFLUuM4sg/Be9A2MQefXDDFuSB10hEzL?=
 =?us-ascii?Q?HE/8ZMwRoXwYtZCFkF/tjKybyJpYcNrRsPgkmR6MUQMKKd4HaDs9mqPyEhHN?=
 =?us-ascii?Q?nwEie3f4la71QQVrmqYsr4oa/Y4G7BMhztKTXnfu+xqVRhuVA0Pucs9l7ptt?=
 =?us-ascii?Q?iVjx5z/bDNxrhAN9hLWtVxcMug9J+vZBJ9x/x6jnDe80wde3J4rNRwLZh+J3?=
 =?us-ascii?Q?v2UTTJ94ku+C2G5DZn7eT2E2eKygkByAv7vgQFgl4ECZiKuqcDqTtgIgfjEp?=
 =?us-ascii?Q?Piea/tBlF6n+W6A1DshtWcnTJqsD2QEKH3P1/TTyd5Rtfb/SDiASTsktAhRy?=
 =?us-ascii?Q?LUaTUX7nDHgqdpD5J2M8v7jB1QU7bwEHUvUW99elC4Ywl2BaQLyOtii/2bgG?=
 =?us-ascii?Q?Pm14otkfwYjL0CVLLf4SF/B6sJ6j82vPG4/d3peLDid+CN5QK0swS82YHj1+?=
 =?us-ascii?Q?RiPHMrXKbdcqMyp4unIjmY8v7wKqzUvR1qE3nNRSHCaMH1QzE6GTZuOCc42C?=
 =?us-ascii?Q?CrmEHY+TbvQDUMUGHjlmnFtfHRmsYsJTQ+U//R7OyaCazi9ZOgBZ67NsFtRs?=
 =?us-ascii?Q?rYMrWjaI0U4swMLj7C6D6IrJqDmmtvy+ugYckV5MyPgmkMfLMMJYXp4xtmpl?=
 =?us-ascii?Q?u+emVJUoAgZEqg14fEhC/2sHjHdtrk3ykqUfR8bHZLCeXksEesEKbBCGk5a/?=
 =?us-ascii?Q?oR1f4RejGO5TwNt7I5wvvmdf+jNrt30EuYBChjYtyWBhdRZGd/3jc3srhc2a?=
 =?us-ascii?Q?Vd83dkCrNDjbLqDN8DMbWuwKmLa15brkUp7o+Ap/9GbYupsSDkGQgWdN6lQ/?=
 =?us-ascii?Q?wTr918Hq3+0ecrLnow0uW9ZB6ycuu6B32yvG9krFzB4BV4MXdogdkhjp42Gl?=
 =?us-ascii?Q?FgGuOzIiuIv9CJRSYfQ383RawWsXhccNArkXcBAkAFXLbOAUhnOgB4XIy/ky?=
 =?us-ascii?Q?/KvUe3WQI0z2wAyk03+ENwhbpAOlYR9pZG4cL7JY5Syor9Gnexb1qYPb7eka?=
 =?us-ascii?Q?pyYP0mznWQg41C8IPoIO5a+I7tlCp45/A7M6UJVm3H9nWwLCSCxs5UBcGhBO?=
 =?us-ascii?Q?q3zW/VnckVlxX9dTeGEvTCQ6PJLk3/nvXPTemIrXQg9cdRcrXfgsFg0EEiu4?=
 =?us-ascii?Q?IsxktXoYgtFSik7P652777IPJCqdb3HIuDwveyKKre0caMpdH6zJnY8Zpe8Z?=
 =?us-ascii?Q?SnmnGqu5jpe5TTN4zzW729vPEHXTveESW269e6SsKR7yefs7aIYmEk6xWkF9?=
 =?us-ascii?Q?W00EacU2ZUVjqG63fJ3bWvxkQkXlFlo7bYLJDITrMqz9d21Z5fTEE8x14xKT?=
 =?us-ascii?Q?ZuWoJAZ2XOfivmhEY6ARmtc1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9bc708-49b6-48e0-dceb-08d9932194cd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 16:57:49.4865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aa5bQc0RK2gZ4zsJFOW3XDyNBclkONBzK5POKElOhL7t+5rbrl3TG97Z7QDgpM4r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 09:57:34AM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Fri, 15 Oct 2021 08:18:07 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Oct 15, 2021 at 09:18:06AM +0000, Liu, Yi L wrote:
> > 
> > > >   Acquire from the xarray is
> > > >    rcu_lock()
> > > >    ioas = xa_load()
> > > >    if (ioas)
> > > >       if (down_read_trylock(&ioas->destroying_lock))  
> > > 
> > > all good suggestions, will refine accordingly. Here destroying_lock is a
> > > rw_semaphore. right? Since down_read_trylock() accepts a rwsem.  
> > 
> > Yes, you probably need a sleeping lock
> > 
> I am not following why we want a sleeping lock inside RCU protected
> section?

trylock is not sleeping
 
> For ioas, do we really care about the stale data to choose rw_lock vs RCU?
> Destroying can be kfree_rcu?

It needs a hard fence so things don't continue to use the IOS once it
is destroyed.

Jason
