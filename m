Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B3D4394D1
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 13:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhJYLal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 07:30:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229911AbhJYLaj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 07:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635161297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cxbzx2vp0ECnG7lbAcPeKc1WVzKcTdh4GtjEHB6J5cI=;
        b=Meu2ON5nDcH78wxdIvDzMkO5YAhOGFpIqvc7MxhLylqT4aoxvCdNGHwtYRHRXjAFf6zfw3
        Sgj1bm5BHsyf8ekA+AC3uOvc6/4wx0rcsT4790azHQCAuL/OonTe2Yk6rg/nd4Naq90C/f
        l8G0zqmLaMVkVUNWhXB5q9ggQm6g+to=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-DcekAsJJOVSyUfRkF4ANtA-1; Mon, 25 Oct 2021 07:28:15 -0400
X-MC-Unique: DcekAsJJOVSyUfRkF4ANtA-1
Received: by mail-wm1-f72.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so3548091wmc.2
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 04:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Cxbzx2vp0ECnG7lbAcPeKc1WVzKcTdh4GtjEHB6J5cI=;
        b=7vzqZkNmONmhXT9f6gq5acm0xaMMIm9JgAelHaIagLKCX+vbEtav2eWMOEFADZHaAd
         e6HCGTw7PFdVsEhm4BRK5UxEjiZnhLZqIgk6pAhKNxCnI0z7keb8rHy3LR1FR2RGmNRR
         yrf/Xk1rF/L5U4L353/SCCAlvMj9az2iR5W9q1J1Y86OZXETuPfS5ZXK9NbA+pXJwcFN
         hs8LwgX03U29nvPWRQ1Dnv4VZnX+yr0Yt1R4lcFXiyhaG2vVVAAsUp8k405DEXMgXIsr
         gdK/1LaCERY295iyqO3GhU71K/Tbe3EXqMaeYUtOWWf5SNo55u5ESZppmyzwDaOvjCEE
         DbQA==
X-Gm-Message-State: AOAM5302lC1Vg9leo5G4yu6SC5adKP9z4MAHihAqVd0hsavTNro681o6
        8iKx4qNf6tA611edrpsW2re/f7FtwGpkOoKnZ8aYSC8rz4HKdkHz80NZ+Sqg4sQ+BOxj4xmUX3N
        XaxtdKOjQrJFv
X-Received: by 2002:a05:600c:4e91:: with SMTP id f17mr19264999wmq.180.1635161294831;
        Mon, 25 Oct 2021 04:28:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzez3HAlAvqha0PDJuRBuvOQYpOcexqKELd/5VIieBm029qrHpSp1UWMeAvrG6sZI64D/GejA==
X-Received: by 2002:a05:600c:4e91:: with SMTP id f17mr19264963wmq.180.1635161294552;
        Mon, 25 Oct 2021 04:28:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o194sm9479016wme.40.2021.10.25.04.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 04:28:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        JoergRoedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in
 kvm_vcpu_block()
In-Reply-To: <168bf8c689561da904e48e2ff5ae4713eaef9e2d.camel@infradead.org>
References: <168bf8c689561da904e48e2ff5ae4713eaef9e2d.camel@infradead.org>
Date:   Mon, 25 Oct 2021 13:28:12 +0200
Message-ID: <87ilxluywj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

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
>  arch/x86/kvm/xen.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 9ea9c3dabe37..8f62baebd028 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -190,6 +190,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>  
>  int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  {
> +	int err;
>  	u8 rc = 0;
>  
>  	/*
> @@ -216,13 +217,29 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  	if (likely(slots->generation == ghc->generation &&
>  		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
>  		/* Fast path */
> -		__get_user(rc, (u8 __user *)ghc->hva + offset);
> -	} else {
> -		/* Slow path */
> -		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
> -					     sizeof(rc));
> +		pagefault_disable();
> +		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
> +		pagefault_enable();

This reminds me of copy_from_user_nofault() -- can we use it instead maybe?

> +		if (!err)
> +			return rc;
>  	}
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
>  	return rc;
>  }
>  
>
>

-- 
Vitaly

