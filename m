Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3674350EA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJTRII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57820 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhJTRID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAHxn000751;
        Wed, 20 Oct 2021 17:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sKUss4Gz6R671I1BdNoIAj3WU6QlaFJoZXbDohc01gM=;
 b=BdI33MnQ7S0hfhVWTwlA5nOAFCHV9DbJDOdtu6V+v6tdjKQ8M91+hWM6SdlTO3xfm6lt
 CyLk9em6a08Ezb3HPcfbTCBAcmk/vSwe9ixiuWAuSzt0cOW7U3Gz+l8BVQubWKjeNvgb
 l4xJCtAkB/lPws1eZgRBM731FjzaVtXfTvpfmNfx19E/SRdnR631w0s5w32nRSSNPA7l
 W0SonZ7A6vIjWn2HA5lklAAAoTGTgz3rRHyV14TY8G8Kqml5ealRU5o324tN5zGFFYuX
 P5AXTmOQy+XvmkInkXUonkXbBUQywAwXAT4TvttX1qtitkywAkcAhuw9BOHdr7gimsOm cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4scdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCU005957;
        Wed, 20 Oct 2021 17:05:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gze/OCUlGvRi/iEUUt9trVFej3uR3SCNEFNq6lenkjGf48/zs5nU1vaA2jB5xBz1A46n2sS9obIVNDZC3AUfgqiUZ6XCJaQQfSx+Eb0F6lId7OX0zAlaWVn97fnHGEIMSzqRqG8uhu7fqhmqyEgC9iQJHkPBW5NYwu3cHv0DAi8r0I4t6VMymrn+kuekjAzM6x2dYcInVzrUKCsopQ0esrVl/apxIR4HhPupnBH5cv8+gkCZrL8s5zAqM8q+FFIDeEewh/V73D03sqsMN8cs8YRFI9HMRKPY7P1thFt0+yoxHJDByD/mXESpHSJK1qb0cR6Xvrn0a8zigcLrjdfAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKUss4Gz6R671I1BdNoIAj3WU6QlaFJoZXbDohc01gM=;
 b=iQ7IKcb2bCCvc54zLdJ2YktTQVM+ZSElj55IDH+aIb17flONnALa70mKoA7oZJTvITuLvL70J68UVNOsIkP7bdCbhl8p4Mo/UCojiSNuAd9j0eswZ6QQ0YnH1xl2vaWAQ6MScpyoURR82jcCmkvABYSpWeMIDQ9qdLehvl+6D0+5hAEexLtXP7MXW+K5Vd/laoTmx2exUlPmDjcYJn7lw5SXSnVf22BiYuD2oCHXrV59YqiBU9OsK9Ae5dvY7uQNgB/UA3D9abp+O3Puo8mOhUY+E3C90+xMDXjg+hZHcs+D38KR8fz5GHoJoF6qMa2sbdy2/6U/dI1+5pO69nVkRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKUss4Gz6R671I1BdNoIAj3WU6QlaFJoZXbDohc01gM=;
 b=RdBtzC21wrI6oBg2mLFz1Hd0FMEoIPgo2NmMPFPWVj15YbN1+GBY5W3aEHvDmRCZntmuGKIpHcaF+18j+kIxzxjLK9TP5HUMyp/ybTYF8+66YwIXhXbJ2BwFi7sZ1FwRrDTIeVYrfY5VM07J+3nCPnLzv71QR+Ql9al3IS3dIN0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:32 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:32 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 07/14] x86/clear_page: add clear_page_uncached()
