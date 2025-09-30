Return-Path: <kvm+bounces-59171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB667BADE85
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC383C7F9D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 15:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C05B306B1B;
	Tue, 30 Sep 2025 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lPp+1Idb"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8345232395
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246303; cv=none; b=hlruGVaVXNW/8yQMRQyRXqGY4oHSm51dIJ3e/YQaqmEZukXpRQ7N+JzOMVFMDeNtTTCKQ+5GtJHTVHXySdZF9Tcni6tUqfCj2RDU5Uxpoj0JHe732dilpAiGQ75f28gzKtNluRnDRJUHyu9MLPWhs651joBDa1u5GdkORUv/beM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246303; c=relaxed/simple;
	bh=v19bFNrzkt7riTcig8ndrDo4LbXmOSHlI9E/Ob6ri+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrU4Wr/PtgwyLiVtm+OkMGZVWujhhQVbMvdFpXnx2Dlc0A0l7F6Mu+MjHR6Tim5CYIz+YdEQlwWNy2LURMMTRiZo5DzQNmuZE5/47hTk9PZfHukBhh2+WuRHKU9sf1RE+xlC7DlK3DUQR95CFZb05rhtcRqdBTsJJqliXBu/OfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lPp+1Idb; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 30 Sep 2025 15:31:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759246297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NUHdbnPVBMmNzYNCNhOytndM02qHZYt1xCR9JMeoOu0=;
	b=lPp+1IdbC76EZsQVygeCoomm2L/xuTxhNVqqSQIGGJCrKJL+S2k2QkgZgdTq94N7NkgpQ5
	BplY+K6aTKM/+ExFFzTFZYw5sdlBuywQ72grIYtgF/D3Su/qc+vdSsUSii3jxF4h+Cx70d
	TcawZmHwpG8WxULcHKowPDsfiXpB3fo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Advertise EferLmsleUnsupported to userspace
Message-ID: <byqww7zx55qgtbauqmrqzyz4vwcwojhxguqskv4oezmish6vub@iwe62secbobm>
References: <20250925202937.2734175-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925202937.2734175-1-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 25, 2025 at 01:29:18PM -0700, Jim Mattson wrote:
> CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> it cannot support a 0-setting of this bit.
> 
> Set the bit in KVM_GET_SUPPORTED_CPUID to advertise the unavailability
> of EFER.LMSLE to userspace.

It seems like KVM allows setting EFER.LMSLE when nested SVM is enabled:
https://elixir.bootlin.com/linux/v6.17/source/arch/x86/kvm/svm/svm.c#L5354

It goes back to commit eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be
set with nested svm"), the commit log says it was needed for the SLES11
version of Xen 4.0 to boot with nested SVM. Maybe that's no longer the
case.

Should KVM advertise EferLmsleUnsupported if it allows setting
EFER.LMSLE in some cases?

> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 751ca35386b0..f9b593721917 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -338,6 +338,7 @@
>  #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
>  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>  #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
> +#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
>  #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>  #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
>  #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e2836a255b16..e0426e057774 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
>  		F(AMD_STIBP),
>  		F(AMD_STIBP_ALWAYS_ON),
>  		F(AMD_IBRS_SAME_MODE),
> +		EMULATED_F(EFER_LMSLE_MBZ),
>  		F(AMD_PSFD),
>  		F(AMD_IBPB_RET),
>  	);
> -- 
> 2.51.0.570.gb178f27e6d-goog
> 

