Return-Path: <kvm+bounces-67004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F2CCF215A
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA38A30094A5
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53401248F6F;
	Mon,  5 Jan 2026 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5OOpVRMi"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010068.outbound.protection.outlook.com [52.101.56.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779151C84A0
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595041; cv=fail; b=F/eklYhJEqwUh4kqmmq3xLWsgir0OTSHIiSrBhLEk+cS5KCLqLPjyNnaH1OOPrSzQ6IRor/EyMZ3fc/qNJ+l1To+azciLsJI1Ox/vaKlG+D7QR1xCvUADJNG3tiPyTJ+zRuYE3xK/WHbxUSZ67vOr5hIuKv4PXd7UKfLA0/4JhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595041; c=relaxed/simple;
	bh=qcf8BBb0Y9PeIgYl4579qsVYXKQdWRhc8Z4ZVW4v/lQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1C8/rjWMfgzyTnwGfwuCJjm4Vs1KOxRUBAy08xbwAzfKCbQmHTl4sI1OMTcgyUz3LMAnICh8nfGHtIV687M0Lh9ytRi3IVXqVR0pVSLPEs+9PwAYy5dU2/GF+i3Y9htU5vqZiFo+UTVzLWScWOQDPmZoen8IilO8UWjTb0H1bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5OOpVRMi; arc=fail smtp.client-ip=52.101.56.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJt+CTP9BG9tfv9D7+JY0DoZemtlWUikRLtA+9SfTFioSkON2LQVNiwByLQEhdSOH92kEsLYFDsQXkZMjvlv4SBjfCeNc/oYQWxXM4PPe5EL1cZbvpo3/3eEOZmfYoOyUK2glDrrzsXWpweFwZtasf14sc3xsq476hzwVbVHfxqGcfJYAO5JuY9UTpdIQreJBko8vBInwTylznq+Vy8kVBguwk4KRwCvj8xz6t1qQKUmqqo0R0jZSwS3glU3sIR7C3a0iSMgser5zBdTsfodGUH5IxXuDsUEke1SGhYpGEnCUjn507MROK6p8IgTob2FGedJgLXAkfWe1OXdlhlO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfA3GpHRx4j41HwswZWxCzr92QiAwBTzJjSVsghD2Oo=;
 b=XIiiTu1dcB2SKx2TnFFSayZ9gKeLeHtnlkVEmrvVcNIHj4V1zIHVa+9DqDxYaTLVWvq1Pc/mB6oKxU4vhkR57nIuc8BdF2EFzfLxx+mOGq/e9ZdZvTqjyJfvZIJkkfemi/pVDaj3MKavie9DeblSBT7DpxJjWCgCQnRnuLcnoGu0wpmSoRzzyGwf9BPvcaGuqpbCKAPrbHdx5iS/VPFG6vpPGimJhkZdBrVM0S6KSATpxsRUyX3rWnUtvGKw/x9/4YKr35udx39qmPnXSXvgSFy9twFRxUtlB08erMK3WdLKg5cRXMZUCEuCapXrCcEcxBcKJ8QuxG0bX0/MuXTtzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfA3GpHRx4j41HwswZWxCzr92QiAwBTzJjSVsghD2Oo=;
 b=5OOpVRMiGqdlDnOGYq9zC2T4i8nvMqxAlDjRFK6B5eh2SwOK7jQgGHV8U9q/gUdjSWhFBoPfAKa2qLM9/4s+KPN40NBSiS+P3DpZ9D7Zu+tSipMrp9pGtL/+mx41QF2mA7MBnMto8MVf/lrdk3pfaR3I5cOoOLdB36WQhJobCxQ=
