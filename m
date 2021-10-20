Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067D6434F7A
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhJTP7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhJTP6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4E7C06174E
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:56:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p16so16028082lfa.2
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mk0Fw1d85Ctx+UYR5JvQoEBClZUQNjs0O369mrPqXFw=;
        b=etuxTANyHHFxn/JCnCXn/cSvjX5oH38psGo9/gqj6vd7vZJbVfe7+loM4FsXy0OJs4
         RKepimgEpd/dm6cQd9D9sqpKCTfqfBn8MmLzb9DMG6yhIMxd8DfvYC4FdWuNACDHadBA
         r2RzpY0Zt7cFCdeSj5d64dJO2LM6Ye3crlfklWk4hnZorxP+bDG+yUzZjUY0TecrYQ7Q
         6DgI8REXuAF9D29IwaHkRJHKkmp2eR5aUIUmN9Cc5Y1TVFkUmB5XQMX2me7n0oTz37wZ
         weAgDMhHdki0gtWBxsU64jB2uwPAcsNI/SRlv5VUovG7suSqMFEb6W5mAQGo5JXcecro
         4Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mk0Fw1d85Ctx+UYR5JvQoEBClZUQNjs0O369mrPqXFw=;
        b=ByBt7Ht3tMsdoQcBiOTRfrcFWq2G0u/r1uRLLM5IgLmpxJIOoRGJBDOykTrMjrj09K
         sXlNRsdRXIqhp55pGwNqFKeISCp80AOBzUu3Wyl90I6pYa/UjwNONjbBfCU68q1gUjoU
         ciDKSxvEhk7T4lYd59s4HxwH9dJt3tQhCuSzW5WTWrzOId4edlOSeb4iGs36ubHL5DHJ
         xmRlLLeXISXNjqqVinnMBt5oteUo91PBge3DnH5++UMuEtROmsUE8OT4e0x20QVDrT89
         OL15CnmoNRaDLq05PbkWP5Rwb2RHu0n2NtwV7SnWWtkx42sJuX+U3C2QJ+jsa3dJyII8
         SqFA==
X-Gm-Message-State: AOAM532u+bb7MX6GyG9894XW2p3KsEq3tuSRQZxnbnJurO+OG81mixPc
        VoYhQZQuwFyVQw1qGulESNmmJJig5ETrCQsEVdkU+w==
X-Google-Smtp-Source: ABdhPJxpla/OfagpfrBP9uAdqwmY/Y3BFr6oF7A+pooBfrc94hkrkM2Q6g72R02A1g+FI3lf/EbcZFqkWjBGGzgmSYY=
X-Received: by 2002:ac2:5fee:: with SMTP id s14mr81434lfg.537.1634745389914;
 Wed, 20 Oct 2021 08:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-2-senozhatsky@chromium.org> <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
 <YW9vqgwU+/iVooXj@google.com>
In-Reply-To: <YW9vqgwU+/iVooXj@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 20 Oct 2021 08:56:03 -0700
Message-ID: <CALzav=c1LXXWSi-Z0_X35HCyQtv1rh0p2YmJ289J51SHy0DRxg@mail.gmail.com>
Subject: Re: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 6:24 PM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (21/10/19 15:44), David Matlack wrote:
> > On Tue, Oct 19, 2021 at 8:32 AM Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> > >
> > > kvm_mmu_pte_prefetch is a per-VCPU structure that holds a PTE
> > > prefetch pages array, lock and the number of PTE to prefetch.
> > >
> > > This is needed to turn PTE_PREFETCH_NUM into a tunable VM
> > > parameter.
> > >
> > > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 12 +++++++
> > >  arch/x86/kvm/mmu.h              |  4 +++
> > >  arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++++---
> > >  arch/x86/kvm/x86.c              |  9 +++++-
> > >  4 files changed, 77 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 5271fce6cd65..11400bc3c70d 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -607,6 +607,16 @@ struct kvm_vcpu_xen {
> > >         u64 runstate_times[4];
> > >  };
> > >
> > > +struct kvm_mmu_pte_prefetch {
> > > +       /*
> > > +        * This will be cast either to array of pointers to struct page,
> > > +        * or array of u64, or array of u32
> > > +        */
> > > +       void *ents;
> > > +       unsigned int num_ents;
> > > +       spinlock_t lock;
> >
> > The spinlock is overkill. I'd suggest something like this:
> > - When VM-ioctl is invoked to update prefetch count, store it in
> > kvm_arch. No synchronization with vCPUs needed.
> > - When a vCPU takes a fault: Read the prefetch count from kvm_arch. If
> > different than count at last fault, re-allocate vCPU prefetch array.
> > (So you'll need to add prefetch array and count to kvm_vcpu_arch as
> > well.)
> >
> > No extra locks are needed. vCPUs that fault after the VM-ioctl will
> > get the new prefetch count. We don't really care if a prefetch count
> > update races with a vCPU fault as long as vCPUs are careful to only
> > read the count once (i.e. use READ_ONCE(vcpu->kvm.prefetch_count)) and
> > use that. Assuming prefetch count ioctls are rare, the re-allocation
> > on the fault path will be rare as well.
>
> So reallocation from the faul-path should happen before vCPU takes the
> mmu_lock?

Yes. Take a look at mmu_topup_memory_caches for an example of
allocating in the fault path prior to taking the mmu lock.

> And READ_ONCE(prefetch_count) should also happen before vCPU
> takes mmu_lock, I assume, so we need to pass it as a parameter to all
> the functions that will access prefetch array.

Store the value of READ_ONCE(prefetch_count) in struct kvm_vcpu_arch
because you also need to know if it changes on the next fault. Then
you also don't have to add a parameter to a bunch of functions in the
fault path.

>
> > Note: You could apply this same approach to a module param, except
> > vCPUs would be reading the module param rather than vcpu->kvm during
> > each fault.
> >
> > And the other alternative, like you suggested in the other patch, is
> > to use a vCPU ioctl. That would side-step the synchronization issue
> > because vCPU ioctls require the vCPU mutex. So the reallocation could
> > be done in the ioctl and not at fault time.
>
> One more idea, wonder what do you think:
>
> There is an upper limit on the number of PTEs we prefault, which is 128 as of
> now, but I think 64 will be good enough, or maybe even 32. So we can always
> allocate MAX_PTE_PREFETCH_NUM arrays in vcpu->arch and ioctl() will change
> ->num_ents only, which is always in (0, MAX_PTE_PREFETCH_NUM - 1] range. This
> way we never have to reallocate anything, we just adjust the "maximum index"
> value.

128 * 8 would be 1KB per vCPU. That is probably reasonable, but I
don't think the re-allocation would be that complex.

>
> > Taking a step back, can you say a bit more about your usecase?
>
> We are looking at various ways of reducing the number of vm-exits. There
> is only one VM running on the device (a pretty low-end laptop).

When you say reduce the number of vm-exits, can you be more specific?
Are you trying to reduce the time it takes for vCPUs to fault in
memory during VM startup? I just mention because there are likely
other techniques you can apply that would not require modifying KVM
code (e.g. prefaulting the host memory before running the VM, using
the TDP MMU instead of the legacy MMU to allow parallel faults, using
hugepages to map in more memory per fault, etc.)
