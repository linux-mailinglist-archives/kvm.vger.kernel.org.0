Return-Path: <kvm+bounces-15447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1FA8AC0AA
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85E95280F94
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB35E3EA98;
	Sun, 21 Apr 2024 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LpfFNfWi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C42376FC;
	Sun, 21 Apr 2024 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713723057; cv=fail; b=aC3RLRIpR2XXjeZ7KksYQylHZ6mFNUs+xpgbk0zdpsl4sHbh1drgRGPHMFE5gJqcv6CmbnzLIKbR3HkZ0J/0Dp+UN9skN7jnP5Y75OTmQOjKToOq0X1ght7YAawY5sAFHWGu5LMqdnmVZzmZMrRmOt/PQ1yjXigTNbSIez0nXgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713723057; c=relaxed/simple;
	bh=Eh0ueBL+KhbONW1+fr7xiqnrgMc0cglKw4I/TNuwZMY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGBQ5EBQlD3Ms42o6S2LBXvOmtb5tQnNwtblJoxX57XWVC3oD/wMbyRFzk8duAQkjaQ7/pQ2qdAS7Rj0aQKRmxq0pSk02ma1XcD72TxkbbXYIMpBe6s8NSA4pQ9vWWhyOHnZKJUFH8jCIMcK4BizTMC29vnksBPMB5096uANc6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LpfFNfWi; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VO8Z4KACOlo7i10oZJnVx72lCiMcuCyIzAF9a6Epd3Xs0WQ+f1M6Mmz71sqJijM8p6zUeXuyJp4xjH04QYxWstri4AFVMPO5IlTVgeytHRv68n82d9MfBjZsw30xHorDlloGzfLalyE1hkp54a3l7wnxMI+dJi34M4XEFhERMnJZM0i64fZPHud8Apb8QOqcS8QOnVfsubw1lZapJQQs1b889XQSFzf33PTkri/MFGWewnEYf31nvf3LL9sWQK4EqH+JPJTMmQyqFxZjLKZcaizW4ZiWdFBuTGW7dTf3K/Mhcv9Cc1JnDNbCRnmlyTbyPt+c1hOLP3g5OScKAbiHLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMLcSqMLx+WnMuvKssjd3QjQtrtM9T0ZYvsTn0pvMl8=;
 b=MJi1V/hUTwPAQ9wshO7bI3bxBpGwP3qO6McNSeDxMuiDulw+ghyn/DO/KfFfxdkggK2b1qhfu4rHvh9qQXo5P4AJHNIfAozUkq5hvnZSPX5HuF8w16Wu9J0+H0aZLs/EexAOlKuvNWYVLXzgzHpPM1KLZfHG8XUh2gmm9julIrCeBCMATqKX+y0YYxmzoI94xY9o6PK4Yres4tg/YRBbgra0haQRK8rDKz5DDQvWs3YMYTPyexaW6YNaL12qz2PAgX81gvY3nv7r/xE8c6pMseVJllzWrSPOEIbFDZLtifqjNmhiDJK32SR3r4fEBRHWI2Ed0QhiGBcADpJ4J82cMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMLcSqMLx+WnMuvKssjd3QjQtrtM9T0ZYvsTn0pvMl8=;
 b=LpfFNfWiKv37Tzasc1Mc8lcpSJpLcfNfn27yREUr7dUAn/dSuc1/kp6MxSDiUTbBGbQ6svqGfBoGP9G2JuiP1ancqxTiTp9izKXkJgut3W6OzrboC8ajaHArlJeqajBuI9NRE8TlBe4s/u7u03PNeMXt1tR/qm/aos0rIil+sMs=
Received: from CY5PR15CA0010.namprd15.prod.outlook.com (2603:10b6:930:14::15)
 by PH7PR12MB9127.namprd12.prod.outlook.com (2603:10b6:510:2f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:10:50 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:14:cafe::42) by CY5PR15CA0010.outlook.office365.com
 (2603:10b6:930:14::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:10:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:10:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:10:49 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v14 07/22] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Sun, 21 Apr 2024 13:01:07 -0500
