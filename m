Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE803F6888
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbhHXSAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbhHXR77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 13:59:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CCFC08ED8D
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 10:40:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so2854057pjs.3
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 10:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MRfElf5Ktg2ZL34FL8vljahbPh47EMrD1FdyVS+g+o=;
        b=bNZ07zqJSLhYeyR5d7Jb4iWgrARD6Kv3snnrt53OcU6hGM2ZXcKg52lyPlKS/M9nfE
         Z9itCPtOfwJR6mmWNYz2hK1E/aEahDPoH3JAhvNCctvkXn4geR/KJmm0KLR6FH+Nckp9
         mq+wqqysJjUupRx/ED1ySAlh8/by+zl8rYDK2XYtG/I1SthYnPMZkrzeQBCRVbbe2Xyx
         YSzEmJ+8rkaoQzk9oe+OT+88PfGjC5ezP1rg92Zo0hPAacDisujaH6rSP2waujq/ZOfm
         q6kqCm05NYHKizssC9zM9vcFjLutUCIVlz2zFylryHrmPldGBQWCaxhuv4Fe1XyCJkHD
         6eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MRfElf5Ktg2ZL34FL8vljahbPh47EMrD1FdyVS+g+o=;
        b=f7tPRMs/LeTEU1U/J+D7FO93aG0byZz2+aiHih6G325Ut6QaMulSi3VtyYWMVS8+Ij
         IcPqkFsEfcLQBpB0z5I9lEqSy7WvFm3F56E0nZBDE8O4OZbhrusyNZlGP/bdqOiuMdts
         1dd4yS36nCyuM4G1mTvlKQv+x7aPPqtHpt/p214ih5EY9MKOvLMAq66T+916MRtOM2WM
         upVFOwiuOdjw2/7R2AhqQ2Yb0LtNX4qssv4FXlvNNfVth/5l11sDxt2FyJ5orqjm8wEA
         kN05MffCdMfgvPCexs9H8pFo8S8iBnDaNJ0oKmOrFClxucO3GENTmcK1SbCCHabhwjXL
         pJ+g==
X-Gm-Message-State: AOAM530i389MGRL6UsTzjIBbQRK+qko/KuWHJEAM4OdhyjwYVwVTCZsP
        NBuQ2/XS2tu3A61L+LkoMrb0AA==
X-Google-Smtp-Source: ABdhPJxNfb6wPoVgTa5ynkgUH+QlI5xB0tV3Q4uJEWvwhzOK5c/yhrCS5YeIPcSbtAO9ST/2G/HMVw==
X-Received: by 2002:a17:902:7145:b0:137:2e25:5bf0 with SMTP id u5-20020a170902714500b001372e255bf0mr896260plm.10.1629826840089;
        Tue, 24 Aug 2021 10:40:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gn12sm2996444pjb.26.2021.08.24.10.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:40:39 -0700 (PDT)
Date:   Tue, 24 Aug 2021 17:40:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <YSUvESHcms6B3+DA@google.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Maxim Levitsky wrote:
> On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
> > Eduardo Habkost <ehabkost@redhat.com> writes:
> > 
> > > On Tue, Aug 24, 2021 at 3:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > > Eduardo Habkost <ehabkost@redhat.com> writes:
> > > > 
> > > > > On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
> > > > > > diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> > > > > > index ff005fe738a4..92cd4b02e9ba 100644
> > > > > > --- a/arch/x86/kvm/ioapic.c
> > > > > > +++ b/arch/x86/kvm/ioapic.c
> > > > > > @@ -319,7 +319,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
> > > > > >      unsigned index;
> > > > > >      bool mask_before, mask_after;
> > > > > >      union kvm_ioapic_redirect_entry *e;
> > > > > > -    unsigned long vcpu_bitmap;
> > > > > > +    unsigned long vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];

The preferred pattern is:

	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);

> > > > > 
> > > > > Is there a way to avoid this KVM_MAX_VCPUS-sized variable on the
> > > > > stack?  This might hit us back when we increase KVM_MAX_VCPUS to
> > > > > a few thousand VCPUs (I was planning to submit a patch for that
> > > > > soon).
> > > > 
> > > > What's the short- or mid-term target?
> > > 
> > > Short term target is 2048 (which was already tested). Mid-term target
> > > (not tested yet) is 4096, maybe 8192.
> > > 
> > > > Note, we're allocating KVM_MAX_VCPUS bits (not bytes!) here, this means
> > > > that for e.g. 2048 vCPUs we need 256 bytes of the stack only. In case
> > > > the target much higher than that, we will need to either switch to
> > > > dynamic allocation or e.g. use pre-allocated per-CPU variables and make
> > > > this a preempt-disabled region. I, however, would like to understand if
> > > > the problem with allocating this from stack is real or not first.
> > > 
> > > Is 256 bytes too much here, or would that be OK?
> > > 
> > 
> > AFAIR, on x86_64 stack size (both reqular and irq) is 16k, eating 256

Don't forget i386!  :-)

> > bytes of it is probably OK. I'd start worrying when we go to 1024 (8k
> > vCPUs) and above (but this is subjective of course).

256 is fine, 1024 would indeed be problematic, e.g. CONFIG_FRAME_WARN defaults to
1024 on 32-bit kernels.  That's not a hard limit per se, but ideally KVM will stay
warn-free on all flavors of x86.

> On the topic of enlarging these bitmaps to cover all vCPUs.
> 
> I also share the worry of having the whole bitmap on kernel stack for very
> large number of vcpus.
> Maybe we need to abstract and use a bitmap for a sane number of vcpus, 
> and use otherwise a 'kmalloc'ed buffer?

That's a future problem.  More specifically, it's the problem of whoever wants to
push KVM_MAX_VCPUS > ~2048.  There are a lot of ways to solve the problem, e.g.
this I/O APIC code runs under a spinlock so a dedicated bitmap in struct kvm_ioapic
could be used to avoid a large stack allocation.

> Also in theory large bitmaps might affect performance a bit.

Maybe.  The only possible degredation for small VMs, i.e. VMs that don't need the
full bitmap, is if the compiler puts other variables below the bitmap and causes
sub-optimal cache line usage.  But I suspect/hope the compiler is smart enough to
use GPRs and/or organize the local variables on the stack so that doesn't happen.
