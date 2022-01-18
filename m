Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEB49310F
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 23:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350112AbiARWy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 17:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344503AbiARWyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 17:54:25 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6455EC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 14:54:25 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id p5so1438154ybd.13
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 14:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2A0o9RStrnIxmL11KBIrT0fGYmNaZT0XLIaxHQF5rjs=;
        b=dag6jxRDJUEiQYlvYUtjYS/OfkScCbS15kuV1kOlQvrem03MJYgdAwaEHsk7xkMGTO
         kFHIj3pxg2l26Gamk9bynAV2Zfontn1hV5i3Z18gq3jN3xjnwhxB20CVOjA4+vlA0R02
         ceyCS6rF1ci0H0IzntFxCa97kN3hwPwH9Z5sBLk8kMfM4ZECEp0lNsPAGgF1rYgVCvUR
         PGkIyNBVj8eZ5YoiH4PXKb+AZcWt0b511F2zYUm4g2+HsrQfl/5+64z1s3gsYWingZHi
         WN++EpOE6AguKoOdixg8BZ9R5wasNuqelZQvKvhUyQa3VDRdqhnIkSRieTj99s3sWzle
         ku3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2A0o9RStrnIxmL11KBIrT0fGYmNaZT0XLIaxHQF5rjs=;
        b=DvCwARraaQMGAAAfrr03pbz1cVzfPCBUrCSPT8DnLKKYOn26VW01FpM5WIjWAUVYQi
         +QfIgLn56qEJeMcsGLIckjlD4/7QXfbJ0NRN9BQkGkBH5UAvq66eXfJiseaMEgIiz/7v
         N/toCmLRZCfTDQqPJuZg2hhTlsSPd+QskkxakCZgOKihW319aTZOuPaioyAmlsnLazfr
         kXbNPDDuf2i2ibVszHCaEwS1/DyhBm6HX0MRfltZwxJVh7u6Wss0aRBfGC2EWcoKYwlf
         /0csHZukvGcxhPrKcE6HCK3B+dhW1KHTd3RiNXNKJ3b2Ge2DG+p1tR0JKBt5CFxjZa+G
         mH5A==
X-Gm-Message-State: AOAM533lDlPccAG/Yl+GDgL3DnGQJ5+zk7ZIjYcbRUN/MTSw3DloYJA7
        ZHWWjXKjw/XUENntiv+seFJRofpvs2fvDpTZA4sdLQ==
X-Google-Smtp-Source: ABdhPJwKhpxDqzsHYaDrecYU3+cgHLkJME7T1oocecMclqJnaqy7jDJK7leekDDAezlwQk6RPUBfNaub4qT6EIgRDRI=
X-Received: by 2002:a25:d055:: with SMTP id h82mr6237602ybg.543.1642546464435;
 Tue, 18 Jan 2022 14:54:24 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com> <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
In-Reply-To: <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 18 Jan 2022 14:54:13 -0800
Message-ID: <CAJHc60zcwNskA7JCg9nQc4YhmLdziHVauf1gQQ48GHYtby_aYg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
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

On Fri, Jan 14, 2022 at 1:51 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> On Thu, Jan 13, 2022 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> > > On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
> > > > Perhaps it would help if you explained *why* you are doing this. It
> > > > sounds like you are either trying to protect against a malicious
> > > > userspace, or you are trying to keep userspace from doing something
> > > > stupid. In general, kvm only enforces constraints that are necessary
> > > > to protect the host. If that's what you're doing, I don't understand
> > > > why live migration doesn't provide an end-run around your protections.
> > > It's mainly to safeguard the guests. With respect to migration, KVM
> > > and the userspace are collectively playing a role here. It's up to the
> > > userspace to ensure that the registers are configured the same across
> > > migrations and KVM ensures that the userspace doesn't modify the
> > > registers after KVM_RUN so that they don't see features turned OFF/ON
> > > during execution. I'm not sure if it falls into the definition of
> > > protecting the host. Do you see a value in adding this extra
> > > protection from KVM?
> >
> > Short answer: probably not?
> >
> > There is precedent for disallowing userspace from doing stupid things, but that's
> > either for KVM's protection (as Jim pointed out), or because KVM can't honor the
> > change, e.g. x86 is currently in the process of disallowing most CPUID changes
> > after KVM_RUN because KVM itself consumes the CPUID information and KVM doesn't
> > support updating some of it's own internal state (because removing features like
> > GB hugepage support is nonsensical and would require a large pile of complicated,
> > messy code).
> >
> > Restricing CPUID changes does offer some "protection" to the guest, but that's
> > not the goal.  E.g. KVM won't detect CPUID misconfiguration in the migration
> > case, and trying to do so is a fool's errand.
> >
> > If restricting updates in the arm64 is necessary to ensure KVM provides sane
> > behavior, then it could be justified.  But if it's purely a sanity check on
> > behalf of the guest, then it's not justified.
>
> The pseudo firmware hvc registers, which this series are adding, are
> used by KVM to identify available hvc features for the guest, and not
> directly exposed to the guest as registers.
> The ways the KVM code in the series consumes the registers' values are
> very limited, and no KVM data/state is created based on their values.
> But, as the code that consumes the registers grows in the future,
> I wouldn't be surprised if KVM consumes them differently than it does
> now (e.g. create another data structure based on the register values).
> I'm not sure though :)
>
> The restriction, with which KVM doesn't need to worry about the changes
> in the registers after KVM_RUN, could potentially protect or be useful
> to protect KVM and simplify future changes/maintenance of the KVM codes
> that consumes the values.
> I thought this was one of the reasons for having the restriction.
>
Well, that wasn't the original intention of the patch, but just to
protect the guests from the userspace's dynamic updates. Having said
that, and based on what Sean mentioned in his last reply, it could be
inconsistent from what KVM has been doing so far and would be
difficult to cover all the scenarios that userspace can mess things up
for guests.
I'll plan to drop this patch in the next version, and bring it back
back to arm64 if we really need it.

Thanks Sean, Jim, and Reiji for the comments and discussion.

Regards,
Raghavendra
> Thanks,
> Reiji
