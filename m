Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952AF2DFF54
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgLUSIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgLUSIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 13:08:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E84C0613D6
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:07:42 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q22so6866374pfk.12
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yNO8jGDtlS9/+qaDws58cBrDRouOJiQU2gAopS4B8Vk=;
        b=O5gViP4Il+PXK/jxaMyajx9y3R+wQffH+a0fS4J4ATfsDnWH5gtawwOzYQmikzMgAA
         sxNYcIUIYBPP7hIJZojc4XEVKFAYhl0MBrmcVz6hka7GEL4AINhnxCDSxOudOySrGoEU
         FJFMsexJsPqupWC9zRb2obnd/bq7oiVf6eg4svMnL1l5u7NVut0PFdPHFlsJlxcIESg7
         q/0z0aXSZ2dLNgaTaGPdjLIWe2N4N5I4qo8chOIEdhEJk3Pm0vlYZq6S4GRojmDOWT4r
         I0zbCVKn+h8n3kOxsPDywSgj+F2Ia/sKMcnollo3wRTLTTqkOw/WqFQxDO78uxfTop/U
         H0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yNO8jGDtlS9/+qaDws58cBrDRouOJiQU2gAopS4B8Vk=;
        b=Imid5KfC/XBLm6kBUkcMNCnxAVPwJkGRNJEPFgpjHy9Ll3wlyhHkBNbMkQ7NTfxMfY
         mCy3WQz4QJwwx3IA4fGRjx6L0lnigc1KxD+YmBmVrYtEhU/47EeOwRhD5T2CGlY7sR9T
         XyjwT4np6NG03498ereWJ7yBPr3TgYDIpWovBUSiMzXTOTaaT4/p/UZ88YH833kHRUHv
         X4Z/yjKkOu/TOIwHUCEmYS+Xp/L6MJOV3faLMR+YVcALa2swC1db8oAxDcNNcZt45b8y
         kUxwUEekFQsOuyXv8nr0AAzYxyXiY6OvbURGtQV0jvYtEX+Ftm3Pz+uTsg9lLGZcmBfN
         AiTQ==
X-Gm-Message-State: AOAM532LQSB049ZaMvJS8lx8HwSjeDRercOmt0YS+z+MmP5UAouAHDXq
        E1kVXQi7+Vu/v9mlvn9psVohJWUC6px3UA==
X-Google-Smtp-Source: ABdhPJzwIc6I9BTaZTa+kGOU8pPqqKdAE9u3nMXnJXQ0dAPXewB5flJ6IGkxSWudHvgZDJsiLNTnaQ==
X-Received: by 2002:a63:dd53:: with SMTP id g19mr15929591pgj.291.1608570311088;
        Mon, 21 Dec 2020 09:05:11 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id k15sm17662546pfp.115.2020.12.21.09.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 09:05:10 -0800 (PST)
Date:   Mon, 21 Dec 2020 09:05:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH 1/4] KVM: x86/mmu: Use -1 to flag an undefined spte in
 get_mmio_spte()
Message-ID: <X+DVv3/KjDn1+Iut@google.com>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-2-seanjc@google.com>
 <87tusjtrqp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tusjtrqp.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Return -1 from the get_walk() helpers if the shadow walk doesn't fill at
> > least one spte, which can theoretically happen if the walk hits a
> > not-present PTPDR.  Returning the root level in such a case will cause
> 
> PDPTR

Doh.

> > get_mmio_spte() to return garbage (uninitialized stack data).  In
> > practice, such a scenario should be impossible as KVM shouldn't get a
> > reserved-bit page fault with a not-present PDPTR.
> >
> > Note, using mmu->root_level in get_walk() is wrong for other reasons,
> > too, but that's now a moot point.
> >
> > Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
> > Cc: Ben Gardon <bgardon@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 7 ++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7a6ae9e90bd7..a48cd12c01d7 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3488,7 +3488,7 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
> >  static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
> >  {
> >  	struct kvm_shadow_walk_iterator iterator;
> > -	int leaf = vcpu->arch.mmu->root_level;
> > +	int leaf = -1;
> >  	u64 spte;
> >  
> >  
> > @@ -3532,6 +3532,11 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
> >  	else
> >  		leaf = get_walk(vcpu, addr, sptes);
> >  
> > +	if (unlikely(leaf < 0)) {
> > +		*sptep = 0ull;
> > +		return reserved;
> > +	}
> 
> When SPTE=0 is returned from get_mmio_spte(), handle_mmio_page_fault()
> will return RET_PF_RETRY -- should it be RET_PF_INVALID instead?

No, RET_PF_RETRY is the most appropriate.  A pae_root entry will only be zero if
the corresponding guest PDPTR is !PRESENT, i.e. the page fault is effectively in
the guest context.  The reason I say it should be an impossible condition is
because KVM should also reset the MMU whenever it snapshots the guest's PDPTRs,
i.e. it should be impossible to install a MMIO SPTE if the relevant PDPTR is
!PRESENT, and all MMIO SPTEs should be wiped out if the PDPTRs are reloaded.
I suppose by that argument, this should be a WARN_ON_ONCE, but I'm not sure if
I'm _that_ confident in my analysis :-)

Related side topic, this snippet in get_mmio_spte() is dead code, as the same
check is performed by its sole caller.  I'll send a patch to remove it (unless
Paolo wants a v2 of this series, in which case I'll tack it on the end).

	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
		*sptep = 0ull;
		return reserved;
	}
