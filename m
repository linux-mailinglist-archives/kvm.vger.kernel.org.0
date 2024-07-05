Return-Path: <kvm+bounces-20969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CAE927F78
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A671D1C22165
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 00:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312808C05;
	Fri,  5 Jul 2024 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSWDW13z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3072579
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 00:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720140954; cv=none; b=albXP5wkhMIOZ/vc/tX0jjlcnfz+msA1jWp0y13z3dbjSakGxVumFZKakfS53r7MbMUQd0FJ5MOYbtJ4pgaXrRULC9hF+n37n21ihB0v2dPusMn4Z2IXavQFtTw1/l7LbKr/VkxUKh0XHNt+m39RDUHg8dLIsFSzXfK4cf9lc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720140954; c=relaxed/simple;
	bh=LnzhxkxBAg4y7J6EaICw/p8UG7h2y2D94/h3sIPLTms=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ELEAaYlZIM4TwISeYQRTtNpCtif8JoOqdy7ozWmFMgcmK9if6LFf9le3SLykfRqVXg8w0PqQBx5gQkAJWR9lwJr0ziozRiCOjF5laxafiG1vbAYP7ki4+D3N7d/zyrKDYNe0xfpEHswP2jngIMd3pWCViYs40swSlHFEhH6+xUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSWDW13z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720140951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrQTEUbm9OSwk4aJubE3yEzrIosTl0+4Ms8/9+XrR1A=;
	b=bSWDW13zOyNttZIv53TmMQg/jnYtaAAY1aYkJbFyUAnGjUlcrdTuK2wb1lTgOV8qKnDGNy
	dDFMuvQd5MmdOrqW1d6Qi+QEa+mEnWz8Eo4/ZaxcizKkal1pck3mu+SA7Py1sxXp2p46Dm
	6ADhdR637BOKbqxj6Xk2G1DN8mWKZoE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-iHn7_iIONJO7nz9a24uLIw-1; Thu, 04 Jul 2024 20:55:49 -0400
X-MC-Unique: iHn7_iIONJO7nz9a24uLIw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b5ebdd8109so14117786d6.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 17:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720140949; x=1720745749;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IrQTEUbm9OSwk4aJubE3yEzrIosTl0+4Ms8/9+XrR1A=;
        b=D+ojeXUfjNGG9/Ht9BsHBIbGizTYDGzws/fbIm3Qii9n1+DdDIBQCP95/i7q9ui+tl
         +NBxNA009LVd6YQk8ssMTv0h/hvc1UG4XwLx9EkErFFuYPjASzgBmPS/iLi2S+sdtu3e
         cBFnj+dpucAvHl6K3jKakdyQmNVcIMtGvBzp7IorqgqGmKVNJyDZBAEz3IAbk65/mnS5
         mOjwOdmtVxEpVmyHeyPHeSbhwmb1piRsOBWuRhwIQ9EZ2XBfV1FrBUuLzDJTsmuhXhhV
         3NXcb+L/yfzc4Ew3GJZNWe2RoPvPKYmFihKklrE5txUWhEKameRlF1kTsNGxKduAgkBr
         w8kw==
X-Gm-Message-State: AOJu0Yzs2LHH0rwiaXJQK/dZM9IhvqVaI+ZmSAbXUclHcUun49jO0oV/
	5qv+b/14jPkMth696fkFYBU9OXd4419W/gLY6ai5UAXivUxtJar7my6GbDRtwANlw6gwhRARs8F
	bkgL2efsWLpJF1H8Bc47p87j+AyXZBRPCSOGEPYPe4CippSdaiw==
X-Received: by 2002:a05:6214:2502:b0:6b0:76e8:921f with SMTP id 6a1803df08f44-6b5ed094fc4mr38806746d6.60.1720140949387;
        Thu, 04 Jul 2024 17:55:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGE9LVDBJqW22FYY7p0Uy74ZDQ97wnrrjTsvquv93NtmfvCpvbstrTKEZ9XvqGYyzsSZaPUbg==
X-Received: by 2002:a05:6214:2502:b0:6b0:76e8:921f with SMTP id 6a1803df08f44-6b5ed094fc4mr38806576d6.60.1720140949096;
        Thu, 04 Jul 2024 17:55:49 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5f2937b7esm5095666d6.118.2024.07.04.17.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 17:55:48 -0700 (PDT)
