Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56ED67F07A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjA0Vg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjA0Vg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:36:58 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651402A175;
        Fri, 27 Jan 2023 13:36:57 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l35-20020a05600c1d2300b003dc4634a466so244789wms.4;
        Fri, 27 Jan 2023 13:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjzq5k6eWg1I0/GMAp2LeFAGPD0xEfbPD6kNUwzQn8A=;
        b=mqqjWersLhfnnFg/Gkqe7Zf3VibhxN0tDukAlSoRZ1/AEXL8BL+LplnUwCVPmWvMMS
         OX9+qM9EkFPZtMpiAKG6VdZ0W68bwn3lMYc+oFu8ZDiOGYOZ/f0y+Lta5WBpPlDPDQJJ
         6qlUeCfcP7oUgOkNsYUuw0dAG9Gkjy7FojaKnNIXueNkiIco+Kv5qskhYKJuwvD1ArmQ
         /IoRmLePJOyWeuTGXU9/NOafvbpbtps62bM2VWLxX04jkRELtw31FWOgC8XHGP739I5n
         gjEVQiywRy5jDySwPLutvKNUQPrlfv5uHtzoiu4MtQV8KuBgmyZ6uqQx9ERRR+ZzDfBx
         1icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjzq5k6eWg1I0/GMAp2LeFAGPD0xEfbPD6kNUwzQn8A=;
        b=0YiuWaHt0hwAen26m+EeTI9EhGu8jMEIF/sk/T6pWolpKkYFLkW71P+ET6gsFxDkgD
         p1VhCb6VPkID5Y7WoAI4MEjz0Om66Dhfw3VfLigOgMF9DSDKu6y/bjFezTywPMxG13Tu
         v43H9rqzZIOpWaH9g4r20Du20AlBLhYXCSm+ZPYCALHxuKCxa30XTzMJFY62o6nEQ5Fb
         KgzAHsOep1FJcTPPaN3qIzNXZ3fdwoCtFL/VWWRI7mgW7X/Mfhcuvs7ojcB2QCBliDGU
         UfCffvvo6nffqvPkplLx+PguSsmpKUMoKWz69uHl2qFzdtZTaWnyaTv7rEBBYPFDfkNE
         iTNw==
X-Gm-Message-State: AO0yUKXQb1TPGajldNRhkONhJdOjNKqurQbToaNd3Bg6VxxLZPLf/Nzr
        NAODuPX6twEOWwFyiiQ7GBY=
X-Google-Smtp-Source: AK7set8Pp4tv0182n/GQp7PzspRCykcbjXnPJBNjmaMDjFFHpobvlRLVqA0F6RTTSKBcgI2XIhPeqQ==
X-Received: by 2002:a05:600c:1c02:b0:3dc:3b1a:5d2d with SMTP id j2-20020a05600c1c0200b003dc3b1a5d2dmr910363wms.0.1674855415880;
        Fri, 27 Jan 2023 13:36:55 -0800 (PST)
Received: from localhost (95-172-185-203.cpe.netmadeira.com. [95.172.185.203])
        by smtp.gmail.com with ESMTPSA id t1-20020a05600c41c100b003dc47d458cdsm81138wmh.15.2023.01.27.13.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 13:36:55 -0800 (PST)
Date:   Fri, 27 Jan 2023 23:36:52 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kai.huang@intel.com
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20230127233513.0000367c@gmail.com>
In-Reply-To: <Y9Fj/vgPEzfU1eof@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
        <20230125112434.0000512a@gmail.com>
        <Y9Fj/vgPEzfU1eof@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Jan 2023 17:22:08 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Jan 25, 2023, Zhi Wang wrote:
> > On Thu, 12 Jan 2023 08:31:38 -0800
> > isaku.yamahata@intel.com wrote:
> > 
> > This refactor patch is quite hacky.
> > 
> > Why not change the purpose of vcpu->arch.mmu_shadow_page.gfp_zero and let the
> > callers respect that the initial value of spte can be configurable? It will be
> > generic and not TDX-specific, then kvm_init_shadow_page() is not required,
> > mmu_topup_shadow_page_cache() can be left un-touched as the refactor can cover
> > other architectures.
> > 
> > 1) Let it store the expected nonpresent value and rename it to nonpresent_spte.
> 
> 
> I agree that handling this in the common code would be cleaner, but repurposing
> gfp_zero gets kludgy because it would require a magic value to say "don't initialize
> the data", e.g. x86's mmu_shadowed_info_cache isn't pre-filled.
> 
> And supporting a custom 64-bit init value for kmem_cache-backed caches would require
> restricting such caches to be a multiple of 8 bytes in size.
> 
> How about this?  Lightly tested.
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 25 Jan 2023 16:55:01 +0000
> Subject: [PATCH] KVM: Allow page-sized MMU caches to be initialized with
>  custom 64-bit values
>

It looks good enough so far although it only supports 64bit init value. But
it can be extended in the future. 

Just want to make sure people are thinking the same:

1) Keep the changes of SHADOW_NONPRESENT_VALUE and REMOVED_SPTE in TDX patch.
init_value stays as a generic feature in the kvm mmu cache layer. It is *not*
going to replace SHADOW_NONPRESENT_VALUE.

2) TDX kvm_x86_vcpu_create sets the SHADOW_NONPRESENT value into init_value.

3) mmu cache topping up function initializes the page according to init_value
with Sean's patch. 

> Add support to MMU caches for initializing a page with a custom 64-bit
> value, e.g. to pre-fill an entire page table with non-zero PTE values.
> The functionality will be used by x86 to support Intel's TDX, which needs
> to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
> faults from getting reflected into the guest (Intel's EPT Violation #VE
> architecture made the less than brilliant decision of having the per-PTE
> behavior be opt-out instead of opt-in).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_types.h |  1 +
>  virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 76de36e56cdf..67972db17b55 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -94,6 +94,7 @@ struct kvm_mmu_memory_cache {
>  	int nobjs;
>  	gfp_t gfp_zero;
>  	gfp_t gfp_custom;
> +	u64 init_value;
>  	struct kmem_cache *kmem_cache;
>  	int capacity;
>  	void **objects;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331..78f1e49179a7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -380,12 +380,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>  					       gfp_t gfp_flags)
>  {
> +	void *page;
> +
>  	gfp_flags |= mc->gfp_zero;
>  
>  	if (mc->kmem_cache)
>  		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> -	else
> -		return (void *)__get_free_page(gfp_flags);
> +
> +	page = (void *)__get_free_page(gfp_flags);
> +	if (page && mc->init_value)
> +		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
> +	return page;
>  }
>  
>  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> @@ -400,6 +405,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
>  		if (WARN_ON_ONCE(!capacity))
>  			return -EIO;
>  
> +		/*
> +		 * Custom init values can be used only for page allocations,
> +		 * and obviously conflict with __GFP_ZERO.
> +		 */
> +		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
> +			return -EIO;
> +
>  		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
>  		if (!mc->objects)
>  			return -ENOMEM;
> 
> base-commit: 503f0315c97739d3f8e645c500d81757dfbf76be

