Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BB45A5119
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 18:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiH2QJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 12:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiH2QJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 12:09:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96C197B00
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 09:09:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 69so6454805pgb.13
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 09:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7gmneVV/PeR2auLfOweRCYlrNZl198jGSiU2pn9CJ/M=;
        b=e2MM/uD9EleY2NgflZQ15phWiKR7iGBYOF4f2ryqZgIkqCDciSfTqJWYvWigAJwvN9
         Wr8vdlxIh02cflN6kobiq0+z7iGZu3i1an3w00Ku3LlFAF3ZOzi/KhWaE8XuUIJ78d/b
         Y+li4g3XExPIUqGOyupwv8PcrmxTMdmRw9FQw6qEHZqq23Q3C94WHGRLvJ0ou4EwMl73
         NQVzoxl2Ap7XYSk1SE82lwh/V7TXH0tQvknELk06EZmw0UcJkTBPJSAI5kPn5Rg5fcjY
         B9NFZYnjjKhuJYn42vzCYQh182oYqq/gO/VmFh7CfnSReZBFG5XpZUecwkypud8o7GiS
         IN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7gmneVV/PeR2auLfOweRCYlrNZl198jGSiU2pn9CJ/M=;
        b=s5lqqhj6RNKL6ou9x4I4s+NdBeog4hF63GhEHtUibS86KJ2l9qtfkH0KhS/zSF4vJK
         84AO4p2bcqkr36vKiRX3vW3il4Zf3som0O0sciStROStJvzjLz6Z4b32zbJYE9KkJfqb
         ijU0i0HZRNWdLNJvLHJ2uorMRd8nbHNvxWTAvTXbyUwIbCq3wOYytSLXKvBlhYpt7kxh
         w7XlWZvrtNifUHg0wkuKqFNpqMotQVZvKofU//2+hOqsR5TJ4LI+ZLAo7OMIMTWnKjn8
         fbS7Sq3s5SJie72+7bH1d0iBOmMlrV3ANlfBjr/cT44lbdGPAKsJ6iGPkgeWeTy8GsW7
         eygA==
X-Gm-Message-State: ACgBeo3Dye+iMHBv+GeWYBafxkT0oXogCFYSEzKomaM7uktx61i/+9WY
        hocuXTNwgFd38NSmPLuwmKp+0Q==
X-Google-Smtp-Source: AA6agR7xgtbylkLkJoXSxMrkgzXqe2uz8K5MfQCJAfeLlaBbSleA0wyt7fZ5VtJ9SkPCBSQka962sw==
X-Received: by 2002:a05:6a00:3306:b0:538:444d:87d3 with SMTP id cq6-20020a056a00330600b00538444d87d3mr4964846pfb.38.1661789377182;
        Mon, 29 Aug 2022 09:09:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b0052d4cb47339sm7422143pfb.151.2022.08.29.09.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:09:36 -0700 (PDT)
Date:   Mon, 29 Aug 2022 16:09:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
Message-ID: <YwzkvfT0AiwaojTx@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828222544.1964917-2-mizhang@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 28, 2022, Mingwei Zhang wrote:
> Create a common function to handle kvm request in the vcpu_run loop. KVM
> implicitly assumes the virtual APIC page being present + mapped into the
> kernel address space when executing vmx_guest_apic_has_interrupts().
> However, with demand paging KVM breaks the assumption, as the
> KVM_REQ_GET_VMCS12_PAGES event isn't assessed before entering vcpu_block.

KVM_REQ_GET_VMCS12_PAGES doesn't exist upstream.

> Fix this by getting vmcs12 pages before inspecting the guest's APIC page.
> Because of this fix, the event handling code of
> KVM_REQ_GET_NESTED_STATE_PAGES becomes a common code path for both
> vcpu_enter_guest() and vcpu_block(). Thus, put this code snippet into a
> common helper function to avoid code duplication.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Originally-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

