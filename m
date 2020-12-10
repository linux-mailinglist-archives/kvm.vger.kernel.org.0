Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523FD2D6322
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392504AbgLJRKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:10:34 -0500
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:7392
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392503AbgLJRJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:09:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CG6qgkUF5XM6MLjf0QmrTnbRq2BKpkRtKokNFyBR34itwCpWry1EO4xe7GSAh+vV4XI4qcQbL4Kk++8mzJQsGsR4118K88TxgXYvkUk8PhN+NfwMeCmbqRO8LCT4ZLLqDeV9iWu8vPrtPnvdDWF48eMim88NrB4s/Bektfro6bilzQS5DdUIo7W5PL9BpviAogIJ2tIhblzABc3xDNpsMQF5a6Ql+K41RSrniMoUAeeEq5ckjn4sZQwKkHBwrOEuYi1DFupULxsA9lcRW5SrwmTFEOByI2YZ8BsyOcn6jY81HJ1Stx2mmM57T1KBXdNYqg2knzTELebT+QvdeJtRug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/x/KtVi8hPGFLO6vKOwtBAPv4dLHZ2GgBJEUvm+W/dI=;
 b=I8IPdQHP8+ZMRoYNLGrIunsxXX1T3JNRa0SIh4eAP7JK+5zf3YSgzexE7j/rhUcaOifQhvruA1isD5NZtRHYHZsr1XAw77X2KFVifI/HJJYuXMRsAP2PQOWoydkIWXb2INIUMj8HD4gf01Rn/kctQEqEFcksir6oaAThyIqKLldks06xicBBil/5MfRVBw0znLQBqgopbQXCIuVeSUSivbocp5BPo8DPMooKy92g8GbGAZ8YgAKiFq3Nw0hk4MSphgMobOE5085bcSOSBfChLinqTcOd340dLwc3ly8C7EeoaOJ8X7BgorGczOhb2H25vXe2TBRFv0ikP1DbmbTnWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/x/KtVi8hPGFLO6vKOwtBAPv4dLHZ2GgBJEUvm+W/dI=;
 b=2igkzp3HPXy4E3TzXKDivRkxa9GjN5QrC8rVIQNzBICKwaoPsI0iFepi/82s7AS4V0vLYcjH8NmZqA19oAbEcN6FRbhaTRn7Op0AO3bCt1qK+Pzklm7qJ2MAMO4OYXErM/9f2GT+9Cq6xzN98A7DhLD9qUv4WSqoYIro1ABZwyk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:08:36 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:08:36 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 07/34] KVM: SVM: Add required changes to support intercepts under SEV-ES
