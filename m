Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2DF5B400A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiIITpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiIITon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 15:44:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0DE14994C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 12:41:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u22so2691823plq.12
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 12:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nFqa2TjcyXtG5LfkjrFfIDjlrSVISY6DMyya0dLw/08=;
        b=INWicGDVCHNjRChYQUf3p6ERzcoQzdyQwpLY9F5k31ibyYFWjpYoQkviCN8kRqCiJF
         u6ODVKBTjggi2n2vPWGFEfNgu8Me3at6plEEbvoFbeyyTnrvDa4a5I0zEpqsReX5u6nF
         z2CjcoMh4/7N23U+MFTYfrQta/jU8nffJE6zcIbKiyatnkYPk+Y6MQKi2F0cJPOQV/pn
         Nky6ZkNsVBnQwJKIMgc6PDfvbjoe6KfQ58n6kfSJNHlR2U6TtvvIJrcE1EhvsM5n/Vlv
         HinORdE4AdN/QvWtxw1ZnsX81lVnPY/xdKtJX30OkNiAt4U8AWpiBhZrzC/tgaNaVH0D
         Cdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nFqa2TjcyXtG5LfkjrFfIDjlrSVISY6DMyya0dLw/08=;
        b=aM5w88WBc5AIBullFmY6oC/IVu48jl0XUOa4djdofmNuScuYedxdV27gqM4kgsTgcn
         8s6p0KLW12PUw2pLfpOVJfSROiqcY2UGvYYQqdZytF+4uI+2w6s9W8jKncStnUyo/y2B
         HzcvAg8uR/CP8RGVB4EAzJUAze1ufJylK5M+2onCXsaq+zuqMDxyY07aXi/KIS0lfHZ/
         yL27SAN7dJSaLVki75jaCkYIxPO4qLkAJlueXtXAjGjO1G5O0vByxIkU4q27o6L1HRVW
         xdrDqMfCOVO5R/x6j6z+qrmjQgSkXWZML/UFrm8Ri8PqslqN9qjrZbBO4YF7thKeX3Qc
         4bbQ==
X-Gm-Message-State: ACgBeo2uDbQZ8Vr2fQ06dYSwbtRF/qqnp69jjQPkcxkHMuwRJiW0KAGm
        iWbZD9jsIlokmQlQOg0cDkXwbSXOAk4ZxQ==
X-Google-Smtp-Source: AA6agR5cccff42JYvlvNY5vl7unif/7zJ0ajNvKLi6sFiggxdBJLSQi0kZ5wx764yB3OEn8O+Aad/w==
X-Received: by 2002:a17:902:f683:b0:176:cc02:ce83 with SMTP id l3-20020a170902f68300b00176cc02ce83mr14899100plg.88.1662752456991;
        Fri, 09 Sep 2022 12:40:56 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l125-20020a622583000000b0053659f296a0sm126783pfl.8.2022.09.09.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 12:40:56 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:40:52 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r
 helpers in debug-exceptions
Message-ID: <YxuWxMPNYKuYcREX@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-3-reijiw@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 10:08:39PM -0700, Reiji Watanabe wrote:
> Introduce helpers in the debug-exceptions test to write to
> dbg{b,w}{c,v}r registers. Those helpers will be useful for
> test cases that will be added to the test in subsequent patches.
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
>  1 file changed, 68 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 2ee35cf9801e..51047e6b8db3 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -28,6 +28,69 @@ static volatile uint64_t svc_addr;
>  static volatile uint64_t ss_addr[4], ss_idx;
>  #define  PC(v)  ((uint64_t)&(v))
>  
> +#define GEN_DEBUG_WRITE_REG(reg_name)			\
> +static void write_##reg_name(int num, uint64_t val)	\
> +{							\
> +	switch (num) {					\
> +	case 0:						\
> +		write_sysreg(val, reg_name##0_el1);	\
> +		break;					\
> +	case 1:						\
> +		write_sysreg(val, reg_name##1_el1);	\
> +		break;					\
> +	case 2:						\
> +		write_sysreg(val, reg_name##2_el1);	\
> +		break;					\
> +	case 3:						\
> +		write_sysreg(val, reg_name##3_el1);	\
> +		break;					\
> +	case 4:						\
> +		write_sysreg(val, reg_name##4_el1);	\
> +		break;					\
> +	case 5:						\
> +		write_sysreg(val, reg_name##5_el1);	\
> +		break;					\
> +	case 6:						\
> +		write_sysreg(val, reg_name##6_el1);	\
> +		break;					\
> +	case 7:						\
> +		write_sysreg(val, reg_name##7_el1);	\
> +		break;					\
> +	case 8:						\
> +		write_sysreg(val, reg_name##8_el1);	\
> +		break;					\
> +	case 9:						\
> +		write_sysreg(val, reg_name##9_el1);	\
> +		break;					\
> +	case 10:					\
> +		write_sysreg(val, reg_name##10_el1);	\
> +		break;					\
> +	case 11:					\
> +		write_sysreg(val, reg_name##11_el1);	\
> +		break;					\
> +	case 12:					\
> +		write_sysreg(val, reg_name##12_el1);	\
> +		break;					\
> +	case 13:					\
> +		write_sysreg(val, reg_name##13_el1);	\
> +		break;					\
> +	case 14:					\
> +		write_sysreg(val, reg_name##14_el1);	\
> +		break;					\
> +	case 15:					\
> +		write_sysreg(val, reg_name##15_el1);	\
> +		break;					\
> +	default:					\
> +		GUEST_ASSERT(0);			\
> +	}						\
> +}
> +
> +/* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
> +GEN_DEBUG_WRITE_REG(dbgbcr)
> +GEN_DEBUG_WRITE_REG(dbgbvr)
> +GEN_DEBUG_WRITE_REG(dbgwcr)
> +GEN_DEBUG_WRITE_REG(dbgwvr)
> +
>  static void reset_debug_state(void)
>  {
>  	asm volatile("msr daifset, #8");
> @@ -59,8 +122,9 @@ static void install_wp(uint64_t addr)
>  	uint32_t mdscr;
>  
>  	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
> -	write_sysreg(wcr, dbgwcr0_el1);
> -	write_sysreg(addr, dbgwvr0_el1);
> +	write_dbgwcr(0, wcr);
> +	write_dbgwvr(0, addr);
> +
>  	isb();
>  
>  	asm volatile("msr daifclr, #8");
> @@ -76,8 +140,8 @@ static void install_hw_bp(uint64_t addr)
>  	uint32_t mdscr;
>  
>  	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
> -	write_sysreg(bcr, dbgbcr0_el1);
> -	write_sysreg(addr, dbgbvr0_el1);
> +	write_dbgbcr(0, bcr);
> +	write_dbgbvr(0, addr);
>  	isb();
>  
>  	asm volatile("msr daifclr, #8");
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
