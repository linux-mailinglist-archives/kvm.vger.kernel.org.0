Return-Path: <kvm+bounces-40297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7598A55AC8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F184E176EC5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB7527E1A8;
	Thu,  6 Mar 2025 23:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gSyKwkb4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23951278107;
	Thu,  6 Mar 2025 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302682; cv=fail; b=D1vn8Sfim1sfk7U8KTKS8UjbIorFuBfh3kSlxuJn9XKBlOxcBjuu3qG6eY/0ElxpG8vOiLF1QoCvjc9pfMxkE4d04QK44eluAzCw59GnYucG906iftrMGzOIB2pZ9AKt6fpon2CwP+48pY0RrSB6g+X1EbBwAAPfUCVGcZ7FYmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302682; c=relaxed/simple;
	bh=N3rUFLUIrPb+/yG2hrzRJGfkALzE0DdrDrJfAcb85Y0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HEaZ38+MVSFzH/LY2TXeMuxR5GtOR2sFVBR9uVeD4HWX5K3JoS6vokl/MnjXsEfQLE8zbTH/3FJ2ApIcCpLF4XXmup0VevT4kHf4NVCBFVj6TGBa+4xjBR8suoVSFR3ZsL0lNDdN5SnoBV3fwA+5QVC5Lrvx3SHjsrTDpvmUD58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gSyKwkb4; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTwwBy3RqQsKx2ybVb225vyNGHnWXgfLcBu3cE8xn8iyOQp59km3Y0aNEeQXz/8PX3bxzl6Magp7orflSXtORN0Tl7nZkfGcH1bqrxyKmL8cKxbMh3hbnMLK0XwAcKKhB4nYrMIL0KaoJIJf0SOv1/HuGDLTC2YCPeDAsxV5CpbS1Rb4XJAb4fWx7QQ5zcMbk7aUSi+3zSVZ0aSXLXKf7x6RYBLte31jV8vVbXiMKm73cHFFwmHR9tgvK8CNCNSLyPNb6h7Jawcivqw/rklCHTDYesGeIZNMhKzyd1ZhvdLevBhW6wohEcFNWV4FnjraK6+HMjsLjVkn6MlGpPrVlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=im+kXAXl1ngYXrrNsoXj2Bx8KGrOh4v3DFEgf74Bow4=;
 b=YguZrePmv4MjsAYkBOzdZ+yz5/r1Mn36z/kjx9uUsyr2Qg8y2w3o47jkZQVfL32Sve/M4SeZq2ExlilZFgSdk19cWnOl3Fj9FU5Ec0gQSGRr8JXtwCwg4uSTvGicwoyOARPTJmW8g8P81dbLj0HDuF87X+pWywPTW38OcPy6KfMdbHdzB+vWil5YwonNmgabMpR1/c5G3UvaUsvdVeHkEr6a3MgYGnKvjiFlSzBleKQ6sWAs+M7Bfob4EBeVL2i81zINFzwcIna6E/PpOecuMMu43xJZVYi0e2zgfxMs7uyOvlbmmfdELv80/IdRY+5ixn9zSn58HUkFay2S30ZJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=im+kXAXl1ngYXrrNsoXj2Bx8KGrOh4v3DFEgf74Bow4=;
 b=gSyKwkb4m2OFblpyg9i8IONlHwbe4DlQEdEei6UswCePs9iYE2Vk1aJgi/nMReF8eZvTjlON7OO4LDlcWSvf7eVORYWGEmhOBoNgjn/zegy+cQwjezaFfmNkp/jMmGbIpucYVWh3mQQ0JXH99bZP+VwiMkqc2WHE1c0ll7lRRFc=
Received: from SA1P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::23)
 by CH3PR12MB8970.namprd12.prod.outlook.com (2603:10b6:610:176::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 23:11:14 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:806:22c:cafe::e0) by SA1P222CA0014.outlook.office365.com
 (2603:10b6:806:22c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Thu,
 6 Mar 2025 23:11:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:11:13 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:11:12 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 7/8] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Thu, 6 Mar 2025 23:11:03 +0000
