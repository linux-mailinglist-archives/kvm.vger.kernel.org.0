Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EE2695881
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBNF2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBNF2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:28:40 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73493CF
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 21:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676352519; x=1707888519;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YpPec0kUGjsmXPwX/LnRnRLj88sBMIU4pIASbXJrUNs=;
  b=Wfd6rlaPbVK1byoMm4Lu4Mt6MAy3TQA9jK/fSMUXWAadC2dl55EGrt7C
   yD/fd/1zLTLkcNxeTvD7TS9BAUZiV4nCg1P9VDq2W+6V4AKFXOPilvJhU
   FoL2AEIo66Psel60EJZQBDCf9pj0YmLF+Vnb4IWbof65tSLx+aMKudnq3
   GovqBR0GPgRo/g31GfaI/WgM+kcmx2Ad6uZmJWfKXPCwAQO0kKtSK/gev
   mQkD7N1/tYs9O1G98i3dqGYsu9T8eZXzbUpdEpMi6Brrb92zM62yDbNgp
   2gn1EwNJnoTsyFHk8cLaYEC5aGVjlMTYt0CvxlPJZUxlvlopOW+pK2Rwm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314723445"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314723445"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 21:28:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="792988027"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="792988027"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 13 Feb 2023 21:28:34 -0800
Message-ID: <8ece08328b0ab07303140b9b731e252cfdb38b1f.camel@linux.intel.com>
Subject: Re: [PATCH v4 7/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Tue, 14 Feb 2023 13:28:33 +0800
In-Reply-To: <Y+mvG8S3W5lXoZNJ@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-8-robert.hu@linux.intel.com>
         <Y+mvG8S3W5lXoZNJ@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-13 at 11:31 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:20AM +0800, Robert Hoo wrote:
> > When only changes LAM bits, ask next vcpu run to load mmu pgd, so
> > that it
> > will build new CR3 with LAM bits updates.
> > When changes on CR3's effective address bits, no matter LAM bits
> > changes or not,
> > go through normal pgd update process.
> 
> Please squash this into patch 2.
> 
Though all surround CR3, I would prefer split into pieces, so that
easier for review and accept. I can change their order to group
together. Is it all right for you?
> > 
> > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> 
> This change isn't related. Please drop it or post it separately.
> 
Yu commented this also on last version. I thought it's too trivial to
be separated.
Now that both of you suggest this. Let me split it in a separated patch
in this set. Is this all right?
I do think separating it in another patch set alone, is too trivial.
> > 
> > 	if (pcid_enabled) {
> > 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > @@ -1257,6 +1257,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> > 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> > 		goto handle_tlb_flush;
> > 
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> > +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> > +		return	1;
> 
> can you move this check to kvm_vcpu_is_valid_cr3(), i.e., return
> false in
> that function if any LAM bit is toggled while LAM isn't exposed to
> the guest?
> 
OK
> > +
> > 	/*
> > 	 * Do not condition the GPA check on long mode, this helper is
> > used to
> > 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
> > that
> > @@ -1268,8 +1272,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> > 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> > 		return 1;
> > 
> > -	if (cr3 != kvm_read_cr3(vcpu))
> > -		kvm_mmu_new_pgd(vcpu, cr3);
> > +	old_cr3 = kvm_read_cr3(vcpu);
> > +	if (cr3 != old_cr3) {
> > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> 
This means those effective addr bits changes, then no matter LAM bits
toggled or not, it needs new pgd.

> Does this check against CR3_ADDR_MASK necessarily mean LAM bits are
> toggled, i.e., CR3_ADDR_MASK == ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)?
> 
> Why not check if LAM bits are changed? This way the patch only
> changes
> cases related to LAM, keeping other cases intact.

Yes, I can better to add check in "else" that LAM bits changes.
But in fact above kvm_is_valid_cr3() has guaranteed no other high order
bits changed.
Emm, now you might ask to melt LAM bits into vcpu-
>arch.reserved_gpa_bits? ;)
> 
> > +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> > +					X86_CR3_LAM_U57));
> 
> Do you need to touch kvm_mmu_new_pgd() in nested_vmx_load_cr3()?

Didn't scope nested LAM case in this patch set.


