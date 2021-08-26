Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210A13F902F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 23:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhHZVg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 17:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhHZVgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 17:36:25 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C68C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:35:38 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l10so4777331ilh.8
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjf5k/4LGu/VKE/74uCD3RNhClu4tQPAgKlOCuWM+IE=;
        b=RdK2k7svMeppUYTFEqP3Z80P/Z/0oxZXSu0k5H3JnQ0aucPp3J/xMi3CbPvX/4pwoO
         plEmtha7+abcpG4+UQY1za6l4uRod8L4ea6qJOL997zfnPHUXnI2niTdt7NsyxdEv5Rl
         oM83PcwqsyvddAW2YwV6VytJx/EFB6WLpcQRFElN1u93JtThi3ICBnVA/D9+Nbg2KjiW
         X3M+SFT5NkMEl5Xkb9guEjWQffL/EOwpU9Tmhxzh2nnouh0GoHjCsM8kwFcyCi7cGgil
         O9xr862aswoySolE/Uce4EM23J7V8rfUrHmbIvw6Ey+UyRj5zcVVIZ7g5fSIJecWbZJ6
         8MgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjf5k/4LGu/VKE/74uCD3RNhClu4tQPAgKlOCuWM+IE=;
        b=Y7piFDhRtJlCREHCUO9MW7TbZOhbWsJY/TY52BpAlCC2OLRtJtdZIzP5dcjjca44nR
         PebOlGoYBG7AA25LxLQl3di22QCGbdduPQdJvDVtdTnZKwgqRMG/odX9QMn+evKH3Tth
         erx9R7i8y2P8sR55MOA83/YVfLaBwiuhfkiPXK/di+I2i/3f20/M0Zgt5x1+PeifMtie
         X8U3f1eIe4aXgpvt097cldi55TABHT6OFogTMw55+5I3+4w6iFPmzf0oK97aMQOMi3qa
         IUsN4zOfe7vGrd03ecKupoAKWyPWqyiNbJoCvda4rhqY6542s/tmc09dAl3vBYWocQDJ
         8wDw==
X-Gm-Message-State: AOAM533iTPO4JirxFfUNy9pOuaN2mctGvk4PtgBAoS8n/dTezOQPnkZa
        T+rEhZG7oQbeMCUsmzrMqLB3kR/c7zhjpe1SkpDslA==
X-Google-Smtp-Source: ABdhPJzoYcsVq2LpOtxESPi6FhUKwj6LS4F63JAolkjEObIRKYkocWT+b8WRutOKcOqdnO/RAclr5qfvstYnY2kBh5I=
X-Received: by 2002:a92:d586:: with SMTP id a6mr4067917iln.283.1630013737153;
 Thu, 26 Aug 2021 14:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210818235615.2047588-1-seanjc@google.com> <CAJhGHyDWsti6JpYmLhoDfxtaxWC3wFeWzM3NWubqmd=_4ENc3Q@mail.gmail.com>
In-Reply-To: <CAJhGHyDWsti6JpYmLhoDfxtaxWC3wFeWzM3NWubqmd=_4ENc3Q@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 26 Aug 2021 14:35:26 -0700
Message-ID: <CANgfPd---jQ-eO3thxu4bvE+1DkuRXyhjfmZ5dLO6OUQdDsOAA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Complete prefetch for trailing SPTEs for
 direct, legacy MMU
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 3:49 PM Lai Jiangshan
<jiangshanlai+lkml@gmail.com> wrote:
>
> On Thu, Aug 19, 2021 at 7:57 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Make a final call to direct_pte_prefetch_many() if there are "trailing"
> > SPTEs to prefetch, i.e. SPTEs for GFNs following the faulting GFN.  The
> > call to direct_pte_prefetch_many() in the loop only handles the case
> > where there are !PRESENT SPTEs preceding a PRESENT SPTE.
> >
> > E.g. if the faulting GFN is a multiple of 8 (the prefetch size) and all
> > SPTEs for the following GFNs are !PRESENT, the loop will terminate with
> > "start = sptep+1" and not prefetch any SPTEs.
> >
> > Prefetching trailing SPTEs as intended can drastically reduce the number
> > of guest page faults, e.g. accessing the first byte of every 4kb page in
> > a 6gb chunk of virtual memory, in a VM with 8gb of preallocated memory,
> > the number of pf_fixed events observed in L0 drops from ~1.75M to <0.27M.
> >
> > Note, this only affects memory that is backed by 4kb pages as KVM doesn't
> > prefetch when installing hugepages.  Shadow paging prefetching is not
> > affected as it does not batch the prefetches due to the need to process
> > the corresponding guest PTE.  The TDP MMU is not affected because it
> > doesn't have prefetching, yet...
> >
> > Fixes: 957ed9effd80 ("KVM: MMU: prefetch ptes when intercepted guest #PF")
> > Cc: Sergey Senozhatsky <senozhatsky@google.com>
> > Cc: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> > ---
> >
> > Cc'd Ben as this highlights a potential gap with the TDP MMU, which lacks
> > prefetching of any sort.  For large VMs, which are likely backed by
> > hugepages anyways, this is a non-issue as the benefits of holding mmu_lock
> > for read likely masks the cost of taking more VM-Exits.  But VMs with a
> > small number of vCPUs won't benefit as much from parallel page faults,
> > e.g. there's no benefit at all if there's a single vCPU.

Yeah, that probably does represent a reduction in performance for very
small VMs. Besides keeping read critical sections small, there's no
reason not to do prefetching with the TDP MMU, it just needs to be
implemented.

> >
> >  arch/x86/kvm/mmu/mmu.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a272ccbddfa1..daf7df35f788 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2818,11 +2818,13 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> >                         if (!start)
> >                                 continue;
> >                         if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
> > -                               break;
> > +                               return;
> >                         start = NULL;
> >                 } else if (!start)
> >                         start = spte;
> >         }
> > +       if (start)
> > +               direct_pte_prefetch_many(vcpu, sp, start, spte);

It might be worth explaining some of what you laid out in the commit
description here. This function's implementation is not the easiest to
read.

> >  }
>
>
> Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
>
> >
> >  static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> >
