Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7564D4C7
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiLOAlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOAlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:41:08 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616A511F3
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:41:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d82so5646175pfd.11
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+9aFWIywW24+fuTbx+Qyc1HRmi+jILztX+FivWx3Q=;
        b=jb2ClHC0JzlU6/A7oG9wX2lIjW163wYAAsnuD7z6vHKLAJ6WCABdC0zHaJgH+vW1cJ
         X85wm2u0tBa3ucj4A9xYBR14n5W4lrDo4Z776KQYkYdhCQEQVA9T1mvhctnbGmU3BE4C
         WARNv31LD1wabhMMu+06rdt20q9faYRYxU+FQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1+9aFWIywW24+fuTbx+Qyc1HRmi+jILztX+FivWx3Q=;
        b=55ZpT5agGXcx5wYZo7fbxCP+VhXKABhbiJXRkwpuuwRjTtWCSC99ZVoy8btFo0gsQs
         E99O/6i7mkEARYEn52jubiyXptLv+ckYEFrDG41wchDyvpSIvA8SVHScx1npFfn2cfyL
         ukRVL7fGK4jeJErWtgyBcxPc3GM5A721dn/Oxnz0AUjOswQKSaqJYk/biz0xdt+7XTZl
         pCfA/omKANmYh0OZCUVY7a8C6LBwIaCcowrl710GGlSSPrdhgBk8OygvSDTP5jXokiX/
         Wxl/h5Hbx07A15krBiNwSQUZ25dP5EHvki5k0wi1Ep9BZjq2bXoN5p9bmesx8FVuepVD
         LrmA==
X-Gm-Message-State: ANoB5pnwFkJZH8DGd1iyCfw25zPjT+T8wA9oAKZcUwisfZKgPfg713gO
        m7DAgRXNWflAb8SfIcIKqVJ/VaOfJi9iGGalDuG3
X-Google-Smtp-Source: AA0mqf41r0jXtY+/17AH27nqYNOeQ6pZv+/Uw7fREISQYROGD50E5EiI8tulDjCBbhcj8fUBC5QzNKLSVNd4DxlDuwc=
X-Received: by 2002:a63:f4b:0:b0:46f:98cf:3bb6 with SMTP id
 11-20020a630f4b000000b0046f98cf3bb6mr68618832pgp.332.1671064864426; Wed, 14
 Dec 2022 16:41:04 -0800 (PST)
MIME-Version: 1.0
References: <20220921214439.1491510-1-stillson@rivosinc.com> <20220921214439.1491510-4-stillson@rivosinc.com>
In-Reply-To: <20220921214439.1491510-4-stillson@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 14 Dec 2022 16:40:52 -0800
Message-ID: <CAOnJCULtT-y9vo6YhW7bW9XyKRdod-hvFfr02jHVamR_LcsKdA@mail.gmail.com>
Subject: Re: [PATCH v12 04/17] riscv: Add vector feature to compile
To:     Chris Stillson <stillson@rivosinc.com>
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Oleg Nesterov <oleg@redhat.com>, Guo Ren <guoren@kernel.org>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Changbin Du <changbin.du@intel.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Barret Rhoden <brho@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 2:47 PM Chris Stillson <stillson@rivosinc.com> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> This patch adds a new config option which could enable assembler's
> vector feature.
>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  arch/riscv/Kconfig  | 15 +++++++++++++--
>  arch/riscv/Makefile |  1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index ed66c31e4655..e294d85bfb7d 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -432,7 +432,17 @@ config FPU
>
>           If you don't know what to do here, say Y.
>
> -endmenu # "Platform type"
> +config VECTOR
> +       bool "VECTOR support"
> +       depends on GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
> +       default n
> +       help
> +         Say N here if you want to disable all vector related procedure
> +         in the kernel.
> +
> +         If you don't know what to do here, say Y.
> +
> +endmenu
>
>  menu "Kernel features"
>
> @@ -556,6 +566,7 @@ config CMDLINE_EXTEND
>           cases where the provided arguments are insufficient and
>           you don't want to or cannot modify them.
>
> +
>  config CMDLINE_FORCE
>         bool "Always use the default kernel command string"
>         help
> @@ -648,7 +659,7 @@ config XIP_PHYS_ADDR
>           be linked for and stored to.  This address is dependent on your
>           own flash usage.
>
> -endmenu # "Boot options"
> +endmenu
>
>  config BUILTIN_DTB
>         bool
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 3fa8ef336822..1ec17f3d6d09 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -50,6 +50,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)      := rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)       := rv64ima
>  riscv-march-$(CONFIG_FPU)              := $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)      := $(riscv-march-y)c
> +riscv-march-$(CONFIG_VECTOR)           := $(riscv-march-y)v
>
>  # Newer binutils versions default to ISA spec version 20191213 which moves some
>  # instructions from the I extension to the Zicsr and Zifencei extensions.
> --
> 2.25.1
>

Kernel boot hangs if compiled LLVM and vector enabled. Because LLVM
enables auto vectorization by default and it inserts
random vector instructions.

We need to add "-mno-implicit-float" for llvm builds to disable auto
vectorization. Thanks Vineet and Saleem for the hint :).

-- 
Regards,
Atish
