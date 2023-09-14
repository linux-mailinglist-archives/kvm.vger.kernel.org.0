Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4477A073D
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbjINO0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 10:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbjINO0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 10:26:06 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC08D115
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:26:01 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-401b5516104so10726605e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694701560; x=1695306360; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YG4jj4GnceKWHFc9CDsOyyvWCOlMS/zle7Y09KSgtKI=;
        b=g9aO+D0A7Vn87/QKbx6OjNyzvS41oJJljAbyt1gOMP0HFE/p0xVhJfDJyruCGJezsL
         0Xp8U7T7SpVCoNljpptT6C8MQ3S8eOsCAMOBtX1wFniGrHDubaDjs++2PM9seSsFmVRv
         i6pcY7ZcBzDbA+T4cOZtjvJYJPtWouq5DCINtoEMPlJYoUYS/7JstacfGZVNa56xbnxY
         x9YkPFKN26qHx9kqXWnJ4aq4rvwAbRCYuKu3warY8gcutISNPKUNITeesF+LbvuReeVl
         CA6RDVqiLMVMZaDVFD66wIuI5kGF2FlxSL1GXMa4JshALqWLyijVeJp3axBBWcHyd9kP
         urcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694701560; x=1695306360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG4jj4GnceKWHFc9CDsOyyvWCOlMS/zle7Y09KSgtKI=;
        b=w6vS8FI8dmN4WsoyQKCM/+bF8KEdY6Eq8lci+7nKkWTpAom/MntEvo1HEHpUItPuxs
         9H4DGa3PfyBeE158mVxlZMGX0hVyfOjdR9L2vDbnAS18BVSLh/gfHxhN090YK71UTXA2
         fiywi+2Wkovygd/ls7Rs0aIXZ71VOp3aLnm04Mi69knuuHMkLnQ5VgkAY21i3/SmcDzK
         LEIw8C8HHUfnXnwwLXGbdXAfWv9zD096G4AdMlgGjOA4kB4BpXNBkGgbqSHYff03Q7Kt
         yGWeigj9o1jAijKgSedx0TkzbHEkSMTjyAmrJA/vmcWV0ReqZOHerq8Wgi9ye8sdvhRC
         RtVw==
X-Gm-Message-State: AOJu0Yy1bvfOLp5jRWhoKZs4vwYpTzc69n/u3zcs3jJbrIMqiLSdXPZr
        uuPhajVq79rl1Zd0+JRHf7R0ZA==
X-Google-Smtp-Source: AGHT+IFWc50omqudDyR0Nh+pUUfbse+nkODV23h/mlFUP8m4u/vojRIjASaeifFA7VSOhcKfy6pcrw==
X-Received: by 2002:a05:600c:c8:b0:402:f5c2:c6d9 with SMTP id u8-20020a05600c00c800b00402f5c2c6d9mr5110748wmm.37.1694701559948;
        Thu, 14 Sep 2023 07:25:59 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id f7-20020adff987000000b0031c8a43712asm1914525wrr.69.2023.09.14.07.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 07:25:59 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:25:53 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     guoren@kernel.org
Cc:     paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, jszhang@kernel.org, wefu@redhat.com,
        wuwei2016@iscas.ac.cn, leobras@redhat.com,
        linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 03/17] riscv: Use Zicbop in arch_xchg when available
Message-ID: <20230914-892327a75b4b86badac5de02@orel>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-4-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910082911.3378782-4-guoren@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 10, 2023 at 04:28:57AM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Cache-block prefetch instructions are HINTs to the hardware to
> indicate that software intends to perform a particular type of
> memory access in the near future. Enable ARCH_HAS_PREFETCHW and
> improve the arch_xchg for qspinlock xchg_tail.
> 
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  arch/riscv/Kconfig                 | 15 +++++++++++++++
>  arch/riscv/include/asm/cmpxchg.h   |  4 +++-
>  arch/riscv/include/asm/hwcap.h     |  1 +
>  arch/riscv/include/asm/insn-def.h  |  5 +++++
>  arch/riscv/include/asm/processor.h | 13 +++++++++++++
>  arch/riscv/kernel/cpufeature.c     |  1 +
>  6 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e9ae6fa232c3..2c346fe169c1 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -617,6 +617,21 @@ config RISCV_ISA_ZICBOZ
>  
>  	   If you don't know what to do here, say Y.
>  
> +config RISCV_ISA_ZICBOP

Even if we're not concerned with looping over blocks yet, I think we
should introduce zicbop block size DT parsing at the same time we bring
zicbop support to the kernel (it's just more copy+paste from zicbom and
zicboz). It's a bit annoying that the CMO spec doesn't state that block
sizes should be the same for m/z/p. And, the fact that m/z/p are all
separate extensions leads us to needing to parse block sizes for all
three, despite the fact that in practice they'll probably be the same.

Thanks,
drew
