Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1E3A7FD3
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 11:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfIDJxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 05:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfIDJxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 05:53:55 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D61DDC054C58
        for <kvm@vger.kernel.org>; Wed,  4 Sep 2019 09:53:54 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id c1so11718829wrb.12
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 02:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MQ0ORt+LMxvMNt0gOxb01vr7KJbfbZAZWcqX/gvXBAQ=;
        b=H/u5fPeJ9LkeGvlwcRNSdTZvHUNO3tnDKqJSlCYAXu72eZZv7CO4y6p427xqkcm90+
         Cw9fMG5teIyWFCjr5DVn4gCcV/iv4eaXQt3PQS/8W1E/cEAtQYxljfYG8AMnGZ4idBD2
         2anAZzucRs7AqKZ56fx4R46Bl7rX8IJZgRcHtntJOZO8MGLBv6Aw1svJGk6EDHE8dALp
         ZU+mmM2gcOgw4R7dof8k21XsDCLUqQBX5V/XJVSENgSfnJMeb9dovC09zjzUeamgeUVT
         TSAS2bgCpO5BW22UCB0fCEBTjPU7youMhxQ8neYHkKzGkHLP+d2PELMBlXfrBkQYE3tO
         /xuw==
X-Gm-Message-State: APjAAAXxElfEHcKkpQM4SrpkBTczvp3CBrcneO5lXjVU5Pw4y3VSKe/Z
        SGm8bcjmjEViu9My9UAp8t4xsGg/YvSzbTfj9RDhWvGTwBQ37D86M6Ui1/rzCAa1fdCvbcO6S9P
        i1DKk4rDCF1QQ
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr1640577wmh.141.1567590833590;
        Wed, 04 Sep 2019 02:53:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz9A60+P3s64/Houz953lqsuqdmaa6s/hVkL96GaiJh9id8MMHQU3sJV09BEAnD+vgwmQrfDA==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr1640561wmh.141.1567590833289;
        Wed, 04 Sep 2019 02:53:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l62sm5094137wml.13.2019.09.04.02.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 02:53:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     =?utf-8?B?SmnFmcOtIFBhbGXEjWVr?= <jpalecek@web.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
In-Reply-To: <87y2z7rmgw.fsf@debian>
References: <87y2z7rmgw.fsf@debian>
Date:   Wed, 04 Sep 2019 11:53:51 +0200
Message-ID: <87woeojsk0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiří Paleček <jpalecek@web.de> writes:

>

Your Subject line needs to be 'PATCH v2' as you're sending an updated
version.

> On AMD processors, in PAE 32bit mode, nested KVM instances don't
> work. The L0 host get a kernel OOPS, which is related to
> arch.mmu->pae_root being NULL.
>
> The reason for this is that when running nested KVM instance, arch.mmu
> is set to &arch.guest_mmu (while normally, it would be
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
> See https://bugzilla.kernel.org/show_bug.cgi?id=203923 for details.
>
> Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
> Signed-off-by: Jiri Palecek <jpalecek@web.de>
> Tested-by: Jiri Palecek <jpalecek@web.de>

Well, this was commented on in v1 :-)

> ---
>  arch/x86/kvm/mmu.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24843cf49579..6882963374e7 100644
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
> @@ -5646,7 +5647,16 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
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
> +		free_mmu_pages(&vcpu->arch.guest_mmu);
> +
> +	return ret;
>  }
>
>  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> @@ -6102,7 +6112,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
