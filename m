Return-Path: <kvm+bounces-59317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD390BB104B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A2E61883673
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BD1274FDF;
	Wed,  1 Oct 2025 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QMm1BpLJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621946BF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759331932; cv=none; b=Yvg0vidHAYPXfyyjj+HyN/q6Gtjz88R5WEUlnUQGyJ4hP6oULaYvfga2jx10ENmPnmxZSf1xLRAXS7lG1maK1bgL/VTf8SYGYDkFUkdH/KlV2x6LQU+en3TuET/vgV1cPaj8JdsBhvR0qc3Ft02o/skK7LEFw5OcEoTFwBE5pA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759331932; c=relaxed/simple;
	bh=clYzD45QF0l/Yb962K6im/hAIBEWMJ+l2kSiwON7t0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBWPdnBG75QkhuJ8aPfEBUoY/zXrwMnnfaBids2GejhsBwCRvXfsCw9Izt0ZAziJD1rpFbrKrHAlhcnZiQAvXIXGOaO6uVw+Bjz10SKqjZFvwMrGHRsos3a6WoQf+PpHJllZ3qT6ax8tzsVCecNYOowzK2vskiD14x1DFJgxDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QMm1BpLJ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 Oct 2025 15:18:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759331928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+43gDRdm6H7SxJLLcC/uCvEpRJ3obEeymWu8l17Qn8=;
	b=QMm1BpLJLaBc+OxE44Y78T85IRKetxwt6i21WWNilNOUrZoHfyfuRKqY/YoWsdyRmW2GDW
	9i/Q8v3+HcZkuD3ihe1Lpm9Y7z0ZnwK+9pcYpKTXwXR+mnWqUFyOgYZexto+7N9tIKvqr7
	R856/ybadWpp37b8DjiPlTu+S9cgTe8=
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
Subject: Re: [PATCH v2 2/2] KVM: SVM: Disallow EFER.LMSLE when not supported
 by hardware
Message-ID: <dcyhv3zfpoolrj4z5i57vx6og5afreewwpm45yclqkvdpjab7u@ykgaqcr5kyxf>
References: <20251001001529.1119031-1-jmattson@google.com>
 <20251001001529.1119031-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001001529.1119031-3-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 30, 2025 at 05:14:08PM -0700, Jim Mattson wrote:
> Modern AMD CPUs do not support segment limit checks in 64-bit mode
> (i.e. EFER.LMSLE must be zero). Do not allow a guest to set EFER.LMSLE
> on a CPU that requires the bit to be zero.
> 
> For backwards compatibility, allow EFER.LMSLE to be set on CPUs that
> support segment limit checks in 64-bit mode, even though KVM's
> implementation of the feature is incomplete (e.g. KVM's emulator does
> not enforce segment limits in 64-bit mode).
> 
> Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1bfebe40854f..78d0fc85d0bd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5351,7 +5351,9 @@ static __init int svm_hardware_setup(void)
>  
>  	if (nested) {
>  		pr_info("Nested Virtualization enabled\n");
> -		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> +		kvm_enable_efer_bits(EFER_SVME);
> +		if (!boot_cpu_has(X86_FEATURE_EFER_LMSLE_MBZ))
> +			kvm_enable_efer_bits(EFER_LMSLE);
>  
>  		r = nested_svm_init_msrpm_merge_offsets();
>  		if (r)
> -- 
> 2.51.0.618.g983fd99d29-goog
> 

