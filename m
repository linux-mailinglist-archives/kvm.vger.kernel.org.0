Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243D46FFCDD
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbjEKW4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjEKW4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00BDE42
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24de2954bc5so6411309a91.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845796; x=1686437796;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4sU4PXcM1yZx9GH6PSa5VLjbCjU9dXv0tysprAN7oU=;
        b=oq5t7tGHKJ5wy4fdXq+zUN5O+sD+A/2xTxbs706Al0rL0AG/zViVFVR2UhJilKZ9we
         AhVNFa7KGIEO/3M9EeKi4fzPGl0GF3BmBj5ntlosTsnwt1HDawYaQUIRhQj0aPhnJgAp
         zDO8EMC+VaysZ0Wbn6oeI0ogpwjZM5JLLCo6UH3K9CFGdYX1tcOVejABjvgQdpSOyAdu
         k5Qy1AK9ICOEj9rbCHMTOxDBOruhNXrWwDufQajDVCOcohs8iRnkuZ88kZ3OWHwhTxWp
         Baqe2GdBHMVNuVRPvwjCD302tyCN30CskwOflMw6nW4vt4IqyXZn5J37FwzWIBSzcjqx
         6q2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845796; x=1686437796;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4sU4PXcM1yZx9GH6PSa5VLjbCjU9dXv0tysprAN7oU=;
        b=BOZMk5TOrbUymo5LbX30r4BBE3UXH9KJlhtJIxXeW980xwfbQmrF6kzCMk1Ysx9lzm
         xCVr8gi4My6g1oJX6hjxbqtEcSfsJsLAZWjf6rlUWHnnAOryeVhZSoD+jde3KjICAnnw
         O//vnAPBu5GPvkVPrMgS20dsooSrdfbXD+/xIYbi5uslWqK1eCX8ezEMXo4s1Br7E2qG
         soHwJ48aJ0Eli/w2YOVIZuK2OKxb2uH/hscQLcDDhz77u89sa+/Q0sEWaqLgQjKe+lhg
         gf5A9wi8y9qBtqde+KR7RWEHyWKB9xEmz5HIkEsY3d6EWoweUXkmmSDR4N3dhDQkECEY
         hMow==
X-Gm-Message-State: AC+VfDwo0NdKgE30txFhrbrYSyPpAXCmjINNDURMZjRZ9+IlXAapz7GF
        nLWf8hwi5wVPZnkfa2klJWiffw==
X-Google-Smtp-Source: ACHHUZ70bhqMPwkSsP6X42AOYNIyNmNqrrLiV9JgAaX28M3FT2LZHST7X1PIv3JH+CnZHt7N6osBzw==
X-Received: by 2002:a17:90a:5e45:b0:24b:af7d:201d with SMTP id u5-20020a17090a5e4500b0024baf7d201dmr23840093pji.24.1683845796070;
        Thu, 11 May 2023 15:56:36 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aca0600b0024e37e0a67dsm16980603pjt.20.2023.05.11.15.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:35 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:35 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:39:38 PDT (-0700)
Subject:     Re: [PATCH -next v19 02/24] riscv: Extending cpufeature.c to detect V-extension
In-Reply-To: <20230509103033.11285-3-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        ren_guo@c-sky.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ajones@ventanamicro.com,
        Conor Dooley <conor.dooley@microchip.com>,
        heiko.stuebner@vrull.eu, apatel@ventanamicro.com,
        jszhang@kernel.org, guoren@kernel.org, vincent.chen@sifive.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-5a4ccb60-d078-436a-a25f-b444e27b9115@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:11 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>
> Add V-extension into riscv_isa_ext_keys array and detect it with isa
> string parsing.
>
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/hwcap.h      |  1 +
>  arch/riscv/include/asm/vector.h     | 26 ++++++++++++++++++++++++++
>  arch/riscv/include/uapi/asm/hwcap.h |  1 +
>  arch/riscv/kernel/cpufeature.c      | 11 +++++++++++
>  4 files changed, 39 insertions(+)
>  create mode 100644 arch/riscv/include/asm/vector.h
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index e0c40a4c63d5..574385930ba7 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -22,6 +22,7 @@
>  #define RISCV_ISA_EXT_m		('m' - 'a')
>  #define RISCV_ISA_EXT_s		('s' - 'a')
>  #define RISCV_ISA_EXT_u		('u' - 'a')
> +#define RISCV_ISA_EXT_v		('v' - 'a')
>
>  /*
>   * These macros represent the logical IDs of each multi-letter RISC-V ISA
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> new file mode 100644
> index 000000000000..427a3b51df72
> --- /dev/null
> +++ b/arch/riscv/include/asm/vector.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2020 SiFive
> + */
> +
> +#ifndef __ASM_RISCV_VECTOR_H
> +#define __ASM_RISCV_VECTOR_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +
> +#include <asm/hwcap.h>
> +
> +static __always_inline bool has_vector(void)
> +{
> +	return riscv_has_extension_likely(RISCV_ISA_EXT_v);

Nothing publicly availiable has V yet, so it's not likely.

> +}
> +
> +#else /* ! CONFIG_RISCV_ISA_V  */
> +
> +static __always_inline bool has_vector(void) { return false; }
> +
> +#endif /* CONFIG_RISCV_ISA_V */
> +
> +#endif /* ! __ASM_RISCV_VECTOR_H */
> diff --git a/arch/riscv/include/uapi/asm/hwcap.h b/arch/riscv/include/uapi/asm/hwcap.h
> index 46dc3f5ee99f..c52bb7bbbabe 100644
> --- a/arch/riscv/include/uapi/asm/hwcap.h
> +++ b/arch/riscv/include/uapi/asm/hwcap.h
> @@ -21,5 +21,6 @@
>  #define COMPAT_HWCAP_ISA_F	(1 << ('F' - 'A'))
>  #define COMPAT_HWCAP_ISA_D	(1 << ('D' - 'A'))
>  #define COMPAT_HWCAP_ISA_C	(1 << ('C' - 'A'))
> +#define COMPAT_HWCAP_ISA_V	(1 << ('V' - 'A'))
>
>  #endif /* _UAPI_ASM_RISCV_HWCAP_H */
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index b1d6b7e4b829..7aaf92fff64e 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -107,6 +107,7 @@ void __init riscv_fill_hwcap(void)
>  	isa2hwcap['f' - 'a'] = COMPAT_HWCAP_ISA_F;
>  	isa2hwcap['d' - 'a'] = COMPAT_HWCAP_ISA_D;
>  	isa2hwcap['c' - 'a'] = COMPAT_HWCAP_ISA_C;
> +	isa2hwcap['v' - 'a'] = COMPAT_HWCAP_ISA_V;

IMO it's OK to provide V in hwcap, as there is a "V" extension defined 
(unlike "B", for example).

>
>  	elf_hwcap = 0;
>
> @@ -267,6 +268,16 @@ void __init riscv_fill_hwcap(void)
>  		elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
>  	}
>
> +	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
> +		/*
> +		 * ISA string in device tree might have 'v' flag, but
> +		 * CONFIG_RISCV_ISA_V is disabled in kernel.
> +		 * Clear V flag in elf_hwcap if CONFIG_RISCV_ISA_V is disabled.
> +		 */
> +		if (!IS_ENABLED(CONFIG_RISCV_ISA_V))
> +			elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
> +	}
> +
>  	memset(print_str, 0, sizeof(print_str));
>  	for (i = 0, j = 0; i < NUM_ALPHA_EXTS; i++)
>  		if (riscv_isa[0] & BIT_MASK(i))

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
