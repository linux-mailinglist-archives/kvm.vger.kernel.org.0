Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD60485D98
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344387AbiAFAu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:50:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46874 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344067AbiAFAsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:18 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N58XL007590;
        Thu, 6 Jan 2022 00:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=+E9ynw7v0+0jTPU3dvFVP9/tc0O0J6ZHfL4pFSIjx/0=;
 b=PQNUzK29uYLZUWgc3R5LLTWcgtom1lTyFMwYmK+nyAxTdc7+SqY9fi5DVhb08z90kxnk
 7v7Kr1W/OlnfSfnlGdUf+6ZYCkimK1Vok0pO758STXtT4MV0XUX2sUC6rdnuWxtRLnjz
 PYp0WfUuSGfeFp5oVWLFdCgTqg0okqYnBM1Yt18/6RFzQTt7ov9xgcHyvtws0COmmhk8
 CpZ8ekukPsdIsOMV4CjQUjuvqsVnALy5QqGIiXE1SozDCMqY1RA6hBMaodoiVPBqf9Pb
 ZOL29hkdm7nnMdGFQEdxq486k+o8DTiZW4Kvsg/EgSK4Pf8ZwEahP1Ckf1O41vAEWxqQ WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpm03xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060W8hn102586;
        Thu, 6 Jan 2022 00:47:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 3ddmqgu5c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciI9MtVo9IITy8zxEo23PoawRRUs735BtF+OvTPw53OXewTAMIxDYKlK9NZhd+pz/pavLggA6FjwzDD3Jv6VYk1R4o66g4G+BiLgS4lRAQVOPXR5Rqt1Dii7AfUkHgZvpyb7K0mkhF+rDPAOZAOzpNiBsAeojtQJiehrX+xVDPhZcyq7zA38LHqEkHxVSmULApqPz2wbDyrWe32H43PjegfYu18NpwmI7DYrlkQ3DcDhBpvzxJf1BuIqyrBxa2Czwg6nto4ni6RY++Q1jifkCZ8sFpwcuW0MzijTKfm2w2s4gmT7bTESohIjNoJX5YUB/6bv1+mT2rlN2daHgHmiTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+E9ynw7v0+0jTPU3dvFVP9/tc0O0J6ZHfL4pFSIjx/0=;
 b=VMiqD2VVxcLRWZt0vQUTr7EyiX4mf4KJWAqJbsQx1XrV9wBAucPSTdsI9hjwyvB12IBJfgLL+eJ3UTp5zuhzqPpPXvva35MHJ2aQ/ADsCR4mElh3JSr1bRcpaIE8wuTfusDS7qeEyiKt+JEvSYfvtmbe0qNCS7eVb6uYM6YgZNz9IBNncbf851P5KhfbH3OFMTLd8+Fo4GLYrY2JYfSdAHevCw7u17O4YoF6NOkQF0JYuLWAI0RftWtfrrFJAYLUzX9sSGgTYQzjEWMbcbZVQToBfKQu3wQzlMUXQvseAX1Q/gom7zexXr2KJimYe13bqyKnBf3Bh7IMymbdlHf8uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+E9ynw7v0+0jTPU3dvFVP9/tc0O0J6ZHfL4pFSIjx/0=;
 b=yk8F1X7Ys3vpNq4X+joMKwRDMK3oFIHglDy81fPONEUxQn6yUrVlTt3SCNSUArbJACIqhhuDUKs/FdDdSzzQkAx+UKcDEAaSBfLy1DHAZ0AnI0sU6YS1rv8BoVrRVMiGtjQVrxrQgZH5Uuzg/pO/O2hvMOq5hWHYVZ2gorIKjhU=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:46 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:46 +0000
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
Subject: [RFC 12/16] sched, padata: Bound max threads with max_cfs_bandwidth_cpus()
Date:   Wed,  5 Jan 2022 19:46:52 -0500
Message-Id: <20220106004656.126790-13-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: c2f406f5-f8c7-4510-5849-08d9d0ae27b0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422A3FE024927CAADD2EFF3D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUu7Xc1XTbfL2u4BzxXRn1OdTYRsjydK9LXTgWgsce0LbF9dlGwlrS7s5A4vtqY4WzWz9kVVjmeBUxwjzX2EsrBotGEkPX2WVFy0hAsrSjv4gQ5ipZUkGqmksfVZy2XoIL3nf0hDCWmQ9C4OmiqvDk/C9giaJLuIR7OHmkFwLEsdpN/zbgh5byJ+RRQ5xkhLa9NBAdvaTx4DznA9JUjY6sK9JtIHBOVULKDAG+4FV8CphABucRf+lcEWEZ7O1mMHSkljLuE4oqMQa6GdBKLr6tfPDKwS1dQLsPWo7fJTlbiOfDdmB8LD1w0ifyGwIe4LKd+iB3P2rPtY/uBc4GG5HanPusUKHaUIl38EGsa9MFnbCy3D0Pv2W/n2GugfEcwa3f7taJ00S9fEpVwibalg9plUHidrSXVhn4VbaEydv9FbcPjFi6mS742PL6sLdZkYVFRfLUiRbN4UWWu8WDeOcK8kCQz8QHdHc/H4vCQtymB4ePdd/phdfVmaS6V3NT9mgWeWPne/6j7nikFPUR7oJlDrLaR2dl5ny2qs2KG0JLA7lJB8fhZl3W0Rwq2GLk7wvfqwCBJpiyZXYlZjvo2kwtT/L36z2Z0FevPMpj9fxfzXDwlEaianaqsq/VvxWnMJvqRRZpt99u84eOoCYnSAh/pmiBJFlQQ3b5IHj1oix1wpvfR23SbgZh/yIczHKruGnQGPtmmHIM+KDmvpshE5O8DmznKGfpFlx61fMl6lKkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y+IaWN+ymj3Z2D03i3QdHbch3azTOPgaxXLTSvMgHRYSEpWCvmCErh/6UZI/?=
 =?us-ascii?Q?2SDugfaoag0IM5TAa0HChLC7lFP5fBR0HNia2lKrnooLsN2NaJPDAACi/YiZ?=
 =?us-ascii?Q?WEiseYtGeCm2j5AQlCE8YpVRK2j9gOZDg4mneGNrtsU/jyEy8GP8wU+d5aYi?=
 =?us-ascii?Q?cr2rLw5YXkBQQnLMZ3lnkwkqmBOwlGag/XbAsPYn5l3hWqplfWe+yB8g8XXO?=
 =?us-ascii?Q?evvx7/gEGhF50JgYuJHFAp5sYdw0UkpqjqGsu/HMq/nLStY0tX7wnbDUFDa0?=
 =?us-ascii?Q?5O4YF3VVShxEQLHBniAB8n8gwds4vGefGH/ut9+xMC409aOvVvi/rEiCqJ4h?=
 =?us-ascii?Q?SvwYEqs0NAUMKj2rx1wU793x0hiYPyQocXyWDynW41e0jAkvo8ZmOwNgQjXU?=
 =?us-ascii?Q?+9qDWxZO0cwbRrY42L4NTPOIvS0MCbd15yUWy/PsvHBlBu2w7waX7XViaGWf?=
 =?us-ascii?Q?k/67bhyDFOA4hVOyZMpOvKraUAQ4EOrNHqoSjrj0siPD+CVlySYXv0MfV9z2?=
 =?us-ascii?Q?JBlWdGHoayufseqDBVUg6mi/ywFFFAoCQ+kQ2mySOQM6LtDsypxEgaQqpcdI?=
 =?us-ascii?Q?BVYe1YenWPVyxIuE8s0Wxc/rjZSG//ejX0Nolq58DluJ5DV2ZFP/jLSfZ/T7?=
 =?us-ascii?Q?fY4zqmCMmn9DX3zf6XfSlG1CE4JgtYyw1D0JsO3wa31bwhfE3RNivsttDAWz?=
 =?us-ascii?Q?4j3rkQJLPBLgrDg0sXoOB2JsLV7le1Rred9TzkEl7AzTvk8i8s0TBOt3u6Nh?=
 =?us-ascii?Q?69h655zOgI0tWAkC4HTr1BzF/DzEzLUgt8OAmy6TG9kerz4zn9yOvmnXWWAv?=
 =?us-ascii?Q?QjdY99U2xuv2twZkN0S54Iqboa01q/K5fPWIu2TEkcXWitiM8KgT68n9o733?=
 =?us-ascii?Q?MFMkWjxl2NayRzZ4M53e4rzQnEO5kDb15VDePr5SBPgKSsGxgaf9iO7ZfSOX?=
 =?us-ascii?Q?CJRjqZq8Ck0vppA2ZwigUqIW1NNsS9cuvZU8cGnka6VE95WwdcPcsCrT8LEm?=
 =?us-ascii?Q?xmAoqEzbi4GkErxFbs2QQogBju7YPNoBQPGzaCYi/61De3wfJVtQT6kOzHXV?=
 =?us-ascii?Q?VN00rQZk786Gf4maw1+AnZ5+VlShsXzUjuGHs8OEWXz7WKnAgB5XSXUG93c7?=
 =?us-ascii?Q?gKDjaBrwpQW4vhjVtfgbJ/Q6BemNkevOC65SomCNb7LXgxfG9bgAU+F6M/zS?=
 =?us-ascii?Q?pc8UgOy0ST87UHkVBdDM75dGOZlQaE26nl8WCvRPie4Y/TlIKFcl37L8BeBK?=
 =?us-ascii?Q?CfnwI9mRVy8La9QUs55hzIEgwen0UdlwA3dcFqPJJa0uspOwDKxOaMnjTzDB?=
 =?us-ascii?Q?ZOWUrmSaZi8SSWP0+GvN6DPLd4XJA6FndWdx4G28pogeUtTU5vcZl8p6CY9M?=
 =?us-ascii?Q?X0D/Bb6My9rRZR1jzxFMLkxrlIW10b088sDWDvFnvpbvfgWgXai4qCYA59M9?=
 =?us-ascii?Q?JdkBA2jPnrkQNTuf7cK8MEKQM5o1iPjUH9VX8pxMSZPF6rNOo5NhGJKS9m/C?=
 =?us-ascii?Q?PDp9BvNDya+4oabqNVvBtNraQPrlpnlPxLebKS9I7IoqdhgsCCfbxobCclQ4?=
 =?us-ascii?Q?8G2gpgwevbQ6EQMPqJBRMfq+bIlEbZJ+hDCLVcI098xfuWgyBhjNhQx6i4dA?=
 =?us-ascii?Q?C7FS934nSfn11l07o82Z6aJyHLAAbJFodivxd9RedH4zpYtsTwVkyJE1rGYN?=
 =?us-ascii?Q?pmY/g+GnLC/Xk7au8zzme6O500c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f406f5-f8c7-4510-5849-08d9d0ae27b0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:45.9954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IN89zn15klzP9BOFrLM/57KM093S9acMgui0GwOnytc4ZRZ5sEw+Une03S1h59JEzM8/HnQQ9qmJb0C45BCgk3hSI6CUT7jVphkUuRQD/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=667 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: h4_Y8PEYP4sYh1Z9hBLR5vldbozDzFp5
