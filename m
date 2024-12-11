Return-Path: <kvm+bounces-33493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FE79ED454
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EC1B16720F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8791DE2DF;
	Wed, 11 Dec 2024 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4rBHx31"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195531AAA3D
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940139; cv=none; b=MwB5UXHBrtKLfbP1b1rREWCXersvEYaL7WxPtwhFc2CWNgPi/Pa/QX+jpAB3rmVmqC46K4rEM+mxpHTxJyA3PI5pt8t51cQGLFoq/nJ08swCbMyQbud7bUIw2p2ouGlZS9i2UhVrA+NS3dtAV31C3U6XgjaINwcksQO8GN3AhuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940139; c=relaxed/simple;
	bh=asqiJpjLiLhCgnZPbayuiLkQWTg+6hfrolruXld72/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=olW+ocdQq3O6bJSnlx9rPVIsO0JsVRDiSOW4tlwBT0cBi2g/G+8tB/wQR2E7zuwtWsc+pCZHHX0aFsEhHjKsePuWqOyP9bpLjQ3zjjQFwMy7c7o+ac3Kjp9yoMboEHnoXOpcbaADQUePqOQe4oFHEa00TX72U3OAOuwLNgfyc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4rBHx31; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef80d30df1so4796697a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 10:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733940137; x=1734544937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1lf4kyl5o8ojaR7yeVD7qLHy8y/n2Kt6+OeU26iF60=;
        b=X4rBHx31fTP/34Lhya3SLBAdkYqjryz6yd4FMt+hv+69XQEYDGT3R7vSVLqAaDxlzz
         7QnA89RWW9HPeHyumm/aoqepXYzK/T7R2ILozbrwMwnNT35RvFMOX/k82Xgup95CSCOo
         Ccicgyx8rWsDj/+S17kJwLxEYmqGikW3pvMGDVVsAlDArEY9GtsPHRjBGei5L6Bc9cGQ
         WGkpNHSjYpPqhLMZsABbJZW+5Nk79tmbs9X1YhZTn+nHOhDuY7rUNSa79BcM+kEcpfzz
         RsPJUsUEEWH53ehJjL4rgrpeJrQygGK8IWmeUKy8/y/SS3nnE7aAn3XIa8BcCNiyeVOx
         gyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733940137; x=1734544937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1lf4kyl5o8ojaR7yeVD7qLHy8y/n2Kt6+OeU26iF60=;
        b=DDcnvpE1kDrpZZOpGG9I2VmxKceoBXU1niH/dMOrceV9E+hDUXM+eXPCNeRDgnsYrP
         ruq8TB6pmNlQ9cBBU5NLKVaiIxdGCndM+GVoHU8GWOEOSj/3pDiP6cMmLOpsda+iFRwN
         u8lXtcvG8aJkJEkoKQbv6nITOl22s02cNjaOcSTLNSrqdMtv5/ZKIIvj8HJuWF0Tanv0
         SNOQpAQnWYhFxr/h1fyhNkbo3HHX3TonYACr3QtjAuqvlUSjarVgPI9QwX7nv6hmZvYl
         UKxQmoJhGru+hKeOxhYbfQxzYILVEdJg+4WG7x2SK86NaHFfkHb5XDpKPken+p0czIwQ
         PgEA==
X-Forwarded-Encrypted: i=1; AJvYcCXizX/1RLaypVKPgvu5xwW8NqgkAbJyT47O9zjXUOiu2Xa4Z7AGXMCIyeEtSq7EjzbKFow=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ORgdVExtx0QnyMlk4aTzk3IFM5Yt/dnogZpE81qmbjBgOU3Q
	Q11EXFH44ZX4hgcs+9zQGlhXmRd3FCSyIiyOUq2mFMaYWLwhOVYGUXFNBglJg+OCdAkHZBFo83B
	yRA==
X-Google-Smtp-Source: AGHT+IELhj748F6SgeaEJfutWFt3ozm7X+t736qOr2yK5dsPlYPqcc0/Ms9TEI5h9cMJ659WQfUT6SLlSMs=
X-Received: from pjbqa6.prod.google.com ([2002:a17:90b:4fc6:b0:2ef:79ee:65c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:544b:b0:2ee:b2be:f390
 with SMTP id 98e67ed59e1d1-2f13930a57bmr1094830a91.28.1733940137438; Wed, 11
 Dec 2024 10:02:17 -0800 (PST)
Date: Wed, 11 Dec 2024 10:02:15 -0800
In-Reply-To: <20241111102749.82761-2-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111102749.82761-1-iorlov@amazon.com> <20241111102749.82761-2-iorlov@amazon.com>
Message-ID: <Z1nTp82wgSGe4AmV@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: Add function for vectoring error generation
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 11, 2024, Ivan Orlov wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f6900bec4874..f92740e7e107 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6452,6 +6452,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	union vmx_exit_reason exit_reason = vmx->exit_reason;
>  	u32 vectoring_info = vmx->idt_vectoring_info;
>  	u16 exit_handler_index;
> +	gpa_t gpa;

I've gone back and forth on where to declare scoped varaibles, but in this case,
I think it makes sense to declare "gpa" inside the if-statement.  Making it
visible at the function scope when it's valid in a _super_ limited case is bound
to cause issues.

Of course, this code goes away by the end of the series, so that point is moot.
But on the other hand, declaring the variable in the if-statement is desirable
as the churn is precisely limited to the code that's being changed.

>  	/*
>  	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
> @@ -6550,19 +6551,10 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
>  	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
>  	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
> -		int ndata = 3;
> +		gpa = exit_reason.basic == EXIT_REASON_EPT_MISCONFIG
> +		      ? vmcs_read64(GUEST_PHYSICAL_ADDRESS) : INVALID_GPA;

Again a moot point, but IMO using a ternary operator here makes it unnecessarily
difficult to see that gpa is valid if and only if the exit was an EPT misconfig.

		gpa_t gpa = INVALID_GPA;

		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
			gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);


> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
> -		vcpu->run->internal.data[0] = vectoring_info;
> -		vcpu->run->internal.data[1] = exit_reason.full;
> -		vcpu->run->internal.data[2] = vmx_get_exit_qual(vcpu);
> -		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
> -			vcpu->run->internal.data[ndata++] =
> -				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> -		}
> -		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
> -		vcpu->run->internal.ndata = ndata;
> +		kvm_prepare_event_vectoring_exit(vcpu, gpa);
>  		return 0;
>  	}
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83fe0a78146f..e338d583f48f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8828,6 +8828,28 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
>  
> +void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +	u32 reason, intr_info, error_code;
> +	struct kvm_run *run = vcpu->run;
> +	u64 info1, info2;
> +	int ndata = 0;
> +
> +	kvm_x86_call(get_exit_info)(vcpu, &reason, &info1, &info2,
> +				    &intr_info, &error_code);
> +
> +	run->internal.data[ndata++] = info2;
> +	run->internal.data[ndata++] = reason;
> +	run->internal.data[ndata++] = info1;
> +	run->internal.data[ndata++] = (u64)gpa;

No need for the cast.

> +	run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
> +
> +	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
> +	run->internal.ndata = ndata;
> +}
> +EXPORT_SYMBOL_GPL(kvm_prepare_event_vectoring_exit);
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -- 
> 2.43.0
> 

