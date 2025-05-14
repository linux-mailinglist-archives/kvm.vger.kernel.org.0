Return-Path: <kvm+bounces-46445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4187AB643A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB3947B4E9A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695182153C1;
	Wed, 14 May 2025 07:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FqhjMcrt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE4205501;
	Wed, 14 May 2025 07:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207502; cv=fail; b=LoG0fPluJsGbno3lq70RrVVNSv7tzwIjKUYgSb3GTWekt9lxB/s1Z7N4Y2SnYW3C9CB5/fxrA/aUApgmgvWIKZicjqdANWibkcqrfGlkaPSCP3Do6NyeFR85WPatTXqxG28tbGfJCr6I98hDsGl4QNuCZETCVCdk430erIfugFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207502; c=relaxed/simple;
	bh=Q3UWE+ApeBO8lXF4JSaOp2L5CT093Zt2+TQG8JX0gmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5RZ2C+u7P01PUcSsyJT8YYHNWGBpRVMGL8eI6flu8d/WnNhsGGEMPLKz7ghtg7/MuaEIAoEa4V7OSqjrQsL5UyrW7LX9kfsBaSblvbt9umIK8B4ThkaOCpa01wgsVW1MWs/0Hm8QU8dY9b0LYMdx5q1bpIDWxzSp54/qT55g2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FqhjMcrt; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQkA8kBN2aS0gU72SPIlT9KV/NHf1eZiVild3SSfgcigd4qCHFyVSxIDsUoRCDza4IRZwPfR1XMBO8Rahnoe9CT1J4eZ4EqD3G0lo4r5vSWl+8ALiDCBD5MLJs0z17oGIl5eYpnnf12tWsOEERPdnv+kK5MVYux2HnuAZtZMNfPNrQqaGnkHOzjfCem51y6FTvlGhKUKtHlCZmhSvtAx/Bv9hvhujmqNCG8RSOaKYz4Iz2DejrX1P4wMJtt+PA+Sqw5fMWLkmbiZCEawBVE8pq3eDhIWkzN3CSG9HtU+FgQVuv9Sb+IxkqRcX2hc6XUdmtOkjlueza+MDbwrflN+lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+v2d0nuV/9zEt1cQCXk2Y2itlvJT5MXO0o2UjXZAC5M=;
 b=Ob8OAVkzPNF20qAdxsE/D9ChB064i8+0ZpWVL08t8DEhxg2FT1cVG79EFuEX0Sn1KUmulDXmLJE3GvFF6oXFU8IfIYcegFBRoD5l5fmeANuoMWY9uNdHexArcVex3FbDhLyjIjljX0Bs6xRNjYIFD8oiTvKp+5kdX7k8qWItLGCs/fj3dhDTX0TTjYTMXyj0aiQLncd5QY31UQuRBiXwFpZCbV5H5K5sOJHfcTnI3wvY3Gk70XIHSKTi1QQIMyDlptQo0MZYWhCepr+tu8EkCinceK0C3QLdGwd+k0kUmRe6nnNEXWB3wHQeDi6SdeViR4pE5NQ28x4xBv3wn+MT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v2d0nuV/9zEt1cQCXk2Y2itlvJT5MXO0o2UjXZAC5M=;
 b=FqhjMcrtWQoPXAPXquxTfWaxJKqx2dv1oH716j8KRQIW7fNUo+GIXO0dK5a7H6ybrAz7/h4SAdKQx6eX2oLq+h3uSKBh5wJwtgUvlXw74zAGAnDN9klzs4HhlK1gT+RZprXILVkvfO416+UYl3jlDjgJYc3TngjoNCbSMHFBiRY=
Received: from MN2PR20CA0039.namprd20.prod.outlook.com (2603:10b6:208:235::8)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:24:53 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::5a) by MN2PR20CA0039.outlook.office365.com
 (2603:10b6:208:235::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.25 via Frontend Transport; Wed,
 14 May 2025 07:24:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:24:53 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:24:43 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 16/32] x86/apic: Initialize Secure AVIC APIC backing page
