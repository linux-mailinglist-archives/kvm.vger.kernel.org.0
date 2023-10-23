Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815B77D2F54
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjJWJ7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbjJWJ70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:59:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205CD1728
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:59:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-538e8eca9c1so4478241a12.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698055148; x=1698659948; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2OmZDh8zFkt2im5G0Ax6bYEcMQDHeA27n8h3Y3jQvbM=;
        b=hjpzCF/fgnhnePd3lDSypoSov04oIGQOoD5kN0+b90weY6uL9toeQ8AlbGRjodLmtR
         WYbcZ+UHdcmb+0TQlL9/FCfi7exL/W+LkZ0T/Zs9JEZCbZDyJ2ng/tUtUBCMGX5QkzaS
         Jl5mV8tYnJQCkaKmUDnHwUKIdSet5hkqPLOUT6PNE1BHovCPQYEfph5uKmyvCucN3Amb
         EMgEqa1ZOlld+wgok/DH7N10qg915QCWRc9SUXf3MkwzUapBq/T+dru6KDoAULWN/hGb
         v9BY8rQA9DoKyPAV4JDqBDY9lCVSyBpluTZGj1EJooDA5ZwT0MIoW3h+Ao0jVp37sh7b
         Ztmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055148; x=1698659948;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OmZDh8zFkt2im5G0Ax6bYEcMQDHeA27n8h3Y3jQvbM=;
        b=kPz/dpxHl9nh4qTxZQohF4mX1HNJMZp+GYvEoWXaYqYAFULqxnYmiP5b6J/INhEx9f
         rjt+7RlbSZKPoQoq7Yzma0FbJzCjnejZPw0c31TLdw1EQGnnQSI1i98G6IUoT5PEjz/5
         UjysqJGATQVMj6PbsW5RnqD5nXt9ydhhZcvtZHNDPtRhzs9jehpWx+Dlw/hcx61/j9Cq
         uQgRvfEnQVaUiurymV3zlJ171Zjs5kaiDPZBZxQw4dUJosdkZNfK5ku1RtJCf1kqqW/5
         rSveVmpG/MxseV0Ll7TyvSeSrsONdJA70er+dpUIMCmL1UkV6+ahwVw09I8lzdBPSsP/
         OfYw==
X-Gm-Message-State: AOJu0Yy3v+3lbdO1RNH/v+kWpHOeWi/6kqsW1SS2XFVIHqK+oaAp7Tzc
        Bdh+T7Y1s9CvJdnfMCTxGETMPQ==
X-Google-Smtp-Source: AGHT+IHRYa8NKx/W61EUWyQsjouRtZ7JYz3USclA7m0EOfz/Cuu6SSfbR3giCiKx5DNBdpsLukoaCQ==
X-Received: by 2002:a17:906:6a19:b0:9bd:a165:7822 with SMTP id qw25-20020a1709066a1900b009bda1657822mr7556299ejc.47.1698055148535;
        Mon, 23 Oct 2023 02:59:08 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m10-20020a170906234a00b009b29668fce7sm6355325eja.113.2023.10.23.02.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 02:59:08 -0700 (PDT)
