Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA04F3765CC
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhEGNLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 09:11:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236544AbhEGNLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 09:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620393021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=OzNZ8fsZP5SyHIdVZ/cRlR2nzmpijUfIpMsfTWcEav0=;
        b=U0xy1KI9k+El0CQgvgd11hgL1nAtrBMnoWxjztu4S0C/0vThF89kWH7p9djiwEtnUKiaWb
        cFThFdj1cl9e3iSiNfouL58xmQJUudRW4byen8+l/8kjc15iBgoWuf4sMoehqF1xMF2OuW
        SQy74EatT0cD8TBtaOiEpwbhy0nIzmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-scAvktjpMAqONfvlLHsVMw-1; Fri, 07 May 2021 09:10:20 -0400
X-MC-Unique: scAvktjpMAqONfvlLHsVMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 188D0107ACC7;
        Fri,  7 May 2021 13:10:19 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1611B19D61;
        Fri,  7 May 2021 13:10:13 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id ABE5540B1EB2; Fri,  7 May 2021 10:10:07 -0300 (-03)
Message-ID: <20210507130923.528132061@redhat.com>
User-Agent: quilt/0.66
Date:   Fri, 07 May 2021 10:06:13 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Pei Zhang <pezhang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor when assigning device
References: <20210507130609.269153197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
3) device interrupts vcpu V, sets ON bit
(notification vector not programmed, so pcpu P remains in idle)
4) vcpu 0 IPIs vcpu V (in guest), but since pi descriptor ON bit is set,
kvm_vcpu_kick is skipped
5) vcpu 0 busy spins on vcpu V's response for several seconds, until
RCU watchdog NMIs all vCPUs.

To fix this, use the start_assignment kvm_x86_ops callback to kick
vcpus out of the halt loop, so the notification vector is 
properly reprogrammed to the wakeup vector.

Reported-by: Pei Zhang <pezhang@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---

v2: add vmx_pi_start_assignment to vmx's kvm_x86_ops

Index: kvm/arch/x86/kvm/vmx/posted_intr.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
+++ kvm/arch/x86/kvm/vmx/posted_intr.c
@@ -203,6 +203,25 @@ void pi_post_block(struct kvm_vcpu *vcpu
 	local_irq_enable();
 }
 
+int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
+{
+	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+
+	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+		return 0;
+
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return 0;
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
+		return 0;
+
+	return 1;
+}
+
 /*
  * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
  */
@@ -236,6 +255,26 @@ bool pi_has_pending_interrupt(struct kvm
 		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
 }
 
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
+		if (!kvm_vcpu_apicv_active(vcpu))
+			continue;
+
+		kvm_vcpu_kick(vcpu);
+	}
+}
 
 /*
  * pi_update_irte - set IRTE for Posted-Interrupts
Index: kvm/arch/x86/kvm/vmx/posted_intr.h
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/posted_intr.h
+++ kvm/arch/x86/kvm/vmx/posted_intr.h
@@ -95,5 +95,7 @@ void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
+void vmx_pi_start_assignment(struct kvm *kvm, int device_count);
+int vmx_vcpu_check_block(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
Index: kvm/arch/x86/kvm/vmx/vmx.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.c
+++ kvm/arch/x86/kvm/vmx/vmx.c
@@ -7727,13 +7727,13 @@ static struct kvm_x86_ops vmx_x86_ops __
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
-	.vcpu_check_block = NULL,
+	.vcpu_check_block = vmx_vcpu_check_block,
 
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
-	.start_assignment = NULL,
+	.start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,


