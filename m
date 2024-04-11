Return-Path: <kvm+bounces-14343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4FF8A20FF
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88321286C01
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD8C39FFD;
	Thu, 11 Apr 2024 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ynSWdYrh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FF3383AA
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712871369; cv=none; b=bVxIedopvS+KXzRHBjUByTONILbu+5BUHkKQHgCM2QR2wDp8M94JK0PuO5MgeYBxypmALJDZGQ2fXs9u9RpD6RMt/hvJbWY435uS+s3uSS7j22ziGNPgkq8oEYbR/rSkpG9/bAJQP99Y1cOhjZVO5uZts805RqP48M/vjSEfHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712871369; c=relaxed/simple;
	bh=i20kViclVoU910FhgD4850gArucbSEi6mTUIiZzLMgE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kd0z453v/mSgqZnBMXQ3AL7DpEBU/3YquBVv2W5ijpewb4C/kAkHnxTUADip+C+oB01Z14Xqr08KNWxw0SOfe+gOU0TjvNhBSZnqv5NkdM8lt/2pBlJXxB58ya+yxjWNgq4mkgL7+auhsETsh9eVCkVrC32jLo4a2/tItIb0I6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ynSWdYrh; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6187588d2a7so4968607b3.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712871367; x=1713476167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2t/yhHavryfHLTVYj1u8BqInFBj/5xKyOtI6EEMp6kY=;
        b=ynSWdYrh7C6tSJa/muuA7UmUKl1SrAO4dl9VTraIazRA0fAU4boYpYKqWvMkcf2qM1
         20c/NHUmL0YkeyUx2PcwKKQ8QqX/m8MlicYrjAwDQ79ZKxFjoPdM7t0TgJKDEwIdmYcL
         OjeG+75zPFRpqlxnkh+rhM/3p+Y0jr0wlzn+s1pnrkv7Evzf+JN9sWKFcw0xnOCId6MO
         U99m4uy6t9K4xFKn/EtgeMpnSIcYYUf8jn8rUO1DzFVRFpmfezK+ri3aTFq7TYrNdP3T
         agHvYTjZcdj9a4z/io6ELqVhGdlMhZGphWy4vRolOru/uL6HHkkWFdhBJZXWJSDJoHy3
         z+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712871367; x=1713476167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2t/yhHavryfHLTVYj1u8BqInFBj/5xKyOtI6EEMp6kY=;
        b=tuNq34ZClS3G85atgKitiqPgEDiqc4dD9duKFZIkBujd86xbFwv16Apgt17BEAck2s
         qibCKgOycXvxAELTfdAfpQV9Y3m9xsJKMW8tkoSG5o9My2NptFnBWrXO/OltKQfuLKR4
         KC1sWCsUlG/Vc6RVsZxGUKY2cdr9Zs9HPyBiACYcHz35hq0bzzAzWrenV7TtIumf2cN1
         FI6uQHAZUpNAPdHFdiSuhypcOY+eepUtCemQ6VYx2ZGNCkQI4pAmvsMSKOZ7SPsIC6wH
         B9AP4b6lqJ38Zxs3KCONt4uqXoVn+baOuoTReHDjTeExh6cFKe3w7J29mnr7Tg18oE1X
         NhPw==
X-Forwarded-Encrypted: i=1; AJvYcCWom6TzpAPMJyfME/7cC22TWA224hBLSTvafVCYjClRQeQS4SLwsPOsWafRJd8+ZKtOZuTUkgYkeZ+jrw9vrnXh0+ZT
X-Gm-Message-State: AOJu0YzOVt8akFynTV3ZK7x1VVP1KcOjPP1+xbh6pWu7GrU33UNLDfj+
	59IbACqJqh3+5xbXT49/Rgm1HZAojSdLzgh+PnCxmxuRuJ5YskqVLxkhPLackjXye5bVPHOvlXs
	Irw==
X-Google-Smtp-Source: AGHT+IHOnBnVhBGz76zEM73ew/BnSB+dc6+KJZYmdSqjoxgILellc26j5dgSKSbo3MKBLVz44DL/AVjXFss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca56:0:b0:615:80c8:94f3 with SMTP id
 m83-20020a0dca56000000b0061580c894f3mr161673ywd.6.1712871367327; Thu, 11 Apr
 2024 14:36:07 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:36:05 -0700
In-Reply-To: <20240126085444.324918-25-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-25-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhXxV3Z1UHLp1M1@google.com>
Subject: Re: [RFC PATCH 24/41] KVM: x86/pmu: Zero out unexposed
 Counters/Selectors to avoid information leakage
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
> Zero out unexposed counters/selectors because even though KVM intercepts
> all accesses to unexposed PMU MSRs, it does pass through RDPMC instruction
> which allows guest to read all GP counters and fixed counters. So, zero out
> unexposed counter values which might contain critical information for the
> host.

This belongs in the previous patch, it's effectively a bug fix.  I appreciate
the push for finer granularity, but introducing a blatant bug and then immediately
fixing it goes too far.

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index f79bebe7093d..4b4da7f17895 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -895,11 +895,27 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
>  	}
>  
> +	/*
> +	 * Zero out unexposed GP counters/selectors to avoid information leakage
> +	 * since passthrough PMU does not intercept RDPMC.

Zeroing the selectors is unnecessary.  KVM still intercepts MSR_CORE_PERF_GLOBAL_CTRL,
so just ensure the PMCs that aren't exposed the guest are globally enabled.

> +	 */
> +	for (i = pmu->nr_arch_gp_counters; i < kvm_pmu_cap.num_counters_gp; i++) {
> +		wrmsrl(MSR_IA32_PMC0 + i, 0);
> +		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> +	}
> +
>  	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>  		pmc = &pmu->fixed_counters[i];
>  		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
>  	}
> +
> +	/*
> +	 * Zero out unexposed fixed counters to avoid information leakage
> +	 * since passthrough PMU does not intercept RDPMC.

I would call out that RDPMC interception is all or nothing, i.e. KVM can't
selectively intercept _some_ PMCs, and the MSR bitmaps don't apply to RDPMC.

> +	 */
> +	for (i = pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_counters_fixed; i++)
> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>  }
>  
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
> -- 
> 2.34.1
> 

