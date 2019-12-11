Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75011BCA5
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 20:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbfLKTN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 14:13:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:56799 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfLKTN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 14:13:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 11:13:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="245397493"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 11 Dec 2019 11:13:27 -0800
Date:   Wed, 11 Dec 2019 11:13:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
Message-ID: <20191211191327.GI5044@linux.intel.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
 <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
 <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 10:39:22AM -0800, Ben Gardon wrote:
> Has anyone tested this patch on a long-running machine? It looks like
> the SPTE_MMIO_MASK overlaps with the bits used to track MMIO
> generation number, which makes me think that on a long running VM, a
> high enough generation number would overwrite the SPTE_SPECIAL_MASK
> region and cause the MMIO SPTE to be misinterpreted. It seems like
> setting bits 52 and 53 would also cause an incorrect generation number
> to be read from the PTE.

Hmm, the MMIO SPTE won't be misintrepreted as MMIO SPTEs will always have
bits 53:52=11b, i.e. bits 10:9 of the generation number effectively get
ignored.  It does mean that check_mmio_spte() could theoretically consume
stale MMIO entries due those bits being ignored, but only if a SPTE lived
across 512 memslot updates, which is impossible given that KVM currently
zaps all SPTEs on a memslot update (fast zapping can let a stale SPTE live
for while the memslot update is in progress, but not longer than that).

There is/was the pass-through issue that cropped up when I tried to stop
zapping all SPTEs on a memslot update, but I doubt this would explain that
problem.

Assuming we haven't missed something, the easiest fix would be to reduce
the MMIO generation by one bit and use bits 62:54 for the MMIO generation.

> On Fri, Sep 27, 2019 at 4:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > Currently, we are overloading SPTE_SPECIAL_MASK to mean both
> > "A/D bits unavailable" and MMIO, where the difference between the
> > two is determined by mio_mask and mmio_value.
> >
> > However, the next patch will need two bits to distinguish
> > availability of A/D bits from write protection.  So, while at
> > it give MMIO its own bit pattern, and move the two bits from
> > bit 62 to bits 52..53 since Intel is allocating EPT page table
> > bits from the top.
> >
> > Reviewed-by: Junaid Shahid <junaids@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 -------
> >  arch/x86/kvm/mmu.c              | 28 ++++++++++++++++++----------
> >  2 files changed, 18 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 23edf56cf577..50eb430b0ad8 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -219,13 +219,6 @@ enum {
> >                                  PFERR_WRITE_MASK |             \
> >                                  PFERR_PRESENT_MASK)
> >
> > -/*
> > - * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
> > - * Access Tracking SPTEs. We use bit 62 instead of bit 63 to avoid conflicting
> > - * with the SVE bit in EPT PTEs.
> > - */
> > -#define SPTE_SPECIAL_MASK (1ULL << 62)
> > -
> >  /* apic attention bits */
> >  #define KVM_APIC_CHECK_VAPIC   0
> >  /*
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 5269aa057dfa..bac8d228d82b 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -83,7 +83,16 @@ enum {
> >  #define PTE_PREFETCH_NUM               8
> >
> >  #define PT_FIRST_AVAIL_BITS_SHIFT 10
> > -#define PT64_SECOND_AVAIL_BITS_SHIFT 52
> > +#define PT64_SECOND_AVAIL_BITS_SHIFT 54
> > +
> > +/*
> > + * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
> > + * Access Tracking SPTEs.
> > + */
> > +#define SPTE_SPECIAL_MASK (3ULL << 52)
> > +#define SPTE_AD_ENABLED_MASK (0ULL << 52)
> > +#define SPTE_AD_DISABLED_MASK (1ULL << 52)
> > +#define SPTE_MMIO_MASK (3ULL << 52)
