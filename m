Return-Path: <kvm+bounces-28204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C391B99655F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 798511F2136A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F28418E05C;
	Wed,  9 Oct 2024 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EjBCO4lh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3D18A92C;
	Wed,  9 Oct 2024 09:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466166; cv=fail; b=qlq/Q3jCSJ2RQsN8y8xCihf7oFMAq8g8AxqwCVW9i10wYs+9+uBnmwvso3dHjV5prpUWcruEcGNR/YZ9UAvrNhvn0/oZngMyQCvES5GG5Pi2vxD7z0Q6/JZmizMl22qoSKoiQOWxEFnHzl/+qUhpZ1QT+jXXKH49nT0QeHMuNcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466166; c=relaxed/simple;
	bh=DSfxiI2nikeGJTAxShGmB6N/UCJ/9SYh3h7DOlVuTfA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZB6cTaGPpWHxBAtJ5eJ1FxOjlAVkr5g7VLS64f8EE66ssDiK6SUZ6YvZupnm17oIMNb00a2xrXUesKRaZJrgGZL4R4aerCBr3DppiYH+EHFpByItaQVigN/NkDckKaA+DvEzisBCJeN36wddv4+Jb/p0lJGu/Dnvhz6/Fy1dwsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EjBCO4lh; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lm+6k6EWfdMp4fVyE77o4DLkQYv20SH8KS7CMWAluz5J49CJtgAgdnbySZLuF5AWAUOr55TX0XelyVYDDBvNW9XxJXtyLXNmBQwNK/TKBP+CxAatW6lJWreE1d6rX/6U2zjhf/SJcFC8uXdeflIvgz1Q/fBVLUdJPwGgwQPwj1/jWOJXe6rYBztBW0DisX1QiLrgponv4Ak/H1Tp6lKPH/rAQOoasxOzUt0GwRRrIcJSF2Rqq6QOKP/fIYcU9CF45LIh5XWYTD8JrhQUvayvBZima63UCzLP7Gr5DdLxSHKT3L8OhXcsb7MuZB6GUp2Z6V+c/xGs5X2ALcdxKR/nBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9SshTo6Lgdv1RfGyLJZNgzQSlTVoH5shPVaS/HcIHM=;
 b=xVIwiICOg9bDXuBkqOPzAvGedf+FUQWKY5GWZrLr3RNXBBnX+ZG8QdsXN9izvUAT0/0AZYpcW8X6utnLRvg2Zb+diJt0APwZUuB5nQ+GNyy6eSMdXsTGIlf9rp/2SsnUr/cm8Qaj/PuUdooyftkqO3KHE5jcWkq26Q9JBt45P+i/azNeatXzzYHyqbOe0xnG/uj7sjzQbr+SNJ3LWX6NNNJxowI3fZvtLqgYS2eqQaCGSNKx7N6tOSxuhJkdkcUn6sv6EQeh9NSaaYonXMuL9gZdLwPPFIzNMCJ8jIy3oXLwbVraEGVVt+4nn9Vcz8TY+WGV1jV56kOjJZWrgxpy4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9SshTo6Lgdv1RfGyLJZNgzQSlTVoH5shPVaS/HcIHM=;
 b=EjBCO4lhY7ZVDcNoNZrWeh2VuCbwb3DMHCqGhft6toipi9j6r4nVULeh+X637RWhkNiMuvpdJoi26tizMiy3vdXw9qqOnCKpommWvN4OYct1XApSJFrZlSx1iGQgHoS+acs9lSscmBlPi39f5z2xxDYPVyY7uBL3UAgSxeschyg=
Received: from BLAPR05CA0040.namprd05.prod.outlook.com (2603:10b6:208:335::21)
 by SA3PR12MB9091.namprd12.prod.outlook.com (2603:10b6:806:395::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:21 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::57) by BLAPR05CA0040.outlook.office365.com
 (2603:10b6:208:335::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:21 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:17 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 03/19] x86/sev: Cache the secrets page address
