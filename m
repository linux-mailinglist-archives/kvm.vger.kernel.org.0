Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5F65224B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiLTOR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiLTORa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:17:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FBFD2F6
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545809; x=1703081809;
  h=message-id:subject:from:to:date:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ymxZryEHDHlrfVLHxwmM4t7sEGIWfOhy9ulmRK9XQcI=;
  b=QjeUgMTVbIvhar7VwIOYNZ87tD8cm+DWirnu4k0ThIrRv2yDzqsCcAvn
   ddYY8fBLSEwEqE8bx5LEyoiZmOcQeETRo+CMuxK2NOpAFEhDzfxCr2PiP
   tn/2ghVPUb4CcxmRGrgbJGuwMztKCfh9pQUj/dDRzvK5Xfo9PROeCucuk
   mc2twChSwBk9kd4Ucc5K/EzJISQoZTScg+pjgv+DEUNvQO3YzGyjduIM5
   ySveJQ8I2GLLUgSRt9Qdk6vueQOvHYRHSRDV1Q/V854w6v8KD2+JtOx8S
   u458Ue9RqaT6sQBCV6BYnAj02MY2t8WA7bZZA6ihzZuEqeviJDCTgZ7/3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="346724172"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="346724172"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:16:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="601105939"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="601105939"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 20 Dec 2022 06:16:46 -0800
Message-ID: <08b4bc70fedcd0bfd6a2bc9c932f283ed5efdbcb.camel@linux.intel.com>
Subject: Re: [PATCH v3 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Liu, Jingqi" <jingqi.liu@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Tue, 20 Dec 2022 22:16:45 +0800
In-Reply-To: <d9f576df-04b4-1d30-438c-7296e5b4f359@intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-9-robert.hu@linux.intel.com>
         <d9f576df-04b4-1d30-438c-7296e5b4f359@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-20 at 17:10 +0800, Liu, Jingqi wrote:
> On 12/9/2022 12:45 PM, Robert Hoo wrote:
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
> >   arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
> >   1 file changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 48a2ad1e4cd6..6fbe8dd36b1e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1248,9 +1248,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu
> > *vcpu, unsigned long cr3)
> >   int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >   {
> >   	bool skip_tlb_flush = false;
> > -	unsigned long pcid = 0;
> > +	unsigned long pcid = 0, old_cr3;
> >   #ifdef CONFIG_X86_64
> > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> >   
> >   	if (pcid_enabled) {
> >   		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > @@ -1263,6 +1263,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> >   	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> >   		goto handle_tlb_flush;
> >   
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> > +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> > +		return	1;
> > +
> >   	/*
> >   	 * Do not condition the GPA check on long mode, this helper is
> > used to
> >   	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
> > that
> > @@ -1274,8 +1278,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> >   	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> >   		return 1;
> >   
> > -	if (cr3 != kvm_read_cr3(vcpu))
> > -		kvm_mmu_new_pgd(vcpu, cr3);
> > +	old_cr3 = kvm_read_cr3(vcpu);
> > +	if (cr3 != old_cr3) {
> > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> > +					X86_CR3_LAM_U57));
> 
> "CR3_ADDR_MASK" should not contain "X86_CR3_LAM_U48 |
> X86_CR3_LAM_U57"

Yes, you're right. CR3_ADDR_MASK is the effective pgd address bits
range. This hunk of code is: judge if changed bits falls in effective
address, if true, need to load new pgd, no matter LAM bits changed or
not.

> But seems it is not defined explicitly.
> Besides this, looks good for me.
> Reviewed-by: Jingqi Liu<jingqi.liu@intel.com>
> > +		} else {
> > +			/*
> > +			 * Though effective addr no change, mark the
> > +			 * request so that LAM bits will take effect
> > +			 * when enter guest.
> > +			 */
> > +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > +		}
> > +	}
> >   
> >   	vcpu->arch.cr3 = cr3;
> >   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);

