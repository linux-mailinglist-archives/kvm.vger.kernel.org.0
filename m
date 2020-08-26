Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196F2253802
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHZTOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:30 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:51745
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726910AbgHZTO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+0U2K3shNqNNVJxVZ2bkstU/TT0hVpRrnT/3aNmBR+9mtdjKXwQkqf9VNTcA+uokhW8ltGg9oM9ZrcroTLE0rsCub5zdWauwAS3+Z5XO0zK/gb6V9mC4P8exbfD2y4YBil4bRC/ETXxJdo49W+Sel4atlxGQJdPe0zH/mb/3xiIRdioMdfZoZcbzyJpoKkFQTLOWD8xXekmQV/yneA+7wOuf1dHIqnUtXr3Sz/LOu/GWxQXNn3zwZe4t2RoODsA4BRu7hMjJmnLPL993unnGnKYlr5/xJ+l/gnavcesze8Bu59iYGybFo1tN1G0HFu6tg5KguvMwUYA2suL8GDwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRIsWxT0ILE3KT36R9KGtHzYCpDFmOG+Nwbu2l6CWZw=;
 b=aSu5ZfpqIwzBZqgOB/5gYNumhFWZ3WqaQKDo3G22THEdVhtXime6dyPpJ1kZkgfimU9ifTikxY8XanilGzeO1PpWi4o01pedfieCZJGSuE67MwilMKQPDo2ekSZ3Qr1PD50wqBLtxsHZunVf3INEo0pScMM0OBjoDBUPUgrXWBRvw+p12xLEELiEEE/YI9rywSG62RRkQccIoZyi3A0h0O7506+nFvTd6hY83XQmRZVdbqKIIFqpWGrhNhIGNTh1UN/1hVeHjYAW6LWsOFX5+3VH2h2dxA8NhvlzAhaXFmJlwm6o7UDiUaQ26Bv0sqEWMFlXrr5FjW/AXmqp6GqH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRIsWxT0ILE3KT36R9KGtHzYCpDFmOG+Nwbu2l6CWZw=;
 b=E7ZlXrllwbdycdKn64pZxqOu//gcOvITzU3orNUDgNPlz52a7vsv5mJ/VCTitRnEw+PHjm00BBNlR5rhIy2NOqbBw38qhqp0KsV4YM0ARTGf6B3rNqVe7WCGKPx5Lq/HbXbs3899kmXNhuz7zFTOFSJiGjprsd+5QsfwaADGpT8=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:25 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:25 +0000
