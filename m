Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9888A48CAFC
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343953AbiALSaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356229AbiALS3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 13:29:20 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BEFC061751
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:29:20 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id n68so8083056ybg.6
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ioZFa8MC1+lYZ4QoC/7YWzVkd4bJ+z/9gnEvzeEbMy4=;
        b=EJNOGgBTzR4d+pUvCYvjfawgKqJB8uCOzmTw2NhI6Ch4V2hprO0Xm+S2ceCFGHixST
         1aOvJU8qmRqqf10TwmjZB/8yIck9/Ul0B2TrybLH8AZpQedw43I5Bhd0xGkNCK3hhApy
         sj2igGZoPKoPqkAfZ8uTtQME39e63cTzXDayaDxqglMPXGFYONmw7IjqWg2VOTyOgczU
         duKpoVMkB1wPF5NntnPSm9sleh730pv1OcV64hAIMOwqJ0/sBg559ydh50Pk+jXjiWUg
         cWMTbPH7K5Oxj15BMlROOqtJokzcsrIOAEZ8lqCr5R7bNYW1msKEMfthMnmoh94skcj9
         qXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ioZFa8MC1+lYZ4QoC/7YWzVkd4bJ+z/9gnEvzeEbMy4=;
        b=j/K9Y/l5z9nAnaJkwglrDyya48EKaWY8NmmriAca99IFnQKLyXjuwrPV/h0EeRIH5O
         jMN5kQaZljK+i5/PfdylcEJQHhcCHpVzh+nouKAlurGORZC6MvAVUyJD5DHIChWZZ05T
         Os0uNnNrS/iSfTgVyZ6A7lM1fJidgtdSFBOOSQCHLdIoSfIQNERhIGD1O2KomutYkasc
         uqLVoMf86SBr1qEd41IbBIXxX5jHOvQU+/JEVugIyV0Oa7jaYyYY/qiRFW5MysjlBcdO
         xXESc3RnlaZGiPDtQ3p5O7EffUjcAmrbNv50+0RRIFz2xwwPzZW3vBNB79HusDD5uGwW
         P0Ag==
X-Gm-Message-State: AOAM532W4hF3wiRlsijtEhTAp9mdKfJmQ8qUSvU4pXBIzSEu+jGK7PIb
        PwCTyO2ripx88qR+XrdHzoWBldzF9f+hvJiHIwiWSQ==
X-Google-Smtp-Source: ABdhPJxP9y/VohUfFKSPP8Ebe2w7tuIIiYl3DrsSGfw54USAQIa0/WSL7GFfuDNgf1DGqj0M08Dx9O0UOuOOD7NOH9w=
X-Received: by 2002:a25:244e:: with SMTP id k75mr1255464ybk.172.1642012158650;
 Wed, 12 Jan 2022 10:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com> <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
In-Reply-To: <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 12 Jan 2022 10:29:07 -0800
Message-ID: <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Jim Mattson <jmattson@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Jan 11, 2022 at 10:52 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > > > >
> > > > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > > > <rananta@google.com> wrote:
> > > > > >
> > > > > > Hi Reiji,
> > > > > >
> > > > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > > > >
> > > > > > > Hi Raghu,
> > > > > > >
> > > > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > > > <rananta@google.com> wrote:
> > > > > > > >
> > > > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > > > in the upcoming patches to prevent user-space from
> > > > > > > > configuring certain VM features after the VM has started
> > > > > > > > running.
> > > > >
> > > > > What about live migration, where the VM has already technically been
> > > > > started before the first call to KVM_RUN?
> > > >
> > > > My understanding is that a new 'struct kvm' is created on the target
> > > > machine and this flag should be reset, which would allow the VMM to
> > > > restore the firmware registers. However, we would be running KVM_RUN
> > > > for the first time on the target machine, thus setting the flag.
> > > > So, you are right; It's more of a resume operation from the guest's
> > > > point of view. I guess the name of the variable is what's confusing
> > > > here.
> > >
> > > I was actually thinking that live migration gives userspace an easy
> > > way to circumvent your restriction. You said, "This state of the VM is
> > > helpful in the upcoming patches to prevent user-space from configuring
> > > certain VM features after the VM has started running." However, if you
> > > don't ensure that these VM features are configured the same way on the
> > > target machine as they were on the source machine, you have not
> > > actually accomplished your stated goal.
> > >
> > Isn't that up to the VMM to save/restore and validate the registers
> > across migrations?
>
> Yes, just as it is up to userspace not to make bad configuration
> changes after the first VMRUN.
>
> > Perhaps I have to re-word my intentions for the patch- userspace
> > should be able to configure the registers before issuing the first
> > KVM_RUN.
>
> Perhaps it would help if you explained *why* you are doing this. It
> sounds like you are either trying to protect against a malicious
> userspace, or you are trying to keep userspace from doing something
> stupid. In general, kvm only enforces constraints that are necessary
> to protect the host. If that's what you're doing, I don't understand
> why live migration doesn't provide an end-run around your protections.
It's mainly to safeguard the guests. With respect to migration, KVM
and the userspace are collectively playing a role here. It's up to the
userspace to ensure that the registers are configured the same across
migrations and KVM ensures that the userspace doesn't modify the
registers after KVM_RUN so that they don't see features turned OFF/ON
during execution. I'm not sure if it falls into the definition of
protecting the host. Do you see a value in adding this extra
protection from KVM?

Regards,
Raghavendra
