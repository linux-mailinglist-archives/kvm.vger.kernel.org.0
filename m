Return-Path: <kvm+bounces-15273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EEB8AAEED
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75C461F22D9E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAB84D137;
	Fri, 19 Apr 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zCX3Jppf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496985948
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531573; cv=fail; b=Bv1fSI8WslACYnXS2s/f8NQcfKDjsBD433UEegtRBwf4geZmhf988g+8ae/D5g4myUxp1FpRfktAlmmJhb/t8cztIP/Dt1B7CVISfSZI2eev/y/tmBhVzLk6UZK0foIDIeTdPN6R8E8gOnT/HVNmjW+jYe4nBdzxaSbQBBWsuUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531573; c=relaxed/simple;
	bh=dvVKHoeLGZ0wBt0oTVyp7FaTUXIDhPng/yKV5j/9V+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUvtqmFdoA6XfYG2tRiq/+pInaI2JOUvcyPUfY0QvijqbuDVyn+12kixvq+dLat15gV3AxtSySH+OxPrhsQt4BU+hDC8KNaQYqjJcjtXWIeO26EUlf6BgCwt6wpIkKG7MummdNKAepWibwhU+XwsrbRIX3Kwk3Vg/Xu7Mm8rjA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zCX3Jppf; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlosAS4QYmU/XJmnZRzycyA8dI81qwZGfls+85qkjx2lK+ILOAYJUb1gKwNykDFFciG42hUBxYifocUyliNIDg2pZqpU+3jLdmGUT9242p6kRRQMzsIRiI5k5msc4YHzCHIgb+wxfnWiIc9NhaauddeWZBFEr2eC+OtGmZkwuxwBnLYUZrQNROlLhdLq43lBRhZSnojRo23CF5cnbKz+gBcm0hsNjXd0otXZqeLlZ0HRbDSUJK/vrwy+5DkFu0wGWyftW7QrrykZ7SV4RIRQ2fVN8YbXvBhZXl9S9rmbLZz299uWjn1pA78V+aBUmcOrx0tHgjZ0QS/5Wr0lFmSH7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG3jANTDSSG1/++/vLnYPLU5dCPv9msFKrszBqlqZ2Q=;
 b=QiS02HP7t9anPOZAgaSXO2VL8lmApz45IsLrCBCbywWn7sc61tj4vpUSz+NR7KijS2ZIHkjtQurZS6ADozdqtgRdzDkf6NHgokYyDXThgCJ7a2fyOSAY6fr4PHQr/6aRVA3ETe6OxpBXkjoJDbApYok4jROBN9TTDKfEhe2OIqW4qWcXFzw02AEFFNCHZ36WdJqirFKIL3rlMWhenXkWnhijsXqcZEsOAG8Hbpvnq9U/utiOUENRG73mY83iXx0gyuqE+6kvgFqKzWYnj58NNWReFFthBmIqPS+wi03glr4ls/rUH3Lxc20I2lI8i6zZDuUcBpUY1+b/ynTinnu6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG3jANTDSSG1/++/vLnYPLU5dCPv9msFKrszBqlqZ2Q=;
 b=zCX3Jppf9QHL7chSBW505ukMPqbvbTj6cbFtWFxBeC6LZqpSqRD23/5oZ97sjrHXAor91FZGzL9QD8iGFkBhTHVBGtlJFPc/ZJNNmQNJBCaD2A8OpXErBKtYl6RhZVcN2k/sovoLPDJ2Zwc6pNT6Z+7o/oPLi/nx/qI6QzmosDo=
Received: from SA1PR03CA0020.namprd03.prod.outlook.com (2603:10b6:806:2d3::17)
 by MN2PR12MB4128.namprd12.prod.outlook.com (2603:10b6:208:1dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 12:59:29 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::b2) by SA1PR03CA0020.outlook.office365.com
 (2603:10b6:806:2d3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Fri, 19 Apr 2024 12:59:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:59:29 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:59:28 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 06/13] x86 AMD SEV-SNP: Add tests for presence of confidential computing blob
