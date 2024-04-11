Return-Path: <kvm+bounces-14346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B4C8A211B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8B5F285546
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60AF3B182;
	Thu, 11 Apr 2024 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fz0dM8Qr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B973BBC3
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872152; cv=none; b=rbuuWNkp4tGdIfLtzlpaiGo7hzjVUWZ1Vvl4t9QKBIUZezfpzPGBE4kzrDhGkyyLeNccPbOPy9ccC6lxja4Ry02znAh0WcPk+xfI/WEAH09krqSIiMfow97Zo3iJwjV3TJUvjQzWmkbq3onLuxsX6cA+JMfZSNNuA+WI41NLEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872152; c=relaxed/simple;
	bh=YNOXp9b/Jpb+es+bSQ62skx+KBDAECbNrG40A/IivHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oA0Pzb7lZA3kIge5ZgOeYgg2mn4hzGJJtx4csqtG23JE9SvhCAMVg7Ri4gTcGByYqOaoV6/5zUGo0bth3DtnP9ZoCs/u+m53fUM+MJQ5xUd58TH27vjVmiPzEQw53ULhUKR0EZnzf09xkTrWhJiZU/aLD7la95F5BVayxxeam4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fz0dM8Qr; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcdc3db67f0so1813112276.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872149; x=1713476949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E46uucbaaoqsuZZvyzOBFLngOEYFFwjcligp3RIvVUA=;
        b=fz0dM8QrZYckAcpi5DyJDPwgQSGXvY120TrbGeIwqVEckqJ8WjXLXe4KsufnIfIaZs
         hLrMZrrdPe7SYCoxmYtNiPvgd/kAKTNpdcRN1BPgCtKRvF1W6C7lfEShhzps2CV1zqRI
         bmyIZee7lQICCo7zgVvvTt/UnHXPxs7Hih6OaxNX4noSESUNyKH/m6QhfcbmTqv9PpHl
         MlnAv9zHx4CKbwdeW3fMjeSJrFG5saiFN9hyoWX+T2dQQ09i9eveNSvGkOCkyy+A3DH5
         BaipWAfEYEP55TyPEoD3sc86ptjgXRgCJIzylTHWMy5iFvryOVKU5BTQ9oC5IlUE8rKH
         L8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872149; x=1713476949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E46uucbaaoqsuZZvyzOBFLngOEYFFwjcligp3RIvVUA=;
        b=eSPRTRXqQrXte+ZPnuCAdlVJ2E5SyGslluD+Rua1TwDTp1sSUqNLLIw6e8LqjaVqfG
         1JKhGOJa0OsJW2UT7BXEEusiB2PW5XXHlx/vtyI/G4Yf3Moncq/Z/xs9RJhp+r5+YMDX
         bakg2SKUkLLS7WLofW/Y5RmwqwORi4nVCYTP+kESibe0G+mtTuc83r0sNqLp8Reflhhq
         o7+sNnZd18nt5DMAPNneWQ63soNpMH+mF/tySZmZDaXAtEgUvEUHJ5Jn51dAylMUS5b4
         EyzAn7/eY9xbmrhZeZRaQMi1IrFlR3YuutgJWSMDKmJN6F+2wQqO0yEKCBRPfw39Ttd1
         QpRg==
X-Forwarded-Encrypted: i=1; AJvYcCXHqrLLKsncrFVyaBk3b4Kupg3Yfi7bfgcO0D+O3oWK7cSTS20SJwDAR+ZITyrc8Ogu+mg/JtJ8xqHc9mRW7ECmqOrh
X-Gm-Message-State: AOJu0Yy7sJjS3/QRGRz/GCRNPBUkdSx2P3joDMypyes8Hdv7GPHyBwlQ
	pMhn90/08Xj+gxhtlnqvaojPezrkaPup3q2VSlZeO9pjXP3jaT/wLn/x5kNFRVsJlOk/UP7xRf+
	kCA==