Received: from DM6PR13CA0014.namprd13.prod.outlook.com (2603:10b6:5:bc::27) by
 IA0PR12MB8981.namprd12.prod.outlook.com (2603:10b6:208:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:37:14 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::1b) by DM6PR13CA0014.outlook.office365.com
 (2603:10b6:5:bc::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via Frontend Transport; Mon, 5
 Jan 2026 06:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:14 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:37:10 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Date: Mon, 5 Jan 2026 06:36:21 +0000
Message-ID: <20260105063622.894410-8-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|IA0PR12MB8981:EE_
X-MS-Office365-Filtering-Correlation-Id: 235ee758-bf02-445c-6642-08de4c24dcd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kxA3VQ2YljnzOjzE2sphhBp5EYl2FlKL71fJVAOHX6vQkzdhuVgd+JQ2oh5g?=
 =?us-ascii?Q?H505jk7oFF9oAf/pvrp7vJM15zy+Pqd/wy3CZsrGiOiDIxLCf2nzf9x2LQxV?=
 =?us-ascii?Q?BtBvS3TYQ1Zth+4J/9GetiZyaoom4selT0T615ye6hZm80PYFg2VteOAhOZP?=
 =?us-ascii?Q?q7BAqM1N/lgXZ/RItVoplboNmf2q3zezeN/yg7PaI0ZaDXl7JlVPRHfkAg5M?=
 =?us-ascii?Q?R4FekBRYhxVkkn8CJ3fuAcAylyws7Eb36Gt1kyX6NRqz4VR16iRZ9oIX3v//?=
 =?us-ascii?Q?yLRONTCfZ/eNdWeAZ3fPBzSKtPBOPYQxBtDGGIPk8bqxSKJ1/RsVcbO039Dm?=
 =?us-ascii?Q?NEukbLhh8GGSRSYlNgXB5i72vnZaDeiKUKPXPV/Ei9cnzaVklJZnmNR1utS3?=
 =?us-ascii?Q?5kwfcoXr0o30a3umlkb66lI9a12OVPw4m36Rw6bb10XgKEw+G07ViSm2FoJU?=
 =?us-ascii?Q?chYaYhF2Bu3l91G2uc4DtjCezZFxWPORZrv2jE34sklpI1GrnPHZA4optADr?=
 =?us-ascii?Q?3jNNJcnSnGUb01be4tDllZjnTrD4mex+P17FJmA1cJIrb/YFkR7Cilj0zA4m?=
 =?us-ascii?Q?xN5VJ3PwaPzbiCyI5Gsvq7qhVgBW6zpE5ohp7d31MX6qbTDO4fcxt9HReJ/a?=
 =?us-ascii?Q?wwr7tVDPvAxMHAY+YRSRuXYi0oJgejuWHeV+6uPGluDop+Z81HX0MlzwMLWy?=
 =?us-ascii?Q?+OX9hjwBOPiMz/PeYwI3CRQKFRWN1q1zewCjiN33ED3wP+gVKN43/MEYfwSk?=
 =?us-ascii?Q?16wh/ZHPdcMHOEczMotupne0+ntzipMktp+j6VgoFcDw76B1n4GlCwltsCcc?=
 =?us-ascii?Q?UdHXFhJrbs46zso12a8MyHnDqLE0RQ7RncUnUR74C2ARxU5YMRwp5gryJ3ya?=
 =?us-ascii?Q?GUdhaJ6zDarAcFrAiYH01BG/NILr9A/o0U4DPDdGTCS1R4Bp15UembARS1Pu?=
 =?us-ascii?Q?WRbrZHh6rozcZSOVe+q9CVRNXO0rckwpe18sMFjBtYU7Oy2OtJH70gIQbCfn?=
 =?us-ascii?Q?k2z76n854gBpCkagppL+x/lObpOigNLUbBV7euMo8t8lW/VertiAyjCHl674?=
 =?us-ascii?Q?npCh7jO9dm4J28u8TAPQbmGjU/tQpofj3UgEulGfGfx7BHjTUpdHyEzeeECY?=
 =?us-ascii?Q?TIDcI0cArBjuW8/0ahdpG7joUlciyTpAgghdECacTL1xSjIqYvoQlyCJItKe?=
 =?us-ascii?Q?jHrbXdorZLGYfiflv2sJpiajbkibIUfGRLsg7cmFc8sDERkumU4XWBHccQHg?=
 =?us-ascii?Q?I1LV5+CyGR3j+6QIz3f/VJnuZY1VfUeSZq9r8o9POTwZNT7Wve5iLZW7H0Z7?=
 =?us-ascii?Q?VFvEl01/aRF6CktoGoJEriVfHOTXWu/hre+P22gPkETEJDFaR1qj37v0Wrid?=
 =?us-ascii?Q?U0TTz73Ocf6AAB9iaORLD2XKBSZvbtW8IfdJ9uyw00+GcI7ApdMZ3FdvfsaI?=
 =?us-ascii?Q?VRg5jB7lV6jfabOfKI8HZEJ5kuaaSUBMLNU6+eOZfz0TXnF7aAsidC5H/u8h?=
 =?us-ascii?Q?w8g5qCfcmsLWOg5sLEmy1Eg1IJuRlvTmNlbtEBYv8YrxrJKeLYmcXyqrAfs8?=
 =?us-ascii?Q?bTPuNItrOg3HyVyk9G4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:14.0156
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 235ee758-bf02-445c-6642-08de4c24dcd9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8981

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

Disable PML for nested guests.

PML is enabled by default when supported and can be disabled via the 'pml'
module parameter.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h      |  6 ++-
 arch/x86/include/uapi/asm/svm.h |  2 +
 arch/x86/kvm/svm/nested.c       |  9 +++-
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          | 85 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  3 ++
 6 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 751da7cbabed..6bf88fe8ac7c 100644
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
 #define SVM_NESTED_CTL_NP_ENABLE	BIT_ULL(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT_ULL(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT_ULL(2)
+#define SVM_NESTED_CTL_PML_ENABLE	BIT_ULL(11)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 650e3256ea7d..6c41b019d553 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -101,6 +101,7 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_PML_FULL	0x407
 
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
@@ -236,6 +237,7 @@
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
 	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_EXIT_PML_FULL,		"pml_full" }, \
 	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
 	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
 	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372..c1eb64fcc254 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -748,12 +748,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
