Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB1A34F834
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 07:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhCaE7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 00:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhCaE7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 00:59:30 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98210C061574;
        Tue, 30 Mar 2021 21:59:23 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so17840165otn.1;
        Tue, 30 Mar 2021 21:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IuFbiB26Sb3dU7rtk02ZCczKB4Gc8hOz5qs5qATXub8=;
        b=WWO7bmjzkeWN+EV+FTJNZ40JsxeXUFjaknr+X6i2DLvgsdvg5UF2OnYFNeHRBQIRCA
         KgjqwTUS0d9Sl8ALq9rDb1wEzlAD9ZYLkOJK7/3GraRMsBcwpBjdCme0rZKmP82pgbHZ
         ruxhbh6fIl85qoEW0QmonZloAnxtyM7VX8pV7Y4u4QrJSszfkKaBNpVGeNTZsekg7nm9
         bSHY19ehHY/8r/6OyDDyzxbUwWYOSxvTFpyyxTepwf0ENWRGSgii45wc0WOXrLV+rwUN
         qzRoHzF6VNJW4k86kPVNE9gUh8eT9j2BDN0yRMUNUgIQ7xApoTX0vmFfilEvqr/ZiPB4
         BOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IuFbiB26Sb3dU7rtk02ZCczKB4Gc8hOz5qs5qATXub8=;
        b=AJyEAzfZedXYb8ZTcoRm8aFD15SjSMKxwNFw4IGqwaRAesGLIIvOa8yLxvQxZ31gRN
         B5LpQDwtbi1Sajs/kg+a8ZM4LAwfpZ55SCiOIAyuxzpoXnK1HEGYuV1wXigP9qjNeOSI
         GmFDtKuFmM639F02EJUpJiXGFkApp6jXBY12z08BjdjXjil3u9hrL80GmpP/KXThlr89
         L1m/GbX2kK9II2vYcGCtVtDu3Q8pB8n82f102XEUjQabplGsWMziqxZlgAJ+umH5gx8e
         I4d9Kb5YFMZdGXafF8JdNREjdcIcc8EAH3c71enPEEPtXXviQ15Y96pb+bCL6x4bgODv
         /kGg==
X-Gm-Message-State: AOAM530g3BXAfFV8z/lBnzlIzzRFzk8Mejp2gFSv97NoPhRz4LN08OIn
        3debi3MaWCH5QdD5gVtOowe1vIhuUDLLaKOog3bSHRiQoRc=
X-Google-Smtp-Source: ABdhPJyNUdNj7gtOw1A943gOBRthVUofJ7aBbkkqjoFB0AKv2WAv8kdYtex1JIOhWvpSQ3+mQ3hHpGfVdz6La5s+e2w=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr1196612otc.56.1617166763033;
 Tue, 30 Mar 2021 21:59:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023025.2485960-1-seanjc@google.com> <20210331023025.2485960-2-seanjc@google.com>
 <CANRm+CwowrYPSnFNc11j5aT2JNw_k+NOh1apoxc3raVD4RVaAg@mail.gmail.com> <YGPrZyIutYQGldO2@google.com>
In-Reply-To: <YGPrZyIutYQGldO2@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 31 Mar 2021 12:59:11 +0800
Message-ID: <CANRm+Cxe0ygrFm=TWZP0_uVEyaCTfq2SoaXRotUGR-anAXOQpQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Account memory allocations for 'struct kvm_vcpu'
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

On Wed, 31 Mar 2021 at 11:24, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 31, 2021, Wanpeng Li wrote:
> > On Wed, 31 Mar 2021 at 10:32, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Use GFP_KERNEL_ACCOUNT for the vCPU allocations, the vCPUs are very much
> > > tied to a single task/VM.  For x86, the allocations were accounted up
> > > until the allocation code was moved to common KVM.  For all other
> > > architectures, vCPU allocations were never previously accounted, but only
> > > because most architectures lack accounting in general (for KVM).
> > >
> > > Fixes: e529ef66e6b5 ("KVM: Move vcpu alloc and init invocation to common code")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 383df23514b9..3884e9f30251 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3182,7 +3182,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> > >         if (r)
> > >                 goto vcpu_decrement;
> > >
> > > -       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> > > +       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
> >
> > kvm_vcpu_cache is created with SLAB_ACCOUNT flag in kvm_init(), this
> > flag will guarantee further slab alloc will be charged to memcg.
> > Please refer to memcg_slab_pre_alloc_hook(). So the patch is
> > unnecessary.
>
> Hmm, I missed that.  However, AFICT only SLAB/SLUB enforce SLAB_ACCOUNT, SLOB
> does not appear to honor the flag.   The caveat to SLOB is that the
> GFP_KERNEL_ACCOUNT will only come into play when allocating new pages, and so
> allocations smaller than a page will be accounted incorrectly (I think).
> But, a vcpu is larger than a page (on x86), which means the vcpu allocation will
> always be correctly accounted.
>
> I've no idea if anyone actually uses KVM+SLOB, let alone cares about accounting

I asked maintainer Christoph in 2013, he told me "Well, I have never
seen non experimental systems that use SLOB. Others have claimed they
exist. It's mostly of academic interest."

> in the that case.  But, it would be nice for KVM to be consistent with the other
> kmem_cache usage in KVM, all of which do double up on SLAB_ACCOUNT +
> GFP_KERNEL_ACCOUNT.
>
> Maybe rewrite the changelog and drop the Fixes?

Agreed.

    Wanpeng
