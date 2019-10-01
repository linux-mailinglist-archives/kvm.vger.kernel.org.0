Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D9C3766
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 16:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388987AbfJAOaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 10:30:13 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43031 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388965AbfJAOaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 10:30:13 -0400
Received: by mail-io1-f66.google.com with SMTP id v2so48357445iob.10
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dA2LfRIGoffEi6e/trDGXZZsQS5EjYWmp4CzTn5oPEk=;
        b=ru8l+MiFe0uxae7CzGyGkm95G4hi87/F8EHtAJGL5zhFx8MPmm2hQaH/4JmSmGLoJx
         wSBEkH6DlVKE4w9EdEsNW3r1s4Afk9Xxvs+8S8t6Gy0GQS5GPtWGKA5/s0BbMuZb2nWM
         QTWNjYmWcnLD3g8vKSeKe43a3FDoIgIoiICitLfDajqBcYAqorNoaqISkz6RiyR7DL3N
         Q8qqiT2So/qw8CmnnsU5ztj7BYAI1RUc2pv2oczzUbEPd18QAA+QgYDuZk09hXY/2Etc
         KC0QvYdSe9EZTKrX7mqkwSRPnMVtgf75A28iHmZttB/8RG6fCtN4P5/371AjyvXvixtH
         y3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dA2LfRIGoffEi6e/trDGXZZsQS5EjYWmp4CzTn5oPEk=;
        b=WaNehyD31Ct5JsRyRXU4YSUkMs5yyyr3uWbxBVJEc9+gFir1kDW6NtOeYS/RrVWQEN
         cSogVhmrQ2V95ELT0hcH40aqdQXoDHu54pn3HLP79vhwP1naITQHtIVRHbLToLDNGagh
         hEUHTSKvEie23iuB6C0TZBMHchKnXNcViN9O80iZp2QqGo3Ib52Q5a73TID2lNsb29n+
         sUKV4C6sZwzBw5TD8mR3IGLn4aLuebj+/MYiZbRVvQ3VQBxhfHunjlGrlS9nQ6j/zOaf
         Lx6fSp3Wf0JUlpuwEE4VHr8wN0RxZnIy2j1hPEG5LdNFtwJqbfMDholW3BRI7Nzm1saG
         BgOg==
X-Gm-Message-State: APjAAAV0ksKQcLNbR/9nGKmAgfCmP4Q+U1VzVdcEpREeD1uDdmXWoZfN
        VSJvIMuAbzN8vC+N4kX0GDIbDQ5GuFnl6VbvB2oWxg==
X-Google-Smtp-Source: APXvYqycE3v06jZkRnvCfN0psatT+dZhlvH0vo17HvnA2GeszMRgF9/Bq+lsCPAwEs2yGRg899jwIYpidjn7BheKbkQ=
X-Received: by 2002:a92:5e0b:: with SMTP id s11mr26984022ilb.26.1569940212259;
 Tue, 01 Oct 2019 07:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190930233854.158117-1-jmattson@google.com> <87blv03dm7.fsf@vitty.brq.redhat.com>
 <08e172b2-eb75-04af-0b63-b0516c8455e1@redhat.com> <CALMp9eRu42dSwuZ5ZoGmPd9A5qw7wJmfh-OhCUFaWEke2vcHkg@mail.gmail.com>
 <89918126-97f6-37ff-9d28-68440a15b710@redhat.com>
In-Reply-To: <89918126-97f6-37ff-9d28-68440a15b710@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 07:30:00 -0700
Message-ID: <CALMp9eTZtHTWyEth7Hm1=goZask8viJ_3XuOF=UQKeLbqBABKQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 1, 2019 at 7:24 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/10/19 16:07, Jim Mattson wrote:
> > On Tue, Oct 1, 2019 at 6:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 01/10/19 13:32, Vitaly Kuznetsov wrote:
> >>> Jim Mattson <jmattson@google.com> writes:
> >>>
> >>>> KVM can only virtualize as many PMCs as the host supports.
> >>>>
> >>>> Limit the number of generic counters and fixed counters to the number
> >>>> of corresponding counters supported on the host, rather than to
> >>>> INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.
> >>>>
> >>>> Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
> >>>> contiguous MSR indices reserved by Intel for event selectors. Since
> >>>> the existing code relies on a contiguous range of MSR indices for
> >>>> event selectors, it can't possibly work for more than 18 general
> >>>> purpose counters.
> >>>
> >>> Should we also trim msrs_to_save[] by removing impossible entries
> >>> (18-31) then?
> >>
> >> Yes, I'll send a patch in a second.
> >
> > I thought you were going to revert that msrs_to_save patch. I've been
> > working on a replacement.
>
> We can use a little more time to think more about it and discuss it.
>
> For example, trimming is enough for the basic usage of passing
> KVM_SET_SUPPORTED_CPUID output to KVM_SET_CPUID2 and then retrieving all
> MSRs in the list.  If that is also okay for Google's userspace, we might
> actually leave everything that way and retroactively decide that you
> need to filter the MSRs but only if you pass your own CPUID.
>
> Paolo

If just trimming the static list, remember to trim to even less than
18, since Intel has used one of the reserved MSRs following the event
selectors for something else. I was going to follow Sean's suggestion
and specifically enumerate all of the PMU MSRs based on CPUID 0AH.
