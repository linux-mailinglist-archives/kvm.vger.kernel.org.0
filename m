Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E3D64D05A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiLNTww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiLNTwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:52:08 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDA102;
        Wed, 14 Dec 2022 11:50:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEMR9k3bWggy3zLcG+Uxs5Qi2IQxSxsmOQTspnew0tuLFktWmeLHqHrItoFri44FLPkjIfcREk5E0rcmcaZQ2OpI67Ox5ZQkQs0ZnUalATHSLNUB0ESUN6HvH7oeIHdRr+TDKns4aMDxSA03eZiMRhfD2TiMFLFHiMJCeJo1CYNR2lL1reQDKVY49U1t+wOP6QaSJ6d4zluEinYDEDT847wGKrYg/TBXveABSXCZtzMpyydUV4LqbhLbSPINGMa8Uco4LgLkoPVYVSBP3RezcCmIVcN6wJ29vmHTauEgOrgbbFevcCzv52j83qIYaAuGtQVW70E6q0yvtwxitZrN/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaE99ZyE9fPNXP1+sCNkKPB9OJSZnnK2iy4k/8TUgSg=;
 b=WFRYR4lGWdXP/K5hoVSmr+hzDGmtiQ8pZ0BFY2QXmSWrXrVzctTEQXHoKlK4B72QiEz0JBSU8Qh2jUNuC4+bhNq2KkU2ula+zPn9MIgP2RAbZ/gnLxFaEcz2Tw9SLPEChtu4/9pmRZDzVrfatz91C4J+g7opb7lToA238/AKwSosYkjUmzyDUV65Mi9iLBaG6t7alGLD0MgNIwNL+AdnMhO7taw9ID7ZKF/Uv7dNVDbAsD01/7sZcjd/pQ78DC+JtiWi0XJ8rh7phqP3ZuZOddMIqPhs/Lt5IYUZ96pPWlZuzhDy+4Es3rVPGTUgG0jnrv+DVJ8PEjW6o0fefqTx4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaE99ZyE9fPNXP1+sCNkKPB9OJSZnnK2iy4k/8TUgSg=;
 b=5OWEKjdS/EQKZbw3YVCW7utdhryuOCmQZOIWxDpD3nkPNELnih/L9umKdzQbgoCkktJQGSLCm2GlPsv10ciChl9uKqu0CwnEE55RVPyn7DgJCCdsQhClvB54BiWo0wKVkrCZnXgHs2ES1iFU2zLyCwQzaZrevVZz4vLWTDmQUik=
Received: from CY5P221CA0085.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::41) by
 CH3PR12MB7739.namprd12.prod.outlook.com (2603:10b6:610:151::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:50:35 +0000
Received: from CY4PEPF0000C97B.namprd02.prod.outlook.com
 (2603:10b6:930:9:cafe::8e) by CY5P221CA0085.outlook.office365.com
 (2603:10b6:930:9::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97B.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.9 via Frontend Transport; Wed, 14 Dec 2022 19:50:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:50:34 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 19/64] x86/traps: Define RMP violation #PF error code
Date:   Wed, 14 Dec 2022 13:40:11 -0600
Message-ID: <20221214194056.161492-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97B:EE_|CH3PR12MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 07312df0-0df1-4361-20a1-08dade0c77a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJTUvFSfCY3nCSvwEHoQlZesbGpDSU6DqU9Llr5VhC4XQQrp0usk+9d3z1ic4mLhufQVVrbqr8e+XJxtLIRAbaXOyLxQEG2mYqLWeM8P9ph+iuHXeOZHHeFr6nvl+DaRvIEqSecAZBvI8bLIHjvunFSbL1CkcSg3SpYSIKIBrPIxrM2TS30i/ICum6JcqcwzhiTR73iNg71xR2FMyZ4aHjOKAWkdrlV0fh7saCuS/aJls1HjTZ4QafKcN8qmKGYmQcwXj2W2IK2CAn1y/s89ijUqcZTS2khdsn5VlQRzl7ZFg1A/ZbKrOx1ISylPx/+FfypmGyfRDKUOlUTeK/AwIi5PWUXQ6gRFdgFrolZbJDxbNSmOLFoM2BmMctaZizbF8Vz6ha9LouVLV1EC6g1wFW712fgT2sR8sfjYVLQHNGItzvk5MQR+t5JqkNdSqaNPP+mHNNXclMibOKU5hUgzhU4dspMG05Gf37r7JmHSIZzVi22hz1toAxWx7mT2tU360edSNgg0L18FoN3ueXexu6hskk3r0k6BDzCyWczgEvYB0adgSc5OUuzu7x2hd0i0fXct2ShI0yvWgX5TXAWEu81Lfdtw4jrlR0j6vIPVyXZk6pp3JSNVdbcOvgQ3Tt00D3OXjvZbd4gwtj4QXGsHA/ZhYMLmodV1vPpwN58O3FbNLNL6rGCI/RLrjwavnD7Si1M/O0dVel4iN2n3s58W1a9Wih7mtGlRqxycWWQj6FY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(316002)(54906003)(6916009)(70206006)(4326008)(1076003)(2616005)(6666004)(16526019)(478600001)(186003)(70586007)(8676002)(26005)(8936002)(41300700001)(336012)(426003)(47076005)(83380400001)(5660300002)(7416002)(44832011)(7406005)(2906002)(36756003)(36860700001)(82740400003)(40480700001)(81166007)(356005)(86362001)(40460700003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:50:35.2781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07312df0-0df1-4361-20a1-08dade0c77a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

