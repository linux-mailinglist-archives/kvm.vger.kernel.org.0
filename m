Return-Path: <kvm+bounces-15435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F068AC085
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:07:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9201F20A9B
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF103F9E9;
	Sun, 21 Apr 2024 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wn40Le87"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B143AC2B;
	Sun, 21 Apr 2024 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722798; cv=fail; b=lYs11dFY1NCKcM2NNN7VPyjNcFvFVlZ570iBkocexA8Wkm/hDy2LQkvwxqIReSQSUjgIV4w4ZVElvAVlj5DlCeWssolzm6kSDUhjzfbtJRU3F3MMEED4U5gLDngXFoL3BaOIkYlMlLo8fTH9cY04ZwBEI9PnaSNbdGA5DvYwlOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722798; c=relaxed/simple;
	bh=kM8UkVrgiNBzOeW+57a/SByD0XRC+1BYy0TLZqbdFLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptqdffZG7+xwxVGmMITVqMTTUd2vKxuVVDpk4T6LNWCqdxokinqhxJylFnuKz+u2mzwB9RslkBqWV6TsI+usKBKdVMYaVecx9Fv4u8trQyT9hpTw3d6RX/fex9TAw0F9DLcVplqiFofHx7i9X5i2UUo4QzOi4EEUcucKWiBZPJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wn40Le87; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7RU7YIic+iI1r/IacHFYbq+brVmTBzDBCSopRnpU4YQsvzNvlnXD2HDS6wgUd4N5D4+fDRhAi8x554xZoW8+35mufO3xMRPooayY7vlLucHB9nO9tzID+5BZp8jsE+aXoXWlX7XEDnu2DwZOODo3NKOph23u/YtD3sP6LG+84dJMxN7xrcpbdVwjdnQtK6/qu3zrfeeKq6Bxkt2Vk+HT3u1s3n6qcBzEVcbTwjjk8cVXeS+tMQcu0klNi0/R7fc/QgSFEv+YbZBF5W3Jowj+pkRmxe5qr5G7tLKheKZI3DoP2RflsiemD7KPPRDruGbemYk909FsU/vWkE4QUZtMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcTo69bz2FR2QQt37dRJeiSzEAGpfA9OYhZgvIIVOpk=;
 b=h8KRNLhd7HOd+RFMRj0JkB4ChnFtdPjFBJwfjDwJyg2yhTG1vAa13V9lnFqeiNCMl2v1k614rtFtdGr0Nv5OfGMiLrC4rBb0qYwB73H68HnIeeGyoWmoW96hVmMoRw3IMkE8BL37kdO8TX8QSiTTDjYoSQ5yIAsjcVTG8+mu7Rmp+Svy9ml79WVGVfgs7ljd/6Tuo7iOpjJnsgP9YEJR9xcn7jPYSRgONQBmfP2QeNraZbbI68MrNilqVHVYQ4aeRreQ/Te7WfhupRFe6IV9bzSqpVeT9zc+o6XUDG4ja8DFfEtoIHpchAOJ4h9kself5Pw7TUS7HMeWfBkvQMFJQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcTo69bz2FR2QQt37dRJeiSzEAGpfA9OYhZgvIIVOpk=;
 b=wn40Le87rhtx01MZwwCyPuuPGE8Ie82EzuISqmeeyLDkEhOWt+u+suTw4UdjV2vcYRQqsqvPo2EZNuw1UeQBawnRfOIoxqI4WS533qUgnRS8M4Yg33waquMADi97BcTZsDRdLhRwjLWeAYkyQLstDc2k6g0iGwOSfumHpAp+xgc=
Received: from BL1PR13CA0120.namprd13.prod.outlook.com (2603:10b6:208:2b9::35)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:06:34 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::62) by BL1PR13CA0120.outlook.office365.com
 (2603:10b6:208:2b9::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:06:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:06:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:06:33 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 17/22] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Sun, 21 Apr 2024 13:01:17 -0500
