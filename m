Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0D3AD0C6
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbhFRQ4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhFRQ4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 12:56:15 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23706C06175F
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:54:05 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id t140so11269405oih.0
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtSqJOQGfjKv3UOcjj+P/M/U0KAJcbotecQbdXLeGdE=;
        b=S6H4mLsocQZXJTWCCi58vEGYojWSPpW0UBu5oyIqTluZ1mhtIhmr8gi/WkMNeemx9V
         ZVVxgzztTTFLcKcB7Fl9a6JjekIFLAD7GK8aco+Ed9UvOgWLWmhtPKxbFX7Mrii+GK36
         +vCHyWa+xfsZbl8w9tKOmCXqnyHgWTsCGYhiqctrFdiWgo6mBo6503RS8pHiIA+1kgNy
         Lo0e8EpTtukNP0M0cubZstkmwYWHaCIzJx7hIwLb3IcYuXpfOlay3MIWYwWYDIbyqQ9y
         3OccBtAaOIJQ4IxlAb4Zyp8/H3I0oUeZLf6vCuoF7iakCwbd7Fv9Z/dTSnxhl9Nlqvdn
         UeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtSqJOQGfjKv3UOcjj+P/M/U0KAJcbotecQbdXLeGdE=;
        b=s1WrVaK6mC8FYI2KEAE3Jn4rUCIu1Om+YyU1sYy3q3YHzu7qaNDxMgHuE/7TFbHTgo
         TASgWl9lDvkujDDVYXfAHNh7Q1RRIPg8GkcF9am6yUnJ/005kuwNIa9gVZLce8a7tHJC
         fszAI6mzmJK21vSipb+Ia2t5LceBHVk+pw4v+fE6eoSzPz0xYfh/vYlbJVQ40ZiUYEfs
         dVW4QFkGCA5+xrB4Rl9FrrttCfAyTo+LKgdfq+U8bnhOXeCvAscJgCmUiUwtqP5QOD1e
         wGvtwp258iFqNE3AEGJXWi3lMExtjWi/1KVlj2IuaAtqd1fjuJ+EPW59du+r3Mj+nvFA
         QWiw==
X-Gm-Message-State: AOAM530UsLfrVitswiMs+tBLeadhnv2BlFXJ4QVTxEz6yfqxPVaFYIf3
        omua9lD3SLgojAeGpVOxo7UAymbE9sz0C+FxPWsBQQ==
X-Google-Smtp-Source: ABdhPJyHzNg1FTlnP0ojeJkXrYeJkXPTb5H3tCQJjlx70G2MdTVcBObUsy/Yte/q9+CooW6Ir2VvuD/lJo1v/CAIyYs=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr7727189oic.28.1624035244083;
 Fri, 18 Jun 2021 09:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
 <20200603101131.2107303-1-efremov@linux.com> <CALMp9eSFkRrWLjegJ5OC7kZ4oWtZypKRDjXFQD5=tFX4YLpUgw@mail.gmail.com>
 <YMw2YeWHFsn+AFmN@dhcp22.suse.cz>
In-Reply-To: <YMw2YeWHFsn+AFmN@dhcp22.suse.cz>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Jun 2021 09:53:53 -0700
Message-ID: <CALMp9eR9n6N5EB-nUEJPM=e2YtE3_tQBDHj0uP3T2dcGsutSCQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Use vmemdup_user()
To:     Michal Hocko <mhocko@suse.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Paolo Bonzini <pbonzini@redhat.com>, joe@perches.com,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 11:00 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Thu 17-06-21 17:25:04, Jim Mattson wrote:
> > On Wed, Jun 3, 2020 at 3:10 AM Denis Efremov <efremov@linux.com> wrote:
> > >
> > > Replace opencoded alloc and copy with vmemdup_user().
> > >
> > > Signed-off-by: Denis Efremov <efremov@linux.com>
> > > ---
> > > Looks like these are the only places in KVM that are suitable for
> > > vmemdup_user().
> > >
> > >  arch/x86/kvm/cpuid.c | 17 +++++++----------
> > >  virt/kvm/kvm_main.c  | 19 ++++++++-----------
> > >  2 files changed, 15 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 901cd1fdecd9..27438a2bdb62 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -182,17 +182,14 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
> > >         r = -E2BIG;
> > >         if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
> > >                 goto out;
> > > -       r = -ENOMEM;
> > >         if (cpuid->nent) {
> > > -               cpuid_entries =
> > > -                       vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
> > > -                                          cpuid->nent));
> > > -               if (!cpuid_entries)
> > > -                       goto out;
> > > -               r = -EFAULT;
> > > -               if (copy_from_user(cpuid_entries, entries,
> > > -                                  cpuid->nent * sizeof(struct kvm_cpuid_entry)))
> > > +               cpuid_entries = vmemdup_user(entries,
> > > +                                            array_size(sizeof(struct kvm_cpuid_entry),
> > > +                                                       cpuid->nent));
> >
> > Does this break memcg accounting? I ask, because I'm really not sure.
>
> What do you mean by that? The original code uses plain vmalloc so the
> allocation is not memcg accounted (please note that __GFP_ACCOUNT needs
> to be specified explicitly). vmemdup_user is the same in that regards.

I asked, because I wasn't sure if plain vmalloc was accounted or not.

In any case, these allocations *should* be accounted, shouldn't they?
