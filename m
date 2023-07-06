Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208C574A1A8
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjGFP6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 11:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjGFP6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 11:58:12 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8F91BCA;
        Thu,  6 Jul 2023 08:58:09 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6b71cdb47e1so810906a34.2;
        Thu, 06 Jul 2023 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688659088; x=1691251088;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ELX9uuKAjfgek1/p+NwumoGO6BxLWYptg064O9OiHBc=;
        b=eom9rNUvY8PSvEiS2yEy5jzWdJZzDvOogRDYqmeCMmwnH49PDRAlb6A64DC/BsFdvw
         8sB/gBTWnJUy3Vf5sxBQdnzN798+8M5al/Six8srqG7vFuN2j7eIGkCoIn1jGVbxOdlQ
         k0TJlPB+p1leNL2pQtt57MxN0BJjUABkoTMJ7K06jyI0oSeTnDNIW3BFtD36isceJnhC
         Ov1RKDxVv9ttVhyc/ajzhjVYQ408TrEBueG0oqMFX09h5Wm5fiw3CBKSJWuZpbbW9mDl
         fzgNaq6H/z5+MW47FmpSbb1giv9UrEZWmHwC2aEaPtVkw0QUhiZaco32bqgO4JpuPB+3
         c8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688659088; x=1691251088;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ELX9uuKAjfgek1/p+NwumoGO6BxLWYptg064O9OiHBc=;
        b=AUApLFpYG4JtsH8Ada6zAVwbzfKHCysmoLg0f02x7s+1Ee1xvVc/p2JzJMHVwz3v9e
         srLriQcIVb4lS3Q1iXV/z4hpGaYQUi74niKJZdEEL0pV+Gfrf+nBFIEXDObq1FIxPpiK
         qbtOBnw3jw/E/gs4syooJI9JYL2MDfHwUKFXI0sLtBuu1/2D4t5753+n6aCWTlgLdgPk
         7ArsZ6Y/68We2enz2YeYreHKWdaclBxhP5tzpClodOSDsq9DVbqxceUI4YWFVQCmnIMa
         JgZkzKTwbRAaLt2WXnCH5ACHVeSjhl4OvgsDZx8ScmGj24c0X7nl+3lkbrY63sjlg1Cj
         gqvw==
X-Gm-Message-State: ABy/qLbzbckLuIUsRDDTjM9DyN2v6fzWVe3HMuIDOdzOco0iIjNloGWO
        LjA4N04rX+xPX0KqZMBjzj0=
X-Google-Smtp-Source: APBJJlFDnf5rOYi7hzzNB1UrOiVyacVt/Eu6Y2AcAbTzk9CE0nP6/LyCfIuOIjrJ9jJQIFHGu3ZFYg==
X-Received: by 2002:a05:6830:1e42:b0:6b7:4e97:343 with SMTP id e2-20020a0568301e4200b006b74e970343mr2928881otj.27.1688659088029;
        Thu, 06 Jul 2023 08:58:08 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id q17-20020a656a91000000b005533c53f550sm1366282pgu.45.2023.07.06.08.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 08:58:07 -0700 (PDT)
Date:   Thu, 6 Jul 2023 08:58:05 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230706155805.GD3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
 <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 01:52:08PM +0900,
David Stevens <stevensd@chromium.org> wrote:

> On Wed, Jul 5, 2023 at 7:17 PM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
> >
> > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > From: David Stevens <stevensd@chromium.org>
> > >
> > > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to map
> > > memory into the guest that is backed by un-refcounted struct pages - for
> > > example, higher order non-compound pages allocated by the amdgpu driver
> > > via ttm_pool_alloc_page.
> >
> > I guess you mean the tail pages of the higher order non-compound pages?
> > And as to the head page, it is said to be set to one coincidentally[*],
> > and shall not be considered as refcounted.  IIUC, refcount of this head
> > page will be increased and decreased soon in hva_to_pfn_remapped(), so
> > this may not be a problem(?). But treating this head page differently,
> > as a refcounted one(e.g., to set the A/D flags), is weired.
> >
> > Or maybe I missed some context, e.g., can the head page be allocted to
> > guest at all?
> 
> Yes, this is to allow mapping the tail pages of higher order
> non-compound pages - I should have been more precise in my wording.
> The head pages can already be mapped into the guest.
> 
> Treating the head and tail pages would require changing how KVM
> behaves in a situation it supports today (rather than just adding
> support for an unsupported situation). Currently, without this series,
> KVM can map VM_PFNMAP|VM_IO memory backed by refcounted pages into the
> guest. When that happens, KVM sets the A/D flags. I'm not sure whether
> that's actually valid behavior, nor do I know whether anyone actually
> cares about it. But it's what KVM does today, and I would shy away
> from modifying that behavior without good reason.
> 
> > >
> > > The bulk of this change is tracking the is_refcounted_page flag so that
> > > non-refcounted pages don't trigger page_count() == 0 warnings. This is
> > > done by storing the flag in an unused bit in the sptes.
> >
> > Also, maybe we should mention this only works on x86-64.
> >
> > >
> > > Signed-off-by: David Stevens <stevensd@chromium.org>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++------------
> > >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> > >  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
> > >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> > >  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
> > >  6 files changed, 62 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e44ab512c3a1..b1607e314497 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> >
> > ...
> >
> > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> > >       bool host_writable = !fault || fault->map_writable;
> > >       bool prefetch = !fault || fault->prefetch;
> > >       bool write_fault = fault && fault->write;
> > > +     bool is_refcounted = !fault || fault->is_refcounted_page;
> >
> > Just wonder, what if a non-refcounted page is prefetched?  Or is it possible in
> > practice?
> 
> Prefetching is still done via gfn_to_page_many_atomic, which sets
> FOLL_GET. That's fixable, but it's not something this series currently
> does.

So if we prefetch a page, REFCOUNTED bit is cleared unconditionally with this
hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for prefetched
spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should represent
whether the corresponding page is ref-countable or not, right?

Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(prefetch_pte)
is shadow paging, we need to test it with legacy KVM MMU or shadow paging to hit
the issue, though.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
