Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B022668C2
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgIKTaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:30:03 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:48352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbgIKT30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdWDR9gbdqYptLcsazVKiI51Zsz9D+n1exLjwTwYIVjL0xcH9Tfk3beuJeMDHhvLOpH3sh7PSpc/vjnQJKVbCpjTB1GvzcD6rx9LquhaxmPEZZBpvKymEuxFUa2filD4njqA7pohRjXcC0yYJEqOAdHwLf+m68SOoiQNgJ08GBBdzN45xCrNqn7bC4Ge50ckVdnPEzXzFFqrJmpgvPX+QIHkY5KuNtX1ZLc7UjhvikVpff/Bz0sF5ZfN7ncJi2VHzS9iIYS79vB5qvoCuWAK1vkpKyH0SF1wAnMBKmsOgWeLvkbvYAu5fP9z+glPlsY2rBp2fEn2He6CTXpOm9Oovw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHU2Xn9kiLh7WV7gEewUQFD8r994ls4feZ7pKTUJhMM=;
 b=TPaTe4xjXv2T8qwQqiuUnZlWHnwzlpvaoRh/Ppyj2nfeVWBJ3/YiZ6xz7HyQCPKY5NBv+jEw5k9JY77sIMpO1vYzfgKKgusPx+O7MoKZkZGXFToslchJPKD/VnDaro8Q60RVcqjvUGCb9QFv1Awt689Np1a4dkjNpSgBQxDzht4/Cu+LCIQldjZD61nsuwvZ9bfUQ1jTWZduZ8d+lF4W4KPBowahGH+RevXIZPSNnqSOpVUdPDyr624Adx4hOjsHnzYZZQ1RVoFb2PE+nZy87W+SUnVJbE5T9CBc6rJF9LkTMb0Wi4RZkIHaMWnJTzVgvEfrkpkEcRAZOhThL9JceA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHU2Xn9kiLh7WV7gEewUQFD8r994ls4feZ7pKTUJhMM=;
 b=lPsJufYlMJbmGg25TcNWvDUS9rzB1M+cuN2fFFcwSp3BAv9x/jH0UPm/FB9O5AHXFQzmdzm4YS4bwnFLnML/YZPmHqk6/Zjdfajg9fONX7s7Zm9sSPIfEmGiZOcKLS+HzioFUkO6VaRjPk97v8B+RGPZpddfz/uTHTqrYXRKDEY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:30 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:30 +0000
Subject: [PATCH v6 05/12] KVM: SVM: Modify 64 bit intercept field to two 32
 bit vectors
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:28 -0500
Message-ID: <159985250813.11252.5736581193881040525.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0001.namprd21.prod.outlook.com
 (2603:10b6:5:174::11) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM6PR21CA0001.namprd21.prod.outlook.com (2603:10b6:5:174::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.3 via Frontend Transport; Fri, 11 Sep 2020 19:28:29 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4763efc2-9803-4457-143c-08d85688dd4c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4543C674965FE6F195E7121B95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1uRsmfS5aNeAKhIabt8/tfZ8hVZWmVN7TFzQjXofZ5/iJLWnrTlIMODWOMdZJ6O9W5UCowMROtA78ZejPl/SfC6y+Cw1MTQnnY15rgp7J6kVRrBdXbY+44M3xPz0OV0DfzDve2iv3t/Bw4DsYdElIeV0XAqHTDaPF6jekyfCn+oUdv1sf/pXzBMEA8i/7UdsqJHouwlmmO1mDaANE2MBqpROsRZ2Y3h/79FlSGOBxQhFs4uH6UryMDuxc/mWZqc646CQvoZ8I9fsOAsAtHS/pdx7es4CtUWnIOIfRuXrter8UsueyY+jaZ0F1pVG1rl/QSmHiVrECTJ/UCRvdK5+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(30864003)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ackTLmmsH3eQpgUNpVfme4fQhQqHsxF5+6cOU0ioSDs8+MCEz7RUhkNDW7gEfS+WjLF3uSmKdEID6r42t8Dnun4a4NSHfTs0k3Z9oJilm4YYaPXyb0immaY9pSDMiwrxUBaqIeNfcCqiJOddFY7A+rwr2m7u9CIwlr+nHMftmni9+WHVZhdPz58sE3ALtKwRhd/johmRd29bJPqpgSz7VbRs7thJPQofVZJSAG+NUTvEK8Ap9MEWwGiQm74HfZZKtRghTe29MAygMyytvwfqkpjzvac+euWzyuTv8+fl6K4PnNQc1wMOTMTb9GXhCDFCHm3PyUHdYLmWrS++ccrjWRfmFca9sJE5Aykxly9oxqM4GSnpgcCS4aRaxfbVWzz2L1lpUGXZrMzJ66Dw1aE+IHiiKqkogs6SJZmJH1tQxa4wIn484wPW/HBL6v8ZT4oJ7z76n4YzqLP6pE+fJWwGuBWVXMPwr0R1thuO0GUZN/hROlS3hLhozLMGP02LPfw+otebR90x2T/nl9GN7BAOWxtZg08XLdjXj7pGMh63/zKSjkWmbGqEQihbxLI56JmRgx32oQ062PR7WeXVufYBf8j/w0mFjqdr3FfrZJUd6LsX3m4X1qU7ZWJ7oQTcKBxt4Mz3CWF7iMV4MeDWtkWfcw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4763efc2-9803-4457-143c-08d85688dd4c
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:30.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTlNTU7PsBDGu/g6kwPotJeEfIQrk/RZbETJZtVj4RZV4ZX/FLECV8zuaC2m2oxx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
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
index c161bd38f401..353d550a5bb7 100644
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

