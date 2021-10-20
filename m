Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09674350DD
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJTRFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:05:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60764 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJTRFn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:05:43 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAWS9000747;
        Wed, 20 Oct 2021 17:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=47AdVQnP4lNzmxB3zj+2p4Hs+N625Kmd3Mqcswt0ifw=;
 b=cBAIws8S/hN3oC48d9HONtr2IdBk3c51s6/4V2Y4FkYwqdoq1zySuDgd4H/Ydz4k3PYn
 ctw7+BVu8NFluZueAKp3TnZvsdtGT5G/JIpofrzNS4fG3VMN4dCYqwcVgMCXLmgRJCZl
 zsIZdXx/xhJcvIC4GPWu8fWfCXNn4GPteXFBGB5t9orOdoY/UDxHHgoBcCG6rHUXEUEI
 dbIj44tRR85/251rzzBhOENWoO+sPbR5QSC8ZQw85xt3jy2H//PojJ0glR6cdKaa4Bu6
 CnOUG9JTQnoT+OeKcsJtluHRne1ewERbPykOHwnuJ0I2NT3Vy1L03gfxr00DcNkT9qo1 YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4sbwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:03:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGtbM4104587;
        Wed, 20 Oct 2021 17:03:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3br8gug2dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:03:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB9NH3BCiEUznkCrkn6wbwVYwF7vLXawPWVfCp3pPmZBBRsL7rMUY/NE+dCTY0V4VyYq2VJXdloD8kCV+2M43YS4N+W7egT5TAcwlmP2ZRvz9vEi05Mp6KUhCawxMwBZG3B7kBwhxlqAvFnXITxyTCO/Pxvrrfxn0d/1n6sMQQGjLbP0rVOBOHru4eL8kcCHluTqFR55NFTIJJOhagnJEN3a8v6aYws5HmTOhEr14JH3xWz/3yUNn7El2aXeD9ZtVLWk9enRsFtAGxHDz2RyTjDKA0EX7YPGpcDU1cAbCF0u6ZOTBoeW4XKqf6o+qMyguBcWQm4uPGJrVfij/0l5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47AdVQnP4lNzmxB3zj+2p4Hs+N625Kmd3Mqcswt0ifw=;
 b=g9/tS4UywnblCln/gbOchwaArni7IAxSjPKuFhc+WB/w/b2v4mQnsTj1Ktmi7AyOtEVNCuaH6tBgfp4z4lwGVPQLp+EpmY/AZpDYVUrS287FFNnozLGfOWxNdwK2D6YD3XZA0kHHgyynP7uGPjFMsGJBmiw8aIMbwA/1qaEyGATCl3znKfWnnr3uKaKAw8Y8IbY++AVpwwkeiVYXiw6fwcnjDY38HkFdbNkc+4ED6D+IsTQ5r+ROr0VBTlf//znu//XmLjBdd3hqsStrxqSzB151xDg8fUWpMtjLfmb8XN10WV1RTqxfxwRhiLT/7KmiOIP6oMN2bLdielPKlDEmzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47AdVQnP4lNzmxB3zj+2p4Hs+N625Kmd3Mqcswt0ifw=;
 b=udxgngcT/Ld50r5+wPkJaE6B5BGb3Iu1eCIvEBCoE68ZO/WKFjbJvUnHaBdgl7n4swImMYXp40gaBsdbaYi/R8jArDYdlTDO8yDMfgOrR8bvHiJHjoC5XE47qdYGEg3W6CZTC8nh9+1uX00a7BfWZDUjcL9bgj5DKdtC/98miGo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (10.242.164.110) by
 CO6PR10MB5571.namprd10.prod.outlook.com (20.181.96.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Wed, 20 Oct 2021 17:03:10 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:03:10 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 01/14] x86/asm: add memset_movnti()
