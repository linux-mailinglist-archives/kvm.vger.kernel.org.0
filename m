Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725EA23164E
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgG1Xi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:26 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:47457
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730632AbgG1XiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxrBwzwd5l9mJxQVLwItQPNV0RYBZJQdPX7V2hhYQJ2vn71j2JI65DQwfIdk7baLbXU3D/qkjt1jycuaLe9rlY+hcRsuWpkZ+CjnKqH2jhbZmSvlgpOLVPsFAHNMNkeEAntt7DVcp9T5kLBdJyqR7GgOdXDxQsz+GJ/jUITfmMlkPApz0MEuZ0i/mIIe0T/gW8xRD1n3C6eTnnHkNLGZcRqYVV7FsnKYxT2NsXwLtkaYNyp7+MMPlq+0rfunVzL7MYCYgms/LMWL3H4L5Vjjj52SSdKMI0u3hCzxrqR38Y858+AqSClbh7stJNlq+k2V/q8UJVdchccS3tsa8a85cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctoC0dLGNCpq/NAL9v5/m7UKKA/f35zw5hCrXjKsTNI=;
 b=Ri+EKxDIx+Ukp1MNCTtpDCWdC4OMNFu8/Zwa8ElZk8PceLHiM02RWQ9Ouzw6dZZRGvhtB+aplEBrI2JvgVlGK7urBV4umH/8XAR06fhY7hN+yGCdCxiIbQtYLUTSmH2eiwFpq5nBOWz4dX1oujABB6WXit9ZGZyjZOB0SyGvEZ5F+e9tjjWJtm1dUTiR8BJWvrupyp1bSBlqlMR1EX8bJ5ZY3urYgrxr33niU6k8yEh9gIOFJtWK81aQvpDFGrWHrKVGVonJ+v6IMayPprO9bq/43c7U9eP3MWo1LYtJBnrARRzO60s5gtlfcF1aApGt/Vx/I5XPXk2wJUhPRned6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctoC0dLGNCpq/NAL9v5/m7UKKA/f35zw5hCrXjKsTNI=;
 b=gScjxlIWEsbaQZ+RcNfseDjDOvBNCDNseEfbs7b+5YRDkBH8TLGrncgtVIJTJUghV/9lEdgmvx0PflYoXTW9Ow+OkNWbauN9hB0SP9O8VironNsPaj30JfizGNuNqPq9mlDBfbpJihrmJlGOQgprB5mUCbmM0Fgb+jzQqctRjm0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:21 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:21 +0000
