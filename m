Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559DF295188
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503504AbgJURaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:30:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:55205 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503481AbgJURaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:30:35 -0400
IronPort-SDR: SnpLRIDV6AAcw66rVsR9LFT48sqPkfolHJxsC0s1F3++E7FtOiRtMwrASojj7PB7GOzEZVVAPc
 men8N+/L3cwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="167528331"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="167528331"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:30:33 -0700
IronPort-SDR: Ho1F3WZ9LkCFAXZXxjdX/55nZ4weSfnlIi0NCIGKEyEPXn3I6s20+t+OmQcwO3bvWDkWsURx48
 pgSjfGVo7hiA==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="353748758"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:30:32 -0700
Date:   Wed, 21 Oct 2020 10:30:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] KVM: VMX: Explicitly check for
 hv_remote_flush_tlb when loading pgd
Message-ID: <20201021173030.GD14155@linux.intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
 <20201020215613.8972-8-sean.j.christopherson@intel.com>
 <87r1pr4q8z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1pr4q8z.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 04:18:04PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Explicitly check that kvm_x86_ops.tlb_remote_flush() points at Hyper-V's
> > implementation for PV flushing instead of assuming that a non-NULL
> > implementation means running on Hyper-V.  Wrap the related logic in
> > ifdeffery as hv_remote_flush_tlb() is defined iff CONFIG_HYPERV!=n.
> >
> > Short term, the explicit check makes it more obvious why a non-NULL
> > tlb_remote_flush() triggers EPTP shenanigans.  Long term, this will
> > allow TDX to define its own implementation of tlb_remote_flush() without
> > running afoul of Hyper-V.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++++-------
> >  1 file changed, 16 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e6569bafacdc..55d6b699d8e3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -560,6 +560,21 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
> >  
> >  #endif /* IS_ENABLED(CONFIG_HYPERV) */
> >  
> > +static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
> > +{
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> > +
> > +	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> > +		spin_lock(&kvm_vmx->ept_pointer_lock);
> > +		to_vmx(vcpu)->ept_pointer = eptp;
> > +		if (eptp != kvm_vmx->hv_tlb_eptp)
> > +			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> > +		spin_unlock(&kvm_vmx->ept_pointer_lock);
> > +	}
> > +#endif
> > +}
> > +
> >  /*
> >   * Comment's format: document - errata name - stepping - processor name.
> >   * Refer from
> > @@ -3040,13 +3055,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
> >  		eptp = construct_eptp(vcpu, pgd, pgd_level);
> >  		vmcs_write64(EPT_POINTER, eptp);
> >  
> > -		if (kvm_x86_ops.tlb_remote_flush) {
> > -			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> > -			to_vmx(vcpu)->ept_pointer = eptp;
> > -			if (eptp != to_kvm_vmx(kvm)->hv_tlb_eptp)
> > -				to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
> > -			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> > -		}
> > +		hv_load_mmu_eptp(vcpu, eptp);
> 
> So when TDX comes around, will we need to add something to
> hv_load_mmu_eptp() and rename it or there's nothing to do for TDX when
> PGD changes? I'm just wondering if it would make sense to rename
> hv_load_mmu_eptp() to something else right away.

Short answer, it's a non-issue.

There are things to do for TDX guests when PGD changes, but it's a completely
different flow than VMX.  For TDX, the Secure/Private EPTP is set in stone,
i.e. it's per-VM and cannot be changed.  The Shared/Public EPTP can be changed,
and this is what's handled in TDX's implementaiton of .load_mmu_pgd().

As for why .tlb_remote_flush() is relevant...

For TDX, because the VMM is untrusted, the actual INVEPTP on the Secure EPTP
must be done by the TDX-Module; there is state tracking in TDX-Module that
enforces this, e.g. operations on the S-EPT tables that rely on a previous
flush will fail if the flush wasn't performed.

That's why KVM hooks .tlb_remote_flush for TDX; KVM needs to do INVEPT on the
shared/public/untrusted EPTP, and then do a SEAMCALL to invoke TDX-Module's
tracking and flushing.

The collision on the VMX side occurs because VMX and TDX code shared the same
kvm_x86_ops (in our proposed implementation), i.e. VMX would get a false
positive for "am I running on Hyper-V" if it only checked for a non-null
callback.

For "real" TDX, KVM will be running on bare metal, i.e. KVM won't be an L1
running on Hyper-V.  It's certainly possible emulate the functional bits of TDX
in L0, i.e. to run/load KVM+TDX in L1, but the odds of that colliding with
Hyper-V's L1 GPA PV TLB flushing in upstream KVM are *extremely* tiny.  The
main use case of TDX is to take the platform owner, e.g. CSP, out of the TCB,
i.e. running KVM+TDX in L1 in production would wipe out the value provided by
TDX as doing so would mean trusting L0 to do the right thing.

There is value in running KVM+TDX in L1 from a development/debug perspective,
but (a) I'd be quite surprised if Microsoft publicly released a version of
Hyper-V that emulated SEAM+TDX, and (b) even if a publicly available VMM
emulates SEAM+TDX, it would not want to enlighten L1 KVM as the goal behind
running nested would be for development/debug, i.e. it'd want to provide an
environment as close to the real thing as possible.
