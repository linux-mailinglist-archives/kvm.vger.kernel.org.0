Return-Path: <kvm+bounces-25994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 263A796EA11
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 08:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4F9328AECA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1D313E03A;
	Fri,  6 Sep 2024 06:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRkF0WNz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD162F4A;
	Fri,  6 Sep 2024 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725603751; cv=none; b=S8kxth/ITQml4tdtNozYrLyYNs6Yvh6feC1d3ABh5mK/DQxP2JKOA3B3eJA5eGh7GFobLGbgAKUdTclAB0fYcS965wdLIqIoWp9EcWRfFuvFkg1erAFYone/KSGWSG5DkilaRlcD68Dn8+7YrAnajAHhx0kHZPkx89Ql/haCsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725603751; c=relaxed/simple;
	bh=jaDXJ6teKw9QKtROdiagfeni/FjRNqD/q4LF0dj42GM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaNDss44ie7q7k0Zn3F8hc3MYNDEBVL1GVhpjFXzwcVI5OTjnvD1zDlSZm4GqN+6ypR6J9QONSvVpoTHwxpb4fgwktOHWoKb9vFjlCytL9kjIhzEEibsEUzFvSlpmnrIPILdOzWKqsJNS1iKQMx0Vd0ElNC7RGooDzPV7iyU+/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRkF0WNz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725603750; x=1757139750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jaDXJ6teKw9QKtROdiagfeni/FjRNqD/q4LF0dj42GM=;
  b=DRkF0WNz8geKyZ6Eff8yoVVpurhvh32czoYeppSFiDGFWUX8HGkFqLXK
   0LQAnxo/ebep8dpDRlIFeITrh87GSdSwC+v8nnQ5WVoPpI8D6iyCchh5e
   lvIAoJRjzcyB3BhCHxDCc8MuGoFDWa3wD7BdJED7Po0hWW8JFasxCvAo5
   x/9MY3BwkY988wN47R+PJS3yhh33O1Zr3gS3JWl5fzt2y8oj3uBOPvxtU
   n/7/NhiqdFBuXNf+6PMohSKXJK3pywfq2bm3hb5NDXb2dwxdWX88LkduC
   YZJg6ot0AsN+TKkxu9xPULcC1d2J/TPpKK6rvY/n+41F5htnYrqriW0Rj
   w==;
X-CSE-ConnectionGUID: Gp0mqqxPRyGktcK39eIRvA==
X-CSE-MsgGUID: IsZ36e6sSgSPSk2oOEHTCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="24464222"
X-IronPort-AV: E=Sophos;i="6.10,207,1719903600"; 
   d="scan'208";a="24464222"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 23:22:29 -0700
X-CSE-ConnectionGUID: HrBkL/w2Qye/Dzj8a7kPJA==
X-CSE-MsgGUID: AFuN4uRYQoGaZpwzzay4gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,207,1719903600"; 
   d="scan'208";a="96575685"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa002.jf.intel.com with ESMTP; 05 Sep 2024 23:22:27 -0700
Date: Fri, 6 Sep 2024 14:22:26 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v2 04/22] KVM: x86/mmu: Skip emulation on page fault iff
 1+ SPs were unprotected
Message-ID: <20240906062226.ej4ni5t2hz77x7tj@yy-desk-7060>
References: <20240831001538.336683-1-seanjc@google.com>
 <20240831001538.336683-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240831001538.336683-5-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Fri, Aug 30, 2024 at 05:15:19PM -0700, Sean Christopherson wrote:
> When doing "fast unprotection" of nested TDP page tables, skip emulation
> if and only if at least one gfn was unprotected, i.e. continue with
> emulation if simply resuming is likely to hit the same fault and risk
> putting the vCPU into an infinite loop.
>
> Note, it's entirely possible to get a false negative, e.g. if a different
> vCPU faults on the same gfn and unprotects the gfn first, but that's a
> relatively rare edge case, and emulating is still functionally ok, i.e.
> saving a few cycles by avoiding emulation isn't worth the risk of putting
> the vCPU into an infinite loop.
>
> Opportunistically rewrite the relevant comment to document in gory detail
> exactly what scenario the "fast unprotect" logic is handling.
>
> Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> Cc: Yuan Yao <yuan.yao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 57692d873f76..6b5f80f38a95 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5959,16 +5959,37 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	bool direct = vcpu->arch.mmu->root_role.direct;
>
>  	/*
> -	 * Before emulating the instruction, check if the error code
> -	 * was due to a RO violation while translating the guest page.
> -	 * This can occur when using nested virtualization with nested
> -	 * paging in both guests. If true, we simply unprotect the page
> -	 * and resume the guest.
> +	 * Before emulating the instruction, check to see if the access was due
> +	 * to a read-only violation while the CPU was walking non-nested NPT
> +	 * page tables, i.e. for a direct MMU, for _guest_ page tables in L1.
> +	 * If L1 is sharing (a subset of) its page tables with L2, e.g. by
> +	 * having nCR3 share lower level page tables with hCR3, then when KVM
> +	 * (L0) write-protects the nested NPTs, i.e. npt12 entries, KVM is also
> +	 * unknowingly write-protecting L1's guest page tables, which KVM isn't
> +	 * shadowing.

Hi Sean,

Sorry I didn't reply to you in v1 in time.

Now it's very clear to me why we had this code path here.
Thank you for the excellent explaination on this interesting behaivor!

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> +	 *
> +	 * Because the CPU (by default) walks NPT page tables using a write
> +	 * access (to ensure the CPU can do A/D updates), page walks in L1 can
> +	 * trigger write faults for the above case even when L1 isn't modifying
> +	 * PTEs.  As a result, KVM will unnecessarily emulate (or at least, try
> +	 * to emulate) an excessive number of L1 instructions; because L1's MMU
> +	 * isn't shadowed by KVM, there is no need to write-protect L1's gPTEs
> +	 * and thus no need to emulate in order to guarantee forward progress.
> +	 *
> +	 * Try to unprotect the gfn, i.e. zap any shadow pages, so that L1 can
> +	 * proceed without triggering emulation.  If one or more shadow pages
> +	 * was zapped, skip emulation and resume L1 to let it natively execute
> +	 * the instruction.  If no shadow pages were zapped, then the write-
> +	 * fault is due to something else entirely, i.e. KVM needs to emulate,
> +	 * as resuming the guest will put it into an infinite loop.
> +	 *
> +	 * Note, this code also applies to Intel CPUs, even though it is *very*
> +	 * unlikely that an L1 will share its page tables (IA32/PAE/paging64
> +	 * format) with L2's page tables (EPT format).
>  	 */
> -	if (direct && is_write_to_guest_page_table(error_code)) {
> -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> +	if (direct && is_write_to_guest_page_table(error_code) &&
> +	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
>  		return RET_PF_RETRY;
> -	}
>
>  	/*
>  	 * The gfn is write-protected, but if emulation fails we can still
> --
> 2.46.0.469.g59c65b2a67-goog
>

