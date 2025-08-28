Return-Path: <kvm+bounces-56102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 327D2B39B5F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42FBC18922CB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28A825EF98;
	Thu, 28 Aug 2025 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q+JLxjYL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2057.outbound.protection.outlook.com [40.107.96.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4795117A2E3;
	Thu, 28 Aug 2025 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380032; cv=fail; b=ep7wFvfXdNOUKencvPSjYkiKK+ilXPSLQMC8Z0lGkAoke7tbdQlqmtnRFryvRCS8mStRfjPxRXX48d5sIpWwZJvTh4DP5Ye9VZ4M3yu25+SZBJRAKO+CT38zQms69BhZiDNhtUTkU8nfycVj6Rg/THg7LHgYjT9ufJzlX6bkH90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380032; c=relaxed/simple;
	bh=MdBR9ZJnXxmr2DdHROPGW6B2ob7NhCz7CpyvxbDoRNo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USXbBT63Bf7ltFww3oZcgE6JZJwvo7ENGfq+Y0vnc8S7IR7QSrtoK9uBJXrC/pkXzGOvipspko33s91mr5VVTs0TMcagde8CoG8IYgHBO65vOtGkVUU6DhXmHMGoMQy7jv0Qb5OW+AK2ZU47J35OzbtSKPYWiRfU1fTAsuaG5cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q+JLxjYL; arc=fail smtp.client-ip=40.107.96.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qm8FaudQxoBJ6jE7HtQi+swuHVd3j8yivqZ9ej81YqJbraHo7cISAEL+Dah3l3I8YJ/ivutVEFkOqNqmZonuIPxTe0yQAmTIW1OCGDiqGwAxESAsK2pa4uhtDMsJ1GP/dqTNRdm+7FtVFho/tVzyHkHLiP2HomLjYwXKXcI28vgGZi8d2eQMgn6POwxt/sSp5uDMTMG6n3311Vb400hSq3FzFrbBM6wM3SEzPvj8z9GEPGVoBTjoS6tWoksNu4Dqpx0nLY1uK2z5cfwafqrjrlZ1VVrGerz1HQmYudpP5XaWJFQ1eAa9JPr1Gy4MoXtkAADtOreSZnM0UqDcDkpcdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27EpBdoOqpQN1KyvotA0CEQzdn81DhpxNFuluHbc5LI=;
 b=YHEOI5/kxS5jHdSZSju/DOuAI1SxobMHjVFvb10YOVBmpTSBys2rPe4gFJFupvkUuRNUPHbGFSXPPJuTJSu+iK1SmeQbMij00O/AWLZBJ/jP3wwphW+fznDAscyftoMBsVUzgqbhhQpIArC7dY6WjljvLcABCcaj3YZBKXVXL14QXZyYZ93/xfnvLS/u49wEVZu65M4wtNdTaJxMcN385JFYEP/twsEHiGFTYTI2h0nYvvlx74TPxwoCTQGHA9LmFxR4LSomulVJtY7tzPEe3PeKMtDizl+GrnFsfMdrhazVvdMiUdGA0P5P4/G5eapBqCy7+vcYeCZOYI6X+SBTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27EpBdoOqpQN1KyvotA0CEQzdn81DhpxNFuluHbc5LI=;
 b=q+JLxjYLMDYcEl2aucB5p2dS4G2Dvd2V5BxukEZbzE2N0mPoeECM2LvmPCEA12uoZhfmuuFgaHyZTBa4ETh49REv4kKs6LC4zglixWW5F03XyulnanoWnB/692C90sop67mTPpNxHxROVnelWliEKKra4IIL0sys0L8I8/Utkh8=
Received: from DS7PR05CA0059.namprd05.prod.outlook.com (2603:10b6:8:2f::32) by
 DS7PR12MB9043.namprd12.prod.outlook.com (2603:10b6:8:db::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Thu, 28 Aug 2025 11:20:24 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::b1) by DS7PR05CA0059.outlook.office365.com
 (2603:10b6:8:2f::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.6 via Frontend Transport; Thu,
 28 Aug 2025 11:20:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:20:24 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:20:23 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:20:16 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 15/18] x86/apic: Add kexec support for Secure AVIC
Date: Thu, 28 Aug 2025 16:50:08 +0530
Message-ID: <20250828112008.209013-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS7PR12MB9043:EE_
X-MS-Office365-Filtering-Correlation-Id: d1fba513-8c8a-469d-252e-08dde624e216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ueVS8sNK8Kzg1arw4/Jr0Apif0xCM7cqqAZ+T1mOYW/kzLlAzxgjnMvz3Qvg?=
 =?us-ascii?Q?qTmdAo6k5U/oUZAx7cPHX/XHrINk+qdnuJuNpsOFE2RyZnd3hxIsLnfyF8JR?=
 =?us-ascii?Q?K6LHrjcvG44uG+p01JPBfn4DuskLm02lBHvX72qlmRTxt3BX6hrW6Lug81je?=
 =?us-ascii?Q?ABueTIjm/5SgLHUimC+D/gr5NTK+AfQ3AHOJKHdHMswyCn0uLMLS0cBRKCzd?=
 =?us-ascii?Q?CRE7YrHZ8s+YxaMq0I1jmkWUlXkfQAPOtzcMSPP4cZ5cGkGt67hlqHpppNXp?=
 =?us-ascii?Q?x7meZsQnVrS31qaleim+DA6LTAITu34Brwyg9p8qPafwlWnm/ukXuvvxNqFD?=
 =?us-ascii?Q?QVC1lIK41Q5w4iu3gcwfwXWhvMceOBfH4/GOcdcMhCYPSg5IYkhGXIiUIbU9?=
 =?us-ascii?Q?b7EK+RbKWQt/gONVqiiBtYvcN+/3UuDwDTDn3QhH5bsy78bpYdtBbL94WLdI?=
 =?us-ascii?Q?mqQijR4fM1gAlF17ycwNS9dtQiZ379geBSNPMNTshAOksTTzHQx5PiVdMfng?=
 =?us-ascii?Q?Vs4SlTn12dMdkgPF5ZpOOu9Iy9DZ+B+Y02Z8yGTc3dV7LKEYbmx6R4C2i5O0?=
 =?us-ascii?Q?F85mjLkXDbKoGcSoUq08roSdh8HKfBK5uXz/PrgF3gyDQcNcfMEP/EU8yx6V?=
 =?us-ascii?Q?Bd5bvLCpTktbKACLsKOSCPVXz3HfLqaJ5bVJVoPb4lQVWtWmWLZWqGKcxfZ8?=
 =?us-ascii?Q?Wdl+o0tbdnWuns3REPzqauLuty4spy0pxPK/CiyJG6HcUoGgdRSYyMkEG9Vs?=
 =?us-ascii?Q?BC3p4+O2IxskXoo1HzaYl44KtFdorZGaxTC2ZrZ5+QVv6V/8KQK7LGvvBuY2?=
 =?us-ascii?Q?V/6wCgFWIcCg3VtwugxFKE+DJgBf+tgXMiuGGdVtZOR/1+nNgKhHZN0MwACw?=
 =?us-ascii?Q?5EvsxxtX/719wmS6vnyLZN+yq3zTLO8TR6+W3ZndsaVkWjIiwd6eAgojHUVa?=
 =?us-ascii?Q?k56083wSWuti7ZV0NTQ5iyTqxkCzcre5IABRNMoiXUPeCzxqxVt3q3RtKzBU?=
 =?us-ascii?Q?4Q1qBoDHuZu9cRpzSo88xnPItP/PxdWkgkitfvol5P6jVDBCQnAzLQYUGo4p?=
 =?us-ascii?Q?5uJlEatdBUjloXKjTY3BkC8GOuASBHrOrihFZah3plxfC4Xiz5/mv4+wkllo?=
 =?us-ascii?Q?9HON2Pkw59v3/LoJwAwbeo0noo4maCR7g4cIVLc8MXrfDf5aB38ZWT4EjUT7?=
 =?us-ascii?Q?Kz/sj7bC6lcEQav2u7raEjhgPZiYuMy1+TorCR1tDUSHBJydLefUtOBBat9o?=
 =?us-ascii?Q?HVuD7Sa/rydWRhmtaR2iUPsrj8aCBbAzphxvTFDHYl0Lut1Fks58FDPz7XWY?=
 =?us-ascii?Q?KvMaSUBoUd22+zDLbJcPYB313P33OYyD+s1XhjKDUMC6RzHCgNH7YeF75wNJ?=
 =?us-ascii?Q?Gxu9ZhciJf86ygpBNoj05cN4xedk+F/0q52P/olwyvDyY/tLoUruX1kV9CD/?=
 =?us-ascii?Q?1GD1gicMq1o3ETNs6oiO3xnMy3q+l7z+nM4in5a4s51rsw0DZ7sIsZ6Yg3/E?=
 =?us-ascii?Q?8hohGOxdBwv2WaYlBGZl3XLwyQc4kr+4vl33?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:20:24.1986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fba513-8c8a-469d-252e-08dde624e216
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9043

Add a apic->teardown() callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. Such accesses can happen
if there are any APIC accesses done during the guest boot before
Secure AVIC driver probe is done by the new kernel (as Secure
AVIC would have remained enabled in the Secure AVIC control
MSR).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Commit log update.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 08f9a9ef2c19..1362a81c609a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1187,6 +1187,29 @@ enum es_result savic_register_gpa(u64 gpa)
 	return res;
 }
 
+enum es_result savic_unregister_gpa(u64 *gpa)
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
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_UNREGISTER_GPA, 0);
+	if (gpa && res == ES_OK)
+		*gpa = ghcb->save.rbx;
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
index 0683318470be..a26e66d66444 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,6 +306,7 @@ struct apic {
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
 	void	(*setup)(void);
+	void	(*teardown)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 875c7669ba95..46915dd163ed 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+enum es_result savic_unregister_gpa(u64 *gpa);
 u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
@@ -609,6 +610,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result savic_unregister_gpa(u64 *gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 69b1084da8f4..badd6a42bced 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1170,6 +1170,9 @@ void disable_local_APIC(void)
 	if (!apic_accessible())
 		return;
 
+	if (apic->teardown)
+		apic->teardown();
+
 	apic_soft_disable();
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 08cd1f51d909..88e0ac9ad092 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -330,6 +330,13 @@ static void savic_eoi(void)
 	}
 }
 
+static void savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsrq(MSR_AMD64_SAVIC_CONTROL, 0);
+	savic_unregister_gpa(NULL);
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(savic_page);
@@ -384,6 +391,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
 	.setup				= savic_setup,
+	.teardown			= savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


