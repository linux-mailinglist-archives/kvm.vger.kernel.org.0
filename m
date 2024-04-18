Return-Path: <kvm+bounces-15156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 549338AA364
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACBECB24E34
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B22A1A0B00;
	Thu, 18 Apr 2024 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="150sGLdP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCA9199EB4;
	Thu, 18 Apr 2024 19:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469698; cv=fail; b=X7NS0V7tIWiHLgGgD+cP8/2/P5yfw2VPGyb60S5gXoHbWZr+IR472DMgjcTDjbvlraqpLXtXBepMQcyZ+2TE1yPuatGSHBEaHueSTe/nHqJ4Stw/qjqlSq97KZJuWscfT9PcWeSiQXOwD3oeZ05Ro6X2a7vlBIYbA8GyihVi6TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469698; c=relaxed/simple;
	bh=T6pGJVRHlHSyXnXGrojJ2riNnafIVnvK+50POJ+c5gE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0GnHb7DTvzAcrjUwsapHLJIox/E3oqigGZlAMLPycXp3v1m68PcXqVq4EDnHzzDXxK4nUV7RIAQzFD7weGPB+bREYDgU7k8ooKLbuRDLzReCufSPB/Mw0r9TbQ/01QC85sE4OcmlQt2rirjs8/tvcLTM7qz42uM3P/THNiSW/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=150sGLdP; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gD+WbXrvViLlcWQ5zk524xNAymrGUCYQi/B7Ml9XxbJ6mOvcO7HHRhdb6odIYAVf6qVmJBCJo1SPWaLGgqVFZWxFl0Fl+MKjyyXqzMoiWy5vZPSevwgG/upnWzhtxBOdtBJPeqDkNWNTmr5AZKnzQEubTENUu7VuXvAgEeVwT8gHZqDDAOlODE75c/M0ia4akQaybkeLhUIkzjbvUd4Vk3HuFNTuBN89T81P8sWIxZQZ1xb6d6+csBL3l9qR1jfnJYvXMesB/q7RBtRcCvtDDjYqwfmO6l6u1VmwLBuPJXUrY7PBw+hx7mIY1zNDdwyE+BGp7tKceTjbXO3EBNxwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=aH/TCq3wJVRcv4doMYQC0nKh2W2oHnHgtSCxJvA5oic+OT1/OLqtYSvsP6AICsTNTty1+YftAuuOyegbBGLLEvGeMM/mT9RswLg8QCGyjVsEQu3ICMipFevePCsdMTh+yhtBJMuIhPREeOMnwk83o3vBuWsjrmfutC2JZTCMH4Ikee2um3YXLlBfXVTRmpX7IQwK5BvDZyo0/Wobc7yW9e60kBniQEDEwYLpeiJAr0QYAJ7/1BHN/isK3nruu8zKKfMsgIAS7SNbN9ZauqiHwYiBJvlGJhBEoIS6bZ8aGLfzAE7gE30FEXpB+3Ml5zH0i25adJ17w699iyH49bL82A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrLx/Gtif4PESh/Cb7f+ZeKvu4HjLI75t/BpaHSyZ/E=;
 b=150sGLdPv5XFiJDPYI2VZVL8wV9VRibK6Cse/0BgmA2CjqPBbr+bu5Pt7cwYTLf9OyooS4lRr/LvFte3+ABZOhEBOcuwL+xt1iY4eCtlLOsTk4Dpku58KYa0VAu7utAOYRA04e4A0HEtMMnEBquYrrqv24m2F1Yk6arKCruxHZA=
Received: from PH7PR17CA0029.namprd17.prod.outlook.com (2603:10b6:510:323::23)
 by IA0PR12MB9012.namprd12.prod.outlook.com (2603:10b6:208:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:48:14 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::2) by PH7PR17CA0029.outlook.office365.com
 (2603:10b6:510:323::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.29 via Frontend
 Transport; Thu, 18 Apr 2024 19:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:48:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:48:12 -0500
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
Subject: [PATCH v13 24/26] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Thu, 18 Apr 2024 14:41:31 -0500
Message-ID: <20240418194133.1452059-25-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|IA0PR12MB9012:EE_
X-MS-Office365-Filtering-Correlation-Id: 825a3000-62c0-4f6a-2102-08dc5fe07c05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6WBLfDe9c068/zJhGn1Q7+Dj3TRXL2QOkKsOSENcVapTmlchwXVPSXPYtufNksFLJvkkjvTIBl1oMxLEfVtSAH4Gi28Z9cSn3OY8uOyy5jI23cLGQPW61JcWV+eX2kde55gSkoNty1aE2oJwBrlaeiAfWpJh8SlpxSvbpg/4DJqpmGQmXwSX6bjawOKxK+x0WpvX3LxI4BTd7yahTWTUMJwmdXhQ3dKKX7fnlYl/BEFdZmPqgJcu+qN7LeEvA4n8174Fmt9DSPIXKBKOutuk6H14WICTszz1viheL8jEr63mB89xn/zQIeQpavLXfymcnZR9tPtPtequih2JFi7+ROWEcau9IM6qsxatTbVgCN0PTEP5JzwMWsJS7RaOMUbWCpymfiVLP7quUFyQpNAlS8x84Jiv64sUcwIAb71lDK9XHKSBvobAapU3Cx8WDj7EcGwxoqYWgQtmc0JF6ULxhLMC0pgiDbSmy220GYo226KHnYKD5NcR8oWo27+p3L+BZzLFLTVkMLNltYHiqtMyUdGbAJGglh4HVd6gxdqbBpVeBXgUW06oFz+DRUfc9rx0itGk4qkS7gOhVlGFH5kTjMYRz8UO/itCCxZHjRcG1piZnLXaNDhGqvB1NslYeP5vuUrrNZyjcRUtNqS99zc0nOAXS9m0Ub58Vw9otDx5LNt2iPgaw42PudWXJSlNQSHMTf0k2rL+r41Mv6tCNkn+WcSqbzwUIrtPLbeFcTDMcO5EIldCVbQ2r6X5AsKhCA7Y
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:48:13.6854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 825a3000-62c0-4f6a-2102-08dc5fe07c05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9012

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


