Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8084485D9F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiAFAvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:51:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50354 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344247AbiAFAtI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:49:08 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4xqd009805;
        Thu, 6 Jan 2022 00:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=GAQtMAtI1qSIfyiVsWQOnUMKJ2+/nWAKrAgV1ZFDKao=;
 b=FIZbAa+kXXumEMDn9H0J0JgVS5FzFjBQxpzZ82d+vmX6quQzqOcMJgo5rqSNbVULydm1
 MBJZ0UVuVP19DD9g+w8XkpMih/3WIoBDfOLynD/dwvNgsut6rmBfSA+HsKdw1EvylpMb
 uj75mM+aubNRDSSTCnbipFV/iqQ6R89YuRF/ovgRfQ1ZQA3x1JmXy/PDNy2toJUChV2a
 w1+02IQX6M8y2cv/nq7XiLehAnanugNqOYp49x/xMW4RGnmP0AyMKKFZLKAghp6+BSDP
 3XgCmTqt1SEAXFjhksCCPihcjgZmC6w5iGxtbDWOIYkd/+jSiA14vt8j6ujYXUDsRlJC XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp83u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VnTD086823;
        Thu, 6 Jan 2022 00:47:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by userp3030.oracle.com with ESMTP id 3ddmqbvt3x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfqYuqu5Sg3KmUaxNjFwcvX2v//dtWuUG/ndgKi/XIikSLvUjCEPFwMQbgEKjQY1k17jhKLT7lwrlU8JDrBpAunWLsZafOXic5Ogl+Y63UpOchdM9/GzbcPdu/NVkJZU1DHbg9iJG3Ow3eYz75wOCU07LM2mKuW8H1ME6Vfr7eHVjzgF3rU1S2C8KRAdHEq6PRGjMvrjiMhRIF53/brx6sd6D+QhzItYg8jznX1v3eKS6tgM9mv3oXMnDQTUqksxxQfM8X+6EvS8IQ7Twl61fwOAHHjekMJSx6xnBMd2qqF8lmLV3mXcxSviD9k7Ef/gTFQ5QbWRCQ7inxUScHdCfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAQtMAtI1qSIfyiVsWQOnUMKJ2+/nWAKrAgV1ZFDKao=;
 b=lPXcrFTWBAbh8i5oPRcicTppO1EgKcaBpIxVSjz12JGf9CPTz6X6YW6xZAuUY1wfWXFRkpgpHLMoXPtEocfQKlKMB8DxbJBQss+QW57qWl2lBEyrpOYEptepKlYLNDZvBJoYcUV8kniHenXZBI+Rh5MqLvxPoCiCVEgu2LUwKJqYXzrm3sjWhr234LdL5IlmPiQW4eL3kQPQp7fCwiIudi5AMES/0XFDmdhFed8d/gwX37hpzE3ei60f/EMlzNgYgC5GC8DPF4fmTalXZs76U/TxISPjIXxcsCrHh9DU+tfaeilEo0G2rFzar8PvVaS8or2iaZK4UweReTNNNUTFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAQtMAtI1qSIfyiVsWQOnUMKJ2+/nWAKrAgV1ZFDKao=;
 b=VZsKU+E26yavrNrNJc/Pbnzd1SAPNvKppp6IiOrnQVePA9EhrYMqfZzcu9fEjWlTVrrHeOBRHGO/SU7F42XJbGtXv0lcPeKhdEFf9D8bDMNzO1i+BuXxXf2XJ+qHp+XB6yUwa8TsCSvhXAdC2J0T9a7XZE8QV53nvwUcJr6Fbpc=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:38 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:38 +0000
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
Subject: [RFC 09/16] padata: Use kthreads in do_multithreaded
Date:   Wed,  5 Jan 2022 19:46:49 -0500
Message-Id: <20220106004656.126790-10-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2ec127d2-81f6-444d-be20-08d9d0ae22e5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44223E4D16132324806C54EAD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6C1bhAQf3F0r7/SU6i/etFINJl39M2Y9Z+uyeO7pDLNKIV36U8UiI5ViYU7aOo1vc9foGQlBb1yfhBGV2Ce2Ya6bVQui1+sLQS2decD4FM08frei391RYe07FScBnbzO847jgCJ36AmrmGIhoL7V7Xbw91gU9ej6AqfLbDawQBiPMANeWuus4AuWbqH2MdHKW7upM+UsJHBShaXG+bvtqj3xRRmJ+c7usOpnbgq2hZ2zf7ZC4tISg2vaua44gsyUgb9w523gB7YWHWDML6KPLkfeo83jBMfoyEQRIEENhPnkWTKZRbtBosICcssVtSRGPuRiiahjYMYSxMK25aEN7Baq8b3lGNYl58I/am6w++apxurQ+Dq1wO278gEhyCkYeBf1nKPkbHxpGl7ZXX2rd48aMnjCgBCiCu8zwfLNdJgtdl3sMsn4D4ZLpDaGWyv9R8GE2VJn+mok+hKrRrqtGUK0Vn6ozF4cYRGGApa/6vn/6rg3RZdcWseLG2t2N/hMaClw0zIWWbMIWPUNMHQ9i5HDAj7j0OZbeW1iAjS8bwd6MKKNPq5XK6wmz10nLP264Cj+vp+pHjXMsUhaduIeESQTGZCN00C82PPjyO2WKpW5OHNnag/mXyy37hfsPGEsdFT5/2pgrCfYTLjwpKhoD2sVa9IRoAzVfUwNyQwI3gX58JHotJrkXZnAhNruw5zuTcJYif2Mu0+WdVcbbT72y7c8/LgzKkusZqlMJGpuZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3cc6P8bzIKXJ776dvZXiIte/+nGK2kDoWQmIeFRneDGEAWd+NsIv3m4JVqpp?=
 =?us-ascii?Q?fDlGNYQKAAAjemhhCWPvt1msidKPLYYG5JOoclEc1CytFXKBSDbCVMD9jW85?=
 =?us-ascii?Q?DZM/ZTFr1enPK7o+DKPj4auNYeJtUcFTxnHqLLiisDS0LQo64aGUsB9KNSyU?=
 =?us-ascii?Q?vP7Q4Tq+X7dv041WGSmDpBvzTdedUXJs/cO162RwA+10B+pD9DG5F2TAC+fG?=
 =?us-ascii?Q?58ohvhPf1wDDZsClJT6igolE5GU625E6+dafwBH798sSLIc81rqqRDPg8RJn?=
 =?us-ascii?Q?vquf7/lijB1g+3yu3ea8w5lamEXcYc60rBqYBTCo5xtHO7b3QvHxJ2JwSUtV?=
 =?us-ascii?Q?4SY3wP3taZQoYH84O2oiZg2NDXROkb7JJaywFZVkD2TnjEXPc6nNm8A9oHKg?=
 =?us-ascii?Q?45YdSoFnnfv6pRR/GAE49bsV6k/wqD7fFaKKvfAd6TpKdmVnDoqo4j3a9qjz?=
 =?us-ascii?Q?RoW9ie5jHdtGqu+LsacC5Q040MFzt6odeR78bFuIncOR2ve6hyWqoygxSs76?=
 =?us-ascii?Q?C19WBKoUBrMUsiL4kkFcE5klvruqAnB7UAw5i78dYaCZH1Fa4MZbXo9r94Sa?=
 =?us-ascii?Q?JH1wTjH2ZztLKbjIbD9gw7MvIX8IHBdwuXwBEeF2qoKJL7J10HLmzjsotSb2?=
 =?us-ascii?Q?QT21xSA+YtVeTv6nsQJnq1gtIFRRUQqibyy9ygM4gh5V/lIFKfmyT8GG/pTl?=
 =?us-ascii?Q?br1f6hB2lO7NUitoi3nYh3R3n2OvCWxBno+OXNmhLm1KLQe4QYKadXy+rkEO?=
 =?us-ascii?Q?5d/sYEYP71YIu/9t6lUxoQYutt3dqn+jloyzHjGDfWPafRmQA6JL62hbXmgQ?=
 =?us-ascii?Q?puAKoLAcP9H14cT7zl6wEesY6v6FQs+RVcCmlGHuVnTArteQwG8bcIWtSzln?=
 =?us-ascii?Q?90AfWP0f04To+SBcOnTJmbUMXESbAgv5HXG9rbU3g4OtNuTQ5VDVWDMaD07Z?=
 =?us-ascii?Q?65OG0JBpsVdiLbj42rL0vwa3wHU2beBT1kqElrWCmuM8E9bBls+Q6jwxAMmv?=
 =?us-ascii?Q?FsqU7jho84eKBTErqq4FQ0IYJ9/3nF1djP0QVfUsAbQ8SLaNKb8tYhmH84x+?=
 =?us-ascii?Q?pSoPBA3oyWdmLH5CFJS6aPdkRn1qM4QP7WAag1bEIIL2ZZU925hIeYbB0Nxu?=
 =?us-ascii?Q?ZCdIFIqd5eWOGwURLi1M2cw/OgUAFXL1I0iINSYgoiIQyBVAWXHB/4J2jsRx?=
 =?us-ascii?Q?S0BddPtMGw5hVPXbWzsiFqgLTqsWqnTEAIO55Lbz03hnmtYGSOB5IRYHZTe5?=
 =?us-ascii?Q?WsLDT4j5BF1hqnrmENipDkOsy+aZvRXvt05Nrom/hsi0MD0xmssQtVoLaato?=
 =?us-ascii?Q?3FDxZoBQHZLjX7v9wPFhNa0IMKedN9fbqm4rHcmZUrQBXDklDy0yY+t/eDaZ?=
 =?us-ascii?Q?+ryqkHdWnTqB5bNd7i8OS8ejNioCz77SpAkUBKYTGC+QlTnqqOPrEC+XtfPv?=
 =?us-ascii?Q?3fhqcFdnCYhRBHcpjqt4AVbQpSKj5ZQjVwC6rfuUa4ixcLPpt22OOQ+FDDwY?=
 =?us-ascii?Q?1/xjxCTknFBx8ErGfLhKLq1dRBNoWucFhLXVQeYoDGnbdKvbj/6y14TTnf9Y?=
 =?us-ascii?Q?WshF74Lttl/xwAFUGgtbeyi4vYX+nZpR4TBGVfDrHIDUe8pZp8XZbrQ5rHiP?=
 =?us-ascii?Q?MfpVwkCqSoYeUI9DsqB1zF8dz5RbK6tvDtRprCkY8qqMqNiyoMGogKeeJOby?=
 =?us-ascii?Q?uEfWnB2c/VjxJD62shlK8s3V344=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec127d2-81f6-444d-be20-08d9d0ae22e5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:37.9587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uuyvnuuphMJMrFj9O5WmV1dqNPj4teqeIW4hOSfnHQa3uEYGM5BwirACUnD3THYK3DdJs3fRHiyFjzeCjxuumcUiriI7xfivbFvQshh54g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: Gg9wq4R0jhnrPL-28Hs0olXvb0H3RzcU
