Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA6485D77
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbiAFAsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:00 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16552 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232729AbiAFArz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:47:55 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4QfO011262;
        Thu, 6 Jan 2022 00:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WAtN67KHK0wTvC6vTxsC/598Mppie6gA5gLpr72IscY=;
 b=natvdBGQcoFsDKKM4NoKPw4X0kDh53F4S1dp3afIlgOIgSczm1aQr6ux6YXWm/HS/3+/
 4uzo7auznx+TRKi03yStdCN/xcGmFzD8q1bW7CdFpPBLyMY0a9+CWSMj4c+VSeiatuuo
 AvdGUpc5EI5o9eYpM8L6XnCdPpaTayn/uitzAlH0M6M0YteEkdctrk+2wBsLaH4mdPRI
 IXU7aQjBDFk2YXXLbULmEop9rwlAL4As2m5Wy6VVeEl7jqFJlP8wBNI72wmac3D2kODM
 P7r7G+SiQN3aFwYb4PwZ+P9+kh41lmZM15ru7Mnz+f6bRnPh3PKgAITELvc+XKde7Oe+ pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpdg43k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VfVe076226;
        Thu, 6 Jan 2022 00:47:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3d01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fut4/lLyjhBoaSz0VvwngQ5PCOAQNH8KiENTjsGaeYV4Zq/VCX+kh7Fbs2HhtXwX1jaIzgaib2NcTaxzToE8wzk5LIaed8AJKtG25TZpzq4P0CfXErye9eh88o4paGv7R1rl5Q8RPcpVB1+kOjmfhWlJ/y5HOggiIhQlhWHE98lji4O7ewbycZl9n0erSvx73WacB92Wsok/I47PP8sf/93ptCeO9o4+6QnhRiyqRdOYvi8BrhdvgpGuwu5x/rtjCh5TVMoTdkZ9m8WoLIblyjiMmbaIh3tJ3DAeGv20P7WPUCAr5P87Hw9w4RISdU70VayZEcaMqHYZCRzNxr7Uqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAtN67KHK0wTvC6vTxsC/598Mppie6gA5gLpr72IscY=;
 b=U2AJRqj0hTQ12WffDjAVSsHQaXlPo58AZuwtbLnzHny3HTU/3Icy5y5LQtV1PtRkjnrkvUH8YNwWPokCzOaDscRoBmR4sc9xzw12Wo8Ll+h7Qrl5+nbk0okzZQDXoGL6yr1/zbgAUQWyzc2ZMWnZgecSMKXeaWB8DB5QAYVa2t/AdYOYvmrs9iRZvskvtMu4fBU6vkKbgU6pruQ8M6npjUQHdNK84ILh6h7n1ZGTWywKRnK/R9dECGK10jimZHG9D1n5eqXM4fuK/WLZrOtgBupGQomNMcqdQJDr0HHfmSOHNkrEr68wDEva37QKgoynzqvmNmgxXohEkyVW0ZXo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAtN67KHK0wTvC6vTxsC/598Mppie6gA5gLpr72IscY=;
 b=wCLrvilXDfwtkT5Zq6FT9eQGxRHP+kzpvVdWhEJa616apwFAUaw0jcSQYf2+DhJlSwiI6eVAJa+JRrX6X82vYhM2iIu3lr7vI7kmuYKKek3m+uBNE0Fv8TyRxPauWZj4c8djFkwkFItQrC7zY9mNA4bPReV7/wrmxHtS8Evl5So=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:16 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:16 +0000
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
Subject: [RFC 01/16] padata: Remove __init from multithreading functions
Date:   Wed,  5 Jan 2022 19:46:41 -0500
Message-Id: <20220106004656.126790-2-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 05c48c74-9a94-46a5-ecda-08d9d0ae15f8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422908D27E25E6758A16151D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /MdqR1nW8oGOJRWkL07QKJWzVETsZrbHQlMEKoSp8cPEWmrDBhiTivpIa8RVu0lWZTweb/O2JzEaoZfggDzrQX+lQ05IZPHeFZQxgGtrpqL/GW5Z1mHHbr8btwtQaDN6ye8gG/BzNH4oEs61vIWfC1gbcbuZBSFC5UlTjB+cQyRyX1+1aBcIx3ryOucdQtqCJXSY6qtRqRlfn4xk6swc0pVZttfkGM4E0+esNPfmZG8WrIAlDvFm3XBAK6CA8FvohZ/WmgMuC51A5QIyy0dnB7rlfHBhZZUB7hW6M6cuiiSXu+RpEzx6ewT/akn+c7GKo/rnhfw99p1xJnGUTeAt9Q2l70+kHJZ4BJFCeZ2s+WWfs5rWRPd1qmuG95thSpHh/itBgK1l+GNQMk8hvKZKIs6Zhu4zxXXLSMpR4GRIgIbta8SVxVP9lIieky1oAeSYaMUnQrMzjHFUcomvf2MVqsKmXzw0Zh70bPClmyvIQdJNo0U338Jgdefsemys3Kbs1QKpnVTeVHB0SSUgw7NzEOPotcCo+ydvF7q9oPl6zdgu8zB5KFVZA/2dcA06h+JaPwe+fybaZkmOkd0cTz1qcmazTQx8cZJab0/rk8KzIVD2Y07m8D6CF3g4lxfwyiMuLU2tWF1KrQl3a5fYFk14+uh408qScPCH1fECf79KMtQc5CaSk94Ji5MVVD6GhF84q8EKxBhafl5iusGR42oHuf9I3dLZCfbCOsIKE9L53Tk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C17whqtZAPMPuGXlrcMJWk+Do/nK6i7mWhzVFi/v/QhNy/ZfmVd3mgaICJIf?=
 =?us-ascii?Q?vrZHlU/qPpLGHH8usUWCzvnbfjYTFd75cDGqCuEOUFg7CaKXfy1hSt8GREK5?=
 =?us-ascii?Q?bzX41MHm103IrDllVbE3IwvH4xffKeSU+TQ9hNnZKQlHb0yM6ctvbrdMlWwa?=
 =?us-ascii?Q?Pb8Iqp+Og9h+jDohwUsusyqeG9LHgu+f4shXT2PsSkHuOZRYktvUg1wLsPvj?=
 =?us-ascii?Q?psQDtMrI1FTxPQVPEbPTsKz3+VxW2+VkCBfXJSpto8zCdErAlrosfXnDOnOI?=
 =?us-ascii?Q?PBbQxAgzTR7+EWGezPlkTfxQxVDNAXu4UTQIYERPO9RbtqtH7KgIzavysGXX?=
 =?us-ascii?Q?9HWKZhZwSBPmA1ECkeTKF9HoOfuYH0El25GaU87bn84r8/qIIT3Bhvb6hG/r?=
 =?us-ascii?Q?pwIvHA+y0pHG6QJ27/mTncKC/UkSJFy3C9R71DVhpLPaXJtG9HnwpIaRCHsh?=
 =?us-ascii?Q?Y8Mp2Z/mcqm5HHY3o38v++fKLfZaWuEPZgW9s8BT97Sme/qUVxfjSmpvgE9L?=
 =?us-ascii?Q?XHp9XKD/s0YA9tmj6VoPX4knZ9AcnE1x3sy143vrsKKvqjWi86FsfpTfkqxi?=
 =?us-ascii?Q?lmYlYaG0wYSOomKOX8XgFCzN2T6Lyz/hW6aZnoD62pxXeepBPk8QX6dAdfKE?=
 =?us-ascii?Q?TP3QWN/O4FGxVNtfv4/APXs02Se2hvq7EuWHNL6dfbb/AuaZIjQRRhuzlGE1?=
 =?us-ascii?Q?xDIvjqFmc0fbFaHTCczuXbsZ8eRGkZnnlWO9PIoWbG0e98wtpSrMcmAUgNmN?=
 =?us-ascii?Q?Zo4SGsBoKD8HiqXU8aJ9XV56i/Wp9H7jVG3dekqujJkYh4W9SwXe8/7DeU4o?=
 =?us-ascii?Q?4vRV40roRWF5rJ08FrVc1IMKm9z0rFq3J6WwM6bZwpzJf9tmItZjA+oJfNEO?=
 =?us-ascii?Q?j2WIZEeMd6V5hsy2vStSFXeP9Ucw5IqR5MZcHGwU22zaaCA+btlHdcY/77/5?=
 =?us-ascii?Q?VcTgdFaoOkshGtxLwUpNpx86wCJZhs+BwbScP6R7JSIHKbfJfp9TfPiEzn9P?=
 =?us-ascii?Q?1Q6eRd8URtVNH/pvqafwmMn6nZ/l4hZoan85mzCmOmfA3P195qKPy5oyOsHF?=
 =?us-ascii?Q?insdyghTVZZhfnQIGVXpJrRQADth3VreR4nI/8CmwhVWqv/uAlcjxxLXZ6f8?=
 =?us-ascii?Q?+MhLB9D2Og6cubLE94bHmDtL3ZrYnKyYP93e8u9S5pU2PsKoh04kHAckbE6g?=
 =?us-ascii?Q?ESyUrJ5e9MkuNukf6u6rqcJNudue04pJsUkuhrloUKMhSraZbIHEyGuHo/xg?=
 =?us-ascii?Q?G0ygL0jBIneE5YX16yeuDVauQB/ggCpIgEA6gwSt/TAbkGMAVAeHsaRfpyYX?=
 =?us-ascii?Q?Zo8shWBa2qmFnjXu4W2OBZzOGjaMg0wfeIIZqky9mHABTD4A1J561ZDs1N3q?=
 =?us-ascii?Q?EK/8VhZhO8r54TK1MQSqH8t+gnZZUTfdB94LV3VIVUmoMiNTSFKIPRdV3Nj2?=
 =?us-ascii?Q?OWK4sfNZGXNp1tOJYhDMlzeZ4z1MUI1FL+WKYyhFci2HmkXW4LHqwvLlAmxo?=
 =?us-ascii?Q?h1SCPUWlhASUesibGPuhD+b91VAUrYRe6wSZi+dKEcG/iArCYVLfhUgQUmNK?=
 =?us-ascii?Q?CfAUyl0V6X23Wzwr4SC38k6kOEIquBBx2aV9YkCAZP3K3lRLs1OuYe95Wccg?=
 =?us-ascii?Q?5RSm876Prjtfh9GlxzTe4OMOcBGo+wf+eq7P45Zz0WpDR78rpUhwF0JTef3S?=
 =?us-ascii?Q?Cw4FTiUJsIiln7ehOBxrRiAKanw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c48c74-9a94-46a5-ecda-08d9d0ae15f8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:16.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2N9984L1X1glfZky+EAXdUNq2vMDgNbCfn0L6YgQSlM/ALCievElU6AeIPGBP41SbKGajWXElBogw7aQxQi0nbl+UfVKyPW4rZyB6+hS8/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=566 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: kewc-Tu24IOzPSRNed-rRCQ9TqQLf7c6
