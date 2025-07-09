Return-Path: <kvm+bounces-51858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFD6AFDE67
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720C5480008
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A7E214801;
	Wed,  9 Jul 2025 03:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="daWZjeOt"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mail.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651F920DD48;
	Wed,  9 Jul 2025 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032428; cv=fail; b=F3CAa0H3/rHPxt1cb0ep6a2Btmn0qrnd3wn+v3KKA7mKw/lF/aQqLmOnru8J9cBEDFgMufd/uoTLoufMLMIbW53nZ7GJ7FuSXxmRVzB7HWcP9YKJ+JyVo1FDunkR1HvJsoLg0LMVb6pkrQzxp7D3aVYTTNMemqBNXznYZKj/D/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032428; c=relaxed/simple;
	bh=orlWQKBew3qJczCGuaZXFGYi56C4fvKh6HkMwe11gcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCMjdHJqNtH7eAztR+IUyKk/FLbKSTTtWH8mbQPFg/98GFPOHXE49SSjfwb7oUQa+6CVtucJYAvqQAkmkwvV6vfh4X+1HiZgEv1peYH/YYtACIlWDbbHk7Mtd0/MtXsxzPAaLgtB622iHCMVQ1sw6wU+4Hr9pkHSSmNpc3zGPeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=daWZjeOt; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X8Tah+rFjtl2n6B3PDZn+/hN/ArRomxOpAPGQ2kECYIU+efUSLxfOpfpVBSr2ArbeY0nr+//ByJRKPgM3uECRPC+SH0egoJzf/6XBZ3OJjiBq/GUZing+p8XknuvkJjqeYAlQbvmT3xMk4Uenr8G1/F/QAEeoV4DXs10hp02u9XnKVLWdeJFqTjsYZEJq7XoJH1z7QVj0tprJBcg5AAt+eF67L7nLfIp4avawo59QTKGrMLNm1BHnIEpCSGEl9MblijQlovX78qZx6m3A/xHtvbdUVU6m2qFfFs0kmU21XrzTGN9GNhcy18//jzEvdOeb063o1QbkqZyGPpMXxbRew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyaL4AV5Fi+ZtCLwEgE0S8T2nt20IyMb4DQFuHeRy/I=;
 b=arCF14G74mLz4JWc6mFrIq9fL27XHJ5NmSBxs6qKYh9P57ccID/be9UM2CfDyHdSxCUMWe8noMDwj4Yrb49ny0WFg2X3RmDYUR8vcrR6jyxt2jrOcfp64jGKTKgQ5dWZQxWu5Fc9/lLKauhq2HHAcr22XcTceKhE3uuVvizVH98t2x4oMtYGgZl9R1Adjm7IDWa6riLakmwmEXOS7je2erEqcB/aKPJsBHNMxJD97eZDvwcaDElTAQkqVRrxOtxylbZf5JLVWCTlku2XzT8VSuX3jY8s8SnWJ2tLNAuqczSyoHhtUHqR7Bij2Hg+nm4QEZ1sgA7APhMj6v9HQolk3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyaL4AV5Fi+ZtCLwEgE0S8T2nt20IyMb4DQFuHeRy/I=;
 b=daWZjeOtJFvwbKgz09AhjcmANIJyJQZ92k9DDio8c5D2Hhyn3uuVkuHrnXD7e98sNw4DCh/qAUmhdO3UddHx/I8KE/fZKYHywz3b3XLaJAHEMbBdWpcBVUJkam/uXbH6aR0wGn43LZh/rYaxraU567X6T7LuqtI2akvu9ibDSL0=
Received: from MN2PR02CA0010.namprd02.prod.outlook.com (2603:10b6:208:fc::23)
 by CH3PR12MB8187.namprd12.prod.outlook.com (2603:10b6:610:125::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:40:22 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::2f) by MN2PR02CA0010.outlook.office365.com
 (2603:10b6:208:fc::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Wed,
 9 Jul 2025 03:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:40:22 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:40:17 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 24/35] x86/apic: Add support to send IPI for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:31 +0530
