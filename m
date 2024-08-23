Return-Path: <kvm+bounces-24903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3B595CDCC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 006C11F21EEF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C979186E58;
	Fri, 23 Aug 2024 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m9RS1VGY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CD186601;
	Fri, 23 Aug 2024 13:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419754; cv=fail; b=bq5l5cqMCaATclDIkSNgsqJ7xNTp1thHdDxRvqLHE7QjDsKWzT54xfK5mM7FVgosmhC23YRmPAKOYQNW+C8VtPIJ+jLRTdO7unI3Z3MkwmvDVt/vjh+jc9TqcZfxypN/JfbIBLjRTY4ScHfpT5rHKpgf5PinpG7gFPZlwurVmYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419754; c=relaxed/simple;
	bh=XZwg+pWtUWIjRj+l4+xAVQ1DTfFU/OVF6TkqbWYmH00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRzNMfOHLMCJ/NKVQXTnZhGGiPD7lL7vR600MmWs5TX+MCT5YK0obqgwfDoN9hxCsds/RDPOIuqlVQJdiwNixJaEnGf56c/NvOuKbJHJCd4X19NejAwia4VJ7bJLHBrwjUxwKOjkXmMm8osK/9CRmfp1BwM/Iyc8LNHOvZUDzDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m9RS1VGY; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVYC6Q+hGLYDMoewSdp2v+RtYC31twN1XDMC9pMbakH4hb9YmdqbsaqjOMjotnZFZScbzwUkPXE4kmkE1Rk8X48J0JZDCxE11NTvkMRBJ06I/xcrxlh3F+rRmzRk8bIg6jmIc9q1XO0XeiHL/dTF7h7cG43x1tJEcnIvA+t8XMUUBrxdTB9cXR25yZEicNgMANADFEKBbfjaDMjkt7eNNL+Zq2UA8QEdSK+urP4TdPGuV9ZiCwWB1+ppjIfj09PxB/u2tMWKPDcCYU05fu84rFk1uoA8A50LbhBl0n2sCB8cn1UiyQAV4BDYUWK12QQB6DrsqLEGYWx2sUcplLjojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGkXFzZ8jaJKxMht/c7C4G/4z0BV8248LV2V3Z1yLto=;
 b=vNr13Tfn6COXlOtu0v4N6v/DpUqyeDgEFHgu+B9KCX/4f5qoRuD/5UPZLDcRNlzrwNqCiGe4pSWERJY+YzQpZsRkc5ko/9CJXUt9naMy6F9yUo8xaTtJA/zK2hSc0Za2Bod42p2yV6nfnYnKYl36s2pDxdqn1t/QtAokEiE1zmI/E6s5etW9tBSpNKMyQrf7sUqMQJr+fWhbuoUbtAnprlqWb6G/kev3lSPHNo9KDZAad7mA8bz96GrWXs+63rATYu5aq/6dGTsDmp5BV7GKcWPr789VHw2pc9TfHWvQShxnt0IJZiE4O05lAwpkF14wDKOZb/E7w5qOiERa5eoh5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGkXFzZ8jaJKxMht/c7C4G/4z0BV8248LV2V3Z1yLto=;
 b=m9RS1VGYyRd2qyLnqPZx1zm7Q+ZO462icbYrfhXVWrD37EoyvR3/f7MUPC5PplB3TWXLY5na4bXtO15H22dpm/dmM30eEfUScV8Xop8WQmGt80VmZCuHTqzI363jtqxCJc3kEAP4NZMU7Gj5ZKWpr+yNfc3cKOBqNHNnTD4T114=
Received: from DM6PR21CA0023.namprd21.prod.outlook.com (2603:10b6:5:174::33)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:29:04 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:174:cafe::c) by DM6PR21CA0023.outlook.office365.com
 (2603:10b6:5:174::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.9 via Frontend
 Transport; Fri, 23 Aug 2024 13:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:29:04 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:28:59 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 06/21] crypto: ccp: Enable SEV-TIO feature in the PSP when supported