Subject: [PATCH v5 05/12] KVM: SVM: Modify 64 bit intercept field to two 32
 bit vectors
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:22 -0500
Message-ID: <159846926282.18873.15781891247605539136.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:0:54::32) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM3PR11CA0022.namprd11.prod.outlook.com (2603:10b6:0:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:23 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59d6b046-c014-493c-9c0b-08d849f43eed
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB246192F202C22591952423E795540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nW6/6QBi2rxujD0LhCKriqExYnriBvsw4UoLfPRpyJqkAR5BtAK7gICoU59iq1rzdsMfy/aqJhZgCwvJfXLrbFM5A/NFYlwgfMDwkIRTjSntvdNxWKl8A0PAmzIwnk5erJXriMLT2jrdIogAj1tS4x84BiMHJm6AOUhLWQlHnRiT+RHLaHl3/t5miCzvKOEcwgzCRiSFEFUCZ494V4IQSa85DpzA4TVr44gESXt3HMW3JUVngau+lTJfKlmHz0mVMHTm3MuJXiSUX59JLUdM/QJjcwLDr//DrXeyICrJMgkKa0FSzzspm8wSxzgw6A1zFF7isDZrrlZ7cnhcU7UslA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(30864003)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9/K7FLIwNyayPwvsu5YBCLQ6eeZnbhDuftiKfi+Eg7fqeolztvJ4Ma8xYzPONR2iWC8Tw8x/JdwV8VR6kNMBMFJr08/K7w3qZMGeI+E+vS+DfXSXpnj3X+jCMQiSCgQSX6c8bylqLCxzt7P0vePoN9b77TTikOwERGmfSzLNzjb1HDklg4hW8DCMmBqKWrrod/J4uIMXS01b/Q+S7y7oeLYfZcaKCKzN7NCm0EHB9ZqF3g5EGgugxxRBpZx1n5PF7rBJN1GNfkhdGAnmDz/95rkIOUsA7XzbxzqGPv8YAbnnBfhP+m8j8mAzQFP+iSnOYR3xCm4sA2TjfVOlf/xDgt5kMrcNauagwYERnkvHe3phn8Bjyb39oXkgfcOLYKU8KRkEE+HCMrGh6ojlJ0aYCO8LBQTjG+suyQGXNDaWrgy0Ib+u0WpZUCVFKyllVfPva6qPzNatcSvr3hm0iJJ2iTlD8ydsxLWg0tvio1G0DvZRZTORXVd24WFTfVvFFOQKCmVRFrgeIOO8lSwoXxfADQQd2wWap6yGaL7KNQ6TIDUDXSm6KQv/NOfKxc7cEnbzemg6mYtx0ypJC/FIVhwhhv5k/2slrf4l8Tso/rT5vwpiJoZymRD9zepCsuRVi7PsaV2d8Qy8Egwxopl6NPrWEA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d6b046-c014-493c-9c0b-08d849f43eed
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:25.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0k9SOBKGWtA+G1WGEgS+uegL276N13S2br0j3SWMSTkir587Tkp2GsiZfPN+dOEk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert all the intercepts to one array of 32 bit vectors in
vmcb_control_area. This makes it easy for future intercept vector
additions. Also update trace functions.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/svm.h |   14 +++++++-------
 arch/x86/kvm/svm/nested.c  |   25 ++++++++++---------------
 arch/x86/kvm/svm/svm.c     |   16 ++++++----------
 arch/x86/kvm/svm/svm.h     |   12 ++++++------
 arch/x86/kvm/trace.h       |   18 +++++++++++-------
 5 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 51833a611eba..9f0fa02fc838 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -14,6 +14,8 @@ enum vector_offset {
 	CR_VECTOR = 0,
 	DR_VECTOR,
 	EXCEPTION_VECTOR,
+	INTERCEPT_VECTOR_3,
+	INTERCEPT_VECTOR_4,
 	MAX_VECTORS,
 };
 
@@ -73,10 +75,8 @@ enum {
 	INTERCEPT_MC_VECTOR = 64 + MC_VECTOR,
 	INTERCEPT_XM_VECTOR = 64 + XM_VECTOR,
 	INTERCEPT_VE_VECTOR = 64 + VE_VECTOR,
-};
-
-enum {
-	INTERCEPT_INTR,
+	/* Byte offset 00Ch (Vector 3) */
+	INTERCEPT_INTR = 96,
 	INTERCEPT_NMI,
 	INTERCEPT_SMI,
 	INTERCEPT_INIT,
@@ -108,7 +108,8 @@ enum {
 	INTERCEPT_TASK_SWITCH,
 	INTERCEPT_FERR_FREEZE,
 	INTERCEPT_SHUTDOWN,
-	INTERCEPT_VMRUN,
+	/* Byte offset 010h (Vector 4) */
+	INTERCEPT_VMRUN = 128,
 	INTERCEPT_VMMCALL,
 	INTERCEPT_VMLOAD,
 	INTERCEPT_VMSAVE,
@@ -128,8 +129,7 @@ enum {
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercepts[MAX_VECTORS];
-	u64 intercept;
-	u8 reserved_1[40];
+	u32 reserved_1[15 - MAX_VECTORS];
 	u16 pause_filter_thresh;
 	u16 pause_filter_count;
 	u64 iopm_base_pa;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 798ae2fabc74..772e6d8e6459 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -114,8 +114,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept = h->intercept;
-
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
 		vmcb_clr_intercept(c, INTERCEPT_CR8_READ);
@@ -126,16 +124,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		 * affect any interrupt we may want to inject; therefore,
 		 * interrupt window vmexits are irrelevant to L0.
 		 */
-		c->intercept &= ~(1ULL << INTERCEPT_VINTR);
+		vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
 	/* We don't want to see VMMCALLs from a nested guest */
-	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+	vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
 
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
-
-	c->intercept |= g->intercept;
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
@@ -146,7 +142,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
@@ -179,7 +174,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 */
 	int i;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -205,7 +200,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
 
 	if (control->asid == 0)
@@ -493,7 +488,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
 				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
-				    nested_vmcb->control.intercept);
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_3],
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_4]);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
@@ -710,7 +706,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 offset, msr, value;
 	int write, mask;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -737,7 +733,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