Message-ID: <20240421180122.1650812-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca948b7-bf41-41b4-ec30-08dc622dc77f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bMr6STBnd4yEOr0JC23az6fvQZlxEA1dgI+88us6vfAstKZgWl1yK2vnzeCI?=
 =?us-ascii?Q?qmbLztS+vHHbdaD6pMKIPNn82w4zRBwjhKybNOXVuimkt5CWH25IPs/dJPC1?=
 =?us-ascii?Q?yZT2m2KtfZNwKlw2D7w1/qdqfTr3kaKbOWELN2dq3ZKOWRChVRsZlbcf0Urt?=
 =?us-ascii?Q?b6BgSwux48Mg6q02WsjewIsiZEPiY3AJ6o0je32Nk+jvPdPG7bYvZsZ6YHms?=
 =?us-ascii?Q?4sUP47DXbcYQFMW8RabZQNCLWwFzoKPVoPpRKZHX3OYxIpo10w8hZZ/DwMLZ?=
 =?us-ascii?Q?m3BAvpHfErGbEd9nmpSma/qkugFei61DsKMOYkR2D8V7aYlmLeuvZ8OZZlZv?=
 =?us-ascii?Q?THy82QfdtSWVCKGvedb9YZE58ztM3dEetwEmbliH7SNGbtXCWQLieBWlmCs9?=
 =?us-ascii?Q?E9lnG+9iJxseq2ww5pMF6eKHPtgtExj3Xai7t/y5VO+ju05QMxoxjHejKYHW?=
 =?us-ascii?Q?h02OZyQUtVlBHxxKwHCZ+CiBuZ2pNqtsQiTL73U6BCCcElGvhigCTAqDnLhk?=
 =?us-ascii?Q?MOlk8nj4O9Bo4BZpu8Olww1dtITtk2hVwsIJdLbDJWz9hHweMhUE192NzvwL?=
 =?us-ascii?Q?BtvDKxGD3bdRU+LPdYoizR519jiJzLKxIpeBJJNH2ErCfUnar1v4PohZXUQ8?=
 =?us-ascii?Q?5/O1wDfKcK5MOoI4Bskx3dijcUUXtJp6CYN03Hmz1sNtSUM1Vrkon6UEBBtc?=
 =?us-ascii?Q?QMa0WVwBnPzubH6/QVKjS0cC4ursp5ZN6+GaY+OIL9nzYKq5WyANqWn4n6JV?=
 =?us-ascii?Q?vP/RRB0qsy/++aoO84IF9jhYDR+BkKCRvjZzq1PrxB6a0WtdW/z8WK7PLFyi?=
 =?us-ascii?Q?tXDRbR4FPEH1KfUInwoDdIndNtwhzqFSLLb7m+Sa1xhGeeLNS0AiF1Ax4+BI?=
 =?us-ascii?Q?8sSvHf50NHH1LLRKYCeAxbPHb8I+B+KJFkUCF0au2K56C3jDQboUceN07BG9?=
 =?us-ascii?Q?P9wTbWYQkCcG/yL8rCfwjqxSX9amAZIZe06ykEzKKLQZXGNlL1LlMpRs/IDf?=
 =?us-ascii?Q?uiLMQVQwNpboAHAVkrCs0I6NbBKztVptcMtyKkXZscnHsVPaR+bsYOJ4Ntvf?=
 =?us-ascii?Q?PUBdR1//I60gQAO29ftzvUZQB1rzKi5UyBT4kvBxyN9JxZwl4OUZW9eXHMHV?=
 =?us-ascii?Q?TuqX4ZQd0SNjclrltwCCArG5nDWla8+ki118iylyyhMFOMgkJTno2lgWGxLA?=
 =?us-ascii?Q?qZctuZC/aS4Y2LQq2RWRfF0T2Aqlt2Q7P9XtbnOZgot7eMS+gsuMXCXUXBnz?=
 =?us-ascii?Q?UyXmz+sXRZdlGM5bn2fsOTmMWmjNnmAckNb/lP/GcErAiIGsqvwekKeLuNcP?=
 =?us-ascii?Q?8CBVFHuJ/2oS88hSQ+3WuKIdfF7El38cV+FpZXoBKgY8Nl3CMTc9kJVb7/Ps?=
 =?us-ascii?Q?gnFaJt4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:06:33.9242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca948b7-bf41-41b4-ec30-08dc622dc77f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572

From: Ashish Kalra <ashish.kalra@amd.com>

With SNP/guest_memfd, private/encrypted memory should not be mappable,
and MMU notifications for HVA-mapped memory will only be relevant to
unencrypted guest memory. Therefore, the rationale behind issuing a
wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
for SNP guests and can be ignored.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
[mdr: Add some clarifications in commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 243369e302f4..cf00a811aca5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3042,7 +3042,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
-	if (!sev_guest(kvm))
+	/*
+	 * With SNP+gmem, private/encrypted memory should be
+	 * unreachable via the hva-based mmu notifiers. Additionally,
+	 * for shared->private translations, H/W coherency will ensure
+	 * first guest access to the page would clear out any existing
+	 * dirty copies of that cacheline.
+	 */
+	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
 	wbinvd_on_all_cpus();
-- 
2.25.1