X-Proofpoint-GUID: kewc-Tu24IOzPSRNed-rRCQ9TqQLf7c6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A non-__init caller will need them soon.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h |  2 +-
 kernel/padata.c        | 11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index a433f13fc4bf..0dc031d54742 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -188,7 +188,7 @@ extern void padata_free_shell(struct padata_shell *ps);
 extern int padata_do_parallel(struct padata_shell *ps,
 			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern void __init padata_do_multithreaded(struct padata_mt_job *job);
+extern void padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index d4d3ba6e1728..5d13920d2a12 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -58,7 +58,7 @@ struct padata_mt_job_state {
 };
 
 static void padata_free_pd(struct parallel_data *pd);
-static void __init padata_mt_helper(struct work_struct *work);
+static void padata_mt_helper(struct work_struct *work);
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
@@ -106,8 +106,7 @@ static void padata_work_init(struct padata_work *pw, work_func_t work_fn,
 	pw->pw_data = data;
 }
 
-static int __init padata_work_alloc_mt(int nworks, void *data,
-				       struct list_head *head)
+static int padata_work_alloc_mt(int nworks, void *data, struct list_head *head)
 {
 	int i;
 
@@ -132,7 +131,7 @@ static void padata_work_free(struct padata_work *pw)
 	list_add(&pw->pw_list, &padata_free_works);
 }
 
-static void __init padata_works_free(struct list_head *works)
+static void padata_works_free(struct list_head *works)
 {
 	struct padata_work *cur, *next;
 
@@ -438,7 +437,7 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
 	return err;
 }
 
-static void __init padata_mt_helper(struct work_struct *w)
+static void padata_mt_helper(struct work_struct *w)
 {
 	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
 	struct padata_mt_job_state *ps = pw->pw_data;
@@ -478,7 +477,7 @@ static void __init padata_mt_helper(struct work_struct *w)
  *
  * See the definition of struct padata_mt_job for more details.
  */
-void __init padata_do_multithreaded(struct padata_mt_job *job)
+void padata_do_multithreaded(struct padata_mt_job *job)
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
-- 
2.34.1

