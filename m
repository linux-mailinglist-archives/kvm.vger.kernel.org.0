Return-Path: <kvm+bounces-15438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0633C8AC08E
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C991F2111D
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941663D0D0;
	Sun, 21 Apr 2024 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mb3W0eKX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1653AC34;
	Sun, 21 Apr 2024 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722863; cv=fail; b=MeyVz8NbLniqAnTIKYHeYq0EOX+XkOSTaeUHgA98K4WBTnxk7mJpOCS6JbOZXjjW1Rkkj0Tr7d2PoijStffnnLFfikF/59AMqjbUWkyfYAY36q7/Mv7COgWmx/nn1NV7GrzDNfJYGYAIvf5w98/8MpJ1MR2zZpRTBjsa/+/Sv8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722863; c=relaxed/simple;
	bh=T6pGJVRHlHSyXnXGrojJ2riNnafIVnvK+50POJ+c5gE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adfi8PTtbfOBjB9pr+0WQJHbSPeI9baz2XblME/79PnYALmWSRIJxfwB3V4IWo6VppE9Rnua1bL15qvxW2ExAKGEk5jCvjXw2Or3ojwJhGZ2dLPV92R6IFSQBPzakhZMzOvtzpiffCD8jAANerEeQ7gjRWGQy5epH6R8aC6ufA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mb3W0eKX; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZ5QCOCBcK3z9KYe3JMshEvWDt0rrAJi01FcQDKk8ODiYX4aNjV3Gj3vH07NA8wd4jZZH8voHxTcmErkrtH3j0T6uNPzAWTR+0oDmbmtKvdehjJbsEwHEcfRG6GdTSbOR71B1QsVPBtbJQNROIEaayi9x4nEfFXLPj/hXKcKMTgNj4Rw9IQsj2bGrg+bF1QFsJ/rKNuy0+rnvGl7GgthfKl+mcIwXuQ458JUn0S4H8JYLUqojdxdl66PePO1sxF6Pufk/4dvYRIL9upKBZwaoYQgu+pPmYV6TRxGVoZ4GrQMsushtks+nTUqFpzqQ9oCEfUk5fQbMSbanj9dMjFNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=VB5n1xg0eHbkaCfTWyIJCyNnb+EgdAirW0lwfTf31j5TXxzgwUfP6GV8RteiMLnT5npHOQliHwwzMRPGxZVcIsH4hW1H100Me5bFiabViUFEZtAO3fQNBsIjB2NvrGj+zzXrWhXZjhoWGVSwN8Nc3qGx+wycTfpeI2zKt8ycGTYPDUXn2aJ3iANiGpZ8GA1zpq5TVaoYmGsXyIWYNlmHxcsIa0fELiY/i2TQvtLgYBZMfotb8a114lttNtsX3ObDoYXlgeJcofgDQCKkRZU2LtlXQUPth2qTrzM34WA7ljSzO1WFENyVkIBICjLQs9lj1SWSvWPR/jwnQNQg2+iaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=mb3W0eKXkT/S98/8IaV2rxOQLY0uumunVbCGB7VdrkhMuBJmpMzxBvqEMQz3+GfJ+u1ilU8ebVJqhJzoQQB33OmZOjCOPBNRLmrII0GU+mP4IfstPQIQWZ+Iq3FZUoyU7vOBwF36Prttsm8dFWHh/XeNvrJ1JC3qOppb0EV1n/8=
