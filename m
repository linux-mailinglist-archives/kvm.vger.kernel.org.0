Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD42C391DBD
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhEZRWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:22:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232386AbhEZRWG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 13:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622049634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g++RKsuvKjaEKQu5RfO6EzgIJ6tRl7iozPHy4sMKPPs=;
        b=Vwerphx5+VCywcXY2K1K+ZDZ4dySQkmP/dw54gXwgFI3v7cldt2tezijiqF7O7ITUPDKf7
        WMiG0SwvxhXQNdGsF3hRbWHdoSIx++TaQn6y6vNaVfeRF3NeOZcvv/cpoGYuZ7ERDobAtm
        J7xBPATsmvB5loW6eQNCf0Hl+5KNHz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-uIV2pHOfOLqbJdhhZTkNpg-1; Wed, 26 May 2021 13:20:28 -0400
X-MC-Unique: uIV2pHOfOLqbJdhhZTkNpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B1AFC88;
        Wed, 26 May 2021 17:20:27 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-7.gru2.redhat.com [10.97.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB8B0136F5;
        Wed, 26 May 2021 17:20:18 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 528404172ED4; Wed, 26 May 2021 14:20:14 -0300 (-03)
Date:   Wed, 26 May 2021 14:20:14 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: [patch 3/3 V2] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210526172014.GA29007@fuller.cnet>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.345140341@redhat.com>
 <YK1WHWsA7XuwTQR3@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK1WHWsA7XuwTQR3@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

For build error:
Reported-by: kernel test robot <lkp@intel.com>

---

v2: Add brief comment to vmx_pi_start_assignment (Peter Xu).
    Export kvm_make_all_cpus_request (kernel test robot).


Index: linux-2.6/arch/x86/kvm/vmx/posted_intr.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/vmx/posted_intr.c
+++ linux-2.6/arch/x86/kvm/vmx/posted_intr.c
@@ -238,6 +238,20 @@ bool pi_has_pending_interrupt(struct kvm
 
 
 /*
+ * Bail out of the block loop if the VM has an assigned
+ * device, but the blocking vCPU didn't reconfigure the
+ * PI.NV to the wakeup vector, i.e. the assigned device
+ * came along after the initial check in pi_pre_block().
+ */
+void vmx_pi_start_assignment(struct kvm *kvm)
+{
+	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+		return;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
+}
+
+/*
  * pi_update_irte - set IRTE for Posted-Interrupts
  *
  * @kvm: kvm
Index: linux-2.6/arch/x86/kvm/vmx/posted_intr.h
===================================================================
--- linux-2.6.orig/arch/x86/kvm/vmx/posted_intr.h
+++ linux-2.6/arch/x86/kvm/vmx/posted_intr.h
@@ -95,5 +95,6 @@ void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
+void vmx_pi_start_assignment(struct kvm *kvm);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
Index: linux-2.6/arch/x86/kvm/vmx/vmx.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/vmx/vmx.c
+++ linux-2.6/arch/x86/kvm/vmx/vmx.c
@@ -7732,6 +7732,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
+	.start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,
Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -307,6 +307,7 @@ bool kvm_make_all_cpus_request(struct kv
 {
 	return kvm_make_all_cpus_request_except(kvm, req, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)

