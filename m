Return-Path: <kvm+bounces-19508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA71A905D94
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56EA6283A15
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0567C1272A7;
	Wed, 12 Jun 2024 21:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2UMGOmvp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E084D35
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718227255; cv=none; b=Fa9/l+c0aCCn16snufHTtm4uzJ0Jr9pVglmwizeh6XHGb11MToZDjI9D7CwyM030+/JFOXaq94wC3Yg1C8qJ2N1coZDS6FAmlfnN+NVgvCWyoOx1wZ2vIoUWCnbYs3tWVtslq4qf+dmKO6zs25AN/enwyI9OIng7WRNKI6u7+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718227255; c=relaxed/simple;
	bh=1GcSncPwqKEQjxsMosB7/O2aygmUJPI07VDJmC37b5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BKYykDgqJh0v37lgqjz67S+elmJu3ycfS69MtNz0gPE0Q6G+xXmt2R551kdGvt05wZ9NuxX6bdLa+2VBsewVRCWgoaF+nQu6FqFEKzwbP+N/ePQIezT0m+oL8g30EoG/wbBmaSkJjDa0vH48hwTafE84ak5yeaVJVvtxrBHcEWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2UMGOmvp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f847870542so2458925ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718227252; x=1718832052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a4s5wFvfeNJXCJWEmUtUY237craFIfNnXh+7wQwiZM8=;
        b=2UMGOmvpfuxZFXk9IV9IutXeotId8EYUzKxQe4/pzSKzalDUMuUMEqCZ5S5+bCP5+m
         SSHuT//O0SB2zqV4FxFGPHmmZGLwPSP56Y1+PxVV6hhGDtQ6R2IcJwamT9EcJ7LMdEjO
         HltO6YBhQ5oSis1c/KH9H/H/EXXqwu6pKt6rSzWzEOx+N6ioUBcRUr6UIX4Ak2hqLOS4
         YR1Ka/kf6HBxDtfcKPPQ5TOYZ8bkDAGDxplSzY1EWkF6+3ahoxzvrmZ/5xGlAvT4BWhd
         VQ41E3iDlGaeha/vh3q5coQbWOCCC8yQRr7AcyCV2yD1Hm9oYxHtmdEVxYp0BcielSdp
         jVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718227252; x=1718832052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a4s5wFvfeNJXCJWEmUtUY237craFIfNnXh+7wQwiZM8=;
        b=IkpI7uoPxnaTQPxLNLgxGjM37eev9D95p0lN1N7lOn34cX9I3oIYj22uWNtPyI2bbW
         edKJKXpQsgKFKvNKYjIXhPpN+PLdYROMIx6No+PsWi4qjht22wXZYONWwvVn0v05F0JS
         6myepW7Eph9bv9W3cuXjKcvrszhI7Kh5ZE0OCQiWlijmyA0BifGWN9G7AmbLlc42HiO1
         jRVq76fLJR17VeJjvohEzgFV8jdJpQdzItPHcBjAnb7+HzJyjZ9dl7fFwKJQXjTdewco
         62C88rCHqxvsP1ySWej09ld2Ug+yM63HgtuwlZndinesAfYL/Ijp9IA0FNwJKn13rU87
         bokA==
X-Forwarded-Encrypted: i=1; AJvYcCWQIbvouYIqihR6XfztEpffVc7Ue3V+Dul9KNd0hvtx2UDGkj+6NO3UJt5wnMd/kSSXYFCXWCWpZfYBaJsEiyJ3hxqs
X-Gm-Message-State: AOJu0Ywtwe+q16Mc0jvwPkL0h72DYpunG5EY9PyIgQIS2b4n3nz5EWch
	Snv+iKKKD16KLrHbQaKHSHfA5QauABp6BlpRPloMfWBs6FS/MC8P7H7seM1WSk/dWp8BIIa4k3O
	2gQ==
X-Google-Smtp-Source: AGHT+IF236fVTqan1xeFH5dPPmgc0NM7zLynRwigfEMIC3iJa54rvvA/hW7i8p+BK04gMU89grxKlGMEn9I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234f:b0:1f3:f8c:55d5 with SMTP id
 d9443c01a7336-1f83b55b4b7mr84625ad.2.1718227252048; Wed, 12 Jun 2024 14:20:52
 -0700 (PDT)
Date: Wed, 12 Jun 2024 14:20:50 -0700
In-Reply-To: <20240207172646.3981-8-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-8-xin3.li@intel.com>
Message-ID: <ZmoRMp_-CXC9QqPK@google.com>
Subject: Re: [PATCH v2 07/25] KVM: VMX: Set intercept for FRED MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	shuah@kernel.org, vkuznets@redhat.com, peterz@infradead.org, 
	ravi.v.shankar@intel.com, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Xin Li wrote:
> @@ -7774,10 +7777,12 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  static void vmx_vcpu_config_fred_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	bool fred_enumerated;
>  
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
> +	fred_enumerated = guest_can_use(vcpu, X86_FEATURE_FRED);

"enumerated" isn't correct.  Userspace can enumerate FRED to the guest even if
FRED is unsupported in KVM.

Planning for a future where this becomes guest_cpu_cap_has(), maybe "has_fred"?

> -	if (guest_can_use(vcpu, X86_FEATURE_FRED)) {
> +	if (fred_enumerated) {
>  		vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_FRED);
>  		secondary_vm_exit_controls_setbit(vmx,
>  						  SECONDARY_VM_EXIT_SAVE_IA32_FRED |
> @@ -7788,6 +7793,16 @@ static void vmx_vcpu_config_fred_after_set_cpuid(struct kvm_vcpu *vcpu)
>  						    SECONDARY_VM_EXIT_SAVE_IA32_FRED |
>  						    SECONDARY_VM_EXIT_LOAD_IA32_FRED);
>  	}
> +
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, !fred_enumerated);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, !fred_enumerated);
>  }
>  
>  static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> -- 
> 2.43.0
> 