Date:   Thu, 10 Dec 2020 11:06:51 -0600
Message-Id: <eb73a31713e8ddc324b61c4d4425f27cbf5eae50.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:610:b0::19) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:610:b0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:08:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb31d6dd-d274-4ec0-110a-08d89d2e3b70
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168410D4E103F95E7BA8A73ECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9OFqTE8kgItiOZyB90pFqI0ST3q7dA5vw0NYlyP8haM8FUtmFiqBDl6WxZJNRKJ0qykFPknIkfHe0o7dH9sjnI8t4Se5RUEdA8R70KVskrezuYrIKboWe1ccD7TVdFnhc66WfgERbn47KO4ITbJGVlfzXdOF8j1+SBpo7phdygJQwZ7AhIE7w8jM73ZzCKBLOoKVjVZH0BS2tnnwSMFzD2ssDgJpGzfPb8ftBaut9IKXcRPtgNTH4U/JuOIyBD206AFH6jLzWdbeBMEo26jF26YeG0CupSBiPWTlQqYt/fmSnn/5nO7TQ5yAK+SpTidadXNUkgUd+U1+SbmmvE220Zn05cQml+aXGwYQ3sddJN0AIu4UE+GbbbWtx0PNClT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V8Rkg0tHXgMtXdj3J3owJlwup9o7rlhizGwOAxmcM08qBD7IIhlsX4i8p7RH?=
 =?us-ascii?Q?ePIGU2Hw+spGUXTEnq72yt/zrhM/fTpqp+uksu5MOcL7sXRKqTPqQyMx0865?=
 =?us-ascii?Q?gNap04Coe5CEdKbM0jSiWFwA35ONZG4tZhQ8ssJkE2ze3AYuAltG9RmcbZBC?=
 =?us-ascii?Q?041/UfHcpgVqwRLkyInJ7/VlMgYh29R/majTkwpFdKvznVdv9TQHlOiH/PSg?=
 =?us-ascii?Q?clmJKQ4rdaDC3sqPtZ9IR2zoAkioRMIiR8iYLfhJHvCCtZfsHw8TZ3SwdpVh?=
 =?us-ascii?Q?H14pxdhVuJJabSJdrgHUqfdqaI0iH8EqOh5ImGmriQALfZNNE9Nfbb6RLH13?=
 =?us-ascii?Q?cS47pGNAPu7SrMilHrgzIo6fIhThDcYMSkJEPqR3/zN2O6AbIwDbXjmnrTQT?=
 =?us-ascii?Q?5e3lkPKaUpgtA+ZzBJOvmeg23Ldhgo2izktBTLwGlPbhshs4YOmdOdxKZkAL?=
 =?us-ascii?Q?51ycnmqWQQJXTrJEwuXPgOhdWmClpYDs2iao54SziEElpRNUSffD09mU51UF?=
 =?us-ascii?Q?ndzGUHrRxUK4FGgGZNE3K1o7d+obJXn6V9YGFgRZXEKynwfGf1ZfhGAz44Lx?=
 =?us-ascii?Q?rgEPVGOwo2zUgZyxpkRjjqF9GowGzxIpvkbny6J7nZPIF0NxFPbrQPKX7WEw?=
 =?us-ascii?Q?AYXW1I/MXI+d72IDU3zWHmjQTWPXkAJKknToZReEKliI3Zhzc7IdEmwrV1XH?=
 =?us-ascii?Q?zr4aiLJYfIRYinv53umQ8brkd3F9fS5CfVSM3OEbq73YTxFat/FakYrMt45y?=
 =?us-ascii?Q?6rBWzO8UL8iETgTG+BDahFkzYB4jI1yE6l40dmlAL6phVxHdnfkcHU4pca1D?=
 =?us-ascii?Q?R16bo4JrCrHORKPJLYdGwpS30U/S47sint5D0wis/KPrSYdHdGITvPN6XpFq?=
 =?us-ascii?Q?MhmQUJQehrVfWM8Odh4v9PdnzZRWo6p5F/p4cU98k1YBZx2TAV4u2xn50zDT?=
 =?us-ascii?Q?Gk/h9SdgkqD5VKJeB8Zk+j1QTDVxJjuCQeVXaxnQvH8QZ6fnMuWEBjKmXOLa?=
 =?us-ascii?Q?fBCG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:08:36.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: bb31d6dd-d274-4ec0-110a-08d89d2e3b70
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GGVshpBG9IfGqMbbHPOYKtf6ZrD3+nJgBICgQOxdYV51+4KdwyJ4htDy1E2nJu+3iHCWQp6MMhDjSzPVIKaIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running under SEV-ES, the hypervisor cannot access the
guest register state. There are numerous places in the KVM code where
certain registers are accessed that are not allowed to be accessed (e.g.
RIP, CR0, etc). Add checks to prevent register accesses and add intercept
update support at various points within the KVM code.

Also, when handling a VMGEXIT, exceptions are passed back through the
GHCB. Since the RDMSR/WRMSR intercepts (may) inject a #GP on error,
update the SVM intercepts to handle this for SEV-ES guests.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h |   3 +-
 arch/x86/kvm/svm/svm.c     | 111 +++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c         |   6 +-
 3 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1edf24f51b53..bce28482d63d 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -178,7 +178,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
-#define SVM_INTERRUPT_SHADOW_MASK 1
+#define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
+#define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
 #define SVM_IOIO_STR_SHIFT 2
 #define SVM_IOIO_REP_SHIFT 3
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd4c9884e5a8..857d0d3f2752 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -36,6 +36,7 @@
 #include <asm/mce.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
