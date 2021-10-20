Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16F4350EF
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhJTRIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40258 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhJTRIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:07 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGGQE7029728;
        Wed, 20 Oct 2021 17:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7IgdtqonAs/0Ndhh4q9aioh7d3qlI1VLPGxojSk388w=;
 b=Z01FL+/DFP55lUcksOafe5N5upXXglSjCuq38D8aXNbRqNZ+lGwTy+euJtZrWr46d/o0
 q2D07N8DdhB1B5tC2P/hNV91h6SsF9nKko9U+nRmgB7NszMN4TyLEkjXm8Pvv79gdPUW
 XXvu9TRTD/n7FFRaITkMzj+6Uf/M6I7PkxvIBoD6uDKBEKxeyqnctDE7jCcdkSitbSul
 yefKkst9sMQynamAbHVAE18q6oEMDB9R47kfJu4xwWwDNtiGAoVxrKm3nq7MBHOa7Yul
 cFyuL/IMFQIoiYhzO8AUYNU6wSTNdeFndm52X9HI81ghi7NQGFK8GyhLU8+6xDAKU33K mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj1b8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZjV005950;
        Wed, 20 Oct 2021 17:05:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 3bqkv0cr90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjxvqqc7KUUaoQv0Oo6K8PJQ4r//Q59lsSs2X26JfJM8VeAgliFueJMCrLG1Mbfs27jlzReDISMBRrtP5n09BtwSbtfmkJw0tMH3aCv21LcHYFqP0h4ASDc053uBmG404m3f0XNgx19bVo/C6K+NRvwvAr4W1VHAKZpRtDgUpqi63yPRr0zu7U/4rSbuu54Kw7qTvqmW4RpCFUf0h7JdN7xKslKpQ4FIVte/tJxNKjg6ai67xKLpm7dYzhTe1dd/IfybAhbsqzuGwvPLDV8OCJlU0nFY5DNIRk2P3bigyeZjWSASjbVmb0znP58xFZBBZjkv3iZ1+v9cu6vyi2Clhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IgdtqonAs/0Ndhh4q9aioh7d3qlI1VLPGxojSk388w=;
 b=bQrKiqhilg2Due7oXLDrVclfs8/oO/mrKtGIHW0xRbmEUSrlMEQb9oCJChNlCRDzeGD8ypqRkyo/nMLuQzI/fPQHWOHlwLOt9D5cfL1xhD+ryaB2lOtUl6XFEvcJ3cDpsyRnqD4KRSH7PzVxFG2xAmwqhElLGXi2DQWqRz0qLrNkK28PANcFnGxiPcHZltOQXV1mshWJC7i56P+HQoXEW7QZ3lopSBbqwNWzMCD9nOnRRdyTnoXTbEJVKFARAfl9DJz30ubaf9Q9tUr5/lb2JioLg7b5jhgO3L9DUSfhX3Np7PQl8bz777aLLXQHWJDOSRUsYZzgWIMlO0tNaqJJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IgdtqonAs/0Ndhh4q9aioh7d3qlI1VLPGxojSk388w=;
 b=pEdpD/BHvL+xJCCl6egG57IfG1rJYaNXGGRjk+/0ZI+2WBQxjtZivN66cuaoOCwHYt51sixz5Tv13Idi/e29pl0KiBxPgcTIvigPgI2dgZfNIKcTIeE/Hk6bzrIA9LA6Xbl82jg3GLjhdO6ErRjQRG5A9XavAPJ7w1LzHJsfGWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:42 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:42 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 11/14] gup: add FOLL_HINT_BULK, FAULT_FLAG_UNCACHED
