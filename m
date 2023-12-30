Return-Path: <kvm+bounces-5343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D3F820723
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5729E1F21018
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB69BA33;
	Sat, 30 Dec 2023 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uPLjsqsq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4477BDDC6;
	Sat, 30 Dec 2023 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrUmHpRluYsyM8UdOuTB+xbz4FfuBM78uSx+ozYgXzBzDNgrsOTmRUraTjVQ0x1heONdlHQUGM9VWcRKMkIRxJ9DCwJwIIib829c2zhtJJjbWeO5eP1Cm46b2vtnatd4IecamjYfX49W1b1QlyUT0fGDF+vXLG6XlyCB6AayFvCYHr71lfqcFZIN9f0nKeWamDKjuc4IyoK8xRVaffGzF0lWyi3Aykj5YOOe/dpAtUAFM+fWRv8pp4d2EoEOnyt1lCkAkUjWY+/rVKe3Bu8qFAj3YMbzikaEp1K9qKOXhWZvmSzrl0GUlE+tRmrhi+OrCCOmNyMFsBFW1t7axffJxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vg8hNqxzPvTdDJnhMLzezvdd7rMr6n6xVpdNNd8ZLxA=;
 b=X//58TzVKxgoGOoGoV5eb25mM4SYRwZwnzapknXosmz4MjYMCxmMD31l8rO5J7mqLbTv5sWZRmf8/6rnGwdLbR1NtSBdltwrpkukF99LhpJ6w0a+quOq5d8X5tuRDJxfl89L8vQ+1FEG7SaSH42KsLq6fvys2S/yYo0yqMTK56FlhxMKZPOxK+re1KCLzLvhtuRFNuHJrt1IztNE49cm7VZ83X7zLllNpvWmqiDuQy9R3bT+WiIKYVo1PZeSG9u/kq1l/Wb+UlevGmp3uNaHOCLtBvdQ0YcNKkA//VN4QiNUjTbF17eTtQ4Ngyi4PVGkAKae/YnE41i75JTd7ZgL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vg8hNqxzPvTdDJnhMLzezvdd7rMr6n6xVpdNNd8ZLxA=;
 b=uPLjsqsqFnorc3dVuzj0Q8nrVZ3S5rIumCLQJ7g7Je7P7E7Y4sPhb07Wxtk8F3ttlraFRlggztaPZ4JU8TgHPvX8IYKywmf8tLcX8xYCt9UIdXVyqaPPTWF+18PTMe6tX1El6dZYi9HcqosWuqXZ5+PcLEtEHa3RzWQMl09ScGE=
Received: from CH0PR03CA0325.namprd03.prod.outlook.com (2603:10b6:610:118::31)
 by DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 16:21:25 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::6b) by CH0PR03CA0325.outlook.office365.com
 (2603:10b6:610:118::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 16:21:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:21:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:21:25 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v1 08/26] x86/traps: Define RMP violation #PF error code
Date: Sat, 30 Dec 2023 10:19:36 -0600
Message-ID: <20231230161954.569267-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|DM6PR12MB4484:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8f7c36-8b31-4dba-fc97-08dc09535ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jyw3aszWCCxgHt5su6iUL7Rt8LbwZWJjiktcne7frUgxtn8qbw+ibcSLgbaMwI3M7PeDLJqSBveuRD27cAyTKe8C3GBViBht7qnfEGcxAVAs5NtnpqSgwVWZSPd42ErmMsP5VIrd0gdZHhk5AkReSaH5Hy/oos23lvJEobQ7VpRvt96smSIubUpxPdp/zQcKz4Ffc7ZbdU+Yivd2DQir4U3khpBjBJNFyiL6FK9q2J/ra0ZSKj4cgijuMnS8DkPw+XrKHKmgnaiMMA7qm28ebxsJ1XiKeuekO8QlaR1dWFKlh6E66Ox3WPZ8LMrQyE+zY5sYIbHHieQml82cFYawaCj1Lf1KSUv25oV7RTgpW1N1TbDdsLCcCVCsdebXWTP4MwJYAFPdcHurWYQ+neeAb3Xn5A30v7od0qWz0LBp8FCQABvw8sg2zW9KEq8/OZDoEa1+odZTCbRORDHaoyDgas9lJB0XJXga1bZgJPrs97TXkGnO/xXamoet7EM7kAcuKOlEgtG3CwhaqkXssXf36qQd8ujtBKI0sJ6CraZKmnF271JA4uLXvm02e6qXP86M2Wn6gv7K4SC615uFN6h3LCdo+mT2ac40i/5unU6UcK7sERqCHsW5+4OCxBTSCavNiuwDbkrV/Z3hwt0t+26Wu8+S3vXmyq02ThqL6MiRNsJsDAUxOfJUoHlIo2UmX3xDwwX704axdywRGbCW0PQpW5lMcCJJbWVmBH/lysGzOOWyIk6bCOeuw5ZNOaBkytuAom9826fZQbakdA377f/KZw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(6666004)(36860700001)(478600001)(86362001)(81166007)(36756003)(82740400003)(356005)(7406005)(7416002)(41300700001)(2906002)(83380400001)(2616005)(1076003)(426003)(336012)(26005)(16526019)(47076005)(44832011)(316002)(54906003)(6916009)(5660300002)(70586007)(70206006)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:21:25.5653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8f7c36-8b31-4dba-fc97-08dc09535ebe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484

From: Brijesh Singh <brijesh.singh@amd.com>

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 20 ++++++++++++--------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index afa524325e55..7fc4db774dd6 100644
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
@@ -13,16 +15,18 @@
  *   bit 5 ==				1: protection keys block access
  *   bit 6 ==				1: shadow stack access fault
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
-	X86_PF_SHSTK	=		1 << 6,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT(0),
+	X86_PF_WRITE	=		BIT(1),
+	X86_PF_USER	=		BIT(2),
+	X86_PF_RSVD	=		BIT(3),
+	X86_PF_INSTR	=		BIT(4),
+	X86_PF_PK	=		BIT(5),
+	X86_PF_SHSTK	=		BIT(6),
+	X86_PF_SGX	=		BIT(15),
+	X86_PF_RMP	=		BIT(31),
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


