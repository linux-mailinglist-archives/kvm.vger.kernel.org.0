Return-Path: <kvm+bounces-47054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BF6ABCBD3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD5E81BA12BC
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7C523C8BE;
	Mon, 19 May 2025 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ImoHFwRW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A4D23BD04;
	Mon, 19 May 2025 23:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699021; cv=fail; b=M0U1FU2Xb4gygv/ZoEYwRoU6scTSpzvzNmneplIOb4dvk2cYcpmv+1TB+YEwwcZRpuzjXGspSmWwLYJaAGljcHuJlHJ4Ll0HcfHfWhi9jYgXPmEVRZE26pmR0zMHvcOoUPfGOn9xW0SlGPdiDchZT/tcBkB05oWCv2KIMrGiQCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699021; c=relaxed/simple;
	bh=kZLcIU7QZnldYGsSKsdizS3lzPgflqHKvQAn0gJqXAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZrB+igiRDKLYD132e3++iRxU5TmD2IjRCUA9jqkBLHH3tKrck6C6PxhqktG3zonTrf6bNsd5EHWpf8MzRrNaP0oEyYoSy3SVAPC+Ixc+9B0kP+0mC8HE+2U5rmr87KptKPN6tfV+shxeRNa4lt0cGqmVPmaQ3VIMMLybkK0djw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ImoHFwRW; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjuJ9m6le4/nkUJdtQkF7eCN2QAp5KgAx78niyjgDj+Z3YhALffMUbofL2z+PELNLcpyjCr3RSeUAQPB+Zq5uiFdILqEzQWoOowqBhxLexRzZI9/6Qyt+dcqk2C6zQn8IdtsRj0h/Ayz5miuWIf4tUQ6gvp0ogy3aHo44lTZU4vHvgyvNj1qJ6uf/vFjRq6I6qukOOck9ugV6hrxqHAYcSUAjryfdgOt37ZHWc4XmoJ5PpuPw71Dcnv5jgCbvaHEbiQUsxb0M7njg/JkowytoHhMUPJtCR4/2jnE5WTFvc8qJVSqoMhyobHngmXA2m+0fgCSyGTy7BP1zk+Cv89/uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEzHrWEEZCwPvUaiypKb7J64aUHXXdOCZztwylwESTw=;
 b=FzyYdwsq1QAHzjejjmwPv37XX9wLPv2jQ2Koemxb7CkHO3+tEzN6jGOBree/GBzcjeMQW/jiDLJDAxMT8p8Dz46F6n/KHU09LPctVxoidPuUpd4leYzCBq7BIksizlRuCuUNGxsguDozOGx4UEPW/kSzrtELiFXW+sgCGnuo/Ant9g4KV7smb6kkIfoeq4TFBe1ODNXJ4mK3D2oon8CTlKl49TlXAw3yuRakD/1c9wZDm69DUxifZBHcAYgIOA997pOsxbYRz/ZRmbP1knAIRxgjZSRgCkWEdr/49zCl7NdmDfCAck7h8s2mzgemnhgRd1QGDND6CdVnSHNlFMGmWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEzHrWEEZCwPvUaiypKb7J64aUHXXdOCZztwylwESTw=;
 b=ImoHFwRW0ft0VUwrCzYdYFDpjFBB7nXvuFu75tV84qZpKAn6t+YSRP9jb+kuuyJFXBWqokAa9RIfxsHvFfgSzEycI7VqucOtYS6IYk4n2KZJjWNl8unJtzCEjO71WjIY0mZ67WwkIbGvaYg379J7JXuEHOtu3fbIFIdhyQKP/hU=
