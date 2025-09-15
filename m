Return-Path: <kvm+bounces-57530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E098CB5740B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A559D20034A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D482E2F5303;
	Mon, 15 Sep 2025 09:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XPEV/VuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C48DDD2
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926835; cv=fail; b=n4Orn9WPKIMp3Gu9LISDqWyZvhu801qn5N6s2BilpKtwcmkp35kA0RKRU8sAp8mWKgDmDN6yOzEzKz4GV6K8g7X8tQfOSuHeopHO0qeq4IHHkZLu4T4KIXHjaaMzwXfq6DgdjCeSYtql8eDpksHJXbe7AkbAh8Hy9/8yc71cMwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926835; c=relaxed/simple;
	bh=CfZcysmIdt/9x+UTbay5VCbGRRUjypQzSh2PV1Im7Is=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcPJHpnT5ZTZoHP2I+ru1HPtt8KzWSs4EXl8ILAlPyjdwRTNwtIsgQM5gYqBSkr3QUaqw5dzUFkzsBkbj4iQeiZ6yaPA/Tz9mJI9MZh/I3oaVtWVab1GQz8RqHzIbX7Iw3YQPL4M+kMfpgaJv3lCQM4ZQKH1EODo31VTUBlSfiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XPEV/VuB; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhMxYvMsHnS+F65T8zpbYKzWdjVVePlGDeKu+Zydd/Z/Gq7EsZLjyX517aykXFEGyVwVxcVGJSs9r+BPqg9KAZUCghQXy1O/n9ogqC8GOCEgmCB4uWJlv2r7eoAmuIaFUOROi/q3b7yDX7MpNCamxExta+CV5+EiAxLkGg6SpWsPLeFNJ86nqFEyvTgYDzOdmFg5mbsXcPNPcgkfI9oH4hCmC77tjnnwXtB8I6Uc0iChTu2RzaWD0uipxW0EyHUOSiSHZfjiJJS4hiB1c6SkC10yRiL9dFgnQ2UWozoL7C5Lfy3uoQSShjAjFWw9muXOud6AosXSUN0uQ8gi6p+TZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/5Xreij1HV9qgMDR8BXfXpUj69w0Yb/T5blxke01YY=;
 b=g1hy44eRIkjKrGBWuIOeiw1a5AZakoM/bTxOf9BG2ewcE1KRa1EBaDN3MAyKK+54wkTL2uT5qdFt5+33k6r3LQg02Tf08CSyuzWIpedkTS/p2/r+KzU4KxUQKf8kuvAzy9GZ+cAd6ptA1bO2BZZinEqZEyOOULVp+hB1+vbC/O9+an0R0f/OxdksAfU983VanOw4z6TTpYORP45IjxVLEmCyza3a2QOhev9Xok9Vvj8KbyGw5Iof3BXZrW4M5xzNxZ4W8ZWxDX632Pu00SZQNMg22mhQhVmcXMhGNIncjHF5MGDoBTEw9gb3pEX7Ia3y+epnW/auebiiuIDfYJO4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/5Xreij1HV9qgMDR8BXfXpUj69w0Yb/T5blxke01YY=;
 b=XPEV/VuBtRVu4XwsQeMUnbVW30bniR3wMbenPPclndahEiD06AKOirHzUY/SIztTK27JxARF5lZIdvxjHIxs45OM2bI9NyRUAfIxDFEznSH7Ix7wDrs0comutF5Nr9b1G3yoqgnr13kqKPymAOvdA3UoquJD9s+YukLAuE6rkYU=
