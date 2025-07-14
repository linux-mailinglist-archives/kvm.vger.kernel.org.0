Return-Path: <kvm+bounces-52368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92594B04AD8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36F01AA040F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE8F273D89;
	Mon, 14 Jul 2025 22:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kz6Hd79F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5720D5103F;
	Mon, 14 Jul 2025 22:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532821; cv=fail; b=m+V71/rl4IcaNVKtDQWsgkoinJWvfqH5wwPC0ZpROg/gD36Gmz69V/1xQ9Qi2Nb7walGcn2CHH7SETm2e6Z0UdDXWbtVTzwMeOdaNJwMTtnTzRcx4JtEvHQyLr7h7NhMzcxiX0Cg3BcWFYj7jikEb2EOlTj6/CxpvP1K4XeeVIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532821; c=relaxed/simple;
	bh=Kn7P7bwZ5A+JdQciInEzBqnrHvcTZKRDFC9AVROgplo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UOTQV7Yp6/A375RtzIWyb8CYcFSRcPCaxhHsxJHhXAobdi/zhYLjBNJM99khgMI4XALNvGFZQ1A2pCfU1miQVvueVczX27+XZOBJ8mw19IdHFtKXpeZ58C5nifd/rs7quBatWzXc8aVp7jga+OKv9fBSBx2TER9g86N78+N1i4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kz6Hd79F; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sGuabx2fpvgvoR9IJ0CUwl00sQrJAHv2znFCOGS08H36guWICAmLBCy36XwxflFYx7IgDVqJSAzs1rnMdWvlukvn6cg1NpRxXs30rKNHmdwCGKz+lalTqaT1P0phrKPvIkHYdCnMCyRIiqpjyfGS7yFOs9Dh05EhBfl7yprjoId1tn6baKn2liu1T4/8RQK+XJaRUWaPv5g3m8KQVCpQd12q+ARa/QpsnIXScywgt05joLdP4RWTPfkPD4Xy54rJM/hnoCs53vNd8vctOWWaSXG8lmqX97+hiGAZl7hxRN1D2RU/BEem+z/CW3KUVDwHI5pKpOkPG1RwoIeWrkJDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVkrIfZuUsioM+cnyA+r6AfReIZf83aAxm+tgNechCA=;
 b=ZHPa9T1M+6iLDKHThcJGLMIFk1uTPHIphU9NSpTCzCoxdkVpGjCgoXjneUngUDc3HCI6djbAtwUozl2056DKDmGDDXEzkA/KIGOGIaQYN6tk4ErzRtVKis2+OWE/itfFh+4zJLIlKyWXDRZJh9q23eltc8B2LecYgubXG5K/sZStYj1aySYVBKXMf7l5FRUy+HnfWBHnaz4Gxh3CSqVnOxPgC6CBn1J3yl996kk0xnqDfDbHvN8O8ASTLmHuXvamWiO23N+M7HCX6V44MZci1lk1YfprWgpWP+H+5QpED0uaNg/INy6N/k56A2YYG+mB1xGea/9BIwAdFnIrrlQliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVkrIfZuUsioM+cnyA+r6AfReIZf83aAxm+tgNechCA=;
 b=Kz6Hd79FSkk4SUrE0VqRVfNcGRjLKYMp2cbZLEWvP2zLRXrS7vNy5z6A9FV6PUMVuLIS+aGYvoBPkd+F8oLZ8xqbHUQd6Uvjc9eMw5t9FIjquix2O1UEbo6JPV12RdWKuHDhdNs4VhE9kxVEuTtHArD9VQX9CF1ECTGbB3YQLbw=
Received: from SN4PR0501CA0123.namprd05.prod.outlook.com
 (2603:10b6:803:42::40) by SA3PR12MB7999.namprd12.prod.outlook.com
 (2603:10b6:806:312::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 14 Jul
 2025 22:40:12 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:803:42:cafe::60) by SN4PR0501CA0123.outlook.office365.com
 (2603:10b6:803:42::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.13 via Frontend Transport; Mon,
 14 Jul 2025 22:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:40:12 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:40:09 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v6 3/7] crypto: ccp - Add support for SNP_FEATURE_INFO command
