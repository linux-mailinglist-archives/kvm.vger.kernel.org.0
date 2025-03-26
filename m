Return-Path: <kvm+bounces-42075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEDFA7201C
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 21:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A95F516AA21
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9766825E476;
	Wed, 26 Mar 2025 20:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuIH7naF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480E21EA7F3
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743021968; cv=none; b=NlIq73FQ/7IghtsFZO5+FRIV3LDMZFJ+obV2jQ+4nzARpObfLkjVrny/WvXTP2wXAIvrjtT1lLtRpa0HWa+KX3nPnaOqi3xHoy0bJjI0hulgKxSM45WKhLRl8nC3ZD0SsBQW8Nf4my6TIxWx8WI9OGo+dw+SRXeFkHErIYzzQKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743021968; c=relaxed/simple;
	bh=Y6AhyK49pxkzn1ksbUR43T1pZXDv+BVv5QZJqfe+jkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CsIxbinTWmC9y+hvgTlq+UONjbEQXb3ZSRGEi7+hN8xQ5mEKHNzmX9cKUmwAqC6PRj3WkzfGneZ1vj+M5Qj0U0jbjoKPazx963m2M3pSibEH8xKfxterXw8d/VRhyi43NkhuR5/pVh/13CI3hTno5upUO7QVynrUmQ/oS0zUh7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nuIH7naF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22647ff3cf5so4529975ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 13:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743021966; x=1743626766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o4TnW2Uz5dKZRhVJDSlrRtrZST0v5S6K4ANZzv9qPFY=;
        b=nuIH7naFl3andnO/WLEGB0RkwVV1XsSxdZhCZDP90ZTXCuBa3lSoNuhM6FeWE4A0FE
         Y3TOuPt8vB7HSJ2smQ/e8CEAtaz9zFQ6n7RIRiOoE6EV8cLWX432CG8XBitNDYRDdPHC
         OLNP9hdFH0EjQemyjhk4KyIhuOeG2usFuN76u1NSc3tEUwWBJrgsyI6TSa5zqLXOBSsJ
         6kT2qaHhHIZK6OTIMLDZNnVVsVUfpqS4JzRtIfzYIrrpLJkTmmOQuv2eNHzeABwn4JO0
         YSXV7+UOkLIDUpAoWltMYZvAjZU5GxemKKnw8hWCzE5uSZJJ4NMTH3eW0Ko5yXCzen56
         oVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743021966; x=1743626766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4TnW2Uz5dKZRhVJDSlrRtrZST0v5S6K4ANZzv9qPFY=;
        b=WDMaOS82E5kngcxS7X/maMCxBzVi5Bmi6a0ZWjlyZe+fVKmzWrEXXPOF2D90+aLrUD
         fkV7pd1S5t1T0SEEoZbUtd9O0RZHT9BXWpci2tsvJgmDT7SEoHRGtkJ5h6k5g9T4vOXc
         rCBwvmiQ+8fwAH0b0dheaZfBCTzOyBP4+GdFXajvnVaUQ3ONdsAmj1ezHRG8vNCVGbGg
         tstINv8Mrk4WpMyp3ggFh+T/EhEEsJS3QJiGEoP5+pE/mn30ERYPJQL3NeoTSpkd6Esf
         eP6079hc4lagWwYsT+lnG0I81qUqGynTEDCk6ACfMm/7tyZpmrgdvGe1trW6Z+1Aw7Ih
         xwmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXezS6CHijIscHvL7ZkuHaFA5yuFPadO3GkMsvul4BUJwsrGd0Pm+M/AEqbq3Oi2MhONWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbA9e4SlLF4ZztqGTxKWpvr/ZAQwyOq36uwx5lTgmSgWCENWx6
	bOQbH+olxK5mp3o7r5H6jYi2cQDMeUCrjl259fXqQywwKfuDmdf6JG77a0VANBogVofGNt2N1fg
	Keg==
X-Google-Smtp-Source: AGHT+IG8fkyy0WUh4763nYORNLKBqfCAbmVWPy9jfWL/7DeLL3/hOCRU5DW9gPneZ9vs+KSuQSR91LQmU04=
X-Received: from pfbdf2.prod.google.com ([2002:a05:6a00:4702:b0:736:adf0:d154])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:198f:b0:739:4a30:b900
 with SMTP id d2e1a72fcca58-73960e3239dmr1232609b3a.7.1743021966483; Wed, 26
 Mar 2025 13:46:06 -0700 (PDT)
Date: Wed, 26 Mar 2025 13:46:04 -0700
In-Reply-To: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
Message-ID: <Z-RnjKsXPwNWKsKU@google.com>
Subject: Re: [PATCH] KVM: x86: Unify cross-vCPU IBPB
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 20, 2025, Yosry Ahmed wrote:
>  arch/x86/kvm/svm/svm.c    | 24 ------------------------
>  arch/x86/kvm/svm/svm.h    |  2 --
>  arch/x86/kvm/vmx/nested.c |  6 +++---
>  arch/x86/kvm/vmx/vmx.c    | 15 ++-------------
>  arch/x86/kvm/vmx/vmx.h    |  3 +--
>  arch/x86/kvm/x86.c        | 19 ++++++++++++++++++-
>  6 files changed, 24 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329d..89bda9494183e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1484,25 +1484,10 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	return err;
>  }
>  
> -static void svm_clear_current_vmcb(struct vmcb *vmcb)
> -{
> -	int i;
> -
> -	for_each_online_cpu(i)
> -		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);

Ha!  I was going to say that processing only online CPUs is likely wrong, but
you made that change on the fly.  I'll probably split that to a separate commit
since it's technically a bug fix.

A few other nits, but I'll take care of them when applying.

Overall, nice cleanup!

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69c20a68a3f01..4034190309a61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4961,6 +4961,8 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
>  	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
>  }
>  
> +static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -4983,6 +4985,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	kvm_x86_call(vcpu_load)(vcpu, cpu);
>  
> +	if (vcpu != per_cpu(last_vcpu, cpu)) {

I have a slight preference for using this_cpu_read() (and write) so that it's more
obvious this is operating on the current CPU.

> +		/*
> +		 * Flush the branch predictor when switching vCPUs on the same physical
> +		 * CPU, as each vCPU should have its own branch prediction domain. No
> +		 * IBPB is needed when switching between L1 and L2 on the same vCPU
> +		 * unless IBRS is advertised to the vCPU. This is handled on the nested
> +		 * VM-Exit path.
> +		 */
> +		indirect_branch_prediction_barrier();
> +		per_cpu(last_vcpu, cpu) = vcpu;
> +	}
> +
>  	/* Save host pkru register if supported */
>  	vcpu->arch.host_pkru = read_pkru();
>  
> @@ -12367,10 +12381,13 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> -	int idx;
> +	int idx, cpu;
>  
>  	kvmclock_reset(vcpu);
>  
> +	for_each_possible_cpu(cpu)
> +		cmpxchg(per_cpu_ptr(&last_vcpu, cpu), vcpu, NULL);

It's definitely worth keeping a version of SVM's comment to explaining the cross-CPU
nullification.

> +
>  	kvm_x86_call(vcpu_free)(vcpu);
>  
>  	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
> -- 
> 2.49.0.395.g12beb8f557-goog
> 