Date: Wed, 14 May 2025 12:47:47 +0530
Message-ID: <20250514071803.209166-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca488ee-d098-4412-b72f-08dd92b86ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qQKKdb1ueT10NhTc12qooaWeklD+QEoaXP+NuLk4TaDAZ+Oz1onXE3g+uJMd?=
 =?us-ascii?Q?BB/fkwPG4XPs+7rzyK90nL1EEjNl5phwB/glm3dheDDyao8jVLvWsKSs4Z6X?=
 =?us-ascii?Q?58uWDi1xwsP/LecfiYtNxRWYWlKL+gADTVfuvshNCimSqO8Z4swcNkSr9CY4?=
 =?us-ascii?Q?em+1R/OvGZMS9uoShXgy0qV39h+wxdVAejkUhzcmG4KzsHDWGgSUrmU7tqyR?=
 =?us-ascii?Q?r38QrPf9WLgXJu2c89umb6H3wdFt6oUXgMTxSNbrVHUYdvrcgl/FtwHjMtzH?=
 =?us-ascii?Q?CkZcEflEfE9c8qpuRq09EecBMv/EMNrxbJyTHFnjoRAFNKsHp5WwV2fm8e8S?=
 =?us-ascii?Q?NuTWROVIivqRrGL1z4Z/DEhMuFVVi9lo467AbR+I60VSJB1PYviURYN+g90n?=
 =?us-ascii?Q?ONMshQI5HwqbmF8h8NMJaMmOp/ZpNlFHYCjKm78ltuUN0cAoPJrrR4a/zPPm?=
 =?us-ascii?Q?DIZvkFRqDOgD8MBpVI8THvEC//I4SPexa/Nd8dC6LwAmsBf6s+GdEljjDFNl?=
 =?us-ascii?Q?f4UcIjMXPc0bykwvb3d3x+O3ctMGI2/k5znfMjINXlBpbtH+Ob8f/WYTPe59?=
 =?us-ascii?Q?PY2rKZkakEhbYQFcSSrv2+c9w3yNkkoziGVNOPn5Y2Zd69R60GvhFRcbZ8P0?=
 =?us-ascii?Q?u7CqcqoveG6uJsvmPqAB95mEnAEvA3ELWlfdrp9dAi1btjXmUzrKOp18ygbf?=
 =?us-ascii?Q?QaPLe3n1DAyymr6cCDlA8iHIA7fvaR3SL6fxwEpmRFfBpkuu1Q3Rn4ji2yVh?=
 =?us-ascii?Q?sXzLkT6PpGOK60JlQbi09a5kNCPq/rMKX1STyLLkK/8DBPxY35ZUCHkg3RKa?=
 =?us-ascii?Q?4PSSv+df+zUBaJnzkluIdRSk1UYA7w6JyiM7bObdhQppZ6fFefhkrNz1DdQo?=
 =?us-ascii?Q?yS68P3SpTPO6hKlSi35T7Y7rKDXt3eaG0+stHLAN/E+1VzrAfqunxtSVkIlW?=
 =?us-ascii?Q?S/GNXPT+Dx/z/IAyW7yZ7Pmf8zC4Gfc84dIuDZXSy7PHvD5fgBqtp37qIgvo?=
 =?us-ascii?Q?+K48uzIPdS2E0Ij8y/a/934lj7vUaZCvhYkDZDTiZX7r2zwr7a/QWwkzGjLN?=
 =?us-ascii?Q?5lVN0krDLyAQWJUnv5ZSAX/fKkF1qsGuXl93zzkE451q3+QnGnPmGOE/fRHb?=
 =?us-ascii?Q?EZlmh5zDBzKmme5wbNGHZI3l1CTuX6lKyM8AIR9nrBU/lqqB2WdDu5bMbfK2?=
 =?us-ascii?Q?Eq8fyCB1HMXYfk+oIJlw3GAND7Tge3lrZG0DX9o1Id803SRJP9oJ5Lh5cihQ?=
 =?us-ascii?Q?iRFM1GAGSBs36zOGLsy14Ho27Jqoe1Yodf7fP0tgsuwwivxuuh+mrT415XUj?=
 =?us-ascii?Q?fgo1TqIMNFFpTjJhm4Q8wvX8p84f+NYjfUhU1DTayGxEjp1jLjR253DX7KyZ?=
 =?us-ascii?Q?mfe/C7GLe7WWKm+KzjIrNq/48LMLaI2BCVNoxmRqNy79HUS+ZN8BxSRgjynK?=
 =?us-ascii?Q?HjRV06gTfQR6agEAYFyFXJZ08gW0Ukj1mgLryHoHRrb3PrTSn/PfxmWkFnZB?=
 =?us-ascii?Q?mCcMymKLX43F67mLzR3clwrRU9xuCW1hTUY2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:24:53.3718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca488ee-d098-4412-b72f-08dd92b86ba5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present
when the vCPU is running, in order for Secure AVIC to function. A
VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
the NPT entry for the APIC backing page is not present. To handle this,
notify GPA of the vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
the hypervisor makes use of this information to make sure the APIC backing
page is mapped in NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Minor refactoring to remove the struct apic_page definition which
   is moved to asm/apic.h in previous patch in the series.

 arch/x86/coco/sev/core.c            | 22 ++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 ++++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 32 +++++++++++++++++++++++++++++
 6 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 2a604b24a02e..c8093a47296d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1006,6 +1006,28 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
 	return 0;
 }
 
+enum es_result savic_register_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	ghcb_set_rbx(ghcb, gpa);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eddcd3c31fef..926cd2c1e203 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 58e028d42e41..12bf2988ea19 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -520,6 +520,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -592,6 +593,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index ec1321248dac..436266183413 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -117,6 +117,10 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SAVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
+#define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..36f1326fea2e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1503,6 +1503,9 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
+
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bea844f28192..a2747ab9200a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,44 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+static struct apic_page __percpu *apic_page __ro_after_init;
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static void savic_setup(void)
+{
+	void *backing_page;
+	enum es_result res;
+	unsigned long gpa;
+
+	backing_page = this_cpu_ptr(apic_page);
+	gpa = __pa(backing_page);
+
+	/*
+	 * The NPT entry for a vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	res = savic_register_gpa(gpa);
+	if (res != ES_OK)
+		snp_abort();
+}
+
 static int savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -30,6 +57,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	apic_page = alloc_percpu(struct apic_page);
+	if (!apic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +69,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


