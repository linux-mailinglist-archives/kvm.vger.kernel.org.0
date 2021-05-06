Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D6C375BA7
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhEFTWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:22:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230375AbhEFTWg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 15:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620328898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Z0QjuQrLcOOXbkjH3icVUPr3o/oGH5cz14pM4ocImo=;
        b=Q49NgLU/4kErWeCpqhA7Y1ASxpvtj//oM0U+bR66TnUL6HTedMYSQ74Uv/T0OAjOPFBQRs
        lEsY0yZ5Ouycjj3tbqKZOcI4W9poJyAvZi0RofPjBXWXyUKsZKYK1oOUm8h8FAdh5pTuTh
        jhAyUuqrYGpyzDOONX2+gSu95fp5fIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-ntFDwCM6PoyvARZlNgf34w-1; Thu, 06 May 2021 15:21:36 -0400
X-MC-Unique: ntFDwCM6PoyvARZlNgf34w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C32BA40C2;
        Thu,  6 May 2021 19:21:35 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 788915D6AC;
        Thu,  6 May 2021 19:21:30 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8D0CB418AE0D; Thu,  6 May 2021 16:21:25 -0300 (-03)
Date:   Thu, 6 May 2021 16:21:25 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: [patch 2/2 V2] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210506192125.GA350334@fuller.cnet>
References: <20210506185732.609010123@redhat.com>
 <20210506190419.481236922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506190419.481236922@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


For VMX, when a vcpu enters HLT emulation, pi_post_block will:

1) Add vcpu to per-cpu list of blocked vcpus.

2) Program the posted-interrupt descriptor "notification vector" 
to POSTED_INTR_WAKEUP_VECTOR

With interrupt remapping, an interrupt will set the PIR bit for the 
vector programmed for the device on the CPU, test-and-set the 
ON bit on the posted interrupt descriptor, and if the ON bit is clear
generate an interrupt for the notification vector.

This way, the target CPU wakes upon a device interrupt and wakes up
the target vcpu.

Problem is that pi_post_block only programs the notification vector
if kvm_arch_has_assigned_device() is true. Its possible for the
following to happen:

1) vcpu V HLTs on pcpu P, kvm_arch_has_assigned_device is false,
notification vector is not programmed
2) device is assigned to VM
3) device interrupts vcpu V, sets ON bit (notification vector not programmed,
so pcpu P remains in idle)
4) vcpu 0 IPIs vcpu V (in guest), but since pi descriptor ON bit is set,
kvm_vcpu_kick is skipped
5) vcpu 0 busy spins on vcpu V's response for several seconds, until
RCU watchdog NMIs all vCPUs.

To fix this, use the start_assignment kvm_x86_ops callback to program the
notification vector when assigned device count changes from 0 to 1.

Reported-by: Pei Zhang <pezhang@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---

v2: add vmx_pi_start_assignment to vmx's kvm_x86_ops

Index: kvm/arch/x86/kvm/vmx/posted_intr.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
+++ kvm/arch/x86/kvm/vmx/posted_intr.c
@@ -114,7 +114,7 @@ static void __pi_post_block(struct kvm_v
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
+	if (vcpu->pre_pcpu != -1) {
 		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 		list_del(&vcpu->blocked_vcpu_list);
 		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
@@ -135,20 +135,13 @@ static void __pi_post_block(struct kvm_v
  *   this case, return 1, otherwise, return 0.
  *
  */
-int pi_pre_block(struct kvm_vcpu *vcpu)
+static int __pi_pre_block(struct kvm_vcpu *vcpu)
 {
 	unsigned int dest;
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
-		return 0;
-
-	WARN_ON(irqs_disabled());
-	local_irq_disable();
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
+	if (vcpu->pre_pcpu == -1) {
 		vcpu->pre_pcpu = vcpu->cpu;
 		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 		list_add_tail(&vcpu->blocked_vcpu_list,
@@ -188,12 +181,33 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	if (pi_test_on(pi_desc) == 1)
 		__pi_post_block(vcpu);
 
+	return (vcpu->pre_pcpu == -1);
+}
+
+int pi_pre_block(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->in_blocked_section = true;
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
+		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
+		!kvm_vcpu_apicv_active(vcpu))
+		return 0;
+
+	WARN_ON(irqs_disabled());
+	local_irq_disable();
+	__pi_pre_block(vcpu);
 	local_irq_enable();
+
 	return (vcpu->pre_pcpu == -1);
 }
 
 void pi_post_block(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->in_blocked_section = false;
 	if (vcpu->pre_pcpu == -1)
 		return;
 
@@ -236,6 +250,52 @@ bool pi_has_pending_interrupt(struct kvm
 		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
 }
 
+static void pi_update_wakeup_vector(void *data)
+{
+	struct vcpu_vmx *vmx;
+	struct kvm_vcpu *vcpu = data;
+
+	vmx = to_vmx(vcpu);
+
+	/* race with pi_post_block ? */
+	if (vcpu->pre_pcpu != -1)
+		return;
+
+	if (!vmx->in_blocked_section)
+		return;
+
+	__pi_pre_block(vcpu);
+}
+
+void vmx_pi_start_assignment(struct kvm *kvm, int device_count)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+		return;
+
+	/* only care about first device assignment */
+	if (device_count != 1)
+		return;
+
+	/* Update wakeup vector and add vcpu to blocked_vcpu_list */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_vmx *vmx = to_vmx(vcpu);
+		int pcpu;
+
+		if (!kvm_vcpu_apicv_active(vcpu))
+			continue;
+
+		preempt_disable();
+		pcpu = vcpu->cpu;
+		if (vmx->in_blocked_section && vcpu->pre_pcpu == -1 &&
+		    pcpu != -1 && pcpu != smp_processor_id())
+			smp_call_function_single(pcpu, pi_update_wakeup_vector,
+						 vcpu, 1);
+		preempt_enable();
+	}
+}
 
 /*
  * pi_update_irte - set IRTE for Posted-Interrupts
Index: kvm/arch/x86/kvm/vmx/posted_intr.h
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/posted_intr.h
+++ kvm/arch/x86/kvm/vmx/posted_intr.h
@@ -95,5 +95,6 @@ void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
+void vmx_pi_start_assignment(struct kvm *kvm, int device_count);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
Index: kvm/arch/x86/kvm/vmx/vmx.h
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.h
+++ kvm/arch/x86/kvm/vmx/vmx.h
@@ -336,6 +336,9 @@ struct vcpu_vmx {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	} shadow_msr_intercept;
+
+	/* true if vcpu is between pre_block and post_block */
+	bool in_blocked_section;
 };
 
 enum ept_pointers_status {
Index: kvm/arch/x86/kvm/vmx/vmx.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.c
+++ kvm/arch/x86/kvm/vmx/vmx.c
@@ -7732,7 +7732,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
-	.start_assignment = NULL,
+	.start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,

