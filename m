Return-Path: <kvm+bounces-39674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 504E8A49470
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1BDE7A6DC5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C919F2566D4;
	Fri, 28 Feb 2025 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NYPslT2k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C02254B1B;
	Fri, 28 Feb 2025 09:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733755; cv=fail; b=I2zB22bIR0esXDkTz/yikdAI97ZoYXSqMtfzL2DnAnh1/0SCyNsnacxVRTb5hdpfOF3T16eCuouQ8zr7KEWHyXzkzAs5qQRNmZTpRTL8Ip7WYcQJQygO3vwgf4zomVgbOeL1RbtSFjVS4TfnAJ1P8pUgM166rTfUOuh+tfIlOhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733755; c=relaxed/simple;
	bh=WDO7dXWbMWOyUPyTEKDwd5GSKXHftByasQDVPeGefQ8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrwVAc9IkgGZuIQ3dwt6DngwwYFeJeT7pu1L8qNBZEM0RTKMVHweDkD5ndtdg4bcFnNvVuHl0kKRiQGAKQLryeCeYL3FOX7N//DtAlxicnV5gDBi2oPnPHeJ0zrgOibuwiaF2T9Rn8ZLhlvXG1TZPMckf4nzFHPOmOSA/eKNupU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NYPslT2k; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=waGAEANXjEkj1tCky3fDuV4quzypQmI5i9qjkA3MFWJ2x86cOJFmcBi6B+Ja8Yu+ZPe7ENhk/8Vkwvbu0bXNuA3RK31Nh6zJGb+WpN1L5JZpOhPWTkThzLFsH/ntbhLQtNerLh3jZuOhRCnZqfW8OBvIBhSeAKn5ndhLyOU0yy8Lg3uboxazY29TbEPSPskyH7r58p1RDTBu0QJi12Ybl8HtuED85IPgKSj/ppiP66CEEVmPHF/LGc1W47ygSSY5zZw4VYP55HmWW4/tdxVvOrc0A3OS+QBtBpQ8NgzjT/IjvU2aMuuoQgVdd+JwhBYy+FJs48r1pN9IJz0CzlnOnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eJ+9LXJT74g3EXNSpB/lNEZ/9wtqRZAKZPifn5da4U=;
 b=yPTrX3mecj+Bh7dmoxvatK/GiY3bejJPfPF+h6u1Z+/V0O4yPiSldAazxiwczKEE2pUE8XVDWXwroZbBaPVMDkpOs3AU1i/VNmLXwYrMW7WDvJX1f0r/wa22mp6zYwIjCE5aWed7VWnR76N9sX3VZztzWdWco3blGZAlecwLZElMy7ye3wMc3tlX3S9Yt6O6lpyl7ljJwh4Pxi7aN55UoO9T+f4dI7OxZ27Z0bUXwTibRnXXxMzY6qVf2MFVRjFkvqogcFZNb0ht+5kMFnf+hbFmf3oIXtQxA12OWhT2e7HbuOuC5zRhzcbpmy4fPYgsOWrDop/d92v3KFuu+2z3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eJ+9LXJT74g3EXNSpB/lNEZ/9wtqRZAKZPifn5da4U=;
 b=NYPslT2kjZgzjIt8wUH0Bl7iCmdkewAyNWE6ETK5r4U0Y4nJSVjTa+YIVLLVxr+qVNE5rFA5+wMFsNvQnRxv/uHCR6LuL2/wuF+4NX8BLp5xBpe1pIdGDLqxl9kctqAdaRIhbv9uhod855u8pWB3GQ6Scv89MersXoUpzT+3yxI=
Received: from BY5PR04CA0002.namprd04.prod.outlook.com (2603:10b6:a03:1d0::12)
 by IA1PR12MB8333.namprd12.prod.outlook.com (2603:10b6:208:3fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:09:08 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::12) by BY5PR04CA0002.outlook.office365.com
 (2603:10b6:a03:1d0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Fri,
 28 Feb 2025 09:09:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:09:08 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:07:08 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 09/19] KVM: SVM/SEV/X86: Secure AVIC: Add hypervisor side IPI Delivery Support
