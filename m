Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5AB3E84C0
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhHJUyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234070AbhHJUyF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRmGslpFqQWJkcIjZOsxZu4cXo4YW/mr/81aUSTAihs=;
        b=DK6IIuB/PqLIn2lKPLtPkaxglr5idVpb7AVN1PWaojaE/h8lw6Pl5pK+x/KaVUAT8IHjAZ
        dl6aeIAdnmz2dN8JLlq3w6ZKK/M+mHYkwRDCIv/tyWGWSfjnSuE8q8Lay8qtvyj84W1hdi
        /zAf9gBN7IfCo/tvxEj9RLeMYU8I22M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-1vQ6CVqiPgm1p5esLZNG3Q-1; Tue, 10 Aug 2021 16:53:41 -0400
X-MC-Unique: 1vQ6CVqiPgm1p5esLZNG3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36EF71853026;
        Tue, 10 Aug 2021 20:53:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99E4C620DE;
        Tue, 10 Aug 2021 20:53:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 09/16] KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
Date:   Tue, 10 Aug 2021 23:52:44 +0300
Message-Id: <20210810205251.424103-10-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 arch/x86/include/asm/kvm_host.h |  6 +++++
 arch/x86/kvm/x86.c              | 39 ++++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d800ee894c92..27627e32f362 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1047,6 +1047,9 @@ struct kvm_arch {
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
 
+	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
+	struct mutex apicv_update_lock;
+
 	bool apic_access_memslot_enabled;
 	unsigned long apicv_inhibit_reasons;
 
@@ -1730,6 +1733,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 			      unsigned long bit);
 
+void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
+				unsigned long bit);
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8952001ee44..b6185921fe44 100644
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
@@ -9252,39 +9256,44 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
-void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
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
+	old = new = kvm->arch.apicv_inhibit_reasons;
+
+	if (activate)
+		__clear_bit(bit, &new);
+	else
+		__set_bit(bit, &new);
 
 	if (!!old != !!new) {
 		trace_kvm_apicv_update_request(activate, bit);
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+		kvm->arch.apicv_inhibit_reasons = new;
 		if (new) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
 		}
-	}
+	} else
+		kvm->arch.apicv_inhibit_reasons = new;
+}
+EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
 
+void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+{
+	mutex_lock(&kvm->arch.apicv_update_lock);
+	__kvm_request_apicv_update(kvm, activate, bit);
+	mutex_unlock(&kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.26.3

