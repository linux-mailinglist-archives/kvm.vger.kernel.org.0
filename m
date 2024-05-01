Return-Path: <kvm+bounces-16318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D76A38B873D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EECD61C22F9B
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209E6502BB;
	Wed,  1 May 2024 09:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZWfrqQot"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94A1DFDE;
	Wed,  1 May 2024 09:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554399; cv=fail; b=Vzd6MBvs5pQ2TtVQ1Ge1mL2IwQ+sD/wpF8Xt5Am6ETXkQgPZBI7PLMrBRqVsLtWAVvuFOGDia0f+11RZ5CMURKN1LtqA+8Fyp1s79gDDBkfAq3Sv4qBvcgQ3GzTd2aC/mVsRmk/U9H++JaQ3j8zSAMHb/mmbocLXNw0uGGX9j7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554399; c=relaxed/simple;
	bh=T6pGJVRHlHSyXnXGrojJ2riNnafIVnvK+50POJ+c5gE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cRReEE0Ngtp+b03RML76AObeTy1CSi5k1P3ITPQSgBcbLZKtJpVZIygtDRbYZpKt1jZn0leSDlO0YTleUaQTWKF4gpDAG4rU56XukQZQtLYqVxgDIOXqcidfMTgrlVT/8WJY066BygaszX3aRXdLHdolwqVmLkO+gWDj7JlOvoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZWfrqQot; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoWItKzLSyXRbwSn9BAiAEdWY8VnHj8eR8uQo7ooP8lSWu8mGSi5ELVCvem00+n70P4yZgP00crHTmzmSZrjAtpXbZbR6X2ch0iX20pMQ+q6PxNeaO74CMy0kwwuvsqC+Jq1OfrjiL+BZMjXrzLik73l1PNf3Eirud7QpmNRbzM9dAmodpfW9b8ji3/ZgFDuhKGKwRGE3+Gqox4qu3axqepEUdKw7Pfycd0nbI/dCIa0lqCMHyrE/gOv73IxYmfzy/P31Hglat81mG3aHDmwjNk8EOJ5dcHSuSlbcrsgEDkxWe7xT+J1tQyzqtvbDimpz/7sPwDgyl9TtX5CGIajcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=QKvhXVUuWykmPTBrORprW6uUWNpuOHQrXqxHq3FshKWIMvaqHDihwREPAqM+HQVAjDdc7hQqqZek8/+t7HKiHvdv1dI/N9z2vlM8HRmOqyGrjbxn/rtojh/2GgP9ECSx7chGtVedvJ7xvgDcA5ro3A2qY/C/XdjwnL0zpfpscFSYY3398k+GmKbPkPOZjaDE2Khf93ATNkprMWGE7M0K5PQy5ISONCbTB0jM4yV3TxU6nC3C3YjO0ScgDgMO4WkzYtZXkSWD5VGWZahuNXUK/aCT4fRWYSYt7ufPeESc3TAGrYMn159bcsvJwmDOlVwP034uQ/GBxLuMRO6rScF7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=ZWfrqQotR8K7QKALU4IPm20pAJNXmSBYY+PZZJrAFA5JgG1ISmG+ms/QxeyxI5617sV2Jw4z13bah2LldhmdlgGyVdmVlhTfBY3zhvQZRALCIoPQtni2KAZGXbwcBuiq8JJyhYuQgNoPFo+xaVrySNW2XTPqGSn6yXXq+IfkeEo=
Received: from BN9PR03CA0663.namprd03.prod.outlook.com (2603:10b6:408:10e::8)
 by PH7PR12MB6419.namprd12.prod.outlook.com (2603:10b6:510:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 09:06:32 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::e8) by BN9PR03CA0663.outlook.office365.com
 (2603:10b6:408:10e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 09:06:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:06:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:06:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v15 20/20] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Wed, 1 May 2024 03:52:10 -0500