Date: Wed, 9 Oct 2024 14:58:34 +0530
Message-ID: <20241009092850.197575-4-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|SA3PR12MB9091:EE_
X-MS-Office365-Filtering-Correlation-Id: fed8f367-be6d-4a61-1301-08dce844db5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5m4AnHZd5Y22moe0cpvvTqnnUYWEUppsDbSJiAU6Y/ivNfshliCbnwtE9dhB?=
 =?us-ascii?Q?UUA4OnDdaM20wyB6DLXCXwbBcvz5ksnHi9xG0zdlLJWyCWarQq6iAXK8WRb/?=
 =?us-ascii?Q?TQH5vhceBt17ndTvpExbbQpab5Ln4OjeX7f2CaezB8KV6/Gk3ivl2FiOXYbC?=
 =?us-ascii?Q?MJiKrKaeYvAQnQaS2+eUcmG9Tg4+y34DdysqYSuaop0gp3boCA9knj7T5y3U?=
 =?us-ascii?Q?m3uu5EmCtKEGoT1PF5yu8p+OAhVsXWpBZxCp5BozeF6gIi6/GsGBIA/w9WY7?=
 =?us-ascii?Q?uolvLb+V8SUifH4W6LRgeM3OTV0W5QWHioSvD9J0GGXjbbNkoyAfqpwFBykk?=
 =?us-ascii?Q?6ERS7z/L0RPMN1Db0lEm5pP1+fBos6WsvXyU+r3zyLMC8GWMkFDLLvWN0SUQ?=
 =?us-ascii?Q?kcIC/iqOtomCpLHk9/w/YXtRpTOtyKeazvyj00zY0aSNPtpV/Hzq539S80b3?=
 =?us-ascii?Q?oiyrk/fcMgf5AUehs4vubWCBN+ZN/GcxJIAfEjH9pGDSmZWrJgIMXI9Ec2Xo?=
 =?us-ascii?Q?znOTd5gChLC7wiDimnho5sKdPJ7OGXa0q+EvBVMwB6H4XK3/IkpVOA83Hu8p?=
 =?us-ascii?Q?PS17iDj7YjMBqisLtBWhr3iPZ/8QyHXiSZVCsZe952vJ/OpUXFZU5ANy0BZu?=
 =?us-ascii?Q?k3zPxZunpLmDUDke8YaFY1dNVwtiVJp6BqxjTuYWgeCKhNFqt4zrM2AHh8Mo?=
 =?us-ascii?Q?vQmo5APVW/hsX5BvuWNdS+daiVjZSdCYCJ2ZcP5mypL6Ob1qfP5/vy3SX6NN?=
 =?us-ascii?Q?eQgZNWvhQ52GSTX8/vHDEVlfpLmShUbs3bLfDyF3rfZnz99MTWE0GyN3KE/A?=
 =?us-ascii?Q?P5lsO6aOsEOo5gAZyq7P8KiejXImppqj1YPoFZ6MGULMaCtp8bzugitVi8kg?=
 =?us-ascii?Q?Erg4UPlFa/OmkjVe/udSno57FJPumFDZZhGHPMcjGnApkrVSlvSVAk5j5ACr?=
 =?us-ascii?Q?gGWZXEu3kLA3CTQ1Mr1LSv5Ar/D+cxh5dU0IVBQGsWpefMONCn16BbiUUVHy?=
 =?us-ascii?Q?sFXysM0UMRvfUhjs1Kk8wFdDlkFXcIbyTldhfAO4f5WfELpaC/7rqKvKUFTs?=
 =?us-ascii?Q?SiOHUE11c1IihEVgtfJ4G6akudfiprKxZVCEKjmK2KcCrCR8PGB/m/W+8i7n?=
 =?us-ascii?Q?bUGfQnKCVNGQbEnFJkS2bJALybjD4r/hMUAKEDvhVgqUewf2HzjkH9QLRHV1?=
 =?us-ascii?Q?gp1azLTQTX6sYJTM6wXt4pfLAv+LDSJkDt31Byn2+oB0cuiLZmtUjXIG8tek?=
 =?us-ascii?Q?7CpeiBjjabBzgS3tk6dclUBP6x3q+QXANVgjfU7jeaEquXSGA7Vm/fhOYdNB?=
 =?us-ascii?Q?iGFHdXFD2YbGfr1jfRy7vDpLRhJmNzXK+A77m36HE33WDQelxf/M3Fb7RfNq?=
 =?us-ascii?Q?tXHPacgQMfHFm3OEMpivPTuQ4Pj9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:21.4585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fed8f367-be6d-4a61-1301-08dce844db5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9091

Instead of calling get_secrets_page(), which parses the CC blob every time
to get the secrets page physical address (secrets_pa), save the secrets
page physical address during snp_init() from the CC blob. Since
get_secrets_page() is no longer used, remove the function.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/core.c | 51 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index de1df0cb45da..1b0facfe658b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -92,6 +92,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -722,45 +725,13 @@ void noinstr __sev_es_nmi_complete(void)
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
@@ -2300,6 +2271,11 @@ bool __head snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+	else
+		return false;
+
 	setup_cpuid_table(cc_info);
 
 	svsm_setup(cc_info);
@@ -2513,16 +2489,11 @@ static struct platform_device sev_guest_device = {
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


