Return-Path: <kvm+bounces-59319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCA4BB10FD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0092F1894C85
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8852773C2;
	Wed,  1 Oct 2025 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Aaiu0gfT"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77D274B2B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332374; cv=none; b=thcQQCUPVznBeMQ+NoCGEmupZoYzqoGQy7Oup8BIPbd3XcRvYZT51J9vdWsAXDO2EHWq6XpW/fHR7wM3E3l+tudzlDfDdXzHglFdAhethVne9OMZYl1eG9lYL3Akke5a3uR7Fo3DV1wbjFGnTy9zhTlg0cFBQxmkTnFcUNF/5b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332374; c=relaxed/simple;
	bh=3NPgTdCTSiOwSfyaOccKmeH1hQcF01gH+1NVUof/2hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuku77MzBvYfGkucjusZoRoKquqaqKGl1/xJrw561YSp4SX9PBGxm1WDELSYodxhckmdiCeOP0e45sEtCeveMgae60OTgay+0GfZ9xQOF4+EQbnxmQCcRQfJHrVle2wrJdasrmFx6cHkBvVgJc6mSY6pqnm/VvSZywUqUoaVGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Aaiu0gfT; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 Oct 2025 15:25:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759332359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QBXvtvXzaamYu4esLWBy5y0OZPQ0U3Papg1nhMt8jew=;
	b=Aaiu0gfT9xu+QL3y6vH9H5yr+eql58RaGE7wlVgqBoy5qArLkrvEixCANlC6LpO0jKgSUA
	PcluVR9ZSYF1CemNNm3+6+RwmbmB1Lb4Vvp7dcYsLOEZ6kqqAplzpGQ7BRa14QftyF6Qon
	95sn2lAdSMHDaJPAqzOjInFQgPQM55g=
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
Message-ID: <auftrtth2z3df4qc5vfm2cxv5b2tnhcu4eron7fbebalh6laxd@wgw2tamdw5ho>
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

If anyone is as curious as I was, the bit seemingly started being set on
Milan. Rome (and supposedly older CPUs) support EFER.LMSLE.

> 
> For backwards compatibility, allow EFER.LMSLE to be set on CPUs that
> support segment limit checks in 64-bit mode, even though KVM's
> implementation of the feature is incomplete (e.g. KVM's emulator does
> not enforce segment limits in 64-bit mode).
> 
> Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
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