Date: Fri, 28 Feb 2025 14:21:05 +0530
Message-ID: <20250228085115.105648-10-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|IA1PR12MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 04dee30d-450f-46a2-a7cc-08dd57d78ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6eKi1sNBV1u3OYukd/nFvzg+LNuVKoyVomh74J0AzZolwMvp1Z3jKreeUJIN?=
 =?us-ascii?Q?zR9G/Zh97tCWA28raK6LZAg+lPxlmukvjNKJ3X3jHAuQEvYgfiLG3cQsTD5Y?=
 =?us-ascii?Q?BVMJ9iJfa3u/IfKByFw0PMnIMfTf9XjQSrzkjykQDVhbGSwAYaxDpe5/QuHk?=
 =?us-ascii?Q?UQsbYv68OuxfXHgoG9kNQ3tzzxQMgSNp/oyr4G3eoWdb5lbyK9g00TPhvBgI?=
 =?us-ascii?Q?0VMAZZIhCxmiDmf2ryrLr7g5h2ehMVZby2PvD0Q6dWkb6kxCJaGHUQHCnMGU?=
 =?us-ascii?Q?WPh7pd9NNdrUOHosxSTrCa7eQVRehjBQDPtz4wMWJZAFS+omhpSAViTm5I94?=
 =?us-ascii?Q?0l+GTpuS9mf6Cj4wN/3ku7SkcUrC+k+QUmLrrvXcKwxWaXA1hbqTkt2p77as?=
 =?us-ascii?Q?0DAP22nm2YdKHlmATUiYrTQpArmtfTLqm8hNpud3jmNin15mepax9XxIbk3h?=
 =?us-ascii?Q?59Sl+fpUB34ZU3MpFmX5dc2gDahcukG66587Oy5fVjqx6OEgmdQKuXpfyZ77?=
 =?us-ascii?Q?kvc1fKtdeBLWkElAN/uX1JCfTJ2RLY4gQsu/3bxcol5BLSaTurer30XwmLMo?=
 =?us-ascii?Q?9vzOoVP6sgrTriUdGaKpsY31pUi6mBhqTQo8mpkR4sB/DSdlcOhRSJUcNFlq?=
 =?us-ascii?Q?nYaOUrkf8zZrm+uQGZJljEMETcJweoY/efd2wk0JRRhh6wWaaMFYQmV1zR48?=
 =?us-ascii?Q?Cm1PxthtAuGykZgT8hhIxLyt0M13KexrWnLwQVse3/ytoUIN7jXEd02Ui3Oq?=
 =?us-ascii?Q?JIPOZRChHz7LEQm5kwpFxzKjZhiEZAu9ZH1cKilF4IspxyU/VHhp9PG6De4A?=
 =?us-ascii?Q?BEeZGBK3pa2vyxezdHFvzQdk7utm+oj3RvTuPDBxaAPTTBrDHZEEA2tm8e60?=
 =?us-ascii?Q?peKi8otSP/aOL7Co4qAascyDE/EOm7E6wOIi5oJ/LNfER6FQblxl6fkd+uif?=
 =?us-ascii?Q?czge47AMwhT0NFLbgPmCX/FNHj7Pssz0UEhaiRkzJqNgoh+wxcoW7HJG17Mu?=
 =?us-ascii?Q?D+eHAaX0CoW0PYUDLOPgTeto5BqX9e08NWgLeNk+LRhC2EFA+IhO1bgxPjUZ?=
 =?us-ascii?Q?I1fkyitz7kohVhxUinMJWmp0JUgOY81SkmJHQ7iHoaFJ6FBJwaNuslKtD1J4?=
 =?us-ascii?Q?jtCLACFFP2d2F80aj/nK1bRF/cLyJhhW17TfGKBn3p962yDYNAo8LlAEMOrp?=
 =?us-ascii?Q?Y3Za6uzQXJg0xp68SPKn42w9B92utzdVcDAVHoeSAQ+C7zabP1PzO8SGf3KB?=
 =?us-ascii?Q?fbKMJWhbm5UZDdE6sdNtKecyudpC3mAmmAajO6gaWXKmRHSQc7DD1EKYOKeP?=
 =?us-ascii?Q?0frja2Gez9ekHh9YpSEViHe9UsKd0sLDT9G6Krajx1DIFBIkW0rrzDib6hb7?=
 =?us-ascii?Q?kXlj3STnOznM7YP6qHYIbXhWj0O0kCFCd//WCjSBP3Lpyug9ISNbQ8UaS6sS?=
 =?us-ascii?Q?bBK0FCPesqBcjd1uFurbDqsge31oLc74Yk7tzsobKQ4PJYYSHjn7NA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:09:08.0318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04dee30d-450f-46a2-a7cc-08dd57d78ecf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8333

