Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CC1487B20
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348514AbiAGRMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:12:52 -0500
Received: from mail-bn1nam07on2063.outbound.protection.outlook.com ([40.107.212.63]:29115
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348477AbiAGRMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 12:12:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo8FSGa0giwUhrsNsiLqM1ID6RMr5JSah1yKYdRFlKVqF/N/2bz8wb3PUAUjoEBSqdPaOlb6v0Gj1k7WoQade3ZxPOAs2WZnkobG7duoeyfZvcHFu6gsHBHWuZqeaIMdmSMvE3n7URjL/5+3ZXXmSOzEUXZQ9Jk+hySmpY6btM8kYmS2ji5SDqoVUxkrYOqLDb+OSjfm4TelJurWiiuMcdcGDuyO739LW5ePshpxD9F34CYSONcvsCfXyb3Qa2aHnCZ/BEWHM3u5Kcgdt9m/dTcgakVJi0pO6JBBO/oGRUpMJgRoyMWZOryyres/2IBIEU/5TA+RXNATyTKdzvSeHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGeerC0fk4AxA1Tto3XUy6zVabdSyrt7TAMZlmMRD1I=;
 b=lT6UQP966uTkFmvud5JKQHyfRIue4Z2oViBu/jP1Fzq5FOmLXmyELaiToIINyTZtj3XQR0AY8hrx+iZiFNYM+6GOaLXVXbjnsR9HbI52C0EUuQWlN1C7taqBL2nRqiiK61doOIV5rZvo70V4Dsg+SE9a9Qmj0NXh/3QJA0TQgnKzVSGTr1YvlaVaocdp8ENFC9aU4Xpov44psit+IfzMjPvUO6Z6GO/qoxZPsLswCAKGoFq+UNGmCrJNG8rNgvRC2ye9s/SpXaIPtkUl2y8lngWyiDeldhln4jIkkwp2FqltfSltf4Ihu+OZZhU2XX4AXjFTwlSVyvxX7/xuuFwFdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGeerC0fk4AxA1Tto3XUy6zVabdSyrt7TAMZlmMRD1I=;
 b=BKd+morRRyMuGsOPXbckWjQVLu2ZIGjemRCpUix34VUXMDDlOaunqbsRFR+Iex6D+FDTL6dy+PKGE1kaVDim4n+BLT4RhN/Yc0Ra5kkMtdN3N4ufhr2DbiyxcfDyg6i5S5qYlzfe2z1/62co5ourqjjHf5/ZzzvYxRdh4d/DzdQyeaFMZyxGvG654TaUvEZez0uPrRzVVeuxYGT3MdjaAdWNPsh68nN8iGbJ0ppXvIooUN140XQbpJ3IEZEstu4y/71ocje7NoSdRkz/u7zKVF2bQEKv5U0RW9DOtQ44XqAfIpOMSkB3Buu239XreyJJ8f0QQI+NcOgutMM50PiIZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 17:12:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 17:12:49 +0000
Date:   Fri, 7 Jan 2022 13:12:48 -0400
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
Subject: Re: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Message-ID: <20220107171248.GU2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106011306.GY2328285@nvidia.com>
 <20220107030330.2kcpekbtxn7xmsth@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107030330.2kcpekbtxn7xmsth@oracle.com>
X-ClientProxiedBy: BL0PR02CA0111.namprd02.prod.outlook.com
 (2603:10b6:208:35::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 649dcfbc-e04b-453f-f27a-08d9d200eeac
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB517618B763A9A1EEADDAD6E9C24D9@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uxC/+4MAFs/8Hiue3WCGhzauHF2hmhZzOxwHjMs2hnSsh6qjWHSZQwpzxt5SuT4fIodloeLROvVaDGkx9JoWtOtm/TOUNGpi9hbWSHkhzufaGvxJ1YCspVha1+E/jk1n0SwF0265o1vVKlo9qwDwcgpboibCLGX3o0sCn688a56zOgfOqY8+uq3aKeYybuZkkWfTeNOLQEGY8YCCmbuTWF7WIcTqp0t5eNtjfhACUIPyetb6ooqy7OGt1gIjKRIlPPdkT5TghTERi1dFCHwZJZT/ehmmdfhNkoYwCgN+MJcgc/k7TvzJo9CDjbeZU4YXZOF+LdzeGeCI7wvkhAKb8blvaoTuLaGWAwkkq3juYE0+48OqsIQurfA5IW8XH+NpRUbhrK7jQBvQnT5wxj3AKnqGCmJ54nAxnLuwd6AODQqOUxeP73RLpG3ziKb+zG0VOKbec9gIqr9jexGHfXuXEE/rqtwnnh7axcuilKO/TqHh7QYboah4CQtg9N8xMvq74bDuwxR/+ndATsl/OXeBD25ijRzQMVhY70+LFVTL6YZfXrx/cQaHLdwYYCLP/w21esfRHwB6WsFIBs1z6ZKz5UDWc9pe2mN9ew80bSnPdUl22KORBLE5h2JXaieCWO+ED4sTRIwSyoVBkTqdJT9Clg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(26005)(4326008)(38100700002)(8676002)(6512007)(1076003)(7416002)(186003)(66946007)(508600001)(66476007)(66556008)(5660300002)(8936002)(54906003)(6486002)(316002)(6506007)(2906002)(33656002)(86362001)(2616005)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xNA8M8acaIuuGm565wrw3dqDCb1jCNNPVDqC0dYhXW4kVkKIuL0oKgZ3tkio?=
 =?us-ascii?Q?AZ2LNr7tPRF8o46ZJovCqoq600K0JIYcwSjcfL9Evvw29XDrDwnHzFIPExci?=
 =?us-ascii?Q?EWrgxW00tC2tDcnKswJ0KxNUnmyEwBlvSq4fdrXao+pL0FrWZctNovyF4u43?=
 =?us-ascii?Q?LySn/FcvpAXQR6GBpIm4CKhraIc04UNo0JKT5cYudo69Erwv/zPLC2ACBZpj?=
 =?us-ascii?Q?+Fr0Yt8PtoDI9TcB0riRA6CF3lDBAUcgUGyAFzTxaDlug2PH0TTWn3zlQNdq?=
 =?us-ascii?Q?+EvwgYSyZ74e8XW9vHLecmnQdCDbjGK37c1yNeMOM8YDYjIQ8kmo1Z5jGel4?=
 =?us-ascii?Q?u3n9qXPisVAFHSwV1ZaNsxc08qaYL6l3vNCHfKWSwcokGO8C4sWngbb4AgqW?=
 =?us-ascii?Q?7ak4s+ILRe8isZNCKP6VrgTpnHGzPoFYUpxjDwoV9Q8+TMCcMRs2Tx+DbCVe?=
 =?us-ascii?Q?Lj45R8v2l7mE+kRfIKiDjmH7Y/x0Hr3jZktECyUkGEXw8CX3r1kG1ge92DMW?=
 =?us-ascii?Q?ePaZs9ZxuYWiMmScT/4hs+w8nhOH2awtvar5gU1NkJCuMnHMH3B2QBZY4VZa?=
 =?us-ascii?Q?98aaULwMM7uSw8pE8F/OO/lDPwTCWcff5HsER2o3XX515X3HJS89L76CpzZ/?=
 =?us-ascii?Q?zMRFW1rWfCylR9apKYshhfk5MVp4aNYdJdH6Dsqd2ytax9+bfVrkibGHqUAJ?=
 =?us-ascii?Q?de2/22Y+DKPIZf42vIUCfQ/5wZFPs++ekQMPz0EPv5y248zERpzzfMPovHOz?=
 =?us-ascii?Q?A0aPJSIe/JwqDQ3gcws48UGSQR0JMu19YV94bCGxtQqiKejGP8CGYyD8ST2+?=
 =?us-ascii?Q?VutLuNsDKHPHHLxDslyW9Nh8Q8M0W+W0qVaomCC8clcBpzbMphObdky3WWU/?=
 =?us-ascii?Q?bAU0k8aq/F7/5AtX4S+8QeVbfD6HgV5+1W8GOqkRgUW1ZJ3DsHrmesG1NH9i?=
 =?us-ascii?Q?0O2NykDTSRv1RR1mKVogA/n4SvrDLflk63zEoDsOxrUrefNWT4uCAuAiDw07?=
 =?us-ascii?Q?eRBP0igain1aEo8QZpP1eJFJrhbQxfzTEdsON+lmTHuPMJm865ts+yn1uxcT?=
 =?us-ascii?Q?CbX07tgQbK0V9VKrhOtN1Q4s7S2CNjQd5jpl7iSItBCbZ+1BBPQFm2GHG8+h?=
 =?us-ascii?Q?djndMVBa16OPrXaVNvl4x528NpGxXZAxroF+yBUnpOJDKnaTa41xgL3UbWOV?=
 =?us-ascii?Q?5vDqH1hBFD+19EYk1IR49FxP8bPanzQEbFdbtyvAtDxAO/d+wGaI1wcT6d8t?=
 =?us-ascii?Q?Nu31eNUb/4ZHyXDz7zOMo2zZcscZ0CIfzpeyYrj8WbAT4clFu4Ixu1aLbl61?=
 =?us-ascii?Q?XPIeypyQ+xEKo3W41TZI48dyoPHcpGSBx7ZjHUipASIHc1st8nsCHksMwc0f?=
 =?us-ascii?Q?XAeLyl/9TfLgB7GWIcAUzpHfSovzcrT6w7EtCKUjgujoKGxvsYHmPA7+ywE7?=
 =?us-ascii?Q?lFIo/1h1UVVJvyp61eDsCPmeLc6kYH8CVSRhld6+0cnObBX7NLf/8lEmqi6E?=
 =?us-ascii?Q?ZuOiAAiaBRgm6qqFhNjchAxOrrUiVYbpgKc0ikpn/kiDkyySrP3HEDSDr5Cm?=
 =?us-ascii?Q?Mm2x5Sz/7Oldmt6iHSs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 649dcfbc-e04b-453f-f27a-08d9d200eeac
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 17:12:49.7498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vU4pFjB8iJtzlhKRy4NPDyXYFyREHLRUVsX7F4c0RSxyMEXx8OrFNLFVBCfpUsK5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > It is also not good that this inserts arbitary cuts in the IOVA
> > address space, that will cause iommu_map() to be called with smaller
> > npages, and could result in a long term inefficiency in the iommu.
> > 
> > I don't know how the kernel can combat this without prior knowledge of
> > the likely physical memory layout (eg is the VM using 1G huge pages or
> > something)..
>
> The cuts aren't arbitrary, padata controls where they happen.  

Well, they are, you picked a PMD alignment if I recall.

If hugetlbfs is using PUD pages then this is the wrong alignment,
right?

I suppose it could compute the cuts differently to try to maximize
alignment at the cutpoints.. 

> size.  If cuts in per-thread ranges are an issue, I *think* userspace
> has the same problem?

Userspace should know what it has done, if it is using hugetlbfs it
knows how big the pages are.

> > The results you got of only 1.2x improvement don't seem so
> > compelling.
> 
> I know you understand, but just to be clear for everyone, that 1.2x is
> the overall improvement to qemu init from multithreaded pinning alone
> when prefaulting is done in both base and test.

Yes

> Pinning itself, the only thing being optimized, improves 8.5x in that
> experiment, bringing the time from 1.8 seconds to .2 seconds.  That's a
> significant savings IMHO

And here is where I suspect we'd get similar results from folio's
based on the unpin performance uplift we already saw.

As long as PUP doesn't have to COW its work is largely proportional to
the number of struct pages it processes, so we should be expecting an
upper limit of 512x gains on the PUP alone with foliation. This is in
line with what we saw with the prior unpin work.

The other optimization that would help a lot here is to use
pin_user_pages_fast(), something like:

  if (current->mm != remote_mm)
     mmap_lock()
     pin_user_pages_remote(..)
     mmap_unlock()
  else
     pin_user_pages_fast(..)

But you can't get that gain with kernel-size parallization, right?

(I haven't dug into if gup_fast relies on current due to IPIs or not,
maybe pin_user_pages_remote_fast can exist?)

> But, I'm skeptical that singlethreaded optimization alone will remove
> the bottleneck with the enormous memory sizes we use.  

I think you can get the 1.2x at least.

> scaling up the times from the unpin results with both optimizations (the
> IB specific one too, which would need to be done for vfio), 

Oh, I did the IB one already in iommufd...

> a 1T guest would still take almost 2 seconds to pin/unpin.

Single threaded? Isn't that excellent and completely dwarfed by the
populate overhead?

> If people feel strongly that we should try optimizing other ways first,
> ok, but I think these are complementary approaches.  I'm coming at this
> problem this way because this is fundamentally a memory-intensive
> operation where more bandwidth can help, and there are other kernel
> paths we and others want this infrastructure for.

At least here I would like to see an apples to apples at least before
we have this complexity. Full user threading vs kernel auto threading.

Saying multithreaded kernel gets 8x over single threaded userspace is
nice, but sort of irrelevant because we can have multithreaded
userspace, right?

Jason
