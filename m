Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC87696E1
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjGaM5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjGaM5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:57:17 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F61E46
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:57:16 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fe21e7f3d1so4382533e87.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690808234; x=1691413034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RFhza85n34YdBGQ3np4adGOz+d7KJkgXl8a6XQ2Pqag=;
        b=erDK9JS6y/odZNp7MFqiC3ckDq18Ca7KxVQDGdN/6+yuEuwMa3AshB+5L9mkNa8fO2
         GU0TPg8BNT08GwRTZpPNHsv/5LXaqMm98sL7xNp74dGctl70MDRQPKk2QyI1640dvulm
         JVvt7o5KFizQ0ewetP+MaC/BYntC6BPcTvNreBOfokkp+WtjRABGGlsSzQtEO6xBUOea
         0utId7+hoKiyqFTvY9+sQ0J7YsXLo3xJX1cBDq+Z6Qex7rSgn9Gb51uFJN0vTQRu41SI
         GY2qQnDqb+6hOIe6aaAzdatfBgb+DZC1frG82OLxNnydI/ZvB9XqBxMwWzZe98+sckdG
         kY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690808234; x=1691413034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFhza85n34YdBGQ3np4adGOz+d7KJkgXl8a6XQ2Pqag=;
        b=VKW0wFKgyhj84XwYuNjs5Fg5umNbiMbWxo2zMGS37JxvG+RFvffW7TmMc9/LOwvTMM
         /GHIhBJjWZb/YanWqLu0JYUPvEoYPbZ9BmW/HukdkyfZAVGsAxhrgWsaSdM79l2ieilJ
         bRe3oJ9Al685iw/lm+0hyXXFMNPQ8Q+/ZsKu2H5ks4c7BLZb29EuwaaWjNZOF6K6TjfP
         oy0IpOIblcNfHw5yIJrMdE0/YgevfplqlBlO5rYON5BKBabHe8xVoydVU3mkw37NqB5v
         CQSX8KNTXt8qR8/OBq3XjVsOZ+LVcjCXU23quRu/+dVtia7ji8W5c64EXYufr1isz9UK
         KqNA==
X-Gm-Message-State: ABy/qLZK2kTLSIjjX2uu1tp6EQVCDhXA3vbu1tj12WUMnnMFqutySDwD
        YLyDsl0MlGOYFT47O3TOqE40Qw==
X-Google-Smtp-Source: APBJJlENWc7vvjXU8g36et3FnRv9uFXJFmcy0z1jxOVP2hZ1bVoYR79Vf2/YMrKCabfqfqdXvobgjA==
X-Received: by 2002:a05:6512:348f:b0:4fb:8616:7a03 with SMTP id v15-20020a056512348f00b004fb86167a03mr4974177lfr.4.1690808234457;
        Mon, 31 Jul 2023 05:57:14 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x4-20020aa7d6c4000000b0051e2cde9e3esm5454619edr.75.2023.07.31.05.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:57:13 -0700 (PDT)
Date:   Mon, 31 Jul 2023 14:57:12 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH 5/6] RISC-V: KVM: use EBUSY when
 !vcpu->arch.ran_atleast_once
Message-ID: <20230731-a4cd05af8a738c2d1fe8a120@orel>
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
 <20230731120420.91007-6-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731120420.91007-6-dbarboza@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 09:04:19AM -0300, Daniel Henrique Barboza wrote:
> vcpu_set_reg_config() and vcpu_set_reg_isa_ext() is throwing an
> EOPNOTSUPP error when !vcpu->arch.ran_atleast_once. In similar cases
> we're throwing an EBUSY error, like in mvendorid/marchid/mimpid
> set_reg().
> 
> EOPNOTSUPP has a conotation of finality. EBUSY is more adequate in this
> case since its a condition/error related to the vcpu lifecycle.
> 
> Change these EOPNOTSUPP instances to EBUSY.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 42bf01ab6a8f..07ce747620f9 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -209,7 +209,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>  			vcpu->arch.isa[0] = reg_val;
>  			kvm_riscv_vcpu_fp_reset(vcpu);
>  		} else {
> -			return -EOPNOTSUPP;
> +			return -EBUSY;
>  		}
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
> @@ -477,7 +477,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
>  			return -EINVAL;
>  		kvm_riscv_vcpu_fp_reset(vcpu);
>  	} else {
> -		return -EOPNOTSUPP;
> +		return -EBUSY;
>  	}

I think we should allow these ran_atleast_once type of registers to be
written when the value matches, as we now do for the other registers.
EBUSY should still be returned when the value doesn't match, though.

Thanks,
drew
