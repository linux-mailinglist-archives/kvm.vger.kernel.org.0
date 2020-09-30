Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FC27F5EC
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgI3XYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:24:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:4791 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgI3XYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 19:24:36 -0400
IronPort-SDR: G+gNLcF+Ob1QJ2Jq5/VInePf+rntLQqHBQKZeMztNBxPPpU645gkSw01JyxET6ZLALXwyMVZMm
 WyWKtfJ+Wv0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="150220233"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="150220233"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:24:33 -0700
IronPort-SDR: f4b3ZziJaIx737s5hskNUAVyiWNqYThsApyflfAtet9h4bdzWOQNiDs1XeQdZUy79iHENLWkjb
 k0fUdIsQRbNg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="500081380"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:24:32 -0700
Date:   Wed, 30 Sep 2020 16:24:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 13/22] kvm: mmu: Support invalidate range MMU notifier
 for TDP MMU
Message-ID: <20200930232429.GA2988@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-14-bgardon@google.com>
 <20200930170354.GF32672@linux.intel.com>
 <CANgfPd8mH7XpNzCbObD-XO_Pzc0TK6oNQpTw9rgSdqBV-4trFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8mH7XpNzCbObD-XO_Pzc0TK6oNQpTw9rgSdqBV-4trFw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 04:15:17PM -0700, Ben Gardon wrote:
> On Wed, Sep 30, 2020 at 10:04 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 52d661a758585..0ddfdab942554 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1884,7 +1884,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
> > >  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> > >                       unsigned flags)
> > >  {
> > > -     return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > > +     int r;
> > > +
> > > +     r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > > +
> > > +     if (kvm->arch.tdp_mmu_enabled)
> > > +             r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
> >
> > Similar to an earlier question, is this intentionally additive, or can this
> > instead by:
> >
> >         if (kvm->arch.tdp_mmu_enabled)
> >                 r = kvm_tdp_mmu_zap_hva_range(kvm, start, end);
> >         else
> >                 r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> >
> 
> It is intentionally additive so the legacy/shadow MMU can handle nested.

Duh.  Now everything makes sense.  I completely spaced on nested EPT.

I wonder if would be worth adding a per-VM sticky bit that is set when an
rmap is added so that all of these flows can skip the rmap walks when using
the TDP MMU without a nested guest.
