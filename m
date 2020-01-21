Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4848614462D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 22:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAUVEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 16:04:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:9889 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgAUVEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 16:04:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 13:04:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="280731336"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jan 2020 13:04:05 -0800
Date:   Tue, 21 Jan 2020 13:04:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and
 generation
Message-ID: <20200121210405.GA12692@linux.intel.com>
References: <1579623061-47141-1-git-send-email-pbonzini@redhat.com>
 <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 09:24:07AM -0800, Ben Gardon wrote:
> On Tue, Jan 21, 2020 at 8:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
> > generation number.  A high enough generation number would overwrite the
> > SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted;
> > likewise, setting bits 52 and 53 would also cause an incorrect generation
> > number to be read from the PTE.
> >
> > Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
> > Reported-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 57e4dbddba72..e34ca43d9166 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -418,22 +418,25 @@ static inline bool is_access_track_spte(u64 spte)
> >   * requires a full MMU zap).  The flag is instead explicitly queried when
> >   * checking for MMIO spte cache hits.
> >   */
> > -#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(18, 0)
> > +#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(17, 0)
> 
> I see you're shifting the MMIO high gen mask region to avoid having to
> shift it by 2. Looking at the SDM, I believe using bit 62 for the
> generation number is safe, but I don't recall why it wasn't used
> before.

This patch does use bit 62, see MMIO_SPTE_GEN_HIGH_END below.  It's bit
63 that is being avoided because it would collide with NX and EPT suppress
#VE.

> >
> >  #define MMIO_SPTE_GEN_LOW_START                3
> >  #define MMIO_SPTE_GEN_LOW_END          11
> >  #define MMIO_SPTE_GEN_LOW_MASK         GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
> >                                                     MMIO_SPTE_GEN_LOW_START)
> >
> > -#define MMIO_SPTE_GEN_HIGH_START       52
> > -#define MMIO_SPTE_GEN_HIGH_END         61
> > +/* Leave room for SPTE_SPECIAL_MASK.  */
> > +#define MMIO_SPTE_GEN_HIGH_START       54
> > +#define MMIO_SPTE_GEN_HIGH_END         62
> >  #define MMIO_SPTE_GEN_HIGH_MASK                GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
> >                                                     MMIO_SPTE_GEN_HIGH_START)
> > +
> >  static u64 generation_mmio_spte_mask(u64 gen)
> >  {
> >         u64 mask;
> >
> >         WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
> > +       BUILD_BUG_ON(MMIO_SPTE_GEN_HIGH_START < PT64_SECOND_AVAIL_BITS_SHIFT);
> 
> Would it be worth defining the MMIO_SPTE_GEN masks, SPTE_SPECIAL_MASK,
> SPTE_AD masks, and SPTE_MMIO_MASK in terms of
> PT64_SECOND_AVAIL_BITS_SHIFT? It seems like that might be a more
> robust assertion here.

That was Paolo's original proposal, I (successfully) lobbied for using a
BUILG_BUG_ON so that bugs result in a build failure instead of random
runtime issues, e.g. if PT64_SECOND_AVAIL_BITS_SHIFT was changed to a value
that caused the MMIO gen to overlap NX or even shift beyond bit 63.

https://lkml.kernel.org/r/20191212002902.GM5044@linux.intel.com

> Alternatively, BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK |
> MMIO_SPTE_GEN_LOW_MASK) & SPTE_(MMIO and/or SPECIAL)_MASK)

Or add both BUILD_BUG_ONs.

> >
> >         mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
> >         mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
> > --
> > 1.8.3.1
> >
