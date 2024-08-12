Return-Path: <kvm+bounces-23883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9794894F79A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 257B41F21D8C
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D9C193087;
	Mon, 12 Aug 2024 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H1SVTpku"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731181917C9;
	Mon, 12 Aug 2024 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723491762; cv=fail; b=qsgEV7CUbvfLTcMrIa2mU+oPhS8E7wleYwwmGXZ86XTNDd1Aki/ocQeX6PfUxhOGaMDsJVwWgQp6TX8C96xG8djautUcAmfSh1uqdxNHdBaQ5UkI4SNxUj8ONpMXFVmD97OFmnb8qjifksq1AYM9OeKUfZL4yRGeIOwzyfDzye0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723491762; c=relaxed/simple;
	bh=eLujWlpcM3GwnxmIsWGH8V0yRezZTHjnAUK9utqO7+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rByT21rLphB23Fyt+6qKF9lfqDFEfk2YoYTI8s0eqhw4LDmoRPyTZ8LT6VAgTfE2NyjODakMDThqf9pOjJW9xnoTh4IVE5OUWLEytAizKtS4gKbKBMX4RWLjxGtdvSD+YtEeQXU9ZfyoJPeXUWCDcfSosqXW9EvYWuAFTv3s6w8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H1SVTpku; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSnaEOfAQIeKsw85hjydJtI0L5ZPq2weXYyZS6bSzTn4ntEV3jVwMpVhk55Dy+6LunCBMv22a+8YjgDBkl3DdxcOpACnmT2kBLCyDrYV8tMuZqTT1kFcp7XkNrIxedyrWMugckJQ8LLzDMs2tfHWRSvM+5vv8w+M1jTQqj8fw+gm65kfPkdv1tKhQIK0vs3jc/YrCxAK0IeQX2sxoU3u534HOl6abmlMQCiaXScdPZ4YUVs78sSsv2NpRhcUnp4vA2SxXX0PYBy8gE7jh14NZHMjzvAvU6mI46cTQxcIcVt7GSeQrMRAUfNW4Qftkct2cr29RqLEWIIxKDOHwv4mIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L886+9zxBPKlF9uhCu8Z4gx2+ck0aYzOtEvNPtj+44U=;
 b=SPYfN6vJkXDBZFcn3OW++QaBtrjpkRilN5FmwpfzoZW+Z4wcDw2KPuykUt6dItou6tRaPofe/NQi4B87Xo6e/0qMKZNrTg2n9BqEq0QHsIb4q1gHhRSRfVjO8bmbLPdqRSnIA8hQzYHdBVy1T27k+JYfyxX4ympn6yDM8vDI23eqFtfS9YnH83oQCDRmPz+p9LPpkU+EA0yOOuvoYIabaSYbBDG0VOJm46W1rJOX/5IvE8IXpPCgi1GdoK/An1dRKKaNVVjo7UxG4KQ4Q4pcVRK9NmMv4nPH1vLsnQSvY1rHtL/rVm4rJj6BJsTbJFHklSMrCURiZ6vfGpjM1w60ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L886+9zxBPKlF9uhCu8Z4gx2+ck0aYzOtEvNPtj+44U=;
 b=H1SVTpkuAkpxs1BtSVONvuiK4OhG1H2v5VykOczwph7OW15vgQd2/Hup64W7C23s6T0JyvG6fxATkzkBrmL7CPfjPGCrGuoz4LSS9DziXOg6RmTVGgjvzceZRHbGFrokExCUsYIcRVhV//wMQFH9JHF9p1Bt+Kk/x7ftNr7SYcs=