Message-ID: <20250709033242.267892-25-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|CH3PR12MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7f8c9f-7e50-45b3-6527-08ddbe9a55ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TL8u30+vpUTuHhlUrGpROkcXsaNNAOSysU8ZWmVxcvJCv/xou2F5V5QP366o?=
 =?us-ascii?Q?UFUh4qmsFhzsRlrtdAwILgBQPNHfysyUU62cu34AU8PxxlsVZxyqVGaCHxWw?=
 =?us-ascii?Q?4nGYQh+1jNeIfjigdAxz32OgNjNqINoS19bR3axn9juuv2WCZRGUImlGEo7D?=
 =?us-ascii?Q?Cm6WFgDfqMpfnlXvHPutVfDDuGi1ZR9zgssI7X+CpGPBT5BvdJbewpItGCF7?=
 =?us-ascii?Q?KOh/4CzRNDQm/2NtVdrhdC5ZizR+4+M6ia0Al6J5K33BJHBLGsd3OFqInIIg?=
 =?us-ascii?Q?ap+kc1Ui5kJgfRlM7eHSlNp1dy5bbFhmvEi4Bf4oYw99ggqItrjdTutrz+ME?=
 =?us-ascii?Q?BJu6PypVRDi6xqo/BnSNI9P5zql21h5SVavIPXW6W+mov+8BhJ9HMcGrRAjF?=
 =?us-ascii?Q?DXs3wed/njT/QFQJIgVUVgWjrDKGRhQQjTwrppmozYl3TmKzXST9BeySCIv8?=
 =?us-ascii?Q?U1scS3Y6+TXtdwSoSCDXozse7SAwQtR7aE4Y9x3QBFPQFrLEbmZW0TiGxf6h?=
 =?us-ascii?Q?im3lkYx2O9MDIAWivvhFQcMyTmjMWhpkrUSgayWNb3TIYrdaVE9MkZuA/vfV?=
 =?us-ascii?Q?k8sFWdET55ACsDzFHU8TcUQQDMVpUTSV2d5HP9apZF32BsbRkToRC0Fh3ak3?=
 =?us-ascii?Q?PfWZ0ib4sxXmU80TLSoqfzkrVgYy/i+SX7WrrdUfUkJU87uwMQH+ikOUjUfK?=
 =?us-ascii?Q?YDGFFApHrPBC55/sb9/vr8pE63rgBgU49Ae+IQTaofN4Qeh9ninYOPH+E8rO?=
 =?us-ascii?Q?j8PTxOx5G174G4WfdrzVwCnl7AQ/0PndB6DaZUEDYQlvshku6+IhRiHRtQZW?=
 =?us-ascii?Q?R9FRrSWNH1kVxbBJLUA7wNJnCpp0uZ5G+xMmHk+zR8g/9I0+aQyhNFE8hSgK?=
 =?us-ascii?Q?N7Jj2JLBRg7yg+zChC5vrlxGjavxDbF7y2Y4aewlueDIdQVWOx0U1sD+IACD?=
 =?us-ascii?Q?uv1b8YCDgqJB4cY9qCJgicRVLZHib67oqxpL5nZkiev7ggCVaseqof282Tnr?=
 =?us-ascii?Q?HBZ93bg9i7J1092VXazQlzsAQgDpNmzo6Z45+pELFjT68i8t0ErAGSOGXId7?=
 =?us-ascii?Q?RgPnk4U8AyffbxThguyyg+p51fk1bf3FwthSjJk2a5f7dO7m7nsmscFW8nnc?=
 =?us-ascii?Q?Yo4ePBnRYKVWFmVBjRLc3YMugEGfAy4NaA7nd/BCssDTwa7g9K7mqFuy1YC1?=
 =?us-ascii?Q?om6rr/W9KykCnYWTmxlTgkJBBf+uJ4+doVv19DvrXeYevEUyvxqf3zxpB4Aw?=
 =?us-ascii?Q?yF/K/mqEZfavcU2eT44/z7eIv5LG8unz4T7YXjZWqFvZxCh4Kgnd3sp+4hYy?=
 =?us-ascii?Q?w9+aZvRh3OY3IIIHjyGiRDYEsrdwGNaakjidoMkF2cuTKdQIxQ8KzVchBNLJ?=
 =?us-ascii?Q?AS8H2CMlINDJ7oPLa6+HFmpWPBDbw+YLQnT6vi+ncOAH+SrEYX1SskEEhTpe?=
 =?us-ascii?Q?yJGBnsYOj/Nib1KWLmnBiDJkhJN9kl5UXmOFG3+6bTLqpA5pvJOkjdKZpeNK?=
 =?us-ascii?Q?RhVsAK9RrA1AVSHZvLEykoaXA2MVpczK8pyS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:40:22.7572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7f8c9f-7e50-45b3-6527-08ddbe9a55ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8187

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI. These callbacks write
to the IRR of the target guest vCPU's APIC backing page and issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU about the new interrupt request.

For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
vc_handle_msr() by exposing a sev-internal sev_es_ghcb_handle_msr().

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/coco/sev/vc-handle.c       |  11 ++-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 139 +++++++++++++++++++++++++++-
 5 files changed, 174 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 0c59ea82fa99..221a0fc0c387 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,34 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
 	return 0;
 }
 
