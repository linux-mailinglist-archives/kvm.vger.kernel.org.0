Return-Path: <kvm+bounces-58726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10261B9E94C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BD611BC2994
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AD92EA720;
	Thu, 25 Sep 2025 10:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hvmCntKD"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5EE26CE2A
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795094; cv=fail; b=srf+f4qTzRN84jzKJHR3AihJrmUtjPyrjAcnxpaXfFLlp1tjzPi+16p0vWVdaNbXQ44HL60jRDeNcih29IhXMlOMAMv9CjxENCYbBcBNmhnCtkHD6N/hXk48dxjLdGV0T8MlQCj6Wpcsh9aBOJkPmDZDJXMSQ5n9Fa7ZL8/TnN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795094; c=relaxed/simple;
	bh=+Hrjdcl9hYVtDTxH+p927miEhixUGUL0rI7BY2vL6cs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqj/Arv9vNkvHz1HdbJ5k7yMwVANKJ0vf7J9593BjKQ6pxxfdoXgcMvz8r035s3I2FK/ZdRGc6kC0eCQO5l+sQXcqiHj1Gumgvf1eb6WcWgfjvAvln7TWBkFDd9kFOu30vMwRX+pX6w/u156Busubs80teSKjOoDZosJGeI0eng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hvmCntKD; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A0vxyuum1zSIHhsg8DTLgciIrlmKvapdrP9QYLrmhWzeZLUD+aiJYUXto7VhDerttCAak816acIphN+aBt4eZlrTwNzC7FiuasbvQM7MECBXqyfRpyo+MCRthVyzCHjipLwN+id7b4aM8Rnxu48vo3aAe1iI+yEHNJKTQ9VG48tNl2Lm0yjrk7FNnlDy1KFrYmKkrgR07kwoMKYCCeEHNceDE7WjhK/lJuXMXIdBgdzCFkPrbQbrdLCz9KgiRlcONPXZ9BBlWcQXSl9je65yT1wApNMWRX59S9WAE1kKij5aXTigzWlxXvZy+Pcm4/uHKF1TCfWsubMhS8u3y0zo5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNh2/nJ6sq2xVAtMU45I8tsOG0e8T/EUYDQjN8iR0HA=;
 b=BMk2knBV1MkcqmD2QC694fCcV0B/nOajsGV6MaB1oymG/duY9+fDBAdj5pKVJVG5qVwnRoHEdxxOZdyy5HZmrsFPx0N5CdcLy1qSwDuXgUDLhzCKW/rnShSEpwKvIq8m62y97Dur1R0T9+PwKGOPZM1ktvNE3czuRYOdU71nvtfWpGjDTljN16I8xHF94qiGIIGRiuadPRtjYUGn1E/HLotww1ect84W9goYIElqwdNMm1NnuVJhjYXbbvr4zCBUq8Y52cVhwKg0Gawz2FqSeQ1qthbOp75jijswQqVPyuDVyBvM0qc1v5+G8+dDe5hIMOy1OvLqupBT0xLpBfZCZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNh2/nJ6sq2xVAtMU45I8tsOG0e8T/EUYDQjN8iR0HA=;
 b=hvmCntKDj7Se9bLSdFGlE2yNZS8skmRgFZHqHK9Wd6qpx068ZsNqquZGQ6gzIzFnRukcGDekz8x362wghEGgabF6mZOTHgEbuPfqCem6qWAjbZfhiHFGweuTjsCQX0FsDlHjq46y7bOYsnaAj0l0S9eYGrQgoJUaOxh1CQtNI0s=
