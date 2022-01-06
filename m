Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA16F486D11
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244991AbiAFWJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244946AbiAFWJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:09:19 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF3C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:09:18 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id h7so8767929lfu.4
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zh8WscWyiNvU7md7cxJp2C+yd6i7voS/ejq8w+YcyA=;
        b=l6w8CuqEV3oJv2+v+Ubwm268SBTcJ7beAYEoVs2fgVSnbwI+QFqYv9tVJQGGYd21CI
         gofOVfviZyEYfjWNO8wWZfP3shLo3r/Wf1Vv6XBLMAebUcLLx+i4BS8wy75a9nXc4UXD
         CVjTiGuYjRh+uiuDlqY8Q6u6Z0gZ2OqHqcH0CnjBMV5moLRMdvPD0Apu9dmJhVDU3rKH
         jP7pfBvaOmmHF2EConWFdEn77D7Qwt1KUIjweS9D1Nz0A1EjwTX6Vmf+am6dOIQ/NcFn
         qL3jY9CP1H5OZmHOZ6JybDywyk61fPYBZmutaAXmgAIMC+BfJFDJNOEknfTe206UfEl6
         nFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zh8WscWyiNvU7md7cxJp2C+yd6i7voS/ejq8w+YcyA=;
        b=RXijbAVATpdWSoCo0QQoCJLYY4Ke2jpfWVSTzDa+Xlq7ATknhpvKs/zn+P86+y4cjq
         mCHSmHV0VT0J2kbDREzAOgzIApIuNK0bLX3/zrgV/GwNSR1aEDcJCrcH2F6k7oQZNnCE
         3YdnKx3bvkOKQGpSSuuKz3tInEePcBlWk/HFDrZcd3Cyq0WA+4phCXlMSJH1E2pa+RY+
         IlPSGQWwD4RAW8uCdi85PjlffMY7P6NwKB8mEUcxbjhapdeKJBXHHeI1cFc9rydJGvs8
         64DiGAA5Pur7Wb7ha0LfaAozogHM3hpm+fVBQyp75hMB/+v2TlJvIWAOFOKPon96P2+T
         rNOQ==
X-Gm-Message-State: AOAM530eijbrN3tCTOL/VexF1FIlUPLW82U5Ijr+osNQ8XvsM9Gy8bn9
        cOmVS+fXDAci9nhEVtFakvK3XSq4D5yQ0v/5v6F98g==
X-Google-Smtp-Source: ABdhPJz+MgDfNCz97gohsEJ5bMIfTB+d6359e1eq7RPHVVsfYvL23BIBpkzE55VYCVoL+8ia5M9XDjgNY6krKBZJFnc=
X-Received: by 2002:a05:6512:2003:: with SMTP id a3mr54615123lfb.518.1641506956446;
 Thu, 06 Jan 2022 14:09:16 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-9-dmatlack@google.com>
 <YddYGIoTaFloeENP@google.com>
In-Reply-To: <YddYGIoTaFloeENP@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 14:08:49 -0800
Message-ID: <CALzav=f4XPATmTA4YVMNswy4frCDYScpdA1+69oJ8pkJdT6hCg@mail.gmail.com>
Subject: Re: [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page initialization
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 6, 2022 at 12:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Separate the allocation of child pages from the initialization. This is
>
> "from their initialization" so that it's not a dangling sentence.
>
> > in preparation for doing page splitting outside of the vCPU fault
> > context which requires a different allocation mechanism.
> >
> > No functional changed intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 30 +++++++++++++++++++++++-------
> >  1 file changed, 23 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 582d9a798899..a8354d8578f1 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -157,13 +157,18 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> >               if (kvm_mmu_page_as_id(_root) != _as_id) {              \
> >               } else
> >
> > -static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                            union kvm_mmu_page_role role)
> > +static struct kvm_mmu_page *alloc_tdp_mmu_page_from_caches(struct kvm_vcpu *vcpu)
>
> Hrm, this ends up being a rather poor name because the "from_kernel" variant also
> allocates from a cache, it's just a different cache:
>
>   static struct kvm_mmu_page *alloc_tdp_mmu_page_from_kernel(gfp_t gfp)
>   {
>         struct kvm_mmu_page *sp;
>
>         gfp |= __GFP_ZERO;
>
>         sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
>         if (!sp)
>                 return NULL;
>
>         ...
>   }
>
> Given that the !vcpu path is the odd one, and the only user of the from_kernel
> variant is the split, maybe this?  I.e. punt on naming until another user of the
> "split" variant comes along.
>
>   static struct kvm_mmu_page *__alloc_tdp_mmu_page(struct kvm_vcpu *vcpu)
>
> and
>
>   static struct kvm_mmu_page *__alloc_tdp_mmu_page_for_split(gfp_t gfp)

Will do.

>
> >  {
> >       struct kvm_mmu_page *sp;
> >
> >       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> >       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +
> > +     return sp;
> > +}
> > +
> > +static void init_tdp_mmu_page(struct kvm_mmu_page *sp, gfn_t gfn, union kvm_mmu_page_role role)
>
> Newline.  I'm all in favor of running over when doing so improves readability, but
> that's not the case here.

Ah shoot. I had configured my editor to use a 100 char line limit for
kernel code, but reading the kernel style guide more closely I see
that 80 is still the preferred limit. I'll go back to preferring 80 and
only go over when it explicitly makes the code more readable.


>
> > +{
> >       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> >       sp->role = role;
> > @@ -171,11 +176,9 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       sp->tdp_mmu_page = true;
> >
> >       trace_kvm_mmu_get_page(sp, true);
> > -
> > -     return sp;
> >  }
> >
> > -static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
> > +static void init_child_tdp_mmu_page(struct kvm_mmu_page *child_sp, struct tdp_iter *iter)
>
> Newline.
>
> >  {
> >       struct kvm_mmu_page *parent_sp;
> >       union kvm_mmu_page_role role;
> > @@ -185,7 +188,17 @@ static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, stru
> >       role = parent_sp->role;
> >       role.level--;
> >
> > -     return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
> > +     init_tdp_mmu_page(child_sp, iter->gfn, role);
> > +}
> > +
> > +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
>
> Newline.
>
> > +{
> > +     struct kvm_mmu_page *child_sp;
> > +
> > +     child_sp = alloc_tdp_mmu_page_from_caches(vcpu);
> > +     init_child_tdp_mmu_page(child_sp, iter);
> > +
> > +     return child_sp;
> >  }
> >
> >  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > @@ -210,7 +223,10 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >                       goto out;
> >       }
> >
> > -     root = alloc_tdp_mmu_page(vcpu, 0, role);
> > +     root = alloc_tdp_mmu_page_from_caches(vcpu);
> > +
> > +     init_tdp_mmu_page(root, 0, role);
> > +
> >       refcount_set(&root->tdp_mmu_root_count, 1);
> >
> >       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > --
> > 2.34.1.173.g76aa8bc2d0-goog
> >
