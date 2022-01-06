Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720A485D73
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbiAFAr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:47:57 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16482 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbiAFArz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:47:55 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N58XH007590;
        Thu, 6 Jan 2022 00:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1R5dould2MVk1Qz/Ri7lqDW2iwJ1bSRGeVZGbWAtiVc=;
 b=AROGK+5qCSqM9iDtEIwLPZd8qscYtH6RI2X1kpW/cP67E3v16YQApLBz17nb+OHr/1fo
 SczxwTdZE4awV63McFNpmpUOW5PBmm7uXVhP0DxDrhm9w5OzbalQCJJSL/VqoNoCPDFi
 FBFx+W+oAe2JX24YhF5ArihWoFIBQ+JiY7SvMsX+FFZBE0vgK8cJoakqZwhbeVqV6kRX
 5JtC42I1SuS+HCQczth89/H8A1qtj4gLuvC5bNIQHEWbk293QgvH7eRzJiz4NIOrwHaV
 lXPRqOSaCRHMpgeyv+LAgA9CKxJoycPQpRUWajez0VQTQZXVUAhrFYmJbtg2UGY56QZa pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpm03wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VgRX076295;
        Thu, 6 Jan 2022 00:47:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3cxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AECLjg8EMOovL6YRlpIUvw/mkRqs0+6Fpj31KgjZiQf0mBdR/VcJMNa86f8QZwH/8hnnCh+0taKD6eASiEukDqQgucV8niGM1BWUI4Wr9GEaovAT2f988KRled+SaQWwUQ8BYdu2p2xJ3wBV/zVJjVccAymgvLaecC8WDRZzmCaZAs3IrpfCHSkqBWD2oLtkuGb+v7R2xA1fALDNtHllOIKIvJNz6EXQozlqSpba1HRwOoCKXtEJTxlRzVprK1/0DxJnreX4ozCMl4CzH5qGxLMgmN62QNr0T5afMAq/FThDqSrVho2+5gFDf+7KMFZBH4ct4Okpq/FdsUqXKEzblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1R5dould2MVk1Qz/Ri7lqDW2iwJ1bSRGeVZGbWAtiVc=;
 b=Qt/og6121FiA2qBL6jqjxKxLsZgB0YsCs7Vk0uhY6mJfaPX48TpE3Ul4PVgL8BWs/eI2IkOmD/rBSNugjHcEF76vRJftKMHk/c8nhps1Zfgp/wmifBqNQNMS8lfsgddGC9/zcmK2U8sCvvt/hHelyEerZdIbTSWDZBgWDahzjG68XXS0rDV/qmTIbmU7y5BUk95sCeWfrYBEU37Lc69iEqavAinb08ioheZCgLe9B7eChOwtCaPCJ8yIItILsYDFwqdq1lwEOeRcWiIXcCh6PzkctiRU+2wzCLeKoZLz4miglktUSDI/m+93qNvU2ro+gMRELce2NRnxMJgTyVA59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1R5dould2MVk1Qz/Ri7lqDW2iwJ1bSRGeVZGbWAtiVc=;
 b=fozWlQSug4sujseyqqjfy0iawN0mcvGlwrJokUjU3PiV4NS3JU5K6r/kS19TAb+oL5stQpqjXaxO9d93HMthOvgoUflzeaSVur6vf2TM36TUmEekvTV7lIvYJAt3lMbEg8LJ2/hbR2AFuVyz91LQ5g34V71OdQAUe67qf/ThPa0=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:13 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:13 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Date:   Wed,  5 Jan 2022 19:46:40 -0500
