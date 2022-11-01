Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598A3614333
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 03:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiKAC0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 22:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKAC0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 22:26:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9E6175AD
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 19:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667269608; x=1698805608;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XLVrNZsZ7z8AFnWqDYT+gtltRQ01HjiuQk4yA7eFXLg=;
  b=P/xqFL+gHAvKx+Y7EHaNGO3How7i1/mWThUQublAJK8md6WDm2maMyxs
   4Rohr+ftgKQleOx8B33P6CKz8oTHFjcSUO/Yc+rjY830CHgFuIT53o1jY
   J9OvS2aBV4JgQRnH/iZxawUzlsN0W6smRH5b7FGXlKX4OAgkEvK4ODmEh
   rLQLi+BB8KH3CkR1HX3rVWoEO9O5DyiBp8SjF5YoRW8mFHNLTHu9aOn5d
   2TnVstnKLhJ7jIOBdXGA8N+/V7fdwQlAIp13VMTV1fBLFgPpU214/b2sV
   RhEi11Pl1mdku0ZZ/tvDoFDFLCfEIPb79hi+9ukkIGSylQAt/I5JYGNBI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="310143064"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="310143064"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 19:26:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="584868907"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="584868907"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 31 Oct 2022 19:26:46 -0700
Message-ID: <c2031f91e80fe24ed466db738ffb611f14bbad4f.camel@linux.intel.com>
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Date:   Tue, 01 Nov 2022 10:26:46 +0800
In-Reply-To: <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
         <20221017070450.23031-9-robert.hu@linux.intel.com>
         <20221031025930.maz3g5npks7boixl@box.shutemov.name>
         <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
         <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-01 at 05:04 +0300, Kirill A. Shutemov wrote:
> > > > @@ -1254,8 +1258,22 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > > > unsigned long cr3)
> > > >  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> > > >  		return 1;
> > > >  
> > > > -	if (cr3 != kvm_read_cr3(vcpu))
> > > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > > +	old_cr3 = kvm_read_cr3(vcpu);
> > > > +	if (cr3 != old_cr3) {
> > > > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > > > +			kvm_mmu_new_pgd(vcpu, cr3 &
> > > > ~(X86_CR3_LAM_U48 |
> > > > +					X86_CR3_LAM_U57));
> > > > +		} else {
> > > > +			/* Only LAM conf changes, no tlb flush
> > > > needed
> > > > */
> > > > +			skip_tlb_flush = true;
> > > 
> > > I'm not sure about this.
> > > 
> > > Consider case when LAM_U48 gets enabled on 5-level paging
> > > machines.
> > > We may
> > > have valid TLB entries for addresses above 47-bit. It's kinda
> > > broken
> > > case,
> > > but seems valid from architectural PoV, no?
> > 
> > You're right, thanks Kirill.
> > 
> > I noticed in your Kernel enabling, because of this LAM_U48 and
> > LA_57
> > overlapping, you enabled LAM_U57 only for simplicity at this
> > moment. I
> > thought at that time, that this trickiness will be contained in
> > Kernel
> > layer, but now it turns out at least non-EPT KVM MMU is not spared.
> > > 
> > > I guess after enabling LAM, these entries will never match. But
> > > if
> > > LAM
> > > gets disabled again they will become active. Hm?
> > > 
> > > Maybe just flush?
> > 
> > Now we have 2 options
> > 1. as you suggested, just flush
> > 2. more precisely identify the case Guest.LA57 && (CR3.bit[62:61]
> > 00
> > -->10 switching), flush. (LAM_U57 bit take precedence over LAM_U48,
> > from spec.)
> > 
> > Considering CR3 change is relatively hot path, and tlb flush is
> > heavy,
> > I lean towards option 2. Your opinion? 
> 
> 11 in bits [62:61] is also considered LAM_U57. So your option 2 is
> broken.

I don't get you here. Yes, 11 is also LAM_U57, but LAM_U57 is safe (6
bit).
Anyway, flush, as below hot path doesn't hold.
> 
> And I don't buy argument about hot path: the case we talking about is
> about enabling/disabling LAM with constant PGD. 

Right.

> It's not hot path by any
> mean.
> 
> Let's not be fancy. Just flush TLB.
> 

