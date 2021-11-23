Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE93245998E
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 02:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhKWBTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 20:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhKWBTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 20:19:17 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307F0C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 17:16:10 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p18so15589894plf.13
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 17:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aOapSZPUp0g2vRLPFt2Pwlv4YJeJLNgFW5OzxeO2Az4=;
        b=L7O8jFumaB7EmY5HtnwDKbxvXRB5S0200eENfBFBtzsOYZm0Xb0fZkzugBes9139gc
         LtOpN74gDJingIlx2690zN4s3ahjPf41d0oh+7i5fxL9QxNlx04ZQztrDNs2fR+TBWrL
         vKkkWxwTOM2ac5h2AKvi7Eti26GSgQJzzZ/8CLVEUmQGCqGLL6GdLYXzgO+oE0soWXar
         gWPRAQi+IAhx0fk6JqIv4UUB4QTmtQetbKvGpNtxejn4YJPH/tFMpLGIU7+pEN3rji4R
         4fqvN61jFMP4o95fuRjUpq3IyEfhHZ9DvtxsQ66iBoJpILhFAmVeGDa5Qnud/7kVKy2+
         Qlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aOapSZPUp0g2vRLPFt2Pwlv4YJeJLNgFW5OzxeO2Az4=;
        b=0gonQRaAhCzl6V9osQySdH2wS9XInMG9UKkGWtui3KSm2fdB6Z2n1O0fz70Mtcm7Qk
         8APQVUJaZcsLp/ZixWzaiRFEHgnyvRuVijfmED7UdA9EYyk/Hc7p33+pYgVcxz6R0G4z
         3Ij0lwsR9aWb3mLyxUb+SVsfRDklrsB8rBadluaafVBfQ7UuGxcwki93IjtHsQmH2R1B
         TVL9tsmIjvH8CbLu4XE4zLytwJrzlFzUeCyituP8664zfWUGX0+AzgqrHvcL89MLB9UL
         IH08+ds0RDL1H5lNShljAjR5X1sF/jvuJeA2aXpZypmm/bUuQpWvSycFE21vaRk76Pzh
         6JxQ==
X-Gm-Message-State: AOAM531zdHdBGpj2hASujFJgUxHo5JB6vHByzA8NRyGNrBIez8tcMkjq
        N0wEZGJZDm/clOiRk3kedSptxMOwEeFf9g==
X-Google-Smtp-Source: ABdhPJwy+1KiAnohFRJPtinqi0mLVPo2CYoFy6QQ+dNhNSAJSqwN1dFfxnZhk0fdbHcBKjJRAcLlNw==
X-Received: by 2002:a17:902:c643:b0:141:cf6b:6999 with SMTP id s3-20020a170902c64300b00141cf6b6999mr2068159pls.80.1637630169419;
        Mon, 22 Nov 2021 17:16:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m6sm6829396pgc.17.2021.11.22.17.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 17:16:08 -0800 (PST)
Date:   Tue, 23 Nov 2021 01:16:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 19/28] KVM: x86/mmu: Zap only the target TDP MMU shadow
 page in NX recovery
Message-ID: <YZxA1VAs5FNbjmH9@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-20-seanjc@google.com>
 <CANgfPd83h4dXa-bFY96dkwHfJsdqu65BAzbqztgEhiRcHFquJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd83h4dXa-bFY96dkwHfJsdqu65BAzbqztgEhiRcHFquJw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > @@ -755,6 +759,26 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
> >         return false;
> >  }
> >
> > +bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +       u64 old_spte;
> > +
> > +       rcu_read_lock();
> > +
> > +       old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> > +       if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
> > +               rcu_read_unlock();
> > +               return false;
> > +       }
> > +
> > +       __tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> > +                          sp->gfn, sp->role.level + 1, true, true);
> > +
> > +       rcu_read_unlock();
> > +
> > +       return true;
> > +}
> > +
> 
> Ooooh this makes me really nervous. There are a lot of gotchas to
> modifying SPTEs in a new context without traversing the paging
> structure like this. For example, we could modify an SPTE under an
> invalidated root here. I don't think that would be a problem since
> we're just clearing it, but it makes the code more fragile.

Heh, it better not be a problem, because there are plently of flows in the TDP MMU
that can modify SPTEs under an invalidated root, e.g. fast_page_fault(),
tdp_mmu_zap_leafs(), kvm_age_gfn(), kvm_test_age_gfn(), etc...  And before the
patch that introduced is_page_fault_stale(), kvm_tdp_mmu_map() was even installing
SPTEs into an invalid root!  Anything that takes a reference to a root and yields
(or never takes mmu_lock) can potentially modify a SPTE under an invalid root.

Checking the paging structures for this flow wouldn't change anything.  Invalidating
a root doesn't immediately zap SPTEs, it just marks the root invalid.  The other
subtle gotcha is that kvm_reload_remote_mmus() doesn't actually gaurantee all vCPUs
will have dropped the invalid root or performed a TLB flush when mmu_lock is dropped,
those guarantees are only with respect to re-entering the guest!

All of the above is no small part of why I don't want to walk the page tables:
it's completely misleading as walking the page tables doesn't actually provide any
protection, it's holding RCU that guarantees KVM doesn't write memory it doesn't own.

> Another approach to this would be to do in-place promotion / in-place
> splitting once the patch sets David and I just sent out are merged.  That
> would avoid causing extra page faults here to bring in the page after this
> zap, but it probably wouldn't be safe if we did it under an invalidated root.

I agree that in-place promotion would be better, but if we do that, I think a logical
intermediate step would be to stop zapping unrelated roots and entries.  If there's
a bug that is exposed/introduced by not zapping other stuff, I would much rather it
show up when KVM stops zapping other stuff, not when KVM stops zapping other stuff
_and_ promotes in place.  Ditto for if in-place promotion introduces a bug.

> I'd rather avoid this extra complexity and just tolerate the worse
> performance on the iTLB multi hit mitigation at this point since new
> CPUs seem to be moving past that vulnerability.

IMO, it reduces complexity, especially when looking at the series as a whole, which
I fully realize you haven't yet done :-)  Setting aside the complexities of each
chunk of code, what I find complex with the current TDP MMU zapping code is that
there are no precise rules for what needs to be done in each situation.  I'm not
criticizing how we got to this point, I absolutely think that hitting everything
with a big hammer to get the initial version stable was the right thing to do.

But a side effect of the big hammer approach is that it makes reasoning about things
more difficult, e.g. "when is it safe to modify a SPTE versus when is it safe to insert
a SPTE into the paging structures?" or "what needs to be zapped when the mmu_notifier
unmaps a range?".

And I also really want to avoid another snafu like the memslots with passthrough
GPUs bug, where using a big hammer (zap all) when a smaller hammer (zap SPTEs for
the memslot) _should_ work allows bugs to creep in unnoticed because they're hidden
by overzealous zapping.

> If you think this is worth the complexity, it'd be nice to do a little
> benchmarking to make sure it's giving us a substantial improvement.

Performance really isn't a motivating factor.  Per the changelog, the motivation
is mostly to allow later patches to simplify zap_gfn_range() by having it zap only
leaf SPTEs, and now that I've typed it up, also all of the above :-)
