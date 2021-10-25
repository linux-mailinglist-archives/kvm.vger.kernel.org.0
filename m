Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31E643973C
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhJYNNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:13:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233441AbhJYNNL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 09:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635167449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CC2qfVYwSSCkvnbuI4+4oNk0qXxqQCY4CC7bZHSVhWw=;
        b=Yr6opWTAcvPJ/C5VdGHfiw2VuymrHE06E/zqsLQOUlNsItha+BI85Wr6lPKhf5+Onbcqnh
        ++QtbsLMX3nySOLGtbepLlajzdFEFm3SzudsD5ujz+BFrT/7Dhq79zFGyIU+e89C1Ta12V
        1fRW4jcyaInqpPR6Dm7o4c6lzomfDww=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Ft0ftrzVN0W5agKMefASSg-1; Mon, 25 Oct 2021 09:10:39 -0400
X-MC-Unique: Ft0ftrzVN0W5agKMefASSg-1
Received: by mail-wm1-f72.google.com with SMTP id f20-20020a05600c155400b0030db7b29174so3952250wmg.2
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 06:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CC2qfVYwSSCkvnbuI4+4oNk0qXxqQCY4CC7bZHSVhWw=;
        b=7brmWHHROVuzLzaLVXRj3NZqm2iL8GllTBncFbiZaSE24MLV6MmUXrrZtp17GEhXyT
         7K5a+F1Xo9FSBZ/HkXz+H/StzDz1k32FxO8F8CAW3v0aep//6yhEr57shTfyiDmYcTb+
         7UyoMl8MLBc4h/Y/AvclBqfHirJOhJhBBpDPJqHaY8IXJsXnNeu/p5g/BsH70GZbttAP
         RZQsU85uj9Bh+gnHhignLi3qRjQOOSJBSUJr5rt9bfeUnmyAKfHGl2eSknFBbevNKqht
         qmzorD/Aug+Vm/jGNzZqudnLtaJvJeyNL2ZHlxWgyYbZvt5iA2znfYKMXiWymksBZrUA
         yUow==
X-Gm-Message-State: AOAM5320Fmyap5rXqpOmP+xHn1Ul5R7eSebKZjI6moLIOclHzo9fvgnR
        7SZ2fkgYYIVDO2Rkzq+3KlSNlxwcz5WctBiw5UtiYANY5ZFrea3ybCz4T/N56floUwMALUUBwxt
        Vn4tEBzgQSOec
X-Received: by 2002:adf:c70f:: with SMTP id k15mr23417821wrg.98.1635167437572;
        Mon, 25 Oct 2021 06:10:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTijQmc2aqI1GHuqySlClxTZDxXw9/4RDBGYE6TK7xD4+SInHZd2pv+EHAlYQEO+JONPXqjg==
X-Received: by 2002:adf:c70f:: with SMTP id k15mr23417789wrg.98.1635167437352;
        Mon, 25 Oct 2021 06:10:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f9sm5917135wrx.31.2021.10.25.06.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 06:10:36 -0700 (PDT)
Message-ID: <83ac5bed-d613-28b3-4482-794bdd49abeb@redhat.com>
Date:   Mon, 25 Oct 2021 15:10:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in
 kvm_vcpu_block()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        JoergRoedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
References: <168bf8c689561da904e48e2ff5ae4713eaef9e2d.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <168bf8c689561da904e48e2ff5ae4713eaef9e2d.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/21 21:47, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In kvm_vcpu_block, the current task is set to TASK_INTERRUPTIBLE before
> making a final check whether the vCPU should be woken from HLT by any
> incoming interrupt.
> 
> This is a problem for the get_user() in __kvm_xen_has_interrupt(), which
> really shouldn't be sleeping when the task state has already been set.
> I think it's actually harmless as it would just manifest itself as a
> spurious wakeup, but it's causing a debug warning:
> 
> [  230.963649] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000b6bcdbc9>] prepare_to_swait_exclusive+0x30/0x80
> 
> Fix the warning by turning it into an *explicit* spurious wakeup. When
> invoked with !task_is_running(current) (and we might as well add
> in_atomic() there while we're at it), just return 1 to indicate that
> an IRQ is pending, which will cause a wakeup and then something will
> call it again in a context that *can* sleep so it can fault the page
> back in.
> 
> Cc: stable@vger.kernel.org
> Fixes: 40da8ccd724f ("KVM: x86/xen: Add event channel interrupt vector upcall")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> ---
>   arch/x86/kvm/xen.c | 27 ++++++++++++++++++++++-----
>   1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 9ea9c3dabe37..8f62baebd028 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -190,6 +190,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   
>   int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>   {
> +	int err;
>   	u8 rc = 0;
>   
>   	/*
> @@ -216,13 +217,29 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>   	if (likely(slots->generation == ghc->generation &&
>   		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
>   		/* Fast path */
> -		__get_user(rc, (u8 __user *)ghc->hva + offset);
> -	} else {
> -		/* Slow path */
> -		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
> -					     sizeof(rc));
> +		pagefault_disable();
> +		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
> +		pagefault_enable();
> +		if (!err)
> +			return rc;
>   	}
>   
> +	/* Slow path */
> +
> +	/*
> +	 * This function gets called from kvm_vcpu_block() after setting the
> +	 * task to TASK_INTERRUPTIBLE, to see if it needs to wake immediately
> +	 * from a HLT. So we really mustn't sleep. If the page ended up absent
> +	 * at that point, just return 1 in order to trigger an immediate wake,
> +	 * and we'll end up getting called again from a context where we *can*
> +	 * fault in the page and wait for it.
> +	 */
> +	if (in_atomic() || !task_is_running(current))
> +		return 1;
> +
> +	kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
> +				     sizeof(rc));
> +
>   	return rc;
>   }
>   
> 
> 

Queued, thanks.

Paolo

