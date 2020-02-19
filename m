Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E760C164846
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 16:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgBSPRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 10:17:08 -0500
Received: from mga17.intel.com ([192.55.52.151]:11100 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgBSPRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 10:17:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 07:16:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="258945868"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 19 Feb 2020 07:16:44 -0800
Date:   Wed, 19 Feb 2020 07:16:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86: Move #PF retry tracking variables into
 emulation context
Message-ID: <20200219151644.GB15888@linux.intel.com>
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-4-sean.j.christopherson@intel.com>
 <40c8d560-1a5d-d592-5682-720980ca3dd9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c8d560-1a5d-d592-5682-720980ca3dd9@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 09:13:00AM +0100, Paolo Bonzini wrote:
> On 19/02/20 00:03, Sean Christopherson wrote:
> > Move last_retry_eip and last_retry_addr into the emulation context as
> > they are specific to retrying an instruction after emulation failure.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I'm not sure about this, since it's not used by emulate.c.  The other
> two patches are good.

The easy solution to that is to move retry_instruction() into emulate.c.
That would also allow making x86_page_table_writing_insn() static.  All
other functions invoked from retry_instruction() are exposed via kvm_host.h.

Moving last_retry_* into the emulator context hopefully makes it more clear
that this code is the only user of the variables, e.g. last_retry_eip can't
be set by some other non-emulator flow.

	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2)
		return false;

	vcpu->arch.last_retry_eip = ctxt->eip;
	vcpu->arch.last_retry_addr = cr2;

> > ---
> >  arch/x86/include/asm/kvm_emulate.h |  4 ++++
> >  arch/x86/include/asm/kvm_host.h    |  3 ---
> >  arch/x86/kvm/x86.c                 | 11 ++++++-----
> >  3 files changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> > index a4ef19a6e612..a26c8de414e8 100644
> > --- a/arch/x86/include/asm/kvm_emulate.h
> > +++ b/arch/x86/include/asm/kvm_emulate.h
> > @@ -315,6 +315,10 @@ struct x86_emulate_ctxt {
> >  	bool gpa_available;
> >  	gpa_t gpa_val;
> >  
> > +	/* Track EIP and CR2/GPA when retrying faulting instruction on #PF. */
> > +	unsigned long last_retry_eip;
> > +	unsigned long last_retry_addr;
> > +
> >  	/*
> >  	 * decode cache
> >  	 */
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9c79c41eb5f6..6312ea32bb41 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -752,9 +752,6 @@ struct kvm_vcpu_arch {
> >  
> >  	cpumask_var_t wbinvd_dirty_mask;
> >  
> > -	unsigned long last_retry_eip;
> > -	unsigned long last_retry_addr;
> > -
> >  	struct {
> >  		bool halted;
> >  		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f88b72932c35..d19eb776f297 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6407,6 +6407,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
> >  
> >  	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> >  
> > +	/* last_retry_{eip,addr} are persistent and must not be init'd here. */
> >  	ctxt->gpa_available = false;
> >  	ctxt->eflags = kvm_get_rflags(vcpu);
> >  	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
> > @@ -6557,8 +6558,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> >  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> >  	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
> >  
> > -	last_retry_eip = vcpu->arch.last_retry_eip;
> > -	last_retry_addr = vcpu->arch.last_retry_addr;
> > +	last_retry_eip = ctxt->last_retry_eip;
> > +	last_retry_addr = ctxt->last_retry_addr;
> >  
> >  	/*
> >  	 * If the emulation is caused by #PF and it is non-page_table
> > @@ -6573,7 +6574,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> >  	 * and the address again, we can break out of the potential infinite
> >  	 * loop.
> >  	 */
> > -	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
> > +	ctxt->last_retry_eip = ctxt->last_retry_addr = 0;
> >  
> >  	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
> >  		return false;
> > @@ -6588,8 +6589,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> >  	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
> >  		return false;
> >  
> > -	vcpu->arch.last_retry_eip = ctxt->eip;
> > -	vcpu->arch.last_retry_addr = cr2_or_gpa;
> > +	ctxt->last_retry_eip = ctxt->eip;
> > +	ctxt->last_retry_addr = cr2_or_gpa;
> >  
> >  	if (!vcpu->arch.mmu->direct_map)
> >  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
> > 
> 
