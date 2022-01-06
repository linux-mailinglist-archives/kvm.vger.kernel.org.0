Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3A4485D7E
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344047AbiAFAsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22422 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343961AbiAFAsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:00 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4XNU023551;
        Thu, 6 Jan 2022 00:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PoisbZfL3AfP4BBP2lSBO2jVWJUFXNgYLbrr9J5R6XA=;
 b=RL2bXCnsrG1LbYoQhWLBOTOCaBalFKyH7oy2bRXIgDxay97NHTbfvquZzRNnY20XOvtH
 tRP4C77oYiD+u4b3GZCKLyX4hbIYCcWT2YSbNd9wYNbqvF/A6oO5CYU2tqH3FIWaooPO
 fLUkTzLk9jLDXYKwSp5mYvTDNG9Khd4O5smth50hbk0vZRtMZGz+Pp5CiDw3R7Qnu/dV
 C8n4hUXLt4mSWXezrkKwA/4z07F4WtZwEWJfZQHu/GcoD7ztmqjH2ZnB19fXHi7QVYqB
 amWbk9DdKHX3euqcwfHp+FMusKdFb86YSoMag7O/WX63T7XDiP/YwvtH9137DyBbI916 hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpeg41s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060W8mm102657;
        Thu, 6 Jan 2022 00:47:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3ddmqgu51k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmDJovxDttcXdnX86qOnjWmXGSbyUuCrGGsesM+8AvsPmCNdiL8RPuyofmWYBGJVOiEjLrz8tP+5T9TvH2wePUgiUvJgJDmflF5loFW7wSYD8AlTbu/gUBJnaZPh1Gd5k42pBVd9oBrzUKreOXYFdM6+KINJAJYJlSO29etQnCrK80R3goe1gdBZO2b0WYdaOcFuVJeZpA4VAvqXghwD25FJiiR1RKRp66lzccWwnS60ZO9kGHuaeW7lPIKo7rHs8Y/ftNwPIoG1GRxSECCyBedsJ3jjjVUzDhEFGmZJf+dzd5axO4iB4dg+tM/6pFyF0oFSnoKO6RYs4RDWjFfkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoisbZfL3AfP4BBP2lSBO2jVWJUFXNgYLbrr9J5R6XA=;
 b=SsIkuMTnOJ/uVc4fy3rZhPIGfstTEJCVQubwFtSiB73quZO0g9xZrJr5JvfHDHt9qqMGhpypMZ0FsnjyQFxzhflRHV2YnFHH68rAfwL37RJXNG+vazuw6ovnVao0e4gNOI/HePkNOgxBsR3VrCPGXSe1aC5HdvYtRaov3LG9bvrh+diq23DszM0XP3FnzIVt8Y9sKbpJ3O+5asubIUeJyr4oeuy9Ws/n4ymh/rpn462NJqwCTkLgfOcjbd3rKmN7f9tG5r3+ImYBie5Z6WF3Ly9zeDSV4yv9h0SbEqYSdYd+FLPXByy1h6qhQZ1WZHF0hjM5i5bqmJWmui/uQ7W2Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoisbZfL3AfP4BBP2lSBO2jVWJUFXNgYLbrr9J5R6XA=;
 b=lZmMutmMDDxO3XCaVH0aBLUL69XF/qRpY9vQcdNMPRefLAhaweh40ejivD8kCXCiPCD3dw+lSUPY/B0BKi2UCE0x5Y2vCV2/5wmwn4urhRe44zRR9nqWOBp0LEkLAA4mBTZSZGWl+MKBxP11trNbL4te9Dpa75Gi7HL2SKAzNrw=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:21 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:21 +0000
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
Subject: [RFC 03/16] padata: Add undo support
Date:   Wed,  5 Jan 2022 19:46:43 -0500
Message-Id: <20220106004656.126790-4-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b2effce9-2081-45ee-e6a4-08d9d0ae192d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44225C9463845CA496A26DFCD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ApamA5NsUIfXuhdZDe8fx2caSD/QYBOZUbavaVif1l/n6BHG6sySYOzbNoBLqHmM+qbinNxivpOGeU3/ojCmIFIrXKKZIkMHFl7ao5YtDMG9xi/WHMRKzh+D/N4CFj/E+Zx7vp3iCUr/ZoTYSo2ArThX5w7nMNSapQz4+TFv0Z6GGzUd/dHftes+Vyn4QYw4VtqXZiOEyJ9r2/9lpepvVTtt882Z87QM3gztrXPSoOhLawdk2DmrDAcIQEoyx3WQhcuD6V+puL/kzShNctkVulLCVjyTFGcWvjjB7HkjrMDsrwBv+LiJduxAsRVKA1wRhljoD79jt7UL2NhCPtdWx7asOTkCPnosdjdVsf9+ZqmaS/qi699LNS6RtizMnHMDD/csuNORy4/j4pROtu644Cm6LKw+viX+iJeVdBvwjrSPX2P+BvvQ5sZfVt3SZR1KHkAIy6vaK+Idgip1J7TtGTBNLR4ZiB8gEt9QuwK4JwxDNZkHzZTHyrWW2GY/yRGkGNTtjtiW/Q04qgLlOhQlc36KLT4YX8q6vPn7LHdty6mv1rEElmq2DTWppKkv1vf03CW5ltnX6oIclV7nSnNCcyO58f45XgLUnBhNSltE0z+cRxSS3/VPA51lYBL144h/ONN9Wi6PAVcF3DQeVbYwmyG2a3cPf9im7Rq+4Ykl3bys7/NMSY/fc89Uo+0mJpWEEL0+GrlnAxGDXUNokQcRCaYOBrOhTW+hLwfIs77TbO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FJDWYOBPvo5lEb0oKvNhde8bPtLWRXP6LQTSb7JW1wx4WGpFzyqSS54YtDfD?=
 =?us-ascii?Q?pW2dxxtLCXAgzokkdT7cwO2mdKuwb0Sw7xhAjNSkhwYut7Gr0PP1RisgVqSN?=
 =?us-ascii?Q?FsJUcefN5f3U9qmklPsXfm+DWL0Q/9TTxaqvFE++K+hToJ+qDq7FVQgZ0E42?=
 =?us-ascii?Q?hP4Mu6ByXztKbf2sn6rbIZL58gEXY1a3RRsT+h9EtTUlaIwHiLfhWXuaVelL?=
 =?us-ascii?Q?mm94HRq94fzW/oqXPC2mcNW9UoQ5yHwkkj1eIQ3fwYiNTRo00UWOTcriq5zY?=
 =?us-ascii?Q?wlJn9TWEVpz6iI5IN93V2ilvsr2t2NyoWV1+9Ys6VEi5ZC7XOzKTGEnrSP9f?=
 =?us-ascii?Q?nipwshzb4pyeDgProgwwPmR7QoJORAuUJ0Ptr3VzTXHM5TjmDmYMBajltePF?=
 =?us-ascii?Q?8HrDap9icibvsp9tuZDUHH2THPPkK2D1wLId6aNhwh7KIdGaymiCxasmGSv0?=
 =?us-ascii?Q?Fo9IKl0SMQTfE5ZJqLPGDIO2bSRyqGt5NBcJ4zixYaoGetEJ4nw9iQwl2Dr1?=
 =?us-ascii?Q?pxNOtAiZZhF8P7/FsGPi3BHiL+ZfwvZY+4L3ajeHzZCkOClgf5qpR5dvZYjU?=
 =?us-ascii?Q?Bq2oNPKJT0DsQZ97dvA5Ld2Z2+EYHOrohYkAYtByUHvaDSydz5UJtBnJ0jLp?=
 =?us-ascii?Q?XjHaJ+hSQpesKstR9+qzUBvQ8N1S+oWoiMfTS+WrCFxxFETzk8+Pej4p9Jmm?=
 =?us-ascii?Q?E5NqOv60DyvGOu+eZf29t6DPGeb7FykjMbokYYq+EG3Kw8/7YnONytbu1A/j?=
 =?us-ascii?Q?zdALJreKfw+uN7xaODH29pwtke+TZVHDuDqSuJ/7wZ3F2+lrTUqhpPbQFPQZ?=
 =?us-ascii?Q?wDEajoCaXqWsoGUKnWw1OuvIpkVTtjIqz5I0isiosvudSx6gN3T4MOVfkNJF?=
 =?us-ascii?Q?t8YqHas1JI/DfqisygzalbBnQJWk0rMRXYKyGYFvd+dvOhh9ID7iw8VNL2wg?=
 =?us-ascii?Q?nv3sVdzg5cGcTYo70FFpnIrKLADdXoHw7TkhXNw+eI0IvZRY8wcuySYPtRU+?=
 =?us-ascii?Q?pfO254qtQA5Mj0M2a/k4VNLWZMU48EVwXdnkuUKj+7fgA3QQPMKy6bRL23LV?=
 =?us-ascii?Q?felpGHA71ZRtxQYjcKTaNtnn+NNaAD3E/Ir7EOi8CpSGYx9G2Cvrsf0QBK0h?=
 =?us-ascii?Q?4D0oMU4FfJeCQ+e1mef0S0yx6/WbFHxK3dRG7E8k5T7WJCtmApTQ49vEm9dC?=
 =?us-ascii?Q?9olcU0IRmRkdqCZy7hJRU1+jOIe9zEHC7jw4DZYFewKB6IaJuQx2xRKZ7O58?=
 =?us-ascii?Q?SpmCg06IBATt9z0iHXv27eJddkGERLz4IOkYEJipOU3WlAWhoG5yYc7OfBr3?=
 =?us-ascii?Q?KE65/YXlSjgdAggyxIe40ZxSOENZZv6T8c3ORTBPcaLgF9XD72si4KuBFh/A?=
 =?us-ascii?Q?XhI4q3ur4ng0mrqV9t2qb6KrhKtLLJsiKs2zDEZ0koAIht3cyPZE2jO8h1BS?=
 =?us-ascii?Q?O7qropEVoibL7taAENKRv8b63tRtHROy6VtAKSRrF41BFsQ4omV3EtjqNo8v?=
 =?us-ascii?Q?ZEZE+eFNqnRSgp4GLj9CQAU6Ct+Sf3r0KS7tazqveJ+KFT2B8mnFjDc344NB?=
 =?us-ascii?Q?arGy5cABfIO7mfZaYd86qIrpGE/XNBIa8vMDGDkr93VxJQhfHSSfKmUeuwJ4?=
 =?us-ascii?Q?xULn4q6aZz99tKwlgzI7GIcwSNzQUlESDCWq/Nsu8txAIpwFRJvt6EVfdhL5?=
 =?us-ascii?Q?tQZw7FQb6zj0+cL7+K5elswV+cA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2effce9-2081-45ee-e6a4-08d9d0ae192d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:21.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TgV5ZF0ycnEdQ8MMR8lM2dBmWEKt6vqZzn1iDxgixu9I44MejpjSe1mY7oZ+/WrIisEc17vhEhcr2QxVrGFlmBt8GGeb/OUxPIoz0FuMm4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=634 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: IckvHlTAip73IL8Ep3N-9WoqAYcw_KlT
