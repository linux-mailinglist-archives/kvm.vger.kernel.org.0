Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3394BBE0C
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiBRRMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:12:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238159AbiBRRMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:12:53 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD8444755
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:12:36 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id l8so7661392pls.7
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rd+L0NpmRxP51ahSRBwjzexi22gynEtFgPMfpz+PHPs=;
        b=prBseZC8s7hyert8XERbcfz8EHA2o71yywYUTEjxu4j9Ivbs6v1skghyF7DDGFNV5o
         57X8r4gXyL9U1EPPQBKXZUFoCOxmuOyOTGCElTlCYf+CO0A2pYMvewfCZ75DK79ILJj0
         3htK9GmOFOFA4l7iQ/gopJG7UCSW38MVDgn9EYaiIcKGxwmOZPdDQ1Ky21E0C72QsSA2
         KnUkkzGWgdGcR3a9VXSkpiW1nf0vt8vCiuO4RF05ekKXZ06DI+gdAi6fvUX5/ySfnSi/
         MDZ/A8e/jYEVOdm8ISDM7xGsJIvoFGHWdttT9R0w22Kn+HlrqOznv3vw0+bCyPGqATGh
         9nWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rd+L0NpmRxP51ahSRBwjzexi22gynEtFgPMfpz+PHPs=;
        b=DuSj1OMoFYHtSYdXLkxtx57GE0q5831u+aezPMKwOYg+2T2oWdKUlGnD6L8/tL9H+u
         Po4JXjVMtjVLpEQinC2HMmpQ14jkTVQzVHiZXFYyXyTMfkydUfC7cTEai148iVcPntjk
         +lM6+GLybwgJYXrZTmZeUJguSjdwDJRnQfdFLTq/I1/tCvKh0GtLCq0WrtLhYn92ltax
         /fhtgXG0lVCZYw68tHv2xwOGeijTYpH3M1RNaxXmJkzjtoLgmVSUAiu6HyGJLVgxA/qv
         r5+37ji9T65jPRNtbiYew/Ye5ijIbtBeh0TYxiyrJxhXS2dK9CQlNQ5HlXRvzFF58YSv
         9zmg==
X-Gm-Message-State: AOAM530wcaWnYwswRPK/WVUW2xX0PhlzGF1yty30jlDSF+M17oDOdORR
        idYEDNGnQ7zW6IOwnwW70WIYQg==
X-Google-Smtp-Source: ABdhPJxV01IOK0zmveWvz0Pf3rMMYWygqKCKGQFx6UZHOGJPkfjikkqEDRu7xOTasteNzl8+tJp8hA==
X-Received: by 2002:a17:90b:4b92:b0:1b7:aca7:b2f3 with SMTP id lr18-20020a17090b4b9200b001b7aca7b2f3mr13764585pjb.169.1645204355709;
        Fri, 18 Feb 2022 09:12:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c14sm3561166pfm.169.2022.02.18.09.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:12:35 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:12:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 02/18] KVM: x86: do not deliver asynchronous page
 faults if CR0.PG=0
Message-ID: <Yg/Tf520avCvMuXj@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Enabling async page faults is nonsensical if paging is disabled, but
> it is allowed because CR0.PG=0 does not clear the async page fault
> MSR.  Just ignore them and only use the artificial halt state,
> similar to what happens in guest mode if async #PF vmexits are disabled.
> 
> Given the increasingly complex logic, and the nicer code if the new
> "if" is placed last, opportunistically change the "||" into a chain
> of "if (...) return false" statements.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Comment nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/x86.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 99a58c25f5c2..b912eef5dc1a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12270,14 +12270,28 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
>  
>  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  {
> -	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> +
> +	if (!kvm_pv_async_pf_enabled(vcpu))
>  		return false;
>  
> -	if (!kvm_pv_async_pf_enabled(vcpu) ||
> -	    (vcpu->arch.apf.send_user_only && static_call(kvm_x86_get_cpl)(vcpu) == 0))
> +	if (vcpu->arch.apf.send_user_only &&
> +	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
>  		return false;
>  
> -	return true;
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * L1 needs to opt into the special #PF vmexits that are
> +		 * used to deliver async page faults.

Wrap at 80 chars.

> +		 */
> +		return vcpu->arch.apf.delivery_as_pf_vmexit;
> +	} else {
> +		/*
> +		 * Play it safe in case the guest does a quick real mode
> +		 * foray.  The real mode IDT is unlikely to have a #PF
> +		 * exception setup.

I actually like the comment, but it's slightly confusing because based on the
"real mode" stuff, I would expect:

		return is_protmode(vcpu);

Maybe tweak it to:


		/*
		 * Play it safe in case the guest temporarily disables paging.
		 * The real mode IDT in particular is unlikely to have a #PF
		 * exception setup.
		 */

> +		 */
> +		return is_paging(vcpu);
> +	}
>  }
>  
>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> -- 
> 2.31.1
> 
> 
