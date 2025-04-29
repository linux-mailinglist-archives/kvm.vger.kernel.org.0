Return-Path: <kvm+bounces-44692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1C6AA02A5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45E4A189FC3D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB50427465F;
	Tue, 29 Apr 2025 06:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5apUASze"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E3C1D6DA9;
	Tue, 29 Apr 2025 06:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907117; cv=fail; b=mLmZaZv9/FwWj4BCDkvSBe1/Mah98MLaAycTScjxFWwaYv5RrN8/AiHc/PqBV+mOUNVnjxDnb/qPn5ORiKzl6meFOPthIM7Gwf78cEGiLXcQx9O6COd/Hru95ZZP0jXm+LOTtZ3fqc2pARx6eZhPUCz7UHeBMU76gskvk5NZy6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907117; c=relaxed/simple;
	bh=hAg3tXE8NmqrNc/XQlhIO3ZUdJGEwoXTTo2ATdT1ey0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FD8TP4ISpohf2JeDehDRv1N43R2MBcA6l3yyf0weQzK5Wv7PY4cebWUAUbtLW2InVIk35Dd3tpgv0jINy7fzG/L8CQx7baMMmEOG+p8Kbx74ODD3dO4EC2c9JKuJiU8HQbELQH0KqEBM1jHI5HR2YFjoHBZP9p6Mugg13sn5zw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5apUASze; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URrAPp3cDbsVO9r3pyAXCrM3sERMEUXjnIEeZgOQpknS86LtawIoK0o+6Yvnh2ylsQHcEzP7vDY+SgXiS5fPB00Q14mmIDB1QPHt7iN7G+/uixlveCqTG/x9HaLxsoeuxKLeDP0MGnBxOTHerk2q8KIlDYBReX7iuen9pwtw8c1THLlpFnkZpMcYHbNP5JCtesqHFj8JZEOR2HV0oUFv3A0fzIxCqbAnVCs8se9MtjUs8rIQq12/ZijwNcwwHtX60Mff7wZJLs2A3z511nwjH9UZMAWEI+ss8bdtatcVfMR1NsoUQZLW8ub2h8415yU9JitTGUnyXhcxVjgmsneD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BzkIfKp9BLbxRqevF4qHCyseB33su/PE/dLm1OEpK4=;
 b=fXDjDIs6dzI8I/A0fOrFRoBOtgZuyWRiOjQNB9r1Qs5etlZOtKvW1aIn6eTJFo2WpU3OZPxIwwVeOSzoEVF0Eu9rClwrSPn7NCfvY+oRotJA7mvq2e94v0Cm5Sb9C3qeEwZHqM6jc4EKDhR+JFW8fDv8rPBRR0W9n/7Pqq4Htq3NXl5d26Yc1Cr+LSr5LWg7BEasj607H+KgaD0e59DsJTIwXmy4qb9bBkiCwjVBjXvgKDsJHrFKFmtQw0IeKWn741/3lLsxfqZdk7Mzi/2A3XfZjkp5MGfLBwbekM9tuW7A1P2wyZJ3OzD7A4JOFr3edzsDfSSZMlAyIWbp8Ig6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BzkIfKp9BLbxRqevF4qHCyseB33su/PE/dLm1OEpK4=;
 b=5apUASzeHwoWW5A+g9nPk3Rfe4Yx0NbcTOqLa87JhKsACMn9jG1Nl4EQSAy3occ1W4CnvvOybwhAN7tir9QGsFSSdt4r1cgX5U6x+El3y1ikofKbtDCM3HCf/YuDmQug2UQjjUgSI2QgC6m4+/0SMGKlVkl0lbFes6HzUKTCQ5w=
