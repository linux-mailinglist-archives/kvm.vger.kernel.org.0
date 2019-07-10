Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1174364AC6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfGJQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:33:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35385 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfGJQdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:33:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so3187963wrm.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:33:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAZ2caXl1Op3wUbeAgdgFHIrI9I20XhjoR3o/FCNFws=;
        b=fBt3dgoFWtDhv93Y7Ms7vBL3eOTGFG5qLE9FcMoUREgdgDplIUHFUAdEBvw07/bB6g
         9k8RcfXCqQi4JX0z1aTjx9cGFhAEOq/INdj4wCB9tuwCjsLfKSA2Kmc6Dq0tpL67mx/L
         YJebIx/IY6cmwNtBZ5LTo+8CLYURmFpw7+rk0JuE7qg07inxwMlrHfR4ZA3vhg3MLmcI
         bwaGj/Ro5b2Bp42+LSOPCJ7FotjzsO9fhxMuH2leWeNnX9Dkf6Nefr37wRzovs+kjA1c
         Gm2T9CrntGE88jFYUBXbmy7nZo3dCX36w++3do6t2GDY3ofvwU9TOLXj9YGOkZE+fagE
         AYzA==
X-Gm-Message-State: APjAAAUru/pgN20UX9UDrqsOQ5ReqceBZrkfsmmikjHfUFlX800Q3H06
        unL8HTvWWOoYefdLP4TmmG4irg==
X-Google-Smtp-Source: APXvYqxhQq7OXRgb0gbjoF9Hn0GY3QAChW4eHbeEuhvmpUBZ6/RZCXM3TQBnu4Y6zDYOWw6mmcF5bw==
X-Received: by 2002:adf:e947:: with SMTP id m7mr33013902wrn.123.1562776393225;
        Wed, 10 Jul 2019 09:33:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id n1sm2765082wrx.39.2019.07.10.09.33.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 09:33:12 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: nVMX: Skip Guest State Area vmentry checks that
 are necessary only if VMCS12 is dirty
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-6-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dedc725a-0810-a981-0ceb-a48a7f2f8b09@redhat.com>
Date:   Wed, 10 Jul 2019 18:33:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190707071147.11651-6-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/19 09:11, Krish Sadhukhan wrote:
>   ..so that every nested vmentry is not slowed down by those checks.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Here I think only the EFER check needs to be done always (before it
refers GUEST_CR0 which is shadowed).

Paolo

> ---
>  arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b610f389a01b..095923b1d765 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2748,10 +2748,23 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>  	return 0;
>  }
>  
> +static int nested_vmx_check_guest_state_full(struct kvm_vcpu *vcpu,
> +					     struct vmcs12 *vmcs12,
> +					     u32 *exit_qual)
> +{
> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
> +	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
> +	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  					struct vmcs12 *vmcs12,
>  					u32 *exit_qual)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	bool ia32e;
>  
>  	*exit_qual = ENTRY_FAIL_DEFAULT;
> @@ -2788,10 +2801,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  			return -EINVAL;
>  	}
>  
> -	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
> -	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
> -	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
> -		return -EINVAL;
> +	if (vmx->nested.dirty_vmcs12 &&
> +	    nested_vmx_check_guest_state_full(vcpu, vmcs12, exit_qual))
> +			return -EINVAL;
>  
>  	if (nested_check_guest_non_reg_state(vmcs12))
>  		return -EINVAL;
> 

