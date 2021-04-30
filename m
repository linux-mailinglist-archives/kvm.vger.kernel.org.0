Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8136FA82
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhD3MkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:07 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:41101
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232428AbhD3Mj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htV91abDsOwTEt3NXRtHL+y/wxljPW176dNwAIZwobszJKsak48HY5G6mB+LY/r3sGFydRlSZqpDAWZytQoXNEcMvIHjpfreAYWbWOPf7xF8h0QmjDpqZ89ujC4gVYGd8NyCubhGUAE3eeard/t9cWGo3tDMviwnYzWjaUrdjZgktYfOyHYlM4wY/1Uf4oGqVaESWncFFsa6qQg/kF8oaXQEkRvCaDkrhwIFRStDXfwFOERXALJi14oJwRO72yUIAaO95+nFYCC4akx/P6yON1rpSPL+J4mHLwh6UwwvfK7SNUIorCycN0c4OPMmSV3LaPxKy7vadF6X+qKNJSmMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQk1+NayfuudC/EVbsPjdngnqar5UmVKrfvL/maJC8k=;
 b=Wg3dHycyVf/sfFT+Yz0xVn1h6ue16ebPbNaNylSm9DF4v+AOa93vK9BYq5aqgEeWqo4u+vG+Nc2xt9EPi8591GPZ8TGaAVNJDYZba2mzOr9CPZS/oA7W28w/+R8x8iL/nioj8c6f9fNbIqjuvgOxo6zMjA/2H8/xMdfWfDvyjIuVb8Sgw+AgU0/6o+xDx3nAnS3Ln36poEDwOUvSfG/i9h1VcX/tjNhf5aAkL3WDZhzq22v21GjS/slAopU3nFo6nzpM6em0JpIn6Nm8hmbkjI0yltIBSn7iEZFS48cAv7T60PWIAvWAdGfEVcR2ZCoZWrXdcSDWgStzikz/oXQj1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQk1+NayfuudC/EVbsPjdngnqar5UmVKrfvL/maJC8k=;
 b=01Tpar9U8c15XBvOcNLCOMc+BGKIbo4cHGNggVEJTDTbzWtFXm0dgEOLjHuFzilY5XEVhV6c9hEkpjveLVH8neNh9JMrWyfuQHkxB3LsEVps5+hN1Lb0H6bCSehtgJ/cu/Zqw+ch5JFOltVgLQUep9wQifT/Pue24fvrD/Z2PnY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:00 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:00 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 09/37] x86/traps: Define RMP violation #PF error code