+void savic_ghcb_msr_write(u32 reg, u64 value)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = {
+		.cx = msr,
+		.ax = lower_32_bits(value),
+		.dx = upper_32_bits(value)
+	};
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, true);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) write returned error (%d)\n", msr, res);
+		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+}
+
 enum es_result savic_register_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index faf1fce89ed4..fc770cc9117d 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -401,14 +401,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
 	return ES_OK;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
 {
 	struct pt_regs *regs = ctxt->regs;
 	enum es_result ret;
-	bool write;
-
-	/* Is it a WRMSR? */
-	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
 	switch (regs->cx) {
 	case MSR_SVSM_CAA:
@@ -438,6 +434,11 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	return sev_es_ghcb_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
+}
+
 static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
 {
 	int trapnr = ctxt->fi.vector;
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 3dfd306d1c9e..6876655183a6 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -97,6 +97,8 @@ static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
 }
 
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write);
+
 void snp_register_ghcb_early(unsigned long paddr);
 bool sev_es_negotiate_protocol(void);
 bool sev_es_check_cpu_features(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8e5083b46607..e849e616dd24 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -607,6 +608,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2e6b62041968..2a95e549ff68 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cpumask.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
 
@@ -109,6 +110,74 @@ static u32 savic_read(u32 reg)
 
 #define SAVIC_NMI_REQ		0x278
 
+static inline void self_ipi_reg_write(unsigned int vector)
+{
+	/*
+	 * Secure AVIC hardware accelerates guest's MSR write to SELF_IPI
+	 * register. It updates the IRR in the APIC backing page, evaluates
+	 * the new IRR for interrupt injection and continues with guest
+	 * code execution.
+	 */
+	native_apic_msr_write(APIC_SELF_IPI, vector);
+}
+
+static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+{
+	update_vector(cpu, APIC_IRR, vector, true);
+}
+
+static void send_ipi_allbut(unsigned int vector)
+{
+	unsigned int cpu, src_cpu;
+
+	guard(irqsave)();
+
+	src_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		if (cpu == src_cpu)
+			continue;
+		send_ipi_dest(cpu, vector);
+	}
+}
+
+static inline void self_ipi(unsigned int vector)
+{
+	u32 icr_low = APIC_SELF_IPI | vector;
+
+	native_x2apic_icr_write(icr_low, 0);
+}
+
+static void savic_icr_write(u32 icr_low, u32 icr_high)
+{
+	struct apic_page *ap = this_cpu_ptr(apic_page);
+	unsigned int dsh, vector;
+	u64 icr_data;
+
+	dsh = icr_low & APIC_DEST_ALLBUT;
+	vector = icr_low & APIC_VECTOR_MASK;
+
+	switch (dsh) {
+	case APIC_DEST_SELF:
+		self_ipi(vector);
+		break;
+	case APIC_DEST_ALLINC:
+		self_ipi(vector);
+		fallthrough;
+	case APIC_DEST_ALLBUT:
+		send_ipi_allbut(vector);
+		break;
+	default:
+		send_ipi_dest(icr_high, vector);
+		break;
+	}
+
+	icr_data = ((u64)icr_high) << 32 | icr_low;
+	if (dsh != APIC_DEST_SELF)
+		savic_ghcb_msr_write(APIC_ICR, icr_data);
+	apic_set_reg64(ap, APIC_ICR, icr_data);
+}
+
 static void savic_write(u32 reg, u32 data)
 {
 	struct apic_page *ap = this_cpu_ptr(apic_page);
@@ -119,7 +188,6 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -135,7 +203,10 @@ static void savic_write(u32 reg, u32 data)
 		apic_set_reg(ap, reg, data);
 		break;
 	case APIC_ICR:
-		apic_set_reg64(ap, reg, (u64) data);
+		savic_icr_write(data, 0);
+		break;
+	case APIC_SELF_IPI:
+		self_ipi_reg_write(data);
 		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
@@ -149,6 +220,61 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void send_ipi(u32 dest, unsigned int vector, unsigned int dsh)
+{
+	unsigned int icr_low;
+
+	icr_low = __prepare_ICR(dsh, vector, APIC_DEST_PHYSICAL);
+	savic_icr_write(icr_low, dest);
+}
+
+static void savic_send_ipi(int cpu, int vector)
+{
+	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
+
+	send_ipi(dest, vector, 0);
+}
+
+static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
+{
+	unsigned int cpu, this_cpu;
+
+	guard(irqsave)();
+
+	this_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, mask) {
+		if (excl_self && cpu == this_cpu)
+			continue;
+		send_ipi(per_cpu(x86_cpu_to_apicid, cpu), vector, 0);
+	}
+}
+
+static void savic_send_ipi_mask(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, false);
+}
+
+static void savic_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, true);
+}
+
+static void savic_send_ipi_allbutself(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLBUT);
+}
+
+static void savic_send_ipi_all(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLINC);
+}
+
+static void savic_send_ipi_self(int vector)
+{
+	self_ipi_reg_write(vector);
+}
+
 static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 {
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
@@ -228,13 +354,20 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.calc_dest_apicid		= apic_default_calc_apicid,
 
+	.send_IPI			= savic_send_ipi,
+	.send_IPI_mask			= savic_send_ipi_mask,
+	.send_IPI_mask_allbutself	= savic_send_ipi_mask_allbutself,
+	.send_IPI_allbutself		= savic_send_ipi_allbutself,
+	.send_IPI_all			= savic_send_ipi_all,
+	.send_IPI_self			= savic_send_ipi_self,
+
 	.nmi_to_offline_cpu		= true,
 
 	.read				= savic_read,
 	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
-	.icr_write			= native_x2apic_icr_write,
+	.icr_write			= savic_icr_write,
 
 	.update_vector			= savic_update_vector,
 };
-- 
2.34.1


