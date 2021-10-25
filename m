Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88290439A9B
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 17:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhJYPlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 11:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhJYPlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 11:41:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFB6C061746
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 08:39:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i5so8198141pla.5
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 08:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4JnvwWaRo4iE6zeN8DeflI8kuZhLv6TYtgEJ2sN18X0=;
        b=rom/C+7mjkBstnMy4kARza9EAU5haDsedag9MF1Zu7WU30XMVtslLTmJS9nsVH/4aW
         LNokxElJgsig45c3pYprJDavuno9wsjLPEDvcv2TmfyACdG1j+kqyg0m61VF0UlNa8tN
         bNr/6RFoZUqOaFUtnGwIjrWXcjPhkjdNjwZvYIvi9+Paf91n/6uv1CtnXCGKqXzseRh9
         e4FJz23pel7svPYBsPeOA6lQHq3pGX4Ey2yj9jakwJsv9q3O841Q2pye58s7OKYDA7SC
         i55TfAFVvcdF4XpsBgH+W0sUNZPXciJE+DCU+NoWxrU1xv+JziMARtTkFyWDQnzWxNp6
         URzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4JnvwWaRo4iE6zeN8DeflI8kuZhLv6TYtgEJ2sN18X0=;
        b=3x6MP+l2n6OVXnw/3OnagxS+fSsTsxe1my/6k2yke73XgCsVFnQoAMX9s22Z78oNxb
         5Xndqpvuju0kDRX2P8IZQddTc0OBh4CZrgnIO0sFLc2fH8ScVpCHHkCH94AFYVKVWsKJ
         ErqeW1VMfiMHkEN31tPiogrxutZdA4UvcMzW0xuc0LBodh5QpC3YGbV4W5tvwG3O0Lqp
         sZsN7pNl30VuPYjjUeePEZlwk3aPXT01Mydv0o8d0YFIfZUCs6GNdeSMehhxe/IBmK0P
         dk+upkSj/fiJxkFa0898VuMawZZ6ZGlHsqs8M+Q5PoObajZwynqgxIu6LCO9geqOh5Fg
         D/RQ==
X-Gm-Message-State: AOAM530gsxvnigPqvSjACxM+vHaFSNwT1id9HkJBwDFMEsJnl3G7+dlW
        ithLceMATeDxOcWKKMWAD8GEzA==
X-Google-Smtp-Source: ABdhPJz4HZ3w/aq90jYLL/t0p9f4pVly7t0P3O7N0DVqxyTCNjrxnpFqCJU0OLTcZE9ycxEHw7uDLw==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr24322651pjt.37.1635176369106;
        Mon, 25 Oct 2021 08:39:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id om5sm19094195pjb.36.2021.10.25.08.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 08:39:28 -0700 (PDT)
Date:   Mon, 25 Oct 2021 15:39:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Drop a redundant remote TLB flush in
 kvm_zap_gfn_range()
Message-ID: <YXbPrOXlSMJrVaqA@google.com>
References: <20211022010005.1454978-1-seanjc@google.com>
 <20211022010005.1454978-3-seanjc@google.com>
 <ed34e089-5a35-2502-5a7d-ad8b1cf6957f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed34e089-5a35-2502-5a7d-ad8b1cf6957f@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021, Maciej S. Szmigiero wrote:
> On 22.10.2021 03:00, Sean Christopherson wrote:
> > Remove an unnecessary remote TLB flush in kvm_zap_gfn_range() now that
> > said function holds mmu_lock for write for its entire duration.  The
> > flush was added by the now-reverted commit to allow TDP MMU to flush while
> > holding mmu_lock for read, as the transition from write=>read required
> > dropping the lock and thus a pending flush needed to be serviced.
> > 
> > Fixes: 5a324c24b638 ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"")
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > Cc: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 ---
> >   1 file changed, 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f82b192bba0b..e8b8a665e2e9 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5700,9 +5700,6 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >   						end - 1, true, flush);
> >   			}
> >   		}
> > -		if (flush)
> > -			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> > -							   gfn_end - gfn_start);
> >   	}
> >   	if (is_tdp_mmu_enabled(kvm)) {
> > 
> 
> Unfortunately, it seems that a pending flush from __kvm_zap_rmaps()
> can be reset back to false by the following line:
> > flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start, gfn_end, flush);
> 
> kvm_tdp_mmu_zap_gfn_range() calls __kvm_tdp_mmu_zap_gfn_range with
> "can_yield" set to true, which passes it to zap_gfn_range, which has
> this code:
> > if (can_yield &&
> >     tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> >       flush = false;
> >       continue;
> > }

That's working by design.  If the MMU (legacy or TDP) yields during zap, it _must_
flush before dropping mmu_lock so that any SPTE modifications are guaranteed to be
observed by all vCPUs.  Clearing "flush" is deliberate/correct as another is flush
is needed if and only if additional SPTE modifications are made.


static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
					     struct tdp_iter *iter, bool flush,
					     bool shared)
{
	/* Ensure forward progress has been made before yielding. */
	if (iter->next_last_level_gfn == iter->yielded_gfn)
		return false;

	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
		rcu_read_unlock();

		if (flush)
			kvm_flush_remote_tlbs(kvm);  <------- ****** HERE ******

		if (shared)
			cond_resched_rwlock_read(&kvm->mmu_lock);
		else
			cond_resched_rwlock_write(&kvm->mmu_lock);

		rcu_read_lock();

		WARN_ON(iter->gfn > iter->next_last_level_gfn);

		tdp_iter_restart(iter);

		return true;
	}

	return false;
}
