Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB35DA3EAC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfH3Tua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 15:50:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37968 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfH3Tu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 15:50:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id e11so4035719pga.5
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 12:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UJQaDOFEm5QjBkfUovYTVpdbuhQzVCTMOy7gOIwZQr4=;
        b=GkA5TmbzJj+EN9qIzpT/V4PQZu+gIO7aA+Cjbptv4ztcuUy3TnfPY7eHmOkusL+gE5
         Kw8zPgQuqYW6ELW9Q+x169AfRmHzcZfdvS/mGYqmmbkEiA1gVWJh8AY7RmfzCIwx3uGG
         SBKflWbc4iyKFuHqXLncqWqUu/o1z53Qon83w8s5dyc4+nGXQmPYz5SUONI4WyFiwuHd
         wZQhAIF9zyBOaJO3utscrp4A/bDziZ/SHA47MO80hFKpO1TzPp1Lou4GRKoun6GtY9CJ
         jFXgX6QKrK4SkgSwsoVzPobDAOySDcXlrO4sbOKUecDgiQllqtrPoJWV1YQUJrPqyG9U
         SrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UJQaDOFEm5QjBkfUovYTVpdbuhQzVCTMOy7gOIwZQr4=;
        b=ErdfDN/La5wwSHBm8j4mhWSuuiOtCF0KeNPX2IfG81AZG85Saw2SyYCx1w2EHKfaEP
         DupEyto6GSyNTU1aGM0d0jOw79Z26y/vhbciPLH5y3LeXZzSu8pKXjfblyCXYggylVv9
         EjCt5ZhLg5qKGIPvnqDAn+OaSy57omqeo+GDFn5wwx/kVwcKMW7BhiTwFntVF2/z2rSq
         EDdwpCl1v/q7SaoH/cevw4Yd7saQ2eEg2v4uflMiU5JBYeGR8qGrks3MHITDtKjn9xgA
         UXcF2HtqzcSpV3CyCALbb9nLVjLhX6e+FDegvLzjP/xwKEI6h6q4iKiqo6Vbrv7suQPH
         VDBg==
X-Gm-Message-State: APjAAAUvZCbKN9JlWzqZr01VPbjGRgdU5He8N8HK7dWKvJ7t8bqZnCeH
        hEASSUgLfENIowJGx7Td9wDv3A==
X-Google-Smtp-Source: APXvYqz1VqNYs1/wF6ET3VLVIxouhmYOWTTrrjixLyPdbgjC+7iLr9KqtHRCyHhveCBp2BQQs/sC5Q==
X-Received: by 2002:a63:e807:: with SMTP id s7mr13876041pgh.194.1567194628608;
        Fri, 30 Aug 2019 12:50:28 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id dw7sm5621060pjb.21.2019.08.30.12.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 12:50:27 -0700 (PDT)
Date:   Fri, 30 Aug 2019 12:50:24 -0700
From:   Oliver Upton <oupton@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 3/7] KVM: VMX: Add helper to check reserved bits in
 MSR_CORE_PERF_GLOBAL_CTRL
Message-ID: <20190830195024.GA257167@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-4-oupton@google.com>
 <20190830182634.GF15405@linux.intel.com>
 <CALMp9eRi-8TGEYi9Vj3HsHHrHnPCiqhRxHYr0=FxyEPrmUjYKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRi-8TGEYi9Vj3HsHHrHnPCiqhRxHYr0=FxyEPrmUjYKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 12:20:12PM -0700, Jim Mattson wrote:
> On Fri, Aug 30, 2019 at 11:26 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Aug 28, 2019 at 04:41:30PM -0700, Oliver Upton wrote:
> > > Creating a helper function to check the validity of the
> >
> > Changelogs should use imperative mood, e.g.:
> >
> >   Create a helper function to check...
> >
> > > {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL wrt the PMU's global_ctrl_mask.
> >
> > As is, this needs the SDM quote from patch 4/7 as it's not clear what
> > global_ctrl_mask contains, e.g. the check looks inverted to the
> > uninitiated.   Adding a helper without a user is also discouraged,
> > e.g. if the helper is broken then bisection would point at the next
> > patch, so this should really be folded in to patch 4/7 anyways.
> >
> > That being said, if you tweak the prototype (see below) then you can
> > use it intel_pmu_set_msr(), in which case a standalone patch does make
> > sense.
> >
> > > Suggested-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/x86/kvm/pmu.h | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > index 58265f761c3b..b7d9efff208d 100644
> > > --- a/arch/x86/kvm/pmu.h
> > > +++ b/arch/x86/kvm/pmu.h
> > > @@ -79,6 +79,17 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
> > >       return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
> > >  }
> > >
> > > +static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_vcpu *vcpu,
> >
> > If this takes 'struct kvm_pmu *pmu' instead of a vcpu then it can also
> > be used in intel_pmu_set_msr().
> >
> > > +                                              u64 global_ctrl)
> > > +{
> > > +     struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > > +
> > > +     if (pmu->global_ctrl_mask & global_ctrl)
> >
> > intel_pmu_set_msr() allows 'global_ctrl == data' regardless of the mask,
> > do we need simliar code here?
> 
> Indeed. For all of the special-cased MSRs in the VMCS, the validity
> checks should be the same as those performed by WRMSR emulation.

Is the 'global_ctrl == data' check present to ensure that
global_ctrl_changed() is only hit when necessary, or is it a condition
to test for valid state?

I'm having a hard time seeing what returning true on 'global_ctrl ==
data' is giving us (in the context of emulating host/guest state checks
on vm-entry). Also, intel_pmu_set_msr() will still need to check it
anyway to decide if it needs to call global_ctrl_changed().

Either way, the check against mask condition can be shared through a
common helper with Sean's suggested tweak to the prototype.

> > > +             return false;
> > > +
> > > +     return true;
> >
> > Or simply
> >
> >         return !(pmu->global_ctrl_mask & global_ctrl);

I'll go this route in the next series.

> > > +}
> > > +
> > >  /* returns general purpose PMC with the specified MSR. Note that it can be
> > >   * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
> > >   * paramenter to tell them apart.
> > > --
> > > 2.23.0.187.g17f5b7556c-goog
> > >
