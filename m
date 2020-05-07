Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6191C88DE
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEGLu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726906AbgEGLuY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=mECb3ShBRZGDZIbMB6qaSL3T8Up7GntQKNBI+0t6vuo=;
        b=DBu3Ik+i1HjagIfdrTMWMpZ0wl2Sx4jLI0QRQ5NS2E6joKDaMpEO7/nqurZFiEKf184Tua
        Mfw8pRsHCmjtnYQDDly0Ah5smFN/S+tvHNWGB3RDx/fD8aZ6oQv9Oc4+DgaaY6llcLh3KE
        rG75qNEKQQ/b1Z1+v+TwHAJQn5wBbbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-K3q6sYYzMCuvb1Hn4CDz0w-1; Thu, 07 May 2020 07:50:19 -0400
X-MC-Unique: K3q6sYYzMCuvb1Hn4CDz0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DFDD80B722;
        Thu,  7 May 2020 11:50:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1144E1C933;
        Thu,  7 May 2020 11:50:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 7/9] KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
Date:   Thu,  7 May 2020 07:50:09 -0400
Message-Id: <20200507115011.494562-8-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_x86_ops.set_dr6 is only ever called with vcpu->arch.dr6 as the
second argument.  Ensure that the VMCB value is synchronized to
vcpu->arch.dr6 on #DB (both "normal" and nested), so that the current
value of DR6 is always available in vcpu->arch.dr6.  The get_dr6 callback
can just access vcpu->arch.dr6 and becomes redundant.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/nested.c       | 23 +++++++++++++++--------
 arch/x86/kvm/svm/svm.c          |  9 ++-------
 arch/x86/kvm/vmx/vmx.c          |  6 ------
 arch/x86/kvm/x86.c              |  5 +----
 5 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c247bcb037e..93f6f696d059 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1093,7 +1093,6 @@ struct kvm_x86_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
-	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index adab5b1c5fe1..1a547e3ac0e5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 
 #include <asm/msr-index.h>
+#include <asm/debugreg.h>
 
 #include "kvm_emulate.h"
 #include "trace.h"
@@ -267,7 +268,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
 	svm->vmcb->save.rip = nested_vmcb->save.rip;
 	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
-	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
+	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
@@ -482,7 +483,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->save.rsp    = vmcb->save.rsp;
 	nested_vmcb->save.rax    = vmcb->save.rax;
 	nested_vmcb->save.dr7    = vmcb->save.dr7;
-	nested_vmcb->save.dr6    = vmcb->save.dr6;
+	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
 	nested_vmcb->save.cpl    = vmcb->save.cpl;
 
 	nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
@@ -606,7 +607,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 /* DB exceptions for our internal use must not cause vmexit */
 static int nested_svm_intercept_db(struct vcpu_svm *svm)
 {
-	unsigned long dr6;
+	unsigned long dr6 = svm->vmcb->save.dr6;
 
 	/* Always catch it and pass it to userspace if debugging the guest.  */
 	if (svm->vcpu.guest_debug &
@@ -615,22 +616,28 @@ static int nested_svm_intercept_db(struct vcpu_svm *svm)
 
 	/* if we're not singlestepping, it's not ours */
 	if (!svm->nmi_singlestep)
-		return NESTED_EXIT_DONE;
+		goto reflected_db;
 
 	/* if it's not a singlestep exception, it's not ours */
-	if (kvm_get_dr(&svm->vcpu, 6, &dr6))
-		return NESTED_EXIT_DONE;
 	if (!(dr6 & DR6_BS))
-		return NESTED_EXIT_DONE;
+		goto reflected_db;
 
 	/* if the guest is singlestepping, it should get the vmexit */
 	if (svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF) {
 		disable_nmi_singlestep(svm);
-		return NESTED_EXIT_DONE;
+		goto reflected_db;
 	}
 
 	/* it's ours, the nested hypervisor must not see this one */
 	return NESTED_EXIT_HOST;
+
+reflected_db:
+	/*
+	 * Synchronize guest DR6 here just like in db_interception; it will
+	 * be moved into the nested VMCB by nested_svm_vmexit.
+	 */
+	svm->vcpu.arch.dr6 = dr6;
+	return NESTED_EXIT_DONE;
 }
 
 static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f6aeefeb55..f03bffafd9e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1672,11 +1672,6 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
-static u64 svm_get_dr6(struct kvm_vcpu *vcpu)
-{
-	return to_svm(vcpu)->vmcb->save.dr6;
-}
-
 static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1693,7 +1688,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
-	vcpu->arch.dr6 = svm_get_dr6(vcpu);
+	vcpu->arch.dr6 = svm->vmcb->save.dr6;
 	vcpu->arch.dr7 = svm->vmcb->save.dr7;
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
@@ -1739,6 +1734,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
+		vcpu->arch.dr6 = svm->vmcb->save.dr6;
 		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
@@ -3931,7 +3927,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2384a2dbec44..6153a47109d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4965,11 +4965,6 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static u64 vmx_get_dr6(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.dr6;
-}
-
 static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
 {
 }
@@ -7736,7 +7731,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
-	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7628555f036..b1b92d904f37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1129,10 +1129,7 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 	case 4:
 		/* fall through */
 	case 6:
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
-			*val = vcpu->arch.dr6;
-		else
-			*val = kvm_x86_ops.get_dr6(vcpu);
+		*val = vcpu->arch.dr6;
 		break;
 	case 5:
 		/* fall through */
-- 
2.18.2


