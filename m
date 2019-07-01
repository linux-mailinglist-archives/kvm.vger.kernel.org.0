Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1451E4498D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfFMRWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:22:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42949 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFMRWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:22:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so6344143wrl.9;
        Thu, 13 Jun 2019 10:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=AQp+KFfeJT0OSBL+CCZ/KccGQKuMHF8GjaLwYUkA7w4=;
        b=sHiDmHhhDVNB6jBg1CpsijuLuoyb8ZnTgwF8s7AtooTKwHkbT4jRrvhHZd1otUQTNg
         d0dK9U0nqWviFJwM6rez1MJ9K7folNyvD761obQX7r4+Gb94XE6FGIefM9ccYfdXBBcn
         MTONy7tYsyn4cfO0O4lVhmIR94/1kBMD+Ju2JEDa79AaxgwOMus/crbX93a0/urTvtfW
         IJp+10VTdzon6r4Hg1FHtme9NFkBLH+wIgXfSJYLs0LHFzrzNw69UFrdV5GRQ/9q3tq9
         rB3gX4xe5V7FQfSD7wtSVa32qXs48cp+ytRujz6dybTeRrg9IbZL24Ud75Tv6GrXSVVf
         ohgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=AQp+KFfeJT0OSBL+CCZ/KccGQKuMHF8GjaLwYUkA7w4=;
        b=Mj/Ln8okeguL8OqLLsR2dN+2J+aUOON9TT6Sk5RHmNHTl+BHGDlEghly24L35YN6HK
         SvLMJ3E6G1d4xgRhHeFyiGVGodZwavUFEUTbo1Zo3f+dmj3YwNozSmrIm6RVDqT3drWD
         TuialyA8gNoSjVf2ZBWE57pos4YrgXCKQAr/p74TZTwTxuZlWAiooNBp2707nnyiESS0
         9+uUkqNZ/LLpAp1g1sdZ5BnCHe/eBkinloiuPE5b8Vw9Zx8igwhNehB6WCObJ9EouU0C
         zUHbRAG529Ytqk3wMp6in1rUq4Y1cuSgAojxp9ZViUv2C/OofgHc9emGoJAMRadAISk+
         C5Eg==
X-Gm-Message-State: APjAAAWD+f/BI26erw2TeqKdDMUsvKB9v8/L9zNwRXXzhPFVDKmiU7wc
        ffcJW6vC2HLs5zjllVNK74hQxjB4
X-Google-Smtp-Source: APXvYqwvlFPZ4u49f9kRdTgPQkkxRQPyaafuWh/FPUVFisw1squkleajFf5dr1Q0eo9nwbd2sJQ7cQ==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr17445969wrs.2.1560446534240;
        Thu, 13 Jun 2019 10:22:14 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s10sm753538wmf.8.2019.06.13.10.22.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:22:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
Subject: [PATCH v2] KVM: x86: clean up conditions for asynchronous page fault handling
Date:   Thu, 13 Jun 2019 19:22:12 +0200
Message-Id: <1560446532-22494-1-git-send-email-pbonzini@redhat.com>
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
 arch/x86/kvm/mmu.c | 13 -------------
 arch/x86/kvm/x86.c | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 42 insertions(+), 18 deletions(-)

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
index 6200d5a51f13..279ab4e8dd82 100644
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
@@ -9783,11 +9813,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_not_present(work->arch.token, work->gva);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
-	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-	    (vcpu->arch.apf.send_user_only &&
-	     kvm_x86_ops->get_cpl(vcpu) == 0))
-		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-	else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+	if (kvm_can_deliver_async_pf(vcpu) &&
+	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
 		fault.vector = PF_VECTOR;
 		fault.error_code_valid = true;
 		fault.error_code = 0;
@@ -9795,6 +9822,16 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		fault.address = work->arch.token;
 		fault.async_page_fault = true;
 		kvm_inject_page_fault(vcpu, &fault);
+	} else {
+		/*
+		 * It is not possible to deliver a paravirtualized asynchronous
+		 * page fault, but putting the guest in an artificial halt state
+		 * can be beneficial nevertheless: if an interrupt arrives, we
+		 * can deliver it timely and perhaps the guest will schedule
+		 * another process.  When the instruction that triggered a page
+		 * fault is retried, hopefully the page will be ready in the host.
+		 */
+		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 	}
 }
 
-- 
1.8.3.1

