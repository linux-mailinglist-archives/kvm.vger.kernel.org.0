Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A030485D7D
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbiAFAsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20618 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343955AbiAFAr7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:47:59 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4TM5023248;
        Thu, 6 Jan 2022 00:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=4h9fxZQjoge9zoEz5uRD/jyfg0rfEsOFpuVpN34IFis=;
 b=MU68LcvTccjVYNTtRXvU2vTAXEYW+GEWznU0SfO1UKDYorpzR26aQv9uh/9TmuaTKw2n
 MN8gmiACR3Xh/w/2OiqVpIk/RgXw+q5/ZLmjzflXtUaGYb+OGdbI00/UOiP8frpgOKUq
 zMdJUmYwAVIovFiu36Ws9+JBaqyc/vS8zz+36/20C2E6P/HDwXFYvn52PKC/LgH+i9Ua
 k7hic7GhT7h2I9DICf/Qn1je58Y06eyWBNJKkLoDmAlO5q1xWUfbT5hwgV4xo1qNnk5x
 9ZM/V6gEa3xd1iXU+44t6TtD7tCeNBNG+YGRp1V3smzdzin+ln7Gi3JfaTxDwJUBG+S7 Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpeg421-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VIsZ107309;
        Thu, 6 Jan 2022 00:47:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3020.oracle.com with ESMTP id 3ddmq5uwk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ras/B4sEn1e609S5NQVAYJwtO1VGIS4SJj4DYQQ9kINQmMjUGzt3/BMRz75keSCTWDmN672Dr6fRXnMtd58dB2DJ5eDIE/RCKnXWiiEEeoFoWH2Sl7ZAgVWAlvsxS7B6EruY/cPZ2YNJcZpcjJMSSkTmjweVvf+zXZZF4W6Kxeg1Mhqg7jRySj56tEfVDv3dTyBMz/fTWBcTu/YTPWUM2hkgsFPYMMonSHCaHYcVUfJM/dXxUR7iuQzOQsamXxr5Eu6aX4HIX/LFV+83WZAAVgzxsg/HeQKXkk3PQQvQS74L694Y12BRx86NIICejOPYoJs7FudvF0Y+hID2GhFELw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4h9fxZQjoge9zoEz5uRD/jyfg0rfEsOFpuVpN34IFis=;
 b=Cq/GtN7QeJsE2GLGtb7ku2aNb2j8nCvGbYClXjyZdg3XBYeYnE227y7o6PpZMczoquQWygJiQIbuM+RExZ1CbU6aNpzYLdSOAI+scw8CWrLdpSHTMbzPy5oZuZDsmYGsTgx4kHe1r8YCdZfAWTgchyZJ12SCLxQq0sFH2S6XIOcyYeTfid5BVvtM0h5gaiNFV026iGhVkAZYeUJaL25iagFhrwzz7fO6SaPhMp4JXyKCUafG1VvKMYomU31gdifFtSVXfDnNrZ19vgPiy/dEvKwBSDunKSsKL3hbslWf3YcVgr2gXe/Qa/qmYKCEZgeOsWBDF/RyuJ1sIpTQd+zZSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h9fxZQjoge9zoEz5uRD/jyfg0rfEsOFpuVpN34IFis=;
 b=Zb77Ind/eqFI9u6gz9jzqxYNngiT2589S7qO/PyEelfyOtJOXxoilgDe/XSYscpPXRO2oyzr5FW/nk0MpQqQGoIR3L2DHeJG7lNdsWOXBCzFFtpR9prK3CMBIFKXJB1UjipsrqZTH+LWfxxKg6tqrlrY/NgN7sx4Hh50r+A/uyg=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:24 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:24 +0000
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
Subject: [RFC 04/16] padata: Detect deadlocks between main and helper threads
Date:   Wed,  5 Jan 2022 19:46:44 -0500
Message-Id: <20220106004656.126790-5-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b4597dcc-d4b5-48c4-63e3-08d9d0ae1ad4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB442282A0E782DEA42288DFAED94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJuxC5rg3ADIN4UcifVaKMIALHSC/v5eRjy3LGiYUPPtvBZ6RhdQ57Y4xnMMRyQm50gMbv6J3m0s9D+GoOTvGGApevnsRb5nY0WDIHKX7DsrcppxmSGtSsRRgK+vfxTbb45Wj7wl4RbpV7BEyKhLdQDLKMWJUkrCyMekAVUen7LS+g5LWGcK1ZdoR9cBaVOMeO8JjEA/s0cpnCJUZioKQvmOwiuOYO3uLJ9CUQiT8gV/laHP+ZLXSRI5BjIx6S9c5lM5lDQ1U1PQ7e/ysm6yysM7SIgIoBqFDKDSq/BGKrI1+fD0ybcFdVYX62/mball15kkrcXRw0raPWpHuwok0kxb2544wGtk0/5RJ1CZS8TbMIZH9OiMpBL7QlpPij/ZF3VozW1ReUuWrF1FdmC19iT7DHuv+K04II0G3w2CPv2FP0/ezNIXbH1BaVcM78iTEabXsFuRXi9f80PmLrCqWbE1XpWUJQmdCWVEpItevdongS3IvkdJbKbkhz70/SsB/DgnEoqHqOl7H0Lwz05h/T1z03P0HT23NFIATFHqCfIhkHLbNJA50vc99nljY1Mtno17Uc51dl+uKK5hhgAfjvJ4OThiARHbqh/XKWFRh8RWg5wRMnZvXvhraVl3+OZQM/rVQ9b9QD/cOAnRPOqYjkjjn0vcH9yikjac3OVID+umLoNuvvNKUYQchRxKShB3z0txKfYp/fA3jVzVZJ6W0+NE7cPaPGulN/a6inZ1NXc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96/3BNgUbgvDGAZIxyrKpgGq9V8RlsY6EHveVDUYmoNzBzPajee7GezxgQ40?=
 =?us-ascii?Q?8XOG1KbAH3a7mKIc8n5InGnctRWl7G7SDUoxmLaobOqk3imqAbMlmXhAniRw?=
 =?us-ascii?Q?GKLznOkSBB1CYso07VWh9oY5wqBXXbbRR0BkomYVnPeWKNxnJ6wly2aFIprv?=
 =?us-ascii?Q?AVM4rLS0ZPExAI3k3Al6RsB+g6vr80eeaG9IIcDbAvl2juVRYKruq/QSv0dB?=
 =?us-ascii?Q?XGYAYU8B34KNy2CPdmNZz+HmFgOnObc+ZzneeVAuKKKDW0YsIDrPRM/+cNMq?=
 =?us-ascii?Q?ARdXcAWZEEUtMToKc08jcZORnAByJlRzIKcK29NKn7hWtCfWHe+w+cj4ewtI?=
 =?us-ascii?Q?HluUmKN7SmPm2NjEqzMBGH5nkf99CZ4C1gTsFxxBK8hxZZT6hgDJJhIpQbx7?=
 =?us-ascii?Q?CoArFgk4XeKeRPMQ3uAEaKkvhuArvNw7eSTBh5XzuWXyO1pcyWF0sgCU/Hzn?=
 =?us-ascii?Q?wWEjb6kAvIdfY+3UIMYmgcoUUdt8FJCBSJjr5LWuLurhyM64GMOjeS7ob3M3?=
 =?us-ascii?Q?BEgunxS0xDmRGB4elkJyNtkdWboyBMdwkhdunFoBAMfMuePxLjGL1t+yK7vu?=
 =?us-ascii?Q?12v4txjSEo+T7e9Wg6/US8jweYYvNzWuHB/tUF8kQX/4Bewad+Rmsf1Pmd7V?=
 =?us-ascii?Q?+OMjy78eurvNKpCoNS6o3EkwhpVU1OAXtQXlBqvd7xiLFuxkQpje8Mahx5/s?=
 =?us-ascii?Q?0mdgdSp3X8mrQiOUyHTBZ7/BVgr1cN0vUtiGdXFpv6SZQqORu6WsmZIh3aNi?=
 =?us-ascii?Q?cD8dBniahyeacYtB5ZuJK8Dwh2MFcChlSE4Gl4gy6l+Lbk2tqRuxgQEm+8i7?=
 =?us-ascii?Q?FcrsDTnWj4tw4wM9puLkgQvyjtTtWcRmohgmaS3OqSDXhCXeRdPRAUpmSgII?=
 =?us-ascii?Q?utfwDk5RfFSFNiQPNXjaEIdaCyi3WYZHORW7fIKomDR1c+34Spb2c8h3ykpD?=
 =?us-ascii?Q?u5U3bfHB8PfMscPfO+u8wmh3z+PfdMy8+1YRLP4l29prDyXhJSgAlHVd4EIs?=
 =?us-ascii?Q?Kd4pvhzPqozH+nbaEW3aUTCBEasut5S95kldec27EsNeahbFHxlTA5kq+g4b?=
 =?us-ascii?Q?nW8YddK1gc2SCBvSZOLSbHZs/4PnnHIDV59CcwWfU1o7asWsRcZ3xfmwscmR?=
 =?us-ascii?Q?2pLbQdjtypsjM8oXx3CU6ZjkbQz7AiTs2rXiMaawJptP+rDu9+6F00yE7165?=
 =?us-ascii?Q?veBYkMwQatUPsxcHq3gIdg9C4Y/cSdHBot1y99jAdhjiUaNI1p9MMRw84dVz?=
 =?us-ascii?Q?hiNdz9KiNendxAtS0QCbc+khwMccGzJhSJRJ5btF33zY1kGT+EjfVokxdL3z?=
 =?us-ascii?Q?426LdyxtT6Tp8BhNrfRoV1AhPRgPEbHR7hauFs3azWXSg+OVfXhgq9uGt8sF?=
 =?us-ascii?Q?Q+6rfr+v8S3EkUQhic/SOnUzT6cyT9JPxFmv76E5xQvECsfKgo5VGxdDPNzZ?=
 =?us-ascii?Q?C/2+1tFPu4YPExWzQpCacURSPeYtYn4rA66LOqHCR8pmW3bI/JeNIH5TETNL?=
 =?us-ascii?Q?DLM+KTUq8Ka5zt69X05g9kUvZqel7EpXA6UvmhGfpO2ni3XodL4S3jTmYz30?=
 =?us-ascii?Q?gfU3a39sADgm2E/SBbowKQj7h7j3h9uYqSQPCqw/xyPTQkK7ahc4XiZKaz7p?=
 =?us-ascii?Q?Q0p1DGDQaHsxynJWrxX9oQomuKjjFIYAvWfRh4I0OeHicYKd8+10kDFtU5gU?=
 =?us-ascii?Q?qLrK50SFSq6z7YLdejDc1AkLiDc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4597dcc-d4b5-48c4-63e3-08d9d0ae1ad4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:24.4133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQ9S0WN4CzH9RifL8BPYGTmr1T7LZf2hQ1H77f4rOAtwZAlPK9dKHpfFJnx6pWOuHmGgXrT//3ttx8heP7cBLFtl6Es56av0ihsvj6DwGs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=546 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: VPF4fmMAJ08kkXoGfE_JRmztebTYOvOY
