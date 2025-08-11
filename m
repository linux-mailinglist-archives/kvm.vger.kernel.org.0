Return-Path: <kvm+bounces-54403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43084B20479
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5ED14249EB
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72666221F09;
	Mon, 11 Aug 2025 09:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HQ86QRVX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA09214A91;
	Mon, 11 Aug 2025 09:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905831; cv=fail; b=tZE5ZNRAaw5qQzfce+sU0dLkHHr8r22CPRCJ89VFKvgNOHvwlCI5m1cahWcytAtaK4tSJStV7/xuXx8RtURbpwZKrgGExAZnjUNI8XqQTW/hHNHZ+Yl7MnxdOS1RgDPHF5vqpVcHAfpgx9hH8iQZIivLNQDjmNluo/fpD2RpOMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905831; c=relaxed/simple;
	bh=PSx8QoX2BGM9HHTQcXk4GWxX7dtfqAwq2iH+Yxi6qgk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=au7e5q45zCHhyXAgjGHpTItibs7IfnGOYfqrjudihDP3GzMxaGZGnB0pYHcSO4ZLF/DFzeFfoUTFOOVJwbE2PKRsjtraKlDOSLkhYXSqoypaG9MlFFEIOjyGHR34XWZsunP55b8mMVEPhshgctkb+Jkjod79Zv6xEMpi7Af1iCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HQ86QRVX; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rC67Frtm6jGESYNOLcUGPw23Mz5gmAsLZl7isSYHdq6QV9XeDiICpVOcOF15o+r5t3iX5e0GF6BReRj/DBu57qZ/bY2vwExDMWA/p0u2fLHmBSubiQbY3yO4wPd+Czj9pH+JijYZDr+344Ae/L5bjPM5Zc1FBAFgNyU7la/E2Q4SA7dSlagxNfWdabt4CDuIeVkuVwNhH8O5GII9fUgZtFIe66LIYcukKaRfC1Djjp0ECR8eMkurJ+OrCwQhYcCUwmNAjy3wfYzSroKWEBYl7c1oUwtxhSMubghm3c6OkmnctFAXf7n60Mp7VFSU50OHVaOQwHYt7K3Ld/oMNNdabA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ago6Oup7qOxicul8bpZNVR8z+3rT6kN+OrqB7vMpg1c=;
 b=kSeb3P7ytL7RURyAV9DAA8bDGmKc3E2EO35Rbo0Z/qHursrvZmzMgnXlrZ/GKxD25zHR5WKGw09TFmwxiY5PMYBkKoj2HFZ6n9xjTLVR3Cug+8M5pQdSje1UtJaYOtpfBZyar6mz4txtsvKIQL/Rnqgd5BghVj+BsOVFjDqZTvhCgSzntPunIWalAFoJXTw/rZL1tIACZdaghh+xQxSOcUlrx4i2eXSI+/opYONxQZYwRJ2X+KhFfi/3KPspPjASNFbW+kKGkPUYe6kXbwi39yOdClVTzYz0cY/5SPGA7dc0qxuKfpcKUeOxL7rfoAXQIapLtK1r5Tl4ETpSNdMYdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ago6Oup7qOxicul8bpZNVR8z+3rT6kN+OrqB7vMpg1c=;
 b=HQ86QRVXEd8XIeX/X+qQOFPvMlWInGQ3CBjOCWWFIvHpISEJ/Se5ygBhDYSPEKEj2EEtbWDkMmLEoNjugGebZJpmyhGf0wr0A8h8mWidaQ+CKLexY6ikUWFTxCaTdwnv+abKwNR6BIkZJMQ/WV+jo6byWyM8yGYCVWk1hPSJUpY=
