Return-Path: <kvm+bounces-24086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5509511B2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6E4F1F24E44
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAB318040;
	Wed, 14 Aug 2024 01:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sV5pJ14D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B9F18046
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723600373; cv=none; b=hFSngy1btg1+8z3Ce3CG9gQpbd7ITjcFA9whPhHE9c4211lIldVQ4JFR+8E7kqSTx6t7YW9rHwJZ7bZrxqZx3fgWQmRNDCvJembjNl2wNDYCL7CrLJ3OPN+cT6k0zF6eBnEOfgtLklAWMr3AqIiEovbi1y6C+O+NzwQbFWdjAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723600373; c=relaxed/simple;
	bh=MBCa2yJn6tPfuatc5ue5hU/K2qFjzCAd7cqEpq1nl2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ms3kfecqUL4DSkui10oa0wR2Z0oxU2PtxITYsEyuJRfimGMG1h9kyOwF9fKvOYRKHVP+1cgcKleVZ/m3yViPpakpQ/oHoBUIIz7Qbj0MJNtgeT6Piu10GhhC6gEqJTFH0uyyKXrkop21ql6w5DHpVztGTDzPAPVt9PO0b/XrHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sV5pJ14D; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d14fc3317so5218172b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723600371; x=1724205171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4yGIdJv7M/k+bCqCZh00a/qc87zMvXpkoJKzkdnDM8=;
        b=sV5pJ14DgfCih+EMZx6iDTCb5mZP6rF/Y/30hbpEe/3liCXVfrH2Bt43KdoB62JlMd
         DKc2YHOU+EwUnulBOIJ9VresJh5txSr7lO9O3o04Nl6CU+mMWqZ+4vx7j02OZmJPZi6s
         xqklKKrR5O6NHKzNYXXC3XIin++uOdXoBGjOCqeRE9vplHe07OPND2MF2jDo33+hWBAs
         aNSYGOLNt8w2bT5CEewOS8SVK1/jZX9k3gcC5uXOC2nNUAi1rXLYwdSM4lL4HvxtEXNg
         pYWil48ih6iuCSnl7Z6zls384Y6o6ge56GdF0kWQdvSeYQWAlsMpAchynxHGq8xnu5qu
         3PzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723600371; x=1724205171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4yGIdJv7M/k+bCqCZh00a/qc87zMvXpkoJKzkdnDM8=;
        b=g4obO05OrgIInOxTe4hJD6bba0zfz/5M4aU8EOcRfDSd/l+JXQWlKzOGRPCDQv+oq0
         oRQ/+4yzXp1T6+qa4BtrXP7EpVgwlpeVpxE/3lfphf38xp5vO/1mvAxyrAAbYx3i5bi2
         UfuafbSlk+yvxhT/S3NyLP4cyp0Na3RMjGgZJLamcboiD0B5GW3PLEwXq/KrdAju9lGB
         T9/RIt4QaDV2UN2G9ov6bDcaqF2+kAyw18XSbxqdGzmE1s5JXvrH6GhwgPRMYa04PZaF
         YYVMHCrhpT85DMvuinSDlLsW3dPU/IVH0WHpMhSCcQQir7FVU/tk0WrS4epqZ0bm2P8C
         3AoA==
X-Gm-Message-State: AOJu0YxHuqEjXs783Wxqw1rfx5a/77cW59wywM09DriULWpkLnMknGfY
	ufzu82N0DfINZgCj1swQ71KiP0aSrOree3zQ2GAmZYi4+YVS6pY5PIkV2xjAaPucIl2U9BxEG23
	PgQ==
X-Google-Smtp-Source: AGHT+IFwKCIOV5o7L3PLXRmNBudEXbN7xq9tO/YnjNTtRMxUwLL8mbEGKsngAowwXWeHPhTmxOCOIjUexcA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2ce:b0:710:9d5d:f2ad with SMTP id
 d2e1a72fcca58-712670fd788mr4153b3a.2.1723600370238; Tue, 13 Aug 2024 18:52:50
 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:52:49 -0700
In-Reply-To: <20240522001817.619072-8-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-8-dwmw2@infradead.org>
Message-ID: <ZrwN8eGIaA4dzB5l@google.com>
Subject: Re: [RFC PATCH v3 07/21] KVM: x86: Add KVM_VCPU_TSC_SCALE and fix the
 documentation on TSC migration
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
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 72ad5ace118d..fe7c98907818 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -864,6 +864,12 @@ struct kvm_hyperv_eventfd {
>  /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> +#define   KVM_VCPU_TSC_SCALE  1 /* attribute for TSC scaling factor */
> +
> +struct kvm_vcpu_tsc_scale {
> +	__u64 tsc_ratio;
> +	__u64 tsc_frac_bits;
> +};
>  
>  /* x86-specific KVM_EXIT_HYPERCALL flags. */
>  #define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 42abce7b4fc9..00a7c1188dec 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5715,6 +5715,7 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
>  
>  	switch (attr->attr) {
>  	case KVM_VCPU_TSC_OFFSET:
> +	case KVM_VCPU_TSC_SCALE:
>  		r = 0;
>  		break;
>  	default:
> @@ -5737,6 +5738,17 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>  			break;
>  		r = 0;
>  		break;
> +	case KVM_VCPU_TSC_SCALE: {
> +		struct kvm_vcpu_tsc_scale scale;
> +
> +		scale.tsc_ratio = vcpu->arch.l1_tsc_scaling_ratio;

I'm pretty sure vcpu->arch.l1_tsc_scaling_ratio is set to the correct value only
if the vCPU is using KVM's default frequency, or TSC scaling is supported in
hardware.

	/* TSC scaling supported? */
	if (!kvm_caps.has_tsc_control) {
		if (user_tsc_khz > tsc_khz) {
			vcpu->arch.tsc_catchup = 1;
			vcpu->arch.tsc_always_catchup = 1;
			return 0;
		} else {
			pr_warn_ratelimited("user requested TSC rate below hardware speed\n");
			return -1;
		}
	}

I assume the easiest solution is to enumerate support for KVM_VCPU_TSC_SCALE if
and only if kvm_caps.has_tsc_control is true.

> +		scale.tsc_frac_bits = kvm_caps.tsc_scaling_ratio_frac_bits;
> +		r = -EFAULT;
> +		if (copy_to_user(uaddr, &scale, sizeof(scale)))
> +			break;
> +		r = 0;
> +		break;
> +	}
>  	default:
>  		r = -ENXIO;
>  	}

