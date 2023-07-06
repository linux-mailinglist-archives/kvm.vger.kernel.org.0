Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51822749630
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjGFHTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 03:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjGFHTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 03:19:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B051989;
        Thu,  6 Jul 2023 00:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688627975; x=1720163975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2g1bfmb7JvyQO85ZXkV2EeVN1io1hktM1VBz/kom3ng=;
  b=O4kEhY8o19tVgYcLZUToDCznW+quQpWsCCCjWMyDrSZ8iihaqJ8mNRF/
   BpDS+fEjoz6Xuo5dXWsD+GxoVchv0TI9C28zsW5U+I3CmwK6eyRMv/wYa
   DI1SlhnI+D1vJCwhh3xdwcfIMqzL9qI/yez8gKCzOluPHDdFLNuElB0O2
   GOMxYuZQ9GVlx3vpMxoeTBI+1s8WAQE7P0P+LKoEO4mkNg6ZOKB3MIYzy
   7M8qi8cA7mQ/uGlCOqmgIXDJom/FVKEW34yGxByRP0UkstIy/mPoTmOR+
   mzWIXQoLcQ1QqTMKEeScfc1zVRWMZwZNqDudZ0SxrRmsWhk2Q7FS2/R1u
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="367015570"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="367015570"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 00:19:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="784818848"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="784818848"
Received: from hegang-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.31.139])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 00:19:30 -0700
Date:   Thu, 6 Jul 2023 15:19:28 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230706071927.o7gwmryonr3v3dpp@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
 <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 01:52:08PM +0900, David Stevens wrote:
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

I know the A/D status of the refcounted, VM_PFNMAP|VM_IO backed pages
will be recorded. And I have no idea if this is a necessary requirement
either.

But it feels awkward to see the head and the tail ones of non-compound
pages be treated inconsistently. After all, the head page just happens
to have its refcount being 1, it is not a real refcounted page.

So I would suggest to mention such different behehavior in the commit
message at least. :)

> > >
> > > @@ -883,7 +884,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > >   */
> > >  static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
> > >  {
> > > -     bool host_writable;
> > > +     bool host_writable, is_refcounted;
> > >       gpa_t first_pte_gpa;
> > >       u64 *sptep, spte;
> > >       struct kvm_memory_slot *slot;
> > > @@ -940,10 +941,12 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
> > >       sptep = &sp->spt[i];
> > >       spte = *sptep;
> > >       host_writable = spte & shadow_host_writable_mask;
> > > +     // TODO: is this correct?
> > > +     is_refcounted = spte & SPTE_MMU_PAGE_REFCOUNTED;
> > >       slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> > >       make_spte(vcpu, sp, slot, pte_access, gfn,
> > >                 spte_to_pfn(spte), spte, true, false,
> > > -               host_writable, &spte);
> > > +               host_writable, is_refcounted, &spte);
> >
> > Could we restrict that a non-refcounted page shall not be used as shadow page?
> 
> I'm not very familiar with the shadow mmu, so my response might not
> make sense. But do you mean not allowing non-refcoutned pages as the
> guest page tables shadowed by a kvm_mmu_page? It would probably be
> possible to do that, and I doubt anyone would care about the
> restriction. But as far as I can tell, the guest page table is only
> accessed via kvm_vcpu_read_guest_atomic, which handles non-refcounted
> pages just fine.

Sorry, my brain just got baked... Pls just ignore this question :)

B.R.
Yu
