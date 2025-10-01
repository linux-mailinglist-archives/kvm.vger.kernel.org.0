Return-Path: <kvm+bounces-59316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAB4BB1040
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A896816450D
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654C0267AF1;
	Wed,  1 Oct 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qA6uzC43"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086946BF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759331879; cv=none; b=SuhnPme6/1f6IxvRO+ydLoTPxadjGmiTgvkJhpklv0s3vrcFG7bdijxrn2EywV2K+txS6aRhTHFUmwb90e61ELWI5gM+KeDZIIvdzPtUYSNIUP+z4u9l0X8yyCmZAFmv/uf4wIZEyhzRMMtdmMItMisJMLn60iny/IcEVw0LQM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759331879; c=relaxed/simple;
	bh=WagaDL/zHG2InUA/9zPSQnsq97bnuIdW38m1h8u2uR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y06sDZPLVsDEM1ORUr0oHScBd/QYdvVLlgWOhLUXGorCJUQuCzhZDgLkCCTLl3XTyRR4jYDf1OeM4/761N/oNHm60COcM/gVf4QILBRm87rhBEl+M6e2g+mXELmZptCX1DfJTluwRyRG8E3QUSjHBQnPjp6zraVLF3e2RQXBOTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qA6uzC43; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 Oct 2025 15:17:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759331875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=grDs8NN+Hgb36aBgVfNQWcTkt1jpbQM36Y+tpCZQSh4=;
	b=qA6uzC43E1IIlctQNcbmgvGtbYNPMyhXd8X9pkzdZ3lGs6BYuywHC88F+zRLD4MvPnECIH
	yZRxXONN2YpVGWVbTgmdhHqvu/xV/5wh4JgvPWq479iwmYGgHPgieR1AIw3M9icXgvyiLi
	iIFr4vN701DBytFmlFiVL6g/CYcOzJQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Perry Yuan <perry.yuan@amd.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: x86: Advertise EferLmsleUnsupported to
 userspace
Message-ID: <iopba3gpwkynnrupnz3ldy7cjnpcs22kfi2yzazhmh6p2z4brd@e4xq3rp5hz3a>
References: <20251001001529.1119031-1-jmattson@google.com>
 <20251001001529.1119031-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001001529.1119031-2-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 30, 2025 at 05:14:07PM -0700, Jim Mattson wrote:
> CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> it cannot support a 0-setting of this bit.
> 
> Pass through the bit in KVM_GET_SUPPORTED_CPUID to advertise the
> unavailability of EFER.LMSLE to userspace.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  v1 -> v2:
>    Pass through the bit from hardware, rather than forcing it to be set.
> 
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
> index e2836a255b16..4823970611fd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
>  		F(AMD_STIBP),
>  		F(AMD_STIBP_ALWAYS_ON),
>  		F(AMD_IBRS_SAME_MODE),
> +		F(EFER_LMSLE_MBZ),
>  		F(AMD_PSFD),
>  		F(AMD_IBPB_RET),
>  	);
> -- 
> 2.51.0.618.g983fd99d29-goog
> 

