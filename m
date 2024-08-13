Return-Path: <kvm+bounces-24053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD396950BAF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3C11C21026
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8740C1A38CB;
	Tue, 13 Aug 2024 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDff7bnp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D41A2C32;
	Tue, 13 Aug 2024 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723571509; cv=none; b=pwTmzOWeoCQvdqs3oat5939W9n9Y1hyI2bAgpEz0agI6f8KZrPNGNhPU4pPzCRdkYExLQtzk6J+LOvQbv4iJrnhRYRi41gCoOY1Qi1ZQ2vBmbwgiCCfj3gFsTLSTveUIniqSH0+JasZnbe7mH3IHHaU1tbZg17wzKt86Y1qK5r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723571509; c=relaxed/simple;
	bh=CSQq8lKHKJYcYR2uxzATV/yKyJcOtXWbihzEXB5uc1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofu8HqxmFmmpDhGTg/I5ql+B/Vj0SoiIGrkiY4pvAkHxHYg+KNOxTYlSqsiP7HTdUetNs+9rd0UfDXInhskBrIIu5kgVzDImPkSsG5lP5VGmFaYxCWoykYL2TNfQZ5C8M51j4WoxpguG+K1P23PHj8+itdpaFAODzVZHynoHkV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDff7bnp; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723571508; x=1755107508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CSQq8lKHKJYcYR2uxzATV/yKyJcOtXWbihzEXB5uc1w=;
  b=bDff7bnpOmCMy8DHXtCpDV0gNgTvOc9OvqnMl59QtUIA2K04ufdllPoK
   oa0+IBoqBKMNVn6yxBXc0zbQIncm/o1cU3Ru66bod1zO+7YJfA3BSQc7b
   6G1FIJ3ZtkMnY+cGfYfE3trUTToNcfVd8vGg6A7l2pJqZgsNZZLffFAJO
   y5+b0Sg11hB03w4QLwvVIeNDDJ9t3u6YWsyOO5U1cusv6rHvBawJadmwt
   gkH6Wos5TTr3zavC7MnH3gnAHbnwqXD1KUZDkQVbvyt/ke/tj8y9ge1RE
   oXBJ4YUuHX9RSIJ7CZi4EIpnoF2I1Xkk3jMG4dTVR1W2q07/C9rhGopQ/
   w==;
X-CSE-ConnectionGUID: EWuDol23Su+AYdcouNh4UA==
X-CSE-MsgGUID: w1ZDY+p/TCa9dqIeInu87w==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21567847"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="21567847"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:51:47 -0700
X-CSE-ConnectionGUID: N46dxCNkRyWrBpf082kcJA==
X-CSE-MsgGUID: 1RafmUaYSR+34HQMVVldAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="63408135"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:51:38 -0700
Date: Tue, 13 Aug 2024 10:51:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of
 opencode
Message-ID: <ZrudKcslzzO4TP3m@ls.amr.corp.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-3-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240813051256.2246612-3-binbin.wu@linux.intel.com>

On Tue, Aug 13, 2024 at 01:12:56PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> Use is_kvm_hc_exit_enabled() instead of opencode.
> 
> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  arch/x86/kvm/x86.c     | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a16c873b3232..d622aab8351d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3635,7 +3635,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>  		return 1; /* resume guest */
>  	}
>  
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>  		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
>  		return 1; /* resume guest */
>  	}
> @@ -3718,7 +3718,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	bool huge;
>  	u64 gfn;
>  
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>  		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
>  		return 1;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6e16c9751af7..9857c1984ef7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10171,7 +10171,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  		u64 gpa = a0, npages = a1, attrs = a2;
>  
>  		ret = -KVM_ENOSYS;
> -		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
> +		if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
>  			break;
>  
>  		if (!PAGE_ALIGNED(gpa) || !npages ||
> -- 
> 2.43.2
> 
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

