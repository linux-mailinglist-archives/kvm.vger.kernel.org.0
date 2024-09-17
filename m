Return-Path: <kvm+bounces-27059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B0597B486
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 22:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B814AB292F3
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 20:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F0C18BC04;
	Tue, 17 Sep 2024 20:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TH73XsqZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7944214A4D6;
	Tue, 17 Sep 2024 20:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604203; cv=fail; b=h3IyHwNLRQXZOfoT6XkdydIw3yRxCmwqRVPx0IBZVbbLSjBEuKgKr3SKTmAWwUeNDuGvvywLRsxtRuKdNRjrXFpSV2cuJA4qdHHM4Mm/XVY+m7rs9wuMQNHzyJalRRMF7bHpIaGwVbEWZFIYI3CaFQvHQDFVBLT9qh9UN58YQaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604203; c=relaxed/simple;
	bh=x+x3I4U5DGo/49XGe8AnE6PNbB4UDkeGFIU5/UfY8Fg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un7IeUS/2DLj7mY/bQJkXKCK4Q84VF18Lj09pKMOdzQwUadSUaxhqe6cREuFoUdnUttZXN2kkPzloMiRzA7LzeC96NH7XyyPW37czb9UbbMZXlxgSfeg5Z4oiNXen0UEqM35j3LWGm0U4RqUYvBWhM9J7CHnicKBeBD8Mzi6sgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TH73XsqZ; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yv+yPs9z+AIwoRxA2TFdX9BpKT+p/EX43DdLs27a8hW8iREtT6TFuiHW7WAM1VRWvoQX4/PwWX6dtNTLq+8Lgei7X77HGKAB+7pHzqbLkV9t8mrf2r9NkS07xNBe/sA1A01IRASawkvGkpbQKTEOpZKO5RMSMGN2KROZzyUGcqg7DREPiJMqTuN/NahtHZtFVWFiwrfaMnumiozbjocd4EL9LqPBrn3dTclnc3WNwkkkI2T413+P09Y/vu0ZWP8zzVPcUoZrFqRd85CJT0C5TaPQ1udbVlPPvyD5JJI4xjuAuFr8+lp75UiE9Kd8JcheZKn0KjWbzfN9RCjKAb7gKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeX+2fdrpjOugp/vIMl68H+LI7jCjigkld9Vmo2D9WQ=;
 b=vBBvOJcNKcp4bW0VW8p3rU9e0GUFxnLI1FjCFdmE7g4SEPe8jhEWhrlZLJ2fE5e7u+jMCEouuYWzLNA65H3L2RJJq7207qCwXEz+IOJumJ4pOOqvAxA305Zz6gnjeGpBaELYr7//+ik220KbDKhzTkKWuwIPjvcCgL/mZitUhrdvVevGlSz2H83Tilu2LYliksv3YmmYWLyWg5IDf8k4AisJbHV6sVZOSfjh0rA2/U/a+HS3OC48tKWr/yE1nFiN3nPmY9qJSByKkSFxQpS/p7Vt0IFtWAcfr2UGpz5IuFRfJ8VOeb1MJ9zJhijE2FRYwXCoMzpzhXatkfunmT61+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeX+2fdrpjOugp/vIMl68H+LI7jCjigkld9Vmo2D9WQ=;
 b=TH73XsqZwwObeUtXJDCVK9q9az8qUaHAVT2owICEXZeGWTkW9Y4PKu6TYlakyHKOqc3cugaRybhq+T8kSzxLudVaAGL48zGeUT5JSYESq6IOe995SE1JHl7tW/Hqu0SkpV8EKitfuqzBN4gtTMgxXFyHya1jhiiG0cyxd77NVDo=
