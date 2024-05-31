Return-Path: <kvm+bounces-18482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7D28D5979
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 620BB2886ED
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989DD7E57F;
	Fri, 31 May 2024 04:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z4o0+qUz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE617BB01;
	Fri, 31 May 2024 04:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130044; cv=fail; b=iS9D6Fylix9ZaHEgjd9ioltk0+FvwgfrJ5qmIbJG49QwoAE4NHzKUq1cibyqNHT5lNxtdtnIIKZ4TUTrZ8bA4ahQdFWg0nTdxSOPcLFfIKwQV+KhETBOkv3OII1rwErF78WTdraR3hp5LNKN/C+afJb6TutiDtwoWQQtcxv+WiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130044; c=relaxed/simple;
	bh=5qSYz184dG55AgMt1KcS/YHhgJrEhgfTvgTTCjahzBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQZCggPXISwHsYHaml62Y/6iAsS5Uy9D1mfVucKyP0kn5C2XmpbwSDz6YjcomPAGCnCeoaC/KFX/1zfBfJSZzL6KcgimKjyc3Ssn34FyGUQPI6l3hL0kHzgA3S+dDinuS6BKS59CbqQJ7srMQYf/DhThReQZZT0IMFx0ZT+HO1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z4o0+qUz; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWIlg/+9SaMQM0244FC56ey/Q6YqLlmSSGHqeSvaWoh+akMrecvQzqJUkYgQwsFo2pK+pEpS6cOFakVKZp9CYBs6scxu4bLjWYxos6M8qSt/EZiKOJOOHYMwfsep7DEguG5g9mInetfxw/rIp7EeSAnjRKZ5llOaegDRS1W8uD+Enfoz/BGhEpXqnwdcP2tnJi+yISVc9FyN8oJ0qLuTFUN1/CIV94+ErNHkTjMUj/xTikKJmbXvKPXa6GcegTe9ic/YmN8u276c9iBoDKT9Z5bDvhmAmNiWHjUdM++87pYcPpFEzfcTmW6hu0fA8fSPR/HBIKMjPuEVrKI2lSXdTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcHu6ihXJZRoVgQf2gK8G/BljboPy4aUZTH6uo1HfZM=;
 b=fi06Zkc6xInTWsVjC0nop/SdqBp3Yt/CVTSesqHWKKGjCXEvNYl12HT03KgplTFrTwW+z6vkOY4w09gCVwIyl+bq9QjHiWEQyRVwOVLKzcb9X0Z1mLCzcyj5CSPHMZaowGyi2k9JV+OJt08OAc4RHXh6BXCG50Kn4t4dgaOZ13kRZXN/h3JZFgwAJnq9/ztPgPL1uqZcMqG0XUDd/I4rDxRvGPpyq6dPJ6iV+aMPhb2qd++hY6d20h9lJMN0p6GW0jW60mS5kaBQtp+3OvL1Q2ibaZozaQWKipUvIH852bBPDemWcZ2U571/L9H+DlJg2RxvbD0S2h7Be9Kbav4IfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcHu6ihXJZRoVgQf2gK8G/BljboPy4aUZTH6uo1HfZM=;
 b=z4o0+qUzaibxsijnfj7Y4OZV9PChw8jbTeD8rKNl7zuBM+dUHwCZBZKDicAwjhWFMwI48IeZRR39Sb0qxo31UfW7bs7ud+W3PVXRL55E1eEWNPleZE3rx0cMRn19DTKg5WIndoNghQBA5N1vOJYXdOrLDdfu/Rmln9netWgQyLg=
Received: from DM6PR02CA0155.namprd02.prod.outlook.com (2603:10b6:5:332::22)
 by SA1PR12MB6727.namprd12.prod.outlook.com (2603:10b6:806:256::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:34:00 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:5:332:cafe::e) by DM6PR02CA0155.outlook.office365.com
 (2603:10b6:5:332::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:56 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 14/24] x86/sev: Handle failures from snp_init()
