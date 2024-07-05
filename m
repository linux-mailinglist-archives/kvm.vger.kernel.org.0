Return-Path: <kvm+bounces-20987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7063E927FB7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19950282386
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7FB10A2B;
	Fri,  5 Jul 2024 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD5zP5XQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22BD3D6A
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142499; cv=none; b=g1EA6NxNmPMtVEjhSNSkowyzHD0Gg3pzeRWOuLNlaPrxISwfrzJJTfV8rCD5+s1VIN5FUa6kYJdvP5Nvntr7Bcz3Dua+C+fALAHtL0ihZdq9DLBBwIrrwV0WmhjgVYnSlN1cXHRmAcDd0P3EG+DXmGJpQOZDYVIFgMxpepqfCFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142499; c=relaxed/simple;
	bh=kUrvdJJZaaD51brweInbHtrGPTgE+jW3eNT7+SStkSU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L6jWxho6mYuYATUP2Rg2acEBdzTh1gniEgK7sICbiD9+zlZaJRU+8nZLZD8v7KpTjBfLs5l9Q8fVX1qN4B0uMidp+UFiwAZOmz+Ge1U5JXyDE8xdXJpVkEYfThVpPf2QrZh9Ys45SpRPFuykgXCGwGKSz1qbxHrKWoivRgJdrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD5zP5XQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLdYes014YOGARjY/z8YUHSsmB3NMreKpnD05Eo5dVA=;
	b=JD5zP5XQ30IeA2AZYkHvBGVWFRvUPeZPcmha/QmFPnOBFadZn+SOZVAcNYMxLVR/sfjI3H
	tUAnseuZBv/n2LIcpa9x7/8yjA9f8ymkbrmQ8z4q8wXiHIEEY0FcWxOH3UxLCmKV8Vq4vS
	5yJE03xuo6q3MAg1pwGO/d9IX1yDf0w=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-9Np4jKRaNeG1DylaDrpUlQ-1; Thu, 04 Jul 2024 21:21:35 -0400
X-MC-Unique: 9Np4jKRaNeG1DylaDrpUlQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b22e2dfa6cso16832776d6.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142494; x=1720747294;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rLdYes014YOGARjY/z8YUHSsmB3NMreKpnD05Eo5dVA=;
        b=r+gNrOseHOMU3le7yXMIfO3oD2BVE9kEk04ujXPpRv3c+j/ymZVPnhBJb3kFy3KWH7
         QCYYqbPyZH6wm11xx9B2kSnkBeWoCU2f97iyyDikCQGC9VQliIlz5BLQEAn6y0lCyhKV
         8uBIeJYH7wBAk1SOppQROCotQBBmoT141wC2rn+LKAzXFf3t3gTbmlf201FcYMrGpTv6
         wpZ33u07zc5j1hpqptoYFlMGDxMAJX0Tpy/nOVIozm2zocAvcMx+DZ3zzZl/jprmn335
         4Ytkjx2QLqNY3C9cdEm8RWyxzn62abI9R/CPisYz1HrEjCPHTyatGbqRdoYHFopRK38w
         kWug==
X-Gm-Message-State: AOJu0YzNzdJAmkxU+eFIJ8YwT6QgVeLV5i2jdrnhoUJfaFZ1aq33yg0m
	+KHxP9/Cje77TB3mmtqCZS0ogOSJX9GWXimbsmWUM1Ng3YnJNHDTdzOFW8Fw828A0dPGF9/HKDs
	yZNsdty2AWTsTmLgU3eQOz7oCIhGRWX+04/Jk3v3Ou+B5tsplvw==
X-Received: by 2002:a05:6214:daf:b0:6b5:dff6:cac0 with SMTP id 6a1803df08f44-6b5ecf97793mr38138276d6.21.1720142494681;
        Thu, 04 Jul 2024 18:21:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGicR0okBEqG0PULE/EG8W94vYsVFsQcCKsh9Xj7NWrddJl1sZNVYVh4JC0ge2nMXeETH5RYw==
X-Received: by 2002:a05:6214:daf:b0:6b5:dff6:cac0 with SMTP id 6a1803df08f44-6b5ecf97793mr38138096d6.21.1720142494406;
        Thu, 04 Jul 2024 18:21:34 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5f39c1sm68802036d6.97.2024.07.04.18.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:21:34 -0700 (PDT)
Message-ID: <2a4052ba67970ce41e79deb0a0931bb54e2c2a86.camel@redhat.com>
Subject: Re: [PATCH v2 19/49] KVM: x86: Add a macro to init CPUID features
 that ignore host kernel support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:21:33 -0400
In-Reply-To: <20240517173926.965351-20-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-20-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Add a macro for use in kvm_set_cpu_caps() to automagically initialize
> features that KVM wants to support based solely on the CPU's capabilities,
> e.g. KVM advertises LA57 support if it's available in hardware, even if
> the host kernel isn't utilizing 57-bit virtual addresses.
> 
> Take advantage of the fact that kvm_cpu_cap_mask() adjusts kvm_cpu_caps
> based on raw CPUID, i.e. will clear features bits that aren't supported in
> hardware, and simply force-set the capability before applying the mask.
> 
> Abusing kvm_cpu_cap_set() is a borderline evil shenanigan, but doing so
> avoid extra CPUID lookups, and a future commit will harden the entire
> family of *F() macros to assert (at compile time) that every feature being
> allowed is part of the capability word being processed, i.e. using a macro
> will bring more advantages in the future.

Could you explain what do you mean by "extra CPUID lookups"?


> 
> Avoiding CPUID also fixes a largely benign bug where KVM could incorrectly
> report LA57 support on Intel CPUs whose max supported CPUID is less than 7,
> i.e. if the max supported leaf (<7) happened to have bit 16 set.  In
> practice, barring a funky virtual machine setup, the bug is benign as all
> known CPUs that support VMX also support leaf 7.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 77625a5477b1..a802c09b50ab 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -70,6 +70,18 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
>  })
>  
> +/*
> + * Raw Feature - For features that KVM supports based purely on raw host CPUID,
> + * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> + * Simply force set the feature in KVM's capabilities, raw CPUID support will
> + * be factored in by kvm_cpu_cap_mask().
> + */
> +#define RAW_F(name)						\
> +({								\
> +	kvm_cpu_cap_set(X86_FEATURE_##name);			\
> +	F(name);						\
> +})
> +
>  /*
>   * Magic value used by KVM when querying userspace-provided CPUID entries and
>   * doesn't care about the CPIUD index because the index of the function in
> @@ -682,15 +694,12 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512VL));
>  
>  	kvm_cpu_cap_mask(CPUID_7_ECX,
> -		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> +		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>  		F(SGX_LC) | F(BUS_LOCK_DETECT)
>  	);
> -	/* Set LA57 based on hardware capability. */
> -	if (cpuid_ecx(7) & F(LA57))
> -		kvm_cpu_cap_set(X86_FEATURE_LA57);
>  
>  	/*
>  	 * PKU not yet implemented for shadow paging and requires OSPKE

Putting a function call into a macro which evaluates into a bitmask is somewhat misleading,
but let it be...

IMHO in long term, it might be better to rip the whole huge 'or'ed mess, and replace
it with a list of statements, along with comments for all unusual cases.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