Received: from CH2PR11CA0004.namprd11.prod.outlook.com (2603:10b6:610:54::14)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 10:11:26 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::67) by CH2PR11CA0004.outlook.office365.com
 (2603:10b6:610:54::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.22 via Frontend Transport; Thu,
 25 Sep 2025 10:11:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:25 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:22 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
Date: Thu, 25 Sep 2025 10:10:52 +0000
Message-ID: <20250925101052.1868431-6-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250925101052.1868431-1-nikunj@amd.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: e0235561-ba58-4d40-05f4-08ddfc1be2f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lZ/HleJCcO6WzSbtHJRE2fwRpZ8hn4Oc4OKwsVpDTDKNb3CGdsg7hUDucSkq?=
 =?us-ascii?Q?5sBvKdr5ZrV4g7MvykNOl1doAhh3aJHupEAvPVI1EWkp5AH6Q5E1DrjmASgM?=
 =?us-ascii?Q?9joLnZ7fNHMyFz9C4N7t7vXqvJGDBzFAbm0GlNfou7y4PU0+6f1fHVB6+1Cl?=
 =?us-ascii?Q?k8Kjb01ok4KJh/OoPuHWNj2bI5sDtYHv4l9mLZhtsNc31Dg3JdaaTH+eHEo6?=
 =?us-ascii?Q?WtGWREsMmVBkwFYpzeSFq7sH4DLRyKOomq7y7UOaHLd3r6WPULhUL7BR95Md?=
 =?us-ascii?Q?sn081Ys5DScHKjD5+QnV3ianzoN0Mm27WRXZGEFf9j/1PgOM4C/IlJAI72fo?=
 =?us-ascii?Q?NQmi6e4Px4WA6wNgYy2bhTiXmzH5bwc9yUYlPpQ7/5vUZjrfqve4wOvGlue2?=
 =?us-ascii?Q?dITJTrV04h4XNkr/Fpg5zLTE+9/voThNyiQbEOUSRsO2sz2i14FumheiwnP0?=
 =?us-ascii?Q?1jTEIAHbL7ZW/ny/p664b1EeYiOgavHz67o3Sum+vnQSJFdQ9i79dJbk7ZAL?=
 =?us-ascii?Q?HaNp0wKvPMjURUHLgvsteCt0MDqatILF2ToNQ35wFdq7FxZqQXj2clemTO3R?=
 =?us-ascii?Q?MaaDap6wz8/piL4cfZoCeyinu6ZFdcv4gOHai7nVYWUT/34vlLRxtgECJfgQ?=
 =?us-ascii?Q?V/gRyIwOSkizfCnOPbkqsaSOi4Q6PhcW3RQNFjFkSFgu5jKP+8MGrNfKZ8gN?=
 =?us-ascii?Q?gWTFiDn6Kioeq8+CByWCZKkCeqh8/L9ieCYo5jFiz+bes4NycbRGECVeDFpO?=
 =?us-ascii?Q?IWvWqX5PLPk1WxExsc4IZkFhVHniLibqcYzQN8pdz25P+4Z+JdgvGcFGjpsf?=
 =?us-ascii?Q?bJTRf3Wf2mO197vp3cOwttONwbr0PiSTJpH3v06m+Zd7JTDHq6sxtEs1RdGT?=
 =?us-ascii?Q?SfG2dqzsn3rJ+TRRGBUPdadKlItlZv863/ahGjgOIn7X+hiVYbslgVyDdJby?=
 =?us-ascii?Q?fVgFC7gTAne305B7Js0HzT/YAhCNTyONpnINpo/bFHpghi903u5Hgph5TCSD?=
 =?us-ascii?Q?+0RXiPloiDibtlI8OHZhhulitLkpq5gMtJ2kaA9yFdl1DCG0eVsgkLutUqes?=
 =?us-ascii?Q?09jq02HfSbvEIYvr/IB4kmPmmDcZMANkKXOWeRwYVxn7iGdsDhOKGvcssu/U?=
 =?us-ascii?Q?a6zr3wa9iSvRV2FGFTaX76rfr80abvC2PMtAopRvA0/IG8tJEqbCRlNfHuDy?=
 =?us-ascii?Q?HIvY2/4tx4RcgNigHCkB+5RXBcY8RsEnhTzL1f2i4YbHR2DIqOLb0rG2DjAG?=
 =?us-ascii?Q?hntoGkTU8cFQfT4s5uFqWy0hiVX5nUuPpfvku8QFA7kMl5JpUYgArWXHwMZt?=
 =?us-ascii?Q?tm5asS5x2so0LvYZiOnMdYHHe/pw3f8kUMFGiFZgqHL/KZBoiuayQ101zcDR?=
 =?us-ascii?Q?12GD9sySbC8M+fJVOIfZn7UJODKSPvePJAV9Lqkr6iFr0Lt5u2owfcYOCzRD?=
 =?us-ascii?Q?2S9cXuaoS+NfD4wr2qh4B1aG5TMaNFLJqd1MtSzopZqdzKCn2WPWMEMo7sTw?=
 =?us-ascii?Q?F0jcRIUg8DJv1N0K4FHf4MBddacZym5GGC4g?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:25.8237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0235561-ba58-4d40-05f4-08ddfc1be2f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

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

Disable PML for nested guests and defer L1 dirty logging updates until
L2 guest VM exit.

PML is enabled by default when supported and can be disabled via the 'pml'
module parameter.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h      |   6 +-
 arch/x86/include/uapi/asm/svm.h |   2 +
 arch/x86/kvm/svm/nested.c       |  13 ++++-
 arch/x86/kvm/svm/sev.c          |   2 +-
 arch/x86/kvm/svm/svm.c          | 100 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |   5 ++
 6 files changed, 121 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e2c28884ff32..6be641210469 100644
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
index b7fd2e869998..b37a1bb938e0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -740,8 +740,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	/*
+	 * Copied from vmcb01.  msrpm_base can be overwritten later.
+	 * Disable PML for nested guest.
+	 */
+	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl & ~SVM_NESTED_CTL_PML_ENABLE;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 
@@ -1177,6 +1180,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	}
 
+	/* Update dirty logging that might have changed while L2 ran */
+	if (svm->nested.update_vmcb01_cpu_dirty_logging) {
+		svm->nested.update_vmcb01_cpu_dirty_logging = false;
+		svm_update_cpu_dirty_logging(vcpu);
+	}
+
 	if (vnmi) {
 		if (vmcb02->control.int_ctl & V_NMI_BLOCKING_MASK)
 			vmcb01->control.int_ctl |= V_NMI_BLOCKING_MASK;
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
index 8a66e2e985a4..042fca4dc0f8 100644
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
@@ -3206,6 +3231,55 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(!pml))
+		return;
+
+	if (is_guest_mode(vcpu)) {
+		svm->nested.update_vmcb01_cpu_dirty_logging = true;
+		return;
+	}
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
@@ -3282,6 +3356,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 #ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 #endif
+	[SVM_EXIT_PML_FULL]			= pml_full_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3330,8 +3405,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3562,6 +3639,14 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -5028,6 +5113,9 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	if (pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
 	svm_srso_vm_init();
 	return 0;
 }
@@ -5181,6 +5269,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+
+	.update_cpu_dirty_logging = svm_update_cpu_dirty_logging,
 };
 
 /*
@@ -5382,6 +5472,10 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	pml = pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
+	if (pml)
+		pr_info("Page modification logging supported\n");
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70df7c6413cf..ce38f4a885d3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -216,6 +216,9 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	/* Indicates whether dirty logging changed while nested guest ran */
+	bool update_vmcb01_cpu_dirty_logging;
 };
 
 struct vcpu_sev_es_state {
@@ -717,6 +720,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.48.1


