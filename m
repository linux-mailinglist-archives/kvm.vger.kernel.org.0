Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E283D5686CB
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiGFLkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiGFLki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9F8D14D20
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657107636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9Lj3RyDX92hfQSFqlU6kQoYe1pQfwKH5XoVYNn4fSs=;
        b=G8Rx4DauXuvKhHjNmPAowslkT9Yt/Z6FXl2U3++OQ8zzxM8muiv3liJTeF0rHZBFCtKXaY
        BulXhRLTgqzoDu6kIqWs8HYRymiK7pR+/H1CyenFAd56jD0qzIKPYGDztj2YRO/YLC3rz6
        K7/qZjxNAhAdmY/v8iY7JgfG8M1f7XM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-bBNdnsj1NwKIw3oGtQk5aw-1; Wed, 06 Jul 2022 07:40:31 -0400
X-MC-Unique: bBNdnsj1NwKIw3oGtQk5aw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A4493C11042;
        Wed,  6 Jul 2022 11:40:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8069440CFD0A;
        Wed,  6 Jul 2022 11:40:28 +0000 (UTC)
Message-ID: <faba7f7ff1a8f090143b2d58d3e33a3c82dd328e.camel@redhat.com>
Subject: Re: [PATCH v2 01/21] KVM: nVMX: Unconditionally purge
 queued/injected events on nested "exit"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:40:27 +0300
In-Reply-To: <20220614204730.3359543-2-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Drop pending exceptions and events queued for re-injection when leaving
> nested guest mode, even if the "exit" is due to VM-Fail, SMI, or forced
> by host userspace.  Failure to purge events could result in an event
> belonging to L2 being injected into L1.
> 
> This _should_ never happen for VM-Fail as all events should be blocked by
> nested_run_pending, but it's possible if KVM, not the L1 hypervisor, is
> the source of VM-Fail when running vmcs02.
> 
> SMI is a nop (barring unknown bugs) as recognition of SMI and thus entry
> to SMM is blocked by pending exceptions and re-injected events.
> 
> Forced exit is definitely buggy, but has likely gone unnoticed because
> userspace probably follows the forced exit with KVM_SET_VCPU_EVENTS (or
> some other ioctl() that purges the queue).
> 
> Fixes: 4f350c6dbcb9 ("kvm: nVMX: Handle deferred early VMLAUNCH/VMRESUME failure properly")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7d8cd0ebcc75..ee6f27dffdba 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4263,14 +4263,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  			nested_vmx_abort(vcpu,
>  					 VMX_ABORT_SAVE_GUEST_MSR_FAIL);
>  	}
> -
> -	/*
> -	 * Drop what we picked up for L2 via vmx_complete_interrupts. It is
> -	 * preserved above and would only end up incorrectly in L1.
> -	 */
> -	vcpu->arch.nmi_injected = false;
> -	kvm_clear_exception_queue(vcpu);
> -	kvm_clear_interrupt_queue(vcpu);
>  }
>  
>  /*
> @@ -4609,6 +4601,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  		WARN_ON_ONCE(nested_early_check);
>  	}
>  
> +	/*
> +	 * Drop events/exceptions that were queued for re-injection to L2
> +	 * (picked up via vmx_complete_interrupts()), as well as exceptions
> +	 * that were pending for L2.  Note, this must NOT be hoisted above
> +	 * prepare_vmcs12(), events/exceptions queued for re-injection need to
> +	 * be captured in vmcs12 (see vmcs12_save_pending_event()).
> +	 */
> +	vcpu->arch.nmi_injected = false;
> +	kvm_clear_exception_queue(vcpu);
> +	kvm_clear_interrupt_queue(vcpu);
> +
>  	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
>  
>  	/* Update any VMCS fields that might have changed while L2 ran */

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

