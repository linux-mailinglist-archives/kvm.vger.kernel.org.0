Return-Path: <kvm+bounces-52987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796DAB0C5F9
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DCAE7A98CB
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E2B2DC347;
	Mon, 21 Jul 2025 14:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x6nogqQh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C722DAFCF;
	Mon, 21 Jul 2025 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107212; cv=fail; b=AkKuQzmCqe8qhlsxjLuIlr/ia+QAVYLQo8/uqvkQ+MVsSMdmD7DeSP55FsiJOI4N1hlj4x7wrxpHqI/v4XSRH3cwNy4sMCjB3zVP2xJ763rgaCV3fFYLkz7vCebDd3kpr8Tt8HDnY552o2cHyO7FYuOODgd/jmjsyfmMqJgWC/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107212; c=relaxed/simple;
	bh=u9j8zcrFJCvAZrovAKYLpqJF1g4WHnAASyhzyZRS4ec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdVRV8/U9ntG6VSdv4/y7UhEdei1cOseDqIWR6RlqB9wuAEZfh5cHqmLqX2AFzuyujcXz1s1PlDyVzKexmk0S+k3yvFp4aRtpcJed/Z+/yLT5J8uwbmIPZLtQxUqNUvGNabBaahE5toUN2JJnJilkl6+bEPKYR2DktQNKcBEkV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x6nogqQh; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MoKchq/ZK+x10xPaS/waQ2R/VLvesgIK929sf+Zq2edD2SU6XFTukbp16XFiuEZkdhR7tyys6y9iqeeNxH9YdBtw31k7mKDoIO2c/j6lkyh5xSiL7KwL/XqfXpeAafdbdfLz/DEPNaALxInRWTbS28RcbynGJvqtcKl67QKYSJRhIQPtnkgeu1eqwcBlcB/DZY8acME8+7lyrgrzLzllvxG/Cu1aAsCy0TSQODPllKZYDSqUWTHi0V/QCNCK1BhEy/yTGUdkjoH9pTemRg5M7ovymS7+bDJsqmt0RWEPumQ44bz+dKi9AK9gA3uOw+iHX4Q3lXCAXsrknDcED7PBHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paU5LM884N+tcr1ogK/o9kSQyhITFtV0l4D7Fm5iRR0=;
 b=IYCSc1m+OKgrAIYE81lVgyJ2B07/R8xnADql4n4pTfI8jcBgc1n1VGS0Ya3rbrCYdt85NghU7lK2Ufj9mqpUAkzAXnM9iGGJFBNuTwUhpKuGXla26n2ZuUQnSNhoaB9bRx/zTv9IAogvK9DpLPmb/NlBggrxb4s6eKJCLbQedO2ldeH68pA0H0SgeOJzyGtsqcvtEMBx94a/RNoAhcUjyI9IrMbrJ6y5Z5SHM8dqRuQuQNeRWzSly5L8ydOXGQ3cPU9/pqOdrGyj5zLjB5daOwKEQj5MIkTSsugd6iQw+sfTR3c3aDDQHy7KUF7Dj+NhVOp4VREtgRFOG9ZldIPr9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paU5LM884N+tcr1ogK/o9kSQyhITFtV0l4D7Fm5iRR0=;
 b=x6nogqQhqtqGjQnJgspDZ27pl/td+VMGbMERV7EyrpgG211EkyEWOmy73uh6Q8sacdKTmOk8d7z54TcG7xDKgLrTGGwJL6o7gAX+DWmjgTU/45/RrYbm6k1oA4NKcbmLhNWKm7n9swbK7Z2U2uShcgGF0r3R60U42sol/SU39JI=
