Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEAB485DA2
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344000AbiAFAvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:51:23 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53980 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344262AbiAFAtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:49:14 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4Owh011234;
        Thu, 6 Jan 2022 00:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZRSeNxc7Bw6HLtNJdTm0NAGeJ5M3OC0ZzhTZqShHmU4=;
 b=UTQacROCJf8Zrovm/SVTe6QWEAECNxcoaL5HGANRRoEIuZdrLFU0cbWhqiLfVFHcnKr9
 IYHXF9HN2JjDmN/SGRhajex0lf3vDotYyZqaGeSfvssnIEtdJlqRvFmn6/XslP3b83Xu
 zqJV92JJjgQESv+JwMDEBP52rzLwpBAaXD+sZo5UxdnvCn61/wgt+RubRtBbLIUJn/TE
 0yKUePT3Fnb2hOKtqugd+VRdRjQmFLviNmZQwfbu8PuCohO4obs5NnejqpBEEISytuPV
 UrOXzgJIXQLx5vuX+z3xJoGvgGD1U6/hR6xL8Mqw+tJT4stOfOmgvFcca+B9J4E23jLF lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpdg447-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060Vg5W076301;
        Thu, 6 Jan 2022 00:47:45 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3dg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lel81XyYCcCv3s1nDYeyO04Je4S89dq1ut4jcPLk5uaQ1yIe8dbZfDR+VbxkiFq1NK9xOeSq+N3FnPVZ45uyora9GENXUGWYQFWUwtwEWNMHuDP/sV7pQuYJUnN6fGlHxRpPuB3oCv7P5Z3o0ybDoV4MJfxDX7HTRWtTEsu+StAARRDN1yteRSP2AECEDrINSWBvDcAVsPAa6rG6vO/3TyOlnFnAMyeO7qfxzNWgWYlmXc5Ov3nCkbCNYRhbSNqdEBqvVeJlmrZe3/o9K7yeftmFTceEl3QECGjQpJ8XZWxpAVJQ19T4rq78LKaeu2cnZShCkLc3lXAcHqgG7oxPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRSeNxc7Bw6HLtNJdTm0NAGeJ5M3OC0ZzhTZqShHmU4=;
 b=bptjIJnsx3xs5pmUySeuQIKFws9SLz02e4evth0KG6F4yS8iRGd+yB9/4mUyVur4yHVvDP9m0uPGZbpN43IBVhc6T05DU0WrGrpNSrf0opGLj7zxA3LU8WQUCVrklknH80VVUgCfelT1qgZDl48yklf6t4Ridf6x89Z8izhikmlzZ5tJ/oszzhfa0ek/qOprhPZGzc7DaZy790Ddeo3RQStmJ4RiGYJuRLE4fPPoZppRuH8Z6S/PdV5ylA4Xx/fAPtQyJP9hUwg6WOoyb8286L0uROwzGfTnGqRRZ5SgyIlcCSNJFptZDbY3193djWWv2U3/Hl7DjufCa1FSlgaJfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRSeNxc7Bw6HLtNJdTm0NAGeJ5M3OC0ZzhTZqShHmU4=;
 b=f8lqgBR/g/9xz1jOH9LdTWm1ZUVGIGFJMD4dCKQp+8TYfanTdYEWY67WL/+3hGUvDMi8HEka42XHFXBF+1wpGZaegPxchB0xOYC5fE8BsLKJAw3+C2MoSoaYMnmwBBwFufpRYYJSFBjzzPASiov7rQQef5Gwo3nkrGIsIowAlgs=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:43 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:43 +0000
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
Subject: [RFC 11/16] padata: Cap helpers started to online CPUs
Date:   Wed,  5 Jan 2022 19:46:51 -0500
Message-Id: <20220106004656.126790-12-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: ad652e27-55d4-4bc4-4d08-08d9d0ae261d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422C971C676DDA55CEF7A2AD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33+TMqCEn0u4jovHvHlDynU6+A58o9pjgmRvBgn+i+pkdT9hCS8cHSBo9fpUggdKHfBg4/LkZK8lXwue8WTwM7ijkpOoYU1M53C+uWy28UFUPiCGQBnKWI5lRhxe9Yj2b2+60heN9v7Zv8p2qy1IL0Ot8HMH26igssiTBSq4Hl/1eX2XAgalitjpfMpxiAi0EbrT5dHNVAIzhxivzxuSeGbB/v2bWbOCKDlL+A2e/KHkFLnf3Pl2/EpmAs54zYW4389s/mMr5WaAxFaLiSaKoRCi4E52CxVcYO9XtQtdW9ffYBYontMd4jwtfnAFqgG47U8WTruAvaMnt0Ycgu8kwukt+c5LQqfrzYufrIAdBG8efQFDzpQUtWXcpPiIEbAB8xJHzYzu81ou43kzxXW40U+qVmNCU24O7rEjatClRhTgYjXko6SjuB8yo0J3bC3P1ZMVk3DqPt7dy6xgn4xpFMrrv/62JRVUVtPbZ68zEcYDLV6GSn7g7P+qaL/+NNrGaX3/iu4ds18TlYEw/7aNnYk+bnuSeQu/SRsvJJbu+f01/TGwaCwDqmbvNHAipdn34gJsZD2A/BunSvB54eGPj0HzNU1NR6gAwaVTmN6ckdX6I+mf1UGK6dnlAnm9Rw+eOo3FGRI3b6A0+Cwzwve7N1SujSNVex3XI2/TYTGEc+2DsPr1idHgfFpQSwF8m8ahGhKAyvT5ktEj/SORivff78kXyx9vXszRAI7looLgWVg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/aSos5vd5kxO6Io5KHbf6r+eqCnYvyH/bgb63WBnA3Nm8AZ9gLn57FaOsWy?=
 =?us-ascii?Q?Dlmq/nfIRnNnmCT1/ccOJFpc94Jyv2ErknaEzOjsW/+RhsSmM8TTP3jaavw+?=
 =?us-ascii?Q?q73BSbJq+MWIBeqC9L/7VJNYl4atg4C4cMjNamWBcFluUhc0GIsK/2wuLdW8?=
 =?us-ascii?Q?Rylvwu69kiF2HKddTP5Y77xNAtEpQQUKLy3i+ghnavBhdza1U0uskjZWxp9W?=
 =?us-ascii?Q?eNiBlRDZ4Fe140x5VUoxpi0duJ4r94T2x7muQzIW6ogjPXRtjFZ5sHL3oROb?=
 =?us-ascii?Q?brYtu5yFvmYsU+Fx8PWAli2R4+uLcYDCxtPPsa9f72xTNn3WPWebhjx9YAaI?=
 =?us-ascii?Q?0lFAuL2jgBdZRry6P3qnnZSbdB/gQEgWjcZ8rf9maEsQw/ZPVLc6t0n9BlBb?=
 =?us-ascii?Q?dQf47KtfcZvukJsqOezWG+fRvkDHD33BJIfQhTAwzsA5D1aBjhqNh2R5HGou?=
 =?us-ascii?Q?AseDAQr/hSqSg7yh4+NzxLKycobCPkiYGi39vB4K8nyzjmZnKx2TXYS5W67p?=
 =?us-ascii?Q?14TrOeYrq2re0ND/ygZvfckFgOzn7TQvVjJj5O9dX7vEExPr+4Rme+mOp+v6?=
 =?us-ascii?Q?73ch6I3L2KgfZagubYRNKg8o9/0gJHzmkxdlUs4XKrB2BqLGqfYj+qLsTpqa?=
 =?us-ascii?Q?pJl/ywZJzdjZio0hVx6SwAWLZRC+KJG8w5dL9/+CgAnD57hBzBiPu6cpwYn2?=
 =?us-ascii?Q?NB0vUNkdOluqcbMLWsDzl9WiHVINhP7LZFQjSTzW4F/QrGczZAjiqLb54AOp?=
 =?us-ascii?Q?+WysKVOZUyjKcZWJgxN+sR/L+qaWJvEhrPIjBzCuT0Ozf/HCS9k6IM0rSURI?=
 =?us-ascii?Q?ZQF/4qswGsyFll+rsdQRJxAK+VKM2gfI7F2reYzZHEY823C7TwxU3qx70qNS?=
 =?us-ascii?Q?sO6aZSbf6TkF//aCARYRCdtycHzhREHl14Q8ZMwHqG7znJc0Sw9NLNJ2mIRx?=
 =?us-ascii?Q?dK0JfXFUzqSdymKrVTiJL+u9PP+ZmQ38IgNL/wwSSH/5IbPUNHDQyiFonySH?=
 =?us-ascii?Q?bkmDyooWqlPcrY9vXt2Jqf6TH90eVhFJ7qRhl+GKIU0fqGojMrhxgWwW6y78?=
 =?us-ascii?Q?re9Wi5WET/iOKsUvH2AhfGYLW/PdNLEh08rDZpaz6YgfVsLaC34z2/5MFuU3?=
 =?us-ascii?Q?rQ8TwbPvyTqbu3bzewmtiSwayosS5V8MNC3KMzG9km2F6xdyNOi8IFRkM0HL?=
 =?us-ascii?Q?utbiExtEw0je3VXzfi8mEgmAc7yciisJxXo+os7sSudulL1uCFI9686sc98l?=
 =?us-ascii?Q?akJaYlqvqqXIo3uQyN1aTrXJerGHxIj4imzkA05355CbyVO0DYnsZhtbQNVW?=
 =?us-ascii?Q?YHo2StF4o7jSFwHvUINIfT5CecsfjlpjvOu8u1dOEpcGAeZklhmBZMJCAAyR?=
 =?us-ascii?Q?mfpF0sVhV3xKehPorV30YuWfC2fRXE/nAL9vxuAVHIRzrCUtxxa6cXh3oxnb?=
 =?us-ascii?Q?Tx2VmzP8DmYG+Beut1u2j14mkL6VVgMiFCgZ8LYxETMMao+YyBU1M/94Fbze?=
 =?us-ascii?Q?mgBuZCK134gZsxKyMW1SLHU54uOojcFKX4zCtm4CwKI6t9tN/NZTNX0vGe69?=
 =?us-ascii?Q?tF/pISmorXHd+M36BP5tcNLBsInHYfMHeNHukj7XR4RUvVdlIGpVzGSAVEYI?=
 =?us-ascii?Q?GAfsgTU6QCrm77kNwuFCl21cTmWXv5ZQ0sTtOqItZAmRkPeeAVgrzluwsVmk?=
 =?us-ascii?Q?GhevvTJ8Qlm9qcUcFyBt26r79c0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad652e27-55d4-4bc4-4d08-08d9d0ae261d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:43.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+jxUHgqaT7jdYwGx3mF7J+IQXMEvIiEqkjc5gMgBjFeDlfK3CfV5LXSZFckRhuRbc4zYWA0+EXm5iwCA/cUC1WGEPG8EZiS4S2a9C3Z2Uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=909 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: 5n4C1OmqtK9TRM25e9I_Ma2_AhvvRb2A
