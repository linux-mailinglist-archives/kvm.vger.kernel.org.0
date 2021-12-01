Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B34658AB
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhLAV4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 16:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353329AbhLAV4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 16:56:37 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9DC06174A
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:53:13 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id m12so12790837ljj.6
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUEj3i8K6dYoh6AYzrusPWhHZOvQfVMcv8PQ1ogRx6s=;
        b=PmvgKTEagBg2xzZDkD1xesEoDTkrkTEpDK8EtVtpo69d5mnlgYsJdXdEaWANuYGeBj
         kqfRGu85szuGEoZfRVa0r5FiouybScN3bl4gKilS/tSy6u5byzD8n/DFZhSiUJrNz2gs
         UGZzPCFzGqqqNH3Bkgaf0FywqpZ0roN67DucM/aWda5pX8M9UN9Vm5yHqCdlSEISwDzc
         1sL13FR4NELeWigdBIE+Kap1zs4WlEdkVw8nwMqQat3GZ/lNXlz3JdSJF0wKBEGO6U1R
         bOkhtD9inHTFsHcrmOQLXQoquK68NU8kjWYfvldjkF88kof59CwKvn07rHZ3+p3z73XJ
         QGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUEj3i8K6dYoh6AYzrusPWhHZOvQfVMcv8PQ1ogRx6s=;
        b=HD9S1Wj4lyoklThOy+8B/q7D9slcbvvJ4tW1EYWL4Hwus+OW6BLaooyYCitPhMBJuD
         wkWZvQzY7YM9G6ExKp/7Nr2nNNY4uIyAnnnN2JiKaBWzcPS0FlDUphHh949WXErnCvkp
         I5k7Lvu9mYTrKhB7KG3VkNxwZ3kUxpHkDncgLixPMMHYRBTs88HlbVy9301ftOheqG7L
         DmbJbygDSkCX2E4nq1sELV6L4Y+A440crZneE0dLP0lYwuYi4RW9sB61LXzgBTq3Vsru
         XTZ1KbrSSl6SKtB1vJiKB+LCW9ZPrhv7AbzImbnTbGNY44Mgm1r8V6shtG+azbc7fNhJ
         +FsA==
X-Gm-Message-State: AOAM533vf6xBD5wcbqp28UjS2hcm+XcpkFtHE6k6hISthvVs8+G3z5jL
        YnuTOOx4Xpdup64etgdX9V9UgwRlFv07RBi37oCIpA==
X-Google-Smtp-Source: ABdhPJxGJOsgWe+jhHJ3sEj8rkDd2Smj+HcB92Q2JaRr7pXLQhq/M4WDXZKYh0d1To1KYkk0FIBhKukT+LpIaeDXhWA=
X-Received: by 2002:a2e:8156:: with SMTP id t22mr8145254ljg.223.1638395591566;
 Wed, 01 Dec 2021 13:53:11 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-5-dmatlack@google.com>
 <YafJc1GHcxTG19p7@google.com>
In-Reply-To: <YafJc1GHcxTG19p7@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:52:45 -0800
Message-ID: <CALzav=d+674x+q+mx7i8WjGBNMcAzRZhryxdUFHc8g4P2oaPSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
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

On Wed, Dec 1, 2021 at 11:14 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 19, 2021, David Matlack wrote:
> > Factor out the logic to atomically replace an SPTE with an SPTE that
> > points to a new page table. This will be used in a follow-up commit to
> > split a large page SPTE into one level lower.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++------------
> >  1 file changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index cc9fe33c9b36..9ee3f4f7fdf5 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -945,6 +945,39 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >       return ret;
> >  }
> >
> > +/*
> > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > + * spte pointing to the provided page table.
> > + *
> > + * @kvm: kvm instance
> > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > + * @sp: The new TDP page table to install.
> > + * @account_nx: True if this page table is being installed to split a
> > + *              non-executable huge page.
> > + *
> > + * Returns: True if the new page table was installed. False if spte being
> > + *          replaced changed, causing the atomic compare-exchange to fail.
> > + *          If this function returns false the sp will be freed before
> > + *          returning.
> > + */
> > +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
> > +                                   struct tdp_iter *iter,
> > +                                   struct kvm_mmu_page *sp,
> > +                                   bool account_nx)
> > +{
> > +     u64 spte;
> > +
> > +     spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
>
> This can easily go on one line.
>
>         u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> > +
> > +     if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
> > +             tdp_mmu_link_page(kvm, sp, account_nx);
> > +             return true;
> > +     } else {
> > +             tdp_mmu_free_sp(sp);
> > +             return false;
>
> I don't think this helper should free the sp on failure, even if that's what all
> paths end up doing.  When reading the calling code, it really looks like the sp
> is being leaked because the allocation and free are in different contexts.  That
> the sp is consumed on success is fairly intuitive given the "install" action, but
> freeing on failure not so much.
>
> And for the eager splitting, freeing on failure is wasteful.  It's extremely
> unlikely to happen often, so in practice it's unlikely to be an issue, but it's
> certainly odd since the loop is likely going to immediately allocate another sp,
> either for the current spte or for the next spte.

Good point. I'll fix this in v1.

>
> Side topic, tdp_mmu_set_spte_atomic() and friends really should return 0/-EBUSY.
> Boolean returns for errors usually end in tears sooner or later.

Agreed. I was sticking with local style here but would like to see
more of this code switch to returning ints. I'll take a look at
including that cleanup as well in v1, if not a separate pre-series.
