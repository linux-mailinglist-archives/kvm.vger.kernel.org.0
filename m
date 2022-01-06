Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7938C485DAA
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiAFAvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:51:55 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61484 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344086AbiAFAsX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:23 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4rMJ025697;
        Thu, 6 Jan 2022 00:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/5PlUHHbvSBrXqo1tlC/TeRPSUcg6TVKzPG45MjfoGQ=;
 b=lRCBnQWr4mD1MS5OePydMfpHJ4C5sXY5cs061i4Iw+3ZTpljFKFKgVkTn9BhXV1sA9ol
 9Vh1f4/wF+Bg9KVMU76/p11SvVuOyV9Hocxg6STcx128DXNVrH9BptU8Sbfn6zcLOK+g
 NgmaCoizz0VSCEG9r0wplyHfg7Z6ksuvhrI7mcFPlfUNJvKzh0bu3xkx+gvXEhIyY5dj
 tBnknD+YVitp8go6YDLMIJEXmyYUSFB5hvn9kq45R0rBZimVE/LX6UdT03LMFi2hITEm
 wo6guV+YPl1qytHB+hCVRl1tLFSPXZzgIcH8jbu07EiSPanEnLA8m1n5IDyUsMXuFugY LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpmg3tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060Vf2R076234;
        Thu, 6 Jan 2022 00:47:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3dnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTUIjDY4zUsYw5ud2GXL/YNwoVNjxFflNmY9WFf4/mfRgF9wgeY4c1i7LnLRTrTQMROz3/8C5vfG4rzZV8UzmmOLo7eaweXU7M+BnKo3Y1XhWlYgO858odiq7xjm2TLnxlnXkYPo8sFLSLYx1MhVN34oPcOP2pc6SoralMoWXF8eEXPDRxlgU+MxINGOQpULFZ5T8f0vzf2qfFH71fP4hJ1OAHEOcIavfl7345ZkJoFG14pO8NpLBsr7+VhCrOtRbuKvlPNMOn2tqWpASrOi424Fry3a8+rcBZh3ekXIQz84ggTDs1oYuVB/Mp4QJXwMxKY145+te7aLmc0TlZj3eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5PlUHHbvSBrXqo1tlC/TeRPSUcg6TVKzPG45MjfoGQ=;
 b=nUUz25kbFPlNAH8LDQ4oWDBwfKMq78gchLozDK+9bSw2z42eAAmpa3b/crUBAVUozXxThpnW7jk0uDvbhNao+ZaOuvuQU99r/yniWyKizSSTmzQzyjmQBqdnSoHgJCH4WvwqpigMeWwdAVzEeZ6nLhf255Ioo0cV2UdkICiob6yfr8a3FlzU+h9rVQEN3LcRy7DC9RAoZOrCS9A+VloBdJcyOpQIbICbl4MKRo22dpN9v/bV+UlxVcFSH32rP5pbZCB2cbuIjOcsekkTa5vmL9kQT2vulj3x5nbPqVNOQyj9ezgwxixLjmiEcgnOsErpf9NFHldaoaHo8rIUFXawCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5PlUHHbvSBrXqo1tlC/TeRPSUcg6TVKzPG45MjfoGQ=;
 b=W7TqO1gtfg03OCWIBLSwKKDzCFOQDZayufHwaL5w1kbj/XkPd5sDjee3WYsgkf2iusf/8d5LNEzZwp5K5BLoqvOJUSvwMoh6PXtSp0aGyFDuutoFfz76sfGvFxEyY+uLqnF8yvF4EezKWDF34FwpS85z02lhmX/rbQoAoHYL0R8=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:54 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:54 +0000
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
Subject: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS bandwidth
Date:   Wed,  5 Jan 2022 19:46:55 -0500
Message-Id: <20220106004656.126790-16-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6efbe408-1076-491a-2f88-08d9d0ae2c6e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422C2913DCF644163FAA6BDD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzC5nrkBwQZRdwQdEdavNPL6jn8WNhnppAmUDeRGvuLZG/kH2QMqFqK+LoLrFsB6QVcPGpox87LW55A9xzXAlJLs3sPy/+ALxJi3OG56dIA1M8LfCLbUdDlsBZLMp+V0hHZHsZo+5ASY3uPo9lSNVClL9qaGnBFPlsM979//xIUPYo7EGRtWkCciB/oliWDHUu+BT6h57dNUOt0HIXdO5h0otFDQVjopw9/MZIjnsRx+goI2+7QsepjVwCYWEGF8bfpaqP9iN6/IFQbz/S5lf6uoSazlivcoSANZeyeZv69/lGaPk6qyEXoQhHEgszMPXepp3bBJEAgBBP7GMo/nlIQhmt0A4X79qRnqE80TiouTUgd2Vk6JgWElOvjWXnInt8sXguMg7NibYzLe0YuNFAz/dpVYDGO7hc6M4HQUpPHVROwk0KicRraHtWURjfCNIhHcb1aTVPn5FzEnZlJH8mjl4pw/+VTSJdFukdmrFPx+IH6mXhMCDcJ2eegiqdNc3HM983P3XLSLVXLXL50deUzH1VxVH2n8HgFXdIqzrTjXJFCTILom6pWFAxZ5h2+hBjn6r4hIL0xSPs6Z8e5k8dhTfI+sHeEWztAGZsQdfpjR3m7f+O1jiuxXm9JWUlUMa9ypNM4tXOi4J7ITgxkb66SlCt0WiJvkcyVBL1yvFnO9H1bh0boZm/LiucOVb5Se8IqUsIqhDtgkvdQUq2QGf39FlqT8g+oUOmqCsrJXTYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(30864003)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(15650500001)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7j1IyFGIsxnCqii5/J0rvKnXkxWZIEtmZU0OLBy26pnc6TeWER/zZKuQby0H?=
 =?us-ascii?Q?EYYE3qRVmXRJxr8SCx0tq1uvtNgMAMYayWhIWt5RO2vT3EFdwFjm4LahUPQu?=
 =?us-ascii?Q?hCLUYvrK/yDjQVpwyOGY80TWW9xbENP3dfzVKxq8rSnRWNkQDQLAM6RGOlL3?=
 =?us-ascii?Q?av8332uYCCTCaijTM72QwIIe/gnL0nPZFBDAw7hU8z+/E56UDoJPKND7VTem?=
 =?us-ascii?Q?+6vYW5VOE6Bd32LJXHWR0PEB0M1RjBHocU8gVlb+ejk5RfEgxZ7wnlvY8/Qc?=
 =?us-ascii?Q?WALcbfl0oWdotAXYE7SAMYTIzigAoeKgCMhXvFXBpRjsxCoF92nqFCDH2o1D?=
 =?us-ascii?Q?uYl3xVOcxLx74CmaPHpi5a7ZTBefJtvJtwN8qQHoU2OJhG+AEzJHGfeE4FM7?=
 =?us-ascii?Q?wfwEVbSVjuK90QQSq2rAIO2qKmu235f8q2ZlIoWVdVQmR5+mWd3aLw/h6QVq?=
 =?us-ascii?Q?Wxt0H676P8YLCeJU3plyLtc/WhRe/7m4Z3HeZL464Hd5/lyu5tJYzTxGWEk7?=
 =?us-ascii?Q?XKvRkOAHthdXdtgmySi1q0ZFRG8lwulYqsOfXWqhhuKkBWOruk8ltN3NBeb3?=
 =?us-ascii?Q?94wsYMzrcOLeJmeGBBPsi9/k9a2Y2Z86K6mK+y29TyFeLdNgi7iQMkLgRDLu?=
 =?us-ascii?Q?yiHkjXCoWuuBqsztoLs6hSJ3xD23jAqmnpNhi7/+tPzwmYpSqdzrItSZqjar?=
 =?us-ascii?Q?oCfvdLY3wP4yznNlZXxwG/5guvPwIszTLT6esCCeMuzhX3kL1BKcqyUekb8H?=
 =?us-ascii?Q?9Q2HYz3qpIrxllDq5E35j5rYD1Y8spN/Ep3D4lRI7jpSu2wFAW5WKzX8t4LB?=
 =?us-ascii?Q?qPkEVtKKVl3BfQ4zKx7X1i1LtQTTs37wxYd2zu39usk7imHNPr9vA9vcLs04?=
 =?us-ascii?Q?0njOkTDblUaq/HOaRRFvyT9Ucg+9yaGNl47HtPW0wKlUh7UXHYpj81GoM3yO?=
 =?us-ascii?Q?40kI9KYaBJgOTeorv8+fiOIXyswS2SaiZ1R0E7QJQYLPaMUjDMmrwBYoA08w?=
 =?us-ascii?Q?pxuxnHCrKzOjsFhORXr+u88DUoGFob2N9esJ4cP6bp/pvnx37Vh4YKlVvIZy?=
 =?us-ascii?Q?pR2KiWM7fbyAvOAbcDVuvy1fMyzA09uQ5sfVMiH90Zmof01DwEGS98Vm1Ph0?=
 =?us-ascii?Q?tIE4NWGGORmkiujVRlTw4Q1nbzoHplLRP6QVHKYNoHysnSzxYhWbiLX8iXOI?=
 =?us-ascii?Q?jpmvhFxK2OXQygB/c+YzRfX9mDu23f6IfCHFCARd0aWz+CmK1nbwVIAAxQWz?=
 =?us-ascii?Q?tixEd6EfNco3zO2itYic8i2HJ2SDAlHE7LuTHjR/PA8O6aI21liXVlLvkDgo?=
 =?us-ascii?Q?usWam64A5Mlf7OXmv/i9Tz+62WbIBMAYHhiXeWTY8wZo7fvJmIcZtXwPoyw+?=
 =?us-ascii?Q?3Ta05yFbKSl9UAQqMGGISFgJKI8vu87PkGWmkR4MYZwLXw9TCgX1VQJ+TT8i?=
 =?us-ascii?Q?5T1LsVeZgL3ZnacA5qqwFrBPdUFg1/S1Y/D/AEGuJr5FjRdA9PvQFbSgHtR4?=
 =?us-ascii?Q?sbf9/e9hQb7bOrzOaxCQF+w7IYZvqT8Bjiy/k2tQogtnp6T0eTouDxhWzbnr?=
 =?us-ascii?Q?QWSqX5zjKk5H5+qNDdEDn63OKjbYcbYKDSvITKRfeP/wg47mCdN2udygh067?=
 =?us-ascii?Q?LFMvs0pTsQc9HnGHKW9ZQsoF5iRePCoRGcwxyRkOCNgUeUFatW7p8JQcefxc?=
 =?us-ascii?Q?VkbYGTbu88+PNklyCzhlrz3JxWg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efbe408-1076-491a-2f88-08d9d0ae2c6e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:53.9673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: So5uZ61Kry0GKk1jriKA9EJXUPOYu2N0rni6+Vmml7KP526vCQHy2FOm9EJfRD//FW1kMtU0q4+PrzXiXQdA2K0awONB1lGQaCNH4GqH0uU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=585 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-GUID: w3mb_GHYJ-7p8scw9RnGLppuHmLuheNE
