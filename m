Return-Path: <kvm+bounces-5365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9503382076B
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EE0E1F20F8A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB0713ADA;
	Sat, 30 Dec 2023 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xD2z1hUM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2381640C;
	Sat, 30 Dec 2023 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0/ZHIoHTvl8USZtqxbBU3Usza+8xuWqp3s9uryAoXHgRATxEtlMxaKEZWNS/4zoSoG7dp0QrY1snCbgebkp/yLRjYXDhBY3/It1WJ4XHFK3rQYUtqv+xgOdlERQE0hfXqcaHJxXykiyF/K/r///0+JcdOVgI74tGhfPmk4BopmK9j5lbMJJvu3BnhI0sxMgBI2DbSjfw72cG0IxK2B0iqXAvIMctxQeYTO3dJK6juOv34FHwRdNr4+RlyRneCYFDHNzL1XJqIguBbKEL+ooYuQ3g9kkKqC8Hl+fM6EBeDxilFReMFOD3p6q2EAiWUux0PU46UpN4rUfTVewfbbAwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EBkuuwAMxgLT2/1D4+e0YMYOmHg0aHx1LaOEpXzh5DM=;
 b=b4mD1h8SMYNGr6c35AA8Q3AqSAT1nWEjZAT4IXN0qVGzXSqWg3t6wqGPEGw9tV5QxlFVICGD2OFFJyf7VM6a87FriatsEEztUU3rplOzgsfAOsTwZ99697Se5w10zqEI/ABEueEvac8MdtXXdVkRAKrog7gizjFQuPd+E3w73epy47GigxiBGBZ2fOWGhmqBfY89k33/SwMWYlfJw9lE+HuqvF7r1uI+CzigqnyroN+p0UW6HgsoPFHDXooegbNYYjCLvxelmGcRREjx108BOSEDWEhfON/W5nMqpwngNI976J7JaiegTomcZzJ1ybMk3yvKZD/mFqq0eAdJw/4Egw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBkuuwAMxgLT2/1D4+e0YMYOmHg0aHx1LaOEpXzh5DM=;
 b=xD2z1hUMJXk71CiW+kqtZ7tdx8turCSTvXZnW2NZhvgsPwmgGDH/KAoeK1KhQ/XglE5HYNXKIlMx1KXS8Jgrv9J7eIABm4ATDNhEzZcTf8jh4KOjaLqh/KIVvwt+EmurljcxsfBTga6LNY4HCX2KzTauVMH3yOVh5ZgO8jYW/DQ=
Received: from DS7PR05CA0092.namprd05.prod.outlook.com (2603:10b6:8:56::10) by
 IA1PR12MB7565.namprd12.prod.outlook.com (2603:10b6:208:42f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:29:03 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:8:56:cafe::2a) by DS7PR05CA0092.outlook.office365.com
 (2603:10b6:8:56::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.9 via Frontend
 Transport; Sat, 30 Dec 2023 16:29:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:29:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:29:03 -0600
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
	Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH v1 01/26] x86/cpufeatures: Add SEV-SNP CPU feature
Date: Sat, 30 Dec 2023 10:19:29 -0600
Message-ID: <20231230161954.569267-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|IA1PR12MB7565:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f9912a-3907-4544-83c5-08dc09546fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4EGvFaMWuvDf6qX7lC7xwkmN/VL5fZB1Bu0gQ/13PXX7XAzFxKP4zfO/ThDS2qEgr2A7GLrcyfFg+ExZlJr5c5BdWTg2dfMVIDuGHPdYqlm8ZNt9Zt+srWAuIxulDsmWTMgfXelW09hcd7QCQqjFSkAk5vSPEtCpEUAtZCRRZZa7VOJ41OPRwlmex4yjSEAaDvHPcSqr6cklqAzay71R6AUst/ctNOdn9UH/e/ohI9H9b7WGvrdCGanepn0BiwNl0ieirzbwUIyoAYziEilAODbvPFd/qChjw3AdxRgAQPhamTkcghRRhTuOYm7kIIVG5vV6Holtt5s+T4RO46PrDJMN2Xnhhi5h9NtdsfAaqFkoZStqSJvKv9iwBcA+yM4oO9PY9LUdp1m/CniJo5jfO+vsaea0gCA6kyhsnDY9mn2ixlkYy1OsFbgBAyLOyvEQaoZe3FIs82q8bGRHNPlHrQSwlI374S6EeSRwpDRAewLq//PV7I5kdwIKT/OzDfzdQKMrU0GFJCmww2zhhodveCZKVScJFlV7qbT25906/315tQwBDMVTWclaflKyvMF9eGUGQcgsJnaxrN7kGBYR2v/IIDtJ7J3LRPBM/PB32FIBNe1HgN25y4ABJdCs28n973L9jLnDqhrJonOQE3kZiStTmkzTLnnaC5blbBqztG04R9pEWnew486ENm9RPNu6CZ0i6dKFY/+TNq65D3rVWhmF4qA2NpZsysWEdV3CdxLyhmNPY7I4OkCz5PgpkKpIyzILmybPVCpwlR4ANsK4gA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(396003)(376002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(336012)(2616005)(16526019)(83380400001)(426003)(1076003)(26005)(86362001)(81166007)(36756003)(82740400003)(356005)(47076005)(4326008)(44832011)(5660300002)(7406005)(7416002)(6666004)(36860700001)(54906003)(8936002)(8676002)(70206006)(70586007)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:29:03.5817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f9912a-3907-4544-83c5-08dc09546fc3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7565

From: Brijesh Singh <brijesh.singh@amd.com>

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Since enabling the SNP CPU feature imposes a number of additional
requirements on host initialization and handling legacy firmware APIs
for SEV/SEV-ES guests, only introduce the CPU feature bit so that the
relevant handling can be added, but leave it disabled via a
disabled-features mask.

Once all the necessary changes needed to maintain legacy SEV/SEV-ES
support are introduced in subsequent patches, the SNP feature bit will
be unmasked/enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/include/asm/disabled-features.h | 4 +++-
 arch/x86/kernel/cpu/amd.c                | 5 +++--
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 29cb275a219d..9492dcad560d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -442,6 +442,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 702d93fdd10e..a864a5b208fa 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,6 +117,8 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
+#define DISABLE_SEV_SNP		0
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -141,7 +143,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	(DISABLE_IBT)
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK20	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9f42d1c59e09..9a17165dfe84 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -592,8 +592,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      SME feature (set in scattered.c).
 	 *	      If the kernel has not enabled SME via any means then
 	 *	      don't advertise the SME feature.
-	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
+	 *	      any additional functionality based on it.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -628,6 +628,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index f4542d2718f4..e58bd69356ee 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -437,6 +437,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
-- 
2.25.1


