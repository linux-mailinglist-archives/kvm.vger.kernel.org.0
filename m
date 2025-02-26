Return-Path: <kvm+bounces-39259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6A3A4599E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90AEC189B93E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798F52459DF;
	Wed, 26 Feb 2025 09:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KRz5u8Ts"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F309C210F49;
	Wed, 26 Feb 2025 09:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561004; cv=fail; b=qgJDyHej6m3LGACDbXaYEeMCVkK2gnQ0S1lRwh+og6mIGsVBTUGG+ovboBJqDrJ9PhIVBcIRjag81PhNkOYRwlTjN8j83iT4S291/UBOXeRQu1b3LUrQJmseF1PKClelFbtAOn+Gp9G098cl3Ty7oZSsvsrunpXiHqauHjHJYpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561004; c=relaxed/simple;
	bh=1p7gkVUnVNZ5L9oMsrn4uiXFDo3euwLL0HjAjOZSI3I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ss1yDwD6uAUiO9hwA/QbCrvCmRBYitUv1JagRCjY6ZZT01ZgzrYqFi1OqV+5FSnEs2oYhoOuB96fglDwjty8wuZDUUvphNVyOs7i9yTcD+ouRvbnmke33DcfNHbf9GSPcm/8Ii/V9eAl8qXqBk8yowdEsAGLHeHons5YvyXbdJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KRz5u8Ts; arc=fail smtp.client-ip=40.107.244.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXVe7IcN5TekqdTKpclUry7o8zta6NfyvnOafMz26TMHaIBgPN2325H797ABbOR+K0oCYGfxBhqDvjDv5sK2Gtj+P7KbncN6NuQ2PQvLZ1w9EUm1TVGkhvDyuC15iAVMBPX27GEjmAw1dQGuKdFVQFrlTB2ngi7KIq2yS9rGiRR7DmD8MnyJgDX+Gh+DJRnnd+95B/YqB52PN1ONtLpKlQhdM+pUn7VljNd40D8sbblPIWl5sPA8DkdOAxt1gKvR4SHBb7IjIK6e7e56J+Caz0SWxzqFb4rNwDcZZUMkHzQQNlqQSwOdRPAAawHryakKXAM7v1+yuScq6ThlmYEnFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GE7VzxV928GCdTH+EaA3oph6oLlypqMAo/uitgdwfc=;
 b=TC4WGI/2y790z0gE1dO1WmyhhNaHGFIDR/sBGqJqicp4iAaGHNVdgZf8mUEacwn8jot2cfoAKS5tghr3GypuLd5NL/b+1Z8LSnLVm+WCBRoL7nAKFBO1A1DmljVHGjlu7wyQNGNechgXkj390vcwX5OhhIKflHSshznY8SCIfNF0SNVh6EbE6rQtooZjzUMPfqIc5i+osLgPnBDuHwYKBmLEFbl5zuk1mJSaDpvKHdg1Ns5lnwX4rl75pov2Ddm7JYKrln0a6kddClyb03vx9hgz5GU6XfXOf4h7UKDmWMhmbYpCoA/qzZaNrMMxI6z5SZfPG00ZM+DDYesNrIGuyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GE7VzxV928GCdTH+EaA3oph6oLlypqMAo/uitgdwfc=;
 b=KRz5u8Tsfnjdf9PkX/+9xUlM3bTpn3SJYD4nC2k82MxqW6vwS4BIFbtj+HhwZFbpk+kkEmQ4mKp3mTXqTpxZxbqJQKoej+klny3MI+ykCyuUMuLy5HrYDXSFbn1pHQJDmokHajz1AuJ32yF20xtRPvDQxr6FqKCScDJcL0WfDOQ=
Received: from SJ0PR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:33f::27)
 by SJ1PR12MB6244.namprd12.prod.outlook.com (2603:10b6:a03:455::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 09:10:00 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::b7) by SJ0PR05CA0052.outlook.office365.com
 (2603:10b6:a03:33f::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.16 via Frontend Transport; Wed,
 26 Feb 2025 09:10:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:10:00 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:09:54 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 14/17] x86/apic: Add kexec support for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:22 +0530
