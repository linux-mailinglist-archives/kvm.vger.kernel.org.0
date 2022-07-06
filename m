Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15335687C3
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiGFMFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiGFMFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:05:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A73029CA7
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTLl0DVL0+ql+yz72rKhqwUBIiayJ+CT7sWW1zV6cIo=;
        b=c1gdCEkI0S87grhw0512joTwVpfajjH7eFS2FzSroEUsblHws1/wFhs2JIMXMRDSqoW/WW
        G0zem2V6vRJ8VlK6z1rkajutxNAGw6wm2Utnc285PS6VwX/1CVrvtLuEQE+cXTyjaLzvOb
        V5ees5DL79IqUa1Bjaq/+bNqnxWGW2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-UBwIqgXfOa6HGrjbxkDg0Q-1; Wed, 06 Jul 2022 08:05:10 -0400
X-MC-Unique: UBwIqgXfOa6HGrjbxkDg0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95F4185A7A4;
        Wed,  6 Jul 2022 12:05:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 686FE40CFD0A;
        Wed,  6 Jul 2022 12:05:07 +0000 (UTC)
Message-ID: <6b93133a9a868e21fe4fb854f9ed0fdf20519064.camel@redhat.com>
Subject: Re: [PATCH v2 15/21] KVM: x86: Hoist nested event checks above
 event injection logic
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:05:06 +0300
In-Reply-To: <20220614204730.3359543-16-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-16-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Perform nested event checks before re-injecting exceptions/events into
> L2.  If a pending exception causes VM-Exit to L1, re-injecting events
> into vmcs02 is premature and wasted effort.  Take care to ensure events
> that need to be re-injected are still re-injected if checking for nested
> events "fails", i.e. if KVM needs to force an immediate entry+exit to
> complete the to-be-re-injecteed event.
> 
> Keep the "can_inject" logic the same for now; it too can be pushed below
> the nested checks, but is a slightly riskier change (see past bugs about
> events not being properly purged on nested VM-Exit).
> 
> Add and/or modify comments to better document the various interactions.
> Of note is the comment regarding "blocking" previously injected NMIs and
> IRQs if an exception is pending.  The old comment isn't wrong strictly
> speaking, but it failed to capture the reason why the logic even exists.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 89 +++++++++++++++++++++++++++-------------------
>  1 file changed, 53 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e45465075005..930de833aa2b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9502,53 +9502,70 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  
>  static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  {
> +	bool can_inject = !kvm_event_needs_reinjection(vcpu);
>  	int r;
> -	bool can_inject = true;
>  
> -	/* try to reinject previous events if any */
> +	/*
> +	 * Process nested events first, as nested VM-Exit supercedes event
> +	 * re-injection.  If there's an event queued for re-injection, it will
> +	 * be saved into the appropriate vmc{b,s}12 fields on nested VM-Exit.
> +	 */
> +	if (is_guest_mode(vcpu))
> +		r = kvm_check_nested_events(vcpu);
> +	else
> +		r = 0;

Makes sense a lot!

>  
> -	if (vcpu->arch.exception.injected) {
> +	/*
> +	 * Re-inject exceptions and events *especially* if immediate entry+exit
> +	 * to/from L2 is needed, as any event that has already been injected
> +	 * into L2 needs to complete its lifecycle before injecting a new event.
> +	 *
> +	 * Don't re-inject an NMI or interrupt if there is a pending exception.
> +	 * This collision arises if an exception occurred while vectoring the
> +	 * injected event, KVM intercepted said exception, and KVM ultimately
> +	 * determined the fault belongs to the guest and queues the exception
> +	 * for injection back into the guest.
> +	 *
> +	 * "Injected" interrupts can also collide with pending exceptions if
> +	 * userspace ignores the "ready for injection" flag and blindly queues
> +	 * an interrupt.  In that case, prioritizing the exception is correct,
> +	 * as the exception "occurred" before the exit to userspace.  Trap-like
> +	 * exceptions, e.g. most #DBs, have higher priority than interrupts.
> +	 * And while fault-like exceptions, e.g. #GP and #PF, are the lowest
> +	 * priority, they're only generated (pended) during instruction
> +	 * execution, and interrupts are recognized at instruction boundaries.
> +	 * Thus a pending fault-like exception means the fault occurred on the
> +	 * *previous* instruction and must be serviced prior to recognizing any
> +	 * new events in order to fully complete the previous instruction.
> +	 */
> +	if (vcpu->arch.exception.injected)
>  		kvm_inject_exception(vcpu);
> -		can_inject = false;
> -	}
> +	else if (vcpu->arch.exception.pending)
> +		; /* see above */
> +	else if (vcpu->arch.nmi_injected)
> +		static_call(kvm_x86_inject_nmi)(vcpu);
> +	else if (vcpu->arch.interrupt.injected)
> +		static_call(kvm_x86_inject_irq)(vcpu, true);
> +
>  	/*
> -	 * Do not inject an NMI or interrupt if there is a pending
> -	 * exception.  Exceptions and interrupts are recognized at
> -	 * instruction boundaries, i.e. the start of an instruction.
> -	 * Trap-like exceptions, e.g. #DB, have higher priority than
> -	 * NMIs and interrupts, i.e. traps are recognized before an
> -	 * NMI/interrupt that's pending on the same instruction.
> -	 * Fault-like exceptions, e.g. #GP and #PF, are the lowest
> -	 * priority, but are only generated (pended) during instruction
> -	 * execution, i.e. a pending fault-like exception means the
> -	 * fault occurred on the *previous* instruction and must be
> -	 * serviced prior to recognizing any new events in order to
> -	 * fully complete the previous instruction.
> +	 * Exceptions that morph to VM-Exits are handled above, and pending
> +	 * exceptions on top of injected exceptions that do not VM-Exit should
> +	 * either morph to #DF or, sadly, override the injected exception.
>  	 */
> -	else if (!vcpu->arch.exception.pending) {
> -		if (vcpu->arch.nmi_injected) {
> -			static_call(kvm_x86_inject_nmi)(vcpu);
> -			can_inject = false;
> -		} else if (vcpu->arch.interrupt.injected) {
> -			static_call(kvm_x86_inject_irq)(vcpu, true);
> -			can_inject = false;
> -		}
> -	}
> -
>  	WARN_ON_ONCE(vcpu->arch.exception.injected &&
>  		     vcpu->arch.exception.pending);
>  
>  	/*
> -	 * Call check_nested_events() even if we reinjected a previous event
> -	 * in order for caller to determine if it should require immediate-exit
> -	 * from L2 to L1 due to pending L1 events which require exit
> -	 * from L2 to L1.
> +	 * Bail if immediate entry+exit to/from the guest is needed to complete
> +	 * nested VM-Enter or event re-injection so that a different pending
> +	 * event can be serviced (or if KVM needs to exit to userspace).
> +	 *
> +	 * Otherwise, continue processing events even if VM-Exit occurred.  The
> +	 * VM-Exit will have cleared exceptions that were meant for L2, but
> +	 * there may now be events that can be injected into L1.
>  	 */
> -	if (is_guest_mode(vcpu)) {
> -		r = kvm_check_nested_events(vcpu);
> -		if (r < 0)
> -			goto out;
> -	}
> +	if (r < 0)
> +		goto out;
>  
>  	/* try to inject new event if pending */
>  	if (vcpu->arch.exception.pending) {

All makes sense AFAIK.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



