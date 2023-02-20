Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB1B69D30C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjBTSqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjBTSqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:46:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36410212B2;
        Mon, 20 Feb 2023 10:46:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ib+QpV4dtiCPvitAowhXJoqt6AuFnZRb9Cc94pbBK9x7hTGF6yECS/qxVCdatV/8+GtnzkFdjiWXZWjZnZmYzg8WNfRVP/6w3MybTuufT2oAKTW1LNj7lgTtpILW61meN9CnpScb/O8ZjgbiaxQgiJZqvmv01eZ4Oleq4kCfpw1TeQ1oDZAUVhtlTSNsB+U3G4UwvGOlvTmtXaRmkjiaFh2aC3zrdsFJr8Wkq0lDA8hE7Z6KrP5GblzNOQOvOE0l5WkYZwbs7QFpG+loeQghwe9R4+VRe+nN4tefxps/AbEcKj0OdxIFJHgiGH4AKnJ3GoHK/jHLZTYZlwqdirbjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaE99ZyE9fPNXP1+sCNkKPB9OJSZnnK2iy4k/8TUgSg=;
 b=I6Xjea3pj2aKHKhdSkxjR6gikxurOur4IP+GjkVtmHO8SLiA8rmGq0TrBsNCS58TGEcnnJc9lAa8vSBi1jRJaUq5KycgJhaUNPOf3XfCoAlc5irq1GOhCprk++gei0UlpssKFSZyoQjfbAr9DpzqVfqmFkJlQW5fkwldFmhbWTyf0Ll6Kt3hTG+U9mccWcTsAYa7PpAMBg0C4UYhF0/rlavHlajIlZa3x/s3PsRceZEs79/ILZyyXQcraixFu6SYBjDcbubq1Vf4E3MEomVpftTSPIfQimk1i/XbvPq1nNRVWTZQpjicCP+grlaHkLkaKQZWWnrP489o8m2L9Df1xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaE99ZyE9fPNXP1+sCNkKPB9OJSZnnK2iy4k/8TUgSg=;
 b=5ScSu2nP8vwx48ps6wK9Q7/C+pleM5XY3oVqWseQHPXeeNBGgZ0Ai+qhFcAuWAn+0iuU0ONOadc7mj1JQq+U77QpbHWjaFCDcZFdJGOhfbRFPHXp5coXavZYRtFRnSnOs8UVELiuQRwGJD8nyhJTePhtlu2vZwk/XI5L3f2eDIc=
Received: from CY8PR22CA0016.namprd22.prod.outlook.com (2603:10b6:930:45::27)
 by SJ0PR12MB7068.namprd12.prod.outlook.com (2603:10b6:a03:4ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:45:59 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:45:cafe::3a) by CY8PR22CA0016.outlook.office365.com
 (2603:10b6:930:45::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:45:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:45:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:45:58 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 16/56] x86/traps: Define RMP violation #PF error code
Date:   Mon, 20 Feb 2023 12:38:07 -0600
Message-ID: <20230220183847.59159-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|SJ0PR12MB7068:EE_
X-MS-Office365-Filtering-Correlation-Id: 33661cb8-979b-4837-8754-08db1372b597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FAAeYIHurIps2K/JbO09YdHrBe1AjJsKNqb7GYwz2aBSj7eW6BanckDmdj6Cys2OwC7BKay+bs1YmbEM2zxGgq2yMEAEaOGnSbsUEDuv3mEwI252KjeRpRpVD+VayI3RHaEa1IpNJ5KMnN35J1yQeZuqln9KzGKGSEdIoJhVoLbqrS87itrEiGZA+/rj8Vu3Kqo6ngIQoc3Y7C7CWOU+Kxtt9Aq+4TU+vyqbtQboA/RvexFOnNJwktWT9fRvK5T76FQCnIWoKPvy1gsWZpcDFN8Q1FkQms7c+Kj6/Ij4idDw90JJC6YkatRVI7EznC1L1lac++F/Qc30pEdmuTfkxb8aReuI9cvqqSEeyner+ieaHMG4yIzpz144ZdgRSOVzB6CVLr3Sv7QkuyO7kOf/LiSEfb3JsBNFif3mSbtNM61UQz5Sd53vCcugP4SyQaggJNHYDuNADFwFQ6pEpehRCrPYzdnhswBw8CKmUKRfbNZG1n5q58G/cQJxPoDwXSmFLHPnw/XEz1QAnKuoh3DxUuzffgysoWnQ/LAtZdOPmvT6xHskWptFOw9Cv9UcylqKFR69CIpOgXM3y99z3QGq5q7vzGTe3/YB85Ze4OW3a5Vmtc2QUlhVbNxyAsMnDEEwgXl54MduP0w4tfOqshOk/cPQfBl2aSKsZ6mm2HlYJ5WuoWGuvyCfHo8K7xJP136skBVFXPwO95u1d1/KbXUj3ZBx1QKa7vIZnS8m2Zv2TlE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(82740400003)(81166007)(82310400005)(36756003)(356005)(36860700001)(16526019)(40460700003)(40480700001)(6666004)(26005)(186003)(70586007)(1076003)(70206006)(4326008)(336012)(2616005)(478600001)(54906003)(316002)(2906002)(8676002)(6916009)(83380400001)(5660300002)(7406005)(8936002)(44832011)(86362001)(7416002)(41300700001)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:45:59.5769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33661cb8-979b-4837-8754-08db1372b597
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7068
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 18 +++++++++++-------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..295be06f8db7 100644
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
index 7b0d4ab894c8..f8193b99e9c8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -567,6 +567,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "RMP violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.25.1

