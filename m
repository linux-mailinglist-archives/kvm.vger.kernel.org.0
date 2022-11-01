Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D696142DC
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 02:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKABqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 21:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiKABqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 21:46:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392ED15710
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 18:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667267201; x=1698803201;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pJ0/Wl/Io6Q2v4I0L5BLp5Ls0rDOB9MA1M0D23grpOM=;
  b=VKtYeBd5FYzK3sjo5jiKzKCChSrCj/KSzgEUtpEsPIkSevT7fC9OCYxd
   QPtZA3g/bLJomJFdii8PTUQ3fX4cxUjVnWWIO2Ibt2gyWt4arjgwlFwKW
   cwIGQ6BoFVgeWvrtPkgqHzDDCEk7kywEquSzOpaU/OJKI4FDx5yMLNN6a
   CvbYRj9P38sXoZi3yS0jYuUpKJ17pqAUnMXC4R6onUcQUlre2rONUNQ+1
   wD8Kac7DguoRHxvdIEqDcLJPAEZ2Q2y/9aOPoyFwu2wNn2Zu18Psjh51E
   xRDko6pyrOfMi7i/+JGZgsGyNx3/9yF9a3GX5rr5tyqA1cGE9LiLDBCiM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="335705617"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="335705617"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 18:46:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="739170311"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="739170311"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2022 18:46:39 -0700
Message-ID: <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Date:   Tue, 01 Nov 2022 09:46:39 +0800
In-Reply-To: <20221031025930.maz3g5npks7boixl@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
         <20221017070450.23031-9-robert.hu@linux.intel.com>
         <20221031025930.maz3g5npks7boixl@box.shutemov.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-31 at 05:59 +0300, Kirill A. Shutemov wrote:
> On Mon, Oct 17, 2022 at 03:04:49PM +0800, Robert Hoo wrote:
> > When only changes LAM bits, ask next vcpu run to load mmu pgd, so
> > that it
> > will build new CR3 with LAM bits updates. No TLB flush needed on
> > this case.
> > When changes on effective addresses, no matter LAM bits changes or
> > not, go
> > through normal pgd update process.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e9b465bff8d3..fb779f88ae88 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1228,9 +1228,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu
> > *vcpu, unsigned long cr3)
> >  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  {
> >  	bool skip_tlb_flush = false;
> > -	unsigned long pcid = 0;
> > +	unsigned long pcid = 0, old_cr3;
> >  #ifdef CONFIG_X86_64
> > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> >  
> >  	if (pcid_enabled) {
> >  		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > @@ -1243,6 +1243,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
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
> > @@ -1254,8 +1258,22 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
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
> > +			/* Only LAM conf changes, no tlb flush needed
> > */
> > +			skip_tlb_flush = true;
> 
> I'm not sure about this.
> 
> Consider case when LAM_U48 gets enabled on 5-level paging machines.
> We may
> have valid TLB entries for addresses above 47-bit. It's kinda broken
> case,
> but seems valid from architectural PoV, no?

You're right, thanks Kirill.

I noticed in your Kernel enabling, because of this LAM_U48 and LA_57
overlapping, you enabled LAM_U57 only for simplicity at this moment. I
thought at that time, that this trickiness will be contained in Kernel
layer, but now it turns out at least non-EPT KVM MMU is not spared.
> 
> I guess after enabling LAM, these entries will never match. But if
> LAM
> gets disabled again they will become active. Hm?
> 
> Maybe just flush?

Now we have 2 options
1. as you suggested, just flush
2. more precisely identify the case Guest.LA57 && (CR3.bit[62:61] 00
-->10 switching), flush. (LAM_U57 bit take precedence over LAM_U48,
from spec.)

Considering CR3 change is relatively hot path, and tlb flush is heavy,
I lean towards option 2. Your opinion? 
 
> 
> > +			/*
> > +			 * Though effective addr no change, mark the
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
> > 2.31.1
> > 
> 
> 

