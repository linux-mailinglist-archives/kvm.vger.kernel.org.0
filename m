Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4C948DF67
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 22:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiAMVKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 16:10:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63076 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234890AbiAMVKA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 16:10:00 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DKOtgv005799;
        Thu, 13 Jan 2022 21:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=UMRdc5HbqvlXy/6LApAIkPRUEDYCQUk1jAjle0H1v54=;
 b=NN6WfZsh8WlPEYkSR/SBaeiEf4poh43bcnIOFnc32mnWMiw6Of+c0pJeugt7YW6RGPRY
 lz4nFrw/rhbDJ6Pll8dSv7QdNNZtIXavQ2oHSQMZ4xyv5K6Qe6cs6W5J5DJCu7nocS0f
 D1+kYZWUpQQcxTmv3twxOqOafeskx45UHVY42hiJ9/0ysUnD9cS6Ec1dAU0WJRM1RvH+
 fKJIxJLqbLWcTjqrTbJ1YDbz3AD/irPEtN9AcIsmOstEHpNY3GL0REzQrg3NjmWDU5mt
 Bqggjroa5jChjNN1ow5Wh06RZHHmGqeZLDY34B7JqLXFb1dwo02+Yy5TiZtkH0TtvoUh Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3djkwj9qua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 21:09:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20DL0I5a153908;
        Thu, 13 Jan 2022 21:09:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3deyr2eumf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 21:09:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQrFxeabIiCUg12ZQzatAWjDMTyPmNU6DwbAxmEvh5i1qySTxxYAyc+2cgiVxIJ1Ac41nw++ryYNo/st7jfEgdnHwA5YO1QOzOIfh1cEEyRoZnVqAzVGkTQcZmIuaZNqxq9gnahYtk2SiVx4C8CMbljKkF9SfrdJ+Dg5RsmnDm6uToGPlYrPBJpazOfMU/HfQYcPebYRbLKiPunQMFbeqLBhS6liN4MimGvTY8cWtYi2fDc4lDVWzOacCqo3rzIJv234SPoA8myjbUTib0fPppBbSMuE1X8h65lTECfkhKijsj/mBWamrBZPraeC+/FSgRSnQDjheALe2sXbINVVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMRdc5HbqvlXy/6LApAIkPRUEDYCQUk1jAjle0H1v54=;
 b=iPFK9JQodbFPJ11C7ux2gRrj+jUhG2DWmVdEP6vz0WHss4jEyl8GiY7wgONuOfdYqGPzwvsof5HSLfcJE/8v6xVw96nZ3kkwHokHS9KV69OoQg8fMmSS6ZXR3q2TIP/O1RmWQrXV4BSyGi51rbzSX77+gXJIqGBXSt6BmZMdi5r5yRvcTRN1yayU2WIWtcCbAzlzYfi3QVj2VtPE/h41yrfTLJpNoWjYAyPPj/hnm+PG6jNTQxJ5d5IhQUZ3J1uqxQBUNKRHTJqZrwIG5GZWJBy4I9VDjYTsfPXXTWK2OZHRW+lAaUR+uGR6NPAuhVip/68VWtH6W5lzwPDUgbU4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMRdc5HbqvlXy/6LApAIkPRUEDYCQUk1jAjle0H1v54=;
 b=yNB3wCMZja8spnVQLdH0Bf+IoGI3l7myT05RU8CMIXjw6hf5N5t05UmvbSKvcK0Bcauhl8m+C9OHmukxOVXiFWFC61Hymy88w1olloWgd/xWDLgzgVP3pWeB609pLHx5nwMvDtD/uI3+kT/pGpzmToUAXAyzJXs06awZ1iJJ8ok=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by BYAPR10MB3447.namprd10.prod.outlook.com (2603:10b6:a03:8b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 13 Jan
 2022 21:09:01 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%9]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 21:09:01 +0000
Date:   Thu, 13 Jan 2022 16:08:57 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
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
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <20220113210857.d3xkupgmpdeqknhn@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
 <20220111162950.jk3edkm3nh5apviq@oracle.com>
 <Yd83iDzoUOWPB6yH@slm.duckdns.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd83iDzoUOWPB6yH@slm.duckdns.org>
