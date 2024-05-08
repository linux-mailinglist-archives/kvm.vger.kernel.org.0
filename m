Return-Path: <kvm+bounces-17017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F388BFFC0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 16:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED8521F2249B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A7A85297;
	Wed,  8 May 2024 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tFyi6Qvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74F26291
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177391; cv=none; b=bwYVBvGCDThLoR+kChmxXssIUN/1uNaie4oVe8UjCxgH4/nPEmh9cp6YUYjzb1SVpyP42k7go1v7VoL0X1jCO+MBeFoDT2Yb6iEXkPf9/P/v6n0y7gdUqerDmjm0NUKWImwY9OF6wf7dT4TfTxxLBfJduTE59/HephWdbLLWyJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177391; c=relaxed/simple;
	bh=muTBhNKKyfLxTEheuwIpv/vLCE51rLmD3T6Hx58fn3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDnSwOyAsfivB0k8HRZlyJ1T9rlZA6OtoLt6/KveO5x1j5pV3ujsoL44PzPEf1h/K3KGQZCqc1UhXzH4JUP759lTHQljkCLM++Jd+AXAnj4CdUkxxHoN0e1PfcpxSPV1DUEeA22tPBtkpucpbxbs2o8vsdgZ6iPWiG/wq36MUhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tFyi6Qvw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f4755be972so2476362b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 07:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715177390; x=1715782190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tfYRBLNRHkcg/E20qzGwgcZT/WOB/w2rN51VWZ00zK0=;
        b=tFyi6Qvw/TZdeIo1JMZ0FzaDBJmnQUI+8PezOAXrssy0LbjLbBA/W1AfzZjfzRBm7P
         +hAk4oYrdl6hBz1qnwvtLhaiWj1aGqRQ/5RCI46t30ESgz/v0zNEtk8I+X4nqTILiY9v
         mdG1Bw2E021l0dukwHoV1I7i1j0z37W47NzaetBOaFZbXntu18MLwYjO+zFJ4mFvsnlw
         tVnWRKPuyNmwvwSetrxx+9hpoOGAX4C8bmGp4cfb1igaRuBlUVIiWmpZ/FLn7Y27W/Gc
         87pfqRwuqSVuKQkir/hYs+YzQLdmmIEvt25v2sntR3hBv8B9eyJWZfmdwJTLVj8pb4VF
         qKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715177390; x=1715782190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tfYRBLNRHkcg/E20qzGwgcZT/WOB/w2rN51VWZ00zK0=;
        b=eHfKt+bR2dNq9xIjDIe9rTLbA6XVdkWCF0i5zKl738s5+wnssB0sMKNJ3RaMgTgQiw
         IYMj6/gxXON21mAkYnbnklZaAOoJ1KvBAXSlLMAanrgWqDvoiO91BMxhxop9XPDUnE5s
         8HBosYs+cVzw8IMdpWqYarVQFnUi4/xA34zf+I6FGg6BpzcJ/PBOfKaXKsxaT2H4rGVk
         FA/CYH+Z3KUzZeEXlRzjfYza/K019NnZEy/FCKldP7Mxd0e9k16ZZbRWM+y/Q3EWQan7
         FVOeZMWHHgRXaNOpxaGySRYUjjnD2ENJs9tYRUYPy4zDNHAEY/8qekmxGmLrSJf44pcW
         1hPQ==
X-Gm-Message-State: AOJu0Yz+9CkQlZ6XAitQTEXXyUVEM25chzldF6gl8Kiu1ZbY3yktfLLS
	R9QcaWld5Qy5P2DkiVt8u6RuGy0cN3Sxcpiojxwh5qPisB7C2ONj5jgMYgXq2C5PWa3PedOnX8C
	8aQ==
X-Google-Smtp-Source: AGHT+IE2rUI5EkfgYoBnp8g96Y58xo4YXn7sORjIu0h8BzTG170CsrfIpe2Be3EiWLRkSErVbLNTtu3fDaA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a1a:b0:6f3:8468:432f with SMTP id
 d2e1a72fcca58-6f49c3047f1mr178093b3a.3.1715177389800; Wed, 08 May 2024
 07:09:49 -0700 (PDT)
Date: Wed, 8 May 2024 07:09:48 -0700
In-Reply-To: <20240508064205.15301-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240508064205.15301-1-tao1.su@linux.intel.com>
Message-ID: <ZjuHrGROhuBylm4x@google.com>
Subject: Re: [PATCH] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 08, 2024, Tao Su wrote:
> Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
> max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
> dirty_log_test...) add RAM regions close to max_gfn, so guest may access
> GPA beyond its mappable range and cause infinite loop.
> 
> Prioritize obtaining pa_bits from the GuestPhysBits field advertised by
> KVM, so max_gfn can be limited to the mappable range.
> 
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> ---
> This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
>  tools/testing/selftests/kvm/lib/x86_64/processor.c     | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 81ce37ec407d..ff99f66d81a0 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
>  #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
>  #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
>  #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
> +#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
>  #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
>  #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 74a4c736c9ae..6c69f1dfeed2 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1074,7 +1074,9 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
>  		*pa_bits = kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
>  		*va_bits = 32;
>  	} else {
> -		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
> +		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
> +		if (*pa_bits == 0)
> +			*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);

This is the wrong place to incorporaate the max mappable GPA.  The pa_bits field
should reflect the "real" MAXPHYADDR, it's vm->max_gfn that needs to be adjusted,
and x86 selftests already overrides vm_compute_max_gfn() specifically to deal with
goofy edge cases like this.

>  		*va_bits = kvm_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
>  	}
>  }
> 
> base-commit: dccb07f2914cdab2ac3a5b6c98406f765acab803
> -- 
> 2.34.1
> 

