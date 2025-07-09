Return-Path: <kvm+bounces-51866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A78AFDE74
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62FFE16EBC1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F53421D3CC;
	Wed,  9 Jul 2025 03:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TUWB+do2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5AF1FDE02;
	Wed,  9 Jul 2025 03:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032588; cv=fail; b=o154qK1bWIaEfotq4eX4fu1F8ix6ZacKZtIqXx9xohC80xS4f5BJ+LweHzigBSN5kYDAlBKIFdtiVm7yd1PCaeRC6iQVASBEr6iQv2ftrLF65O6iTHUt6Ja5KGqbdec2KfypfGrY1akffLMj8oPGLHqgcfdbLwvuhJxORcPsOlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032588; c=relaxed/simple;
	bh=koGhlNmKPQdNiwRvOOdFbgm50xsvhUofSh35LDhgtlo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUtu3JxIefIVc984vi7vhBuDkRG1bYullBpS6dRkUKWlELRwefOdq442+NHQ+TY2oia6sK6KGUqECR2SqyfsPLS09r8VH5nwU/vS5y6zz+bBp/yNU91j1GPjhZWDVQp/YORXodAO+tGKr6ZLMiccQMK4QeGuF7IUu7HaLkqUisM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TUWB+do2; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQfDWqEDX21034tCbxheXUDx6xXvu+IJed1C97iF4ZKadkOMCbS/mN/qgYpcbLZo3l9tGNO0Rmy1V9hvNg2vl35XDArx0e8b8mL9RV9pBSJ24gE7UPeX2R5PbxL2tiBbvweoJFMexjB+XtcdOh+ff2DrzWGVDJY5dXGfFezV8ETrhSEr6z7cducqkUCJC2/piEiNlCOM/AZpv7mXCbHZdRM/J+mvxKJkRw9X4U18p3XwQK7JvRjzNAkrf65nUklrbmPs/bfuKJ9PJW5GVZRxGbHE/WpUg+efvEUcywwEveL3uFy+LxxV6YHyf+N/G+mQ3K575gthGX2OIPMhqsvYVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmHFKfuK0gFFYIlTtddi6WahMbJVA0fHjSacG9nf1EI=;
 b=uLNrscpG2rN36MDf12qL7q2COUB0dy3ZZhU26ewmlAsk/uYqJp5vcPnk3oasIz/m1KSVNjz3SiDhUHWrLekXg+98N04ZNRMwHYrG7/NntAKLLxOTwRDaPosB9O4kjl92l+7zsy4KsaR1S+9LIowCzcIcOTUU1nTALyyxJkhIj/SlbAhQuxlMmM4Hb4K4Bl1igcdtJEDS2apboIVS0FnUqBr2O/Bbvpy33mqsK1hp4C2Pka5Qi/Brf3TCJ7DBwTwH9mzfPoUGBlDAb6eLT8saKvnI5+CLRZgNzyfdLYATCGPdqA2Gpeg3xe1VP6f18eYP7WhcdM+cEqUb3LA7nC7LvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmHFKfuK0gFFYIlTtddi6WahMbJVA0fHjSacG9nf1EI=;
 b=TUWB+do2YXgu6Wc55hnK7jXSz2x++e5IKlWO/6MtHwQCjoJtGM2HkFvVobtIrvuFfizZ7kzG1/W3Guq6XNVTNWP/jqot/y/qhDmuQO935SjYAGgS1LRLFAIs4/8SRHImeNYScjj5HNp+74XBuEZjYEPY2F9ftphYkI6e0t3KjEQ=
