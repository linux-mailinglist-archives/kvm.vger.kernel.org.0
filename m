Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49502528776
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbiEPOt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244670AbiEPOtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:49:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1E12EA22
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:49:24 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so123298pjb.1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JQA1CAM9EcNlBvTilQjyrtgzNtDUyC6fSOZfEYDNvqw=;
        b=Ofiyf21IY/JWacyt2sm4b5JqGuuC4xCXQfaviI0AIJLTpd/Oflx9mf4AgU0jPq/he9
         P8q38uagOiSBPUbhhVCO3xI8wFi0ws+7XMFVjOWAvczYAZ33OeUVSPMA8IVoEmfTxavH
         +Jh+8dMsZkVLYRmnNIWBfjKQFw8nAEdqSzfrse3j8qFBus5uBYj6xSSRx79YbRUTr+10
         8B536NcDWQLKPoDEy+LDdo2lk4qv4nAC0OGBKT90rawf8LvkqU6R1Si7o1p8XjJnsjqN
         GT9r+zrdlv0EmZI6VxVd3V7k7fmzQe0uepCQluN6+sScjYoFjch6hclfAYUVyNMTtadf
         qwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JQA1CAM9EcNlBvTilQjyrtgzNtDUyC6fSOZfEYDNvqw=;
        b=M2EkviKZ05OdNWohzzsHm/iva20Ic1NiLFtikAvvm+c8/8XMOvxzYDwtpaHycb5fxi
         uJzOEsUfAqa8HrRAtgfojz9ZB9Sk5sFKFBViXtPw7ZltWDzkHDJOWUWsWK9BXbZDBNJt
         jU/DrKkntyAIP6mSB+iTqY61BoEpT8jPMg2LggRMmeJZMH6+UMi+r92D/6+3q1JHi5XP
         g1S90/0GL1fGwoMHU2fnhvZ0yGIrFUwfshB/vgu/oTFrVmvsYU7JISoZbmVBZ3/ArxPf
         +ntNvmNOaCfyKiGWVvmCVsYr05SgHEDLv3Ro87hLw5Bsk4TrsBZ7nbf7c/H+O/QRKQrO
         REAw==
X-Gm-Message-State: AOAM533iMbsxMryd2D3w5itNmONQGX/yuJpupDvF4gL2uexvTiW83CU7
        4PL+PW0utOHntNGv9fYJDSuIkQ==
X-Google-Smtp-Source: ABdhPJzWW2D4IvLQy4A8frhcp8tSvPwynf61rQPofCvBwMRNuG9eI1HYcmZ1MomMsjCVF1GmR1hHDA==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr17896959plk.50.1652712563657;
        Mon, 16 May 2022 07:49:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id jc13-20020a17090325cd00b001618b4d86b3sm1609217plb.180.2022.05.16.07.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 07:49:23 -0700 (PDT)
Date:   Mon, 16 May 2022 14:49:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YoJkb7oMEz0v1dnp@google.com>
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513202819.829591-21-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022, David Matlack wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..2f2ef6b60ff4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>  	phys_addr_t addr;
>  	int ret = 0;
> -	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +	struct kvm_mmu_memory_cache cache = {
> +		.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +		.gfp_zero = __GFP_ZERO,

I dislike requiring all users to specificy the capacity.  It largely defeats the
purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
really doesn't care all that much about the details.

Rather than force the capacity to be set before topup, what about adding a custom
capacity topup helper?  That allows keeping a default capacity, better documents
the caches that are special, and provides an opportunity to sanity check that the
capacity isn't incorrectly changed by the user.  

And then I believe this code becomes:

	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };

E.g. (completely untested)

static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
					int capacity, int min)
{
	gfp_t gfp = GFP_KERNEL_ACCOUNT;
	void *obj;

	if (mc->nobjs >= min)
		return 0;

	if (likely(mc->capacity)) {
		if (WARN_ON_ONCE(mc->capacity != capacity || !mc->objects))
			return -EIO;
	} else {
		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
		if (!mc->objects)
			return -ENOMEM;

		mc->capacity = capacity;
	}

	while (mc->nobjs < mc->capacity) {
		obj = mmu_memory_cache_alloc_obj(mc, gfp);
		if (!obj)
			return mc->nobjs >= min ? 0 : -ENOMEM;
		mc->objects[mc->nobjs++] = obj;
	}
	return 0;
}

int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
{
	const int capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;

	return __kvm_mmu_topup_memory_cache(mc, capacity, min);
}

int kvm_mmu_topup_custom_memory_cache(struct kvm_mmu_memory_cache *mc,
				      int capacity)
{
	return __kvm_mmu_topup_memory_cache(mc, capacity, capacity);
}