Received: from SJ0PR05CA0165.namprd05.prod.outlook.com (2603:10b6:a03:339::20)
 by DM4PR12MB6255.namprd12.prod.outlook.com (2603:10b6:8:a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:13:24 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:339:cafe::a7) by SJ0PR05CA0165.outlook.office365.com
 (2603:10b6:a03:339::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Mon,
 21 Jul 2025 14:13:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:13:23 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:13:21 -0500
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
Subject: [PATCH v7 3/7] crypto: ccp - Add support for SNP_FEATURE_INFO command
Date: Mon, 21 Jul 2025 14:13:10 +0000
Message-ID: <8b4a6d2b6fbb1c31f994fe137f79dec1cbc9d0c9.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DM4PR12MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7c0922-5ce3-42e3-2c66-08ddc860c0fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bxCJjbDy5/cgQu+CkcrrXESSW60q+74SxRl6kmc92GiOISv7SshYVCXPxMW5?=
 =?us-ascii?Q?gm5le+Mpq/+qSS8Mcx8h+y99sjx/r/CQgCuAFY8qqyQTkClNsMFWYYFvD4x1?=
 =?us-ascii?Q?qFimek5KQv/AEmJG0W/SZ6k38Vz+ITmH3wNeWK6bYJVyWMY4xOHsKrOYk1UR?=
 =?us-ascii?Q?ocSM4eXaMYBiqQ20tufNJd1xTFzblqCofDvf90hUJbUmNiW2QEZGgieMOe4v?=
 =?us-ascii?Q?Mz3OBH1pmH9rtazT1svJWBaO6DB2k3Z8YKqknXUIgcI+X2ZXx1LH3UDmrCYP?=
 =?us-ascii?Q?vqUpknzk8m98oXdRiyazkkymCV5ByFsbhUzpMs2LerHCUFuTQaUdJ+muJexc?=
 =?us-ascii?Q?vPO/Uda/q9MPIXddUgj6LJeJg5712JjBi4nsvgFCJkjkZoTEwYYDtjlLvLlA?=
 =?us-ascii?Q?ZxyQEXfRFcL6iDluK44KFagK8I2KZih6i7PcATsQg6I6eI5xqtMxmi1YW/EV?=
 =?us-ascii?Q?0RCI+n6bdqy9HevSv/sb+hUDSQs1L2E7QH8mduJvweK34DypqeIVtsHjhYMQ?=
 =?us-ascii?Q?cowYMApFlcn2AW0OCyO9n5Df89P+mJ+rLxuopmzQ+chP1wrcLonW3TmtBOzv?=
 =?us-ascii?Q?2y7mair+jXoFU8LFOo5tlV0BDQUx+/sFlGISIA3jksSzCDgOam6jeog7lKVo?=
 =?us-ascii?Q?PPnta4hO2sqKcwmI7ub7WuiYCZu+bkSoOpceHwsRx8hJ0ajo+/oQhe1lsRXN?=
 =?us-ascii?Q?uwif1+EUzxgDlcF8E7nuij8Kmr9EbZCFVGAert0MPxYyAJzoTnoqYKaiNuzO?=
 =?us-ascii?Q?fL6cBI83QtX94qUg5mq1UqLWKcMCsdo2Ij4hrA3RHYf8n34rM7eNz9AqtZGH?=
 =?us-ascii?Q?8yA12QmP5oFUmbhFZqXbCzxDGo28umFMFVQ0SvTW14EQgUIU4VTAF/EvNsER?=
 =?us-ascii?Q?Q0WAjPPtCdMbvLv7wTDwGOoq3hOVHiZ2f2D/6Qmcp7yCoqirUhK7+sh6Wue8?=
 =?us-ascii?Q?YrWAgMfZ+Xf9rgoyt3fs9SgIepPH+7z4k/16c3BkhoowzQhFcL55ihKJEyji?=
 =?us-ascii?Q?iSEi9URy6cyhq3EUtVJdPWoZG9JpgnlaBJ7upSc0GcEhHsJgtgxF+C78eTfe?=
 =?us-ascii?Q?TG2Avmj3zdip6KXja0bU89qr65yp6MnGTcP9oxSSmGRfXQ1uGKnVhe4X2q6L?=
 =?us-ascii?Q?juOhvENJ8yLQH/Q5XoN135Nn04ZRpWTDau/wRgvi/RzdRbh4JUckBhFSUfVM?=
 =?us-ascii?Q?zuRv2Sp+bZBzP2xOoEAixgN57DvBOCv/Y4VWfkfoQcdi6VGUtK8zrjUqSx+6?=
 =?us-ascii?Q?/+kXq+XjU4xL4uclS6P+tWuTZPoTgmB71wW362Rs9MHD4+E2V56X69uVAbKl?=
 =?us-ascii?Q?xDtgWHONoCrtosVf34r278Hva/ghnw8lar+mlcDeD7o8e0LrU3Lv+1H5OAqY?=
 =?us-ascii?Q?c3rgzIlMxAwcnNpf9PFNGRt60H70H0LhsPCx5rVu2iew+zJ0OdhQe0o5LHRy?=
 =?us-ascii?Q?hO9K28rs1spZn/E7rAv+Zqm2tQ9Hs8uFk+sxZz6/oTGnS9uKhnlxYHJF6kzq?=
 =?us-ascii?Q?8mUJxOOErDLKMgyfuvn7zRKX2veQCjj1XYlPM+aDE1a2q/Msqay17UMUOg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:13:23.5378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7c0922-5ce3-42e3-2c66-08ddc860c0fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6255

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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 72 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 29 +++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 528013be1c0a..a3941254d61f 100644
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
+	 * This function is expected to be called before SNP is
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


