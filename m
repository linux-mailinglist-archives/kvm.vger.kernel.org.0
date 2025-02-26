Return-Path: <kvm+bounces-39244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C43A45970
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDB7E3AB79B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2D6226D0F;
	Wed, 26 Feb 2025 09:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="01iAPTt5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0890F20AF8E;
	Wed, 26 Feb 2025 09:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560787; cv=fail; b=G/GzypAg60IX0zoARFnCowqX/T28K4G+kasN9YKstGKdHqA11kgLDCahv08UDM+E+zE+MLFzJ8bX6i8C53DfjEUAtGVc7IYkNCIS3wZxNAIU9XLUA4JT5ISMo45Vh1FBfWJu4D0IsnzKlEPK3+f/0BqkKoxCK77GUcGdY9fO60g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560787; c=relaxed/simple;
	bh=+SYu31qiseV5CtPL40d2jOGctjaYJsf1UeEDd1Nai88=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOYDf/GEJRzjp/iP7zegtoIeO9a8MMK20odGb6fe2kiHmNVwmD/9gFEiSotN88hO3WES/YG9P+9l3UIayCaoolgCGtBUlqMm034O6C6/+ZOjOcHg8WVE7vOC8cen7+1YXCEDDh58wctRhquFrcaZold7/GcRmHGNz59uDVOLkvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=01iAPTt5; arc=fail smtp.client-ip=40.107.100.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epdyPn9j3wGfBLwMcki6mCS9qwSsnd6gLcBcEiq4u5S5nwJi34V1Jkie4pCA7wFpmh5fQI4FzipA6Cc1y6Pdr14Z23I1J3jRdlXqyMTA5QXbtRR2arVywhB3ADuSiV/ApvDIFq/IquKUzCVqZqqWnsw8fANtMzTMkr9CgMzKmBg6W7UDrF3wdBePP6eV+CfFYSjHDIY6w/Twcjmfqns8HB30YsrM07g7SuqOqLQ8Th1pQmuP/VD8NX7FtoPwJQLZOo+llyaEZX2wS4/HBQ8eiUBPoE1P7XJnpm8JZtA5Gv/yp5kxI6wBKagUJYRJV6q0/XftHmXznDP9h/HG+564CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ72ZTQ8IAzZQMuyhjih4kEsBpl5nqht3oQkjU1CWuc=;
 b=QPDy6euR7yx/yb0C9n1cjYVCs0/1uQ0jYpwASa4s8X89ajv8zgbQyjL1dWm29/2feWKK7xbbM/EV9SEMjvs0NKHVvdPuvEr8Y9fRweU++0upNTcxFFtBFr2wt2EpxLAtgkxj4Y4Yppq3rS9guREu4cMGK5V1FT1d9CsA+zA/bXJmtd2TxqExzGvdBlO8E05RhV5ZxQRAMrlh7YAEXwgp3ZcHdWBzJFywwOeurLvLL9Qn8kyqlaIpgiBiv94/vwA7HJZ5XQQWKt4GCNa6tgUlH4iIxUICWzuGKuXWvTSInrLVePXDJ2gS1qWoWMxebJsXFlCDHGFJs7tOQCIU8khrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ72ZTQ8IAzZQMuyhjih4kEsBpl5nqht3oQkjU1CWuc=;
 b=01iAPTt5dL7MxJBQyt3ZN9/k+GaaxM1oGPGf+9EadOKNTUJfstixC3DM6MaczYP0BOxfA7HvXdLravBfJg37M5pWxg/cRDSFKiY286EBXcDo8k+DskmoXM+LkFS7WTGhoizWsniD2/IDzegcsGFqjQ0gHTWkwJhdH/7eqQ7mP0w=
Received: from SJ0PR03CA0245.namprd03.prod.outlook.com (2603:10b6:a03:3a0::10)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 09:06:20 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::8a) by SJ0PR03CA0245.outlook.office365.com
 (2603:10b6:a03:3a0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 09:06:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:06:19 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:06:14 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 02/17] x86/apic: Initialize Secure AVIC APIC backing page
