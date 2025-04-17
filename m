Return-Path: <kvm+bounces-43541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7849A91786
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82F5344158D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13968226D0A;
	Thu, 17 Apr 2025 09:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vPEjGivv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D3C207DE3;
	Thu, 17 Apr 2025 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881527; cv=fail; b=j2QQjFpK47OJ8/JCPHlAg1Cqc0LL775H2oFG2FWm2CASBSKn062x6ZVJ4QZF/Zlyh9CPsScwYh0hb+P0tbbCtF5ynuRRdCH3cwDRGkkjl2MIZuWa0Yi3g+TLeop0udxvXkV9cilEHrMi4eIrXywr1aTwdWundIi+MR1Pzsjn/OE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881527; c=relaxed/simple;
	bh=YfthRmJD3btVb2DBS9eT5T1NVuwJlYCn6RISQ/K2jg0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8oGs+3JRk+ACpSACu5Gyu4sSvWMDAnXK6xhZVHWApHbz76yspgoCffeiqIyfx9OGxxIgEgkRKnVklvNo7MeiO7TgcQsuoSN4lE6pA1wj4U+ijZ6mWP47U+bvkDeHvE54obLbUyHLzlbgLcftO0SJ8MOKSwzjpYOI4FLoJ1SbYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vPEjGivv; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GDQL+gIugDZ2shR7VBRiQVXIog9u9gIMhy+H9IRrIMrzBUWCmEO2NdhI+0+w7xL2w3U/mh9wp8wCSc9XB9kw6VQ/i/dPhF/OLaX6pe69DRtJd4FzuMCs1suB2KAb3H354E2YXB9pbz31b+fSmo1gtdfTw7LYj1Reo0RaXErszK55a3GzeC64aDDn964oQX6+Wds7X2RGVg8c1FHiaNGAP8p60dXB1eGxOhVhzVCkxk2inxSWA7IRFMdwYK4X2IJT6iifqdfWDRgSEnMLqyy0SvEMXgHYvmQ8KEgPImvF0xqmFHF3xGmCr1WZ1y+DCeEkyybe/VEtPTDtXttGScK4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqSJ/QoCPWDV4whhgc7+r7rLybWtNPTK5Src9rXOvcc=;
 b=CRvUMxZIAV5zX11DWHjkcMVUMZXW16tCPAQ16ozg9yw9YntkC3PXWFSMgB9lz3ITcvICYTTxmwtaQwhtXKVO8xKfwv8/ugY3xLH7LPVuHlYgMjhNW9iqne2r6E6g9IKRAnKTcdrcdY58nup6LfdQVt93QGmiYH818+PV8Wb+xDT35+pVtXmIR1mzxdl3SXNYPDM/VIcTXfKu7YEn5soy4BGY1JZ3gfiKdS7CRk2USztszrD20/g8AxfBAo5U79TxoFyY1c+JgaRLIinnQW9h+dAnk/Pc2r53XWmZtCcg7Pi31+2um5ivqmCE368Kk9S6E30mq8LdfeKwLYoRZvQBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqSJ/QoCPWDV4whhgc7+r7rLybWtNPTK5Src9rXOvcc=;
 b=vPEjGivvnnzfRkGRl4ZkRhAhoVldqI92hwOiTd4mYQ5WTladphOgAeJEX6pAUkTwr5rYTuHmcyvKSjtkEP427HGlinOTIxj1utvGfTXXbhWh4DmDETRoiGOuJ9Nj0IIKT5cSmZJx8Wk2KnJXLFlBAMmoww01z6DKkeEU4q/Yyb8=
Received: from MN0P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::14)
 by MN0PR12MB5908.namprd12.prod.outlook.com (2603:10b6:208:37c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 09:18:40 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:208:52a:cafe::d3) by MN0P221CA0026.outlook.office365.com
 (2603:10b6:208:52a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Thu,
 17 Apr 2025 09:18:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:18:40 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:18:33 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 03/18] x86/apic: Initialize Secure AVIC APIC backing page
