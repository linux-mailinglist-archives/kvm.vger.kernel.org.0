Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A339751D27
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjGMJ1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjGMJ1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:27:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7A26AD
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 02:27:00 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-991ef0b464cso380903966b.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 02:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689240398; x=1691832398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=15U9uDXPb/OlRHK4Y6KhNZVmgYaDgAPnXX1XqWhvPsI=;
        b=HLA30Uqe87y6+RDJyJFSiUhIT/2tJcVkH7pCTL2p2Q9QSWsfGte85IZrSqgvVVivFF
         jw4vmxezj6FPZjR+rlVrRBJfoTdiV0AAMWSJFUMrI/3TS9IPrI4gbL5KhVX7mIjf9hUl
         wN7O7KBUJwSA+H726e1BLClccCAw812x1MpuFmcAtzvWUGGpCd1yq3YV7zWHzV8EugTC
         XRj+4wbY6DAwy1FXStonDF5rLBZxcelaJvWjL1Vqkr5l3fQSirBCQOQH+RI/cGcy+IpM
         gKXRG8L30uws8zLEWWGOKkVmMSexDn7BdF2tSLthL+/8I5JODmePnlpNg6B/zZ1CD8r8
         3yLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689240398; x=1691832398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15U9uDXPb/OlRHK4Y6KhNZVmgYaDgAPnXX1XqWhvPsI=;
        b=Pcpn1/A6Sn72cN9V0jI8h2VgUHdSCk8ZzB44uXCefZe9YQNE6qfxCZFPQb0o4shCRL
         GuYQIY7kSuK8c4JY7nNLus1Qp3jQcYoJIDbUfD+QHnIkNmnZvFmZX9oNJXXLYFCM7p42
         BjG8OJdPX9ADveabq9MLuyayS2WthwpCpvlzKiE4/lqXJbLqQzwH3Q9eqbxrvSXP3JW2
         uGb3Do+Sbl+JLDcm6LjSBX8SYuoYmOtEWf7va5s3e/hvE7aU5LmFe1fcQMJ/skhefc1I
         x0o7+GygyH2MVETwuI9GkGFF/kfVS1fhOiatT68D80x4t2XKbSXaYM25/iy2fdFLlDdi
         9vuQ==
X-Gm-Message-State: ABy/qLaQPOJwfe3r4f3gylgxjz1KeP3hu13s4v67OzsRfypRnhPcjk1/
        IabEGVlhm151WXlOY5rIZbNLBQ==
X-Google-Smtp-Source: APBJJlHmTjnTAYkm3Z19cBosH9qp3zmPxyq9tVsa/Eyq79OXIqYKyMduKLtN3h0ITyRDHmVRkc0+yg==
X-Received: by 2002:a17:907:a410:b0:993:da5f:5a9b with SMTP id sg16-20020a170907a41000b00993da5f5a9bmr6076165ejc.8.1689240393511;
        Thu, 13 Jul 2023 02:26:33 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709063bc100b00992b7ff3993sm3710877ejf.126.2023.07.13.02.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 02:26:33 -0700 (PDT)
Date:   Thu, 13 Jul 2023 11:26:32 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v5 2/5] target/riscv: check the in-kernel irqchip support
Message-ID: <20230713-c8221857f478558194b4d5bd@orel>
References: <20230713084405.24545-1-yongxuan.wang@sifive.com>
 <20230713084405.24545-3-yongxuan.wang@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713084405.24545-3-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 08:43:54AM +0000, Yong-Xuan Wang wrote:
> We check the in-kernel irqchip support when using KVM acceleration.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  target/riscv/kvm.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 9d8a8982f9..005e054604 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -914,7 +914,15 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>  int kvm_arch_irqchip_create(KVMState *s)
>  {
> -    return 0;
> +    if (kvm_kernel_irqchip_split()) {
> +        error_report("-machine kernel_irqchip=split is not supported on RISC-V.");
> +        exit(1);
> +    }
> +
> +    /*
> +     * We can create the VAIA using the newer device control API.
> +     */
> +    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
>  }
>  
>  int kvm_arch_process_async_events(CPUState *cs)
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