Date: Mon, 14 Jul 2025 22:39:58 +0000
Message-ID: <7fe696f2cfda1e6cd3c24af5b0a93c70ac692667.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|SA3PR12MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: a476f167-c9cc-4d32-8fa1-08ddc3276559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pTNOtQB5J0UW1XWWfhgyZdO+47RZOvt9ZLMfrEi3DvfFq0LlFaoTDmIklHg1?=
 =?us-ascii?Q?9Ps4ZD4dgUG1RLI2i0LA9t3V2tNn03J/gIMGtQrck723IAdOcoKOHGT3XI9V?=
 =?us-ascii?Q?RDip5w6Hc8uAxKwTv/D4Et3/oGyZ4Il47t/8PDCS6riYqAbIyxPFSP9ZkPGg?=
 =?us-ascii?Q?i23rmLg5/vJBK3SF/0v3/iiNCho5+gtfJjeAwXTDV0kl2peXxkElB502v0F2?=
 =?us-ascii?Q?4vHpi5h6++ofUc7p8QhEbT4g0vchRhjYpKKKhil0WJWBOssmpZqsHQCLSb6b?=
 =?us-ascii?Q?8c7qsbN0wxF76K3Gt/4eqZ3yyFgrHUMpZKkHxyZSYD67aPDewyfanibywnYc?=
 =?us-ascii?Q?2YMPsJePQBn18aJ133u4roaO5ednqGLrIVzQr2WtCjOLbU9wgZmIvlNsGkPP?=
 =?us-ascii?Q?6EA1AEwRK7dff9VjomsSHwX5/QoDyxSY1tuy7ogGbe0Zf1J3U1zky2CQYcUH?=
 =?us-ascii?Q?e7SGcz0bXeW6Fc9fZSI0//HsT3So/30XKZHhX4AjCZYPqyYEaca/Frt957cb?=
 =?us-ascii?Q?yHMW0E/BBu2H/uyPoW7hwsg03USSw9kUZqA26kiuXjLpApfcitbmGiQXdasn?=
 =?us-ascii?Q?mncCKuWNKafaMk/GGLnsYcuTT1Tmbdk6i+Cqj19kZrAzSMv9Z9Uvbmu0posV?=
 =?us-ascii?Q?iye+SgQLd428D4sPVDOmnZy5wun78+Zwk22YbZMwAFIGVpo4OVXDUsaon1eu?=
 =?us-ascii?Q?W6f+VQkwd0kmQD28ik+2kY50E5kihQoR1vgc6H5mB4L3BXITt/oPC9rVH+US?=
 =?us-ascii?Q?TcsmElO+IASXqrl3bD3VM4uQ+mWY72lot/kH5YjD5cIF9PUNVsjRgzkGQ64c?=
 =?us-ascii?Q?V0Lp0KhbEL4Z2a9IFhSnCDnjL0tgs1jln0+EgBTF6LoM/X+1PPYCxJT/ci/U?=
 =?us-ascii?Q?1ooLLu+uCMGh2cf35CdrYYexOeYq3Mg8NdOseG0/3zsB3bFbldNn3Ss/CGdS?=
 =?us-ascii?Q?2nTwq+l+4apId7T9MKUXD7FU/Ab7Hg0mSDdfcdDFEv2H3bRjnkwBy8/3fGFI?=
 =?us-ascii?Q?iWzs2HezyNHX48DTKUC8NMSd46eQiGYeonIFJJ8vbgONeBqbiRo5ROYg2FNz?=
 =?us-ascii?Q?fWAKKvMiD7AqhVX0zz7SApRDiwcRi7RbdNkfPhxb20M6TTXp6E13c19+qIQA?=
 =?us-ascii?Q?nuAmHzRJ8Mh9Y6hB25K9iX4hYnXAX4qCpY8wh85y8WaBibra1a4/dabw0gNE?=
 =?us-ascii?Q?o80SDoD9Q1mL+/Iqwn5XEYrK7i7YnE6biohOnFtqj3nasvVVRPW6cErqUSTs?=
 =?us-ascii?Q?uhUdNGIybNzjWPcKn1cIIgQ24cbaCY91krULaPxzYIIrRRppQTHFnjEtpA1y?=
 =?us-ascii?Q?uwZRms5JIrt3JkcjfKCRMNxmDiEmV1RIs1oBxSTHNNO/X7wCp5NOT1bNHBYW?=
 =?us-ascii?Q?BWKxAIts7TGMI5zDLSMK/gWg5NLTQ7t4DRwUP2ei0o2in88z1pGcNhBacHSN?=
 =?us-ascii?Q?fiuBvKTkJzokapUyj/XxlgdotYUfhfqOF7w2ahUzR6rYhMhs58pBzsGq8x/u?=
 =?us-ascii?Q?2EqJ8M8kTSE3LwSAfPmZ9DtfEPhodqRD1SuTuKi8ZCgJunVMDhCnKFI9vw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:40:12.7573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a476f167-c9cc-4d32-8fa1-08ddc3276559
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7999