X-Proofpoint-GUID: h4_Y8PEYP4sYh1Z9hBLR5vldbozDzFp5
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Helpers are currently not bound by the main thread's CFS bandwidth
limits because they're kernel threads that run on the root runqueues, so
a multithreaded job could cause a task group to consume more quota than
it's configured for.

As a starting point for helpers honoring these limits, restrict a job to
only as many helpers as there are CPUs allowed by these limits.  Helpers
are generally CPU-bound, so starting more helpers than this would likely
exceed the group's entire quota.  Max CFS bandwidth CPUs are calculated
conservatively with integer division (quota / period).

This restriction ignores other tasks in the group that might also be
consuming quota, so it doesn't strictly prevent a group from exceeding
its limits.  However, this may be the right tradeoff between simplicity
and absolutely correct resource control, given that VFIO page pinning
typically happens during guest initialization when there's not much
other CPU activity in the group.  There's also a prototype for an
absolutely correct approach later in the series should that be
preferred.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/sched/cgroup.h | 21 +++++++++++++++++++++
 kernel/padata.c              | 15 +++++++++++++++
 kernel/sched/core.c          | 19 +++++++++++++++++++
 3 files changed, 55 insertions(+)
 create mode 100644 include/linux/sched/cgroup.h

diff --git a/include/linux/sched/cgroup.h b/include/linux/sched/cgroup.h
new file mode 100644
index 000000000000..f89d92e9e015
--- /dev/null
+++ b/include/linux/sched/cgroup.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SCHED_CGROUP_H
+#define _LINUX_SCHED_CGROUP_H
+
+#include <linux/cgroup-defs.h>
+#include <linux/cpumask.h>
+
+#ifdef CONFIG_CFS_BANDWIDTH
+
+int max_cfs_bandwidth_cpus(struct cgroup_subsys_state *css);
+
+#else /* CONFIG_CFS_BANDWIDTH */
+
+static inline int max_cfs_bandwidth_cpus(struct cgroup_subsys_state *css)
+{
+	return nr_cpu_ids;
+}
+
+#endif /* CONFIG_CFS_BANDWIDTH */
+
+#endif /* _LINUX_SCHED_CGROUP_H */
diff --git a/kernel/padata.c b/kernel/padata.c
index e27988d3e9ed..ef6589a6b665 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -24,6 +24,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/cgroup.h>
 #include <linux/completion.h>
 #include <linux/export.h>
 #include <linux/cpumask.h>
