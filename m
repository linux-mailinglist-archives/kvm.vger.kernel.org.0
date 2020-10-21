Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA02950EB
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503008AbgJUQiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 12:38:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:23791 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391406AbgJUQit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 12:38:49 -0400
IronPort-SDR: OY8Ws834KFk6XGWFECr9i8ng2RwCqBSFyTwcL30fczwJE3hWwPpFTO6cCgeuU31h/CjnGSd+Uk
 pWPmAHErCsQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="154349687"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="154349687"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 09:38:48 -0700
IronPort-SDR: EuRiUVnPh2wb6SfRJE+J3dGuxPBSNoG4pjdWbxbiKLEqAkg7ot1iMfdF/rFPm+mtNtWf32OUCS
 +IfYRVS5Slug==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="358946764"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 09:38:47 -0700
Date:   Wed, 21 Oct 2020 09:38:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] KVM: VMX: Invalidate hv_tlb_eptp to denote an
 EPTP mismatch
Message-ID: <20201021163843.GC14155@linux.intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
 <20201020215613.8972-6-sean.j.christopherson@intel.com>
 <87wnzj4utj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnzj4utj.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 02:39:20PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Drop the dedicated 'ept_pointers_match' field in favor of stuffing
> > 'hv_tlb_eptp' with INVALID_PAGE to mark it as invalid, i.e. to denote
> > that there is at least one EPTP mismatch.  Use a local variable to
> > track whether or not a mismatch is detected so that hv_tlb_eptp can be
> > used to skip redundant flushes.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
> >  arch/x86/kvm/vmx/vmx.h |  7 -------
> >  2 files changed, 8 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 52cb9eec1db3..4dfde8b64750 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -498,13 +498,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> >  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
> >  	struct kvm_vcpu *vcpu;
> >  	int ret = 0, i;
> > +	bool mismatch;
> >  	u64 tmp_eptp;
> >  
> >  	spin_lock(&kvm_vmx->ept_pointer_lock);
> >  
> > -	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
> > -		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
> > -		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> > +	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> > +		mismatch = false;
> >  
> >  		kvm_for_each_vcpu(i, vcpu, kvm) {
> >  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> > @@ -515,12 +515,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> >  			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
> >  				kvm_vmx->hv_tlb_eptp = tmp_eptp;
> >  			else
> > -				kvm_vmx->ept_pointers_match
> > -					= EPT_POINTERS_MISMATCH;
> > +				mismatch = true;
> >  
> >  			ret |= hv_remote_flush_eptp(tmp_eptp, range);
> >  		}
> > -	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> > +		if (mismatch)
> > +			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> > +	} else {
> >  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
> >  	}
> 
> Personally, I find double negations like 'mismatch = false' hard to read
> :-).

Paolo also dislikes double negatives (I just wasted a minute of my life trying
to work a double negative into that sentence).

> What if we write this all like 
> 
> if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> 	kvm_vmx->hv_tlb_eptp = to_vmx(vcpu0)->ept_pointer;
> 	kvm_for_each_vcpu() {
> 		tmp_eptp = to_vmx(vcpu)->ept_pointer;
> 		if (!VALID_PAGE(tmp_eptp) || tmp_eptp != kvm_vmx->hv_tlb_eptp)
> 			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> 		if (VALID_PAGE(tmp_eptp))
> 			ret |= hv_remote_flush_eptp(tmp_eptp, range);
> 	}
> } else {
> 	ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
> }
> 
> (not tested and I've probably missed something)

It works, but doesn't optimize the case where one or more vCPUs has an invalid
EPTP.  E.g. if vcpuN->ept_pointer is INVALID_PAGE, vcpuN+1..vcpuZ will flush,
even if they all match.  Now, whether or not it's worth optimizing that case...

This is also why I named it "mismatch", i.e. it tracks whether or not there was
a mismatch between valid EPTPs, not that all EPTPs matched.

What about replacing "mismatch" with a counter that tracks the number of unique,
valid PGDs that are encountered?

	if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd)) {
		unique_valid_pgd_cnt = 0;

		kvm_for_each_vcpu(i, vcpu, kvm) {
			tmp_pgd = to_vmx(vcpu)->hv_tlb_pgd;
			if (!VALID_PAGE(tmp_pgd) ||
			    tmp_pgd == kvm_vmx->hv_tlb_pgd)
				continue;

			unique_valid_pgd_cnt++;

			if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd))
				kvm_vmx->hv_tlb_pgd = tmp_pgd;

			if (!ret)
				ret = hv_remote_flush_pgd(tmp_pgd, range);

			if (ret && unique_valid_pgd_cnt > 1)
				break;
		}
		if (unique_valid_pgd_cnt > 1)
			kvm_vmx->hv_tlb_pgd = INVALID_PAGE;
	} else {
		ret = hv_remote_flush_pgd(kvm_vmx->hv_tlb_pgd, range);
	}


Alternatively, the pgd_cnt adjustment could be used to update hv_tlb_pgd, e.g.

			if (++unique_valid_pgd_cnt == 1)
				kvm_vmx->hv_tlb_pgd = tmp_pgd;

I think I like this last one the most.  It self-documents what we're tracking
as well as the relationship between the number of valid PGDs and hv_tlb_pgd.

I'll also add a few comments to explain how kvm_vmx->hv_tlb_pgd is used.

Thoughts?
 
> > @@ -3042,8 +3043,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
> >  		if (kvm_x86_ops.tlb_remote_flush) {
> >  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> >  			to_vmx(vcpu)->ept_pointer = eptp;
> > -			to_kvm_vmx(kvm)->ept_pointers_match
> > -				= EPT_POINTERS_CHECK;
> > +			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
> >  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> >  		}
> >  
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 3d557a065c01..e8d7d07b2020 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -288,12 +288,6 @@ struct vcpu_vmx {
> >  	} shadow_msr_intercept;
> >  };
> >  
> > -enum ept_pointers_status {
> > -	EPT_POINTERS_CHECK = 0,
> > -	EPT_POINTERS_MATCH = 1,
> > -	EPT_POINTERS_MISMATCH = 2
> > -};
> > -
> >  struct kvm_vmx {
> >  	struct kvm kvm;
> >  
> > @@ -302,7 +296,6 @@ struct kvm_vmx {
> >  	gpa_t ept_identity_map_addr;
> >  
> >  	hpa_t hv_tlb_eptp;
> > -	enum ept_pointers_status ept_pointers_match;
> >  	spinlock_t ept_pointer_lock;
> >  };
> 
> -- 
> Vitaly
> 