X-Proofpoint-GUID: Gg9wq4R0jhnrPL-28Hs0olXvb0H3RzcU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unbound kworkers will soon not be ideal for multithreaded jobs because
helpers will inherit the resource controls of the main thread, but
changing these controls (e.g. CPU affinity) might conflict with those
that kworkers already have in place.  While the changes are only
temporary, it seems like a layering violation to mess with kworkers this
way, and undoing the settings might fail or add latency for future
works.

Use kthreads instead, which have none of these issues.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index b458deb17121..00509c83e356 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -29,6 +29,7 @@
 #include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
+#include <linux/kthread.h>
 #include <linux/list_sort.h>
 #include <linux/padata.h>
 #include <linux/mutex.h>
@@ -37,8 +38,6 @@
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
 
-#define	PADATA_WORK_ONSTACK	1	/* Work's memory is on stack */
-
 struct padata_work {
 	struct work_struct	pw_work;
 	struct list_head	pw_list;  /* padata_free_works linkage */
@@ -70,7 +69,6 @@ struct padata_mt_job_state {
 };
 
 static void padata_free_pd(struct parallel_data *pd);
-static void padata_mt_helper(struct work_struct *work);
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
@@ -108,17 +106,7 @@ static struct padata_work *padata_work_alloc(void)
 	return pw;
 }
 
