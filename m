Return-Path: <kvm+bounces-41866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FE0A6E584
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73293189D5FD
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDEB1F0E22;
	Mon, 24 Mar 2025 21:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YwYeHrEt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CAE1E3761;
	Mon, 24 Mar 2025 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850950; cv=fail; b=MgQBrDBsg4utN6JrBjU5n7m24uSuDH74wFWVB0AbUwSP9jRgw1lEhKIcR7k7ZyZYEmloLdwKFo1R3Xqu4RA37AQI3Xw+/HOnQc7ny62i/FrZMgKgkgkPJHoC2r+a7v9009a6fTNPC++VzDH50xkbyLEnPpr1ViiP/7AAdtfu7G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850950; c=relaxed/simple;
	bh=N3rUFLUIrPb+/yG2hrzRJGfkALzE0DdrDrJfAcb85Y0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSjhR708KukxcjMvL0VMRJIbvCvib+495MDjIyaY4Iea8NbvcsBUUj8jKy1CgtN/UKPW5BPE1d1bQVKFjoQONTYwfhfPjYe6y9e9K1Lnc0sJZetvLF7k15IQE/U/Ejzz7cgxkohFnWWqVJvj6BeduQ4vhpL40L39itUxru4E1to=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YwYeHrEt; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IbWwO8ILbtT2TjIr+/osUYoq8DZvBq2oMbD9688uFBst1ygu34sqLOj8/34wRX94uy3DbE3OkO49b/H7esHm+GWElMK1SkaZhjBlzWt+XvdMa74WU1soxbMIIVcFMB/SlVFymDKaJbbmnD8WvdzGi/U46XbHwjVQ0uVAMA0kE/lYn4ZzjorCzQoqqgDSlHLeuBwWdjcTCSLHjRUH/TK+YDYEWILRp+1pyEsi0FGzlbGBFSA0sxFiCwMdP4Pw7LE8kzqKVZZuLsU7Y5QYtNcwqUGDz0tv5b7k6TllLSqr7HJLzPY68zHFlCVeAYqmpkL1xdgONpb4FgvDEa2Ax2O0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=im+kXAXl1ngYXrrNsoXj2Bx8KGrOh4v3DFEgf74Bow4=;
 b=GM8EOOch/2TjU2/bFcFpql3tsPMoW/zF0zHtLiCLhF0e9gCYGO4ViowmWhO0QwusFaQnCNH8NzjlC4jRFhopDghVIK+lwvDXzZp9olE/pcM8ecru+wUr4xWRoPgq6LGaUbv0DmwW/1YWuaUI+furlG+PdilBhJO/jrc7jncrC+jayntKzAXnVwIypmrM6omgUYgRrMN3bowz4+gErVULn8Ce22utsSLspW+IAOudEG2HddXhrfwax8B7ieU2LVDO1EgN4S95qRLqT5Vv47OwYeTsyGSD7JumKREseQOy3DO/fKqJ3OACjlkAZ4foHbNb0hr+6d6g/hyfZ6Px4/2cvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=im+kXAXl1ngYXrrNsoXj2Bx8KGrOh4v3DFEgf74Bow4=;
 b=YwYeHrEte/VYM8/vWSzQobQY48RNa2cGMKI3j775rJXR1UCtVAKGRYNSeq2OGBaM0Tc2lYsgwmfAOHc75gRdNJD++fd14IWEEQ9M5Wl4xVNgfS6SkaaT5EKNU+z6v6klMTwuPJWhCnZp7peSdhoXJwEvbSCqz+Ig5i5nbNTXO70=
Received: from BYAPR07CA0025.namprd07.prod.outlook.com (2603:10b6:a02:bc::38)
 by DS7PR12MB6007.namprd12.prod.outlook.com (2603:10b6:8:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:15:42 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::8a) by BYAPR07CA0025.outlook.office365.com
 (2603:10b6:a02:bc::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.38 via Frontend Transport; Mon,
 24 Mar 2025 21:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:15:42 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:15:40 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 7/8] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Mon, 24 Mar 2025 21:15:31 +0000
