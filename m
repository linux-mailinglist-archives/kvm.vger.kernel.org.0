Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414B13E4CC2
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhHITPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhHITPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 15:15:17 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94944C0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 12:14:56 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e19so4079201pla.10
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 12:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z71lr7ALr8yhgNFk9t0UHNkHlIbL+MrfSpKuMWA0Gdg=;
        b=YVNswqj3RzqtdUCaokR8knCfXB0jvPDRV5LdgxJ6C8HQbi2VR5aa7OVGrPfzlCUVn2
         upyUDfslHyeyU5wW48o32z19ZYAvobB1AXj+vg4N/R8BXmmHSUoaAepVcNPnw4VFhVPk
         O2vxbA6kJ+Qn0uWW/yWtpY4S4CIIlEdLxOYQYe+GA1pjGKrLqbU/cQueVVfzXF2nZk2r
         yx/mk13TMcvULK+C5YG5kusmdC+1Euhzad+2Cl2ie75YR7EtYhiYzotmhtQHUtse9ZbQ
         Il6PUpDC0eYsDUTTLgbYgGJXyGlZXLqU2SbDq+C2vPeOeObO/GBVlbFNHqfyfjtrs7Un
         GtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z71lr7ALr8yhgNFk9t0UHNkHlIbL+MrfSpKuMWA0Gdg=;
        b=akQlZ7oYUYECRJV2SA0w7+l1QYUb3dAdu/j89k796olpSclBWk1bCJ6/RGDNIkTvXI
         DDHhJSfEcOe8jjwXlgLG0Y9yAMI7xdMpIF2sNmD4PcFPQBwYWpHdNjScTBfgOgGlJHBd
         CLt9LCuD9HdOwtDEMpvvYQgSdJi6ZDmJXhT5TFhW6LL+uRUvxPG4P5b7wvqxckoNNMK4
         f+zZln6mf5OmhBR9FEsmd1s1fLsMvs3qAjZjXxLXdhE6xnRgm3BDd0FOUbAfZRxjnXMx
         yj0hs3N9E4z7PynenxVtkCx9OrRtYMXxfZyQZ6go7E9O9/bjh34qgDw78qNm8cKq36jg
         SvCg==
X-Gm-Message-State: AOAM5332wodkjYm0bdZgrWPOcIk8P2f4d15YOzNuY8KO6UVk+1uSdy1M
        OwpWagwMAWpdMtvtwQQNe1m1r3uVd8jDFg==
X-Google-Smtp-Source: ABdhPJzuIWt8O8bmIq2TkVYVreUsqsCwzquCtkX2KomoumtcUA3Jc+kI6kQmWcweJczhoUNgdUzzJQ==
X-Received: by 2002:a17:902:6b4b:b029:12b:f96f:dc03 with SMTP id g11-20020a1709026b4bb029012bf96fdc03mr22019481plt.14.1628536495773;
        Mon, 09 Aug 2021 12:14:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e27sm21418503pfj.23.2021.08.09.12.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:14:55 -0700 (PDT)
Date:   Mon, 9 Aug 2021 19:14:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 06/12] KVM: x86: don't disable APICv memslot when
 inhibited
Message-ID: <YRF+qzvH8jbLCuNE@google.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-7-mlevitsk@redhat.com>
 <f221e94c-fb64-a859-de3c-30f883eac657@redhat.com>
 <d3e0ba8085a8b6054e757dac696823f1181a712b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3e0ba8085a8b6054e757dac696823f1181a712b.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Maxim Levitsky wrote:
> On Tue, 2021-08-03 at 10:44 +0200, Paolo Bonzini wrote:
> > Reviewing this patch and the next one together.
> > 
> > On 02/08/21 20:33, Maxim Levitsky wrote:
> > > +static int avic_alloc_access_page(struct kvm *kvm)
> > >  {
> > >  	void __user *ret;
> > >  	int r = 0;
> > >  
> > >  	mutex_lock(&kvm->slots_lock);
> > > +
> > > +	if (kvm->arch.apic_access_memslot_enabled)
> > >  		goto out;
> > 
> > This variable is overloaded between "is access enabled" and "is the 
> > memslot allocated".  I think you should check 
> > kvm->arch.apicv_inhibit_reasons instead in kvm_faultin_pfn.
> > 
> > 
> > > +	if (!activate)
> > > +		kvm_zap_gfn_range(kvm, gpa_to_gfn(APIC_DEFAULT_PHYS_BASE),
> > > +				  gpa_to_gfn(APIC_DEFAULT_PHYS_BASE + PAGE_SIZE));
> > > +
> > 
> > Off by one, the last argument of kvm_zap_gfn_range is inclusive:
> 
> Actually is it? 

Nope.  The actual implementation is exclusive for both legacy and TDP MMU.  And
as you covered below, the fixed and variable MTRR helpers provide exclusive
start+end, so there's no functional bug.  The "0 - ~0" use case is irrevelant
because there can't be physical memory at -4096.

The ~0ull case can be fixed by adding a helper to get the max GFN possible, e.g.
steal this code from kvm_tdp_mmu_put_root()

	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);

and maybe add a comment saying it intentionally ignores guest.MAXPHYADDR (from
CPUID) so that the helper can be used even when CPUID is being modified.

> There are 3 uses of this function.
> Two of them (kvm_post_set_cr0 and one case in update_mtrr) use 0,~0ULL which is indeed inclusive,
> but for variable mtrrs I see that in var_mtrr_range this code:
> 
> *end = (*start | ~mask) + 1;
> 
> and the *end is passed to kvm_zap_gfn_range.
> 
> 
> Another thing I noticed that I added calls to kvm_inc_notifier_count/kvm_dec_notifier_count
> in the kvm_zap_gfn_range but these do seem to have non inclusive ends, thus 
> I need to fix them sadly if this is the case.
> This depends on mmu_notifier_ops and it is not documented well.
> 
> However at least mmu_notifier_retry_hva, does assume a non inclusive range since it checks
> 
> 
> hva >= kvm->mmu_notifier_range_start &&
> 	    hva < kvm->mmu_notifier_range_end
> 
> 
> Also looking at the algorithm of the kvm_zap_gfn_range.
> Suppose that gfn_start == gfn_end and we have a memslot with one page at gfn_start
> 
> Then:
> 
> 
> start = max(gfn_start, memslot->base_gfn); // start = memslot->base_gfn
> end = min(gfn_end, memslot->base_gfn + memslot->npages); // end = memslot->base_gfn
> 
> if (start >= end)
> 	continue;
> 
> In this case it seems that it will do nothing. So I suspect that kvm_zap_gfn_range
> actually needs non inclusive range but due to the facts that it was used much
> it didn't cause trouble.
>
> Another thing I found in kvm_zap_gfn_range:
> 
> kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> 
> But kvm_flush_remote_tlbs_with_address expects (struct kvm *kvm, u64 start_gfn, u64 pages)

Heh, surpise, surprise, a rare path with no architecturally visible effects is
busted :-)

> kvm_flush_remote_tlbs_with_address is also for some reason called twice with
> the same parameters.

It's called twice in the current code because mmu_lock is dropped between handling
the current MMU and the legacy mmu.

> Could you help with that? Am I missing something?

