Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2B34858CA
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 20:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiAETCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243263AbiAETCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 14:02:46 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AD2C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 11:02:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w7so282599plp.13
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 11:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C5TGxSihMQO3IXFdvvnm4Z/BjCSMQVybEIBkkH4uWd0=;
        b=HBJacN4jBaXROANJNZOIsFCQr+cw2jAtH4pkRI5I0lWUCoa92DjpcPfElpngDicJzA
         0YyiOx5jgXBKIJ5sic5Wlmw5GLmGQaw/f6lvVmLi5zTn618CwkkKi6SqMJfbw9DZaCxa
         nfyKvwXyGMHeXdC0ZGBuJhg6GdPua+6zJu52b+eSYfcZZz2KeeKkyOdb1ak69MwvXNS7
         OQJd3WVIpvcprUaSnHlu4JHAKjMloofyJeKbNNo0zyTclI0eQ8VmpfzpTq6iytqyBm2D
         nq++D6Xs4Gg3FrMu2idotXpK7jS54v9lhWU6lSrkp4qK81/QiMV+fhJaBeOdBhMl8lle
         /4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C5TGxSihMQO3IXFdvvnm4Z/BjCSMQVybEIBkkH4uWd0=;
        b=o9ORPTHmbzJkvGAyuP9IM11R+jbLFIp5PFOEH7CApmHGvxzx2uYojhaNdCLdT/RN3D
         zmGoMo9r6Y//JE07TktMpGnfzzce7mP7DfWOOIwLSY6cD0Y2RvwIF+QNn5fNIvd04dEO
         /cyFnP0DJ4b69jyXALqZeLPdbeVdhoTkVzK+YRnNy17rL10qK/dc/Vir7kkyIMETaNwb
         2xNQ284YoOmzicvYrRPiErUWWZJiXTDBkzBIG8rNxkyQ9uzYut4acj5AM6EByDA6y9zW
         V1hjxUFgF4Q0xkRcbiy2rFo5YIWEFlHHFEfiRLH0v8wQ3GrYgs8o1mopBiK5ZXznSJKu
         Nn/g==
X-Gm-Message-State: AOAM53118N7JwbQPocAPA4duhF8dNMEqA9qSwq4dZHZ87pGXMRd3Mg1W
        2vYrjnIMsgRxfA5KqsX/6GV9SA==
X-Google-Smtp-Source: ABdhPJxUdnM3b6DqognTobDbG9Dmm0Ti/SDctNLZ/xAkOE4liZ0NPc+FLQpmerY5LVHMbecEx6BgSQ==
X-Received: by 2002:a17:902:8e84:b0:149:a2cb:4dac with SMTP id bg4-20020a1709028e8400b00149a2cb4dacmr30257117plb.22.1641409365057;
        Wed, 05 Jan 2022 11:02:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y129sm10931675pfy.164.2022.01.05.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:02:44 -0800 (PST)
Date:   Wed, 5 Jan 2022 19:02:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdXrURHO/R82puD4@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, David Stevens wrote:
> On Fri, Dec 31, 2021 at 4:22 AM Sean Christopherson <seanjc@google.com> wrote:
> > >        */
> > > -     if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> > > +     if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
> >
> > Hrm, I know the whole point of this series is to support pages without an elevated
> > refcount, but this WARN was extremely helpful in catching several use-after-free
> > bugs in the TDP MMU.  We talked about burying a slow check behind MMU_WARN_ON, but
> > that isn't very helpful because no one runs with MMU_WARN_ON, and this is also a
> > type of check that's most useful if it runs in production.
> >
> > IIUC, this series explicitly disallows using pfns that have a struct page without
> > refcounting, and the issue with the WARN here is that kvm_is_zone_device_pfn() is
> > called by kvm_is_reserved_pfn() before ensure_pfn_ref() rejects problematic pages,
> > i.e. triggers false positive.
> >
> > So, can't we preserve the use-after-free benefits of the check by moving it to
> > where KVM releases the PFN?  I.e.
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fbca2e232e94..675b835525fa 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2904,15 +2904,19 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
> >
> >  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
> >  {
> > -       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
> > +       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
> > +               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
> >                 SetPageDirty(pfn_to_page(pfn));
> > +       }
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
> 
> I'm still seeing this warning show up via __handle_changed_spte
> calling kvm_set_pfn_dirty:
> 
> [  113.350473]  kvm_set_pfn_dirty+0x26/0x3e
> [  113.354861]  __handle_changed_spte+0x452/0x4f6
> [  113.359841]  __handle_changed_spte+0x452/0x4f6
> [  113.364819]  __handle_changed_spte+0x452/0x4f6
> [  113.369790]  zap_gfn_range+0x1de/0x27a
> [  113.373992]  kvm_tdp_mmu_zap_invalidated_roots+0x64/0xb8
> [  113.379945]  kvm_mmu_zap_all_fast+0x18c/0x1c1
> [  113.384827]  kvm_page_track_flush_slot+0x55/0x87
> [  113.390000]  kvm_set_memslot+0x137/0x455
> [  113.394394]  kvm_delete_memslot+0x5c/0x91
> [  113.398888]  __kvm_set_memory_region+0x3c0/0x5e6
> [  113.404061]  kvm_set_memory_region+0x45/0x74
> [  113.408844]  kvm_vm_ioctl+0x563/0x60c
> 
> I wasn't seeing it for my particular test case, but the gfn aging code
> might trigger the warning as well.

Ah, I got royally confused by ensure_pfn_ref()'s comment

  * Certain IO or PFNMAP mappings can be backed with valid
  * struct pages, but be allocated without refcounting e.g.,
  * tail pages of non-compound higher order allocations, which
  * would then underflow the refcount when the caller does the
  * required put_page. Don't allow those pages here.
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
that doesn't apply here because kvm_faultin_pfn() uses the low level
__gfn_to_pfn_page_memslot().

and my understanding is that @page will be non-NULL in ensure_pfn_ref() iff the
page has an elevated refcount.

Can you update the changelogs for the x86+arm64 "use gfn_to_pfn_page" patches to
explicitly call out the various ramifications of moving to gfn_to_pfn_page()?

Side topic, s/covert/convert in both changelogs :-)

> I don't know if setting the dirty/accessed bits in non-refcounted
> struct pages is problematic.

Without knowing exactly what lies behind such pages, KVM needs to set dirty bits,
otherwise there's a potential for data lost.

> The only way I can see to avoid it would be to try to map from the spte to
> the vma and then check its flags. If setting the flags is benign, then we'd
> need to do that lookup to differentiate the safe case from the use-after-free
> case. Do you have any advice on how to handle this?

Hrm.  I can't think of a clever generic solution.  But for x86-64, we can use a
software available bit to mark SPTEs as being refcounted use that flag to assert
the refcount is elevated when marking the backing pfn dirty/accessed.  It'd be
64-bit only because we're out of software available bits for PAE paging, but (a)
practically no one cares about 32-bit and (b) odds are slim that a use-after-free
would be unique to 32-bit KVM.

But that can all go in after your series is merged, e.g. I'd prefer to cleanup
make_spte()'s prototype to use @fault adding yet another parameter, and that'll
take a few patches to make happen since FNAME(sync_page) also uses make_spte().

TL;DR: continue as you were, I'll stop whining about this :-)
