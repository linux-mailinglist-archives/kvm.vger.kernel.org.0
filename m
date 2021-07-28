Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD23D9818
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 00:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhG1WBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 18:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231903AbhG1WBM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 18:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627509669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pKidz3FSMJhJcIlYfT3swxoQS+3hE6AXtJkM+UemTX0=;
        b=YlYXn6X9nsDPoelomEWSTO/uo2Y1i4od8aOYS5AInAvgK/7dLvKDOARtUUOX4M0quy5b29
        PzCg+y9tPLFIZ1Z5ewF6LOrnq4YqRHFV4iLV/mHvlz+n4EeXadnF03LcxJT2EU++fcLjii
        TldvoYY4sIKTrsdWQln8c/h5A93SANI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-byR-1r3gNGqX3m2doF650Q-1; Wed, 28 Jul 2021 18:01:08 -0400
X-MC-Unique: byR-1r3gNGqX3m2doF650Q-1
Received: by mail-qk1-f197.google.com with SMTP id 13-20020a370e0d0000b02903a5eee61155so2495206qko.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 15:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pKidz3FSMJhJcIlYfT3swxoQS+3hE6AXtJkM+UemTX0=;
        b=dvatQVh9E9wbuHUUL67Tg5KPba753sIRobGFHbR3OwVyAs3uq45LQIjaR7GR63sp3E
         UDoGnSt6qI40dy5s0/+yCxS2rMQ60XDQy0PZEIu/QlGuUgDBeIlw1liZDRbyZwZsp11q
         BKRKTn+8ZCNPC2kz5Woxe8W3mLwYBgMhaWtADjup4dMOuaVIjuMPAOSzmDagZWiNatvn
         C2l44P9dq++7R6ceP0CFotNGi5YJki13Yn5Lue1oL1buSECqjsh+JKlGE2ri75aRP1p2
         MbPCZhPK5bmTNWLymydf3fGNbtMuQHE8iR4B/mPebrGraIEzdr9+o94g7fD6LpDPWEcM
         +bYQ==
X-Gm-Message-State: AOAM531cFzRl78eaI4EyJpWLHZtqqMyPPvb36ZMaJZFb4AIu3o5t/mo+
        pvSW2fiNzFrVCfhdfOEhOFlQbPzu42nsD4FLdmqs0GydeLYlrfT92wFJOaTNTL8EedsOy47go6P
        x3tyQdICQIMCt
X-Received: by 2002:a05:6214:21ee:: with SMTP id p14mr2277312qvj.8.1627509667468;
        Wed, 28 Jul 2021 15:01:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVYy91ZfI5zoJBEKJ3Yd5LRP0ae3BUZQqzdPCj6QgqrfTkFjRd1wt7FFWnSP8Q2X1IkxR3pg==
X-Received: by 2002:a05:6214:21ee:: with SMTP id p14mr2277294qvj.8.1627509667289;
        Wed, 28 Jul 2021 15:01:07 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id o63sm680309qkf.4.2021.07.28.15.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:01:06 -0700 (PDT)
Date:   Wed, 28 Jul 2021 18:01:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 9/9] KVM: X86: Optimize zapping rmap
Message-ID: <YQHTocEdMzsJQuzL@t490s>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153419.43671-1-peterx@redhat.com>
 <YQHOdhMoFW821HAu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQHOdhMoFW821HAu@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:39:02PM +0000, Sean Christopherson wrote:
> On Fri, Jun 25, 2021, Peter Xu wrote:
> > Using rmap_get_first() and rmap_remove() for zapping a huge rmap list could be
> > slow.  The easy way is to travers the rmap list, collecting the a/d bits and
> > free the slots along the way.
> > 
> > Provide a pte_list_destroy() and do exactly that.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 45 +++++++++++++++++++++++++++++++-----------
> >  1 file changed, 33 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ba0258bdebc4..45aac78dcabc 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1014,6 +1014,38 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
> >  	return count;
> >  }
> >  
> > +/* Return true if rmap existed and callback called, false otherwise */
> > +static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
> > +			     int (*callback)(u64 *sptep))
> > +{
> > +	struct pte_list_desc *desc, *next;
> > +	int i;
> > +
> > +	if (!rmap_head->val)
> > +		return false;
> > +
> > +	if (!(rmap_head->val & 1)) {
> > +		if (callback)
> > +			callback((u64 *)rmap_head->val);
> > +		goto out;
> > +	}
> > +
> > +	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> > +
> > +	while (desc) {
> > +		if (callback)
> > +			for (i = 0; i < desc->spte_count; i++)
> > +				callback(desc->sptes[i]);
> > +		next = desc->more;
> > +		mmu_free_pte_list_desc(desc);
> > +		desc = next;
> 
> Alternatively, 
> 
> 	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> 	for ( ; desc; desc = next) {
> 		for (i = 0; i < desc->spte_count; i++)
> 			mmu_spte_clear_track_bits((u64 *)rmap_head->val);
> 		next = desc->more;
> 		mmu_free_pte_list_desc(desc);
> 	}
> 
> > +	}
> > +out:
> > +	/* rmap_head is meaningless now, remember to reset it */
> > +	rmap_head->val = 0;
> > +	return true;
> 
> Why implement this as a generic method with a callback?  gcc is suprisingly
> astute in optimizing callback(), but I don't see the point of adding a complex
> helper that has a single caller, and is extremely unlikely to gain new callers.
> Or is there another "zap everything" case I'm missing?

No other case; it's just that pte_list_*() helpers will be more self-contained.
If that'll be a performance concern, no objection to hard code it.

> 
> E.g. why not this?
> 
> static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> 			  const struct kvm_memory_slot *slot)
> {
> 	struct pte_list_desc *desc, *next;
> 	int i;
> 
> 	if (!rmap_head->val)
> 		return false;
> 
> 	if (!(rmap_head->val & 1)) {
> 		mmu_spte_clear_track_bits((u64 *)rmap_head->val);
> 		goto out;
> 	}
> 
> 	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> 	for ( ; desc; desc = next) {
> 		for (i = 0; i < desc->spte_count; i++)
> 			mmu_spte_clear_track_bits(desc->sptes[i]);
> 		next = desc->more;
> 		mmu_free_pte_list_desc(desc);
> 	}
> out:
> 	/* rmap_head is meaningless now, remember to reset it */
> 	rmap_head->val = 0;
> 	return true;
> }

Looks good, but so far I've no strong opinion on this.  I'll leave it for Paolo
to decide.

Thanks!

-- 
Peter Xu

