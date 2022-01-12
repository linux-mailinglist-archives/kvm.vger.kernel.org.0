Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB56948CF7D
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 00:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiALX6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 18:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiALX6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 18:58:23 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75727C061748
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:58:21 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m1so13757899lfq.4
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VK5Chaiv49hXFhq/Ylsc0Ysn/8XZCZEjh48087/6T5s=;
        b=CXP5z4XbMtStB2d9PuUcRXIVO5u1wT8cwmHLJs0YGKQwRjiKYt1/Tk0QXtRZZ4holj
         y/OlCeKQswYhQwUsfKWm2h1bShIiUysSMn4JRTg0vQi5XoJ6a5Z8Eu/JvnmP9otECLpK
         iiDJypeCFoSJNQxtLemhzXtTiO/QRsEvU1pAPZShCWRMNx80v+CaziPg5etUJWZPaysZ
         ehC7ne/AsDxBCXwqA2E/jnnDlBxuefuwzG1Gc3Lg6KyEX69PDrhoHKr4YopD7G+yqqdE
         aTunWyIUuhbOmUBDtwQ+pYSRIna0NLJZMEtRyLRkLlMk2bONtw+3a80ebwmu8rE/9iyr
         Q6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VK5Chaiv49hXFhq/Ylsc0Ysn/8XZCZEjh48087/6T5s=;
        b=rUv//KhJNzABrbypKMJnb/SgERvbpWd/BPqFVHmpzv5WpGVcoMibwuT3CdgiDT+H5L
         gGRvnFXmW64PG43Paw3KsXVe6V8YQlik1ZBIzzBhIrLBft2bVl8RtylLEesDupadOHdh
         adx48I8wan7z3EkzSEynfBafVBHvqPkQldWv3ljyvtJZ1grCQHZsHItdhtsnT0u2lD24
         T8L0q8G8Z0fa6uBq7bj8PF1HFQBPrrpTy8A1Mpfjhyv1Su+lRnlPQ6YVHASutqUstKtX
         QkjHAUTa9Esse0B1ak7IX5f7GfLa4vr6h67xHo7kCty6N0dhPwVep6za1XDPtVXLFtHk
         KDvQ==
X-Gm-Message-State: AOAM533fP59uSWyveWudEO2CvX/E4jWyxoWKXrl7YupFnxnPuxLM1paN
        s5cs/uAh4kbpvvR7f9LJ2hFT9rSFRtaJc/g7Rgdfig==
X-Google-Smtp-Source: ABdhPJxbBMMZsx65FTr7xkH2qzCNIJXWQKLWq9YT9VDe7v6J32fvzh2n0Ofg11bMRozjknwvBDhqdY2xzka1QXDsYhU=
X-Received: by 2002:a05:651c:904:: with SMTP id e4mr1294012ljq.198.1642031899579;
 Wed, 12 Jan 2022 15:58:19 -0800 (PST)
MIME-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com> <20220112215801.3502286-2-dmatlack@google.com>
 <Yd9g1KIoNwUPtFrt@google.com>
In-Reply-To: <Yd9g1KIoNwUPtFrt@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 12 Jan 2022 15:57:53 -0800
Message-ID: <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jan 12, 2022, David Matlack wrote:
> > When the TDP MMU is write-protection GFNs for page table protection (as
> > opposed to for dirty logging, or due to the HVA not being writable), it
> > checks if the SPTE is already write-protected and if so skips modifying
> > the SPTE and the TLB flush.
> >
> > This behavior is incorrect because the SPTE may be write-protected for
> > dirty logging. This implies that the SPTE could be locklessly be made
> > writable on the next write access, and that vCPUs could still be running
> > with writable SPTEs cached in their TLB.
> >
> > Fix this by unconditionally setting the SPTE and only skipping the TLB
> > flush if the SPTE was already marked !MMU-writable or !Host-writable,
> > which guarantees the SPTE cannot be locklessly be made writable and no
> > vCPUs are running the writable SPTEs cached in their TLBs.
> >
> > Technically it would be safe to skip setting the SPTE as well since:
> >
> >   (a) If MMU-writable is set then Host-writable must be cleared
> >       and the only way to set Host-writable is to fault the SPTE
> >       back in entirely (at which point any unsynced shadow pages
> >       reachable by the new SPTE will be synced and MMU-writable can
> >       be safetly be set again).
> >
> >   and
> >
> >   (b) MMU-writable is never consulted on its own.
> >
> > And in fact this is what the shadow MMU does when write-protecting guest
> > page tables. However setting the SPTE unconditionally is much easier to
> > reason about and does not require a huge comment explaining why it is safe.
>
> I disagree.  I looked at the code+comment before reading the full changelog and
> typed up a response saying the code should be:
>
>                 if (!is_writable_pte(iter.old_spte) &&
>                     !spte_can_locklessly_be_made_writable(spte))
>                         break;
>
> Then I went read the changelog and here we are :-)
>
> I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
> writable and can't be made writable, there's nothing to do".

Oh interesting. I actually find that confusing because it can easily
lead to the MMU-writable bit staying set. Here we are protecting GFNs
and we're opting to leave the MMU-writable bit set. It takes a lot of
digging to figure out that this is safe because if MMU-writable is set
and the SPTE cannot be locklessly be made writable then it implies
Host-writable is clear, and Host-writable can't be reset without
syncing the all shadow pages reachable by the MMU. Oh and the
MMU-writable bit is never consulted on its own (e.g. We never iterate
through all SPTEs to find the ones that are !MMU-writable).

Maybe my understanding is horribly off since this all seems
unnecessarily convoluted, and the cost of always clearing MMU-writable
is just an extra bitwise-OR.

The TLB flush is certainly unnecessary if the SPTE is already
!Host-writable, which is what this commit does.

>
> Versus "unconditionally clear the writable bits because ???, but only flush if
> the write was actually necessary", with a slightly opinionated translation :-)

If MMU-writable is already clear we can definitely break. I had that
in a previous version of the patch by checking if iter.old_spte ==
new_spte but it seemed unnecessary since the guts of
tdp_mmu_spte_set() already optimizes for this.

>
> And with that, you don't need to do s/spte_set/flush.  Though I would be in favor
> of a separate patch to do s/spte_set/write_protected here and in the caller, to
> match kvm_mmu_slot_gfn_write_protect().

I'm not sure write_protected would not be a good variable name because
even if we did not write-protect the SPTE (i.e. PT_WRITABLE_MASK was
already clear) we may still need a TLB flush to ensure no CPUs have a
writable SPTE in their TLB. Perhaps we have different definitions for
"write-protecting"?
