Return-Path: <kvm+bounces-48958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B2FAD48D0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3967189B084
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B95145B25;
	Wed, 11 Jun 2025 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y774YWLF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525BE17A300;
	Wed, 11 Jun 2025 02:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749608552; cv=none; b=CCimwyQj7Vih7P5ixOdsoOftB5RflNwoGNlaVSNWypyYZMHEmxSaLhHvG6o2P0k7YfdxS7a77M/shqjHb0ldY+qXjZJu5wl+M8iingVFP85xU+NpIfiyb5F6veCBVuI+AewtEpyc7f7xGOxeEPptweB0/29aVCJwBlSIZfLG6so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749608552; c=relaxed/simple;
	bh=Ed1is4dFFQcnJqd890TF8mEHkJbOWmhg5Z6sN2kKXiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jZuTjuLOVwiY3iK3UdOEGdOM1F362yb61+N/z8vkXQJJyhAl2xLLcxUFk5vMSVBEqJ/BiBkEwy8aXMlh+MHca91e3/EsAr+NpmsPglWpuFtydBGAyPuLwLxFrAbtk2Yzy7Q2+cxxR7GQPnQ1JJ8RA4J7b5vgx6TeiU7dc2lbfcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y774YWLF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749608550; x=1781144550;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ed1is4dFFQcnJqd890TF8mEHkJbOWmhg5Z6sN2kKXiY=;
  b=Y774YWLFaKsJX89L0SKPAXjWE/vbRA/r3y+V6kZE2FsMxDi0/AkywvIJ
   NyVsE8P5nzC2ejh/6H5+PHhZ66iPRsvuATO6oVWTjBtu0B/wwYN4gx0jR
   kHjAg6x/sMDk/SQ6JmNwF0CYM4Q3+jryxnB4Ohi/nyUj4EILmVnUWqlDh
   IadhaMxQ9IE0l0rGozj1J1uM7bT/V/UwQoLAIjeWjEhpWogdidhPLMpt/
   xY0eadXZfkRsa6oGVFq14W0UxHc4QxrhprL9oCU7uJ2D2AbNsXa/5KtXE
   zI39bjUiJ303sShfnITwF7E6Xgkg/XnQiKYWnO2j2JRIWZL/NN6D36MDJ
   Q==;
X-CSE-ConnectionGUID: dUbSLDQkTP++75Bn+J5GHw==
X-CSE-MsgGUID: 0z3bxPUrR8+HLm3jI8Nq/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="50963429"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="50963429"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:22:29 -0700
X-CSE-ConnectionGUID: cJqF3sT6R0+zK3350hbcPg==
X-CSE-MsgGUID: 2yNrwdHTT6ScKhzYCoIr8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="177931736"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:22:27 -0700
Message-ID: <6ca40a71-fd4e-49f7-af45-5855ccbb857b@linux.intel.com>
Date: Wed, 11 Jun 2025 10:22:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/32] KVM: SVM: Massage name and param of helper that
 merges vmcb01 and vmcb12 MSRPMs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-9-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610225737.156318-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Rename nested_svm_vmrun_msrpm() to nested_svm_merge_msrpm() to better
> capture its role, and opportunistically feed it @vcpu instead of @svm, as
> grabbing "svm" only to turn around and grab svm->vcpu is rather silly.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 15 +++++++--------
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8427a48b8b7a..89a77f0f1cc8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -189,8 +189,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
>   * is optimized in that it only merges the parts where KVM MSR permission bitmap
>   * may contain zero bits.
>   */
> -static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> +static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	int i;
>  
>  	/*
> @@ -205,7 +206,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  	if (!svm->nested.force_msr_bitmap_recalc) {
>  		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
>  
> -		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
> +		if (kvm_hv_hypercall_enabled(vcpu) &&
>  		    hve->hv_enlightenments_control.msr_bitmap &&
>  		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
>  			goto set_msrpm_base_pa;
> @@ -230,7 +231,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  
>  		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>  
> -		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
> +		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
>  			return false;
>  
>  		svm->nested.msrpm[p] = svm->msrpm[p] | value;
> @@ -937,7 +938,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
>  		goto out_exit_err;
>  
> -	if (nested_svm_vmrun_msrpm(svm))
> +	if (nested_svm_merge_msrpm(vcpu))
>  		goto out;
>  
>  out_exit_err:
> @@ -1819,13 +1820,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
>  	if (WARN_ON(!is_guest_mode(vcpu)))
>  		return true;
>  
>  	if (!vcpu->arch.pdptrs_from_userspace &&
> -	    !nested_npt_enabled(svm) && is_pae_paging(vcpu))
> +	    !nested_npt_enabled(to_svm(vcpu)) && is_pae_paging(vcpu))
>  		/*
>  		 * Reload the guest's PDPTRs since after a migration
>  		 * the guest CR3 might be restored prior to setting the nested
> @@ -1834,7 +1833,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
>  			return false;
>  
> -	if (!nested_svm_vmrun_msrpm(svm)) {
> +	if (!nested_svm_merge_msrpm(vcpu)) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror =
>  			KVM_INTERNAL_ERROR_EMULATION;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ec97ea1d7b38..854904a80b7e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3137,7 +3137,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 *
>  		 * For nested:
>  		 * The handling of the MSR bitmap for L2 guests is done in
> -		 * nested_svm_vmrun_msrpm.
> +		 * nested_svm_merge_msrpm().
>  		 * We update the L1 MSR bit as well since it will end up
>  		 * touching the MSR anyway now.
>  		 */

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



