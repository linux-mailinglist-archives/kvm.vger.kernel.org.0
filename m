Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17967D10D
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjAZQMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjAZQMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:12:09 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407DF599BE
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:11:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id v6so6389076ejg.6
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTuRDxbfWg39Wdf8MzHmSvof5BdyBoYVZ4tVj9C0vdE=;
        b=k4zXl9wSOzT/hXYVF/RWS+MlEEKZ9rSwfiqCrVzT+5K427yb+3ngGAKiKmE3HZLGLp
         FIXsamU9iKhdxwfe5chNrwjiKnxYxZP7dzTdjDYdlOJ3pZBjYV4GUlIUUDfqzb1KOJY2
         RS50VQikH+FNvBbsKC0/bO5gOrhdpl26RbPfotICnImztHHhDzK1vryqLRcKSbaNSbOu
         otrkbjfn19peb5OMybSS0HrRC4ua3z9ZEXtj6FfyNSBwYtO9nblgJBq0F3fimk0CiIWP
         qlAhImj/EASE9ScORVLWT4MCwiJ7N5dY/qbUTEWVsOIvz3RvGbqyGYGX1lbt41Atlv2v
         7Ebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTuRDxbfWg39Wdf8MzHmSvof5BdyBoYVZ4tVj9C0vdE=;
        b=qYmVUBVV0eqTy15fCpG4Rgzlvsc9AdZtvfpzb3568G2i6q6yF1pTcJhb/3tqSstzTd
         SxAGEhXFBTm4t4MIamlJvvnipMxLBevm5nRnmGJwi5RjiWcnUFSYA5T3L0CCVNTLtV9b
         C/RXt0RuVVk+tjWlhPTvecPfURZuFK+GY/rBAtudGrxdFaSrR6BMuCvLK2v7xrDSWdUi
         YQ6Uze4CZcDZjhsWnRJaRDXpONhQFeb5PAjV2nUTeoSUketfFcSqWXm+hnWkUNLJkZ26
         /Syw8b3oVhqIENMafMW9l8jncNVi0+KQWCUBqO0gXnJshfF0/WNl3koSk80/4GKTu+tw
         bskw==
X-Gm-Message-State: AFqh2krWA9E7vKhYidREdyk5dRKHKYGXkFjwiFCJAqsN7x5IjlmeA/mF
        Q+4Y7bf2UTvOBmG6CTwTAxGBpQ==
X-Google-Smtp-Source: AMrXdXsyyaq9WL28lgCMw2oKhC8d+T2NBMFe+cOw0CLF/8Noh23mi3z88nsbaVwyj37sqzNjaTmCvA==
X-Received: by 2002:a17:907:c712:b0:7ba:5085:869 with SMTP id ty18-20020a170907c71200b007ba50850869mr41788111ejc.9.1674749508793;
        Thu, 26 Jan 2023 08:11:48 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090655cc00b0084c6581c16fsm793123ejp.64.2023.01.26.08.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 08:11:48 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:11:47 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID
 mask defines
Message-ID: <20230126161147.6rewhfvlouqn4ual@orel>
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
 <20230112140304.1830648-4-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140304.1830648-4-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 07:33:00PM +0530, Anup Patel wrote:
> The hgatp.VMID mask defines are used before shifting when extracting
> VMID value from hgatp CSR value so based on the convention followed
> in the other parts of asm/csr.h, the hgatp.VMID mask defines should
> not have a _MASK suffix.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/csr.h | 8 ++++----
>  arch/riscv/kvm/mmu.c         | 3 +--
>  arch/riscv/kvm/vmid.c        | 4 ++--
>  3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index d608dac4b19f..36d580528f90 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -131,12 +131,12 @@
>  
>  #define HGATP32_MODE_SHIFT	31
>  #define HGATP32_VMID_SHIFT	22
> -#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
> +#define HGATP32_VMID		_AC(0x1FC00000, UL)
>  #define HGATP32_PPN		_AC(0x003FFFFF, UL)
>  
>  #define HGATP64_MODE_SHIFT	60
>  #define HGATP64_VMID_SHIFT	44
> -#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
> +#define HGATP64_VMID		_AC(0x03FFF00000000000, UL)
>  #define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
>  
>  #define HGATP_PAGE_SHIFT	12
> @@ -144,12 +144,12 @@
>  #ifdef CONFIG_64BIT
>  #define HGATP_PPN		HGATP64_PPN
>  #define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
> -#define HGATP_VMID_MASK		HGATP64_VMID_MASK
> +#define HGATP_VMID		HGATP64_VMID
>  #define HGATP_MODE_SHIFT	HGATP64_MODE_SHIFT
>  #else
>  #define HGATP_PPN		HGATP32_PPN
>  #define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
> -#define HGATP_VMID_MASK		HGATP32_VMID_MASK
> +#define HGATP_VMID		HGATP32_VMID
>  #define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
>  #endif
>  
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 34b57e0be2ef..034746638fa6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -748,8 +748,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
>  	unsigned long hgatp = gstage_mode;
>  	struct kvm_arch *k = &vcpu->kvm->arch;
>  
> -	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
> -		 HGATP_VMID_MASK;
> +	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
>  	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
>  
>  	csr_write(CSR_HGATP, hgatp);
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 6cd93995fb65..6f4d4979a759 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -26,9 +26,9 @@ void kvm_riscv_gstage_vmid_detect(void)
>  
>  	/* Figure-out number of VMID bits in HW */
>  	old = csr_read(CSR_HGATP);
> -	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
> +	csr_write(CSR_HGATP, old | HGATP_VMID);
>  	vmid_bits = csr_read(CSR_HGATP);
> -	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
> +	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>  	vmid_bits = fls_long(vmid_bits);
>  	csr_write(CSR_HGATP, old);
>  
> -- 
> 2.34.1
>

Could switch to GENMASK too at the same time :-)

Anyway,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