X-Proofpoint-ORIG-GUID: w3mb_GHYJ-7p8scw9RnGLppuHmLuheNE
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As before, helpers in multithreaded jobs don't honor the main thread's
CFS bandwidth limits, which could lead to the group exceeding its quota.

Fix it by having helpers remote charge their CPU time to the main
thread's task group.  A helper calls a pair of new interfaces
cpu_cgroup_remote_begin() and cpu_cgroup_remote_charge() (see function
header comments) to achieve this.

This is just supposed to start a discussion, so it's pretty simple.
Once a kthread has finished a remote charging period with
cpu_cgroup_remote_charge(), its runtime is subtracted from the target
task group's runtime (cfs_bandwidth::runtime) and any remainder is saved
as debt (cfs_bandwidth::debt) to pay off in later periods.

Remote charging tasks aren't throttled when the group reaches its quota,
and a task group doesn't run at all until its debt is completely paid,
but these shortcomings can be addressed if the approach ends up being
taken.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/sched.h        |  2 +
 include/linux/sched/cgroup.h | 16 ++++++
 kernel/padata.c              | 26 +++++++---
 kernel/sched/core.c          | 39 +++++++++++++++
 kernel/sched/fair.c          | 94 +++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h         |  5 ++
 6 files changed, 174 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d88641..cc04367d4458 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -487,6 +487,8 @@ struct sched_entity {
 	struct cfs_rq			*my_q;
 	/* cached value of my_q->h_nr_running */
 	unsigned long			runnable_weight;
+	/* sum_exec_runtime at the start of the remote charging period */
+	u64				remote_runtime_begin;
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/sched/cgroup.h b/include/linux/sched/cgroup.h
index f89d92e9e015..cb3b7941149f 100644
--- a/include/linux/sched/cgroup.h
+++ b/include/linux/sched/cgroup.h
@@ -5,6 +5,22 @@
 #include <linux/cgroup-defs.h>
 #include <linux/cpumask.h>
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+void cpu_cgroup_remote_begin(struct task_struct *p,
+			     struct cgroup_subsys_state *css);
+void cpu_cgroup_remote_charge(struct task_struct *p,
+			      struct cgroup_subsys_state *css);
+
+#else /* CONFIG_FAIR_GROUP_SCHED */
+
+static inline void cpu_cgroup_remote_begin(struct task_struct *p,
+					   struct cgroup_subsys_state *css) {}
+static inline void cpu_cgroup_remote_charge(struct task_struct *p,
+					    struct cgroup_subsys_state *css) {}
+
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_CFS_BANDWIDTH
 
 int max_cfs_bandwidth_cpus(struct cgroup_subsys_state *css);
diff --git a/kernel/padata.c b/kernel/padata.c
index 52f670a5d6d9..d595f11c2fdd 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -43,6 +43,7 @@
 enum padata_work_flags {
 	PADATA_WORK_FINISHED	= 1,
 	PADATA_WORK_UNDO	= 2,
+	PADATA_WORK_MAIN_THR	= 4,
 };
 
 struct padata_work {
@@ -75,6 +76,7 @@ struct padata_mt_job_state {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
+	struct cgroup_subsys_state *cpu_css;
 };
 
 static void padata_free_pd(struct parallel_data *pd);
@@ -495,6 +497,10 @@ static int padata_mt_helper(void *__pw)
 	struct padata_work *pw = __pw;
 	struct padata_mt_job_state *ps = pw->pw_data;
 	struct padata_mt_job *job = ps->job;
+	bool is_main = pw->pw_flags & PADATA_WORK_MAIN_THR;
+
+	if (!is_main)
+		cpu_cgroup_remote_begin(current, ps->cpu_css);
 
 	spin_lock(&ps->lock);
 
@@ -518,6 +524,10 @@ static int padata_mt_helper(void *__pw)
 		ret = job->thread_fn(position, end, job->fn_arg);
 
 		lock_map_release(&ps->lockdep_map);
+
+		if (!is_main)
+			cpu_cgroup_remote_charge(current, ps->cpu_css);
+
 		spin_lock(&ps->lock);
 
 		if (ret) {
@@ -612,7 +622,6 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
-	struct cgroup_subsys_state *cpu_css;
 	struct padata_work my_work, *pw;
 	struct padata_mt_job_state ps;
 	LIST_HEAD(unfinished_works);
@@ -628,18 +637,20 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	req = min(req, current->nr_cpus_allowed);
 
 #ifdef CONFIG_CGROUP_SCHED
+	ps.cpu_css = task_get_css(current, cpu_cgrp_id);
+
 	/*
 	 * Cap threads at the max number of CPUs current's CFS bandwidth
 	 * settings allow.  Keep it simple, don't try to keep this value up to
 	 * date.  The ifdef guards cpu_cgrp_id.
 	 */
-	rcu_read_lock();
-	cpu_css = task_css(current, cpu_cgrp_id);
-	req = min(req, max_cfs_bandwidth_cpus(cpu_css));
-	rcu_read_unlock();
+	req = min(req, max_cfs_bandwidth_cpus(ps.cpu_css));
 #endif
 
 	if (req == 1) {
+#ifdef CONFIG_CGROUP_SCHED
+		css_put(ps.cpu_css);
+#endif
 		/* Single thread, no coordination needed, cut to the chase. */
 		return job->thread_fn(job->start, job->start + job->size,
 				      job->fn_arg);
@@ -687,12 +698,15 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 
 	/* Use the current task, which saves starting a kthread. */
 	my_work.pw_data = &ps;
-	my_work.pw_flags = 0;
+	my_work.pw_flags = PADATA_WORK_MAIN_THR;
 	INIT_LIST_HEAD(&my_work.pw_list);
 	padata_mt_helper(&my_work);
 
 	/* Wait for all the helpers to finish. */
 	padata_wait_for_helpers(&ps, &unfinished_works, &finished_works);
+#ifdef CONFIG_CGROUP_SCHED
+	css_put(ps.cpu_css);
+#endif
 
 	if (ps.error && job->undo_fn)
 		padata_undo(&ps, &finished_works, &my_work);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848c9fec8006..a5e24b6bd7e0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9913,6 +9913,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota,
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
 	cfs_b->burst = burst;
+	cfs_b->debt = 0;
 
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
@@ -10181,6 +10182,44 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 	return 0;
 }
 #endif /* CONFIG_CFS_BANDWIDTH */
+
+/**
+ * cpu_cgroup_remote_begin - begin charging p's CPU usage to a remote css
+ * @p: the kernel thread whose CPU usage should be accounted
+ * @css: the css to which the CPU usage should be accounted
+ *
+ * Begin charging a kernel thread's CPU usage to a remote (non-root) task group
+ * to account CPU time that the kernel thread spends working on behalf of the
+ * group.  Pair with at least one subsequent call to cpu_cgroup_remote_charge()
+ * to complete the charge.
+ *
+ * Supports CFS bandwidth and cgroup2 CPU accounting stats but not weight-based
+ * control for now.
+ */
+void cpu_cgroup_remote_begin(struct task_struct *p,
+			     struct cgroup_subsys_state *css)
+{
+	if (p->sched_class == &fair_sched_class)
+		cpu_cgroup_remote_begin_fair(p, css_tg(css));
+}
+
+/**
+ * cpu_cgroup_remote_charge - account p's CPU usage to a remote css
+ * @p: the kernel thread whose CPU usage should be accounted
+ * @css: the css to which the CPU usage should be accounted
+ *
+ * Account a kernel thread's CPU usage to a remote (non-root) task group.  Pair
+ * with a previous call to cpu_cgroup_remote_begin() with the same @p and @css.
+ * This may be invoked multiple times after the initial
+ * cpu_cgroup_remote_begin() to account additional CPU usage.
+ */
+void cpu_cgroup_remote_charge(struct task_struct *p,
+			      struct cgroup_subsys_state *css)
+{
+	if (p->sched_class == &fair_sched_class)
+		cpu_cgroup_remote_charge_fair(p, css_tg(css));
+}
+
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c452072a1b..3c2d7f245c68 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4655,10 +4655,19 @@ static inline u64 sched_cfs_bandwidth_slice(void)
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	if (unlikely(cfs_b->quota == RUNTIME_INF))
+	u64 quota = cfs_b->quota;
+	u64 payment;
+
+	if (unlikely(quota == RUNTIME_INF))
 		return;
 
-	cfs_b->runtime += cfs_b->quota;
+	if (cfs_b->debt) {
+		payment = min(quota, cfs_b->debt);
+		cfs_b->debt -= payment;
+		quota -= payment;
+	}
+
+	cfs_b->runtime += quota;
 	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
 }
 
@@ -5406,6 +5415,32 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 	rcu_read_unlock();
 }
 
+static void incur_cfs_debt(struct rq *rq, struct sched_entity *se,
+			   struct task_group *tg, u64 debt)
+{
+	if (!cfs_bandwidth_used())
+		return;
+
+	while (tg != &root_task_group) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
+
+		if (cfs_rq->runtime_enabled) {
+			struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+			u64 payment;
+
+			raw_spin_lock(&cfs_b->lock);
+
+			payment = min(cfs_b->runtime, debt);
+			cfs_b->runtime -= payment;
+			cfs_b->debt += debt - payment;
+
+			raw_spin_unlock(&cfs_b->lock);
+		}
+
+		tg = tg->parent;
+	}
+}
+
 #else /* CONFIG_CFS_BANDWIDTH */
 
 static inline bool cfs_bandwidth_used(void)
