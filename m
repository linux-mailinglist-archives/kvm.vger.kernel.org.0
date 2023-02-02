Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A8688169
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjBBPOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjBBPOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 10:14:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4DD37B72
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 07:14:36 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n13so1650421wmr.4
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 07:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I16Z1KgxRWP5MyHAvbuxURW5bLdfVdGat8LdiyVkZ7U=;
        b=VEUHLfU3cpYCINOO9LcLpYGlADqSXC15ZfI53t8aLaFHNN3NMUbf2x8wxcnck6Iuay
         j4FQ6kiNcj+ysWf+meWmecn3IPVa1cG7jGRlpE9Vby85Ge8Qyok3xNr/j9si3PVy3/lp
         KlQSpT7gjOYy/VljXUgCjlmBGpFhDpZsXdWFJm3g6pUmvI5/GC09tjIYY5u1wSBFMmZB
         pjtHzE9+/7DnM4BxwYnA7OjYwA0srrOZFWLrp7V9RJ/5KzDCbftjsJOJqO1/RdvvxNRg
         7OdrIg5Fc8L/je0Ym0Or4m0AecDgQe+b90Zx6nPHzmGf3T9LZcrIVrvKkaOw6EvUFH9f
         Rtng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I16Z1KgxRWP5MyHAvbuxURW5bLdfVdGat8LdiyVkZ7U=;
        b=bxRlOmcEOTmsK3Q6wKYSL/YhqC520aSATInCiTa7l1DfqFwp0Oa7dE5ruf8B5ZWWK9
         EIxoVW5XRrYsgt43ErRtOFXCUaxIMXSf0A1hiBX1CMfDxI0i/gJaJpuJWlxcQ2Vv0oPF
         DhDi4A17SJxoa/MlEm59yjr5K+u5UL9wEMfVjQ7ZRjxQzC69hKQT4X4dHDarukrH3FD6
         PF8qJ2/wRPBz1W0s4Uqsogc7njcfa7NNIfOfWG1bA0hPQk+t0U6jpCaGGQ+REmncm2Yl
         Rt6WH3dVKB0hWRn2/NY+xGnjOcxPCcpmrAydayzzL8uIzNI7XiYvJYLMvNOXEP9J4kiy
         T/JQ==
X-Gm-Message-State: AO0yUKV2+oZoliWoCIfAw9oC1GD41mDzocSWjOFKHXocqtYhXGFVC+Ez
        aVSfqto0YtWy40ucV+hBcqyA+w==
X-Google-Smtp-Source: AK7set++OTtPGCP2P3+NgUI2qvWC34mJ3Zb5+a0gIgWMcAnUGLvAA2gRKgUzvEYkmiOl+mgEgbT78g==
X-Received: by 2002:a05:600c:35d3:b0:3de:e8c5:d82c with SMTP id r19-20020a05600c35d300b003dee8c5d82cmr5645595wmq.29.1675350875212;
        Thu, 02 Feb 2023 07:14:35 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0ac700b003d1d5a83b2esm4924261wmr.35.2023.02.02.07.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:14:34 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:14:33 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 04/14] RISC-V: KVM: Define a probe function for SBI
 extension data structures
Message-ID: <20230202151433.kspo2g7cqsccoqsq@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-5-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-5-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:40PM -0800, Atish Patra wrote:
> Currently the probe function just checks if an SBI extension is
> registered or not. However, the extension may not want to advertise
> itself depending on some other condition.
> An additional extension specific probe function will allow
> extensions to decide if they want to be advertised to the caller or
> not. Any extension that does not require additional dependency checks
> can avoid implementing this function.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index f79478a..45ba341 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
>  	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
>  		       bool *exit);
> +
> +	/* Extension specific probe function */
> +	unsigned long (*probe)(struct kvm_vcpu *vcpu);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 5d65c63..846d518 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  {
>  	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	const struct kvm_vcpu_sbi_extension *sbi_ext;
>  
>  	switch (cp->a6) {
>  	case SBI_EXT_BASE_GET_SPEC_VERSION:
> @@ -43,8 +44,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			 */
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
>  			*exit = true;
> -		} else
> -			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +		} else {
> +			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> +			if (sbi_ext) {
> +				if (sbi_ext->probe)
> +					*out_val = sbi_ext->probe(vcpu);
> +				else
> +					*out_val = 1;
> +			} else
> +				*out_val = 0;

Conor points out elsewhere that we need {} on both arms if one arm needs
it. We actually don't need {} on either arm, though, or even the if, if
we rewrite as

 *out_val = sbi_ext && sbi_ext->probe ? sbi_ext->probe(vcpu) : !!sbi_ext;

Thanks,
drew

> +		}
>  		break;
>  	case SBI_EXT_BASE_GET_MVENDORID:
>  		*out_val = vcpu->arch.mvendorid;
> -- 
> 2.25.1
> 
