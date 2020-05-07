Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A971C88E9
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgEGLux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbgEGLuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=PLBBS9aFuTqxVtmqT4itbzBp+MpmjRogU7DCRiVBJvo=;
        b=WxowdvpDXV9M852AmOwnAhqGY21EPC/A7rejLvHdkmbjkQrazmJ2wVPhAll5FQb3rRlzSX
        TLJw8H6skynax4nJ3YTflVSRbns8pymrb+lnLm8isOD0kUtxZK+Iwtym3Ii11IVmolJK8h
        a53eDPs5rkQTGjX7zbxGD/huABEEVD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-z7DYs-3rOZmhBGhQjvQEiw-1; Thu, 07 May 2020 07:50:19 -0400
X-MC-Unique: z7DYs-3rOZmhBGhQjvQEiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E27DEEC1A3;
        Thu,  7 May 2020 11:50:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 878DA1C933;
        Thu,  7 May 2020 11:50:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from vmcb->save.dr6
Date:   Thu,  7 May 2020 07:50:10 -0400
Message-Id: <20200507115011.494562-9-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two issues with KVM_EXIT_DEBUG on AMD, whose root cause is the
different handling of DR6 on intercepted #DB exceptions on Intel and AMD.

On Intel, #DB exceptions transmit the DR6 value via the exit qualification
field of the VMCS, and the exit qualification only contains the description
of the precise event that caused a vmexit.

On AMD, instead the DR6 field of the VMCB is filled in as if the #DB exception
was to be injected into the guest.  This has two effects when guest debugging
is in use:

* the guest DR6 is clobbered

* the kvm_run->debug.arch.dr6 field can accumulate more debug events, rather
than just the last one that happened (the testcase in the next patch covers
this issue).

This patch fixes both issues by emulating, so to speak, the Intel behavior
on AMD processors.  The important observation is that (after the previous
patches) the VMCB value of DR6 is only ever observable from the guest is
KVM_DEBUGREG_WONT_EXIT is set.  Therefore we can actually set vmcb->save.dr6
to any value we want as long as KVM_DEBUGREG_WONT_EXIT is clear, which it
will be if guest debugging is enabled.

Therefore it is possible to enter the guest with an all-zero DR6,
reconstruct the #DB payload from the DR6 we get at exit time, and let
kvm_deliver_exception_payload move the newly set bits into vcpu->arch.dr6.
Some extra bits may be included in the payload if KVM_DEBUGREG_WONT_EXIT
is set, but this is harmless.

This may not be the most optimized way to deal with this, but it is
simple and, being confined within SVM code, it gets rid of the set_dr6
callback and kvm_update_dr6.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/nested.c       | 14 +++++++++++---
 arch/x86/kvm/svm/svm.c          | 29 +++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c          |  5 -----
 arch/x86/kvm/x86.c              | 12 ------------
 5 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93f6f696d059..9e8263b1e6fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1093,7 +1093,6 @@ struct kvm_x86_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
-	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1a547e3ac0e5..9a2a62e5afeb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -633,10 +633,18 @@ static int nested_svm_intercept_db(struct vcpu_svm *svm)
 
 reflected_db:
 	/*
-	 * Synchronize guest DR6 here just like in db_interception; it will
-	 * be moved into the nested VMCB by nested_svm_vmexit.
+	 * Synchronize guest DR6 here just like in kvm_deliver_exception_payload;
+	 * it will be moved into the nested VMCB by nested_svm_vmexit.  Once
+	 * exceptions will be moved to svm_check_nested_events, all this stuff
+	 * will just go away and we could just return NESTED_EXIT_HOST
+	 * unconditionally.  db_interception will queue the exception, which
+	 * will be processed by svm_check_nested_events if a nested vmexit is
+	 * required, and we will just use kvm_deliver_exception_payload to copy
+	 * the payload to DR6 before vmexit.
 	 */
-	svm->vcpu.arch.dr6 = dr6;
+	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
+	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
+	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
 	return NESTED_EXIT_DONE;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f03bffafd9e6..a862c768fd54 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1672,12 +1672,14 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
-static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
+static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
 
-	svm->vmcb->save.dr6 = value;
-	mark_dirty(svm->vmcb, VMCB_DR);
+	if (unlikely(value != vmcb->save.dr6)) {
+		vmcb->save.dr6 = value;
+		mark_dirty(vmcb, VMCB_DR);
+	}
 }
 
 static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
@@ -1688,9 +1690,12 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
+	/*
+	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
+	 * because db_interception might need it.  We can do it before vmentry.
+	 */
 	vcpu->arch.dr6 = svm->vmcb->save.dr6;
 	vcpu->arch.dr7 = svm->vmcb->save.dr7;
-
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
 	set_dr_intercepts(svm);
 }
@@ -1734,8 +1739,8 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
-		vcpu->arch.dr6 = svm->vmcb->save.dr6;
-		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
+		u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
+		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
 		return 1;
 	}
 
@@ -3313,6 +3318,15 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
+	/*
+	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
+	 * of a #DB.
+	 */
+	if (unlikely(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
+		svm_set_dr6(svm, vcpu->arch.dr6);
+	else
+		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
+
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
@@ -3927,7 +3941,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6153a47109d3..e2b71b0cdfce 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4965,10 +4965,6 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-}
-
 static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	get_debugreg(vcpu->arch.db[0], 0);
@@ -7731,7 +7727,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
-	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b1b92d904f37..f780af601c5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,7 +104,6 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
-static void kvm_update_dr6(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -474,7 +473,6 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
-		kvm_update_dr6(vcpu);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
@@ -1048,12 +1046,6 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_update_dr6(struct kvm_vcpu *vcpu)
-{
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
-		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
-}
-
 static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 {
 	unsigned long dr7;
@@ -1093,7 +1085,6 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 		if (val & 0xffffffff00000000ULL)
 			return -1; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
-		kvm_update_dr6(vcpu);
 		break;
 	case 5:
 		/* fall through */
@@ -4009,7 +4000,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
-	kvm_update_dr6(vcpu);
 	vcpu->arch.dr7 = dbgregs->dr7;
 	kvm_update_dr7(vcpu);
 
@@ -8418,7 +8408,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
 		kvm_x86_ops.sync_dirty_debug_regs(vcpu);
 		kvm_update_dr0123(vcpu);
-		kvm_update_dr6(vcpu);
 		kvm_update_dr7(vcpu);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
@@ -9479,7 +9468,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = DR6_INIT;
-	kvm_update_dr6(vcpu);
 	vcpu->arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(vcpu);
 
-- 
2.18.2


