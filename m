Return-Path: <kvm+bounces-46265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D03AB468D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47621865185
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6553129B223;
	Mon, 12 May 2025 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gjpi4QHA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103A3299A82
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747085562; cv=none; b=akG9n+T2WJxD1GYk1FF8qTNJqKSEcLxT4K9Ql0t1Yju3o0pfNe78GVQvcSQPcaOdXPdUj6uruj2jNp0t2kT3OyEPGUcpT9C6suYP7XIv2yLPPAbGXkabpLoqOrGxItHeQklCJt9V2wUTP73rugmdVh8LQCpdletL2ZV2wM4gWA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747085562; c=relaxed/simple;
	bh=sFHYzOqc9ldiOIkZ5g5soXtLw0oO0wTl3DJJuDEdpCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gvPZLbqyrF6ieYTkFhr3Ul7G2FojA5SqJZyZQ16dWjgf7jmGoY4EdujJBF6JdCN/riBOGMCj5XGWM2H4CiF6MlLQ+C4z7PAz/dkX/E2aIgSz1hERiTgiUDI7fo6Ajft7MZZwZ4pajFj/y5xFR+OIBNw5JUlKCjK/HyLpl034MZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gjpi4QHA; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742229c8d8eso5206435b3a.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747085560; x=1747690360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i+B2Elcw17Cu4CBcJZhD06N2/yMjwzCSgqlqc2Asw9k=;
        b=gjpi4QHAwqg04/Oa8OdNdzd71Ak1lSJyPHN6CF2OukY1P3zozBAATh66FH7tHcKkHo
         MUvX4ZK57SDQJ6+tKbu6xuvwxuBaB8zwr0MPmNkBH7I8zkXVtf1+kAV8JhPFwQsO1FQR
         idgHAXag0E3BNPWJTVvu7AU+FmQg8WU82/LnUa8FR8vVvBR4YXPWKVtKGskZG5kI4zbC
         qW7VbNZtpHOsznKygV4Ve+LkQl/Bh+y0xggRWEOHgxI8c16UyoBz/0iVz5ZwqmcDT+7F
         BAjxog+6H+UB3khAj7m9ONOqk1ktDTlJLc5zEs51N4oWTOgbW/4YSxejNT+FLMme3z4K
         RJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747085560; x=1747690360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i+B2Elcw17Cu4CBcJZhD06N2/yMjwzCSgqlqc2Asw9k=;
        b=GeR3nOE/UihqItQcMP0gB3w3lFvy3nTu1H2tqz5mOPqbPy8LyZ06HA9s4oeMELgisv
         cnZYcHg0q3xidme1cjaw9RDWnyiuETp2bVdHR4Vk2VcJO8hmVHhKUT+ufM9i0DjyT4aB
         lproXUfiW1lAtSppn0/sj1ArvtlEoEJ4vv2CYJ94nC5MRWLAa0QRNxUJDwc3oC9xdiOu
         x21FJSXKNUtMRKfYM/rV4PxXX4UF5yKYAHIsLRYdl8aAAEeSfutwGrCpjy7D7OGZysT4
         da8dh9HftWICorrlevKgNhbwv6nMx06fdIIh3hYIBfuv5v2pxQIZisrGgZZgi8zuGhub
         G9CA==
X-Forwarded-Encrypted: i=1; AJvYcCVB7VfDGEFki6F+x4ziwm2TruJSP0tfVU5VPctZAzvwYX0wnJrDtZWzwBnwk7bxO3nYxNs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ZDzRnGmnTeuzNJ7d6RGBX7HqTckDxdjl9JDg/tei1tK9P6LF
	KZh0NlETOQevuahCI5VjT6JrvZ7H8OeXH03Cqc9EzHATHFWIgrJOX+uJjETX+BgAa6rMVMF4Pac
	FYw==
X-Google-Smtp-Source: AGHT+IEp1InJ4GD3YtvHdByU1GNNXTqDQ4FLT07UCcjYKesrglIqAhjhJEZJflXendq5wohUelB1dP7LOeQ=
X-Received: from pgbcf9.prod.google.com ([2002:a05:6a02:849:b0:b0d:b491:d409])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3405:b0:1f6:2d39:8713
 with SMTP id adf61e73a8af0-215abc21edcmr19190748637.19.1747085560396; Mon, 12
 May 2025 14:32:40 -0700 (PDT)
Date: Mon, 12 May 2025 14:32:38 -0700
In-Reply-To: <20250313203702.575156-17-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-17-jon@nutanix.com>
Message-ID: <aCJo9qZdTrWBOwhf@google.com>
Subject: Re: [RFC PATCH 16/18] KVM: nVMX: Setup Intel MBEC in nested secondary controls
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Setup Intel Mode Based Execution Control (bit 22) for nested
> guest, gated on module parameter enablement.

*This* is the enablement patch.  And it's not doing "Setup", it's advertising
SECONDARY_EXEC_MODE_BASED_EPT_EXEC to userspace and allowing userspace to expose
and advertise the feature to the guest.

> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 931a7361c30f..ce3a6d6dfce7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -7099,6 +7099,10 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
>  		 */
>  		if (cpu_has_vmx_vmfunc())
>  			msrs->vmfunc_controls = VMX_VMFUNC_EPTP_SWITCHING;
> +
> +		if (enable_pt_guest_exec_control)
> +			msrs->secondary_ctls_high |=
> +				SECONDARY_EXEC_MODE_BASED_EPT_EXEC;

Land this above the VMFUNC stuff so that more of the secondary_ctls_high code is
clumped together.

>  	}
>  
>  	/*
> -- 
> 2.43.0
> 