Message-ID: <2c8a398c9899a50c9d8f06fa916eb8eb13b6fbc5.camel@redhat.com>
Subject: Re: [PATCH v2 03/49] KVM: x86: Account for KVM-reserved CR4 bits
 when passing through CR4 on VMX
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 20:55:47 -0400
In-Reply-To: <20240517173926.965351-4-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-4-seanjc@google.com>
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
> Drop x86.c's local pre-computed cr4_reserved bits and instead fold KVM's
> reserved bits into the guest's reserved bits.  This fixes a bug where VMX's
> set_cr4_guest_host_mask() fails to account for KVM-reserved bits when
> deciding which bits can be passed through to the guest.  In most cases,
> letting the guest directly write reserved CR4 bits is ok, i.e. attempting
> to set the bit(s) will still #GP, but not if a feature is available in
> hardware but explicitly disabled by the host, e.g. if FSGSBASE support is
> disabled via "nofsgsbase".
> 
> Note, the extra overhead of computing host reserved bits every time
> userspace sets guest CPUID is negligible.  The feature bits that are
> queried are packed nicely into a handful of words, and so checking and
> setting each reserved bit costs in the neighborhood of ~5 cycles, i.e. the
> total cost will be in the noise even if the number of checked CR4 bits
> doubles over the next few years.  In other words, x86 will run out of CR4
> bits long before the overhead becomes problematic.

It might be just me, but IMHO this justification is confusing, leading me to belive that maybe
the code is on the hot-path instead.

The right justification should be just that this code is in kvm_vcpu_after_set_cpuid
is usually (*) only called once per vCPU (twice after your patch #1)

(*) Qemu also calls it, each time vCPU is hotplugged but this doesn't change anything
performance wise.

> 
> Note #2, __cr4_reserved_bits() starts from CR4_RESERVED_BITS, which is
> why the existing __kvm_cpu_cap_has() processing doesn't explicitly OR in
> CR4_RESERVED_BITS (and why the new code doesn't do so either).
> 
> Fixes: 2ed41aa631fc ("KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 7 +++++--
>  arch/x86/kvm/x86.c   | 9 ---------
>  2 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e60ffb421e4b..f756a91a3f2f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -383,8 +383,11 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
>  	kvm_pmu_refresh(vcpu);
> -	vcpu->arch.cr4_guest_rsvd_bits =
> -	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> +
> +#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> +	vcpu->arch.cr4_guest_rsvd_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_) |
> +					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
> +#undef __kvm_cpu_cap_has
>  
>  	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
>  						    vcpu->arch.cpuid_nent));
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7adcf56bd45d..3f20de4368a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -116,8 +116,6 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
>  static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
>  #endif
>  
> -static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
> -
>  #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
>  
>  #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
> @@ -1134,9 +1132,6 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
>  
>  bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
> -	if (cr4 & cr4_reserved_bits)
> -		return false;
> -
>  	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
>  		return false;
>  
> @@ -9831,10 +9826,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		kvm_caps.supported_xss = 0;
>  
> -#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> -#undef __kvm_cpu_cap_has
> -
>  	if (kvm_caps.has_tsc_control) {
>  		/*
>  		 * Make sure the user can only configure tsc_khz values that


I mostly agree with this patch - caching always carries risks and when it doesn't
value performance wise, it should always be removed.


However I don't think that this patch fixes a bug as it claims:

This is the code prior to this patch:

kvm_x86_vendor_init ->

	r = ops->hardware_setup();
		svm_hardware_setup
			svm_set_cpu_caps + kvm_set_cpu_caps

		-- or --

		vmx_hardware_setup ->
			vmx_set_cpu_caps + + kvm_set_cpu_caps


	# read from 'kvm_cpu_caps'
	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);


AFAIK kvm cpu caps are never touched outside of svm_set_cpu_caps/vmx_hardware_setup
(they don't depend on some later post-processing, cpuid, etc).


In fact a good refactoring would to make kvm_cpu_caps const after this point,
using cast, assert or something like that.


This leads me to believe that cr4_reserved_bits is computed correctly.


I could be wrong, but then IMHO it is a very good idea to provide an explanation
on how this bug can happen.


Best regards,
	Maxim Levitsky







