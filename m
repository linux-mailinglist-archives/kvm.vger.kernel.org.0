Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB7A486F2D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344018AbiAGAzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiAGAzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:55:02 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E13C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 16:55:02 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id g11so9881217lfu.2
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 16:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MFXd2GZzM97CntEW/TaFS7iaG4i3oCkzynH7EOS2mJ0=;
        b=MTOEZbeI3pVU1RHKnnbrSOHU/9g2vQXdTTHNTtK03SVmTHTBCCootTX+eeNv/qCB1s
         M4x2L9uBrVjRWSgaWDgwaJ8mX0CxNx6E7M1Y0oD33QglUXU1ggCkOaLH2VrDrpXPEXOg
         KqGH6yA6oY8CVIuwqS1NqKjKl2CZHbkOL6xSp+GqR0eM5FI0Vjaj8kixpRkUjToWqeHI
         jfN0GPsn7Tjk6CXUodqboCpZcA1YDlW/w383AsA58TkZDUAnSGrLGQBH3+1uJnTLeqrU
         yKGjd4opFZDS8mHtpCvQR+JwBNjUQybdMrdeUmsN5RigwclUBII0yOBB0mbA+Xe0/G9+
         97DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MFXd2GZzM97CntEW/TaFS7iaG4i3oCkzynH7EOS2mJ0=;
        b=uB83J6DKXydNXkLxcz6BuhHuJGLLrIKd+C7Zfvvo1UlEyL1ou2m9CR3TMFKdyHG+Zn
         nZ8mKW3CsNBo7tBcHuXzlIc/Cs7abhoXxKLGY3ygB7+3TrFjt0sRR5YzStdy7JXbnaap
         weu6rdOjBbFmNpAUg0N10ylUC5kq0LJjqlXtG4yHcY3hH/ii2ZmM3b6QM5X6fwNZYZuL
         x+5axv3qmYys3ZdMDLtibAuKyCG061DN/tpjkpm+EmN8hm7nkxQnf6YKVJBZWKnMgf61
         mcErIuKZXYzvMpN8X/wCseFRNTueXkekpCJcE06LH/sRn3WpXNZjDwqrZdDH0QUg5bVx
         tiVQ==
X-Gm-Message-State: AOAM530oKfSGbHvnOWZ+sZqoqhikwwHq5/nL904zW0K2FjRXOXvyCrIi
        nZKa5US7jGfcL0UzyAm6Lkblwn8ffbQVzlnEVJCRBg==
X-Google-Smtp-Source: ABdhPJzOdgOJeHakcTWaLampQbPUu1JEHiDnS5zrRSWxn6PpoN/voVFBUcWQFwYZiim67CC1hsSZdzOmR8NGemGEgZk=
X-Received: by 2002:ac2:4c83:: with SMTP id d3mr52187580lfl.102.1641516900443;
 Thu, 06 Jan 2022 16:55:00 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-13-dmatlack@google.com>
 <Ydd35kUoHp+7n272@google.com>
In-Reply-To: <Ydd35kUoHp+7n272@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 16:54:33 -0800
Message-ID: <CALzav=eCrm5TLY_rEG3YnKbsuyhA=wZcapaVnPP-yw+mRD3H4w@mail.gmail.com>
Subject: Re: [PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 6, 2022 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Add a tracepoint that records whenever KVM eagerly splits a huge page.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmutrace.h | 20 ++++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c  |  2 ++
> >  2 files changed, 22 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> > index de5e8e4e1aa7..4feabf773387 100644
> > --- a/arch/x86/kvm/mmu/mmutrace.h
> > +++ b/arch/x86/kvm/mmu/mmutrace.h
> > @@ -416,6 +416,26 @@ TRACE_EVENT(
> >       )
> >  );
> >
> > +TRACE_EVENT(
> > +     kvm_mmu_split_huge_page,
> > +     TP_PROTO(u64 gfn, u64 spte, int level),
> > +     TP_ARGS(gfn, spte, level),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(u64, gfn)
> > +             __field(u64, spte)
> > +             __field(int, level)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->gfn = gfn;
> > +             __entry->spte = spte;
> > +             __entry->level = level;
> > +     ),
> > +
> > +     TP_printk("gfn %llx spte %llx level %d", __entry->gfn, __entry->spte, __entry->level)
> > +);
> > +
> >  #endif /* _TRACE_KVMMMU_H */
> >
> >  #undef TRACE_INCLUDE_PATH
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index be5eb74ac053..e6910b9b5c12 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1325,6 +1325,8 @@ tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter, struct kv
> >       u64 child_spte;
> >       int i;
> >
> > +     trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level);
>
> This should either be called iff splitting is successful, or it should record
> whether or not the split was successful.

Blegh. My intention was to do the former but it's obviously wrong if
the cmpxchg fails.

> The latter is probably useful info,
> and easy to do, e.g. assuming this is changed to return an int like the lower
> helpers:
>
>
>         ret = tdp_mmu_install_sp_atomic(kvm, iter, sp, false);
>
>         /*
>          * tdp_mmu_install_sp_atomic will handle subtracting the split huge
>          * page from stats, but we have to manually update the new present child
>          * pages on success.
>          */
>         if (!ret)
>                 kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
>
>         trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level, ret);
>
>         return ret;
>
> and then the tracpoint can do 'ret ? "failed" : "succeeded"' or something.

If we do this we should capture all the reasons why splitting might
fail. cmpxchg races are one, and the other is failing to allocate the
sp memory. I'll take a look at doing this in the next version. It
doesn't look too difficult.

>
> > +
> >       init_child_tdp_mmu_page(sp, iter);
> >
> >       for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> > --
> > 2.34.1.173.g76aa8bc2d0-goog
> >