Date: Fri, 19 Apr 2024 07:57:52 -0500
Message-ID: <20240419125759.242870-7-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|MN2PR12MB4128:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bbd1aa5-7e35-495f-ab64-08dc60708cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H/9aHU5KgiSv9jeHGSzAmWVrfPVBxYpSSgVhZeviXDtVYSN5SA1x4hQszo9t?=
 =?us-ascii?Q?v7tRQHYRnwOWiuXhUJPQ6V88nhowWCt7SYZNYT3Rl+VmJg2Ii3rI1laFKgQ3?=
 =?us-ascii?Q?kAZbuboN3m/NZ1e/KJFSc94fHWe3yNd5zBsrtseVGkJiUtYlnl/siqpgQAD0?=
 =?us-ascii?Q?exrlgzC3n5v3IWx4kOA5V7kpV3wdd4IANbFxNB491yiaAG1u1RVcNQq0cIan?=
 =?us-ascii?Q?5Ovx/JEO3jTwItPdC4DCc0Bw3sdWBgLY0276+ESjBb0AN2eqpA2gjxEcTmhw?=
 =?us-ascii?Q?4zLbY6D78cLZQdwFDmAOG+RVGCseydMI+FLHJXK1DlEv/bbAIwwoyzPcqHcE?=
 =?us-ascii?Q?2GbW7xnm4Uy1AU9ZxQY8rsWGMnaMamb0MfCUdBkw14G+VKjFlL/+PVBkfPHJ?=
 =?us-ascii?Q?VGE4s2y0501AFsuO8Vp+nG66D4qAAEfIa4wb1aBKSaDQq/Gd9yJlCNxEm7ax?=
 =?us-ascii?Q?rlAF+gsKbxZj0VnsTagtxVf/GV5q+aC2kBsjun4Bp3Mh5OBTwIc2hdRCI6Yo?=
 =?us-ascii?Q?X7ynmBJVF/nJQe6W2FNkkrefEq8VFZzfq+d8YrFBdMjYPjc/nVoP7cmR8g+Y?=
 =?us-ascii?Q?WyZIGvjQ2EhwC/3L9zpahWQWxYUkSSNLB/QeMvNgdW/LTieX1xtF1Q7NQwpN?=
 =?us-ascii?Q?IsXx30qzu9elIA4eed0sAeIm3TsAw0ail5IP9V3FIyTBreMUmADV5lZE/ckw?=
 =?us-ascii?Q?SPOPC23uezn/hJ1UO66zXne949iwQ/PQ6IopzQbsNxLIoUFtts0SIdTj+V3h?=
 =?us-ascii?Q?kWxGSku1+zvD2F1ITWFboF0T1KLh8QxKhsTgZ5J+EQl0cpZFGKwrk0+WamNt?=
 =?us-ascii?Q?ypcr8BjPdszZU1C08wFAoMNwZyOpGTzuLdpKBmcWtw3EC9ufwSdxs2SO24lB?=
 =?us-ascii?Q?QS/FdxReXyNk2kq5OEoLcR4VM54iwf4sCiIUBRjf95ApdTBdbasHiJnbJDnK?=
 =?us-ascii?Q?VY0nGCIoqL7mvtDoSCbhrhWQptr5OwmzXkurOS1RTXhy6avDfcyqXy9KaG0K?=
 =?us-ascii?Q?c8wlCxEefPYGnOXR9hBTdkFww2WTa0mshc/sArs8b9DyTCfLGmETGzTYA66U?=
 =?us-ascii?Q?PDeAwTm0f5Qb6vbLBOX0/wU37csVDd/xW+9+WcPi1aPHZh6rCrQH7qYEPBY/?=
 =?us-ascii?Q?zwZn++SlKai0UtbkD9jyv50SmJOPzbauKYWcfGOUxtXWu1Ab5isoF5HM+EPi?=
 =?us-ascii?Q?XKWdgl9VIBg4E19nhcOMZHXop/iQjynMTRpDxqr1Mgapxm2j+Ps+b1H/mb89?=
 =?us-ascii?Q?MVVrga3fQ7r3O1whpfgynwkB9A7IeAy4wBTuKm2mztFMmeJLM3fDUujq+Ugs?=
 =?us-ascii?Q?tjKrQ3G0CEyiVnvbxt1qwI8j?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:59:29.2336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbd1aa5-7e35-495f-ab64-08dc60708cbf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4128

