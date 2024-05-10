Return-Path: <kvm+bounces-17223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F35728C2BBC
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B0FC1F26B09
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEA813BC33;
	Fri, 10 May 2024 21:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cwhSQxC2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFF213B5A6;
	Fri, 10 May 2024 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376045; cv=fail; b=kOQYY+jKeq6tN3QLMJ9kLF15mOznYu36H9T5uXPBJSA3Aba4PkegrFzcEgqnUnX9W+iDeJxkYg00Fxfh4hs1oHbYGWAosFUpZp+1E/AfynJ1xsaz25i9D9VhKmIQOQRuz2QpDYtOAZ4VTrcDBnuXNg/jlpP0Rb+yJVPh4yW9ktU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376045; c=relaxed/simple;
	bh=QAl8gOPZsQShplxaz0eaDzsWSDH7XmZwbTb8q2vOg24=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkZziiypvpu6Nfih1cESpyD9GAhBWSAiOIL/C8B01vs3U2VG+OPHeh90HlACAIaBWytb4aOk1MxPXejcCcVvx0VBsKUqAZqGp8R3ZFBsI6wkcZCcizUEQGBfNlUWkeTYmtPYp+V09MCdphc2HzleAoaIMOPUlEwBf+FvuaLFDTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cwhSQxC2; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhVqqTzHAbmel2ThuxmxmnBb71Q8B5PuHI6xC8apFE2fj0JHEMlMLLVRm131TRYtb5JwJaRZvpwVQn53OVjdXMPRmac1cNV9/zQBXeKAaIrMXK7iOoSwcYIbyipyi7Tp62gVJEwasqJKRvCbekoHtSxb4r+f/eo6KobFnlbu5+5U88sWsdMgPdtRCWC65E6JPoBiZk/SmUxIlTl31KRJ/G8q6PTE9C5sEaaZG1D+ipSGXhFerIFG0Vykzw0tFIimn9tcDQHKODJZbMLma5KTq1RHb2AZ3EgDu6Lg3+yGcI0HekkPPvRCxHwry4+cNIBvuk8IrRvxUvQSP9xlDrnhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIMg7qa9m2Dc9naTEuqUQU5elOqtpvpKiHA3BPPrdY8=;
 b=aukKPq2tRStFz9kyF2RPj6pcWL+7F0O+nTbVb6L3MVrSDVdTjYslcjDbEilGPtQ/iDQeWw80OTdaGBIKpD3yUcs0GntBG61izTJlcUTRANnQyAXk7xMH2eO/C2Cj0Y+kVBmy0ZEzcPe6SZ07yQ0uXZ4qeGfjWEpepw7o+Xr0xQ94NNY8WLDyKvC2kZ4nrundQFGDQ9eornkhkcyMuiaKInKQftfqZYMqWz/4mULRa0RMWnM6jOLB7A/ZChHcdjDI+XNbsrE7nZcgrtEsQRcTzAdUWjl/6A6/FTKA96NYpjjFkbCLQGIk8zULtRIQJX+USQ4MgVxxmpMPi/NqV1O4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIMg7qa9m2Dc9naTEuqUQU5elOqtpvpKiHA3BPPrdY8=;
 b=cwhSQxC2aRhqdyfTw3srTcH5BSrL29A25d9EoXDoecMnPRAY8o+ivr7hVoRt/8bx9nMWwGnVqh5++iMRzKJ+2J/NzDOKPMr+7YC1SaHWd5eXvRWDcxcWkvJDiSpY+rHQDNQHZfKdKYBBG6wLSl+Of/RRT3NGtnEzalGmtFRw4JA=
Received: from BN9PR03CA0080.namprd03.prod.outlook.com (2603:10b6:408:fc::25)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Fri, 10 May
 2024 21:20:32 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::2f) by BN9PR03CA0080.outlook.office365.com
 (2603:10b6:408:fc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 21:20:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:20:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:20:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PULL 19/19] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Fri, 10 May 2024 16:10:24 -0500