X-Google-Smtp-Source: AGHT+IGck7OcujVjK4HXtTQv2Wbqqa7S9w3/FO991MY4XC3orGk6WQGzWdNyjeqNUn6MdpdyT3+lkMWbHpw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab70:0:b0:dc7:463a:46d2 with SMTP id
 u103-20020a25ab70000000b00dc7463a46d2mr626352ybi.0.1712872149661; Thu, 11 Apr
 2024 14:49:09 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:49:08 -0700
In-Reply-To: <20240126085444.324918-27-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-27-xiong.y.zhang@linux.intel.com>
Message-ID: <Zhha1N61JU1x3c64@google.com>
Subject: Re: [RFC PATCH 26/41] KVM: x86/pmu: Add host_perf_cap field in
 kvm_caps to record host PMU capability
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> Add host_perf_cap field in kvm_caps to record host PMU capability. This
> helps KVM recognize the PMU capability difference between host and guest.
> This awareness improves performance in PMU context switch. In particular,
> KVM will need to zero out all MSRs that guest PMU does not use but host PMU
> does use. Having the host PMU feature set cached in host_perf_cap in
> kvm_caps structure saves a rdmsrl() to IA32_PERF_CAPABILITY MSR on each PMU
> context switch. In addition, this is more convenient approach than open
> another API on the host perf subsystem side.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 +++++++++--------
>  arch/x86/kvm/x86.h     |  1 +
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 349954f90fe9..50100954cd92 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,32 +7896,33 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vmx_update_exception_bitmap(vcpu);
>  }
>  
> -static u64 vmx_get_perf_capabilities(void)
> +static void vmx_get_perf_capabilities(void)
>  {
>  	u64 perf_cap = PMU_CAP_FW_WRITES;
>  	struct x86_pmu_lbr lbr;
> -	u64 host_perf_cap = 0;
> +
> +	kvm_caps.host_perf_cap = 0;
>  
>  	if (!enable_pmu)
> -		return 0;
> +		return;
>  
>  	if (boot_cpu_has(X86_FEATURE_PDCM))
> -		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, kvm_caps.host_perf_cap);

I would strongly prefer KVM snapshot the host's MSR_IA32_PERF_CAPABILITIES, if
the CPU has PDMC, i.e. not leave it zero if the PMU is disabled.

>  
>  	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
>  	    !enable_passthrough_pmu) {
>  		x86_perf_get_lbr(&lbr);
>  		if (lbr.nr)
> -			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> +			perf_cap |= kvm_caps.host_perf_cap & PMU_CAP_LBR_FMT;
>  	}
>  
>  	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
> -		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> +		perf_cap |= kvm_caps.host_perf_cap & PERF_CAP_PEBS_MASK;
>  		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
>  			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
>  	}
>  
> -	return perf_cap;
> +	kvm_caps.supported_perf_cap = perf_cap;
>  }
>  
>  static __init void vmx_set_cpu_caps(void)
> @@ -7946,7 +7947,7 @@ static __init void vmx_set_cpu_caps(void)
>  
>  	if (!enable_pmu)
>  		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
> -	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
> +	vmx_get_perf_capabilities();
>  
>  	if (!enable_sgx) {
>  		kvm_cpu_cap_clear(X86_FEATURE_SGX);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 38b73e98eae9..a29eb0469d7e 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -28,6 +28,7 @@ struct kvm_caps {
>  	u64 supported_mce_cap;
>  	u64 supported_xcr0;
>  	u64 supported_xss;
> +	u64 host_perf_cap;
>  	u64 supported_perf_cap;

This is confusing, host_perf_cap doesn't track "capabilities" so much as it tracks
a raw host value.  Luckily, I have a series that I am going to post this week
that adds another struct for tracking host values, e.g. host_xss, host_efer, etc.

>  };
>  
> -- 
> 2.34.1
> 

