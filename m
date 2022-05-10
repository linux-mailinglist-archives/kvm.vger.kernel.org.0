Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A665209ED
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiEJAVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiEJAVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:21:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F2513C4FC;
        Mon,  9 May 2022 17:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652141823; x=1683677823;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E5z10fQtUjQnqiqpp/swFHGrC/hU0UuUbUATou3iop0=;
  b=DT4NGvW20pWwlOe1CYOcfPkD2l15VqkMri2TnKULPzT+vqtFNQk3WjRm
   8hYlT6pwQ910hdwaSg2eLEllVl7ELmKREX3NTmVHSaOfib7LozjLb5RBk
   UKU3h4JIiNzXBHXjdZKpaVoF0jKEtQsq2ZICsAXym3h/d2EE556LBwhLh
   6CCGwVMyY/kfY51DvZPkREthQ4ZgzN2pKJjeEi0jfMTHM+h013EJBl+dH
   d7sE6/rS4emDuJ3XRy+k5sra9ICNrRWMKFmjLMDua85Tc8mxbfYfmb3f5
   HF3WnM9dgAjvRfDPhMISqt7jL1fUA/QALMGKu8QKsotBfeWdwMl+KjocD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="266796801"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="266796801"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 17:17:03 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="552211497"
Received: from abehrenx-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.104])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 17:17:01 -0700
Message-ID: <c103ce2619b0ee6d72a10c60cd12d08af112e43d.camel@intel.com>
Subject: Re: [RFC PATCH v6 034/104] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Date:   Tue, 10 May 2022 12:16:58 +1200
In-Reply-To: <38c30f2c5ad6f9ca018c3e990f244c9b67ef10cb.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
         <38c30f2c5ad6f9ca018c3e990f244c9b67ef10cb.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 11:14 -0700, isaku.yamahata@intel.com wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> TDX repurposes one GPA bits (51 bit or 47 bit based on configuration) to
> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> GPA.shared is set, GPA is converted existing conventional EPT pointed by
> EPTP.  If GPA.shared bit is cleared, GPA is converted by Secure-EPT(S-EPT)
> TDX module manages.  VMM has to issue SEAM call to TDX module to operate on
> S-EPT.  e.g. populating/zapping guest page or shadow page by TDH.PAGE.{ADD,
> REMOVE} for guest page, TDH.PAGE.SEPT.{ADD, REMOVE} S-EPT etc.
> 
> Several hooks needs to be added to KVM MMU to support TDX.  Add a function
> to check if KVM MMU is running for TDX and several functions for address
> conversation between private-GPA and shared-GPA.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/mmu.c          |  6 ++++--
>  3 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 60a97ae55972..88fd3fd3e1a0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1251,7 +1251,9 @@ struct kvm_arch {
>  	 */
>  	u32 max_vcpu_ids;
>  
> +#ifdef CONFIG_KVM_MMU_PRIVATE
>  	gfn_t gfn_shared_mask;
> +#endif
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 7e258cc94152..3647035a147e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -373,4 +373,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	return kvm->arch.gfn_shared_mask;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline gfn_t kvm_gfn_shared(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_private(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gpa_t kvm_gpa_private(const struct kvm *kvm, gpa_t gpa)
> +{
> +	return gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(kvm));
> +}
> +
> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
> +{
> +	gfn_t mask = kvm_gfn_shared_mask(kvm);
> +
> +	return mask && !(gpa_to_gfn(gpa) & mask);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 909372762363..d1c37295bb6e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -264,8 +264,10 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
>  {
>  	int ret = -ENOTSUPP;
>  
> -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> +	if (range && kvm_available_flush_tlb_with_range()) {
> +		/* Callback should flush both private GFN and shared GFN. */
>  		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> +	}

??

>  
>  	if (ret)
>  		kvm_flush_remote_tlbs(kvm);
> @@ -4048,7 +4050,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	unsigned long mmu_seq;
>  	int r;
>  
> -	fault->gfn = fault->addr >> PAGE_SHIFT;
> +	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
>  	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
>  
>  	if (page_fault_handle_page_track(vcpu, fault))

As I said in previous version, this above change alone is broken:

https://lore.kernel.org/lkml/cover.1646422845.git.isaku.yamahata@intel.com/T/#mcd5c235e3577f5129810f3183f151a1c5f63466e

Why cannot this patch be merged to other patch(es) which truly adds
private/shared mapping support?

Or did I get something wrong?

-- 
Thanks,
-Kai