Message-ID: <cbd2f5252549d8499a7a0058db17376003317e15.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|CH3PR12MB8970:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1a8e51-536a-460a-0c9e-08dd5d0430cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MjVoYjtv0brnZhG1DxrM+WgFaFl4IuooWLTu71nqwspE6wCSBZc46JI4rJTi?=
 =?us-ascii?Q?zXynIzMJ3Qe7jF2bA1QAyhC9LBp9Pz7InEhQSFc5wOyOOQ99+EJY/0IpjKPR?=
 =?us-ascii?Q?MMKtSPt3k1WVPmd28kD49BOJ4qFYA/GvR/dnA1C+L6QvUn21c5oO1YXOqCrE?=
 =?us-ascii?Q?nFsA1kgsmw/s21ITZc3t0wV3PQN1+6fv4yUWQjdA5lfKdlWDozHuCJrXz1zL?=
 =?us-ascii?Q?BWvk6Z6SiGHb3ByXM4jLsk5X4qhY5/ERidhsnPXpfQHp5NckDS8IjJITR8aT?=
 =?us-ascii?Q?bvWBkdNZKHlCMeBs+AX/l5pTc4PGGqURPo9W7+F7EtKre67NfOs0MvN5u+p+?=
 =?us-ascii?Q?2UncYGQYRGvKLlxzoP5khjOg0s8K9rUlSnm4wmK770va8Tc0XRWAUXYfPzlT?=
 =?us-ascii?Q?OAS/L2ydNNzIY6J3G+gBiqT3vLIafnlmlSlfQ8Z0R/xChrnQv8Jvkp3V4sP/?=
 =?us-ascii?Q?LuVbqx1Mhs5x7fvg/0aLIEjjvv/cUE2CwwmPBEO2GfLt85IH8Ps+kUc5URTn?=
 =?us-ascii?Q?tRMRA93z6RUTexoBSFzy2RvlpY/y8OFOwIfSihh2MTwdNH9ZgtIb/VyNuJAV?=
 =?us-ascii?Q?eG7PNh5G+WqIva/S5IMDbBCu8p4qo1DOKkFuwJUuWt9Q7MsbfWbkks1e+icm?=
 =?us-ascii?Q?eQKw633PKlduUOr2sEez0h8LkNkC+zl03UynqO2EP3xdrtaou9IvqSn0ZUNr?=
 =?us-ascii?Q?FjqUReORWfTXoUgbl+qMDnPLH15rX5RnEOyCpdrMg99jZHypqc6k7VFtF+3U?=
 =?us-ascii?Q?OPD8zE1eHXAa2BzsknawIr9ckUpuvFzdMEMmFg4rUzmtNKgJquXgZAB1okdm?=
 =?us-ascii?Q?6TffWZ3+/O+tllaXUVuB9XB0Y7EtKzOR1ETFpRVuN22S2+0YNucMkiPNkDWr?=
 =?us-ascii?Q?KGzYf3SlDdCraqrkhHuqXCoWFY2JxMndyXlSa9pwbW7z80xGg0+v0fkQp3ro?=
 =?us-ascii?Q?JQu/8AHTviZQhRGEdohsBn4NqPH9NUwnOrdyMv3yuP06227mqO8b1bsQU4Ad?=
 =?us-ascii?Q?Pzn2yLYeuBOMpaK0SfeX16+On+TOKXJpe7Ovxj5+n0i2K4ObE6TTWcCw/Osv?=
 =?us-ascii?Q?up4qJe7mR1+cuPnxnOE+j76dg0qKiJCiNOPWlzEVT+foBHe1FLDb0VoDFS2X?=
 =?us-ascii?Q?xdhcwdowaCMXg0Y++oM2JMsTOxsx8nGO8cxPtbmGUEer2omouE/ewVO9FDR1?=
 =?us-ascii?Q?ZKXCsKHy+iMlkjCui5g/OtzUwXIWRQGj696yYUZqUAS0mItyj2ymywVu99NO?=
 =?us-ascii?Q?Cu0zrB13Gm6yvqc23CWoOY3scfUt3yR+1eHBd82Qmg/YYOnbbznByUSsBcL8?=
 =?us-ascii?Q?kkhh5buBt5H3xzFWOpiVXBXPQfxqg8/Ow9MqCH9k6lD7uVEyX/pW6EiGtXGo?=
 =?us-ascii?Q?4l98Gxrt0K92xWJvQUROtBGyUWJslB8SlIac9cGc3+XRGb6cxqu3D1hiAdc/?=
 =?us-ascii?Q?uX/dmow9Gnr7xTDTUWprEKdVRHODfPcIRMhpI5ArTyj+nZNO5pKrCvOPjIoq?=
 =?us-ascii?Q?+R7+uPDH4VE8QcQt8BfplwU/gU4Da8W6vZL2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:11:13.5406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1a8e51-536a-460a-0c9e-08dd5d0430cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8970

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