Date: Fri, 23 Aug 2024 23:21:20 +1000
Message-ID: <20240823132137.336874-7-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: e389ab2e-841b-46ae-8c9e-08dcc3778f10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iRM3oeqaDtBr8N7h53sRx8IvQnQ+goeWnxLzuV4md5dCkqQnb1xdaxwtmrCF?=
 =?us-ascii?Q?LKZ6nO9uZlbal6lnhHv6iFI7ppsiufuJOe641x5Cfz6HLJ/SDcDP4AsEIsLS?=
 =?us-ascii?Q?JuF+BcffFSsV+iWWm2fu5MGpAdpOHv0twHiBA18gXipU9hJOtE7ZXiFmziYJ?=
 =?us-ascii?Q?lfEHjrxFGoX9TH6EDPfQksde08gm9Itj1YelyGztDXvpRrTjBRFG013yNbeQ?=
 =?us-ascii?Q?R98UYjCYUgynRxqt21LmFj7k0EXu/EqUsy4yR2TW07nk8pbC6ffD3wKsBxNZ?=
 =?us-ascii?Q?KfqlqwXLRFK8MQSkOR43rWlEq/yjBsh+qdK0vlI0sSXacd72AIwjXItrrjxs?=
 =?us-ascii?Q?seNd4u+pxWplvJV5GrNpz/zeIfg2YCI3DmziBOsCO8ZxehdcPAoaB/8kdIpY?=
 =?us-ascii?Q?VB6Pqy0nVtiOTVyrdgxnJ8JGjlx36ebnSrsLSRtL6t2I7fNua0aeFkHePOzI?=
 =?us-ascii?Q?qbV/WpIKq5W9SwZBFry9ndvon7LqGovDlHx7MxiWrDrPA8Hq3pIv4QnC+d9U?=
 =?us-ascii?Q?L/uWEtFjGZQIfCTNQjjAD0vQ497VXQ3/2N1/dEqtO4pSP+9qz385j0He52d2?=
 =?us-ascii?Q?3F/PoYkUFEccSRBHa4dcXktcRAINJIPSc6l9D/ceehadCeMcbBzZEhkQNMSN?=
 =?us-ascii?Q?HtDxIHa3xHEnjK5RDMl2BE6uHLRY/buxHTWEP6TE8bpGa4hEqzP9EJQ/WT7Z?=
 =?us-ascii?Q?yeRuTVD2Mdx+c3c9NoWZL7vZvYUALFDjUHcIP2mojDAkYRULBdzK4V1t+Y3s?=
 =?us-ascii?Q?Lh5YEqRE8y/p32fmyz+yQZ2PxeeOUyqAfYwVRv4HijlDWOOWnLzesu9eQtGa?=
 =?us-ascii?Q?mXy0p61EBCq1a4MWofRLHyWXYywSRi9vkjUyG8f0pRGX0vWYegbLQfCeAHSf?=
 =?us-ascii?Q?C6iY6iktk3tjLfXWvxvCTxaKnBrWbguQpUWMPKpHrS9CnohgoTTsTzEGURUK?=
 =?us-ascii?Q?/BmzizAbO1kt7bReNqJfew/2qOxyf3fH+3S5ZMSy5YCI4lPg5JZ4jqVMUNvi?=
 =?us-ascii?Q?7c9wjMbyK94oYhx/s84oy/31iIBRBfNHXe/kEhlqxgnsFs2u69uWELyGdIoK?=
 =?us-ascii?Q?NylxfzFrUZWIUp0hnHMnhoqwuXEAozXJgEDWvS+yeMhm5BgbFDzKBtKEH1fs?=
 =?us-ascii?Q?dwle7ytAUZZUU1V8ASqmDJx7gsq9UHs1RcRuHfcLMZg9fGv9714ZuVoeoaTU?=
 =?us-ascii?Q?Rb3YlH4z89Y/3RNIHL6GFvojioVLZolMujlsdEkI/ydb1ltGtmtVz43oYNI2?=
 =?us-ascii?Q?/Ne0bZvTKV9U4npkTjdMypHyKy1qqD2gn2+opCCBBgsJWDhhY54jIwoeHubY?=
 =?us-ascii?Q?JCcYbupAXgCteT4odFe5wZGROfjrwf+doH5/Mb4zMz9/qW2jZePrwfhFeTJS?=
 =?us-ascii?Q?zM5hi1Ta8+GklUjlOyf7O0TbAMEktHnGO/eD/52CMERXSAOxIo4eVW6JFafV?=
 =?us-ascii?Q?1WoLVrl3C6fuwwojb0yroSvhKoQ/UUsG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:29:04.7425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e389ab2e-841b-46ae-8c9e-08dcc3778f10
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

The PSP advertises the SEV-TIO support via the FEATURE_INFO command
support of which is advertised via SNP_PLATFORM_STATUS.

Add FEATURE_INFO and use it to detect the TIO support in the PSP.
If present, enable TIO in the SNP_INIT_EX call.

While at this, add new bits to sev_data_snp_init_ex() from SEV-SNP 1.55.

