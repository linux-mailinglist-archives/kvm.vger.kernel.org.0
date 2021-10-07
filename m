Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637F4256B5
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhJGPiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 11:38:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhJGPiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 11:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633620968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uAG2gSfGivkFqPdUcOcMoHWNK+3LPbOEp8js+1JX9D0=;
        b=Ngc4qfxRbpgW1MYExDoqOvd2JJSkmJzFXoxzUbzeDX4UBAciUbhbUcP/YYokLq6vIjW41M
        RUhnxppbMq/HBEpvvh/O3eFvblJbPb/Lz8Ru9mh/5+J0889URiLKlRgkyGswegN2CH+QvH
        C5n2nIZXk6R6uBRBdkDIt3/pH53oYw8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-P7NDkXGVP56aJt0cyhf0Ig-1; Thu, 07 Oct 2021 11:36:06 -0400
X-MC-Unique: P7NDkXGVP56aJt0cyhf0Ig-1
Received: by mail-wr1-f69.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso5018048wrg.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 08:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uAG2gSfGivkFqPdUcOcMoHWNK+3LPbOEp8js+1JX9D0=;
        b=KZqWJJfOCIKa+4U0SEWAOVjN6YeKNL8YXTkBkFLazdiltEv8JdK5wyvFe4VzsSIW1E
         ZJhHWtCd350Y1pxaksuv4QX0QCBk4XzstyE/YrjffCHWMCwKrtlR7Ro9mNLXKgOG74hG
         MgkZicQEZaP1cZuzDy7FzCdVVF0S+a3BJwnCkJA67oYUdrIigDhAqV5vDTvEISThoLil
         JXuW4Od5nsIdB4t1z0a1tSZaW+ZzXgN4ngEvj80B5sZDhdWeVHRxvsB6c/xLBmOVVUJ8
         IbaT4qKOdpQeIMlm6ux3i0sggVYrYFL0cddW6hnxuW9PNuqoUzByNpEpNPOKCaw0EVaG
         tPjg==
X-Gm-Message-State: AOAM530VF6p66J5er2yS4bnu9b6kysoyDtt5ZUK7sNmvxGmwWj1t2jnJ
        SFKqPez+NQXSZ0lEVYBKQP/OiFdao3PK7ZemKW3YuwoY/UjNy/luwIi5TkiuzODpik6kcJMJfTL
        6G/OhT8pYT7Y8
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr6309718wrw.226.1633620964989;
        Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOKhb13upVjPdpIgw2cu/kQXMovUZ4V+HV98DQtzXtkqpTYLB5D5upVw8rRtM4pTWx6MSkgA==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr6309692wrw.226.1633620964837;
        Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id z1sm20480911wrt.41.2021.10.07.08.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
Date:   Thu, 7 Oct 2021 17:36:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 13/16] arm64: Implement ioremap/iounmap hooks calling
 into KVM's MMIO guard
Message-ID: <20211007153602.ty72qbglrwbphokj@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-14-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-14-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:46PM +0100, Marc Zyngier wrote:
> Implement the previously defined ioremap/iounmap hooks for arm64,
> calling into KVM's MMIO guard if available.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/mm/ioremap.c | 112 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index b7c81dacabf0..5334cbdc9f64 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -9,13 +9,125 @@
>   * Copyright (C) 2012 ARM Ltd.
>   */
>  
> +#define pr_fmt(fmt)	"ioremap: " fmt
> +
>  #include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
> +#include <linux/slab.h>
>  #include <linux/io.h>
> +#include <linux/arm-smccc.h>
>  
>  #include <asm/fixmap.h>
>  #include <asm/tlbflush.h>
> +#include <asm/hypervisor.h>
> +
> +struct ioremap_guard_ref {
> +	refcount_t	count;
> +};
> +
> +static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
> +static DEFINE_XARRAY(ioremap_guard_array);
> +static DEFINE_MUTEX(ioremap_guard_lock);
> +
> +void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
> +{
> +	if (!static_branch_unlikely(&ioremap_guard_key))
> +		return;
> +
> +	if (pfn_valid(__phys_to_pfn(phys_addr)))
> +		return;
> +
> +	mutex_lock(&ioremap_guard_lock);
> +
> +	while (size) {
> +		u64 pfn = phys_addr >> PAGE_SHIFT;
> +		struct ioremap_guard_ref *ref;
> +		struct arm_smccc_res res;
> +
> +		ref = xa_load(&ioremap_guard_array, pfn);
> +		if (ref) {
> +			refcount_inc(&ref->count);
> +			goto next;
> +		}
> +
> +		/*
> +		 * It is acceptable for the allocation to fail, specially
> +		 * if trying to ioremap something very early on, like with
> +		 * earlycon, which happens long before kmem_cache_init.
> +		 * This page will be permanently accessible, similar to a
> +		 * saturated refcount.
> +		 */
> +		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
> +		if (ref) {
> +			refcount_set(&ref->count, 1);
> +			if (xa_err(xa_store(&ioremap_guard_array, pfn, ref,
> +					    GFP_KERNEL))) {
> +				kfree(ref);
> +				ref = NULL;
> +			}
> +		}
> +
> +		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
> +				  phys_addr, prot, &res);

OK, I see this follows the document and passes prot in x2, even though the
hypercall implementation doesn't look at it [yet].

> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn_ratelimited("Failed to register %llx\n",
> +					    phys_addr);
> +			xa_erase(&ioremap_guard_array, pfn);
> +			kfree(ref);
> +			goto out;
> +		}
> +
> +	next:
> +		size -= PAGE_SIZE;
> +		phys_addr += PAGE_SIZE;

Looks like we're assuming the guard granule to be PAGE_SIZE here. Looking
ahead at the next patch, I see it must be PAGE_SIZE, because if the info
hypercall doesn't have a matching value, then mmio guarding doesn't
happen at all. Maybe it should be documented that for this feature the
host and guest must have matching page sizes.

> +	}
> +out:
> +	mutex_unlock(&ioremap_guard_lock);
> +}
> +
> +void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
> +{
> +	if (!static_branch_unlikely(&ioremap_guard_key))
> +		return;
> +
> +	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
> +
> +	mutex_lock(&ioremap_guard_lock);
> +
> +	while (size) {
> +		u64 pfn = phys_addr >> PAGE_SHIFT;
> +		struct ioremap_guard_ref *ref;
> +		struct arm_smccc_res res;
> +
> +		ref = xa_load(&ioremap_guard_array, pfn);
> +		if (!ref) {
> +			pr_warn_ratelimited("%llx not tracked, left mapped\n",
> +					    phys_addr);
> +			goto next;
> +		}
> +
> +		if (!refcount_dec_and_test(&ref->count))
> +			goto next;
> +
> +		xa_erase(&ioremap_guard_array, pfn);
> +		kfree(ref);
> +
> +		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
> +				  phys_addr, &res);
> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn_ratelimited("Failed to unregister %llx\n",
> +					    phys_addr);
> +			goto out;
> +		}
> +
> +	next:
> +		size -= PAGE_SIZE;
> +		phys_addr += PAGE_SIZE;
> +	}
> +out:
> +	mutex_unlock(&ioremap_guard_lock);
> +}
>  
>  static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>  				      pgprot_t prot, void *caller)
> -- 
> 2.30.2
>

Thanks,
drew 

