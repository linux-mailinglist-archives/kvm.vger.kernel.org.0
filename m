Return-Path: <kvm+bounces-39673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CF3A49468
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 696717A2CBE
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB652255E3C;
	Fri, 28 Feb 2025 09:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BLNnYoQF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29511276D3B;
	Fri, 28 Feb 2025 09:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733677; cv=fail; b=EQOZiYd78JoOusUYizqdfHgL/pU6mKeAw07n8TwVM4JeOrv1KfsdavTB+5mKYudELZ+l6QMbNypuGrrGtsgwAQIWX33Y81vPgUpvSMd65k2V2GCJT6PCcWA9cpxbVyZbrJkpcUr7gStPHcZ78EDDjnW4snhJi4xgXEQXdLGNYIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733677; c=relaxed/simple;
	bh=4yaAuVUq9FYLE+UVYA3CqZmLEtltAsypSJWPARKDt/I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2N0KNbQansM+psVsm4c0ztLpoDpFcNFK+LercoEQOAh3LA1bM1pWtRamdtYAmLo2e1wcvwLChjfHwbjOEbLHrVON6rM/N19M61jwsm5rz96WM1h3QE6EMBHXC/bdDplcJvtJQKVBJMAvnkhgiIJbR98NnaTsk0bYp3gitdeY8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BLNnYoQF; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hv/oEl+RG4ql/RMrJ+Nbc/DlyS0ikfUkXHOSeQmNBV1LPNnUeGn8oD2Wckjx78rEjt0aJjUG4jmfjl4xtXRjEx8WftNB3T2NAY1zNjQmLMWnP8o7iSs6Z1iXKE3AdR0Sc4m3W1JO+B+VqSnxam4h5kgwzD5oPRylo8zYvl3pCYpZfnOnlEgz8mIfUnyFjuvBL57VrN7/TVzAPGA3CcsNhGDAhBgX6JznJE1pWRzDyD/9v9wkvYvQwPfjdHMkY4eGO57NmxqZc7ln9NqHLqZQSKqzXBxX/Sjp4xoHlUdhk+UvRL24HgxRpFatvSvwWUUSCHB1mpp8bQCH2yRuFC6nzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05lQPpANyB29eGqTjydQNn5Au5N79v1L7wmR3mMcxiY=;
 b=IqJveA92hFmCoJJvXbq7mgOXP//0oiKMOxlBcWij4dNQKWswVpdamvDRuuULGizLsBgdyjissFfTYVk2YzGtIaKq5+Sz4Eutk+YoKgEzp4WR48XVj39apuMCFi9xCJ1tq5UQNmtExeb6jH5vtuMUuIYPIbsSBBGGCRxbnrVv90a29YEayXjYduVWKOvC71G0sckAlCjPkedlJAFccRPpSlqOrpZ7KgxzAGkWYrykamK5c1LRvQjWuNfzZlcJz9jh6/MCX9WBRTj6QXnGm9Sb9vqIRGoDJX6DeiKfGf8DPjO60+I1OpUktOimU3pWDdrCsXloG4eVdeu91vtzXb4sDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05lQPpANyB29eGqTjydQNn5Au5N79v1L7wmR3mMcxiY=;
 b=BLNnYoQF2Jep8m8Oq+OXHBly7+qV9GK2HSZJZ7WY+IU2B79Pcr2jPCYFucP8sK5xD8VV87efRHLqdMKBwS93mEKXa/Ae9zYVrYKgo6JFMCBmhRytQFs87Gj1ZpP4cPzTqpoPWmansQKl7JQNgCTuFgmeiRFgoALw8IeIOTwpv70=
Received: from SJ0PR03CA0150.namprd03.prod.outlook.com (2603:10b6:a03:33c::35)
 by CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:07:50 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::d5) by SJ0PR03CA0150.outlook.office365.com
 (2603:10b6:a03:33c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 09:07:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:07:50 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:05:05 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 08/19] KVM: SVM/SEV/X86: Secure AVIC: Add support to inject interrupts
