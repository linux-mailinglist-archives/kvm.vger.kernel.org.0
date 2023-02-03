Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B90688BB3
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 01:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjBCAYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 19:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjBCAYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 19:24:47 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB281B2C
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 16:24:44 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id jh15so3653502plb.8
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 16:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/S7e5WEqMk16Ay2DoIKqyJpIuF5AJjNAAjV63IUL/tk=;
        b=hQHP9qyZHVA+a+uHuTsMO8GZ8HIvjBwROyn/IiLj4UlR5kumKYQZiOaP0yjAA/1OSG
         C3MjFbaOYsrz20pQoZpTAzls1PAfIviVRvp3Q7r8Xwja45vzqoZLvAU0isd2qEdg9C9n
         G5MNgZKFWHjl+Qr7/mk/lTfoukCH46J1tvzyn3Y/sN3cqY1SJkbCpJ2lnecR/OO73t/I
         cM1IibAIrbvSVCWv5TbN7WvpARB41Vlge16J+7pGQy3k6qVx0zEauexfdpR3gA42h0nI
         ykfx23+DrjARrWRdmejWAqveHSHaMPBFdC44rz6oiK/2k2mP6PLIHKuJ4GQeSXLs69+h
         BDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/S7e5WEqMk16Ay2DoIKqyJpIuF5AJjNAAjV63IUL/tk=;
        b=NhLk7T+B1RaK19+NdVhRj8FvT+P5g1dXO4lTfjhIDCw3xrBI1k53ex+m4Nl2wpJARa
         utclmHN1BAu/hWozOBTEdMfcCbmx8x9mFyxI/1dWthNc6NHwX4zLpUXEVjIy+5iuWeDX
         Nt2iWmdDtkqbdS/7F77tm1w3/uk3XTyJyQXZR2Cf6BBM/7tqHBRFZgxk2d4H/cHZrvOk
         802VbZIe3ubV0zIG+cbegriYwwT11XJvyguSb9RY7l4HETcAjsbSRWtVr5NbpVJt74NY
         7N03CRGYSbmsSMjz62+qiV7FgeZaU+5VjQVzKBzeOAV8yTqNz5qZYPWEp5KA5NN5rGDI
         jBOA==
X-Gm-Message-State: AO0yUKXRbnaXhN3fXTBH1yDV5GjlISNGQVAkOD8bsouthLeXQ4R0XJwq
        O6PtU9mZTVAASbG0s/NTxXG0kg==
X-Google-Smtp-Source: AK7set+rJWfbsNd7M3rDZo/kVRyVpyV17Qy08I1XQbG1fnSbrgJIKhyrLKBmh0Ll2t6sRL/UrW+9uw==
X-Received: by 2002:a17:902:ec8c:b0:191:3098:8b with SMTP id x12-20020a170902ec8c00b001913098008bmr3437192plg.58.1675383883696;
        Thu, 02 Feb 2023 16:24:43 -0800 (PST)
Received: from localhost ([135.180.226.51])
        by smtp.gmail.com with ESMTPSA id q13-20020a170902a3cd00b001948ae7501asm238241plb.298.2023.02.02.16.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 16:24:43 -0800 (PST)
Date:   Thu, 02 Feb 2023 16:24:43 -0800 (PST)
X-Google-Original-Date: Thu, 02 Feb 2023 16:24:14 PST (-0800)
Subject:     Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
In-Reply-To: <20230128072737.2995881-3-apatel@ventanamicro.com>
CC:     pbonzini@redhat.com, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, apatel@ventanamicro.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     apatel@ventanamicro.com
Message-ID: <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote:
> We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> and Ssaia (S-mode AIA CSRs).

This has pretty much the same problem that we had with the other 
AIA-related ISA string patches, where there's that ambiguity with the 
non-ratified chapters.  IIRC when this came up in GCC the rough idea was 
to try and document that we're going to interpret the standard ISA 
strings that way, but now that we're doing custom ISA extensions it 
seems saner to just define on here that removes the ambiguity.

I just sent
<https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/> 
which documents that.

> We extend the ISA string parsing to detect Smaia and Ssaia extensions.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 2 ++
>  arch/riscv/kernel/cpu.c        | 2 ++
>  arch/riscv/kernel/cpufeature.c | 2 ++
>  3 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 86328e3acb02..341ef30a3718 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
>  	RISCV_ISA_EXT_ZIHINTPAUSE,
>  	RISCV_ISA_EXT_SSTC,
>  	RISCV_ISA_EXT_SVINVAL,
> +	RISCV_ISA_EXT_SMAIA,
> +	RISCV_ISA_EXT_SSAIA,
>  	RISCV_ISA_EXT_ID_MAX
>  };
>  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index 1b9a5a66e55a..a215ec929160 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
>   *    extensions by an underscore.
>   */
>  static struct riscv_isa_ext_data isa_ext_arr[] = {
> +	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> +	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),

This will conflict with that ISA string refactoring I just merged.  It 
should be a pretty mechanical merge conflict, but if you want we can do 
a shared tag with the first few patches and I can handle the merge 
conflict locally.

>  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>  	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>  	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 93e45560af30..3c5b51f519d5 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
>  				SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
>  				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
>  				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
> +				SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
> +				SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
>  			}
>  #undef SET_ISA_EXT_MAP
>  		}