Received: from PH7P220CA0094.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::30)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 9 Jul
 2025 03:43:01 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:510:32d:cafe::67) by PH7P220CA0094.outlook.office365.com
 (2603:10b6:510:32d::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:43:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8943.1 via Frontend Transport; Wed, 9 Jul 2025 03:43:00 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:42:54 -0500
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
Subject: [RFC PATCH v8 32/35] x86/apic: Add kexec support for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:39 +0530
Message-ID: <20250709033242.267892-33-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c17b5d4-150d-4218-bde8-08ddbe9ab3d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DaI+RIyVMg+hU60wY9RpgPaQSyliYVMVD8RntfJbVvR96MaNJMjw6vRgWsAU?=
 =?us-ascii?Q?byaz6qMNBsXkwn9DK8C5XbIQ03/I8DJLt8+3vLZQ6YPloNFrPahkAr6kzJIq?=
 =?us-ascii?Q?MtkkIMzV3qEwdZnvES1AC5A4jcOsM2EswtYMWlsLiJzFd4Oz5xandHh8Ka1o?=
 =?us-ascii?Q?2TG1mIhGUvS1OZ89SM47zgSaMabKsJqJ4xYfFs6sPYmMKU1OjKK3jcqATl20?=
 =?us-ascii?Q?2yHutE9geMT9BYKtozYnzJt5o+vNvROzzAdJLwjnnwwhtxQdS1K3fH93q2GD?=
 =?us-ascii?Q?wnYb38B3XVULzp6DF9WIwAmCRJbfeU3WJejRcQdP8dcTYpEkv2VEbhxFeNLv?=
 =?us-ascii?Q?suLtDHRTaI32YudkUbhlFcoHLcX5tBgNzvbo91xdXMrT6AlzYZHkS9aEG2km?=
 =?us-ascii?Q?wWJ5ZxOWfd6K9NWqSgepRQd2h4C9q5omLcgIIvC6rW8vCj8dk3Z/5y6rXJDr?=
 =?us-ascii?Q?5PgubSn65T4/LSSPjhscSCx3TTDSVmIFJxoS8N4ibZDhJOehflDkaC1/JozO?=
 =?us-ascii?Q?5Izkk7vw21rXnDzVYU5JeGMa0NTchj12XaIct/O6PAWnyqXW2GLRVu27LttN?=
 =?us-ascii?Q?SIhMN7KT9dX/PNuWJQNGPzPbPLuofhqqMU04PSZZwj2wFz7K6WL3DHj3Z5MN?=
 =?us-ascii?Q?cstXlcFHSb8IAwzJtgKdxuTZKw7eR3Rh67XdIa3y4DiLEKjz2K3fY1W6ZQxY?=
 =?us-ascii?Q?CjnBdXkSQEQXk3ZewCvaZgUoSIg2BP2u5HfR8oCa2k4jJQ0k/SEEcrTajcMw?=
 =?us-ascii?Q?dLYe/fFWGPq6/tKRyG2KlZEa34p+qpJ/jhmV10vwj7e8dGnmmzt13v4++a0m?=
 =?us-ascii?Q?Pire6DIC9JsIiMuRFZkwP7Q+3qhdlFcclmE4CJktcIg1JZ39RlC9vNxSHqnX?=
 =?us-ascii?Q?GMXzYmofI6f3i3Pl5DH15ZmRx8ue6ProJQJUOZ4RMGIm2gFyCsH7seT4mDfr?=
 =?us-ascii?Q?ZRg8KkcYX8YJb25AlF91sQob739CmbBmqAwRsWiXJfWxmMYbt5R8DQ3e7kVF?=
 =?us-ascii?Q?Y5T2jTYZk3cN0W9CJDeYXSe7iL6sjjA8wwLCKKiKLo9vrMIfmYEVShP2xSY+?=
 =?us-ascii?Q?lkoH7t8nzOD0ep6esofuvVITsTrCUiOvqA2F6dKITGNvsFYDExLNlOFsAAJs?=
 =?us-ascii?Q?1FycaN6CYvYt4MdS8go+ek/6+tdZzdY5IlKT6uL6l4f5cUkz871ZOd/hnfud?=
 =?us-ascii?Q?/8KmH2zXPQ90aWm5z5b6M9w96Rnj7v68oWOW/AoY/GvVbZ1p0tZVO1XnU5pW?=
 =?us-ascii?Q?xMyxLBJyf7J5urJLueyypWSYyKMdw2IRYDux7YKRqmBiQRnrICxp/zyEf9aq?=
 =?us-ascii?Q?0P7fBOPuoA1TC3nmlDVDA4i2kCn1yuMYbC6OOJu/gGevJAT7Q/tWxoLrcmwb?=
 =?us-ascii?Q?GA7pyOTOuzp7Pqmeu8YIKj6FjTV9HACtPwgf4v7qsUWgOp+SSAikFa9aEAXT?=
 =?us-ascii?Q?lnIwovq4ck8BsaYTFCfLJTSzWyiLgN3gpZjOmaGHGKu++faEibV3gI6I/wll?=
 =?us-ascii?Q?LumJl9QbVMC7uEpotr9COUTAoufzysUHNtd3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:43:00.6758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c17b5d4-150d-4218-bde8-08ddbe9ab3d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946

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
Changes since v7:
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
index 9c74d1faf3e0..e8a32a3eea86 100644
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
index a527d7e4477c..417ea676c37e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -345,6 +345,13 @@ static void init_apic_page(struct apic_page *ap)
 	apic_set_reg(ap, APIC_ID, apic_id);
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
 	void *backing_page;
@@ -395,6 +402,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
 	.setup				= savic_setup,
+	.teardown			= savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