Subject: [PATCH v3 05/11] KVM: SVM: Modify 64 bit intercept field to two 32
 bit vectors
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:19 -0500
Message-ID: <159597949971.12744.1782012822260431973.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0063.namprd12.prod.outlook.com
 (2603:10b6:802:20::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN1PR12CA0063.namprd12.prod.outlook.com (2603:10b6:802:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:38:20 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 017054d8-f9ca-4184-ca4d-08d8334f4fbe
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25597C71E154A2291875050695730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JyBB6u1q+NMxCwb5/icYJsXelku39KHh4zxSQtwWFJx451mSSIh4TAtulWtP49N0+FWPv9IPD0HxUrRhs/vrAfMi4PxnQZBCaYBvcCAJsSL04Y8lnM5ITANseYOK6Zn8eBQCjDL6As7vf3XJ+jhdg/sJMCy7bUt+AuSMYUA8mjBPeUWG9xP+emGmDIloF0ks0e4XNqa0f23YCpE9yz5pVsoUDwSfH/KriSFIhr405djVQRrzM2Lx4gulnt1ye0Khn1GoUME5ez9wBolBW0hS0+jaAt0DX4NfmuRbI8SIvOCpdSMbli7JB/l9jxMBrynUpUjv6MkWsF/D9bKjceIxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(30864003)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kCxzc/xDBNZpXT7XdslA7aMLnEBc0yua5ka4mqMm+STEe9imMuBOBwSPs88u0+9ulHamn73St5CZGdKKx+wmTXyvN9ZzU2Tg8VeHrgljsUkMWO/tOramoJOV1wFzmfEY0wI3MXbKcdpZ9H6mDNoHqoOoNzd2NdxAsqfD6DdfUOaCd0uru4C+zJ5XKtM/5sLNbu0zrFgoWohiVHQ2EH1DS+bSCS3wt5e0VFVHRFbR+QEcqw37RcPxrbwIMKSobYItU1/7Zk9Ie99WeyD4uUrd5Orxzdai2qptwteumuRbsv0+7rboXepWq8aWUpaLk+uBFvVo7q95polGu86YeqQeL2sLbuoinu+F1C1+9Fjw8MqeYQhUT+YbcwiXtemyS1AUfe9Ne/5dbf+EdsCLCADbiJ93eAhFme5C9/V2+PIyAFOjJdTGEGmBqjBFn/JUIgOrbN0/ONN1PGX+iOz7wNyKN9fc57rtknsSpX1VriECnE8LX2U9mPJYPLvx1tWvnE6rHcrdJuALtLAuAZzB1SR72bNCCeVW2JBWXs007u9Ifpymf6ppHJchoQdCgF1I4MyiIqI6RUoCAde0FavZvLMXY1WM3JgdvGiPSQUJ7p42VIEZ4RB3IIvt9mTybBR6NYu41oUOw/xHKlcG3zbnclozGg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017054d8-f9ca-4184-ca4d-08d8334f4fbe
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:20.8590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9egcmv3RFYQBDId78xYhvgt0C9fz61NPXZbQ0Je7581uaDylxbc9/Exu9q4/BP1H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert all the intercepts to one array of 32 bit vectors in
vmcb_control_area. This makes it easy for future intercept vector
additions.  Also update trace functions.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |   14 +++++++-------
 arch/x86/kvm/svm/nested.c  |   25 ++++++++++---------------
 arch/x86/kvm/svm/svm.c     |   18 ++++++++----------
 arch/x86/kvm/svm/svm.h     |   12 ++++++------
 arch/x86/kvm/trace.h       |   18 +++++++++++-------
 5 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 751a6deb64ef..aa9f1d62db29 100644
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
 	INTERCEPT_MC_VECTOR,
 	INTERCEPT_XM_VECTOR,
 	INTERCEPT_VE_VECTOR,
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
+	u8 reserved_1[60 - (MAX_VECTORS * 4)];
 	u16 pause_filter_thresh;
 	u16 pause_filter_count;
 	u64 iopm_base_pa;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ee126d5d3348..d2552de42fb1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -121,8 +121,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept = h->intercept;
-
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
 		__clr_intercept(&c->intercepts, INTERCEPT_CR8_READ);
@@ -133,16 +131,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		 * affect any interrupt we may want to inject; therefore,
 		 * interrupt window vmexits are irrelevant to L0.
 		 */
-		c->intercept &= ~(1ULL << INTERCEPT_VINTR);
+		__clr_intercept(&c->intercepts, INTERCEPT_VINTR);
 	}
 
 	/* We don't want to see VMMCALLs from a nested guest */
-	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+	__clr_intercept(&c->intercepts, INTERCEPT_VMMCALL);
 
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
-
-	c->intercept |= g->intercept;
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
@@ -153,7 +149,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
@@ -186,7 +181,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 */
 	int i;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(__is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -212,7 +207,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+	if ((__is_intercept(&control->intercepts, INTERCEPT_VMRUN)) == 0)
 		return false;
 
 	if (control->asid == 0)
@@ -436,7 +431,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
 				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
-				    nested_vmcb->control.intercept);
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_3],
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_4]);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
@@ -648,7 +644,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 offset, msr, value;
 	int write, mask;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(__is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -675,7 +671,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+	if (!(__is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
@@ -729,8 +725,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	default: {
-		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		if (svm->nested.ctl.intercept & exit_bits)
+		if (__is_intercept(&svm->nested.ctl.intercepts, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -838,7 +833,7 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
+	return __is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_INIT);
 }
 
 static void nested_svm_init(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4ac2c5bb365..1db783435a8a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2204,12 +2204,10 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
 {
 	unsigned long cr0 = svm->vcpu.arch.cr0;
 	bool ret = false;
-	u64 intercept;
-
-	intercept = svm->nested.ctl.intercept;
 
 	if (!is_guest_mode(&svm->vcpu) ||
-	    (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0))))
+	    (!(__is_intercept(&svm->nested.ctl.intercepts,
+			      INTERCEPT_SELECTIVE_CR0))))
 		return false;
 
 	cr0 &= ~SVM_CR0_SELECTIVE_MASK;
@@ -2802,7 +2800,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
-	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
+	pr_err("%-20s%08x\n", "intercept1:", control->intercepts[INTERCEPT_VECTOR_3]);
+	pr_err("%-20s%08x\n", "intercept2:", control->intercepts[INTERCEPT_VECTOR_4]);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
 	       control->pause_filter_thresh);
@@ -3677,7 +3676,6 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	case SVM_EXIT_WRITE_CR0: {
 		unsigned long cr0, val;
-		u64 intercept;
 
 		if (info->intercept == x86_intercept_cr_write)
 			icpt_info.exit_code += info->modrm_reg;
@@ -3686,9 +3684,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		intercept = svm->nested.ctl.intercept;
-
-		if (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0)))
+		if (!(__is_intercept(&svm->nested.ctl.intercepts,
+				     INTERCEPT_SELECTIVE_CR0)))
 			break;
 
 		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
@@ -3947,7 +3944,8 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	 * if an INIT signal is pending.
 	 */
 	return !gif_set(svm) ||
-		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
+		   (__is_intercept(&svm->vmcb->control.intercepts,
+				   INTERCEPT_INIT));
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9c798781172d..cf0cfd57a972 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -312,7 +312,7 @@ static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept |= (1ULL << bit);
+	__set_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }
@@ -321,14 +321,14 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept &= ~(1ULL << bit);
+	__clr_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline bool is_intercept(struct vcpu_svm *svm, int bit)
 {
-	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
+	return __is_intercept(&svm->vmcb->control.intercepts, bit);
 }
 
 static inline bool vgif_enabled(struct vcpu_svm *svm)
@@ -389,17 +389,17 @@ static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
+	return __is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_SMI);
 }
 
 static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
+	return __is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_INTR);
 }
 
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
+	return __is_intercept(&svm->nested.ctl.intercepts, INTERCEPT_NMI);
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
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

