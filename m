Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6594350F4
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhJTRIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23200 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231230AbhJTRIO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG5mRW028962;
        Wed, 20 Oct 2021 17:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=+WcxjPmGecZ33zLM4HXZ0QW441mI6Giii3BHuxSYV6I=;
 b=0GYVT0jbPEZuITSGrozsn2v4MND8qF3+T6bRiaGAO20uFyv8OoI7NWfpqGO6wVipulBx
 ODud86ZdnQ/BXIOuDKpAuXxVggxCQoNVLpbSaXuhODbqY2PkTVdcLcVFj9xkWHGOqf/h
 bXcQSmWIkNAImndQ4Fue7mCPu6PM+D7HFOF8A+IK6/VOL6DnWLHg50vZbQTkcOGrIWAQ
 T81v4R2ha379UAcuvi920tnyXI1Hj5CAJbIPr6jFpz+lWbER+J0Y2WiQ3xNI3dl6GWtT
 fbrlYzURoQ/pdIuJ/B/tYl2L2BnMAlcjkTsn/zY6bBctZu2W/vcf7+HFbHhBaHH+YvuR CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsrefjhtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCV005957;
        Wed, 20 Oct 2021 17:05:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMNiJ00aN2LnQM7EasRqPOnLqPc/Zs9R8FYS5xDCiFSw87A1sAuCxy9mP9v0lyzVFobkYY9jf82+oaHz2ckaymQFIXsdjcWPWd8A574Bbk/8xuXRjdOxAgu0LjTI3rmp2pTTiXTg5HvfdvpXpiRZOhSNOvVhH+EBv8ni1xZQ9Jrd1IKRXGR5+CQKb21u0RG9WnQiFShSsv5a2JKy24q27f+fpy+8lnn5Yo/ASVw19zOAlrf5wUVmWvqe6FehPii8L1QpZqTNauK1JUCf3bcoGgu0D5qSsqvanqVLcLLvrlGHKl97ic8H2drCwuznD/xccSjA5HoomJJmfjKOCGBTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WcxjPmGecZ33zLM4HXZ0QW441mI6Giii3BHuxSYV6I=;
 b=IJWoLg7FgbZD4uIlQ+om4glEwWU/depFBe1zdALi74XP2p9q5RBBrG8AM8unRQrcltgE8IdAKFhsxSENEkysqmdfmfj9DJ3VnUgMNH7i2s+3YY9RGM4pGnyslexBA80z/bKltSrD1CH12T2MpIJBPdkAWOpgJPGg+3WyYBrEHNQsgqT4L3hShXclMX+md+UwnD/uz3TMC3XeUPPrAuOF7Io4uBbuCy6VEV6nt6lxhZvuccJd4aXtsyizl4BcG5N4dDqBbqaJveSIqZXccxUzqzmgbSY3CK/fFuosPZ4DknQc9+pF1Rq07FXIKDgTs7sVMdUsuNNHjQl/lAOrU+geGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WcxjPmGecZ33zLM4HXZ0QW441mI6Giii3BHuxSYV6I=;
 b=aNznlL8msiNELCVmVeBhq1l3X/wWsj/cFvdNwAHwfNkBU9cc49aGjhvQEiSeder6/JAXqKSjd5AShRDa7+xVMUq9Ukj2ngxbHOlrFRlF6B3TkRliPqMaLS1QQ2w2Mbo9yHs1WDV0Tgu4XKCdilWKdsv8eA5wF04BlNnFMNIk6Mo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:35 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:35 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 08/14] mm/clear_page: add clear_page_uncached_threshold()