Secure AVIC hardware only accelerates self IPIs. For cross-vCPU IPI,
source vCPU updates the APIC_IRR of destination vCPU and then issues
VMGEXIT with type "SVM_EXIT_MSR" to propagate APIC_ICR write to the
hypervisor.

Hypervisor then examines the ICR data and sends doorbell to running vCPUs
using AVIC Doorbell MSR or wakes up a blocking vCPU. Hypervisor then
resumes the vCPU which issued the VMGEXIT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 216 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h |   2 +
 2 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 080b71ade88d..d8413c7f4832 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3496,6 +3496,89 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
 
+	/*
+	 * It should be safe to clear sev_savic_has_pending_ipi here.
+	 *
+	 * Following are the scenarios possible:
+	 *
+	 * Scenario 1: sev_savic_has_pending_ipi is set before hlt exit of the
+	 * target vCPU.
+	 *
+	 * Source vCPU                     Target vCPU
+	 *
+	 * 1. Set APIC_IRR of target
+	 *    vCPU.
+	 *
+	 * 2. VMGEXIT
+	 *
+	 * 3. Set ...has_pending_ipi
+	 *
+	 * savic_handle_icr_write()
+	 *   ..._has_pending_ipi = true
+	 *
+	 * 4. avic_ring_doorbell()
+	 *                            - VS -
+	 *
+	 *				   4. VMEXIT
+	 *
+	 *                                 5. ..._has_pending_ipi = false
+	 *
+	 *                                 6. VM entry
+	 *
+	 *                                 7. hlt exit
+	 *
+	 * In this case, any VM exit taken by target vCPU before hlt exit
+	 * clears sev_savic_has_pending_ipi. On hlt exit, idle halt intercept
+	 * would find the V_INTR set and skip hlt exit.
+	 *
+	 * Scenario 2: sev_savic_has_pending_ipi is set when target vCPU
+	 * has taken hlt exit.
+	 *
+	 * Source vCPU                     Target vCPU
+	 *
+	 *                                 1. hlt exit
+	 *
+	 * 2. Set ...has_pending_ipi
+	 *                                 3. kvm_vcpu_has_events() returns true
+	 *                                    and VM is reentered.
+	 *
+	 *                                    vcpu_block()
+	 *                                      kvm_arch_vcpu_runnable()
+	 *                                        kvm_vcpu_has_events()
+	 *                                          <return true as ..._has_pending_ipi
+	 *                                           is set>
+	 *
+	 *                                 4. On VM entry, APIC_IRR state is re-evaluated
+	 *                                    and V_INTR is set and interrupt is delivered
+	 *                                    to vCPU.
+	 *
+	 *
+	 * Scenario 3: sev_savic_has_pending_ipi is set while halt exit is happening:
+	 *
+	 *
+	 * Source vCPU                        Target vCPU
+	 *
+	 *                                  1. hlt
+	 *                                       Hardware check V_INTR to determine
+	 *                                       if hlt exit need to be taken. No other
+	 *                                       exit such as intr exit can be taken
+	 *                                       while this sequence is being executed.
+	 *
+	 * 2. Set APIC_IRR of target vCPU.
+	 *
+	 * 3. Set ...has_pending_ipi
+	 *                                  4. hlt exit taken.
+	 *
+	 *                                  5. ...has_pending_ipi being set is observed
+	 *                                     by target vCPU and the vCPU is resumed.
+	 *
+	 * In this scenario, hardware ensures that target vCPU does not take any exit
+	 * between checking V_INTR state and halt exit. So, sev_savic_has_pending_ipi
+	 * remains set when vCPU takes hlt exit.
+	 */
+	if (READ_ONCE(svm->sev_savic_has_pending_ipi))
+		WRITE_ONCE(svm->sev_savic_has_pending_ipi, false);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
@@ -4303,6 +4386,129 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	return 0;
 }
 
