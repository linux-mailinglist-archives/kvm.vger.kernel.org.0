Return-Path: <kvm+bounces-18484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6998D597D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0CBA1C23BF7
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BCB7FBAE;
	Fri, 31 May 2024 04:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gogVyGb+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00FF2135B;
	Fri, 31 May 2024 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130075; cv=fail; b=m0jrfe+FssqvlyHykFqcolLFpgmrmZaQwtDXcOH1cYmB6VrjcFtwTkk7Cd35jYlhK2phIt93JXNddeblgjC6a6PuX8A36cYTPUad/k40h2gf8yl0dBs9MUux1BH7yBL65KgS6zEfPHSh3Gd6qW2AjK77X04igeR1wLIPoYLsb88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130075; c=relaxed/simple;
	bh=7RatBNCnIbDRhEKO1UiiuqJEpLxL39hIQkT7wV0TAJw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKJZUoNn9Kj4qfLC5ZRRqgf9k2OEQyIf2iZjReagK2ZaLwMLyOINC54hSoPz11/3HAnc14ZNP/PfHmYaVbylDgZ/cy7PTcocdfd+DNE4pXw88C2PBTPpxUbaGapSo31yUvYklJYjaLGeJJt8iyMJDzYegmtwG0Hz6NRIMklU0cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gogVyGb+; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j37lGsRfELBG8p5AIOwFGecRoEI7qnR46YIothLtZBSrnhwvDRRybS3MaAhD5MODKCqbqL+wgAkKUXkCbTpfzc8J3dRYeSPM/g+PXGAxSefu/y6uN8wKAkN92b1TJ5HHL2wqewMM40vC5rQ4Sf9Y87N1kS744gKMoFwVo46fpVLvWVAEFrIZS3DB4rOTCgv80WipnAZh9amD8uAq2ISmTymFeDUZjFli1cg0PEZgVa/zI+fKwxrH0qyU2DzjHSNLdc27wfYmQ2ZR0KOb8SK5YJePEPPICfsVYFzKFZheNvA6xx8BRf+oqaaozeolV/mfx0BrPkCrtVEdnhvKLdJTcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FW1kVb2HUuaBogO5Iihlfq+YjSLq/wBGzEKbi3itwQ=;
 b=ZQJiD3NLjQwOFlljMeNZm1Nb6HkO/k81h9aHMSmlsF+sSaMheG9uNjWw9qjeC/j1L35IkM8E13xdovW01CMTkYWzR8mTPniSGZNbED1K0I0xJjI2keo1ku8Zjnx7AvWbQ01wuaLFDRSmlajhhJCgDaezzHlUOTLN7zc3p7DZ3ia10AXGmCkOQhz45klEY/1ZmwWRbWHv46OVoR9XdprrVOXmJ7ecH3hc4monhYDFgYo1mS/UhfLDewJaO5LYAso57h870KAoR0uxxVib43blXNEyLsMg4bjPMuO2wxxXvRFdHmjvrJTSCzv+H7g3txu365+B0smRfBBVQSlEVBcJEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FW1kVb2HUuaBogO5Iihlfq+YjSLq/wBGzEKbi3itwQ=;
 b=gogVyGb+x7v31ArH5MSBHXy1u1EhlQ4VlI0/RYGcuI4FPISzOjpc7dReCzkSeuvhhXlLmCxOGFg3QZLJ2vsehKwiBVrJsYLYLTP8j/S6mKNNuokt15wNQropcYaAHmSd+ieq0hqNWK8fbjBDC3fj1QT70/ieDw1ljdQfIM0RLII=
Received: from CH2PR07CA0058.namprd07.prod.outlook.com (2603:10b6:610:5b::32)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:34:29 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::21) by CH2PR07CA0058.outlook.office365.com
 (2603:10b6:610:5b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Fri, 31 May 2024 04:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:03 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:59 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 15/24] x86/sev: Cache the secrets page address
