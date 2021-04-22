Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30790367DBA
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 11:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhDVJab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 05:30:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235613AbhDVJa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 05:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619083794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3kZqpcpDryGiJYWT4WCPcehjl0P1U1v7NJiamcT4384=;
        b=AW3Yt1zXUqfNlqz4Ixh6sTw7uY1IxilsfopA7n62oL55nTs0jOphQENPgjLIYFfRXZacKV
        GrkrRoP2/AU5oIt1szd6M+VhUqgtmDaEdlc9xI87e474sLMs/KsV1qVIXN0WtbiA2xmc39
        xOOOJY9/0UHIRLGcA6GfYLji/EZcf/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-nmeL2AHLNr2oNKkFuYW9ew-1; Thu, 22 Apr 2021 05:29:53 -0400
X-MC-Unique: nmeL2AHLNr2oNKkFuYW9ew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6DD5839A42;
        Thu, 22 Apr 2021 09:29:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 825CC10023AE;
        Thu, 22 Apr 2021 09:29:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Properly handle APF vs disabled LAPIC situation
Date:   Thu, 22 Apr 2021 11:29:48 +0200
Message-Id: <20210422092948.568327-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Async PF 'page ready' event may happen when LAPIC is (temporary) disabled.
In particular, Sebastien reports that when Linux kernel is directly booted
by Cloud Hypervisor, LAPIC is 'software disabled' when APF mechanism is
initialized. On initialization KVM tries to inject 'wakeup all' event and
puts the corresponding token to the slot. It is, however, failing to inject
an interrupt (kvm_apic_set_irq() -> __apic_accept_irq() -> !apic_enabled())
so the guest never gets notified and the whole APF mechanism gets stuck.
The same issue is likely to happen if the guest temporary disables LAPIC
and a previously unavailable page becomes available.

Do two things to resolve the issue:
- Avoid dequeuing 'page ready' events from APF queue when LAPIC is
  disabled.
- Trigger an attempt to deliver pending 'page ready' events when LAPIC
  becomes enabled (SPIV or MSR_IA32_APICBASE).

Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/lapic.c | 6 ++++++
 arch/x86/kvm/x86.c   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cc369b9ad8f1..49a839d0567a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -296,6 +296,10 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 
 		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
+
+	/* Check if there are APF page ready requests pending */
+	if (enabled)
+		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
@@ -2261,6 +2265,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		if (value & MSR_IA32_APICBASE_ENABLE) {
 			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 			static_branch_slow_dec_deferred(&apic_hw_disabled);
+			/* Check if there are APF page ready requests pending */
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		} else {
 			static_branch_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a06a6f48386d..001c6a445eaf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11296,7 +11296,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return true;
 	else
-		return apf_pageready_slot_free(vcpu);
+		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
 }
 
 void kvm_arch_start_assignment(struct kvm *kvm)
-- 
2.30.2

