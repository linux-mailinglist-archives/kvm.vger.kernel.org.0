Return-Path: <kvm+bounces-58456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A9DB9447C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B99818941DD
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD79830EF7C;
	Tue, 23 Sep 2025 05:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U+ybh55x"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421B630EF63;
	Tue, 23 Sep 2025 05:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603922; cv=fail; b=rF8mjyOP9Q9XoTDR4U5pst/M3kJZJBmHETDu0V/8RYM2x+GeYMw93hFD1kQxrBM8Q2ImUzzJhMamGNHQkio91iXuCJ+O1DHGHVi7yirPEtIXCOW9A9v5pz/gFLhTFumqyfV0DAUOLocRar4ebT/O2re2SfgF//nGt5ZFUU2RCnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603922; c=relaxed/simple;
	bh=HYIgTTA4BACWGyJSb9Kh+LMOeJWmKJnfVtmJQLuUTGs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tumEzPCVOzn71ljVaYduDgRuWeIkAR6CYHqtACLQs9EB60ZPHoqo0nai80IPDt0AhyEz4OW0A5zfP/sM4DFYjy38NvoI3Ac32rL0n52KDFGI86clI89q4fZ6b5yaTZhW1V8z7Rh/+z0iqAEIN4wAugIcBWst7DnJezqfQVFV7iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U+ybh55x; arc=fail smtp.client-ip=40.107.209.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjMWmcrsxfJtZgAWZlYV5fpt9N2kHJ9Jt1HxvYvcwS3jvuZy92DkfAjVDibQdHk388Elejnzt/wOpVTYIYcN9bp/odT2rUBfrTUHxiZ2pYbu7/RnMa1AJA66rA9ykociWSpvU2kmuK6adFHhu4H8jmqSQboAYokxQU8U0+T9aQO98C8cRmvwMD+I9PetAl7z4V8WtIjP595i5Q2mMb0b7VaIgEmC43O28geI8PrSKUvyR2u86M2MfN/pDVnmlIw3iHCnbNfPVicvyH01S6VM9JrZ+oRyn/6drinoptw8rVgkfJFhqpk4xe6rD2ecQTZ+Yf47+L7i42qy2R7npyApRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9zO9Xo2vRxy5ZqCH//0hlVkRms/SUPx5dkjCCuLEzA=;
 b=eqBFM8Ywwy50ydUWLSrDiqoZ8rUIqjqFNrXQNmt9pIJcjSWPZ6+FZxkYL/TRe4ODT3VIS95H0+Lj5QFa4PLc74urqWaynD6sv+87ZjDhzpq1PTnbhdPGEW8idTYMRiG3zDLI/V66v9GaSbHMQIoKHwbXmhn+q5lUQtZB5WtGmKTe+d806qq6/DLQJPbHgkOwQ00PUtnQfuTqmGcEsJp87SfU+NUkbpxZkl1YEZkxrfN3ypw+ZK3VMp1rIiPDzwqiABi8YcdqRlaYjxxlknQMH9YQuMD18io1dUaLgyBwo1Euv/oIOYANxFHSRwii8X/dJmYcNGCW+g3ycd+eYGCnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9zO9Xo2vRxy5ZqCH//0hlVkRms/SUPx5dkjCCuLEzA=;
 b=U+ybh55xAMRZCUk7pE0Q22YFL4wzMRFYA1MWFFBPpn31bLS2t+6I5spwsvy6geAcOUY/qCsX5epH30hER1veRn2Iibn/09liFzu1GZMBvepIafTGY5Du82WWYob27a0PHm4STiXkU8aivSKPB5iyn/5m8i+De+fpY8OHr1f8ClU=