Date: Thu, 17 Apr 2025 14:46:53 +0530
Message-ID: <20250417091708.215826-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|MN0PR12MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a714bfc-1808-41d6-dce7-08dd7d90d7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r4aM6sfMMKaDxk3K0zzCqP+e6+qHqieFqWNIdqOCsjVQhq4Pyx3u4iUFKX7d?=
 =?us-ascii?Q?SOt7948++SHjM5eSZ3mD1sWD2zU+nhRAVDhadLL9KVnsH6jBKdGQQ+fDdB2b?=
 =?us-ascii?Q?QaxmznvsYxBQqsoo1dxQ6ySmtGeoSd2CpBB7X1POJmdhMSJsp+psYF5EG3Ud?=
 =?us-ascii?Q?rvQtnjisSq0hX5OncRwL0oedFjzmbDKXF/Fu6t/dMWqNacnMcuQSjAs+bJ7H?=
 =?us-ascii?Q?AR3aTqIITgvszD6F8kw+Xbo3QRY7GelkzeHERok/Fu0YzfWtLZWmsMcPLtPn?=
 =?us-ascii?Q?K3mmaL6paZI0aEmi3lt78EcyMZRURrnMEXgs5M8L6dzghv16hhj3BSzC0JRd?=
 =?us-ascii?Q?qZDj3WYUCWB+OSX1Gkz9dx/eWdLBRsSXEptX+wd6rxB1HlMue2vqjWGiQ/SN?=
 =?us-ascii?Q?mVPCHyC37k9HMeZQh3tm+7OuE3QSXSzp/fDh68kcfsZmY79lu7jz42bvSENm?=
 =?us-ascii?Q?n9/2/L47cdFEbkWEbOQJP5lyf3yIDAlZZ5WcpbjhS3PY6fN3qElMC5KVagjQ?=
 =?us-ascii?Q?qNzXkTLLip3wQHBCTs0yWFuHv/tqoXSAbedtXinXWpxi7hNqo5in8lqIGWNj?=
 =?us-ascii?Q?1pnRV1VM4Cr4PBLfbpOis66ecDCxAfMgbyoFR1parkWpIrVLeGQ3K4WrBeiJ?=
 =?us-ascii?Q?+xWpyka8f0bw/J+w1amLGMHCdR8kYM8akO3/OVK6as7lzsdRYKWndOYNiaFT?=
 =?us-ascii?Q?kb1br2L+N9OlRq0YfcLqHjfuPgNY1ixI81cHKUJdEcnh69I6hw6klS3XPMBK?=
 =?us-ascii?Q?jHjp91DVtwJueUcY0xvPqdurZ69UTm3+GLsJEgKKK9Q5RXiBL72+UIy6jPcL?=
 =?us-ascii?Q?iHHMukpA+JJr0u/PeR0W3brPatd4+ERrEVg1lCv240qaGWQclv4VuVHtW4Pd?=
 =?us-ascii?Q?JbAWXkGQlRVTc9IaGL3Tm73Yh2eArgURHEa+GUK5PCdhJ5mRq0mBaF8VeR8g?=
 =?us-ascii?Q?4tT+XDzSHT9nkAbO7TsdDAt4XKsZxhXlsVHTf2FqOgWjf09WhD4FDAO4ai2i?=
 =?us-ascii?Q?rcS0x/Mv6VN77dPZUJKYf/9YFSmFD+bH6P69oI7rfTFCi6r1jPsb/HvqpE40?=
 =?us-ascii?Q?aeq6CzlCFU9XF2EgEjJL6PmdCmYlEX07r0XNnj93y+u0m9pZjFk/Bs0fJqdt?=
 =?us-ascii?Q?s1VLfgDfipAonDQ6P2scfLotrbTZzKHM4MdM63G05tyaXoSkcv2nqvYl7nCp?=
 =?us-ascii?Q?rbkXzXzobtmMI+4AE0HoZqY9bNuYQ+6gLXxVx3zupz6Ugdl1eZKs9TKOSuQS?=
 =?us-ascii?Q?wGFgfn7G/b6yFrV3Lyxpckt95MPuvPZgyzMiUHNYO9BD5oSJ2rWbfKbPFe4a?=
 =?us-ascii?Q?cijTBb2T8id7UpruBGBZBjrr8yGcDQ7QWcdIMCdWedGthcao2rd2SX+XjACL?=
 =?us-ascii?Q?PvIWLTCsZ4LXbhfSEtsSJViEh3/sBLAM3LZZDEWkDH+eaxdvrytvtM5oBpaO?=
 =?us-ascii?Q?W5RoEPMZyvP6A2R/tLOU/+5+EMR2+Nll+ul/mPAxB8jYKnwzubLVTcDXnyov?=
 =?us-ascii?Q?fjzUQQ2Oq9su3pHoko3v+lOr3JDOGeFlVMAo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:18:40.4296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a714bfc-1808-41d6-dce7-08dd7d90d7bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5908

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present
when the vCPU is running in order for Secure AVIC to function. A
VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
the NPT entry for the APIC backing page is not present. Notify GPA of
the vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
the hypervisor makes use of this information to make sure the APIC backing
page is mapped in NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Use guard(irqsave) instead of local_irq_save()/local_irq_restore().
 - Use ~0ULL in place of -1ULL for local CPU in savic_register_gpa().
   Define SVM_VMGEXIT_SAVIC_SELF_GPA for this value.
 - s/x2apic_savic_setup/savic_setup/
 - Other cleanups.

 arch/x86/coco/sev/core.c            | 22 +++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 +++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 42 +++++++++++++++++++++++++++++
 6 files changed, 73 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index dcfaa698d6cf..6046a325abd6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1419,6 +1419,28 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
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
index c63c2fe8ad13..562115100038 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 13a88a4b52a0..4246fdc31afa 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -520,6 +520,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -570,6 +571,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
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
index a05871c85183..839397eab8fc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1502,6 +1502,8 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bea844f28192..0a2cb1c03d08 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,54 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+/* APIC_EILVTn(3) is the last defined APIC register. */
+#define NR_APIC_REGS	(APIC_EILVTn(4) >> 2)
+
+struct apic_page {
+	union {
+		u32	regs[NR_APIC_REGS];
+		u8	bytes[PAGE_SIZE];
+	};
+} __aligned(PAGE_SIZE);
+
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
@@ -30,6 +67,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	apic_page = alloc_percpu(struct apic_page);
+	if (!apic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +79,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


