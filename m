Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CAC2B4F99
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbgKPS2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:20631 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387541AbgKPS2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:01 -0500
IronPort-SDR: Vg83dSd5UFRouAKPihuajBzqn/+XmU/q2YX1+gmmz01qy4awjVpvj7/jmot/zp6Hulv8teIpeu
 cyuElxd3ZTUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410016"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410016"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:00 -0800
IronPort-SDR: OI90Sp+0qmyiFgxzCdljXpg25545QW2CfvlbrQzS4Ul6dLLLdHacOO7IzVMVaYWDUsqP0qOCMN
 gHEYX63lwytQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527908"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:59 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 17/67] KVM: x86: Introduce "protected guest" concept and block disallowed ioctls
Date:   Mon, 16 Nov 2020 10:26:02 -0800
Message-Id: <b2485e5d0fc7876f9e7750c95dd70914bbffb6d0.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add 'guest_state_protected' to mark a VM's state as being protected by
hardware/firmware, e.g. SEV-ES or TDX-SEAM.  Use the flag to disallow
ioctls() and/or flows that attempt to access protected state.

Return an error if userspace attempts to get/set register state for a
protected VM, e.g. a non-debug TDX guest.  KVM can't provide sane data,
it's userspace's responsibility to avoid attempting to read guest state
when it's known to be inaccessible.

Retrieving vCPU events is the one exception, as the userspace VMM is
allowed to inject NMIs.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/x86.c              | 113 +++++++++++++++++++++++++++-----
 2 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ff33efd6394..e687a8bd46ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -994,6 +994,8 @@ struct kvm_arch {
 		struct msr_bitmap_range ranges[16];
 	} msr_filter;
 
+	bool guest_state_protected;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1fa6a042984b..6154abecd546 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3966,7 +3966,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted && !vcpu->kvm->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
 	/*
@@ -4074,6 +4074,9 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	kvm_make_request(KVM_REQ_SMI, vcpu);
 
 	return 0;
@@ -4120,6 +4123,9 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 	unsigned bank_num = mcg_cap & 0xff;
 	u64 *banks = vcpu->arch.mce_banks;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
 	/*
@@ -4212,7 +4218,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
+	if (!vcpu->kvm->arch.guest_state_protected)
+		events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
@@ -4241,11 +4248,16 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu);
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
-	if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
-			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
-			      | KVM_VCPUEVENT_VALID_SHADOW
-			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+	u32 allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING |
+			    KVM_VCPUEVENT_VALID_SIPI_VECTOR |
+			    KVM_VCPUEVENT_VALID_SHADOW |
+			    KVM_VCPUEVENT_VALID_SMM |
+			    KVM_VCPUEVENT_VALID_PAYLOAD;
+
+	if (vcpu->kvm->arch.guest_state_protected)
+		allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;
+
+	if (events->flags & ~allowed_flags)
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -4326,17 +4338,22 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
-					     struct kvm_debugregs *dbgregs)
+static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
+					    struct kvm_debugregs *dbgregs)
 {
 	unsigned long val;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
 	dbgregs->flags = 0;
 	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
+
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
@@ -4350,6 +4367,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (dbgregs->dr7 & ~0xffffffffull)
 		return -EINVAL;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
@@ -4445,9 +4465,12 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	}
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+					struct kvm_xsave *guest_xsave)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
@@ -4458,6 +4481,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
 	}
+
+	return 0;
 }
 
 #define XSAVE_MXCSR_OFFSET 24
@@ -4469,6 +4494,9 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
 	u32 mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		/*
 		 * Here we allow setting states that are not present in
@@ -4488,18 +4516,22 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-					struct kvm_xcrs *guest_xcrs)
+static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
+				       struct kvm_xcrs *guest_xcrs)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
 		guest_xcrs->nr_xcrs = 0;
-		return;
+		return 0;
 	}
 
 	guest_xcrs->nr_xcrs = 1;
 	guest_xcrs->flags = 0;
 	guest_xcrs->xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
 	guest_xcrs->xcrs[0].value = vcpu->arch.xcr0;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
@@ -4507,6 +4539,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 {
 	int i, r = 0;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -EINVAL;
 
@@ -4776,7 +4811,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
-		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &dbgregs,
@@ -4802,7 +4839,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
@@ -4826,7 +4865,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xcrs)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xcrs,
@@ -8136,6 +8177,15 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
+	if (vcpu->kvm->arch.guest_state_protected) {
+		kvm_run->if_flag = false;
+		kvm_run->flags = false;
+		kvm_run->cr8 = 0;
+		kvm_run->apic_base = kvm_get_apic_base(vcpu);
+		kvm_run->ready_for_interrupt_injection = false;
+		return;
+	}
+
 	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
 	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
@@ -9263,6 +9313,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (vcpu->kvm->arch.guest_state_protected &&
+	    (kvm_run->kvm_valid_regs || kvm_run->kvm_dirty_regs)) {
+		r = -EINVAL;
+		goto out;
+	}
+
 	if (kvm_run->kvm_dirty_regs) {
 		r = sync_regs(vcpu);
 		if (r != 0)
@@ -9293,7 +9349,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs && !vcpu->kvm->arch.guest_state_protected)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_sigset_deactivate(vcpu);
@@ -9340,6 +9396,9 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -9380,6 +9439,9 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -9435,6 +9497,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -9634,6 +9699,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	ret = __set_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -9646,6 +9714,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
@@ -9725,6 +9796,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9745,6 +9819,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (vcpu->kvm->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
-- 
2.17.1