Received: from MN2PR03CA0026.namprd03.prod.outlook.com (2603:10b6:208:23a::31)
 by CH3PR12MB9395.namprd12.prod.outlook.com (2603:10b6:610:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:07:38 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::ef) by MN2PR03CA0026.outlook.office365.com
 (2603:10b6:208:23a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:07:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:07:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:07:37 -0500
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
Subject: [PATCH v14 20/22] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Sun, 21 Apr 2024 13:01:20 -0500
Message-ID: <20240421180122.1650812-21-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|CH3PR12MB9395:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f34b018-8ef8-46eb-b7f3-08dc622dedb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M8A9gaA4D+sYw2B+QfIxPu22rbdC38dppteFptNvVjqzyxvDJecploCuZIuj?=
 =?us-ascii?Q?a3XNjTKgF7UodbpCCD1atlPw4b8YHzeWll4UFkxuMnyqdlsT1gqu03gYLsg4?=
 =?us-ascii?Q?sduvEruOqyzbMEX8gGXzjHO9zxxhiGhGTCYyzLFNcCrrW+SwydYZruOn+AaG?=
 =?us-ascii?Q?g9SHe8IPQBaQ71EsTkBFNJD4IoMLnJNfzU0easXkUxi+36BhYU4UKueeDpKU?=
 =?us-ascii?Q?Jo+O93l8MAX0xuLjWlhtRbVSOhtcfZwNTnpIgQSyTTjnW84oA3VcP70sGTzF?=
 =?us-ascii?Q?5skyeVaBXN3P1JkYHRpYpQBd+m2lOG60dRVawpa0Zv3QAFRvho5dYATM14bq?=
 =?us-ascii?Q?HoX9UocHTi2UYBdLcDdv2lxyWfvtxGMMjSdcWUdZ8NhX/k07NkAicO1sM+mJ?=
 =?us-ascii?Q?90Wv5D+P74GP7+q2tC/CG9XmkMyeWNL4vPWsjaLyvK4kdgU+rSI5BaU6k/k2?=
 =?us-ascii?Q?3Y2B6JRaWAmRc90FJvfVB8j1lJpVWmeHTPAHhRGl60eIYKLlxsu+EZvL09gy?=
 =?us-ascii?Q?rXmki8q0UBQYREZZ1/ktxKt/+r0YRdOmglZrlknhUJIijC85daupPVEYxhiL?=
 =?us-ascii?Q?kdGd0JBwc1IhC0r8X8E7eq6uaVb9hMhYYwHVo3zTvacg/6jhE9Rz2cYzeZTy?=
 =?us-ascii?Q?3E8Qpnb0E7xX+04V/QZ7rX/tSWZ5ZwObgjYxqwsgjhZSxJ3GcuoukcTkC9vc?=
 =?us-ascii?Q?lUPemN+dLYXW/d54IrGWp7VeracWWBJ+xvw+//aVh9o4Nh0s+yTokeB1Elcx?=
 =?us-ascii?Q?GpmaX+u+W5PaTT+KAP2URurIbxvkE/SRfCPAKoL/WRbyTqJXzdCFPmRd1+jB?=
 =?us-ascii?Q?4wTJxnI79d9iohV6qdok7AYUw85LLrWXIFrLU2A1m8zemWX0zAHaT0e+rAFe?=
 =?us-ascii?Q?b39vFGO3wVQNeJkjO2JTLQc1/x2blieAbO4idAKgAwnQgdtJNily8990M08z?=
 =?us-ascii?Q?AQ2viap/gcL/5OkMGGuHlcv65tMs3tRypDjAWrqTQEOIcSYfoOCPZPLhGvKa?=
 =?us-ascii?Q?h2qSp7HXok6EMEssAPqkTrIut4/sRBh+uoDqHS3Fgzvi46AezR5cb6Irhkw2?=
 =?us-ascii?Q?kdmVfReLB5XRV+Dxjfngkysjr1+aNXYzgswFrNKzwqE+PVzIs1KerMvwfLIj?=
 =?us-ascii?Q?Q/nSwU2ig1wQ16DzTv7wCqgnHu23v+sqSuN8bRPx8ZdSSJCm49b8ofQUs2+A?=
 =?us-ascii?Q?1nTK20AMdSrXBHEsC4pWa3sYZvJXasMZQJmkv5m+kt3GYlFOQa0XV2WZ2pFM?=
 =?us-ascii?Q?VikpPwUUd0pDpEky0Prf0Ghpi9iIavLfmFZUF3pgEIZAsTT7nedz5T88HKDR?=
 =?us-ascii?Q?Cr+VjYy3PVXFk4ZlkEk/u3kpeRTFFwLhlKx7kDEsddah0fA15QaL9lUdh30C?=
 =?us-ascii?Q?P2ZIqnDd1fd//4BFEji9ipSWJfE/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:07:38.0196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f34b018-8ef8-46eb-b7f3-08dc622dedb1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9395

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


