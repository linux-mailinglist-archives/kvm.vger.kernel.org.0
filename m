Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E7E485D7A
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343994AbiAFAsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16616 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232760AbiAFArz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:47:55 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4TM0023248;
        Thu, 6 Jan 2022 00:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=KgMOY08OYy5Jfl+TXf47eMq8wi/R/m1t5Tc7eqelZAA=;
 b=obA+DWnirHZieNnVEX++4t6Tr6JYwiQLZmt7W4rzKZGH9QPZJh8FogPqWSLX2E6I+qfN
 1NKJ1kRohMBBbt8gQ7LE6t6FdKU02kKZXfXy8JvdZcsi7x3Z1ttGqcvCYsnT3//1icSk
 N1GJ0x44ARbb1EGCzrj6Mkq0kKhYdfddvYk7QDYnNu5/5M6h6O1KZ6WeVewwJJOuuIiS
 XGyksNvnZkbH5SwxrZEF867rngoW2HjbhXgq9s8VQgcLOgZ8qxPLvODJitCk8gDma2Rc
 QjwQTEMV3AlXdrvFnE1KX81UdeZNRywnXeSZbCpxjYOPEnSVSqJrZD3Z0WAskG7NvCzL iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpeg41f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VgcA076335;
        Thu, 6 Jan 2022 00:47:20 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3d1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZYGTUx3O/Jt9dXL3LxDxabdxxwBmwuB/zJUlTDYbUhlVneSKEiV/ENLjN4evJvPZAKsS/deabTUnPduwfEWWb50sfpImnG5kQcK+4x7KO+qf1kbjmsEAeNb6ahuOrZl8+ZrI4Kgq0HsGWZQzR2Y82CfjmPrYLnjOfjndy/SSK6cMlKDbMJ4cDwt5dqrVKxb9qOFf7ei7cQznWJ8T+HjDXse9Kt3KYPvdasjf6ncPrQktF2m5Ci8kQwK35D1MkNW2mwe1om1wVpLhluSyHXSv2B9boKGwZkLtgpdN4IOIlcSZ77KwcjMlTVxqnnV+8Z2I2L494Rmvz1PuYuwjmCvDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgMOY08OYy5Jfl+TXf47eMq8wi/R/m1t5Tc7eqelZAA=;
 b=QDzWIabzL1Wh5kAWalj6vSY8avHk9oXE09+04m2R8DaHJonZnFEng/XFekL/lTgvakRZ/Rn9hBdfh8yynwJ3bF9snsmLJjvrWlhsDiv/6R8XIVmGrY+s3pE5fr3WgJmbHAuMIcjse/oe/cGPtMMoucXr0P5VHH+MI1d40I1jHhi4O9Wbr7EYJtKX+TG3J8mVAhPR3ICCmXOISlq11jYTooC0ibyr8Wmp22tdMF/P5p3vp44211o2mJFYmoWqCy4lS9dn1s+DA1HsxRRXjmqoFN3Hh8k7cSgsgoLn7lZY10fZzTAF7H1jODmkGrcjTtqh98R4Hg7vNU9PLdMkuG8YHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgMOY08OYy5Jfl+TXf47eMq8wi/R/m1t5Tc7eqelZAA=;
 b=v+U+oy8wb9riz2oYRvfy1ZtVfF3adOBgEHvuwzaUGDjyQKOXEugeZ4Rfju6t2vZxazZBKxo8clKqvx4NvAVbS7XPX+aFmQa6Lxg0XR2Lj4yojjf1j01T8aP6uqkimbRztd6s2vLuOdHIEqwyBR6/Y3d07PKd3R5UKUBZwmd8VsY=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:18 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:19 +0000
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
Subject: [RFC 02/16] padata: Return first error from a job
Date:   Wed,  5 Jan 2022 19:46:42 -0500
Message-Id: <20220106004656.126790-3-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 512a504a-9bd6-405f-adbb-08d9d0ae1790
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422289FBF38F936AA268060D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Lb5mBnrM58MOmrLMWJf9fCodHNjPLb/fLVYNHx+Ed39u58V2s1rkBSv3GC05I7145sijpese8488pp6LzgDZrokOpPy0ViSwRofU9ind8v0LmiTz8pTk5UnIoPU684WeH43Br8jXQlG9bxxMPjme83tqcMSX+tU3MWmr4Io8WBXMyeu83PWcTzeJaDLPMNzcKBNB8Sh63TztnfylfUfVxCzylLrikM9bRhpEQC6ibQ5e6Ei01gvGLtgrh1criWed5jgaY75P5NUphD2R39v3SGYJpCiAUL2G49fiKV4YvjcAIZfyF583QcFxL2PJuBx2I3n06fKym44KKNLWWmD1/dKHR05oK90IBnQKx0/HcwnYAd5tp0JPzQ9MF/k+vVrYVfH8smXO6B+6EwFH5QlfybX7DYRrH+b4frGKUaFvmzOywRpx5DrpZOKXdPQAUdLYCdikGN7diti1c+7Z7l5rzQEgpSo2h1M/R0b9+qmeAMO6TtnkER0QUtvQ+f6i+6L50SgxDQWNAf44BA4A8qsqLv/xUVhg4fI9xzrOi6mttNxeThNvmhppQn1wlJ4KDaHtWcBjYCbYrLSeGZHs1xPwVDzAAgzU7KEnw23HKA+UaD7AshcGUwky+GVWQ2cDocnJNjGKqIQIm/AeLXwWkRYb18z3Fc4FA0Ic+BNRok6nacF0g+ZF6VWKeLeOU7dCQWScy2Ln+c/kuk58DeMgVfjrigatXPyC0iVlVmkT62h7Us=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aXMXNG+lg0slpWdQELMzu8lRJE/kse2CaRag2Tjq4BVo+gfCdRUX6bSAa2U/?=
 =?us-ascii?Q?E3VHcKsjX6P2vpyB6a2ZH4BaLasjEINyT6zzgJ/0iNvNaULLvUOauBj8OjsU?=
 =?us-ascii?Q?/c3GZhsFdVzzfrVC2YXSju9rpL4TkOh+GL7FHwl6O+i/027W5wHJEt0g3Ock?=
 =?us-ascii?Q?HIZOebo4CoXDwnj1BbpMgbGnlyxh6ljL+u96jNpU2jsjd176BDaYg5Pbu6Mc?=
 =?us-ascii?Q?rzthaIUDn91vYi+L/ziFngwMhcw7q/Xre1pRc9tqWRPTHd6TKZToKPX0BCOh?=
 =?us-ascii?Q?oap2VsRglV0xvBah/M2UJhArah0n4BBer7gSx0ei6RrUQQGRHHb5MzHM/bIY?=
 =?us-ascii?Q?EjIz23R57x8MhuF66VfGI582prQwHurB8wZU8bEF7Kh7h6VJPp1RgbNUVZbp?=
 =?us-ascii?Q?vldKDlEBGiA+qGzMOu8D+dEjG6DKZ+sCY8TcZPEVekcinH40SIyF0PjXUS0a?=
 =?us-ascii?Q?aufSabWmvTKeFclgnUh+zfnEiiBjCzlPvP8nY7vaXzgloZVB44tMyIYjUbWE?=
 =?us-ascii?Q?N2JTLkuOOFlwVqHbuAK+7U42kcpHGdXe3TldAs1kDkEesU3KfrNZLz9rwRUt?=
 =?us-ascii?Q?jOYJ2Jl+o3FMstnQtuT0fC4gq9e99WZwO7lK0jHR6WTjHPQa7ZhoxBoxnMm3?=
 =?us-ascii?Q?XR2UykxoPLAOQKECAJIqCjyBM0OuASp9FiXVjtlO9aDmBTWpNJ3bctbTJrek?=
 =?us-ascii?Q?WAeNceVjl4aWZbsaxnS6duIYZKh2kE94SofZQgqTN0rWuwrnjUlSaTby5mgc?=
 =?us-ascii?Q?zVsqlUCWWqYm04BAqoU+utioBepZYeC8PKDm9lrQVGB/YjK1hvZ2RWH1Q3ZA?=
 =?us-ascii?Q?Put5/tFex6OZdYguK1eGW7JzXPDPUiARxls4iznumnuXcA5vr5Xo/VbowwmK?=
 =?us-ascii?Q?Xg5CZDzes1pfz6rqRXuny9fVdyp3ag+oEnPHmYqO6qDBfAoKmn0F+wAJ4/3w?=
 =?us-ascii?Q?ovLkweAoRPH6QM+v2y4eF5eAs6UEOH7Hn5d/8nJ4Clili5plOBROudNqKG7T?=
 =?us-ascii?Q?UmNpzCoX89a5WKhoEA9teBsfneuH52KWHVH1EtQPc5VUIiJaw/ZZDfpS/rsD?=
 =?us-ascii?Q?Pu0Lh4iEQVdO5/5I1C9jGRleeuzB4Ffh9DzyfIJ4d7N1IMMf9LZGMyRwuHRk?=
 =?us-ascii?Q?OxzhBi6beyw4/Cx248+kd8X4l2r3zgRq78VxWtqSJ5k9wNzhpWxZNr6fkXzU?=
 =?us-ascii?Q?OjDjXu+7PdL0XnnHWxrjwmFCSmGL8bzvjk/d0E3iAgcg72d0cNxZrxZsmcHT?=
 =?us-ascii?Q?AA7fQtGCwGo3HgdgOTOkcc1orp13hyaH6L7w5waMRhhe5Kr9CyYSncBmBCkl?=
 =?us-ascii?Q?YdSBFBC1i3PH4xbsS5ksSU5rUq1DCeBKnIHTN9YnM65sgFGU6uhVfopGuQ8L?=
 =?us-ascii?Q?Xc+4VbRSWtd4szwTM2lduC09ApG881jBKEJZh8t42Iuoh79AotrCTOotqbn0?=
 =?us-ascii?Q?/Ecvd8tWaZLEhm+XcfdvbBhdWVSNd76xHN7m8MqjRnFR7ODBdDnye9+dzkH4?=
 =?us-ascii?Q?jN0uj5EtHwsJ7TK6JcAMnKJBZCyr9FdYkeAoSHvLmNnnAW2rd0DeoQ+4tFjg?=
 =?us-ascii?Q?OY6hNVpJJ8JbqaleMCTrWpKTDksSy05JMOblIYpv3r2CC12PCwi6MqFGFyMj?=
 =?us-ascii?Q?+H6zn9BmsjFlB+xAPlWor2mOf8kGIrwqLyhGWJVlSbRFx/E006Z9+QBFylRD?=
 =?us-ascii?Q?2avWUZdtwK2gjujmdazXWAtUuFg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512a504a-9bd6-405f-adbb-08d9d0ae1790
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:18.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBWAB5rGKG/lXbAC+wwPy3pUFItO1xR0rk39xh8mTOSAXbhGLUvsT1E/sDk84kRWk63MNvRFxsMZC9DjO9ztSJZJv+GvJPU3rxpVRNLy4d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=690 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: jQanJTV1FTLmez4qLUmhqXWU1nnSHByB
X-Proofpoint-GUID: jQanJTV1FTLmez4qLUmhqXWU1nnSHByB
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only current user of multithreaded jobs, deferred struct page init,
can't fail, but soon the world won't be perfect anymore.  Return the
first error encountered during a job.