Received: from SJ0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:a03:33a::16)
 by BY5PR12MB4081.namprd12.prod.outlook.com (2603:10b6:a03:20e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:05:16 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::69) by SJ0PR03CA0011.outlook.office365.com
 (2603:10b6:a03:33a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:05:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:05:15 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:05:07 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for Secure AVIC
Date: Tue, 23 Sep 2025 10:33:06 +0530
Message-ID: <20250923050317.205482-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|BY5PR12MB4081:EE_
X-MS-Office365-Filtering-Correlation-Id: 489abcfd-5460-4d0e-6452-08ddfa5ec8c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HLO2RxtjoSYlwUrysOnEFin/Y75UAiyaldmfsxIdVZZ+U6ZTgLh2g3vuTKFI?=
 =?us-ascii?Q?GC3uuVpGXTGiOb3lsJKzblZAZ2sIYcLTU2cJS8Fcq8uDUVkQ0kOTVPsjcpFt?=
 =?us-ascii?Q?nISnAnycxWEehir+dGvyftQdMbX8WScF2+XpeFV8zWIE1VkB0T+E32vSPxlM?=
 =?us-ascii?Q?2uou4wG3c3+jz2sjZczsPvGyQZWBVNEOBrnhxkHQ2bbZGKV44WD7Y8EXYx8R?=
 =?us-ascii?Q?umBmencgcK7Wz9vGb1p42v2UssThUqTALXHuXh1JHjH7g2aKSh60Zqwj7hst?=
 =?us-ascii?Q?1QwYqtnKab1fNRiO7bKoXlgLJg1XkfBFHS1axjKtj6isd9uv9gc/ys3ynSsc?=
 =?us-ascii?Q?9wkZDOePZyW6infD0b7u5YWKyy409E2xcpXxQiPatlIOzMVRJlYy4w4fZDwC?=
 =?us-ascii?Q?XVBwg1o3ZdFTCEIWGY9DZ8eU4qt5FiErln9He/xL7aCJ1B5PpCIhamFyfPd1?=
 =?us-ascii?Q?g3OzTdLOvHV6fHGpwVu5m2h1ghAsl7G0/N6UGV2nGCvT9CIyCXukc8qFSvyY?=
 =?us-ascii?Q?OCfVNgL4LV64Ni7VqGV67QnfOXPraP8u85g722R/bjiJnCheosjto62VSVNN?=
 =?us-ascii?Q?LEk7mn7rQlEIQcgDrhw/I0s24fjlWVptswxKY3Swom/ufHThPrI0A3uwIFFA?=
 =?us-ascii?Q?Wl4q1GWi+LL1vSEHDs6fo2taeym9KTGdG+dMXcA0/nm5N1F0uOCo1Qf0HVpm?=
 =?us-ascii?Q?uQN5qCyiN03MoomCMPopiRsYklodnzUPQ3pURaLjFwf8WpoYpqWhuBfi6uSm?=
 =?us-ascii?Q?sttZmeXYX5hDe9MFsv0JFgyYVJGxIyqFkWL7m1DNYOhTX4t1D3Mm2grqzAGk?=
 =?us-ascii?Q?cwuZ74/VsOc8QBD8EJCegsF+FnnigRnn2Vr6kLtEepkS8tGxMREUImsaxCIG?=
 =?us-ascii?Q?vIQteW/eFZkfaJ9YIJvurne4VM5BGwS3kLCYm+tx3hjZwfcpAVv5QqI/akI1?=
 =?us-ascii?Q?2erJcRVdMQrKwm0dESl38VXwJj33bqR4fnaaQ13u+LzNDR2dYAYQS0ktByEL?=
 =?us-ascii?Q?kyqB+xJQYD8jVLs/un4V8QVzHsfLDLmAyj30oimktQ5HdFKuWu6D9tpTm1bQ?=
 =?us-ascii?Q?pUF3GJexBbWCfKLAE0Pb3xJy8hTtTtwRd+WkvgJXqaA1KMY0kMzKh4l8u1yL?=
 =?us-ascii?Q?W9AzFJPAw71NX4oGROVksqzIT7jPbkA6TCdhm23/mQQKjPg92QAMwn0sSZzS?=
 =?us-ascii?Q?RaQt4LENia9cU/w4Hh/ZupRV7tL6znRVea5ljMqpihOdWQaBl8TEwEuTD2H2?=
 =?us-ascii?Q?4zyYZRWKcshwM0NERFOxjqTVv4IvU106roNn0VhZ6BZbPKwrUvdnpRoraJ8a?=
 =?us-ascii?Q?EdrLcTqukE5kD4fo8ugDLKWUuEnbVdq+T4oOZ96Jeqw7T2xr1f9J4SlrfdJQ?=
 =?us-ascii?Q?bK39yQw6FcX9aGwrJdKY2TrCgkoKX5QSoyiE/2fOyn7i4eTBESog8/KiIHLq?=
 =?us-ascii?Q?iEVHbnZ+EEqTWp5Aa8Uo0CDm3Uh5bwUbQ73mOWpexRz9LVPQw61b2MtdqlQI?=
 =?us-ascii?Q?6FwiRBAjED4NMXbi5Jzzobe4JxCkM+m/Zoyl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:05:15.7252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 489abcfd-5460-4d0e-6452-08ddfa5ec8c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4081

For AMD SEV-SNP guests with Secure AVIC, the virtual APIC state is
not visible to KVM and managed by the hardware. This renders the
traditional interrupt injection mechanism, which directly modifies
guest state, unusable. Instead, interrupt delivery must be mediated
through a new interface in the VMCB. Implement support for this
mechanism.

First, new VMCB control fields, requested_irr and update_irr, are
defined to allow KVM to communicate pending interrupts to the hardware
before VMRUN.

Hook the core interrupt injection path, svm_inject_irq(). Instead of
injecting directly, transfer pending interrupts from KVM's software
IRR to the new requested_irr VMCB field and delegate final delivery
to the hardware.

Since the hardware is now responsible for the timing and delivery of
interrupts to the guest (including managing the guest's RFLAGS.IF and
vAPIC state), bypass the standard KVM interrupt window checks in
svm_interrupt_allowed() and svm_enable_irq_window(). Similarly, interrupt
re-injection is handled by the hardware and requires no explicit KVM
involvement.

Finally, update the logic for detecting pending interrupts. Add the
vendor op, protected_apic_has_interrupt(), to check only KVM's software
vAPIC IRR state.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/svm.h |  8 +++++--
 arch/x86/kvm/lapic.c       | 17 ++++++++++++---
 arch/x86/kvm/svm/sev.c     | 44 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 13 +++++++++++
 arch/x86/kvm/svm/svm.h     |  4 ++++
 arch/x86/kvm/x86.c         | 15 ++++++++++++-
 6 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ab3d55654c77..0faf262f9f9f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -162,10 +162,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
 	u8 reserved_8[16];
 	u16 bus_lock_counter;		/* Offset 0x120 */
-	u8 reserved_9[22];
+	u8 reserved_9[18];
+	u8 update_irr;			/* Offset 0x134 */
+	u8 reserved_10[3];
 	u64 allowed_sev_features;	/* Offset 0x138 */
 	u64 guest_sev_features;		/* Offset 0x140 */
-	u8 reserved_10[664];
+	u8 reserved_11[8];
+	u32 requested_irr[8];		/* Offset 0x150 */
+	u8 reserved_12[624];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5fc437341e03..3199c7c6db05 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2938,11 +2938,22 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
-	if (apic->guest_apic_protected)
+	if (!apic->guest_apic_protected) {
+		__apic_update_ppr(apic, &ppr);
+		return apic_has_interrupt_for_ppr(apic, ppr);
+	}
+
+	if (!apic->prot_apic_intr_inject)
 		return -1;
 
-	__apic_update_ppr(apic, &ppr);
-	return apic_has_interrupt_for_ppr(apic, ppr);
+	/*
+	 * For guest-protected virtual APIC, hardware manages the virtual
+	 * PPR and interrupt delivery to the guest. So, checking the KVM
+	 * managed virtual APIC's APIC_IRR state for any pending vectors
+	 * is the only thing required here.
+	 */
+	return apic_search_irr(apic);
+
 }
 EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index afe4127a1918..78cefc14a2ee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 #include <asm/debugreg.h>
 #include <asm/msr.h>
 #include <asm/sev.h>
