Return-Path: <kvm+bounces-66033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EBDCBFBC7
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 059CF305DCF9
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FA33446B6;
	Mon, 15 Dec 2025 19:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LDrZDkby"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C13446A5
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827206; cv=none; b=jlWzzLd80neCzwbH0gmQEQM/5BSB2aty034i71ejYjL9+sMfbHViY+RC8Znmd0ffXlyiTkJYb0jPJK5inkvoHQIsci92WllFPwxdS4DQAwgojB7HKfLGwrfZ5bYLS4veh7eH8wfkN0pB8pPm5SU7aD9V0TpXtjvx/s/5y5SA5Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827206; c=relaxed/simple;
	bh=5K9dVKrFNvq+UztJPA6V6LAXY96BAShfw8hQxFLzPoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKAGn9+p1qyRXT5S+bsiv7vi+FGTZeTqh0/k1igO3zf3D9zTnDIB7vqpLuBWOnJScvhNULr8zcjvJvmY9gyrVH4kT/HAxrfUwemVr416q/7mcrRxHon6ALVPPq8NqNecljp/ftqUSh+ZhT8ZxeVPUbSIHYrwH8UUnM4s3HlFASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LDrZDkby; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 19:33:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765827193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asjDZxWNBEJ605HFXpdIR/6Gm2xB5pbkPvRJHQnUY7s=;
	b=LDrZDkbyG7J8wbnmntGs9ZABQ2nohTqrHCRSjQrw1Gp2I80vkP1s5OvX74IprIOmQHLBA0
	ElXe0ekzs1tJnmQcmWtONYqMNcVPGEAdpjuuMJAB64SpbuL0Az0Aytox2zDt0vyHNm0h3x
	2Wb67hTpUt235c642iKRLp8lgB3S91E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Message-ID: <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 07:26:54PM +0000, Yosry Ahmed wrote:
> svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> already set correctly. This results in force_msr_bitmap_recalc always
> being set to true on every nested transition, essentially undoing the
> hyperv optimization in nested_svm_merge_msrpm().
> 
> Fix it by keeping track of whether LBR MSRs are intercepted or not and
> only doing the update if needed, similar to x2avic_msrs_intercepted.
> 
> Avoid using svm_test_msr_bitmap_*() to check the status of the
> intercepts, as an arbitrary MSR will need to be chosen as a
> representative of all LBR MSRs, and this could theoretically break if
> some of the MSRs intercepts are handled differently from the rest.
> 
> Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> only recently introduced with no direct alternatives in older kernels.
> 
> Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Sigh.. I had this patch file in my working directory and it was sent by
mistake with the series, as the cover letter nonetheless. Sorry about
that. Let me know if I should resend.

> ---
>  arch/x86/kvm/svm/svm.c | 9 ++++++++-
>  arch/x86/kvm/svm/svm.h | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 10c21e4c5406f..9d29b2e7e855d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -705,7 +705,11 @@ void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
>  
>  static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
> -	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
> +
> +	if (intercept == svm->lbr_msrs_intercepted)
> +		return;
>  
>  	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
>  	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
> @@ -714,6 +718,8 @@ static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
>  
>  	if (sev_es_guest(vcpu->kvm))
>  		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
> +
> +	svm->lbr_msrs_intercepted = intercept;
>  }
>  
>  void svm_vcpu_free_msrpm(void *msrpm)
> @@ -1221,6 +1227,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	}
>  
>  	svm->x2avic_msrs_intercepted = true;
> +	svm->lbr_msrs_intercepted = true;
>  
>  	svm->vmcb01.ptr = page_address(vmcb01_page);
>  	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c856d8e0f95e7..dd78e64023450 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -336,6 +336,7 @@ struct vcpu_svm {
>  	bool guest_state_loaded;
>  
>  	bool x2avic_msrs_intercepted;
> +	bool lbr_msrs_intercepted;
>  
>  	/* Guest GIF value, used when vGIF is not enabled */
>  	bool guest_gif;
> 
> base-commit: 8a4821412cf2c1429fffa07c012dd150f2edf78c
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

