Return-Path: <kvm+bounces-17829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2228CA8D9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 09:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BAF0282402
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 07:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7A34F88A;
	Tue, 21 May 2024 07:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qx1mDMxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2F179BD;
	Tue, 21 May 2024 07:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716276074; cv=none; b=Qv2CVV/06o+MPbP+n2XRr8tOtRlhbrFvcPD5c3GdhtrORU0KWKp7/IMVgrmz1HqEthW1sI/ZFLpVMpmpiJ1Mx+kDiXX5sw4u3Ltu1lORwP2UDoBCpp5HGKS6p7L0BH01QNwpj/E7h1B9y6yVp9p6LgnlT2hxB0XqurQwm0hK4kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716276074; c=relaxed/simple;
	bh=NCuRqtf4hbaWEv2tg870lYe1vIfJnNGgszYy20WfbEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O12mD9Y9UoAgvb05BAnRvW/9rp1AJpqZ8EtIt0QyRMxwp04NCY09UiF4ebORbkW3MOcEghTr2xhQNWFMkCwhBFnLuSfPwT1M28Osu8A5o3Uy+rTRPzHw5yX8xVZVhVMQQ35AsI4vKqygerOHjx7iAh1W77oargyIdWRNYv7tp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qx1mDMxV; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716276072; x=1747812072;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NCuRqtf4hbaWEv2tg870lYe1vIfJnNGgszYy20WfbEE=;
  b=Qx1mDMxVIDQX1QlJJQ8Lesy/vQE+8EwCXkZp8DtYRJRYd+jdTAnHslPy
   80ClkG0f6L+AuQSehbKTeakx46/xT7Egcov1RYcBtko3MpwSBscRy/zsi
   k9JF8yXeAa/A8hnLi31y7Y9H49In1yeMeaZsB73xE60CHUAbO/q1ecssa
   vRR4I+9bL2sJ2zkEfSpzPTX6MSvHIfCqSX2xz3r7Bd/LiAfWpEgKMOQwg
   z27HLSgnnaWlzlnLc+FgsJ/epGtixmGxxfVeScNvzWab8WHyrYqDs8sIg
   8r5Xs+nVp5SJbCnVnSJ936K9Fk7QbIkQsqq7mY8HrTah377Vsi+LO4oa/
   w==;
X-CSE-ConnectionGUID: RUddRDgSSRKLOBJMaBRpxA==
X-CSE-MsgGUID: utmEdidcQWWzMEL2McwBgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12673446"
X-IronPort-AV: E=Sophos;i="6.08,177,1712646000"; 
   d="scan'208";a="12673446"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 00:21:12 -0700
X-CSE-ConnectionGUID: DdQXJ35BRhm3ehYXLG3OJA==
X-CSE-MsgGUID: Ib5lFRWpRHOHmyGNrtsDeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,177,1712646000"; 
   d="scan'208";a="63652041"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 00:21:11 -0700
Date: Tue, 21 May 2024 00:21:11 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Use SHADOW_NONPRESENT_VALUE for atomic
 zap in TDP MMU
Message-ID: <20240521072111.GA212599@ls.amr.corp.intel.com>
References: <20240518000430.1118488-1-seanjc@google.com>
 <20240518000430.1118488-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240518000430.1118488-2-seanjc@google.com>

On Fri, May 17, 2024 at 05:04:22PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Use SHADOW_NONPRESENT_VALUE when zapping TDP MMU SPTEs with mmu_lock held
> for read, tdp_mmu_zap_spte_atomic() was simply missed during the initial
> development.
> 
> Fixes: 7f01cab84928 ("KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE")
> Not-yet-signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> [sean: write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1259dd63defc..36539c1b36cd 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -626,7 +626,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * SPTEs.
>  	 */
>  	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			    0, iter->level, true);
> +			    SHADOW_NONPRESENT_VALUE, iter->level, true);
>  
>  	return 0;
>  }
> -- 
> 2.45.0.215.g3402c0e53f-goog

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