Date:   Wed, 20 Oct 2021 10:03:02 -0700
Message-Id: <20211020170305.376118-12-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0106.namprd15.prod.outlook.com
 (2603:10b6:101:21::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by CO1PR15CA0106.namprd15.prod.outlook.com (2603:10b6:101:21::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 17:05:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 242d4a96-301a-478c-2054-08d993ebd91b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45777815D8F6475F7F888283CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iWAxqm/g5cJSctJvkFP9YR7MOgUBIP95xAUR+WnTwhVq9ddewP7KaQ0xjPOF?=
 =?us-ascii?Q?gr/niNtckjYREytw/cWLy0rQCBQgJIChPqM3fv8iP33+17keYM21PQg0SfaB?=
 =?us-ascii?Q?upcg/TZH36UOh2MaFjRdP3376wO0FNg6SLmKBmalytbEeLFmVxkCWN0wihJX?=
 =?us-ascii?Q?Sq+WVGpd12trOs37oy2ac+yOhr6KcVK3yxZYcsvjZPWAVeHYHlI0cGpp8JU/?=
 =?us-ascii?Q?X1j/sBY/0pTeWZ8K3EuEfcRGG9W8rIuCr34uZz1p/0F3itxoCQe5BgT2dpCR?=
 =?us-ascii?Q?c5O+K94npzSOWWNACA7zac5SqcnFXsZKzwTUF/O6pe6DjY9D5e0c3QQ/qsGv?=
 =?us-ascii?Q?x8pZ2liASTyM5CehFZVLfxJ7MQlTGtYp+mcd+0x/z7zKimNCvcwtqWYWf+1l?=
 =?us-ascii?Q?N0IQaUunIxmqHSxt2Jn9CLFs7QTjY7dFqvZw70SJ+M6Dl+Oyi4ciV7wKRwVH?=
 =?us-ascii?Q?CA2RTbCOpXRE5XhoVMoZNUXWQ0yOUO34GyF3pOUHRDSe4eG0mRTyni7Pvy9L?=
 =?us-ascii?Q?AB5EtuL1ohRrFVFwPIYx4PBvSJAE9yQXQ7lG0JvJRGygQktofB5Kx2aA1cVb?=
 =?us-ascii?Q?Z2rBEK2UCYH8pOPNwozXYK6d6xVbYDj7C4x39fWNuRp6OXfXRYhtoyj21gCY?=
 =?us-ascii?Q?8DNwfIyAOqghHrARsRVXOk8SkM9SCNIDeFAO8tU/ECb2SuK0yWFs3r1RQJps?=
 =?us-ascii?Q?nRJv6DQ2sKzaziFhSksNRAHNSLPYuX0phgqcSwDDs4n8cVxgoMl7kdpzJfrG?=
 =?us-ascii?Q?xN0opmjkDbzxvFWC1tFjoXrXAko1t2dNMf911grmPwnaKcCPDUJfknjMyWZJ?=
 =?us-ascii?Q?K6jQV7c4MKrjKRzGsoPhjI0yId7UXHvPtuwUPPV5qmuUbmMAV7JeE2RugwAn?=
 =?us-ascii?Q?2vfqd8zt1U5RMf1/fCkAfOk82fdMWGGB0+TMSbiQfYF3/9srOU4enEpmnV2f?=
 =?us-ascii?Q?UUYjgNevrlfEcVj2FwX1gzjmqHa6ZTuxBBk2V3gn1IhPb+NaU9sReGyvFKYH?=
 =?us-ascii?Q?8YGREpsloATlbjvaH4KDiW9xOk/bwWzrFilK3a9fBTaumc0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BkTCM0pYqw2iNFE2dJaYpp1HQLvEw5dYHTanVfMTMYHB2bhmBLLqKadS5GDX?=
 =?us-ascii?Q?PwSOD3CxnXT99+VL8Kwq8PB2c5YPQybV0qWq8d5bEL1njdaiPEVFUBpr3KX7?=
 =?us-ascii?Q?Ebrfd4vXzEft7WjxE2hSq+8b2utxUy6VkwbWrGyKtXFzSWUg95heXcAGThxK?=
 =?us-ascii?Q?RukRejqsn9kCmZY+PRgCgZQYZDcoD1ESbPPUBDUi9ZWSqScOR46cnEFnwV0s?=
 =?us-ascii?Q?g4v3wQTzGVIwSjRb07Q9G/Vyr3EMUjC3dHnAPpMpXvKfv+KQUmYkPbahGiy7?=
 =?us-ascii?Q?EOH3WrUSWPBHq4Wx+CB5//eigzHYts6XK6duFoTXADfs8dYfQaiBegS0MK3B?=
 =?us-ascii?Q?HIAVLeR3zd+9+RzkrVy04DRrTViPH+d7f1Zh9daniIamJgkWAotiIc7OTWk/?=
 =?us-ascii?Q?zTc94Ztf5+WIrrMh8zXZkMFXILzuT5BJqxZCGRXAco/6m2cBFnabywplRc/8?=
 =?us-ascii?Q?MSpGAPV/Newb6/SuaC/dWdVegjaPqKNsfy0z4UmfZnNHnjVi9b4Ub/1SqaaZ?=
 =?us-ascii?Q?wRyto2ZG9Xyhr+3z6JApYqieGOmcz9HeaGF9BP1t16H7Jr/prXeFY8LCyHBr?=
 =?us-ascii?Q?/yefgzeC+UTI3zxa6nZj/fK+xHWshw35PuJdfD2c6/J0k3LeCrY5S/VCAwxN?=
 =?us-ascii?Q?gXkETR1KoTgaBvu3jGq/7EOSklYcJi3x3DOuuPrpyluOXEoBmpjZWFg+M/2+?=
 =?us-ascii?Q?TQsHS39S4O8XSb0c4xG4y8USiV4GAIOr36uOhKbCjgp383steNt/1TLFRlsx?=
 =?us-ascii?Q?2VGN1vZi7UC3tOOkohx04PH/peGYKwPaP62C2BZesymfuw+JL5hW9folKSKH?=
 =?us-ascii?Q?T582I7w707dbt9NqnZwYHYXRAxkmlciud6t87Gi79metQmuWEijYS6LYk7Tn?=
 =?us-ascii?Q?74QzcGQkTAYQX6iuKOMiPS2MLSwPvUXjKMv5QySZ0lrca8xAR3jQiuwSyWmh?=
 =?us-ascii?Q?O1U1IxswqTYghc5KWWCPAkBUj3RCMbXaVfjK3VPzu1YglB/CJKebkHj8myNb?=
 =?us-ascii?Q?W50fkOjxu4WM4vAnfhI75rqyN4do7VH3Y9yAeP3GOktYNdEWnO1/7l+gzJSG?=
 =?us-ascii?Q?L7Jr+bqMBTnzrs7Ukg5EVRMqd3XGwe5bz6VTlNOo9J//TRvlGKkcSITyLG++?=
 =?us-ascii?Q?mibJDV8LCdNOShfjbWWdX9vDWfeKBy4w+FJwDIK5qlJQqIaYWzQSJlZfD2br?=
 =?us-ascii?Q?/xvTfixnRoM35Nk0KGaZiuz6EPkMyqpT9YacLY+vwDAxllgnPiucvH483MKX?=
 =?us-ascii?Q?5qWq1z1VtKSQsnkQtS8N97Sg6f/xlJkijSplrNCHChKFAyyE+6swtw174ERQ?=
 =?us-ascii?Q?Gof1K69WyYmFlrcpvkDFH2txfrmlhJQZMbuY2/WI6sZ2Phv5yiZh7mVkNf6j?=
 =?us-ascii?Q?jjXQiVq3QUwVcHA2+aX7kaRb0hoEzqk2QH8K8a3EqrWuD9BnXYR9VgF0n7uB?=
 =?us-ascii?Q?sYwtCbhxBVz/gbigwWuNt92TZB15Ju3N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242d4a96-301a-478c-2054-08d993ebd91b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:42.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=780 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200096
X-Proofpoint-ORIG-GUID: V6tEJ0QDJr63PMwHFdV5l7BDIBeZVBW9
X-Proofpoint-GUID: V6tEJ0QDJr63PMwHFdV5l7BDIBeZVBW9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add FOLL_HINT_BULK, which users of get_user_pages(), and
pin_user_pages() can use to signal that this call is one of
many allowing get_user_pages() to optimize accordingly.

Also add FAULT_FLAG_UNCACHED, which translates to the
same idea for the fault path.

As the second flag suggests, the intent for both is to hint the
use of an uncached path if one is available.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3e8ddec2aba2..cf1c711fe5ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -446,6 +446,7 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ * @FAULT_FLAG_UNCACHED: Fault handling to choose the uncached path.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -477,6 +478,7 @@ enum fault_flag {
 	FAULT_FLAG_REMOTE =		1 << 7,
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
+	FAULT_FLAG_UNCACHED =		1 << 10,
 };
 
 /*
@@ -2864,6 +2866,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_HINT_BULK	0x100000 /* part of a larger extent being gup'd */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
-- 
2.29.2

