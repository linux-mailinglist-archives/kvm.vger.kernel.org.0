Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D069543BC4
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbfFMPbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:31:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35827 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbfFMLDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 07:03:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so9672731wml.0;
        Thu, 13 Jun 2019 04:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=AAokdGbMPUTql2roL80hHEWTvMypuX8aD+4nP0eZhJg=;
        b=CbPmIijfPXDoXV/6fdU9wdARXOaTCWwYTRdbNMPEmpkRZ8maFC/ZdmRxxGlMTQ/3hz
         vUXJyE0vWGq3gDdSIM6WkaglYKFKaE419iDXt3fCi3zXgPf29om3qzrsNr92kK2jSsQ2
         BltsDxjefMJJ+nrbROi8RUd4lB7Iwv7DZFvFaYg5NeTpQUd+9FOhwYyEuFNf5l1mnfJ9
         Y+Z41fwXHawT+PMi33vBe4vP5SBDL9vYSVxgs49WI2WwtWgYCvyfIwad4xc2HdeKVoml
         1Rv2+r97sz7/Xw/G23U2yGnckqm/7+spNmLhqzhrudiVYTHaGfI19r6vgEb8sY9w32tb
         3m5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=AAokdGbMPUTql2roL80hHEWTvMypuX8aD+4nP0eZhJg=;
        b=SJ3KaZIBpFybJBUXyU+rN0OHJsWahGZ+R2eQji7WdGq85ahtcZfSMJE4h2HKPIDFC0
         B/KUxAjEVL6smdIpBYtsWu7q9i9+G9k7cr4X51kWmDsY0Wh7Yx9BszNL58vMpOphBPla
         m4SwaKV3MSXD6v4kwoY/nwLQSex4w1eW9P6hkwLuN4/CHcytoZIMNXeFltZJezcZtfmT
         WUaiG9O9EJteNL2P8Ba04ejZhjHDDCr1duRoC+k6r7GgfGDIOyvG1TF8VJeOomfjcBn4
         NnZKdPUJl3XotIEUu20PL39cJtEq/VdAZnTAazb0m+IZSRBOnb6elwq9PuuHXCA77ji2
         OoIg==
X-Gm-Message-State: APjAAAVNHvYrbk8MoNNp1KvBWwLyDtbhAaQUpz+Wt1+wx+qTUThqxLKN
        8oJs8HOH/Es4DjRCcwL8MvAh18vo
X-Google-Smtp-Source: APXvYqxKn6FTCHsgUKeM+24rUe23nKUqGI6M4rYLebz+9Ii33fcE0iibfJ+k2hx4q/8/b5f3Bul8zw==
X-Received: by 2002:a05:600c:228f:: with SMTP id 15mr3447006wmf.31.1560423813983;
        Thu, 13 Jun 2019 04:03:33 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f21sm2596606wmb.2.2019.06.13.04.03.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 04:03:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH] KVM: x86: clean up conditions for asynchronous page fault handling
Date:   Thu, 13 Jun 2019 13:03:32 +0200
Message-Id: <1560423812-51166-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when asynchronous page fault is disabled, KVM does not want to pause
the host if a guest triggers a page fault; instead it will put it into
an artificial HLT state that allows running other host processes while
allowing interrupt delivery into the guest.

However, the way this feature is triggered is a bit confusing.
First, it is not used for page faults while a nested guest is
running: but this is not an issue since the artificial halt
is completely invisible to the guest, either L1 or L2.  Second,
it is used even if kvm_halt_in_guest() returns true; in this case,
the guest probably should not pay the additional latency cost of the
artificial halt, and thus we should handle the page fault in a
completely synchronous way.

By introducing a new function kvm_can_deliver_async_pf, this patch
commonizes the code that chooses whether to deliver an async page fault
(kvm_arch_async_page_not_present) and the code that chooses whether a
page fault should be handled synchronously (kvm_can_do_async_pf).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 13 ------------
 arch/x86/kvm/x86.c | 59 ++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3384c539d150..771349e72d2a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4040,19 +4040,6 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	return kvm_setup_async_pf(vcpu, gva, kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(!lapic_in_kernel(vcpu) ||
-		     kvm_event_needs_reinjection(vcpu) ||
-		     vcpu->arch.exception.pending))
-		return false;
-
-	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
-		return false;
-
-	return kvm_x86_ops->interrupt_allowed(vcpu);
-}
-
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6200d5a51f13..2fe53b931b72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9775,6 +9775,36 @@ static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
 				      sizeof(u32));
 }
 
+static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
+		return false;
+
+	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
+	    (vcpu->arch.apf.send_user_only &&
+	     kvm_x86_ops->get_cpl(vcpu) == 0))
+		return false;
+
+	return true;
+}
+
+bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(!lapic_in_kernel(vcpu) ||
+		     kvm_event_needs_reinjection(vcpu) ||
+		     vcpu->arch.exception.pending))
+		return false;
+
+	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
+		return false;
+
+	/*
+	 * If interrupts are off we cannot even use an artificial
+	 * halt state.
+	 */
+	return kvm_x86_ops->interrupt_allowed(vcpu);
+}
+
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
@@ -9783,19 +9813,26 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_not_present(work->arch.token, work->gva);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
-	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-	    (vcpu->arch.apf.send_user_only &&
-	     kvm_x86_ops->get_cpl(vcpu) == 0))
+	if (!kvm_can_deliver_async_pf(vcpu) ||
+	    apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+		/*
+		 * It is not possible to deliver a paravirtualized asynchronous
+		 * page fault, but putting the guest in an artificial halt state
+		 * can be beneficial nevertheless: if an interrupt arrives, we
+		 * can deliver it timely and perhaps the guest will schedule
+		 * another process.  When the instruction that triggered a page
+		 * fault is retried, hopefully the page will be ready in the host.
+		 */
 		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-	else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
-		fault.vector = PF_VECTOR;
-		fault.error_code_valid = true;
-		fault.error_code = 0;
-		fault.nested_page_fault = false;
-		fault.address = work->arch.token;
-		fault.async_page_fault = true;
-		kvm_inject_page_fault(vcpu, &fault);
 	}
+
+	fault.vector = PF_VECTOR;
+	fault.error_code_valid = true;
+	fault.error_code = 0;
+	fault.nested_page_fault = false;
+	fault.address = work->arch.token;
+	fault.async_page_fault = true;
+	kvm_inject_page_fault(vcpu, &fault);
 }
 
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
-- 
1.8.3.1

