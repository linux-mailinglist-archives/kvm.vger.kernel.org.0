Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDEB653118
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 13:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiLUMxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 07:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiLUMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 07:53:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8352317F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 04:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671627179; x=1703163179;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jsjsf7OV5vft2Et6ATJBWddKewSqbz7/Ro+IXQZxboA=;
  b=WmJTo6EDBQuCmaxJtWzx+z3vYr5aXzDtJY/eRAFyQvQYPl/iAVuCoRuZ
   ybkNKkeCK99z2HMXGZk/J9w50fWpwTVG6k04J4aD8hxhndhphxluityEo
   S/GUqRT353fE2eMY3YuA2vNvZmRf1xUDsP+GAyTEnzMAINMnb5BeExO1+
   SmtlKJKB//baGU3VzPWIHCAZv7KybM5PXSX4Dbptkt7p6fmY6Km/dGBIN
   nEzl6xmIGC323ILslDZes32l7fqXbEPteuB347Zvdgdm8NOhY9WAArVIw
   p5K0hkxdqkhIrV2UJmZ97ujQUge3K3n5AWqidPAbPTLT3/DrggriVSBQr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321040781"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321040781"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 04:52:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="825638002"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="825638002"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 21 Dec 2022 04:52:57 -0800
Message-ID: <735cd5060271bfa8abcca69c2ae086adaffa38a7.camel@linux.intel.com>
Subject: Re: [PATCH v3 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Wed, 21 Dec 2022 20:52:56 +0800
In-Reply-To: <20221221083021.5qb3v4ecyswtktd3@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-9-robert.hu@linux.intel.com>
         <20221221083021.5qb3v4ecyswtktd3@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-21 at 16:30 +0800, Yu Zhang wrote:
> On Fri, Dec 09, 2022 at 12:45:56PM +0800, Robert Hoo wrote:
> > When only changes LAM bits, ask next vcpu run to load mmu pgd, so
> > that it
> > will build new CR3 with LAM bits updates. No TLB flush needed on
> > this case.
> > When changes on effective addresses, no matter LAM bits changes or
> > not, go
> > through normal pgd update process.
> 
> Sorry, may I ask why this is related to effective address changes?
> This patch is only about the CR3 updates...
> 
Not sure if we mean the same thing. Here effective address I mean the
CR3 & CR3_ADDR_MASK, i.e. pgd part.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
> >  1 file changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 48a2ad1e4cd6..6fbe8dd36b1e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1248,9 +1248,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu
> > *vcpu, unsigned long cr3)
> >  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  {
> >  	bool skip_tlb_flush = false;
> > -	unsigned long pcid = 0;
> > +	unsigned long pcid = 0, old_cr3;
> >  #ifdef CONFIG_X86_64
> > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> 
> This may qualify a seperate patch. :)

I had thought of this as well, but it is so trivial, and literally we
cannot say original code is wrong.
> 
> >  
> >  	if (pcid_enabled) {
> >  		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > @@ -1263,6 +1263,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> >  	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> >  		goto handle_tlb_flush;
> >  
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> > +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> > +		return	1;
> > +
> >  	/*
> >  	 * Do not condition the GPA check on long mode, this helper is
> > used to
> >  	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
> > that
> > @@ -1274,8 +1278,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> >  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> >  		return 1;
> >  
> > -	if (cr3 != kvm_read_cr3(vcpu))
> > -		kvm_mmu_new_pgd(vcpu, cr3);
> > +	old_cr3 = kvm_read_cr3(vcpu);
> > +	if (cr3 != old_cr3) {
> > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> > +					X86_CR3_LAM_U57));
> > +		} else {
> > +			/*
> > +			 * Though effective addr no change, mark the
> 
> Same question here.

Here is the case the CR3 updates are only of LAM bits, no changes to
PGD part.
> 
> > +			 * request so that LAM bits will take effect
> > +			 * when enter guest.
> > +			 */
> > +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > +		}
> > +	}
> >  
> >  	vcpu->arch.cr3 = cr3;
> >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > -- 
> 
> B.R.
> Yu

