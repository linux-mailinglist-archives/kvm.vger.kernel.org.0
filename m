Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563E43892F5
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354974AbhESPuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354552AbhESPud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 11:50:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1B0C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 08:49:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n8so2048010plf.7
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fzzsEWGkXSsJ9I1epD5kqjbD+mKgK9dwfaWHAcXTDQ=;
        b=M/7YvnwM8QrnHOcBf6BuPkQI2Lb25QR+EjsnMO16qcf0iUI/jzn9mIHj9WtBj8QzLR
         Uc5P42EC+vXNcUuziM5rccL3fKi/gC/hkocKWTgMIplnr8mv82dMe2JtyBtkMUIcLPWz
         FZpkAuB3muTtwnzLS8NtSiVCIqoMfKrQPXnsdYAhPrqkTB9VjCD4rGdrF3Qey+iGhhnQ
         W2k3HgHvyBHs5b6NYWKPbqggxk9GF8MQNAjZ019lWUZDTuG23Mm7Avgto8itSwrO+Cz/
         a6dclhTWdTxIvW6IqVjmWXzmenyrMO9Qr5zEDC/Pb1XUlmJYf5e6gVo9xlAPiq4Cxdn+
         ZnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2fzzsEWGkXSsJ9I1epD5kqjbD+mKgK9dwfaWHAcXTDQ=;
        b=M1oFnCimsOJPgk4Tzb4eNn1AGNcxRJP/glolsBKJAy9pT+FGTPWIjZw15SGgGBGmGb
         XIq0LB9lGCGZxpZIvWqF1nkJJMzluTueXWE8XBR8I6wCXumCrE1EtKMfqyJ1QqrE6fWp
         ssgQ9dNSxkv3U2M9BbjiKBG7wqgM5Kzmipk9tEKrTWEeRM61024yYiMe4wjA4nf2xXRy
         yC6hzyedJJyA/7VJ2lWfmjXTBpCnKGkjhcSLXPzWVh13tNqLxuzjO9bJ4IUbXQ05IIWx
         7bAX3CgcYDmmkhpgL/8NnXb+HVntFseDXLjjoXh7047jzp7DBM/tyP+mkBft3WflMUFp
         S2OQ==
X-Gm-Message-State: AOAM532UqMMmqHp+Ld6MvyRwSsuUBGC9CFW0UUzQm+IbnRyVuQKiNLGG
        dlk4NFFUUg3VCU2c0oHzwEbuLQ==
X-Google-Smtp-Source: ABdhPJwVbtTn69uWgexFTvEV1CdB0wgdLr0bJMiRGRKhHacryVRGqjoMfgRHepnmaf4racrmMWjc1g==
X-Received: by 2002:a17:902:ea03:b029:ef:adb3:a6ab with SMTP id s3-20020a170902ea03b02900efadb3a6abmr26041plg.47.1621439351706;
        Wed, 19 May 2021 08:49:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y69sm14317590pfb.162.2021.05.19.08.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 08:49:11 -0700 (PDT)
Date:   Wed, 19 May 2021 15:49:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v2 07/10] KVM: X86: Move write_l1_tsc_offset() logic to
 common code and rename it
Message-ID: <YKUzc4WJlxvyzw5B@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-8-ilstam@amazon.com>
 <YKRWNaqzo4GVDxHP@google.com>
 <e9f32ea05762ad8b87b1f8e6821ca2c8a4077bbc.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f32ea05762ad8b87b1f8e6821ca2c8a4077bbc.camel@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Stamatis, Ilias wrote:
> On Wed, 2021-05-19 at 00:05 +0000, Sean Christopherson wrote:
> > On Wed, May 12, 2021, Ilias Stamatis wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 1db6cfc2079f..f3ba1be4d5b9 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2377,8 +2377,23 @@ EXPORT_SYMBOL_GPL(kvm_set_02_tsc_multiplier);
> > > 
> > >  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > >  {
> > > +     trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> > > +                                vcpu->arch.l1_tsc_offset,
> > > +                                offset);
> > > +
> > >       vcpu->arch.l1_tsc_offset = offset;
> > > -     vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
> > > +     vcpu->arch.tsc_offset = offset;
> > > +
> > > +     if (is_guest_mode(vcpu)) {
> > 
> > Unnecessary curly braces.
> 
> Really? We are supposed to have a 6-lines body without brackets? I'm not
> opposing, I'm just surprised that that's the coding standard.

Comments don't (technically) count.  I usually avoid the ambiguity by putting
the comment above the if statement.  That also helps with indentation, e.g.

	/*
	 * This is a comment.
	 */
	if (is_guest_mode(vcpu))
		kvm_set_02_tsc_offset(vcpu);

> > > +             /*
> > > +              * We're here if L1 chose not to trap WRMSR to TSC and
> > > +              * according to the spec this should set L1's TSC (as opposed
> > > +              * to setting L1's offset for L2).
> > > +              */
> > 
> > While we're shuffling code, can we improve this comment?  It works for the WRMSR
> > case, but makes no sense in the context of host TSC adjustments.  It's not at all
> > clear to me that it's even correct or relevant in those cases.
> > 
> 
> Do you suggest removing it completely or how do you want it to be? I don't
> mind deleting it.

Heh, I'd happily write the comment, except I have no idea what the logic is in
the non-WRMSR case.  I do think we need a comment, IMO none of paths that lead
to changing the TSC offset while L2 is active are obvious.
