Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148C35C04D1
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIUQ52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiIUQ5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:57:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3C0114
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:56:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso6542155pjd.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WD1FZIutqj+tuGsCZmK7QgnW+m8oVqDV5SlVa0DsKPo=;
        b=MrJ8i4vyRfldWAslL13xCVuzcAku+ZeZInTeZ6vKhsLg7myXl7wDykT1eQ/wcOGizU
         IdIuc1uYPuiUTjpFX1+OOmLcVqOtSm6y/C5V1xec0JSP49ewMa5s32dejosRZLk8YB0I
         6sr6Wa0fS/mqvqZ1s8X9zvDfEuAViIbsP0+YpDt0f4QRA5jfoHz7Rf6EHPLABTIF45jb
         S6TD8Z8nwwfvL38+JP/6PdITSR3AsYkNUhLE+1BB71tPXE8kuyDW9VCsXo2njVL722yb
         Gp0f/bwP/OGz+XD12Co3sgimPC4B2QUWKZmqJzlnK8ylLWUa69Y+op8g6rRBBlP8v07f
         zY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WD1FZIutqj+tuGsCZmK7QgnW+m8oVqDV5SlVa0DsKPo=;
        b=lRZsiD959j7drbSsyL/1bjQjnhzz8WsRxVHxSUEw2KK62yMP0MzDuaGU6ZVZiuOB4C
         2Y4ch4QpODg9r2mWKRTrUq6klS2cY5elgybKrX+lTH1QxTrubhe20Mr2c0bdJ4WhpYqv
         IohKpSC390RtF9iu7PJ6QyacyGqeOE6kb2jeG23i4LxOzJzEK3zXWj7U8GwlVQlZo3Zu
         yd1So+5P6Tw1yvKWXNwDxoogxHE1J9zcm9GEHK3kfVwEe1HcnXaII/EA1AjFzggBF6jS
         PzG1Ucf2CCisx/fDxz9NNh1Ae0cgbLQ1h0JO9/GkQAItc55oWbBwhkCCzSKXyF6R7MO2
         6lWQ==
X-Gm-Message-State: ACrzQf0PnWjd+ER0wNPyM67rfVqVwfM0HRcUEZDSYoWcnbfh/clwQkpN
        RRQ8HAQOo6n/4+froshSMEWPj6H9PqFibA==
X-Google-Smtp-Source: AMsMyM7T4L5soCsnLelwqUnxyP+xMf3K/rRXyaFm+N4g+5miEl0zt4QYYEOKObakW7EISSITjMWZuQ==
X-Received: by 2002:a17:90a:9a95:b0:200:34af:d277 with SMTP id e21-20020a17090a9a9500b0020034afd277mr10329770pjp.177.1663779372429;
        Wed, 21 Sep 2022 09:56:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902ce0c00b00176e8f85147sm2285448plg.83.2022.09.21.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:56:11 -0700 (PDT)
Date:   Wed, 21 Sep 2022 16:56:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 03/39] KVM: x86: hyper-v: Introduce TLB flush fifo
Message-ID: <YytCKIMgiVY+kSf9@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-4-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> To allow flushing individual GVAs instead of always flushing the whole
> VPID a per-vCPU structure to pass the requests is needed. Use standard
> 'kfifo' to queue two types of entries: individual GVA (GFN + up to 4095
> following GFNs in the lower 12 bits) and 'flush all'.
> 
> The size of the fifo is arbitrary set to '16'.

s/arbitrary/arbitrarily

> +static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	u64 flush_all_entry = KVM_HV_TLB_FLUSHALL_ENTRY;
> +
> +	if (!hv_vcpu)
> +		return;
> +
> +	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
> +
> +	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &flush_all_entry,
> +			    1, &tlb_flush_fifo->write_lock);

Unless I'm missing something, there's no need to disable IRQs, i.e. this can be
kfifo_in_spinlocked_noirqsave() and the later patch can use spin_lock() instead
of spin_lock_irqsave().  The only calls to hv_tlb_flush_enqueue() are from
kvm_hv_hypercall(), i.e. it's always called from process context.
  
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 1030b1b50552..ac30091ab346 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -151,4 +151,20 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
>  int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		     struct kvm_cpuid_entry2 __user *entries);
>  
> +

Unnecessary newline.

> +static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)

What about "reset" or "purge" instead of "empty"?  "empty" is often used as query,
e.g. list_empty(), it took me a second to realize this is a command.

> +{
> +	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	if (!hv_vcpu || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
> +		return;
> +
> +	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
> +
> +	kfifo_reset_out(&tlb_flush_fifo->entries);
> +}

Missing newline.

> +void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
> +
> +

One too many newlines.

>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86504a8bfd9a..45c35c5467f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3385,7 +3385,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	static_call(kvm_x86_flush_tlb_all)(vcpu);
>  }
>  
> -static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.tlb_flush;
>  
> @@ -3420,14 +3420,14 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>  		kvm_vcpu_flush_tlb_current(vcpu);
> -		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +		kvm_hv_vcpu_empty_flush_tlb(vcpu);

It might be worth adding a comment to call out that emptying the FIFO _after_ the
TLB flush is ok, because it's impossible for the CPU to insert TLB entries for the
guest while running in the host.  At first glance, it looks like this (and the
existing similar pattern in vcpu_enter_guest()) has a race where it could miss a
TLB flush.

Definitely not required, e.g. kvm_vcpu_flush_tlb_all() doesn't have a similar
comment.  I think it's just the existence of the FIFO that made me pause.

>  	}
>  
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
>  		kvm_vcpu_flush_tlb_guest(vcpu);
> -		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +		kvm_hv_vcpu_empty_flush_tlb(vcpu);
>  	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
> -		kvm_vcpu_flush_tlb_guest(vcpu);
> +		kvm_hv_vcpu_flush_tlb(vcpu);

Rather than expose kvm_vcpu_flush_tlb_guest() to Hyper-V, what about implementing
this in a similar way to how way KVM-on-HyperV implements remote TLB flushes?  I.e.
fall back to kvm_vcpu_flush_tlb_guest() if the precise flush "fails".

I don't mind exposing kvm_vcpu_flush_tlb_guest(), but burying the calls inside
Hyper-V code makes it difficult to see the relationship between KVM_REQ_HV_TLB_FLUSH
and KVM_REQ_TLB_FLUSH_GUEST.

And as a minor bonus, that also helps document that kvm_hv_vcpu_flush_tlb() doesn't
yet support precise flushing.

E.g.

	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
		kvm_vcpu_flush_tlb_guest(vcpu);
	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
		/*
		 * Fall back to a "full" guest flush if Hyper-V's precise
		 * flushing fails.
		 */
		if (kvm_hv_vcpu_flush_tlb(vcpu))
			kvm_vcpu_flush_tlb_guest(vcpu);
	}


int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
{
	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);

	if (!hv_vcpu)
		return -EINVAL;

	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;

	kfifo_reset_out(&tlb_flush_fifo->entries);

	/* Precise flushing isn't implemented yet. */
	return -EOPNOTSUPP;
}
