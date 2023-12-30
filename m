Return-Path: <kvm+bounces-5366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A941C82076E
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 602CB2823E2
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A8B16426;
	Sat, 30 Dec 2023 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0UE+kHcz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA916409;
	Sat, 30 Dec 2023 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1D/++CPU8UJe1erRU/HVEm2Mjb5cOEiC2jqKSZXAsgqr1OSA9zmVq22BjEZ0ltkj6hQjBQeOg++e9K81Og5nbSDeEbZkUVquqAX9+ywSOVDjepbv2UwOpfws/BvrGJAgbfirmLg1HCwhpl2F8Cq6Y//PmicPRY7uTbh4EqZ1bEidlNtb2lkGjas9gGYsAdg6tFaOcx8DsG8mtzVNXkyqEYMlrsNEZTqBD5C6R4oDt8tD2X+rN3UIGJl5DJNhNRKreqyUCi/nRg32fNJFlGmNSCYvjQrOrFvL3dPH/qHLexVP9duuMpgp9hrqmKBVABbRgiRJ9snnHVXeZbaFUnotQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42bfQ6FeSVGZCam3Ke+AMjdPhfDYAoqjZO55LNOmw0E=;
 b=ASbZWs3Q6F7fefk5otFL/AQ3UCKiwuBf68JX72Cg6+UqYnaDTl+jhMkX6I7EM4j5UzOZtQD8ewAmgyQmUoL/cyRv48rYrJM7nzIE1diiC8p+3mxAadz0kMzi9HZuTBzkEgsIghAjOAYNONMzSBC43rOGrCJ/7xSwJbC9fbDTtlMdGiS6qSq3jKdhGRuAd6xfV5ETCSTHZayG0aTDF4GZK8ts97AI+aH2YuvvR93LlE22zgPxGA9y7OK/ogjvWSW/Cgv5ysBSF2kRo+RutSBU/5lY14C7vdtZ5mGzM62nqKw8jKV4M8ZnVbmgZkBy6WAtGJJUlQrl1mdE8iLpd8Ch0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42bfQ6FeSVGZCam3Ke+AMjdPhfDYAoqjZO55LNOmw0E=;
 b=0UE+kHczYBTrGZIxL6IOVvI1Nto3+TTKJyCnfavODjOHjD/UwmRcE9KoBCPVMSkjXwtf5J9JbQ4oA9hhmXzDNUBrCwDX7XyQcc61yUif2GVm8wCUjLCJ248eO9oGem9v0gSvh+zseS9+uIPU5ZOdx6B0Sv23puZym2KnbpeGy5g=
Received: from PR1P264CA0186.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:344::15)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:29:29 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10a6:102:344:cafe::88) by PR1P264CA0186.outlook.office365.com
 (2603:10a6:102:344::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Sat, 30 Dec 2023 16:29:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:29:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:29:23 -0600
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
	Kim Phillips <kim.phillips@amd.com>, Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v1 02/26] x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled
Date: Sat, 30 Dec 2023 10:19:30 -0600
Message-ID: <20231230161954.569267-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|SJ0PR12MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e64321b-a432-4bc8-d8cc-08dc09547daa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eL5u6DGURLZ8vhhEZVbWiCkQbtyMVtVp6sjP/MD6uEj7P6peUBW1ek+d16q18ipphj0tJf0GPv3dqEqpmJd5p7FAKp2ZmXkYZ7ba+Wiub3pMizxKD6WDAgPEdiY4z30xprDJhXj6401ALe4I7OfOPG7FLZOmJT00lL/SV8DMjNqI2YiwwgVaksH9FAMu6ZQCKMUX7MW8IpLuGc12Q8UWp6U/iO6A7xMVJqKawXormqWKzn5P1co+Gb3PrezIBKlUQKhP0eDhKfiLF6104BcrKdqDNO2TO2MAcvtL3iRYd33xkIWnXeIjN173d9xkK+5qvhSsGYNndl2sGzU3xL1WfUCprwS2poyrvDkL9kJ5tbvCxO9hPkc2L1P0eAO8VL4npMH7XSMJLA2Mvgt7EDcTLavqFUeKYnWT2j1hYYHjqbBftLEOx77nGHVM9KXbJeAMqbf3vY4ibYpCYf05uYaQ9Cg+ajP5xDCFyneYuBIk7ZiISl7v3dRE5gLf7LCITFgWIka/Wrec36ZwVCpC+DasTQa7xd1GVc8yuHBZ45ccdPjtdg8TOvcpYwrfuWFgUV/MlVYgCRYTmbBM//iQIhs0CueVzZjvJoJLx79f0CuX2nv70xuaB0lXSP0N8Um4930jH3PE6AJ+BIFUtWV2y2SuDU1D6JjrIeyolWg6q3hyOGygCu/aAn1kUmZxIm/TD3ArpoZdiqQ+QuoPq2E//zmSlYFlNGSLtB02heKVWdsyUmXpXPuxSwBIxNb4MFMu/dGTmChKz56kzKV90Ot7Lv6zPQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(36860700001)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(81166007)(54906003)(70206006)(70586007)(6666004)(47076005)(336012)(426003)(16526019)(26005)(1076003)(40480700001)(83380400001)(8936002)(8676002)(2616005)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:29:26.9394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e64321b-a432-4bc8-d8cc-08dc09547daa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612

From: Kim Phillips <kim.phillips@amd.com>

Without SEV-SNP, Automatic IBRS protects only the kernel. But when
SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
host-side code, including userspace. This protection comes at a cost:
reduced userspace indirect branch performance.

To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
hosts. Fall back to retpolines instead.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
[mdr: squash in changes from review discussion]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8f367d376520..6b253440ea72 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1355,8 +1355,13 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	/*
 	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
 	 * flag and protect from vendor-specific bugs via the whitelist.
+	 *
+	 * Don't use AutoIBRS when SNP is enabled because it degrades host
+	 * userspace indirect branch performance.
 	 */
-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) ||
+	    (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	     !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
 		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-- 
2.25.1


