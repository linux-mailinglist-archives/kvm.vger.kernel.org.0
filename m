Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5695D45D200
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345051AbhKYA2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:28:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:6408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352764AbhKYAYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649672"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649672"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:07 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042140"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:06 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 15/59] KVM: x86: Introduce "protected guest" concept and block disallowed ioctls
Date:   Wed, 24 Nov 2021 16:19:58 -0800
Message-Id: <3e78c301460dfabc2aec22bde3907207011435b9.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 80 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f4b6f70489b..b21fcf3c0cc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4539,6 +4539,10 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
+	/* TODO: use more precise flag */
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	kvm_make_request(KVM_REQ_SMI, vcpu);
 
 	return 0;
@@ -4585,6 +4589,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 	unsigned bank_num = mcg_cap & 0xff;
 	u64 *banks = vcpu->arch.mce_banks;
 
+	/* TODO: use more precise flag */
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
 	/*
@@ -4680,7 +4688,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+	if (!vcpu->arch.guest_state_protected)
+		events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
@@ -4709,11 +4718,17 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
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
+	/* TODO: introduce more precise flag */
+	if (vcpu->arch.guest_state_protected)
+		allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;
+
+	if (events->flags & ~allowed_flags)
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -4789,17 +4804,22 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
-					     struct kvm_debugregs *dbgregs)
+static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
+					    struct kvm_debugregs *dbgregs)
 {
 	unsigned long val;
 
+	if (vcpu->arch.guest_state_protected)
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
@@ -4813,6 +4833,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (!kvm_dr7_valid(dbgregs->dr7))
 		return -EINVAL;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
@@ -4845,18 +4868,22 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					      supported_xcr0, &vcpu->arch.pkru);
 }
 
-static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-					struct kvm_xcrs *guest_xcrs)
+static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
+				       struct kvm_xcrs *guest_xcrs)
 {
+	if (vcpu->arch.guest_state_protected)
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
@@ -4864,6 +4891,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 {
 	int i, r = 0;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -EINVAL;
 
@@ -5247,7 +5277,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
-		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &dbgregs,
@@ -5297,7 +5329,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xcrs)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		if (r)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xcrs,
@@ -10188,6 +10222,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (vcpu->arch.guest_state_protected &&
+	    (kvm_run->kvm_valid_regs || kvm_run->kvm_dirty_regs)) {
+		r = -EINVAL;
+		goto out;
+	}
+
 	if (kvm_run->kvm_dirty_regs) {
 		r = sync_regs(vcpu);
 		if (r != 0)
@@ -10218,7 +10258,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs && !vcpu->arch.guest_state_protected)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_sigset_deactivate(vcpu);
@@ -10265,6 +10305,9 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -10305,6 +10348,9 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -10387,6 +10433,9 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -10635,6 +10684,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	ret = __set_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
-- 
2.25.1

