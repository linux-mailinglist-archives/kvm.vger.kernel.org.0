Return-Path: <kvm+bounces-11650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DCA879149
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 10:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CB261F216A4
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAECB78283;
	Tue, 12 Mar 2024 09:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hkZETeDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310478281;
	Tue, 12 Mar 2024 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710236687; cv=none; b=S2mqsjHmbsU7QUi2wIReKH7JrAsjqjtfrMouDl59WtAXr98ifM+IMbQdn9ngMrGIICOzpTd2GOSf+21UEwqVOSdoJepc2vf/ZaQLSNGd49GsWRbHYUQmsb70pUrc+RjY9P/vWmlfwQy7NbFqYgTPi5rrbQ0GrO1jbi2lU5/p3eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710236687; c=relaxed/simple;
	bh=bQp+ziLFcrO8OM8ZoVaCOS6TWTCgAg7XPg2KUIQKb9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RK1nnQYAHruyvN5oKHm9w/zfy5aTCxx/2GZbpJ8KhvhfCZsR3H/uNFrlWaPgUC1rQGLwORKmKxeMIyQqUJrUa3EGlAFWQwIhK0xAygOv6zAR00z8KMRgULBvKMV1MRha/MmxtAdCuWrc+nN64UmpQa8yfkh8U0MOaCC6QVT0DLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hkZETeDJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710236685; x=1741772685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bQp+ziLFcrO8OM8ZoVaCOS6TWTCgAg7XPg2KUIQKb9c=;
  b=hkZETeDJV6IiGl4/KNKKnDPJanvwJyEgKUGsWsQ7YtSoQBg9wR583y94
   fyoYGD1DFCadSdeaXQI6znkGbn2nc8eSOx6TDC2oZ5lQ9MnlO8toN2M9h
   7RHkjpnqvjHbYyCGNmLAL/SYOKh5dWos5Sm/Gi/o3tf6nkbKfTh04s9ny
   CdO4YdZrgufYPzQW9iwBDXtWtrH0DjCoL3AbmmXhz/hjkoU/BoJ+GAAeT
   RFwtLgRUYVkIIGmOUdburH1k3zUDxJ9ctCFoz5PsU6LLDKRiyK2FKN4bD
   3wxFh5n9LZpecl0drCI/PG+Pdvv9MS0WtO3jK4884QtyBwHtXwcLr06Wf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5069695"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5069695"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 02:44:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="34662417"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 02:44:38 -0700
Message-ID: <3a2ff24f-0f22-4718-835a-fbd8a0763dcb@linux.intel.com>
Date: Tue, 12 Mar 2024 17:44:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-8-seanjc@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240228024147.41573-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 10:41 AM, Sean Christopherson wrote:
> Move the sanity check that hardware never sets bits that collide with KVM-
> define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
> i.e. make the sanity check #NPF specific.  The legacy #PF path already
> WARNs if _any_ of bits 63:32 are set, and the error code that comes from
> VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's

"Violatation" -> "Violation"

> EXIT_QUALIFICATION into error code flags).
>
> Add a compile-time assert in the legacy #PF handler to make sure that KVM-
> define flags are covered by its existing sanity check on the upper bits.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 12 +++---------
>   arch/x86/kvm/svm/svm.c |  9 +++++++++
>   2 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5d892bd59c97..bd342ebd0809 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4561,6 +4561,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>   	if (WARN_ON_ONCE(error_code >> 32))
>   		error_code = lower_32_bits(error_code);
>   
> +	/* Ensure the above sanity check also covers KVM-defined flags. */
> +	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
> +
>   	vcpu->arch.l1tf_flush_l1d = true;
>   	if (!flags) {
>   		trace_kvm_page_fault(vcpu, fault_address, error_code);
> @@ -5845,15 +5848,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	int r, emulation_type = EMULTYPE_PF;
>   	bool direct = vcpu->arch.mmu->root_role.direct;
>   
> -	/*
> -	 * WARN if hardware generates a fault with an error code that collides
> -	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
> -	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> -	 * flag that KVM doesn't know about.
> -	 */
> -	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> -		error_code &= ~PFERR_SYNTHETIC_MASK;
> -
>   	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>   		return RET_PF_RETRY;
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..199c4dd8d214 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2055,6 +2055,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>   	u64 fault_address = svm->vmcb->control.exit_info_2;
>   	u64 error_code = svm->vmcb->control.exit_info_1;
>   
> +	/*
> +	 * WARN if hardware generates a fault with an error code that collides
> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,

"sythentic" -> "synthetic"

Two typos.

Others,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> +	 * flag that KVM doesn't know about.
> +	 */
> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> +		error_code &= ~PFERR_SYNTHETIC_MASK;
> +
>   	trace_kvm_page_fault(vcpu, fault_address, error_code);
>   	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
>   			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?