If you drop someone as author, then their SOB also needs to be jettisoned.

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..3dcaac8f0584 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10261,12 +10261,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			r = -EIO;
>  			goto out;
>  		}
> -		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> -			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> -				r = 0;
> -				goto out;
> -			}
> -		}
>  		if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
>  			kvm_mmu_free_obsolete_roots(vcpu);
>  		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> @@ -10666,6 +10660,23 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  		!vcpu->arch.apf.halted);
>  }
>  
> +static int kvm_vcpu_handle_common_requests(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_request_pending(vcpu)) {

Probably going to be a moot point, but write this as

	if (!kvm_request_pending(vcpu))
		return 1;

to reduce indentation.

> +		/*
> +		 * Get the vmcs12 pages before checking for interrupts that
> +		 * might unblock the guest if L1 is using virtual-interrupt
> +		 * delivery.
> +		 */
> +		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> +			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))

Similarly

	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu) &&
	    unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))
		return 0;

though I can see the argument for fully isolating each request.  But again, likely
a moot point.

> +				return 0;
> +		}
> +	}
> +
> +	return 1;
> +}
> +
>  /* Called within kvm->srcu read side.  */
>  static int vcpu_run(struct kvm_vcpu *vcpu)
>  {
> @@ -10681,6 +10692,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  		 * this point can start executing an instruction.
>  		 */
>  		vcpu->arch.at_instruction_boundary = false;
> +
> +		/* Process common request regardless of vcpu state. */
> +		r = kvm_vcpu_handle_common_requests(vcpu);

IMO this is subtly a dangerous hook.  It implies that both vcpu_enter_guest()
and vcpu_block() correctly handle requests becoming pending after the "common"
check, but that's not actually the case.  If a request _needs_ to be handled
before vcpu_block(), then ideally it should be explicitly queried in
kvm_vcpu_check_block().  KVM_REQ_GET_NESTED_STATE_PAGES doesn't have issues because
it's only ever set from the vCPU itself.

Following that train of thought, KVM_REQ_GET_NESTED_STATE_PAGES really shouldn't
even be a request.  Aha!  And we can do that in a way that would magically fix this
bug, and would ensure we don't leave a trap for future us.

KVM already provides KVM_REQ_UNBLOCK to prevent blocking the vCPU without actaully
waking the vCPU, i.e. to kick the vCPU back into the vcpu_run() loop.  The request
is provided specifically for scenarios like this where KVM needs to do work before
blocking.

Normally I'd say we should do this over multiple patches so that the "blocking"
bug is fixed before doing the rework/cleanup, but I'm ok if we want to skip straight
to the rework since we're obviously carrying an internal patch and no one else is
likely to need the fix.  But I also wouldn't object to including an intermediate
patch to fix the bug so that there's a better paper trail.

E.g. as a very partial conversion:

---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 arch/x86/kvm/x86.h              | 10 ++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9345303c8c6d..bfca37419783 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -939,6 +939,8 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;

+	bool nested_get_pages_pending;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..e83b145c3a35 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3446,7 +3446,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		 * to nested_get_vmcs12_pages before the next VM-entry.  The MSRs
 		 * have already been set at vmentry time and should not be reset.
 		 */
-		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+		kvm_nested_get_pages_set_pending(vcpu);
 	}

 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0e3e7915a3a..0a7601ebffc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9650,6 +9650,12 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops.nested_ops->check_events(vcpu);
 }

+static int kvm_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.nested_get_pages_pending = false;
+	return kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu);
+}
+
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_inj_exception(vcpu->arch.exception.nr,
@@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		if (kvm_cpu_has_pending_timer(vcpu))
 			kvm_inject_pending_timer_irqs(vcpu);

+		if (vcpu->arch.nested_get_pages_pending) {
+			r = kvm_get_nested_state_pages(vcpu);
+			if (r <= 0)
+				break;
+		}
+
 		if (dm_request_for_irq_injection(vcpu) &&
 			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
 			r = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1926d2cb8e79..e35aac39dc73 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -481,4 +481,14 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);

+static inline void kvm_nested_get_pages_set_pending(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Here is a comment explaining why KVM needs to prevent the vCPU from
+	 * blocking until the vCPU's nested pages have been loaded.
+	 */
+	vcpu->arch.nested_get_pages_pending = true;
+	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+}
+
 #endif

base-commit: 14a47a98151834c5bd2f6d8d592b01108a3f882a
--