Message-ID: <20240501085210.2213060-21-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|PH7PR12MB6419:EE_
X-MS-Office365-Filtering-Correlation-Id: 27418ea7-e4c0-4af4-7100-08dc69bdfee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|376005|1800799015|7416005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AhLvACFJpGWAOMl2/I3fX8Pl48bF2v3L7Vb2lGg+0Qex0iMDTRgWOjPaXmiL?=
 =?us-ascii?Q?ZXRtBlKx5NVYpYaDpWpfjt2AuggQoUWlijxjoih5R6YDZmpcf5DOXmF6qhuO?=
 =?us-ascii?Q?hDm1IQsm3QagDUbPUoxInX3ubvaqT972vWj5rZmmsSZQtTph0w30m8slbI4w?=
 =?us-ascii?Q?ekK9YSsVqH/MhWnbBWwA2ZZJMB0XxeKV17gjegh0IvLVdequM5Mv6W0fk2Ps?=
 =?us-ascii?Q?Ke+FBGZlvA0uLheg1PYwDH41pSkA0oaQdN/cdH/+87cDFyxBiDQ0vYxRy6PI?=
 =?us-ascii?Q?QRs9Z2Cwv5e9qHUOCRFnDQkbpPOxhVbekhzQKDhaCbS49fOerh6j+2sOdDIF?=
 =?us-ascii?Q?y1crpPL4f1WP9TolA0P06B4FwftD1A1LdudJItYqMG4jph6CWsGf5mOb5T1f?=
 =?us-ascii?Q?CQzcwpJK3HiQ1I2alCL/6uvVKLuWIdoNfrQ4aYXY+bQfKzGs/NCuAiSJ82tP?=
 =?us-ascii?Q?jJrFHtoRRjJ4kUhfX8dh3Y5NqUElALhdxpaiWAsaNfZgePWFB1eWIMuwveia?=
 =?us-ascii?Q?NAppf2XRozjw4KsoIcW4S7LV6oEgiEibiyIeGVI3gGelusEs1dxY1+n9xWxH?=
 =?us-ascii?Q?SgLcalOcaXgLigXhCiUjeZJQHEqsYKJHF5ENYLz4tUkikoqjUTYuhNlO9Jcu?=
 =?us-ascii?Q?FyrNBMOLKgGEICuQI76LzOXPggG3ffWPC4vltEhJZtanbn8BTmdLspsYY9A3?=
 =?us-ascii?Q?Ei7p6R7loKbESbJW0a2LqbC7pynhlXTJmqUPk/o8ARgXIpFe4kqy+7f1GgCV?=
 =?us-ascii?Q?xu/CD9E4+bkVRb9Lf2/5kwDkAEnHyLy+ilLJi4++QiDVKKJ53ffOxd9/97aP?=
 =?us-ascii?Q?dfj9S3eNabvckgQEyMIEOAC/vwHDiuD2pEoGxU67coxi/CvZAu8QDVBzbLsJ?=
 =?us-ascii?Q?Aa0SRjchSoxaVAeZXdBddRDypEvIiM6YY6LeB5bBxGWwkLpyPom746LvSauD?=
 =?us-ascii?Q?w7Y4/1t6k80khbwHyBn9mZtvlXWHpac9P3Z/8lulbAwK34stayryaNppqX8y?=
 =?us-ascii?Q?m53+hUxi1jrL0tH5h6N+Nf9vUKqKjk825M7eyw5FakagEowBnrwgztAI6hMM?=
 =?us-ascii?Q?iPUivtKynZe8v/wnLbqTa0XvaTm/dGtVUk+AyDS/0B2tIs9hkJDw4gZkyDYN?=
 =?us-ascii?Q?MPLxf5GoptoA6vkJyOdrJR+mtqaqHak8rl1KC/oGRCEGN4uYivAqGpEIikTG?=
 =?us-ascii?Q?fZ5GbNKdWFWwy9rzeFAkMQUr+3gJXWXmJZBeOXsTtt2SzJQwPVElNUswSMUR?=
 =?us-ascii?Q?I9gmUqKvmMFdAU0a8Swm316mUZg9dPlzgDYyrrR4jhuBGVLoQL+tqZiZhk56?=
 =?us-ascii?Q?TbOQvzs6fGTZQAFmWQ2zyu7Y6akOkPEpdIxyL5jsEMO4Ozhu/g4u2kBRTD9e?=
 =?us-ascii?Q?wg8F76Jeg5yzIwpyjrm+ySnD5jgy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:06:32.5196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27418ea7-e4c0-4af4-7100-08dc69bdfee3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6419

