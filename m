Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429D8C077B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfI0O11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:27:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:26680 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfI0O11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:27:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:27:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="190331489"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 27 Sep 2019 07:27:25 -0700
Date:   Fri, 27 Sep 2019 07:27:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
Message-ID: <20190927142725.GC24889@linux.intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-2-sean.j.christopherson@intel.com>
 <68340081-0094-4A74-9B33-3431F39659AA@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68340081-0094-4A74-9B33-3431F39659AA@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 03:06:02AM +0300, Liran Alon wrote:
> 
> 
> > On 27 Sep 2019, at 0:43, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested VM-Enter
> > isntead of deferring the VMWRITE until vmx_set_cr3().  If the VMWRITE
> > is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
> > refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the emulated
> > VM-Exit occurs without actually entering L2, e.g. if the nested run
> > is squashed because L2 is being put into HLT.
> 
> I would rephrase to “If an emulated VMEntry is squashed because L1 sets
> vmcs12->guest_activity_state to HLT”.  I think it’s a bit more explicit.
> 
> > 
> > In an ideal world where EPT *requires* unrestricted guest (and vice
> > versa), VMX could handle CR3 similar to how it handles RSP and RIP,
> > e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  But
> > the unrestricted guest silliness complicates the dirty tracking logic
> > to the point that explicitly handling vmcs02.GUEST_CR3 during nested
> > VM-Enter is a simpler overall implementation.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Reto Buerki <reet@codelabs.ch>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> > arch/x86/kvm/vmx/nested.c | 8 ++++++++
> > arch/x86/kvm/vmx/vmx.c    | 9 ++++++---
> > 2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 41abc62c9a8a..971a24134081 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2418,6 +2418,14 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> > 				entry_failure_code))
> > 		return -EINVAL;
> > 
> > +	/*
> > +	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
> > +	 * on nested VM-Exit, which can occur without actually running L2, e.g.
> > +	 * if L2 is entering HLT state, and thus without hitting vmx_set_cr3().
> > +	 */
> 
> If I understand correctly, it’s not exactly if L2 is entering HLT state in
> general.  (E.g. issue doesn’t occur if L2 runs HLT directly which is not
> configured to be intercepted by vmcs12).  It’s specifically when L1 enters L2
> with a HLT guest-activity-state. I suggest rephrasing comment.

I deliberately worded the comment so that it remains valid if there are
more conditions in the future that cause KVM to skip running L2.  What if
I split the difference and make the changelog more explicit, but leave the
comment as is?

> > +	if (enable_ept)
> > +		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
> > +
> > 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
> > 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
> > 	    is_pae_paging(vcpu)) {
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index d4575ffb3cec..b530950a9c2b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2985,6 +2985,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > {
> > 	struct kvm *kvm = vcpu->kvm;
> > 	unsigned long guest_cr3;
> > +	bool skip_cr3 = false;
> > 	u64 eptp;
> > 
> > 	guest_cr3 = cr3;
> > @@ -3000,15 +3001,17 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> > 		}
> > 
> > -		if (enable_unrestricted_guest || is_paging(vcpu) ||
> > -		    is_guest_mode(vcpu))
> > +		if (is_guest_mode(vcpu))
> > +			skip_cr3 = true;
> > +		else if (enable_unrestricted_guest || is_paging(vcpu))
> > 			guest_cr3 = kvm_read_cr3(vcpu);
> > 		else
> > 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> > 		ept_load_pdptrs(vcpu);
> > 	}
> > 
> > -	vmcs_writel(GUEST_CR3, guest_cr3);
> > +	if (!skip_cr3)
> 
> Nit: It’s a matter of taste, but I prefer positive conditions. i.e. “bool
> write_guest_cr3”.
> 
> Anyway, code seems valid to me. Nice catch.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> 
> -Liran
> 
> > +		vmcs_writel(GUEST_CR3, guest_cr3);
> > }
> > 
> > int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> > -- 
> > 2.22.0
> > 
> 
