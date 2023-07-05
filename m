Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818D974828E
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjGEKxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjGEKxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:53:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DCBCE;
        Wed,  5 Jul 2023 03:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688554417; x=1720090417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IBLKigB688l4z6znm/BvrWmSXP37deMHsQcHbbqjCj4=;
  b=fqEEnzvajrUI/25RGHs4GC+xvSCiN/DIaqNP9oxCLnXWyDD0U1HKc5Q6
   aqgxJsDZCrYF2OpmRe2T8kmy0NDuLWqWol8V8UnThK8BtOJT9P/m4A5eG
   vvQF1z3sfOqeroqxFqfqGpBgTy59k3SmOtiUmvQ8845QhB98X7kIAlq7X
   bn5zzem3JajPe4cg49sD/tNfyRYG9cWM7AJEM9xmsAyJF/wtLr7pOzoeQ
   glnvsqxK2Ev8oDiUAvHFSmuzPiRIf4Yj4YH7ettv2g+2JubQi/6vWg5oT
   EAXcJszx1/rsIYNVEx/1F18fgVpTRG+Ny5eVAprvL6sVNF6NKW4+7YoHC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="394063290"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="394063290"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 03:53:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="809217086"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="809217086"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 03:53:33 -0700
Date:   Wed, 5 Jul 2023 18:53:43 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
Message-ID: <20230705105343.iounmlflfued7lco@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com>
 <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 06:22:59PM +0900, David Stevens wrote:
> On Wed, Jul 5, 2023 at 12:10 PM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
> >
> > > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> > >   * The slow path to get the pfn of the specified host virtual address,
> > >   * 1 indicates success, -errno is returned if error is detected.
> > >   */
> > > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> > > -                        bool interruptible, bool *writable, kvm_pfn_t *pfn)
> > > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
> > >  {
> > > -     unsigned int flags = FOLL_HWPOISON;
> > > +     unsigned int flags = FOLL_HWPOISON | FOLL_GET | foll->flags;
> > >       struct page *page;
> > >       int npages;
> > >
> > >       might_sleep();
> > >
> > > -     if (writable)
> > > -             *writable = write_fault;
> > > -
> > > -     if (write_fault)
> > > -             flags |= FOLL_WRITE;
> > > -     if (async)
> > > -             flags |= FOLL_NOWAIT;
> > > -     if (interruptible)
> > > -             flags |= FOLL_INTERRUPTIBLE;
> > > -
> > > -     npages = get_user_pages_unlocked(addr, 1, &page, flags);
> > > +     npages = get_user_pages_unlocked(foll->hva, 1, &page, flags);
> > >       if (npages != 1)
> > >               return npages;
> > >
> > > +     foll->writable = (foll->flags & FOLL_WRITE) && foll->allow_write_mapping;
> > > +
> > >       /* map read fault as writable if possible */
> > > -     if (unlikely(!write_fault) && writable) {
> > > +     if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> >
> > I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.
> 
> The two statements are logically equivalent, although I guess using
> !(foll->flags & FOLL_WRITE) may be a little clearer, if a little more
> verbose.

Well, as the comment says, we wanna try to map the read fault as writable
whenever possible. And __gfn_to_pfn_memslot() will only set the FOLL_WRITE
for write faults. So I guess using !foll->writable will not allow this.
Did I miss anything?

> > > +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> > > +                            bool atomic, bool interruptible, bool *async,
> > > +                            bool write_fault, bool *writable, hva_t *hva)
> > > +{
> > > +     kvm_pfn_t pfn;
> > > +     struct kvm_follow_pfn foll = {
> > > +             .slot = slot,
> > > +             .gfn = gfn,
> > > +             .flags = 0,
> > > +             .atomic = atomic,
> > > +             .allow_write_mapping = !!writable,
> > > +     };
> > > +
> > > +     if (write_fault)
> > > +             foll.flags |= FOLL_WRITE;
> > > +     if (async)
> > > +             foll.flags |= FOLL_NOWAIT;
> > > +     if (interruptible)
> > > +             foll.flags |= FOLL_INTERRUPTIBLE;
> > > +
> > > +     pfn = __kvm_follow_pfn(&foll);
> > > +     if (pfn == KVM_PFN_ERR_NEEDS_IO) {
> >
> > Could we just use KVM_PFN_ERR_FAULT and foll.flags here? I.e.,
> >         if (pfn == KVM_PFN_ERR_FAULT && (foll.flags & FOLL_NOWAIT))?
> > Setting pfn to KVM_PFN_ERR_NEEDS_IO just to indicate an async fault
> > seems unnecessary.
> 
> There are the cases where the fault does not fall within a vma or when
> the target vma's flags don't support the fault's access permissions.
> In those cases, continuing to try to resolve the fault won't cause
> problems per-se, but it's wasteful and a bit confusing. Having
> hva_to_pfn detect whether or not it may be possible to resolve the
> fault asynchronously and return KVM_PFN_ERR_NEEDS_IO if so seems like
> a good idea. It also matches what the existing code does.

Got it. Sounds reasonable. And thanks! :)

B.R.
Yu
