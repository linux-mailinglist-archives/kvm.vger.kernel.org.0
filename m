Return-Path: <kvm+bounces-20997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC093927FE1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EDC51F233BA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F374212B87;
	Fri,  5 Jul 2024 01:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KyMhkhca"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0117492
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720144314; cv=none; b=UL1IrBqM7oV+K7ZOdBa1aOsFhhhnf4nhKkCcIl5idpPsvVbd4gOLVeVnx6snKM9thTCwn0gQu/HRIFfng399j5yQmzxgVZQNfUQmj9E9XIAmTeg0arX50VMs1X5WiLFLLRu54O8mKQNOoNvz2qYFh+VKikJeHU22NpO0djNv46E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720144314; c=relaxed/simple;
	bh=3HB/ZhBL8+YYThLGhHrP6KWQy2uCzZ85VbVeMo508Vo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JqEuPYGD9ikftcytXvgp0jy+4duc/KUYxdl0JBe7z2snaLfSoztqBPG4gNXlug3Gnj+ZzIQkSAtI5S1Pl3YyszqAXOR8GCv9NRVRv0dv8I5NMIhKZG5kMqUAqgIrtHXNzw+aRCbccUyJ+t9Re7PsFWev/G4eweeYUcvmKi8Ndek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KyMhkhca; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720144311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsgDdXEr0hvAMMHI+PUQAhRQnBqOPRxX0LUlSZGTc7s=;
	b=KyMhkhcaPwZUdsWoiVeI5yX881iwXAFusYzH0Yvv45oJo9V97Pcsa/Mmjh5r30E0fbo8rx
	RmogZy3A/4y3Clvi8fmsrriOGceMST4D/LLyPGpL9hs9ZUt+tOtpWBsped6lfIllhU0DAs
	Wt7LmQLrPYfKsyHYhQBP85n9PIUsYsY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-gy7252zFOPG3jHdohp7sGw-1; Thu, 04 Jul 2024 21:51:49 -0400
X-MC-Unique: gy7252zFOPG3jHdohp7sGw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-44645ec39d4so14116841cf.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720144309; x=1720749109;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsgDdXEr0hvAMMHI+PUQAhRQnBqOPRxX0LUlSZGTc7s=;
        b=CuRmdsYbJaLKCk9/0jgrK9hve/DdRbsVKF6uMfX/lvFO4EFJ7e9Gi9HOXXA/OIV8GW
         Wck+vfpe/GvT9YUQB9X+Xd1NweTNWfXpZlXY9o8ysnr41fcw9gJo8xD3U3sTQ0DW/4wH
         O3PlnXI84tY8j8BaYqIxutK32PY0PcPzCDp+AgdCZMB6ufIPk1ZvWv11Go9zGhhYSK+5
         hKgqgz8aYjBU1q948zsX7FQNGFNMXDlVFAFuyiZnfGpovp326CFf8OkF/Xxq/CbZcOis
         MJUdlQDv09q6jC7fz28zoOSa3vC1cr8Zyvpv6Ah8wH/wd+kfqwBxJ+IOEjDbil+NPjDd
         WCSg==
X-Gm-Message-State: AOJu0YyLvs4Lwk9VbSVm7Z0HbTzIEv8MZ7OFwKWjmzCsWOv0GPgz5VXt
	QutQptkUCKd9s1z9G0//ywXr74w9ew0D0qc34/JW0W0XLnSBW2AOILAHDmpu5pTjjocLZygVOZE
	8al6fghHbMypYl4BwBjtdc8KrV2CWI9nouGuS3k+dPTqpojxEcQ==
X-Received: by 2002:a05:622a:1792:b0:447:c7e4:6b33 with SMTP id d75a77b69052e-447cbefdaa2mr44353591cf.7.1720144309276;
        Thu, 04 Jul 2024 18:51:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkvRWOffe3GXynpyOq/YmuJAybCeDrX06IZmipkMFMZuINw9fVJdp7zFvBhCXG35EdtEjyTA==
X-Received: by 2002:a05:622a:1792:b0:447:c7e4:6b33 with SMTP id d75a77b69052e-447cbefdaa2mr44353471cf.7.1720144308943;
        Thu, 04 Jul 2024 18:51:48 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4465143eb1csm65523421cf.57.2024.07.04.18.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:51:48 -0700 (PDT)
Message-ID: <ee919bfcd4a57cde7debe7bd54d3cbd04d3ba15c.camel@redhat.com>
Subject: Re: [PATCH v2 30/49] KVM: x86: Always operate on kvm_vcpu data in
 cpuid_entry2_find()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:51:47 -0400
