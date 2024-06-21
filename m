Return-Path: <kvm+bounces-20262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B96629125CA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CFD7281EEE
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677AB175543;
	Fri, 21 Jun 2024 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uzjO2rDj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B6174EE5;
	Fri, 21 Jun 2024 12:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973627; cv=fail; b=GMfGUlGm515Fgp/qSzjzm1zEqMK9hBQiC4v9FloGy8tPxrHiZeG/dwOmQI3W7wV8J4xyG6vjBpmVH/oX8X2yy7IL5clf/RnvdIGs0eqCworDYQgBXNqzyNM2qJLA141LJC6nYi5Sxsf/yFpT1+rwPHACjWS9qxXOVcK4/348Ius=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973627; c=relaxed/simple;
	bh=Xva9JtNOoPlPm1swPjvGG686jz79Qn7himgY2KNr2VA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYOLfodG0NyjtXhl6P0fwIuFQK4HfIqQUnbKsYaSOrq0d+G8avXqK+QDSKjXhJXi2R8EIPncqoA9VI9bRRjhEB++o2WDY3YexFvNoydgk2YsKefywBRrQ+NqAmN+4NUj4CEmyMyVAl4wVirJE7zKz4ts6Q5pSi05HqBOkQZiXOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uzjO2rDj; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZVmgOyhZ7v6sdNOJLd1AHpvFVY1wD6iAjKsRflgy+64POGg7tLtIdcTCqE8QAI3zpQLm7YUvvhuDhX70fB/z2dbF26zvlsa3o9+R0t342VwQ6yS55rVSynij9dVDDR2bXxe+hkbGXrfEKy5XDOTnMcMTmzFdrvjSTwSSJxzP3aKOYIAaQxyLzTtfdgo3Mbm9zKZJ41P+RdeyCfueyHhyfkcCPKdWkvrckOi87PwcgFcHLEn5Ah3TOV0LVRB9NUoxGN/LKMaZUa/TitwlLwsQWMCHYKHngDHSHupP/FpxZ1gTLCoOKeUCUM9j42SiQRB3+J8Z2RtNen2EcV5r1m3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85o/aoww35R2jPaxPqeDU6ARsndbVylbytpwJvTn5+Q=;
 b=VVwwboXLUdo6YcrbZC3Rn1E2SRsHt4eHaAcZ0LUwfSupQ3Vx5OJ3eEqFmeAC5t/69zR3szKPApYDuGM4Vh/hsEQw/UtczBCXjKQOggl0+hl4cAu/2wxSnuqDlUmvCU03Ha3a1gn00V4gHc4/34fF1J09baBk59Vc+g0dkzhV6EoGkf3/bz58E2PFBVgj5B/1COY/b00Y9ZHUWzP9NVIppwvuzvzPB6C3pfsNbwsf58Hlo6p4xrg9ioZMahom96+pPmv38lrTzxNrvFMDzh7b0yEyJ4a9BR2Jvc8n79MwRAoZ6fV/NxXNMPd6+zc1O9JmSTaw3flfsdLi7VEYKXMo0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85o/aoww35R2jPaxPqeDU6ARsndbVylbytpwJvTn5+Q=;
 b=uzjO2rDjHn3WEgcFokDcuEHXVNWQHLQGBCkAIGVH+H/3ZiCwY4ywozrro+6Bo3qjI4KzE9G4rTdLASPbMOn5s6N1xYval9XCdl8wVRsPTi7DbD332VUYBb7NX4aHqDR0uaxxY1BUxBvtwkuABKp/QB+JCpkXXO6Xjwc3KpIZ4nY=
Received: from DM5PR07CA0065.namprd07.prod.outlook.com (2603:10b6:4:ad::30) by
 IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 12:40:22 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:4:ad:cafe::65) by DM5PR07CA0065.outlook.office365.com
 (2603:10b6:4:ad::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:20 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:16 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 15/24] x86/sev: Cache the secrets page address
