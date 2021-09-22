Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA15414C4B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbhIVOqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbhIVOqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:46:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDD4C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:44:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso2471829pjb.3
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k92i1CTT4UfLIvqoj9NDLUAGbjRSVGtjE0AGo1vSZmQ=;
        b=f4lwilm8F32Il0kw2q+o2S5gn8bX330s+QqjMwYgJsMXJx2nLKL8EyWd3+MfL2K9jX
         0tGZwNvTXYGj36wKXNRWv7f2/8WtblkGM8adydd7zCEXJGRgzSafRw0/O5bJe3dDxQQ7
         U6i6z0ifislGQqzGxuWjmB4KG9fM9SillTMfXqaBzcnu4xfTxwQwb9DhTuwjk8oShc1N
         jmvJCl5gNVv2BNfFOnt3eTgLyXM+NbWeomDRALyfRFD5e79waLuLKw5bLUrghLsJW9+c
         416hVoGg/lJKH5l5wbmxWkJQPlcGZB1pD/Mw8bTjlh40CsuIN/vh+c8yxxUJ2SyTVGzx
         o6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k92i1CTT4UfLIvqoj9NDLUAGbjRSVGtjE0AGo1vSZmQ=;
        b=SRkQktL0mrNPaqG3lLBteX7BKfMOp11VL+4s9Wp8IQycA5m4Te0j/w+5pcWNQyfEg/
         FolXforh3aACk9LsaJQFifChFOjGIyvhAbjitFMexykW1F30/FLWy/pyqhn32L4tZRci
         pg2qL+4LDn2t0FrKx2JHiiitNzuxcEGa7vhrp5NGiGmEwaGAc4MKwsQo6j65NjD/jC+C
         BikPiNmvn8ai6eu18iV7rU6hdu3aG0r+i6etXhL82hWDFsOH+XkibfzOe+WU59H1bQPO
         IPw+DepHuUp5d2mpXSbwNLQISgStyJwg6RH2EHbPivoRvT0C809RoVzA9xBiBpFI0At6
         X5/g==
X-Gm-Message-State: AOAM530UbesfufzKXBN+v2LAL8CUSnQ+BqYDXarZInMrOwPUdF6gm3OJ
        E7Csl9eofaYMJQl9+5o17Gn/IQ==
X-Google-Smtp-Source: ABdhPJy6Cm8J5yFpuY0b3Q26cuBfzP0jR3SXJy8Sit4o8X0PGq0Nl30V3OZC+YaU8p9jHy4oX17FmA==
X-Received: by 2002:a17:902:8606:b029:12c:2625:76cf with SMTP id f6-20020a1709028606b029012c262576cfmr223350plo.17.1632321871110;
        Wed, 22 Sep 2021 07:44:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d14sm2901977pfq.61.2021.09.22.07.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:44:30 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:44:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset
 values
Message-ID: <YUtBSvC97RPD4iRD@google.com>
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-3-oupton@google.com>
 <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
> > +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> > +{
> > +       struct kvm_vcpu *vcpu = ctxt->vcpu;
> > +
> > +       switch (arch_timer_ctx_index(ctxt)) {
> > +       case TIMER_VTIMER: {
> > +               u64 host_offset = timer_get_offset(ctxt);
> > +
> > +               host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> > +               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> > +               timer_set_offset(ctxt, host_offset);

Really getting into nitpicking territory, but it maybe name this
timer_set_virtual_offset() (assuming v=virtual and p=physical).  Based on the
name, I expected this to set a variable literally named guest_offset, but it
reads and writes host_offset.  Maintaining the virtual vs. physical terminology
all the way down avoids having direct host vs. guest naming conflicts, i.e.
virtual and host aren't generally though of as mutually exclusive.

> > +               break;
> > +       }
> > +       default:
> > +               WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> > +       }
> > +}
> > +
> >  u64 kvm_phys_timer_read(void)
> >  {
> >         return timecounter->cc->read(timecounter->cc);
> > @@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
> >
> >  /* Make offset updates for all timer contexts atomic */
> >  static void update_timer_offset(struct kvm_vcpu *vcpu,
> > -                               enum kvm_arch_timers timer, u64 offset)
> > +                               enum kvm_arch_timers timer, u64 offset,
> > +                               bool guest_visible)
> 
> The name 'guest_visible' looks confusing to me because it also
> affects the type of the 'offset' that its caller needs to specify.
> (The 'offset' must be an offset from the guest's physical counter
> if 'guest_visible' == true, and an offset from the host's virtual
> counter otherwise.)
> Having said that, I don't have a good alternative name for it though...
> IMHO, 'is_host_offset' would be less confusing because it indicates
> what the caller needs to specify.

I'd say ditch the param altogether and just have two separate helpers.  Even in
the final code, the callers all pass explicit 'true' or 'false', i.e. the callers
can just as easily call a different function.

Despite the near-identical code, smushing guest and host into the same function
doesn't actually save much, just the function prototype and the local variables.

That'd also avoid having to document/comment what 'true' and 'false' means at the
call sites.

> >  {
> >         int i;
> >         struct kvm *kvm = vcpu->kvm;
> > @@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
> >         lockdep_assert_held(&kvm->lock);
> >
> >         kvm_for_each_vcpu(i, tmp, kvm)

This needs braces if you keep it as is.
> > -               timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> > +               if (guest_visible)
> > +                       timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> > +                                              offset);

Let this poke out, 84 chars isn't the end of the world.

> > +               else
> > +                       timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> >
> >         /*
> >          * When called from the vcpu create path, the CPU being created is not
> >          * included in the loop above, so we just set it here as well.
> >          */

Any reason this can't be called from kvm_arch_vcpu_postcreate()?  That'd eliminate
the need for the extra handling.  The vCPU is technically visible to userspace, but
userspace would have to very intentionally do the wrong thing to cause problems,
and I don't see any obviosu danger to the host.

> > -       timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> > +       if (guest_visible)
> > +               timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> > +       else
> > +               timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> >  }
> >
