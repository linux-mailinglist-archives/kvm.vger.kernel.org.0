Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8072A5BD8F2
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 02:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiITA4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 20:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiITA4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 20:56:03 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5755F481F9
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 17:56:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h188so944135pgc.12
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 17:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=xEM78DA9vAlG5zrPlRQ/Wkwq/r1WdumNRcvFYfR+/4k=;
        b=DKzflZJ1w7k5XyXNplvbINHUyvKUnWeRp2N+BYaiKeikenfpZVH7zDWYedfRccmbiT
         MelH9q4FVlQDyINUZcJ08X8/XahJ1W0fu/4K0VhHRXf4yYVl9Dt5ndu4TfU8JYApQxJa
         1jcV5ecAbazbIBRYtAHTStQzSVpSj6VztOwZPZ/c4RfzuLG7MpbEf7pYbE0PFOntzEx/
         0E9zR0ogzJ0ZmOMI5luMzf4pR7PEWw3u7abJI+o3kyB1vA7BhtW+foS+q2z9QavqWaQB
         nwGMegSRHV2X8sF23WeFLiraIKKPfD0LU6KFRrEALZzZAS4RZ++HpbowVEkv+QLtq/8+
         7WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=xEM78DA9vAlG5zrPlRQ/Wkwq/r1WdumNRcvFYfR+/4k=;
        b=HYfOImv2qgGProRgfUuUo8X2BHax0R9IPrnP6OSm9pUX/+hxl9Na6PGPlGq3sauqUe
         FmN8Xw9nodknNtrcCs2co5EaiVdnAfgaSYD7hlqj8CkUcJEDmthveiIShZbjjfSmEV1X
         pWRH6ba3xMWH8tWg0I9Oz5NHDRIYauoE6bqka0BCbIliN/LaUp01kSORYgFfocwqFXh4
         BZnPoyCIAKr7yyWQMEJb4lB47FyfYvIQMiQOgdCkVtinLEvzoMm4zVvjKKczHLli4mlq
         fKP8B9kDM63vzeCYs71o+v7IlBU6wOgUKUBw5EFGKK5PxnD3S9el/qzDI09+6qix80xr
         kEfQ==
X-Gm-Message-State: ACrzQf0VZY7lxaBZ5YB2f7YA8IHvikyD3WMt49GZ6i3Rx7kpvPONfFFR
        1VHJFjh+Pi1dQPbKVhxdpzsUfqYT9BRrXw==
X-Google-Smtp-Source: AMsMyM5pPDPDmF2J68WEvPqi90QvXe2UnVhiDy+hiqBKY04rvxmEGTgYfKHdvciCrekfDlsD2mLa3w==
X-Received: by 2002:a05:6a00:16c4:b0:535:890:d4a with SMTP id l4-20020a056a0016c400b0053508900d4amr21412019pfc.0.1663635360679;
        Mon, 19 Sep 2022 17:56:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902d0d300b0017534ffd491sm8805pln.163.2022.09.19.17.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 17:56:00 -0700 (PDT)
Date:   Tue, 20 Sep 2022 00:55:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 9/9] KVM: x86: never write to memory from
 kvm_vcpu_check_block
Message-ID: <YykPnPrjqann+L2i@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811210605.402337-10-pbonzini@redhat.com>
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

On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
> it cannot sleep.  Writing to guest memory is therefore forbidden, but it
> can happen on AMD processors if kvm_check_nested_events() causes a vmexit.
> 
> Fortunately, all events that are caught by kvm_check_nested_events() are
> also recognized by kvm_vcpu_has_events() through vendor callbacks such as
> kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
> remove the call and postpone the actual processing to vcpu_block().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e9358ea112b..9226fd536783 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10639,6 +10639,17 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  			return 1;
>  	}
>  
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * Evaluate nested events before exiting the halted state.
> +		 * This allows the halt state to be recorded properly in
> +		 * the VMCS12's activity state field (AMD does not have
> +		 * a similar field and a vmexit always causes a spurious
> +		 * wakeup from HLT).
> +		 */
> +		kvm_check_nested_events(vcpu);

Continuing the conversation with myself, this "needs" to check the return of
kvm_check_nested_events().  In quotes because KVM just signals "internal error"
if vmx_complete_nested_posted_interrupt() fails, i.e. the VM is likely dead anyways,
but again it's odd that the return of kvm_apic_accept_events() is checked but the
direct call to kvm_check_nested_events() is not.

> +	}
> +
>  	if (kvm_apic_accept_events(vcpu) < 0)
>  		return 0;
>  	switch(vcpu->arch.mp_state) {
> @@ -10662,9 +10673,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu))
> -		kvm_check_nested_events(vcpu);
> -
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted);
>  }
> -- 
> 2.31.1
> 