Message-ID: <20240421180122.1650812-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|PH7PR12MB9127:EE_
X-MS-Office365-Filtering-Correlation-Id: fbfdbd03-fb5d-41ed-9a5f-08dc622e604f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Kb8w0IroJPUKsvnn8rC69EBDDxQU1KmmBIrQpnQuVNfV+be5u1wsjWDpeMM?=
 =?us-ascii?Q?vtIXhGsQbcWR0XyP1ujDYL3Xx1PSP/KLsvB0w/BF0qdi3nBnTA8EqUzEAMn3?=
 =?us-ascii?Q?lXQmwS2McksfALN11AQmUQqNW3XZu5HIRL8L67m58NIVkhLZe7YQ/ZJCBqrT?=
 =?us-ascii?Q?HWPqxy/bMtCcezmFuOIyF9SwBEK0VUc3eEJ7L8eSiJkOFyBL+uxPU+64PvH8?=
 =?us-ascii?Q?0IaFk8TZlByOtcfLOJQ7OQkoSaI/oGKYpfsLQI52ImSjBKNmbq/hCRgETPEJ?=
 =?us-ascii?Q?20y11qwlv0/XDTpjTHkY809Aq9FNaZNDE73z9iTB6gIu5/K7kJoXdi8vz6yT?=
 =?us-ascii?Q?hSDKqoNxul6utfhvIezHubh0xuryTM+cHJA/oKarCF8FW8pENEc07GmqGmPq?=
 =?us-ascii?Q?9QPMKvKmgGKvgNdqaiB/ZJ18ZMLw0MwATxXtoJ04vrcmQdmboG4qlp6algyW?=
 =?us-ascii?Q?jMWtQRfJfVanXZMQH35qwkCXDp7n3yS3zrdIDn6FrZsa+S6kXDur1Eb49z98?=
 =?us-ascii?Q?cGCNA5NTyBtVIjNFZC+kDokfZLZCSE12HyrKhXIMGsXpt5PBh2q9J4W9o+Fe?=
 =?us-ascii?Q?+nqlGqLtV2zQpDcl7MlqffoqwqBYx03QQ6ZqMtaw7jM+6Ob4saexxvaHEiIx?=
 =?us-ascii?Q?YiiPSYehHL+iIiOarqu7abY5AZBsPnBQyMfGDN3ErOYrsSjjvS08uM7tnK1Y?=
 =?us-ascii?Q?X36k9BWIkCDmMlsuNCFSeg72MWSHmyh+qVDr3295N7OoAC+rBlHvz6N2dM7Y?=
 =?us-ascii?Q?pKAump/RvKjUWbjGdNRYG2iyRz9d9Whdvj1k6kavs3/yd5lRPmRh9rTYoFbW?=
 =?us-ascii?Q?HQGD9ZBHeqt5gqrPkDDxkbzCWE7WQcKtjrYu2SlauW4fdDTot9zdbgChpeB5?=
 =?us-ascii?Q?6yPLAN+TpYj/x0u1XHFE9Yobku2Fw7XPboQtyV0D0LjAwbTjABb0+xOx9qLi?=
 =?us-ascii?Q?qi4XVUHNmdorQTBxbBWYdDGoenTwxrEGdL8TQCvGs6iGx0awVfMIk73yOO4C?=
 =?us-ascii?Q?SdjOUV42ImR6eoHkgvSm8//WZpTYMhEmk740dzl+KZlMvQnHiKVW9VFsTY3S?=
 =?us-ascii?Q?sJBAG0Bys+tsJ7J91Uhk1wZYkjrAMP+5xk9e1r/Eb2qVIqFYwlxAzDjHrWqZ?=
 =?us-ascii?Q?vcBsk82aIFkRchcbQtbssgBBgvAYPmaNAW6UMkCVE6FOJLdZ10SYlTSSRkAf?=
 =?us-ascii?Q?x2kQhgrFy0IT75OfxUy6RoCoO8Z8li5mG9gJkAainjMGw5KnW2k2T+N8P9Bt?=
 =?us-ascii?Q?pbmgtETmW6E3vVn33mFgMjBsWMf4zMHVR1fEIDT+53DPUvk1KsZiUIrSw6YV?=
 =?us-ascii?Q?iJ65I6eYWVMXgLUgzLBowaZqW9Y+sA+1Qz8xTMkiCerswrFzKGuzAYpt7Ah5?=
 =?us-ascii?Q?7GPtiYSeJaS8o5ACxPYBlEoUlxcG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:10:50.2677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfdbd03-fb5d-41ed-9a5f-08dc622e604f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9127

