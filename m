Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB109485D9B
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344402AbiAFAud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:50:33 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62246 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344097AbiAFAsY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:24 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N50I9009819;
        Thu, 6 Jan 2022 00:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=g6wbgLabBfejMsOUJXr9N/Jk61qImKZOs8Xw5z6wzKI=;
 b=c6c2Kcucf6st2/6H+vLK1PLZag9VG7vyH/WwxL42HRS91DczFLdrPp5V/asg8oOVZPvE
 gAoKoh5Qq7mTfnrEEg2mWjxBpp/Kf4AjLrXoeE6LigjRlTaWaVB1KxWnUUAzw3jzeD4u
 /w8fNluzVLdvzYNubxDw6Xs68pfC37GdW/mSfO2O6VkKnGyxmdUecnqmB006lEK1lC/m
 Q05Hqz4N40F7xsWZZjvc87rPXXeURDiWeW+ol6qPMYRtv2tLGJgtShrpHBICv35HijWw
 JMr0ZAwgOpwqngE8ciH2Q8V8i14ByBy433POUy1taHscJZaO1te7UzzyPDAYn0sb4+5R yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp83ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:48:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060W7HW102479;
        Thu, 6 Jan 2022 00:47:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 3ddmqgu5gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEK/Y7CSM5aMlrOuhQm4gS7yJDKHkdfaOx3xSeglYIVHo1Xrj6m07BydGiq1KMlnVG9NRFwzLVN4qTiN1aKx1h/fvt7nQeoqwMEz3yq8UUyX//p2U+PTGWK4h7NjVUJiFo/tyGCzzrKLsechxzNcughhYH9r6e4PEg2cMVmCw+BA2rDjxFs4omSgi0Jpb2p0TdqxYtLaZBCdBeA6Pvq55Nj1TbLSSaJMEGuwfdwpW676oJXiyz8tJ+4vp+ZIIXec0eDFqlHQUBHy75XphIExAqtTMxJY3EgYTI7GFP0pzWd5tmW++Yn6qSAGl6R/Uedid+Y8KKvILL6JamrqWzup0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6wbgLabBfejMsOUJXr9N/Jk61qImKZOs8Xw5z6wzKI=;
 b=jzq5Nswckid0IEuc7iJpZ9ioEsi9DCPEzc/QeXyBI4O0Pj79qdV3m+is82ilzyTp92KjIRI/srWa0zTBwpp5gVcy7TM1M5ldl25/yLRfxS8vLlRSJBoy5cVg5d+pDMtE/ovCh3Z+dtGvwnqjxuOzowZzRsDkqz4me+SH2/1+jiAumJSFYQ6v1j+8nfXA8e7r85ebniKdCx42rfSJDSHHdacQiaG3P/AL3effd8mN5w3Xr0L9GaHhdbey1q3j4iX1bluqR3vAtT+817qx4Lildh7Z9NfiISD5tnMLoZZTbZ2aqUwEsf7H9YUs0w97cuB+PLA21pKznjjzq4c0O3t64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6wbgLabBfejMsOUJXr9N/Jk61qImKZOs8Xw5z6wzKI=;
 b=V0sFM5zWLvzTX1xqRKDlOLiZ0km4Im8QMxidIJLTwJ7GdWltvw7MbpUhP3MOukECLj42rnxfYMV7GjM1yZjRCyKd6CHDzS+yGPj1AqTlraT7ppaqeqltD9YKgj2gdJ+jQsg5DhEiCpMUXAe3Je7YGHbf1AVlsRrZEbJEq1qQbHI=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:56 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:56 +0000
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
Subject: [RFC 16/16] sched/fair: Consider kthread debt in cputime
Date:   Wed,  5 Jan 2022 19:46:56 -0500
Message-Id: <20220106004656.126790-17-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 961fb492-34d2-41e6-bf8c-08d9d0ae2e02
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422B0610CA363D5162A7661D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06uXJuKwhpEyxBHrIy02hCl+vCw57/H3/F7H754Dc7RGLtNyZGs2WkSqRU9UxKcUGct3V0F3rwJx9F+133hGtmNSzmxK/xTHpfBVNneIeE3R4zcsK5870K1kTcYYU3sBpVkj3vadsi5ui/hpglpQA9pbDDanPzZsZgyG5n3bfLpQaCi6rzTYNZYDenEZidY6yeuByNTtIAeyxmG+Cab4cn2UUxWm0wA26YdU3jKdJJs27Xgj15INdDWW5KmRctj0ml+LL2tko1Y0t9teKvrr640YczAyZEQsqNntDlnkSSL7NJau1RLvmpow0zmtim+yryhvSMUpaDAdQelwHhVvxZMGEfHsqVpA3iU7QUUNdSj5Axq0CysMbqYYAYFDZh4OYVkw5JEDM+HEx0piI5YO57f2aI7usFs+GDefl1Aph33NVgR1yR+qiAxquoQsLO5jHk/2iZIRP8KK+mUs2BfN/XjsXyZknfbcgDplzhzOj/8CU+eP+9OvxluChtnkFO4D4JIHE6ggD70YHneW0r0rJdRYY81jFEo5E0Y9AvZfUeN4hSoOuM//rE2nl2lP9eM8DWzcBnW/Ag2M0MMnhP99TkBMOE1Nz4AmPImzb8IiPWUStYuX/4jRFn8+8TGA8kiyRKXc08RqUjcX529uwlQKbIbx2YElEzmLZuO1TtuMs11JSVCUW/DwFJEcfdVvrHvlX+E+dft+Vq02lA3CxCwnwcAsyjnn95Qc4bGpnb3k2XI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(4744005)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?60hMrD68FoDPL+zTC1E6RbDd7u3Umob1ninjKahDE5F3C49hccI3uWpNfCuk?=
 =?us-ascii?Q?DFChFQxsXFouTuET2SprLfhF9Wt/hXiXu4NEcP5NhuDQyOgTqKnKvmwptHdE?=
 =?us-ascii?Q?079+mcXwpuTrg1nWRilyQDhqBsFImXKLyep7NtwMloxeEQDdJww+Mdxovh64?=
 =?us-ascii?Q?9I6VEMQvS5kaxm7D7icyDFUYO/fI2PCHxoM62UX5Ph68xdt4luSdlsmQecDs?=
 =?us-ascii?Q?gd9+RGiZmKx2e5IoeQJwOReAr6U/cCpzfVS4v82ma+3kmq+1UnPU/YOHawD9?=
 =?us-ascii?Q?jSB/yAX0SiL1SN8gsZjqmPq4DSUq2V8kwRwmB4v4TC9hWqW4/yNwYLyU5M1K?=
 =?us-ascii?Q?T2YhY9N2tn/ClF3wXzq1/q0YBKgQBCpPhy8Q5CRr54bsiVWFgZr5ZIH7MyWE?=
 =?us-ascii?Q?A6IBfIKN/DNfEdFIJEdGMttJE6eCwRFAK2w+XgkjgqYFHnCkABri7K9FIP0B?=
 =?us-ascii?Q?hIgjClN+cRaVozQeo4RQF0aoh4ObHN68gI58dgFNcA5Fav/Ito/3HEwvTO7x?=
 =?us-ascii?Q?XLlGGrrnKjYZye5Cg0XJfOpn2um1cJgAF1wRgaGoORYBNiIxj/JTEQhSShow?=
 =?us-ascii?Q?owjpXo7ykmup9TLF8OhaDFuhxcS6MK+A4a2iQKLV6FwNR+AmCow7ZucoDjEB?=
 =?us-ascii?Q?FzJRzgtkGduaEUzY6jRVB/3hX48NPnGXrvgfbuqSY15g9hSNN9gnwYzpz8Zz?=
 =?us-ascii?Q?aqkDsdITJnEUgth2sreB6HXcgs7yKmjzruP2E7hMJ934MguBrCndk+sC0ZK/?=
 =?us-ascii?Q?PaSjrI1lr9gC4acEY/pp/9e4vr9Tbx0Gfet3PEj3xFg7jUcVB19BdoHzkJmo?=
 =?us-ascii?Q?Q6tDfuX0Kwde8rnS9Um+/q1mXjb+tV30KiW8vjhpkoUzzg65kZ8Ubk+5AbcY?=
 =?us-ascii?Q?n4O/m+TLXC4OkZlf6UDpA7LHgHSnfbEknPV24EfPT55+GvsfKCqtjSvB7tje?=
 =?us-ascii?Q?i52loBAIUKax+AjTdLt4pEEew8Hd+8e3r1wsu/IsV5PKH8KSWkdhcTAprJzK?=
 =?us-ascii?Q?WzxXjcTL0ifk3CPmicxjC6m4rK9AUgRy9wT11jaS/v4TQcEwxliIA5UpreDC?=
 =?us-ascii?Q?ZCHrIU+zTaBFc1BuxdYVbVfmhoWcI4aGaUwJ1yjHBZjyt6dMHckPe9y8p5Fc?=
 =?us-ascii?Q?ZLBHPithgbHPMPNAlW/2pMn2ygmhLTi2cSecpXR+Th+u4t0h3ia9GsDv7UsN?=
 =?us-ascii?Q?RUFh5XGg9WptRQT2ai6UFA8oKz+dgZedhRaAUSZVqzbamycaU+Zvu+7TkO6Q?=
 =?us-ascii?Q?WEZm7TPo8Mp/rRKYjMaUWm4+T+urQjUJyURHglJmiVI45HvcyodHIx6H/WM/?=
 =?us-ascii?Q?nsyOoGoOFutv0mM3wE+f3ldKhaiTVcMqSgdCWjpaIBtrZPAGgq+dpoRFPZO/?=
 =?us-ascii?Q?BxNj43xJ9bPxcFpepth7b3mz9A+RORaUuDD91ULlG0hRbZt3+0kRvFl/3hRO?=
 =?us-ascii?Q?LFtSCE3wcY0fqKFVhEb4Yq5DiR2UWsyiSLfnOTfPXgXxzTOmiiSgshZ2spBr?=
 =?us-ascii?Q?Q5UdEbvNSpRHX0u4LA4KcerX9cpNr35a7JSaOwO0HvcmjL6EeIfVnW9Qrzem?=
 =?us-ascii?Q?9/qT4qHmlyV5r9jjmkohMxE/E81kDJbcaXZ9PQucBr0uXGwm2TIPIlrHZJS/?=
 =?us-ascii?Q?GBDUniwGnmjYawoD0mzhg40zL4Su1clFVTqftpqgA/RFYIc47tBNdK+jj6fF?=
 =?us-ascii?Q?79dzs8+8s+FDNbTMUO5kPznHhJc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961fb492-34d2-41e6-bf8c-08d9d0ae2e02
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:56.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJzqxi0yVUBcFUJt7XtjlaxV1xcyiOyjFZNJT8gq39Se21tkaApgGKK5dowjzaqdtGDAXUIcAxzzwXRuefAyXb1JKrus0Ur2mgCRtRhuSqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=993 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: K9Ee__0VwpsSlQEGThoUqRnivlDQb83K
X-Proofpoint-GUID: K9Ee__0VwpsSlQEGThoUqRnivlDQb83K
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kthreads that charge their CPU time to a remote task group should be
accounted for in cgroup's cputime statistics.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/sched/fair.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3c2d7f245c68..b3ebb34c475b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11524,6 +11524,11 @@ static void cpu_cgroup_remote(struct task_struct *p, struct task_group *tg,
 			goto out;
 
 		incur_cfs_debt(rq, se, tg, debt);
+
+		/* cputime accounting is only supported in cgroup2. */
+		__cgroup_account_cputime(tg->css.cgroup, debt);
+		__cgroup_account_cputime_field(tg->css.cgroup, CPUTIME_SYSTEM,
+					       debt);
 	}
 
 out:
-- 
2.34.1

