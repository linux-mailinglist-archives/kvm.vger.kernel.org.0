Return-Path: <kvm+bounces-59875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D5BBD1ACD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 92EDA4EB965
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7072E2296;
	Mon, 13 Oct 2025 06:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pw1SlO6N"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AFA2DCBEC
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336780; cv=fail; b=FrSbWO8O7o6ymuJwW43a30xTw4ytE3l2ZAG03l8yAQzgNvxfUcM8s4kvLNkihv7tzJMa9d8p+gLp+4RQWPpEUJiFdA2USfh0sOvJK4s5XXCjG0PY5syQWjtwKIU0Dk/yg4+RRv6AW0aObTomlsnrJDdhRLGYQeiorrre8fGAgss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336780; c=relaxed/simple;
	bh=OuhhYm5LK1g+nisGWdFyjwSUrbIClF9yJuK6IJCw4Vw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnsAzxBs+fW9d/oaoDQzrq/D5aO/2VwjxxiUMioTw5lieDIYYAdgqRGdRHh/A3clSnMVaqsRyQcg98PZ66kW7fjCrL1O2HWxP11oRN9OI5pfwvZOGKoypZJ3lwDbFDJLvlZsWEeZ/TY2mHWmX1T9VaiPxIsadntZq7sPin81nXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pw1SlO6N; arc=fail smtp.client-ip=40.107.201.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFHWJhldlU9WptI4U0KjaQH55HKeJkdrxeYqrW0lK2qtpSo7zMHKBu45CyQa+6hKLtJFYxvSr/FfN5cu0yVGIKZSAdp5m1Ka1MRJ/BKnIoR9tJVGM2siUClI4jdCVjDmdE9OXrNVq8I4DuR4xnL9QgtEwhDuG6XLYOYsDDIUi3PpCFYjhwWM9ttoGMzDPscLfkvLHfrzjyLVysO7XXGYKwhYWGK/8x67W5V7feDzMMx2S22kdnETlddpIsQpYw/AaYG/F63wk9/d2K4GapyGjdp47DKcukwDrsCguwgeof519aIxH6m+E6PAA/C7yxLi5V+i/jvwAu9gFFvTkPTRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJRdFXaDZlK8sOn8cJKk1adY/z+tIyDseyD1ht8ByMI=;
 b=kevFDMb3VERX+kCx5ks7KSDVsd5TDTHuMgU/MJRFK7/gykRmQGlbAkq803LVuKGEQyPRqOlxSE1E+bbjSirqDrG5dz0LRQ2ki0zCkSBQmvssSBJ/pCM2oUtCIT83GYA+XhobReaqHF1Gg0mBkV7HM4cdmDATcVzApusQAPvSMTLk2HEKuvBAzEbx73aLfk/9nuGTi9hvUDdufqoimexMFpYfZejAWcA+h97EWLcvffzDKxv9gdUNz64GEiEGbBKHbpht3be6wyNcs6ZX6Jp2b05rjYQIgsPncyEtGYgtFIFrGVGGJ04mKlnkWMgI2Xy1zeSZQrvvNzR5A78D6vJO3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJRdFXaDZlK8sOn8cJKk1adY/z+tIyDseyD1ht8ByMI=;
 b=Pw1SlO6Nd67cNLKGCDrpzEDRkEjIXbiMNVUTKrQ3w7inUlw3FfABEi976aNpPPsigGsXqVQPqYnMrcXRYiLDanTn1jn9HRu53S6dWkWq9WSwOJQvWRL+xIOwZG4Y0R9NXwb54tVAwpGVnSw7Xv+M99uy0nC+rZSbqDd2xUkiKCM=
Received: from CH2PR08CA0003.namprd08.prod.outlook.com (2603:10b6:610:5a::13)
 by DS7PR12MB8229.namprd12.prod.outlook.com (2603:10b6:8:ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:26:12 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::40) by CH2PR08CA0003.outlook.office365.com
 (2603:10b6:610:5a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:26:12 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:26:03 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 7/7] KVM: SVM: Add Page modification logging support