Date: Fri, 31 May 2024 10:00:28 +0530
Message-ID: <20240531043038.3370793-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|SA1PR12MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 659662a1-d348-4595-2fb9-08dc812ae48f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|1800799015|36860700004|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TXFTJ2UsDgqUjfvPcTlelKNAcfVfe9o52+uw5FeM1+1MttIkZGZLEfjkSR3G?=
 =?us-ascii?Q?oYF+24cR0jftruJNSAbBUZkNlIxLBbcBUHkr5y3qjitRTpXW0iMZw6IilIei?=
 =?us-ascii?Q?XHSb6oPYTLmYjiI+gf0pTd4knzgitC+fCy6f+RQ5QXFeleMijwo+8fCR5ugz?=
 =?us-ascii?Q?QF+6NbKq5ZQHPVOefDVwUTFneSmFgQkZEHb8BT4yn0CrG9gXq/E1Lv7LmuSZ?=
 =?us-ascii?Q?1OK8NzVGCGsRj9mkuiXqgbAaWYyFO47GcfzMKO3+keNqQVw9JxJZ3ND8XadV?=
 =?us-ascii?Q?7eHU5y28Pg4hACNYCBpZhxFnvKEQuLTRDaIM1H6a9Jkw3sb9LdvQA9fickdI?=
 =?us-ascii?Q?Csci+wg8irv1pA2vdzIKeQ5nL8/guWm9gRFuIJLAo1kRqXWtW3fU8Lz5WMzs?=
 =?us-ascii?Q?BBAThmoybuJkw+CsqQlpGaM5M/4EK5vt2CEDuxQbgoJ+0y8RMqE0SP7DLbO4?=
 =?us-ascii?Q?QEfSA7qMLxh0/mZU2/fQIUstFgXfYEIJxXXB73/1YeRyA7QpTntAvu7gzNU7?=
 =?us-ascii?Q?8MOzWtnDcUMBJ7Jv/Yhp8Q0FgqXRfdlRYQW7pccYeYOWI5PHlW7A1+86riPU?=
 =?us-ascii?Q?wemE+Bp3xoSKt/ncVwvo/8d+ZMAXgP7ovQsrI13TOFNgEijE8Q9fHmZ+0sD9?=
 =?us-ascii?Q?Q3U9UuFaQ019//x+OefAPLUfF2vE5xkUIjRsaul+rWui2h018EEglbX8kRAH?=
 =?us-ascii?Q?wg8CrFduJAuI5YIH1STPTVeTU5yV/okguKgYOvJ75gG1eAlX6ApewnL7xIgX?=
 =?us-ascii?Q?E//eMSO7dFMk99VyQTrMni7S9p0HwFd2KcRJ2Eng7GpDWhIl203vLNJR0GCP?=
 =?us-ascii?Q?vpGraHcv75kZPtF0swsJBkM5j9nc19jBVzds8yStQxnQsBFmt4VCBxpQ6dcv?=
 =?us-ascii?Q?uJU2B7o+RoFJZxwZUNbgHDWtCC81UkSzju34ugNvOewmBkRbO9t24G8KZrcO?=
 =?us-ascii?Q?QxT44kLiGNO/VQeqV94+DwdA1HoLBdQYCnB8TMH8gGNCcTUxhB3kB2ELdj3r?=
 =?us-ascii?Q?l710VJmXtHa3mXJG19HICSz3Ggj5zDc8iKJcMJBYJDh2M+At1JYyzMTh+pjL?=
 =?us-ascii?Q?jBbWh2gcT280kSIJyqnwMlrGrOZ1ShKpnNBEZk8Di2vi3Imzo1a0gxB9Tl7i?=
 =?us-ascii?Q?XvQR5qdUiUGa9Vm2H+LnvEOm8XWECIXF+350Ksa/f6s9XMfGZmQtM9i806Eo?=
 =?us-ascii?Q?kz7kbKE91o05kcslPyNi3JEffewa3cK9xkFotKiRp1Aoqm9qmV8D3qmhZAlx?=
 =?us-ascii?Q?HdC6sKm8i+uJH0cd/JVoXmJlm7n1spHqIO8rOS6I8YI18/PXGeF4KQR9UwkZ?=
 =?us-ascii?Q?oZl4yxDKtIgFZC2s35Mz4uiAHNGTYKkFPiS7Ri9JdVJjcgnzXLBP3LFoLfW0?=
 =?us-ascii?Q?FwmnTEBaBai0YEuvXtp0+svatj0L?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(1800799015)(36860700004)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:00.2185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 659662a1-d348-4595-2fb9-08dc812ae48f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6727

Failures from the snp_init() are currently being ignored by sme_enable().
Add missing error handling for cases where snp_init() fails to retrieve
SEV-SNP CC blob or encounters issues while parsing CC blob. SNP guests will
error out early with this change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/mm/mem_encrypt_identity.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index ac33b2263a43..e83b363c5e68 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -535,6 +535,13 @@ void __head sme_enable(struct boot_params *bp)
 	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
 		snp_abort();
 
+	/*
+	 * The SEV-SNP CC blob should be present and parsing CC blob should
+	 * succeed when SEV-SNP is enabled.
+	 */
+	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
+		snp_abort();
+
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
 		if (!(bp->hdr.xloadflags & XLF_MEM_ENCRYPTION))
-- 
2.34.1