Date: Fri, 28 Feb 2025 14:21:04 +0530
Message-ID: <20250228085115.105648-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: f4dba2ce-2b6b-4508-f9b6-08dd57d76050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q1JV41h74LvhCwZoEZRYVoNV39B6365gDBXkyjxXJpysnoqg6mUUwcz04Vbh?=
 =?us-ascii?Q?TwDHwLqY675A9KhdSJ6uWzOIn0q2VkxnoY4ewEnIehhyTCkVQn/d6wwi1B7I?=
 =?us-ascii?Q?5HxH52rv4vE1GiOAGVtWa2TZrB+5MM9uw27bT0bevlHbvQBO0j7sy4GvDwbo?=
 =?us-ascii?Q?1gTTR5CRV301KWMmX8b4CE1oV9Y7HF4cFNZNlR/Th4j7HMziN1ZTsoIpgX6H?=
 =?us-ascii?Q?0bK+aTpb82P3HukC7MUgJ1Zwygf3COY6V039VrXF/ktDz5GOYK3mBFI67Pae?=
 =?us-ascii?Q?B3+GeotfR7lQH7sQLO7UkTzVVversHKMRWkv4xiUuejy7rxweMOTFFpGFQ5r?=
 =?us-ascii?Q?VWc9Zuc54Ei1Kes1N0f+l4B+iQXSAwxuAvo1DOAwWePJieiM5CSL7MqfrNr4?=
 =?us-ascii?Q?JJ6TvY3parutoEPJ+6K9skv5qIKYQsbfpoVru/xwGG1rsO0kzEPfiqzKfbGT?=
 =?us-ascii?Q?CMrPdAEQqQtOu2O/2jkwp+1TeuDnTbDVVcfB2HmCYVVKezVGCL55ZjR0pLUi?=
 =?us-ascii?Q?GyOiD8O9FRygkDNBiYcOWkyCl9kYKjnujkRQ0qUEtgTaqHjUCQl4QU5u1ueC?=
 =?us-ascii?Q?VgBWofbARBMV4omEFsr+SUtky/ujgCR3p+NEsxXM0lzuXjC+3fEAhyZm5xku?=
 =?us-ascii?Q?sP8mASTROMQngergaYQt28O24PrgfB/NyOeml+QtCs+1LJEm6sydyPHzG0Uh?=
 =?us-ascii?Q?w1XeRFapPjge2Q+m5R/Rac0LQwLDZQ+SPXfy8vG2Xl4jaYKk0/ut07HKJ22V?=
 =?us-ascii?Q?EGT8gbkfDMBSOEwJpyoHO4OTPcBG/aJnhI61gulOmYf+gfPKMhw1jQUoSNXA?=
 =?us-ascii?Q?2EgeBtuKfePVFp1r65uR/OZm2seBUAzC7emywHBOFWNG6vZkj/IXJyOHL1h8?=
 =?us-ascii?Q?BqlKwCj9M/yMhd+D8OxcybGcpCKUAR+HnG/NyZUKp5wlY7TLdOASWuHhUBAq?=
 =?us-ascii?Q?tI1KGyCf4Skw2Haz4FwupbGXosnzpN7l/oApNLdUR5h1t4LgmsYYJgvWXtca?=
 =?us-ascii?Q?xRu6cELEpJJP0hQuP2/SibAtnBNFldApHgZj67KNKJYftRFKr+np34sSLajZ?=
 =?us-ascii?Q?WcpPdf/r2CNxAgfZ6MllE8Bz/qYTRzbjtTdJxjLJRaACD6/C+41up+afd3cV?=
 =?us-ascii?Q?xlBnc2jnlHuUglbvZRbQYHleQaMBtfbbG9/pyCP7VAjb46EqGKMCwgPliTYe?=
 =?us-ascii?Q?kiqaizSDL/mE7z5mQbHvO1mO6652ijV8LP8XUeW5HAW4TNY5Rc7nX942HOYx?=
 =?us-ascii?Q?3U/93gol4xj4u1KHqFXplzFmdvM5S2IxjT/LS56UbhngUPISXOFv99VMRc1A?=
 =?us-ascii?Q?SxjCg4DFla5s8oYYxXjyZqup6h3gp0BPVprMXhU9z60tZzxEy+27CXLiVvOh?=
 =?us-ascii?Q?i5q4zeihcPyRkalagA8CkaW2n5MaK8DIV7KLr9Du9xgxpFt3DZDNK7piEvTU?=
 =?us-ascii?Q?V54wDP/dlfQ/C8UFNEZtscq3OWE6ZOITxtfp01rFhLOEMsD2cmvTf+pllKPo?=
 =?us-ascii?Q?18ZoF98xiHv0zx4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:07:50.0420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4dba2ce-2b6b-4508-f9b6-08dd57d76050
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

Add support to inject interrupts from emulated devices/para-virtualized
devices for Secure AVIC guests. Secure AVIC requires RequestedIRR and
UpdateIRR VMCB fields to be set before VMRUN for interrupt injection.

Secure AVIC allows multiple interrupts to be injected at the same time. So
on interrupt injection, the entire contents of APIC_IRR in host APIC
backing page are copied to RequestedIRR. As guest PPR state is not visible
in KVM, all pending interrupts in host APIC_IRR are considered as
injectable. Secure AVIC HW handles re-injection itself so no explicit
handling by KVM is required.

Secure AVIC does not require an IRQ window as hardware manages interrupt
delivery to the guest and can detect if the guest is in a state to accept
interrupts. So, short-circuit interrupt_allowed() and enable_irq_window()
ops for Secure AVIC.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/svm.h |  8 ++++++--
 arch/x86/kvm/irq.c         |  3 +++
 arch/x86/kvm/lapic.c       | 13 +++++++++----
 arch/x86/kvm/svm/sev.c     | 39 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 13 +++++++++++++
 arch/x86/kvm/svm/svm.h     |  5 ++++-
 arch/x86/kvm/x86.c         | 12 +++++++++++-
 7 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f81b417fe836..59253e3b28f3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -159,9 +159,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
