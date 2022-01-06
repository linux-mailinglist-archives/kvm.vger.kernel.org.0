Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790A248646B
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 13:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbiAFMfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 07:35:02 -0500
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:40320
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238831AbiAFMfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 07:35:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYDt/Qb/trQLl9HGmwxg7HhfqS5RtZRQeD9CWj2atOucNqWWFA/p7BbgMK1/Fs4KnxVBUSIuBUdM8FIDZloqt9gxQCKM4ZbR3ESctPBvwfKV6b1XdJjRIBbglMBBC3CDVhH21ssLIkZI8WRnbO3l/RxbiUOYiyfo10MtUndqWwudnC3S1fiV7V/+jAW+RZ33QwZrFlq/AkebXiYGCsc7dq0Yw29x1A8UBTvOWHMRkXEgb3iMpaaJtb9PrIPK94ejSlPdsFE9XushSf3K7kUKuswLdUeiqWs8XIyq/V6k0G/xDiOPhcH9yJshX7oC3X1y4a0cVCDVHhSOQW50kLUDYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxkJFyt5bnCQJYqz8u2UGExDud+y7gfzDerzhv4yLgk=;
 b=dUDjj/uGD66ExQ621E+TrsYchdtiC1dB6DIY2UpkxILYb+6Ev45fjwZosQ/EybQCnEHP3IUx8/8Y1l+A9EO5AkyUbN3bjAdjRqbrCW/kaJdXDD+Pw9VYzHt23raZqHEVsKng/gDcNbKcFgLBT5/2KJ+fq7JHpaVcuGw7kTjjwOtRInDIb0h0cYwdjXXQH8I3zFepvy1GGaSWV24S9244LG+WdUUv41ByNwn8sJhBrYeDFW7gVXg1NotKXxNamUDPomzlkJE7r21FAWjRaLHRbFAnQ7330FjUApzDBob8+JK4rV5za5O2loAqveA0VQV20a2YTjFsTmK0OgKzzLvDfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxkJFyt5bnCQJYqz8u2UGExDud+y7gfzDerzhv4yLgk=;
 b=RU+TAw5nu5+poLhtoqElak45PyDvVQwF00HwOJcRDI1t187IhHqwyIYnv5GCntvzUglbB/95MMfk2xU5JjtxAqnZEcZHkJbXaDK4gGIlTYASJ+y+QAefUljWDTykmlnNFJcv+ZPBwIVtpxlWRIUu9osiVAD7IiZlwM5z7p4PsS7UXmU7JzXuuODOb8mHh8INQSd5XqWbsN62GdxOfhwzd+HJnqzP7qNtbRNZp9zYDM8wDa/dgnGWn4xYHPJdzpRTdwGsi8NQLLEDsCo89VBP4ULZtNGUIyDXq9X5dvq7TlhHlkci4wrSLt2/zKvPG7xSu56zLUZR7CCwiT3MKpMtcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 12:34:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 12:34:59 +0000
Date:   Thu, 6 Jan 2022 08:34:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220106123456.GZ2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
 <20220106011708.6ajbhzgreevu62gl@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106011708.6ajbhzgreevu62gl@oracle.com>