Date:   Mon, 23 Oct 2023 11:59:07 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
Message-ID: <20231023-136cad6e15a2c5c27b6176af@orel>
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-3-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231004143054.482091-3-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 04:30:51PM +0200, Clément Léger wrote:
...
> diff --git a/arch/riscv/lib/memmove.S b/arch/riscv/lib/memmove.S
> index 1930b388c3a0..5130033e3e02 100644
> --- a/arch/riscv/lib/memmove.S
> +++ b/arch/riscv/lib/memmove.S
> @@ -7,7 +7,6 @@
>  #include <asm/asm.h>
>  
>  SYM_FUNC_START(__memmove)
> -SYM_FUNC_START_WEAK(memmove)
>  	/*
>  	 * Returns
>  	 *   a0 - dest
> @@ -314,5 +313,6 @@ SYM_FUNC_START_WEAK(memmove)
>  
>  SYM_FUNC_END(memmove)

Should this one above be removed?

>  SYM_FUNC_END(__memmove)
> +SYM_FUNC_ALIAS_WEAK(memmove, __memmove)
>  SYM_FUNC_ALIAS(__pi_memmove, __memmove)
>  SYM_FUNC_ALIAS(__pi___memmove, __memmove)
> diff --git a/arch/riscv/lib/memset.S b/arch/riscv/lib/memset.S
> index 34c5360c6705..35f358e70bdb 100644
> --- a/arch/riscv/lib/memset.S
> +++ b/arch/riscv/lib/memset.S
> @@ -8,8 +8,7 @@
>  #include <asm/asm.h>
>  
>  /* void *memset(void *, int, size_t) */
> -ENTRY(__memset)
> -WEAK(memset)
> +SYM_FUNC_START(__memset)
>  	move t0, a0  /* Preserve return value */
>  
>  	/* Defer to byte-oriented fill for small sizes */
> @@ -110,4 +109,5 @@ WEAK(memset)
>  	bltu t0, a3, 5b
>  6:
>  	ret
> -END(__memset)
> +SYM_FUNC_END(__memset)
> +SYM_FUNC_ALIAS_WEAK(memset, __memset)
> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
> index 09b47ebacf2e..3ab438f30d13 100644
> --- a/arch/riscv/lib/uaccess.S
> +++ b/arch/riscv/lib/uaccess.S
> @@ -10,8 +10,7 @@
>  	_asm_extable	100b, \lbl
>  	.endm
>  
> -ENTRY(__asm_copy_to_user)
> -ENTRY(__asm_copy_from_user)
> +SYM_FUNC_START(__asm_copy_to_user)
>  
>  	/* Enable access to user memory */
>  	li t6, SR_SUM
> @@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
>  	csrc CSR_STATUS, t6
>  	sub a0, t5, a0
>  	ret
> -ENDPROC(__asm_copy_to_user)
> -ENDPROC(__asm_copy_from_user)
> +SYM_FUNC_END(__asm_copy_to_user)
>  EXPORT_SYMBOL(__asm_copy_to_user)
> +SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)

IIUC, we'll only have debug information for __asm_copy_to_user. I'm not
sure what that means for debugging. Is it possible to generate something
confusing?

>  EXPORT_SYMBOL(__asm_copy_from_user)
>  
>  
> -ENTRY(__clear_user)
> +SYM_FUNC_START(__clear_user)
>  
>  	/* Enable access to user memory */
>  	li t6, SR_SUM
> @@ -233,5 +232,5 @@ ENTRY(__clear_user)
>  	csrc CSR_STATUS, t6
>  	sub a0, a3, a0
>  	ret
> -ENDPROC(__clear_user)
> +SYM_FUNC_END(__clear_user)
>  EXPORT_SYMBOL(__clear_user)
> diff --git a/arch/riscv/purgatory/entry.S b/arch/riscv/purgatory/entry.S
> index 0194f4554130..7befa276fb01 100644
> --- a/arch/riscv/purgatory/entry.S
> +++ b/arch/riscv/purgatory/entry.S
> @@ -7,15 +7,11 @@
>   * Author: Li Zhengyu (lizhengyu3@huawei.com)
>   *
>   */
> -
> -.macro	size, sym:req
> -	.size \sym, . - \sym
> -.endm
> +#include <linux/linkage.h>
>  
>  .text
>  
> -.globl purgatory_start
> -purgatory_start:
> +SYM_CODE_START(purgatory_start)
>  
>  	lla	sp, .Lstack
>  	mv	s0, a0	/* The hartid of the current hart */
> @@ -28,8 +24,7 @@ purgatory_start:
>  	mv	a1, s1
>  	ld	a2, riscv_kernel_entry
>  	jr	a2
> -
> -size purgatory_start
> +SYM_CODE_END(purgatory_start)
>  
>  .align 4
>  	.rept	256
> @@ -39,9 +34,8 @@ size purgatory_start
>  
>  .data
>  
> -.globl riscv_kernel_entry
> -riscv_kernel_entry:
> +SYM_DATA_START(riscv_kernel_entry)
>  	.quad	0
> -size riscv_kernel_entry
> +SYM_DATA_END(riscv_kernel_entry)

I think we could also use the shorthand version for this one-liner.

SYM_DATA(riscv_kernel_entry, quad 0)

Thanks,
drew
