Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9983D56879A
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiGFMAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiGFMAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:00:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED5DB2408D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fI8zpSYJcp3SecHdqF+x/6bDajtJusuvKvSKLk/wVpM=;
        b=D7m03Yp6Kon5TbHGhs1GTx6oVy1NmUipyuMr9ljLV3ozNEky7kMySI43kXglByQbGtfrAF
        3WXssQ8BdJMnCPF/Oq8Q2BjM2PIgQzEKZpkv1qVtLvti4GpKvvpXjcY+CvMFdCrrmyOQ6I
        P4T1DswIJXC9JHzvV0W5/6vKJcdy5T0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-y8nhbP4DOZep3qUJfycw8Q-1; Wed, 06 Jul 2022 08:00:42 -0400
X-MC-Unique: y8nhbP4DOZep3qUJfycw8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83C6C2932480;
        Wed,  6 Jul 2022 12:00:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31D752026D64;
        Wed,  6 Jul 2022 12:00:39 +0000 (UTC)
Message-ID: <599b352e16c970885d3f6bfaf7d1a254627ef5dd.camel@redhat.com>
Subject: Re: [PATCH v2 09/21] KVM: nVMX: Unconditionally clear mtf_pending
 on nested VM-Exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:00:38 +0300
In-Reply-To: <20220614204730.3359543-10-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Clear mtf_pending on nested VM-Exit instead of handling the clear on a
> case-by-case basis in vmx_check_nested_events().  The pending MTF should
> rever survive nested VM-Exit, as it is a property of KVM's run of the
^^ typo: never

Also it is not clear what the 'case by case' means.

I see that the vmx_check_nested_events always clears it unless nested run is pending
or we re-inject an event.



> current L2, i.e. should never affect the next L2 run by L1.  In practice,
> this is likely a nop as getting to L1 with nested_run_pending is
> impossible, and KVM doesn't correctly handle morphing a pending exception
> that occurs on a prior injected exception (need for re-injected exception
> being the other case where MTF isn't cleared).  However, KVM will
> hopefully soon correctly deal with a pending exception on top of an
> injected exception.



> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d080bfca16ef..7b644513c82b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3909,16 +3909,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	unsigned long exit_qual;
>  	bool block_nested_events =
>  	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
> -	bool mtf_pending = vmx->nested.mtf_pending;
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	/*
> -	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
> -	 * this state is discarded.
> -	 */
> -	if (!block_nested_events)
> -		vmx->nested.mtf_pending = false;
> -
>  	if (lapic_in_kernel(vcpu) &&
>  		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>  		if (block_nested_events)
> @@ -3927,6 +3919,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  		clear_bit(KVM_APIC_INIT, &apic->pending_events);
>  		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
>  			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +
> +		/* MTF is discarded if the vCPU is in WFS. */
> +		vmx->nested.mtf_pending = false;
>  		return 0;

I guess MTF should also be discarded if we enter SMM, and I see that
VMX also enter SMM with a pseudo VM exit (in vmx_enter_smm) which
will clear the MTF. Good.

>  	}
>  
> @@ -3964,7 +3959,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  		return 0;
>  	}
>  
> -	if (mtf_pending) {
> +	if (vmx->nested.mtf_pending) {
>  		if (block_nested_events)
>  			return -EBUSY;
>  		nested_vmx_update_pending_dbg(vcpu);
> @@ -4562,6 +4557,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  
> +	/* Pending MTF traps are discarded on VM-Exit. */
> +	vmx->nested.mtf_pending = false;
> +
>  	/* trying to cancel vmlaunch/vmresume is a bug */
>  	WARN_ON_ONCE(vmx->nested.nested_run_pending);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