X-ClientProxiedBy: MN2PR10CA0033.namprd10.prod.outlook.com
 (2603:10b6:208:120::46) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bbe163e-4ed8-468f-0557-08d9d6d8ebfb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3447:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3447693B0DEB91D9C44FCADBD9539@BYAPR10MB3447.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5tuZ4qWk/8wkneglfP+tRrxSJeKbrhgpu+TVrRV5RGth9sUqxcX/l7Q4pU8G57TVB1oXLrachEwR2MnJWHY9faLllKjigTCKJlbExwtDlzeSZpd9qYqW0jtjF1LQCNc5OI4H94+gS8qQ63GTSWXtEsUTqTITlAw/zRwA8mXCIr876Vk5zIGC3gfc97JcYTynDYgu1aFvc29V6u3cCDEmM96h0zWU+zumc9P9XKGFHrzcqrg6WVkGVtq145K5yFT/n5XLZ89yBbtk0uJ9Vfy2jND2IgGAwu6X5A/skeSmU4zrv6I1YBiQnxG2EtU/v3RAkPvevYLTVu3PKnHI1TqnQqefG75kI8Ux2IZ9Cx8BFGPVBZCAwbRM8s864YUJ8RxlAXKDaTRIqnHFixwgI0WVj0DU82D5z00WGE9WZf2hHKjowQYZ9DWvvEk4t0WMp1rgZ25mndAvXqW3xeyOuIAUztzCFMIKdHIBSsflr/eqD/QaEn7AQE+FR9ftOXdMtOCPjp2SSF0riEWptLBaToL6iGHsD5yCVcBf6L9vujX/lPiBNOqn5m2g01Ik16g5RpAP1fv7VvMTCgIyypI50Mllynqs8KwG9eBhlNq8deV5Hk83v1Tg8t8EM+ddGNgqt0Xvwez0Qe6RJBM4hlZDMJ0eWM0214W4he7dlEeeYU9df/UFTM9thuSE+vhn+vzCzuRf2FMLzzfpQxX/DgHPuP2+Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66556008)(86362001)(6512007)(36756003)(6666004)(7416002)(66946007)(4326008)(186003)(38100700002)(66476007)(316002)(2616005)(38350700002)(26005)(2906002)(6506007)(1076003)(52116002)(5660300002)(8676002)(54906003)(15650500001)(83380400001)(6486002)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?do8R8cXjDqklGqS/IdjSb0jwwSMmDzPYXODWzH0NMTv7Q08kqkHPdlOtcoa6?=
 =?us-ascii?Q?g82fPd6e/bIcMRVh14Sh9pvBjC5BKchpTewR2GVAqeOItKm5GvOPbIREtLQZ?=
 =?us-ascii?Q?MmfSPkpzu+al1jjpVcuYHIGqpwbPovg1eeDtXvwYMUAZj3QcJa+uVW8aMt7B?=
 =?us-ascii?Q?eCtD7NrpWyzvGaAK1DS8aTHiUUwa9OSZXws/yunJ8EqxmDBsPcg8mxZQa+ws?=
 =?us-ascii?Q?xmyWei+j40jS7e+fkqzdeq94K7gUWfAUG81BCVky1K28gHy6GzLOJKeF7iP1?=
 =?us-ascii?Q?YqxxR5erRi3yfwp/Ly/2Hv0zjC7+AkXm5pXLcMaOGR27EIFNnrTffF8UO0l8?=
 =?us-ascii?Q?Quy9i5h1JQn231zSJGZ8o98o2pnbJUOx6Hj8z+xhub4Vz3RdVh9tSf4UORSy?=
 =?us-ascii?Q?QtKOwI0KoVDhQ3898QPgSflPANYVsl/g4rpUsnyajLZsTgyK+lehSqqG56BM?=
 =?us-ascii?Q?mR8IPWMQI9lHaTHvNhaO0bosAKZRSpHpQX+Y7wK0rdsBZkBBUgm+z4ReVJm4?=
 =?us-ascii?Q?2FTqyEhOz/sUl5PDLGHTrhPbvHyjJYqZB4LRBC+KJ2E/D9t4yiw2vMdEKTAp?=
 =?us-ascii?Q?US8VYIjIeOzLD6geQdw0vTPfWRdOL2oDm05Pn624at7CX7GbuRuyle5zrGtO?=
 =?us-ascii?Q?ZYMJBOmQKbAL1azh3s7CsuvdXoOfbkkCJXqz2qVzxUjecBE5mzq7m4812INI?=
 =?us-ascii?Q?ygsX3ubitH+j1FQu+TjkhF9JJt4onaso0EzR48VARI0JvcrxWEIkpo47bkP5?=
 =?us-ascii?Q?8J9f8eDMQI0qwc0GOuFtak+vFHPyPdsz9FV5r5J2mgzxOo+yQHWQzigmlYE/?=
 =?us-ascii?Q?Dda29KvYBqEyLRtckS6WmP7DUi3sq/cxTWf4GDHEC9zKJJslq8LR6oudwy+Q?=
 =?us-ascii?Q?8jCK4NjrZcphMKFLccV1daEsUAZyr7pqxWEvGPF/8OhQJDPNDNu5bJVTkJkZ?=
 =?us-ascii?Q?7YFLy/cuT/G8cYywDcXBi2C+aSdwgvDIXannjShL2WMmTtTCUT8gtPVsIsqT?=
 =?us-ascii?Q?cL6wp9niRdFbwtEOiq+HBTnPfwakJGUleVV2QA/QnkeeIrA4N3/D6AO8Mvg6?=
 =?us-ascii?Q?g1PlkW9DDaMpwNjgPIj4L+sJxht7DZe4UsXzFcgF+4iia/+R9+FtJqTIADF2?=
 =?us-ascii?Q?Tn5/umbpWacqSDKNcgGg/IM76cT+7Y0ZiwbecF4f/Z+ESmp00e61s50QUO0a?=
 =?us-ascii?Q?W7AeRroQK8WA0O/X+SoXaNHuyiFyBaQKOy0gOxJAKnN8oUQcb8/1KidLyIlQ?=
 =?us-ascii?Q?5hhfvOdIq2sQnP6f4ETH1QqqKXWupkbLq1G5fxDAqKCKdZpa9NyU7kQNi1Z+?=
 =?us-ascii?Q?ce7zDLsMSEof9CxKldLfML+PKqc5AH/ygH0XUtAbHHvSRZmpMLNLpgybI9nZ?=
 =?us-ascii?Q?hldhZ5ZeCsn7kzzkhkehdMwOyhxg1nhTiHWgeTgklFAIREW55eNefxK8xAo9?=
 =?us-ascii?Q?CfgXD0cMZVHUfZIJaI6MG+Sdv42ueGgTVRZAK8l1IDemKBU7k6E0THoRv71j?=
 =?us-ascii?Q?o4YThHqw3e5YEtn+rr+Z+pP3rSzR8DJR9VIm382CtnpLZFj7xLE+JcMk7iLP?=
 =?us-ascii?Q?UX47iIDf9e14XDAKLpVQ/CmY5CitKeS7npB8lAZEEAjUT7PZqjS1TUxBWkkW?=
 =?us-ascii?Q?CqAEG7WnvSWF5pS3KqbC7DbhbfGiqamiUQhYBGktyqL9zsolorRZGRh9/2Ia?=
 =?us-ascii?Q?OSef3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbe163e-4ed8-468f-0557-08d9d6d8ebfb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 21:09:01.2824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UExDNpJgDsGPyTeuRL7PYBQW6ZYme8Vo4kCgYMXhqw6OWnfI0DSKjMDdnoOEhOKhxFaX99+lc0WSNO6kkj0h2gdHd06PVJCL4gY9egOuCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3447
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130129
X-Proofpoint-ORIG-GUID: uBnESALOBZDdWVtEeO8LZwfGqghLSHbM
X-Proofpoint-GUID: uBnESALOBZDdWVtEeO8LZwfGqghLSHbM
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 10:18:16AM -1000, Tejun Heo wrote:
> Hello,

