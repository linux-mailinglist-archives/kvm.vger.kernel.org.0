Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253494658AF
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhLAWAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 17:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhLAWAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 17:00:35 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3153BC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:57:14 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id t26so66490205lfk.9
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ritQ6Z4SV2U5axc0nyhYpmB+kPfOgvuSU0NQX4GU+mU=;
        b=ox/F6F5ak0j4Rxt2RbMo89SxBAZRztdyVa/oQfyXC94fpYNgOw2PAVt1byTOE6QXGq
         R8698Gw53L0NB5iUe5zmwBQJ/fpr9u0A2AcEdJsQOwd/Yel01ryYAFYaoPzx6wUwFNml
         JLBVdKWqgheVaaYBEw6z9DEfqegRmJORDuVEFjYG4y0a1oB1YrgF4s8tu8KpCjEgMl28
         pDILmos32OX/302Hedy0TWElCD2L1BhcpfK5OLgB2MhwEUA+KP6xo/heIaqmaPFw/Rge
         RPAueGilRq9fiIYmA+AczCKECyRTiCw5uvBptcLvixFBMM/wgGnK5wksCVLbUaAYvDAB
         5muA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ritQ6Z4SV2U5axc0nyhYpmB+kPfOgvuSU0NQX4GU+mU=;
        b=UjKMTDCP1BhL1nYfWptzAPlx0Cf3qdTdIIrnhjB3hRdZsVQ/u+Mtw7ckzAOFNlJCoR
         szbVr7cccbuEg47qIRG9yD3yaaUoZnlP1HJKz0OL77p1BzfmGw0JXY5K6KwjrUouAAdj
         e4HYRRMUFZdxhBdBcsi1Bhq6ZnrTR+N3vXrxq4l5ghypr4khRCk+ICx7tS5U7xYTUEXY
         9kUjDnwBSnz3tgMnO8NNREgHJ8qbb+AKl+ZP3r/BjGkU4R+iWNV67uB49JizKnaa1N7Z
         X8jyM+JD0GVg2+X+6vbwxPXB1CQO3getUP3ebnIYmHHR/cDfck22ZzkRV4Tf8PKW9MDs
         MndA==
X-Gm-Message-State: AOAM532tx5A0uOj8enUQEqlJH2dltsr5MSRLSMA7p9L9dWuecgOyYA6S
        X7NGkSUK7cduIYTYECHHMwaxBYizXuN5jAm7RsqUQA==
X-Google-Smtp-Source: ABdhPJzmxre8jLW7X0pVkVbZc5d2NZ7hk4xlptOCnwe2ZihDCTirVSVPjhIyFPYZKcuA3wmeR9Kj6FQecARv04lNeN4=
X-Received: by 2002:a05:6512:3503:: with SMTP id h3mr8385998lfs.235.1638395832362;
 Wed, 01 Dec 2021 13:57:12 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-7-dmatlack@google.com>
 <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com> <CALzav=d59jLY6CNL9U8_Lh_pe-BviL_oKZGCAhJcnKxGGAMF6g@mail.gmail.com>
 <YabFqf0fZqe9RZii@google.com>
In-Reply-To: <YabFqf0fZqe9RZii@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:56:46 -0800
Message-ID: <CALzav=cRAENeD+nLZ0H=1gKPX1Fim-Y542wMTkiVR9GsPF6xWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
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

On Tue, Nov 30, 2021 at 4:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 30, 2021, David Matlack wrote:
> > > I have a similar patch for the old MMU, but it was also replacing
> > > shadow_root_level with shadow_root_role.  I'll see if I can adapt it to
> > > the TDP MMU, since the shadow_root_role is obviously the same for both.
> >
> > While I was writing this patch it got me wondering if we can do an
> > even more general refactor and replace root_hpa and shadow_root_level
> > with a pointer to the root kvm_mmu_page struct. But I didn't get a
> > chance to look into it further.
>
> For TDP MUU, yes, as root_hpa == __pa(sp->spt) in all cases.  For the legacy/full
> MMU, not without additional refactoring since root_hpa doesn't point at a kvm_mmu_page
> when KVM shadows a non-paging guest with PAE paging (uses pae_root), or when KVM
> shadows nested NPT and the guest is using fewer paging levels that the host (uses
> pml5_root or pml4_root).
>
>         if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
>                 mmu->root_hpa = __pa(mmu->pml5_root);
>         else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
>                 mmu->root_hpa = __pa(mmu->pml4_root);
>         else
>                 mmu->root_hpa = __pa(mmu->pae_root);
>
> That's definitely a solvable problem, e.g. it wouldn't be a problem to burn a few
> kvm_mmu_page for the special root.  The biggest issue is probably the sheer amount
> of code that would need to be updated.  I do think it would be a good change, but
> I think we'd want to do it in a release that isn't expected to have many other MMU
> changes.

Thanks for the explanation! I had a feeling this refactor would start
getting hairy when I ventured outside of the TDP MMU.

>
> shadow_root_level can also be replaced by mmu_role.base.level.  I've never bothered
> to do the replacement because there's zero memory savings and it would undoubtedly
> take me some time to retrain my brain :-)
