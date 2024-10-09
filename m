Return-Path: <kvm+bounces-28203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3040899655D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53D771C23D4E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B139218E02B;
	Wed,  9 Oct 2024 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b+j7bGhS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DC018CBF9;
	Wed,  9 Oct 2024 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466165; cv=fail; b=NMq+iVcqe/cmSR5UPjLzDQqLn+ejshFJf3KXhyLTJTykKmiGwelfjk7ccs4EP6411OcbP8Oo10OE/OaBT8n1HyHyX5Y669vElmjO66S4Vg7ITvtDlYEBa94jZlGT1Mm21foUbrSg7aOfqeh2OUhvYTubHntuDmB824T2uhqG80Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466165; c=relaxed/simple;
	bh=nvFwflWtEXBHBOepuefTE8W/XPlcOm1GopzdhrcCyJM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUy5vquBEGFRceLMmTNin3Ptvno1rpFhHpw8kbPQP6BbO451zlvBYKVUcI359G/yUM9Fi3mpEwojmd6cNW29al4Z4ZR3hGjJ04n1q5cEiygYkfQNMvjB5ANqBWKCLp6sNWzJiNHCjFnP5mJA2AjNg04wJt2zQqHafy982u5FsUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b+j7bGhS; arc=fail smtp.client-ip=40.107.212.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7ByOmbRqOue2ur8MsNt3chlSQrSpFx+PSZWhB5Hhh3tUxtmJ7TamF+oE3RCtO2QB4GbkWR3+iBU7ssfe2F3KAJKuNhKPtGhJs4piXIicqKrlw3IZ57DLMOjcoHiQYaiPYo1qeMb23RuXV9oaR2P8mlipzKozNGMk5OGBR3XL0MP6ppM4E/BEwQHVg5Vjd/82ZevY6yNt/v9OgmoMgBO+r9DyRBeXErk3yFmu5CWCvF2m9/1SFG3cvlVGdiKrnmnX2LKmEgZuIB6RCbZCHJE30D59X+B3govLNL8TYyBo0JGeRk0T43heY9dLIx7nvKoRaIh+UjFoiG3+U0m5rvKpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fYhzEuhBn6YEMIao7FDsD/MSmaCaFCHu501dahjc30=;
 b=rqFnu1njMChIVhVG9pMZ00wAv9AecVOW5jijzHvoNtyDYRa/t4ePK/FLSLLfgZ4yX3MLsXG2G3fcSUXK//Qa1YUnB6lHtg0WYfh/mqrH03O2V9xM0/EVbVHZepyuyOBnojX3V8tmFpQf4IEtfuE/y7fAmVuzEtISoenSQCXkSZLln4Zu0HA6P/sNouuANQGzgGJmlYiyQKio/Ylx0WNH3yDX16SIyBY1TWl0lwwnO+zhKKblgVyqzpDR/HFS7qkxVWdJgSDUHahyeyBXZ0yvDtqvVCZY7LFk8m/ZVTS5yHIlijA0sxTMI/66tX/WbecN4taKpsB1duLc1RsR0f6g8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fYhzEuhBn6YEMIao7FDsD/MSmaCaFCHu501dahjc30=;
 b=b+j7bGhStFMc+y5WlVK5aofaA7u0YXLxPd5P5gp0hn1sGlHToZJOk4n0SBf7wIMuizKyb0EfwJmH8CZzMeLYiirHh69F6VXYLrpxVnm+rngkHpWXewm/MxKPNH7WpO52HtU7yFSnfTLWf0Kl4WrKuiwm32urcHuXDeEWouuD1MA=
Received: from MN0P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::18)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:18 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::36) by MN0P220CA0024.outlook.office365.com
 (2603:10b6:208:52e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:17 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:14 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 02/19] x86/sev: Handle failures from snp_init()
