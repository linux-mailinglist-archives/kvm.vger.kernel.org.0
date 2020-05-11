Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A591CE0E1
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgEKQsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52086 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729613AbgEKQsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 12:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HhwY47nxj1UdfQsjm+9VtE1yq6uitrdcNiNFnzaGmSs=;
        b=APxScxYUnyiPa8iq3DXwIRzVQL0EBUy3akyKB530FfpvwmW3Mt3cAjz6nlvanEG4TTWAZT
        kcl2LIWxk5EsU3nFPal+hv9F3yF6Yo+E61lij1AenVO9U6ZHTjdofiBCR71XzAUPvprOhK
        nqzjtLRXE5UEWRBJfeg3dHgWdUaOpc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-i1Ob4udyNbKM9TEIVonvRw-1; Mon, 11 May 2020 12:48:07 -0400
X-MC-Unique: i1Ob4udyNbKM9TEIVonvRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAA87100CCC0;
        Mon, 11 May 2020 16:48:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA44341FF;
        Mon, 11 May 2020 16:47:57 +0000 (UTC)
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
Subject: [PATCH 1/8] Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and "Page Ready" exceptions simultaneously"
Date:   Mon, 11 May 2020 18:47:45 +0200
Message-Id: <20200511164752.2158645-2-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 9a6e7c39810e (""KVM: async_pf: Fix #DF due to inject "Page not
Present" and "Page Ready" exceptions simultaneously") added a protection
against 'page ready' notification coming before 'page not ready' is
delivered. This situation seems to be impossible since commit 2a266f23550b
("KVM MMU: check pending exception before injecting APF) which added
'vcpu->arch.exception.pending' check to kvm_can_do_async_pf.

On x86, kvm_arch_async_page_present() has only one call site:
kvm_check_async_pf_completion() loop and we only enter the loop when
kvm_arch_can_inject_async_page_present(vcpu) which when async pf msr
is enabled, translates into kvm_can_do_async_pf().

There is also one problem with the cancellation mechanism. We don't seem
to check that the 'page not ready' notification we're canceling matches
the 'page ready' notification so in theory, we may erroneously drop two
valid events.

Revert the commit.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..edd4a6415b92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10359,13 +10359,6 @@ static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
 				      sizeof(val));
 }
 
-static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
-{
-
-	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, val,
-				      sizeof(u32));
-}
-
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
@@ -10430,7 +10423,6 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
-	u32 val;
 
 	if (work->wakeup_all)
 		work->arch.token = ~0; /* broadcast wakeup */
@@ -10439,19 +10431,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_get_user(vcpu, &val)) {
-		if (val == KVM_PV_REASON_PAGE_NOT_PRESENT &&
-		    vcpu->arch.exception.pending &&
-		    vcpu->arch.exception.nr == PF_VECTOR &&
-		    !apf_put_user(vcpu, 0)) {
-			vcpu->arch.exception.injected = false;
-			vcpu->arch.exception.pending = false;
-			vcpu->arch.exception.nr = 0;
-			vcpu->arch.exception.has_error_code = false;
-			vcpu->arch.exception.error_code = 0;
-			vcpu->arch.exception.has_payload = false;
-			vcpu->arch.exception.payload = 0;
-		} else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
 			fault.vector = PF_VECTOR;
 			fault.error_code_valid = true;
 			fault.error_code = 0;
@@ -10459,7 +10439,6 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 			fault.address = work->arch.token;
 			fault.async_page_fault = true;
 			kvm_inject_page_fault(vcpu, &fault);
-		}
 	}
 	vcpu->arch.apf.halted = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-- 
2.25.4

