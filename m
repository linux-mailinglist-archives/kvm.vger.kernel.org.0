Return-Path: <kvm+bounces-15445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D537E8AC0A4
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 603701F21351
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51763EA98;
	Sun, 21 Apr 2024 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dcJF1FAK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09C3A8CE;
	Sun, 21 Apr 2024 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713723014; cv=fail; b=R2OG1/38KZ48RbpSBsc8a+RocytOfJ93rjrvIrop1US1jrQn7JHj/sd6jNq9/ceZq4ACdV3EvoLlfmggb2vdZT5GZXXoDhx7G8xQgiT3TlpyoCtZmJcghmkwA6h4+Nmhz05tmDolOXT/sx7DwekpKkBhlricwZlVcFf+5lsdwvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713723014; c=relaxed/simple;
	bh=Rb/xNNgyKP2BElQQCQX/pAUApPvHkVSU2oFyPY/JeoQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6T/KtuYjS3eT06G7yO0NR3sAGHErsoWbgP10t43gxGhJr0bDFZ00nJPkmpqbniPE3qcvNcIvtq1SmWqkwXmpQumbQTm8gu1fHV/SmZsLYwrEGiqJS2KkCdOCgB17oKLATtrV0Ztf1DX/IHw7HHXDYbeaBvUQAOGQJNsm5JEPtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dcJF1FAK; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwLkY6q8/v+VmYnr9cmGErauJfdtS5l95pB0Q7MMUbtBLl9ySb4MO5t5C18oanzQ62Enbc76e4yIokbdazsUjvUwlzcfuQr+yS+Uiyaydk/Fm540qz0Nb/AaAKfoxoD7NOc8LlNcLlRiuxs4K//DenFZLqXsNy/CdiiOTRWc+zBzgCQpQIbuq5ki0cTPgNQQtfEu+4jd9Fdg8FIK3c3XTE8egBroygV9Qyz9hwLD2Q+paEvQgNluPtBqXQFeH3mLlHeFZyu6q4fTsZp4vT1ufh8w9Wz4rc7Fs0CAfpv+nNlnF7C8LuUSKcXDHDPXBXGAtZ0yXE6SOXl+lj0O0iX1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xj0PCdbxto2/vrk3jZ7QgProPbvUdx01e5v6oTqjQrw=;
 b=dSqpuNsfcxgITawXOiwn1+FUxEVthG434CEwbCDZqKo4j74NdLpv1ERJ6ytWBL/sas7Js7VZR9E76X7mcDwAEQG/OxqLDKZeeC5yP8SPVNds679CJ/hNGOKIbiG5bfS2DKIXvgWC0Cd9C8egq3D8UcAenBQdfCyuL9kboIotC6LY3V43oZ+VclKe1AERLs5wvk2Fu9rDis/fKyCfSY8+4oBC1c3aBd17f2dLHddWTnezZ3yrns1o1JK8Nd5n0WS/wPBxZZ2kSTyo2TpYjGiNliL7FGZtyWPw4LUEgNpBFowO+jZYtlFy4qC6wIX9oBtDTS6Q3SA0ULc8L0SKb7APDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xj0PCdbxto2/vrk3jZ7QgProPbvUdx01e5v6oTqjQrw=;
 b=dcJF1FAK5AvGpELX/N1uDl/Q44ZSTwOJpQiK5RnntZ0PYhLGgIwPw2P/SAYGYQ1xQPNFAdGZbRKcYWIVhKDRgecPNxeiQCFezRgXp+zpfHIjXgCXVXWIhdmDR3NCb/NxY+YhsrU5rQfoFlchVjsGqvkaTe2hNZU3GXKi+IqM+ls=
