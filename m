Return-Path: <kvm+bounces-16323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF018B874C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BEA11F23424
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ABC51C2A;
	Wed,  1 May 2024 09:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Diw++JkF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63E1DFDE;
	Wed,  1 May 2024 09:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554508; cv=fail; b=E2pbFbRUksbukmN2dZbq7DgnT2l0jJ2o+KliIrmXEvFRpmwm0b37ah104Ps6ujh8jhnEzuML3fhMG4guPS/14cMZUtQTxREOTFdEW+ZV00dU/3cSZajpRVqVpGoL9o2H8yUENjdcEad6u07YXiHDfP54lRfT6SSLnZHOTyb/fLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554508; c=relaxed/simple;
	bh=LrGlfh8N3J0VcVVcqYTLVIvmWQUZwnQsbxcYYH4gncA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/WuTAkDkJHtDjJSfOmQNdKc+HJ4ykyt1ie+CVGDvJI1TUccm18IyFEVPGdbdSKGaU6ekLU9tnjrbATpQrKprsRaa2D16X4lWgG8IxGYShb4fN2sFtF3CM9i1EpbNtS42AMuYSTgtbVktZni/7SYz0lz11yDDy3bPuichf0p+FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Diw++JkF; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1QOa8ndclrRVM5qVR+mmfH52EGUZV3RK/S2c8HZs62D36z/StNL7ct5ycboUUs0q4FuWfFarLALKF22CGB2bKp5ZuSkjBHEIWzedC7sgM/VckKU7jN8kjSf7hBeW+B5646dKUC0y16nUXQZ0HI/PgYVOPLbEERKXFrMEj1ptIP/Bi9T5HbR5oan6FQJ288pff9gR5dMnoPFN8BWjCPRPMTUUkVLZQb+082u2tNZHRs1iLeG+DSB0N2TyiCASrDq+MgQshSN3L2X4dsK9JGiKTOf572o4PKAMSKKfNTZG4dXpVCHu+ctMUYBEBYWVd/6m1h8Fd4tj4DnQP7nLlySgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adchZnC4GHdiw/o4G0b7b23QArDQM7ZH8lxbcI2Pby8=;
 b=GB+NKVe7573fwrZPyBtqY4RXC29iBriq4G2D497uVNYsCGsKBgJDGNhwTIu4I8MnBysrbyfYeQuqXNAZ/h7oFYdqvU1AQzXW4FQ9vt1mY+SFSB929mAvoA284EP2nIiNlqHGPhjzJljskDS5JPvK3Yi11xMpM6CYK49jnPKerRTEzBd6ysaCmHywcV0uE4IRx375JIRXIksDpS72k5hKxYxoAmLOkm4bh5vXuVdyjxAz8GPMrq6YrzDTrmTRo60sg4GqBzbOpyNWQ3DZ4Rb/pjg2ezAhyGSi6vBINfaUWtY7FUJVgKpoaoNjNdWmiopok1FHjozCdqAaYIEFM35QyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adchZnC4GHdiw/o4G0b7b23QArDQM7ZH8lxbcI2Pby8=;
 b=Diw++JkFxMkkazWqrYpZAQk282Y7mkwXpde9NAeqSBgR5Kz0Lq61wpINtH9ssag+CRmVkelr1Rqpo8ZUmiDcZraGIuslUNtXpWxgLoMitVCw6s/vSb8EPfLUsvRz9R9WE6dSVQpjttfu6/3kJI7NeWicAgCiDxurvrZI1YmnTBQ=