@@ -34,6 +35,7 @@
 #include <linux/padata.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/cgroup.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
@@ -572,6 +574,7 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
+	struct cgroup_subsys_state *cpu_css;
 	struct padata_work my_work, *pw;
 	struct padata_mt_job_state ps;
 	LIST_HEAD(works);
@@ -585,6 +588,18 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	nworks = min(nworks, job->max_threads);
 	nworks = min(nworks, current->nr_cpus_allowed);
 
+#ifdef CONFIG_CGROUP_SCHED
+	/*
+	 * Cap threads at the max number of CPUs current's CFS bandwidth
+	 * settings allow.  Keep it simple, don't try to keep this value up to
+	 * date.  The ifdef guards cpu_cgrp_id.
+	 */
+	rcu_read_lock();
+	cpu_css = task_css(current, cpu_cgrp_id);
+	nworks = min(nworks, max_cfs_bandwidth_cpus(cpu_css));
+	rcu_read_unlock();
+#endif
+
 	if (nworks == 1) {
 		/* Single thread, no coordination needed, cut to the chase. */
 		return job->thread_fn(job->start, job->start + job->size,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f3b27c6c5153..848c9fec8006 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10021,6 +10021,25 @@ static long tg_get_cfs_burst(struct task_group *tg)
 	return burst_us;
 }
 
+/* Returns the max whole number of CPUs that @css's bandwidth settings allow. */
+int max_cfs_bandwidth_cpus(struct cgroup_subsys_state *css)
+{
+	struct task_group *tg = css_tg(css);
+	u64 quota_us, period_us;
+
+	if (tg == &root_task_group)
+		return nr_cpu_ids;
+
+	quota_us = tg_get_cfs_quota(tg);
+
+	if (quota_us == RUNTIME_INF)
+		return nr_cpu_ids;
+
+	period_us = tg_get_cfs_period(tg);
+
+	return quota_us / period_us;
+}
+
 static s64 cpu_cfs_quota_read_s64(struct cgroup_subsys_state *css,
 				  struct cftype *cft)
 {
-- 
2.34.1

