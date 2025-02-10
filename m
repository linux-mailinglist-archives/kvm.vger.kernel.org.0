Return-Path: <kvm+bounces-37685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB77A2E78D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C19E1886CC0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A6F1C5496;
	Mon, 10 Feb 2025 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tTEHomhO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73751C2DB4
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179382; cv=fail; b=OfBgc5sF1FwyO4SkroCABbldVa1lbYGLFy0FkjoQfKydRlAtqIBjMP3Uyt9nGzwKduQeMrPKFL1Dlrdm6EWn6+9SjW1GltqPljOtDh2SOkzsYH3L8gui+zIEAf4jKICRmOPdcV+hpbCgsTuB2cKkh18uobiWlvtapxkSqMG47gE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179382; c=relaxed/simple;
	bh=rSaAevgpkI+TNVkp6KsROK8waD5YsKgD5+55UCzT23E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pCqa/yLI3JI/zuWLhEfZGMwCkp3AyzTmKwnZvkwQWj6bG72R347CVNLiLBDcX+3+F9e/t+Q1rOnahssERrsNIBmFT2YFuHS39oU5hAnGGkAg8OBUg9jLLkLjzSrnpRqmJFLbcQ7VtUNu2TtyO4H/3Qde2rfFzTrh6fKCSs7ohYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tTEHomhO; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjpYc0p3jzKeyGV7QI0AO0vTwSGcnzvoCXcNPgmTfFZ7+tzG3gotCE9XBzBei0ToKcqrypecKOf4zZpafd4DkG9nj7sb4MUm9PFMIsJ+0ykqwOWHP4fJ/ashkF4ZV5hJWn9q6skewGU8yaiLPOesSBT/i4pGXp884wcsB4MS8KZnVSnJWGm6vOCEZHW3BMeUMzuxQqyZvtlW8FmsM9E7qqxJ80U8wHxxFoDhINjGf/U72+9SSJSRnkdKRvJIkVwx/7786GD3FLnEAD7Anl7Br+DeuYw5so6WbwRyQaS9TSY+MKaz0jw2jp4Zb8wwwby3pU46Is6eGfO4nay2Wvpl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/fFLmFleA3d4xhF2WJaKXXpGGUXEJqb72Z1xxXU4k0=;
 b=f22pyKQE/ebdJ3k2XSTZFtyEOohw6nbW5z1R8R9P7BBXVRrG2WfytFuuKy5Zqvugb6BF1xESyJsPaGAwPAvHK8/xAiHMYH07y5Jo9C5JWPffJRa8mN0NKuQVXsCic4s+a1PWh7Kkimcw+KaSqXHbdworfLm5oP7LG36+V3oPIqmZecHc0a1eYnKMKg+9aeZuw0mp6P0qdHurQAK8wK08EYwicACjNdeuqpCmjHZLfE5HN+zkcc24RkvFJSNAxMO1v7DcEafTIQ1RkbwMiQrhpF5zhF1vvWm1juDME25HT3Uvni4T62kRBKTOmvcnACDy3c7D1AHFJZeKRlL+tYd4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/fFLmFleA3d4xhF2WJaKXXpGGUXEJqb72Z1xxXU4k0=;
 b=tTEHomhOV09qXUiH1cGkRDwrdaz3kJxRlGEsgeEejJKhXV7HspLBqZ5SKNNQCVuhGBriI8Gm8P0d/v8iuukfX8IC2Zq9prnVSmalOo+APtQExK6c5QFFXVosFETXZf+VmtDNyrYUuBDqEg7FEkqi1CoU71D0eZZ7zL6V9JB0nok=
