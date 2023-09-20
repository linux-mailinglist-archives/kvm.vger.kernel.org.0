Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1651D7A75A4
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 10:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbjITITG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 04:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbjITIS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 04:18:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A37125
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 01:18:52 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4050bd2e33aso31550835e9.2
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 01:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695197931; x=1695802731; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LqBFN5FLB49lnK/5qmtGVnKUxCOh5CXzqPeEzI92Gus=;
        b=H/Q66Ri5aVz8NB1wAKAM3VNIBTPApCowNWaRlZopnkcBTDnIRvtVsrcvEApkM14cGJ
         K45ugsy/hyZMkcGKsxou6GqsGyszxX9AzfdO+Mog2ljcczoiGRU6Ofu2a+5b2bODg771
         CCLQEp3BtZ2eEcKT2yAEyQSPUOTeVXvhIzubmnj8JlxvZ9r8CuZdaNjHQodVs1hd7wuV
         +wHxfqt15K7ckzrhC+EGWhnk4LYd5QiIO5q7TsbvcoI6XoYyzZjDsYT6iN/mmNXbQxWu
         CNu0GzpTkQsH8Vjb/wkQI1Jxe7v2Yf2Q2D34wkIwmOsBGBqvKDzgrr8BGWH1QcIWWLpF
         RTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695197931; x=1695802731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LqBFN5FLB49lnK/5qmtGVnKUxCOh5CXzqPeEzI92Gus=;
        b=AqD2ETYalhOTWcQURQb++OIjs5OOn2bkVsMpLeIAdfp+7Fn/K6X4sRqQpyFutTffYM
         3NO7gBQKZ5orMw9zUwwDVY35ZVAdRP5IXqSxE3867CgKJF56G6IZXYUSpGts8EewaBVm
         ruoj5M7O9cvWKqBG5nk3rRpz/SOoQBZF/e5fErErOuhw25+rAII3xHFiLEJp2w8ORh+Z
         xqO9p8T1tX7sS6CVlfSzZYeN9UyjS8DwdAZISq2zriZ31ohyblZjFym05MQYr9xF1z/w
         tyjt8ldvio7Ypc3zmfTtwku5PYTEGFaKDw5J4G7eOPw0fWqnvNliQWWrbYgUIt2rAx1B
         QjGg==
X-Gm-Message-State: AOJu0Ywhghh/d5UIOLp/GoNjQqyuXpR02KBdImwuU6G3uKVXeqGixyf6
        9TqseR0r0Fn0S++5tHXUznqahQ==
X-Google-Smtp-Source: AGHT+IEL6XDWeA1RRkJT2O9NGVoH7Skvq4BGuzq8l9Y1wg1d+Qpftyi3lW7iMmOUd4m4gogg1F9R8g==
X-Received: by 2002:a05:600c:ace:b0:401:b53e:6c40 with SMTP id c14-20020a05600c0ace00b00401b53e6c40mr1791966wmr.10.1695197930897;
        Wed, 20 Sep 2023 01:18:50 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id c26-20020a05600c0ada00b00400268671c6sm1250996wmr.13.2023.09.20.01.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 01:18:50 -0700 (PDT)
Date:   Wed, 20 Sep 2023 10:18:49 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7/7] KVM: riscv: selftests: Add condops extensions to
 get-reg-list test
Message-ID: <20230920-d30b398a99804418792264c3@orel>
References: <20230919035343.1399389-1-apatel@ventanamicro.com>
 <20230919035343.1399389-8-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919035343.1399389-8-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 09:23:43AM +0530, Anup Patel wrote:
> We have a new conditional operations related ISA extensions so let us add
> these extensions to get-reg-list test.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 9f464c7996c6..4ad4bf87fa78 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -50,6 +50,8 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIFENCEI:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIHPM:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SMSTATEEN:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_XVENTANACONDOPS:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICOND:
>  		return true;
>  	/* AIA registers are always available when Ssaia can't be disabled */
>  	case KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_AIA | KVM_REG_RISCV_CSR_AIA_REG(siselect):
> @@ -360,6 +362,8 @@ static const char *isa_ext_id_to_str(__u64 id)
>  		"KVM_RISCV_ISA_EXT_ZIFENCEI",
>  		"KVM_RISCV_ISA_EXT_ZIHPM",
>  		"KVM_RISCV_ISA_EXT_SMSTATEEN",
> +		"KVM_RISCV_ISA_EXT_XVENTANACONDOPS",
> +		"KVM_RISCV_ISA_EXT_ZICOND",
>  	};
>  
>  	if (reg_off >= ARRAY_SIZE(kvm_isa_ext_reg_name)) {
> -- 
> 2.34.1
>

Don't we want to add test configs for these?

Thanks,
drew
