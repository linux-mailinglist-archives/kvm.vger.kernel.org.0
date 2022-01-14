Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF048F220
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 22:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiANVvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 16:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiANVvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 16:51:24 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B01C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 13:51:24 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo15392697pjb.2
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 13:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CDsGS2jq8SAFd9OvPx49AGjFg/2s2ed5RyEVXzRWnAo=;
        b=cfjpva8bdcPLTTQoIPCixVnAFaxsDELlb/9JwStbXYQvRDZGYhfWD3/1KeCmYuq1Yy
         IupWGk+fR/uoJLiecnN6JvPjTin7H2Hska91lSfi0kRro7XHjZ6Rzw5/PBWb3KmK74HI
         6pCTKoDjaCjUtQcw4EmIb5Vfnyj3Gkuo0vj2jqbXi6WAKriAHyY1Sgq+jO+4eA5weoen
         ZrIWRe1oHnOOA/6QybWEb2IdUiv7mV9Bj9zx4zNCcwBb//Iynkc59wxBPmD0p9oUP07a
         L+eJCdTyRQg1pRPFhhLwPjoPg8fhQ884XaKcHU6+jI7Zd1mjfSkV4huFnNNCOGyPSI2t
         Jc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CDsGS2jq8SAFd9OvPx49AGjFg/2s2ed5RyEVXzRWnAo=;
        b=ahK3tLPIyJq0W5RhoR46NtzeRuVzRRndaf34qfHkbhT7pGA9TAGQPh/VVKu3ie2ikt
         HvjCufacd3UW/0le8n1+4kzEd6PAWVu4NlEDNmQpWnLCy8wfAgGV0e/xa6BfL/3rSwcA
         18DZiU3bVrkw/KfD21BFaM0fqBG1YkSrJ9wswFK9dUkkeinHzv9pWm4jAdjUduYxfV6D
         AzLBbuBjkrz/GiIj8V269XL8S11dmMbNg0TdOD7exYBj5tM6ZVtfifVEP6P+Hx8nh3tb
         zBONWaciX+KL+5yH3XKHuSdVOOedlqrmWrOC/vIpPapp1tVP/wrPpXAX396eOSZA8Oqs
         Kq9Q==
X-Gm-Message-State: AOAM531/4qgs+AlNHjwHAl99aemVI7H7ZB/sPYzwbn2dgjKlAPWlqpZ2
        Ca0CzBD3J9Ph59tSBQi+4/hW3AXcqDR4D18112tmsg==
X-Google-Smtp-Source: ABdhPJxoOISTy68Z7laSCPjCr0YLWiNLl+ousUKcH2g0/tuXUHAGX63U2SWCQe4kEq9CrnNG7uifRtzx5bVqMY3fqWc=
X-Received: by 2002:a17:902:ea10:b0:14a:6c29:a6a5 with SMTP id
 s16-20020a170902ea1000b0014a6c29a6a5mr11540567plg.172.1642197084066; Fri, 14
 Jan 2022 13:51:24 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com> <YeBfj89mIf8SezfD@google.com>
In-Reply-To: <YeBfj89mIf8SezfD@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 14 Jan 2022 13:51:07 -0800
Message-ID: <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Sean Christopherson <seanjc@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> > On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
> > > Perhaps it would help if you explained *why* you are doing this. It
> > > sounds like you are either trying to protect against a malicious
> > > userspace, or you are trying to keep userspace from doing something
> > > stupid. In general, kvm only enforces constraints that are necessary
> > > to protect the host. If that's what you're doing, I don't understand
> > > why live migration doesn't provide an end-run around your protections.
> > It's mainly to safeguard the guests. With respect to migration, KVM
> > and the userspace are collectively playing a role here. It's up to the
> > userspace to ensure that the registers are configured the same across
> > migrations and KVM ensures that the userspace doesn't modify the
> > registers after KVM_RUN so that they don't see features turned OFF/ON
> > during execution. I'm not sure if it falls into the definition of
> > protecting the host. Do you see a value in adding this extra
> > protection from KVM?
>
> Short answer: probably not?
>
> There is precedent for disallowing userspace from doing stupid things, but that's
> either for KVM's protection (as Jim pointed out), or because KVM can't honor the
> change, e.g. x86 is currently in the process of disallowing most CPUID changes
> after KVM_RUN because KVM itself consumes the CPUID information and KVM doesn't
> support updating some of it's own internal state (because removing features like
> GB hugepage support is nonsensical and would require a large pile of complicated,
> messy code).
>
> Restricing CPUID changes does offer some "protection" to the guest, but that's
> not the goal.  E.g. KVM won't detect CPUID misconfiguration in the migration
> case, and trying to do so is a fool's errand.
>
> If restricting updates in the arm64 is necessary to ensure KVM provides sane
> behavior, then it could be justified.  But if it's purely a sanity check on
> behalf of the guest, then it's not justified.

The pseudo firmware hvc registers, which this series are adding, are
used by KVM to identify available hvc features for the guest, and not
directly exposed to the guest as registers.
The ways the KVM code in the series consumes the registers' values are
very limited, and no KVM data/state is created based on their values.
But, as the code that consumes the registers grows in the future,
I wouldn't be surprised if KVM consumes them differently than it does
now (e.g. create another data structure based on the register values).
I'm not sure though :)

The restriction, with which KVM doesn't need to worry about the changes
in the registers after KVM_RUN, could potentially protect or be useful
to protect KVM and simplify future changes/maintenance of the KVM codes
that consumes the values.
I thought this was one of the reasons for having the restriction.

Thanks,
Reiji
