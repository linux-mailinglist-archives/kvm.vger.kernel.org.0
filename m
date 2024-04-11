Return-Path: <kvm+bounces-14340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF208A20D5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCEF41C21E4B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AA83D39B;
	Thu, 11 Apr 2024 21:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XFm20QOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B983C464
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712870606; cv=none; b=lN6/raUrqDhF3TyF3vyEiWoyhiRyFI0mWs6gFdfaH7qnMOuGxPGIBYnvQNNuUphdhMcs938GRs2nJARv17QpR6WR0bB/AdSkBv6WE+6PEbnlvlof9zo8EZ0niUSaTvJvAZllhLQAfQBVUE/K72AMM49ZCXEcEElcEI2Ff+FnhZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712870606; c=relaxed/simple;
	bh=+D2gqeHElRX7BXeeD1K9fckk7QQ7DkL0FOAQt6ybymU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kw4wLme1o80DucaPfsKytjflTnRlm/glYGY7YVR+octB821u56pDBo+H03mR+ItfnMw+2lj8klZ9PmDOeIzRjtgRDL1LmPNaSxhU/5cEXQ4+GLL2fdEULq0uCK9G7bpY8TnyqqLNlX9CJdJtrlA29qrGI1Q5HEVb4WK8Tw5zdUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XFm20QOy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a5457a8543so200696a91.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712870604; x=1713475404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f4sYynhcMrBtwb48cfVkTJ5DoHsaKANS6hAxyOyilKo=;
        b=XFm20QOy/jSp8lW2aAR1UhriMz5YlZh9GILImy2itFB9NLKz0smphMXgcSAbjjFQvU
         PbLdAs11yFZDPu7PcKWKdxdiOrmcrgGO5n8QUeV6NQwa9V+Mf3XJEwtkbOVtLoGggRZ8
         mCy3sRiwR3LRSZivYti1JvcguV0K+eHjtXKFy03zMqaoG05cPWQTZ9CGQ2Fxejl5f9YX
         TTJE3o7AYJAylMX5FUYhBQOzqBLdv1gl+t1rsVhOiJACdL+Ddv2103TFagu8f86OtidM
         gXWlFwvDiU47gQgelhH8fxayK8/OWoqRTDzYXXG7ROvWHuGhod40Vd6OWhEWe7pvE/oM
         pbuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712870604; x=1713475404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f4sYynhcMrBtwb48cfVkTJ5DoHsaKANS6hAxyOyilKo=;
        b=cr3wpvmaqbhheCvyeeZeF7G4n0kx1SMLTr5AiZ33TvXqIiGYBlhlMT/fSo+mLw149f
         w9e6pR9ey0TkOWeY6Xc7F61JYlKuT6ha9oUmwzIyw84FU2Li43HlUCIXArl7ZrgsFYjz
         s51t5JV3pNIZO1UmAQBqksRmoPSL5nY+sgCGH1INyoI+SR7A1+9RMQU+2YZFWG6WXoxd
         U/JmOO+GnHWIUL6fykvvlwDMpZxtwCDNLCBxLsMO196AjNQYv0Up3BObGAXP/COuANFd
         Petp3XNjXVXftmjBP6ukrzvwfH5pwyOolOPgmS1L74LzCKB3E3dPCEQ12d+vcuQD49Qf
         SFog==
X-Forwarded-Encrypted: i=1; AJvYcCWkur51yJvo4fyaLLzDTtXQEaCN1VMORu7067pskEJk25aDexksnBYR2k35N47Vwz6eD6vLtyzkzw0eSnrc5LM7LtmG
X-Gm-Message-State: AOJu0YzhvFINLN8qfUy2q1sTqkaIIztPu6eaL+tneOZJwMhFSV59T3ao
	kL16+e2NkCCeg6TZbeTZd0/8cicieKgjDFzQ3GOolAqJ7xjsyfekP7yaEXx/VHGlGEqpm8OtMmy
	zvQ==
X-Google-Smtp-Source: AGHT+IGLnJWSe1pvT4fYPO2ARANLiP/Na43gje8HhGRqItkZXxuLiueYxnrbicDCpCBuUCuFLqQcY6Xcom8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e213:b0:2a5:c05e:6e3d with SMTP id
 a19-20020a17090ae21300b002a5c05e6e3dmr2191pjz.0.1712870603948; Thu, 11 Apr
 2024 14:23:23 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:23:22 -0700
In-Reply-To: <20240126085444.324918-19-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-19-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhUyk2uAXqG7GEd@google.com>
Subject: Re: [RFC PATCH 18/41] KVM: x86/pmu: Intercept full-width GP counter
 MSRs by checking with perf capabilities
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
> From: Mingwei Zhang <mizhang@google.com>
> 
> Intercept full-width GP counter MSRs in passthrough PMU if guest does not
> have the capability to write in full-width. In addition, opportunistically
> add a warning if non-full-width counter MSRs are also intercepted, in which
> case it is a clear mistake.
> 
> Co-developed-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7f6cabb2c378..49df154fbb5b 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -429,6 +429,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> +			if (is_passthrough_pmu_enabled(vcpu) &&
> +			    !(msr & MSR_PMC_FULL_WIDTH_BIT) &&
> +			    !msr_info->host_initiated) {
> +				pr_warn_once("passthrough PMU never intercepts non-full-width PMU counters\n");
> +				return 1;

This is broken, KVM must be prepared to handle WRMSR (and RDMSR and RDPMC) that
come in through the emulator.

