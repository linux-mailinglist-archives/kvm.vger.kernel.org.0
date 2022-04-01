Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDE4EE7B2
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 07:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbiDAFRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 01:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245051AbiDAFR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 01:17:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CD261331;
        Thu, 31 Mar 2022 22:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648790139; x=1680326139;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZIr+KdNh2N/rlw/ANBNWbrIxZR/TQJ4qv2aCPwfiR0=;
  b=VZy1KHUNtTM0uMoQtzGzrfzH7ij0mgHYsPjCH+Fu/dQCErcZ/2BpcB2M
   GSZomRbVhXH8SoeZWBCv/+BsnP7AZ1Iug2Ad2Fo6w4sT4rX7uNWe8Y1F+
   r3dYy+mZMJM5dxNbUH+i0p6gibJoDyzgedk5vOC1I3lKgtatho7D9aZi6
   GeUqNF63gmzcYnBfZLHNMTkId8ZM5hB47XNxY4zIEbaIFRXqoMs7SFq5i
   LW1QiNLzUWG0OzB3wdIjYGC/eDJX2Bw5/z8n4K8XYE6qbyWSDjfdOjdrW
   TmIGw+FlnviiXv7Rf5QzjtayMMBgE/MDLcqoIaTjTbNObiHMczMUa79VB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="257623902"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="257623902"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:15:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="650585733"
Received: from tswork-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.39])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:15:36 -0700
Message-ID: <c6fb151ced1675d1c93aa18ad8c57c2ffc4e9fcb.camel@intel.com>
Subject: Re: [RFC PATCH v5 038/104] KVM: x86/mmu: Allow per-VM override of
 the TDP max page level
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 18:15:34 +1300
In-Reply-To: <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> In the existing x86 KVM MMU code, there is already max_level member in
> struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> page fault handler denies page size larger than max_level.
> 
> Add per-VM member to indicate the allowed maximum page size with
> KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> kvm_page_fault with it.
> 
> For the guest TD, the set per-VM value for allows maximum page size to 4K
> page size.  Then only allowed page size is 4K.  It means large page is
> disabled.

Do not support large page for TD is the reason that you want this change, but
not the result.  Please refine a little bit.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu.h              | 2 +-
>  arch/x86/kvm/mmu/mmu.c          | 2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d8b78d6abc10..d33d79f2af2d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1053,6 +1053,7 @@ struct kvm_arch {
>  	unsigned long n_requested_mmu_pages;
>  	unsigned long n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
> +	int tdp_max_page_level;
>  	u8 mmu_valid_gen;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 0ae91b8b25df..650989c37f2e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -192,7 +192,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
>  		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
>  
> -		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.max_level = vcpu->kvm->arch.tdp_max_page_level,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
>  	};
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a474f2e76d78..e9212394a530 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5782,6 +5782,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> +
> +	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
>  }
>  
>  void kvm_mmu_uninit_vm(struct kvm *kvm)