From: Brijesh Singh <brijesh.singh@amd.com>

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest which stores the measurement of the guest at launch time.
Also extend the existing SNP firmware data structures to support
disabling the use of Versioned Chip Endorsement Keys (VCEK) by guests as
part of this command.

While finalizing the launch flow, the code also issues the LAUNCH_UPDATE
SNP firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU, which requires setting the RMP entries for those pages
to private, so also add handling to clean up the RMP entries for these
pages whening freeing vCPUs during shutdown.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  28 ++++
 arch/x86/include/uapi/asm/kvm.h               |  17 +++
 arch/x86/kvm/svm/sev.c                        | 126 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 60728868c5c6..67bcede94bb5 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -537,6 +537,34 @@ where the allowed values for page_type are #define'd as::
 See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
 used/measured.
 
+20. KVM_SEV_SNP_LAUNCH_FINISH
+-----------------------------
+
+After completion of the SNP guest launch flow, the KVM_SEV_SNP_LAUNCH_FINISH
+command can be issued to make the guest ready for execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 vcek_disabled;
+                __u8 host_data[32];
+                __u8 pad0[3];
+                __u16 flags;                    /* Must be zero */
+                __u64 pad1[4];
+        };
+
+
+See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
+details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3c9255de76db..8007fbfe0160 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -700,6 +700,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -852,6 +853,22 @@ struct kvm_sev_snp_launch_update {
 	__u64 pad2[4];
 };
 
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vcek_disabled;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad0[3];
+	__u16 flags;
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d3ae4ded91df..6ca1b13c9beb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -74,6 +74,8 @@ static u64 sev_supported_vmsa_features;
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2352,6 +2354,114 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.page_type = SNP_PAGE_TYPE_VMSA;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret = rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address = __sme_pa(svm->sev_es.vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected = true;
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block = NULL, *id_auth = NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (params.flags)
+		return -EINVAL;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flow. */
+	ret = snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret = PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en = 1;
+		data->id_block_paddr = __sme_pa(id_block);
+
+		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret = PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr = __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en = 1;
+	}
+
+	data->vcek_disabled = params.vcek_disabled;
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2454,6 +2564,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2944,11 +3057,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
 
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3705c2044fc0..903ddfea8585 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -658,6 +658,7 @@ struct sev_data_snp_launch_update {
  * @id_auth_paddr: system physical address of ID block authentication structure
  * @id_block_en: indicates whether ID block is present
  * @auth_key_en: indicates whether author key is present in authentication structure
+ * @vcek_disabled: indicates whether use of VCEK is allowed for attestation reports
  * @rsvd: reserved
  * @host_data: host-supplied data for guest, not interpreted by firmware
  */
@@ -667,7 +668,8 @@ struct sev_data_snp_launch_finish {
 	u64 id_auth_paddr;
 	u8 id_block_en:1;
 	u8 auth_key_en:1;
-	u64 rsvd:62;
+	u8 vcek_disabled:1;
+	u64 rsvd:61;
 	u8 host_data[32];
 } __packed;
 
-- 
2.25.1


