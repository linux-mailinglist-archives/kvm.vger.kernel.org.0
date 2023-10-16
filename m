Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12C07CB370
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjJPTps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjJPTpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:45:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF1F9F
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697485505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04LjIwtYGGBaqDl5gBQzyzheSzqfZG47EyQuGN124eA=;
        b=I9h42jZanEpTNllAXow6dpz3jyxVjIp8mFx6WLUWVlEKhu5pe7KZQy03TBYYwjlP/KeQHE
        fdlKV3KDZMo+CNAIYAoSoHQ+YpeoeWUMnPT2H6+oJTtfhk1gcbKTLhKzS91Qj8G+UdVICf
        1ZEgCgQZO6mGJo1LbPfgUlRTiQJKbhg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-HkKEKaq_MSClaEqh0COgxA-1; Mon, 16 Oct 2023 15:45:03 -0400
X-MC-Unique: HkKEKaq_MSClaEqh0COgxA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66d062708b0so59923986d6.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485503; x=1698090303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04LjIwtYGGBaqDl5gBQzyzheSzqfZG47EyQuGN124eA=;
        b=N34sRTC/LlSLRpXZ+F9/5+bVOXSyUs1yMeICxxsfLVSw62GszKhrIbOyTjxobheo23
         Mf7iczUP1HipRv8YGTE1ImG8T27PlP3oqVVp6JVvbzB7Durgq77iMGnuXlieVgE/Nkv6
         oWnCPX4wKP8KoGYodoA2JLJ6fWzRKtKp7AEz3dbscqvTNZ9zZ396hWFUDU3dYqcWd15h
         2elMuFh0lQnBDjqS6PcRV18vkRD7/8N5J7c4nZ7s/+ztHe+alOEJKhQUWSJQLIUZVoU2
         fm9ouOatuHKPCmI3lfzSkjIg9Sy4px8MC3NqF73R9KefoTTyHe/TrgEg4tZxURs3OQqr
         QDNQ==
X-Gm-Message-State: AOJu0Yxlajhm4vRTfu89RwSto/QloU7Wpsw7IQ2Uo6nCTb7cSHKSzUOs
        tA30vUC781nkTPHyf5HVl3ma7S3GjQ86t880vyws3nsN1woJlaKQ+X0YZhX2RPog+czANISL0Sb
        elbe9mjIRDQzi
X-Received: by 2002:a05:6214:c49:b0:66d:114c:bdd5 with SMTP id r9-20020a0562140c4900b0066d114cbdd5mr477432qvj.39.1697485503123;
        Mon, 16 Oct 2023 12:45:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv0GXtH++psTY27fTmUPNDZligDmsLJ+tncVL81/Bq0tJgMaEP5J9Ly9VcQTdNnf7OsYUmKQ==
X-Received: by 2002:a05:6214:c49:b0:66d:114c:bdd5 with SMTP id r9-20020a0562140c4900b0066d114cbdd5mr477421qvj.39.1697485502861;
        Mon, 16 Oct 2023 12:45:02 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id e11-20020a05620a12cb00b0076db1caab16sm3256901qkl.22.2023.10.16.12.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:45:02 -0700 (PDT)
Message-ID: <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
Date:   Mon, 16 Oct 2023 21:44:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-4-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
PMOVS{SET,CLR}_EL0?
> This function clears RAZ bits of those registers corresponding
> to unimplemented event counters on the vCPU, and sets bits
> corresponding to implemented event counters to a predefined
> pseudo UNKNOWN value (some bits are set to 1).
> 
> The function identifies (un)implemented event counters on the
> vCPU based on the PMCR_EL0.N value on the host. Using the host
> value for this would be problematic when KVM supports letting
> userspace set PMCR_EL0.N to a value different from the host value
> (some of the RAZ bits of those registers could end up being set to 1).
> 
> Fix this by clearing the registers so that it can ensure
> that all the RAZ bits are cleared even when the PMCR_EL0.N value
> for the vCPU is different from the host value. Use reset_val() to
> do this instead of fixing reset_pmu_reg(), and remove
> reset_pmu_reg(), as it is no longer used.
do you intend to restore the 'unknown' behavior at some point?

Thanks

Eric
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 818a52e257ed..3dbb7d276b0e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> -{
> -	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> -
> -	/* No PMU available, any PMU reg may UNDEF... */
> -	if (!kvm_arm_support_pmu_v3())
> -		return 0;
> -
> -	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> -	n &= ARMV8_PMU_PMCR_N_MASK;
> -	if (n)
> -		mask |= GENMASK(n - 1, 0);
> -
> -	reset_unknown(vcpu, r);
> -	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> -
> -	return __vcpu_sys_reg(vcpu, r->reg);
> -}
> -
>  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	reset_unknown(vcpu, r);
> @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
>  
>  #define PMU_SYS_REG(name)						\
> -	SYS_DESC(SYS_##name), .reset = reset_pmu_reg,			\
> +	SYS_DESC(SYS_##name), .reset = reset_val,			\
>  	.visibility = pmu_visibility
>  
>  /* Macro to expand the PMEVCNTRn_EL0 register */