Received: from BYAPR06CA0034.namprd06.prod.outlook.com (2603:10b6:a03:d4::47)
 by MN0PR12MB6002.namprd12.prod.outlook.com (2603:10b6:208:37e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 23:56:54 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::66) by BYAPR06CA0034.outlook.office365.com
 (2603:10b6:a03:d4::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Mon,
 19 May 2025 23:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Mon, 19 May 2025 23:56:53 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 18:56:51 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO command
Date: Mon, 19 May 2025 23:56:42 +0000
Message-ID: <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1747696092.git.ashish.kalra@amd.com>
References: <cover.1747696092.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|MN0PR12MB6002:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c00859f-5d0c-4031-2d50-08dd9730d468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rIY8TKU6gPoblMwRus7HlnmUD8gZsSfbcEEf+omk4f/HlQ+6Vv39ymZJyUCT?=
 =?us-ascii?Q?FTU9+aDqnHqsvjrIJarMw0IdVR+jGOr0dxM32Ualvs/zW7eYxvBEVgz/+Bki?=
 =?us-ascii?Q?SBRIrgWPnrXaYNi+qHRpFUGuwx4uDasHjGiZB03HVyU3Q0RnDE470v5XXQzO?=
 =?us-ascii?Q?dzfoc96+4F6ScgMkZ2eF6K2tOB22hRdUM4sDfrpOKU2/ZRKJzrSBURzicPrO?=
 =?us-ascii?Q?k8vs8o2+jEU5vC8iU+VhcZyCahPIfuJswUmsoxtKKa0dfNzTCz1u3REuBRHc?=
 =?us-ascii?Q?ASJiGzf5V8TO+h0S5NyGjunXwrC7nWIqlEsm4+pN3NtGiQ4pmh0CucZnxTxV?=
 =?us-ascii?Q?P5B26bYlvNgwsQlWSSKpm+/G9wYEZDxnrvDOumWIyL+imsGhS41c61JJuZoA?=
 =?us-ascii?Q?8JJhsnfvy5EeqcWOcxRjOzIXaZndHiAaJaQpRyb2CmK7RZchUfWD/V4X+t4a?=
 =?us-ascii?Q?WUt5WacuH9JudLdMx0lz+e0TRqvysbAbyLJTozeK0lwwFCZhvN3fVsr4asOw?=
 =?us-ascii?Q?GTkevTau4RqVDlaAJ3nSTH+w5KYs02tsHUVqU8ZvJuYd3bx3lclevI+8B6lQ?=
 =?us-ascii?Q?wVqwu5KbeafUeLVehOEK3qDKKdaw0HQaYt25UyaIqfrj0P+UIZH95PC3HcUD?=
 =?us-ascii?Q?Dx1XQxCNtShcOGofOkEzjboCHxWEQEPBaeHw4Qw1QHy5r+Zjo/vj8C1WupGv?=
 =?us-ascii?Q?rGpGNDnvrGDdHuFzZ3WU/e0hXTbjQX16jZQerD1XJRgMVNKAwxb6WSs6KR1J?=
 =?us-ascii?Q?i0npG0Ib6QgTvbA5yesZMql21+BrJJkU8GGzbHDwwa9NAEMagWmvProp3wH9?=
 =?us-ascii?Q?FjKg+AfQqS+DfNAcfwhPksVTjabVVBBHwDHNk4Zm5thXvsztq63UUleS/f3R?=
 =?us-ascii?Q?5IV0VGW9SdIT1MP/qVC50addvPjA/Ob1UpLtdfBoIhcO1+sDVP5eL8907cFU?=
 =?us-ascii?Q?ysnYI2wtQJlsRqtmoKHO07HU32tr7MUVFRWjTwrSYTmaEtE9WHgX3lQJwgEM?=
 =?us-ascii?Q?0mUDCu1QPlR0ve55BffpGff9Ap5RYjvV3fjNBbcPCPGm95NaLyzIsnF9Z/ZX?=
 =?us-ascii?Q?CdB5cz5oq0DoidfFGDpWIZcTAwCYduLMlp5A2EhawjBu4JNYkUJm4SKHIi/A?=
 =?us-ascii?Q?SYZnaT6lgp/RpJUf4352O/6njC1Eeslrq3q76yhX9jIL8aj81tphlBawptL2?=
 =?us-ascii?Q?m5KJ2BxYLbSzH3BKDU7/yuQecARl7lKPr6e0rceZi1SRdNXReQAHmKOoD/D/?=
 =?us-ascii?Q?x5wYvsbLhF3ZEJMg8eAD3ucMZRf3kOaV/xoeJle5WWIX+jWCm+ElFNpkcEyA?=
 =?us-ascii?Q?+BxBcIMtwFXPOvXlNUYdaO3sSvyCJV0IzFAqkfznJVM02zPihRVlHzYreTgy?=
 =?us-ascii?Q?6YBZB4PR0NFxl3+V+lpvTeXszKRoas/XZcc7TE1z1P0vUO9AVoDBsC87grUw?=
 =?us-ascii?Q?uO/VaP9w+pI7R6Lfd629HEJB1wAx8kVw+AwjI4lJgs5hm6pgVQUwaJezqzxz?=
 =?us-ascii?Q?4u1F2X6beuxT7PhWA/D4MoLtJ+JHqWoEMcKF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 23:56:53.3042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c00859f-5d0c-4031-2d50-08dd9730d468
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6002

From: Ashish Kalra <ashish.kalra@amd.com>

The FEATURE_INFO command provides host and guests a programmatic means
to learn about the supported features of the currently loaded firmware.
FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
Instead of using the CPUID instruction to retrieve Fn8000_0024,
software can use FEATURE_INFO.

The hypervisor may provide Fn8000_0024 values to the guest via the CPUID
page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
the hypervisor can filter Fn8000_0024. The firmware will examine
Fn8000_0024 and apply its CPUID policy.

Switch to using SNP platform status instead of SEV platform status if
SNP is enabled and cache SNP platform status and feature information
from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 29 +++++++++++++
 3 files changed, 113 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3451bada884e..b642f1183b8b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	default:				return 0;
 	}
 
