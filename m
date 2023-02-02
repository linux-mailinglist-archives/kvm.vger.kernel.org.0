Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD086881F7
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjBBP1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBBP1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 10:27:02 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB146AC
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 07:26:23 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso1675605wms.4
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 07:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7JvyQzIXrYzZCLKNZaj6R2VAhQkxcWFvbrbB71vdxiY=;
        b=NFzaXziAMdjXMefgcdiIfAgykFIib8kqV4hgNeJjK7p5d5YDI2LqUstwoCbzQzurAz
         io45S8prq1FQH4h5x5dwUpFdaBwyK3neV2Gx5dQQ3zg1scQDvsEqJkvO6Qh2+G4+8tdv
         Vw+VGgpptbsjVhDVpNayJJ0o0V4+wF94Ou9oCfK9m6VtQdLQKEK5wNUFP9oU2jT5c8rL
         DWsi+i/SGgJKRq4aN/PUXbz/yIxZjyi35j0Chyy649aw33SAdtKaUTOPhMB4aklU3Ktd
         cd1N75tJ+YuGpuCsDmQ9thbyXUhda0nxpCxP7sBXIq8wgp/ZS1qiASJYyX1WVlJkXYr9
         hZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JvyQzIXrYzZCLKNZaj6R2VAhQkxcWFvbrbB71vdxiY=;
        b=GOjAX9+WkcDjpK9kjwe8OKiZk3oG6VpcY+mv7L9EgamN0F4MrMHz0ku1JtJzS874EY
         wRfGJFUXdduDcsucoUeUsrYADF1Np4D2s+tZ0etvrRdmm3SQG2wyN+JER0nqwnYsy/5C
         kjqBpObm7iix4tZhFJrheqSiDDb89bHi/Xrazk2lN/uKvUdnTboEx+u/wHzg/6ogG0iP
         FJoTAFpz925RFfsWNQATcHelu+dS5JRWWzKZ3bDE/NOoYjFj47MVGTGF53gaxgzTsPRN
         kImAqTqahgoLfO0NkrN3K0GGkpajbpme16ug+uBuzYMiTyThus7k1GFN4ryOkQE9Cixj
         HKwA==
X-Gm-Message-State: AO0yUKWHhjzs39yE2voy2ub0qOxYW/IAg9RJzkyGQJ6CuuQxtmvSzlp0
        8IMW90SoW8WieO7IhlcymTyLnseFXgN8aQYg
X-Google-Smtp-Source: AK7set9A4n18kl9i4UwguaAeoWR339x/GVj5QRqPXZsZybE64WhTf8z+GJ2nA61mcrarXb55EnXjHg==
X-Received: by 2002:a05:600c:601b:b0:3db:2063:425d with SMTP id az27-20020a05600c601b00b003db2063425dmr6128224wmb.2.1675351581811;
        Thu, 02 Feb 2023 07:26:21 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c351000b003dc521f336esm41967wmq.14.2023.02.02.07.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:26:21 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:26:20 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 05/14] RISC-V: KVM: Return correct code for hsm stop
 function
Message-ID: <20230202152620.q4vfqqqtbz6cfyf4@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-6-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-6-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:41PM -0800, Atish Patra wrote:
> According to the SBI specification, the stop function can only
> return error code SBI_ERR_FAILED. However, currently it returns
> -EINVAL which will be mapped SBI_ERR_INVALID_PARAM.
> 
> Return an linux error code that maps to SBI_ERR_FAILED i.e doesn't map
> to any other SBI error code. While EACCES is not the best error code
> to describe the situation, it is close enough and will be replaced
> with SBI error codes directly anyways.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_sbi_hsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 2e915ca..619ac0f 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->arch.power_off)
> -		return -EINVAL;
> +		return -EACCES;
>  
>  	kvm_riscv_vcpu_power_off(vcpu);
>  
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