Received: from BN9PR03CA0776.namprd03.prod.outlook.com (2603:10b6:408:13a::31)
 by CH3PR12MB8972.namprd12.prod.outlook.com (2603:10b6:610:169::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 09:08:23 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:13a:cafe::5b) by BN9PR03CA0776.outlook.office365.com
 (2603:10b6:408:13a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35 via Frontend
 Transport; Wed, 1 May 2024 09:08:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:08:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:08:22 -0500
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
	<brijesh.singh@amd.com>
Subject: [PATCH v15 05/20] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Date: Wed, 1 May 2024 03:51:55 -0500
Message-ID: <20240501085210.2213060-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|CH3PR12MB8972:EE_
X-MS-Office365-Filtering-Correlation-Id: bd1a55a5-bec6-44ad-18d3-08dc69be40db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|82310400014|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ANF41sZRnBIUdunTLSNN6C5+J/qB/uUjysDAGI5v0gVUq+fAgO7+XhJ134H5?=
 =?us-ascii?Q?bf9acDkxuwCoBcfadufi/zvTfBvqrqhDV4bpJAmIgSJ7NdPwR0reEgDQCCtw?=
 =?us-ascii?Q?JllVC55ijMMNHw3pdgCG7CyTAfaQVRMt8dhe+Zyj/nRsj54jxTGIuDmfny6O?=
 =?us-ascii?Q?icsU2zfC8O0wWmOVULjMd5beEF8kQT4Oinypn6vBOnvKBB4Z0f+5MwaiLmGB?=
 =?us-ascii?Q?SnHsgwyUBuJgshvQkvfHbgNXbFOKGy13m9v6XeR5ZCi4od2ab4l+zuCVHlHh?=
 =?us-ascii?Q?LbuBt+cUW+f2cnoITLbTX/5U8HRCyzjLCs9eS9gIKooWfN45UFkl7R16Lvrx?=
 =?us-ascii?Q?pP+o1rzIOdZrDzsrzedHX82yoLw6tWuLDSDxI09p37kugFj96vTkevvq3Q98?=
 =?us-ascii?Q?aaSF6L+G1Ob7b360F2zCwZna+rvXkmfPljZf2zta0enSNuN2d2eX7a9hhGtW?=
 =?us-ascii?Q?RoaF+a4flheJJ9sVF5DWjT7jM90ZXk9YSy4FXo+7h5K34dqPEoVfpkU0Prcj?=
 =?us-ascii?Q?GjylI/p7OpOm+kuQu7XlNdnLM7HNjOk3FWxpjHRYYYtARjS9qYuYZGEbAmzV?=
 =?us-ascii?Q?y5Dx7c3SV0dqDiDa/gv0SksFfsTjZyVNXC86ootT3RH76gd2FofZiTtK9gNh?=
 =?us-ascii?Q?Vr2tFFXz0qXA5GiS1orvm6buytoIoiSNoz9I4Q5QXYMEqknV7XrGemLYKpbI?=
 =?us-ascii?Q?Qb1Jgy4dR67QoWmbzEm0DK1fpMxOZ6atdjz/cvco/H0ZiZGjCijsbrc5mTKD?=
 =?us-ascii?Q?46stNOOBXrTOp08Gf9snf+Dc5Rs3R2r38LMSRF8z4AkLyzlAbFkvo+nKz4iR?=
 =?us-ascii?Q?lTUNQdLkLrYl/yZstHY3vndpIlDj8ZKJS86GKFWQdBa+bff30j7Q5fg7HP4F?=
 =?us-ascii?Q?vuucQHW8vTdW7pbv0EDndojJ3CmMxo7AoaiKqvcbfQhihQekwRf1CAYJFPgY?=
 =?us-ascii?Q?3pkzmvFlm9CTMmtp+ZaCIIuIwXHarPSrw86T+M51zok+sa/0WJTC1sNYpu2s?=
 =?us-ascii?Q?cK/7/d21dNxDF9vEQNY/9OBKod5RhU1KOqFoBTRbW4a1qgxIbEvB5kKKnyoa?=
 =?us-ascii?Q?og+BbFOX8JQxEHe/igF8YxYpsWsZipnxrkqefgTQEKIMm4esN/GDGIjH6tLy?=
 =?us-ascii?Q?dFg2HYTt8FlV1N06fhjvvEmiiBsja/InFeCgK91XjN7VqI1b1cvzfx21lhUJ?=
 =?us-ascii?Q?7I74vXkiKhD5sFYH4KfAWKnzij4ppFr4JuFhqm5uDLyopBC0Kyvp2udTCi+p?=
 =?us-ascii?Q?pWkcKEiV9jr9BU1SSPmpEHXwNbmZTjnxP/KNRuHTgeaDvE/lcQE2dqHnitIz?=
 =?us-ascii?Q?0tk5p9BrIhgF4I7YeXtQgUm/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:08:23.1946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1a55a5-bec6-44ad-18d3-08dc69be40db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8972

From: Brijesh Singh <brijesh.singh@amd.com>

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. Other commands can then at that point be
used to load/encrypt data into the guest's initial launch image.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  28 ++-
 arch/x86/include/uapi/asm/kvm.h               |  11 ++
 arch/x86/kvm/svm/sev.c                        | 176 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 4 files changed, 212 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 9677a0714a39..dd179e162a87 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -466,6 +466,30 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest. It must be called prior to issuing
+KVM_SEV_SNP_LAUNCH_UPDATE or KVM_SEV_SNP_LAUNCH_FINISH;
+
+Parameters (in): struct  kvm_sev_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u8 gosvw[16];         /* Guest OS visible workarounds. */
+                __u16 flags;            /* Must be zero. */
+                __u8 pad0[6];
+                __u64 pad1[4];
+        };
+
+See SNP_LAUNCH_START in the SEV-SNP specification [snp-fw-abi]_ for further
+details on the input parameters in ``struct kvm_sev_snp_launch_start``.
+
 Device attribute API
 ====================
 
