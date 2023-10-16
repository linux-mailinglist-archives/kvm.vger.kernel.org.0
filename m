Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A1C7CA959
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjJPN3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjJPN3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:29:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB19ED;
        Mon, 16 Oct 2023 06:29:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2W7CrFhrZM45yHzRepEirhaFjhqOaAl1HHHlFoZB/SfsGUCFcT9oYVd9iWRlX7/1aNPDiPX0v0LbXn7ciwLVcdFWNtF3/flsT2phwu/bwGxABOpx8lB3fVwB6uk1rHAwSVZ9xyU+HVRoKVyiHsBUUKb1XcVwI52FAGclAIFPLut/XXm9XhHCEl4cAmfDYLUn8fS5Ys+MZ9GSWRHC0+zdnJohZeIEFX55Rm4DhZ3Z7vJq7AoursWxjmMG72zO8+ljrigeh8J6imWiDBm+6SPDb4qVwiKytpGpwsfUG3R38p1d/qdnEQipBOu/OuwEStGTNTD3Y5Ku8D1aDzKi/qbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxkTby7lFTzFsWFAMnJrm3V9qcqFNOGCwHnaQwzNcgE=;
 b=atebdNL17GJlrRhAUoRr9rCmS8bDduyEAkIjnFezUkAOqkAqM5sVOg7wh5iflgffZwSV8Nm+pLNEZ2w2RoGKxyP5Ol4fhB14PJfjim8DHP7bAr2QqFbAavVN4nb+/SevFp9Lb8qgj5rojketL69hEcUgnnskAmH8EsrIDzFQeev1E9iHxbhP71oe+hcjPBzunZHwrUysMSD4aq4+V3wQWRa+DqknLzFL/GmpKMpPQZkyPjTpM0a5JS+QOZHuGce/WQJPc9CbXQu63s89ZSmVKQzXGWIFNTTPnRPfEWoA7bKi4yz/Odng/74W/Jt22QR4ZUwbrTf9OI10ggH9nYw27w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxkTby7lFTzFsWFAMnJrm3V9qcqFNOGCwHnaQwzNcgE=;
 b=j1LUaar81RoDxEoEbPcjQPwktefhABhKc8NY4SeaKSdIV8d7B5UT8iKGz3fz/zjgdE7tkPbZdhaK0Yhsf/M+sRT3PfyfJwia7SPB1Fh7/z6Cf9r63Huw4aAuoJZhzR3NN5VvRXHUcmZX/GNWRchQMJYVY21TB1fVb3S6I/PhoMY=
Received: from DM6PR11CA0042.namprd11.prod.outlook.com (2603:10b6:5:14c::19)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 13:29:07 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:5:14c:cafe::f5) by DM6PR11CA0042.outlook.office365.com
 (2603:10b6:5:14c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:29:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:29:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:29:06 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v10 09/50] x86/traps: Define RMP violation #PF error code
Date:   Mon, 16 Oct 2023 08:27:38 -0500
Message-ID: <20231016132819.1002933-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a75589-b38e-49a8-8f50-08dbce4bdf68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdi0/kGZRy0P4FRirFxTF5xYWfdMAuOY/FLUYc+kjt0UPtXQE34Dxvz2U7AcCNqi0qK0Q2qTOVtwrjOPcdCURuJ4bnRdkynES6rll9EOVDpEvK7ftk9cRSNX0NNevK31APjCgtWH6eyudIjo2Ei7FqgGNfErMRU3+B4MEO0NLRSx1oX1TDfO2WMf42sKWay0XPaS1k4i0zuqiuABxQib+evTeJkRSp/UxnDKbTUlbR/LMVVFbeYZuA8SNXtajgL4+AgmG+trap0ArnJIOlw0lliq7eIoFNGf9/nDBS+Jepw7WJKwzH8dWGp2PXwYLYibDEq1lq58BtpN6po+HntPohC6DzVYjSYSgF48pEgVW90eCy7XKlQ93wYxFwg3crysfOAQ6nNsi9lWa3KXLde2WCoWiAE1j77CcnNfEz0Tq4X6f9QOWekTXqscKBxSu/1eCwzO2jrl3m+CCTbQ3M0zXAWALSTQapsMXydPC10pPnc1AttawKgGtrAYTzyoEoIVO08MekS7dcGQNzc6ITWpiAjQm3zy6ieHsikfS8UKNnV4J3Aw+hRbVhw8M+siLbdK4XVgd+edtL4hgWPA4E03YPpfINDEDiNNqeoDDjiN2+tBTUTEedgIYAdlGtw/x6hPzxBPvcuRHM1ZtrWgPEEVxBj1frvYm5YbMQDwJChBTX35OfA/gL78x8xEXoE3oGun1Y6fYXLDAzLKOy+Mk5z5gSgNSwL0qGB0ZvDxqZD2ApukHMHIZ3d+8aBQf0NijOSQiYbEPNmSCWZPZJFh1GuQjw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(186009)(1800799009)(82310400011)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(40460700003)(40480700001)(478600001)(70586007)(70206006)(54906003)(6916009)(6666004)(47076005)(36860700001)(83380400001)(86362001)(356005)(82740400003)(316002)(336012)(16526019)(26005)(1076003)(2616005)(426003)(41300700001)(44832011)(36756003)(81166007)(7416002)(4326008)(7406005)(8936002)(5660300002)(8676002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:29:06.8004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a75589-b38e-49a8-8f50-08dbce4bdf68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 4 ++++
 arch/x86/mm/fault.c            | 1 +
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index afa524325e55..136707d7a961 100644
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
@@ -13,6 +15,7 @@
  *   bit 5 ==				1: protection keys block access
  *   bit 6 ==				1: shadow stack access fault
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was due to RMP violation
  */
 enum x86_pf_error_code {
 	X86_PF_PROT	=		1 << 0,
@@ -23,6 +26,7 @@ enum x86_pf_error_code {
 	X86_PF_PK	=		1 << 5,
 	X86_PF_SHSTK	=		1 << 6,
 	X86_PF_SGX	=		1 << 15,
+	X86_PF_RMP	=		1 << 31,
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ab778eac1952..7858b9515d4a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -547,6 +547,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "RMP violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.25.1

