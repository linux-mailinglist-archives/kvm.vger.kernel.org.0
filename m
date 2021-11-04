Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D649F4456E7
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhKDQNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 12:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhKDQM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 12:12:59 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A84C06127A
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 09:10:21 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 2so4169766iou.1
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 09:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tUqoCGNnbxt+oywUiqReWRW9/LoLH193vc9R2cKGEpc=;
        b=oUHtN5yvmtuLU7Rt+p4AHRDksWqkQE+q3NqxcycZqtF9qmtzdBQ2tL5D+HqyyO/6T6
         6RAH0Gm9enHnLZalZqd5vPhRiGo2BfuVG1/UtiQ5AlwtVyQxemDr2UAwLCeojaWJY//d
         HNaQIvQ9Z/HOjrGtUSDqmFuin9f0hb4Y5NwlAWG/Qb2plZ0RdYYhu1GhofX6SKx3Fcec
         jwV3+ZgpfWp9BUkGER+zSl8pSOY4QNbMW2htCUrZqDu7/lMD/Gm1y3hTLz0Q76u2LZ7Z
         UzOJSTuv5DMxl/thqh42/QR39gXTNNEE4XRxPV9P0rl7usFCGjCvM9eOZ5QGb5QuEpX8
         Umtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tUqoCGNnbxt+oywUiqReWRW9/LoLH193vc9R2cKGEpc=;
        b=tQYohWKmhjuVa0ujv3N23l8ko6JWjr3aOF2+aZMOkg+xrYEASJTjjvHhExmC+i7/op
         lP9Fkrcx/peUSqUH1VLJ2zWerpa0nUA3U0ZNX/P3witZOzwdGVvbZgW3+bO+c6PP2cau
         R359TNSN7wT7WXRKiFdvv6rKGxO+nlQj+gEku9ukprVnojhRZT4ygr9qVwK/AehJ2lgj
         tkbMn9ekVjXeenECRRgL9BANbTRPd2GoVJ+JF3axoSUWrwLzdNw5+GXqdmN7f5fD51TZ
         MlUsFvgjqtUorFLAjSf8lxnbVX8OaWWSgXuGU4zeqMvjqAP8wPJ/MpGVCcfsfSsJXOMo
         sTeA==
X-Gm-Message-State: AOAM532/R6KNGZAX/R9l339p2CnVOBgTYZZFoHFqUfdH+cB2e7xCvhXX
        7gJ2zApe3oDbn6SKxN2tjpd0Zg==
X-Google-Smtp-Source: ABdhPJysdsBusunjAyJwyQgc6/PueGiLqEhbeMUOLxDa87sm4If+utgQP/RXb6DCfoSyUOfBj47T8g==
X-Received: by 2002:a05:6638:d84:: with SMTP id l4mr4682907jaj.30.1636042220331;
        Thu, 04 Nov 2021 09:10:20 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id w11sm2661526ior.40.2021.11.04.09.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 09:10:19 -0700 (PDT)
Date:   Thu, 4 Nov 2021 16:10:16 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH v2 01/28] KVM: arm64: Add has_reset_once flag for vcpu
Message-ID: <YYQF6HSMYDww1Gk7@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-2-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 11:24:53PM -0700, Reiji Watanabe wrote:
> Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> if the vCPU reset has been done once, for later use.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/reset.c            | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..9b5e7a3b6011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +	bool has_reset_once;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)						\
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5ce36b0a3343..4d34e5c1586c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_load(vcpu, smp_processor_id());
>  	preempt_enable();
> +
> +	if (!ret && !vcpu->arch.has_reset_once)
> +		vcpu->arch.has_reset_once = true;
> +
>  	return ret;
>  }
>  
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
