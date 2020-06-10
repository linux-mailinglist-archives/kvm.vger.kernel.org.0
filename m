Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F0C1F5AD0
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgFJRzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 13:55:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29646 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726081AbgFJRzp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 13:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591811743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtbWANQso5ashZaAefg4iTD+YvjBiY3Rvcd86C6GIYQ=;
        b=gvdgdB9jDOdmb3x5LtRbFX/WCTVwH34VmkPaKdx+tOvnYarZ148fSWduiyRV18FzIU+g0o
        sKjZUlULhoNP3vBkdFaTg0CzDGOurCODbRRksSa8tBNudjCNNWs8cYyhxkV+JYn/dpYEN+
        nJWt9+7UEg7fMpSF5tvuV0svSlMyfP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-0J7IyOx8NoapTomZce-53g-1; Wed, 10 Jun 2020 13:55:41 -0400
X-MC-Unique: 0J7IyOx8NoapTomZce-53g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B513107ACCD;
        Wed, 10 Jun 2020 17:55:40 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E88FF78905;
        Wed, 10 Jun 2020 17:55:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if 'page not present' was previously injected
Date:   Wed, 10 Jun 2020 19:55:32 +0200
Message-Id: <20200610175532.779793-2-vkuznets@redhat.com>
In-Reply-To: <20200610175532.779793-1-vkuznets@redhat.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'Page not present' event may or may not get injected depending on
guest's state. If the event wasn't injected, there is no need to
inject the corresponding 'page ready' event as the guest may get
confused. E.g. Linux thinks that the corresponding 'page not present'
event wasn't delivered *yet* and allocates a 'dummy entry' for it.
This entry is never freed.

Note, 'wakeup all' events have no corresponding 'page not present'
event and always get injected.

s390 seems to always be able to inject 'page not present', the
change is effectively a nop.

Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/s390/include/asm/kvm_host.h | 2 +-
 arch/s390/kvm/kvm-s390.c         | 4 +++-
 arch/x86/include/asm/kvm_host.h  | 2 +-
 arch/x86/kvm/x86.c               | 7 +++++--
 include/linux/kvm_host.h         | 1 +
 virt/kvm/async_pf.c              | 2 +-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3d554887794e..cee3cb6455a2 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -978,7 +978,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
 
-void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
 
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 06bde4bad205..33fea4488ef3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3923,11 +3923,13 @@ static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 	}
 }
 
-void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
 	trace_kvm_s390_pfault_init(vcpu, work->arch.pfault_token);
 	__kvm_inject_pfault_token(vcpu, true, work->arch.pfault_token);
+
+	return true;
 }
 
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e03c021956a..f54e7499fc6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1660,7 +1660,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
 
-void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13d0b0fa1a7c..75e4c68e9586 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10513,7 +10513,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	return kvm_arch_interrupt_allowed(vcpu);
 }
 
-void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
@@ -10530,6 +10530,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		fault.address = work->arch.token;
 		fault.async_page_fault = true;
 		kvm_inject_page_fault(vcpu, &fault);
+		return true;
 	} else {
 		/*
 		 * It is not possible to deliver a paravirtualized asynchronous
@@ -10540,6 +10541,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		 * fault is retried, hopefully the page will be ready in the host.
 		 */
 		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+		return false;
 	}
 }
 
@@ -10557,7 +10559,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
-	if (kvm_pv_async_pf_enabled(vcpu) &&
+	if ((work->wakeup_all || work->notpresent_injected) &&
+	    kvm_pv_async_pf_enabled(vcpu) &&
 	    !apf_put_user_ready(vcpu, work->arch.token)) {
 		vcpu->arch.apf.pageready_pending = true;
 		kvm_apic_set_irq(vcpu, &irq, NULL);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 802b9e2306f0..2456dc5338f8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -206,6 +206,7 @@ struct kvm_async_pf {
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	bool   wakeup_all;
+	bool notpresent_injected;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ba080088da76..a36828fbf40a 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -189,7 +189,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	list_add_tail(&work->queue, &vcpu->async_pf.queue);
 	vcpu->async_pf.queued++;
-	kvm_arch_async_page_not_present(vcpu, work);
+	work->notpresent_injected = kvm_arch_async_page_not_present(vcpu, work);
 
 	schedule_work(&work->work);
 
-- 
2.25.4

