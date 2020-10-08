Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03524287BAD
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgJHS1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 14:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbgJHS1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 14:27:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7D0C0613D2
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 11:27:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c5so6683747ilr.9
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RrkOdAbBDCwyeOQ37z5tV7CnkLENGAjGaGO/schUabQ=;
        b=KOwuXgfsy9d3hZ9ebY1MDbA+SQZ34Ep/hpkIyi8xd/Dzs9rEKt+5vx2AiS6+Cqohrf
         WUu1wEzLRxNjDKUUKrGAiu8Sh6LunX42uuGSGKthYgpZLrbUp9a6XlrUQZHp4R3dyZSG
         A8QT+Bjdc9CK8oYU7MkpW/4899D7lD3plf1FxnSFhUgoUIRNOa1wb9O+Ul3y+g3MWXYi
         MoV9lwPLXmhoKVDd6m4Ps/XTbjYdaenWSmXkncPd6DwJ5P8Z7U+gh+cojH0Uaad3+QjD
         uPUNlh3k7E6bB2LtRrjm+l5Bu0HNLzZSeb0ch/kEnd/YjUlnMBeR8pd79dGcCj+WLQmD
         OeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RrkOdAbBDCwyeOQ37z5tV7CnkLENGAjGaGO/schUabQ=;
        b=ajEh9uDd1lhyPqqsTSdMkAVs/Ns8kFB1rMtHtNpjCjLkuhmgrUMgfS2bk/G1piDaPh
         +I8BIA7PtnK/rB3Y2s690vPKOe2GrHX2+n6rei8ztEf+HIAiW7pXdZPYYOsoLj25CQ0m
         pvB9f4vMshL3HOA9vmBQ5E3eVgKMbkwexEx0ozzPen3L2Oz8vWV3yRz+p4XZUSj9ZT3d
         xaBJny8PlvirJ0YM1xKxIBc4YiNY/tRTPOq8iwy0rAJfGe1lGD0Jh8ub1mzAhnmkFQzP
         h1MRZCCVpl7llFSPCq4d1qvEpwrmjHLkK2LICR7MCZFup6Ptvhql8LJ+M9p72J8s2T1E
         kSNg==
X-Gm-Message-State: AOAM532pgVykxADZpSQaBwdeKvbcPF9Vxmbdo/ebgjbBzURWtscms39x
        wk3OrgTtfCGOaQAjefvnBYBWXMy9iLE/leOMtNk3Tw==
X-Google-Smtp-Source: ABdhPJx2ISXtg+5wgVEGtpWtH9JkiOPqpq0nDgXIkl0aFwYeEmDjLStOH9ErLi1lPojEWjAmlzHEdZhgs6x7qCFck04=
X-Received: by 2002:a92:7914:: with SMTP id u20mr7656969ilc.203.1602181668922;
 Thu, 08 Oct 2020 11:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-18-bgardon@google.com>
 <6990180c-f99c-3f1d-ef6a-57e37a9999d2@redhat.com>
In-Reply-To: <6990180c-f99c-3f1d-ef6a-57e37a9999d2@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 8 Oct 2020 11:27:37 -0700
Message-ID: <CANgfPd8itkAnPqr=PfFn3Jf1O_NbY90AEQBKDQ8OR14CagDOzg@mail.gmail.com>
Subject: Re: [PATCH 17/22] kvm: mmu: Support dirty logging for the TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 6:04 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 23:22, Ben Gardon wrote:
> >                               start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
> > +     if (kvm->arch.tdp_mmu_enabled)
> > +             flush = kvm_tdp_mmu_wrprot_slot(kvm, memslot, false) || flush;
> >       spin_unlock(&kvm->mmu_lock);
> >
>
> In fact you can just pass down the end-level KVM_MAX_HUGEPAGE_LEVEL or
> PGLEVEL_4K here to kvm_tdp_mmu_wrprot_slot and from there to
> wrprot_gfn_range.

That makes sense. My only worry there is the added complexity of error
handling values besides PG_LEVEL_2M and PG_LEVEL_4K. Since there are
only two callers, I don't think that will be too much of a problem
though. I don't think KVM_MAX_HUGEPAGE_LEVEL would actually be a good
value to pass in as I don't think that would write protect 2M
mappings. KVM_MAX_HUGEPAGE_LEVEL is defined as PG_LEVEL_1G, or 3.

>
> >
> > +             /*
> > +              * Take a reference on the root so that it cannot be freed if
> > +              * this thread releases the MMU lock and yields in this loop.
> > +              */
> > +             get_tdp_mmu_root(kvm, root);
> > +
> > +             spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
> > +                             slot->base_gfn + slot->npages, skip_4k) ||
> > +                        spte_set;
> > +
> > +             put_tdp_mmu_root(kvm, root);
>
>
> Generalyl using "|=" is the more common idiom in mmu.c.

I changed to this in response to some feedback on the RFC, about
mixing bitwise ops and bools, but I like the |= syntax more as well.

>
> > +static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > +                        gfn_t start, gfn_t end)
> > ...
> > +             __handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
> > +                                   new_spte, iter.level);
> > +             handle_changed_spte_acc_track(iter.old_spte, new_spte,
> > +                                           iter.level);
>
> Is it worth not calling handle_changed_spte?  handle_changed_spte_dlog
> obviously will never fire but duplicating the code is a bit ugly.
>
> I guess this patch is the first one that really gives the "feeling" of
> what the data structures look like.  The main difference with the shadow
> MMU is that you have the tdp_iter instead of the callback-based code of
> slot_handle_level_range, but otherwise it's not hard to follow one if
> you know the other.  Reorganizing the code so that mmu.c is little more
> than a wrapper around the two will help as well in this respect.
>
> Paolo
>