Date:   Wed, 20 Oct 2021 10:02:52 -0700
Message-Id: <20211020170305.376118-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0171.namprd04.prod.outlook.com
 (2603:10b6:104:4::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by CO2PR04CA0171.namprd04.prod.outlook.com (2603:10b6:104:4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 17:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 798c735b-a590-4567-c9ba-08d993eb7ee4
X-MS-TrafficTypeDiagnostic: CO6PR10MB5571:
X-Microsoft-Antispam-PRVS: <CO6PR10MB55710C3118E91F0EC4F0872FCEBE9@CO6PR10MB5571.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OOBQyf1Veahj5ejDVCtawzXtExz3dJnu7EACwS5DbBCzglEZfYhj8bUYF80i?=
 =?us-ascii?Q?tOOzfAroLQcZpWz7ITioJ9P5o/AVy017QwfbRLMh1x+o7hGpOeR1o9/Z1Bd5?=
 =?us-ascii?Q?pE56AmWYgCoOINIcqbopZ316poRecd17M4k3wtHrAlxcmSOMjA/saZ3cch9X?=
 =?us-ascii?Q?WCJYjN5Ij2ny//UqXD56WCUWTJgFwxImO+653lhU8cmkF+rpCCEqNFEl/I1m?=
 =?us-ascii?Q?I+B77SYxQ/aJodVQVkJLGuHlo2ex6/Pt6RSqDS320m1B1YeUQ/YKq5mKWieB?=
 =?us-ascii?Q?jb3YH1Tvg/xV0Lrzh7JIHiMch+nnj6HWf8tn+1B+k2xuKd0SF2F9914jcmxc?=
 =?us-ascii?Q?le0+hbIqfVFFrrw9kWMa2OCTLrHNiQvgRSmNMocWG7zLoP6pXAeXqRCHfIOY?=
 =?us-ascii?Q?cu7QziC+8akwpmmgLg733PZN++DBiin7k/3VoPhQHGbqkyCuWN2oX3OqRR0O?=
 =?us-ascii?Q?RQCvgsZxXAnP6qnonWhIeWcIwi9kGR4s68MbqNqEHghYGGchiN2cnVHJ1Cik?=
 =?us-ascii?Q?CCD2/BQqLWHs4Sffgas+Oyskjjnxp7OSrPbjEQwMtIykjDgYwC64LDQlxrH0?=
 =?us-ascii?Q?zki0qoYjQK/c7GYfXotGOo2IVnmq6GF+I6lMXUjeeX3h4WOQ6ViS39aMczgi?=
 =?us-ascii?Q?+hHXKCsg9+fubFXvjkvE5Tl0EalpoNZxJEOC8JaCsIrMnyEBKACE+7kOvLNz?=
 =?us-ascii?Q?BV9zd/yORFl/4JICYIrM1icGkbPYXyhsAZskMb8Hu9QC0Du1mZUQUG7+GX5Z?=
 =?us-ascii?Q?9aGqJ95nkifF2y7aRi7SE/q51moEZcr7Efqvic8keM454KDg0ko95won9O5u?=
 =?us-ascii?Q?wkJPzUWStqftNkyzMf/X/m/MkF1H+CuMBsNhdC8C8eY6mJvLf8Ahf68w9mK1?=
 =?us-ascii?Q?j5hn7bBRCPvJndsZYLEfoBt66Gyph21R/bFtzcw1+Mh/SzvLklQjEoZsvszY?=
 =?us-ascii?Q?RkF1j9WpKALVczkpR07UCQ8jsW3toFxteMTOd8s7rfF1l6XG8CcUgvqiw9ES?=
 =?us-ascii?Q?ZEXRS8qLiz+AnsEe8D24dhLii8bq58woFjv6yBZ77875nBs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(8676002)(2906002)(66476007)(6486002)(103116003)(66556008)(83380400001)(1076003)(956004)(107886003)(4326008)(8936002)(5660300002)(2616005)(36756003)(6496006)(52116002)(86362001)(316002)(6666004)(186003)(38100700002)(38350700002)(26005)(508600001)(66946007)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A8hM6yKeqS90CpPbavMSdvPVufq+XMmxNS6GuTgJbNYGDvS7bR6BwtT4ImPW?=
 =?us-ascii?Q?Xn3b5PrMbLc1snMauDraUoThxskQ/msRTc+JoqsQoF5VKvTKq+KmyS7DBbae?=
 =?us-ascii?Q?11jTN7vvZ1AUBOVH1Yp8al+7hSHFSbOJ5AkIa4SVw07Ht79iMq64Uuxj0Iws?=
 =?us-ascii?Q?gQVO60X9yJDlbzGjEtFn9Pu7SOCR4Niso2NVmuQBAdzKQ8bcqO3VMOUITe47?=
 =?us-ascii?Q?IMuQ4iTPOIiwxC8mEswaX3ySbwyFg3/CNVP8LEpEpoMS/0M7IXJF/PmCbCay?=
 =?us-ascii?Q?4umAV+Jz2joLV6fYE5PYPuZ0KGwTV388Ykl5VqygwGJWGX18a8UJZ42sSwS0?=
 =?us-ascii?Q?6+VQ0qLnHUvob10EgWSm4bvHET6Nv1osm48BEC5ddgdsescvC/5QwsUDb5IY?=
 =?us-ascii?Q?NauadeXupD/c70U3JiulBAyEKGOqNB7NfY2pQhKYuCSrdJA6FGoVfaZZaGI1?=
 =?us-ascii?Q?G5q4iUy+lLu5Fa0dYP5NQyVokcGj0eUDDlwsYFgxZeCXhYS8gWQARvgo5RRd?=
 =?us-ascii?Q?g71WeCDjVvSpspw8fSVdEp8LJdJfHppt8N7cenuHmWw6ad71KHGQCAa4SG2t?=
 =?us-ascii?Q?jQayeIQ3zgy3HN9AAdYqzu/u8T7Xqtag2CcGXjmzIh4Pnmo58APlVNxbS5iy?=
 =?us-ascii?Q?bZy3I71ENFf/6pdGpsuC8RKmjwuWjhJpRveV83lo/BD4SQf75hBuaQrzbPv0?=
 =?us-ascii?Q?4k2UF1RcMq4pJ39mIyRkTwbK1OH31XJzP3ALEnZovWfE+gNyUaPu6dt/OQly?=
 =?us-ascii?Q?B0ZkSIBQoJwcUK7UxHcQmWJT2sKau+U2U61tG9jE4m6oTpDmJG4StDZqOKuj?=
 =?us-ascii?Q?OwwwCGKNpvcDPauPNKfRVw2FpXZ6phBC3Ha1j6/FfqYv9H+5iOQ+abMavldr?=
 =?us-ascii?Q?3BYaUVrP8816lnxFCCcPfBbAjCLT9TOaUmzqGOB+YqKu0JdgJixKVYlw+XUW?=
 =?us-ascii?Q?3zaf54zQUJqH1GwBkjicCTOQk2fvUl5ge3n3YriYd/BFTl9KpqkwMSEwMJZF?=
 =?us-ascii?Q?ZgS4Syr4dySwqwtmQcV3SDqKXwIcMaFcfPjOEc2xLBmrkr/xW57x5S8jrmsB?=
 =?us-ascii?Q?sBK/l9JbVn2fsiA3AOdP9rWVVviY1tu2yRTmQnIU9FKWw+sc8nP7/Tf3tSP6?=
 =?us-ascii?Q?8Gs52485u3uiBMc2KEtM9e1f/+A9j2cb+PoKPkkv0dV2EZa99gH4WhTqtJ6X?=
 =?us-ascii?Q?ZqHATvtoSdFlsVOMTk5aj9nMxwBFnSdMQi6jNrtRQKRx1aqZLLB9el6CYd+e?=
 =?us-ascii?Q?QZiViBUvqEnlnVcONgcR/C6eUPMABRrDzsSkRl+dH7c1aawBjYw8jl1qbrzo?=
 =?us-ascii?Q?ovM/WBBdfaatFZotdFdrhWWlCEf+DfBMRTk6qpDKkTHPgGa0RN028a9n3xHf?=
 =?us-ascii?Q?ZIcQ9nnTUiHtW0ZtpK4l1bPhnsGN4Bv6NlIChbdqesKE5Hr6iCzV2GDlzFLp?=
 =?us-ascii?Q?0A4dSNeaRCWXWXIfRoSt0VHj6tUYLTiM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798c735b-a590-4567-c9ba-08d993eb7ee4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:03:10.7476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5571
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200095
X-Proofpoint-GUID: z-Xik7QtdNbJ15_qUVfD0JCRBDggSbFO
X-Proofpoint-ORIG-GUID: z-Xik7QtdNbJ15_qUVfD0JCRBDggSbFO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an uncached (based on MOVNTI) implementation of memset().

memset_movnti() only needs to differ from memset_orig() in the opcode
used in the inner loop, so move the memset_orig() logic into a macro,
and use that to generate memset_movq() and memset_movnti().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/lib/memset_64.S | 68 ++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9827ae267f96..ef2a091563d9 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -25,7 +25,7 @@ SYM_FUNC_START(__memset)
 	 *
 	 * Otherwise, use original memset function.
 	 */
-	ALTERNATIVE_2 "jmp memset_orig", "", X86_FEATURE_REP_GOOD, \
+	ALTERNATIVE_2 "jmp memset_movq", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memset_erms", X86_FEATURE_ERMS
 
 	movq %rdi,%r9
@@ -66,7 +66,8 @@ SYM_FUNC_START_LOCAL(memset_erms)
 	ret
 SYM_FUNC_END(memset_erms)
 
-SYM_FUNC_START_LOCAL(memset_orig)
+.macro MEMSET_MOV OP fence
+SYM_FUNC_START_LOCAL(memset_\OP)
 	movq %rdi,%r10
 
 	/* expand byte value  */
@@ -77,64 +78,71 @@ SYM_FUNC_START_LOCAL(memset_orig)
 	/* align dst */
 	movl  %edi,%r9d
 	andl  $7,%r9d
-	jnz  .Lbad_alignment
-.Lafter_bad_alignment:
+	jnz  .Lbad_alignment_\@
+.Lafter_bad_alignment_\@:
 
 	movq  %rdx,%rcx
 	shrq  $6,%rcx
-	jz	 .Lhandle_tail
+	jz	 .Lhandle_tail_\@
 
 	.p2align 4
-.Lloop_64:
+.Lloop_64_\@:
 	decq  %rcx
-	movq  %rax,(%rdi)
-	movq  %rax,8(%rdi)
-	movq  %rax,16(%rdi)
-	movq  %rax,24(%rdi)
-	movq  %rax,32(%rdi)
-	movq  %rax,40(%rdi)
-	movq  %rax,48(%rdi)
-	movq  %rax,56(%rdi)
+	\OP  %rax,(%rdi)
+	\OP  %rax,8(%rdi)
+	\OP  %rax,16(%rdi)
+	\OP  %rax,24(%rdi)
+	\OP  %rax,32(%rdi)
+	\OP  %rax,40(%rdi)
+	\OP  %rax,48(%rdi)
+	\OP  %rax,56(%rdi)
 	leaq  64(%rdi),%rdi
-	jnz    .Lloop_64
+	jnz    .Lloop_64_\@
 
 	/* Handle tail in loops. The loops should be faster than hard
 	   to predict jump tables. */
 	.p2align 4
-.Lhandle_tail:
+.Lhandle_tail_\@:
 	movl	%edx,%ecx
 	andl    $63&(~7),%ecx
-	jz 		.Lhandle_7
+	jz 		.Lhandle_7_\@
 	shrl	$3,%ecx
 	.p2align 4
-.Lloop_8:
+.Lloop_8_\@:
 	decl   %ecx
-	movq  %rax,(%rdi)
+	\OP  %rax,(%rdi)
 	leaq  8(%rdi),%rdi
-	jnz    .Lloop_8
+	jnz    .Lloop_8_\@
 
-.Lhandle_7:
+.Lhandle_7_\@:
 	andl	$7,%edx
-	jz      .Lende
+	jz      .Lende_\@
 	.p2align 4
-.Lloop_1:
+.Lloop_1_\@:
 	decl    %edx
 	movb 	%al,(%rdi)
 	leaq	1(%rdi),%rdi
-	jnz     .Lloop_1
+	jnz     .Lloop_1_\@
 
-.Lende:
+.Lende_\@:
+	.if \fence
+	sfence
+	.endif
 	movq	%r10,%rax
 	ret
 
-.Lbad_alignment:
+.Lbad_alignment_\@:
 	cmpq $7,%rdx
-	jbe	.Lhandle_7
+	jbe	.Lhandle_7_\@
 	movq %rax,(%rdi)	/* unaligned store */
 	movq $8,%r8
 	subq %r9,%r8
 	addq %r8,%rdi
 	subq %r8,%rdx
-	jmp .Lafter_bad_alignment
-.Lfinal:
-SYM_FUNC_END(memset_orig)
+	jmp .Lafter_bad_alignment_\@
+.Lfinal_\@:
+SYM_FUNC_END(memset_\OP)
+.endm
+
+MEMSET_MOV OP=movq fence=0
+MEMSET_MOV OP=movnti fence=1
-- 
2.29.2

