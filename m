Return-Path: <kvm+bounces-32218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F89A9D439D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 22:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA563B27BBD
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B287E1BE87B;
	Wed, 20 Nov 2024 21:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQ4LVKjL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650FF15B97E
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732138685; cv=none; b=nAuuT7GdnZddh0f9nI/uuCisQ5Kp1dGFXnFpjOJBZmOylivYuIe+YfzPpwzg+zKeeVRWvD9XhNa7lFQjfUewzsNa1hE2AUsIgAk6J3d7mNqUsLCSvglE4CZSE9zKi/+WW8ENbWoadS77K0gS2k8xl2enyqarkDQciPZjHTpBGwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732138685; c=relaxed/simple;
	bh=XlXZ4cnlFqDQru63uBgI0es1B56U7QsYTjA4nU2nuiw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gvHcr2gbM4Lel0nvmYYKvQvX/16RRMsuBiNHNbwbWCoKcEeXGX0pyb95WXErntjLd+63j1z6uL7iJ5HrRa23OGr5vg3IGfK8C5FEuIyDslZHmKvD+FNHNq1up/seqFAT4xjZW4iy4o1CGX/BNGOZQQ9fKGtzlvt3KWAPI4ghokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQ4LVKjL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea21082c99so244892a91.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732138684; x=1732743484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hK50UHxviNBEUn8xmLOk7IXRFdynit29NKgyO3ZB+Yg=;
        b=HQ4LVKjLQZc2RAiC+lJJCqKdb0YdRqA5WnQuNRSgyo0Km+yIkYeAT3B+7O9GjO4Nqz
         vPGrBtev2onC/Qxdc60IgaxVOxlyYyAO6jtLk9LEaW45BvJht/UWxdiXhnDBbNE2cPPx
         B6KaIGiUM2rn0EEXqcRLZfEbA5SS51DjVcZdMPOSr1Bq36ti0fcrMbzxw2s9E0D3huC5
         t1q9YpzVZLE2MSUXF++fqnPqMbPnrfxpBo7g5lVWGYGJt4tgxpzTIRU1ienYWhKuP/oa
         ILRyOA2eiMHqRI2Luh/zAC4IKaNVWAyq2qO0czZ77WJNuLAsImmPHXvL+UsRgYSalh3P
         ArwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732138684; x=1732743484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hK50UHxviNBEUn8xmLOk7IXRFdynit29NKgyO3ZB+Yg=;
        b=qxxKw2bBBUB+dqWji2IZxE7YM6dQ0WKxHHmpxykiK5UQ7tK0F0x+IGn9j0z6YFJ4cw
         opc0HjnfrmB/NNRImpROgcque0mzXTeKc+e36Du1MNC7gLBzERvf1VXXrUjbCgl5fg/K
         krMBzLXd0/QwJ48vSUlgH15hA/MKH2wRvWFy7sbXDofLAqWeW0zIf1cnf71wcLoe7aof
         1lDmyikXRWZ/rKOa7kA/P7CA9Y/wXbBBZc217+de9GZXFM1SWdHAYg8LtGXrLLJsaecR
         jIXTV2XCyZI2XBo/idz0rYkkPtQkVrqMoKjlXrw+dHMGOybyVvjCpn5Uxa/3eKd36mwt
         L0Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVhVkjELo8O0wpGlWKQYXrLoSLQ4WdsRoS0VN5IyFHYPS5lURfoh2QHS4A1Pbv6l0KF/6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSPLWxb8Clyvef6BEaj9yM+I4HTQWA+aTPvM2XOPmEefHZAHQ7
	lMllj1FwQVRGedHZ2Jqqe5kDcJXpcaWLuynDistsxQLPLWovLY8yhfaq9Ay2FbbN8WXALDI8BAK
	P8g==
X-Google-Smtp-Source: AGHT+IGkxYnG+hLXLUpjac2R9wZO6qBF93t2mWzts65zA8N1GmLd1ZGgyzq7ef0A6DNF+APY83cNlfgUfQY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3508:b0:2ea:4154:640d with SMTP id
 98e67ed59e1d1-2eaca0fdcc6mr2221a91.0.1732138683673; Wed, 20 Nov 2024 13:38:03
 -0800 (PST)
Date: Wed, 20 Nov 2024 13:38:02 -0800
In-Reply-To: <20240801045907.4010984-54-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-54-mizhang@google.com>
Message-ID: <Zz5WuqMBdDtZfJBq@google.com>
Subject: Re: [RFC PATCH v3 53/58] KVM: x86/pmu/svm: Set GuestOnly bit and
 clear HostOnly bit when guest write to event selectors
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> From: Sandipan Das <sandipan.das@amd.com>
> 
> On AMD platforms, there is no way to restore PerfCntrGlobalCtl at
> VM-Entry or clear it at VM-Exit. Since the register states will be
> restored before entering and saved after exiting guest context, the
> counters can keep ticking and even overflow leading to chaos while
> still in host context.
> 
> To avoid this, the PERF_CTLx MSRs (event selectors) are always
> intercepted. KVM will always set the GuestOnly bit and clear the
> HostOnly bit so that the counters run only in guest context even if
> their enable bits are set. Intercepting these MSRs is also necessary
> for guest event filtering.
> 
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index cc03c3e9941f..2b7cc7616162 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -165,7 +165,12 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		data &= ~pmu->reserved_bits;
>  		if (data != pmc->eventsel) {
>  			pmc->eventsel = data;
> -			kvm_pmu_request_counter_reprogram(pmc);
> +			if (is_passthrough_pmu_enabled(vcpu)) {
> +				data &= ~AMD64_EVENTSEL_HOSTONLY;
> +				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;

Do both in a single statment, i.e.

				pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
						   AMD64_EVENTSEL_GUESTONLY;

Though per my earlier comments, this likely needs to end up in reprogram_counter().

> +			} else {
> +				kvm_pmu_request_counter_reprogram(pmc);
> +			}
>  		}
>  		return 0;
>  	}
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

