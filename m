Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E2B4F6ED4
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiDFXpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiDFXpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:45:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F22FE7E;
        Wed,  6 Apr 2022 16:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649288616; x=1680824616;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=var08CWaVapTWvJV0XMLthqg4e7b4fr7jqqhMfupECY=;
  b=CETrv9zYGlfaezMeg5SEE0SRXlNfGfxhkXu+QCfaxDsHDSZVKDd9pUbM
   Tx+DsWtfjBkhMmb0/Pvla8xNg+/xAPF716aaOcIVtL/p98ODI4hHxe3IS
   2a7R5SMGLfPmnKjsj2Py919Am0oyHrSsTwOtYeCfYj6+vXTWoQQDt5So2
   yrell8fb6cOuC5aKkrXVKhnoQUhCa31mzGF9rjEw2QiadEdY8M5k/jqVr
   ZDFIYUCChozj5TfgBTZZ0tAnF2YjVBbK4Gkn9oKCzQq6WtXEc9V1qlYlo
   /5zU7aDqY+e8A9XQso72k5DVjAT7jlqS5zh3jvPmGNyB5wnH9gF//gHzP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261365448"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="261365448"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 16:43:35 -0700
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="588580003"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 16:43:33 -0700
Message-ID: <a439dc1542539340e845d177be911c065a4e8d97.camel@intel.com>
Subject: Re: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to
 struct kvm_mmu_page
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 11:43:30 +1200
In-Reply-To: <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
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

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a private pointer to kvm_mmu_page for private EPT.
> 
> To resolve KVM page fault on private GPA, it will allocate additional page
> for Secure EPT in addition to private EPT.  Add memory allocator for it and
> topup its memory allocator before resolving KVM page fault similar to
> shared EPT page.  Allocation of those memory will be done for TDP MMU by
> alloc_tdp_mmu_page().  Freeing those memory will be done for TDP MMU on
> behalf of kvm_tdp_mmu_zap_all() called by kvm_mmu_zap_all().  Private EPT
> page needs to carry one more page used for Secure EPT in addition to the
> private EPT page.  Add private pointer to struct kvm_mmu_page for that
> purpose and Add helper functions to allocate/free a page for Secure EPT.
> Also add helper functions to check if a given kvm_mmu_page is private.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  9 ++++
>  arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
>  4 files changed, 97 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fcab2337819c..0c8cc7d73371 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	struct kvm_mmu_memory_cache mmu_private_sp_cache;
>  
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e9847b1124b..8def8b97978f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -758,6 +758,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
>  	int start, end, i, r;
>  
> +	if (kvm_gfn_stolen_mask(vcpu->kvm)) {

Please get rid of kvm_gfn_stolen_mask().

> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
> +
>  	if (shadow_init_value)
>  		start = kvm_mmu_memory_cache_nr_free_objects(mc);
>  