Received: from MW4P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::35)
 by SA0PR12MB7004.namprd12.prod.outlook.com (2603:10b6:806:2c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 09:22:56 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:303:114:cafe::98) by MW4P222CA0030.outlook.office365.com
 (2603:10b6:303:114::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.23 via Frontend Transport; Mon,
 10 Feb 2025 09:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 09:22:56 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 03:22:52 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled
Date: Mon, 10 Feb 2025 14:52:29 +0530
Message-ID: <20250210092230.151034-4-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250210092230.151034-1-nikunj@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|SA0PR12MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e2b5b9-59a6-4756-c535-08dd49b480fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xvsLj96Rfz6dzibGG8vYXPPNq7QY/nzPtM+gl5JNLgqUncVG2GWx7wt8PjIS?=
 =?us-ascii?Q?i5bLPrQujUi6G5TXrlC9HXXmOGbmcDA2OrgKQoIwV1NAJknNV7I1cJqv1Q/D?=
 =?us-ascii?Q?XllzRl8fWkRxoCINHorsXq73yTZdf6DcY3NOgYP02LOFnL6PhiMPN3U1hOYp?=
 =?us-ascii?Q?ORDVxH+HlGBiSItu85RGkJHt7OfcI+jTekRm5ar4lw85rXr93A2XEw9gmKtZ?=
 =?us-ascii?Q?9XdSmkdYGIB8yeXohmPuwLHHNvsmeCYaToE1x82olH+fv8/eqUlwAQbi4so2?=
 =?us-ascii?Q?hiLY2eo6XRacG4G0EivblOfVlAgmT6BOW2yweI70e866L1raFk3PP7EfChRc?=
 =?us-ascii?Q?773ArrSib9s7Xv6Ovjl3h4Z4wYDfpaUqW1PxMWTbcyTqVYuyfPQaxoGllWdH?=
 =?us-ascii?Q?f2Ctg3QvJNb56gnDDnE7EXu1SfQsDgdq90vFrdE1/98X8nvVYCgF7TFuGcMT?=
 =?us-ascii?Q?OzGWb2qEVpNasMvEbX0SqDFJdKE5Vo7aMM37iYv2tDMdBr0Vzk2PuJero8Dz?=
 =?us-ascii?Q?+c2wiN1+sBzewz+SEaJgOrRTsaHFJQz7MoFKzPnDCqgvMl3dpuQmufe2dd2L?=
 =?us-ascii?Q?6i9fD3FxDr6yQ93xfd6nuZlwGNzUKYNcNpYRiwA98Knrw77SVKIAWDXm4LXb?=
 =?us-ascii?Q?dbBLj3maQLE2CFH0idKv/ZNCiFo2KPDXoBC8Ss4mFbGeDM0fhzmyM6FZEoL0?=
 =?us-ascii?Q?pMIv7qamrau5EL3UlOmznkVeROcUqpmaYOvgMLTzHgqll6Gy2QPgWPH9jSH0?=
 =?us-ascii?Q?tv5EezkPPhxUocUBaSGNFZUYlodYjdBC967MiVyEdsPlDnLDpP1cKFwBY9+e?=
 =?us-ascii?Q?E234GbMRv8PC8keSG3rbttWLaDDMI/U1WouiwUL33fNxWAEGpNCdPyPmxBlm?=
 =?us-ascii?Q?rYjg8M8TzFtO3wRr5XENRxtLNlpw3gBpY//IVMod16ocMh+6dU0Bpt+7p444?=
 =?us-ascii?Q?U2zedy+wSO5NCkxQksRcDOB1JmkAqe6gECIN0+sB6RtfaIyqnbbjzzWIp9rS?=
 =?us-ascii?Q?zUFqj8X2RHZH/nq6ov6l/41BXoNDnjqJo+LJKEY5HFmwbNs64ZeTTP47FF0C?=
 =?us-ascii?Q?RhPUZ3m2UZjMDAN27D37SAHOUeowuUSHuoaHHOM77YbdDGJGZTF2LuZlUYBs?=
 =?us-ascii?Q?ZkE/CP4aje9TEIVfMJmx/YAwnY2uR2Rl38YaoTDIhDDaWHIxV0bMPtV8hK5+?=
 =?us-ascii?Q?FtDEybkSY3+w1UWdMi/fwiZhgFmZVMIsgRtVn5oQ9ZD045emHirMiIY/rSWp?=
 =?us-ascii?Q?Lk3pv9Lpz9zVOn8EicrW9FPC3jn1X9R83J7QP9inRBzalrz2oe/li2vyGTLu?=
 =?us-ascii?Q?Z/bHXoNVIv/BrlVzKEteA1sVFs9Ie6ymDGGyr20ZwEW3v0q4fedCOo3lJI/w?=
 =?us-ascii?Q?WmUT2gWu1Inv52E94E7FEMDeGeFp64q8D4hcGG5DLRtVXA270xczbmem/tPz?=
 =?us-ascii?Q?GhsbhJveMG3zL8Jkex/R/9/LEavuzLjG0Kz29YUpC+UJlxwTOYY5qQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 09:22:56.1775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e2b5b9-59a6-4756-c535-08dd49b480fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7004

Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
writes are not expected. Log the error and return #GP to the guest.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d7a0428aa2ae..929f35a2f542 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3161,6 +3161,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_aux = data;
 		break;
+	case MSR_IA32_TSC:
+		/*
+		 * If Secure TSC is enabled, KVM doesn't expect to receive
+		 * a VMEXIT for a TSC write, record the error and return a
+		 * #GP
+		 */
+		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
+			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");
+			return 1;
+		}
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!lbrv) {
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
-- 
2.43.0