From: Ashish Kalra <ashish.kalra@amd.com>

The FEATURE_INFO command provides hypervisors with a programmatic means
to learn about the supported features of the currently loaded firmware.
This command mimics the CPUID instruction relative to sub-leaf input and
the four unsigned integer output values. To obtain information
regarding the features present in the currently loaded SEV firmware,
use the SNP_FEATURE_INFO command.

Cache the SNP platform status and feature information from CPUID
0x8000_0024 in the sev_device structure. If SNP is enabled, utilize
this cached SNP platform status for the API major, minor and build
version.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 72 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 29 +++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 528013be1c0a..8f4e22751bc4 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	default:				return 0;
 	}
 
@@ -1073,6 +1074,67 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+static int snp_get_platform_data(struct sev_device *sev, int *error)
+{
+	struct sev_data_snp_feature_info snp_feat_info;
+	struct snp_feature_info *feat_info;
+	struct sev_data_snp_addr buf;
+	struct page *page;
+	int rc;
+
+	/*
+	 * This function is expected to be called before SNP is not
+	 * initialized.
+	 */
+	if (sev->snp_initialized)
+		return -EINVAL;
+
+	buf.address = __psp_pa(&sev->snp_plat_status);
+	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+	if (rc) {
+		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
+			rc, *error);
+		return rc;
+	}
+
+	sev->api_major = sev->snp_plat_status.api_major;
+	sev->api_minor = sev->snp_plat_status.api_minor;
+	sev->build = sev->snp_plat_status.build_id;
+
+	/*
+	 * Do feature discovery of the currently loaded firmware,
+	 * and cache feature information from CPUID 0x8000_0024,
+	 * sub-function 0.
+	 */
+	if (!sev->snp_plat_status.feature_info)
+		return 0;
+
+	/*
+	 * Use dynamically allocated structure for the SNP_FEATURE_INFO
+	 * command to ensure structure is 8-byte aligned, and does not
+	 * cross a page boundary.
+	 */
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	feat_info = page_address(page);
+	snp_feat_info.length = sizeof(snp_feat_info);
+	snp_feat_info.ecx_in = 0;
+	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
+
+	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
+	if (!rc)
+		sev->snp_feat_info_0 = *feat_info;
+	else
+		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
+			rc, *error);
+
+	__free_page(page);
+
+	return rc;
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -1599,6 +1661,16 @@ static int sev_get_api_version(void)
 	struct sev_user_data_status status;
 	int error = 0, ret;
 
+	/*
+	 * Cache SNP platform status and SNP feature information
+	 * if SNP is available.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
+		ret = snp_get_platform_data(sev, &error);
+		if (ret)
+			return 1;
+	}
+
 	ret = sev_platform_status(&status, &error);
 	if (ret) {
 		dev_err(sev->dev,
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 24dd8ff8afaa..5aed2595c9ae 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -58,6 +58,9 @@ struct sev_device {
 	bool snp_initialized;
 
 	struct sev_user_data_status sev_plat_status;
+
+	struct sev_user_data_snp_status snp_plat_status;
+	struct snp_feature_info snp_feat_info_0;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0f5f94137f6d..5fb6ae0f51cc 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -107,6 +107,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
 	SEV_CMD_SNP_COMMIT		= 0x0CB,
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
 	SEV_CMD_MAX,
 };
@@ -814,6 +815,34 @@ struct sev_data_snp_commit {
 	u32 len;
 } __packed;
 
+/**
+ * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
+ *
+ * @length: len of the command buffer read by the PSP
+ * @ecx_in: subfunction index
+ * @feature_info_paddr : System Physical Address of the FEATURE_INFO structure
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