@@ -791,8 +787,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	default: {
-		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		if (svm->nested.ctl.intercept & exit_bits)
+		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -900,7 +895,7 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
+	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
 }
 
 static void nested_svm_init(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 11892e86cb39..17bfa34033ac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2218,12 +2218,9 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
 {
 	unsigned long cr0 = svm->vcpu.arch.cr0;
 	bool ret = false;
-	u64 intercept;
-
-	intercept = svm->nested.ctl.intercept;
 
 	if (!is_guest_mode(&svm->vcpu) ||
-	    (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0))))
+	    (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
 		return false;
 
 	cr0 &= ~SVM_CR0_SELECTIVE_MASK;
@@ -2818,7 +2815,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
-	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
+	pr_err("%-20s%08x\n", "intercept1:", control->intercepts[INTERCEPT_VECTOR_3]);
+	pr_err("%-20s%08x\n", "intercept2:", control->intercepts[INTERCEPT_VECTOR_4]);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
 	       control->pause_filter_thresh);
@@ -3738,7 +3736,6 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	case SVM_EXIT_WRITE_CR0: {
 		unsigned long cr0, val;
-		u64 intercept;
 
 		if (info->intercept == x86_intercept_cr_write)
 			icpt_info.exit_code += info->modrm_reg;
@@ -3747,9 +3744,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		intercept = svm->nested.ctl.intercept;
-
-		if (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0)))
+		if (!(vmcb_is_intercept(&svm->nested.ctl,
+					INTERCEPT_SELECTIVE_CR0)))
 			break;
 
 		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
@@ -4010,7 +4006,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	 * if an INIT signal is pending.
 	 */
 	return !gif_set(svm) ||
-		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
+		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2fc305f647a3..2cde5091775a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -309,7 +309,7 @@ static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept |= (1ULL << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -318,14 +318,14 @@ static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept &= ~(1ULL << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 {
-	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
+	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
 static inline bool vgif_enabled(struct vcpu_svm *svm)
@@ -389,17 +389,17 @@ static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
+	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
 }
 
 static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
+	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
 }
 
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
+	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2..6e7262229e6a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -544,26 +544,30 @@ TRACE_EVENT(kvm_nested_vmrun,
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
-	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept),
-	    TP_ARGS(cr_read, cr_write, exceptions, intercept),
+	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u32 intercept1,
+		     __u32 intercept2),
+	    TP_ARGS(cr_read, cr_write, exceptions, intercept1, intercept2),
 
 	TP_STRUCT__entry(
 		__field(	__u16,		cr_read		)
 		__field(	__u16,		cr_write	)
 		__field(	__u32,		exceptions	)
-		__field(	__u64,		intercept	)
+		__field(	__u32,		intercept1	)
+		__field(	__u32,		intercept2	)
 	),
 
 	TP_fast_assign(
 		__entry->cr_read	= cr_read;
 		__entry->cr_write	= cr_write;
 		__entry->exceptions	= exceptions;
-		__entry->intercept	= intercept;
+		__entry->intercept1	= intercept1;
+		__entry->intercept2	= intercept2;
 	),
 
-	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
-		__entry->cr_read, __entry->cr_write, __entry->exceptions,
-		__entry->intercept)
+	TP_printk("cr_read: %04x cr_write: %04x excp: %08x "
+		  "intercept1: %08x intercept2: %08x",
+		  __entry->cr_read, __entry->cr_write, __entry->exceptions,
+		  __entry->intercept1, __entry->intercept2)
 );
 /*
  * Tracepoint for #VMEXIT while nested