When requesting an attestation report a guest is able to specify whether
it wants SNP firmware to sign the report using either a Versioned Chip
Endorsement Key (VCEK), which is derived from chip-unique secrets, or a
Versioned Loaded Endorsement Key (VLEK) which is obtained from an AMD
Key Derivation Service (KDS) and derived from seeds allocated to
enrolled cloud service providers (CSPs).

For VLEK keys, an SNP_VLEK_LOAD SNP firmware command is used to load
them into the system after obtaining them from the KDS. Add a
corresponding userspace interface so to allow the loading of VLEK keys
into the system.

See SEV-SNP Firmware ABI 1.54, SNP_VLEK_LOAD for more details.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 19 ++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 36 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          | 27 ++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index e1eaf6a830ce..de68d3a4b540 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -176,6 +176,25 @@ to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
 the firmware parameters affected by this command can be queried via
 SNP_PLATFORM_STATUS.
 
+2.7 SNP_VLEK_LOAD
+-----------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_user_data_snp_vlek_load
+:Returns (out): 0 on success, -negative on error
+
+When requesting an attestation report a guest is able to specify whether
+it wants SNP firmware to sign the report using either a Versioned Chip
+Endorsement Key (VCEK), which is derived from chip-unique secrets, or a
+Versioned Loaded Endorsement Key (VLEK) which is obtained from an AMD
+Key Derivation Service (KDS) and derived from seeds allocated to
+enrolled cloud service providers.
+
+In the case of VLEK keys, the SNP_VLEK_LOAD SNP command is used to load
+them into the system after obtaining them from the KDS, and corresponds
+closely to the SNP_VLEK_LOAD firmware command specified in the SEV-SNP
+spec.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2102377f727b..97a7959406ee 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2027,6 +2027,39 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
+static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_snp_vlek_load input;
+	void *blob;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
+		return -EFAULT;
+
+	if (input.len != sizeof(input) || input.vlek_wrapped_version != 0)
+		return -EINVAL;
+
+	blob = psp_copy_user_blob(input.vlek_wrapped_address,
+				  sizeof(struct sev_user_data_snp_wrapped_vlek_hashstick));
+	if (IS_ERR(blob))
+		return PTR_ERR(blob);
+
+	input.vlek_wrapped_address = __psp_pa(blob);
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+
+	kfree(blob);
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2087,6 +2120,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_SET_CONFIG:
 		ret = sev_ioctl_do_snp_set_config(&input, writable);
 		break;
+	case SNP_VLEK_LOAD:
+		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b7a2c2ee35b7..2289b7c76c59 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -31,6 +31,7 @@ enum {
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
+	SNP_VLEK_LOAD,
 
 	SEV_MAX,
 };
@@ -214,6 +215,32 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
 } __packed;
 
+/**
+ * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
+ * @rsvd: reserved
+ * @vlek_wrapped_address: address of a wrapped VLEK hashstick
+ *                        (struct sev_user_data_snp_wrapped_vlek_hashstick)
+ */
+struct sev_user_data_snp_vlek_load {
+	__u32 len;				/* In */
+	__u8 vlek_wrapped_version;		/* In */
+	__u8 rsvd[3];				/* In */
+	__u64 vlek_wrapped_address;		/* In */
+} __packed;
+
+/**
+ * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK data
+ *
+ * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmware ABI
+ *        1.54, SNP_VLEK_LOAD)
+ */
+struct sev_user_data_snp_wrapped_vlek_hashstick {
+	__u8 data[432];				/* In */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