+	/* Copied from vmcb01. msrpm_base/nested_ctl can be overwritten later. */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
+	/* Disable PML for nested guest as the A/D update is emulated by MMU */
+	if (pml) {
+		vmcb02->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
+		vmcb02->control.pml_addr = 0;
+		vmcb02->control.pml_index = -1;
+	}
+
 	/*
 	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
 	 * instruction; otherwise, reset the counter to '0'.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..ffcc7e28d109 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4785,7 +4785,7 @@ struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
 	 * the CPU will incorrectly signal an RMP violation #PF if a
 	 * hugepage (2MB or 1GB) collides with the RMP entry of a
-	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
+	 * 2MB-aligned VMCB, VMSA, PML or AVIC backing page.
 	 *
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..920c7dc52470 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -170,6 +170,9 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+bool pml = true;
+module_param(pml, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1156,6 +1159,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
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
 		sev_init_vmcb(svm, init_event);
 
@@ -1220,9 +1233,15 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!vmcb01_page)
 		goto out;
 
+	if (pml) {
+		vcpu->arch.pml_page = snp_safe_alloc_page();
+		if (!vcpu->arch.pml_page)
+			goto error_free_vmcb_page;
+	}
+
 	err = sev_vcpu_create(vcpu);
 	if (err)
-		goto error_free_vmcb_page;
+		goto error_free_pml_page;
 
 	err = avic_init_vcpu(svm);
 	if (err)
@@ -1247,6 +1266,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 error_free_sev:
 	sev_free_vcpu(vcpu);
+error_free_pml_page:
+	if (vcpu->arch.pml_page)
+		__free_page(vcpu->arch.pml_page);
 error_free_vmcb_page:
 	__free_page(vmcb01_page);
 out:
@@ -1264,6 +1286,9 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
+	if (pml)
+		__free_page(vcpu->arch.pml_page);
+
 	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	svm_vcpu_free_msrpm(svm->msrpm);
 }
@@ -3156,6 +3181,42 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (enable)
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
@@ -3232,6 +3293,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 #ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 #endif
+	[SVM_EXIT_PML_FULL]			= pml_full_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3280,8 +3342,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3518,6 +3582,14 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	/*
+	 * Opportunistically flush the PML buffer on VM exit. This keeps the
+	 * dirty bitmap current by processing logged GPAs rather than waiting for
+	 * PML_FULL exit.
+	 */
+	if (vcpu->kvm->arch.cpu_dirty_log_size && !is_guest_mode(vcpu))
+		svm_flush_pml_buffer(vcpu);
+
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -5003,6 +5075,9 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	if (pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
 	svm_srso_vm_init();
 	return 0;
 }
@@ -5157,6 +5232,8 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+
+	.update_cpu_dirty_logging = svm_update_cpu_dirty_logging,
 };
 
 /*
@@ -5380,6 +5457,10 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	pml = pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
+	if (pml)
+		pr_info("Page modification logging supported\n");
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..c1e4e9a0c6d7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -50,6 +50,7 @@ extern int vgif;
 extern bool intercept_smi;
 extern bool vnmi;
 extern int lbrv;
+extern bool pml;
 
 extern int tsc_aux_uret_slot __ro_after_init;
 
@@ -718,6 +719,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.48.1


