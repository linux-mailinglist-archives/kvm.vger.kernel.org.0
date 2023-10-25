Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE2A7D6D82
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbjJYNm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjJYNm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:42:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4121A138
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:42:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-540c54944c4so1941652a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698241344; x=1698846144; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=maqcF9SQDf3PxmvOc1+c8KchYpqraLaZwhAUKUz7hC0=;
        b=ddxvAfDRLBbEL6O11KPq+LPwL5IZl3BRdHA6+b0+ObgSoe44Fi55M2upKoJtSKa6fj
         /1HwbgyKfg10Bg5xEKREgrjRDiUq4imCGR+q0djeUI8D/CzIqH3rnOCRQqzpgYP4TBer
         TGuPgpd1cfJKcdGs2ptCHw8yHMQ6FpSUCmUTBgTlCj6C/0lajXoI7Ec42s60qaKnGOmj
         auxr29X6Pck51XDxR/D6u9QtLDAFOAYji2GZ9JYVQjUtXwuJJeZ96HiPUn88kZyb/nHw
         heFOwkv7QZM04D/U5ys3csK4mVmcNL05WMwv8Ic/CBn3MsM+ryiHNIutB6uBgo0wnE00
         3MJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698241344; x=1698846144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maqcF9SQDf3PxmvOc1+c8KchYpqraLaZwhAUKUz7hC0=;
        b=YLOVfIwkw4V8XMBPP7ALEGd4+UAOvs09dfWfLTJuti8FhsHbfViun+R8YE/BADAwMX
         648lbWAc4qRUSRFZr3FB+J7sdTlSwvAnqq6dA9pvAPOEX1C7VeiSulFfo3i4LcDJISgJ
         6JudshuoqK1SUlvevtjY7s1M0T85elGGtt2bY5VmMsPphjPEK5JUj/o1RgAGJ9qlmxP0
         ik40kYkWh5QpoabNYtoDf3RWqrJAutqbeM77a2UP0tVOkGk2eGOISnXjlGvW6NW74w2A
         qunOGREpLThWBvJ1Ga1YXQCZKpjDaEdaSzH7hQKLFw7AcWZ3AQ2GYiMULFnhVA4s6Nua
         S3KQ==
X-Gm-Message-State: AOJu0Yy4L45ySIbcnyrlKIjFwQ/Sc5qyaCwYHPFAUpLTznrSoBe7+L6O
        IvoVk5TvRQKdDWmM3Hyf4EtDJw==
X-Google-Smtp-Source: AGHT+IFQwUzGpzvaW2YhkHx8E0XJrfKpMYmM+iShzsWp2Cy00wHs4GD67fdF57nc5r4sgBL8JLdSuQ==
X-Received: by 2002:a50:cbc1:0:b0:540:2b19:db with SMTP id l1-20020a50cbc1000000b005402b1900dbmr9442429edi.7.1698241343769;
        Wed, 25 Oct 2023 06:42:23 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7c6cd000000b0053e89721d4esm9475856eds.68.2023.10.25.06.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:42:23 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:42:22 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 6/6] riscv: Fix guest/init linkage for
 multilib toolchain
Message-ID: <20231025-58718d04ce00e6ce7bbd4ef2@orel>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-7-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918125730.1371985-7-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 06:27:30PM +0530, Anup Patel wrote:
> For RISC-V multilib toolchains, we must specify -mabi and -march
> options when linking guest/init.
> 
> Fixes: 2e99678314c2 ("riscv: Initial skeletal support")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index acd5ffd..d84dc8e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -223,9 +223,11 @@ ifeq ($(ARCH),riscv)
>  	OBJS		+= riscv/aia.o
>  	ifeq ($(RISCV_XLEN),32)
>  		CFLAGS	+= -mabi=ilp32d -march=rv32gc
> +		GUEST_INIT_FLAGS += -mabi=ilp32d -march=rv32gc
>  	endif
>  	ifeq ($(RISCV_XLEN),64)
>  		CFLAGS	+= -mabi=lp64d -march=rv64gc
> +		GUEST_INIT_FLAGS += -mabi=lp64d -march=rv64gc
>  	endif
>  
>  	ARCH_WANT_LIBFDT := y
> -- 
> 2.34.1
>

Looks good and like something that could be posted independently of this
series.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