Date:   Wed, 20 Oct 2021 10:02:59 -0700
Message-Id: <20211020170305.376118-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:303:6a::22) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR04CA0047.namprd04.prod.outlook.com (2603:10b6:303:6a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 17:05:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ebdb186-a769-4162-d97b-08d993ebd4f8
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45775B481D792E5F2D7C63B4CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZNXl3qDaqCDyK+SNvrMV7yOiccqxGZHsXU3aP7J5R3B4P1vq0JVHrVNO/MFL?=
 =?us-ascii?Q?mceT5IyeBo1UxF6F1B20qcM+/zQ4XfCajuUWrWThoazE98c0PuUru4AI0cv2?=
 =?us-ascii?Q?ymuebRAghjTTO6WCOXOj6GhhW2EqvGD7gvdxnuWNBBbQFpKYBR1ht6NjK6DW?=
 =?us-ascii?Q?3D/Mm14aO6omaS2BPLt82Am0AMV5p5UEJdYPTNVM/T2bnGwiGXudZQrjx8Rt?=
 =?us-ascii?Q?Rhh5mc0SOH9t/PLWrUTG1wqnMwo+b35FPvTbGW2NMCZCMfjK0jicT5JiQalD?=
 =?us-ascii?Q?AwBDyWz3gMpdTzXnPW3clL6xllca1D48dhmB5yVSWHpyoN0TWRQWjlpfAtTk?=
 =?us-ascii?Q?/P+8Lmk8B4e5xtpWArOM4HaagvjwelX1wEg1BqVWLkOELpVF1nI9JMN9ddEs?=
 =?us-ascii?Q?xaQempqZ3finKYLIbEr5LWFXSC1NWrDwLitqs4fxG3S3olubWeP31NGwQol8?=
 =?us-ascii?Q?V4HYJ1tgrF1unMfRiDsn7guOjbgliid5sa04+BmAukjWbUQyQK/OuZ+dm0Ml?=
 =?us-ascii?Q?9lFsTNrO3KBuXKEMuOjylwUZ10ojbMT+0lY0grq0RQ3p8+9r1bHdgyZtCAgt?=
 =?us-ascii?Q?q8YawdlXeLoUMSC4aTWvweTi0AY5zYxo0JeUwJOLKOx0zZ/7vA3drHE+pF4l?=
 =?us-ascii?Q?9E23LTEcvuVZz1Z0Px0Yb4KquwINW3oGqWKlrTea0rTHoQwXdiTIIstTW0m0?=
 =?us-ascii?Q?Kqs2hlEuZJvSm553I0UPcJyptKCopL7H567WxvUyPFLkc1/mIbD6YGe6xmc/?=
 =?us-ascii?Q?Mew1XfddsxC3vKtHcl8N3biQUHMdqaNsbz50rEu7UkaFJS52Owjbtfd7Q8YU?=
 =?us-ascii?Q?oqvpJS84thwobax2YsChk/kGLTy1l+7GRbA741TQLqZVA5jdE4rmsilFmce4?=
 =?us-ascii?Q?0emajw+iwK9bgyu26lUFQG/tIogODUdm7AluVtPIfzfGeB0FsTUIX9QsO+vK?=
 =?us-ascii?Q?o+T9ax+2qmq7wRRNQKmO1DFRh5CTM+QcXT6sf0iQ5hJiAVPw9c3F3A4FCm2+?=
 =?us-ascii?Q?Ja3+HsBND49yFIawmMattgJVhz0dwwCRFDAjhExXMz3miI8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HHWHHQuZi5qsfXfeVfzDZKwNmFaGfx0Uhu5SjHvlKeLBSbyc2KVye9T3ExLK?=
 =?us-ascii?Q?mYREO7dOibfAAf8ndOiGHAjW3KkMQiVzuXEHB2ynrW3Qqmm617PxEbcqAOhP?=
 =?us-ascii?Q?hnqHkEcOYOywsWuNOwCl0ZA9DQQpXpCrQL20M+JlGQxMKQNL/xkDoY44vHNe?=
 =?us-ascii?Q?xc0n/XYogr1o7fT4DzY0yjRn+mTQfxKXMibMjHiaesOb4zRn6dVuycW7FVlQ?=
 =?us-ascii?Q?0SONv5/B8x+OHkoJowm9SmQ/rhtw+WGvo6Z9Y7OepbWzEn8wQWx7gDuG0qsk?=
 =?us-ascii?Q?9a0AoJIA8zdj6kLcBh969u6SPpGShi7WsLcXg/8+Ej+Vp/giNFE15oG8LbEF?=
 =?us-ascii?Q?5eeZkRnXGq2/iR9D8wUnKJ982je9yLj2r+nzw6O7vt+s+NwG+px+3BbtMg8s?=
 =?us-ascii?Q?jFKABYDVgG3eYtVpwzYuxMYucY1teC43EEnZGs2ZT/7kWPhcU3VwsRLshr/Z?=
 =?us-ascii?Q?lLHOXjvVAXulZ37uderDAcRZEpooxVstoLUV/+AFBmJQBRj0FkChu/tvyB1r?=
 =?us-ascii?Q?VAIj8VSYAPocsqxfJTLlcpAe457c96fV/FLjmTAUZkWig/RCwWgyotcsIf59?=
 =?us-ascii?Q?xeR34WbI1ozbstnvxnUzRMLxzu8osW/MZmhgI9kyjM+ErBE8AHnOnOK7O6QI?=
 =?us-ascii?Q?CzOAe/ZkWOkSJ4EcDX41cuPBiuRjIff7TKqQuzl+l8PC9WAZsrVSumNnZnji?=
 =?us-ascii?Q?neQn+5hCigqWjAOULesywFxDOrfQ6tvHuR98pBMlM+NJ38sdUNOdlQGdhM6A?=
 =?us-ascii?Q?ankBeDGaevL1Sa3UsRTdaMv9+FfKK2bcBzR9qk2iaCf0Tb0ZXoXXBKDlh+dI?=
 =?us-ascii?Q?8fVE9GRQ+BxFDAdzep3OfMjcsC+/GRaxSaopjv+LWS/up+ahxAW3ioJCUtzK?=
 =?us-ascii?Q?YPINyNQyDwz0JNFt2md8aZSSsJnIH7ofllOVobo72Mo1nZnzWnJptc219hgK?=
 =?us-ascii?Q?TTE+QVUK6MFVczyP1sACmMPiYCx3aMHNq288S45NMMI+65EBYT53CoCR9Pww?=
 =?us-ascii?Q?XEXqcULlirZCi2KorUZq2/NeSd2Bk3U08v5ntx9uMlewGI8HXUI662RMNqJr?=
 =?us-ascii?Q?fd6Q6J1px5KIzDGmQy06LQAt6+JvP2Dk+GxuNicT9vTyQIrXBAdX6wU7NoD5?=
 =?us-ascii?Q?OqaLLxiUtbf/mLzxqJ/c3WL5YTiXJuygjUp4nhcwbkuc6VNQ1x5dWwH82hBY?=
 =?us-ascii?Q?gV0RmHVSwEvwCMvmiFMv6vKBhUaTv7ODT0UVMTyIFk60gPjaBg5kuYT4jO+q?=
 =?us-ascii?Q?fYBsiE5tdgvmy1CSKcI+8OyJ0xJA83w73W7Ub/YAAkpDlU5ELfzYu0eZ5l2O?=
 =?us-ascii?Q?fVXn8GCzvKRrYzNqv3xUAdH2f72OAw9ebQBDxAyIaM8imtxQ3SybnZnNYnSl?=
 =?us-ascii?Q?x+qjA2lMga4XLP44xnuAwHrsSZMOsDhYIKXFOedSdcVfKlSyLLGO7MPZ2vSr?=
 =?us-ascii?Q?Bv2FGMsSo2QQK47MJpJtNWbEVxh9+PbG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebdb186-a769-4162-d97b-08d993ebd4f8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:35.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200096
X-Proofpoint-GUID: O8CR2FgXzeBOKpuChDg26OmnN3YfwAlC
X-Proofpoint-ORIG-GUID: O8CR2FgXzeBOKpuChDg26OmnN3YfwAlC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce clear_page_uncached_threshold which provides the threshold
above which clear_page_uncached() is used.

The ideal threshold value depends on the CPU architecture and where
the performance curves for cached and uncached stores intersect.
Typically this would depend on microarchitectural details and the LLC
size.
Here, we choose a 8MB (CLEAR_PAGE_UNCACHED_THRESHOLD) which seems
like a reasonably sized LLC.

Also define clear_page_prefer_uncached() which provides the user
interface to query this.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/mm.h | 18 ++++++++++++++++++
 mm/memory.c        | 30 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b88069d1116c..49a97f817eb2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3190,6 +3190,24 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
 				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
 }
 
