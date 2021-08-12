Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5733EA9B7
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhHLRpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbhHLRpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 13:45:16 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1D8C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:44:50 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z20so14956790lfd.2
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzSi7iYmrmtOx5fJEmZOizgBlKohhjrX2as2U2GYhuU=;
        b=Iuy65cd9QD+W9oRklapTOl/vGpAt69N7AHt7935VmuWT30nUSkBLsSxbBrjsTXF7sd
         oQhFyLJbIV4AG5eZxit2x5DDOhwcVnLN4gXvzkbjwnIbNabPvlFuA71xPSVB/kYfVKFN
         3/C0/AcMW17FPpO++mCmXAQPCNveA2p+lEPQ+RE4fl7mP2z5PMBkuLhz9LaK9T1XyOd8
         Arjc6Jc7Isi4CiCjizQpJFyMBywuVFQInPHSxLqhCpQ9P2Pu3sFJcjGVVVRTG4fub5dI
         EfYh0w3jsVGTHl0lgFqtJB3dUiFCY89HsoHoe2oUSTV33ExdvvdGg76zfUVgynG7kXuf
         d8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzSi7iYmrmtOx5fJEmZOizgBlKohhjrX2as2U2GYhuU=;
        b=idcWHDmDK0NYpidCmPePwZNcTFIgaLnvqpi3mtG/0WVIGPnBqyPTfI40S6yr2c9KuN
         DflXCTpLXg2BLGIoXCGZIYq0fZdGhAehgXDGs3DDW9RyrbUiImPVI5UqouMp8hSlTlsm
         avnOeOfhW+3QiH8DNSH6PcnnkBuOwVoMZu4pEy5+Tj7RdFVlWyNfuLpoNVC9V6+c+ZEx
         2dDh0EavFAzt/BBowdg3l2TPks+xPN2NoV/l83sjtrQNgnwVuGo+vBj9pZtGnto4YIyK
         SoTXZiRHYCQelb0gU0TnUF/A1sH5eZsDMi1YcovB5ogG7OFOyGItbbZvbSEyUxe7NLAv
         TGlA==
X-Gm-Message-State: AOAM531ShcEjC8Iyw+xcul8mj5JwDUASZ3Semy7/dDChxN2ADUgoWB6y
        JGazYf++cj9xLWRaYsbEKDKNaSeoHYBgkCxIh40QBQ==
X-Google-Smtp-Source: ABdhPJyLdg9kDeLpMVF+gSZPAAVGTrEBUw524cIRjyc7CmOwg7IpIIfh71HJuGLLmigiDO7Y7o2kRKmCGT1z8QdbyOE=
X-Received: by 2002:ac2:429a:: with SMTP id m26mr3402699lfh.80.1628790288914;
 Thu, 12 Aug 2021 10:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210807134936.3083984-1-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 12 Aug 2021 10:44:21 -0700
Message-ID: <CALzav=dyNE1qXEgXDiSf87K0Q4P2x8UtL--GDUEtwEGEgL_HPw@mail.gmail.com>
Subject: Re: [PATCH 00/16] KVM: x86: pass arguments on the page fault path via
 struct kvm_page_fault
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 7, 2021 at 6:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This is a revival of Isaku's patches from
> https://lore.kernel.org/kvm/cover.1618914692.git.isaku.yamahata@intel.com/.
> The current kvm page fault handlers passes around many arguments to the
> functions.  To simplify those arguments and local variables, introduce
> a data structure, struct kvm_page_fault, to hold those arguments and
> variables.  struct kvm_page_fault is allocated on stack on the caller
> of kvm fault handler, kvm_mmu_do_page_fault(), and passed around.

(I was out of office for the past few days so I'm just getting around
to this series now.)

Overall it looks good. Thanks for getting it cleaned up and merged
into kvm/queue. I'll get Ben's memslot series applied on top of this,
do a bit of performance testing, and send it out probably tomorrow or
early next week.

>
> The patches were redone from scratch based on the suggested struct layout
> from the review (https://lore.kernel.org/kvm/YK65V++S2Kt1OLTu@google.com/)
> and the subjects of Isaku's patches, so I kept authorship for myself
> and gave him a "Suggested-by" tag.
>
> The first two steps are unrelated cleanups that come in handy later on.
>
> Paolo
>
> Paolo Bonzini (16):
>   KVM: MMU: pass unadulterated gpa to direct_page_fault
>   KVM: x86: clamp host mapping level to max_level in
>     kvm_mmu_max_mapping_level
>   KVM: MMU: Introduce struct kvm_page_fault
>   KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
>   KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
>   KVM: MMU: change page_fault_handle_page_track() arguments to
>     kvm_page_fault
>   KVM: MMU: change try_async_pf() arguments to kvm_page_fault
>   KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
>   KVM: MMU: change __direct_map() arguments to kvm_page_fault
>   KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault
>   KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
>   KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to
>     kvm_page_fault
>   KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
>   KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault
>   KVM: MMU: change disallowed_hugepage_adjust() arguments to
>     kvm_page_fault
>   KVM: MMU: change tracepoints arguments to kvm_page_fault
>
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu.h              |  81 ++++++++++-
>  arch/x86/kvm/mmu/mmu.c          | 241 ++++++++++++++------------------
>  arch/x86/kvm/mmu/mmu_internal.h |  13 +-
>  arch/x86/kvm/mmu/mmutrace.h     |  18 +--
>  arch/x86/kvm/mmu/paging_tmpl.h  |  96 ++++++-------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++----
>  arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>  8 files changed, 253 insertions(+), 253 deletions(-)
>
> --
> 2.27.0
>