+#include <asm/traps.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -340,6 +341,13 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * SEV-ES does not expose the next RIP. The RIP update is controlled by
+	 * the type of exit and the #VC handler in the guest.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		goto done;
+
 	if (nrips && svm->vmcb->control.next_rip != 0) {
 		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
 		svm->next_rip = svm->vmcb->control.next_rip;
@@ -351,6 +359,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
+
+done:
 	svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
@@ -1652,9 +1662,18 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
-	ulong gcr0 = svm->vcpu.arch.cr0;
-	u64 *hcr0 = &svm->vmcb->save.cr0;
+	ulong gcr0;
+	u64 *hcr0;
+
+	/*
+	 * SEV-ES guests must always keep the CR intercepts cleared. CR
+	 * tracking is done using the CR write traps.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return;
 
+	gcr0 = svm->vcpu.arch.cr0;
+	hcr0 = &svm->vmcb->save.cr0;
 	*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
 		| (gcr0 & SVM_CR0_SELECTIVE_MASK);
 
@@ -1674,7 +1693,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.efer & EFER_LME) {
+	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
@@ -2608,7 +2627,29 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static int rdmsr_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_rdmsr(&svm->vcpu);
+	u32 ecx;
+	u64 data;
+
+	if (!sev_es_guest(svm->vcpu.kvm))
+		return kvm_emulate_rdmsr(&svm->vcpu);
+
+	ecx = kvm_rcx_read(&svm->vcpu);
+	if (kvm_get_msr(&svm->vcpu, ecx, &data)) {
+		trace_kvm_msr_read_ex(ecx);
+		ghcb_set_sw_exit_info_1(svm->ghcb, 1);
+		ghcb_set_sw_exit_info_2(svm->ghcb,
+					X86_TRAP_GP |
+					SVM_EVTINJ_TYPE_EXEPT |
+					SVM_EVTINJ_VALID);
+		return 1;
+	}
+
+	trace_kvm_msr_read(ecx, data);
+
+	kvm_rax_write(&svm->vcpu, data & -1u);
+	kvm_rdx_write(&svm->vcpu, (data >> 32) & -1u);
+
+	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
 static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
@@ -2797,7 +2838,27 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 static int wrmsr_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_wrmsr(&svm->vcpu);
+	u32 ecx;
+	u64 data;
+
+	if (!sev_es_guest(svm->vcpu.kvm))
+		return kvm_emulate_wrmsr(&svm->vcpu);
+
+	ecx = kvm_rcx_read(&svm->vcpu);
+	data = kvm_read_edx_eax(&svm->vcpu);
+	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
+		trace_kvm_msr_write_ex(ecx, data);
+		ghcb_set_sw_exit_info_1(svm->ghcb, 1);
+		ghcb_set_sw_exit_info_2(svm->ghcb,
+					X86_TRAP_GP |
+					SVM_EVTINJ_TYPE_EXEPT |
+					SVM_EVTINJ_VALID);
+		return 1;
+	}
+
+	trace_kvm_msr_write(ecx, data);
+
+	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
 static int msr_interception(struct vcpu_svm *svm)
@@ -2827,7 +2888,14 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 static int pause_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	bool in_kernel = (svm_get_cpl(vcpu) == 0);
+	bool in_kernel;
+
+	/*
+	 * CPL is not made available for an SEV-ES guest, so just set in_kernel
+	 * to true.
+	 */
+	in_kernel = (sev_es_guest(svm->vcpu.kvm)) ? true
+						  : (svm_get_cpl(vcpu) == 0);
 
 	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
@@ -3090,10 +3158,13 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
-		vcpu->arch.cr0 = svm->vmcb->save.cr0;
-	if (npt_enabled)
-		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+	/* SEV-ES guests must use the CR write traps to track CR registers. */
+	if (!sev_es_guest(vcpu->kvm)) {
+		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
+			vcpu->arch.cr0 = svm->vmcb->save.cr0;
+		if (npt_enabled)
+			vcpu->arch.cr3 = svm->vmcb->save.cr3;
+	}
 
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
@@ -3205,6 +3276,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * SEV-ES guests must always keep the CR intercepts cleared. CR
+	 * tracking is done using the CR write traps.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return;
+
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
@@ -3273,6 +3351,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
+	/*
+	 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
+	 * bit to determine the state of the IF flag.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return !(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
+
 	if (!gif_set(svm))
 		return true;
 
@@ -3458,6 +3543,12 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 		svm->vcpu.arch.nmi_injected = true;
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT:
+		/*
+		 * Never re-inject a #VC exception.
+		 */
+		if (vector == X86_TRAP_VC)
+			break;
+
 		/*
 		 * In case of software exceptions, do not reinject the vector,
 		 * but re-execute the instruction instead. Rewind RIP first
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3fdc16cfd6f..b6809a2851d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4018,7 +4018,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
 	/*
@@ -8161,7 +8161,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
-	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
+	kvm_run->if_flag = (vcpu->arch.guest_state_protected)
+		? kvm_arch_interrupt_allowed(vcpu)
+		: (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
 	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-- 
2.28.0

