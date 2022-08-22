Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC87059C4A6
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiHVRHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbiHVRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:07:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16747422DB
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=io8LBVhoz/cZgYqGMJGAqrxdfnhLPqTQdVJ6lbmIua4=;
        b=DqhHUAK96HU5T/0KcYgmGFbApFbDCekzv4FrgLhudxkNPS25EyV2vtGSJcFiMF8K4ofPSV
        aWrdTArMB89arP8TeHiilElELrC5sYBRpWOtHtjquM5naJrrLHbRVPANdyTrPfjj/HdgnQ
        R/1ZHU1I4ZwHaubQO8/Yy3MxB71lvMk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-6a_5MfZ5N1e1Y1X9Upn7AQ-1; Mon, 22 Aug 2022 13:07:00 -0400
X-MC-Unique: 6a_5MfZ5N1e1Y1X9Upn7AQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA6951C004EB;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 983889458A;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 2/7] KVM: x86: make vendor code check for all nested events
Date:   Mon, 22 Aug 2022 13:06:54 -0400
Message-Id: <20220822170659.2527086-3-pbonzini@redhat.com>
In-Reply-To: <20220822170659.2527086-1-pbonzini@redhat.com>
References: <20220822170659.2527086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
now can return true if an MTF is pending, without relying on
kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
is removed, however, the patch introduces no functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 9 ++++++++-
 arch/x86/kvm/x86.c              | 8 ++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..f57ff10c3ae8 100644
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
index 4d719ba21553..95035c029def 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9788,8 +9788,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	}
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		*req_immediate_exit = true;
 
 	WARN_ON(vcpu->arch.exception.pending);
@@ -12605,8 +12605,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
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


