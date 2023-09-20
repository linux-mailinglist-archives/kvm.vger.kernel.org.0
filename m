Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206637A748B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 09:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjITHoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 03:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbjITHok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 03:44:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BFAED
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 00:44:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-313e742a787so369990f8f.1
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 00:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695195871; x=1695800671; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cx5iccFvgcy7SfhkU5VK+FkZItyjUgRW2eoOl85UWN0=;
        b=mUvsG4BUv+wqri5oScmAmkx2R/A4EG8v+fU8ZWF2dFWv7yDXtV34PsUwVqY4jq3WPf
         MtclqmNFtjuUbfNoCMw0mBUz9RSeuJ3D1KY8aK7+YdjEdSyuMLi7tF9i0tggxUrfZd6A
         U9PzEsHJCdhaJhB7gVdhLsgkAFGu4DB/nrNVZS/3zJqPFtqVs+b/9kxr6ChXkB4ZhEas
         6Ki3ulT0AJsIUtgYBrWzS/a3MQdhmRRqvdaSbjsVRPmwIaB3hntdisxw3Y63v5TgCRfB
         qlByJM4o7N4prSNFUCh4F8F8QiuN7uHJn8hmdsdtt3uSnWwcCW6Sa9iUEonr0AI/H3xa
         edvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695195871; x=1695800671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cx5iccFvgcy7SfhkU5VK+FkZItyjUgRW2eoOl85UWN0=;
        b=g89HWQP5ikBDsYiZ3HG0W0QesZKGIipvT13QJxh94jZkb9FdIwFkgqlp++JEkwJp0g
         7pLkIhDhRop04WBauqq0Np5Ngg6xTD5tox8soUC5qDrNP/Bv8+IcAQg4q8+sUOM38Ttq
         8ScviRzE+S5n/MFh4BNcvfFUrMhMJZ9lxQnmS2EWxu2uv03nSwvPf4YKIadv8FMtetSg
         5D5Ssn5n1vjFM2t1nW772XhI2CuYQeL3vBnAZUvJVzQD2YG7aQsRwCuR4e8fa0rGnOB2
         RYhV5HlzW+fiu+iy8lxYh6rxKIwC8lGsjcaHYlEJ79gsAagt4O4gppn9RlktbtQlT/F5
         fugQ==
X-Gm-Message-State: AOJu0YzTZx97T08bYfki3rou71y/JDw58VNFtMCFQVzlhdlOWXTyskbg
        rUk+pvdZ9uQwAMDnGQT8W7WwWg==
X-Google-Smtp-Source: AGHT+IE9o5cHV0urm0ODENi3O9Ijn9lkPrkLZDxOpwqO/HAz0TCM7U3u4Zev5n0hHdafHw71Ec1kOw==
X-Received: by 2002:a5d:4286:0:b0:31f:e5cb:88e3 with SMTP id k6-20020a5d4286000000b0031fe5cb88e3mr3453401wrq.21.1695195871548;
        Wed, 20 Sep 2023 00:44:31 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id b17-20020a5d4d91000000b0031c855d52efsm17509312wru.87.2023.09.20.00.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 00:44:31 -0700 (PDT)
Date:   Wed, 20 Sep 2023 09:44:30 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/7] RISC-V: Detect Zicond from ISA string
Message-ID: <20230920-36a5645f766ed9cce75a9e8c@orel>
References: <20230919035343.1399389-1-apatel@ventanamicro.com>
 <20230919035343.1399389-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919035343.1399389-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 09:23:38AM +0530, Anup Patel wrote:
> The RISC-V integer conditional (Zicond) operation extension defines
> standard conditional arithmetic and conditional-select/move operations
> which are inspired from the XVentanaCondOps extension. In fact, QEMU
> RISC-V also has support for emulating Zicond extension.
> 
> Let us detect Zicond extension from ISA string available through
> DT or ACPI.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
>  arch/riscv/include/asm/hwcap.h                          | 1 +
>  arch/riscv/kernel/cpufeature.c                          | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index cad8ef68eca7..7ea90e2dbc5b 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -225,6 +225,12 @@ properties:
>              ratified in the 20191213 version of the unprivileged ISA
>              specification.
>  
> +        - const: zicond
> +          description:
> +            The standard Zicond extension for conditional arithmetic and
> +            conditional-select/move operations as ratified in commit 8fb6694
> +            ("Update Gemfile") of riscv-zicond.

As of yesterday, v1.0 of the spec points at commit 95cf1f9 ("Add changes
requested by Ved during signoff")

> +
>          - const: zicsr
>            description: |
>              The standard Zicsr extension for control and status register
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index b7efe9e2fa89..15bafc02ffd4 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -60,6 +60,7 @@
>  #define RISCV_ISA_EXT_ZIHPM		42
>  #define RISCV_ISA_EXT_SMSTATEEN		43
>  #define RISCV_ISA_EXT_XVENTANACONDOPS	44
> +#define RISCV_ISA_EXT_ZICOND		45
>  
>  #define RISCV_ISA_EXT_MAX		64
>  
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 3a31d34fe709..49b6551f3347 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -174,6 +174,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>  	__RISCV_ISA_EXT_DATA(zba, RISCV_ISA_EXT_ZBA),
>  	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
>  	__RISCV_ISA_EXT_DATA(zbs, RISCV_ISA_EXT_ZBS),
> +	__RISCV_ISA_EXT_DATA(zicond, RISCV_ISA_EXT_ZICOND),

Zi extensions come before Zb extensions.

>  	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
>  	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
>  	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> -- 
> 2.34.1
>

Thanks,
drew
