Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92167D562B
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343603AbjJXP0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbjJXP0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:26:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBBA30EA
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:23:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53d8320f0easo7154123a12.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698161038; x=1698765838; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W1fviiS1AszYTyj2li+p8PK0RJzrCXpglYTVJAued7Y=;
        b=otjX8eKeJEzy30ZThdsTCVbEsMo9u6P9f5L7Ymd10uNHDggvk5ow3yA6kdp/BMVyzw
         1aeDnZd2GtAy1NmgSrTOm9+11gcUluA4OajWZZ3uaT82bZqL5b3pqU7ui/4YlfTQiPqA
         H0y6hRYhTqAUzp8g4oFqQ/SxOioamiFrKRjjc/eABY6frw9Se1vLY8d1mhRITY9PLOC4
         YqnpdJe4slph4GLNlkT+2yDv7XHlDY+1mzk9gefVw6Kq/AHXU19mJT+gkhOBvLB6kWbQ
         tohocRJ6eBebmaH/zxpANQXvQOF5jZ21vO1g7nemQIGpYRIXn90moegz2wnX7KMhJyeS
         vx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698161038; x=1698765838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1fviiS1AszYTyj2li+p8PK0RJzrCXpglYTVJAued7Y=;
        b=wb/X7AjQAlW4DiLKgYQJxJwwwFisOqwDH87KvqsXu+m5ygH5BkTSIUBUF3v5DNmLlo
         Hp6yWLKhT3PRoAo43bHXP6+T6KsQUfMTnuJXlnUoGfSaSpbKlqhic8DGEN0Dn2CC/ShF
         bZfv5l9kakKk9SdI3FryIYtgpA0U11MA3NP2rf3GCCr2aGyHq6kSgpDnQ1GepHXitRrP
         zijefeIUOkvDTJrbMOvBEl6jPXSPVJMLVpc9deaLGaAGvJv2OvARtGyiOIbjSv2u67K9
         9PrJH4p3xpObSeLbF4P5XuBc88wnRZqbn/NhncC1pbUH/ipF7NstccuhIxKwFnO1uPLd
         giLw==
X-Gm-Message-State: AOJu0YxSA7bzpksb0p0L5pxDtc6uCxQ0xRK5glw4alg+oG7Dfk0vzYM/
        XXn/MDrQhjH5coE5dgeZUldpJw==
X-Google-Smtp-Source: AGHT+IHosvnhTLuVYkeXIvJ7KzqWh5m4Y6kWu6GMxO2clq9pqbrTRL9hn3cSr81QKm1O62OOf9in3g==
X-Received: by 2002:a50:c35c:0:b0:53d:b6ac:5f64 with SMTP id q28-20020a50c35c000000b0053db6ac5f64mr9069019edb.18.1698161038062;
        Tue, 24 Oct 2023 08:23:58 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ch28-20020a0564021bdc00b0053ff311f388sm6572487edb.23.2023.10.24.08.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 08:23:57 -0700 (PDT)
Date:   Tue, 24 Oct 2023 17:23:56 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
Message-ID: <20231024-e122c317599cd4c6db53c015@orel>
References: <20231024132655.730417-1-cleger@rivosinc.com>
 <20231024132655.730417-3-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231024132655.730417-3-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 03:26:52PM +0200, Clément Léger wrote:
...
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
>  EXPORT_SYMBOL(__asm_copy_from_user)

I didn't see any comment about the sharing of debug info among both the
from and to functions. Assuming it isn't confusing in some way, then

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
