Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD73C7208
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbhGMOXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236868AbhGMOXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1tuHTxIVKxE87B7vlVdhGU2dgY1VbAitD6pYuBbWBY=;
        b=VN7gmHXvfoLOvOn9Jugm4SfSr44fwrFsz/Dcc4FXP3k414mYpR1Tx2ik8FomHw346MVuXX
        2jnmSpYfjwHCAoIatKOtEO1QbcbhyIJUn6JOhUyiebhxVrMxuTswAhT1tWcmTvxCdZwXl/
        zdRDepAX0o16XtMUv+ANEsDBBJ8xoHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-eZ8sNhvTN3CQX3OZ0i-qPg-1; Tue, 13 Jul 2021 10:20:54 -0400
X-MC-Unique: eZ8sNhvTN3CQX3OZ0i-qPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2675A19200CC;
        Tue, 13 Jul 2021 14:20:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A6175D6AB;
        Tue, 13 Jul 2021 14:20:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 5/8] KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
Date:   Tue, 13 Jul 2021 17:20:20 +0300
Message-Id: <20210713142023.106183-6-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently on SVM, the kvm_request_apicv_update calls the
'pre_update_apicv_exec_ctrl' without doing any synchronization
and that function toggles the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

If there is a mismatch between that memslot state and the AVIC state,
on one of vCPUs, an APIC mmio write can be lost:

For example:

VCPU0: enable the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
VCPU1: write to an APIC mmio register.

Since AVIC is still disabled on VCPU1, the access will not be  intercepted
by it, and neither will it cause MMIO fault, but rather it will just update
the dummy page mapped into the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

Fix that by adding a lock guarding the AVIC state changes, and carefully
order the operations of kvm_request_apicv_update to avoid this race:

1. Take the lock
2. Send KVM_REQ_APICV_UPDATE
3. Update the apic inhibit reason
4. Release the lock

This ensures that at (2) all vCPUs are kicked out of the guest mode,
but don't yet see the new avic state.
Then only after (4) all other vCPUs can update their AVIC state and resume.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c       | 39 ++++++++++++++++++++++++---------------
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  1 +
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29b92f6cbad4..a91e35b92447 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9180,6 +9180,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
+	mutex_lock(&vcpu->kvm->apicv_update_lock);
+
 	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
@@ -9192,6 +9194,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	mutex_unlock(&vcpu->kvm->apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
@@ -9204,32 +9208,34 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	unsigned long old, new, expected;
+	unsigned long old, new;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
 	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
 		return;
 
-	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
-	do {
-		expected = new = old;
-		if (activate)
-			__clear_bit(bit, &new);
-		else
-			__set_bit(bit, &new);
-		if (new == old)
-			break;
-		old = cmpxchg(&kvm->arch.apicv_inhibit_reasons, expected, new);
-	} while (old != expected);
+	mutex_lock(&kvm->apicv_update_lock);
+
+	old = new = kvm->arch.apicv_inhibit_reasons;
+	if (activate)
+		__clear_bit(bit, &new);
+	else
+		__set_bit(bit, &new);
+
+	kvm->arch.apicv_inhibit_reasons = new;
 
 	if (!!old == !!new)
-		return;
+		goto out;
 
 	trace_kvm_apicv_update_request(activate, bit);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
 		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
 
-	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+out:
+	mutex_unlock(&kvm->apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
@@ -9436,8 +9442,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 			kvm_hv_process_stimers(vcpu);
-		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 			kvm_vcpu_update_apicv(vcpu);
+			vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		}
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 37cbb56ccd09..0364d35d43dc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -524,6 +524,7 @@ struct kvm {
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 	struct mutex slots_lock;
+	struct mutex apicv_update_lock;
 
 	/*
 	 * Protects the arch-specific fields of struct kvm_memory_slots in
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ed4d1581d502..ba5d5d9ebc64 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -943,6 +943,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	mutex_init(&kvm->slots_arch_lock);
+	mutex_init(&kvm->apicv_update_lock);
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
-- 
2.26.3