-static void padata_work_init(struct padata_work *pw, work_func_t work_fn,
-			     void *data, int flags)
-{
-	if (flags & PADATA_WORK_ONSTACK)
-		INIT_WORK_ONSTACK(&pw->pw_work, work_fn);
-	else
-		INIT_WORK(&pw->pw_work, work_fn);
-	pw->pw_data = data;
-}
-
-static int padata_work_alloc_mt(int nworks, void *data, struct list_head *head)
+static int padata_work_alloc_mt(int nworks, struct list_head *head)
 {
 	int i;
 
@@ -129,7 +117,6 @@ static int padata_work_alloc_mt(int nworks, void *data, struct list_head *head)
 
 		if (!pw)
 			break;
-		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
 	spin_unlock(&padata_works_lock);
@@ -234,7 +221,8 @@ int padata_do_parallel(struct padata_shell *ps,
 	rcu_read_unlock_bh();
 
 	if (pw) {
-		padata_work_init(pw, padata_parallel_worker, padata, 0);
+		INIT_WORK(&pw->pw_work, padata_parallel_worker);
+		pw->pw_data = padata;
 		queue_work(pinst->parallel_wq, &pw->pw_work);
 	} else {
 		/* Maximum works limit exceeded, run in the current task. */
@@ -449,9 +437,9 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
 	return err;
 }
 
-static void padata_mt_helper(struct work_struct *w)
+static int padata_mt_helper(void *__pw)
 {
-	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
+	struct padata_work *pw = __pw;
 	struct padata_mt_job_state *ps = pw->pw_data;
 	struct padata_mt_job *job = ps->job;
 	bool done;
@@ -500,6 +488,8 @@ static void padata_mt_helper(struct work_struct *w)
 
 	if (done)
 		complete(&ps->completion);
+
+	return 0;
 }
 
 static int padata_error_cmp(void *unused, const struct list_head *a,
@@ -593,7 +583,7 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	lockdep_init_map(&ps.lockdep_map, map_name, key, 0);
 	INIT_LIST_HEAD(&ps.failed_works);
 	ps.job		  = job;
-	ps.nworks	  = padata_work_alloc_mt(nworks, &ps, &works);
+	ps.nworks	  = padata_work_alloc_mt(nworks, &works);
 	ps.nworks_fini	  = 0;
 	ps.error	  = 0;
 	ps.position	  = job->start;
@@ -612,13 +602,21 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	lock_map_acquire(&ps.lockdep_map);
 	lock_map_release(&ps.lockdep_map);
 
-	list_for_each_entry(pw, &works, pw_list)
-		queue_work(system_unbound_wq, &pw->pw_work);
+	list_for_each_entry(pw, &works, pw_list) {
+		struct task_struct *task;
+
+		pw->pw_data = &ps;
+		task = kthread_create(padata_mt_helper, pw, "padata");
+		if (IS_ERR(task))
+			--ps.nworks;
+		else
+			wake_up_process(task);
+	}
 
-	/* Use the current thread, which saves starting a workqueue worker. */
-	padata_work_init(&my_work, padata_mt_helper, &ps, PADATA_WORK_ONSTACK);
+	/* Use the current task, which saves starting a kthread. */
+	my_work.pw_data = &ps;
 	INIT_LIST_HEAD(&my_work.pw_list);
-	padata_mt_helper(&my_work.pw_work);
+	padata_mt_helper(&my_work);
 
 	/* Wait for all the helpers to finish. */
 	wait_for_completion(&ps.completion);
@@ -626,7 +624,6 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	if (ps.error && job->undo_fn)
 		padata_undo(&ps, &works, &my_work);
 
-	destroy_work_on_stack(&my_work.pw_work);
 	padata_works_free(&works);
 	return ps.error;
 }
-- 
2.34.1

