Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E127561738C
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 02:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiKCBE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 21:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 21:04:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C959B60FB
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 18:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667437465; x=1698973465;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7//xQ2Idgbk6w1DbjkSTtP1Eth+guHMk5ew8szqsNSE=;
  b=jPwXrDV1Lz5+iQ5o7e8hRmF4iel1+fhgaP5/K1wGbQ7z9wYJi5rTHcjf
   J+5DulRnqfsHvXLh8y7l5IoGrk9qU9wN5Xm9sk0vlT7zvUgLXP0jqbwAE
   zPRwcnRc/xtfzby1jqtvl0EvllWH17ZU3BrDr58iEmT/ywzuIZSjy/vhi
   ymp5rq7cWsitkfxVXa6jtn81jksy29fyrFmW7GtEU8lY/IO3s1quOYdDJ
   1Pn2EqJQnbT6fmDOIGQOqmGYRhCgthTpxx2lMU/wMnJ1ay1BSWkwqoQ8X
   9KrTfn162Mc7NsSgWgQX1SVf+jtfedTKw1c0iCZgEknOKyT8OMRwA1F90
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="289944979"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="289944979"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 18:04:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="759752257"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="759752257"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 02 Nov 2022 18:04:24 -0700
Message-ID: <9578f16e8be3dddae2c5571a4a8f033ab4259840.camel@linux.intel.com>
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Date:   Thu, 03 Nov 2022 09:04:23 +0800
In-Reply-To: <20221102210512.aadxeb3qiloff7yl@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
         <20221017070450.23031-9-robert.hu@linux.intel.com>
         <20221031025930.maz3g5npks7boixl@box.shutemov.name>
         <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
         <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
         <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
         <20221102210512.aadxeb3qiloff7yl@box.shutemov.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 00:05 +0300, Kirill A. Shutemov wrote:
> On Wed, Nov 02, 2022 at 03:29:10PM +0800, Robert Hoo wrote:
> > On Tue, 2022-11-01 at 05:04 +0300, Kirill A. Shutemov wrote:
> > ...
> > > > > > -	if (cr3 != kvm_read_cr3(vcpu))
> > > > > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > > > > +	old_cr3 = kvm_read_cr3(vcpu);
> > > > > > +	if (cr3 != old_cr3) {
> > > > > > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > > > > > +			kvm_mmu_new_pgd(vcpu, cr3 &
> > > > > > ~(X86_CR3_LAM_U48 |
> > > > > > +					X86_CR3_LAM_U57));
> > > > > > +		} else {
> > > > > > +			/* Only LAM conf changes, no tlb flush
> > > > > > needed
> > > > > > */
> > > > > > +			skip_tlb_flush = true;
> > > > > 
> > > > > I'm not sure about this.
> > > > > 
> > > > > Consider case when LAM_U48 gets enabled on 5-level paging
> > > > > machines.
> > > > > We may
> > > > > have valid TLB entries for addresses above 47-bit. It's kinda
> > > > > broken
> > > > > case,
> > > > > but seems valid from architectural PoV, no?
> > > > 
> > > > You're right, thanks Kirill.
> > > > 
> > > > I noticed in your Kernel enabling, because of this LAM_U48 and
> > > > LA_57
> > > > overlapping, you enabled LAM_U57 only for simplicity at this
> > > > moment. I
> > > > thought at that time, that this trickiness will be contained in
> > > > Kernel
> > > > layer, but now it turns out at least non-EPT KVM MMU is not
> > > > spared.
> > > > > 
> > > > > I guess after enabling LAM, these entries will never match.
> > > > > But
> > > > > if
> > > > > LAM
> > > > > gets disabled again they will become active. Hm?
> > > > > 
> > > > > Maybe just flush?
> > > > 
> > > > Now we have 2 options
> > > > 1. as you suggested, just flush
> > > > 2. more precisely identify the case Guest.LA57 &&
> > > > (CR3.bit[62:61]
> > > > 00
> > > > -->10 switching), flush. (LAM_U57 bit take precedence over
> > > > LAM_U48,
> > > > from spec.)
> > > > 
> > > > Considering CR3 change is relatively hot path, and tlb flush is
> > > > heavy,
> > > > I lean towards option 2. Your opinion? 
> > > 
> > > 11 in bits [62:61] is also considered LAM_U57. So your option 2
> > > is
> > > broken.
> > 
> > Hi Kirill,
> > 
> > When I came to cook v2 per your suggestion, i.e. leave it just
> > flush, I
> > pondered on the necessity on all the cases of the 2 bits (LAM_U48,
> > LAM_U57) flips.
> > Hold this: LAM_U57 (bit61) takes precedence over LAM_U48 (bit62).
> > 
> > (0,0) --> {(0,1), (1,0), (1,1)}
> > (0,1) --> {(0,0), (1,0), (1,1)}
> > (1,0) --> {(0,0), (0,1), (1,1)}
> > (1,1) --> {(0,0), (1,0), (1,0)}
> > 
> > Among all the 12 cases, only (0,0) --> (1,0) && 5-level paging on,
> > has
> > to flush tlb. Am I right? if so, would you still prefer
> > unconditionally
> > flush, just for 1/12 necessity? (if include 5-level/4-level
> > variations,
> > 1/24)
> 
> I would keep it simple. We can always add optimization later if
> there's
> a workload that actually benefit from it. But I cannot imagine
> situation
> where enabling LAM is a hot path.
> 
OK, I'm open to this.

I also notice that skip_tlb_flush is set when pcid_enabled && (CR3
& X86_CR3_PCID_NOFLUSH). Under this condition, do you think (0,0) -->
(1,0) need to flip it back to false?

int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
{
	bool skip_tlb_flush = false;
	unsigned long pcid = 0, old_cr3;
#ifdef CONFIG_X86_64
	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);

	if (pcid_enabled) {
		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;