@@ -5448,6 +5483,8 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
 static inline void update_runtime_enabled(struct rq *rq) {}
 static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void incur_cfs_debt(struct rq *rq, struct sched_entity *se,
+				  struct task_group *tg, u64 debt) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -11452,6 +11489,59 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	mutex_unlock(&shares_mutex);
 	return 0;
 }
+
+#define INCUR_DEBT		1
+
+static void cpu_cgroup_remote(struct task_struct *p, struct task_group *tg,
+			      int flags)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq;
+	struct rq_flags rf;
+	struct rq *rq;
+
+	/*
+	 * User tasks might change task groups between calls to this function,
+	 * which isn't handled for now, so disallow them.
+	 */
+	if (!(p->flags & PF_KTHREAD))
+		return;
+
+	/* kthreads already run in the root, so no need for remote charging. */
+	if (tg == &root_task_group)
+		return;
+
+	rq = task_rq_lock(p, &rf);
+	update_rq_clock(rq);
+
+	cfs_rq = cfs_rq_of(se);
+	update_curr(cfs_rq);
+
+	if (flags & INCUR_DEBT) {
+		u64 debt = se->sum_exec_runtime - se->remote_runtime_begin;
+
+		if (unlikely((s64)debt <= 0))
+			goto out;
+
+		incur_cfs_debt(rq, se, tg, debt);
+	}
+
+out:
+	se->remote_runtime_begin = se->sum_exec_runtime;
+
+	task_rq_unlock(rq, p, &rf);
+}
+
+void cpu_cgroup_remote_begin_fair(struct task_struct *p, struct task_group *tg)
+{
+	cpu_cgroup_remote(p, tg, 0);
+}
+
+void cpu_cgroup_remote_charge_fair(struct task_struct *p, struct task_group *tg)
+{
+	cpu_cgroup_remote(p, tg, INCUR_DEBT);
+}
+
 #else /* CONFIG_FAIR_GROUP_SCHED */
 
 void free_fair_sched_group(struct task_group *tg) { }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ddefb0419d7a..75dd6f89e295 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -367,6 +367,7 @@ struct cfs_bandwidth {
 	u64			quota;
 	u64			runtime;
 	u64			burst;
+	u64			debt;
 	s64			hierarchical_quota;
 
 	u8			idle;
@@ -472,6 +473,10 @@ extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void online_fair_sched_group(struct task_group *tg);
 extern void unregister_fair_sched_group(struct task_group *tg);
+extern void cpu_cgroup_remote_begin_fair(struct task_struct *p,
+					 struct task_group *tg);
+extern void cpu_cgroup_remote_charge_fair(struct task_struct *p,
+					  struct task_group *tg);
 extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *se, int cpu,
 			struct sched_entity *parent);
-- 
2.34.1

