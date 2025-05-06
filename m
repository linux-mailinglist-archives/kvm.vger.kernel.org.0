Return-Path: <kvm+bounces-45584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D17AAC054
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 614E31898F5F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472AD269830;
	Tue,  6 May 2025 09:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcPuPxt9"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE381E1DE2
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524951; cv=none; b=CWVCPIMiDT1PYTh6B0+jwMnQf9Fgc05dmPTfm17HktW2j7sqBZI+87sbLuOUqL5vNENKnJ1w944fbW9NUsdvOlX/Wf8o/FcfbuzZ2e/Z+tfqjDL/V8Yo2xknC6EescIUlrBE1Z3zPV4GwYgN+0QLIml/fV3a/QLKRpiywCjknG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524951; c=relaxed/simple;
	bh=wscBd0+K73Iu2KF17/+m0xbBKq1LwXoTntpULm27Yc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u557ei80NT/vNdbf4Qns9BCrAm0Ls74mmXbmYrgUtff9Zcl6dC9c8GTXFw4ay5JTg/Ihycge9wu+3l3HipGPcxxHIF08qUZYq+iktotybNkpaJX0yo8mpj77/6pj7Wyxl9kXk6GfLUB2ap29gFQuMzoIgDF451xvsASzf2iQVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcPuPxt9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 May 2025 09:48:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746524937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SGyzWRmJQQwN3Wi10eV4TGMzAWHWRlBB87uJefqwcVU=;
	b=bcPuPxt9FAJuszqfy37ye6a4kxx+HpJaH0+wEJHo1W8Yf6vWg8Fk6YRlAgAhtiTJxGF7gG
	M24jKSK0Xoyn3/QqOViDGVoz268x+O75YmWYcJvZTowai++uYcJ5ZqW1ppfQIQzY6hNToX
	ztJoaMSNkxCmU0yBn1wh4Nn5flC7qQ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Larabel <Michael@michaellarabel.com>,
	Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
Message-ID: <aBnbBL8Db0rHXxFX@google.com>
References: <20250505180300.973137-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505180300.973137-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 05, 2025 at 11:03:00AM -0700, Sean Christopherson wrote:
> Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
> only if KVM has at least one active VM.  Leaving the bit set at all times
> unfortunately degrades performance by a wee bit more than expected.
> 
> Use a dedicated spinlock and counter instead of hooking virtualization
> enablement, as changing the behavior of kvm.enable_virt_at_load based on
> SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
> result in performance issues for flows that are sensitive to VM creation
> latency.
> 
> Defer setting BP_SPEC_REDUCE until VMRUN is imminent to avoid impacting
> performance on CPUs that aren't running VMs, e.g. if a setup is using
> housekeeping CPUs.  Setting BP_SPEC_REDUCE in task context, i.e. without
> blasting IPIs to all CPUs, also helps avoid serializing 1<=>N transitions
> without incurring a gross amount of complexity (see the Link for details
> on how ugly coordinating via IPIs gets).
> 
> Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
> Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
> Reported-by: Michael Larabel <Michael@michaellarabel.com>
> Closes: https://www.phoronix.com/review/linux-615-amd-regression
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2: Defer setting BP_SPEC_REDUCE until VMRUN is imminent, which in turn
>     allows for eliding the lock on 0<=>1 transitions as there is no race
>     with CPUs doing VMRUN before receiving the IPI to set the bit, and
>     having multiple tasks take the lock during svm_srso_vm_init() is a-ok.
> 
> v1: https://lore.kernel.org/all/20250502223456.887618-1-seanjc@google.com
> 
>  arch/x86/kvm/svm/svm.c | 71 ++++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/svm/svm.h |  2 ++
>  2 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc1c721ba067..15f7a0703c16 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
>  	kvm_cpu_svm_disable();
>  
>  	amd_pmu_disable_virt();
> -
> -	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
>  }
>  
>  static int svm_enable_virtualization_cpu(void)
> @@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
>  		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
>  	}
>  
> -	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> -
>  	return 0;
>  }
>  
> @@ -1518,6 +1512,63 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
>  	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
>  }
>  
> +#ifdef CONFIG_CPU_MITIGATIONS
> +static DEFINE_SPINLOCK(srso_lock);
> +static atomic_t srso_nr_vms;
> +
> +static void svm_srso_clear_bp_spec_reduce(void *ign)
> +{
> +	struct svm_cpu_data *sd = this_cpu_ptr(&svm_data);
> +
> +	if (!sd->bp_spec_reduce_set)
> +		return;
> +
> +	msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> +	sd->bp_spec_reduce_set = false;
> +}
> +
> +static void svm_srso_vm_destroy(void)
> +{
> +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +		return;
> +
> +	if (atomic_dec_return(&srso_nr_vms))
> +		return;
> +
> +	guard(spinlock)(&srso_lock);
> +
> +	/*
> +	 * Verify a new VM didn't come along, acquire the lock, and increment
> +	 * the count before this task acquired the lock.
> +	 */
> +	if (atomic_read(&srso_nr_vms))
> +		return;
> +
> +	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);

Just a passing-by comment. I get worried about sending IPIs while
holding a spinlock because if someone ever tries to hold that spinlock
with IRQs disabled, it may cause a deadlock.

This is not the case for this lock, but it's not obvious (at least to
me) that holding it in a different code path that doesn't send IPIs with
IRQs disabled could cause a problem.

You could add a comment, convert it to a mutex to make this scenario
impossible, or dismiss my comment as being too paranoid/ridiculous :)

