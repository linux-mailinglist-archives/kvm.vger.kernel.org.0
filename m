Return-Path: <kvm+bounces-39666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7B4A4941E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673DA18949C5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED16254AE2;
	Fri, 28 Feb 2025 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EkJnoknB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFDB253F13;
	Fri, 28 Feb 2025 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740732987; cv=fail; b=djD5CUEymMzZLqKfD2exMkImVZOCUZGOYgCvHVkfBFyB5Ul4gPd6H6nTyVPvKp6sQpfVtNzRV4gFqHgMZIR7/EK/8WvYB2/K9zwSiovXzg0wAQHFje7GpLCcjcTPAYfKGT/YotTUKVMdJbiR4Dfhc2utG9MqFKJFHouiUna8gho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740732987; c=relaxed/simple;
	bh=BMq7jdlCLRc8bQWbOrMjMgMe60xuy5jz860uwwLv89k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyqzXzQlj9ZlGey7fs8YWkusC1d3CilvGNTOWGtyFdqO3xBK4EXyLj91j2Sq2QKz4LGjISwPVUgpUHVGeFrd9t6uFVix01+7ntUiuO6naJ9xaKTARcnsj3lE+lCvC/F91+nP8AKizJUh/BaJjwHjBs+s3roJFQz6IFFZIouQqOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EkJnoknB; arc=fail smtp.client-ip=40.107.95.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yN6k2WHfbfIvsI/VOO9J3lVQGfTI0tpBgvN6sOuF4qtQJsCP841rECOMKG5voPrWsUmGGS/JJKreSkEHUd5nHV5886eWbrRdUthk2PfVhi51gi19O8ZNpqi7XEsYXThgRMCKiA/I9lJyyo+Ya4AqOWC5Jo5397cM2Yp4/G6KYtyCuL8TM/8jhUDPut5fYdmYZtV40zd5gCwt0pFYNYD1LEAgIudo7Onbd2ch7/1k2slXyFRPZPALkk5K/n9kedAUJYO01U4Eehaq7USq8Nsrsp61bJhbG6kiwOJP+u+Q/Da/05v2C1zME67zedxtLCuP8H8aIlYmhH6lmDoRiy6Xtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPezGnTuP7Ab3/OvNWsIXTi2VPD8xSb+Qslem+gWhJE=;
 b=zIcavC8zlEW7fu4rR/yZuKSdTRoc9CUXZNWeXHtyi679lW96uby6hkWDajoJ4bBbkrE3QLvgdlbsMbfqbuY16SiRbA4HjDcs/LJnL4wU9fOW6tgzTPgV54s/ZvVEo/BlKsAhLRZy7v0O8ZxW8sdZM4r8O4nA4pNpxbARfFIJwum5PYxAhKFBNJH0c1Y6uzIdZne98a6bkQ7v0uK8vEfP3AQIInRblMdIsADM9lh90g51ZqoX5uBcVgtL44fYJPJcaIQKYEcn6vNKijdyPNUNvbbpR0YrEF++f9mO6jFCKBgAlXM0PwaQo6kKF6WvI622WfKTJdVs2AGDu37cDzYM3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPezGnTuP7Ab3/OvNWsIXTi2VPD8xSb+Qslem+gWhJE=;
 b=EkJnoknB6gZk+EidAwCgGfucjF/wfVG9M0p225tHQhfFyxnZzty9ItqA+iHCXR83LVkFZfioayj3irI3FFJJ7wob/JzOGNI+j5HkwJiIjSRnXHvGDvb62plBzPantnYn4UEZ4tU+wpkserTw5OoPfOI6xB6aecDTCpv5PIh/eSg=
Received: from BYAPR07CA0087.namprd07.prod.outlook.com (2603:10b6:a03:12b::28)
 by PH7PR12MB6717.namprd12.prod.outlook.com (2603:10b6:510:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Fri, 28 Feb
 2025 08:56:19 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:a03:12b:cafe::78) by BYAPR07CA0087.outlook.office365.com
 (2603:10b6:a03:12b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.22 via Frontend Transport; Fri,
 28 Feb 2025 08:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.0 via Frontend Transport; Fri, 28 Feb 2025 08:56:19 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 02:52:53 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 01/19] KVM: TDX: Add support for find pending IRQ in a protected local APIC
