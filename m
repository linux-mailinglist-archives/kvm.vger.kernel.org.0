Return-Path: <kvm+bounces-51859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B70AFDE65
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97312586CFF
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBDE21C173;
	Wed,  9 Jul 2025 03:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rXCenldV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812A1FDE22;
	Wed,  9 Jul 2025 03:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032452; cv=fail; b=N2opSbX05h6wr8AQdQI/y+f6EDnVpicmUum+e8oOF5FL+8HE3h0XyOb9JGdlMJhuRuziV8rBANZdqHlDkx89LuxkKk4wT25Uhu6nsGMi5XOx0bnecNFh7Yop3PtlCz5TRmr+LYzBbC88pZ9i8xh7bH3zg6Ematfa6zwG0CF4eC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032452; c=relaxed/simple;
	bh=bGJWKoFLQAA9EP/ljNzdaEFWa2oCgHCFnj+9dSJU6Bc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+pS99R/9btqDmhh1kmZs8A9JOkb6+rNlHSxJK2eT8h+vS5n1rSL+TdPim5ocGzY1yGcfA24f1P3pxFSiCB8pJVtGEH/V4Cne0Hdw2aagqkrcIQ7UysCotABXX1AZ9HSW2XZ1ZnAWg8Hg85icxRFMciQ6MqF0dHLJOssGeLPDIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rXCenldV; arc=fail smtp.client-ip=40.107.243.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sMVTOcQnvg0NCDbXb7G2JDw1G5dKvp/7D1q9VwUP7kt+w3NxMbxsBYZaLafZUuvhuYpDGkTCDRSJKCRjzdjH6ERJI8zzmdu2R3fWmQbcpBML27BRaSrgJo3RuR6ESjVwCiclpb4WFTZLaMb973SVrAgY8wm+EM8BDTdxKcV2Ok6cWYALz+0rH45L6X5F8a/4EGBshfWNZtExv9b6EGhkxmECYwGHJzCHLST110hi3ULgf8yIXLwN9pWnJb2pbVrj69wfhW9J7IC0qmkTDssLXjaaA7vLJbY29nrVnH8JBcyAcOXUUFUTBPoSobDJxNttGX1/XpEvCKI/ZcCHt/XJSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxE824oSxYO1nyhh7A9vtJhaIX//xWDOSWOQhyIc4pY=;
 b=DO6fDoEdyI6jrkLWbSHZvBO8XZ/PGZCFxNZ63CCjALPGvjy6GBE/6SLVpt3eOpvgZqnsRWM082ZvENLLyq/n0URRZBm09z0cHyXxvAUhQ1gfS3QcEYcpiVOiZv2Fm2jmSIdmEC0ajDw9TUatrohFCKl9ZmakU7WlztiMjtQfDOE7myPxnnPThWxhfG1INgf9MR38odDMXYhdcXB5YNwZZIKhFWelLdVWqxMqOz7JzjYTRp+nypuFxuSBfleNj3zRsk/Hs9vw9hYYLE3yQ2wwoT3USK5A/AB5v8YPHIi/STKk/bdANWo7sy4MGPtxiikWVkFeDVwBQ0S64IWtljFnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxE824oSxYO1nyhh7A9vtJhaIX//xWDOSWOQhyIc4pY=;
 b=rXCenldVYQhT/XnBqAGdzCNwLd1eksgV0NR+oc8FB41MZLxDLkaIa0xYxU68v2/gi+KB63JakUSLkxi/z7pxOvm3KoRB1XioTgyXbCWkaOVHb8FJc9jGG+iHBHA9x2sZmGR5XBpi+vMCbx9enpmowBIWzOxRM6vXS3uL9ZaYDG4=
