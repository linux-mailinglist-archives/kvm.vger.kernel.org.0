Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95924350E1
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhJTRHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:07:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48746 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhJTRHn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:07:43 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG7wLS020970;
        Wed, 20 Oct 2021 17:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HYcM6BZ37nyeF0LWMaoFZ1+N3j1AvzKq5xuMxO5qdDA=;
 b=laHnXSF3t/aVZYGfT+w1r/U4O4uZi0PumF6NRDoQ6UEqXCkRBR1r2jto3iiBIf3q0Ldg
 UqkJ6tRAk6aDL9yKb4LBgdLSfL9z/RVzLnjTa1jUXoADYzoQTYFr3UCb/oFea9dT+U4Y
 ztyJZxjt9qF3X6R8ttK8XnWTRDau5xupKvNSZaKAF4b61JYh3VHI/f+a9ljl+yvENVNa
 GzgQbKgA09lx0n3DgqPMhIIQ3A6VTDAxw8qYkIHJrRxN/r8/4ScwSzrkeHerfNDUO8gO
 7iiyEGnLJm0fpOcsIS6oQse795texBXPoxxolvKd5/muIWQRN8ujH+96M5tcDvertU/G PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9sfju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGuqlJ024711;
        Wed, 20 Oct 2021 17:05:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 3bqmsgs2u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJccCumgzGV0RpFaMrnGBA1Rqu9h0nCDyb5ME9XCbHvUQC4E4LpLmKIWaKWeypBPLiKo4pjDRZsv987gKiuEvWhP3gAyRkr0N6T5IzvhQXkNKVRMWnsTdp2UhuCCI10JYRv4QO2j5i+9lkXL9U6K9BchKFSYU2nCCsdZXQOiYU205vdYpzZhenDMTx5u9iIYNK+wSX7EnuN8TvyRiXCGjP9o+iZomnJ21uHXGwBcIMbDzrbisofwIZg8VGOUhiT9Qhcp+gNYv1dnP4vUiHWZWI3Jo8sh/xGlQN90xu1U2qDGXt0yzLN6EZY1pUFoCzuCn82F2rhhLA//MhY8rerfYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYcM6BZ37nyeF0LWMaoFZ1+N3j1AvzKq5xuMxO5qdDA=;
 b=eIIvvXZTTosmuSGIbDPP9lRFlCncuAXKh+Yfh9MFVdiRK0Gz7WtQgCiD7cBYBbb3X//Wh1uhr4w2+7rEuldTcppjbl+6FUig+Y3oPgqT7fWXQkkP3+k6cWiFpMqh+Sz0s23yRZUF7b8FcuV+aAIT0Z0H72k66+jvI+LnlilaB/0ZqsAqwlU/GvJWAsZbD7MZEX5yYGj0kNsvjTaUkJvY96oNnXo765AdxxRe/91GOey6sPtwPoYSZFkguPZqRgwxnBp1I4smv3oxwKG9uLWyRXzMYCJNrduQjMwRvlcwPh6sOFL5ymwsoS7JkZ8aknV676B+L3yHciTM6cxYcn6Dlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYcM6BZ37nyeF0LWMaoFZ1+N3j1AvzKq5xuMxO5qdDA=;
 b=0Jx1zUOTPliC4TQ9Ucpm3FMojuIli06QeSR+GXLF0nJUZXt8BU8uhk7OXYNConnk1diI3UffE1XojKj1kVNPQqFqQO0wIbUQjy+GGc89OcBSm4TS/KTLniGEzHnACSvaYjk4vgkIJt+lUk1+MJo24JAWvohrD08r5Fp99B04ENQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:18 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:18 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 02/14] perf bench: add memset_movnti()
