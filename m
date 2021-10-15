Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BCA42F38D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbhJONeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 09:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239813AbhJONcu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 09:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634304643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TzclPTF3LlBIf4dbbRNEyBzW3ai4bqqCccg0ARotygI=;
        b=crYAenY2G1RE7Ie5Fcpy4+2nil1KetSJswBZ1HkHS7maZjWqxZr30IJ2B/bxzaNnOLvPIb
        ioa2HpWBoFUVq3oFlDXRAqMEsPShHpqdinF6UfZm4fOIbw69G7RKnBJ5gyCsbAFW0txR54
        lGtEXVD6Cm59Exm0c4LctxdoOnOUCEk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-laQ37q_cOO-iJC8D29JyVA-1; Fri, 15 Oct 2021 09:30:42 -0400
X-MC-Unique: laQ37q_cOO-iJC8D29JyVA-1
Received: by mail-wm1-f71.google.com with SMTP id p63-20020a1c2942000000b0030ccf0767baso876173wmp.6
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 06:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TzclPTF3LlBIf4dbbRNEyBzW3ai4bqqCccg0ARotygI=;
        b=MlMSrxQHjLxccexDKp+vrr/99KxswJSYW578he/1RFvkzPd2BVwUWyF4mJkvkeSAd6
         wQKHPwWUdTTTD6cQm/uDQtJJ7oaBy045jrMjKdSJgPohrYkA2qcnN0qMqpcOgRnQBgDj
         Rsbl8k/uWll9xbZwaxwigB1jyfhSl/vg2CrSlw8lIw0EHpspUjivnoos/qkUyKnbv+mv
         VU5TAqN7izc/dKtvYIcQ2qgORSYZSfliEImn9Nh+avO0zv4FCFaVzzlZVkEUUNXgRFNh
         9LkuTrmuITEGv8dXgH0Nulk3hM9Clt+nrrEpXN+PGWepnGL6MLC2B4puozlmAbQVgrvj
         QtJA==
X-Gm-Message-State: AOAM530Dx10jUUuIgvK+sWQHKk6Qe8MGNzwDMT3xwgfWTCVb6J560R1O
        sxiVEXJtD/QTpOVJvUOL5f0p+DQUXYDM6b1ezjmzt63SCvqaiDcRDmwOw9V4O06IY5Oo5LsJzZD
        0MtVHjH3OkwMg
X-Received: by 2002:a05:6000:188e:: with SMTP id a14mr13773715wri.223.1634304640907;
        Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUVezSIzJykePD1chYmayDwCb5Y2ipNT/EUSs/rogejtsd3QRAM6NctsUUaVjY+/q5r5cySQ==
X-Received: by 2002:a05:6000:188e:: with SMTP id a14mr13773693wri.223.1634304640760;
        Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id y5sm4715733wrq.85.2021.10.15.06.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:30:38 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH 03/25] KVM: arm64: Introduce a validation function
 for an ID register
Message-ID: <20211015133038.xfyez4rvxbs5ihmg@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-4-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012043535.500493-4-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 09:35:13PM -0700, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value that KVM
> can support.
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set can be supported by KVM on
> the host.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..eda7ddbed8cf 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 6ec7036ef7e1..d146ef759435 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3114,3 +3114,29 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  		return sprintf(buf, "Vulnerable\n");
>  	}
>  }
> +
> +/*
> + * Check if all features that are indicated in the given ID register value
> + * ('val') are also indicated in the 'limit'.

Maybe use @<param> syntax to reference the parameters, even though this
file doesn't seem to adopt that anywhere else...

> + */
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> +{
> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> +	const struct arm64_ftr_bits *ftrp;
> +	u64 exposed_mask = 0;
> +
> +	if (!reg)
> +		return -ENOENT;
> +
> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> +		if (arm64_ftr_value(ftrp, val) > arm64_ftr_value(ftrp, limit))

Hmm. Are we sure that '>' is the correct operator for all comparisons? It
seems like we need a arm64_ftr_compare() function that takes
arm64_ftr_bits.type and .sign into account.

> +			return -E2BIG;
> +
> +		exposed_mask |= arm64_ftr_mask(ftrp);
> +	}
> +
> +	if (val & ~exposed_mask)
> +		return -E2BIG;

I'm not sure we want this. I think it implies that any RAO bits need to be
cleared before calling this function, which could be inconvenient.

Thanks,
drew

> +
> +	return 0;
> +}
> -- 
> 2.33.0.882.g93a45727a2-goog
> 