X-Proofpoint-GUID: IckvHlTAip73IL8Ep3N-9WoqAYcw_KlT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jobs can fail midway through their work.  To recover, the finished
chunks of work need to be undone in a job-specific way.

Let padata_do_multithreaded callers specify an "undo" callback
responsible for undoing one chunk of a job.  To avoid multiple levels of
error handling, do not allow the callback to fail.  Undoing is
singlethreaded to keep it simple and because it's a slow path.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h |   6 +++
 kernel/padata.c        | 113 +++++++++++++++++++++++++++++++++++------
 2 files changed, 103 insertions(+), 16 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 1c8670a24ccf..2a9fa459463d 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -135,6 +135,10 @@ struct padata_shell {
  * @min_chunk: The minimum chunk size in job-specific units.  This allows
  *             the client to communicate the minimum amount of work that's
  *             appropriate for one worker thread to do at once.
+ * @undo_fn: A function that undoes one chunk of the task per call.  If
+ *           error(s) occur during the job, this is called on all successfully
+ *           completed chunks.  The chunk(s) in which failure occurs should be
+ *           handled in the thread function.
  * @max_threads: Max threads to use for the job, actual number may be less
  *               depending on task size and minimum chunk size.
  */
@@ -145,6 +149,8 @@ struct padata_mt_job {
 	unsigned long		size;
 	unsigned long		align;
 	unsigned long		min_chunk;
+
+	void (*undo_fn)(unsigned long start, unsigned long end, void *arg);
 	int			max_threads;
 };
 
diff --git a/kernel/padata.c b/kernel/padata.c
index 1596ca22b316..d0876f861464 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -29,6 +29,7 @@
 #include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
+#include <linux/list_sort.h>
 #include <linux/padata.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
@@ -42,6 +43,10 @@ struct padata_work {
 	struct work_struct	pw_work;
 	struct list_head	pw_list;  /* padata_free_works linkage */
 	void			*pw_data;
+	/* holds job units from padata_mt_job::start to pw_error_start */
+	unsigned long		pw_error_offset;
+	unsigned long		pw_error_start;
+	unsigned long		pw_error_end;
 };
 
 static DEFINE_SPINLOCK(padata_works_lock);
@@ -56,6 +61,9 @@ struct padata_mt_job_state {
 	int			nworks_fini;
 	int			error; /* first error from thread_fn */
 	unsigned long		chunk_size;
+	unsigned long		position;
+	unsigned long		remaining_size;
+	struct list_head	failed_works;
 };
 
 static void padata_free_pd(struct parallel_data *pd);
@@ -447,26 +455,38 @@ static void padata_mt_helper(struct work_struct *w)
 
 	spin_lock(&ps->lock);
 
-	while (job->size > 0 && ps->error == 0) {
-		unsigned long start, size, end;
+	while (ps->remaining_size > 0 && ps->error == 0) {
+		unsigned long position, position_offset, size, end;
 		int ret;
 
-		start = job->start;
+		position_offset = job->size - ps->remaining_size;
+		position = ps->position;
 		/* So end is chunk size aligned if enough work remains. */
-		size = roundup(start + 1, ps->chunk_size) - start;
-		size = min(size, job->size);
-		end = start + size;
+		size = roundup(position + 1, ps->chunk_size) - position;
+		size = min(size, ps->remaining_size);
+		end = position + size;
 
-		job->start = end;
-		job->size -= size;
+		ps->position = end;
+		ps->remaining_size -= size;
 
 		spin_unlock(&ps->lock);
-		ret = job->thread_fn(start, end, job->fn_arg);
+
+		ret = job->thread_fn(position, end, job->fn_arg);
+
 		spin_lock(&ps->lock);
 
-		/* Save first error code only. */
-		if (ps->error == 0)
-			ps->error = ret;
+		if (ret) {
+			/* Save first error code only. */
+			if (ps->error == 0)
+				ps->error = ret;
+			/* Save information about where the job failed. */
+			if (job->undo_fn) {
+				list_move(&pw->pw_list, &ps->failed_works);
+				pw->pw_error_start = position;
+				pw->pw_error_offset = position_offset;
+				pw->pw_error_end = end;
+			}
+		}
 	}
 
 	++ps->nworks_fini;
@@ -477,6 +497,60 @@ static void padata_mt_helper(struct work_struct *w)
 		complete(&ps->completion);
 }
 
+static int padata_error_cmp(void *unused, const struct list_head *a,
+			    const struct list_head *b)
+{
+	struct padata_work *work_a = list_entry(a, struct padata_work, pw_list);
+	struct padata_work *work_b = list_entry(b, struct padata_work, pw_list);
+
+	if (work_a->pw_error_offset < work_b->pw_error_offset)
+		return -1;
+	else if (work_a->pw_error_offset > work_b->pw_error_offset)
+		return 1;
+	return 0;
+}
+
+static void padata_undo(struct padata_mt_job_state *ps,
+			struct list_head *works_list,
+			struct padata_work *stack_work)
+{
+	struct list_head *failed_works = &ps->failed_works;
+	struct padata_mt_job *job = ps->job;
+	unsigned long undo_pos = job->start;
+
+	/* Sort so the failed ranges can be checked as we go. */
+	list_sort(NULL, failed_works, padata_error_cmp);
+
+	/* Undo completed work on this node, skipping failed ranges. */
+	while (undo_pos != ps->position) {
+		struct padata_work *failed_work;
+		unsigned long undo_end;
+
+		failed_work = list_first_entry_or_null(failed_works,
+						       struct padata_work,
+						       pw_list);
+		if (failed_work)
+			undo_end = failed_work->pw_error_start;
+		else
+			undo_end = ps->position;
+
+		if (undo_pos != undo_end)
+			job->undo_fn(undo_pos, undo_end, job->fn_arg);
+
+		if (failed_work) {
+			undo_pos = failed_work->pw_error_end;
+			/* main thread's stack_work stays off works_list */
+			if (failed_work == stack_work)
+				list_del(&failed_work->pw_list);
+			else
+				list_move(&failed_work->pw_list, works_list);
+		} else {
+			undo_pos = undo_end;
+		}
+	}
+	WARN_ON_ONCE(!list_empty(failed_works));
+}
+
 /**
  * padata_do_multithreaded - run a multithreaded job
  * @job: Description of the job.
@@ -509,10 +583,13 @@ int padata_do_multithreaded(struct padata_mt_job *job)
 
 	spin_lock_init(&ps.lock);
 	init_completion(&ps.completion);
-	ps.job	       = job;
-	ps.nworks      = padata_work_alloc_mt(nworks, &ps, &works);
-	ps.nworks_fini = 0;
-	ps.error       = 0;
+	INIT_LIST_HEAD(&ps.failed_works);
+	ps.job		  = job;
+	ps.nworks	  = padata_work_alloc_mt(nworks, &ps, &works);
+	ps.nworks_fini	  = 0;
+	ps.error	  = 0;
+	ps.position	  = job->start;
+	ps.remaining_size = job->size;
 
 	/*
 	 * Chunk size is the amount of work a helper does per call to the
@@ -529,11 +606,15 @@ int padata_do_multithreaded(struct padata_mt_job *job)
 
 	/* Use the current thread, which saves starting a workqueue worker. */
 	padata_work_init(&my_work, padata_mt_helper, &ps, PADATA_WORK_ONSTACK);
+	INIT_LIST_HEAD(&my_work.pw_list);
 	padata_mt_helper(&my_work.pw_work);
 
 	/* Wait for all the helpers to finish. */
 	wait_for_completion(&ps.completion);
 
+	if (ps.error && job->undo_fn)
+		padata_undo(&ps, &works, &my_work);
+
 	destroy_work_on_stack(&my_work.pw_work);
 	padata_works_free(&works);
 	return ps.error;
-- 
2.34.1