Message-Id: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 766e7327-d24f-4370-489a-08d9d0ae1452
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422CA313EC39E0D3325064AD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTTtuwSphZH/RGzPpzQkLLvOdpTSCqSI0DB1r7jlnbk8bmfOwHqg7++0BA3gtXSYkEuF1U+gU+axYQzWLhJj/I4LOCAArs0n4br7oSN9Hd1U0QE/fv6OTmvvp1SJxcS/QKPjA6hVY4z6yM0UnEQGODghP57cWZIAOn70tQ80aVa3uRCsHa98eRw/o2SX707hW0z47uT8+fM0oVDOIr7E/rFeerntEXCFaxfeDpXjh4iTAb/wOx/yhTqbNuThP1i2k8A1EZiOI5JX3mhTKqQIDvySdfmxSF+TA2/cLQqwnh5wCkIixtNkPOZK9dMIB2oLwFZ0aGLja7e1f7frfRPJwE2O/Te3RQXfNpdCuZaqlIEYmCBou2l+tf5MxUOXchgJlMqTF1e5wGNTT3RWhF6mY6+KdlH5kUikxRS5CI8yhc8WtdpUpNs9jJj1Xy7g7BMy0B5xS+qFa/b4OBEK7sxbbae7aB286plh/UxjasY7XMu0XEY3hOKnaNify6D1SK2jSMLTLRID0GvgMDwZjv6ke/MscWKQAooy2NjHNsuFPHhJxCU4gNw80EGAn/ObY0DtlYF0OWiBNdkQwZ6qLXVPKl5YVbV4vhMcfn9iE1VsBrtvDUln5EoIb/zreH9Qc1+V0rv0ZWcftDgiNxQm+xLp5ODs4wYoTDOaTYXZ10UX0+Q9TIQhP27eIxLFFrlwIagoAidFMKHJeD+rFd6n16YfkjcpBgzSECWBHA1sdtAjHOzk5XZIsm/mkRQqOEY1Fw+zHAvXOFQ8fYh3zGADQqRgSdQ4K49Lq+OUdnjvr0RwLTlnDAdU5j/W3WQ08VqpCFEnO2Ye4BPMMhoOgxDZbkb3cIxTk1GcvNmlHZ0MuvtmUc0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(966005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?75BYRBXpzp/zmw8iDZQ7barEAtKYl3PonTyu6iO+UGG++QYnOMbhnwB1WBIB?=
 =?us-ascii?Q?OoNdP0o5RxYRthsdBRYqpW0KR6SA3N0qowEif+Wz9i4lCvDmp+eZNn28Wuxh?=
 =?us-ascii?Q?mWe7L7nGpVtVwvlf6NtShtyU6jprJ5ZaA+kPcmtXq32i0vYwTpC8085kSYhl?=
 =?us-ascii?Q?gTu/QFqET4KmINYMEhyyQYkjHkQHUPqStR70kDiD+/IcIYz8DkQbuB/vIEjR?=
 =?us-ascii?Q?Q/o8Ty8Mq4RTX5QH+PVXrpzVCHs5oxjO0Cbd46Y+Yp3Op2ZVVQrwT7IQhUNL?=
 =?us-ascii?Q?PHvz0Jr2xeZveAioMoksGFaVRcsQNtMEelnELH29M9Frus/TBcnvmnoSmrlf?=
 =?us-ascii?Q?rI9kmmGDXTjSJ4DhwvJCVQ5d8//XFHRpInL7C/5k3HSrr/1BKY3IAuspJnOk?=
 =?us-ascii?Q?JvfnNqfSIT8RmxFJoD/qjS697Nrn10edxv7Hm88NdfWhKsl33Fxi/VC+HXTE?=
 =?us-ascii?Q?xIZjzbgxpzB9EjbnMmowYv+/KWx6/gaZ4u//h1y5oCIP1HBuTnzdA6puT5d1?=
 =?us-ascii?Q?OaFt0lxJ7M9l6hn2LX9P3xiFo5kZJ6AW8n+UwU+enFIpMftOM2zwUBpERdbL?=
 =?us-ascii?Q?qhX4f0xvpM9DUhbf39DdfgXFtdMJwDTMG+uNSDznVkvLcgBGims4oXPr0X9A?=
 =?us-ascii?Q?FgIrXmU6AZxuhshW7v433jCzaZyzJjpqT5WPWhZVxZm9+F8XcSb17a9fasn7?=
 =?us-ascii?Q?PinQOQwYOPKoSKsB6gegG856s6S2dqvJRUnUcKX9aofHH3QCfSxVxBtvB/+8?=
 =?us-ascii?Q?rv7THRHSihgwc5NElKmOBBz+/J4gl76C1jcVKmlQeJeg5DNGqDDeSwuFo2df?=
 =?us-ascii?Q?CQTcbsJ3IxHeDOd3TqUADngXmL4iyshrV5HDacuIGoQ/bFUMejIh/1CQ5W83?=
 =?us-ascii?Q?oMjWb6Fk1le6WTqi5gOHWsbM9h3pr/uNS66Byyt0w2z9jGl3+b0jDUyxAUts?=
 =?us-ascii?Q?EYIyEclO2ejTH8tk5+uzdPk5EN4JdCTiqEPRv18V//J5HGGIj0BXK2ZJMGnV?=
 =?us-ascii?Q?DDTU55VHhWf2clyccEDJ8A2iyWkqg/uzUZSB8y2TirstF/CEiBzQ9rTBmPzM?=
 =?us-ascii?Q?siyvPhJRI2cS+G7laq/ohAxtev6nF+a6RS4rd95RYzQTDM7GXJNaK3REtsRG?=
 =?us-ascii?Q?qNE6XQMiatkcZEWzN89wc2yN4ZZpUUTtsknf5R/iAb0D92X2Hg2zqSVft2eI?=
 =?us-ascii?Q?kuv3ZOoBh5vJ1p6pDoYG14KbudQ8Pa8yVsNof4x0ShjnPo7XItPHac77rpiy?=
 =?us-ascii?Q?aR7L32cwQ0BEpyeZ4Di3pzLv1K6iGisaBbssFvETPDBX1kPPOPDGJ0uzmRR1?=
 =?us-ascii?Q?dmkcPqrIUhes0FGbhVZ4LQ6WQJeIZBKxugTZkyxGWAPhhS2/42BiKtCntaga?=
 =?us-ascii?Q?uY4hNlcx8PyYrIcqv6bI7ORbl5mAKHZ1Q/HN8nmIrLJ5DWeCC6XwIRBpGVVd?=
 =?us-ascii?Q?CpTL/BQ8rc1Jn0NJH7sMYlwyIsWETySyqbwNJjh8iCOteH7whu6Z/HsOf0hV?=
 =?us-ascii?Q?MELnUDRpkhDCoE/ywdcIwvnkNaIlOb4iZY9efpDZ3yno3ty90gXE07PS6JE5?=
 =?us-ascii?Q?FCyhOEqnH2twtw81UQyhzIHUXTjvs0DIGXI0IIrko4t6WyLv47B2jtOmNHJy?=
 =?us-ascii?Q?Oz1USpSXkNX9UfTaM+EKIZVY+zM4Mh0ecLBwYapm2wm4dFBwCyQfyU03OkNY?=
 =?us-ascii?Q?VJ7LvpqxuX6uOu6BuOApCL9g6sM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766e7327-d24f-4370-489a-08d9d0ae1452
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:13.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGjPdmQCUkFh5+1AWLY6sP/ggZNsbvtVLROByHWd1vnKkn8P1l5DA787S8+BGYqUR1QozK3zPr6nBA5jZELaev6b4XRFLzmINkqrRhLe2Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: E_VuJnbPeGK9tk_absXwjY9P4TsXRcQU
X-Proofpoint-GUID: E_VuJnbPeGK9tk_absXwjY9P4TsXRcQU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Here's phase two of padata multithreaded jobs, which multithreads VFIO page
pinning and lays the groundwork for other padata users.  It's RFC because there
are still pieces missing and testing to do, and because of the last two
patches, which I'm hoping scheduler and cgroup folks can weigh in on.  Any and
all feedback is welcome.

---

Assigning a VFIO device to a guest requires pinning each and every page of the
guest's memory, which gets expensive for large guests even if the memory has
already been faulted in and cleared with something like qemu prealloc.

Some recent optimizations[0][1] have brought the cost down, but it's still a
significant bottleneck for guest initialization time.  Parallelize with padata
to take proper advantage of memory bandwidth, yielding up to 12x speedups for
VFIO page pinning and 10x speedups for overall qemu guest initialization.
Detailed performance results are in patch 8.

Phase one[4] of multithreaded jobs made deferred struct page init use all the
CPUs on x86.  That's a special case because it happens during boot when the
machine is waiting on page init to finish and there are generally no resource
controls to violate.

Page pinning, on the other hand, can be done by a user task (the "main thread"
in a job), so helper threads should honor the main thread's resource controls
that are relevant for pinning (CPU, memory) and give priority to other tasks on
the system.  This RFC has some but not all of the pieces to do that.

After this phase, it shouldn't take many lines to parallelize other
memory-proportional paths like struct page init for memory hotplug, munmap(),
hugetlb_fallocate(), and __ib_umem_release().

The first half of this series (more or less) has been running in our kernels
for about three years.


Changelog
---------

This addresses some comments on two earlier projects, ktask[2] and
cgroup-aware workqueues[3].

 - Fix undoing partially a completed chunk in the thread function, and use
   larger minimum chunk size (Alex Williamson)

 - Helper threads should honor the main thread's settings and resource controls,
   and shouldn't disturb other tasks (Michal Hocko, Pavel Machek)

 - Design comments, lockdep awareness (Peter Zijlstra, Jason Gunthorpe)

 - Implement remote charging in the CPU controller (Tejun Heo)


Series Rundown
--------------

     1  padata: Remove __init from multithreading functions
     2  padata: Return first error from a job
     3  padata: Add undo support
     4  padata: Detect deadlocks between main and helper threads

Get ready to parallelize.  In particular, pinning can fail, so make jobs
undo-able.

     5  vfio/type1: Pass mm to vfio_pin_pages_remote()
     6  vfio/type1: Refactor dma map removal
     7  vfio/type1: Parallelize vfio_pin_map_dma()
     8  vfio/type1: Cache locked_vm to ease mmap_lock contention

Do the parallelization itself.

     9  padata: Use kthreads in do_multithreaded
    10  padata: Helpers should respect main thread's CPU affinity
    11  padata: Cap helpers started to online CPUs
    12  sched, padata: Bound max threads with max_cfs_bandwidth_cpus()

Put caps on the number of helpers started according to the main thread's CPU
affinity, the system' online CPU count, and the main thread's CFS bandwidth
settings.  

    13  padata: Run helper threads at MAX_NICE
    14  padata: Nice helper threads one by one to prevent starvation

Prevent helpers from taking CPU away unfairly from other tasks for the sake of
an optimized kernel code path.

    15  sched/fair: Account kthread runtime debt for CFS bandwidth
    16  sched/fair: Consider kthread debt in cputime

A prototype for remote charging in CFS bandwidth and cpu.stat, described more
in the next section.  It's debatable whether these last two are required for
this series.  Patch 12 caps the number of helper threads started according to
the max effective CPUs allowed by the quota and period of the main thread's
task group.  In practice, I think this hits the sweet spot between complexity
and respecting CFS bandwidth limits so that patch 15 might just be dropped.
For instance, when running qemu with a vfio device, the restriction from patch
12 was enough to avoid the helpers breaching CFS bandwidth limits.  That leaves
patch 16, which on its own seems overkill for all the hunks it would require
from patch 15, so it could be dropped too.

Patch 12 isn't airtight, though, since other tasks running in the task group
alongside the main thread and helpers could still result in overage.  So,
patches 15-16 give an idea of what absolutely correct accounting in the CPU
controller might look like in case there are real situations that want it.


Remote Charging in the CPU Controller
-------------------------------------

CPU-intensive kthreads aren't generally accounted in the CPU controller, so
they escape settings such as weight and bandwidth when they do work on behalf
of a task group.

This problem arises with multithreaded jobs, but is also an issue in other
places.  CPU activity from async memory reclaim (kswapd, cswapd?[5]) should be
accounted to the cgroup that the memory belongs to, and similarly CPU activity
from net rx should be accounted to the task groups that correspond to the
packets being received.  There are also vague complaints from Android[6].

Each use case has its own requirements[7].  In padata and reclaim, the task
group to account to is known ahead of time, but net rx has to spend cycles
processing a packet before its destination task group is known, so any solution
should be able to work without knowing the task group in advance.  Furthermore,
the CPU controller shouldn't throttle reclaim or net rx in real time since both
are doing high priority work.  These make approaches that run kthreads directly
in a task group, like cgroup-aware workqueues[8] or a kernel path for
CLONE_INTO_CGROUP, infeasible.  Running kthreads directly in cgroups also has a
downside for padata because helpers' MAX_NICE priority is "shadowed" by the
priority of the group entities they're running under.

The proposed solution of remote charging can accrue debt to a task group to be
paid off or forgiven later, addressing all these issues.  A kthread calls the
interface

    void cpu_cgroup_remote_begin(struct task_struct *p,
                                 struct cgroup_subsys_state *css);

to begin remote charging to @css, causing @p's current sum_exec_runtime to be
updated and saved.  The @css arg isn't required and can be removed later to
facilitate the unknown cgroup case mentioned above.  Then the kthread calls
another interface

    void cpu_cgroup_remote_charge(struct task_struct *p,
                                  struct cgroup_subsys_state *css);

to account the sum_exec_runtime that @p has used since the first call.
Internally, a new field cfs_bandwidth::debt is added to keep track of unpaid
debt that's only used when the debt exceeds the quota in the current period.

Weight-based control isn't implemented for now since padata helpers run at
MAX_NICE and so always yield to anything higher priority, meaning they would
rarely compete with other task groups.

[ We have another use case to use remote charging for implementing
  CFS bandwidth control across multiple machines.  This is an entirely
  different topic that deserves its own thread. ]


TODO
----

 - Honor these other resource controls:
    - Memory controller limits for helpers via active_memcg.  I *think* this
      will turn out to be necessary despite helpers using the main thread's mm,
      but I need to look into it more.
    - cpuset.mems
    - NUMA memory policy

 - Make helpers aware of signals sent to the main thread

 - Test test test


Series based on 5.14.  I had to downgrade from 5.15 because of an intel iommu
bug that's since been fixed.

thanks,
Daniel


[0] https://lore.kernel.org/linux-mm/20210128182632.24562-1-joao.m.martins@oracle.com
[1] https://lore.kernel.org/lkml/20210219161305.36522-1-daniel.m.jordan@oracle.com/
[2] https://x-lore.kernel.org/all/20181105165558.11698-1-daniel.m.jordan@oracle.com/
[3] https://lore.kernel.org/linux-mm/20190605133650.28545-1-daniel.m.jordan@oracle.com/
[4] https://x-lore.kernel.org/all/20200527173608.2885243-1-daniel.m.jordan@oracle.com/
[5] https://x-lore.kernel.org/all/20200219181219.54356-1-hannes@cmpxchg.org/
[6] https://x-lore.kernel.org/all/20210407013856.GC21941@codeaurora.org/
[7] https://x-lore.kernel.org/all/20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com/
[8] https://x-lore.kernel.org/all/20190605133650.28545-1-daniel.m.jordan@oracle.com/

Daniel Jordan (16):
  padata: Remove __init from multithreading functions
  padata: Return first error from a job
  padata: Add undo support
  padata: Detect deadlocks between main and helper threads
  vfio/type1: Pass mm to vfio_pin_pages_remote()
  vfio/type1: Refactor dma map removal
  vfio/type1: Parallelize vfio_pin_map_dma()
  vfio/type1: Cache locked_vm to ease mmap_lock contention
  padata: Use kthreads in do_multithreaded
  padata: Helpers should respect main thread's CPU affinity
  padata: Cap helpers started to online CPUs
  sched, padata: Bound max threads with max_cfs_bandwidth_cpus()
  padata: Run helper threads at MAX_NICE
  padata: Nice helper threads one by one to prevent starvation
  sched/fair: Account kthread runtime debt for CFS bandwidth
  sched/fair: Consider kthread debt in cputime

 drivers/vfio/Kconfig            |   1 +
 drivers/vfio/vfio_iommu_type1.c | 170 ++++++++++++++---
 include/linux/padata.h          |  31 +++-
 include/linux/sched.h           |   2 +
 include/linux/sched/cgroup.h    |  37 ++++
 kernel/padata.c                 | 311 +++++++++++++++++++++++++-------
 kernel/sched/core.c             |  58 ++++++
 kernel/sched/fair.c             |  99 +++++++++-
 kernel/sched/sched.h            |   5 +
 mm/page_alloc.c                 |   4 +-
 10 files changed, 620 insertions(+), 98 deletions(-)
 create mode 100644 include/linux/sched/cgroup.h


base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
-- 
2.34.1

