Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359829CF45
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbfHZMQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 08:16:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbfHZMQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 08:16:17 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D96D0368DA
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 12:16:16 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id o5so9594012wrg.15
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 05:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=yihEVjIwyc8e7SdZcMdOrs+djS3hV5KXvCxvTxZp/JU=;
        b=AOdvsYAgjesfc/yagCKmRjU7k3FR726kBj4KUpRzKQq9uNysRf0CNZsbS1v53sON4t
         WjXlb7MFHbwwFrPgeegmgFXvGaf7Hnm3liS1GJ0bP2RSPXRFViQkjYwsQtWEuwl58bNe
         jVMfi6z0ay0Ykjog5bsh8XEcOkIDYtGNcYiHi4doSVQBC6gXWxeR7JyBH5IsAYqE6ZJV
         ld3UQqHbSsrQdahMV6StpKzZDNfZj42gvRmS9INEuQJJLuV7KLJMChBLjCK1wKfLN3wX
         WdDZgKJdk91i/PEc35y6h+qwMdAqVhvRBLKM7rNjNaZNhHwCWHaSdOOEiMImKmKVxu0r
         4xHw==
X-Gm-Message-State: APjAAAUna6AM51u7YyzR3Fj4snGh6ynO+FcYhwSbvjgNW0ej/slgl93d
        9AY6Uzf+mQQh8suIb54mN/YpdTCXMqhqDJdl+SLjB9A3cAsR6Agh6oJAYWQiYwvuakmbLXCqUMH
        7BxVCbQF3sJYk
X-Received: by 2002:adf:cd81:: with SMTP id q1mr17719344wrj.16.1566821775552;
        Mon, 26 Aug 2019 05:16:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy6Bh4aiWyQko30UrpBHK03hNUYfx3ZrwL9U4pmXYWAgTbITsr6a1cPWA4UlQhX0arIt187+Q==
X-Received: by 2002:adf:cd81:: with SMTP id q1mr17719311wrj.16.1566821775317;
        Mon, 26 Aug 2019 05:16:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q124sm12302580wma.33.2019.08.26.05.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 05:16:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     =?utf-8?B?SmnFmcOtIFBhbGXEjWVr?= <jpalecek@web.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
In-Reply-To: <87lfvl5f28.fsf@debian>
References: <87lfvl5f28.fsf@debian>
Date:   Mon, 26 Aug 2019 14:16:14 +0200
Message-ID: <87lfvgm8a9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiří Paleček <jpalecek@web.de> writes:

> On AMD processors, in PAE 32bit mode, nested KVM instances don't
> work. The L0 host get a kernel OOPS, which is related to
> arch.mmu->pae_root being NULL.

The date on the message is "Date: Sat, 22 Jun 2019 19:42:04 +0200" and I
got a bit confused at first.

>
> The reason for this is that when setting up nested KVM instance,
> arch.mmu is set to &arch.guest_mmu (while normally, it would be
> &arch.root_mmu).

MMU switch to guest_mmu happens when we're about to start L2 guest - and
we switch back to root_mmu when we want to execute L1 again (e.g. after
vmexit) so this is not a one-time thing ('when setting up nested KVM
instance' makes me think so).

> However, the initialization and allocation of
> pae_root only creates it in root_mmu. KVM code (ie. in
> mmu_alloc_shadow_roots) then accesses arch.mmu->pae_root, which is the
> unallocated arch.guest_mmu->pae_root.

Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")

>
> This fix just allocates (and frees) pae_root in both guest_mmu and
> root_mmu (and also lm_root if it was allocated). The allocation is
> subject to previous restrictions ie. it won't allocate anything on
> 64-bit and AFAIK not on Intel.

Right, it is only NPT 32 bit which uses that (and it's definitely
undertested).

>
> See bug 203923 for details.

Personally, I'd prefer this to be full link
https://bugzilla.kernel.org/show_bug.cgi?id=203923
as there are multiple bugzillas out threre.

>
> Signed-off-by: Jiri Palecek <jpalecek@web.de>
> Tested-by: Jiri Palecek <jpalecek@web.de>

This is weird. I always thought "Signed-off-by" implies some form of
testing (unless stated otherwise) :-)


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

(personal preference) here you're just jumping over 'return' so I'd
prefer this to be written as:

        ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
        if (!ret)
            return 0;
 
        free_mmu_pages(&vcpu->arch.guest_mmu);
        return ret;

and no label/goto required.

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

-- 
Vitaly