Received: from SJ0PR05CA0169.namprd05.prod.outlook.com (2603:10b6:a03:339::24)
 by CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:50:22 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::54) by SJ0PR05CA0169.outlook.office365.com
 (2603:10b6:a03:339::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.12 via Frontend Transport; Mon,
 11 Aug 2025 09:50:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:50:22 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:50:14 -0500
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
Subject: [PATCH v9 15/18] x86/apic: Add kexec support for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:41 +0530
Message-ID: <20250811094444.203161-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|CH3PR12MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 5729687b-0edb-4c5d-3699-08ddd8bc7d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KlH+ha9MLPPGf//m0k0G2GfyqEITDZHUrfwTnH7jfa6VoGACqZ7NqcOSwtDv?=
 =?us-ascii?Q?OEItWlwAnD9xmISBAypAcRhNhQ6T3+3O2q3xDgOitILcWbtih4TkAO7qFTu2?=
 =?us-ascii?Q?BOs/872CUXpM7cUpezlCs9RzQ78G9cEp3dY/A6SyqjodJo4+vU574YqEJYxi?=
 =?us-ascii?Q?87qObStvhhUQTBGrAx6d4R3U5xRFj4oZewybQN6vhwRhfIEAY3BgVBesN0at?=
 =?us-ascii?Q?bin5UnjHKmd49OjCK8xuz0KcmxkISOft1xihdc7SRiEzRwMPKj3GmDMk7Y8L?=
 =?us-ascii?Q?8x5OA5UGDW168ryQvW+JuxrbFeGcO9NEc1EZQPem7QXR1LzUBXIwqG7j3sNC?=
 =?us-ascii?Q?aY/xmijID4STr0xL62k8rR4xzSf2hFZ/iwZP0096myBS4nGup1pFXpt6RRyZ?=
 =?us-ascii?Q?gHTewvl917mpia7CiCRxOBGQAbSm3IPeJyl4fqVvb1Vv/CsJnh1yTEgllpx4?=
 =?us-ascii?Q?qbPbsAoSlCd2Zt8M2S9CTO8slMQNzAq0vWNINIrPm2Ya+ObLaMzHBlSLYBpL?=
 =?us-ascii?Q?v77WG+y6OV4Y2KebeqkQAusaVGo6C8DRwupHxxK5JeKrbCkrvsWEo8SR5QT5?=
 =?us-ascii?Q?eDmcDnmsf+2JpyT1OLS2HcK0cQlHYfsd4Gk1TSn9KfqSXrRm5kY7gBi4YYmT?=
 =?us-ascii?Q?CmaSCs1D3RCUUPf9xzRUsK0096adASym7NvyNzGk0OL4UOZtcJgFqtEo9ngX?=
 =?us-ascii?Q?lVbWYVkR1ep3zGY8QG7+D92Q8ldsIdyU29jYCz/vlmXHLo0fEk0caSi8kHdP?=
 =?us-ascii?Q?knaTJm9BffE+72/JZfoSIIYDx7ZjaxRecCoqx1yQlNkGL96x1t5uRWiiSmB1?=
 =?us-ascii?Q?pJjnwqgeC1ZhRGcNkK/okaA4MWDML6NBH5gMPe1ylC1VUgi9nEaeWaRRNebr?=
 =?us-ascii?Q?9wzh8/8YcSNAo60l8GIxGJAZfLebgsaTHLZuml2zox+s0eagJVZu8zbEmzWM?=
 =?us-ascii?Q?/dpHzJNpowkBoVUo7Pw4zXDS1DYX47Lj77k1n1be/1C3ZhZrLnEtSyH8YLlj?=
 =?us-ascii?Q?wFmUd3yVSiREGvruN3QfsZzkPH+T4Nh30yby24JmFaT4gPzDKG6ShLTMUsDB?=
 =?us-ascii?Q?C4n+Vsxj8EY+uK0//wW5EiTgeWnbmXHZBhkV4kPLwozxcD/IBSuTiB/edkmA?=
 =?us-ascii?Q?blQMAqTdlGgcp58qCgpm6B/rjU4Qa/izY1r+TCOOfi8rFd5Yd2UeOEqtI754?=
 =?us-ascii?Q?y3oid8k1GK9v1DH+ujWetpWmAnpBUOAQrGkInHkLwMjuGcYmFxrOjG4XcnmJ?=
 =?us-ascii?Q?skrwFvvDHNT6lK1Xf4OxmFilgT/bjupNckdxKBJbYbthjmkZHZU5yv5tmKRz?=
 =?us-ascii?Q?GOi0f6ALmwKZEVV6LCudvbpoIV22qrkhUKqbmlskuBC1brPCBtYClS597Nt/?=
 =?us-ascii?Q?j2DubSGlLNg/P/YIQXoRGtSVlmkAaQjYLeywAzW/l2m8/rrg55GQtR68wXAC?=
 =?us-ascii?Q?7Cz6RVErV2HCJ9qfLOdlv0rxV8Pa4UeO6EWfwnCSk1p96aAkCvtAfEr1RnjA?=
 =?us-ascii?Q?0oG1VTtzOfuQJ8ilbzkONEYczL49Me77yl/G?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:50:22.2343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5729687b-0edb-4c5d-3699-08ddd8bc7d46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8658

Add a apic->teardown() callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. Such accesses can happen
if there are any APIC accesses done during guest boot before
Secure AVIC driver probe is done by the new kernel (as Secure
AVIC would have remained enabled in the Secure AVIC control
msr).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - No change.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index d7c53b3eeaa9..da7fc7913a00 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1164,6 +1164,29 @@ enum es_result savic_register_gpa(u64 gpa)
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
index d10ca66aa684..35877c32b528 100644
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
index bef77283dd43..71775d6d8fbe 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -326,6 +326,13 @@ static void savic_eoi(void)
 	}
 }
 
+static void savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+	savic_unregister_gpa(NULL);
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(secure_avic_page);
@@ -380,6 +387,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
 	.setup				= savic_setup,
+	.teardown			= savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