Date: Fri, 28 Feb 2025 14:20:57 +0530
Message-ID: <20250228085115.105648-2-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|PH7PR12MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d255b4-72f7-425b-e68c-08dd57d5c482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x35W7grOAhklOyeI5fVul4ZRt2D76LHuqbAgUZvb8qmkPxTSVWl3RzZc4ROd?=
 =?us-ascii?Q?b4lvyfJtQa8aNW9hVmCSIxMpwxAqm7CJjzAarQuj9MpHv9BBt/AL3ZzlxCSY?=
 =?us-ascii?Q?tcmWVTI/Tsqz9aT4tzndtnZo8EY2j7rw0T2P74l5FpJfyTh3CuYgnSqzoN/w?=
 =?us-ascii?Q?hkfG4LLmyHud5gyR1J4lesJjsKO6ih1ZlUm7bhwNzGYQKGG9xHDxv1mnQgsI?=
 =?us-ascii?Q?leGUJg1QC/f2ZWI+nZ8nvOdr7bzDGhkv+VUk5ylwdCaqxLjxPJFflJtd84UB?=
 =?us-ascii?Q?GLfgnzP/TOP+2qMFD0M59QBRKW411F3+0fueCv53wc11jwIYWyarmF2nve8g?=
 =?us-ascii?Q?HkS+w1v/tGLR76BqL3zf2esY5cGfsK7sz6elD2H+qwH4EjUF6/rK4S9EXitk?=
 =?us-ascii?Q?oO7s/1WJqzK2oFxZP9JvwTButQYa1+eBG/R39JDkQPdWWs5K+slLlHM608dQ?=
 =?us-ascii?Q?BN7yJJEKe9uBP8wiJHuWIewrJie45LQJ1wTrf2fmuqt7ZTRVZoTnGuubdRf8?=
 =?us-ascii?Q?rkZMe6Ahh91faI2FdTS5aQeTYtENdgHUYNi596+LQbjxGflugEMqXo9JaM1j?=
 =?us-ascii?Q?TU7dYHxvdht+EqIz4OP8hPDGN977Q2Y1bXSpvEJeKKbIycuC5/l8eYn4ORLo?=
 =?us-ascii?Q?8y1aQkmEiY/EgdY390hGTr87vj3dwRRXW3gcCLxIu1/vyRYHaLY7GFJG/mee?=
 =?us-ascii?Q?ZxNyitJUp1KYV0U+txkEii5FuZQ0jgHFe7okSeSGK8PgXD2blkevETRUCQEU?=
 =?us-ascii?Q?x6Im34fBMEOHimDFfsvkuICWapfvW9w8k/PJMcF6YxTYV0HwI9H5rAw1NiwS?=
 =?us-ascii?Q?+lr5zw/aRs+fNUkDWlm5c4KVrOXG51s0UuSX3HQ9AX2JWnd94cIFsUf43NCR?=
 =?us-ascii?Q?T9blmZeX4z1XChdNepgWkGps1g/7KYIBu71r6ltlbDfRo9WBfEvZPZTICfAS?=
 =?us-ascii?Q?Wd7ZVNLxp+W++toYpGH1jB1gIgg/DOFjJ4TvdRwK2RhOZ1y/nTAgertyhjwy?=
 =?us-ascii?Q?2oTGNd9j9rTo/f8gs8tjleHJWvXPoPMUwIbu2w3ekl694qPHdu3VuBUo6Qbr?=
 =?us-ascii?Q?WSX9VYYQCt3rMHLzwyFA/9DAGB99uGnL0623UPnlFR9qIYQBfdJhQe3AcWyV?=
 =?us-ascii?Q?lXYAgvgxmWg7zpmd6/7r0q6dF0NFuVQ7Po6BXNAAcgirLY9dmr6P7EtLpJUJ?=
 =?us-ascii?Q?2fUWFoMtdaWdjWWv2tAmetLd95rhQ66N0eZxjsh3BhqXYqQRWxL0wf9M/Y9t?=
 =?us-ascii?Q?F3nvNp8IDIPVtsvY6lw+ybnsexUUXS3gwLmgHjphzdN07x/rjZIpTcNKwJ2y?=
 =?us-ascii?Q?xGrE44X7DNF7SE3/tYs/R9nbZ98xVG7hWz7InmY73wuSlIn7YxMn9bYHXyPN?=
 =?us-ascii?Q?Ousiy1GwmhPPksp2I0N4NZL/VIQdEtAkuWWxeSw9Y2M2IAY5fZr3iK1/jT9t?=
 =?us-ascii?Q?JfBaE9mSVxA2k2VVvQUfyu20Ru8122MJCcE3CAcNvzqqgrLMvSQ3EzPfm5Wg?=
 =?us-ascii?Q?NZw5YwuS0Qk/+lg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 08:56:19.1323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d255b4-72f7-425b-e68c-08dd57d5c482
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

From: Sean Christopherson <seanjc@google.com>

Add flag and hook to KVM's local APIC management to support determining
whether or not a TDX guest as a pending IRQ.  For TDX vCPUs, the virtual
APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
result, registers that are virtualized by the CPU, e.g. PPR, cannot be
read or written by KVM.  To deliver interrupts for TDX guests, KVM must
send an IRQ to the CPU on the posted interrupt notification vector.  And
to determine if TDX vCPU has a pending interrupt, KVM must check if there
is an outstanding notification.

Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
protected to short-circuit the various other flows that try to pull an
IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
pending, KVM can't do anything based on _which_ IRQ is pending.

Intentionally omit sanity checks from other flows, e.g. PPR update, so as
not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
and userspace will never reach those flows for TDX guests, but reaching
them is not fatal if something does go awry.

Note, this doesn't handle interrupts that have been delivered to the vCPU
but not yet recognized by the core, i.e. interrupts that are sitting in
vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
be supported in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
[Neeraj.Upadhyay@amd.com : Pick common ->guest_apic_protected bits]
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---

- Not intended for review. Taken as a base patch for this RFC development.

 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/irq.c                 | 3 +++
 arch/x86/kvm/lapic.c               | 3 +++
 arch/x86/kvm/lapic.h               | 2 ++
 5 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c35550581da0..5abc048aec07 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -114,6 +114,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
 KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f378cd43241c..97e95b88bc6f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1830,6 +1830,7 @@ struct kvm_x86_ops {
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 63f66c51975a..f0644d0bbe11 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
+	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
+		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
+
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a009c94c26c2..8eefbaf4a456 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2966,6 +2966,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
+	if (apic->guest_apic_protected)
+		return -1;
+
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1a8553ebdb42..e33c969439f7 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -65,6 +65,8 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	/* Select registers in the vAPIC cannot be read/written. */
+	bool guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
-- 
2.34.1