Date: Wed, 26 Feb 2025 14:35:10 +0530
Message-ID: <20250226090525.231882-3-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e7a623-f1ae-4383-5d26-08dd5644d5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XmE6JoRFArdJs6JRfoeAeyWfkqsfK3qnmEZrnKGN2gsbPpIL1KGHvMcUMTHD?=
 =?us-ascii?Q?7ECHFYiAIFVraEmPnOSdgm2RM/Uue1yjwuVLyQ38OZViEEWeO5COxLDJQExn?=
 =?us-ascii?Q?purLvKe5toxEUzHTWqh2JaqgTsQVITH/3UrOcDiRwcY829xVJ6dyGT82SCMj?=
 =?us-ascii?Q?yk/BpdJHGmer0moZW4QfqAnpqX7wI24f1TG3wLMnbiDfr8NZjTt9GXHZFSBW?=
 =?us-ascii?Q?Sn8e2lSE0BI8P2P8FMuDQDElOIcYOvltLrJ5lNO7dqL20bgZSxntPw1IH5dY?=
 =?us-ascii?Q?696RZsVh26sTEGYWMnh6O9L9n//Yyk0QL3YZbcKL2qL6ZXaS+t3Qez5VhMjp?=
 =?us-ascii?Q?UnFbMZG2SJeKN6qXyRjAAkmOMvaFRLMFA2+gK+I3vAWPQMpI1mvnUoUvV1bg?=
 =?us-ascii?Q?2qkhlrl1PLwaUcF3CjMLdkEgEWCj0+RlmvHdlyja7ZeW6BC0Fg4lROMltYUs?=
 =?us-ascii?Q?RZRY/Eer5wQl2PljSD9EDmECtFbFRqWdn6mibLDhsty5rjP7/t2ap6aTZkHy?=
 =?us-ascii?Q?1BlPcQrCT8RFXC/gjqYn4Tqljf2BAAoW+W/X8GrhfTW4pTO0T9pFbBGMYxvh?=
 =?us-ascii?Q?+Fh2UMaoaw8z/vT3zyuas8+L9+aga4C+x2GZ+RA2VtIwi1lI3o/A2bK11qxA?=
 =?us-ascii?Q?vM+VjAeZfE+YS2835Ou4aZbuYq+ogVMCjRrB020l8ePy5BQ/a0WgyU8v/aQq?=
 =?us-ascii?Q?1NOWKELqDPVyl1Rh/anCrgQm7QONnFmMCE5G1AeJNNNdGrgqiOQwcy/sOPVy?=
 =?us-ascii?Q?n5hoczM0pf1VDM8WDiB58wwq5R+hhfltfIVgzmiKlYTpvzYwoMOHEksViZYd?=
 =?us-ascii?Q?ZPWC2VPxi12WATLgif4g9CnoqUjzhtRYqRLacepTwHJ3lSOu47PwCCdlQAUq?=
 =?us-ascii?Q?81NsbZDsJb2Ob6jovsr7RPyq0F4JhAJX0r+4l83aPaoSA4PS7gn6MzmwxmTS?=
 =?us-ascii?Q?G5+t0JMGUmTHF8bP5V310N/0fS3NmFwULH2bA9J6jc25VRQiLVr1WiPe0WPd?=
 =?us-ascii?Q?UZiF5qbEKhi2cOrjWDVPCRhB63VmEWWcBioP2Fu2UcKc0LdWyBoUZs19h8bP?=
 =?us-ascii?Q?1oTD1Vb0sTW1m5UiknKISFv7y7eCl30HqiCKhPK+9yccqz0EgEsecaCArnnN?=
 =?us-ascii?Q?mkpwDItS+zbk+2T23FlgR1uXI+3boH/B+LZE4PGja+EWQo/B8vVCmyItZM1k?=
 =?us-ascii?Q?ZLmc5F6lUENny85NYazFsNvQ2d3XVyNbjYoRfBumQ/O0RP1DrsxObMQ7DMk+?=
 =?us-ascii?Q?Iwy0mUFQ74jFofGlMVtb2iHwLhPutmQRICPc13iUQ4hXnKGuO+9zYO0KuyVv?=
 =?us-ascii?Q?uJZgSdz/ZoylncqxUDi26r1LvRC2mxYiJhWT1QIjmDWbf6/XwFkArbk3axyw?=
 =?us-ascii?Q?8O4IRx7LuYq9evkktWuUK8rmY3SCOzWuxIb7WUBt1ZU5dH1H87yAxHyS8a2M?=
 =?us-ascii?Q?UEoBs4CxyQ8fspaC+DI3iuP9ufz4WsZOYQWUUvIMLK4NFf3wF34P/9HMIBZP?=
 =?us-ascii?Q?+ATRWpY8Muh4tHs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:06:19.8900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e7a623-f1ae-4383-5d26-08dd5644d5c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for the vCPU's APIC backing page must always be present
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
Changes since v1:

 - Updated commit log.
 - Allocate APIC backing page for each CPU as a separate PAGE_SIZE
   allocation with GFP_KERNEL flag.
 - Update the GPA registeration API as per the latest GHCB spec updates
   for Secure AVIC GHCB protocol event (yet to be published).
   Corresponding KVM support is here:
   https://github.com/AMDESE/linux-kvm/commit/5fbf231861207edf73bb31742f75e22cae18607b
 - Remove savic_setup_done variable.
 - Removed initialization of LVT* regs in backing page from Hv values.
   These regs will reads/writes will be propagated to Hv in subsequent
   patches.
 - Move savic_ghcb_msr_read() definition to a later patch where it will
   be first used.

 arch/x86/coco/sev/core.c            | 32 +++++++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  3 +++
 arch/x86/include/uapi/asm/svm.h     |  3 +++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 34 +++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 82492efc5d94..300bc8f6eb6f 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1504,6 +1504,38 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+/*
+ * Register GPA of the Secure AVIC backing page.
+ *
+ * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
+ *           doing the call.
+ * @gpa    : GPA of the Secure AVIC backing page.
+ */
+enum es_result savic_register_gpa(u64 apic_id, u64 gpa)
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
+	ghcb_set_rbx(ghcb, gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
+			SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA, 0);
+
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
index f21ff1932699..3f70aa2f3aba 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1581246491b5..626588386cf2 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -483,6 +483,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 apic_id, u64 gpa);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -526,6 +527,8 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 apic_id,
+						u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 1814b413fd57..0bb70c5988bb 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,9 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SECURE_AVIC			0x8000001a
+#define SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA	0
+#define SVM_VMGEXIT_SECURE_AVIC_UNREGISTER_GPA	1
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e893dc6f11c1..1c0b5f14435e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1504,6 +1504,8 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index c3a4d387c63f..c444161d81b3 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,12 +9,15 @@
 
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+static DEFINE_PER_CPU(void *, apic_backing_page);
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -61,6 +64,36 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void x2apic_savic_setup(void)
+{
+	void *backing_page;
+	enum es_result ret;
+	unsigned long gpa;
+
+	if (this_cpu_read(apic_backing_page))
+		return;
+
+	backing_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!backing_page)
+		snp_abort();
+	this_cpu_write(apic_backing_page, backing_page);
+	gpa = __pa(backing_page);
+
+	/*
+	 * The NPT entry for the vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	ret = savic_register_gpa(-1ULL, gpa);
+	if (ret != ES_OK)
+		snp_abort();
+}
+
 static int x2apic_savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -81,6 +114,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= x2apic_savic_probe,
 	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
+	.setup				= x2apic_savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


