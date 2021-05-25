Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651C9390323
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhEYNz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 09:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233385AbhEYNzq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 09:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621950856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=NPGYHoSnoFBe2Pyrr6tNPxDx3Mmjq4+YFrgUxsImBrY=;
        b=W1yOw9Es6U6bZhHrbK/MTb4lPyNysB9j/q20X37ji7MEHMtjACpZvctjvg91FVWGftu5WT
        ZZt2pmpundAr+L69mWQ6rvAe3I1HLX8qmoyNUJ+IgNgYm3TjWrcSlfTdFlzP4x8kuBdZJR
        cReVCbMQkU7cP4I8uQGOHYp6qN4PY3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-L5hCDacVMDW_Knrk1BCamQ-1; Tue, 25 May 2021 09:54:15 -0400
X-MC-Unique: L5hCDacVMDW_Knrk1BCamQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56464501E3;
        Tue, 25 May 2021 13:54:14 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B6B761094;
        Tue, 25 May 2021 13:54:07 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id B50D54179BB2; Tue, 25 May 2021 10:44:35 -0300 (-03)
Message-ID: <20210525134321.345140341@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 25 May 2021 10:41:18 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>, Pei Zhang <pezhang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/3] KVM: VMX: update vcpu posted-interrupt descriptor when assigning device
References: <20210525134115.135966361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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


Index: kvm/arch/x86/kvm/vmx/posted_intr.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
+++ kvm/arch/x86/kvm/vmx/posted_intr.c
@@ -236,6 +236,13 @@ bool pi_has_pending_interrupt(struct kvm
 		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
 }
 
+void vmx_pi_start_assignment(struct kvm *kvm)
+{
+	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+		return;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
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
+void vmx_pi_start_assignment(struct kvm *kvm);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
Index: kvm/arch/x86/kvm/vmx/vmx.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.c
+++ kvm/arch/x86/kvm/vmx/vmx.c
@@ -7732,6 +7732,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
+	.start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,


