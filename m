Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EE7D2F65
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 12:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjJWKDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 06:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjJWKDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 06:03:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6611E8
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:03:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9c41e95efcbso439047666b.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698055384; x=1698660184; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ip92rbHjEjBMgAx7FNr3A0maZqLC50ltIPpQtdwaJ28=;
        b=iwdzWjLqRcJDEE6EiAYlfHeoXZW0f2G1ZaRFE5/9fa+UVRCfSXiIbf5HmsBm4nttqV
         1w9iSdeEIqcW7fo36L+4KQWJfohTe5O5AWZFlG+qZ0a83yyhIgCB4ITaXE8CVqK1SUDn
         UpPNrnG2C5bGfTsQ2UGc89hmF3g+XG7x9slyEnxJkI2sW3MncUHNX7scPVjPYKeE2UHD
         0dI2XyJjC8M9NMEXGFcjO6Fgv5BdODaucjmtJSWqK3upGy/uysIASayjqqH8euraW5xO
         duUk2BUe2EDga7S/wHzqYYI2LIQwZ9DDejtJL7AuXRa/BYLaK2GC/ZliJ+GLFYWQnWHG
         HCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055384; x=1698660184;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ip92rbHjEjBMgAx7FNr3A0maZqLC50ltIPpQtdwaJ28=;
        b=T2ojQ/zbEPcUXp2HiL/nzrpk1iO7i+Oyl6iEhBl+oS69jhcg32WcJnq9pD3gGrVQuY
         agciiZqiyz3ONjmPDv8EIVRkpYfGeOlxpRYbmHC4N4MBYFhze3ryAZtQLJZEWacWv+h8
         BRYypmITEhy69b/5v6feJPzAgTnrKiC30kVAyopwJcRHDyKCNWoZlljoWvnQ6sCi8wK3
         pXvLh1PjdpZIJkTlnRFeepjV/caZ5iBnKXq54TMEwJkiteh0mi3GNHyyRCuQnhZmc5uk
         +HhTjOR7gf9GYCuysvYOPE4+EGalpmrGbKdps1lnpA9lPX5DesnUnZI1ybkCJ3xUh0io
         u1+g==
X-Gm-Message-State: AOJu0YyR8MHNd4r/Ck3TF9DdnTBspwfuhB8yqRj86sFTOxjBgmubbtnr
        2qK+x6SLgCmjFbw+PvZ/66fmvQ==
X-Google-Smtp-Source: AGHT+IHbP1iRP01wtTj0lGIg97SfHpaSuq3jc10bBcdA9nz/72Ux0bRd2wnzPV3aAOMKFVCBoQdHEA==
X-Received: by 2002:a17:907:1b11:b0:9bf:d70b:9873 with SMTP id mp17-20020a1709071b1100b009bfd70b9873mr7388887ejc.39.1698055384364;
        Mon, 23 Oct 2023 03:03:04 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p26-20020a170906229a00b009b65a698c16sm6401969eja.220.2023.10.23.03.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 03:03:04 -0700 (PDT)
Date:   Mon, 23 Oct 2023 12:03:03 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 3/5] riscv: kernel: Use correct SYM_DATA_*() macro for
 data
Message-ID: <20231023-153a19dd516176d3d3b9334e@orel>
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-4-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231004143054.482091-4-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 04:30:52PM +0200, Clément Léger wrote:
> Some data were incorrectly annotated with SYM_FUNC_*() instead of
> SYM_DATA_*() ones. Use the correct ones.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/entry.S | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 64ac0dd6176b..a7aa2fd599d6 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -324,7 +324,7 @@ SYM_FUNC_END(__switch_to)
>  	.section ".rodata"
>  	.align LGREG
>  	/* Exception vector table */
> -SYM_CODE_START(excp_vect_table)
> +SYM_DATA_START_LOCAL(excp_vect_table)
>  	RISCV_PTR do_trap_insn_misaligned
>  	ALT_INSN_FAULT(RISCV_PTR do_trap_insn_fault)
>  	RISCV_PTR do_trap_insn_illegal
> @@ -342,12 +342,11 @@ SYM_CODE_START(excp_vect_table)
>  	RISCV_PTR do_page_fault   /* load page fault */
>  	RISCV_PTR do_trap_unknown
>  	RISCV_PTR do_page_fault   /* store page fault */
> -excp_vect_table_end:
> -SYM_CODE_END(excp_vect_table)
> +SYM_DATA_END_LABEL(excp_vect_table, SYM_L_LOCAL, excp_vect_table_end)
>  
>  #ifndef CONFIG_MMU
> -SYM_CODE_START(__user_rt_sigreturn)
> +SYM_DATA_START(__user_rt_sigreturn)
>  	li a7, __NR_rt_sigreturn
>  	ecall
> -SYM_CODE_END(__user_rt_sigreturn)
> +SYM_DATA_END(__user_rt_sigreturn)
>  #endif
> -- 
> 2.42.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