Date: Mon, 13 Oct 2025 06:25:15 +0000
Message-ID: <20251013062515.3712430-8-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|DS7PR12MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: 778766df-0c27-4eac-6691-08de0a21679b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J9fOtZAqfWrPfYNnlEE1hwUPkj2XsXkcVlMHvbM53+Vcvi/wY5VHmlghscgC?=
 =?us-ascii?Q?yY1twfaKAcFssMp7KOzAsOdkjAWIOBBn3E6qSRYlgraXVDwkOmcMwg/5C1vS?=
 =?us-ascii?Q?pKx3dlgjsT8Zlc2L/P55IrekHFWoIpEiE1ZW8b4dagWc5lS1x+NuVaiqIZXN?=
 =?us-ascii?Q?WX5qot7+A0YKHCGwkAOD+b3QSU8wWIpqegXIjZgfJlXxCYkD+XCZnbmvZHPy?=
 =?us-ascii?Q?alvZSthQFs2mVVGuA5/AI8FYUIYPGG6TNjTbW4yt+/G9G3KL42aE6qAox8OK?=
 =?us-ascii?Q?gx+GLSfkzxihrz2hDsw/ciFVdeA/8u36wFcuyz00VsqudIraXGfiTzPFEREf?=
 =?us-ascii?Q?zOwJPZ9O7ngYJvIp1xyGObhkExP8ibqJw4EUKHbTneEZROMqw6ixv5Cmr36j?=
 =?us-ascii?Q?Tsi8jnp3A+1Tpx7rCzddm1nPwInpjE13ygcAQNTBhdsDCXHpL5AaGaFFV8FJ?=
 =?us-ascii?Q?YEYQrVK2FDwfU9fLKVfgcDDPtNKrIQzn35b6eBn0W60+4BHgPZZ6zjbRtpV1?=
 =?us-ascii?Q?bPx5x5ScyUuG0lW7fodo8naspwUHgaEZcoChrCurc5fk/bcd/zkxnRaU5VL5?=
 =?us-ascii?Q?xj/pELNu5Un0E97HtdZj6XZIO0297Lx9wl5RnlhpZ1FSobodYJzM+lhIrGtq?=
 =?us-ascii?Q?ggn2Uu2UVwCoZ7airQUqfh1fnjp3p24FJH8xmP1RuUH7dCmwg+W3Hi/6vLmS?=
 =?us-ascii?Q?0pxVWQgTU4UTT24eH3qYobr/rHn+AMx8cpvTzd2lBIs3VZofEr8okqV6Db5d?=
 =?us-ascii?Q?grLrSLEAzu78k8uOGvG/dZjUiZ+yik3qq/BaO6/qiVfuerpONpojPsSprtGk?=
 =?us-ascii?Q?titQPg8r74e5hywdrZTGDVbZnq/2vE0WkE1bmPifOGo5gc+tndkpXsO/I4x4?=
 =?us-ascii?Q?yCXXLwdROhy9WKtr8wBJPAuY+eY+kqq91HZYMpRT000IdrzlsT6i+svM46H0?=
 =?us-ascii?Q?8/jj7PWhxGmzTbNY5KMSa5dFctIWLrb8PrVr9nVighcBA9BVYJpmyS2dI6Ag?=
 =?us-ascii?Q?pLyX5+/qRUo82UOcOHD0FlTG7qLGXQYtkAwxpJx2MjGXidGkwwCC4XWIr5i2?=
 =?us-ascii?Q?UA/ZT9+vrEG9h2hcey+4MSxddHqZRtk+M0HHLIKuCF2CUwxbEvuEHqfyNo/t?=
 =?us-ascii?Q?BAoPA+6QzoiHC4MLNihsKQEJgTHCK9RAXEikJCNGOkDA/MyzzoodnJaNUat6?=
 =?us-ascii?Q?0ZfyNT0gDV4Y0GWLy6Ck8QeYm8Jpd+vxd39Un7AjJ8N8yPVVM6pz9F1XInGU?=
 =?us-ascii?Q?K1Yy6/Od8AvVPEllIzBOGW6Ld+Kvf79ibISAnvfLx76dYqpfd9nUhGMtnLMr?=
 =?us-ascii?Q?cgiGFxlM1HazGul8hk2D+ZhiUlpvtj12SXYOQWz2x9qzAi/nTc5wNgetSJTl?=
 =?us-ascii?Q?uDAT4UAKPlppWcajDyVrlCoiuwZ6EBPnc9IJEqNnV6yTXLuSCzQ68ArBK/c+?=
 =?us-ascii?Q?xuj680aVhj11zB+7NA3C7c5aOrsl9DyONdwPQ1cG2Da42hte2clQOP/4LT7r?=
 =?us-ascii?Q?7po4oOFiiIZsARn1ztpEfkhmdZwrv6jsU+7jdtrdMPdBezjjo7dG+mcLAJ3l?=
 =?us-ascii?Q?XSC446kBSvmRiaQNBfw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:26:12.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 778766df-0c27-4eac-6691-08de0a21679b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8229

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
 arch/x86/kvm/svm/svm.c          | 84 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  2 +
 6 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index d2f1a495691c..caf6cb09f983 100644
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
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6443feab252..1f6cc5a6da63 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -748,11 +748,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
+	/* Copied from vmcb01. msrpm_base/nested_ctl can be overwritten later. */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 
+	/* Disable PML for nested guest as the A/D update is emulated by MMU */
+	if (enable_pml) {
+		vmcb02->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
+		vmcb02->control.pml_addr = 0;
+		vmcb02->control.pml_index = -1;
+	}
+
 	/*
 	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
 	 * instruction; otherwise, reset the counter to '0'.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..080a9a72545e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4774,7 +4774,7 @@ struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 	 * Allocate an SNP-safe page to workaround the SNP erratum where
 	 * the CPU will incorrectly signal an RMP violation #PF if a
 	 * hugepage (2MB or 1GB) collides with the RMP entry of a
-	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
+	 * 2MB-aligned VMCB, VMSA, PML or AVIC backing page.
 	 *
 	 * Allocate one extra page, choose a page which is not
 	 * 2MB-aligned, and free the other.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..fc7147024123 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -170,6 +170,8 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+module_param_named(pml, enable_pml, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1162,6 +1164,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
+	if (enable_pml) {
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
 
@@ -1221,9 +1233,15 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!vmcb01_page)
 		goto out;
 
+	if (enable_pml) {
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
@@ -1247,6 +1265,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 error_free_sev:
 	sev_free_vcpu(vcpu);
+error_free_pml_page:
+	if (vcpu->arch.pml_page)
+		__free_page(vcpu->arch.pml_page);
 error_free_vmcb_page:
 	__free_page(vmcb01_page);
 out:
@@ -1264,6 +1285,9 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
+	if (enable_pml)
+		__free_page(vcpu->arch.pml_page);
+
 	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	svm_vcpu_free_msrpm(svm->msrpm);
 }
@@ -3151,6 +3175,42 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
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
@@ -3227,6 +3287,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 #ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 #endif
+	[SVM_EXIT_PML_FULL]			= pml_full_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3275,8 +3336,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3518,6 +3581,14 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	/*
+	 * Opportunistically flush the PML buffer on VM exit. This keeps the
+	 * dirty bitmap current by processing logged GPAs rather than waiting for
+	 * PML_FULL exit.
+	 */
+	if (enable_pml && !is_guest_mode(vcpu))
+		svm_flush_pml_buffer(vcpu);
+
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -4991,6 +5062,9 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	if (enable_pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
 	svm_srso_vm_init();
 	return 0;
 }
@@ -5144,6 +5218,8 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+
+	.update_cpu_dirty_logging = svm_update_cpu_dirty_logging,
 };
 
 /*
@@ -5365,6 +5441,10 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	enable_pml = enable_pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
+	if (enable_pml)
+		pr_info("Page modification logging supported\n");
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e4b04f435b3d..522b557106cb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -720,6 +720,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.48.1


