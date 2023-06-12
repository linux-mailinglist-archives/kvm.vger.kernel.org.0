Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4648D72B668
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjFLE3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbjFLE2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:28:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD2310FF;
        Sun, 11 Jun 2023 21:28:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiN8aGoUKjnn+v6tPniY4KVrcUTrN5gQmlzQqnTifbMNkLRi9jKTMukg7gd0mhMjpSPzbjhfO7CaoqwbnycACOvZ/JSkDLykX76qOYe+7cpuXs0J3JF8mvEwIfzqPKY/1uxWuya+bcrIMfPPLoZtjMtdEGykr6AKw4UCzlWSSNBoY4zzf/gimEXNjHXqRcn2z7a1KTYjOWnHK9Lh5HSc4JTUJWe7YfZixCp3XEshsCRJPRnqLk/yshkI/6siGKntXHhIdilK6S9H8oduhb8eUgKYmiwooMNtv9P/U7GnHk/a7F33riJz7HFdsOxGlZTQcx0mIm629Q5e5VcDgPH4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMB31nd+imPpavDDp2i3hNbkegevF9k3G64/47I11j0=;
 b=BDrkFr7uObYL01NT3H8A8p5WB610X7EjMMre7+Bhqa3q6RtSn0cGI8oTeuVrfRuFk5lDGF0jHZJwQPYuM47yNskery1sVzgzMDXuxpg6H6QyhbDmTL7CGJJK+5ZKBI5WWy8G8PMtZuYmQLX1yXQFq00jJHNgENtpEjt7oxjcbqTEzV0jTL8C02X3IfPqpvwyJ647Fz1W3yuzjNLIL5Fs4z3Q3Mcs11Va+l8/L6oc8tt3g7teDg9WXaNPcKohi6T3P9i9RfYRXgso1uD/lCWud/faSrl2LnTLsL6VKiLzs0vQwAajhaGWWYJHUUWtyNCGhd2GZDG/c/AJlPVHsuU8Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMB31nd+imPpavDDp2i3hNbkegevF9k3G64/47I11j0=;
 b=wqmCPdyThfxb8PAACYTf/ZJxUuvXMoGJJ4cgCVRrxrZtL7eh6uoQwjxY+K2SSxMGhx6yvKDCJtrBSQCWGhz2L+qrFJS/MDuG3ZAYokmVghmlSfthy3hDqdnaRnzWQ8EWhlWHcRd2+CIgK0q22bTPIT3JL6Gcu2UQJtLaWIEAhXw=
Received: from CY5PR16CA0012.namprd16.prod.outlook.com (2603:10b6:930:10::20)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 04:28:23 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::98) by CY5PR16CA0012.outlook.office365.com
 (2603:10b6:930:10::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:28:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:28:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:28:18 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 11/51] x86/traps: Define RMP violation #PF error code
Date:   Sun, 11 Jun 2023 23:25:19 -0500
Message-ID: <20230612042559.375660-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: e27b4765-fac9-42fc-d1e5-08db6afd7553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqCp7dI7Fv/h+/ZknTqMCpt//yb8DFffSDq7a6+PDKu3uLc4SOJ3vmXoEBX20kHv3r+Sr8EsATnXaDGfHP1B4s3UVsmrE2yJhp2/IMo8Ru5CQwvFdKCNF4AiG63cIh9DP87PjvqUo4Mc8kvzt2yscllho9d1JLX9o6FcVrVSHR27N8aSs8WHNioTsxgqe4bFJTlU90dQFe/uVfb88kQ3EZJn3y92Mk99CLOR9pxNPGIYJ+mIPLAwdJdup+ywsbpgAhbDt/97wSkQd4XqtFIi8EH4BnaukBTxTauOf/BvnKdFxn8BJ7e37+Ub5G9S5cjpiTZxXfXPg/L4cRAYS5BUOhy4tvrXM48s1CRYCedkOLKX1tdmGks3IboXRJ4kYsInaitRdrGJf2oD202u2ppMyaJZ7BaHrzq0TFgtiveRspFUG+66aZBzsPwbpN67MjSgUkewKzD/5yTiQj6xfkZ7XVNr2Feckssna7lhWzWtXvhnoLsxntywVvKhc7ieP6HASowb23fXZsu0+WvgGzbnsNjmJuK0apVsde6fOWh5+sLaRt3tQDh+WIsrZNn/1aCdewNaXjIgMh54j5iZgywgypvnFU4XZCjblMi/h3EK3Kb0dKj9y917ZdS/nxhc8NqRwMoE8sSCiOQktK+pm1QTBCm9IVUNyjVOSVw4Lgos44DpDYwT8gbqc7VCgU1z71RQuAj1GYfkM/Y4M6okokkO1hVucLhPfvQrafz8z/WDbQLRCHKLFcnoycthqIE4G+4cN1npeoVlnSFWyKVlhOV0rA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(16526019)(186003)(426003)(336012)(2616005)(26005)(1076003)(47076005)(36860700001)(82310400005)(70586007)(36756003)(356005)(70206006)(82740400003)(81166007)(4326008)(478600001)(40460700003)(83380400001)(44832011)(86362001)(5660300002)(8936002)(40480700001)(8676002)(7406005)(54906003)(6916009)(7416002)(316002)(41300700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:28:22.9348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e27b4765-fac9-42fc-d1e5-08db6afd7553
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index a498ae1fbe66..95791071e3cd 100644
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

