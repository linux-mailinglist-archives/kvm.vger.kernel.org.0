Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B7E4B0081
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 23:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiBIWnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 17:43:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiBIWnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 17:43:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD9DE019272
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 14:43:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so3751875pjm.2
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 14:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=noMkqdTonhMUp9fT8zd3GJsejZVy8dW1w0VkTntk/8Y=;
        b=bHNRLw+OXy+JodwNMwa69BC1zFb8359yF6+/aSWs/bwszNylIZ0siC6/EmVOeJglKh
         H3o/LrFlf8t3pk9303gznetfLGDEFh2lz/MgmHk5/NIi8AckRL2EYEWWCFzWMeJTSMCz
         +eyK9gIuqwgyMjhkDNYgP66k4dyvVwD2ruIOxsnTD/nCrkhLvekAFoTm5k2tMVf8N++w
         jGCZqjJMsAmdtP1RTj71TkUx78nyb3BcpfVLkTOTfNOwOhEVAI29JWyRtPqix7+LEzMz
         Wo+ntyiWbg9YA84BAysTyhZJCXWYjm8vHq8WSpYY7j08PR0iK9ixJiw85MO7ZXIG+J9C
         aRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=noMkqdTonhMUp9fT8zd3GJsejZVy8dW1w0VkTntk/8Y=;
        b=N5vm4beOXmpiessLR2apTvviFGfMqRTlgQ0lImMjS+PefqSa+2jcLbNz4yr0nKakIt
         wmBRrd3reZZq9nhQneQXjXvIWpZiz2gq+32/bdl9BfWQoOV3ulla0IQ0R1XUBDquPUVx
         MkOJmCn5u1pFOfU/A+9BqslP6+BpROkzuURgIzcBmR1KOGHaosX8/6OtR9D2Nl7Zcxho
         eDF7bGkyXWqzUj36dp1J8KBT+fzzBrjXKVOfTGwUieC+L5Zs7OM5UCz7RXgchp9O51UK
         m7u5I9OgCxaRXmF/i+KdMJc0wNYvTP2k9lLsnLc7By5CfD9US2fIFWszKpaHoOmTgMeU
         TQeQ==
X-Gm-Message-State: AOAM531Kwoxb6ae2DuN2nHyHvRASV3vKjU5yqyBC95hIeGxKHa7Wp1/6
        ayx/NSj6yWOCDjP/bXw1CrMMo6vCQlWyiA==
X-Google-Smtp-Source: ABdhPJw7V1tbuSaIRjHHEsNYjQudgK7dt21qZMZDxlNK9KY1aeYFg0uYMJ7CI4qoGq0jmiaHVuJ0Ww==
X-Received: by 2002:a17:902:7ecf:: with SMTP id p15mr4523948plb.112.1644446590881;
        Wed, 09 Feb 2022 14:43:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p16sm14695437pgj.79.2022.02.09.14.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:43:10 -0800 (PST)
Date:   Wed, 9 Feb 2022 22:43:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH 02/23] KVM: MMU: nested EPT cannot be used in SMM
Message-ID: <YgRDenzMI49hcss1@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-3-pbonzini@redhat.com>
 <Yf1tY8kNzZDRtH3e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yf1tY8kNzZDRtH3e@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:56:57AM -0500, Paolo Bonzini wrote:
> > The role.base.smm flag is always zero, do not bother copying it over
> > from vcpu->arch.root_mmu.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> 
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 9424ae90f1ef..b0065ae3cea8 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4881,9 +4881,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
> >  {
> >  	union kvm_mmu_role role = {0};
> >  
> > -	/* SMM flag is inherited from root_mmu */
> > -	role.base.smm = vcpu->arch.root_mmu.mmu_role.base.smm;
> 
> nit: Retaining a comment here and/or warning here would be useful.
> 
> 	/* EPT is not allowed in SMM */

EPT _is_ allowed in SMM, KVM just doesn't support it.  Specifically, KVM doesn't
emulate Parallel SMM, a.k.a. Dual-Monitor Treatment of SMIs.  Probably worth
calling that out in the changelog.  If there's a WARN, then we don't really need
a comment as blame will get someone to the "why" if they're really curious, and
most people probably would only be confused about parallel SMM comments.

> 	WARN_ONCE_ONCE(vcpu->arch.root_mmu.mmu_role.base.smm);

+1 to a WARN, if only to provide a paper trail for git blame.  Finding when
something is purely deleted is painful.

> 
> (Although I imagine it would just get removed later in the series.)
> 
> > -
> >  	role.base.level = level;
> >  	role.base.has_4_byte_gpte = false;
> >  	role.base.direct = false;
> > -- 
> > 2.31.1
> > 
> > 