@@ -497,9 +521,11 @@ References
 ==========
 
 
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi]_
+for more info.
 
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d2ae5fcc0275..693a80ffe40a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -697,6 +697,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START = 100,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -824,6 +827,14 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+	__u16 flags;
+	__u8 pad0[6];
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index be831e2c06eb..4676ce171aaa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -59,6 +60,21 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_API_MINOR	GENMASK_ULL(7, 0)
+#define SNP_POLICY_MASK_API_MAJOR	GENMASK_ULL(15, 8)
+#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
+#define SNP_POLICY_MASK_RSVD_MBO	BIT_ULL(17)
+#define SNP_POLICY_MASK_DEBUG		BIT_ULL(19)
+#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
+
+#define SNP_POLICY_MASK_VALID		(SNP_POLICY_MASK_API_MINOR	| \
+					 SNP_POLICY_MASK_API_MAJOR	| \
+					 SNP_POLICY_MASK_SMT		| \
+					 SNP_POLICY_MASK_RSVD_MBO	| \
+					 SNP_POLICY_MASK_DEBUG		| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET)
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -69,6 +85,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -95,12 +113,17 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -1998,6 +2021,106 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	}
 }
 
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
+			rc, argp->error);
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. */
+	if (sev->snp_context)
+		return -EINVAL;
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.flags)
+		return -EINVAL;
+
+	if (params.policy & ~SNP_POLICY_MASK_VALID)
+		return -EINVAL;
+
+	/* Check for policy bits that must be set */
+	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO) ||
+	    !(params.policy & SNP_POLICY_MASK_SMT))
+		return -EINVAL;
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
+		return -EINVAL;
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc) {
+		pr_debug("%s: SEV_CMD_SNP_LAUNCH_START firmware command failed, rc %d\n",
+			 __func__, rc);
+		goto e_free_context;
+	}
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc) {
+		pr_debug("%s: Failed to bind ASID to SEV-SNP context, rc %d\n",
+			 __func__, rc);
+		goto e_free_context;
+	}
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2021,6 +2144,15 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	/*
+	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
+	 * allow the use of SNP-specific commands.
+	 */
+	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
+		r = -EPERM;
+		goto out;
+	}
+
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
@@ -2085,6 +2217,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2280,6 +2415,31 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	/* Do the decommision, which will unbind the ASID from the SNP context */
+	data.address = __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	up_write(&sev_deactivate_lock);
+
+	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
+		return ret;
+
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2321,7 +2481,17 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		/*
+		 * Decomission handles unbinding of the ASID. If it fails for
+		 * some unexpected reason, just leak the ASID.
+		 */
+		if (snp_decommission_context(kvm))
+			return;
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1407acf45a23..d175059fa7c8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -93,6 +93,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
-- 
2.25.1