Date:   Wed, 20 Oct 2021 10:02:53 -0700
Message-Id: <20211020170305.376118-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:303:8f::22) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR03CA0017.namprd03.prod.outlook.com (2603:10b6:303:8f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:05:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4278fbc0-0f2f-40fc-194e-08d993ebcb21
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45770F10B32BBDA101D74D9FCEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ROqETJxvsNhjHA7Hz5ZQP8AQrZZHltjldhHj2Dz6uys99ooLCuLqL+54awVu?=
 =?us-ascii?Q?NJ3/hWj/lTfT0yoTMj49EXxbv01msODf79pAlhzHpyefmZ2ojDdXKgLO+tig?=
 =?us-ascii?Q?ml8EarZ800iENQ4DUYAj8Cxu+7r4q2468pC0DyY/VZXWYGGVV6wY/FoCTRxl?=
 =?us-ascii?Q?OL6S8OhCFXhVseiiYSXUzXGc0x87IPUd8LGc2FpYlnTu7ASAPIFA5IPSsf5A?=
 =?us-ascii?Q?v8r6UIzG7lRVMEqMkz8VL3M4VY53IJSOy8E9+OvZqRrcRZVewTKPQ0ONd5K6?=
 =?us-ascii?Q?GRaPJ7o6R1qtn/RsLjZkAK1dUkW2dm2w/IRfT5g6frxZ0/2QPbUKs2vuhr9j?=
 =?us-ascii?Q?TrXRpp97aYQz7MfQ79ChVNiXLqRZxS+PrXVqS4+jkaUWlCvW2w0wzKcEOUG+?=
 =?us-ascii?Q?08tSFfa+3xtTwWGzhDKalqEwKZraqO9NZdSGfXES71VIyYJz/KczPRhhW2Qb?=
 =?us-ascii?Q?0q+Et8M7hcrh6ORkVKOCKdu7ldsH9wz4jZN0d/UGZLzQtrOoNRTfct4Ne84O?=
 =?us-ascii?Q?18yPBG3tP4QMSTy05w9fIU9HsVRsjlOxqRjvs3w9IS7mEI5k4ReVFlyg9nUN?=
 =?us-ascii?Q?DOznE4hKVBtaoHYMvLbbmm5QE8oRUD7N1b2odMGN9XY7OVe0DoijRinfVu8e?=
 =?us-ascii?Q?7P7Do+ANZyiFuvWn9DJ2H+R2HJV7BlJdQvlgl3/OnXiXA+D7jEw/RH1LLQy9?=
 =?us-ascii?Q?vQYAnCQjL5jIKJQ9lpr3RMONBBYkNQgQMz6ah9+tLcWohS8IqpaGxOQY+mj/?=
 =?us-ascii?Q?s1KBTW2weiqX6YgvG3kbxP2turukSdj2RpIwC+fm3aFLD0ECHXIVy6CjgGCh?=
 =?us-ascii?Q?zjMSbbDAyNQ/czzTpzG/eNa32mkkCAXZaxVjs0R+0/YTJSq3jC7i66imk7T0?=
 =?us-ascii?Q?dhqT/pm9jEMDgYVk5EBIHV1Qr3R5jGd1bEmB6cd0DjLAa+ypoHzsZXxwtxn5?=
 =?us-ascii?Q?ral+oVrxxTYAP/Q9RDABqNv7JviDD+djYgqo+BDD6re3ZQVshy20lLS796J8?=
 =?us-ascii?Q?y5WsV/QG4UDmBRN9Zh9aUGMblg4kGvv+8HKLbc58+LHS2NQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gSuujfPlEyfuZDGwuhFkw8AGyxDvl4Vw1MAAVsjWBcift3hadWqPVyTUzWoi?=
 =?us-ascii?Q?6DPWbl/0BiefLy6i4+/7yWaSx0Zl3t1+XScPEFnMtAJcsz/4Z3W2rinNWrbB?=
 =?us-ascii?Q?L6Va0Yma38S9QpWEzZBZjHAjxXvu04LLsBb0QLURMs2KJArw9JcRrsGcaryt?=
 =?us-ascii?Q?/x7OTUkEu7EPh9jqmTa3cTsqp+WXJwMEFRuJRBMHifRRv4vhSYyQ/yIQ1t/C?=
 =?us-ascii?Q?bGqF8NFrASDhlT/BAhqeLDBUj28azH+7WUt5k04yRfuMLrlG70y8PFlAZT2y?=
 =?us-ascii?Q?6MwESoCidzdYjDflKUJGTLt3fVu5Zt4l2AkCxy8Q05aVyRPMzSwReoWASUAy?=
 =?us-ascii?Q?CuaK3wE16uvHRep138/hwAIC3+GJbR6wAqHSd059/JdOrUibnkQXERsSN/2g?=
 =?us-ascii?Q?xHPz7Z6Z2o1eTm7vmKjFsLodM0T0S+hO4LQ28jLYG+SnH6FhXdJCbzCeak6E?=
 =?us-ascii?Q?l3fhJJAxXGvDBE5N9PaooFRCw3sBYvEc7508eQ1GbNPh75CUtTp1+LmhYIDQ?=
 =?us-ascii?Q?2y96kJ+7OzKemgAozPoNU/SgoVHmz6/DItWiNqIwy+v1zzmuxuTJNR1yQaAC?=
 =?us-ascii?Q?t3PIlPBsLd0ed1wvTQQKPBpJipA+4HA+X4FcyXivg6pXUaNyjquFw28Fj8XP?=
 =?us-ascii?Q?hxN8QHPhDxjT0vNv9fL3yzvzPoga/GDh6crj9/0oX80c5QYHZvWddHyRL9Yf?=
 =?us-ascii?Q?n6pdGChrOSubLgzjzeM7l/vUvNJhUpLuDP3qvnDw+vuNVotPjGwVjWnwBoEz?=
 =?us-ascii?Q?j9Sl8ewNOGRDJTkTEyACkeTPYizbrN10LrO8JTJbQYN1Qq0K3jdlrppxa1ma?=
 =?us-ascii?Q?zbxZGrcM1ykNTFvkYp8bBG40qtiOjtjYJqeRFs9jPXVj3UiNTvKdylqKzoWr?=
 =?us-ascii?Q?r1zRuv3NZfhWILtXmbn7sCMmPFZZR6NFY0BYcgxpx1gcmX3hUKBTXY4ydJ+4?=
 =?us-ascii?Q?r2FxgQygkct21vHYa4s/a6PiVqJfa+UhR5OPJ65/mtQF1vQ/Vl2bTsljTf9P?=
 =?us-ascii?Q?ovkk4yrMLuMARBlrSfDrdS5penytkxT1jNloW8Gs3eULy/r+Mm1DtOOvRjKA?=
 =?us-ascii?Q?DDQACDiDUx60/qYMmF78QVLXT5W1l3Mw/HhHSHPSR2DMiwpFv7+GWSEddpqU?=
 =?us-ascii?Q?4Pp5xNwZU2tmETE55kY6L8yaANtYCpGtTceUNPLOMIoi13XIJtF6RrWzmsjB?=
 =?us-ascii?Q?IDkNPDBTG82dBvVqzGiraMNyKJNUIcWPQ2ZOQsK9Yo2rDzeI/ApUfmCKDeJ7?=
 =?us-ascii?Q?wn7qqDkD0EnqcUbdCqsZCqHLEdaAs0niMCpcoqppQ3r+lUIii7AKqW0MG72r?=
 =?us-ascii?Q?F473woDa/0OpL7sXmdxlcHSzGHNotaTlp2Y7f+K1nilvyDUdjPeqM9sHRmtN?=
 =?us-ascii?Q?F0wl3kzN7z1pU+WGjKA18ZjT7cqsudfzS5BWUfZBj+aBYhsUy5sJsK6yHS5M?=
 =?us-ascii?Q?GXDIZ1s13CQsST7Dc0Be8JFNqzABZG4m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4278fbc0-0f2f-40fc-194e-08d993ebcb21
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:18.6646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200095
X-Proofpoint-ORIG-GUID: fNnA5ikQXi6GuGaUfXVZmUVUQJvZ63zE
X-Proofpoint-GUID: fNnA5ikQXi6GuGaUfXVZmUVUQJvZ63zE
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clone memset_movnti() from arch/x86/lib/memset_64.S.

perf bench mem memset -f x86-64-movnt on Intel Icelake-X, AMD Milan:

  # Intel Icelake-X

  $ for i in 8 32 128 512; do
         perf bench mem memset -f x86-64-movnt -s ${i}MB -l 5
     done

  # Output pruned.
  # Running 'mem/memset' benchmark:
  # function 'x86-64-movnt' (movnt-based memset() in arch/x86/lib/memset_64.S)
  # Copying 8MB bytes ...
      12.896170 GB/sec
  # Copying 32MB bytes ...
      15.879065 GB/sec
  # Copying 128MB bytes ...
      20.813214 GB/sec
  # Copying 512MB bytes ...
      24.190817 GB/sec

  # AMD Milan

  $ for i in 8 32 128 512; do
         perf bench mem memset -f x86-64-movnt -s ${i}MB -l 5
     done

  # Output pruned.
  # Running 'mem/memset' benchmark:
  # function 'x86-64-movnt' (movnt-based memset() in arch/x86/lib/memset_64.S)
  # Copying 8MB bytes ...
        22.372566 GB/sec
  # Copying 32MB bytes ...
        22.507923 GB/sec
  # Copying 128MB bytes ...
        22.492532 GB/sec
  # Copying 512MB bytes ...
        22.434603 GB/sec

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/arch/x86/lib/memset_64.S               | 68 +++++++++++---------
 tools/perf/bench/mem-memset-x86-64-asm-def.h |  6 +-
 2 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/tools/arch/x86/lib/memset_64.S b/tools/arch/x86/lib/memset_64.S
index 9827ae267f96..ef2a091563d9 100644
--- a/tools/arch/x86/lib/memset_64.S
+++ b/tools/arch/x86/lib/memset_64.S
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
diff --git a/tools/perf/bench/mem-memset-x86-64-asm-def.h b/tools/perf/bench/mem-memset-x86-64-asm-def.h
index dac6d2b7c39b..53ead7f91313 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memset-x86-64-asm-def.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
-MEMSET_FN(memset_orig,
+MEMSET_FN(memset_movq,
 	"x86-64-unrolled",
 	"unrolled memset() in arch/x86/lib/memset_64.S")
 
@@ -11,3 +11,7 @@ MEMSET_FN(__memset,
 MEMSET_FN(memset_erms,
 	"x86-64-stosb",
 	"movsb-based memset() in arch/x86/lib/memset_64.S")
+
+MEMSET_FN(memset_movnti,
+	"x86-64-movnt",
+	"movnt-based memset() in arch/x86/lib/memset_64.S")
-- 
2.29.2

