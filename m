Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0864857C8
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbiAER4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 12:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbiAER4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 12:56:32 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074FBC03325A
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 09:55:31 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id k21so90866118lfu.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 09:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIfboTmwGHhn9ZkRVT+NXf4/nWZ/YPydZpJAKXxrfag=;
        b=Id7C1uHSg+1ZuRboAVVB47I7zxxwNUDb8+huAd7u18hHyXEyq9s3rnatBbY7vNcDwK
         eeYocCrlcuKLOB8hsB4670zlQYVd/oifzObuCGclky10G4UOXMR3pqdVMKYPmh/LeVe/
         +kbiJlTXCuXaMN4OoipFlfwQhDhOes7RnKX+1E3K3m+RFY5Mnl3P2bG5G1nU/R8q+g08
         hN0VlWICtG6WZ/+V1n2NO5nVqkiGcdDb4GklnFhj9di2C5pIfE5460q0K8JdtLbZjLlJ
         J3TFbEgCABSfSDD3K/uQsHNmBHpfAWQkxSQveOOlDJdZFiLtL5OUwgVuGp24AGTPZl3/
         fvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIfboTmwGHhn9ZkRVT+NXf4/nWZ/YPydZpJAKXxrfag=;
        b=jMwjo+TVWKQ0DLeP565j3v+Ny/MIED0HAqRgLuUdMmS9ZwpDno+bvEegYwNN8tcUHT
         MFQXNBDbLNxAluQ3EHmDTGSDj8qjYEFLhDsB7PZJ5tE+RUO/OLhIpqZ9KkcSeKdgPMQf
         ht3fX0il8uTku9zm9zqzqPvGwepyRmsGIW599TZ9N0t7zfGlANHdwpBUzkzhuo414IRv
         FoR5YiWvzZC6IYBnNfU5D0nladKQEZRJVF6Q0oFx/ndBr/0/k4Gnb0aLN8F5caghwBtH
         3xtjocq8pJmZqbgu9o28eajAT8umbMKhmKwZrvN2QnlRc8JyzbDymubWK9RP1fiLeJKJ
         CKbQ==
X-Gm-Message-State: AOAM530qcbYTJBeb5HtUqMgGjHnPAvkgtYPoimdr3HwBuT+0/UMJ1aBr
        cPPqRHlXNfy+HAIUljkURhZUR9pLidHT8Ugphjm4Xw==
X-Google-Smtp-Source: ABdhPJzW91wrwisU/Q4EBxR7fMlzthJW6G3jrE07BL9AF1rJQE7GP5NXrGH1QeHFxm73t2kMh32L3Dm08u8yTlZt3g4=
X-Received: by 2002:a05:6512:2003:: with SMTP id a3mr49933529lfb.518.1641405329144;
 Wed, 05 Jan 2022 09:55:29 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-12-dmatlack@google.com>
 <YdVejo2TODD3Z+QC@xz-m1.local>
In-Reply-To: <YdVejo2TODD3Z+QC@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 5 Jan 2022 09:55:02 -0800
Message-ID: <CALzav=fqg3AzrJkWR3StKLG38vzwcycSu19M=TFfCWg+wG8q9Q@mail.gmail.com>
Subject: Re: [PATCH v1 11/13] KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 5, 2022 at 1:02 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 10:59:16PM +0000, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c9e5fe290714..55640d73df5a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1362,6 +1362,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> >
> > +             /*
> > +              * Try to proactively split any huge pages down to 4KB so that
> > +              * vCPUs don't have to take write-protection faults.
> > +              *
> > +              * Drop the MMU lock since huge page splitting uses its own
> > +              * locking scheme and does not require the write lock in all
> > +              * cases.
> > +              */
> > +             if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging)) {
> > +                     write_unlock(&kvm->mmu_lock);
> > +                     kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > +                     write_lock(&kvm->mmu_lock);
> > +             }
> > +
> >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
>
> Would it be easier to just allow passing in shared=true/false for the new
> kvm_mmu_try_split_huge_pages(), then previous patch will not be needed?  Or is
> it intended to do it for performance reasons?
>
> IOW, I think this patch does two things: (1) support clear-log on eager split,
> and (2) allow lock degrade during eager split.
>
> It's just that imho (2) may still need some justification on necessity since
> this function only operates on a very small range of guest mem (at most
> 4K*64KB=256KB range), so it's not clear to me whether the extra lock operations
> are needed at all; after all it'll make the code slightly harder to follow.
> Not to mention the previous patch is preparing for this, and both patches will
> add lock operations.
>
> I think dirty_log_perf_test didn't cover lock contention case, because clear
> log was run after vcpu threads stopped, so lock access should be mostly hitting
> the cachelines there, afaict.  While in real life, clear log is run with vcpus
> running.  Not sure whether that'll be a problem, so raising this question up.

Good point. Dropping the write lock to acquire the read lock is
probably not necessary since we're splitting a small region of memory
here. Plus the splitting code detects contention and will drop the
lock if necessary. And the value of dropping the lock is dubious since
it adds a lot more lock operations.

I'll try your suggestion in v3.

>
> Thanks,


>
> --
> Peter Xu
>