+static void savic_handle_icr_write(struct kvm_vcpu *kvm_vcpu, u64 icr)
+{
+	struct kvm *kvm = kvm_vcpu->kvm;
+	struct kvm_vcpu *vcpu;
+	u32 icr_low, icr_high;
+	bool in_guest_mode;
+	unsigned long i;
+
+	icr_low = lower_32_bits(icr);
+	icr_high = upper_32_bits(icr);
+
+	/*
+	 * TODO: Instead of scanning all the vCPUS, get fastpath working which should
+	 * look similar to avic_kick_target_vcpus_fast().
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_match_dest(vcpu, kvm_vcpu->arch.apic, icr_low & APIC_SHORT_MASK,
+					 icr_high, icr_low & APIC_DEST_MASK))
+			continue;
+
+		/*
+		 * Setting sev_savic_has_pending_ipi could result in a spurious
+		 * wakeup from hlt (as kvm_cpu_has_interrupt() would return true)
+		 * if destination CPU is inside guest and guest does a halt exit
+		 * after handling the IPI. sev_savic_has_pending_ipi gets cleared
+		 * on vm entry, so there can be at most one spurious wakeup per IPI.
+		 * For vcpu->mode == IN_GUEST_MODE, sev_savic_has_pending_ipi need
+		 * to be set to handle the case where destination vCPU has taken
+		 * halt exit and the source CPU has not observed vcpu->mode !=
+		 * IN_GUEST_MODE.
+		 */
+		WRITE_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi, true);
+		/* Order sev_savic_has_pending_ipi write and vcpu->mode read. */
+		smp_mb();
+		/* Pairs with smp_store_release in vcpu_enter_guest. */
+		in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
+		if (in_guest_mode) {
+			/*
+			 * Signal the doorbell to tell hardware to inject the IRQ.
+			 *
+			 * If the vCPU exits the guest before the doorbell chimes,
+			 * below memory ordering guarantees that destination vCPU
+			 * observes sev_savic_has_pending_ipi == true before
+			 * blocking.
+			 *
+			 *   Src-CPU                       Dest-CPU
+			 *
+			 *  savic_handle_icr_write()
+			 *    sev_savic_has_pending_ipi = true
+			 *    smp_mb()
+			 *    smp_load_acquire(&vcpu->mode)
+			 *
+			 *                    - VS -
+			 *                              vcpu->mode = OUTSIDE_GUEST_MODE
+			 *                              __kvm_emulate_halt()
+			 *                                kvm_cpu_has_interrupt()
+			 *                                  smp_mb()
+			 *                                  if (sev_savic_has_pending_ipi)
+			 *                                      return true;
+			 *
+			 *   [S1]
+			 *     sev_savic_has_pending_ipi = true
+			 *
+			 *     SMP_MB
+			 *
+			 *   [L1]
+			 *     vcpu->mode
+			 *                                  [S2]
+			 *                                  vcpu->mode = OUTSIDE_GUEST_MODE
+			 *
+			 *
+			 *                                  SMP_MB
+			 *
+			 *                                  [L2] sev_savic_has_pending_ipi == true
+			 *
+			 *   exists (L1=IN_GUEST_MODE /\ L2=false)
+			 *
+			 *   Above condition does not exit. So, if source CPU observes vcpu->mode
+			 *   = IN_GUEST_MODE (L1), sev_savic_has_pending_ipi load by destination CPU
+			 *   (L2) should observe the store (S1) from source CPU.
+			 */
+			avic_ring_doorbell(vcpu);
+		} else {
+			/*
+			 * Wake the vCPU if it was blocking.
+			 *
+			 * Memory ordering is provided by smp_mb() in rcuwait_wake_up() on
+			 * source CPU and smp_mb() in set_current_state() inside
+			 * kvm_vcpu_block() on dest CPU.
+			 */
+			kvm_vcpu_kick(vcpu);
+		}
+	}
+}
+
+static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
+{
+	u32 msr, reg;
+
+	msr = kvm_rcx_read(vcpu);
+	reg = (msr - APIC_BASE_MSR) << 4;
+
+	switch (reg) {
+	case APIC_ICR:
+		/*
+		 * Only APIC_ICR wrmsr requires special handling
+		 * for Secure AVIC guests to wake up destination
+		 * vCPUs.
+		 */
+		if (to_svm(vcpu)->vmcb->control.exit_info_1) {
+			u64 data = kvm_read_edx_eax(vcpu);
+
+			savic_handle_icr_write(vcpu, data);
+			return true;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4445,6 +4651,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_EXIT_MSR:
+		if (sev_savic_active(vcpu->kvm) && savic_handle_msr_exit(vcpu))
+			return 1;
+
+		fallthrough;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
 	}
@@ -5023,5 +5234,8 @@ void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
 
 bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_has_interrupt(vcpu) != -1;
+	/* See memory ordering description in savic_handle_icr_write(). */
+	smp_mb();
+	return READ_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi) ||
+		kvm_apic_has_interrupt(vcpu) != -1;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f70c161ad352..62e3581b7d31 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -327,6 +327,8 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	bool sev_savic_has_pending_ipi;
 };
 
 struct svm_cpu_data {
-- 
2.34.1


