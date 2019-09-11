Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA6BB00D5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfIKQEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:04:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfIKQEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:04:31 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF8E05945B
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:04:30 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id u10so1104783wrn.21
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TqFIRjlhREAoz8YjpN8dYe88dwIYbJQL75ZPqOOH1y0=;
        b=UakZUtFTednTeJ06kbVuolCL3JyTelRo6yvYQsmNxtQJRPdUeuG7U3XM8a6KLx3Kal
         iENBJf+JzNmYAPpW9h6QtXaHju6hl713HPggp4mCGXAVG4O5wCmdEh4kBwU1R3gf7B7z
         YkcJpdZ3XaTlmJZDasAgT0tANxlHxQgYlKh8FF25Rw+GnAuCoI7+IjR/G/JwDblYMQRg
         ppt1C9CxHGn2rQEbXGdKcFJfLxCmiwVPe1i4ht3UeSgPLAdbSVC5TTE0g2MeQ3kPhi4H
         55LHX8N1TS26HCSBT5MdxLXEABpylJJQtF6nDGz5GCcFX/u9xBhsHemRQEfoIvWjp+hn
         +/Rg==
X-Gm-Message-State: APjAAAVGhWiy8dXTY/H/Ky6Dt8cLQuCF8JgGsHRw2mUogJJvjZbJg7Pe
        tenks5JRqDQ1ubvH+9Qx9HEPaJAowsVSyK3d8UgI5NiF/63oSD1Q7VN11xCYPFqrJAvPsbK+8rk
        b4pyx/WdnB7QJ
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr33132455wrx.117.1568217869156;
        Wed, 11 Sep 2019 09:04:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzWmnvovTiLm3tvrrfJMks0GiIKfsG0646/Vnnd5Wdt9qCPQpQjb33RBm5S/yGU7l4VHhxXZw==
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr33132439wrx.117.1568217868874;
        Wed, 11 Sep 2019 09:04:28 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w8sm4017555wmc.1.2019.09.11.09.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:04:28 -0700 (PDT)
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
To:     =?UTF-8?B?SmnFmcOtIFBhbGXEjWVr?= <jpalecek@web.de>
Cc:     kvm@vger.kernel.org
References: <87lfvl5f28.fsf@debian>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8244ba15-2df2-2f92-cb56-2d171932eba3@redhat.com>
Date:   Wed, 11 Sep 2019 18:04:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87lfvl5f28.fsf@debian>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/19 19:42, Jiøí Paleèek wrote:
> On AMD processors, in PAE 32bit mode, nested KVM instances don't
> work. The L0 host get a kernel OOPS, which is related to
> arch.mmu->pae_root being NULL.
> 
> The reason for this is that when setting up nested KVM instance,
> arch.mmu is set to &arch.guest_mmu (while normally, it would be
> &arch.root_mmu). However, the initialization and allocation of
> pae_root only creates it in root_mmu. KVM code (ie. in
> mmu_alloc_shadow_roots) then accesses arch.mmu->pae_root, which is the
> unallocated arch.guest_mmu->pae_root.
> 
> This fix just allocates (and frees) pae_root in both guest_mmu and
> root_mmu (and also lm_root if it was allocated). The allocation is
> subject to previous restrictions ie. it won't allocate anything on
> 64-bit and AFAIK not on Intel.
> 
> See bug 203923 for details.
> 
> Signed-off-by: Jiri Palecek <jpalecek@web.de>
> Tested-by: Jiri Palecek <jpalecek@web.de>
> 
> ---
>  arch/x86/kvm/mmu.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24843cf49579..efa8285bb56d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5592,13 +5592,13 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  				 PT_PAGE_TABLE_LEVEL, lock_flush_tlb);
>  }
> 
> -static void free_mmu_pages(struct kvm_vcpu *vcpu)
> +static void free_mmu_pages(struct kvm_mmu *mmu)
>  {
> -	free_page((unsigned long)vcpu->arch.mmu->pae_root);
> -	free_page((unsigned long)vcpu->arch.mmu->lm_root);
> +	free_page((unsigned long)mmu->pae_root);
> +	free_page((unsigned long)mmu->lm_root);
>  }
> 
> -static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
> +static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  {
>  	struct page *page;
>  	int i;
> @@ -5619,9 +5619,9 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
>  	if (!page)
>  		return -ENOMEM;
> 
> -	vcpu->arch.mmu->pae_root = page_address(page);
> +	mmu->pae_root = page_address(page);
>  	for (i = 0; i < 4; ++i)
> -		vcpu->arch.mmu->pae_root[i] = INVALID_PAGE;
> +		mmu->pae_root[i] = INVALID_PAGE;
> 
>  	return 0;
>  }
> @@ -5629,6 +5629,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
>  int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
>  	uint i;
> +	int ret;
> 
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> @@ -5646,7 +5647,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> 
>  	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
> -	return alloc_mmu_pages(vcpu);
> +
> +	ret = alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
> +	if (ret)
> +		return ret;
> +
> +	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
> +	if (ret)
> +		goto fail_allocate_root;
> +
> +	return ret;
> + fail_allocate_root:
> +	free_mmu_pages(&vcpu->arch.guest_mmu);
> +	return ret;
>  }
> 
>  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> @@ -6102,7 +6115,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_unload(vcpu);
> -	free_mmu_pages(vcpu);
> +	free_mmu_pages(&vcpu->arch.root_mmu);
> +	free_mmu_pages(&vcpu->arch.guest_mmu);
>  	mmu_free_memory_caches(vcpu);
>  }
> 
> --
> 2.23.0.rc1
> 

Queued, thanks.  The goto usage is somewhat borderline, but not unheard of.

Paolo
