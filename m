Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBBF2818BF
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388532AbgJBRGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:47 -0400
Received: from mail-eopbgr770054.outbound.protection.outlook.com ([40.107.77.54]:30056
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388054AbgJBRGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GH7MuoUH4QtJtTqmGeyQF51tFEkIA6ZuC+eT2TgNV0tqgklSwx4Ebpg9EvAl2+ArI/mO6eqon0N2fqKicEUbVAyMV+Ql5uoClLAYEBcBzdNP16MwzB4aXd+U0wEgeZc9H7usnid2IUK9nAcSzydb6WkWv4laNKJGQNbiZlVQ5FZ91gL9OWlNVRSz8VCSWHgOn3NQu/SP8J10FhVKhbZLgmqzX1eRpOBJEzw5Su2R8zbkLFTyCyT0oxX2A64NtlV//nOOSaRhb5LzqxsJsjj+tvXmmberbZdKZMJBLAXJTuwPloliECftHkQrajrzxQsQSBpwybo4k/YXjhTFVw5UNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2ZSSbEckuDtY4WfsBGcix7XSH5yfxaFl6aityseS8Y=;
 b=BJ28x29SJT3J7bJyRL6g5VC7rkSCbwHen7zfvaSHQ1HA9B5JF9Zo8lMoqDC8MGq1HRBTghn0pW02QvUM2rnERfueUTb2QLrqv4S0cPW2wBq1flH3ku39ub4CCibIN6f7XV9zBp/8i47TDHvADOw0vGgT0HIOIDknpN58icEr5GN40JkoK+j1mBeag+uDWs+1t2aAmMQEMrTXCLNnubdzcgeI6ZB8Uhjd7jjvQV3QeugrnVbqexdk9ufKqB13mlCac16HVhYIEbrSZeLgWF5LDQ7UStzFKzdMGloRZ/Q0cKC007+v+3R30NcdEAKL7eB9STw/DoEIcW5M/5Vg0Q0T1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2ZSSbEckuDtY4WfsBGcix7XSH5yfxaFl6aityseS8Y=;
 b=WfxIb+Gve0A80wZnY6jPXDi0Qz3oP0p0eOursesRU2xB7JuU2nmjgbcLEOqwvUpWkq+gZ5jIQJVzj/0v70p6CEy8q7vqWCsgkiL5Dgo271ioktVeNrtZXAwkM31HAglPBQ3S6AnRP8LdUarzw/CDG10rUvOqYPc3Gv4utD8dTXw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:42 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:42 +0000
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
Subject: [RFC PATCH v2 25/33] KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:49 -0500
Message-Id: <7f5959a865807fac16f377100fbc141e1155eaf0.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0072.namprd12.prod.outlook.com
 (2603:10b6:802:20::43) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0072.namprd12.prod.outlook.com (2603:10b6:802:20::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:06:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d628e74-4a33-4c0f-cb7e-08d866f5891a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42189872C8A0722B44D648C2EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwQMRSgtDC0KGZ4wHts5lka3caOhNhoI4JmeO515uunzbLWWDLAr2jMWYSzMkuy8twiIod7H20jrhaT9KC7z2RXv4yUADzYJ/KbkQpIr/0kEc16YTfkHMNBreW4GKdMx4fq0KiIJXr9pt/b3XODcoE9gfOsca4RQz8Y0lPeFdWnVJSizIIu/Qwej1BZnudjGV/0xAHDp9rj1M1UUq47iCHQ24wAzKObm2oktl4UW1kfqFlz/Qf9Ju0LSz/8+6SE6OLXiuzXF0j03ZpAv2I8sG8lOGnd+hcA8IQdsPRqJr3fg/NbSz3FdXSuFvhRgW8jQS2GD+EgK8jxZvfXqeVofNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5ah7bLVT12tsl+A18cfnwvAiP75ai97GGqJHnuuJSO4Pk0FF9TyRCeGsqKkAn+0ZKJMkr42is4T8kZlDf0YV9p2Nw7z29HYW3nK5cPYNG8aS3rqZQOTw7kE/g2t3YmJIXyH/B3fkB9OAkX0P0I9bFT469Hy4MWeRhR5rN3bGPE9M9P9MU87gygArTUrcYvI6aoSqiwM+L+O/AGECuID37mP7B2CfETNa0oBRcFnPeYYDANhQ36QZ1RZWpJw1sq+9zdzBkeyKnDmDYocMc/bsDM+3BtAyPE/6hP90+8v5CrSBv938ZXIUCaI5AyVHQoORVCAu/h7y0gTXfY54whINymlWQw88B/Td7NK5hA1KK8iKweTAFIf95hF+9rIAzgoO1eTlDrNVzm+IoIHZlqOEpz11C8Avu5cxWMEoI2jTu+3asmym8QeZnLgqhdb6kmtlRi9dDEwx8ntRw2Ha1rsqE1KgULi5ERoDkU7bi93pHwqk6oWVNoMVG1wuP6jVvbwDO6IiWDASypMI04C5sDDXxqUSdyWA+AcoeyUCK2kKytytH1m26pc3C7xmwheLQcLxb5vawfFEQ9UiEI26/xhsxUUC49TfCx7vN/kWnr24GoNkzuzL1e8+P34A5fhBpYk71b1KJUTYbnKURkGJBrpSnA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d628e74-4a33-4c0f-cb7e-08d866f5891a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:42.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2qi1y7hCV/NICu8uXCE3NBkMe9lHMeA6ei+y+EWfSoZK+o5b2jUUxdTdJBE5eK7WzjlihqG0NA7tK4cAjQ2Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The guest FPU state is automatically restored on VMRUN and saved on VMEXIT
by the hardware, so there is no reason to do this in KVM. Eliminate the
allocation of the guest_fpu save area and key off that to skip operations
related to the guest FPU state.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 10 ++++++
 arch/x86/kvm/x86.c              | 56 +++++++++++++++++++++++++++------
 3 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 30f1300a05c0..d5ca8c6b0d5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,6 +1444,8 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+void kvm_free_guest_fpu(struct kvm_vcpu *vcpu);
+
 int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index de44f7f2b7a8..13560b90b81a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1301,6 +1301,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!vmsa_page)
 			goto error_free_hsave_page;
+
+		/*
+		 * SEV-ES guests maintain an encrypted version of their FPU
+		 * state which is restored and saved on VMRUN and VMEXIT.
+		 * Free the fpu structure to prevent KVM from attempting to
+		 * access the FPU state.
+		 */
+		kvm_free_guest_fpu(vcpu);
 	}
 
 	err = avic_init_vcpu(svm);
