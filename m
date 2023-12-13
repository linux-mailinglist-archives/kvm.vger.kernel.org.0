Return-Path: <kvm+bounces-4386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F30811D34
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86FE21F210EA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F296415B;
	Wed, 13 Dec 2023 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cup2IQwg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB30DC
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702493146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W6FQ857DrbeP82Sds80Qy0ykClNS9Wo10FW4yj5khes=;
	b=cup2IQwgFYFNUEUxP1eX/hgXKadT1LvRNuDcIMTSWvo2BopmAItn/f09BFiWPJNHS9jblN
	DNQQ7x4J7TbTS01a1l2ibp+Ya40kVUUCVEXUjdGKpxAukdyz8jpD9BBJQ81smlsTDb+Pli
	g4Mzmg6mVKQa4iUf9fHAjCCQZik72cQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-JR4grwMRMFOrVQmwLm1LmQ-1; Wed, 13 Dec 2023 13:45:45 -0500
X-MC-Unique: JR4grwMRMFOrVQmwLm1LmQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-551da4f37baso891843a12.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:45:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702493144; x=1703097944;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6FQ857DrbeP82Sds80Qy0ykClNS9Wo10FW4yj5khes=;
        b=UunTtJ0vSTh65c7m5kEoMjE9in3icqPfpdXFse4JW5p1O42IcA/KmrhViMmOt0Qqqf
         H42dgMVvapun8AIQ+l352eDygfg+XANpygEeRniWjEh8c+kdmF9ZAN139NehYSNd5j0C
         ZYamGbnE+ECvfPnW5jOS1fOnTuJNL1++V2dxAUtPSgfyaLpnSQ6io+eK/eL5kFzBwTLi
         i73/VPgg9tj3im9XAliGXYKpl1t5cbEtA5AYbsINjIh1ShIS+m9R2fahP2cWBDaw9lqr
         Lk06GlrNLzGrWqvz2hndeKNn5qdrmg/owPZtm3b775Vr3mr5y2KtpL5dqPx9/dmXkW2v
         XtDA==
X-Gm-Message-State: AOJu0YwI4voNEKqqr2IPK3IzYhdSxEvcDlzG1KR3wKAyiVWwK6Gwd5Io
	jPiGGxT/kxKAhSlrN2FH58yPW60Gqs1GnekmsBFodvd2S5kjDkRaITDXwYJEcr8roj+xZX/jG8V
	6nza2+JpgDZZ/
X-Received: by 2002:a17:907:9815:b0:a08:291c:62c9 with SMTP id ji21-20020a170907981500b00a08291c62c9mr5195463ejc.5.1702493143942;
        Wed, 13 Dec 2023 10:45:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKjpQf2TwqPPzPCiRhO+rs0Ty7nBrbEfxbl+4ROQnFliFrZhXtWWO3zx7mzt0F8wkwmUvOsA==
X-Received: by 2002:a17:907:9815:b0:a08:291c:62c9 with SMTP id ji21-20020a170907981500b00a08291c62c9mr5195454ejc.5.1702493143555;
        Wed, 13 Dec 2023 10:45:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id vk5-20020a170907cbc500b00a1ce56f7b16sm8240761ejc.71.2023.12.13.10.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 10:45:42 -0800 (PST)
Message-ID: <f1e37bbf-a98c-4090-bc48-05bdae58cbf9@redhat.com>
Date: Wed, 13 Dec 2023 19:45:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Content-Language: en-US
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
 tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-24-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231016132819.1002933-24-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 15:27, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing pages as "in-use" via a reserved bit in the corresponding RMP
> entry after a successful VMRUN. This is done for _all_ VMs, not just
> SNP-Active VMs.
> 
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will
> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or
> AVIC backing page for similar reasons. Add a generic allocator that will
> ensure that the page returns is not hugepage (2mb or 1gb) and is safe to
> be used when SEV-SNP is enabled. Also implement similar handling for the
> VMCB/VMSA pages of nested guests.
> 
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: squash in nested guest handling from Ashish]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Based on the discussion with Borislav, please move this earlier in the 
series, before patch 6.

Paolo

> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  1 +
>   arch/x86/kvm/lapic.c               |  5 ++++-
>   arch/x86/kvm/svm/nested.c          |  2 +-
>   arch/x86/kvm/svm/sev.c             | 33 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c             | 17 ++++++++++++---
>   arch/x86/kvm/svm/svm.h             |  1 +
>   7 files changed, 55 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index f1505a5fa781..4ef2eca14287 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -136,6 +136,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>   KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
>   KVM_X86_OP_OPTIONAL(gmem_invalidate)
> +KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>   
>   #undef KVM_X86_OP
>   #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fa401cb1a552..a3983271ea28 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1763,6 +1763,7 @@ struct kvm_x86_ops {
>   
>   	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dcd60b39e794..631a554c0f48 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2810,7 +2810,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>   
>   	vcpu->arch.apic = apic;
>   
> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +	if (kvm_x86_ops.alloc_apic_backing_page)
> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> +	else
> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   	if (!apic->regs) {
>   		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
>   		       vcpu->vcpu_id);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dd496c9e5f91..1f9a3f9eb985 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1194,7 +1194,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
>   	if (svm->nested.initialized)
>   		return 0;
>   
> -	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
>   	if (!vmcb02_page)
>   		return -ENOMEM;
>   	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 088b32657f46..1cfb9232fc74 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3211,3 +3211,36 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   		break;
>   	}
>   }
> +
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long pfn;
> +	struct page *p;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +	/*
> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> +	 * or AVIC backing page. The recommeded workaround is to not use the
> +	 * hugepage.
> +	 *
> +	 * Allocate one extra page, use a page which is not 2mb aligned
> +	 * and free the other.
> +	 */
> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	if (!p)
> +		return NULL;
> +
> +	split_page(p, 1);
> +
> +	pfn = page_to_pfn(p);
> +	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> +		__free_page(p++);
> +	else
> +		__free_page(p + 1);
> +
> +	return p;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1e7fb1ea45f7..8e4ef0cd968a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -706,7 +706,7 @@ static int svm_cpu_init(int cpu)
>   	int ret = -ENOMEM;
>   
>   	memset(sd, 0, sizeof(struct svm_cpu_data));
> -	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	sd->save_area = snp_safe_alloc_page(NULL);
>   	if (!sd->save_area)
>   		return ret;
>   
> @@ -1425,7 +1425,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>   	svm = to_svm(vcpu);
>   
>   	err = -ENOMEM;
> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>   	if (!vmcb01_page)
>   		goto out;
>   
> @@ -1434,7 +1434,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>   		 * SEV-ES guests require a separate VMSA page used to contain
>   		 * the encrypted register state of the guest.
>   		 */
> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		vmsa_page = snp_safe_alloc_page(vcpu);
>   		if (!vmsa_page)
>   			goto error_free_vmcb_page;
>   
> @@ -4876,6 +4876,16 @@ static int svm_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page = snp_safe_alloc_page(vcpu);
> +
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>   static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.name = KBUILD_MODNAME,
>   
> @@ -5007,6 +5017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c13070d00910..b7b8bf73cbb9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -694,6 +694,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>   
>   /* vmenter.S */
>   


