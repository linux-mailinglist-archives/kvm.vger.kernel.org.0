Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1CC18F935
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCWQEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:04:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:53089 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgCWQEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:04:33 -0400
IronPort-SDR: COJtxdyDi78DFmABqF/UJ0spSQE+qPnpYFmOQHmOTvtajj3f4TihAL4BHi75Ju3me/2SLrr1T7
 l7Vn8l+FYeYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:04:33 -0700
IronPort-SDR: 8160iWQQn2QB9EBkZ/5az9FGQyLtlP8gpZ2wwPk4GGyG8uGZK6pSLjteJMiLAc6G0Mv9/pLSSz
 btIvTAF8I0UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="269922152"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2020 09:04:32 -0700
Date:   Mon, 23 Mar 2020 09:04:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 04/37] KVM: nVMX: Invalidate all roots when emulating
 INVVPID without EPT
Message-ID: <20200323160432.GJ28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-5-sean.j.christopherson@intel.com>
 <87v9mv84qu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9mv84qu.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 04:34:17PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > From: Junaid Shahid <junaids@google.com>
> >
> > Free all roots when emulating INVVPID for L1 and EPT is disabled, as
> > outstanding changes to the page tables managed by L1 need to be
> > recognized.  Because L1 and L2 share an MMU when EPT is disabled, and
> > because VPID is not tracked by the MMU role, all roots in the current
> > MMU (root_mmu) need to be freed, otherwise a future nested VM-Enter or
> > VM-Exit could do a fast CR3 switch (without a flush/sync) and consume
> > stale SPTEs.
> >
> > Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
> > Signed-off-by: Junaid Shahid <junaids@google.com>
> > [sean: ported to upstream KVM, reworded the comment and changelog]
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9624cea4ed9f..bc74fbbf33c6 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5250,6 +5250,20 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
> >  		return kvm_skip_emulated_instruction(vcpu);
> >  	}
> >  
> > +	/*
> > +	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
> > +	 * linear mappings for L2 (tagged with L2's VPID).  Free all roots as
> > +	 * VPIDs are not tracked in the MMU role.
> > +	 *
> > +	 * Note, this operates on root_mmu, not guest_mmu, as L1 and L2 share
> > +	 * an MMU when EPT is disabled.
> > +	 *
> > +	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
> > +	 */
> > +	if (!enable_ept)
> > +		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu,
> > +				   KVM_MMU_ROOTS_ALL);
> > +
> 
> This is related to my remark on the previous patch; the comment above
> makes me think I'm missing something obvious, enlighten me please)
> 
> My understanding is that L1 and L2 will share arch.root_mmu not only
> when EPT is globally disabled, we seem to switch between
> root_mmu/guest_mmu only when nested_cpu_has_ept(vmcs12) but different L2
> guests may be different on this. Do we need to handle this somehow?

guest_mmu is used iff nested EPT is enabled, which requires enable_ept=1.
enable_ept is global and cannot be changed without reloading kvm_intel.

This most definitely over-invalidates, e.g. it blasts away L1's page
tables.  But, fixing that requires tracking VPID in mmu_role and/or adding
support for using guest_mmu when L1 isn't using TDP, i.e. nested EPT is
disabled.  Assuming the vast majority of nested deployments enable EPT in
L0, the cost of both options likely outweighs the benefits.

> >  	return nested_vmx_succeed(vcpu);
> >  }
> 
> -- 
> Vitaly
> 