Hi, Tejun.

> On Tue, Jan 11, 2022 at 11:29:50AM -0500, Daniel Jordan wrote:
> ...
> > This problem arises with multithreaded jobs, but is also an issue in other
> > places.  CPU activity from async memory reclaim (kswapd, cswapd?[5]) should be
> > accounted to the cgroup that the memory belongs to, and similarly CPU activity
> > from net rx should be accounted to the task groups that correspond to the
> > packets being received.  There are also vague complaints from Android[6].
> 
> These are pretty big holes in CPU cycle accounting right now and I think
> spend-first-and-backcharge is the right solution for most of them given
> experiences from other controllers. That said,
> 
> > Each use case has its own requirements[7].  In padata and reclaim, the task
> > group to account to is known ahead of time, but net rx has to spend cycles
> > processing a packet before its destination task group is known, so any solution
> > should be able to work without knowing the task group in advance.  Furthermore,
> > the CPU controller shouldn't throttle reclaim or net rx in real time since both
> > are doing high priority work.  These make approaches that run kthreads directly
> > in a task group, like cgroup-aware workqueues[8] or a kernel path for
> > CLONE_INTO_CGROUP, infeasible.  Running kthreads directly in cgroups also has a
> > downside for padata because helpers' MAX_NICE priority is "shadowed" by the
> > priority of the group entities they're running under.
> > 
> > The proposed solution of remote charging can accrue debt to a task group to be
> > paid off or forgiven later, addressing all these issues.  A kthread calls the
> > interface
> > 
> >     void cpu_cgroup_remote_begin(struct task_struct *p,
> >                                  struct cgroup_subsys_state *css);
> > 
> > to begin remote charging to @css, causing @p's current sum_exec_runtime to be
> > updated and saved.  The @css arg isn't required and can be removed later to
> > facilitate the unknown cgroup case mentioned above.  Then the kthread calls
> > another interface
> > 
> >     void cpu_cgroup_remote_charge(struct task_struct *p,
> >                                   struct cgroup_subsys_state *css);
> > 
> > to account the sum_exec_runtime that @p has used since the first call.
> > Internally, a new field cfs_bandwidth::debt is added to keep track of unpaid
> > debt that's only used when the debt exceeds the quota in the current period.
> > 
> > Weight-based control isn't implemented for now since padata helpers run at
> > MAX_NICE and so always yield to anything higher priority, meaning they would
> > rarely compete with other task groups.
> 
> If we're gonna do this, let's please do it right and make weight based
> control work too. Otherwise, its usefulness is pretty limited.

Ok, understood.

Doing it as presented is an incremental step and all that's required for
this.  I figured weight could be added later with the first user that
actually needs it.

I did prototype weight too, though, just to see if it was all gonna work
together, so given how the discussion elsewhere in the thread is going,
I might respin the scheduler part of this with another use case and
weight-based control included.

I got this far, do the interface and CFS skeleton seem sane?  Both are
basically unchanged with weight-based control included, the weight parts
are just more code on top.

Thanks for looking.