Received: from BN9PR03CA0324.namprd03.prod.outlook.com (2603:10b6:408:112::29)
 by SA3PR12MB8801.namprd12.prod.outlook.com (2603:10b6:806:312::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Mon, 12 Aug
 2024 19:42:37 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:408:112:cafe::c9) by BN9PR03CA0324.outlook.office365.com
 (2603:10b6:408:112::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Mon, 12 Aug 2024 19:42:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 12 Aug 2024 19:42:37 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 12 Aug
 2024 14:42:35 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO command
Date: Mon, 12 Aug 2024 19:42:26 +0000
Message-ID: <e11d4bbb11008ab89982d889b1833e158b8ed6ba.1723490152.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1723490152.git.ashish.kalra@amd.com>
References: <cover.1723490152.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|SA3PR12MB8801:EE_
X-MS-Office365-Filtering-Correlation-Id: 3402d09d-1e3c-42ca-a4c5-08dcbb06eb76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ki9PDEy9cGOyQ+XnukpPt4g4qSZSTXQe/TjEwsNA3tHjxM2htKxuC+GwoBuW?=
 =?us-ascii?Q?2MG1tCoDJ/ITxCyizdjp6eGDKMajEf7w+YXi6s1muePnz13B5/x70KUYqME5?=
 =?us-ascii?Q?1J/1d92jtMUtMSeOi6LIiKkyRZ1nPze20JzkHMqE/HIX/oZPSiab11opnbWO?=
 =?us-ascii?Q?YrRK+lPBPhC3kI1kSa5lC/Xbc4N0QSqe+E7CvHQSNPamJEd7m0dwJTUV1Jm0?=
 =?us-ascii?Q?fVgxyG/laLSPVNPN6gYcPGzYaAmHSP2rjDAMYYDajk71KNBytrtUmkce72nC?=
 =?us-ascii?Q?vp3nkBeEyDr8tgIuhZZX3s5ud77neRiYEZFdshR6GfAg6KgRVOERIUXjGtO9?=
 =?us-ascii?Q?g4Gc48UieCprwI1EWxosm8aiHofNNGDTo/QfugaMqT+Bk8kCvZLzMlUy2XH/?=
 =?us-ascii?Q?dhjTAKuxjtzFphiPIQn1OW6iudOsA6VLWjamWW21siWddgV4M2s+pPUpN7mR?=
 =?us-ascii?Q?wENCvmGDWMgH3IhDmTzeJG2xzz2cmXNp7r3JLicNxCz0CcvrHrvChlNGLjLT?=
 =?us-ascii?Q?YkTgAK/Z9nVmj02YGz5eSB/JkNHumAcbnQo70I/TMJMKYUkNzO7SqzP7qaiz?=
 =?us-ascii?Q?s9W6j5pOFKRBRV+EH+rVmBtD0wVXbRUDkRQNGykqM6TTBhykLu7cV+R0sxb0?=
 =?us-ascii?Q?6aOE6k8d91yOz6u+QP5L7gg6wH1oH6DaObcCfiFxW6+cV/u4bxauybGsFfly?=
 =?us-ascii?Q?mP1QLk8h1a9Cdz0LzicjCDQ/xIMtPKc3WuF/gz9IfB+UdfQ/3Gz33SlZVHud?=
 =?us-ascii?Q?OgRxWa1urwg+w6ZuUJR7+QsOsfGGYAlKbz33RMgS+oUct+JUFedXe3KZyfLN?=
 =?us-ascii?Q?rQW/5FPFZniIDkz9Tb0m8i6ZuqTjKfbJujDc0mR78tGD8dQXyz7UWjSB8/0o?=
 =?us-ascii?Q?0/GSq9DwWfYHt5OlpQsjxh6OXy/M1CwvGG85JKaPeIbipkopto3qMooCE9MP?=
 =?us-ascii?Q?pWs/qfP0TeY88x/z9Ze4hqMqpKU5r75k+8E8qf2Vu8HG84tL7USXqtwotqHS?=
 =?us-ascii?Q?3dFJahVjeXL+RNoWpvthOJrZWeqXp2isrMOb4J2v10MohxtOMFv3rZCt7fwe?=
 =?us-ascii?Q?fWets+J/yedzDPE+lC7Gfj6XCqwXme0fIigz+d8/Yl/z6l5B+5+Z66F2UIZT?=
 =?us-ascii?Q?Iv1Jp5pH5btlO1g6NmymWza3L5CG8tKYF2U5VfR7NhcUmga7pNdP70OW7iRk?=
 =?us-ascii?Q?ptl8uE5tJu78X12SkddxogzSNdTMyCbeO74w7DSI8TUWfdOejUBrEHM4yK7t?=
 =?us-ascii?Q?QmK7cRWQTX+4rOTE0+pyscV3ZNrTwfu0w9CZk8+2jGwlsxfOuOGbK3KJ+O9+?=
 =?us-ascii?Q?gm1k3Ry7FrnYPILuIytfRueCEUWhZ6ABaklZbMwxTYLSK2o0ve4Ufzq7e9nG?=
 =?us-ascii?Q?zO3sosXgY5kp1oaQYoQnDG92BWFH1wZZjYkbQ/qdtVyBdPIxeJsF/94W/uKj?=
 =?us-ascii?Q?ViEDqDDTPwG2g+K6rPlf5Gd6rWcN5ckB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 19:42:37.3605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3402d09d-1e3c-42ca-a4c5-08dcbb06eb76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8801

From: Ashish Kalra <ashish.kalra@amd.com>

The FEATURE_INFO command provides host and guests a programmatic means
to learn about the supported features of the currently loaded firmware.
FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
Instead of using the CPUID instruction to retrieve Fn8000_0024,
software can use FEATURE_INFO.

During CCP module initialization, after firmware update, the SNP
platform status and feature information from CPUID 0x8000_0024,
sub-function 0, are cached in the sev_device structure.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 40 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 +++
 include/linux/psp-sev.h      | 31 ++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d..eefb481db5af 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_feature_info);
 	default:				return 0;
 	}
 
