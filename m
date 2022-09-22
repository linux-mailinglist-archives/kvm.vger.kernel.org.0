Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CD5E5EAD
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 11:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiIVJfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 05:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIVJfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 05:35:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A11F6A4B1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 02:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663839313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gUGcqCxSDMCIAUrOuyN8xRMwYFQcavVb0le1znZCWqA=;
        b=DGLNpWtz4aK1iLaAm7tGit5M1KpRY+OoInVV5PagNRigttkE/N8QbWABvflsR8Ievt32ZC
        AIhgklML5AW89N/+xl/o5qeqEtCs6emaSdtF0tfYlh4tp4GVLU/fPOmTSXrrRnwKviQCwh
        7+/XhOQSsd9JWZoFREYQfYZXKSDbP8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-6UJSczypNuScRJjZ0SXJtg-1; Thu, 22 Sep 2022 05:35:12 -0400
X-MC-Unique: 6UJSczypNuScRJjZ0SXJtg-1
Received: by mail-wm1-f71.google.com with SMTP id g8-20020a05600c4ec800b003b4bcbdb63cso3818414wmq.7
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 02:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=gUGcqCxSDMCIAUrOuyN8xRMwYFQcavVb0le1znZCWqA=;
        b=RScTJ2oF+bMsGmdtcYOUry3lIwEKMOOa3bIQleN0tDIDYixhB16MrySBNUcE35oOtb
         jy7xiYWe8kMCAwJRNBlPj4lEdsAgtZr3c6S2vKNSRBmH62lOsZxYY6Xwjp/ht4UeDKjG
         uDlUReXfdJ385TKTpgf2FUKl765WgctlSa83SS7bbnarPVhqGM0oOkVijRse7sFtwKpl
         Ixp8dFkqYBYDkwXi4YdxuexXyzmem+LOvCxfcHavZfTfaLpeeXnC1AeYGysI765vssdE
         18C7nPNEoVaIcQWQZXEfyP4sYJiFr49ae6jyvH+mh2/C1HyPQVoewUf+Juydq9c1G54j
         /aVg==
X-Gm-Message-State: ACrzQf0krcItRGCMLB8DnXr20oGWhaYIcTFId9B7AtAbLnAy457ppB+z
        8kQzH0UrBsVaLUK/MO3MSsNsnkTJDBZr3EwM5uFKw4GFWNyW/C44M5EZLO2Xun+7KWwb5XwnoIL
        +0LSsAK5miEsG
X-Received: by 2002:a05:600c:221a:b0:3b4:75b8:3f7f with SMTP id z26-20020a05600c221a00b003b475b83f7fmr1622596wml.175.1663839310998;
        Thu, 22 Sep 2022 02:35:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7VWzhc4WjoiR+pNf0jAsiBDn/PgLRNqXLh5/KQS3L2ehVURiYx0K1Ybl1BCLIgh2g79fnzlw==
X-Received: by 2002:a05:600c:221a:b0:3b4:75b8:3f7f with SMTP id z26-20020a05600c221a00b003b475b83f7fmr1622579wml.175.1663839310728;
        Thu, 22 Sep 2022 02:35:10 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b0021badf3cb26sm5468427wrv.63.2022.09.22.02.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:35:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/39] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
In-Reply-To: <Yys/pv0d+8ywcbUy@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-3-vkuznets@redhat.com>
 <Yys6b1ZqYbw9Umyu@google.com> <Yys/pv0d+8ywcbUy@google.com>
Date:   Thu, 22 Sep 2022 11:35:08 +0200
Message-ID: <874jwzoipf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Sep 21, 2022, Sean Christopherson wrote:
>> On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index f62d5799fcd7..86504a8bfd9a 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -3418,11 +3418,17 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>> >   */
>> >  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>> >  {
>> > -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>> > +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>> >  		kvm_vcpu_flush_tlb_current(vcpu);
>> > +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
>> 
>> This isn't correct, flush_tlb_current() flushes "host" TLB entries, i.e. guest-physical
>> mappings in Intel terminology, where flush_tlb_guest() and (IIUC) Hyper-V's paravirt
>> TLB flush both flesh "guest" TLB entries, i.e. linear and combined mappings.
>> 
>> Amusing side topic, apparently I like arm's stage-2 terminology better than "TDP",
>> because I actually typed out "stage-2" first.
>> 
>> > +	}
>> >  
>> > -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
>> > +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
>> > +		kvm_vcpu_flush_tlb_guest(vcpu);
>> > +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
>
> Looking at future patches where KVM needs to reset the FIFO when doing a "guest"
> TLB flush, i.e. needs to do more than just clearing the request, what about putting
> this in kvm_vcpu_flush_tlb_guest() right away?

Will do.

>
> Ah, and there's already a second caller to kvm_vcpu_flush_tlb_guest().  I doubt
> KVM's paravirt TLB flush will ever collide with Hyper-V's paravirt TLB flush,
> but logically a "guest" flush that is initiated through KVM's paravirt interface
> should also clear Hyper-V's queue/request.

I ignored this as a case which is not worth optimizing for,
i.e. over-flushing is always correct.

>
> And for consistency, slot this in before this patch:
>

Will do, thanks!

> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 21 Sep 2022 09:35:34 -0700
> Subject: [PATCH] KVM: x86: Move clearing of TLB_FLUSH_CURRENT to
>  kvm_vcpu_flush_tlb_all()
>
> Clear KVM_REQ_TLB_FLUSH_CURRENT in kvm_vcpu_flush_tlb_all() instead of in
> its sole caller that processes KVM_REQ_TLB_FLUSH.  Regardless of why/when
> kvm_vcpu_flush_tlb_all() is called, flushing "all" TLB entries also
> flushes "current" TLB entries.
>
> Ideally, there will never be another caller of kvm_vcpu_flush_tlb_all(),
> and moving the handling "requires" extra work to document the ordering
> requirement, but future Hyper-V paravirt TLB flushing support will add
> similar logic for flush "guest" (Hyper-V can flush a subset of "guest"
> entries).  And in the Hyper-V case, KVM needs to do more than just clear
> the request, the queue of GPAs to flush also needs to purged, and doing
> all only in the request path is undesirable as kvm_vcpu_flush_tlb_guest()
> does have multiple callers (though it's unlikely KVM's paravirt TLB flush
> will coincide with Hyper-V's paravirt TLB flush).
>
> Move the logic even though it adds extra "work" so that KVM will be
> consistent with how flush requests are processed when the Hyper-V support
> lands.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f62d5799fcd7..3ea2e51a8cb5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3383,6 +3383,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.tlb_flush;
>  	static_call(kvm_x86_flush_tlb_all)(vcpu);
> +
> +	/* Flushing all ASIDs flushes the current ASID... */
> +	kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>  
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
> @@ -10462,12 +10465,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			kvm_mmu_sync_roots(vcpu);
>  		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
>  			kvm_mmu_load_pgd(vcpu);
> -		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
> +
> +		/*
> +		 * Note, the order matters here, as flushing "all" TLB entries
> +		 * also flushes the "current" TLB entries, i.e. servicing the
> +		 * flush "all" will clear any request to flush "current".
> +		 */
> +		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
>  			kvm_vcpu_flush_tlb_all(vcpu);
> -
> -			/* Flushing all ASIDs flushes the current ASID... */
> -			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> -		}
>  		kvm_service_local_tlb_flush_requests(vcpu);
>  
>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
>
> base-commit: ed102fe0b59586397b362a849bd7fb32582b77d8

-- 
Vitaly