@@ -3792,6 +3800,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
 
 	clgi();
+
 	kvm_load_guest_xsave_state(vcpu);
 
 	kvm_wait_lapic_expire(vcpu);
@@ -3837,6 +3846,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_before_interrupt(&svm->vcpu);
 
 	kvm_load_host_xsave_state(vcpu);
+
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20fabf578ab7..931a17ba5cbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4407,6 +4407,9 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
@@ -4424,9 +4427,14 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
-	u64 xstate_bv =
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
-	u32 mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
+	u64 xstate_bv;
+	u32 mxcsr;
+
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
+	xstate_bv = *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
+	mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		/*
@@ -9126,9 +9134,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.user_fpu);
 
-	/* PKRU is separately restored in kvm_x86_ops.run.  */
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
-				~XFEATURE_MASK_PKRU);
+	/*
+	 * Guests with protected state can't have it set by the hypervisor,
+	 * so skip trying to set it.
+	 */
+	if (vcpu->arch.guest_fpu)
+		/* PKRU is separately restored in kvm_x86_ops.run. */
+		__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
+					~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -9141,7 +9154,12 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	kvm_save_current_fpu(vcpu->arch.guest_fpu);
+	/*
+	 * Guests with protected state can't have it read by the hypervisor,
+	 * so skip trying to save it.
+	 */
+	if (vcpu->arch.guest_fpu)
+		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
@@ -9657,6 +9675,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9677,6 +9698,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9735,6 +9759,9 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	fpstate_init(&vcpu->arch.guest_fpu->state);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
@@ -9748,6 +9775,15 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
+void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.guest_fpu) {
+		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+		vcpu->arch.guest_fpu = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
@@ -9843,7 +9879,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_guest_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 free_emulate_ctxt:
@@ -9897,7 +9933,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
@@ -9944,7 +9980,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
 		void *mpx_state_buffer;
 
 		/*
-- 
2.28.0

