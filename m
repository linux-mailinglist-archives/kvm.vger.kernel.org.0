Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92ED3E8E84
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbhHKKY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237150AbhHKKYZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628677441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wjib2CaoBoKQ960V8nb3t6a1/GwcD38v7ydXMlMNTLw=;
        b=gaKUGVkcRCO/BXK4rUgbzzcvPsWsAGQYNjHRjGfdPFnpDRai1WP0GOOzkta/+9EftNcFBx
        0o1YD5goyFrxgiE1V9IKTh71PKZgFjGX8JJzeC/nVSHu1jfhIQ/NxNY28M2TK7aws9qWP8
        milCzZMHKdDfUUenG+DcpqG15Wp5R1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-A1WSQEExOHuemxTFuC2LLA-1; Wed, 11 Aug 2021 06:24:00 -0400
X-MC-Unique: A1WSQEExOHuemxTFuC2LLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7478A101C8A0;
        Wed, 11 Aug 2021 10:23:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE7625D9C6;
        Wed, 11 Aug 2021 10:23:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mtosatti@redhat.com
Subject: [PATCH 2/2] kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
Date:   Wed, 11 Aug 2021 06:23:56 -0400
Message-Id: <20210811102356.3406687-3-pbonzini@redhat.com>
In-Reply-To: <20210811102356.3406687-1-pbonzini@redhat.com>
References: <20210811102356.3406687-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updates to the kvmclock parameters needs to do a complicated dance of
KVM_REQ_MCLOCK_INPROGRESS and KVM_REQ_CLOCK_UPDATE in addition to taking
pvclock_gtod_sync_lock.  Place that in two functions that can be called
on all of master clock update, KVM_SET_CLOCK, and Hyper-V reenlightenment.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 66 +++++++++++++--------------------
 2 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bc6157677753..c54f9da91f99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1839,7 +1839,6 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 284afaa1db86..8f96cdfcf364 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2757,35 +2757,36 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 #endif
 }
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm)
+static void kvm_start_pvclock_update(struct kvm *kvm)
 {
+	struct kvm_arch *ka = &kvm->arch;
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
+
+	/* no guest entries from this point */
+	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 }
 
-static void kvm_gen_update_masterclock(struct kvm *kvm)
+static void kvm_end_pvclock_update(struct kvm *kvm)
 {
-#ifdef CONFIG_X86_64
-	int i;
-	struct kvm_vcpu *vcpu;
 	struct kvm_arch *ka = &kvm->arch;
-	unsigned long flags;
-
-	kvm_hv_invalidate_tsc_page(kvm);
-
-	kvm_make_mclock_inprogress_request(kvm);
-
-	/* no guest entries from this point */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	struct kvm_vcpu *vcpu;
+	int i;
 
+	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
-#endif
+}
+
+static void kvm_update_masterclock(struct kvm *kvm)
+{
+	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+	kvm_end_pvclock_update(kvm);
 }
 
 u64 get_kvmclock_ns(struct kvm *kvm)
@@ -6077,12 +6078,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		/*
-		 * TODO: userspace has to take care of races with VCPU_RUN, so
-		 * kvm_gen_update_masterclock() can be cut down to locked
-		 * pvclock_update_vm_gtod_copy().
-		 */
-		kvm_gen_update_masterclock(kvm);
+
+		kvm_hv_invalidate_tsc_page(kvm);
+		kvm_start_pvclock_update(kvm);
+		pvclock_update_vm_gtod_copy(kvm);
 
 		/*
 		 * This pairs with kvm_guest_time_update(): when masterclock is
@@ -6091,15 +6090,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		 * is slightly ahead) here we risk going negative on unsigned
 		 * 'system_time' when 'user_ns.clock' is very small.
 		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		if (kvm->arch.use_master_clock)
 			now_ns = ka->master_kernel_ns;
 		else
 			now_ns = get_kvmclock_base_ns();
 		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-
-		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+		kvm_end_pvclock_update(kvm);
 		break;
 	}
 	case KVM_GET_CLOCK: {
@@ -8105,9 +8101,7 @@ static void tsc_khz_changed(void *data)
 static void kvm_hyperv_tsc_notifier(void)
 {
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
 	int cpu;
-	unsigned long flags;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
@@ -8121,19 +8115,11 @@ static void kvm_hyperv_tsc_notifier(void)
 	kvm_max_guest_tsc_khz = tsc_khz;
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		struct kvm_arch *ka = &kvm->arch;
-
-		kvm_make_mclock_inprogress_request(kvm);
-		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+		kvm_start_pvclock_update(kvm);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+		kvm_end_pvclock_update(kvm);
 	}
+
 	mutex_unlock(&kvm_lock);
 }
 #endif
@@ -9413,7 +9399,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
-			kvm_gen_update_masterclock(vcpu->kvm);
+			kvm_update_masterclock(vcpu->kvm);
 		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
 			kvm_gen_kvmclock_update(vcpu);
 		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
-- 
2.27.0

