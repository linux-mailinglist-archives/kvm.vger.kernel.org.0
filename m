Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2557D2F6A
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 12:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjJWKEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 06:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbjJWKEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 06:04:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9F0F7
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:04:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9bdf5829000so456988266b.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698055440; x=1698660240; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zx08EZvgl0rut/KB9vhuv+Y1Cl0tPVpq0Bjph7cTE4E=;
        b=f8Glfo9eKGIQASwVtPipy4T/HwESX9sKomR5Q3TqSTIRmYLmTZr/Q83yhnVqVOB0TL
         Fu92vbKCdfGdkG7Y8zsv6Y7hX1UY698G8rnT8OlWPCBsMo9LbfU6WHiD79q4ZUjYiBUw
         x4pxS7+Wvlu74hlujb8wd4OgotHASBQJVeonzIPXus9C01LvjrI5hY2/a59ahUwoyCqQ
         GCK4egN2FgpbDEoGTP9uhgzqOVWdtt5H99HJO9WzjWxmV25+XnisIkGJ7jaz2BVa4E2H
         xkTTLWzt9AXYC+fOFQytggNUh45PVTsr0bP0edIx9/HMs0jVlm3uQX5e1+MusGC4kM8Z
         B/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055440; x=1698660240;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zx08EZvgl0rut/KB9vhuv+Y1Cl0tPVpq0Bjph7cTE4E=;
        b=oubZmJvZpXIizPd7mBtxJ8MlYn3jqgshyaKlEGq1nYn5fb80d7MZg8D9v8Fu2CjG67
         RFYfCApN7XL7kyhEhKmjfU2vvl+/jzrRskdkE32/RPrB7WLQZVEuKW2nQo7KduvpQIy8
         DKXTB/uzgVGlKFB5e5PjKo8Qk/TGhvyRLngSi1koH5Ls/DEA0dKLPRtznt3+WY8sv516
         RaLlZYY51qn40trEPfFJ6JNUMgNyfy5OYD4aGYfbH9T4oa2uYiYiP1MA7dsuyW6HTFdF
         pzQdlzI1lA68CKcTUIB4azFL3v07/IpFvh0OpAo13M6JdmWTwwaxWB/1/apCl/Z3GoWb
         K/NA==
X-Gm-Message-State: AOJu0YyBbm1K21wNATaiLKBe4kCaZiIqEYY5TRezolJFfPjJWPOxgB33
        YvGFM84W4CX/aWEXMKP/qimjviEA/xlaF4+sg5Q=
X-Google-Smtp-Source: AGHT+IG3sS2mYytSxxYKysZeeec9WpQOjDiBbVsMrjyLfRgQIGoY7P02CFsd+W2kTdU6GUmUHdU71w==
X-Received: by 2002:a17:907:3f17:b0:9be:77cd:4c2c with SMTP id hq23-20020a1709073f1700b009be77cd4c2cmr6056230ejc.28.1698055440453;
        Mon, 23 Oct 2023 03:04:00 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id pj19-20020a170906d79300b009ad829ed144sm6355041ejb.130.2023.10.23.03.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 03:04:00 -0700 (PDT)
Date:   Mon, 23 Oct 2023 12:03:59 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 5/5] riscv: kvm: use ".L" local labels in assembly when
 applicable
Message-ID: <20231023-c9629db3ee7d3e845030bc26@orel>
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-6-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231004143054.482091-6-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 04:30:54PM +0200, Clément Léger wrote:
> For the sake of coherency, use local labels in assembly when
> applicable. This also avoid kprobes being confused when applying a
> kprobe since the size of function is computed by checking where the
> next visible symbol is located. This might end up in computing some
> function size to be way shorter than expected and thus failing to apply
> kprobes to the specified offset.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_switch.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 8b18473780ac..0c26189aa01c 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -45,7 +45,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
>  	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
>  	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -	la	t4, __kvm_switch_return
> +	la	t4, .Lkvm_switch_return
>  	REG_L	t5, (KVM_ARCH_GUEST_SEPC)(a0)
>  
>  	/* Save Host and Restore Guest SSTATUS */
> @@ -113,7 +113,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  
>  	/* Back to Host */
>  	.align 2
> -__kvm_switch_return:
> +.Lkvm_switch_return:
>  	/* Swap Guest A0 with SSCRATCH */
>  	csrrw	a0, CSR_SSCRATCH, a0
>  
> -- 
> 2.42.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
