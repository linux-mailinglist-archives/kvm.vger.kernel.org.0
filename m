Return-Path: <kvm+bounces-13157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1951C892D6A
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C50C2282B68
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94D94AEF8;
	Sat, 30 Mar 2024 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/bwkp9z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D31119F
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711832738; cv=none; b=RgcMHBL5TppxCypWP+MeFLHyN6Y50n0RFy8ilRxIwVyyTmkmLr2SdafFzS0/QYhS/Fa1N57WpDpUSl7eNGZvYv1vB6pIfwZzF5Mt0PTZE07unVC7oEUF3tHVMODS8y9p8xDv2qzcKUTZkNDh1d6XmBUXLTmozEndaq+EV3J20zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711832738; c=relaxed/simple;
	bh=3Zs96oVvSrL1EcRD7qOwXkqb76tHEKhezfgjNzTnj6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PNiXqlxdVW1AtHUYT9Lox0RqQ0gOqAH/C12a0WaJ8YJuT3b0WIe95P80NQpBMhIOJjfns+VZLYyFX2C6VDWeA8sxfBd+d0mCSzv9oWwE/aBPYyF9T3LwDu420y65l1CuvyN6jvX1SPtSIwerOVlpelaA7xn5Wl3AcKAsdyXFoig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/bwkp9z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711832735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
	b=Z/bwkp9zeM6aOZHHVlrzAtv4msVYgJudKoGo3HvWI//S6NfoTmg/NiA8TY1vM4ge5cfxPd
	ZY9JuTDXhqV0UWWfzd8gDVJ4kRYtrhtlVmkcfOojWzgkvXJR9f+TO/GsSye690KMIMW9eo
	L1eXzKqiYeKFwr97odtklpwEa0Z3iPw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-GrF2kdagN9aVR0Ep795vZQ-1; Sat, 30 Mar 2024 17:05:33 -0400
X-MC-Unique: GrF2kdagN9aVR0Ep795vZQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e4a0dcee5so55234366b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711832731; x=1712437531;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
        b=RnpHZC+ZE0uG/fB2COMZLRVQFqwYQujWF2OgEcNc/7KMMPiUvZWkpzPfBVgXqzG7XP
         RJuZnGQRFbGG0FlvCRfHH+czWIMZHWk/NulrkY61K6Shq4LQLaWMK5kJXfqmR0uVwAE2
         pRiiief7uLtmCf2y+1dOuosjUu6snSU7uhAAJaDnuVsxcRdvD7+rXqCOpK1SrWS/5hS/
         +wv4HohG6dZHWeqMjGfZd4w9tEiZjIL67aVpFDQpUJcAtnXMy7N+dxl4ANpXKRIf+dAj
         y6PO/ZkD+rMvAN3qJ4q6bAZTRP40gh1uej7/dJVdNsJzaZoeTnJWptDEMYfq3wISBLUk
         FpYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmapTY4WRjne7TrJpioNGm157K7l92NI0vkXpwGw/dRQCiL7HXThx1rhAAySIgTjMYQWh9F16OODdGdNeoFj8eSHke
X-Gm-Message-State: AOJu0Yy5mGnc+fyEkQUXvsbrU2f3Ns4/6CU6ZDVUTvlejifN/XtIn7kc
	3RD5xS7PNLQPqUWKUehWBB2yJWzaGxxosWLB4A6QFu6GLftPSZ+A9os0f2SpG/s2NlRj2Ixnyv8
	Tnl02rGW/lX+e+jnWSaVdhLgi0J0eaggLB8bKXvK+64vsMdcQsHQpwE9gHQ==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204855ejz.8.1711832731490;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTeU1CiYPB2ByqnXfgbHYLBnkSUxAq1ZyFzRHCPzV8G1WZItagAlUo3C1OjOvbzmRD+zOCDA==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204815ejz.8.1711832731102;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id lb14-20020a170906adce00b00a4e57805d79sm513857ejb.181.2024.03.30.14.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:05:30 -0700 (PDT)
Message-ID: <a0799504-385b-40d8-a84c-eddb1bae930d@redhat.com>
Date: Sat, 30 Mar 2024 22:05:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializing
 private pages
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-22-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-22-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
>   	select KVM_GENERIC_PRIVATE_MEM
> +	select HAVE_KVM_GMEM_PREPARE
>   	help
>   	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
>   	  with Encrypted State (SEV-ES) on AMD processors.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9ea13c2de668..e1f8be1df219 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn = start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
> +				 __func__, pfn, start, end, rmp_level);
> +			return false;
> +		}
> +
> +		pfn++;
> +	}
> +
> +	return true;
> +}
> +
> +static u8 max_level_for_order(int order)
> +{
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
> +{
> +	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +
> +	/*
> +	 * If this is a large folio, and the entire 2M range containing the
> +	 * PFN is currently shared, then the entire 2M-aligned range can be
> +	 * set to private via a single 2M RMP entry.
> +	 */
> +	if (max_level_for_order(order) > PG_LEVEL_4K &&
> +	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
> +		return true;
> +
> +	return false;
> +}
> +
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level = PG_LEVEL_2M;
> +		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level = PG_LEVEL_4K;
> +		pfn_aligned = pfn;
> +		gfn_aligned = gfn;
> +	}
> +
> +	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare = sev_gmem_prepare,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	return 0;
> +}
>   
>   #endif
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type == KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>   		gfn = slot->base_gfn + index - slot->gmem.pgoff;
>   		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