Received: from BY3PR05CA0021.namprd05.prod.outlook.com (2603:10b6:a03:254::26)
 by SJ2PR12MB8829.namprd12.prod.outlook.com (2603:10b6:a03:4d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:10:08 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::6) by BY3PR05CA0021.outlook.office365.com
 (2603:10b6:a03:254::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:10:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:10:06 -0500
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
Subject: [PATCH v14 05/22] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Date: Sun, 21 Apr 2024 13:01:05 -0500
Message-ID: <20240421180122.1650812-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SJ2PR12MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: 56afeb3b-2e79-4466-dd95-08dc622e46f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dnVtMqNUQxRHWAwG6QAaPMCZBH45vtGfh9/XojDY6qGZHsU+V1AFa0+B3u8B?=
 =?us-ascii?Q?2woHb29pmiljrLL7x7GX5GCHpB1MFz2dNG4x+1KsDN7n6zFdDaByvgbufIjF?=
 =?us-ascii?Q?mnPrkUxPfgA0m/5gvKoFTE3KsSrarxgIzqSr6l2UbmMYwKyVJuc6n/yzWzdc?=
 =?us-ascii?Q?6fkG7jf/ZqdwZueCjCcEM372RpKSw275nKlCF1n+mwByH66FzvgPMedsEeS7?=
 =?us-ascii?Q?XELdngxb/sU5AdIcrMUb6ATk/ua3Cx+ELbk7di5bE1OCrGdbJgSgW+tcknhV?=
 =?us-ascii?Q?OEkME7AzBh2UqD6Rys6Ifm9+n3qeNHW4NDKhx78/BDEIgFQQDkEP51a453cq?=
 =?us-ascii?Q?KBDYfN6fWNfMe6d5HfX3oNuabxRCtg3rAmNNxi940Dsxe7AKWFiGr8BsEgoQ?=
 =?us-ascii?Q?fUFfflBgM/VAr7dLVFI7aIdbS50kM4t4m8d8MDb0wsVKD4iTde3ALZ0aHd3D?=
 =?us-ascii?Q?DQ8s2Y+nIFr0xWw9Hlv7C1en6UaZJsGnMpWbTTPZoKuIsPLotctTY0cJ4bjb?=
 =?us-ascii?Q?fY9NcV8K277eFvsZUZLU21ZdmkvD1sWtFI9jm96bJef34ACkcPc0FnePUIkb?=
 =?us-ascii?Q?iTo/ALtgtKCZK5eYwMBulx5iu89mWbxEM92w5KHk0mKdsnuK2aRJXag8cbvh?=
 =?us-ascii?Q?uTJS50e+Pg7z6UU4CqSfhBexYhqNxOngDA5/fKxuFsw0JyPYGL9W2nLWHUm2?=
 =?us-ascii?Q?K833nk7jAzuxEHG7Qb3tbOJ53OlVvf/nKokFN9fWyCEd7UIcjxkcacLmc8iE?=
 =?us-ascii?Q?C7qyMHPAKvpY6vCTvjJtliRkOsqF2h+cj4X+X5ZxTOmjBqP+8MYsVq3dta8j?=
 =?us-ascii?Q?Nqzr77Ih6W6OB2OsJyAU2mYtH0MvezhCT8ygKXrE1Y2cavwmzTpFPY5/k9Sr?=
 =?us-ascii?Q?ypTBNFoLB+y7UOEYTL1moBHrrRjQBWwfN4QWkHE3x/MTxi5HTQsmTRx7HiST?=
 =?us-ascii?Q?3gm/yhlqjNu0wl4rGXrjH82xL+giwSvPfDSDqcAro1UyIBc9O3/QPncKYsJp?=
 =?us-ascii?Q?LkgdoNyv6NhLg9sbyCvONM9BdcRwuXTsznyKqBwPacCL7OoeqtTOVzrJb7s+?=
 =?us-ascii?Q?HXX6MXYd7j3K0K93NByNq2q0I9BzXRYzmM3rBpvgSEmCpT1mENa4oiCRUedK?=
 =?us-ascii?Q?UUgN2abHeiOYLFWLDiOpgwmJj9Q5vpH11i9HscSN9FDcLnneoRBwg9e9sjnN?=
 =?us-ascii?Q?U+b5l3eyIat2COF/dHJ544v2PjLCJVd3+yTdRqr0+4Y/5skpo/X/S94rF1a1?=
 =?us-ascii?Q?DyXqst5AI9i/oIuilrKCjp4tLhWNc/4ei1w1LgnsR1QnbXo+Cv51rL6v3iql?=
 =?us-ascii?Q?Z/kzGH4tqxe2BCHIGKreetCL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:10:07.7472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56afeb3b-2e79-4466-dd95-08dc622e46f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8829

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
 arch/x86/include/uapi/asm/kvm.h               |  11 +
 arch/x86/kvm/svm/sev.c                        | 195 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 4 files changed, 231 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 3381556d596d..d4c4a0b90bc9 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -459,6 +459,30 @@ issued by the hypervisor to make the guest ready for execution.
 
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
 
@@ -490,9 +514,11 @@ References
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
index 9a8b81d20314..5765391f0fdb 100644
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
 
@@ -822,6 +825,14 @@ struct kvm_sev_receive_update_data {
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
index c41cc73a1efe..9d08d1202544 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -58,6 +59,21 @@ static u64 sev_supported_vmsa_features;
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
@@ -68,6 +84,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -94,12 +112,17 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
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
@@ -1976,6 +1999,125 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
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
+	if (sev->snp_context) {
+		pr_debug("%s: SEV-SNP context already exists. Refusing to allocate an additional one.\n",
+			 __func__);
+		return -EINVAL;
+	}
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.flags) {
+		pr_debug("%s: SEV-SNP hypervisor does not support requested flags 0x%x\n",
+			 __func__, params.flags);
+		return -EINVAL;
+	}
+
+	if (params.policy & ~SNP_POLICY_MASK_VALID) {
+		pr_debug("%s: SEV-SNP hypervisor does not support requested policy 0x%llx (supported 0x%llx).\n",
+			 __func__, params.policy, SNP_POLICY_MASK_VALID);
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO)) {
+		pr_debug("%s: SEV-SNP hypervisor does not support requested policy 0x%llx (must be set 0x%llx).\n",
+			 __func__, params.policy, SNP_POLICY_MASK_RSVD_MBO);
+		return -EINVAL;
+	}
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET) {
+		pr_debug("%s: SEV-SNP hypervisor does not support limiting guests to a single socket.\n",
+			 __func__);
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_SMT)) {
+		pr_debug("%s: SEV-SNP hypervisor does not support limiting guests to a single SMT thread.\n",
+			 __func__);
+		return -EINVAL;
+	}
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
@@ -1999,6 +2141,15 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
@@ -2063,6 +2214,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2258,6 +2412,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
+	data.address = __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2299,7 +2480,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f2e9c7fc4ca..0654fc91d4db 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -92,6 +92,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
-- 
2.25.1