Add support to enable search for confidential computing blob in the EFI
system configuration table for KVM-Unit-Tests.

The SEV-SNP Confidential Computing (CC) blob (GHCB spec, Table-5) contains
metadata that needs to remain accessible during the guest's lifetime.
The metadata contains information on SNP reserved pages such as pointers
to SNP secrets page and SNP CPUID table.

Having access to SNP CPUID table aids in providing CPUID #VC handler
support. Also, Determining the presence of SNP CC blob in KUT guest
verfies whether OVMF has properly provided the CC blob to the guest via
the system configuration table.

Put out a warning message in case the CC blob is not found.

Import the definitions of CC_BLOB_SEV_HDR_MAGIC and cc_blob_sev_info
structure from upstream linux (arch/x86/include/asm/sev.h).

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/linux/efi.h   |  1 +
 lib/x86/amd_sev.h | 18 ++++++++++++++++++
 x86/amd_sev.c     | 30 ++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 8fa23ad078ce..64323ff498f5 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -69,6 +69,7 @@ typedef guid_t efi_guid_t;
 #define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
 
 #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
+#define EFI_CC_BLOB_GUID EFI_GUID(0x067b1f5f, 0xcf26, 0x44c5, 0x85, 0x54, 0x93, 0xd7, 0x77, 0x91, 0x2d, 0x42)
 
 #define EFI_LOAD_FILE2_PROTOCOL_GUID EFI_GUID(0x4006c0c1, 0xfcb3, 0x403e,  0x99, 0x6d, 0x4a, 0x6c, 0x87, 0x24, 0xe0, 0x6d)
 #define LINUX_EFI_INITRD_MEDIA_GUID EFI_GUID(0x5568e427, 0x68fc, 0x4f3d,  0xac, 0x74, 0xca, 0x55, 0x52, 0x31, 0xcc, 0x68)
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 4c58e761c4af..70f3763fe231 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -106,6 +106,24 @@ struct es_em_ctxt {
 	struct es_fault_info fi;
 };
 
+/*
+ * AMD SEV Confidential computing blob structure. The structure is
+ * defined in OVMF UEFI firmware header:
+ * https://github.com/tianocore/edk2/blob/master/OvmfPkg/Include/Guid/ConfidentialComputingSevSnpBlob.h
+ */
+#define CC_BLOB_SEV_HDR_MAGIC	0x45444d41
+struct cc_blob_sev_info {
+	u32 magic;
+	u16 version;
+	u16 reserved;
+	u64 secrets_phys;
+	u32 secrets_len;
+	u32 rsvd1;
+	u64 cpuid_phys;
+	u32 cpuid_len;
+	u32 rsvd2;
+} __packed;
+
 /*
  * AMD Programmer's Manual Volume 3
  *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 241e1472e333..23f6e3490546 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -69,14 +69,44 @@ static void test_sev_es_activation(void)
 	}
 }
 
+/* Check to find if SEV-SNP's Confidential Computing Blob is present */
+static efi_status_t find_cc_blob_efi(void)
+{
+	struct cc_blob_sev_info *snp_cc_blob;
+	efi_status_t status;
+
+	status = efi_get_system_config_table(EFI_CC_BLOB_GUID,
+					     (void **)&snp_cc_blob);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!snp_cc_blob) {
+		printf("SEV-SNP CC blob not found\n");
+		return EFI_NOT_FOUND;
+	}
+
+	if (snp_cc_blob->magic != CC_BLOB_SEV_HDR_MAGIC) {
+		printf("SEV-SNP CC blob header/signature mismatch");
+		return EFI_UNSUPPORTED;
+	}
+
+	return EFI_SUCCESS;
+}
+
 static void test_sev_snp_activation(void)
 {
+	efi_status_t status;
+
 	if (!(rdmsr(MSR_SEV_STATUS) & SEV_SNP_ENABLED_MASK)) {
 		report_skip("SEV-SNP is not enabled");
 		return;
 	}
 
 	report_info("SEV-SNP is enabled");
+
+	status = find_cc_blob_efi();
+	report(status == EFI_SUCCESS, "SEV-SNP CC-blob presence");
 }
 
 static void test_stringio(void)
-- 
2.34.1