+#include <asm/apic.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -35,6 +36,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "lapic.h"
 
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_DEFAULT	2ULL
@@ -5064,3 +5066,45 @@ void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
 
 	free_page((unsigned long)vmsa);
 }
+
+void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
+{
+	unsigned int i, vec, vec_pos, vec_start;
+	struct kvm_lapic *apic;
+	bool has_interrupts;
+	u32 val;
+
+	/* Secure AVIC HW takes care of re-injection */
+	if (reinjected)
+		return;
+
+	apic = svm->vcpu.arch.apic;
+	has_interrupts = false;
+
+	for (i = 0; i < ARRAY_SIZE(svm->vmcb->control.requested_irr); i++) {
+		val = apic_get_reg(apic->regs, APIC_IRR + i * 0x10);
+		if (!val)
+			continue;
+		has_interrupts = true;
+		svm->vmcb->control.requested_irr[i] |= val;
+		vec_start = i * 32;
+		/*
+		 * Clear each vector one by one to avoid race with concurrent
+		 * APIC_IRR updates from the deliver_interrupt() path.
+		 */
+		do {
+			vec_pos = __ffs(val);
+			vec = vec_start + vec_pos;
+			apic_clear_vector(vec, apic->regs + APIC_IRR);
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
index 064ec98d7e67..7811a87bc111 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -52,6 +52,8 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "lapic.h"
+
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3689,6 +3691,9 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
+	if (sev_savic_active(vcpu->kvm))
+		return sev_savic_set_requested_irr(svm, reinjected);
+
 	if (vcpu->arch.interrupt.soft) {
 		if (svm_update_soft_interrupt_rip(vcpu))
 			return;
@@ -3870,6 +3875,9 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return 1;
+
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
@@ -3890,6 +3898,9 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return;
+
 	/*
 	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5132,6 +5143,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
+	.protected_apic_has_interrupt = sev_savic_has_pending_interrupt,
+
 	.get_exit_info = svm_get_exit_info,
 	.get_entry_info = svm_get_entry_info,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1090a48adeda..60dc424d62c4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -873,6 +873,8 @@ static inline bool sev_savic_active(struct kvm *kvm)
 {
 	return to_kvm_sev_info(kvm)->vmsa_features & SVM_SEV_FEAT_SECURE_AVIC;
 }
+void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
+bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -910,6 +912,8 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 	return NULL;
 }
 static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
+static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
+static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
 #endif
 
 /* vmenter.S */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33fba801b205..65ebdc6deb92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10369,7 +10369,20 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r < 0)
 			goto out;
 		if (r) {
-			int irq = kvm_cpu_get_interrupt(vcpu);
+			int irq;
+
+			/*
+			 * Do not ack the interrupt here for guest-protected VAPIC
+			 * which requires interrupt injection to the guest.
+			 *
+			 * ->inject_irq reads the KVM's VAPIC's APIC_IRR state and
+			 * clears it.
+			 */
+			if (vcpu->arch.apic->guest_apic_protected &&
+			    vcpu->arch.apic->prot_apic_intr_inject)
+				irq = kvm_apic_has_interrupt(vcpu);
+			else
+				irq = kvm_cpu_get_interrupt(vcpu);
 
 			if (!WARN_ON_ONCE(irq == -1)) {
 				kvm_queue_interrupt(vcpu, irq, false);
-- 
2.34.1


