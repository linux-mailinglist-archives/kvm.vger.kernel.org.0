Return-Path: <kvm+bounces-2258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 320AE7F40AB
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1962281809
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CD42D63F;
	Wed, 22 Nov 2023 08:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JUlVi7MP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B316AE7;
	Wed, 22 Nov 2023 00:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700643383; x=1732179383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=579B6Vn86UXddgf59Bx7trqMdHFc5/puvhZkPkUaV4A=;
  b=JUlVi7MPbR//by4Thh7ciwxViQLuX3LQvwvLS8Ri7e3qi6GBLnZPXnHs
   oMzy7cLvLTw5hpHFQsyYYWutNKkPJ3x1eQ4+SkdSTA5uKlEx+Bais/C2p
   bDrFifPgYrHryGLJqJPXJXxNw6w5BkSf2P1xNEBWYBQychdvCkvY06LKy
   cMtXk69hF1BsIo4n7qsUfGfP5vnpYIyGX2dKZwAt+StXtenznfqE6ntBG
   ZDGdvpD35/sxstU5Llj1J0+cuaqelhwuAJVaoZyko4l8QaVwegMf5NygV
   C7EcDjNl9dmaTnjsRWRsBxpugL6JiH3p29aTHm2fU7++NatvoJfEIvRTe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="5154735"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="5154735"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 00:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="770520489"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="770520489"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga007.fm.intel.com with ESMTP; 22 Nov 2023 00:56:19 -0800
Date: Wed, 22 Nov 2023 16:54:26 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paul Durrant <paul@xen.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/15] KVM: pfncache: include page offset in uhva and
 use it consistently
Message-ID: <ZV3Bwghwz63LmgMu@yilunxu-OptiPlex-7050>
References: <20231121180223.12484-1-paul@xen.org>
 <20231121180223.12484-8-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121180223.12484-8-paul@xen.org>

On Tue, Nov 21, 2023 at 06:02:15PM +0000, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Currently the pfncache page offset is sometimes determined using the gpa
> and sometimes the khva, whilst the uhva is always page-aligned. After a
> subsequent patch is applied the gpa will not always be valid so adjust
> the code to include the page offset in the uhva and use it consistently
> as the source of truth.
> 
> Also, where a page-aligned address is required, use PAGE_ALIGN_DOWN()
> for clarity.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> 
> v8:
>  - New in this version.
> ---
>  virt/kvm/pfncache.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 0eeb034d0674..c545f6246501 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -48,10 +48,10 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
>  	if (!gpc->active)
>  		return false;
>  
> -	if (offset_in_page(gpc->gpa) + len > PAGE_SIZE)
> +	if (gpc->generation != slots->generation || kvm_is_error_hva(gpc->uhva))
>  		return false;
>  
> -	if (gpc->generation != slots->generation || kvm_is_error_hva(gpc->uhva))
> +	if (offset_in_page(gpc->uhva) + len > PAGE_SIZE)
>  		return false;
>  
>  	if (!gpc->valid)
> @@ -119,7 +119,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
>  static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  {
>  	/* Note, the new page offset may be different than the old! */
> -	void *old_khva = gpc->khva - offset_in_page(gpc->khva);
> +	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
>  	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
>  	void *new_khva = NULL;
>  	unsigned long mmu_seq;
> @@ -192,7 +192,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  
>  	gpc->valid = true;
>  	gpc->pfn = new_pfn;
> -	gpc->khva = new_khva + offset_in_page(gpc->gpa);
> +	gpc->khva = new_khva + offset_in_page(gpc->uhva);
>  
>  	/*
>  	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
> @@ -215,8 +215,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>  	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
>  	unsigned long page_offset = offset_in_page(gpa);
>  	bool unmap_old = false;
> -	unsigned long old_uhva;
>  	kvm_pfn_t old_pfn;
> +	bool hva_change = false;
>  	void *old_khva;
>  	int ret;
>  
> @@ -242,8 +242,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>  	}
>  
>  	old_pfn = gpc->pfn;
> -	old_khva = gpc->khva - offset_in_page(gpc->khva);
> -	old_uhva = gpc->uhva;
> +	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
>  
>  	/* If the userspace HVA is invalid, refresh that first */
>  	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
> @@ -259,13 +258,25 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>  			ret = -EFAULT;
>  			goto out;
>  		}
> +
> +		hva_change = true;
> +	} else {
> +		/*
> +		 * No need to do any re-mapping if the only thing that has
> +		 * changed is the page offset. Just page align it to allow the
> +		 * new offset to be added in.

I don't understand how the uhva('s offset) could be changed when both gpa and
slot are not changed. Maybe I have no knowledge of xen, but in later
patch you said your uhva would never change...

Thanks,
Yilun

> +		 */
> +		gpc->uhva = PAGE_ALIGN_DOWN(gpc->uhva);
>  	}
>  
> +	/* Note: the offset must be correct before calling hva_to_pfn_retry() */
> +	gpc->uhva += page_offset;
> +
>  	/*
>  	 * If the userspace HVA changed or the PFN was already invalid,
>  	 * drop the lock and do the HVA to PFN lookup again.
>  	 */
> -	if (!gpc->valid || old_uhva != gpc->uhva) {
> +	if (!gpc->valid || hva_change) {
>  		ret = hva_to_pfn_retry(gpc);
>  	} else {
>  		/*
> -- 
> 2.39.2
> 
> 