Received: from MN2PR14CA0008.namprd14.prod.outlook.com (2603:10b6:208:23e::13)
 by MW6PR12MB8913.namprd12.prod.outlook.com (2603:10b6:303:247::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:11:51 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::b3) by MN2PR14CA0008.outlook.office365.com
 (2603:10b6:208:23e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:11:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.20 via Frontend Transport; Tue, 29 Apr 2025 06:11:50 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:11:43 -0500
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
Subject: [PATCH v5 04/20] x86/apic: Initialize Secure AVIC APIC backing page
Date: Tue, 29 Apr 2025 11:39:48 +0530
Message-ID: <20250429061004.205839-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|MW6PR12MB8913:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a923f8-7de3-4ae3-49dc-08dd86e4bb3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8rzIgsOWtZS0e5BvZDoAhzHB5wEbQdoen2IoGLRFpbTtnLPmf5ArrqVQtiTl?=
 =?us-ascii?Q?d6fInAoDThskTk6rkyeWPosnkihF1sudckED/WbFbKIhkm6KSWm9GaIh1ulj?=
 =?us-ascii?Q?svhy51HtBrMhW0EpQgl1XJKx2utTZUigLRjNAxNq3EkWwXHF6QFo4Nj2hDar?=
 =?us-ascii?Q?stLFjFodVuaz+ipumorVLoMF0/3UiXSYBahgZrQsXzjcpdWwqjXJVXIown8g?=
 =?us-ascii?Q?8YP/1ohvgJ0diIZn/1A1Gl/uPy07J0R3onn9QaLsP5EdZZe23Rqn9Y+KN/P/?=
 =?us-ascii?Q?YEKHLjXQEmd84c4l/mxQGAZSbBMzLfaGv8jBhKpazdxt3ziEGa7S7bZRq1pv?=
 =?us-ascii?Q?AS66tVTLDfEHFfu4gOFZmEhzRtc3li4fZnMpQ44w02Wvhw1oHCcBETJYLRsX?=
 =?us-ascii?Q?CFD4ZkPs1A6UOpQRWuf2z9GfhyIECmzQ2hmYYWGmyL7I5xUA6by6lEoV/F9S?=
 =?us-ascii?Q?xJq2oRp47gMAL/elEcgY4QzzK2NUayuLQXyVqpx6Aj00Yf5cmvNtSmyKJQw5?=
 =?us-ascii?Q?wRiqHFTl/diPX+RxgZ+DECZzHA/0i63UgwMbVRr6H3ydDQVu4QzSsnz9q+fg?=
 =?us-ascii?Q?92dYjN/FBS4V9+UcuIZ95pl7A32uiaoM4Re0WszOCDXbiWLyk4QXRvS0e5ju?=
 =?us-ascii?Q?O8uIaPGx5GGXhEDXhW1uhbOEwXpWtpb271eebFXSscd3V0BNLueSvaQL4Jj2?=
 =?us-ascii?Q?B00rae+JRAzKSe+Rf89aZ5xFkZD2RLOhRP9ii97kh6PZCr4AbnTVXM2kP4Vb?=
 =?us-ascii?Q?jxbDm/qzkPkZ6B8Qvt09f7+8qfYMtEEqDwjrfA9SI125ro07LSXpa7hAdMUL?=
 =?us-ascii?Q?erED5MAcuFKkV+/VRCrVQ6bd5uXqn039VGJmNu5io0wNWZBleLNo8zG4sTY3?=
 =?us-ascii?Q?MQn/+I7vb5G5EBLIj/a6xNYiFtlDVGFy5YbMsUn+4UQWVaZUyHLAUq2yC42c?=
 =?us-ascii?Q?/OsKJHKv0WTvgNej95dNE5dQwT0m2ogtKFMUIGgIeSXuiL4XVzblbldvZjXK?=
 =?us-ascii?Q?1jL0W3I9K+Hz7sXIrsRaGoVb6ue235bzbbCigmaKHgxaQ1khlDqN26+oCiL4?=
 =?us-ascii?Q?hKFDQNtwWX6quBq50hFZyrKqgJ6e93kSpti8mi3RSS9WRiGAFwCQNlebaVVh?=
 =?us-ascii?Q?m3lM5U/hrP54TgyJMHJQLB3/lpebdhS+gQOK/TsgI562hTuxEiJZrb9V8BYn?=
 =?us-ascii?Q?7LfLgHsCvmpkpdC5Ozu3SMcBtCfgqu5AfhCxz1rS2zb60Dza8ayEUJ9ytLpy?=
 =?us-ascii?Q?FuWc6Yc/tP5ACbnCJFW15tB5Hp4fUd1Dd81taxyMv0QKtPORbzeglEHOdbax?=
 =?us-ascii?Q?VyFcDow5C6Tme6WSzBZeTAvJVKWdrvVJHbHdOGT6jRDUtjoHIr21+hspVRXB?=
 =?us-ascii?Q?0suijbExQXnuOrjFviJX3cEThr61dcIkSrwyMouLxCqk5GzNkq57OLwOVQ8E?=
 =?us-ascii?Q?Jb9RHnYGOqP45dLHYgpUBOtPGWf3pfC3FO0sxldQ6lO61hy5B4sGKd08A3j5?=
 =?us-ascii?Q?SOmlMs/lSGgGZcEtZcdPXSUlXqY03qmzn9rc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:11:50.7927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a923f8-7de3-4ae3-49dc-08dd86e4bb3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8913

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
Changes since v4:
 - No change.

 arch/x86/coco/sev/core.c            | 22 +++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 +++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 42 +++++++++++++++++++++++++++++
 6 files changed, 74 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 5b145446e991..bf03eaa6fd31 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1004,6 +1004,28 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
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
index a05871c85183..16e88449dc62 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1502,6 +1502,9 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
+
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


