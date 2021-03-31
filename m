Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593DE34EE9F
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhC3RAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:00:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232032AbhC3RAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617123604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B0vVMg9k0YjpgfgyL9kNDxIlNvROcSIN75h8ppPeHB4=;
        b=iYf2CfoExEUdGVpgYq5g5Oa7wi9paFyWs9OtjDZe0AbIvFFatFvT0FZdl10MIbucNuVEq9
        s+fjo/yYzc+4umN7KxSTY12fwHfLR/Ri5nK/9xrgjrp2RWOcIsA7EKKPFIl9ujcG2vt9su
        cKVqenhVtPLZA/FWOLr0A5Ca5nS8f8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-THHn_JaANhmvpe1Nb5-TXg-1; Tue, 30 Mar 2021 13:00:02 -0400
X-MC-Unique: THHn_JaANhmvpe1Nb5-TXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9E67190A7A3;
        Tue, 30 Mar 2021 17:00:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FEC963B8C;
        Tue, 30 Mar 2021 17:00:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com, dwmw@amazon.co.uk,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
Subject: [PATCH 2/2] KVM: x86: disable interrupts while pvclock_gtod_sync_lock is taken
Date:   Tue, 30 Mar 2021 12:59:58 -0400
Message-Id: <20210330165958.3094759-3-pbonzini@redhat.com>
In-Reply-To: <20210330165958.3094759-1-pbonzini@redhat.com>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pvclock_gtod_sync_lock can be taken with interrupts disabled if the
preempt notifier calls get_kvmclock_ns to update the Xen
runstate information:

   spin_lock include/linux/spinlock.h:354 [inline]
   get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
   kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
   kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
   kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
   kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062

So change the users of the spinlock to spin_lock_irqsave and
spin_unlock_irqrestore.

Reported-by: syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a83eff40b43..2bfd00da465f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2329,7 +2329,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
+	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
 		kvm->arch.nr_vcpus_matched_tsc = 0;
 	} else if (!already_matched) {
@@ -2337,7 +2337,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	kvm_track_tsc_matching(vcpu);
-	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
+	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
@@ -2559,15 +2559,16 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 	int i;
 	struct kvm_vcpu *vcpu;
 	struct kvm_arch *ka = &kvm->arch;
+	unsigned long flags;
 
 	kvm_hv_invalidate_tsc_page(kvm);
 
 	kvm_make_mclock_inprogress_request(kvm);
 
 	/* no guest entries from this point */
-	spin_lock(&ka->pvclock_gtod_sync_lock);
+	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock(&ka->pvclock_gtod_sync_lock);
+	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -2582,17 +2583,18 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
+	unsigned long flags;
 	u64 ret;
 
-	spin_lock(&ka->pvclock_gtod_sync_lock);
+	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
-		spin_unlock(&ka->pvclock_gtod_sync_lock);
+		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
 	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock(&ka->pvclock_gtod_sync_lock);
+	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
 	get_cpu();
@@ -2686,13 +2688,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
 	 */
-	spin_lock(&ka->pvclock_gtod_sync_lock);
+	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	use_master_clock = ka->use_master_clock;
 	if (use_master_clock) {
 		host_tsc = ka->master_cycle_now;
 		kernel_ns = ka->master_kernel_ns;
 	}
-	spin_unlock(&ka->pvclock_gtod_sync_lock);
+	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -7724,6 +7726,7 @@ static void kvm_hyperv_tsc_notifier(void)
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int cpu;
+	unsigned long flags;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
@@ -7739,9 +7742,9 @@ static void kvm_hyperv_tsc_notifier(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka = &kvm->arch;
 
-		spin_lock(&ka->pvclock_gtod_sync_lock);
+		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock(&ka->pvclock_gtod_sync_lock);
+		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-- 
2.26.2

