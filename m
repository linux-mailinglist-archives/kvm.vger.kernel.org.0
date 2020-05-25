Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD291E10BB
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403981AbgEYOlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:41:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403961AbgEYOlq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BxYHU4B93upixhtR586I0fhW0D+AACY6i9PRAg0XSJU=;
        b=hD+lRAnEbPlnswVgWNylooqvTMiZK+AjBryMEsLYKqtBbNiNV07m8cVDN3qmoPeUn2Gu/m
        heji8UGsgukX1Us5pE87c81A97DC9EMRxyQ7ZBID7D2EhYSbrxpDQ72aPVhrVjBTH6d6u7
        pRCl1YPp10+Ohx4zZzWx23I7Ur767t4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-RoEQmXqwOvqi3QuMBTNJzw-1; Mon, 25 May 2020 10:41:43 -0400
X-MC-Unique: RoEQmXqwOvqi3QuMBTNJzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A0D9107B467;
        Mon, 25 May 2020 14:41:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1ADE5D9C5;
        Mon, 25 May 2020 14:41:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/10] KVM: rename kvm_arch_can_inject_async_page_present() to kvm_arch_can_dequeue_async_page_present()
Date:   Mon, 25 May 2020 16:41:18 +0200
Message-Id: <20200525144125.143875-4-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An innocent reader of the following x86 KVM code:

bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
{
        if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
                return true;
...

may get very confused: if APF mechanism is not enabled, why do we report
that we 'can inject async page present'? In reality, upon injection
kvm_arch_async_page_present() will check the same condition again and,
in case APF is disabled, will just drop the item. This is fine as the
guest which deliberately disabled APF doesn't expect to get any APF
notifications.

Rename kvm_arch_can_inject_async_page_present() to
kvm_arch_can_dequeue_async_page_present() to make it clear what we are
checking: if the item can be dequeued (meaning either injected or just
dropped).

On s390 kvm_arch_can_inject_async_page_present() always returns 'true' so
the rename doesn't matter much.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/s390/include/asm/kvm_host.h | 2 +-
 arch/s390/kvm/kvm-s390.c         | 2 +-
 arch/x86/include/asm/kvm_host.h  | 2 +-
 arch/x86/kvm/x86.c               | 2 +-
 virt/kvm/async_pf.c              | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d6bcd34f3ec3..5ba9968c3436 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -971,7 +971,7 @@ struct kvm_arch_async_pf {
 	unsigned long pfault_token;
 };
 
-bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d05bb040fd42..64128a336c24 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3944,7 +3944,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 	/* s390 will always inject the page directly */
 }
 
-bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * s390 will always inject the page directly,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c195f63c1086..459dc824b10b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1641,7 +1641,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
-bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3102406102c..bfa7e07fd6fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10458,7 +10458,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 }
 
-bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 {
 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
 		return true;
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..8a8770c7c889 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -135,7 +135,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 	struct kvm_async_pf *work;
 
 	while (!list_empty_careful(&vcpu->async_pf.done) &&
-	      kvm_arch_can_inject_async_page_present(vcpu)) {
+	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
 		spin_lock(&vcpu->async_pf.lock);
 		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
 					      link);
-- 
2.25.4

