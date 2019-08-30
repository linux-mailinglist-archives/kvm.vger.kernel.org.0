Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB701A3E50
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfH3TUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 15:20:24 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38925 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfH3TUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 15:20:24 -0400
Received: by mail-io1-f67.google.com with SMTP id d25so13745542iob.6
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 12:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ghc+Y7KC/JL0kIuErPPmtJFs6rOGq3txjiEyho7K71k=;
        b=C6DTMXF7Tjr03tBixG1JVpqS+w3zHgrfwDwcUZSo0b1qqPqQug/5pM5al90+3axB0u
         KYYKtlFDUkXVO3eLSWG1Rzsw5j6rrY2x5z2YDca7F66WWoxD7HyBYta7hDMenXLwQ5wS
         iSTb+qhyKw2+lZ3UPjKyeeW1OFWEmmYLxhzXU0q7KRionaGupVuNCzvtSMVXyjq/LLtk
         KCIsFuIKW8BDXPksFolfryRKX2AEbwv2/EKyNcw4A+vObHn1f6GFxzt2PFwY4sRDi7be
         Q5f/XZvM9VlNknnWf/k0zoLN/lvBAUYg69Pe7yNDg9UOdZH46Lfc6Sp12rJcEnSeHJjW
         jVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ghc+Y7KC/JL0kIuErPPmtJFs6rOGq3txjiEyho7K71k=;
        b=sUq+31/i8kpriDJfa7rd4Nd3fZe1DubTQxO12tWbVuDZCpu4HCZnnN2DobwJN2alJx
         sZknowa745WkzFkCzoam9NdAT70e6bdmr+TfswZZm2UxNeaK/3E99l++zXvfRcjaeYWe
         rwRlB6yldyBoSYQge+HTS84AbhRpEhNvIXCV9vMS/58H70Yl4P9vdsir2EthMs1egLtj
         DguVEud7K1uSYr3QcAF8966g6/HJyiA5+W/dGwHH/qm/PK1VBVa+nP91lQwiz5VRg6wy
         JE/pLFr+4VfEP9ZZgocwBElTG8XHSX4rQ71XoaWHi0u2t8eLOfJBlIB8/ChCGP7B4EL/
         FnXQ==
X-Gm-Message-State: APjAAAX/0o7NU5vOAAQm7vpUBznvIbZltRu3MzecXEywrC4isaQUcdbD
        iJKM4u2qrzNiAulm4gE8fxfUnQkfoeH7X+tG659DVw==
X-Google-Smtp-Source: APXvYqxBWOWE74Ovp4Id6ZL+IHd/imdLMWBCq1e5yTvXCKJXP8/67gPUcwVrIU6VwxWbjyFR2r9oXZawZf+YioOcv/M=
X-Received: by 2002:a6b:6a15:: with SMTP id x21mr7237557iog.40.1567192823002;
 Fri, 30 Aug 2019 12:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com> <20190828234134.132704-4-oupton@google.com>
 <20190830182634.GF15405@linux.intel.com>
In-Reply-To: <20190830182634.GF15405@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Aug 2019 12:20:12 -0700
Message-ID: <CALMp9eRi-8TGEYi9Vj3HsHHrHnPCiqhRxHYr0=FxyEPrmUjYKQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] KVM: VMX: Add helper to check reserved bits in MSR_CORE_PERF_GLOBAL_CTRL
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 11:26 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Aug 28, 2019 at 04:41:30PM -0700, Oliver Upton wrote:
> > Creating a helper function to check the validity of the
>
> Changelogs should use imperative mood, e.g.:
>
>   Create a helper function to check...
>
> > {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL wrt the PMU's global_ctrl_mask.
>
> As is, this needs the SDM quote from patch 4/7 as it's not clear what
> global_ctrl_mask contains, e.g. the check looks inverted to the
> uninitiated.   Adding a helper without a user is also discouraged,
> e.g. if the helper is broken then bisection would point at the next
> patch, so this should really be folded in to patch 4/7 anyways.
>
> That being said, if you tweak the prototype (see below) then you can
> use it intel_pmu_set_msr(), in which case a standalone patch does make
> sense.
>
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/x86/kvm/pmu.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 58265f761c3b..b7d9efff208d 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -79,6 +79,17 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
> >       return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
> >  }
> >
> > +static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_vcpu *vcpu,
>
> If this takes 'struct kvm_pmu *pmu' instead of a vcpu then it can also
> be used in intel_pmu_set_msr().
>
> > +                                              u64 global_ctrl)
> > +{
> > +     struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +
> > +     if (pmu->global_ctrl_mask & global_ctrl)
>
> intel_pmu_set_msr() allows 'global_ctrl == data' regardless of the mask,
> do we need simliar code here?

Indeed. For all of the special-cased MSRs in the VMCS, the validity
checks should be the same as those performed by WRMSR emulation.

> > +             return false;
> > +
> > +     return true;
>
> Or simply
>
>         return !(pmu->global_ctrl_mask & global_ctrl);
>
> > +}
> > +
> >  /* returns general purpose PMC with the specified MSR. Note that it can be
> >   * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
> >   * paramenter to tell them apart.
> > --
> > 2.23.0.187.g17f5b7556c-goog
> >