X-Proofpoint-GUID: 5n4C1OmqtK9TRM25e9I_Ma2_AhvvRb2A
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

padata can start num_possible_cpus() helpers, but this is too many
considering that every job's main thread participates and there may
be fewer online than possible CPUs.

Limit overall concurrency, including main thread(s), to
num_online_cpus() with the padata_works_inuse counter to prevent
CPU-intensive threads flooding the system in case of concurrent jobs.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 0f4002ed1518..e27988d3e9ed 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -50,6 +50,7 @@ struct padata_work {
 
 static DEFINE_SPINLOCK(padata_works_lock);
 static struct padata_work *padata_works;
+static unsigned int padata_works_inuse;
 static LIST_HEAD(padata_free_works);
 
 struct padata_mt_job_state {
@@ -98,11 +99,16 @@ static struct padata_work *padata_work_alloc(void)
 
 	lockdep_assert_held(&padata_works_lock);
 
-	if (list_empty(&padata_free_works))
-		return NULL;	/* No more work items allowed to be queued. */
+	/* Are more work items allowed to be queued? */
+	if (padata_works_inuse >= num_online_cpus())
+		return NULL;
+
+	if (WARN_ON_ONCE(list_empty(&padata_free_works)))
+		return NULL;
 
 	pw = list_first_entry(&padata_free_works, struct padata_work, pw_list);
 	list_del(&pw->pw_list);
+	++padata_works_inuse;
 	return pw;
 }
 
@@ -111,7 +117,11 @@ static int padata_work_alloc_mt(int nworks, struct list_head *head)
 	int i;
 
 	spin_lock(&padata_works_lock);
-	/* Start at 1 because the current task participates in the job. */
+	/*
+	 * Increment inuse and start iterating at 1 to account for the main
+	 * thread participating in the job with its stack-allocated work.
+	 */
+	++padata_works_inuse;
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
 
@@ -128,20 +138,22 @@ static void padata_work_free(struct padata_work *pw)
 {
 	lockdep_assert_held(&padata_works_lock);
 	list_add(&pw->pw_list, &padata_free_works);
+	WARN_ON_ONCE(!padata_works_inuse);
+	--padata_works_inuse;
 }
 
 static void padata_works_free(struct list_head *works)
 {
 	struct padata_work *cur, *next;
 
-	if (list_empty(works))
-		return;
-
 	spin_lock(&padata_works_lock);
 	list_for_each_entry_safe(cur, next, works, pw_list) {
 		list_del(&cur->pw_list);
 		padata_work_free(cur);
 	}
+	/* To account for the main thread finishing its part of the job. */
+	WARN_ON_ONCE(!padata_works_inuse);
+	--padata_works_inuse;
 	spin_unlock(&padata_works_lock);
 }
 
-- 
2.34.1

