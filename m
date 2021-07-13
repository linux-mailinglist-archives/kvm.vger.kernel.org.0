Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323573C77C3
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhGMUWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMUWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:22:34 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DECC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:19:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y4so20619276pfi.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ApntNZUKGH4ouQpQjiCPIANirQV7gTDdHNRaTDbpwkI=;
        b=AtOjI9/bDSq3Rjimdi/lTu2X5RJ4USrs8ebWyNH6X63y3bZrp7837V6sQUvuLcTyv4
         VtyVHTzRHTl86zcyXa04Ko/aPaXLX6RHfoKq2rUhU1nfHFkpeJ1f9s1Pm7dy4Kt+5eWC
         d/o1ycJX6wU5/3PgMFHVozAtyBn/DqjG4CJQ1qYHhmDQwQkkLEh+O1DIW2xGP7GajfKz
         VAbEY3TpcAlWdQUseO/sWsama1xVFLkxjWboWUPLQ7QhkpkcriDYWIocbkSwF8sED/y7
         CVH15vKlve4Eg7/PKKCrWivT0rsM7+3fCWxadkYZwDxbO5UkZNrMXgV1/JYZdMTeRb2d
         YT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ApntNZUKGH4ouQpQjiCPIANirQV7gTDdHNRaTDbpwkI=;
        b=n1a6uuP2/thITs6iqe14YBJj6CgRZOz6UACKLlZxQ6nQL3scQavpPwy4E6oEFprvsZ
         ImnqrkTIRY3bT2Zgd/4U7F9c/q8tHMOozg1FzD5xDkt8GiSKTIrCVtPdF83gmOAcJrIz
         asp2sn7gH+CIOqVoKxA0pkexNnKG5d44m2LKlVRG7FK/2bfbbzZM74YLAnIyt6kHKo65
         si1yc3ve3xhpBQuRFWSOBlsHrh56uiAVeXyVGBzz080XcoZipAQz8KtPSfbdMhRL0egv
         2YdlSlYRFhZHvxnKavGS8VkGAmfC5ZnS+Pve+OsID9pXt04toRfQtEgB3O4wphXTsK+d
         gF2Q==
X-Gm-Message-State: AOAM533U7II7u7OU3BGjO4CcQvIKbBDcC2mRLUPxv6PdepS1h022o/zr
        AiU1IPNHy2jV8ggTkuieQc/5DQ==
X-Google-Smtp-Source: ABdhPJyPy5xSbrdNySHocck9/UIDyPfB6Nz/gRyKMhpC9oXDBRaudgO55tcL6k+8sEayiyWLkUR7KA==
X-Received: by 2002:a65:56ca:: with SMTP id w10mr5732194pgs.107.1626207583582;
        Tue, 13 Jul 2021 13:19:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k189sm23339698pgk.14.2021.07.13.13.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 13:18:11 -0700 (PDT)
Date:   Tue, 13 Jul 2021 20:17:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 16/69] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot by default
Message-ID: <YO30xgEmqcOr0xlQ@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <78d02fee3a21741cc26f6b6b2fba258cd52f2c3c.1625186503.git.isaku.yamahata@intel.com>
 <3ef7f4e7-cfda-98fe-dd3e-1b084ef86bd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ef7f4e7-cfda-98fe-dd3e-1b084ef86bd4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Zap only leaf SPTEs when deleting/moving a memslot by default, and add a
> > module param to allow reverting to the old behavior of zapping all SPTEs
> > at all levels and memslots when any memslot is updated.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++++-
> >   1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8d5876dfc6b7..5b8a640f8042 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -85,6 +85,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
> >   static bool __read_mostly force_flush_and_sync_on_reuse;
> >   module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> > +static bool __read_mostly memslot_update_zap_all;
> > +module_param(memslot_update_zap_all, bool, 0444);
> > +
> >   /*
> >    * When setting this variable to true it enables Two-Dimensional-Paging
> >    * where the hardware walks 2 page tables:
> > @@ -5480,11 +5483,27 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> >   	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> >   }
> > +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +	/*
> > +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> > +	 * case scenario we'll have unused shadow pages lying around until they
> > +	 * are recycled due to age or when the VM is destroyed.
> > +	 */
> > +	write_lock(&kvm->mmu_lock);
> > +	slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
> > +			  KVM_MAX_HUGEPAGE_LEVEL, true);
> > +	write_unlock(&kvm->mmu_lock);
> > +}
> > +
> >   static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> >   			struct kvm_memory_slot *slot,
> >   			struct kvm_page_track_notifier_node *node)
> >   {
> > -	kvm_mmu_zap_all_fast(kvm);
> > +	if (memslot_update_zap_all)
> > +		kvm_mmu_zap_all_fast(kvm);
> > +	else
> > +		kvm_mmu_zap_memslot(kvm, slot);
> >   }
> >   void kvm_mmu_init_vm(struct kvm *kvm)
> > 
> 
> This is the old patch that broke VFIO for some unknown reason.

Yes, my white whale :-/

> The commit message should at least say why memslot_update_zap_all is not true
> by default.  Also, IIUC the bug still there with NX hugepage splits disabled,

I strongly suspect the bug is also there with hugepage splits enabled, it's just
masked and/or harder to hit.

> but what if the TDP MMU is enabled?

This should not be a module param.  IIRC, the original code I wrote had it as a
per-VM flag that wasn't even exposed to the user, i.e. TDX guests always do the
partial flush and non-TDX guests always do the full flush.  I think that's the
least awful approach if we can't figure out the underlying bug before TDX is
ready for inclusion.
