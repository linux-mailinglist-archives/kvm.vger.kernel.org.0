Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E171B3F8E22
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 20:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbhHZSuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 14:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhHZSuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 14:50:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6C0C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:49:32 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z1so4999812ioh.7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RVUTQwfXwIWJ8KSHNLLKmgxbQdeuJteYiwLVXKrHs2E=;
        b=RlH7+pWHb6AHxbU3UBBJJ37bcoBxFJ+OtQc00AVbSygJknZ/usx11UO93s13G1kXX9
         CcZJrRyf0UdTbKCwUaojenkX5SVnXL9NHwvsqqAY/zQ//p0C+YM4cQD7FneQjJ3tB8Aa
         cMrJUpb9BQzx2jUWBC1kV31Q8634J4jt38JtglF1vnnYuD+EgmbxuiAdKNe0yIPy5viO
         tbjYlVlNGUw9dtSd01/0cTaV2aGVOlCz1pzGl7CAV/zNmDWjdq1bz6VMh9cU5i4GYnxj
         4F3MA1cOOAlb0UtfQ1G0jAbM/WTqp+4jaVkgoa7ZNZ7B4nBPcn1mEfwDWFAId+KT8PYw
         UaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RVUTQwfXwIWJ8KSHNLLKmgxbQdeuJteYiwLVXKrHs2E=;
        b=HcZgTJtKVw4c5huz58v6OMo7ckyBeuP2qdK3+9MfwcKiaFikm9m69f1JiJ06qav9sq
         53kSc/Bz0iXJNj4+GbG4iPv/GkGNIWWw8SnZwCD1Qs/eWD7Sln3/kRZl3BTf7pSI/L74
         UM2Gp9RcYt1VHhTND3fMVVFcnpE9rLGCAtiYcj3JGJtJF39lI+rdzxXGpHUryfILrpie
         ImnCN0mfbpp1Es3D/ahPWlV6CkwY40I01TlMtbNCFsqZGU89U+NQB4DdnAE/MwKiN//v
         uYLaocICPjzEX64UqGRazeccFwolUfSYGv+s0BPVVC1p5gN+nbGxgaaCfOXdhJCJt7FL
         tp/g==
X-Gm-Message-State: AOAM531EEkDBd6Iw7dkHwWbMRaKFjBQY4h9N8twGRd3gLjIbLvbo/bt4
        1eON7v6R/3nmTRm2robsPLarZA==
X-Google-Smtp-Source: ABdhPJx5cxoJqj5jt4PGdlUhbRpwDMVgyY3ef2R2HYspFPIJb/ORtT336DtZE2lfPru1xakwQbOqEA==
X-Received: by 2002:a6b:3c16:: with SMTP id k22mr4252523iob.130.1630003771571;
        Thu, 26 Aug 2021 11:49:31 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a11sm2067749ilf.79.2021.08.26.11.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:49:30 -0700 (PDT)
Date:   Thu, 26 Aug 2021 18:49:27 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        pshier@google.com, ricarkol@google.com, rananta@google.com,
        reijiw@google.com, jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YSfiN3Xq1vUzHeap@google.com>
References: <YSVhV+UIMY12u2PW@google.com>
 <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
 <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dg8ppnt.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> On Wed, 25 Aug 2021 19:14:59 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> 
> [...]
> 
> > > Thanks for including me Marc. I think you've mentioned all the examples
> > > of why we don't generally expect N+1 -> N migrations to work that I
> > > can think of. While some of the examples like get-reg-list could
> > > eventually be eliminated if we had CPU models to tighten our machine type
> > > state, I think N+1 -> N migrations will always be best effort at most.
> > >
> > > I agree with giving userspace control over the exposer of the hypercalls
> > > though. Using pseudo-registers for that purpose rather than a pile of
> > > CAPs also seems reasonable to me.
> > >
> > > And, while I don't think this patch is going to proceed, I thought I'd
> > > point out that the opt-out approach doesn't help much with expanding
> > > our migration support unless we require the VMM to be upgraded first.
> > >
> > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > work as expected, since the source enforce opt-out, but the destination
> > > won't.
> > 
> > Right, there's going to need to be a fence in both kernel and VMM
> > versions. Before the fence, you can't rollback with either component.
> > Once on the other side of the fence, the user may freely migrate
> > between kernel + VMM combinations.
> >
> > > Also, since the VMM doesn't key off the kernel version, for the
> > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > leaving it to the user to ensure they consider everything. opt-in
> > > usually only needs the user to consider what machine type they want to
> > > launch.
> > 
> > Going the register route will implicitly require opt-out for all old
> > hypercalls. We exposed them unconditionally to the guest before, and
> > we must uphold that behavior. The default value for the bitmap will
> > have those features set. Any hypercalls added after that register
> > interface will then require explicit opt-in from userspace.
> 
> I disagree here. This makes the ABI inconsistent, and means that no
> feature can be implemented without changing userspace. If you can deal
> with the existing features, you should be able to deal with the next
> lot.
>
> > With regards to the pseudoregister interface, how would a VMM discover
> > new bits? From my perspective, you need to have two bitmaps that the
> > VMM can get at: the set of supported feature bits and the active
> > bitmap of features for a running guest.
> 
> My proposal is that we have a single pseudo-register exposing the list
> of implemented by the kernel. Clear the bits you don't want, and write
> back the result. As long as you haven't written anything, you have the
> full feature set. That's pretty similar to the virtio feature
> negotiation.

Ah, yes I agree. Thinking about it more we will not need something
similar to KVM_GET_SUPPORTED_CPUID.

So then, for any register where userspace/KVM need to negotiate
features, the default value will return the maximum feature set that is
supported. If userspace wants to constrain features, read out the
register, make sure everything you want is there, and write it back
blowing away the superfluous bits. Given this should we enforce ordering
on feature registers, such that a VMM can only write to the registers
before a VM is started?

Also, Reiji is working on making the identity registers writable for the
sake of feature restriction. The suggested negotiation interface would
be applicable there too, IMO.

Many thanks to both you and Drew for working this out with me.

--
Best,
Oliver
