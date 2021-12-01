Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259646544D
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 18:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351950AbhLAR5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 12:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351940AbhLAR5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 12:57:43 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75304C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 09:54:21 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id n12so65063208lfe.1
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 09:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASpYe4fTZuFJFBy76LHw+jQZUmq9o5mOcEnCFmoh6dM=;
        b=oCmZe89mgiAkUxgwKvO58fj1kkVgbpu34EX/FxZWBfx3nIRGg/tn18BVRjSKspsRuT
         8hRRDMw8zTCdjOB95lMDJxbOR++QrhSBJC7iTnFPFJXCKYE6xkrsQFYw/zQngybMV57W
         Tw+Xm+9J5v1TfvnOOor70ERDmSK/yPegm07FV8JrwmR+D16kutykXHTX5jlhKzrfdVHM
         j9SAIwQ3LWLInqAOGpSC+KmDfg0rfgL+KtBoTjKl2/ipU7j8gUEruVEtPypg2M+ZCjff
         /rxX/FSnjOMM76+Hj7qRORNg1HwVus5qCIAmciRbeKa1z4TjhWCXMtwsndgMSNTEoxOA
         mdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASpYe4fTZuFJFBy76LHw+jQZUmq9o5mOcEnCFmoh6dM=;
        b=HzuYWEwpnYYlxZUd6RFqNOCO1MMNihhA4lKKaLtq/1W59CTRem+Cty/I4BVV8z0gBc
         hw4rKZkRQGOcHRw8FuqR9PwMzOBHNFwfPLbP9QIK7YtybFw9SPYuOfS/zYna6YqSPKc2
         XtnPsIwkJUad/aA8NSuXOXx199gANr8gFEw0D8YUxbz6W6AFxT5ciqXzXxCnTU5fEEnV
         H1FkJLkXJ9nLVorfQKWN7tDyAzsoMY685+tmpHBY4sUKyavTBQTVi3zbZURKy6hs7KiM
         4Fw6QkeaXbJ7OJDEW6E1ICu041Gx9Sxk+0SjHZjZdRIPIOYC8jQRiRDF1UJaCuCJR2ru
         fl9g==
X-Gm-Message-State: AOAM532U5+Kl2SPqlXxnVxza6t7wJq3UkQp7nBlVXCvKJA7TSQwNG5z3
        lnNYBkRSwIkPWF9z3NY1T4H0L5vic3WjhsCu6uj1Mw==
X-Google-Smtp-Source: ABdhPJzGNpYPFmbmsGfoz1vDVDqtKsbdDXGiPeMW4Ql44kSQpp63zJdh9DRs6vntWmDfl4BXuTnNzPKbIDDLkQ7nBM0=
X-Received: by 2002:a05:6512:3503:: with SMTP id h3mr7333063lfs.235.1638381259203;
 Wed, 01 Dec 2021 09:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 09:53:52 -0800
Message-ID: <CALzav=cRRW2ZdotseqV+eKcu2oxehkkzKjYYDc3PA=Lw16JrGQ@mail.gmail.com>
Subject: Re: [PATCH 00/28] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
> number of TLB flushes, and to clean up the zapping code.  The final patch
> realizes the biggest change, which is to use RCU to defer any TLB flush
> due to zapping a SP to the caller.  The largest cleanup is to separate the
> flows for zapping roots (zap _everything_), zapping leaf SPTEs (zap guest
> mappings for whatever reason), and zapping a specific SP (NX recovery).
> They're currently smushed into a single zap_gfn_range(), which was a good
> idea at the time, but became a mess when trying to handle the different
> rules, e.g. TLB flushes aren't needed when zapping a root because KVM can
> safely zap a root if and only if it's unreachable.
>
> For booting an 8 vCPU, remote_tlb_flush (requests) goes from roughly
> 180 (600) to 130 (215).
>
> Please don't apply patches 02 and 03, they've been posted elsehwere and by
> other people.  I included them here because some of the patches have
> pseudo-dependencies on their changes.  Patch 01 is also posted separately.
> I had a brain fart and sent it out realizing that doing so would lead to
> oddities.

What's the base commit for this series?

>
> Hou Wenlong (1):
>   KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
>
> Sean Christopherson (27):
>   KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier
>     unmapping
>   KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible
>     path
>   KVM: x86/mmu: Retry page fault if root is invalidated by memslot
>     update
>   KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP
>     MMU
>   KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush
>     logic
>   KVM: x86/mmu: Document that zapping invalidated roots doesn't need to
>     flush
>   KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
>   KVM: x86/mmu: Require mmu_lock be held for write in unyielding root
>     iter
>   KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU
>     root
>   KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP
>     removal
>   KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier
>     change_spte
>   KVM: x86/mmu: Drop RCU after processing each root in MMU notifier
>     hooks
>   KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
>   KVM: x86/mmu: Take TDP MMU roots off list when invalidating all roots
>   KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
>   KVM: x86/mmu: Terminate yield-friendly walk if invalid root observed
>   KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw
>     vals
>   KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
>   KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
>     hook
>   KVM: x86/mmu: Add TDP MMU helper to zap a root
>   KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
>   KVM: x86/mmu: Use "zap root" path for "slow" zap of all TDP MMU SPTEs
>   KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
>   KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
>   KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
>   KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU
>     resched
>   KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow
>     pages
>
>  arch/x86/kvm/mmu/mmu.c          |  74 +++--
>  arch/x86/kvm/mmu/mmu_internal.h |   7 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
>  arch/x86/kvm/mmu/tdp_iter.c     |   6 +-
>  arch/x86/kvm/mmu/tdp_iter.h     |  15 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 526 +++++++++++++++++++-------------
>  arch/x86/kvm/mmu/tdp_mmu.h      |  48 +--
>  7 files changed, 406 insertions(+), 273 deletions(-)
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
