Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEAF4FEC05
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 03:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiDMBFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 21:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiDMBFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 21:05:15 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B8F22530
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 18:02:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso2913758pjj.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 18:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KpI1kD5PS40ibZjM0D35TPH/+b7l2YUJ66VT/gr7+3I=;
        b=WvEr5jNVtGCO3BZPBqZt3WRaH+qJWPUJ+rs93IIEG+K2bJ3Wt/blAxXxD+jg+m5RUd
         TKEh9acGqoMAwNFo/iZwvIT5HN4JBY8N+7CjG7PADEvLKuwA8OkFZizB3FEZf7bSUB9c
         pDy6TeJW1lmjYQVuQgzprHZjF33F23Uxgf7eet+9mnWnnNU+07ay7Xt0N2XugKQicXBn
         0oRF6f4P7vgwCQUFUaISNiAsixKYit0+u3RnL3LPTCuqshubEKBTALKRCw1KW2xXv6q5
         MOcm9G3pHpI14zHTQSGUsvZX7EdvBv3Jtt+s0+q/WG6iUlZy5LWzj1/478x87JFi9F3b
         S0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KpI1kD5PS40ibZjM0D35TPH/+b7l2YUJ66VT/gr7+3I=;
        b=me7yLQfSwuzB/IDAfPy2jKAeMm6nkPG3MwdoyWvCTIalF1Zdi0qUsKeuWdGdkS/oQ3
         ZaZsGZCZ4hjGyxsUcSHLpzuEzBn879KDHZIRnx51tRhwhibW+YqJYx7dIWKoBFTBFLJi
         JEgXGol24T3y+yPkucvxVEAjDDfvQaoWYfrKFmezCyV8+yVUQr4BtpKEWrNSyobxGbOT
         1fmO/q4DXZcP2Web4Xo+ODiAd0pxyV8bqBhZy057cn1nGi8hTQZF+ek59qtRqBJy9Ldz
         GR66X14EKAvgMxi1kKn10R9LuQy3J9aun3vO5fQW9L4NOBDaTSl330ZwQ+6wkQH5H1Sa
         U5VQ==
X-Gm-Message-State: AOAM532zXz443z8Xqso3nohki1BK4GIi39ri1aHJRykHJBHS5dmz8hcy
        Y+6saEQrVn3VuUtnnOYqi/h2fw==
X-Google-Smtp-Source: ABdhPJxqWTBWdRVUHoEHytrydpTb+wgHLkf9yECQ7JPXA9VzNZCYKDHBFO/AL7hpNzLdXs6Wd+6Akw==
X-Received: by 2002:a17:90a:a509:b0:1ca:c48e:a795 with SMTP id a9-20020a17090aa50900b001cac48ea795mr7872866pjq.165.1649811775498;
        Tue, 12 Apr 2022 18:02:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h19-20020a632113000000b0039d9c5be7c8sm3135296pgh.21.2022.04.12.18.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 18:02:54 -0700 (PDT)
Date:   Wed, 13 Apr 2022 01:02:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlYhO7GvjKY1cwHr@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Apr 11, 2022, David Matlack wrote:
> > >
> > > One thing that would be helpful is if you can explain in a bit more
> > > specifically what you'd like to see. Part of the reason why I prefer
> > > to sequence your proposal after eager page splitting is that I do not
> > > fully understand what you're proposing, and how complex it would be.
> > > e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> > > for nested MMUs does not sound like less churn.
> >
> > Oh, it's most definitely not less code, and probably more churn.  But, it's churn
> > that pushes us in a more favorable direction and that is desirable long term.  I
> > don't mind churning code, but I want the churn to make future life easier, not
> > harder.  Details below.
> 
> Of course. Let's make sure we're on the same page about what churn
> introduced by this series will make future life harder that we hope to
> avoid. If I understand you correctly, it's the following 2 changes:
> 
>  (a.) Using separate functions to allocate SPs and initialize SPs.
>  (b.) Separating kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page().
> 
> (a.) stems from the fact that SP allocation during eager page
> splitting is made directly rather than through kvm_mmu_memory_caches,
> which was what you pushed for in the TDP MMU implementation. We could
> instead use kvm_mmu_memory_caches for the shadow MMU eager page

...

> So even if we did everything you proposed (which seems like an awful
> lot just to avoid __kvm_mmu_find_shadow_page()), there's a chance we
> would still end up with the exact same code. i.e.
> kvm_mmu_nested_tdp_find_sp() would be implemented by calling
> __kvm_mmu_find_shadow_page(), because it would be a waste to
> re-implement an almost identical function?

I went far enough down this path to know that my idea isn't completely awful,
and wouldn't actually need to fork FNAME(page_fault) at this time, but sadly I
still dislike the end result.

Your assessment that the we'd still end up with very similar (if not quite exact)
code is spot on.  Ditto for your other assertion in (a) about using the caches.

My vote for this series is to go the cache route, e.g. wrap kvm_mmu_memory_caches
in a struct and pass that into kvm_mmu_get_page().  I still think it was the right
call to ignore the caches for the TDP MMU, it gives the TDP MMU more flexibility
and it was trivial to bypass the caches since the TDP MMU was doing its own thing
anyways.

But for the shadow MMU, IMO the cons outweigh the pros.  E.g. in addition to
ending up with two similar but subtly different "get page" flows, passing around
"struct kvm_mmu_page **spp" is a bit unpleasant.  Ditto for having a partially
initialized kvm_mmu_page.  The split code also ends up in a wierd state where it
uses the caches for the pte_list, but not the other allocations.

There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
for the split case and assert that @vcpu is non-null since all of the children
should be direct.

		if (sp->unsync) {
			if (WARN_ON_ONCE(!vcpu)) {
				kvm_mmu_prepare_zap_page(kvm, sp,
							 &invalid_list);
				continue;
			}

			/*
			 * The page is good, but is stale.  kvm_sync_page does
			 * get the latest guest state, but (unlike mmu_unsync_children)
			 * it doesn't write-protect the page or mark it synchronized!
			 * This way the validity of the mapping is ensured, but the
			 * overhead of write protection is not incurred until the
			 * guest invalidates the TLB mapping.  This allows multiple
			 * SPs for a single gfn to be unsync.
			 *
			 * If the sync fails, the page is zapped.  If so, break
			 * in order to rebuild it.
			 */
			if (!kvm_sync_page(vcpu, sp, &invalid_list))
				break;

			WARN_ON(!list_empty(&invalid_list));
			kvm_flush_remote_tlbs(kvm);
		}
