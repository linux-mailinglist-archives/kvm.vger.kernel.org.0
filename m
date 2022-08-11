Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D005907BB
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiHKVGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiHKVGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1539F785BF
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZBHej5wRe7xU3WBHwemoCQQEDQCEX2ZZ7C6QJ36Rgc=;
        b=fUPNjtCLnY9zqJ5RXLwp/q1NJ30/C+0o/VAmpCZjMMyJ0tqP6T44ccLNUI9vip8fiw2ihH
        pBMX0YU6uNBzmUllbujo6Wwr/B2A4hI+maaiFJgOMmLQerc6SZsHUDUFwf9jWfdMl91nfE
        bwmlbxGvet5kqtl3cCBODkRyJDtvp0U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-hvhBoeflO764B_GN1I-8wA-1; Thu, 11 Aug 2022 17:06:07 -0400
X-MC-Unique: hvhBoeflO764B_GN1I-8wA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7129585A599;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AA5A492C3B;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com
Subject: [PATCH v2 6/9] KVM: x86: make vendor code check for all nested events
Date:   Thu, 11 Aug 2022 17:06:02 -0400
Message-Id: <20220811210605.402337-7-pbonzini@redhat.com>
In-Reply-To: <20220811210605.402337-1-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupts, NMIs etc. sent while in guest mode are already handled
properly by the *_interrupt_allowed callbacks, but other events can
cause a vCPU to be runnable that are specific to guest mode.

In the case of VMX there are two, the preemption timer and the
monitor trap.  The VMX preemption timer is already special cased via
the hv_timer_pending callback, but the purpose of the callback can be
easily extended to MTF or in fact any other event that can occur only
in guest mode.

Rename the callback and add an MTF check; kvm_arch_vcpu_runnable()
now will return true if an MTF is pending, without relying on
kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
is removed, however, the patch introduces no functional change.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 9 ++++++++-
 arch/x86/kvm/x86.c              | 8 ++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ffa578cafe1..293ff678fff5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1636,7 +1636,7 @@ struct kvm_x86_nested_ops {
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
 					     struct x86_exception *fault);
-	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..9631cdcdd058 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3876,6 +3876,13 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6816,7 +6823,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
 	.handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
-	.hv_timer_pending = nested_vmx_preemption_timer_pending,
+	.has_events = vmx_has_nested_events,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f084613fac8..0f9f24793b8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9789,8 +9789,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	}
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		*req_immediate_exit = true;
 
 	WARN_ON(vcpu->arch.exception.pending);
@@ -12562,8 +12562,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))
-- 
2.31.1


