Return-Path: <kvm+bounces-20999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8B7927FE5
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A09B31C22243
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D997014AB2;
	Fri,  5 Jul 2024 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQXKrb65"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD951CFBD
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720144328; cv=none; b=uXexyXpvTuuMpFHZqG8M/Y/lBzLV0NBHiTfiYRAAHQ5tLsa9PlurrxBgwBKCkJRipCLmrsDpFurzzQhJ/8sAD+iEzRC/mQnj/0gkI602TcPnOBiSOZdhhWel15m5BvnNoWTNQM/3dV8y4hq/GzDmkEAKG/ZImXSKZACVd1KKpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720144328; c=relaxed/simple;
	bh=nzRcGb+kyercVxowW3qU4f37WmP6FLfDsGdbdTsC+LQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8OWT9I5sbphbMOp7AyattENF6z3eUqKQ/04v8753E6kHG8UhHG/k+ikCRER0w2j+o7teGBYn/LDIMSw0oyOeQksOEkwvhCM9BvWL6V6e+XEs57eG9MaVellJHLHVszGZm0NoUz03imStO9NuGsNYlpFyo35NCrbvvecij24oiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQXKrb65; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720144325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6b+7036jYxnuHPjtFREomtgUCm2YK6FRyPY3L2e2E5o=;
	b=fQXKrb65PuiLI+qRvNKFwDqQT3hztyXNrsKfGOVVrVyB/LUsUTMIAPBPP2FalutNEzuEFI
	kuXvGdJj+t4FqCeSrV3gDdz8M4d89V9qsvXFgmx4/mPFcxQxLn/bVhnP1yK/PAeXEMP82k
	XvrPsdwbBLavjJYxXmDhPnMu8Vctmu4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-lCO3jkIlOtahRZJrQxATIQ-1; Thu, 04 Jul 2024 21:52:04 -0400
X-MC-Unique: lCO3jkIlOtahRZJrQxATIQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44659849320so14988211cf.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720144323; x=1720749123;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6b+7036jYxnuHPjtFREomtgUCm2YK6FRyPY3L2e2E5o=;
        b=vih4GlL0wFZxUnAkQuKbE4jUAOxMDct9NeR3u9JQbCKXgqynKC4dt0nJ9KBpApH+NN
         TviXSA2hp+AkrsHyLGS7mOnr1jkJZ7td0AGprJiXzFAGayAyFATl5MFKbAPtquogXDTD
         DV1akAEnwttndLA45CZsS1OouMwmSRWQVwcuSRhKkWTCkmeO+p9HwWYeNTLMfN+Pr1WB
         ZcEZcyBVDpdgzYk24fGl0ZusnAqM1Tr5sB9mnzrh4renPaXWUR/pSk5+8CJb+3xZe0xW
         +C9IsVkynU1Nwps1g6jwfKhgPR4AUzxVtvvgjMOeb99eQs7APXzOQHfeeeMfuniKPmdU
         XHRw==
X-Gm-Message-State: AOJu0YzgiuIogqZfSE1oE0Gr/FJlHhPK3KN7qUfNOs2/tMpesnuxGIrW
	/DF4JQ3i0fm8CWTt8NSowLRRbAW4dcKIURrnSynKpEsNFNOSdgPx+OV+q12/O1bIxaKY8gZMMm+
	XkmKJiAkbq9xsGfRoAmGoat29ViNVVYWzmW3ptD6Xb9SG5fitLw==
X-Received: by 2002:a05:622a:130b:b0:446:4c01:1f7a with SMTP id d75a77b69052e-447cbef2255mr33005941cf.33.1720144323619;
        Thu, 04 Jul 2024 18:52:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwQTFvpVzS+3s8lBQ6rQS5+T3aTA4dKQfRqaVDuOQPH25bn08nShvkBsGun9K/e5wY/OTeZA==
X-Received: by 2002:a05:622a:130b:b0:446:4c01:1f7a with SMTP id d75a77b69052e-447cbef2255mr33005751cf.33.1720144323309;
        Thu, 04 Jul 2024 18:52:03 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-447d5843cd8sm825301cf.74.2024.07.04.18.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:52:03 -0700 (PDT)
Message-ID: <f5e327770211f515701e2de7db03c85c1277efa8.camel@redhat.com>
Subject: Re: [PATCH v2 32/49] KVM: x86: Remove all direct usage of
 cpuid_entry2_find()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:52:02 -0400
In-Reply-To: <20240517173926.965351-33-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-33-seanjc@google.com>
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
> Convert all use of cpuid_entry2_find() to kvm_find_cpuid_entry{,index}()
> now that cpuid_entry2_find() operates on the vCPU state, i.e. now that
> there is no need to use cpuid_entry2_find() directly in order to pass in
> non-vCPU state.
> 
> To help prevent unwanted usage of cpuid_entry2_find(), #undef
> KVM_CPUID_INDEX_NOT_SIGNIFICANT, i.e. force KVM to use
> kvm_find_cpuid_entry().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d7390ade1c29..699ce4261e9c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -189,6 +189,12 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>  
> +/*
> + * cpuid_entry2_find() and KVM_CPUID_INDEX_NOT_SIGNIFICANT should never be used
> + * directly outside of kvm_find_cpuid_entry() and kvm_find_cpuid_entry_index().
> + */
> +#undef KVM_CPUID_INDEX_NOT_SIGNIFICANT
> +
>  static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
> @@ -198,8 +204,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>  	 * canonical address checks; exit if it is ever changed.
>  	 */
> -	best = cpuid_entry2_find(vcpu, 0x80000008,
> -				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
>  	if (best) {
>  		int vaddr_bits = (best->eax & 0xff00) >> 8;
>  
> @@ -211,7 +216,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  	 * Exposing dynamic xfeatures to the guest requires additional
>  	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
>  	 */
> -	best = cpuid_entry2_find(vcpu, 0xd, 0);
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
>  	if (!best)
>  		return 0;
>  
> @@ -254,7 +259,7 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
>  	u32 base;
>  
>  	for_each_possible_hypervisor_cpuid_base(base) {
> -		entry = cpuid_entry2_find(vcpu, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +		entry = kvm_find_cpuid_entry(vcpu, base);
>  
>  		if (entry) {
>  			u32 signature[3];
> @@ -301,7 +306,7 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> -	best = cpuid_entry2_find(vcpu, 0xd, 0);
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
>  	if (!best)
>  		return 0;
>  
> @@ -312,7 +317,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> -	best = cpuid_entry2_find(vcpu, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best) {
>  		/* Update OSXSAVE bit */
>  		if (boot_cpu_has(X86_FEATURE_XSAVE))
> @@ -323,22 +328,22 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>  	}
>  
> -	best = cpuid_entry2_find(vcpu, 7, 0);
> +	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
>  	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  
> -	best = cpuid_entry2_find(vcpu, 0xD, 0);
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
>  	if (best)
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>  
> -	best = cpuid_entry2_find(vcpu, 0xD, 1);
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> -		best = cpuid_entry2_find(vcpu, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +		best = kvm_find_cpuid_entry(vcpu, 0x1);
>  		if (best)
>  			cpuid_entry_change(best, X86_FEATURE_MWAIT,
>  					   vcpu->arch.ia32_misc_enable_msr &
> @@ -352,8 +357,7 @@ static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
>  #ifdef CONFIG_KVM_HYPERV
>  	struct kvm_cpuid_entry2 *entry;
>  
> -	entry = cpuid_entry2_find(vcpu, HYPERV_CPUID_INTERFACE,
> -				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
>  	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
>  #else
>  	return false;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


