Return-Path: <kvm+bounces-17450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC278C6B7F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5321C2347B
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A564481A6;
	Wed, 15 May 2024 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nIiXdbvw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF99739FD4;
	Wed, 15 May 2024 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715794333; cv=none; b=ABoYvjQNFfvxT0nYQ5i+w9kajei1gLKrWMUbFE0VqDbW95ADQAFZUfnPoGFe1GrJyV7lGMYvoL0nbQFqIUykaZ7V9+5OpySZjfv3SwS2+RZJrepA8/sDiH9Nb3EeOVeiyQ4umfbzyb74jah+S48SEzghSz12hPCaG4yNbmIkUxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715794333; c=relaxed/simple;
	bh=H4tvcfjLPDJCNINCPIawFegvFWsr8Silcf/tixLHyQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=larMtPzZj8F8Mb3OcJc1ZL8a0KcnWZRJxvSCd2/eQExcPVRhUh0trSxwLxUqsonFQvAVhc4j2fCTpkN85PnHDmkjdqTnJ/xJwM5sFRenRbwKuesgGfmm2C6BxBRRzfo9qZ5bD3HfA5jMR/cZdrdk8iHBG5WxyENoeQSUVHtqQz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nIiXdbvw; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715794331; x=1747330331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H4tvcfjLPDJCNINCPIawFegvFWsr8Silcf/tixLHyQc=;
  b=nIiXdbvw/SY2u8uaE4/L4UvhcwAGmrevpY2zl0OBPtbSTStRPhn8IRr0
   75NBNI/WgMB+etHNlCu0X+EYXmv2YwmLViqvJ2mzkwkC1ulHA3t2jahzu
   +0SwMV3Bb9kTWIJUxsog9PhWcYHln2lp6GsZyv5PmytfM/X01GszkAVds
   TbBwZT4yLzHDJqR1ofT+AFtbeGC8fyly5iLY7bKQ++Gqt9SGprXl38kRm
   DrmrPdbjixYIpOGRuACwTFOXjp8BHDMROWBj1Mb8SE2JeqTL6R9SqAxd5
   XYbl9WUHJZqDn8Bjh93n05ytrnwA7klGWDkzsVDEZ6VA3IsOpXodhRFTH
   w==;
X-CSE-ConnectionGUID: jPP9+nZnSQS770cDgKk8ag==
X-CSE-MsgGUID: p51zKm/hRFO7l8IPkc809g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11987937"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11987937"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 10:32:10 -0700
X-CSE-ConnectionGUID: K5pXOraDRJ27Jk68iw1uUQ==
X-CSE-MsgGUID: cy365DZqQ/GzGoKi0US3zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35681840"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 10:32:10 -0700
Date: Wed, 15 May 2024 10:32:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, rick.p.edgecombe@intel.com
Subject: Re: [PATCH 2/7] KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE
Message-ID: <20240515173209.GD168153@ls.amr.corp.intel.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
 <20240507154459.3950778-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240507154459.3950778-3-pbonzini@redhat.com>

On Tue, May 07, 2024 at 11:44:54AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c6192a52bd31..f5401967897a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -603,7 +603,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * here since the SPTE is going from non-present to non-present.  Use
>  	 * the raw write helper to avoid an unnecessary check on volatile bits.
>  	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>  
>  	return 0;
>  }
> @@ -740,8 +740,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>  
>  		if (!shared)
> -			tdp_mmu_iter_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>  			goto retry;
>  	}
>  }
> @@ -808,8 +808,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>  		return false;
>  
> -	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			 sp->gfn, sp->role.level + 1);
> +	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
>  
>  	return true;
>  }
> @@ -843,7 +843,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> -		tdp_mmu_iter_set_spte(kvm, &iter, 0);
> +		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>  
>  		/*
>  		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
> -- 
> 2.43.0

I missed one conversion.  Here is the fix.  I found this during reviewing
TDX TDP MMU changes at [1].

[1] https://lore.kernel.org/kvm/20240515005952.3410568-11-rick.p.edgecombe@intel.com/

Paolo, how do you want me to proceed? I can send a updated patch or you can
directly fix the patch in kvm-coco-queue.  I'm fine with either way.


From 7910130c0a3f2c5d814d6f14d663b4b692a2c7e4 Mon Sep 17 00:00:00 2001
Message-ID: <7910130c0a3f2c5d814d6f14d663b4b692a2c7e4.1715793643.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Wed, 15 May 2024 10:19:08 -0700
Subject: [PATCH] fixup! KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE

---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1259dd63defc..36539c1b36cd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -626,7 +626,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * SPTEs.
 	 */
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    0, iter->level, true);
+			    SHADOW_NONPRESENT_VALUE, iter->level, true);
 
 	return 0;
 }

base-commit: 698ca1e403579ca00e16a5b28ae4d576d9f1b20e
-- 
2.43.2



-- 
Isaku Yamahata <isaku.yamahata@intel.com>

