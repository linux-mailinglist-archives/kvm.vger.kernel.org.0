Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67DA4353DE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhJTTgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhJTTgh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 15:36:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27E6C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:34:22 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s61-20020a17090a69c300b0019f663cfcd1so1326140pjj.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qrDNVaKSH2YaCERoSZM9h6YRO5j6lFldR24aY+9Lc8k=;
        b=mqJbaQQ0ide3vmgaDVvc9HcK9EdOSBkVv31Iz7IHo5sqdgLFYQ/6k18oSVR1nTBQmJ
         LQNkev/YsJkdvI2rN5wYOiOlMTmVbNBokxxTn2jqvXerekFbkqdU7kvpN4HR51iC/ozd
         9WQ+Rv5Z67kQZQY8IAIqXpwlXhmTdAkjnqMW/XynzVMH/XdYbZdPlhKEcQHxhDEWXIGp
         FRSMQ11qoLKlrU8Wh6+D2YhU1rKzH00hbcCcOS3vObNpywKfJ7qJqz90lcB+JHsMJSKs
         svH/2rP4xuo7rEgv4QwTYgbsrQFZw3pnMX82o9TXohrfD0Y0vpgM6qT4+MwEWUMluEc8
         +2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qrDNVaKSH2YaCERoSZM9h6YRO5j6lFldR24aY+9Lc8k=;
        b=qPQ3nkp/FJd5Y+9vDdhqM7aXuxgtKY/cO0UU+Rv92FmsX1SXslhg/p7cO+CTc/I3rS
         KIH8rsRcSBtwyn86X2ZQsdocSEIyFuo+rp20lDOtENbKil6DnWGisREi3Wx4Gl3xAFpJ
         yOdgKtcV8cHaGE+wJErUsyAeZ0yfVMLOxRB23qf1uWWeOu55rqQnZJZdkOAfZcfGm9gt
         UjPiyOcVfk4XEffr7GWdUOfoNrmYoPg7+f/Igx+mtLmOARuP8kq/SCRPh0cOPEWU7Uu0
         BVqc6knPvYIDk7U4ZlZylOhlBDmJgo4+JBObRIGs556p0eEUqt+W9n/4ErjX1Feu3ZP2
         O3/A==
X-Gm-Message-State: AOAM532q8/PYYK8+PNZFOUuOf3yuRxlRXly5tK/mkqdfZMdzGch5q1P/
        TK0GpzhlSKHUQhOXzKhsAWe33Q==
X-Google-Smtp-Source: ABdhPJxF3cELQaGP/U+5CRxwMJvhjAsNsJ7KCv4UOibDsWUoMx95iFwRAEwjEl24qCpYsagDBE/M8A==
X-Received: by 2002:a17:90a:b288:: with SMTP id c8mr927024pjr.67.1634758462008;
        Wed, 20 Oct 2021 12:34:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t2sm6681197pjf.1.2021.10.20.12.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:34:21 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:34:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com
Subject: Re: [PATCH] KVM: Avoid atomic operations when kicking the running
 vCPU
Message-ID: <YXBvOR1qQpsbNUIs@google.com>
References: <20211020145231.871299-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020145231.871299-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> If we do have the vcpu mutex, as is the case if kvm_running_vcpu is set
> to the target vcpu of the kick, changes to vcpu->mode do not need atomic
> operations; cmpxchg is only needed _outside_ the mutex to ensure that
> the IN_GUEST_MODE->EXITING_GUEST_MODE change does not race with the vcpu
> thread going OUTSIDE_GUEST_MODE.
> 
> Use this to optimize the case of a vCPU sending an interrupt to itself.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..9f45f26fce4f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3325,6 +3325,19 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_wake_up(vcpu))
>  		return;
>  
> +	me = get_cpu();
> +	/*
> +	 * The only state change done outside the vcpu mutex is IN_GUEST_MODE
> +	 * to EXITING_GUEST_MODE.  Therefore the moderately expensive "should
> +	 * kick" check does not need atomic operations if kvm_vcpu_kick is used
> +	 * within the vCPU thread itself.
> +	 */
> +	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
> +		if (vcpu->mode == IN_GUEST_MODE)
> +			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);

Fun.  I had a whole thing typed out about this being unsafe because it implicitly
relies on a pending request and that there's a kvm_vcpu_exit_request() check _after_
this kick.  Then I saw your other patches, and then I realized we already have this
bug in the kvm_arch_vcpu_should_kick() below.

Anyways, I also think we should add do:

	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
		if (vcpu->mode == IN_GUEST_MODE &&
		    !WARN_ON_ONCE(!kvm_request_pending(vcpu)))
			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
		goto out;
	}

The idea being that delaying or even missing an event in case of a KVM bug is
preferable to letting the vCPU state become invalid due to running in the guest
with EXITING_GUEST_MODE.