Date: Wed, 9 Oct 2024 14:58:33 +0530
Message-ID: <20241009092850.197575-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: be4ccdf3-07dc-4634-0c31-08dce844d93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?syjP6TuaOIFw8iireHXj4KrmF06yxx7mO1crb6KOzLjbOMLGEbziILjGcwqn?=
 =?us-ascii?Q?47uH/rHIAdd4ZJ3dMF1Q8zQtMlpyscfYu1y26QK9c3700Fc0eOxzYXLdZZ0P?=
 =?us-ascii?Q?tSRVGC/Cp9LOllrAFjSTiMSFoN75Mu6ZmEPNQ72VPvUzj/7Vfa43dRodlL9q?=
 =?us-ascii?Q?MpwwwcTbRVoBj9AQYCgIxa8G7B04iKkOAif7929nLXvNvPl1ic8B2k6Oo8q2?=
 =?us-ascii?Q?/GOcL8l0l/rVsWpSuf/XwyjPVYOkH6zMmSQkE+wRrCXQM9XGp6cd84H1hqyy?=
 =?us-ascii?Q?fFu0pclcw8Mq0cR0u7tpdPyiyph+nkMQCPm74IPXBuTS5kBZt4RY6+NlQevn?=
 =?us-ascii?Q?k+Gx9KI4w3s7iUFI2t7VaORVU5YFHXRisfMHqwNLFIcOoDuOe4ZA8e/MA4K6?=
 =?us-ascii?Q?wH0aUg+Bk2q0Zn9pfLGtiz+AB1p1Jknly4aXrhau0uwguLjPkfeA+g8d+bKz?=
 =?us-ascii?Q?9AZlxYb0uCGovBBCDmUgUoDPpxPW4GExkNuwGxTpmowMhefyv3mEE3h2ZrI9?=
 =?us-ascii?Q?95syzhzhTm3oAhRCKcxNIGf5BI2aGfKMVq9yETqn4Z35em704/zj1NCAJ6W3?=
 =?us-ascii?Q?HhIgpFeMkkDnjIBwXTxtJcIH+o+3dDqlc7VPT1jJaol7OBInMxMhe2LUEAu/?=
 =?us-ascii?Q?QCkpgmJS+h9V0cVMQmWc6sVIk4wFvBr+Y+/Xzut3igOsCb9p2FSxH63rPEIa?=
 =?us-ascii?Q?0WEBbriHjUvoKjNraE7oQxHnzZpSrqL/jUxxKzz/Qf/3HYG7Vc59o0AjMA5B?=
 =?us-ascii?Q?/+fKXJxyzdSptz7bS4BS2bfnRZRu+wUOzHU4dQ32kaLGcxl0G6ahcAL0bcGk?=
 =?us-ascii?Q?o7kN0oGAVgoijPFn/d6fVSZ+ij/SPTJlL8Q+rG1Occxs9kib/eg4XToNi4JR?=
 =?us-ascii?Q?In2mkYPbP683G2fSyIwusxk7mW2jGTnwjmFBYMNIkLn0BUsSxHX+u6nohjNH?=
 =?us-ascii?Q?pCUMf4yFPSLNDqr0EayLchFN5MHovbmybDDv7QtIRkS1XM7I/LAHjg8N8UgF?=
 =?us-ascii?Q?AZLuAU/Czvs4+YHUa3iUnHzBDOaVWeNghBtCePa6366qHCccna+rqFxZA7bt?=
 =?us-ascii?Q?1temAprlNFaLrQEmSMPpw1dM5w8PF/YlOldXEVi2XhPl6qtHZlyf4n1FvKhL?=
 =?us-ascii?Q?6u1uRijP3kU8gUvU3wISMXOCnVduDN9k+v+cl1rcNdqcKbbtbhemNw2yELGh?=
 =?us-ascii?Q?W4whqCTiWIF1COumdTF2pF0OilFs5oVOo0iqOe6tVtWQDwRa9J2RQ9T6qPHr?=
 =?us-ascii?Q?d3+9ctqxxMPFy6X33wysMLQWJiskMlvtfT8xMd29y3XN01kP1nfP2Xrugd/B?=
 =?us-ascii?Q?Wq/uho5gHCF9jfxLVTAZuM6SnExRMNqfdh6Q85ZxJmr857Ti4lHNLBjP8mAS?=
 =?us-ascii?Q?9yyjehuqcxhj12nzIZDJNHW9+Jbg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:17.9063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4ccdf3-07dc-4634-0c31-08dce844d93d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571

Address the ignored failures from snp_init() in sme_enable(). Add error
handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
blob or encounters issues while parsing the CC blob. Ensure that SNP guests
will error out early, preventing delayed error reporting or undefined
behavior.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/mm/mem_encrypt_identity.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index ac33b2263a43..e6c7686f443a 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -495,10 +495,10 @@ void __head sme_enable(struct boot_params *bp)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;
 	unsigned long me_mask;
-	bool snp;
+	bool snp_en;
 	u64 msr;
 
-	snp = snp_init(bp);
+	snp_en = snp_init(bp);
 
 	/* Check for the SME/SEV support leaf */
 	eax = 0x80000000;
@@ -531,8 +531,11 @@ void __head sme_enable(struct boot_params *bp)
 	RIP_REL_REF(sev_status) = msr = __rdmsr(MSR_AMD64_SEV);
 	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
-	/* The SEV-SNP CC blob should never be present unless SEV-SNP is enabled. */
-	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
+	/*
+	 * Any discrepancies between the presence of a CC blob and SNP
+	 * enablement abort the guest.
+	 */
+	if (snp_en ^ !!(msr & MSR_AMD64_SEV_SNP_ENABLED))
 		snp_abort();
 
 	/* Check if memory encryption is enabled */
-- 
2.34.1


