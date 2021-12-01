Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2B4658FF
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 23:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353558AbhLAWVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 17:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353522AbhLAWVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 17:21:11 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6231C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 14:17:49 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id m12so12896164ljj.6
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 14:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lfCICFZ0booJ8hDFewkQmQSuulSEExYn7m5Iol/v75k=;
        b=WVXEIK8COXm55oRmaRZjeTeayyByw76dJIja+87D2hNEc/vpmbEJ68dSyW1yywg8D5
         puPRFfncRtBOTtVrNr8ZiZcoX7BJvLGM5ObelPj9v5z4tAXe7eF/vnKvw3cQ8fgoGWGa
         tgCzpUys9dQTV88vowyRXClH9LbKi5HB4mcI9XeiDdqYPvwJSCI9ohuo/0A2z1X13Yay
         M+tA8icaK/PpQO9XJJijCTilxfWNYNBpqdovxYlZQdUXq6UZikWLKxgw8/0aSnq8+ng7
         OjefclrWHSaew7/Cbkd9LCMvcmpg9um/syKvmUnmlZw0x7Apoi2tmadxIkq8Fo0gjJAl
         NfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lfCICFZ0booJ8hDFewkQmQSuulSEExYn7m5Iol/v75k=;
        b=VYyChaqg6BJ1/zI72bGYprVp0LasTS3ke/xOyf01Jxz2WtqlnR+s6bqU65QkuU6Vuq
         BNJglPR3CivziK/sV0GxoUQeaq79thQ8d10N0P/I7M9zQnrsvzRnY5CjjFG0Cp++S1i6
         lmbxdwPMV85KeKWUog702+ElNsZT64fWoWjf2tF5moDT6Jl8IOxYna/01wzTrEV5Ebwd
         aRkIUhyFzsKg/qtEz4JWM/PwBkPdaZes/JcGzpKEdC53DrvKi940obfxTS/CkpxiaGo0
         EPLwcC2WBN+cnXXzL5S/s6BxOdt7vLDki7o7eYbBH1EI2UasmiGlZ1eXBHd0eFubfhGk
         EKQw==
X-Gm-Message-State: AOAM533hrKWxHPwB4f9E6KCvH7TW6CwogKHFThVLAS/vFjp4WjKMD7Ox
        xxfogHCxy6xUnAlzxW0FtZiN2nfaqe05Vt79vrEIbw==
X-Google-Smtp-Source: ABdhPJzO8he1BHlgJfcBM6izpVWiU7P94Gmu77DOG/PzWMlbi8LkxCgAl1yeu+iUEIg95vjHj5KoJwEpqDjoUSjRA6Y=
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr8225864ljj.49.1638397067116;
 Wed, 01 Dec 2021 14:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YafLdpkoTrtyoEjy@google.com>
In-Reply-To: <YafLdpkoTrtyoEjy@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 14:17:20 -0800
Message-ID: <CALzav=e1KpWG6TMDMGkRX5-EXwr+zuqH2hDrk1k01hGTPwQmLQ@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 19, 2021, David Matlack wrote:
> > When using initially-all-set, large pages are not write-protected when
> > dirty logging is enabled on the memslot. Instead they are
> > write-protected once userspace invoked CLEAR_DIRTY_LOG for the first
> > time, and only for the specific sub-region of the memslot that userspace
> > whishes to clear.
> >
> > Enhance CLEAR_DIRTY_LOG to also try to split large pages prior to
> > write-protecting to avoid causing write-protection faults on vCPU
> > threads. This also allows userspace to smear the cost of large page
> > splitting across multiple ioctls rather than splitting the entire
> > memslot when not using initially-all-set.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++++++++++--------
> >  2 files changed, 26 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 432a4df817ec..6b5bf99f57af 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1591,6 +1591,10 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
> >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >                                     const struct kvm_memory_slot *memslot,
> >                                     int start_level);
> > +void kvm_mmu_try_split_large_pages(struct kvm *kvm,
>
> I would prefer we use hugepage when possible, mostly because that's the terminology
> used by the kernel.  KVM is comically inconsistent, but if we make an effort to use
> hugepage when adding new code, hopefully someday we'll have enough inertia to commit
> fully to hugepage.

Will do.

>
> > +                                const struct kvm_memory_slot *memslot,
> > +                                u64 start, u64 end,
> > +                                int target_level);
> >  void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
> >                                       const struct kvm_memory_slot *memslot,
> >                                       int target_level);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6768ef9c0891..4e78ef2dd352 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> >
> > +             /*
> > +              * Try to proactively split any large pages down to 4KB so that
> > +              * vCPUs don't have to take write-protection faults.
> > +              */
> > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
>
> This should return a value.  If splitting succeeds, there should be no hugepages
> and so walking the page tables to write-protect 2M is unnecessary.  Same for the
> previous patch, although skipping the write-protect path is a little less
> straightforward in that case.

Great idea! Will do.

>
> > +
> >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> >
> >               /* Cross two large pages? */
