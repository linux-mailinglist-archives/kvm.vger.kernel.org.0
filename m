Return-Path: <kvm+bounces-14350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB9B8A212C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F38C1B227B1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B523C699;
	Thu, 11 Apr 2024 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YwKWh/M+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958873D393
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872563; cv=none; b=PXJ63xZvNAgtm6meeJXmDZakmXE5g4eGlKnWagRsicXZANb4R98JO4ApqrXfbN45WEQ2eaA0FB4KmxvVKtNuqBFRPJkxDS60D/BYwsNJwwTuY3CW0Kp0BF7zwpHdFJyMmbek0lYLkDAa7R0zKlbEfjlTjPEWs+ddneiZtmXC/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872563; c=relaxed/simple;
	bh=WhE2TsdaFBf//X6Mi0awY4JgS5Ez02ojQe+rYM89Pc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lNUubUHJ5b1vH6+k0763I5ZaIbbpNCn4vwGasua+of9eoff70tc6T6MSbatPhdmjKlL6qy68ZdWGjGhx0keKAATvm4E6ratYYSXZn6zSoeoW9gLYBu86FEFVCKpBIRbSDi7IxQZyE3Idcgt/hK5chXQA7yl/h26pAEPwHVGfAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YwKWh/M+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6183c4a6d18so3854087b3.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872560; x=1713477360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xvBGm3WAp5dT0fLVD6CrBnCmwmbz5ObPTPCGBrsW24I=;
        b=YwKWh/M+c9BEF5GW7MakBF9cybgGnUpIuYWjGheNg//iGe31o3pWZ96DMXkxTGUYw+
         BfBHedjIGKOat2D/2azJhT5YM7M3KqhjcCDg+4R3NGxXeJafvBnZ4oCZEvZy5sYK8xdu
         n9GqBZCJFrcUEbE6lmt0EGrud0nCzWSCpleuR246PpIUn8kJAnPNMHS85GfW+DnJTMIY
         nFDWPiJO0L3ARYJZaf0NEamA2XS2G319nSfu2ZWOpjBzOTbzmUZ/AnAUVrZAusit85e6
         V04NiU5o5W9Eyq4cg79D+EhgmwF843BFXZMh2uiV3g+94CVZkVT6xKqjXi1AZJs1lRlx
         FDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872560; x=1713477360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvBGm3WAp5dT0fLVD6CrBnCmwmbz5ObPTPCGBrsW24I=;
        b=E5/sZoEEfPkCuLFygksCAksjvrTCeD3kWiaieqGAFUQTjBkCLzKF74hLc2n4RDaUXe
         Jmoz3hLMHrEMo51fNoXwoN1DCyyAAkaa4hNgmoluDnAIE2CLnyGC2ypDMyOgizH3x+p5
         ExbMklZ6GS/E1Z6745Yn9lwF8Ym+i6iMT0PZOaQgDoiZhhEZ9VQgVzuvW/Im4EvnBLqQ
         lUD0D8FElauQnjaDOS6IEuIwYhxQRyCDwlaU98zZg4dIuXG23elCiOagEUsXKcifwS1F
         8d87ulFL7tIsEBXLAL8e28CeYWIFuaJYuivyZn/jLdvSkZZujeeuT1t7rdF3ZSVm5vNs
         V/eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPbK7ez7tFIJkOShD/gsLyrEHvSN047id7VepXYCfigtGFUXirwLFy8B6wtmmNdZ5vAClHU3wA7dAvmVuXkKokHIj8
X-Gm-Message-State: AOJu0YyNAB3x2RMAqm+ki+LvF57Mjj+1c5AmKBmL2ShmpOS8df1zeqSz
	eVq2V5f631rKaGP0L+ZSVmfAQcyGbwhJlwHU9fRUDDqg8elcNAvTEP2cCF7t77pwzreobuL4/qt
	yeQ==
X-Google-Smtp-Source: AGHT+IH9dyBjwYQ6qyY0Soi/iKEoDhgE0NmUsd3HLY8ONMNaCYYAfiPmG+fuJNw1ZCLcK+rYaU6AuAjCHHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c0c:b0:de1:d49:7ff6 with SMTP id
 fs12-20020a0569020c0c00b00de10d497ff6mr95831ybb.7.1712872560644; Thu, 11 Apr
 2024 14:56:00 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:55:59 -0700
In-Reply-To: <20240126085444.324918-35-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-35-xiong.y.zhang@linux.intel.com>
Message-ID: <Zhhcb9za_ShcESOh@google.com>
Subject: Re: [RFC PATCH 34/41] KVM: x86/pmu: Intercept EVENT_SELECT MSR
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
> 
> Event selectors for GP counters are still intercepted for the purpose of
> security, i.e., preventing guest from using unallowed events to steal
> information or take advantages of any CPU errata.

Heh, so then they shouldn't have been passed through in the first place.

> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 1 -
>  arch/x86/kvm/vmx/vmx.c       | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 9bbd5084a766..621922005184 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -809,7 +809,6 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>  	int i;
>  
>  	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_gp_counters; i++) {
> -		vmx_set_intercept_for_msr(vcpu, MSR_ARCH_PERFMON_EVENTSEL0 + i, MSR_TYPE_RW, false);
>  		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, false);
>  		if (fw_writes_is_enabled(vcpu))
>  			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d28afa87be70..1a518800d154 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -698,7 +698,6 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> -	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 7:
>  	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
>  	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
>  	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> -- 
> 2.34.1
> 

