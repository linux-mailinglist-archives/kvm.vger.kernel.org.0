Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA00D749FF8
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjGFOy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjGFOxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:53:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB691FC7;
        Thu,  6 Jul 2023 07:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688655174; x=1720191174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7TWDTrZhqpzH7WQViyzB8gJRad/lUc15Zt3pA8KbCZI=;
  b=NOsBcAXWHEPGB6y1Dtgg7QVx9K+nPaoNJbMwiEX8DH3l3Wgaj8yJMVui
   9QYKrFTM2mDkESEyU2v+Yx7mLO3TS0g9uze/mZiHZaczkcvVYvxPJ1bh/
   cLfqOTlygiup5BMQqikimzp5kcaVzagSF+lEr8GIzVb4gxRXpDX0q86h9
   ZpdNkv3i8s3y9WmkVw8JTDvOqrfRdlFFFMpdMYjshGCbwUyiliMdf+gdC
   IaPHeekFlzNVSScHfP3RD/bA+OaedZ1jQ82tjjGgTUvygPrw0qDPai2BE
   BLuJajr9YvWcQn6rWsE2qJDT4+Qe/ViBpWKt/ruha5N1PCJvy9Eluvg5/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="394380265"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="394380265"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 07:52:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="669777985"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="669777985"
Received: from hegang-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.31.139])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2023 07:52:50 -0700
Date:   Thu, 6 Jul 2023 22:52:47 +0800
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
Message-ID: <20230706145247.ddjqsvmfdeimzva6@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com>
 <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
 <20230705105343.iounmlflfued7lco@linux.intel.com>
 <CAD=HUj5ezWt7rLAv2qOpFsMHyFU87Hqtw_p8pWNF5+oxbLhxDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=HUj5ezWt7rLAv2qOpFsMHyFU87Hqtw_p8pWNF5+oxbLhxDg@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 02:29:24PM +0900, David Stevens wrote:
> On Wed, Jul 5, 2023 at 7:53 PM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
> >
> > On Wed, Jul 05, 2023 at 06:22:59PM +0900, David Stevens wrote:
> > > On Wed, Jul 5, 2023 at 12:10 PM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
> > > >
> > > > > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> > > > >   * The slow path to get the pfn of the specified host virtual address,
> > > > >   * 1 indicates success, -errno is returned if error is detected.
> > > > >   */
> > > > > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> > > > > -                        bool interruptible, bool *writable, kvm_pfn_t *pfn)
> > > > > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
> > > > >  {
> > > > > -     unsigned int flags = FOLL_HWPOISON;
> > > > > +     unsigned int flags = FOLL_HWPOISON | FOLL_GET | foll->flags;
> > > > >       struct page *page;
> > > > >       int npages;
> > > > >
> > > > >       might_sleep();
> > > > >
> > > > > -     if (writable)
> > > > > -             *writable = write_fault;
> > > > > -
> > > > > -     if (write_fault)
> > > > > -             flags |= FOLL_WRITE;
> > > > > -     if (async)
> > > > > -             flags |= FOLL_NOWAIT;
> > > > > -     if (interruptible)
> > > > > -             flags |= FOLL_INTERRUPTIBLE;
> > > > > -
> > > > > -     npages = get_user_pages_unlocked(addr, 1, &page, flags);
> > > > > +     npages = get_user_pages_unlocked(foll->hva, 1, &page, flags);
> > > > >       if (npages != 1)
> > > > >               return npages;
> > > > >
> > > > > +     foll->writable = (foll->flags & FOLL_WRITE) && foll->allow_write_mapping;
> > > > > +
> > > > >       /* map read fault as writable if possible */
> > > > > -     if (unlikely(!write_fault) && writable) {
> > > > > +     if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> > > >
> > > > I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.
> > >
> > > The two statements are logically equivalent, although I guess using
> > > !(foll->flags & FOLL_WRITE) may be a little clearer, if a little more
> > > verbose.
> >
> > Well, as the comment says, we wanna try to map the read fault as writable
> > whenever possible. And __gfn_to_pfn_memslot() will only set the FOLL_WRITE
> > for write faults. So I guess using !foll->writable will not allow this.
> > Did I miss anything?
> 
> We just set the foll->writable out parameter to be equal to
> ((foll->flags & FOLL_WRITE) && foll->allow_write_mapping). Taking a =
> foll->flags & FOLL_WRITE and b = foll->allow_write_mapping, we have
> !(a && b) && b -> (!a || !b) && b -> (!a && b) || (!b && b) -> !a &&
> b.

Ouch, my bad again... I typed "!foll->writable", but missed the "!" in
my head while calculating... Thanks! :)

B.R.
Yu