@@ -1073,6 +1074,69 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
+{
+	struct sev_data_snp_feature_info snp_feat_info;
+	struct sev_device *sev = psp_master->sev_data;
+	struct snp_feature_info *feat_info;
+	struct sev_data_snp_addr buf;
+	struct page *page;
+	int rc;
+
+	/*
+	 * The output buffer must be firmware page if SEV-SNP is
+	 * initialized.
+	 */
+	if (sev->snp_initialized)
+		return -EINVAL;
+
+	buf.address = __psp_pa(&sev->snp_plat_status);
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+
+	if (rc) {
+		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
+			rc, *error);
+		return rc;
+	}
+
+	status->api_major = sev->snp_plat_status.api_major;
+	status->api_minor = sev->snp_plat_status.api_minor;
+	status->build = sev->snp_plat_status.build_id;
+	status->state = sev->snp_plat_status.state;
+
+	/*
+	 * Do feature discovery of the currently loaded firmware,
+	 * and cache feature information from CPUID 0x8000_0024,
+	 * sub-function 0.
+	 */
+	if (sev->snp_plat_status.feature_info) {
+		/*
+		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
+		 * command to handle any alignment and page boundary check
+		 * requirements.
+		 */
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+		feat_info = page_address(page);
+		snp_feat_info.length = sizeof(snp_feat_info);
+		snp_feat_info.ecx_in = 0;
+		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
+
+		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
+
+		if (!rc)
+			sev->feat_info = *feat_info;
+		else
+			dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
+				rc, *error);
+
+		__free_page(page);
+	}
+
+	return rc;
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -1597,6 +1661,23 @@ static int sev_get_api_version(void)
 	struct sev_user_data_status status;
 	int error = 0, ret;
 
+	/*
+	 * Use SNP platform status if SNP is enabled and cache
+	 * SNP platform status and SNP feature information.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
+		ret = snp_get_platform_data(&status, &error);
+		if (ret) {
+			dev_err(sev->dev,
+				"SEV-SNP: failed to get status. Error: %#x\n", error);
+			return 1;
+		}
+	}
+
+	/*
+	 * Fallback to SEV platform status if SNP is not enabled
+	 * or SNP platform status fails.
+	 */
 	ret = sev_platform_status(&status, &error);
 	if (ret) {
 		dev_err(sev->dev,
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..1c1a51e52d2b 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -57,6 +57,9 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+	struct sev_user_data_snp_status snp_plat_status;
+	struct snp_feature_info feat_info;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0b3a36bdaa90..0149d4a6aceb 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -107,6 +107,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
 	SEV_CMD_SNP_COMMIT		= 0x0CB,
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
 	SEV_CMD_MAX,
 };
@@ -812,6 +813,34 @@ struct sev_data_snp_commit {
 	u32 len;
 } __packed;
 
+/**
+ * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
+ *
+ * @length: len of the command buffer read by the PSP
+ * @ecx_in: subfunction index
+ * @feature_info_paddr : SPA of the FEATURE_INFO structure
+ */
+struct sev_data_snp_feature_info {
+	u32 length;
+	u32 ecx_in;
+	u64 feature_info_paddr;
+} __packed;
+
+/**
+ * struct feature_info - FEATURE_INFO structure
+ *
+ * @eax: output of SNP_FEATURE_INFO command
+ * @ebx: output of SNP_FEATURE_INFO command
+ * @ecx: output of SNP_FEATURE_INFO command
+ * #edx: output of SNP_FEATURE_INFO command
+ */
+struct snp_feature_info {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
-- 
2.34.1