Received: from SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::15)
 by LV8PR12MB9206.namprd12.prod.outlook.com (2603:10b6:408:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 09:00:27 +0000
Received: from CO1PEPF000075EE.namprd03.prod.outlook.com
 (2603:10b6:a03:41b:cafe::98) by SJ0P220CA0007.outlook.office365.com
 (2603:10b6:a03:41b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 09:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075EE.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 09:00:26 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 02:00:08 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v2 4/4] KVM: SVM: Add Page modification logging support
Date: Mon, 15 Sep 2025 08:59:38 +0000
Message-ID: <20250915085938.639049-5-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250915085938.639049-1-nikunj@amd.com>
References: <20250915085938.639049-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EE:EE_|LV8PR12MB9206:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c99d564-8cb4-42a2-75eb-08ddf4365049
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i75pmoHL+apBLB1R2aea0p4nHSRBm9SRMEsETUna7psvmmHo8pCMDTFZE6Av?=
 =?us-ascii?Q?kZPN3amd7dQkCYr8fgwGm3MkmtkyxNPPzyUEom5n4IcoKkZLOAIIGo/3xRZU?=
 =?us-ascii?Q?TZbz+U4geWYo7lHlXBN7oIepBQtyu+x5CseUl6UUiU0TBdF0U5RLstRtLGv7?=
 =?us-ascii?Q?ZAZx5/TDKIR8WmNNMub7x1WuwlI1bcv86Qz0CO3xhrelKwIObUGMKq5tBMnU?=
 =?us-ascii?Q?bWFRGgdxry7Jy6AC9MOUF39NTzIlvZwAglduU9D+zlo6VIX9yIHPHAMQe/Av?=
 =?us-ascii?Q?7GlFI52oA9241QA2bd2sx9Jbh9A+5d7v6tHuief9j0AdWg51Ry8IrPN93Qjj?=
 =?us-ascii?Q?vDJa09ICSQWm0ckN2CtIxOHH4RdvPXntS/UQWtG8AvIX2KBCovnR2+rvSzgG?=
 =?us-ascii?Q?kYGQRX1btfT1wGny8iTt4J7gOL+CaI1VkBsCXvF6GPHOSjXQFHdznUHoSzIx?=
 =?us-ascii?Q?iJZCWi7Vevgh6RkqFue2/2DWtSsVXvfMqAoxxafFev9l2PSZfTzR1gc1tlyB?=
 =?us-ascii?Q?PEeH6ICCzBffes0ImtPu5PI52SVuKO+fWvO12w3H043OgHw2f2ZMTRkyQ4Hw?=
 =?us-ascii?Q?rdjZnBAfWMwRNj/nZ87sYpm7ZVNDXam7Ze51pOEt2dxD8QVIraFbT77GS2ED?=
 =?us-ascii?Q?CJV8w8R7j9YZSdunNIyl9YB4mkVMlojxyue0gch/6cvaYc8DgNcaOlLNRZmE?=
 =?us-ascii?Q?ieeJqYsYxZKSivrAiu8WuevXhA6LEvw+a1ocnn82jqHEUuak0//L4YRJ9cVy?=
 =?us-ascii?Q?A6wXe2cnWiWzH66h1RTY2th/6eR5XA7Kaou0bCnFhEU0DY7ggu/esifshjzQ?=
 =?us-ascii?Q?/74tYdGoz3cuB7E20GNgHC837zUuoAB1Xiepg7aWvUY8rdl3EeGWxQHva8oe?=
 =?us-ascii?Q?YDKtGAr5I758kDPFWIRIcv53oVwin1SvA8iui51a7u9m0Uix+epBsKXnSwp8?=
 =?us-ascii?Q?Sv/2fxWt4Wfzl5s+GsQregXoLxvUG8yTu8D+QgnEg4i0hTj68F+i8pjL2mXE?=
 =?us-ascii?Q?JnmKe7kkIuQzo1zgyZWPBRDPZsgMklxrtgG5+aE4dD/gY1Cz1khkCEfI//cn?=
 =?us-ascii?Q?pVB3/YDs5Scw65OoU7nPwv0i2iZfGzutfTC50azqsUeCpR3lB6Y2lucGOdIH?=
 =?us-ascii?Q?fRouSsrqonF/t93ndYzwORqoq0It/nn52ps3cpaTHY+AqK4YE4ufoocc+eKp?=
 =?us-ascii?Q?ronbgxThBnvvqxKMNkNxfJCjqetpUF2qrAlov82fDI+PC+HNLH1AWpbOalaz?=
 =?us-ascii?Q?z+IAfzuEM3tYZNgPrq+tqchYwws37KyUpqYWws831U/xLcOvw3zBCrbj5717?=
 =?us-ascii?Q?JmF2S7IMJk9bhv/g/kklEPeM41sDY9wvBewfzGFO8NilWwwDa7DgkAxCuUO4?=
 =?us-ascii?Q?UDP8kpoerKEaYI1lboMBf2Ujm3HePEfiWoXIrDF5tGWrGTorUX6Je4zQ5k4S?=
 =?us-ascii?Q?G1oXYnpGlHHJkvdxbnmO4YntHQSDO+Kc1WBsAVHoaK47oyo3ZmgKddHPXk5o?=
 =?us-ascii?Q?LxNUzlf/x8EgRBPl2Dmd32XbiKRLIcp8k0gb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:00:26.7550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c99d564-8cb4-42a2-75eb-08ddf4365049
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9206

Currently, dirty logging relies on write protecting guest memory and
marking dirty GFNs during subsequent write faults. This method works but
incurs overhead due to additional write faults for each dirty GFN.

Implement support for the Page Modification Logging (PML) feature, a
hardware-assisted method for efficient dirty logging. PML automatically
logs dirty GPA[51:12] to a 4K buffer when the CPU sets NPT D-bits. Two new
VMCB fields are utilized: PML_ADDR and PML_INDEX. The PML_INDEX is
initialized to 511 (8 bytes per GPA entry), and the CPU decreases the
PML_INDEX after logging each GPA. When the PML buffer is full, a
VMEXIT(PML_FULL) with exit code 0x407 is generated.

PML is enabled by default when supported and can be disabled via the 'pml'
module parameter.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h      |  6 +-
 arch/x86/include/uapi/asm/svm.h |  2 +
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          | 99 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  4 ++
 5 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..9fbada95afd5 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -165,7 +165,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_9[22];
 	u64 allowed_sev_features;	/* Offset 0x138 */
 	u64 guest_sev_features;		/* Offset 0x140 */
-	u8 reserved_10[664];
+	u8 reserved_10[128];
+	u64 pml_addr;			/* Offset 0x1c8 */
+	u16 pml_index;			/* Offset 0x1d0 */
+	u8 reserved_11[526];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -239,6 +242,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CTL_PML_ENABLE	BIT(11)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..f329dca167de 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -101,6 +101,7 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_PML_FULL	0x407
 
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
@@ -232,6 +233,7 @@
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
 	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_EXIT_PML_FULL,		"pml_full" }, \
 	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
 	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
 	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5bac4d20aec0..b179a0a2581a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4669,7 +4669,7 @@ struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
 	 * the CPU will incorrectly signal an RMP violation #PF if a
 	 * hugepage (2MB or 1GB) collides with the RMP entry of a