Date:   Fri, 30 Apr 2021 07:37:54 -0500
Message-Id: <20210430123822.13825-10-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e46f871-07f5-4398-f8cd-08d90bd4edc7
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283291AC11368682BA482337E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7ZiCChpUE1m5VjKbopMFHH4r3HqaPVdARiHBKvTlZ3K6mUN3CW4hn7m+1l/H7sWbRDC96dNg6UXWxB5ElXVQPHo/E8PNHkc2iVPBPtXCaCTR5RhSfspezS/pyoBj5o2uSPzfw6pxb+JwijHJEVndXBX+f8mIuAkIT6smZChjBaRY5imBJroEswuFd+Q4IKdvnltfMRWXzmKhqNJFBKHQB6LjxSYVSp6S53zBsnstPqtQRb6FRnVkOtqvwdIAcF96fHQAzrryLoKjFhf1Tj6rCRTmTDf5xO9KOhj6urfElDoITHlSkkaH0xLQBsUBKLRvV4LPHrjQ0QHqevaYVGR2ggfLLHSeI/3cuIkYcTMF08T/2UYD+tI9kEXyrS+BSXU6VVSVB9ea7eUpWnZtcB1s0HT8SMbRgMcgzbYfCsipAVYFU9XV/rALdnYU21/nqMVe6BIb9vVQxnzqxv1momI75RgwImPb29Pge9L2DbTyZVaEKdybsRJUXkE4ZXdopcD6Ih53ES6JK9wwVXOV9TSaZ1Tya7mkdvGJ0+x3kYA7YPkowlEFqzv18iz3EPYlgeNqWrLQjQXRx/T/1Kdtq0RGdLzgvoRk1QufpVif9PAvXReZPPfKzYL8O3LCbvznHR8Qn2JtDDeCQT6IgeZviPDsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oLzGMObs8jhEp+QVv7T3UZSTkSEqd2UFGbROPxx+Tb9qpJqlm+o6iaKDM86k?=
 =?us-ascii?Q?2DO2wni0PbpfKv75yv/q3cCW5KfzEh62Tyq8PJ/diPqmnedBByGNfQcbSKsN?=
 =?us-ascii?Q?R1gPaI8K0ryGJnj1SRNR0pDwOYBD5CsGCpcIltKH3o5joCs1sD0TnrQJdP2d?=
 =?us-ascii?Q?SRPpmYRHWkjDBc3lZcu/j3j2ibf0eyRDIEANa+tyV8QbG5xHtDUauNPlOww1?=
 =?us-ascii?Q?KuLma3JNyZ/RJ8jz18b53NgysyAZehwdB9YS18SVgSElKmU9noBhqeqrzjRa?=
 =?us-ascii?Q?2epekbfSqi89R7hjdF945P6s3dY+xrWtnk2Su3h0Mtfhvr1UXYs6/Joxsd7i?=
 =?us-ascii?Q?mJ0Klk82SOG93yFATbBxK97sl/vLbPFP0rQ/JaOW6bR3nplKoPhHBHxX7W8j?=
 =?us-ascii?Q?aljOOalXadp0FbRMOSWmqgKy/TBjKQzX1WySnGBBesadiLP/MmfqH9vmVGLr?=
 =?us-ascii?Q?gRksW8sOY31yafssYjKF53UzTswZ2lBCJ4y/cp82QqZKb3qD9fJP29n2BCz0?=
 =?us-ascii?Q?0m5zlOkVuHt3UpvKATJsZTe0eo6RE4jviDKbfOibcKDA+dCG+GHBGotL1qFe?=
 =?us-ascii?Q?C/NPr/3n0w4cqPnr14ROP3FW7L8emV8gJ/7y1fBIoM8zmWm36+efrQ/VLl2M?=
 =?us-ascii?Q?TkSh5M1iIzWhShNIqCDZntgpLIXhwYxXgdjL4bwiH4IWAea74AUEqQYryfn3?=
 =?us-ascii?Q?9mcGBlgLrT0d/61ugNunj827fLmlhZhc2vJSfi3p2Gdoc3Mi67Ec+KJKUbIC?=
 =?us-ascii?Q?lG6UEoRpKqfmIlqkKSpdUkx/8O9aVbo9ZTVoiA1RTVUt8d3W1H3b3WnI5k/6?=
 =?us-ascii?Q?WgiD0EksRdQnkKlyl48DW1TSE9Lv5s3MfUbLaQnIlNKxorL3ecqpNeZh0H3H?=
 =?us-ascii?Q?sT7EH891R+eaV73mWklugoW6WaL/jMv9qMQxRkXDdhgaToW2/PRFhV0KDB1p?=
 =?us-ascii?Q?10GALdjZwU9Cz/P47622aERjDcvUSqzrwcyqqE0T4u00zx5Z+ojNFvqPnoKi?=
 =?us-ascii?Q?0Vh8ANTQD5nKYV/+7ee5G9OMsKeNQoFYeytO3fnBh7b9qD/KVpOKoSkCIf0b?=
 =?us-ascii?Q?svqa4Z4WhaV+M9LmgaBy1qokZVhJInxhyxDb3o6R/qNcs07BCPpMq3npx8cl?=
 =?us-ascii?Q?ls23hqbO2X4DsJJTETNSxPomzP59ZaUFKvtAMz73afvXn3yDlcCgoTVOVtCk?=
 =?us-ascii?Q?43sB9njcMQl4pwxER8R87kQFD60Dj/XeDOc6855pamGqaMFNLlpR3cOhGN4Z?=
 =?us-ascii?Q?DUiC0XwPPJJaCunLyJtLUNFaOlPergFLY+uN8SouEocjQhsMtxqLcwZkdFyo?=
 =?us-ascii?Q?H8bv9pgoYtgGOVrZR7PYeug2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e46f871-07f5-4398-f8cd-08d90bd4edc7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:00.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNbXOpUWv6zP3vH+y4KrAjo5TelZNVOGMQtS2xaOvsozKgwl3iMHFldQIpCzsDXxeHpGUOL/OH/BWwdIYn6MyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 18 +++++++++++-------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..29f678701753 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_TRAP_PF_H
 #define _ASM_X86_TRAP_PF_H
 
+#include <vdso/bits.h>  /* BIT() macro */
+
 /*
  * Page fault error code bits:
  *
@@ -12,15 +14,17 @@
  *   bit 4 ==				1: fault was an instruction fetch
  *   bit 5 ==				1: protection keys block access
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was an RMP violation
  */
 enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT(0),
+	X86_PF_WRITE	=		BIT(1),
+	X86_PF_USER	=		BIT(2),
+	X86_PF_RSVD	=		BIT(3),
+	X86_PF_INSTR	=		BIT(4),
+	X86_PF_PK	=		BIT(5),
+	X86_PF_SGX	=		BIT(15),
+	X86_PF_RMP	=		BIT(31),
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a73347e2cdfc..39d22f6870e1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -545,6 +545,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "rmp violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.17.1

