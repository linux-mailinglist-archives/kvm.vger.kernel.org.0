Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A663144EA92
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhKLPml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:42:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:34523 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235297AbhKLPm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:42:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093236"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093236"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182156"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:38:09 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 09/11] KVM: x86: Block ioctls to access guest state for TDX
Date:   Fri, 12 Nov 2021 23:37:31 +0800
Message-Id: <20211112153733.2767561-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For non-debug TDX guest, its states (REGS, SREGS, FPU, XSAVE, XCRS, etc)
cannot be accessed (neither get nor set). Return an error if userspace
attempts to get/set register state for a TDX guest.  KVM can't provide
sane data, it's userspace's responsibility to avoid attempting to read
guest state when it's known to be inaccessible.

Retrieving vCPU events is the one exception, as the userspace VMM is
allowed to inject NMIs.

Note, for debug TD, most guest state will become accesible. It's future
work when enabling debug TD support

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 105 +++++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.h |   5 +++
 2 files changed, 93 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f3cc2a2d844..d06ee07bd486 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4645,7 +4645,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+	if (!kvm_guest_state_inaccesible(vcpu))
+		events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
@@ -4671,14 +4672,24 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
 
+static inline u32 kvm_get_allowed_vcpu_event_flags(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return KVM_VCPUEVENT_VALID_NMI_PENDING;
+	else
+		return KVM_VCPUEVENT_VALID_NMI_PENDING |
+		       KVM_VCPUEVENT_VALID_SIPI_VECTOR |
+		       KVM_VCPUEVENT_VALID_SHADOW |
+		       KVM_VCPUEVENT_VALID_SMM |
+		       KVM_VCPUEVENT_VALID_PAYLOAD;
+}
+
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
-	if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
-			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
-			      | KVM_VCPUEVENT_VALID_SHADOW
-			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+	u32 allowed_flags = kvm_get_allowed_vcpu_event_flags(vcpu);
+
+	if (events->flags & ~allowed_flags)
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -4754,17 +4765,22 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
-					     struct kvm_debugregs *dbgregs)
+static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
+					    struct kvm_debugregs *dbgregs)
 {
 	unsigned long val;
 
+	if (kvm_guest_state_inaccesible(vcpu))
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
@@ -4778,6 +4794,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (!kvm_dr7_valid(dbgregs->dr7))
 		return -EINVAL;
 
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
@@ -4787,21 +4806,28 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return;
+		return 0;
 
 	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
 				       guest_xsave->region,
 				       sizeof(guest_xsave->region),
 				       vcpu->arch.pkru);
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
@@ -4810,18 +4836,22 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					      supported_xcr0, &vcpu->arch.pkru);
 }
 
-static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-					struct kvm_xcrs *guest_xcrs)
+static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
+				       struct kvm_xcrs *guest_xcrs)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
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
@@ -4829,6 +4859,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 {
 	int i, r = 0;
 
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -EINVAL;
 
@@ -5220,7 +5253,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
-		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &dbgregs,
@@ -5246,7 +5281,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
@@ -5270,7 +5307,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xcrs)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xcrs,
@@ -5413,6 +5452,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_GET_SREGS2: {
+		r = -EINVAL;
+		if (kvm_guest_state_inaccesible(vcpu))
+			goto out;
+
 		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.sregs2)
@@ -5425,6 +5468,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_SREGS2: {
+		r = -EINVAL;
+		if (kvm_guest_state_inaccesible(vcpu))
+			goto out;
+
 		u.sregs2 = memdup_user(argp, sizeof(struct kvm_sregs2));
 		if (IS_ERR(u.sregs2)) {
 			r = PTR_ERR(u.sregs2);
@@ -10148,6 +10195,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (kvm_guest_state_inaccesible(vcpu) &&
+	    (kvm_run->kvm_valid_regs || kvm_run->kvm_dirty_regs)) {
+		r = -EINVAL;
+		goto out;
+	}
+
 	if (kvm_run->kvm_dirty_regs) {
 		r = sync_regs(vcpu);
 		if (r != 0)
@@ -10178,7 +10231,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs && !kvm_guest_state_inaccesible(vcpu))
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_sigset_deactivate(vcpu);
@@ -10225,6 +10278,9 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -10265,6 +10321,9 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -10347,6 +10406,9 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -10595,6 +10657,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	ret = __set_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -10688,6 +10753,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
@@ -10711,6 +10779,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (kvm_guest_state_inaccesible(vcpu))
+		return -EINVAL;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2203cc283e04..6b3cf1fdcf08 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -466,6 +466,11 @@ static __always_inline bool kvm_init_sipi_unsupported(struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
+static __always_inline bool kvm_guest_state_inaccesible(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

