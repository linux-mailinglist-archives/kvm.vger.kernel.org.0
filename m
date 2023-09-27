Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B997AFC06
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 09:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjI0H1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 03:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjI0H1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 03:27:13 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A2813A
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:27:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99bdcade7fbso1278149466b.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695799631; x=1696404431; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jicr0C9o+OP8Bl8W0wwK/zVRRNXHvssftPu6icJ2MsI=;
        b=XkVl8o123ihVz+lFiWu+F+e1d1duROYny3PDlo/G4YE4UPXS9pUtDLmFCRXvB7G6ew
         YNz2fb1rBUSLPyHyRb+TNJT1qIJMXQBoHHUitrjotTBZ6bsQMIXwVLCr0LjMVTXWdgyb
         dRp+BtJdP7HerJz8gpW4eFogwMCl7HyAY6ym1ZS3Z7pxDGIKHQrtk/J6TtubAb8CZtst
         fAiCrDsAC4M5KzQvx3ZJBWBAhTcM4UevrjMZlGxuomFyZEFHeZGfthzrZLB8h7Y/n/JS
         96w5AxYG0XDby/h4Dt12/5LbbDuXSUXTm09fnzDKmCJFbbbn82Sq679+OOvx8rzwk49K
         IYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695799631; x=1696404431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jicr0C9o+OP8Bl8W0wwK/zVRRNXHvssftPu6icJ2MsI=;
        b=uyo1u9GvkMM14WlvxFVP2imIpRt6C1JT0ltffXLftE9FsEo6pe+3gdsRwT9j5TvfM0
         o91Wt2DqwFvdIFJ0qjAJgKnU0hiXpQ81QPTc5Z2Ie9Zqxnhi9O4jUtc16IASXDQPZfOJ
         1doA7hlHlns1dyFz7YkQOLAMnZRdX07Ijf/Ea5n32yQWj0zMj5e+NzMypFfcqe4nKjsk
         rj3O+1otkKHedCoLS+IBuEYlDm1zAy/VBx4dUdiqpInsFvtytlmMmIRd6T4gqdDjvqNb
         tXVpR0uwb57wqYn0tQWa0ecD/PZS8SxYNkf9yIri2DTA9G2oLbDCdvmVkVXoN+MbBuju
         YLDA==
X-Gm-Message-State: AOJu0YwnNbkdnn8K8XoBvBo799+jv8iB1wVnXPorNpDd3xvY/WjlbWVS
        Dl4UiMiN2/wI5CuQfE2YDB002Q==
X-Google-Smtp-Source: AGHT+IGVch1VtqFhycPP9kneRFs/qrXR1z3hJ3lQWj3uG9ohGT7avGn+bJyDfZdr17bZiiLnFRcXdw==
X-Received: by 2002:a17:906:1dd:b0:9ae:42da:803c with SMTP id 29-20020a17090601dd00b009ae42da803cmr1014846ejj.48.1695799631122;
        Wed, 27 Sep 2023 00:27:11 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id lf11-20020a170907174b00b009ad81554c1bsm8776380ejc.55.2023.09.27.00.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 00:27:10 -0700 (PDT)
Date:   Wed, 27 Sep 2023 09:27:09 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        greentime.hu@sifive.com, vincent.chen@sifive.com, tjytimi@163.com,
        alex@ghiti.fr, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] RISC-V: KVM: Add Svadu Extension Support for
 Guest/VM
Message-ID: <20230927-408c4f85a0ee1d2caa1779f3@orel>
References: <20230922085701.3164-1-yongxuan.wang@sifive.com>
 <20230922085701.3164-4-yongxuan.wang@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922085701.3164-4-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 08:56:49AM +0000, Yong-Xuan Wang wrote:
> We extend the KVM ISA extension ONE_REG interface to allow VMM
> tools  to detect and enable Svadu extension for Guest/VM.
> 
> Also set the HADE bit in henvcfg CSR if Svadu extension is
> available for Guest/VM.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 3 +++
>  arch/riscv/kvm/vcpu_onereg.c      | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 992c5e407104..3c7a6c762d0f 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -131,6 +131,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZICSR,
>  	KVM_RISCV_ISA_EXT_ZIFENCEI,
>  	KVM_RISCV_ISA_EXT_ZIHPM,
> +	KVM_RISCV_ISA_EXT_SVADU,

This register will show up as "new" in kselftests test[1]. We should add
another patch to this series to update the test to handle/test it.

[1] tools/testing/selftests/kvm/riscv/get-reg-list.c

>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 82229db1ce73..91b92a1f4e33 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -487,6 +487,9 @@ static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
>  	if (riscv_isa_extension_available(isa, ZICBOZ))
>  		henvcfg |= ENVCFG_CBZE;
>  
> +	if (riscv_isa_extension_available(isa, SVADU))
> +		henvcfg |= ENVCFG_HADE;
> +
>  	csr_write(CSR_HENVCFG, henvcfg);
>  #ifdef CONFIG_32BIT
>  	csr_write(CSR_HENVCFGH, henvcfg >> 32);
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 1b7e9fa265cb..211915dad677 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	/* Multi letter extensions (alphabetically sorted) */
>  	KVM_ISA_EXT_ARR(SSAIA),
>  	KVM_ISA_EXT_ARR(SSTC),
> +	KVM_ISA_EXT_ARR(SVADU),
>  	KVM_ISA_EXT_ARR(SVINVAL),
>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
