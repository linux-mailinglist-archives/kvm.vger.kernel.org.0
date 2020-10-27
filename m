Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5A29CC2E
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 23:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757411AbgJ0Wqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 18:46:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:61049 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757005AbgJ0Wqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 18:46:54 -0400
IronPort-SDR: aHjAdtHLbS3vskDut7odSVwp+STR+1m1m0A+bOXr/rhxfsJQG95qa/64fvjk2qQHXe636tMlf/
 CTtIOFlT2VQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="167394579"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="167394579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:46:53 -0700
IronPort-SDR: 8z6ByX/oX8TRbo3l/vwgrZtSk6jRDG9uCION1zqZAuCf13rRqSvpf2x6JlC0jW99l4kfhLJ5st
 VD+5ATXxREHw==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="355715662"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:46:53 -0700
Date:   Tue, 27 Oct 2020 15:46:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Add helper macro for computing
 hugepage GFN mask
Message-ID: <20201027224652.GB2011@linux.intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
 <20201027214300.1342-2-sean.j.christopherson@intel.com>
 <CANgfPd9eZp6pzSZceWD10EZw1mSef+6PSZj=d7g=YzQi-cJt0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANgfPd9eZp6pzSZceWD10EZw1mSef+6PSZj=d7g=YzQi-cJt0A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 03:17:40PM -0700, Ben Gardon wrote:
> On Tue, Oct 27, 2020 at 2:43 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Add a helper to compute the GFN mask given a hugepage level, KVM is
> > accumulating quite a few users with the addition of the TDP MMU.
> >
> > Note, gcc is clever enough to use a single NEG instruction instead of
> > SUB+NOT, i.e. use the more common "~(level -1)" pattern instead of
> > round_gfn_for_level()'s direct two's complement trickery.
> 
> As far as I can tell this patch has no functional changes intended.
> Please correct me if that's not correct.

Correct. :-)

> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/mmu/mmu.c          | 2 +-
> >  arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
> >  arch/x86/kvm/mmu/tdp_iter.c     | 2 +-
> >  4 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d44858b69353..6ea046415f29 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -119,6 +119,7 @@
> >  #define KVM_HPAGE_SIZE(x)      (1UL << KVM_HPAGE_SHIFT(x))
> >  #define KVM_HPAGE_MASK(x)      (~(KVM_HPAGE_SIZE(x) - 1))
> >  #define KVM_PAGES_PER_HPAGE(x) (KVM_HPAGE_SIZE(x) / PAGE_SIZE)
> > +#define KVM_HPAGE_GFN_MASK(x)  (~(KVM_PAGES_PER_HPAGE(x) - 1))
> 
> NIT: I know x follows the convention on adjacent macros, but this
> would be clearer to me if x was changed to level. (Probably for all
> the macros in this block)

Agreed.  I'll spin a v2 and opportunistically change them all to "level"
in this patch.  I'll also add "No function change intended™." to patches
1 and 3.

> >  static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
> >  {
