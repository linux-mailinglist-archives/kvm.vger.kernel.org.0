Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D413652DF2
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiLUIai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLUIae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:30:34 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790D71F2C4
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671611433; x=1703147433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UocrhDUv736jiHIQSS1asl+lpKiezvvf9DWM9IG49SE=;
  b=gs5lldyISeuxoVR+Lg/BzaPMw4tU+fQuPGGBKdwIRPuy6YbkI3v13Oia
   tLDQRMgCRdnhK6mQWHFfgYMU9MQpIwfbSu6BB13s6v03zmWTj+1ZSPqk8
   kRmUktQziuQs/tK5BsbmlTcBHrsG6wtz1l8OGRV8V4MIzh91qhRekL2ig
   LZMyqq+my10Ikq4tRIMPxcmmKDNi+1/Lmn9CkK2rmF3PuprzYEQG1HxjH
   kkvr53DdmgvmzUHNYN83mdA+b0HIx3dn2UsEhrtPhl0LgGdEbt1dhWi+D
   8lzur8suGaxCGcZxZ/M4GmB3/45T68wYmDhwHZ6467wgNRJaXFG9iT2aH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="320996759"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="320996759"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:30:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="719869272"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="719869272"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:30:25 -0800
Date:   Wed, 21 Dec 2022 16:30:21 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <20221221083021.5qb3v4ecyswtktd3@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-9-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-9-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:45:56PM +0800, Robert Hoo wrote:
> When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
> will build new CR3 with LAM bits updates. No TLB flush needed on this case.
> When changes on effective addresses, no matter LAM bits changes or not, go
> through normal pgd update process.

Sorry, may I ask why this is related to effective address changes?
This patch is only about the CR3 updates...

> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 48a2ad1e4cd6..6fbe8dd36b1e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1248,9 +1248,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  {
>  	bool skip_tlb_flush = false;
> -	unsigned long pcid = 0;
> +	unsigned long pcid = 0, old_cr3;
>  #ifdef CONFIG_X86_64
> -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);

This may qualify a seperate patch. :)

>  
>  	if (pcid_enabled) {
>  		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> @@ -1263,6 +1263,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
>  		goto handle_tlb_flush;
>  
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> +		return	1;
> +
>  	/*
>  	 * Do not condition the GPA check on long mode, this helper is used to
>  	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
> @@ -1274,8 +1278,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>  		return 1;
>  
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +	old_cr3 = kvm_read_cr3(vcpu);
> +	if (cr3 != old_cr3) {
> +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> +					X86_CR3_LAM_U57));
> +		} else {
> +			/*
> +			 * Though effective addr no change, mark the
Same question here.

> +			 * request so that LAM bits will take effect
> +			 * when enter guest.
> +			 */
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		}
> +	}
>  
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> -- 
B.R.
Yu