Received: from BL0PR05CA0018.namprd05.prod.outlook.com (2603:10b6:208:91::28)
 by CY8PR12MB7314.namprd12.prod.outlook.com (2603:10b6:930:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Wed, 9 Jul
 2025 03:40:47 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::5b) by BL0PR05CA0018.outlook.office365.com
 (2603:10b6:208:91::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:40:46 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:40:40 -0500
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
Subject: [RFC PATCH v8 25/35] x86/apic: Support LAPIC timer for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:32 +0530
Message-ID: <20250709033242.267892-26-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|CY8PR12MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f1fd66c-c03a-40fa-da13-08ddbe9a6413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7fRlFStB1BwzIWZoUb5fJeGqCqeT3DhDL1Z4cSVMSci9nhs6mh7il27RBhH4?=
 =?us-ascii?Q?utqgOHvLIjJwMNK4m8SKiR+V5p+t9ZJblRFe4kN4YcAdyKgZeFrfVIDGT69u?=
 =?us-ascii?Q?asvrJvJtDL0nbRT065s3XwB/stToDnjoPiM/jG/3i2Eu1UmbruDZXoucYkVj?=
 =?us-ascii?Q?h8MOO3EcrwtYO4A0bdN55400ve1WYOO8y9k3dfPPJTQTG4QtJnEwmisV9Oow?=
 =?us-ascii?Q?skmuKJtGCrJNOP6Hg1I3ppVfTm6Hm6zTTlEpA5ch+wPVCLQag3+pVoTrqKE7?=
 =?us-ascii?Q?1TY4aV2TBqu03CiOw+gyu6RC8cB6U74yQdaA22nzufsuG8/7NJCqhRBTwdjx?=
 =?us-ascii?Q?02PKCZsMGhJ+sO6lL/fQD8CbjqR54X3tVK8RJWQQ5L+HdmDFv7te+FiUVqqB?=
 =?us-ascii?Q?GUWInvchZTp1tpci+f6CbRp0k/eNdQicT+WftSOIVj6T80eVAk5/YefOiBPf?=
 =?us-ascii?Q?mK1x/pz8wuuzX6M0IEj5Wjpu6/rO+v5ODIYfJsrdX9KkC0LE6e+4yLqlXDyv?=
 =?us-ascii?Q?gJObvO3nckBJj+eAjLRB8RKGJRgcBEmdXLW61RhcGAKNxiSHxASKDOc9BSph?=
 =?us-ascii?Q?3EAHa4CC/IlBOIB1GyXpdPqgQR/cJ5wZeprR6VrUfpZLoxkbZmkNMJmBEkrv?=
 =?us-ascii?Q?ux8ZIvxaEW1a2Whps/G6CjXklBXYGqg1aHBiCFQ0WS3EC5RxH7cnESZB8vOs?=
 =?us-ascii?Q?88/OO/1PXr4zDmOnTtIfHq5ZWryBlwYTgmRDTuI8p+WlLmaZb1sbTg9miukL?=
 =?us-ascii?Q?se6oX/Z3vmR3y5wUgBg0J+xCDQwaXz1xTycboSW3WsBaF5DJIPo2YkoFyKtM?=
 =?us-ascii?Q?a1jVVBV8FRJou2eAOyUlVR7c+hl4Jeq0LUx9If9omb+p90m3jCicmnmk/Y4H?=
 =?us-ascii?Q?I8FbzY/8Tqxs8JoqsC/CpmOrUKUVuPCtf2Y39S/kc7FJhSHAQ+pyEz6No61e?=
 =?us-ascii?Q?wjvKb6m9bFHtk9BiP5faHe/7raFvd8Q/tMZhyVXXilc3oU7XmE1RXSEmzRho?=
 =?us-ascii?Q?yKvdea9kQCXwmGzJNOy7HF30Ep1xWizrAVvqAz1Q/fVCno9IySEea28UNnTw?=
 =?us-ascii?Q?xxYmP9+c8ptre5t1D7PXPw5TjKIbdTyCYxlQTMT6DJ0TYnN7MJ8lCfvbak2b?=
 =?us-ascii?Q?sMBBKMlsATRmuV2I2Rk4OgOJQYeqhG7ugwo8mLD10oZcY0s9sJXuFt16tPVJ?=
 =?us-ascii?Q?3p6Dp+QbMzrDg1ZgkGjO/E0WlLxLu16KEbvz4eUloPsbNsXPnRuefWojKbSV?=
 =?us-ascii?Q?EppNKziTLHf7Xgvn3oAROzTODfsQ6yIRhIHPLY2Cr9TO2bnttDkvyMvGcPcQ?=
 =?us-ascii?Q?TsIbZxmsBd8Q/qmu57IWiGWl/rGqnIyUa1+zGk6/VEMlk8L9sROrG2KUqyHV?=
 =?us-ascii?Q?97tpH21aHFHUcFsdzoxRIpzyoIGrPVegCRLqptrVCVq6C4AP9RwuItan+MUK?=
 =?us-ascii?Q?ZkaIJg2wiBNG+3gZuVc01LXg39xTnyeCMyaSfSlxJOjjbXwej/mvL1/mqK+S?=
 =?us-ascii?Q?8z/WnR/QBTQjWYASzOvL95DJ6Fnle4KCjjVa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:40:46.9315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1fd66c-c03a-40fa-da13-08ddbe9a6413
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7314

Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
KVM already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 221a0fc0c387..3f64ed6bd1e6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,32 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
 	return 0;
 }
 
+u64 savic_ghcb_msr_read(u32 reg)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = { .cx = msr };
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
+	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, false);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) read returned error (%d)\n", msr, res);
+		/* MSR read failures are treated as fatal errors */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+
+	return regs.ax | regs.dx << 32;
+}
+
 void savic_ghcb_msr_write(u32 reg, u64 value)
 {
 	u64 msr = APIC_BASE_MSR + (reg >> 4);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e849e616dd24..d10ca66aa684 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
@@ -609,6 +610,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 36f1326fea2e..69b1084da8f4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -592,6 +592,8 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	apic_update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR, true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2a95e549ff68..e5bf717db1bc 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -64,6 +64,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -184,10 +185,12 @@ static void savic_write(u32 reg, u32 data)
 
 	switch (reg) {
 	case APIC_LVTT:
-	case APIC_LVT0:
-	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
+		savic_ghcb_msr_write(reg, data);
+		break;
+	case APIC_LVT0:
+	case APIC_LVT1:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
-- 
2.34.1