-	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
+	 * 2MB-aligned VMCB, VMSA, PML or AVIC backing page.
 	 *
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8a66e2e985a4..a44fd68e3e23 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -178,6 +178,9 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+bool pml = true;
+module_param(pml, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1220,6 +1223,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
+	if (pml) {
+		/*
+		 * Populate the page address and index here, PML is enabled
+		 * when dirty logging is enabled on the memslot through
+		 * svm_update_cpu_dirty_logging()
+		 */
+		control->pml_addr = (u64)__sme_set(page_to_phys(vcpu->arch.pml_page));
+		control->pml_index = PML_HEAD_INDEX;
+	}
+
 	if (sev_guest(vcpu->kvm))
 		sev_init_vmcb(svm);
 
@@ -1296,14 +1309,20 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 			goto error_free_vmcb_page;
 	}
 
+	if (pml) {
+		vcpu->arch.pml_page = snp_safe_alloc_page();
+		if (!vcpu->arch.pml_page)
+			goto error_free_vmsa_page;
+	}
+
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_vmsa_page;
+		goto error_free_pml_page;
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
-		goto error_free_vmsa_page;
+		goto error_free_pml_page;
 	}
 
 	svm->x2avic_msrs_intercepted = true;
@@ -1319,6 +1338,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+error_free_pml_page:
+	if (vcpu->arch.pml_page)
+		__free_page(vcpu->arch.pml_page);
 error_free_vmsa_page:
 	if (vmsa_page)
 		__free_page(vmsa_page);
@@ -1339,6 +1361,9 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
+	if (pml)
+		__free_page(vcpu->arch.pml_page);
+
 	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	svm_vcpu_free_msrpm(svm->msrpm);
 }
@@ -3206,6 +3231,53 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(!pml))
+		return;
+
+	if (is_guest_mode(vcpu))
+		return;
+
+	/*
+	 * Note, nr_memslots_dirty_logging can be changed concurrently with this
+	 * code, but in that case another update request will be made and so the
+	 * guest will never run with a stale PML value.
+	 */
+	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
+		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_PML_ENABLE;
+	else
+		svm->vmcb->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
+}
+
+static void svm_flush_pml_buffer(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	/* Do nothing if PML buffer is empty */
+	if (control->pml_index == PML_HEAD_INDEX)
+		return;
+
+	kvm_flush_pml_buffer(vcpu, control->pml_index);
+
+	/* Reset the PML index */
+	control->pml_index = PML_HEAD_INDEX;
+}
+
+static int pml_full_interception(struct kvm_vcpu *vcpu)
+{
+	trace_kvm_pml_full(vcpu->vcpu_id);
+
+	/*
+	 * PML buffer is already flushed at the beginning of svm_handle_exit().
+	 * Nothing to do here.
+	 */
+	return 1;
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3282,6 +3354,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 #ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 #endif
+	[SVM_EXIT_PML_FULL]			= pml_full_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3330,8 +3403,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%llx\n", "nested_ctl:", control->nested_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
+	pr_err("%-20s%016llx\n", "pml_addr:", control->pml_addr);
+	pr_err("%-20s%04x\n", "pml_index:", control->pml_index);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
@@ -3562,6 +3637,15 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	/*
+	 * Opportunistically flush the PML buffer on VM exit. This keeps the
+	 * dirty bitmap current by processing logged GPAs rather than waiting for
+	 * PML_FULL exit.
+	 */
+	if (pml && !is_guest_mode(vcpu))
+		svm_flush_pml_buffer(vcpu);
+
+
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -5028,6 +5112,9 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	if (pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
 	svm_srso_vm_init();
 	return 0;
 }
@@ -5181,6 +5268,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+
+	.update_cpu_dirty_logging = svm_update_cpu_dirty_logging,
 };
 
 /*
@@ -5382,6 +5471,10 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	pml = pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
+	if (pml)
+		pr_info("Page modification logging supported\n");
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70df7c6413cf..7e6ee4e80021 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,6 +335,8 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	struct page *pml_page;
 };
 
 struct svm_cpu_data {
@@ -717,6 +719,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.48.1