+/*
+ * Default size beyond which huge page clearing uses the uncached
+ * path. We size it for a reasonably sized LLC.
+ */
+#define CLEAR_PAGE_UNCACHED_THRESHOLD	(8 << 20)
+
+/*
+ * Arch specific code can define arch_clear_page_uncached_threshold()
+ * to override CLEAR_PAGE_UNCACHED_THRESHOLD with a machine specific value.
+ */
+extern unsigned long __init arch_clear_page_uncached_threshold(void);
+
+extern bool clear_page_prefer_uncached(unsigned long extent);
+#else
+static inline bool clear_page_prefer_uncached(unsigned long extent)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #ifndef clear_user_page_uncached
diff --git a/mm/memory.c b/mm/memory.c
index adf9b9ef8277..9f6059520985 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5266,6 +5266,36 @@ EXPORT_SYMBOL(__might_fault);
 #endif
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+
+static unsigned long __read_mostly clear_page_uncached_threshold =
+					CLEAR_PAGE_UNCACHED_THRESHOLD;
+
+/* Arch code can override for a machine specific value. */
+unsigned long __weak __init arch_clear_page_uncached_threshold(void)
+{
+	return CLEAR_PAGE_UNCACHED_THRESHOLD;
+}
+
+static int __init setup_clear_page_uncached_threshold(void)
+{
+	clear_page_uncached_threshold =
+		arch_clear_page_uncached_threshold() / PAGE_SIZE;
+	return 0;
+}
+
+/*
+ * cacheinfo is setup via device_initcall and we want to get set after
+ * that. Use the default value until then.
+ */
+late_initcall(setup_clear_page_uncached_threshold);
+
+bool clear_page_prefer_uncached(unsigned long extent)
+{
+	unsigned long pages = extent / PAGE_SIZE;
+
+	return pages >= clear_page_uncached_threshold;
+}
+
 /*
  * Process all subpages of the specified huge page with the specified
  * operation.  The target subpage will be processed last to keep its
-- 
2.29.2

