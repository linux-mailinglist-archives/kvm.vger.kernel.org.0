Return-Path: <kvm+bounces-13150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B817892CDC
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 20:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 018E2282E48
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 19:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEB64369A;
	Sat, 30 Mar 2024 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RP0etF69"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AEF3BBE3
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711828734; cv=none; b=TheyJU+EEsO45fkSbB3AFVrqhNEY52RPpCpyGEfQ5PjWKTubDkBOEcf9HUkAmvxEkiYhOzFcYtOTWF/LvQNVZfFUv0PfcsawBkMWidxIkUMKlhJgp0iq/C9TnobaD4jk02HyYgi/x+IXk5NyqeNan49/cUYmFDoxjsQzcqK4mLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711828734; c=relaxed/simple;
	bh=hf3cXG5C0fUquGqLTgPc2V579FQipFG2QTQsJrAH3ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBGg48xeYnshhNAYogGcBL6JXtiK/7Q+RkakR10QTF2FtAF+aXnRWbhavowjs+B/bfnTnfgZ9Ke7zoGKbCRk5Or/GoojwgzQEv4xkPSvbWufGS2HR2L/NYVViLB/AR8eMRwr8JR/ag7NiHmDymOV14za95r18uqDmn6VtP932/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RP0etF69; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711828731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YCminwhNWaoRY7+GIgboB+tGovxzzkyeTmQzRWRZumA=;
	b=RP0etF69FeQffqzIgMHa3QNuRI8h/hLgHiOsZnbgRkZThsQZSQ/6SgkKNp/DV3kd+uViKx
	Ey1aCEc79wNr/mk1sq3t9cHbjh4jwaAiLFafHxKrCZJ2lJ+Lwo7odODAKtuL/oBIE1Ljys
	y0bT0yRbj1KK9sSgxaREHG0k4KC8QNE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-dguO_8x3O1OcVMSh_hgnPg-1; Sat, 30 Mar 2024 15:58:48 -0400
X-MC-Unique: dguO_8x3O1OcVMSh_hgnPg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e4a0dcee5so52013466b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 12:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711828727; x=1712433527;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YCminwhNWaoRY7+GIgboB+tGovxzzkyeTmQzRWRZumA=;
        b=ks5hNHfvpUR10DtVZS//o+kdkG2FOOcbb4KQJRKRyKHjismWsg3NXEGNIJpcs5uERI
         QuZlXvfT+ySTmVqL7+zavQyIX7YBaXPqHRCc+ls5xF/9sq/hLZ2BF+OfM2bQBC7xGuB7
         VGSUAQ1mvXb81cjRit2+BqG9ktdfDAq3lZ9NbfjJzSVq4EfNcIenSu6j7nYZstVisaK6
         G5P0omfovuDiLMljtUSA/66+LlSKxTaLOSsbfdrywzGK9L8r9lH+ZrZ0Z7HnE1QW5qiu
         7FnysblPPHhzTHOo3m9KU+eyiad4yw8Yu10IQrmJDM/jpWFn9eWsT6KqmDp5ZcHkVjix
         y8NA==
X-Forwarded-Encrypted: i=1; AJvYcCWN+QU/xrCIlbI1OoY7Q6y5b1Jk5BmMhUvGoqBt3D/XZVA8ZIgaOaMHDqT9Prix8XR5OOmysecvw1vwtrwRaMnPoLdl
X-Gm-Message-State: AOJu0YwY+O2WqE9m8Fkk9qEizujwbnnYUH7FwU9+ahr51qsI9SuKWHgH
	9pPFTKfkjbgtOquPzb79WfeRb62UygHT0eqH9F3m8Qys+/SZEsqiZuSjyWJscIWZZKDRA5BnDGf
	TXI7U5nsfOSpTjSfRrSTAQx4kLnGdA0xxLXkmRvUSmFInM8HN1Q==
X-Received: by 2002:a17:906:1c4a:b0:a4e:42f3:3c87 with SMTP id l10-20020a1709061c4a00b00a4e42f33c87mr2570756ejg.60.1711828726973;
        Sat, 30 Mar 2024 12:58:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy+R3udwrEk7qE8kYGBy3X2m7ot4CCo2QHYfwudjqdFowZGSCCNoO42aevE6XNUz55Zs9VnA==
X-Received: by 2002:a17:906:1c4a:b0:a4e:42f3:3c87 with SMTP id l10-20020a1709061c4a00b00a4e42f33c87mr2570749ejg.60.1711828726490;
        Sat, 30 Mar 2024 12:58:46 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id wk8-20020a170907054800b00a4e2d7dd2d8sm2617304ejb.182.2024.03.30.12.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 12:58:45 -0700 (PDT)
