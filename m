Return-Path: <kvm+bounces-43737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75FAA95A29
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E0343B4F9F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E0C13AA20;
	Tue, 22 Apr 2025 00:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SWGUZw+0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520F813AD1C;
	Tue, 22 Apr 2025 00:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281499; cv=fail; b=r1FXPZxRNoFE/+UDYFoiyb/0tVlMjg0yLhg5A68Ye329m8AiZvYXiUAGqxnLhN3Bw1J6RYFcKYlcYQ+86uYbXtdRCEPIKs2AYkgNXumsmegTQWvd0xzV5QcFkCLbFA9nwbyxweE1t+QCVCQt18jkTo0QApWra7QNkYSJXGMJpjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281499; c=relaxed/simple;
	bh=5EoKTo0bswkf0QNkEbOjZ6qCP+9qcKB1BrSctwhXDvI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOp+zkjR/uyq/R/FA4YlS6xzIuHDjgNm7mXFvx0h/dTAfkYGrhUrBwR9aaMn41FubuQ6C5ZlOYJbP71hpjCok1+yOqWTvFcMCUuvm5t/UYacWvyVjef/EdR+ulgKOskF/jrN+bKu2jrl34gueJecMgT2auSv7rfgAT3auG5NjZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SWGUZw+0; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dRvR3k003QKe3OEUImQ6kA3ygerkQOCP+XGkvajwh4BBUoNlR+YW8+hFVKDO59GQesglozvj6p6jPpyXrizqAu9NzqFLS6T+Xu8dnsJt9pZjJMsrLW1VJnFs/vWyzV5LX6+ldThc2ley0dtXzJaDq8upyRK2E9sHGg82D65sdXMvbxBb4oiIpXFjQ++WrQslh/XX+6POM+NHM9+5k3tre2B2maLAqekkLJxE39/9PR2CJBeSIWmAH4SGM3UMug8D5Rfn8JQ0McMYep3EmzOkrn9y+1QXbXthG71mrkuAFcJrF6B+ST2rVJTR9kOlms90pUsRHhxCn84r6pWAuHUxag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/4Tc99I0VjnL+qa3veHlnKtnZFrRVXjP2j0N61Wabc=;
 b=cVzwrI2TeHlUkZoxnr4IZ5futa7NHdHzbgMe94Jafr7UNVuKVw8oyX44zryrN+g05ApU8dUO6077rMuZfa+zA7nSkw56OxDrhtDatQ3i3cBtb4r3bGLASlWMLBrRaedgB53OIfeGImVRMV/m4jPcQRR+ptKFu71pd83rW/naCuAT+3FvpzwAvF+iCF9helcTqSlk4/G2vDSDPNZKSFmWwiNFEZLSBcuFjSoJklI2r3dqALh8vo3wcV5kOz/nZFCSLkflJ0L0A/BbzxxxNPNjd/kq+DSlfytRCgOfv+GEEUZSmx7QagMnBgiI5GR7ZSQvShOT5EkJ4+a9TGx7/ZOmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/4Tc99I0VjnL+qa3veHlnKtnZFrRVXjP2j0N61Wabc=;
 b=SWGUZw+071jwTQrY3p0y8GzUcgkhOPm+vT7/jqM7M0sZCSvDg0F0dcNuMxm34WL4fyzsDpYpH2sn8jwn+k+e0zt1BUhkmyY5Ss/wujG4Z5Aq+yrcdCIDpUFeqhSrxGgS0IK0rZUsQL4xtKJRaN5iYbkNpuR0e+ZsNoe5DU+WJak=
Received: from BL0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:207:3d::36)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.31; Tue, 22 Apr
 2025 00:24:53 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:207:3d:cafe::9e) by BL0PR02CA0059.outlook.office365.com
 (2603:10b6:207:3d::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Tue,
 22 Apr 2025 00:24:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.1 via Frontend Transport; Tue, 22 Apr 2025 00:24:52 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 19:24:51 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v3 2/4] crypto: ccp: Add support for SNP_FEATURE_INFO command
