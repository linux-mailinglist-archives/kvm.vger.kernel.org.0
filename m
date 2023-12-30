Return-Path: <kvm+bounces-5369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E992782077A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48209B2198E
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0FE15AC2;
	Sat, 30 Dec 2023 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LX0cMnah"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B50156EC;
	Sat, 30 Dec 2023 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNVNV0jyxsmEvVyLgF2Svxz2XNXsutze1uuLhcNJMa00euVQlK5Fmq1lPH4wNl2R6Gh2uUcmXpFmudSA9aLppgx0R2ITadYfy4FRlPeUbolEqNTRe6++EXGacfe2axVoTrkzKuVswzQPaoOYJT2EUB1n9TgXBRHIoNS0R/8i1CuyF7//HD+EXSYTUAJpQbOK9Ce9OCTdpmcQCaujGLj2izHdy2Ew5iuHzQ2igZP7kmvwjM1Hwg5hjSUB9kiu0ZzEucdRVENyTgNI+zJZGQSJhjS9cP2bdv/rQ8S8GnEM0HGMEx7j3P77yOQSjYbqwY5V/wX4Ex/2USmtrltwDI6aGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvsYf0n2GxElwqDzXGtfzBBHQRJyP8zKv4HrR1SkNBs=;
 b=IVazzJ5E1LbWWdE4AMSriJD3xhfvprx+gNfS+xTYPs1cUNTnZD54bVUXzv5feky0obigd4npV6NozelL0wiQ83WDeWaxaqS4hhYpMOlDAY5o+Jwv2swiQ47tjgkLIAGd3UvA/yhbHQTCI4a5/jAAAAuTdTkqO3sMCFHSnf1ueohJLKMiMF2Z36G68PnzWu6m1O9apKaYg6123UCmZkxuZyfU2OVeVWrvlPjUZSSxZMYSe91OQELwPPxLcSKsS39JMHIJIpxfrgiCgbi/Xbi0KZtNlTSg90GyfApK+x78jlCqvennhYfR7UBcJVF5C77FMUHG2LGziaCtqYkc6ncxvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvsYf0n2GxElwqDzXGtfzBBHQRJyP8zKv4HrR1SkNBs=;
 b=LX0cMnah+beOhxX7Wkpv6PLcyBAHhCBp+WIruAhj/n4OyhxNA8QI8GT4VtGnIL04smm9SYrwFUXjF3JNSfg5s+WdRWHUH2AvaBnFtlC15Lce0tP7lDxMaaZtiebbJZBYxdM7lOoN0b6Rvjk1yuyJa9+InfaBhpm6hImqDMaMP3g=
Received: from SA9P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::33)
 by CH0PR12MB5299.namprd12.prod.outlook.com (2603:10b6:610:d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:30:27 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:806:26:cafe::b7) by SA9P223CA0028.outlook.office365.com
 (2603:10b6:806:26::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Sat, 30 Dec 2023 16:30:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:30:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:30:26 -0600
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
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: [PATCH v1 05/26] x86/mtrr: Don't print errors if MtrrFixDramModEn is set when SNP enabled
Date: Sat, 30 Dec 2023 10:19:33 -0600
Message-ID: <20231230161954.569267-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|CH0PR12MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e12e1e-62b1-490c-5e4c-08dc0954a156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pNqUTEasT68+PI7tuKei4cA2VnNa763bd30gN6xo6vb7b/Pvy4jWIz0jALTcxn5uvf9bC0yk7DdDMl9veJfkHAUAcY825WJdwOKbAi9x8YwuvLpUe6u1/NgvLFeNysE1nKAiD2FBkGqy3bpNqW9ts5js9DteHgHIQR5N/UHRMzKisRx4uy5W/UjCe9LLo1PtnMEK2zzQf7VUNhHJOu8azb9fe3+8NWxCszhWFJ5DiyZj3h2gaRDFYpRDF1IqsnIWXConHzMIYm7ie/oa9YP9SueNuQLzouqLW0FV6SH/Ps/leYgiZ9BcHoUx6x76hA2hRBfeuAmd/f0IaSTGfxj6NcRAzh7ec948Dzracre0xIqKPbtBIOgo/GS+cZh1qYUQpAf0nxX+sc0JilGvmO/s0BxFHh/wK/xUIcYHlwExNXcEs+a/e8mWRxvYU8AJ9kVcu1IVvFCqEvuX3BTmOmnfxk4wjtlZ7ONI40iEe68j3Y8tRh2KY5YWhrW9CTcObl9GWUL/KBXzh8cIQFczQANWvs7g329WTBA8LJa0+grUub2RxOoYeFXpuORtlmwRCttsVHrcm9AWPTsyRldCesN1oIF4M3XjPoo4ALZtHJCVCS9CAghVN++W8yAT/Dtdx4zVD+4pSoW+f4+eX6oXpqkos1VpjvJSGV6+VdNvqIM4dV7aQXD4SEQQjDi/IjYrW/ghux54lfDmzCZIFzzaN/YIfwcIHftr31PCCcSmpGFM/mBUdubcB5toAbGeV64pEGjKcOE55txIZ/Th2jvcci6LDQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(966005)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(54906003)(81166007)(70206006)(70586007)(6666004)(47076005)(336012)(426003)(16526019)(26005)(1076003)(40480700001)(83380400001)(8676002)(8936002)(2616005)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:30:26.7993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e12e1e-62b1-490c-5e4c-08dc0954a156
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5299

From: Ashish Kalra <ashish.kalra@amd.com>

SNP enabled platforms require the MtrrFixDramModeEn bit to be set across
all CPUs when SNP is enabled. Therefore, don't print error messages when
MtrrFixDramModeEn is set when bringing CPUs online.

Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Closes: https://lore.kernel.org/kvm/68b2d6bf-bce7-47f9-bebb-2652cc923ff9@linux.microsoft.com/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index d3524778a545..422a4ddc2ab7 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,6 +108,9 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >= 0x0f)))
 		return;
 
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
 		pr_err(FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
-- 
2.25.1