-	u8 reserved_8[40];
+	u8 reserved_8[36];
+	u8 update_irr;			/* Offset 0x134 */
+	u8 reserved_9[3];
 	u64 allowed_sev_features;	/* Offset 0x138 */
-	u8 reserved_9[672];
+	u8 reserved_10[16];
+	u32 requested_irr[8];		/* Offset 0x150 */
+	u8 reserved_11[624];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index f0644d0bbe11..fbfd897ea412 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -47,6 +47,9 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
  */
 int kvm_cpu_has_extint(struct kvm_vcpu *v)
 {
+	if (v->arch.apic->guest_apic_protected)
+		return 0;
+
 	/*
 	 * FIXME: interrupt.injected represents an interrupt whose
 	 * side-effects have already been applied (e.g. bit from IRR
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65f69537c105..7b2ee5263644 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2975,11 +2975,16 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
-	if (apic->guest_apic_protected)
+	switch (apic->guest_apic_protected) {
+	case APIC_STATE_PROTECTED_POSTED_INTR:
 		return -1;
-
-	__apic_update_ppr(apic, &ppr);
-	return apic_has_interrupt_for_ppr(apic, ppr);
+	case APIC_STATE_PROTECTED_INJECTED_INTR:
+		return apic_search_irr(apic);
+	case APIC_STATE_UNPROTECTED:
+	default:
+		__apic_update_ppr(apic, &ppr);
+		return apic_has_interrupt_for_ppr(apic, ppr);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6313679a65b8..080b71ade88d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -34,6 +34,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "lapic.h"
 
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_DEFAULT	2ULL
@@ -4986,3 +4987,41 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
+{
+	struct kvm_lapic *apic;
+	bool has_interrupts;
+	int vec, vec_pos;
+	u32 val;
+	int i;
+
+	/* Secure AVIC HW takes care of re-injection */
+	if (reinjected)
+		return;
+
+	apic = svm->vcpu.arch.apic;
+	has_interrupts = false;
+
+	for (i = 0; i < ARRAY_SIZE(svm->vmcb->control.requested_irr); i++) {
+		val = __kvm_lapic_get_reg(apic->regs, APIC_IRR + i * 0x10);
+		if (!val)
+			continue;
+		has_interrupts = true;
+		svm->vmcb->control.requested_irr[i] |= val;
+		do {
+			vec_pos = __ffs(val);
+			vec = (i << 5) + vec_pos;
+			kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+			val = val & ~BIT(vec_pos);
+		} while (val);
+	}
+
+	if (has_interrupts)
+		svm->vmcb->control.update_irr |= BIT(0);
+}
+
+bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_has_interrupt(vcpu) != -1;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d00ae58c0b0a..7cfd6e916c74 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -50,6 +50,8 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "lapic.h"
+
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3679,6 +3681,9 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
+	if (sev_savic_active(vcpu->kvm))
+		return sev_savic_set_requested_irr(svm, reinjected);
+
 	if (vcpu->arch.interrupt.soft) {
 		if (svm_update_soft_interrupt_rip(vcpu))
 			return;
@@ -3860,6 +3865,9 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return 1;
+
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
@@ -3880,6 +3888,9 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return;
+
 	/*
 	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5092,6 +5103,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
+	.protected_apic_has_interrupt = sev_savic_has_pending_interrupt,
+
 	.get_exit_info = svm_get_exit_info,
 	.get_entry_info = svm_get_entry_info,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e855f101e60f..f70c161ad352 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -760,6 +760,8 @@ static inline bool sev_savic_active(struct kvm *kvm)
 {
 	return to_kvm_sev_info(kvm)->vmsa_features & SVM_SEV_FEAT_SECURE_AVIC;
 }
+void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
+bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -791,7 +793,8 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	return 0;
 }
 static inline bool sev_savic_active(struct kvm *kvm) { return false; }
-
+static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
+static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
 #endif
 
 /* vmenter.S */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e77e61d4fbd..a9bd774baa4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10426,7 +10426,17 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r < 0)
 			goto out;
 		if (r) {
-			int irq = kvm_cpu_get_interrupt(vcpu);
+			int irq;
+
+			/*
+			 * Do not ack the interrupt here for APIC_STATE_PROTECTED_INJECTED_INTR.
+			 * ->inject_irq reads the APIC_IRR state and clears it.
+			 */
+			if (vcpu->arch.apic->guest_apic_protected ==
+					APIC_STATE_PROTECTED_INJECTED_INTR)
+				irq = kvm_apic_has_interrupt(vcpu);
+			else
+				irq = kvm_cpu_get_interrupt(vcpu);
 
 			if (!WARN_ON_ONCE(irq == -1)) {
 				kvm_queue_interrupt(vcpu, irq, false);
-- 
2.34.1