Message-ID: <1296cfd8-3986-4c2f-be94-771ae3fb84f2@redhat.com>
Date: Sat, 30 Mar 2024 20:58:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 09/29] KVM: SEV: Add initial SEV-SNP support
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-10-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
> new hardware-based security protection. SEV-SNP adds strong memory
> encryption and integrity protection to help prevent malicious
> hypervisor-based attacks such as data replay, memory re-mapping, and
> more, to create an isolated execution environment.
> 
> Define a new KVM_X86_SNP_VM type which makes use of these capabilities
> and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
> helper to check whether SNP is enabled.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/svm.h      |  3 ++-
>   arch/x86/include/uapi/asm/kvm.h |  1 +
>   arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
>   arch/x86/kvm/svm/svm.c          |  3 ++-
>   arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
>   arch/x86/kvm/x86.c              |  2 +-
>   6 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 728c98175b9c..544a43c1cf11 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>   
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   
> -#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
> +#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
> +#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>   
>   struct vmcb_seg {
>   	u16 selector;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 51b13080ed4b..725b75cfe9ff 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -868,5 +868,6 @@ struct kvm_hyperv_eventfd {
>   #define KVM_X86_SW_PROTECTED_VM	1
>   #define KVM_X86_SEV_VM		2
>   #define KVM_X86_SEV_ES_VM	3
> +#define KVM_X86_SNP_VM		4
>   
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1e65f5634ad3..3d9771163562 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
>   static bool sev_es_enabled = true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   
> +/* enable/disable SEV-SNP support */
> +static bool sev_snp_enabled;
> +
>   /* enable/disable SEV-ES DebugSwap support */
>   static bool sev_es_debug_swap_enabled = true;
>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
> @@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   	sev->es_active = es_active;
>   	sev->vmsa_features = data->vmsa_features;
>   
> +	if (vm_type == KVM_X86_SNP_VM)
> +		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
> +
>   	ret = sev_asid_new(sev);
>   	if (ret)
>   		goto e_no_asid;
> @@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		return -EINVAL;
>   
>   	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> -	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
> +	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM &&
> +	    kvm->arch.vm_type != KVM_X86_SNP_VM)
>   		return -EINVAL;
>   
>   	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
> @@ -2297,11 +2304,16 @@ void __init sev_set_cpu_caps(void)
>   		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
>   		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
>   	}
> +	if (sev_snp_enabled) {
> +		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +	}
>   }
>   
>   void __init sev_hardware_setup(void)
>   {
>   	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	bool sev_snp_supported = false;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> @@ -2382,6 +2394,7 @@ void __init sev_hardware_setup(void)
>   	sev_es_asid_count = min_sev_asid - 1;
>   	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>   	sev_es_supported = true;
> +	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>   
>   out:
>   	if (boot_cpu_has(X86_FEATURE_SEV))
> @@ -2394,9 +2407,15 @@ void __init sev_hardware_setup(void)
>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>   			sev_es_supported ? "enabled" : "disabled",
>   			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
> +		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> +			sev_snp_supported ? "enabled" : "disabled",
> +			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>   
>   	sev_enabled = sev_supported;
>   	sev_es_enabled = sev_es_supported;
> +	sev_snp_enabled = sev_snp_supported;
> +
>   	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
>   	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>   		sev_es_debug_swap_enabled = false;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0f3b59da0d4a..2c162f6a1d78 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4890,7 +4890,8 @@ static int svm_vm_init(struct kvm *kvm)
>   
>   	if (type != KVM_X86_DEFAULT_VM &&
>   	    type != KVM_X86_SW_PROTECTED_VM) {
> -		kvm->arch.has_protected_state = (type == KVM_X86_SEV_ES_VM);
> +		kvm->arch.has_protected_state =
> +			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
>   		to_kvm_sev_info(kvm)->need_init = true;
>   	}
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 157eb3f65269..4a01a81dd9b9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
>   #endif
>   }
>   
> +static __always_inline bool sev_snp_guest(struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_AMD_SEV
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
> +	       !WARN_ON_ONCE(!sev_es_guest(kvm));
> +#else
> +	return false;
> +#endif
> +}
> +
>   static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
>   {
>   	vmcb->control.clean = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 64eda7949f09..f85735b6235d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12603,7 +12603,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	kvm->arch.vm_type = type;
>   	kvm->arch.has_private_mem =
> -		(type == KVM_X86_SW_PROTECTED_VM);
> +		(type == KVM_X86_SW_PROTECTED_VM || type == KVM_X86_SNP_VM);
>   
>   	ret = kvm_page_track_init(kvm);
>   	if (ret)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