Message-ID: <d8de6de80c36721ea3eb92ecac81b211f401c3b2.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|DS7PR12MB6007:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5fc2d1-5f5a-4282-57bf-08dd6b1908f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fV/5WiPOwla20kuaSTL5aeoOa5F3f391aZaWUxwT8C5EHeWtVWfdr8PpSJDl?=
 =?us-ascii?Q?/Kz9r2ppmBrK4QUKJIWcMFLyB9D0n9COpYF7tXworvoCCLAEQF9t89bcTxJd?=
 =?us-ascii?Q?6O9FsJ11sFf1NV0ShVIZcc3SR+ebtRy4911+zNHpiSDayU24JDN8K7sVsM9X?=
 =?us-ascii?Q?gU0GG+WSKwFv6bWfXk60Ip+/PMrMYWcjKza/OmHyHhNh+ABfNtltmip4VLfX?=
 =?us-ascii?Q?gTlhN9RoUUhqXK05bVq+mo5jpzYCWowMRINPEP0skoqY2Uqo4T4f2qRNBewG?=
 =?us-ascii?Q?MZlWYajS30dmq5HKOdOL0iTJqHlM27pLKCR+RqipArDl0pP9h0aBZPqK9/LI?=
 =?us-ascii?Q?rZzdZbpqWRP6jV/XdXrUsk1nNqLrrBoXet1ni76afpUeZo2eMc1C4XaFpvGQ?=
 =?us-ascii?Q?/aDnH79JGo69FzskoMfAD9/ztYSqVljlRaM83vMr8aVwZn3MpUHHSlRamfYB?=
 =?us-ascii?Q?3lvlR3urmFwyVD/2DWWdELh5huLzptAzhlXywQlEoDHrr2aJO2jwvGy4LmC2?=
 =?us-ascii?Q?p2jh6sDbiJtgd4xUtpd+Qtl+guWOJa+U8B2gvrDty0oo7Ufe5JEmlr1RKaZA?=
 =?us-ascii?Q?Uw3VJmD0aFRyC0wbNZgeSkSnRbeJ1RPVcDGfdK3VqnbyAKEgK7gKrxIvV1pu?=
 =?us-ascii?Q?Cgq6v4Ms4olWNagTaRhUxjf3HMXE40JqVFG+SUK5KTdPjl2tQDq+z2nj3wE4?=
 =?us-ascii?Q?k/ZhNOdi1uqKvPUolzFpQ4garuUCUAq83AkHVufCOhTagzNRUjzd1yz/P62e?=
 =?us-ascii?Q?z4ZxGE026iErzd5jl2PRrVgesr1DwBvoCh6z+3WUOWUC+Zwpvy1AWtmlNMzr?=
 =?us-ascii?Q?FGm1koa5fYP0XZN4MY6aFNJtghqQuzeg/cBPUfdzzeBJCCTIjTDQAog123K5?=
 =?us-ascii?Q?7bOCWCylD9Qsbo3SL/JjWOT9JEyHL6TLtQXlSUYXg/QZnE6O/UdI1I8dA7U6?=
 =?us-ascii?Q?iouOyB/8XcN8Yrhh4vjiJJZM7Ilp9lZibjKuMyLH7swWDhWktbboJM08oJrP?=
 =?us-ascii?Q?92PmvLmTtsw+DWEQm3UFkfx9SPr73qKHm87Zb52b7lF0jXQcxT8JOn6FYqOz?=
 =?us-ascii?Q?70K3kE+mFxjOj/RTHdoJuXhB//mEiSXZspODoNneEv29En8CFtC/vnpNaf3p?=
 =?us-ascii?Q?MD2UJgv7bgLSoiGxVT5k+edFrYKOOkk6KGHOTNbKxycSYVT0vFrAv0A31DTN?=
 =?us-ascii?Q?m77l7H/DTCSg6Rpv35HHnxbDxhGO3dwAmTKaFt1xTVGYZ2Fxl2YT2CL7jfDP?=
 =?us-ascii?Q?0vXN8H5l0vBzq6wyWZTm5LUEu5Q1Xv46G9lzReJ2gasofl1lnulwDt7uKdCs?=
 =?us-ascii?Q?x2molj/0leL7kpov78VZ6jJkQdaeaC8sO71e8pWFNKI509geRc/O+IGt6Vi0?=
 =?us-ascii?Q?BYZ6TtHSDX/ipW20A3q/1PPCIZQZJcSyX09kYPLgAhALPRAVEZLJehwlIyW6?=
 =?us-ascii?Q?tLKlwq3xT6pxSSvIc9mCBr0kuAPnX9VkEvdYKGUIdFRZw29on/0rfQRUVxXz?=
 =?us-ascii?Q?3je3oFA/vjO3MVPOUudLUSQaWHh8fjNgNXmS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:15:42.3748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5fc2d1-5f5a-4282-57bf-08dd6b1908f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6007

From: Ashish Kalra <ashish.kalra@amd.com>

Move platform initialization of SEV/SNP from CCP driver probe time to
KVM module load time so that KVM can do SEV/SNP platform initialization
explicitly if it actually wants to use SEV/SNP functionality.

Add support for KVM to explicitly call into the CCP driver at load time
to initialize SEV/SNP. If required, this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
during KVM module unload time.

Continue to support SEV deferred initialization as the user may have the
file containing SEV persistent data for SEV INIT_EX available only later
after module load/init.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..7be4e1647903 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3059,6 +3060,15 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/*
+	 * Do both SNP and SEV initialization at KVM module load.
+	 */
+	init_args.probe = true;
+	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3074,6 +3084,8 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.34.1