Date:   Wed, 20 Oct 2021 10:02:58 -0700
Message-Id: <20211020170305.376118-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0066.namprd17.prod.outlook.com
 (2603:10b6:300:93::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MWHPR17CA0066.namprd17.prod.outlook.com (2603:10b6:300:93::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:05:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc183e7c-0ab1-4879-33b3-08d993ebd32e
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45771C5798A8ABE2B6571938CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PzyD+gzhKVxvAzHeIqFkRK/Isr5XD8LVAnxYCrumwRoX0yrzUnoz+/hATToh?=
 =?us-ascii?Q?RPjI+B+WH8o1tW8eZ8QcHpNB8VOXx5D+bCaLR0hB7PxnB5bIHYFh/g5LIo7K?=
 =?us-ascii?Q?PwfjT6EpViMtp7omxlqVX+n9VQ3lQnYayiXIf0LEvFp2b1LrfgBuhXvnArSi?=
 =?us-ascii?Q?KbIodSc0EIZGwWZ7ASHcfkskshbBOo/61FEzswy0Qyqry+zfBm8HSf7BThHQ?=
 =?us-ascii?Q?CmGzpI4tDJJomb4kHMtNTi2BJyg58OpI4/ayS/W/RmXX2VuNBH51SEH5Ergb?=
 =?us-ascii?Q?Joi9lI8zzm76P3RZo2ur+TX1G9PLTWL/ri1TJxT15A0+wKSQkRm/y2SqRASz?=
 =?us-ascii?Q?pFsr7jQPinEAz2htMqf/1xGeg9D3DzZUs87Iqj9vMXoqJ8X62RVpg4cT3wii?=
 =?us-ascii?Q?BiYhs9yNIU2tWAlAksdTfGQwMGloVfVlrgwDIq/zmmB1iGpwl4SpAP8GJRLf?=
 =?us-ascii?Q?vXdgIS//YmLw1cLpMeK36hmLohX807eCHtj/5drX2FcvPndTSSGnZD12MmiN?=
 =?us-ascii?Q?OwdDtrvcQd6d0AatiM5myYOXMSOvWHA+Bxcukrp7LSWnhl2YdFbeovI844ey?=
 =?us-ascii?Q?XJ66LmDo75vQmlIYBuWYPwMT1R4mR8Z3sM2Rf+nOY+Ye9kNUC2X/UymzEwyR?=
 =?us-ascii?Q?8vYxFA8vjkBDjzZ5ZAadeb1szhlmNmx01MwpH4of3LYXufDH5X6YuAiimScE?=
 =?us-ascii?Q?vKvlQMECiVIFrPVYuWKn9f80UTgOieaiwfqhhiiUvPvwHnrdFhItOytKTp4f?=
 =?us-ascii?Q?CuDkOS/j6av+TK2j8Zlz3aPh0G7pbmJO3I9KNY5KjM46hr3iavLL2havWiY9?=
 =?us-ascii?Q?YnGC0AJbCQXb/nvzD9y88Y0V/hBStBMlxOrhUUt0PhtKayMyCA9OoAKaECgF?=
 =?us-ascii?Q?MQV4O5XK8UFkAKOtj4RU2cXO6V6nK4NHdiwY2nrAazIuxS6NBhNXeyWu9eQr?=
 =?us-ascii?Q?IzYJz7OWNdufAGMQbaRHFdnCep63/xs5Swic9w93fuN7XP/z8PfyYaZSU1Ky?=
 =?us-ascii?Q?SBJQ+NOPRDMErRESE5aWpONmUAO1nnHQ3cTpp0Tvz/04+Zk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qjutq1i4NAZfRUUi3WER4xZt7ZDXjLiEI6GT87z/TXRIwUlOGdCkdRC1PVCk?=
 =?us-ascii?Q?oFtGomDjz777jAJoS6jyS/DxmFyUjOUPDLyvSzdORR2bJWP7LChK7m0wD3vv?=
 =?us-ascii?Q?rqFY0S1Hm24aINBYvL2E+W2t3bVA5xxYtaAD+nFCEtb+xVJfqSXNFCGHh1aO?=
 =?us-ascii?Q?yohqGWREMZsxUFzm4jtvIqZPCk0rYp+RnSvbKTD4lowleEmjeu+Y0mQd7xeI?=
 =?us-ascii?Q?6LU0eIpVDrJqgWK2l9D3ynkrDMvcSX8ELyAY0XkdSyAtSAMItDu5fwBl1WUP?=
 =?us-ascii?Q?lf4jfU4LvjpDQ0jXUoAF/FKYoGr80RluWPU44h0ZkfQK9zn/mp/dVmFa5qyG?=
 =?us-ascii?Q?KfwG/rbXLOYKLOBEGKn7o/v25eJDRWonjngkGCPRpx2o8DXrMnqMFJmD/XF8?=
 =?us-ascii?Q?blsnNps6UUBI+PAAQfWvh59VHTnVL9c9Vl0B9kPqtkloY4h8om22KlOVduPL?=
 =?us-ascii?Q?Z2RQ2Tk2FtkJSiztWd75P6Akfob0/S1sbxRpYJsUoRUCri09mSgX8poLZFSr?=
 =?us-ascii?Q?uPonR1j0xmdVf6nHFpHJLhi0iOnAkeziWpIxtFYfKvhAFJaHvqgnRzXpeoCl?=
 =?us-ascii?Q?fwemzTV7jl0+k+EN1T9tBi7t/mj42b4jSUvEUk0nuB3WzA71jGqwytOfJqJF?=
 =?us-ascii?Q?BBlkkaXdiv9lVT0ddNxOC5i9cWf3ofiw5WJU8OXDCcO7aYj3L4wy3PeByzqs?=
 =?us-ascii?Q?wTwUEHmfuVfk1z5rUncNFCimY1gqnqMzjB1paA37DNGiQLcH72FpoMVz5QOV?=
 =?us-ascii?Q?/l/RGjcWxXgADd3vIfrc0hiQ7hU9YrGTb98gAznljJGx2PHEP3pMuHX3139C?=
 =?us-ascii?Q?yMe/JC1ynokPI4k66kuvfhaNK2j3qPduGSmNtjOT+notH76rvva2Xaj03npA?=
 =?us-ascii?Q?bXwag1C2vxiIULRpvbEWaua2VddZQf9WbdH4omy36rZj3qb11VdgIL18GzS5?=
 =?us-ascii?Q?EF+FhZhOzSimEcJKO8Q/kGD9+NgeLxTIT0izfItLULpEeFc8XN9JPtPz+yrO?=
 =?us-ascii?Q?/jOkJVoqZpobk+vVHwJ4VYowRNrZzeq+eDTaBgQyPlcpvR65ULIHKIS/ZUn0?=
 =?us-ascii?Q?rd67s7NtXpRlO9kYWwQ7XlRFcjrXA0sZKPAR1sDCRFlasuUhprviFQ9Lep6N?=
 =?us-ascii?Q?umUQ9rbeiQ7xEEgvUeIkSUD5MDxTQKaJrFkLTOaOA6mO0TvSkanFVjUTbik0?=
 =?us-ascii?Q?hhCC/IZ2hq5iYRJqA58FmSo/9xQGyAVqE9aqnPZLzFnVLUF6RVRP/fAsDPzi?=
 =?us-ascii?Q?bp1ct5DUHfg3tevwU0Te7MfgS72o1u5o1a1QCHwinGg9buTTWamncOhbiDwV?=
 =?us-ascii?Q?/BVSKmlf8rVpMySNvpjgNkIwRvg3irW0cAc6tvAzK+IyhrBPLFGPwafMkvli?=
 =?us-ascii?Q?aNc0d8rFPCy5B/b/CtXnmojSzN4g0BZNMyc7TPLlY+KG/YQ+fvVSJn3laHbq?=
 =?us-ascii?Q?PD1LXtHy1/uXq6OFpe0l6qYyMi5oyn9d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc183e7c-0ab1-4879-33b3-08d993ebd32e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:32.1394
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
X-Proofpoint-GUID: 0_klsLrttWHRi-mcRqsTRI6JSgeVRnkK
X-Proofpoint-ORIG-GUID: 0_klsLrttWHRi-mcRqsTRI6JSgeVRnkK
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose the low-level uncached primitives (clear_page_movnt(),
clear_page_clzero()) as alternatives via clear_page_uncached().
Also fallback to clear_page(), if X86_FEATURE_MOVNT_SLOW is set
and the CPU does not have X86_FEATURE_CLZERO.

Both the uncached primitives use stores which are weakly ordered
with respect to other instructions accessing the memory hierarchy.
To ensure that callers don't mix accesses to different types of
address_spaces, annotate clear_user_page_uncached(), and
clear_page_uncached() as taking __incoherent pointers as arguments.

Also add clear_page_uncached_make_coherent() which provides the
necessary store fence to flush out the uncached regions.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Notes:
    This patch adds the fallback definitions of clear_user_page_uncached()
    etc in include/linux/mm.h which is likely not the right place for it.

    I'm guessing these should be moved to include/asm-generic/page.h
    (or maybe a new include/asm-generic/page_uncached.h) and for
    architectures that do have arch/$arch/include/asm/page.h (which
    seems like all of them), also replicate there?

    Anyway, wanted to first check if that's the way to do it, before 
    doing that.

 arch/x86/include/asm/page.h    | 10 ++++++++++
 arch/x86/include/asm/page_32.h |  9 +++++++++
 arch/x86/include/asm/page_64.h | 32 ++++++++++++++++++++++++++++++++
 include/linux/mm.h             | 14 ++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 94dbd51df58f..163be03ac422 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -39,6 +39,15 @@ static inline void clear_page(void *page)
 	memset(page, 0, PAGE_SIZE);
 }
 
+static inline void clear_page_uncached(__incoherent void *page)
+{
+	clear_page((__force void *) page);
+}
+
+static inline void clear_page_uncached_make_coherent(void)
+{
+}
+
 static inline void copy_page(void *to, void *from)
 {
 	memcpy(to, from, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 3c53f8ef8818..d7946047c70f 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -56,6 +56,38 @@ static inline void clear_page(void *page)
 			   : "cc", "memory", "rax", "rcx");
 }
 
+/*
+ * clear_page_uncached: only allowed on __incoherent memory regions.
+ */
+static inline void clear_page_uncached(__incoherent void *page)
+{
+	alternative_call_2(clear_page_movnt,
+			   clear_page, X86_FEATURE_MOVNT_SLOW,
+			   clear_page_clzero, X86_FEATURE_CLZERO,
+			   "=D" (page),
+			   "0" (page)
+			   : "cc", "memory", "rax", "rcx");
+}
+
+/*
+ * clear_page_uncached_make_coherent: executes the necessary store
+ * fence after which __incoherent regions can be safely accessed.
+ */
+static inline void clear_page_uncached_make_coherent(void)
+{
+	/*
+	 * Keep the sfence for oldinstr and clzero separate to guard against
+	 * the possibility that a cpu-model both has X86_FEATURE_MOVNT_SLOW
+	 * and X86_FEATURE_CLZERO.
+	 *
+	 * The alternatives need to be in the same order as the ones
+	 * in clear_page_uncached().
+	 */
+	alternative_2("sfence",
+		      "", X86_FEATURE_MOVNT_SLOW,
+		      "sfence", X86_FEATURE_CLZERO);
+}
+
 void copy_page(void *to, void *from);
 
 #ifdef CONFIG_X86_5LEVEL
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73a52aba448f..b88069d1116c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3192,6 +3192,20 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+#ifndef clear_user_page_uncached
+/*
+ * clear_user_page_uncached: fallback to the standard clear_user_page().
+ */
+static inline void clear_user_page_uncached(__incoherent void *page,
+					unsigned long vaddr, struct page *pg)
+{
+	clear_user_page((__force void *)page, vaddr, pg);
+}
+
+static inline void clear_page_uncached_make_coherent(void) { }
+#endif
+
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern unsigned int _debug_guardpage_minorder;
 DECLARE_STATIC_KEY_FALSE(_debug_guardpage_enabled);
-- 
2.29.2

