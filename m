Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEEE673DB3
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjASPkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjASPkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:40:01 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF707E4B9
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:40:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b10so2787466pjo.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGOd0msiKtPUi40NQhnTui7LovvqqH6CkT8xmcG9Sh0=;
        b=lBWFm5Uo5P0QadyGJPq0BdNWny0S9CmUSXifqJ164PxXfsiRpZX2Q97uTwvkRYQWDt
         cG2MZOQUxJUbPfAL/6URMwZ/yupofag2v3DpLfGLDc1GIaoSmsqO3LA36robK53PDUcD
         k/ifV9u59dZJWRcvg3YkquWH5sIJY7N6VmUYsSEvoCQxHGQ5yNalNwdPESJGNzhVa8UR
         W/40/5KtTwcJeSiCk9nIEEj6R1MiK4fftjG2OqqkdL2wGo2Bq0ZE9S4iWrs+aM2gkW/1
         W4CxNKDoLofq0NPwf0lsA9elH+W36loAVQ23H7U7O1+Y5gLke5XJqGFtXj827FQCYU63
         3abQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGOd0msiKtPUi40NQhnTui7LovvqqH6CkT8xmcG9Sh0=;
        b=6/ctITxK1s+BT9FrJu01SALSkfBiFYPVST3XR24umHK0Pmh5wD32YouZ749EVxBGpZ
         kA97jKV3hnqroCqhqBWQpyHOI7MEUyXpm3ZnMvzjzRITROxVmfLblaoY0M3YG1XAqbIQ
         F240G329nwKt5t8OBLklNcOLW/E39PLmPXpd9EgEg849fQe8nWsLk+AiJkkyJJDcIuYs
         YAX9jmRCvOCOYDzuEMsqo3EeUi/A+xP6gAHS76fz+YGpRemU3avE4rd52rjAyRvs1eOI
         2jRotu+hNB0uCtmGAtSWzOa32d0zicfpHk5Zpc/dDPQl4KVTc+IUzIuAJkVSNa1iu+HN
         Hs1A==
X-Gm-Message-State: AFqh2kqWv/GZ1EYfrENJOiHsHN3G3D3HgjB0qBsN6uMC4U9vMei9/Qga
        hctoWVUuXsxuo6yiTHLCXzLvHQ==
X-Google-Smtp-Source: AMrXdXsWEa0QHcWC97605RHISqaUh563ZfBKmW2ev1RfduDhsP0SlTmgpAwu9ewNf+AacpTR7KiFhQ==
X-Received: by 2002:a05:6a20:c527:b0:9d:c38f:9bdd with SMTP id gm39-20020a056a20c52700b0009dc38f9bddmr3288869pzb.2.1674142799917;
        Thu, 19 Jan 2023 07:39:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 201-20020a6303d2000000b004b4d4de54absm16613532pgd.59.2023.01.19.07.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:39:59 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:39:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
Message-ID: <Y8lkS2XUBBrcjNku@google.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-8-seanjc@google.com>
 <Y8kSLBwUuqzlcSEZ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8kSLBwUuqzlcSEZ@hirez.programming.kicks-ass.net>
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

On Thu, Jan 19, 2023, Peter Zijlstra wrote:
> On Tue, Dec 13, 2022 at 06:09:12AM +0000, Sean Christopherson wrote:
> 
> > @@ -7119,6 +7118,18 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  
> >  	vmx_enable_fb_clear(vmx);
> >  
> > +	if (unlikely(vmx->fail))
> > +		vmx->exit_reason.full = 0xdead;
> > +	else
> > +		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
> > +
> > +	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> > +	    is_nmi(vmx_get_intr_info(vcpu))) {
> > +		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> > +		vmx_do_nmi_irqoff();
> > +		kvm_after_interrupt(vcpu);
> > +	}
> > +
> >  	guest_state_exit_irqoff();
> >  }
> 
> I think we're going to have to sprinkle __always_inline on the
> kvm_{before,after}_interrupt() things (or I missed the earlier patches
> doing this already), sometimes compilers are just weird.

It's in this patch, just lurking at the bottom.

> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..44d1827f0a30 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -382,13 +382,13 @@ enum kvm_intr_type {
>         KVM_HANDLING_NMI,
>  };
>
> -static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> -                                       enum kvm_intr_type intr)
> +static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> +                                                enum kvm_intr_type intr)
>  {
>         WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);
>  }
>
> -static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
> +static __always_inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
>  {
>         WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);
>  }