Date: Fri, 31 May 2024 10:00:29 +0530
Message-ID: <20240531043038.3370793-16-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: da6abbc3-0884-434c-82c0-08dc812af5e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Kq+m/pCm2g3gkTQpcTIhbARQ5ZWSVIW6OFWVSHbrJTO8A4zCr/yoh+s+RUA?=
 =?us-ascii?Q?nDOvLr2yCn8QdN3ytKaAyoReN8TQ1rWyQipAgSPPuQMkoHaTCqtHfXOjDaTa?=
 =?us-ascii?Q?mT20LS27+iSMjGORqrifjq5jRte3zjbvPQj5qg4qQueYKccDkRBdleS8JWWs?=
 =?us-ascii?Q?Jc7uZr0UDy0BycEeDqjSSnhDMwbvG9NTtcjVHC6pimwe+6sQGiwSn/V5gzwl?=
 =?us-ascii?Q?V1HmwXcbnfusTob0uVpqq0MrhUpsHFKOmNW0Li3Mk83BMTjG9Za+zAZrGhBQ?=
 =?us-ascii?Q?r4THFy+bUDT2QtwRcZd9zbg25ibe3hTDyN0HdzHcM2K7NafscolYsYBEKt52?=
 =?us-ascii?Q?q9rnpca4DCTFc2hUtpou4wzYtH6FlzUpzCDLAyL0iE3Hd3nvQvp14PuZ/EAc?=
 =?us-ascii?Q?d/RQ0CPdRdd/4VAV261cfZhqZUin99kqKDBJMueu45tAtqlFG2drtDY0NzLp?=
 =?us-ascii?Q?KmAKddCX/aojOzypdOSwVShasWOA3xs3POw4ZaLXtO8EVKBs7oejKfnAGzlE?=
 =?us-ascii?Q?wDjdXXF096zCrHbbCNVuSkJJQjZh7GjNlVg/IYJvte++8cMhAyd2HV3Vg0Fo?=
 =?us-ascii?Q?7IddF0yGVbEd4O7QxLWw/Kf7Gf7AyDpr3wRldguKrNfI3O16nl95vMKlPruv?=
 =?us-ascii?Q?zyAATouHewHglfyvqmhNrE58A2Ui7Mri+0nqiRemStZjG4ZU/uL/972KnJ3Y?=
 =?us-ascii?Q?NUlFcZH8dkDSz2uDZ/D+nFbMUlT1CDxp/AcFw2hlRuc0bNNhNpXnnAEQx0Yo?=
 =?us-ascii?Q?MufHXxdw3tFNENJrqO7E1hKjYFBkLwe2rn7BbQi2jVmvxtxdaXODYl+mIIV2?=
 =?us-ascii?Q?HZSGzctSksZmB6v/Wvrj+HCZkrbP2QvC4JuCdxNc8To4TXidl+b4jC/83GfJ?=
 =?us-ascii?Q?kRUUg0d+cVyJZ7oChqFvcXs+DxqaAHISDalEs19UduHD/W4j0bxBcQ4/cLAe?=
 =?us-ascii?Q?7gr1VujBAcU6pE5x6SHDtzjI1O9dAUrnCEjMAosRzN/7S8TLF0SqHwMnVI51?=
 =?us-ascii?Q?sQ1lN9yJyDSPnoOhGP1mE4DAwI9t7tcpk2KIiHKcKtL6T1T7RIxks5o586JO?=
 =?us-ascii?Q?G5P8ZSVWr8FVD3Jk2/NN9XbhDjxa5TuqmGKQlfwkXfXpSzoSId9klf4soL6e?=
 =?us-ascii?Q?OfW2UY4xyTXY3b3rcZCl/vH73/4rVbQHAmsxm2cfIRsXkR+DtYBI52EO5ylI?=
 =?us-ascii?Q?sKo7R7kwick/h3TJBQIOysKJqF1M/aalP1DDKyQt1l5+u8ZSHjTJq4jLZqmm?=
 =?us-ascii?Q?uOyYaZTt/IRkg3FIVUPQpFGaG7flcNDz7apBm1Vi+8Taeen1U+sxQmO8uDs/?=
 =?us-ascii?Q?zSenN5L1ow6rViOuTjD6LQ9LfJEZUTQ1phOhQreGBL+U1QdgdTdiFVPHZBOQ?=
 =?us-ascii?Q?0vPerKNmLdmuUiz469O1QHav8xs+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:03.8952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da6abbc3-0884-434c-82c0-08dc812af5e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

Instead of calling get_secrets_page() that parses the CC blob every time
for getting the secrets page physical address(secrets_pa), save the secrets
page physical address during snp_init() from the CC blob. Now that there
are no users of get_secrets_page() drop the function.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/sev.c | 51 ++++++++++---------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 878575b05b2d..141a670d2a85 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -93,6 +93,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -619,45 +622,13 @@ void noinstr __sev_es_nmi_complete(void)
 	__sev_put_ghcb(&state);
 }
 
-static u64 __init get_secrets_page(void)
-{
-	u64 pa_data = boot_params.cc_blob_address;
-	struct cc_blob_sev_info info;
-	void *map;
-
-	/*
-	 * The CC blob contains the address of the secrets page, check if the
-	 * blob is present.
-	 */
-	if (!pa_data)
-		return 0;
-
-	map = early_memremap(pa_data, sizeof(info));
-	if (!map) {
-		pr_err("Unable to locate SNP secrets page: failed to map the Confidential Computing blob.\n");
-		return 0;
-	}
-	memcpy(&info, map, sizeof(info));
-	early_memunmap(map, sizeof(info));
-
-	/* smoke-test the secrets page passed */
-	if (!info.secrets_phys || info.secrets_len != PAGE_SIZE)
-		return 0;
-
-	return info.secrets_phys;
-}
-
 static u64 __init get_snp_jump_table_addr(void)
 {
 	struct snp_secrets_page *secrets;
 	void __iomem *mem;
-	u64 pa, addr;
-
-	pa = get_secrets_page();
-	if (!pa)
-		return 0;
+	u64 addr;
 
-	mem = ioremap_encrypted(pa, PAGE_SIZE);
+	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!mem) {
 		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
 		return 0;
@@ -2107,6 +2078,11 @@ bool __head snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+	else
+		return false;
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2264,16 +2240,11 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
-		return -ENODEV;
-
-	data.secrets_gpa = gpa;
+	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
-- 
2.34.1


