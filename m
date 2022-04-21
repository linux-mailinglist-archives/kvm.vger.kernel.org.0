Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6392750A688
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiDURG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDURG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:06:57 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1084992A
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:04:07 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id b95so9890338ybi.1
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mt5d94ouBNRgK4aft9t5vNr0uFkR55z3XwWAQdD5FUc=;
        b=HrQ6SnoElb85r6De0Gyb6QYtmGW0UZZHoRqYniWGXxhbAJxdJBxxDoGjWfFzlyLHCa
         iS6FEOJghE+gwwbiFuO/qzE+v0/xWyacDc/dig/lj0OLYAFuIqjszn6bBifsCmbCzGIr
         ZlEiv9/ngqKNSNChcABhKOqkpYvRxWU6mu2hEvjbWIdvs8nbFLsj6ub4GEwaRL1dxgib
         GQJBc2PA+Rsc0hrZUet+I8zxDXI7xr1LxSnpddJMeRCy6DAIJcYqCV9Dw81JA9zuNR8F
         b6jtRfyhxgw76JMs9k0bR9BotnAZkTT7vy8KrdVPkKxBKDPwT/PbrInF9l6bNSyIIZE8
         hL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mt5d94ouBNRgK4aft9t5vNr0uFkR55z3XwWAQdD5FUc=;
        b=tVmj5LHVSKBj6MArq6QAXMa1rMVZn/w07sIa4pqP6xDA6PMuuWQIs9ELW+QJDetdFE
         FQSICk1relVYThB53HIiRLHdnUkizZ1yM3DIJ34FAycm3+rh29+eeb3m+EY6Oz6DNhMj
         JDfOv5snNX8yeaEoiUELTo/2kZAscDLlIrrgl8Swg28Dh8tiRbz/UX3Juz+pYMDu22hZ
         XKYc/cD+5vs8EPaHK5x16YzBpykjDc7LJv6ijaOkwKfEtmFuX6fMZpCmy7zVOeATz5iB
         KlNsN9G+gOsbIkhS2wGyg/1+zr2/QCNx7DxxJEtwYAwmQ6MDMFBgFIIVHEpiwcGL5LaH
         Koqg==
X-Gm-Message-State: AOAM533NAFo1ODNYTkSPpMvLBPPqoHWVo8kg4uU5AT917Q69MGVXSOvU
        VzzFCmvRdKJdNQW125i4AcP0zAkS6OcCGPO36iCZnA==
X-Google-Smtp-Source: ABdhPJwGlxPxobbr+AhQQh2O9DUBl0dl6jeVvCmp3KF1DE8dxE/HTfIURpAV8tgSrH2T97uM8B8yRKMtO3mXmGlYNio=
X-Received: by 2002:a25:84c6:0:b0:641:5a21:90bc with SMTP id
 x6-20020a2584c6000000b006415a2190bcmr699446ybm.26.1650560646522; Thu, 21 Apr
 2022 10:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-17-oupton@google.com>
 <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com> <YmGKaoStt9Lf9xOP@google.com>
In-Reply-To: <YmGKaoStt9Lf9xOP@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 10:03:55 -0700
Message-ID: <CANgfPd-ebvPq5eqgHz0ED1eSqk0Z-+utoBE8w67uo=GSS+UrpQ@mail.gmail.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
To:     Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 9:46 AM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Apr 21, 2022 at 09:35:27AM -0700, Ben Gardon wrote:
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Voila! Since the map walkers are able to work in parallel there is no
> > > need to take the write lock on a stage 2 memory abort. Relax locking
> > > on map operations and cross fingers we got it right.
> >
> > Might be worth a healthy sprinkle of lockdep on the functions taking
> > "shared" as an argument, just to make sure the wrong value isn't going
> > down a callstack you didn't expect.
>
> If we're going to go this route we might need to just punch a pointer
> to the vCPU through to the stage 2 table walker. All of this plumbing is
> built around the idea that there are multiple tables to manage and
> needn't be in the context of a vCPU/VM, which is why I went the WARN()
> route instead of better lockdep assertions.

Oh right, it didn't even occur to me that those functions wouldn't
have a vCPU / KVM pointer.

>
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 21 +++------------------
> > >  1 file changed, 3 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 63cf18cdb978..2881051c3743 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         gfn_t gfn;
> > >         kvm_pfn_t pfn;
> > >         bool logging_active = memslot_is_logging(memslot);
> > > -       bool use_read_lock = false;
> > >         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> > >         unsigned long vma_pagesize, fault_granule;
> > >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         if (logging_active) {
> > >                 force_pte = true;
> > >                 vma_shift = PAGE_SHIFT;
> > > -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> > > -                                fault_granule == PAGE_SIZE);
> > >         } else {
> > >                 vma_shift = get_vma_page_shift(vma, hva);
> > >         }
> > > @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         if (exec_fault && device)
> > >                 return -ENOEXEC;
> > >
> > > -       /*
> > > -        * To reduce MMU contentions and enhance concurrency during dirty
> > > -        * logging dirty logging, only acquire read lock for permission
> > > -        * relaxation.
> > > -        */
> > > -       if (use_read_lock)
> > > -               read_lock(&kvm->mmu_lock);
> > > -       else
> > > -               write_lock(&kvm->mmu_lock);
> > > +       read_lock(&kvm->mmu_lock);
> > > +
> >
> > Ugh, I which we could get rid of the analogous ugly block on x86.
>
> Maybe we could fold it in to a MMU macro in the arch-generic scope?
> Conditional locking is smelly, I was very pleased to delete these lines :)

Smelly indeed. I don't think hiding it behind a macro would really
help. It's just something we'll have to live with in x86.

>
> --
> Thanks,
> Oliver
