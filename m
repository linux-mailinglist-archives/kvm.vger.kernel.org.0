Return-Path: <kvm+bounces-24052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04196950BAD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29A151C228D9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E071A38D4;
	Tue, 13 Aug 2024 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCgcMZOW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C091A2C3A
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723571444; cv=none; b=MxXHW7YOUKPCvk/EpNfTFc/SG5tXEyQMvoO9usM4ij9kmScCBfc6bbeGPjFAAq5xbafFyB14MR06lUP7EyivQo5unPx1yn0gRQnVQv+7elu68+KL/eV7GWAxJLeuDxYvRkmC23UwkjRmyVgNO4na6VRmElxB6l3feeP/KHxvojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723571444; c=relaxed/simple;
	bh=FstfrUToh1EXfJSAiePToOTUvVOqDVYBssuR0AmtO98=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Du/D/zj0ZXTOSwRexD//9ccVat0XuMqWo1wwxBZx8u6lOtYKCOgYTlBTYsJ+0hc2l1IQuHr0yQi37HfMNDldJBCyuigN4OX7X6wVeKJhyEGyGJ/9D8rlGLZw7PZD/0yfC/ihBIJ/5/2N+TReogLX3DsPij/tAhvpMv79+qYp9uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCgcMZOW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb68c23a00so69692a91.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723571443; x=1724176243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dN2AMVI/niFAXBXumTdMHyNBUN/yv7txGaV0Nn3/UZg=;
        b=UCgcMZOWSf6RiBOyCeOWD0S0VOPcF4dNB1QIi2LzfmNdc0MoS4T5hUGQe66N3PJusv
         hwMqcn7uleWIRW0YCw9qkesTned05fptFJj9xieRbYcSqisbZGpNrn2Ddd+uSluTSRR5
         mLsNcM3UxVFcazGkvi5K7TkSXJIXBK65tKnawV+EdGJY8vt+vjJjqulxxTFnLOOklraP
         Yml8qHx7OYhQK2OxglU5inVvOCvR/PdFpINZpHWbbAnkikgvidYn3leb0cmKlUNMli1U
         sg0eC4hZBR5hdmC40LodImM4CQ1fyMvx0umjVk+L72ykuftkquowl2zUArbRqiotU20P
         BhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723571443; x=1724176243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dN2AMVI/niFAXBXumTdMHyNBUN/yv7txGaV0Nn3/UZg=;
        b=OyF0WXG3GUgcTNURg8zZilph+Vh+XS1PXENZVyJD44rdwsrulrJTnF5+ZCN9Hj9KD8
         nFqUyK3kNGoAvnCtM4ty+vknU1ItZj2TNTzVRAaEk0Lh+UmQxDq3kH2AK2e7x/uhS4wP
         Wx4aL5NPW0QQb0m/q+HtTQ1b6MmL5whjaKMLHr/svw25uC7/v7nw5g5uL0b6RznJf0iW
         4qW5JpijHpQOTvF/NxTH574Wz4aJ2eDTfOkhbNWEIJRAHg1MLZvA5OPRotMqcX2OFBKv
         zQ8HFHNngW8+I3jfKR8uQd1PEpDbaqS2gUVrCFq+kT0WF7eYJslSIef37TVt6FlVL2Lt
         Rk4w==
X-Gm-Message-State: AOJu0YxAURnybMi9wWWQfATOa1vDgcquNBy9f3i+V+tLPKnbmS9wquXR
	vVVn4uKdJow9uOEmdJjjcavEQhNqO101o8jU04ErEtY6ZvpvwEr5UOYfCrkU6oRN50bmGtTqp/3
	XjQ==
X-Google-Smtp-Source: AGHT+IH7Zxucylz6R95aLD54zFrs2SBkGeRrDQqkhFde13ApbPQ4ZM/p/JbtmnqpgndbwN/eAgc+8ZtkApw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4ec8:b0:2ca:7f5a:db6c with SMTP id
 98e67ed59e1d1-2d3942d60b8mr56913a91.3.1723571442217; Tue, 13 Aug 2024
 10:50:42 -0700 (PDT)
Date: Tue, 13 Aug 2024 10:50:40 -0700
In-Reply-To: <20240522001817.619072-3-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-3-dwmw2@infradead.org>
Message-ID: <Zruc8CohpYUa1Im8@google.com>
Subject: Re: [RFC PATCH v3 02/21] KVM: x86: Improve accuracy of KVM clock when
 TSC scaling is in force
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The kvm_guest_time_update() function scales the host TSC frequency to
> the guest's using kvm_scale_tsc() and the v->arch.l1_tsc_scaling_ratio
> scaling ratio previously calculated for that vCPU. Then calcuates the
> scaling factors for the KVM clock itself based on that guest TSC
> frequency.
> 
> However, it uses kHz as the unit when scaling, and then multiplies by
> 1000 only at the end.
> 
> With a host TSC frequency of 3000MHz and a guest set to 2500MHz, the
> result of kvm_scale_tsc() will actually come out at 2,499,999kHz. So
> the KVM clock advertised to the guest is based on a frequency of
> 2,499,999,000 Hz.
> 
> By using Hz as the unit from the beginning, the KVM clock would be based
> on a more accurate frequency of 2,499,999,999 Hz in this example.
> 
> Fixes: 78db6a503796 ("KVM: x86: rewrite handling of scaled TSC for kvmclock")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/x86.c              | 17 +++++++++--------
>  arch/x86/kvm/xen.c              |  2 +-
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 01c69840647e..8440c4081727 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -887,7 +887,7 @@ struct kvm_vcpu_arch {
>  
>  	gpa_t time;
>  	struct pvclock_vcpu_time_info hv_clock;
> -	unsigned int hw_tsc_khz;
> +	unsigned int hw_tsc_hz;

Isn't there an overflow issue here?  The local variable is a 64-bit value, but
kvm_vcpu_arch.hw_tsc_hz is a 32-bit value.  And unless I'm having an even worse
review week than I thought, a guest TSC frequency > 4Ghz will get truncated.

>  	struct gfn_to_pfn_cache pv_time;
>  	/* set guest stopped flag in pvclock flags field */
>  	bool pvclock_set_guest_stopped_request;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2d2619d3eee4..23281c508c27 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3215,7 +3215,8 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>  
>  static int kvm_guest_time_update(struct kvm_vcpu *v)
>  {
> -	unsigned long flags, tgt_tsc_khz;
> +	unsigned long flags;
> +	uint64_t tgt_tsc_hz;

s/uint64_t/u64 for kernel code.  There are more than a few uses of uint64_t in
KVM, but u64 is far and away the dominant flavor.

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 5a83a8154b79..014048c22652 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -2273,7 +2273,7 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
>  
>  	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
>  	if (entry)
> -		entry->eax = vcpu->arch.hw_tsc_khz;
> +		entry->eax = vcpu->arch.hw_tsc_hz / 1000;

And if hw_tsc_hz is a u64, this will need to use div_u64() to play nice with
32-bit kernels.

