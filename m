Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1E334B87
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 23:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhCJWZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhCJWZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 17:25:02 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9393AC061574
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 14:25:02 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id t83so10967647oih.12
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 14:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oQIYfjtgUHgni6JFAt7/VwxRLmto1V13D58zyPfKeVE=;
        b=USlEkai2cn+K/Clcj2iEzeKQbkFeTi8gGwovYsZQKNOrJDe24BnO7OJHsYmIPDRmZW
         PvRVhy+8Ar8zCPqq4PIsamPuVbDgLckQNLd9lPxDsGT+++o6nSgBWT/sUU23NL7SwcIw
         ORAB5T3OKfqhqfF+d0aXUuvAQ8+s6lAOw4drRs72Ox1TAdfV+77hXpqiARkI2qsOtaGX
         PfMwEEJfx5w1Q03eMXiuy5pN5Kdhsq2k9hYZq/xPrYkzkCqfUTEOrN6jKlwhA2qWiEIO
         8JQz4gxMWzdZJMgUyjReLWdN9mda7Il4oFHnDuCipVlXfVd2oR1JeMPk+0zf/fJoOI5a
         kh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQIYfjtgUHgni6JFAt7/VwxRLmto1V13D58zyPfKeVE=;
        b=UzcBSIQxZjqMm2poeGNkHMqbGVYev6qGwQ9odR5CaMsQ7drW/URb4xzP5cGrQ5GXoR
         uTP7c/uShrnkfxjCjG5rXlcan4ydfkahqgNSrbHKGUGu+hFz2m17Y01CJ13e6QpGTZ+H
         Vs+/yeyrfLOa5ljmaZqlpCatvksh+QvgRsXb4VYTdVv7NXZr154tGtGMVXBDLj0C5Usv
         wgWI3G2C8Uf9lwbFWMbjYRIzkqxRnqj+Shf7LnaZl5vE4hLH2ksUAOxoUfJedTxCV219
         ZibqJnD/aVjXlFEbvW6UoITY+sVW/dgd1jZa1L4HHZ/l9yotcpe7VK29ylxeWDgGxmUa
         YR6g==
X-Gm-Message-State: AOAM5303Q1xpqwDhpeFII+jNu/O2h5itOBd8Z09JpzgA0je4yfYZDLtR
        UXLE0ZFL1R6/S6G5ybLkvB3W6yNzzNBo+sngXJgKIg==
X-Google-Smtp-Source: ABdhPJzavjRAgQ/UaS0iEceAQhEvC+qkJPLJG4miOk18dlDF/qrAkUpGU5MyQElDu1zCc9dInB6yOmrkhunjHSO4hE4=
X-Received: by 2002:aca:3a41:: with SMTP id h62mr3945506oia.89.1615415101663;
 Wed, 10 Mar 2021 14:25:01 -0800 (PST)
MIME-Version: 1.0
References: <20210310003029.1250571-1-seanjc@google.com> <07cf7833-c74a-9ae0-6895-d74708b97f68@redhat.com>
 <YEk2kBRUriFlCM62@google.com>
In-Reply-To: <YEk2kBRUriFlCM62@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Mar 2021 14:24:50 -0800
Message-ID: <CANgfPd9WS+ntjdh87Gk97MQq6FYNUk8KVE3jQYfmgr2mFb3Stw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP in
 exclusive mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 1:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 10, 2021, Paolo Bonzini wrote:
> > On 10/03/21 01:30, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 50ef757c5586..f0c99fa04ef2 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -323,7 +323,18 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
> > >                             cpu_relax();
> > >                     }
> > >             } else {
> > > +                   /*
> > > +                    * If the SPTE is not MMU-present, there is no backing
> > > +                    * page associated with the SPTE and so no side effects
> > > +                    * that need to be recorded, and exclusive ownership of
> > > +                    * mmu_lock ensures the SPTE can't be made present.
> > > +                    * Note, zapping MMIO SPTEs is also unnecessary as they
> > > +                    * are guarded by the memslots generation, not by being
> > > +                    * unreachable.
> > > +                    */
> > >                     old_child_spte = READ_ONCE(*sptep);
> > > +                   if (!is_shadow_present_pte(old_child_spte))
> > > +                           continue;
> > >                     /*
> > >                      * Marking the SPTE as a removed SPTE is not
> >
> > Ben, do you plan to make this path take mmu_lock for read?  If so, this
> > wouldn't be too useful IIUC.
>
> I can see kvm_mmu_zap_all_fast()->kvm_tdp_mmu_zap_all() moving to a shared-mode
> flow, but I don't think we'll ever want to move away from exclusive-mode zapping
> for kvm_arch_flush_shadow_all()->kvm_mmu_zap_all()->kvm_tdp_mmu_zap_all().  In
> that case, the VM is dead or dying; freeing memory should be done as quickly as
> possible.

Yeah, as Sean said, zapping under the MMU lock in write mode probably
shouldn't go away, even if we find we're able to do it in read mode in
some flows.

This optimization also makes me think we could also skip the
__handle_changed_spte call in the read mode case if the SPTE change
was !PRESENT -> REMOVED.
