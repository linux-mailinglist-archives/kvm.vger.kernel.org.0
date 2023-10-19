Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18E67CF320
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjJSIqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjJSIqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:46:45 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A0310F
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:46:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-32dcd3e5f3fso1264427f8f.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697705202; x=1698310002; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FirHlCGgMz/FvpzIKQkoBCDO6SGDDg5U9N5KzhQ/LwY=;
        b=M+bRJ0N64mXHeowvT6EHhoGdfEzMFYyLN/bla2lLRUx+GkKhxDDcejVsvqFHHoBT9v
         PWRFXzSQQvog2wP9JmZziHGIlImoAQxfz4JzZPiR3qWCoE5HGoxmU7qIyeEodz7CA33u
         TDfLa2e53MSsoYbcf7smyVho7qVQn2jidrErCGBYwRvfOaSjrp+PWf+BRdgWGrBa88Ev
         j5I9im9yJiLAGJW1u4hvGyoAdIm2DxD2gO4pEhMz4dtGl504zpao8MUmp5EwH6E3c3lW
         mL0bKidCGXzs+PXy6FXC/9q/FjbgmuSrankUynWGWSHLvgarjbIn9ods9/P/w3J8eMt8
         DzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697705202; x=1698310002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FirHlCGgMz/FvpzIKQkoBCDO6SGDDg5U9N5KzhQ/LwY=;
        b=rEBZ5FBfMfhPX85o1d1OfwA6u6AxG9azx7OnUF/qWZefCLHR7mSrBIqE9j2rgffPWf
         mtAR1Qnv7AtnZxC26QIQRNMkTaOQbeusStCB4jrBiJ7QiYHxAL8cK4wJCzD5N8/ap1Vc
         xEJCYG3HKbjxn2wp3QbeJorVS7InjdRU+3DS03i9mWEGxyv+B/kDrYEvCE74D/2wTMz9
         TiIy+dKemDFbCl2dg1KukMYPa7rcpQtJg7bOzhY4cUSCicBtpk0qpcTyOKTbLQBTBKM/
         cp8CGiZNCqZadqhRAW0xnGQHUNprBdPcWxWLb8HofZKs+ePGbK1dTPyTD4WeSwCuJFDB
         kv9Q==
X-Gm-Message-State: AOJu0YwZrQY5qWSM3EYx8bhTY43ql3aopZ5vL/Z0RLWWjmQYilw4U9yM
        Vd7o1R1qDFUbk2n9z1k4kudiZA==
X-Google-Smtp-Source: AGHT+IHIrPhAgCqHiVC0M3rtirooHgesr0AO+GlYhKykcNrHjz1YNAMNd8HgQcR133zWbZZBLn3Q5w==
X-Received: by 2002:adf:cd83:0:b0:329:6be4:e199 with SMTP id q3-20020adfcd83000000b003296be4e199mr1046765wrj.13.1697705202536;
        Thu, 19 Oct 2023 01:46:42 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d6750000000b0032dc1fc84f2sm3960900wrw.46.2023.10.19.01.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 01:46:42 -0700 (PDT)
Date:   Thu, 19 Oct 2023 10:46:40 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] RISC-V: Enable SBI based earlycon support
Message-ID: <20231019-08c33e28cf77beab61519f49@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-9-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-9-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:45:09AM +0530, Anup Patel wrote:
> Let us enable SBI based earlycon support in defconfigs for both RV32
> and RV64 so that "earlycon=sbi" can be used again.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/configs/defconfig      | 1 +
>  arch/riscv/configs/rv32_defconfig | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
> index ab86ec3b9eab..f82700da0056 100644
> --- a/arch/riscv/configs/defconfig
> +++ b/arch/riscv/configs/defconfig
> @@ -132,6 +132,7 @@ CONFIG_SERIAL_8250_CONSOLE=y
>  CONFIG_SERIAL_8250_DW=y
>  CONFIG_SERIAL_OF_PLATFORM=y
>  CONFIG_SERIAL_SH_SCI=y
> +CONFIG_SERIAL_EARLYCON_RISCV_SBI=y
>  CONFIG_VIRTIO_CONSOLE=y
>  CONFIG_HW_RANDOM=y
>  CONFIG_HW_RANDOM_VIRTIO=y
> diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
> index 89b601e253a6..5721af39afd1 100644
> --- a/arch/riscv/configs/rv32_defconfig
> +++ b/arch/riscv/configs/rv32_defconfig
> @@ -66,6 +66,7 @@ CONFIG_INPUT_MOUSEDEV=y
>  CONFIG_SERIAL_8250=y
>  CONFIG_SERIAL_8250_CONSOLE=y
>  CONFIG_SERIAL_OF_PLATFORM=y
> +CONFIG_SERIAL_EARLYCON_RISCV_SBI=y
>  CONFIG_VIRTIO_CONSOLE=y
>  CONFIG_HW_RANDOM=y
>  CONFIG_HW_RANDOM_VIRTIO=y
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
