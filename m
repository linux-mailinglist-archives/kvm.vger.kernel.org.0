Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CCB6D43F4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjDCMA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjDCMAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:00:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55269AD01
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:00:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so14361544wmq.3
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680523250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXOk+fnfr4jL/j1ia/s9JVKXSdrK1PkwEI4HTOkD6GA=;
        b=Aiyl6AAyRbBt5w0rsfEa85x8cuTauU+/JxQJwXYkwafXZXGnKlUf0Gp0IXrnu7TeZ1
         9K3WCHmVt5IM6Cn3dAkIs2IZmocG0PkOYE3cXt4X25eU6VuLThHari/ghOqiEKga0rr+
         I2n3jXj5c5Poaeolks2xVGHbQAY1A/PfL4Is9a9VRSfwvEfnlfEqk4hZLac+QHxwFLjf
         3Ymg9hWUOKUpUH9AaSZLjVxbRy7qRy2d1iiPK1RxWAJOW3XkU0VyLPXN3JgHHYWsSE7N
         vtSYfpZk8N/z4oSvdgaLSvq/NahW1rAISSabz7CdpDbCuiTqL6dVweY3Q9CN87xie2Gg
         GmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXOk+fnfr4jL/j1ia/s9JVKXSdrK1PkwEI4HTOkD6GA=;
        b=ygGxKdBAnnmGv1zW21AApJaXY5yUQ+RQ4BZk7mC1ZCdZfUHyeu8qldfAH2Sb/NBfWx
         MMDbxOKu/DFhfMERGJLjqv9u64DV/lVDuDjIt+napR3UvXvwrWE80YRD0frOIvvZ6uW4
         9TfemHw/g7CeXpHFKW1ht05FfC1YBoVq8xaekqjn0cSSzvDqx2wBVxsKXMWkIEOBn4G3
         9tFEVNeyYstnuSP0YZK9183ufla0AQzEx9m6LUFOTh7MYy0RaaDNYamCNfnHXYNf3YIz
         E8NTVo4pKBimd5DlaosRBsjxjHwH4SQXJsHvhlykqClCv4mGK7PD7yGEm0bbGRBU3MBi
         gvfw==
X-Gm-Message-State: AAQBX9cm4y0bnDwJgJeNjeIqQEUEQWkzfFVQS8zn1fcNV1PmZAfnKyzb
        AUnjspOCKiRA2DeV3egelvFKnQ==
X-Google-Smtp-Source: AKy350YajdxWM3Qq7qE4WZWIToU9nLi7VCOLfAcIS90bSHWdp98RoaT8dTwG4f/4sNtkqSt9sL9RZg==
X-Received: by 2002:a1c:7215:0:b0:3ef:d8c6:4bc0 with SMTP id n21-20020a1c7215000000b003efd8c64bc0mr13027828wmc.40.1680523249871;
        Mon, 03 Apr 2023 05:00:49 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v8-20020a05600c470800b003ef71d7d64asm19405599wmo.6.2023.04.03.05.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 05:00:49 -0700 (PDT)
Date:   Mon, 3 Apr 2023 14:00:48 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v3 4/8] RISC-V: KVM: Initial skeletal support for AIA
Message-ID: <3v5mew46z4kfa3kq4c5gdx72k7qh35qtk3tez26jthnbuygf2t@zy2lukq75ugv>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-5-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403093310.2271142-5-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 03:03:06PM +0530, Anup Patel wrote:
> To incrementally implement AIA support, we first add minimal skeletal
> support which only compiles and detects AIA hardware support at the
> boot-time but does not provide any functionality.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/hwcap.h    |   6 ++
>  arch/riscv/include/asm/kvm_aia.h  | 109 ++++++++++++++++++++++++++++++
>  arch/riscv/include/asm/kvm_host.h |   7 ++
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              |  66 ++++++++++++++++++
>  arch/riscv/kvm/main.c             |  22 +++++-
>  arch/riscv/kvm/vcpu.c             |  40 ++++++++++-
>  arch/riscv/kvm/vcpu_insn.c        |   1 +
>  arch/riscv/kvm/vm.c               |   4 ++
>  9 files changed, 252 insertions(+), 4 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