Note that this tests the PSP firmware support but not if the feature
is enabled in the BIOS.

While at this, add new sev_data_snp_shutdown_ex::x86_snp_shutdown

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/psp-sev.h      | 31 ++++++++-
 include/uapi/linux/psp-sev.h |  4 +-
 drivers/crypto/ccp/sev-dev.c | 73 ++++++++++++++++++++
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 52d5ee101d3a..1d63044f66be 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -107,6 +107,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
 	SEV_CMD_SNP_COMMIT		= 0x0CB,
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
 	SEV_CMD_MAX,
 };
@@ -584,6 +585,25 @@ struct sev_data_snp_addr {
 	u64 address;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_feature_info - SEV_CMD_SNP_FEATURE_INFO command params
+ *
+ * @len: length of this struct
+ * @ecx_in: subfunction index of CPUID Fn8000_0024
+ * @feature_info_paddr: physical address of a page with sev_snp_feature_info
+ */
+#define SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO	1
+
+struct sev_snp_feature_info {
+	u32 eax, ebx, ecx, edx;			/* Out */
+} __packed;
+
+struct sev_data_snp_feature_info {
+	u32 length;				/* In */
+	u32 ecx_in;				/* In */
+	u64 feature_info_paddr;			/* In */
+} __packed;
+
 /**
  * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
  *
@@ -745,10 +765,14 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 tio_en:1;
+	u32 rsvd:27;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
@@ -787,7 +811,8 @@ struct sev_data_range_list {
 struct sev_data_snp_shutdown_ex {
 	u32 len;
 	u32 iommu_snp_shutdown:1;
-	u32 rsvd1:31;
+	u32 x86_snp_shutdown:1;
+	u32 rsvd1:30;
 } __packed;
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 7d2e10e3cdd5..28ee2a03c2b9 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -214,6 +214,7 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: Indicates that the SNP_FEATURE_INFO command is available
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -229,7 +230,8 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rsvd1:28;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f6eafde584d9..a49fe54b8dd8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	default:				return 0;
 	}
 
@@ -1125,6 +1126,77 @@ static int snp_platform_status_locked(struct sev_device *sev,
 	return ret;
 }
 
+static int snp_feature_info_locked(struct sev_device *sev, u32 ecx,
+				   struct sev_snp_feature_info *fi, int *psp_ret)
+{
+	struct sev_data_snp_feature_info buf = {
+		.length = sizeof(buf),
+		.ecx_in = ecx,
+	};
+	struct page *status_page;
+	void *data;
+	int ret;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+
+	if (sev->snp_initialized && rmp_mark_pages_firmware(__pa(data), 1, true)) {
+		ret = -EFAULT;
+		goto cleanup;
+	}
+
+	buf.feature_info_paddr = __psp_pa(data);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &buf, psp_ret);
+
+	if (sev->snp_initialized && snp_reclaim_pages(__pa(data), 1, true))
+		ret = -EFAULT;
+
+	if (!ret)
+		memcpy(fi, data, sizeof(*fi));
+
+cleanup:
+	__free_pages(status_page, 0);
+	return ret;
+}
+
+static int snp_get_feature_info(struct sev_device *sev, u32 ecx, struct sev_snp_feature_info *fi)
+{
+	struct sev_user_data_snp_status status = { 0 };
+	int psp_ret = 0, ret;
+
+	ret = snp_platform_status_locked(sev, &status, &psp_ret);
+	if (ret)
+		return ret;
+	if (ret != SEV_RET_SUCCESS)
+		return -EFAULT;
+	if (!status.feature_info)
+		return -ENOENT;
+
+	ret = snp_feature_info_locked(sev, ecx, fi, &psp_ret);
+	if (ret)
+		return ret;
+	if (ret != SEV_RET_SUCCESS)
+		return -EFAULT;
+
+	return 0;
+}
+
+static bool sev_tio_present(struct sev_device *sev)
+{
+	struct sev_snp_feature_info fi = { 0 };
+	bool present;
+
+	if (snp_get_feature_info(sev, 0, &fi))
+		return false;
+
+	present = (fi.ebx & SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO) != 0;
+	dev_info(sev->dev, "SEV-TIO support is %s\n", present ? "present" : "not present");
+	return present;
+}
+
 static int __sev_snp_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
@@ -1189,6 +1261,7 @@ static int __sev_snp_init_locked(int *error)
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
+		data.tio_en = sev_tio_present(sev);
 		cmd = SEV_CMD_SNP_INIT_EX;
 	} else {
 		cmd = SEV_CMD_SNP_INIT;
-- 
2.45.2


