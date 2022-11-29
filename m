Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1153B63B988
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 06:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiK2FqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 00:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiK2FqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 00:46:20 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306231DF8
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:46:19 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so9992792wmg.2
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 21:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HD7x5LbR33AXrxQu51beO1G2A7rcknzhC17f6V/q6WA=;
        b=BQUjUq/abpPMUKx7kDHWQPniuBMZ/SoyzcNBUx+f61DXcq6lSMqogL/vR9GTx1b939
         2YdZRlidock6vR4dUKjdGaX1xxBOWzKRsTRZ7LyY81iHEF4Cywyt81UTBUHfZaf1Esgi
         5U7sVwtZXhI/g3l55sBpTDvQSEPJProgt8GPRmuT9iaRHuZn6tv4s0l+wltoN+suBxkp
         Y5tNNpgPmgU+EtXvzQuTtrfqW3zDgfCshKEU1hTnDmkf5/z+dqx7FuhmpQ1sLoubRqUt
         6lWKhqbiArdmKg01wCgdKTAvnmtrUOV25vIfP2uEXzd95oKg/MjB/HrKjHOKLSBvBq26
         X7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HD7x5LbR33AXrxQu51beO1G2A7rcknzhC17f6V/q6WA=;
        b=Py7A/+WPa0eT1LQ7O+j8fq/6Uoqe0xhdNQKPgROwgkKUR1sjy+Vc9P+nYIsgVMY1W7
         7bjFth3Zimtt1QDtBrIpOo2OIB1mLE39j8KjcSGTC1NALV/CBRw85Zz/wRsbMfBcyZOe
         mfjpqkk8BFu95JAvUaw4BePQ+6Tr/xqEcTuY2n71nQPbc9m+4rA2ILoN+/Df4Svfdrhm
         9Kj9P4nHKcosSDQUVvIIOThaczNS/hSz2outscehLkYCHiDylz/33Bbqiw2fsB7A1LQj
         ih8Tz3e6MqAXyBp12PUAqEdA4M7waJuBt6fCvMB9pm2+6SeGd/EcsYS9PtmTyUY/EkQE
         IgSQ==
X-Gm-Message-State: ANoB5pkeUcbYn/TgwEt7TuDLpLAov2jvGbTGfIEtBkrrus77xY1ZYKPg
        T9AnTtVAsVNJiQVJxvk3OBR7Ug==
X-Google-Smtp-Source: AA0mqf5KLXL6iv9L9l1kcDPpytL/st2EhbV/q40zSXAbSz7I3BYA93wtvFGhaOW/fH+TVZ8dwXatug==
X-Received: by 2002:a05:600c:3d18:b0:3cf:b7bf:352d with SMTP id bh24-20020a05600c3d1800b003cfb7bf352dmr32068568wmb.106.1669700777581;
        Mon, 28 Nov 2022 21:46:17 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id p21-20020a1c5455000000b003b4cba4ef71sm698389wmi.41.2022.11.28.21.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:46:17 -0800 (PST)
Date:   Tue, 29 Nov 2022 06:46:16 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] RISC-V: KVM: Add ONE_REG interface for mvendorid,
 marchid, and mimpid
Message-ID: <20221129054616.4zju5z7ipg6wki7l@kamzik>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
 <20221128161424.608889-9-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128161424.608889-9-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 09:44:23PM +0530, Anup Patel wrote:
> We add ONE_REG interface for VCPU mvendorid, marchid, and mimpid
> so that KVM user-space can change this details to support migration
> across heterogeneous hosts.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  3 +++
>  arch/riscv/kvm/vcpu.c             | 27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 8985ff234c01..92af6f3f057c 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -49,6 +49,9 @@ struct kvm_sregs {
>  struct kvm_riscv_config {
>  	unsigned long isa;
>  	unsigned long zicbom_block_size;
> +	unsigned long mvendorid;
> +	unsigned long marchid;
> +	unsigned long mimpid;
>  };
>  
>  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 312a8a926867..7c08567097f0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -276,6 +276,15 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>  			return -EINVAL;
>  		reg_val = riscv_cbom_block_size;
>  		break;
> +	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> +		reg_val = vcpu->arch.mvendorid;
> +		break;
> +	case KVM_REG_RISCV_CONFIG_REG(marchid):
> +		reg_val = vcpu->arch.marchid;
> +		break;
> +	case KVM_REG_RISCV_CONFIG_REG(mimpid):
> +		reg_val = vcpu->arch.mimpid;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -338,6 +347,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
>  		return -EOPNOTSUPP;
> +	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> +		if (!vcpu->arch.ran_atleast_once)
> +			vcpu->arch.mvendorid = reg_val;
> +		else
> +			return -EBUSY;
> +		break;
> +	case KVM_REG_RISCV_CONFIG_REG(marchid):
> +		if (!vcpu->arch.ran_atleast_once)
> +			vcpu->arch.marchid = reg_val;
> +		else
> +			return -EBUSY;
> +		break;
> +	case KVM_REG_RISCV_CONFIG_REG(mimpid):
> +		if (!vcpu->arch.ran_atleast_once)
> +			vcpu->arch.mimpid = reg_val;
> +		else
> +			return -EBUSY;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> -- 
> 2.34.1
>

At some point we should patch Documentation/virt/kvm/api.rst to describe
the possible errors we have. It's missing EOPNOTSUPP and EBUSY.

Also, I see a couple places were we use EOPNOTSUPP that would be better
as EBUSY. And finally I wonder if we shouldn't use ENOENT when the reg_num
is wrong/unknown, which would allow us to differentiate between bad
reg_num and bad reg_val in set-one ioctls.

I can send an RFC series to better describe these thoughts.

And for this patch,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