Message-ID: <20250226090525.231882-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|SJ1PR12MB6244:EE_
X-MS-Office365-Filtering-Correlation-Id: cb8411e1-1f7f-44bc-a4ca-08dd56455952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cxEiqtAp26/Y95nOypq9oMqUQiaJmr6dQHGJBCX7utqqUsxUL1dNwEEiWxWG?=
 =?us-ascii?Q?oYUinSTryzgyPOsTiYzF64Y6MJcDzM+jB553mn7wn8zMb3JfGTIP/n9saZl5?=
 =?us-ascii?Q?Nm2KEGfnxWYYm9wrCn2l2IELCV8VJD4gOLnmsu31C+btaN16A1o9DItasXTW?=
 =?us-ascii?Q?kDezI9LiKn71+vSi5c88bWc4xpROdgbzso1Tp9Wzmenph00xmDntEArq65uc?=
 =?us-ascii?Q?IowHAq3/HiTBn/sSLtxQBPDv/OA9q/3j6yQApK1lou8IoH2L/brerokB7H2b?=
 =?us-ascii?Q?jt7T32RolrEWf5M0WXZQ69ugNb/VDc4Cy4L87mqLw2Nnt3XJ602ehkhiiGn1?=
 =?us-ascii?Q?bfR5MmLGdEn3i5bJW0Sl3tLrfxEVAtDMJk5FWqzLCSS49uL9OZ61r2ZpnZpC?=
 =?us-ascii?Q?sheyP/S/GHjTJsXT0AxilSOH44xRx29h6MsO/cMN30KPHNvWESJmYaG1pyEz?=
 =?us-ascii?Q?WUcFlRV/++L3hvl8fg3/AAPJ+76lcRwoqBo5diWjv6UPGe6hgH3bIVp+WBla?=
 =?us-ascii?Q?NiGPadBh2jRxklKnxM3+qqPjdOb1NIx5OYZAlC0J2OOGObiiYbTBatlgkRR1?=
 =?us-ascii?Q?hfAEJGHEywHXPTmduc+dpypp1FeEkmv6JROSUFhC+srbf9Um14t5K68dpOv4?=
 =?us-ascii?Q?rozXI3l/NOKE1PHag7x7STzTQxBvuM/YYk55xH1vBZO5puOkh7QW7bHnjr6Q?=
 =?us-ascii?Q?r1wOIt05APCA5Ho+M3Th1jD/3aCUUSxWAoPlxRhfSTXz3fe1uBKR0rTQOn/V?=
 =?us-ascii?Q?3t4SQlfVWG+ofsdOQcZWrQAWHt1bJTxvGcmFIfoX2W2JJw+dhiynduPAI9zB?=
 =?us-ascii?Q?A0TQawPP50TzLcgQZLo8BH/YhhXJq/kbKXM47lC2FHzQHBJ7qj0wXeX+oJX8?=
 =?us-ascii?Q?VZ/CdrWSKF16aOiNbzXoBjXTiAfzkXtMvMJLq69RfUNOQsQSAwuvr1VMfVmh?=
 =?us-ascii?Q?JKWQCVks6bfLgA8gtqb1OKgIBeUoE4l6NrtKny7JXyzGMHqGPOJnavgTZOLE?=
 =?us-ascii?Q?COgrVkfRukHt7dyR4dRExdFgf2LHX9Gp4SvhHbn+KeioahVnFMAYyhw66ikt?=
 =?us-ascii?Q?x6sBjvI4N68hEjeo2eku3gp5gCt1HvWcqalcAhTUKJIQMHlAVTf25Z0UsBwP?=
 =?us-ascii?Q?bXU3cRH7G+e4opX+uS1J5RNbT+zIm6gjHaIZmHpnbVnYKu7/31lQ5mEbDcik?=
 =?us-ascii?Q?G4mre1do08R0vAktV74Lzz8z+4dmXUWb2u9QNbybfL2d9UHraYXyqL02wv0A?=
 =?us-ascii?Q?a2pJF3RuJIXloHEsx/HSF1svoZ5Kvne7sppzdjPQmZBYhTV1OEhVxOYlFD7C?=
 =?us-ascii?Q?BaVZAABGHQkGO4aMm/imscaQx3Vdk+trKke80brDOW5vRUg7bioBQRfwlb7W?=
 =?us-ascii?Q?fTUBpyOjP+punqojZgmAAzFh5eImaW0umJrzjTVOICG0Yx3bFUn0CTtbrkhI?=
 =?us-ascii?Q?aWZlk6Uep5xHpGwG0J91S7HxIhUnP2ExhRQthEYeEK3QRQWFztT+2Q1EUCvB?=
 =?us-ascii?Q?dylpTpbfbsDGYeE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:10:00.5923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8411e1-1f7f-44bc-a4ca-08dd56455952
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6244

Add a ->teardown callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. Such accesses can happen
if there are any APIC accesses done during guest boot before
Secure AVIC driver probe is done by the new kernel (as
Secure AVIC remains enabled in control msr).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - New change.

 arch/x86/coco/sev/core.c            | 34 +++++++++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  3 +++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 +++++++
 5 files changed, 49 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 248ffd593bc3..e48834d29518 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1596,6 +1596,40 @@ enum es_result savic_register_gpa(u64 apic_id, u64 gpa)
 	return ret;
 }
 
+/*
+ * Unregister GPA of the Secure AVIC backing page.
+ *
+ * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
+ *           doing the call.
+ *
+ * On success, returns previously registered GPA of the Secure AVIC
+ * backing page in gpa arg.
+ */
+enum es_result savic_unregister_gpa(u64 apic_id, u64 *gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	unsigned long flags;
+	struct ghcb *ghcb;
+	int ret = 0;
+
+	local_irq_save(flags);
+
+	ghcb = __sev_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, apic_id);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
+			SVM_VMGEXIT_SECURE_AVIC_UNREGISTER_GPA, 0);
+	if (gpa && ret == ES_OK)
+		*gpa = ghcb->save.rbx;
+	__sev_put_ghcb(&state);
+
+	local_irq_restore(flags);
+	return ret;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 7970ead55f39..3f129c66529e 100644
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
index 043fe8115ec7..e2b1d96b54e6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 apic_id, u64 gpa);
+enum es_result savic_unregister_gpa(u64 apic_id, u64 *gpa);
 u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
@@ -531,6 +532,8 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 apic_id,
 						u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result savic_unregister_gpa(u64 apic_id,
+						  u64 *gpa) { return ES_UNSUPPORTED; }
 static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 static void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 23a566a82084..feb2671d1e46 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1171,6 +1171,9 @@ void disable_local_APIC(void)
 	if (!apic_accessible())
 		return;
 
+	if (apic->teardown)
+		apic->teardown();
+
 	apic_soft_disable();
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 1d6f30866b5b..6290b9b1144e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -377,6 +377,13 @@ static void init_backing_page(void *backing_page)
 	}
 }
 
+static void x2apic_savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+	savic_unregister_gpa(-1ULL, NULL);
+}
+
 static void x2apic_savic_setup(void)
 {
 	void *backing_page;
@@ -489,6 +496,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= x2apic_savic_probe,
 	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
 	.setup				= x2apic_savic_setup,
+	.teardown			= x2apic_savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