Received: from SJ0PR13CA0126.namprd13.prod.outlook.com (2603:10b6:a03:2c6::11)
 by CY5PR12MB6408.namprd12.prod.outlook.com (2603:10b6:930:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 20:16:37 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f8) by SJ0PR13CA0126.outlook.office365.com
 (2603:10b6:a03:2c6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 17 Sep 2024 20:16:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 20:16:37 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Sep
 2024 15:16:34 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO command
Date: Tue, 17 Sep 2024 20:16:25 +0000
Message-ID: <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1726602374.git.ashish.kalra@amd.com>
References: <cover.1726602374.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|CY5PR12MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f72041-6395-4d08-86c0-08dcd755a22a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FOz4JVAakgK9lVevjQFnNyLNmN+WB8zY6aw5cJL7UoED7B+qJ4xg8JF+UQJP?=
 =?us-ascii?Q?LwUwCw9mFCbBo7rjTBnn+kM1U/7NWMlPp/hGryQ55pQeqs53oASHgvvBdpKT?=
 =?us-ascii?Q?2MMIBb+44z9OvgTYUP25xRcRq+hypTEWXieQMQ7RUIra3B/macofdmt65pOF?=
 =?us-ascii?Q?2PtQyG39eCTna2FYKs0Zz+sZNdGFnZHscn6XrPSx0KldFu7AwOkid+SGYGq5?=
 =?us-ascii?Q?G/9xEdmGsZoQuZ2hbfDX2j/PDrO+94N75E8pMig7QpIlnoR3BJsggUgFn4NI?=
 =?us-ascii?Q?tibpZlIZ1gQRWV1KqsYmI8nPK0mxZsj681f6dKgDnB+TmYt5Uc4x65bRS9ai?=
 =?us-ascii?Q?1ndx0/dpd/V3tBPKrcMhMDHEX7agXJ52FNhlmHC4hZk01aypTRRE+ZRVdXll?=
 =?us-ascii?Q?y6PGMdcscHsDcjQSD25LQfi7DvkgOh0lfGRxmb6kpEuX8YFtYu4NPArOFk0F?=
 =?us-ascii?Q?gXUeiK36OOyGZj9HKRt4L7luRa6oyrZlFrszYV55yTQah07Q5+b6Aeq+2D/9?=
 =?us-ascii?Q?hm1Dv+KTjjL95dcoinunMNfJmIcpwNuzrILTDBxmw+1Cp+lFrpPiIPV83b9B?=
 =?us-ascii?Q?e5loJqikHcN5Kozby6aSwvgfguCqMeC87DSu/KohMiaVkZAMLmFGxOC7R1QR?=
 =?us-ascii?Q?2NovjEdda54CLmG6OseMcmfnhj7Ec/EXqS7TyepCBS7BiLzBXBJIysqgEFz3?=
 =?us-ascii?Q?N93XOAV31Ug+TQnld7NNUeYDcT7c31VvFuqhEqZJFzb5P+eRv1qVNIwrl/tP?=
 =?us-ascii?Q?u8G+d2fZ6PJiXHLtFTDx6ZdAi7gHWqxgUk9bBn/M1UjNqsJJNipF++wRquEG?=
 =?us-ascii?Q?l/E5f8U6vHXipEKM1Nc0wGJZnpgNvUYGx9dBjk48pINxq+7IoFsBfh4l7d5l?=
 =?us-ascii?Q?6MCCuZ53xu7CUSNwoJmtk+ya9uf/MFqAjZH0qeAwEx1LtDzsUOX4J4ecZUzE?=
 =?us-ascii?Q?4V084Cnod9e/Bxex9haTkg43jQjKyAdV9CY5vIr6qAKkeyC+lsngtcsErCHl?=
 =?us-ascii?Q?/YSxPWqsb1dvkf2upRtiNzJPLsVQyoKQBn6kpfrMTlYCdbMROdrXD06Ywr39?=
 =?us-ascii?Q?283o2wCV5I8NrkGHS7KuFk/zfzl+MHFR7kqgEUu3jZqjKDgkUNr4DuJDNgDL?=
 =?us-ascii?Q?smjCbpcx+ouTuUYOm7eSZWwqtSAhLMU/GNgHe2w98gq/WXLFyq1efvs6Oqt1?=
 =?us-ascii?Q?OvhbFM+wdaum4ejImlNCjD50hBfLPOLtztqSo4a3NWAPH51Diti2ttvLZxgb?=
 =?us-ascii?Q?KfxlZ8ZgA0gy9+3uu+5YcObUTCACjylvg7fe0rvvd7nwrbCJ6aLIoEaP7z93?=
 =?us-ascii?Q?pd7AVkzLpwYFuRjcOF1rBuurjVhHvC3jNG+MN4ohSAd/nRoyNaJfg8WFPeKf?=
 =?us-ascii?Q?UvuCPjTCofYPclFmKn9qBItbZs/8WwJNpJ4KPIcmJYCICtCBvh/7X6xkR3MY?=
 =?us-ascii?Q?HTwybXQ9SM3R4isEFQovtQjW3OGdlFXn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 20:16:37.0624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f72041-6395-4d08-86c0-08dcd755a22a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6408

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
index af018afd9cd7..564daf748293 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
 	default:				return 0;
 	}
 
@@ -1063,6 +1064,50 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
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
@@ -2415,6 +2460,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	snp_get_platform_data();
+
 	/* Initialize the platform */
 	args.probe = true;
 	rc = sev_platform_init(&args);
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
index 903ddfea8585..6068a89839e1 100644
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