@@ -1052,6 +1053,43 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
 }
 
+static void sev_cache_snp_platform_status_and_discover_features(void)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_snp_feature_info snp_feat_info;
+	struct sev_feature_info *feat_info;
+	struct sev_data_snp_addr buf;
+	int error = 0, rc;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	buf.address = __psp_pa(&sev->snp_plat_status);
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
+
+	/*
+	 * Do feature discovery of the currently loaded firmware,
+	 * and cache feature information from CPUID 0x8000_0024,
+	 * sub-function 0.
+	 */
+	if (!rc && sev->snp_plat_status.feature_info) {
+		/*
+		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
+		 * command to handle any alignment and page boundary check
+		 * requirements.
+		 */
+		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);
+		snp_feat_info.length = sizeof(snp_feat_info);
+		snp_feat_info.ecx_in = 0;
+		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
+
+		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
+		if (!rc)
+			sev->feat_info = *feat_info;
+		kfree(feat_info);
+	}
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -2395,6 +2433,8 @@ void sev_pci_init(void)
 	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	sev_cache_snp_platform_status_and_discover_features();
+
 	/* Initialize the platform */
 	args.probe = true;
 	rc = sev_platform_init(&args);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..11e571e87e18 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -57,6 +57,9 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+	struct sev_user_data_snp_status snp_plat_status;
+	struct sev_feature_info feat_info;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..d46d73911a76 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -107,6 +107,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
 	SEV_CMD_SNP_COMMIT		= 0x0CB,
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
 	SEV_CMD_MAX,
 };
@@ -812,6 +813,36 @@ struct sev_data_snp_commit {
 	u32 len;
 } __packed;
 
+/**
+ * struct sev_snp_feature_info - SEV_SNP_FEATURE_INFO structure
+ *
+ * @length: len of the command buffer read by the PSP
+ * @ecx_in: subfunction index
+ * @feature_info_paddr : SPA of the FEATURE_INFO structure
+ */
+struct sev_snp_feature_info {
+	u32 length;
+	u32 ecx_in;
+	u64 feature_info_paddr;
+} __packed;
+
+/**
+ * struct feature_info - FEATURE_INFO structure
+ *
+ * @eax: output of SEV_SNP_FEATURE_INFO command
+ * @ebx: output of SEV_SNP_FEATURE_INFO command
+ * @ecx: output of SEV_SNP_FEATURE_INFO command
+ * #edx: output of SEV_SNP_FEATURE_INFO command
+ */
+struct sev_feature_info {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+#define FEAT_CIPHERTEXTHIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
-- 
2.34.1


