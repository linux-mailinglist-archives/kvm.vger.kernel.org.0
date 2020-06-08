Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1A1F1ED7
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFHSQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 14:16:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:36448 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgFHSQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 14:16:59 -0400
IronPort-SDR: yD0xONdVeymzeYRomamJp7gXcrO7gP0w2s+E90CISte0kX6EiR8hvjEp+xIG/CR29v2VTOGHTD
 IGlAqEPvUTUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 11:16:58 -0700
IronPort-SDR: emiEpVOSD6jJLw0cunF6upXR3LRNLEH3u0eMcn8k3RwEz6GZM/twKRsAGvD/2VY3Ddl9zagfBt
 2NKanvi6MC2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="349253637"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2020 11:16:58 -0700
Date:   Mon, 8 Jun 2020 11:16:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>,
        Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Ignore KVM 5-level paging support for
 VM_MODE_PXXV48_4K
Message-ID: <20200608181658.GD8223@linux.intel.com>
References: <20200528021530.28091-1-sean.j.christopherson@intel.com>
 <ed65de29-a07a-f424-937e-38576e740de7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed65de29-a07a-f424-937e-38576e740de7@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 01:55:44PM +0200, Paolo Bonzini wrote:
> On 28/05/20 04:15, Sean Christopherson wrote:
> > Explicitly set the VA width to 48 bits for the x86_64-only PXXV48_4K VM
> > mode instead of asserting the guest VA width is 48 bits.  The fact that
> > KVM supports 5-level paging is irrelevant unless the selftests opt-in to
> > 5-level paging by setting CR4.LA57 for the guest.  The overzealous
> > assert prevents running the selftests on a kernel with 5-level paging
> > enabled.
> > 
> > Incorporate LA57 into the assert instead of removing the assert entirely
> > as a sanity check of KVM's CPUID output.
> > 
> > Fixes: 567a9f1e9deb ("KVM: selftests: Introduce VM_MODE_PXXV48_4K")
> > Reported-by: Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>
> > Cc: Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index c9cede5c7d0de..74776ee228f2d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -195,11 +195,18 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> >  	case VM_MODE_PXXV48_4K:
> >  #ifdef __x86_64__
> >  		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> > -		TEST_ASSERT(vm->va_bits == 48, "Linear address width "
> > -			    "(%d bits) not supported", vm->va_bits);
> > +		/*
> > +		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
> > +		 * it doesn't take effect unless a CR4.LA57 is set, which it
> > +		 * isn't for this VM_MODE.
> > +		 */
> > +		TEST_ASSERT(vm->va_bits == 48 || vm->va_bits == 57,
> > +			    "Linear address width (%d bits) not supported",
> > +			    vm->va_bits);
> >  		pr_debug("Guest physical address width detected: %d\n",
> >  			 vm->pa_bits);
> >  		vm->pgtable_levels = 4;
> > +		vm->va_bits = 48;
> >  #else
> >  		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
> >  #endif
> > 
> 
> Queued, thnaks.
> 
> Paolo

Looks like this one also got lost in the 5.7 -> 5.8 transition.