In-Reply-To: <20240517173926.965351-31-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-31-seanjc@google.com>
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
> Now that KVM sets vcpu->arch.cpuid_{entries,nent} before processing the
> incoming CPUID entries during KVM_SET_CPUID{,2}, drop the @entries and
> @nent params from cpuid_entry2_find() and unconditionally operate on the
> vCPU state.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 62 +++++++++++++++-----------------------------
>  1 file changed, 21 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7290f91c422c..0526f25a7c80 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -124,8 +124,8 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   */
>  #define KVM_CPUID_INDEX_NOT_SIGNIFICANT -1ull
>  
> -static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> -	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> +static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
> +						  u32 function, u64 index)
>  {
>  	struct kvm_cpuid_entry2 *e;
>  	int i;
> @@ -142,8 +142,8 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>  	 */
>  	lockdep_assert_irqs_enabled();
>  
> -	for (i = 0; i < nent; i++) {
> -		e = &entries[i];
> +	for (i = 0; i < vcpu->arch.cpuid_nent; i++) {
> +		e = &vcpu->arch.cpuid_entries[i];
>  
>  		if (e->function != function)
>  			continue;
> @@ -177,8 +177,6 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>  
>  static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
> -	int nent = vcpu->arch.cpuid_nent;
>  	struct kvm_cpuid_entry2 *best;
>  	u64 xfeatures;
>  
> @@ -186,7 +184,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>  	 * canonical address checks; exit if it is ever changed.
>  	 */
> -	best = cpuid_entry2_find(entries, nent, 0x80000008,
> +	best = cpuid_entry2_find(vcpu, 0x80000008,
>  				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	if (best) {
>  		int vaddr_bits = (best->eax & 0xff00) >> 8;
> @@ -199,7 +197,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  	 * Exposing dynamic xfeatures to the guest requires additional
>  	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
>  	 */
> -	best = cpuid_entry2_find(entries, nent, 0xd, 0);
> +	best = cpuid_entry2_find(vcpu, 0xd, 0);
>  	if (!best)
>  		return 0;
>  
> @@ -234,15 +232,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>  	return 0;
>  }
>  
> -static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_entry2 *entries,
> -							      int nent, const char *sig)
> +static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
> +							    const char *sig)
>  {
>  	struct kvm_hypervisor_cpuid cpuid = {};
>  	struct kvm_cpuid_entry2 *entry;
>  	u32 base;
>  
>  	for_each_possible_hypervisor_cpuid_base(base) {
> -		entry = cpuid_entry2_find(entries, nent, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +		entry = cpuid_entry2_find(vcpu, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  
>  		if (entry) {
>  			u32 signature[3];
> @@ -262,13 +260,6 @@ static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_e
>  	return cpuid;
>  }
>  
> -static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
> -							    const char *sig)
> -{
> -	return __kvm_get_hypervisor_cpuid(vcpu->arch.cpuid_entries,
> -					  vcpu->arch.cpuid_nent, sig);
> -}
> -
>  static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_hypervisor_cpuid kvm_cpuid;
> @@ -292,23 +283,22 @@ static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
>   * Calculate guest's supported XCR0 taking into account guest CPUID data and
>   * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
>   */
> -static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
> +static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> -	best = cpuid_entry2_find(entries, nent, 0xd, 0);
> +	best = cpuid_entry2_find(vcpu, 0xd, 0);
>  	if (!best)
>  		return 0;
>  
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> -static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> -				       int nent)
> +void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> -	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	best = cpuid_entry2_find(vcpu, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	if (best) {
>  		/* Update OSXSAVE bit */
>  		if (boot_cpu_has(X86_FEATURE_XSAVE))
> @@ -319,43 +309,36 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>  	}
>  
> -	best = cpuid_entry2_find(entries, nent, 7, 0);
> +	best = cpuid_entry2_find(vcpu, 7, 0);
>  	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  
> -	best = cpuid_entry2_find(entries, nent, 0xD, 0);
> +	best = cpuid_entry2_find(vcpu, 0xD, 0);
>  	if (best)
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>  
> -	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> +	best = cpuid_entry2_find(vcpu, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> -		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +		best = cpuid_entry2_find(vcpu, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  		if (best)
>  			cpuid_entry_change(best, X86_FEATURE_MWAIT,
>  					   vcpu->arch.ia32_misc_enable_msr &
>  					   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  }
> -
> -void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> -{
> -	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> -}
>  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
>  static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
>  {
>  #ifdef CONFIG_KVM_HYPERV
> -	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
> -	int nent = vcpu->arch.cpuid_nent;
>  	struct kvm_cpuid_entry2 *entry;
>  
> -	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
> +	entry = cpuid_entry2_find(vcpu, HYPERV_CPUID_INTERFACE,
>  				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
>  #else
> @@ -401,8 +384,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_apic_set_version(vcpu);
>  	}
>  
> -	vcpu->arch.guest_supported_xcr0 =
> -		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> +	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
>  
>  	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
>  
> @@ -1532,16 +1514,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>  						    u32 function, u32 index)
>  {
> -	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
> -				 function, index);
> +	return cpuid_entry2_find(vcpu, function, index);
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
>  
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  					      u32 function)
>  {
> -	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
> -				 function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