Threads can fail for different reasons, which may need special handling
in the future, but returning the first will do for the upcoming new user
because the kernel unwinds the same way no matter the error.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h |  5 +++--
 kernel/padata.c        | 22 ++++++++++++++++------
 mm/page_alloc.c        |  4 +++-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 0dc031d54742..1c8670a24ccf 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -126,6 +126,7 @@ struct padata_shell {
  * struct padata_mt_job - represents one multithreaded job
  *
  * @thread_fn: Called for each chunk of work that a padata thread does.
+ *             Returns 0 or client-specific nonzero error code.
  * @fn_arg: The thread function argument.
  * @start: The start of the job (units are job-specific).
  * @size: size of this node's work (units are job-specific).
@@ -138,7 +139,7 @@ struct padata_shell {
  *               depending on task size and minimum chunk size.
  */
 struct padata_mt_job {
-	void (*thread_fn)(unsigned long start, unsigned long end, void *arg);
+	int (*thread_fn)(unsigned long start, unsigned long end, void *arg);
 	void			*fn_arg;
 	unsigned long		start;
 	unsigned long		size;
@@ -188,7 +189,7 @@ extern void padata_free_shell(struct padata_shell *ps);
 extern int padata_do_parallel(struct padata_shell *ps,
 			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern void padata_do_multithreaded(struct padata_mt_job *job);
+extern int padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index 5d13920d2a12..1596ca22b316 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -54,6 +54,7 @@ struct padata_mt_job_state {
 	struct padata_mt_job	*job;
 	int			nworks;
 	int			nworks_fini;
+	int			error; /* first error from thread_fn */
 	unsigned long		chunk_size;
 };
 
@@ -446,8 +447,9 @@ static void padata_mt_helper(struct work_struct *w)
 
 	spin_lock(&ps->lock);
 
-	while (job->size > 0) {
+	while (job->size > 0 && ps->error == 0) {
 		unsigned long start, size, end;
+		int ret;
 
 		start = job->start;
 		/* So end is chunk size aligned if enough work remains. */
@@ -459,8 +461,12 @@ static void padata_mt_helper(struct work_struct *w)
 		job->size -= size;
 
 		spin_unlock(&ps->lock);
-		job->thread_fn(start, end, job->fn_arg);
+		ret = job->thread_fn(start, end, job->fn_arg);
 		spin_lock(&ps->lock);
+
+		/* Save first error code only. */
+		if (ps->error == 0)
+			ps->error = ret;
 	}
 
 	++ps->nworks_fini;
@@ -476,8 +482,10 @@ static void padata_mt_helper(struct work_struct *w)
  * @job: Description of the job.
  *
  * See the definition of struct padata_mt_job for more details.
+ *
+ * Return: 0 or a client-specific nonzero error code.
  */
-void padata_do_multithreaded(struct padata_mt_job *job)
+int padata_do_multithreaded(struct padata_mt_job *job)
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
@@ -487,7 +495,7 @@ void padata_do_multithreaded(struct padata_mt_job *job)
 	int nworks;
 
 	if (job->size == 0)
-		return;
+		return 0;
 
 	/* Ensure at least one thread when size < min_chunk. */
 	nworks = max(job->size / job->min_chunk, 1ul);
@@ -495,8 +503,8 @@ void padata_do_multithreaded(struct padata_mt_job *job)
 
 	if (nworks == 1) {
 		/* Single thread, no coordination needed, cut to the chase. */
-		job->thread_fn(job->start, job->start + job->size, job->fn_arg);
-		return;
+		return job->thread_fn(job->start, job->start + job->size,
+				      job->fn_arg);
 	}
 
 	spin_lock_init(&ps.lock);
@@ -504,6 +512,7 @@ void padata_do_multithreaded(struct padata_mt_job *job)
 	ps.job	       = job;
 	ps.nworks      = padata_work_alloc_mt(nworks, &ps, &works);
 	ps.nworks_fini = 0;
+	ps.error       = 0;
 
 	/*
 	 * Chunk size is the amount of work a helper does per call to the
@@ -527,6 +536,7 @@ void padata_do_multithreaded(struct padata_mt_job *job)
 
 	destroy_work_on_stack(&my_work.pw_work);
 	padata_works_free(&works);
+	return ps.error;
 }
 
 static void __padata_list_init(struct padata_list *pd_list)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eeb3a9cb36bb..039786d840cf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2018,7 +2018,7 @@ deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
 	return nr_pages;
 }
 
-static void __init
+static int __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			   void *arg)
 {
@@ -2036,6 +2036,8 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 		deferred_init_maxorder(&i, zone, &spfn, &epfn);
 		cond_resched();
 	}
+
+	return 0;
 }
 
 /* An arch may override for more concurrency. */
-- 
2.34.1