X-ClientProxiedBy: BY5PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:180::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a45fbcc-9c80-43df-29e6-08d9d110f3ee
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208236EBE266F521206E139C24C9@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZ7JNxYH8QbRVuFkBiREwY34S8MJsSiJ17l8L7HrusAnA3irNWgz5mOcd6GVn+A4EZS2rNPsjXWJKssc58B77V9wV6N4Y+DK2XIK00bLiYwbfRqu87mXoKdGu2NOR1sOr9L5l2gsd04Zub2Ob1zAVnkhz+/9djryBHDLAi8ulikEFnihxepb3Xv07LmACfADjwDi82pkHLrw3N56bdO3o/hlQOYlrcDKlP7uNvMe4EXmRfh47RmkrTJPKjSmMjyBT8um30NmY0hj3Sr0UcsvqWADlbJa6BslM2+AI9+b5Dtsplv4AzZiPXOaf3yg9vHTxWXoN66lRlyV/4un+ulsETcIMzzUrakA5sDXw8BqW+1leOkWQA1Ji+XaKK7wTBHrg3JiztRJOtD22r6JT8VQDVrCiWXhde/VjoblntSFFzwMISBzv68JFnwcH5S33i64ElRtE1+ZQseCmGmiQ9+Q+zQX3ZsYxWWgrW/MYgkNFyjAZjphEaQgDz/lNxp3OOykefZl9svna2YCq/tHamjQKnJhpKVQS80KDOAi0YCroyWyeqEcvCs/w3Hf79eWnGhtMrbAXReYtE/jrA5vvLnYvhLpAxPIVvGo6MWHXU8Xh6UAvUruj8WhTyXa1EqEaRemBWpeHX2GNOOkjC30O7RtiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(1076003)(36756003)(83380400001)(6666004)(508600001)(6506007)(33656002)(4326008)(86362001)(66946007)(38100700002)(2616005)(8936002)(5660300002)(6486002)(2906002)(66476007)(66556008)(6512007)(186003)(8676002)(54906003)(316002)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+VIJJ/crGtRev+Dysi81iO2Z2KOGwtnlcTR0cPn1wRFRInzJ9Gkkp/W0VBYP?=
 =?us-ascii?Q?MrNtosjv7Td204apZn2uPi0tRmwuGGKrPfmTpVGBI2+uSJMG/VXfJDUDyZty?=
 =?us-ascii?Q?ugRJOX8b1canAO6gDI8BwPNZ/B1E9nZQr4SZ2t9/2TLaQgGie8f1DNkcfkdA?=
 =?us-ascii?Q?DiSfVW2Ot0N19MGlJa4R0qwuqzmA3goB4rqGy+zrhnKlyg5kj3cruZ1CccK3?=
 =?us-ascii?Q?D0Zh0pHJtWM6Mc2i1RFEStELH6JuBacvInjSvNkMsr4XNz1CV4wmKvEIupYe?=
 =?us-ascii?Q?IrozhGWe3CxBk6P6pcMJX5sHiNQNWyFyoAGcDynLcBTx09Xg5DRC7sZsu7tz?=
 =?us-ascii?Q?HhDUuSZy9uEAozwyTpLapO0GXQK7vfCeIYuaJm53kx6mxA6VAfAt40SRPTAy?=
 =?us-ascii?Q?ibSjK5gT6BmJeKjc9N8JXnFo+tIzbJvvEM3zE+qvywGg/b1Sa1w+9D8iFkEE?=
 =?us-ascii?Q?w5MuuKPcXq3GPa2KIqSp9TB1qOMMVtaZ0FKcNdt0zAjngAQFi1nQH56Rw75W?=
 =?us-ascii?Q?giiYPADZ6E9+8Jm7g0j7ctHbEzZScFur/j0cnOJKhTxLo3Ky92O+XTC9ClHA?=
 =?us-ascii?Q?4BUQxgnFhyChdrkrRERSPlgohpUvh9zVlDHswUQPBweaddLY03scdYYl2CtA?=
 =?us-ascii?Q?XKw1pNK8QTlU5Nq0oVEu/AX/N1a0W+Dgh05+rPt+TORF+itTlYKKpUMGZNlo?=
 =?us-ascii?Q?3Js4a7oBx1KVmdT37U+gC9Q4n1Xld6AUaHeqGHOUFyDaVff5IOk1hMHHzRj8?=
 =?us-ascii?Q?aHsdjOwqFyAB7UXt8jEwl3tvhQ9C9yXQskPrSz6GwFlO3r2d+qSza352ir9a?=
 =?us-ascii?Q?GHywAkcD3Dt6Foxeh1sngvBQW+yDzEfWGu9Eaeoy+Vi78McztLTLSNxcyIrx?=
 =?us-ascii?Q?rljtwNYcTu7b58XFxZju8SFmz4b6kpPjwIk/bk1WVpJyu0xhLJjpnAFk2gUf?=
 =?us-ascii?Q?g49rU3OlXLzy6pg2J+GMU+X4Lx1kvjaTew1qfhMep4DEhMrkBg2LNjQkRygk?=
 =?us-ascii?Q?StmxvHziaQbwV4WdvdH01LSNkjPeL3pI/FCFOeQlwrqozPJojeXkq8CsYpsR?=
 =?us-ascii?Q?N6wsgFzF2HhCtfbZPIhkG1BFbxPmfz6nuDQOSui7kF1xGSiZ0EL4QpK7lAco?=
 =?us-ascii?Q?gn0rSl+hqFyOEO+3HbuqbHPSoDBz2TUQl6huRnjBOwkP+QUGWKjWcOWKabCm?=
 =?us-ascii?Q?zyK5qXhrKJka5XKjfWtbI+sH/3Bzirdu3Ew7jd8R/ZiKPU4VssbamKpk9PuO?=
 =?us-ascii?Q?TyJNSz68Abn+3hYFo0Fj/HP3LBmZEAO7H/fRIspCNdod3BPZeXE4R69ct3pQ?=
 =?us-ascii?Q?+PaGspPhkDZ2DgIPZ/lbZ1dsF9BJFhofvUoHEoRSC4I1EjC8s2BieVlU8LBZ?=
 =?us-ascii?Q?Qg1a6U7F2NnrGMD8MagrpbWEUYp/Ep0D5KligCdwQRMiXaF44xeyB3bShCpJ?=
 =?us-ascii?Q?lHcjSgDbTzLXSXomgeRLalQqyoiXTYSWDePQRhgkh3clclFYEoCvOTLWn6xk?=
 =?us-ascii?Q?xPfvBuHYgMqcpqxtjhSy00lrtjsIkTvzVv0Ti1CL/fr5N+p/q7eqoort2Sv7?=
 =?us-ascii?Q?+Pvph1xMQh/QrtVMINI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a45fbcc-9c80-43df-29e6-08d9d110f3ee
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 12:34:59.5706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvVUX+KVIV7YoFOZA1DF7W10bCwF24HDBHeiVZ9Il6QAILPGE11vz85bRVRzG6JT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 08:17:08PM -0500, Daniel Jordan wrote:
> On Wed, Jan 05, 2022 at 08:53:39PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 05, 2022 at 07:46:48PM -0500, Daniel Jordan wrote:
> > > padata threads hold mmap_lock as reader for the majority of their
> > > runtime in order to call pin_user_pages_remote(), but they also
> > > periodically take mmap_lock as writer for short periods to adjust
> > > mm->locked_vm, hurting parallelism.
> > > 
> > > Alleviate the write-side contention with a per-thread cache of locked_vm
> > > which allows taking mmap_lock as writer far less frequently.
> > > 
> > > Failure to refill the cache due to insufficient locked_vm will not cause
> > > the entire pinning operation to error out.  This avoids spurious failure
> > > in case some pinned pages aren't accounted to locked_vm.
> > > 
> > > Cache size is limited to provide some protection in the unlikely event
> > > of a concurrent locked_vm accounting operation in the same address space
> > > needlessly failing in case the cache takes more locked_vm than it needs.
> > 
> > Why not just do the pinned page accounting once at the start? Why does
> > it have to be done incrementally?
> 
> Yeah, good question.  I tried doing it that way recently and it did
> improve performance a bit, but I thought it wasn't enough of a gain to
> justify how it overaccounted by the size of the entire pin.

Why would it over account?

Jason
