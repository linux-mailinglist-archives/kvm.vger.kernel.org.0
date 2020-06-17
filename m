Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776DB1FD247
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFQQgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFQQgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 12:36:39 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA88C0613EE
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:36:38 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id q2so1774903vsr.1
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8DsS6xxyGZ4X1I2BsfKE5F+wl5+Bc0v/Cbn7ErCR3k=;
        b=eawpKQDd4c5bCWEDiwcn6BhRKGQcd5albFMeNaZdFKCB6O3sFwD2XAZx9LvvOYi87t
         Zd0041rw93VndgUPf5lk4RuZlA8dXcSVTpu7VYahKPZdbqv05KKeJ7LnJttdizTtluT5
         OYHgJdvNb8dH72kutypMPcXeLhyWIrRgMaS2iyuw/Lr6YD8+6DI8AvQtasmtlXDE9C7F
         FLi5DWCcWK7BKjDne7sZg/HbVdCiwosxxGZDthxyWacUQng42CxceziSSSXk8BO1AWeN
         BJDSiX2/zLffm0wAwppKnLGmoK/ndXvK8/qS5cg9IJUTWjiRKFGR6YFdm/zusqJzzUqC
         dKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8DsS6xxyGZ4X1I2BsfKE5F+wl5+Bc0v/Cbn7ErCR3k=;
        b=FZqzPnKoUd0rRStyazBKiSwE5h9AdIfl7v+i0vcE9ZTzYTNdCuTqs05Ty6J/7Qfy9v
         gkunrIFFmMmNhzolqFxllIMZftkBwsdQju2Zk91mvDklq3pIl+/Cn09uf/2g8TOzNhTs
         Ee4gwPEFoXl0Tqp47TM1m4eJeLbx2a6424T9IsMcVndx4lSa36WvJZ7nUaKYNOyUbW8V
         nW38L5S/iJUDcn93ALkexx+usrIgAdIYDWpLg9/ElBi97xaqZ32pBBQafdNJQoB9RmRi
         yCkzPv5FdyxqO+2oZ3h/JOF1LtOVIO342USUfsOjmCr8ybFJz+xOxw/EtlD2nvR4u6AO
         ni/A==
X-Gm-Message-State: AOAM533SrcNhd7F1iWzbVg4+veJTL4gJECG26X0z68Hu1sHKvsPoMAWy
        VMXM1XWse1G8OykYBVnTMKTW4o8fElVRbp2eWEjQnQ==
X-Google-Smtp-Source: ABdhPJz7oaun07TMv+zayNnAIYVTbbeP778/fuG5Ll7911G7zeLD5BHbO9dbHYGezneDNySTtZXTodF2yXRXfDK1+ZE=
X-Received: by 2002:a67:70c3:: with SMTP id l186mr6698034vsc.117.1592411796250;
 Wed, 17 Jun 2020 09:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-6-sean.j.christopherson@intel.com> <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
 <20200617005309.GA19540@linux.intel.com>
In-Reply-To: <20200617005309.GA19540@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 17 Jun 2020 09:36:25 -0700
Message-ID: <CANgfPd8xkEotTJQPkMOrJNLOLXb4+TOA06wqO16UPdk_icF8tw@mail.gmail.com>
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 5:53 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Jun 10, 2020 at 03:12:04PM -0700, Ben Gardon wrote:
> > On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Attempt to allocate a new object instead of crashing KVM (and likely the
> > > kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> > > allocation as the caches are used while holding mmu_lock.  The immediate
> > > BUG_ON() makes the code unnecessarily explosive and led to confusing
> > > minimums being used in the past, e.g. allocating 4 objects where 1 would
> > > suffice.
> > >
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
> > >  1 file changed, 15 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index ba70de24a5b0..5e773564ab20 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> > >         local_irq_enable();
> > >  }
> > >
> > > +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > +                                              gfp_t gfp_flags)
> > > +{
> > > +       if (mc->kmem_cache)
> > > +               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> > > +       else
> > > +               return (void *)__get_free_page(gfp_flags);
> > > +}
> > > +
> > >  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > >  {
> > >         void *obj;
> > > @@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > >         if (mc->nobjs >= min)
> > >                 return 0;
> > >         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > -               if (mc->kmem_cache)
> > > -                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
> > > -               else
> > > -                       obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> > > +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > >                 if (!obj)
> > >                         return mc->nobjs >= min ? 0 : -ENOMEM;
> > >                 mc->objects[mc->nobjs++] = obj;
> > > @@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> > >  {
> > >         void *p;
> > >
> > > -       BUG_ON(!mc->nobjs);
> > > -       p = mc->objects[--mc->nobjs];
> > > +       if (WARN_ON(!mc->nobjs))
> > > +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> > Is an atomic allocation really necessary here? In most cases, when
> > topping up the memory cache we are handing a guest page fault. This
> > bug could also be removed by returning null if unable to allocate from
> > the cache, and then re-trying the page fault in that case.
>
> The whole point of these caches is to avoid having to deal with allocation
> errors in the low level MMU paths, e.g. propagating an error up from
> pte_list_add() would be a mess.
>
> > I don't know if this is necessary to handle other, non-x86 architectures more
> > easily, but I worry this could cause some unpleasantness if combined with
> > some other bug or the host was in a low memory situation and then this
> > consumed the atomic pool. Perhaps this is a moot point since we log a warning
> > and consider the atomic allocation something of an error.
>
> Yeah, it's the latter.  If we reach this point it's a guaranteed KVM bug.
> Because it's likely that the caller holds a lock, triggering the BUG_ON()
> has a high chance of hanging the system.  The idea is to take the path that
> _may_ crash the kernel instead of killing the VM and more than likely
> crashing the kernel.  And hopefully this code will never be exercised on a
> production kernel.

That makes sense to me. I agree it's definitely positive to replace a
BUG_ON with something else.

>
> > > +       else
> > > +               p = mc->objects[--mc->nobjs];
> > > +       BUG_ON(!p);
> > >         return p;
> > >  }
> > >
> > > --
> > > 2.26.0
> > >
