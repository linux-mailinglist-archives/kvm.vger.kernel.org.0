Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3461C615CF7
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 08:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiKBH3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 03:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKBH3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 03:29:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87E313E3D
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 00:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667374152; x=1698910152;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HGPGTm9GBQ0YnOiaID9aEq0IEH9SOekiZpcO5JTSd6g=;
  b=L1Se2LankZMqrJjHhnK5d+n95biMEPYmfO0yF1KslvCPpNGBAOA2/XPF
   WnAW2DKiDEqDnL7WPpCZCGc5kKIMzF4RbrU++epTalpmlDcMTpxHH+1bs
   4SN+1DL9tNlOSILjoiNEoLrhVAp6Ux6R591RbPNFADWkyDTUHOhDCLlfU
   cxSISDWmucj+xa1tIBROrAJspXsiAvYwoKutvhKImh66CjXNqesJpkg7v
   u5vmEByvSebY5JvoNDgva+ZZWjncX+udmGenwBpoFyfiBS3EFRnlQu3+d
   UEE3GjfcVBPKaJ2KKryF0AAuaYN1cdcI2Bc1zbP+IMVZAuvJlxQJ5RJQG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="310441293"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="310441293"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 00:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="697703516"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="697703516"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 00:29:10 -0700
Message-ID: <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Date:   Wed, 02 Nov 2022 15:29:10 +0800
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
...
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

Hi Kirill,

When I came to cook v2 per your suggestion, i.e. leave it just flush, I
pondered on the necessity on all the cases of the 2 bits (LAM_U48,
LAM_U57) flips.
Hold this: LAM_U57 (bit61) takes precedence over LAM_U48 (bit62).

(0,0) --> {(0,1), (1,0), (1,1)}
(0,1) --> {(0,0), (1,0), (1,1)}
(1,0) --> {(0,0), (0,1), (1,1)}
(1,1) --> {(0,0), (1,0), (1,0)}

Among all the 12 cases, only (0,0) --> (1,0) && 5-level paging on, has
to flush tlb. Am I right? if so, would you still prefer unconditionally
flush, just for 1/12 necessity? (if include 5-level/4-level variations,
1/24)

> 
> And I don't buy argument about hot path: the case we talking about is
> about enabling/disabling LAM with constant PGD. It's not hot path by
> any
> mean.
> 
> Let's not be fancy. Just flush TLB.
> 