Date: Fri, 21 Jun 2024 18:08:54 +0530
Message-ID: <20240621123903.2411843-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2dd43e-4fd6-4e47-410e-08dc91ef5052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|7416011|36860700010|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U6bcXSoLMtRYuiJAqoT+Zq2j0oaSg42F6aaQljF6jI0y1SMnScsYw+iqTnqa?=
 =?us-ascii?Q?2ceUk0NwLtb3Y44AlWecxVC3zMJ1ogHShYbbb/iyyF3rrWE812CgjpBBWbFM?=
 =?us-ascii?Q?3HqHkHw95wtVLvMcQwNRyloT6tNHLFtJjpRI4rGpIBARUpEpRD9HBGrvflUI?=
 =?us-ascii?Q?MauZ5rknLSGgWUPXVsTDoEenuGpNVRlXQ5tU+YuVV5sGF9Zoh4t60QJ/9thV?=
 =?us-ascii?Q?GmKg2CP5mHnh0JGFwiiaO0q7B1rOAfRgHYgQdTeR9zjREXCIPAQlAONpIhe6?=
 =?us-ascii?Q?7YnprdFLiHzRX+MlA99Ir00DeV9BThR+A3/GZEXsj+miMDHltRId16Pbff8I?=
 =?us-ascii?Q?ZHz//6pi/b5138IBDzhbhgD20E3CMi72rEhBE7qaYj90cqGEVL1NqOdbdd9H?=
 =?us-ascii?Q?tDVuUpMQIWGli2yMPw5+3+lUaIyiuqIA21Q2usIjIxa9ubOZbum/DeqVVIup?=
 =?us-ascii?Q?aFZmZzoA+4U5qaiLa58E0fiu/9HVUPoernEiHQNJOhnf7t/Z4N65lZ/U8/fm?=
 =?us-ascii?Q?g/Y2KJ/DDRpqbcqtpsvBBygv+eSTcuAgivDXWjGRRYiOoUEwT4wz10UUbSe+?=
 =?us-ascii?Q?RS4W7EU+yZ/V+dvBD9T7Z/hX+gbIIRzFyxQO1s3BBNshNVFhFDVgh8lBBZdM?=
 =?us-ascii?Q?0f4CQo/o4qJhIVcF4Uyl9mNyZPyCXgvEyOXBBaMk0+gacgQ+XB+NsXevC9Mh?=
 =?us-ascii?Q?/lSYuBd4v9339qVIR5EcBbLyVCe0YCIBDroh9tqINSEccfzacloPYZUwjqGJ?=
 =?us-ascii?Q?kiFMtDTJV0ZpqHaMuacu6SRhbxbTRsWbro3HeWdV+uJ0GL7/Zg07hAOSQtFU?=
 =?us-ascii?Q?fVwLvXD2R5ewaMRV1o0R5gp8mIyJ2qZYx5ua202GlW+8oQGKIraknkHQgtBs?=
 =?us-ascii?Q?12oqF678UADBqVh5+nGmzJodkub1wSTt2X5Ql4jBw4xIua4Kpj8pVLsIzNUJ?=
 =?us-ascii?Q?Dd4cXMrwGZtThx+//dmRZ2fS1yVpmkWaRNgCaAms/RJXhr+7ag/lijRcl4of?=
 =?us-ascii?Q?WUpCwtgngVx1Njbs2YU8ahMdHpJlgPPBx1v4UpxgIUf+63DlISSz6K2lo88S?=
 =?us-ascii?Q?AReS9t8944uH0QrifJxoLgreLG5T5iux1OrR32WaEeZQYdLtgYYi6GLfK9ot?=
 =?us-ascii?Q?WMAupjT4W0A2m78HvRlLUk+lRaBLJ2G+qWi/b+rJJbmmL6luz/2lg4Iy/oY1?=
 =?us-ascii?Q?yvs01AmFGGW7jJMfjcma1wEFcCsLc6wuijE1y1ivmNJCDXlf9T5iV2+RNVz0?=
 =?us-ascii?Q?M0D7sleRtO5I/t0NmpcfFXpKG7AZqfgdYgQa1I0lf7q5U2gUACdrdvRCytUi?=
 =?us-ascii?Q?cz7UxSR4BwJt+nRhl+8iqIRZdvclsLgBcOVUEgGaD6/qa1TxdaADxkZ//dTU?=
 =?us-ascii?Q?WcLOVkFEdzEXBxptY0OevbBSJVIuVo7ECPoCniCIeirVSicA9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(7416011)(36860700010)(376011)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:20.9453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2dd43e-4fd6-4e47-410e-08dc91ef5052
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325

Instead of calling get_secrets_page() that parses the CC blob every time
for getting the secrets page physical address(secrets_pa), save the secrets
page physical address during snp_init() from the CC blob. Now that there
are no users of get_secrets_page() drop the function.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/coco/sev/core.c | 51 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9f0f8819529c..8bf573d44b0c 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -93,6 +93,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -723,45 +726,13 @@ void noinstr __sev_es_nmi_complete(void)
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
@@ -2301,6 +2272,11 @@ bool __head snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+	else
+		return false;
+
 	setup_cpuid_table(cc_info);
 
 	svsm_setup(cc_info);
@@ -2514,16 +2490,11 @@ static struct platform_device sev_guest_device = {
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