Date: Tue, 22 Apr 2025 00:24:41 +0000
Message-ID: <0ec035a24116dce7c8b2a36a29cf5eed96e0eb52.1745279916.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1745279916.git.ashish.kalra@amd.com>
References: <cover.1745279916.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 132f3039-73ef-4b9a-d3a8-08dd813419e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mi5MtHFLRuYNYxfCs6A0IlkBZxx/bpS91B4NXiwxm3btL5fQfXOhS33j6HP2?=
 =?us-ascii?Q?GPhghWTe5KHOxjnJn+1Av4dgMbam3t+RH+MnQ51/scZDilLwOIgqfdnLuPH5?=
 =?us-ascii?Q?oawYvTBjgTkcjXPdgaEXOimpqmqaGZBnSlPvqEIkTSFllapXhBukjgTV06Gt?=
 =?us-ascii?Q?SnFHYNBnZ9YPfi77z+/DqQ43l6eJEyHuiEEqhrv5jUocKIcjbJyov/1/1lrX?=
 =?us-ascii?Q?AI4iN05tZpYMEq1B9df9AczyUG5hDaO1pvKf+MPsxLsKj6dUJrFNxQIXE2vl?=
 =?us-ascii?Q?qOjZ3asVI6TodLeiQKL37afu3K9Ga9yNtsptdane6/RtjAkMl8Fn1apLCByK?=
 =?us-ascii?Q?uzn4Vb66EjJzlNQ4jbUIYjohdB4K3ecieJkzvli2HY3QVzdCvFLF5jMvBgvA?=
 =?us-ascii?Q?yVL3NqGBc/nrExlyBVur5CdTYEcr9cP+0n4wbdh68x6nosNFQHYKmbGmcwWX?=
 =?us-ascii?Q?OXCfsGWiKc/5go8Qn7zQLIdLrfbiAv+9lws+E0Alw33adJQb7yNfbON0BAt7?=
 =?us-ascii?Q?7f0eRuNY1PWpLmaqijD4NUARqZfdtoMbkDGm22iPyVSBi4f57zEqolUBnhOG?=
 =?us-ascii?Q?s4lhQDq3dTX2RnQaTrqW8jcz43gTySbJM9fXBN/YFyvaeRhLCji38Nv3w5bW?=
 =?us-ascii?Q?PJWsQX6g9Sve6sYN8psawuWr/XHM6okrniDrCYaqLCETds5Zmz4MVPtP18lK?=
 =?us-ascii?Q?FxhV5DfSKt4FijiU40C2vg6BxxRHDBFbr/wUgpCrzViW5gmgnnCHeZi43fLP?=
 =?us-ascii?Q?Wzio0GuM1Mk0EMKAI/hoZWFogTPlxH1Q5VSuacxm3Dzh4+WOuOAV0S2Mv+UX?=
 =?us-ascii?Q?ZOI0MXq2w4nqBZCPXdKSM2zfj4ZGgwt60tfMnv+G+Y1VlxXNz9P978M7IQpT?=
 =?us-ascii?Q?nG94VI32VyFVzJ7PFw49NlHW3rJ6ojgwl8NqQfdjjJnBjWxoBeaTXYtPeoq0?=
 =?us-ascii?Q?2C44MN2RzLMLFEBmZzoFm+pKhi108AHfCskp31aZoE18WBGMVkCYgh9+LkMi?=
 =?us-ascii?Q?/9DJlcKU412SUwJKULsrlfBn67qB9icPCv31XOOVPln/bzxid2w4s5k1GD74?=
 =?us-ascii?Q?VUmr3nQbJyPWN3pjrO57G3FKlDVbOcMcacgK5LgJuvoIWfeOv5WdZCpeBfX8?=
 =?us-ascii?Q?Vf763oRGxSqLYuuBRyGc2KxEYqt3vxNnac4tG870aA992o8WpBEC2niChRU5?=
 =?us-ascii?Q?Um5fhgT0pnKiry5n9sSVRVjKTvMxNFtvurAvaFMNDWJURytqOp7Z4dVF9Mqc?=
 =?us-ascii?Q?Tc+gKXR13qXivAiFbf5Y4BEe3FZlTA67tSdb4eZ5PH6zZ02Ow8UDPJBjapDg?=
 =?us-ascii?Q?xHguzyc9+ULucfEsAORKnQct7PnyNsBAxlsqIVvjWBw+gxK8sN3AbN1fkVHe?=
 =?us-ascii?Q?E9ypXGs+Jl82HfojB66B0zYNvk2YW09yMR/CCn9+HEXq8KbImp/xef6yssyF?=
 =?us-ascii?Q?aZBvk5Z8SB3eJn2D0jRWQzSMyY5vhaCJruLkpuHDkwMAbcgPI9U3Zu3KOzZG?=
 =?us-ascii?Q?O5z1wCE5n3JQeMa9i+myXWDBRIMUUyt13mDw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:24:52.8942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 132f3039-73ef-4b9a-d3a8-08dd813419e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572

From: Ashish Kalra <ashish.kalra@amd.com>

The FEATURE_INFO command provides host and guests a programmatic means
to learn about the supported features of the currently loaded firmware.
FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
Instead of using the CPUID instruction to retrieve Fn8000_0024,
software can use FEATURE_INFO.

Host/Hypervisor would use the FEATURE_INFO command, while guests would
actually issue the CPUID instruction.

The hypervisor can provide Fn8000_0024 values to the guest via the CPUID
page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
the hypervisor can filter Fn8000_0024. The firmware will examine
Fn8000_0024 and apply its CPUID policy.

During CCP module initialization, after firmware update, the SNP
platform status and feature information from CPUID 0x8000_0024,
sub-function 0, are cached in the sev_device structure.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 +++
 include/linux/psp-sev.h      | 29 ++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b08db412f752..f4f8a8905115 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -232,6 +232,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
 	default:				return 0;
 	}
 
@@ -1072,6 +1073,50 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+static void snp_get_platform_data(void)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_feature_info snp_feat_info;
+	struct snp_feature_info *feat_info;
+	struct sev_data_snp_addr buf;
+	int error = 0, rc;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	/*
+	 * The output buffer must be firmware page if SEV-SNP is
+	 * initialized.
+	 */
+	if (sev->snp_initialized)
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
@@ -2543,6 +2588,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	snp_get_platform_data();
+
 	return;
 
 err:
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