X-Proofpoint-GUID: VPF4fmMAJ08kkXoGfE_JRmztebTYOvOY
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A caller of padata_do_multithreaded() can unwittingly introduce
deadlocks if it already holds lock(s) that thread_fn() takes.  Lockdep
can't detect such a dependency because it doesn't know that
padata_do_multithreaded() waits on the helper threads.

Use a lockdep_map to encode the dependency, following the pattern in
workqueue, CPU hotplug, and other parts of the kernel.  See
commit 4e6045f13478 ("workqueue: debug flushing deadlocks with lockdep")
for an example of a similar situation.

Each padata_do_multithreaded() callsite gets its own lock_class_key to
avoid false positives involving locks from different calls that don't
depend on each other.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/padata.h | 22 +++++++++++++++++++++-
 kernel/padata.c        | 15 +++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 2a9fa459463d..907d624a8ca4 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/kobject.h>
+#include <linux/lockdep.h>
 
 #define PADATA_CPU_SERIAL   0x01
 #define PADATA_CPU_PARALLEL 0x02
@@ -188,6 +189,23 @@ extern void __init padata_init(void);
 static inline void __init padata_init(void) {}
 #endif
 
+#ifdef CONFIG_LOCKDEP
+
+#define padata_do_multithreaded(job)					      \
+({									      \
+	static struct lock_class_key __key;				      \
+	const char *__map_name = "padata master waiting";		      \
+									      \
+	padata_do_multithreaded_job((job), &__key, __map_name);		      \
+})
+
+#else
+
+#define padata_do_multithreaded(job)					      \
+	padata_do_multithreaded_job((job), NULL, NULL)
+
+#endif
+
 extern struct padata_instance *padata_alloc(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
@@ -195,7 +213,9 @@ extern void padata_free_shell(struct padata_shell *ps);
 extern int padata_do_parallel(struct padata_shell *ps,
 			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern int padata_do_multithreaded(struct padata_mt_job *job);
+extern int padata_do_multithreaded_job(struct padata_mt_job *job,
+				       struct lock_class_key *key,
+				       const char *map_name);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index d0876f861464..b458deb17121 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -64,6 +64,9 @@ struct padata_mt_job_state {
 	unsigned long		position;
 	unsigned long		remaining_size;
 	struct list_head	failed_works;
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map	lockdep_map;
+#endif
 };
 
 static void padata_free_pd(struct parallel_data *pd);
@@ -470,9 +473,11 @@ static void padata_mt_helper(struct work_struct *w)
 		ps->remaining_size -= size;
 
 		spin_unlock(&ps->lock);
+		lock_map_acquire(&ps->lockdep_map);
 
 		ret = job->thread_fn(position, end, job->fn_arg);
 
+		lock_map_release(&ps->lockdep_map);
 		spin_lock(&ps->lock);
 
 		if (ret) {
@@ -552,14 +557,16 @@ static void padata_undo(struct padata_mt_job_state *ps,
 }
 
 /**
- * padata_do_multithreaded - run a multithreaded job
+ * padata_do_multithreaded_job - run a multithreaded job
  * @job: Description of the job.
  *
  * See the definition of struct padata_mt_job for more details.
  *
  * Return: 0 or a client-specific nonzero error code.
  */
-int padata_do_multithreaded(struct padata_mt_job *job)
+int padata_do_multithreaded_job(struct padata_mt_job *job,
+				struct lock_class_key *key,
+				const char *map_name)
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
@@ -583,6 +590,7 @@ int padata_do_multithreaded(struct padata_mt_job *job)
 
 	spin_lock_init(&ps.lock);
 	init_completion(&ps.completion);
+	lockdep_init_map(&ps.lockdep_map, map_name, key, 0);
 	INIT_LIST_HEAD(&ps.failed_works);
 	ps.job		  = job;
 	ps.nworks	  = padata_work_alloc_mt(nworks, &ps, &works);
@@ -601,6 +609,9 @@ int padata_do_multithreaded(struct padata_mt_job *job)
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
+	lock_map_acquire(&ps.lockdep_map);
+	lock_map_release(&ps.lockdep_map);
+
 	list_for_each_entry(pw, &works, pw_list)
 		queue_work(system_unbound_wq, &pw->pw_work);
 
-- 
2.34.1

