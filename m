Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A915F5687B9
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiGFMES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiGFMER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:04:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E64F328E1D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y00sYDlWcZIUbSKIfjxNwX4MIuc56S64dgMIq8NLDRM=;
        b=FGpufGlRQkM1xuGvZ8mTWnF6el5CfK7qfWOUaoW2HVS93IPGI9E1Fo5TJg5Ld+bBFFjBs+
        3VzatKrc+L0rQ9RBy/WJu0gtb1CUroE91Z5IT1/FaSmpApp2g6XuPeOH1YmOqNFV3t031O
        BMzqUOgPc1KKUZYOE7ZQIKVpkV8Qwts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-NT-onGftPuCNYuGZd3Bfsg-1; Wed, 06 Jul 2022 08:04:14 -0400
X-MC-Unique: NT-onGftPuCNYuGZd3Bfsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B6C41C06EC0;
        Wed,  6 Jul 2022 12:04:14 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09B3140CFD0A;
        Wed,  6 Jul 2022 12:04:11 +0000 (UTC)
Message-ID: <cd9be62e3c2018a4f779f65fed46954e9431e0b0.camel@redhat.com>
Subject: Re: [PATCH v2 13/21] KVM: x86: Formalize blocking of nested pending
 exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:04:10 +0300
In-Reply-To: <20220614204730.3359543-14-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-14-seanjc@google.com>
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
> Capture nested_run_pending as block_pending_exceptions so that the logic
> of why exceptions are blocked only needs to be documented once instead of
> at every place that employs the logic.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 20 ++++++++++----------
>  arch/x86/kvm/vmx/nested.c | 23 ++++++++++++-----------
>  2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 471d40e97890..460161e67ce5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1347,10 +1347,16 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
>  
>  static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	bool block_nested_events =
> -		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	/*
> +	 * Only a pending nested run blocks a pending exception.  If there is a
> +	 * previously injected event, the pending exception occurred while said
> +	 * event was being delivered and thus needs to be handled.
> +	 */

Tiny nitpick about the comment:

One can say that if there is an injected event, this means that we
are in the middle of handling it, thus we are not on instruction boundary,
and thus we don't process events (e.g interrupts).

So maybe write something like that?


> +	bool block_nested_exceptions = svm->nested.nested_run_pending;
> +	bool block_nested_events = block_nested_exceptions ||
> +				   kvm_event_needs_reinjection(vcpu);

Tiny nitpick: I don't like that much the name 'nested' as
it can also mean a nested exception (e.g exception that
happened while jumping to an exception  handler).

Here we mean just exception/events for the guest, so I would suggest
to just drop the word 'nested'.

>  
>  	if (lapic_in_kernel(vcpu) &&
>  	    test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> @@ -1363,13 +1369,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (vcpu->arch.exception.pending) {
> -		/*
> -		 * Only a pending nested run can block a pending exception.
> -		 * Otherwise an injected NMI/interrupt should either be
> -		 * lost or delivered to the nested hypervisor in the EXITINTINFO
> -		 * vmcb field, while delivering the pending exception.
> -		 */
> -		if (svm->nested.nested_run_pending)
> +		if (block_nested_exceptions)
>                          return -EBUSY;
>  		if (!nested_exit_on_exception(svm))
>  			return 0;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fafdcbfeca1f..50fe66f0cc1b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3903,11 +3903,17 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>  
>  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long exit_qual;
> -	bool block_nested_events =
> -	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long exit_qual;
> +	/*
> +	 * Only a pending nested run blocks a pending exception.  If there is a
> +	 * previously injected event, the pending exception occurred while said
> +	 * event was being delivered and thus needs to be handled.
> +	 */
> +	bool block_nested_exceptions = vmx->nested.nested_run_pending;
> +	bool block_nested_events = block_nested_exceptions ||
> +				   kvm_event_needs_reinjection(vcpu);
>  
>  	if (lapic_in_kernel(vcpu) &&
>  		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> @@ -3941,15 +3947,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	 * Process exceptions that are higher priority than Monitor Trap Flag:
>  	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
>  	 * could theoretically come in from userspace), and ICEBP (INT1).
> -	 *
> -	 * Note that only a pending nested run can block a pending exception.
> -	 * Otherwise an injected NMI/interrupt should either be
> -	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
> -	 * while delivering the pending exception.
>  	 */
>  	if (vcpu->arch.exception.pending &&
>  	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
> -		if (vmx->nested.nested_run_pending)
> +		if (block_nested_exceptions)
>  			return -EBUSY;
>  		if (!nested_vmx_check_exception(vcpu, &exit_qual))
>  			goto no_vmexit;
> @@ -3966,7 +3967,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (vcpu->arch.exception.pending) {
> -		if (vmx->nested.nested_run_pending)
> +		if (block_nested_exceptions)
>  			return -EBUSY;
>  		if (!nested_vmx_check_exception(vcpu, &exit_qual))
>  			goto no_vmexit;

Besides the nitpicks:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


