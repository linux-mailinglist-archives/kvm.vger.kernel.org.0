Return-Path: <kvm+bounces-21005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72ED7928025
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5BCC1F255AD
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD2615EA2;
	Fri,  5 Jul 2024 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhFfnAGF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E715C3233
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720145608; cv=none; b=MSIJte3KcrJLPjHJk2im0ELrCaCf2zfnehj+XkLbZyR8+HB/8g7m/qRGVJ5LiEwsXoO6Sz+oVkhcqY8VzLJlcBynpQr4eVF71oJLPbixD1HYK5ege5/hTvH0eq3jol9do++9PXNL0u6WjQebzbn6/J/ktVzoajVo2iz59OR7FRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720145608; c=relaxed/simple;
	bh=jZLSxM98YGwItC6imM4Ot3/U+E+nnLuZxKOMcFLwcPY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OXGjmEiKMMugbXk6KrZkoTS7GCAHZXk1qz7jPL97ZxGARodIjJwC71ghVZZF5zRCyd/DihfeRBt5KhQHlhFb47sKtRAZr7d10P+M56sEUhxJ2Di4PbAXQSiqjAolYhnYAqxy0hIbLOGGaQ6rbSaJJZpNcfRBVmLfw1MysYx0IdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhFfnAGF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720145606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DgO3YkGwzzqqhZiBua5kE5Ja1b8mAMvNMIRLZEzWmpU=;
	b=BhFfnAGFTsllVk3gwH/ZynTYUnivVhofH0SsYTVbbviGBwKzH//ptbDunQtTSgMp/6wcgf
	noqp7NVNZOJ7CT19OyhBOxtH/lKHwsg58SfFIYp+v6bQjCFpz5bQ8X/420hl8NCRmwLhcz
	zPHppe5bx/98JbuEOEAZ4cAshei98MU=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-AsJ9Mvx-NRGzSDiMi-mVuw-1; Thu, 04 Jul 2024 22:13:24 -0400
X-MC-Unique: AsJ9Mvx-NRGzSDiMi-mVuw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-8100ace0fc8so381923241.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720145604; x=1720750404;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DgO3YkGwzzqqhZiBua5kE5Ja1b8mAMvNMIRLZEzWmpU=;
        b=KyDbnKl9BaCKzBC+ivsFHYf3qhsCNxNdrfqXBCoppC2TT+5pEiOVpHZUKR9H1XvBGF
         IJh6UETTrvPFyzYedX+boSJ/kHCw1ssc3iq7BXJ2Z9a2fKuP81Z90PAuEoIWZQX+MnVN
         vNlt7Sn+yC8cx385w3KURt6KrlYxWZhCFNFw9ZvavOTkGmwy1IhzP8FeTFpsl9HYVmQJ
         M6RqEfIR+ap1a4BW/yDCCGgD5sVepWCc08PFzqWX8pNjQFJGzq+eW+HRiAzMSIKTrGDB
         UJPY37w56+zMXpCiSje9mTrr/OTkaj1+C9YywCgamS6W/FkUw1Y9P2tJ+y5ifnL4P0Z5
         V9AA==
X-Gm-Message-State: AOJu0YwvEBp4PhuPFD/v64B//qIygjVbLyqPxCgbKz87abv3CJmnNwyk
	IZIIjVrDpDuGRLWl8EoYxXqOAsrJsjG+ltXg+kx3O/zUYQjo/oyD+zNmjZ0OJeii/nxnjjLmP8y
	XZfjcAL+AcQLMz+FV+Kq0yBpfE23MkcEKJv5u+LbTxUTP6ZoNWA==
X-Received: by 2002:a67:e458:0:b0:48f:1763:c389 with SMTP id ada2fe7eead31-48fee6dc439mr2929053137.35.1720145603828;
        Thu, 04 Jul 2024 19:13:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeSq83CkPS2KSGL5WZ1BIiBjBGhxZwbJx89Ah+Uhbd7P1ted5QOssWdPInSm7HGd5f1FDNdQ==
X-Received: by 2002:a67:e458:0:b0:48f:1763:c389 with SMTP id ada2fe7eead31-48fee6dc439mr2929007137.35.1720145602181;
        Thu, 04 Jul 2024 19:13:22 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4465c4bf7ecsm57418181cf.80.2024.07.04.19.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:13:21 -0700 (PDT)
Message-ID: <303cda854d038a42de58107b5d593758057880eb.camel@redhat.com>
Subject: Re: [PATCH v2 38/49] KVM: x86: Initialize guest cpu_caps based on
 guest CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:13:20 -0400
