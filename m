Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5484B23E550
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHGArA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:00 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:1361
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbgHGAq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRk6Ap3TCaWOadtB1Cyal6hmRtl20wiq2gI2iuSVm8ejRH01fSVy9IuJso/mtlslH7kaH979aX8z67a1h4jO8RCoewFzFpE+B1Ui9SEUjV5OcZnsssqgmVK3LSi+fSahfn1N+X7K9meNMILERloGjvZRbPh2QIRrhtx/KdSp6+qbvOV00KBBkiYNS/XE24zAdCL955De88OWOWHPwXtf9Xu+mM3ht/VR/jM53Wta+qCY8KhEUHlWeO3/5DiB9AUET4cmtHzogt5kRRSVexn5476wpOPaYWv+oDe3zJbw4EhllR418oOGG4XzZFYx+5Bz+tg/UrTI/Ct9lwdaLu/9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AaFux4gDWhfQ9H+l4AdMGyAUmhoVV8Qe4bc2cntnB0=;
 b=P1aOtcCGGCKPIplQHYwAkrfI/bCvPasQFDEGxFkgdlmXH47wCmXbYyNyyUniTS8S0EWnyPagsxVQRP4Lukt/boCYyXDwdg7WOlX7WSGHNFQlFxU1vxh5JDRcunLWannmgpKMCifRuWmo//YSjig+P19GfYFO6sNoRcyU8ovP2bbxv3Sai+umsEtFeb1WgJE/9N456/aJ8DdILvCFQEu6EuYZVPGFlwHnDh7hm+hcZeoYOM9tkMIRjAJ0GD0GqJlgmniNgcW9/0ugjtgGE/i0i5qRFs1v1Ba3I+gpVoZislu5kPMCUGMkrx0Xc6tc5p2EKfSqMMkq4+1TXSwkR7Qldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AaFux4gDWhfQ9H+l4AdMGyAUmhoVV8Qe4bc2cntnB0=;
 b=wny73jfLd5IGFkffi5FBFEJ7eiq+3W8Pv5huHFH5tEaKESBp6jppjrYopNVQYkQipUxVSmqrDGh6/ZQTEKgOlCoXTstYSA0Hhjxzaj4AyFeRNC/SHBiwjcU6VVcKDlApdlKhAgE11/i0TlSOORgr8Uy7LvvbDiBIg1Mv+M/nm8k=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:56 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:56 +0000
Subject: [PATCH v4 05/12] KVM: SVM: Modify 64 bit intercept field to two 32
 bit vectors
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:54 -0500
Message-ID: <159676121478.12805.17232897630131635542.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0003.namprd21.prod.outlook.com
 (2603:10b6:805:106::13) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR2101CA0003.namprd21.prod.outlook.com (2603:10b6:805:106::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.0 via Frontend Transport; Fri, 7 Aug 2020 00:46:55 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2c02720-1037-4ec7-89ee-08d83a6b624f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44793C4F5F38402727F8C59595490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A46CfIVdispn7vrmizgb/A7PdBjPj8kpzSEbrIYn0JYR0osUJ1eLuyAwCz326RI/vWyTp4z+MIviF9ybE5LGjTr8GyQuAhaf+tS/HXxZDqvv5V5fz4O6FmCmtCoKSBH0Gbr1NT4PwNXUW6o5XWgldiOU5921ykU1ccEy2ikX3lkXoby72P7MTWf2MDrWFakTFJ5N3VnCin0yafhf6m5iLAqGmpmWndk4A1VS9a5gqGn7WeebNuYToz4JX2F3R/pOH84OSqaAYqnoU6tth5AnWRYrC9L9vw8FoSvGUdnez35WQcWc4xH32gdagubEQXgpAv8CZMmCp2IO3Bh7tqZqYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(30864003)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wPY+Np0CELTVowtgJzriNkkGFjYzitq0/iQd6dLAChb2Q35fNr8uxsD03mYijzs9UP8lkfTjRi6rWmQ2T0DVaKZxoVwdjk9VuF478gom4QTbslloL7suJseI2V/ChrDcYDXS8tP4iiOaKBGYIgxrskVwwZJfkyja2icLk62iakSRqhWQCygxhDAE3NjK0/zCael+ZjHu/8vBqg9FXdmwxwb+XWDkKXfxIX6JAVtTNiSHextAJxoIge/OjZnUxDcwJmkc+zwWSzT953G+OWtI0J0RGmpKUFBCE0yB1oUIK5c5A3tArid083g+xb6PWtGTkCiNk+xkWzVth0DL7qbSDJ5PiZm9waxpPEQ+4ab3FBKumgTrkn/QKf0rH+ZvGAcaEIibCUAeHIHo6KpQ2C59cqlAx6o9t9UAZC5ZtSlshyuPHvZPb2+Ih9fKpeZlQss2tu5URRmS1WBFdDnrkpc2XjKCX9qshvsFYkC+YQmQYyDAE1CmaOLPX1IM6BGzWkvRuCG9InBw1r0xfnxekXzLFt94u04+Gt964K1pE79+bxDFqedx2Q9WPhAketzMTzbN95h0D+oPTC9Qh3giM1lPJ0UWj7iODcYagGojPy0kjFo/Oybgbgo+nCeOMtb46+A1ynf9n9B2t6aqCMIFCG/e9Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c02720-1037-4ec7-89ee-08d83a6b624f
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:55.9625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oteYnN2D9u/BXLhMpQroCAloH5JU8/sFTWvIQ6LMlBj3iK+nl9Oj4NsR3Ts7FGF0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index 080c76dc05d4..2f498641e15f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -121,8 +121,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept = h->intercept;
-
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
 		vmcb_clr_intercept(c, INTERCEPT_CR8_READ);
@@ -133,16 +131,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
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
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -212,7 +207,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
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
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -675,7 +671,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
@@ -729,8 +725,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	default: {
-		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		if (svm->nested.ctl.intercept & exit_bits)
+		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -838,7 +833,7 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
+	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
 }
 
 static void nested_svm_init(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4ac2c5bb365..9bafb025df05 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2204,12 +2204,9 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
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
@@ -2802,7 +2799,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
-	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
+	pr_err("%-20s%08x\n", "intercept1:", control->intercepts[INTERCEPT_VECTOR_3]);
+	pr_err("%-20s%08x\n", "intercept2:", control->intercepts[INTERCEPT_VECTOR_4]);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
 	       control->pause_filter_thresh);
@@ -3677,7 +3675,6 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	case SVM_EXIT_WRITE_CR0: {
 		unsigned long cr0, val;
-		u64 intercept;
 
 		if (info->intercept == x86_intercept_cr_write)
 			icpt_info.exit_code += info->modrm_reg;
@@ -3686,9 +3683,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		intercept = svm->nested.ctl.intercept;
-
-		if (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0)))
+		if (!(vmcb_is_intercept(&svm->nested.ctl,
+					INTERCEPT_SELECTIVE_CR0)))
 			break;
 
 		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
@@ -3947,7 +3943,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	 * if an INIT signal is pending.
 	 */
 	return !gif_set(svm) ||
-		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
+		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 246ee5fc8077..2fe26c2df3e4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -312,7 +312,7 @@ static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept |= (1ULL << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -321,14 +321,14 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept &= ~(1ULL << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline bool is_intercept(struct vcpu_svm *svm, int bit)
 {
-	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
+	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
 static inline bool vgif_enabled(struct vcpu_svm *svm)
@@ -389,17 +389,17 @@ static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 
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