Message-ID: <20240510211024.556136-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: aab848e9-2ffe-48f2-7530-08dc71370660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iw/HmcLXimbimK5dCeCwPtUEAn9jsfXTsdplwgLRpdOyfLIO3JF1OH0A58nG?=
 =?us-ascii?Q?aJdXHbrExEXFzdY2oZg8oKnquvkUfubnjFbjBKCqJSuZpyHIcyI6eR2IoxgD?=
 =?us-ascii?Q?t37b3ROzglXkLOPYU9POX69GIrq3CriBhbbdjXF8QzHCQ2D+XASYnculv/2Z?=
 =?us-ascii?Q?+IDjAzPYy8ocKb4JBBg5xQm9cMOjhvsAwWsdVWdEDyAROmh0AmCHZPoSvcxH?=
 =?us-ascii?Q?PVaEWGV5Mvi5Xkl6MinqdGz0EY6cF42ipfAscQtSxo/6GGIlvDLPXEiOCN0+?=
 =?us-ascii?Q?AL9Ne/Um8iNiH2URQCRjJveKitUR52UnQLcsJHWfqzRkJDT9XopdBEqMGjWQ?=
 =?us-ascii?Q?lutSuI/dItDRmW03ZMCb7rjVUlMmYvISY6cyX1DW7RILLWq/vpQxS5y7esWC?=
 =?us-ascii?Q?qPsaN7iOg6X1GOBKOKwrQW1P4SY8EKyqooES8OU2G6wtzEUOPH2eXelWjtD3?=
 =?us-ascii?Q?T1xQCUBG9bgInqoF/ABPcqE5TwhvPB/t2EIi/cvuvJgI9OAsFIRYEjVdYY0C?=
 =?us-ascii?Q?yIFy2qtSVuEugNn/zrvjCyVa0s9YW0OKxk0arm7u2B5+KnClsTaBv3Cvsq2E?=
 =?us-ascii?Q?5TcIGfkAoJYKvH7UKg823bI9xBdNQCCphGdfZ566mPWUs+toOwLkC/xZMDNo?=
 =?us-ascii?Q?yTdVT93mkErp3pcPG0iJL290cUP6sabePzobgFFlXQmO0p65i6yyu8+jddMO?=
 =?us-ascii?Q?bN7TPZE0Kh1YVwP4AGEsoORmin/SGgZ9pUYHH65rcmVQSkQdY9tUA9OynJZu?=
 =?us-ascii?Q?P8N4lV95MqKNzubzv4DlS8/OUKek+6uMjkuxHOh5Gk5VUFgQzhrgmLDjYshb?=
 =?us-ascii?Q?9f1Ud2k7vmGK5A44FCfXYAGxFrNFY+W0cHcAdSjqmzGZibZ///tfu7c7/Wwu?=
 =?us-ascii?Q?CAvNfn4jPmHyQM8zAWA0P0W7lC3iTtXkrVfV1VW/fIXAa6WtklZpsj8wP7nX?=
 =?us-ascii?Q?McCrcy7GKG1ykZVQJa0vJR+SUGgnzbdHZDMt7fLa7ccqlrMwzCONbopzF3xb?=
 =?us-ascii?Q?xsYFykS9EguQkga389mNoPKGeqin3LvMu3Tz8qYGQviN9cnaAAO3vSoDF4Xz?=
 =?us-ascii?Q?xQ3ec6uYdvCtwCIIrSV/VN735IjcGnuN5bdOd2+vFFmMLHXgAMFV+jHMBv17?=
 =?us-ascii?Q?tTtEL3R5d8Q89nFPJt3Mtt2QoeqDxj719C5qYyGx44a1uatXahUwOOEd/d1r?=
 =?us-ascii?Q?VUEF1ZUhAbAudx67ObF8H6cM4p1Xdp47iEjjuqE/z+tQvepSyRUWfJrDMfIp?=
 =?us-ascii?Q?H6CRzPz+OLSYyQmq9Ry3Qxhgn18NZLEtTTlUCJNZi5qmeNMur+zHn22U0tV9?=
 =?us-ascii?Q?objzvOGOFnhy0D88YHALO+N7eYVmAHqirKz5KyUwLgD/2xaWPjU9Vb9L+T2V?=
 =?us-ascii?Q?F1he5iM11DmsWaOVjGhEacmFWPzY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:20:32.3423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab848e9-2ffe-48f2-7530-08dc71370660
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

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
Message-ID: <20240501085210.2213060-21-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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


