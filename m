Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0703DDF47
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbhHBSeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232432AbhHBSeO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7GW1qtahTaA1EvczHkvVWrCMtxFgzOx9dGOvsSE6pg=;
        b=SC3aKzIsqXCPxH9vdN+AznCIXHKFxAE9roMppArSVWh8c2GcQJuJS4opJ1PLoWXUGwgvS7
        MQ1sCk9QW3mlYuGzRD/l53Hlo88ZjdrGsE5h8jJ0YjDto4bfKJwJnrUUql0HyaDta41i0q
        4FFbWnHfdFIbUSrgxmEDYkY2vGgmp7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-ytIpfQMqOLKjX-ctKD7QBw-1; Mon, 02 Aug 2021 14:34:03 -0400
X-MC-Unique: ytIpfQMqOLKjX-ctKD7QBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2159B871803;
        Mon,  2 Aug 2021 18:34:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A6A27CAB;
        Mon,  2 Aug 2021 18:33:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 07/12] KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
Date:   Mon,  2 Aug 2021 21:33:24 +0300
Message-Id: <20210802183329.2309921-8-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently on SVM, the kvm_request_apicv_update toggles the APICv
memslot without doing any synchronization.

If there is a mismatch between that memslot state and the AVIC state,
on one of the vCPUs, an APIC mmio access can be lost:

For example:

VCPU0: enable the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
VCPU1: access an APIC mmio register.

Since AVIC is still disabled on VCPU1, the access will not be intercepted
by it, and neither will it cause MMIO fault, but rather it will just be
read/written from/to the dummy page mapped into the
APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

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
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 36 +++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 430447ce19c0..80323b5fb20a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1054,6 +1054,9 @@ struct kvm_arch {
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
 
+	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
+	struct mutex apicv_update_lock;
+
 	bool apic_access_memslot_enabled;
 	unsigned long apicv_inhibit_reasons;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1de7d97341dd..9d2e4594c4eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8579,6 +8579,8 @@ EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
 static void kvm_apicv_init(struct kvm *kvm)
 {
+	mutex_init(&kvm->arch.apicv_update_lock);
+
 	if (enable_apicv)
 		clear_bit(APICV_INHIBIT_REASON_DISABLE,
 			  &kvm->arch.apicv_inhibit_reasons);
@@ -9240,6 +9242,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
+	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
+
 	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
@@ -9252,41 +9256,43 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
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
+	mutex_lock(&kvm->arch.apicv_update_lock);
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
 
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+
 	if (!activate)
 		kvm_zap_gfn_range(kvm, gpa_to_gfn(APIC_DEFAULT_PHYS_BASE),
 				  gpa_to_gfn(APIC_DEFAULT_PHYS_BASE + PAGE_SIZE));
 
 	kvm->arch.apic_access_memslot_enabled = activate;
-
-	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+out:
+	mutex_unlock(&kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.26.3

