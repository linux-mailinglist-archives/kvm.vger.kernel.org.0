Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D024D3FEE92
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbhIBNWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 09:22:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234516AbhIBNWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 09:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630588878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6tJf5xIvKDCnRwuvzEhUuuc4fd9eQkxx1PjNi93Vu3s=;
        b=SnzWriVvL1J/4ZPJ06qeAlQl33FEpWh9jdCEPiw9zTq8pOJ7Y6W2+DQZAr/Uw+0tVj6GPH
        m+Ll5hv+zguwNMRcQ7NjAK+z6iDs9LuIks9uLmWlcbN366y8VKl5zTZBgR9AgzcUnfGTcf
        7k62Rd/2GOiRK8t40gG/ZtjYAWL30UM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-soczMSrUOQWqWP0ZAt3L-g-1; Thu, 02 Sep 2021 09:21:17 -0400
X-MC-Unique: soczMSrUOQWqWP0ZAt3L-g-1
Received: by mail-qt1-f200.google.com with SMTP id e8-20020a05622a110800b0029ecbdc1b2aso1239677qty.12
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 06:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6tJf5xIvKDCnRwuvzEhUuuc4fd9eQkxx1PjNi93Vu3s=;
        b=FBOSj/Eipenwujq2aK2OesNm+p3Up+4hCsD+iHpLmFtBppLIBmhzSQHhlEf/VDw699
         HgXlcr/wFr2GXHLWmsGIDsNzXmBOk7b3WXIHq8MSh5ku8xVfnefuFjOdbx+5RLXdcD2/
         WPJUCgApR3bDS0VQcTi3Jzcvs2aM9u/yX2bTXSy6d2rHOQJdKNVYjvLxnq1Rn1O3LusC
         dXrDgh4hEGL4FXnnbtDf08IkmGc2EAvjorXCGhjseV5ppk/QlLMXPFEVDNJbeferrtA/
         36SVBb9btUWtolVpxyfcFlHBNGla4ZLqT2UJHoUdpxBTl0zIQPQXLJqBeeXPIGvBrtPU
         xjgA==
X-Gm-Message-State: AOAM5337HAB0UDUX4FsvVj7rCU09FI7ZNyngkzFl7vnfzLNviKL64Ov6
        tKQMd540dlTU+P8y+y+tCpQ8vCR540ChE8txA6hnD/gVSBjsJhSesOoPKClWwY2eyicJU4TctCX
        jUyxw6LPae562
X-Received: by 2002:ad4:562c:: with SMTP id cb12mr1587961qvb.6.1630588877097;
        Thu, 02 Sep 2021 06:21:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG9JfvU8t2EsYROxxRPXPNKTs00M8PoYMUrrQVfghePFKxWKnhmt6JBf3fCTGn9rsZbouzrg==
X-Received: by 2002:ad4:562c:: with SMTP id cb12mr1587947qvb.6.1630588876898;
        Thu, 02 Sep 2021 06:21:16 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id g8sm1319814qkm.25.2021.09.02.06.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 06:21:16 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:21:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
Message-ID: <20210902132112.yyz7iiqims3nlmmi@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-2-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> Define the readl() and writel() functions for the guests to
> access (4-byte) the MMIO region.
> 
> The routines, and their dependents, are inspired from the kernel's
> arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c0273aefa63d..3cbaf5c1e26b 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  	val;								  \
>  })
>  
> -#define isb()	asm volatile("isb" : : : "memory")
> +#define isb()		asm volatile("isb" : : : "memory")
> +#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
> +#define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> +
> +#define dma_wmb()	dmb(oshst)
> +#define __iowmb()	dma_wmb()
> +
> +#define dma_rmb()	dmb(oshld)
> +
> +#define __iormb(v)							\
> +({									\
> +	unsigned long tmp;						\
> +									\
> +	dma_rmb();							\
> +									\
> +	/*								\
> +	 * Courtesy of arch/arm64/include/asm/io.h:			\
> +	 * Create a dummy control dependency from the IO read to any	\
> +	 * later instructions. This ensures that a subsequent call	\
> +	 * to udelay() will be ordered due to the ISB in __delay().	\

We don't have udelay or __delay yet, but I assume they're coming soon.

> +	 */								\
> +	asm volatile("eor	%0, %1, %1\n"				\
> +		     "cbnz	%0, ."					\
> +		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
> +		     : "memory");					\
> +})
> +
> +static __always_inline void __raw_writel(u32 val, volatile void *addr)
> +{
> +	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
> +}
> +
> +static __always_inline u32 __raw_readl(const volatile void *addr)
> +{
> +	u32 val;
> +	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +
> +#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
> +#define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })

Might want to explicitly include linux/types.h for these __force symbols.

> +
> +#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
> +#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
>  
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog


Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

