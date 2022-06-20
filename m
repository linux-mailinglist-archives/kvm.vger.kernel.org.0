Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1725155278F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345540AbiFTXEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347002AbiFTXDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:03:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ADA1FE;
        Mon, 20 Jun 2022 16:03:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSrrI65kY2jyGDvUkBJk7pQ4HimCjHQ9+7V8pbiZKx5DNhtrExTYRrTDREzTRYb6jlsowbEP4dzvJDLjWHRL+4sJyYy1/iAjads/plUud9jNv5bceevaFcKccSgKMpv10t5ytSK9BK40etf/Kual5qMs9+BbYiR01ulVbB7x2uA5/BUx3FHv0wOVtmyza1W7Qx0qag/YWy2OCdY2tDLV2M0kX57Jq+JKZo1XueiVusDHrDABVUuXnGB5GsDS0hE0QU1pAhREy6DugtCl1rjWBqBlHtClP8qI2ND6vc5wGMBoOMhzFj21jMil1FI+J2pwINVg0zFM0YH2QYCPGB+t0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdsiXFsov7b6bmc81thYnFUAHUojIU9Zd2eTMANVyHk=;
 b=j4MArPHUHZR4Mnc6rXL9C1nxGzy+sSqTo70MvR6eG9CxohgW4mE37PgjMoytdXbrfFCAODHnOWB1/zJ40fn4/KQMwZXx5SM11X9myXIxlwtKp+MYERG8cTQpjuMIJHbkhuGL76MNp6YCTpHGczcwikur975gUaQ4CJMl83yU4pgZY0AlSjO1Afz0QnTBdcDL1/SX4HgmDWsGSVrMU0Bbx9zVnng++obTdvWFCWiQSTdreH022yAN0ll1G2IQs7JV/o85VlIQR8Oz6XfCGx6UTe3xlshanr1qmND1gxnaQ2jdgQjbydzfqMnZndCOJusl16JkXXp1Gfxl8/JcCyiH0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdsiXFsov7b6bmc81thYnFUAHUojIU9Zd2eTMANVyHk=;
 b=2xYblfZ4kWk9QFT+AEcdjU2XLipSsBDSwMHSURmKBTwW0MCj+mRB8PA2h1a1sNNG0H69Amfp/X/VKDAiOe+4pnl1lBolmyxsoIG5F7chHk5kaSKwfr1qyBEXjrw+TtNEapp7dIeqAIEmu4ZPrkBfdwRVrnsvo9cx9C2M6STW314=
Received: from BY3PR03CA0023.namprd03.prod.outlook.com (2603:10b6:a03:39a::28)
 by MN2PR12MB4797.namprd12.prod.outlook.com (2603:10b6:208:a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:03:40 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:39a:cafe::7e) by BY3PR03CA0023.outlook.office365.com
 (2603:10b6:a03:39a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Mon, 20 Jun 2022 23:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:03:39 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:03:36 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 08/49] x86/traps: Define RMP violation #PF error code
Date:   Mon, 20 Jun 2022 23:03:27 +0000
Message-ID: <5328a76b3fab1f20b3ffc400ca2402bec19d9700.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23a5f2e7-ad38-48b6-962f-08da53111cee
X-MS-TrafficTypeDiagnostic: MN2PR12MB4797:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB479711AF035501B4539DACAA8EB09@MN2PR12MB4797.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LFhTJDrohFrnVoEtuKxsI9O/Ejv/+FDyFzxtRZxBa7YwEdvF0qCcRImZbU8TahdRECh/E3yp5qs3weN1PRVZ0LlS2dmLD8BfdAOV3MRTqW1g+Zvg4JXZDcgMiKR1hoJ0j8BsgUdFcxH2WbTpanhhVTQVj6ZMg0OoJJNOacLfqwCvK7LmSvvRqQejLiYcfumDwaRI+uQGs9R1qf+4zYiCSbgdOmGp1btPIxjriSfknZnJuFUtrP1Bo8br52V93moRmL4JqypmVUDIjIYpPk2+0kewHJnrCj+hRJ9HV6OaxGIuax7Rmh1R7JIF/HH+Lu6j1M4KrSM2Vfgu/3eW7Lk5QxSbUyZaQwvy7Ohq+DnQyTmhEN1GgnhtFGmhP1HkWt6IQ92WizRGxXYFASdb3jFmZpAKO38eNIrN3nX+cCM8v9O2QXm19PoYZkIJP635i6fXgmuf8DIFCCEJJRwQEz0+P2DCNyqry/pd5Rjdgp9oy1vl5U8UPkK1qtrBnRqlPxnRcSd1xc9cdxZVwWUBvnx+zJI5DnS0R8bz1A2Q6+sRb9FLX5Cnddz0icPU6h7cDF3f7jUGVkY75OJGRuVCKoeuruxFozSYgNoHVJD4FyONQVGPsW36kFeD7/2Y70nytyYacWkrqK0Q3CmDUfXAWUk4N50DkCbmymGCPnhWQUYyLbFu9GT07Nx7ZT9XI7DILBG6CVZ5lfso+9MLnHFrSRoKBWUvoubK0YzLeyHhw90+6GN3wZ6gEgWeDyl+fsiDBfxg
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(478600001)(26005)(110136005)(47076005)(16526019)(186003)(54906003)(8936002)(36756003)(316002)(336012)(83380400001)(2616005)(426003)(7416002)(86362001)(356005)(82740400003)(81166007)(36860700001)(40460700003)(7406005)(6666004)(82310400005)(8676002)(7696005)(70206006)(41300700001)(40480700001)(70586007)(4326008)(5660300002)(2906002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:03:39.0356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a5f2e7-ad38-48b6-962f-08da53111cee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4797
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT_ULL() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 18 +++++++++++-------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..89b705114b3f 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_TRAP_PF_H
 #define _ASM_X86_TRAP_PF_H
 
+#include <linux/bits.h>  /* BIT() macro */
+
 /*
  * Page fault error code bits:
  *
@@ -12,15 +14,17 @@
  *   bit 4 ==				1: fault was an instruction fetch
  *   bit 5 ==				1: protection keys block access
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was due to RMP violation
  */
 enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT_ULL(0),
+	X86_PF_WRITE	=		BIT_ULL(1),
+	X86_PF_USER	=		BIT_ULL(2),
+	X86_PF_RSVD	=		BIT_ULL(3),
+	X86_PF_INSTR	=		BIT_ULL(4),
+	X86_PF_PK	=		BIT_ULL(5),
+	X86_PF_SGX	=		BIT_ULL(15),
+	X86_PF_RMP	=		BIT_ULL(31),
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fad8faa29d04..a4c270e99f7f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -546,6 +546,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "RMP violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.25.1

