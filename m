Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0248B23A
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350019AbiAKQai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:30:38 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9080 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350015AbiAKQai (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 11:30:38 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BFEBXi015389;
        Tue, 11 Jan 2022 16:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=b1fOsSfgdCSFjxRHLquKTszZclnk0q50qLe2nj0Z9/A=;
 b=Ssk4XEo5K8OYee6QgYEkOIj9GIXEUiJfSiS6quNjsHOdAylM1YdcOePqYSMrMRwRPi9D
 vjBqjNXNPBENXCLQV8MS11YW+LAwNetB668pk1+uFA8p/FRz87i4oQIJukrPyyA4mdOI
 /bqtY0cbCiSWROnGG48gH+BWspSNhw21bkFUcSCtNPh47akhIRyNAIififFKmSnhGg6q
 6rp3AHBUMeBGY0yyp4/foY8oShi07aDGDJ/XgQLACieH44GpVvY2npLhetw9x/nQ9Nch
 JoIK5z/6l+OTy8lZRMLevbzG0JMJYz55tcfjwucwk3EIb0ciSP+d8+c+dVVhIqsOElSA 3A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk9bkee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:30:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20BGTxqN019784;
        Tue, 11 Jan 2022 16:30:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3020.oracle.com with ESMTP id 3df2e50c5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:30:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRpiD1u9yNP6kSt2ElG1P8CU2lC/KO3d/1/RVTkqgRS+qHG48hefNFQTENm8QRnKSu3GKZR+ruiUVq6M6gydiyduKJ20fu5ZgyabJXb/Q4riJwrt4DqFMLUVi027h4APuizSl+tEjevwQAy2rQsHFlrHRxMRB1jjXUw+QJYmxrvg7djO4IWe9XXeN5INqssAmyxl1UBQDoiJFeyIB7S3dIGf4nJPradCdgtQIaKdsNmJERvu3HMzCOpKfDhdshIO09pAh7LNrRGEHPKys8EUAoJM9XXL4Od4iLH90qlS+U+vP+WkiMSuQgBDPSEOwmp33Ldf6MZwJ0JlP+Z+RmwA4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1fOsSfgdCSFjxRHLquKTszZclnk0q50qLe2nj0Z9/A=;
 b=NSRoR4CAcxPPC6ZJylknc2DbD0DoaNRmAGAp7wtopu2T5NMbB492svM59BtBU67i+tzyWYG7cHcKPnNORUCAPrLVeHoWLmYgQqbr0R9p82qRd5b/Hdlcs0DmNj+3kB0SKpq/X6j30mQzoron+zvk0pWnOao/JkfqfVRkKAtSN7GIk4+zZmy93iRXrng6+XYySTifn3Wr/aTkQ/rTQhhonAmWR7Tk4K8lmsS2DQiNfMRGzhQKTB5kCyT7hafauJgaRzXHb+vn/tRO08LrhFLdQkh/YURB75qac2ar2zRo3HlCv38im9G+WyXXSNhMungrCsncWiay7ojdo1xpJDhM+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1fOsSfgdCSFjxRHLquKTszZclnk0q50qLe2nj0Z9/A=;
 b=x+LG+xJkYEpyEwpbQ9ZP2abqtXQJ0G0jpU21gVKV2c5BgVvecvknGf4PBQpJ562EpH+qS8S/UvZHRXeq63PWk5zM0RqWsUzmW5mla/yvlnr8rGMWCV0uUR2giOzZarARpmJJY1bg2l/O0tmiAdYqGwtX3bTDNlSiCnSDzAVr5Oo=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 16:29:55 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 16:29:55 +0000
Date:   Tue, 11 Jan 2022 11:29:50 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <20220111162950.jk3edkm3nh5apviq@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
X-ClientProxiedBy: MN2PR16CA0064.namprd16.prod.outlook.com
 (2603:10b6:208:234::33) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a87a95a8-92c0-49b0-7797-08d9d51f998a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4732:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB473263BA09B8CCD0365CD900D9519@SA2PR10MB4732.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6s1OEULsaweYKA7dgQw/C5ZCc1S1051xLNeCsiXMKMP8+PET7NEiym6AAPD5ylx+62U23OI0EyQOEUnP8CtWOkacbpkUEZmdaRk9JLa/kdPaeTy89lI+tv+4MP2UNRz7mtpm+aseTOMEEIzBAgoSmH+LZgpxRblOfjhxtQb1fOHzcLcEg3n9OT1tvbEfmUYvhwey3qpX8mMbHp5vChq9JBb4ykp4VF6rErfXDpibqLLv77TRQsbobxZGgcCFvruzaMb4U2UnQ7osO05wcgq+t4sQH/cmtL3Jhz3+xp9lHIi2ui6h/0tu/MHp1DeRU2kB5FdYO06MYJFHeTXUsfxRbMFOVmvecvS6Hbi6YpCeKzihc8btAAK/HEF8hHKhxH+b+l2L7BnIoAhAFT6h+QzdNC52f1gZi77bLklfkgzTwzc5fj4r6p86g87wndKBcSJWbSatU11WVbeUpafLwFO2PMo46QrwiT7bJGfkRDxTegM/e/1rDvDTjxW9RRlQskck76yBaCw/nlkCJfSacNZQNYYLXcnY81jyeJqKLSGJc5NH5lt0yNQqWvT/PsDn0aG830syI4Tluo6Q2k0+zSRDbwBTTpGLlRxmlV1+ieTodnNDsSgE/Lw2WnlAikSG2pEcA3mr8aXUG7zwnaC/K3ROzwccwuMja+1ICvtR8xJbXZG3i+63chNQhidgxfHf9PtAnAqbYH08BSHrXQUFmf1FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(8936002)(6916009)(15650500001)(52116002)(316002)(86362001)(6512007)(26005)(186003)(54906003)(4326008)(2616005)(6486002)(7416002)(38100700002)(83380400001)(1076003)(6666004)(6506007)(5660300002)(2906002)(36756003)(66476007)(66556008)(38350700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PgFv0If2uoDEVTPZjccrXRGvVnSYDZJGwoL/gxOn0ZbjhA+qJZjMLnSVXulp?=
 =?us-ascii?Q?B654dbs9JiA3rg2n/9Ep76cFk/uM2+D86QGfh7lYZPNbciRO73eN3jCDpDfY?=
 =?us-ascii?Q?BArXFNuM0JaJogW8ORMDjLHAyUaf0LzAx21rUM+zOLXZd8C5D5MJJnv7ppkC?=
 =?us-ascii?Q?c5z74kTD1htHIP/LLplXfoi8PQSC3cXtj2WaSDRpsdpaCRDXQd9r2MAmyiR4?=
 =?us-ascii?Q?MRo0++t/HOWLoPs+i5OofBr9BlTzZCmaDi/09h2+jDhsguioyNPH/6Dx3QRx?=
 =?us-ascii?Q?zM9d1AH73qi4Js3HHNnOUjvX0pTpmw9ezG+Oy0CKKSSh3IyzOzBU7bxSqiYL?=
 =?us-ascii?Q?/nyYUmkH7jlG6wPrc+qmAkFS+GcTAIAY7drjzjJ/ddCIjiEL81Lzrbz0UgFu?=
 =?us-ascii?Q?jssfx94/Ixavh7hx8LwJSkLyCyqCS4eOyquhIg+VowI+SuKH0A5zcjl7I25C?=
 =?us-ascii?Q?YMh85Of7Mar6IMi4ttoqK9kkjflBlfAXkEuaAjqbLIWMslhENFV6pql8//Q3?=
 =?us-ascii?Q?VVFkWi9sO0zM9TO8ANiJ02VtA1KYh6Irz7XJ9zyW+0k/pKY57HBbSRpPcr0k?=
 =?us-ascii?Q?t1zOy575UAK2bemHxbblSHT3jxHdgfw+6H0R3NxKSTx/LOS4+3gGEBwV6vXF?=
 =?us-ascii?Q?XdsBVLlI+LXYCud4N6bdAJgRREodoNRd8vyG9vZ0Wx2TG4FXHORVYcywgpFp?=
 =?us-ascii?Q?+rRDFXb2suWITe8KeRhCApmnFygrc/k7+zzMsGu93uiv2+JcRw7pn61l+PpP?=
 =?us-ascii?Q?7GwZ/XXeo5Ha4r2DiSCOBIYFL29VB+9czP5fRYwspMpK8TdBHWY8DEYRN8Rn?=
 =?us-ascii?Q?xRZ5TjBVphFA7+Oel2ynmf6BWnZuhTSmldhPUZqcvbuFCJ/p+p3TlakEkvpy?=
 =?us-ascii?Q?TZEGMClKYnVY0wRdiszfnqaGfhVovUi2FZps3jvswZQjIojVCO9/dLDM8X0S?=
 =?us-ascii?Q?WAkmdlVQsZfGKqRFyZ4JLLWNgbbhoHPMhiJWZxRKxCfaB5+s4oEymiX9E2Up?=
 =?us-ascii?Q?Cobre7c5dTEJK6SUzgkE3e7vdg6UESwmo5+qF728WYFU8Gmjq18tQvtFSEYq?=
 =?us-ascii?Q?Dlxx/jCn3WtAe03cEyIqPxPw449sI2adtzWh4jGG84VzpWAFuBYNisJEjU2h?=
 =?us-ascii?Q?7cMmX4kzsYY7GVIaK7/24IiGO/xuTbM4hR0/qsjOgEto1bfJY+wNRPpyN4Ts?=
 =?us-ascii?Q?dtrzdd69eGTC5eXmg66lOUchH8LAtmJyQKud5DWvbK/6Zz75jRpwV4Bqm383?=
 =?us-ascii?Q?oWPkaP0CzB2dCw1iyFpQuQrSi7ayE0khYTBFMf9Cy7ssthVdEsHjlzH9DGHp?=
 =?us-ascii?Q?ozuFdSR0IPn9xEAULRXsf6cUrSHWfbfZ0MawZrxoA4tMs0KPXPUcfTmmdY1q?=
 =?us-ascii?Q?Ul8OG3g9IEtRwhqdAdAF6UFqFOyGXUfRjGb5mTQftCk6+TPkA7YR1SHyRhsv?=
 =?us-ascii?Q?aAFXMZhgh30zN/7hv62rwJMy+eRMtKCPHaAdPOFKEsBzbpkqlJ24NkbUrqIZ?=
 =?us-ascii?Q?t3PffysL0uXDiFoaO1o4Ojzd4w7G0PXCSDRCq2AaHy8PbLmxy2pzFQpQ+r/N?=
 =?us-ascii?Q?AZZ9cQUYNAlmvLdKQfx1tpQZoz/Tdik55Lu/3LeH5NWey+5CMV4tJ0n/2nzj?=
 =?us-ascii?Q?eco5piPDI38HPfivHL6ZJfa32AsOSP2Fkh0rwju0bkAnnUVQeLcBF7zcdz1b?=
 =?us-ascii?Q?bOddpA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87a95a8-92c0-49b0-7797-08d9d51f998a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 16:29:55.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyBeTP3s6O0jiJR7hZml76Y3IEhk+yS9UKQ94jzjfjQCJfSMO60Wpm3BHgaYGaxGFrBDkoRt3wVof6oyesINM6wD4y5w7kVWshOd+PD7Z3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110093
X-Proofpoint-GUID: M-3nsWlxTIWDDhRUE-hRN2BYyfXX-TqA
X-Proofpoint-ORIG-GUID: M-3nsWlxTIWDDhRUE-hRN2BYyfXX-TqA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 12:58:53PM +0100, Peter Zijlstra wrote:
> On Wed, Jan 05, 2022 at 07:46:55PM -0500, Daniel Jordan wrote:
> > As before, helpers in multithreaded jobs don't honor the main thread's
> > CFS bandwidth limits, which could lead to the group exceeding its quota.
> > 
> > Fix it by having helpers remote charge their CPU time to the main
> > thread's task group.  A helper calls a pair of new interfaces
> > cpu_cgroup_remote_begin() and cpu_cgroup_remote_charge() (see function
> > header comments) to achieve this.
> > 
> > This is just supposed to start a discussion, so it's pretty simple.
> > Once a kthread has finished a remote charging period with
> > cpu_cgroup_remote_charge(), its runtime is subtracted from the target
> > task group's runtime (cfs_bandwidth::runtime) and any remainder is saved
> > as debt (cfs_bandwidth::debt) to pay off in later periods.
> > 
> > Remote charging tasks aren't throttled when the group reaches its quota,
> > and a task group doesn't run at all until its debt is completely paid,
> > but these shortcomings can be addressed if the approach ends up being
> > taken.
> > 
> 
> *groan*... and not a single word on why it wouldn't be much better to
> simply move the task into the relevant cgroup..

Yes, the cover letter talks about that, I'll quote the relevant part
here.

---

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

