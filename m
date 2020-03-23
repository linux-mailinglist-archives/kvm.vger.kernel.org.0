Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B97D18F8FC
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 16:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCWPxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 11:53:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:31439 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgCWPxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 11:53:08 -0400
IronPort-SDR: ncCw1rb1HEuIF2ENAe6XXQnykfbc1Y80MZaoaU4K8/tHy2lybNsopecy3qxJeQmslQIkdgeXJh
 BfboVzPgbcgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 08:53:07 -0700
IronPort-SDR: LIJXRONbRlBxcoQXcsZECJpyRHFeeku3lkFQLFDecL3Xga5yGR57rgWcvcL18VIT8QTcJfP+sk
 06mjAFwHKiLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="445858372"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 08:53:05 -0700
Date:   Mon, 23 Mar 2020 08:53:05 -0700
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
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
Message-ID: <20200323155305.GI28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com>
 <87y2rr857u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2rr857u.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 04:24:05PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
> > changes to the EPT tables managed by L1 need to be recognized, and
> > relying on KVM to always flush L2's EPTP context on nested VM-Enter is
> > dangerous.
> >
> > Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
> > TLB flush if necessary, e.g. if L1 has never entered L2 then there is
> > nothing to be done.
> >
> > Nuking all L2 roots is overkill for the single-context variant, but it's
> > the safe and easy bet.  A more precise zap mechanism will be added in
> > the future.  Add a TODO to call out that KVM only needs to invalidate
> > affected contexts.
> >
> > Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
> > Reported-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index f3774cef4fd4..9624cea4ed9f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5160,12 +5160,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
> >  		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
> >  			return nested_vmx_failValid(vcpu,
> >  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> > +
> > +		/* TODO: sync only the target EPTP context. */
> >  		fallthrough;
> >  	case VMX_EPT_EXTENT_GLOBAL:
> > -	/*
> > -	 * TODO: Sync the necessary shadow EPT roots here, rather than
> > -	 * at the next emulated VM-entry.
> > -	 */
> > +		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
> > +				   KVM_MMU_ROOTS_ALL);
> >  		break;
> 
> An ignorant reader may wonder "and how do we know that L1 actaully uses
> EPT" as he may find out that guest_mmu is not being used otherwise. The
> answer to the question will likely be "if L1 doesn't use EPT for some of
> its guests than there's nothing we should do here as we will be
> resetting root_mmu when switching to/from them". Hope the ignorant
> reviewer typing this is not very wrong :-)

A different way to put it would be:

  KVM never uses root_mmu to hold nested EPT roots.

Invalidating too much is functionally ok, though sub-optimal for performance.
Invalidating too little is what we really care about.

FWIW, VMX currently uses guest_mmu iff nested EPT is enabled.  In theory,
KVM could be enhanced to also used guest_mmu when nested-TDP is disabled,
e.g. to enable VMX to preserve L1's root_mmu when emulating INVVPID.  That
would likely be a decent performance boost for nested VMX+VPID without
nested EPT, but I'm guessing that the cross-section of users that care
about nested performance and don't use nested EPT is quite small.

> >  	default:
> >  		BUG_ON(1);
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
