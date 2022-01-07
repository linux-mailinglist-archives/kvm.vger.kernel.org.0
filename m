Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456B487BB2
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348666AbiAGSB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240374AbiAGSB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641578517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DDq5ZV3raVbWd7catgZXaSPZOFPUpBTYsBeXPjj09UE=;
        b=T+4cbLMxx+TV4iSzXfTeDgSVANj9O6NB5b0F8Yr9qfsNi3MXgx7Dqep9T/WAssZbMTm+2r
        0E1Q/aOjd0Wz8AsAKDFeIgWQj5zhUzviXhszF60j9F5NCF1/lt3yatr2W7QT2hSWqaoQ00
        bugExIVrPHoKoGbqnxgfp9P1lSP95Pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-ujv1KKFlOtOiYmbrP-_iEA-1; Fri, 07 Jan 2022 12:51:36 -0500
X-MC-Unique: ujv1KKFlOtOiYmbrP-_iEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BC7C101F000;
        Fri,  7 Jan 2022 17:51:35 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A059F7A444;
        Fri,  7 Jan 2022 17:51:34 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id D331F406EAF0; Fri,  7 Jan 2022 14:51:14 -0300 (-03)
Date:   Fri, 7 Jan 2022 14:51:14 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] KVM: VMX: switch wakeup_vcpus_on_cpu_lock to raw spinlock
Message-ID: <20220107175114.GA261406@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


wakeup_vcpus_on_cpu_lock is taken from hard interrupt context 
(pi_wakeup_handler), therefore it cannot sleep.

Switch it to a raw spinlock.

Fixes:

[41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001 
[41297.066323] Preemption disabled at: 
[41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60 
[41297.066339] Call Trace: 
[41297.066342]  <IRQ> 
[41297.066346]  dump_stack_lvl+0x34/0x44 
[41297.066353]  ? irq_enter_rcu+0xf/0x60 
[41297.066356]  __schedule_bug.cold+0x7d/0x8b 
[41297.066361]  __schedule+0x439/0x5b0 
[41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440 
[41297.066369]  schedule_rtlock+0x1e/0x40 
[41297.066371]  rtlock_slowlock_locked+0xf1/0x260 
[41297.066374]  rt_spin_lock+0x3b/0x60 
[41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel] 
[41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0 
[41297.066392]  </IRQ> 
[41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20 
...

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f4169c009400..aa1fe9085d77 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -27,7 +27,7 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
  * occur if a wakeup IRQ arrives and attempts to acquire the lock.
  */
-static DEFINE_PER_CPU(spinlock_t, wakeup_vcpus_on_cpu_lock);
+static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -87,9 +87,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 		list_del(&vmx->pi_wakeup_list);
-		spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
 	dest = cpu_physical_id(cpu);
@@ -149,10 +149,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	list_add_tail(&vmx->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
-	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
 	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
@@ -204,20 +204,20 @@ void pi_wakeup_handler(void)
 	int cpu = smp_processor_id();
 	struct vcpu_vmx *vmx;
 
-	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
 			    pi_wakeup_list) {
 
 		if (pi_test_on(&vmx->pi_desc))
 			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
-	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 void __init pi_init_cpu(int cpu)
 {
 	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
-	spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)