In-Reply-To: <20240517173926.965351-39-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-39-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Initialize a vCPU's capabilities based on the guest CPUID provided by
> userspace instead of simply zeroing the entire array.  This is the first
> step toward using cpu_caps to query *all* CPUID-based guest capabilities,
> i.e. will allow converting all usage of guest_cpuid_has() to
> guest_cpu_cap_has().
> 
> Zeroing the array was the logical choice when using cpu_caps was opt-in,
> e.g. "unsupported" was generally a safer default, and the whole point of
> governed features is that KVM would need to check host and guest support,
> i.e. making everything unsupported by default didn't require more code.
> 
> But requiring KVM to manually "enable" every CPUID-based feature in
> cpu_caps would require an absurd amount of boilerplate code.
> 
> Follow existing CPUID/kvm_cpu_caps nomenclature where possible, e.g. for
> the change() and clear() APIs.  Replace check_and_set() with constrain()
> to try and capture that KVM is constraining userspace's desired guest
> feature set based on KVM's capabilities.
> 
> This is intended to be gigantic nop, i.e. should not have any impact on
> guest or KVM functionality.
> 
> This is also an intermediate step; a future commit will also incorporate
> KVM support into the vCPU's cpu_caps before converting guest_cpuid_has()
> to guest_cpu_cap_has().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c   | 46 ++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/cpuid.h   | 25 ++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c | 28 +++++++++++++------------
>  arch/x86/kvm/vmx/vmx.c |  8 +++++---
>  4 files changed, 86 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 89c506cf649b..fd725cbbcce5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -381,13 +381,56 @@ static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
>  #endif
>  }
>  
> +/*
> + * This isn't truly "unsafe", but except for the cpu_caps initialization code,
> + * all register lookups should use __cpuid_entry_get_reg(), which provides
> + * compile-time validation of the input.
> + */
> +static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
> +{
> +	switch (reg) {
> +	case CPUID_EAX:
> +		return entry->eax;
> +	case CPUID_EBX:
> +		return entry->ebx;
> +	case CPUID_ECX:
> +		return entry->ecx;
> +	case CPUID_EDX:
> +		return entry->edx;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +}
> +
>  void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
> +	struct kvm_cpuid_entry2 *entry;
>  	bool allow_gbpages;
> +	int i;
>  
>  	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
> +	BUILD_BUG_ON(ARRAY_SIZE(reverse_cpuid) != NR_KVM_CPU_CAPS);
> +
> +	/*
> +	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
> +	 * honor userspace's definition for features that don't require KVM or
> +	 * hardware management/support (or that KVM simply doesn't care about).
> +	 */
> +	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> +		const struct cpuid_reg cpuid = reverse_cpuid[i];
> +
> +		if (!cpuid.function)
> +			continue;
> +
> +		entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
> +		if (!entry)
> +			continue;
> +
> +		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
> +	}
>  
>  	kvm_update_cpuid_runtime(vcpu);
>  
> @@ -404,8 +447,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 */
>  	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
>  				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
> -	if (allow_gbpages)
> -		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
> +	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best && apic) {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index ad0168d3aec5..c2c2b8aa347b 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -265,11 +265,30 @@ static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
>  	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
> -static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> -							unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
> +						unsigned int x86_feature)
>  {
> -	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
> +
> +	reverse_cpuid_check(x86_leaf);
> +	vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
> +}
> +
> +static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
> +						 unsigned int x86_feature,
> +						 bool guest_has_cap)
> +{
> +	if (guest_has_cap)
>  		guest_cpu_cap_set(vcpu, x86_feature);
> +	else
> +		guest_cpu_cap_clear(vcpu, x86_feature);
> +}

Assuming that this code is not deleted in following patches, I''ll prefer
to call this 'guest_cpu_cap_change' because this is what the function does.

> +
> +static __always_inline void guest_cpu_cap_constrain(struct kvm_vcpu *vcpu,
> +						    unsigned int x86_feature)
> +{
> +	if (!kvm_cpu_cap_has(x86_feature))
> +		guest_cpu_cap_clear(vcpu, x86_feature);
>  }
>  
>  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2acd2e3bb1b0..1bc431a7e862 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4339,27 +4339,29 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
>  	 * the guest read/write access to the host's XSS.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> -	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
> +	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> +			     boot_cpu_has(X86_FEATURE_XSAVE) &&
> +			     boot_cpu_has(X86_FEATURE_XSAVES) &&
> +			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
>  
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_NRIPS);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_TSCRATEMSR);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LBRV);
>  
>  	/*
>  	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
>  	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
>  	 * SVM on Intel is bonkers and extremely unlikely to work).
>  	 */
> -	if (!guest_cpuid_is_intel(vcpu))
> -		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +	if (guest_cpuid_is_intel(vcpu))
> +		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +	else
> +		guest_cpu_cap_constrain(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>  
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PAUSEFILTER);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PFTHRESHOLD);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VGIF);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VNMI);
>  
>  	svm_recalc_instruction_intercepts(vcpu, svm);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1bc56596d653..d873386e1473 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7838,10 +7838,12 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 */
>  	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>  	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_constrain(vcpu, X86_FEATURE_XSAVES);
> +	else
> +		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
>  
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LAM);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VMX);
> +	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LAM);
>  
>  	vmx_setup_uret_msrs(vmx);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


