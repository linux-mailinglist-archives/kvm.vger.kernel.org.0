Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7057CB3A2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 22:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjJPUDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 16:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjJPUDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 16:03:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDCBA1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 13:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697486571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cDXCAqtsqnxUo4mK2MChJM/H3xR/+sXfbuPMAFsDcQ=;
        b=Z3+Akf+5qqdmfQR2NRt0hv2ZUaD4Ng28nbTPiCc627hojUgQ+uh9spLOfgPHgcTfQjkAEX
        iC/Ux/CsmMA3W55sBg6jwTY0TcgOvVKE2dqEiIvbHJtINAvQ5bNXQ0RK+5Sscw/1mudR3V
        /mj6/Q0pZ/9PGnZ8GlN2Rf9/7DvXVMo=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-qyFThVBQNCGJ5HccP2AqPg-1; Mon, 16 Oct 2023 16:02:28 -0400
X-MC-Unique: qyFThVBQNCGJ5HccP2AqPg-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3ae65ecb25aso7855335b6e.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 13:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697486548; x=1698091348;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cDXCAqtsqnxUo4mK2MChJM/H3xR/+sXfbuPMAFsDcQ=;
        b=jVSA+g9tPMEvVEcrwwPm9XquVphWPlS5Jjb1sE2zSstsQET/W9IALDVi+nC+FPUMz8
         QDkhVWp5Oledv0/PXzOqiWdKaujqfinbjYcw+mlUxGzpgDhcXwU7YliL9bOS/SwifOr+
         Tg8tBlOuazf4mkp0U/DOzCsasBmtxplvjRD3RqubuWEh2f2KbJDaM6WnbeaGQxfAf6xv
         QdG9k9z4N738xe6LLjnl3yuUXmv2Pw+TO1jlREBVoKogi/IzWw5qSs8gUPjvWNVdKChU
         dX+ddZIXq6rsGS198UAhgUSEEQJKO2Fa0Xj97MAqF1Y64cgnLGV3nfDaqRY37vC3oWe1
         vdtQ==
X-Gm-Message-State: AOJu0YxVJcwzvYb9Yp6+5G3M6RoCeCeLL3S3IreWMgZR5Q6DDMqDbPEm
        jr8tSp6Vrwbqz6ypY+SdQmQ4GX4hK6quijl/Q1KHzSaViBT4oqNp5hBnoOtZHXGhskTZeXuPFfp
        xJ6sz0m+3YwAx
X-Received: by 2002:a05:6808:4393:b0:3a7:366f:3b01 with SMTP id dz19-20020a056808439300b003a7366f3b01mr322053oib.33.1697486547989;
        Mon, 16 Oct 2023 13:02:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQQelPzIZ1Z4qpFoQmZhLrek36aSRj6fh76IfyACLJ3DhaFuw1XJRec4cNnk5/qDYgoOfvHw==
X-Received: by 2002:a05:6808:4393:b0:3a7:366f:3b01 with SMTP id dz19-20020a056808439300b003a7366f3b01mr322029oib.33.1697486547704;
        Mon, 16 Oct 2023 13:02:27 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id g16-20020ad45110000000b0065b12c7a48dsm3674509qvp.133.2023.10.16.13.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 13:02:27 -0700 (PDT)
Message-ID: <2eb9c70b-1d7d-241b-0818-9340be896519@redhat.com>
Date:   Mon, 16 Oct 2023 22:02:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 05/12] KVM: arm64: PMU: Add a helper to read a vCPU's
 PMCR_EL0
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
 <20231009230858.3444834-6-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-6-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Raghavendra,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Add a helper to read a vCPU's PMCR_EL0, and use it when KVM
> reads a vCPU's PMCR_EL0.
> 
> The PMCR_EL0 value is tracked by a sysreg file per each vCPU.
file?
> The following patches will make (only) PMCR_EL0.N track per guest.
> Having the new helper will be useful to combine the PMCR_EL0.N
> field (tracked per guest) and the other fields (tracked per vCPU)
> to provide the value of PMCR_EL0.
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/arm.c      |  3 +--
>  arch/arm64/kvm/pmu-emul.c | 21 +++++++++++++++------
>  arch/arm64/kvm/sys_regs.c |  6 +++---
>  include/kvm/arm_pmu.h     |  6 ++++++
>  4 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 708a53b70a7b..0af4d6bbe3d3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -854,8 +854,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		}
>  
>  		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> -			kvm_pmu_handle_pmcr(vcpu,
> -					    __vcpu_sys_reg(vcpu, PMCR_EL0));
> +			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
>  
>  		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
>  			kvm_vcpu_pmu_restore_guest(vcpu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index cc30c246c010..a161d6266a5c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -72,7 +72,7 @@ static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
>  
>  static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
>  {
> -	u64 val = __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), PMCR_EL0);
> +	u64 val = kvm_vcpu_read_pmcr(kvm_pmc_to_vcpu(pmc));
>  
>  	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
>  	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
> @@ -250,7 +250,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  {
> -	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
> +	u64 val = kvm_vcpu_read_pmcr(vcpu) >> ARMV8_PMU_PMCR_N_SHIFT;
>  
>  	val &= ARMV8_PMU_PMCR_N_MASK;
>  	if (val == 0)
> @@ -272,7 +272,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> -	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
> +	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
>  		return;
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> @@ -324,7 +324,7 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>  {
>  	u64 reg = 0;
>  
> -	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
> +	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
>  		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> @@ -426,7 +426,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>  {
>  	int i;
>  
> -	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
>  		return;
>  
>  	/* Weed out disabled counters */
> @@ -569,7 +569,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
>  {
>  	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> -	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
> +	return (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) &&
>  	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
>  }
>  
> @@ -1084,3 +1084,12 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
>  					      ID_AA64DFR0_EL1_PMUVer_V3P5);
>  	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
>  }
> +
> +/**
> + * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
> + * @vcpu: The vcpu pointer
> + */
> +u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> +{
> +	return __vcpu_sys_reg(vcpu, PMCR_EL0);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 08af7824e9d8..ff0f7095eaca 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -803,7 +803,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		 * Only update writeable bits of PMCR (continuing into
>  		 * kvm_pmu_handle_pmcr() as well)
>  		 */
> -		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> +		val = kvm_vcpu_read_pmcr(vcpu);
>  		val &= ~ARMV8_PMU_PMCR_MASK;
>  		val |= p->regval & ARMV8_PMU_PMCR_MASK;
>  		if (!kvm_supports_32bit_el0())
> @@ -811,7 +811,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		kvm_pmu_handle_pmcr(vcpu, val);
>  	} else {
>  		/* PMCR.P & PMCR.C are RAZ */
> -		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
> +		val = kvm_vcpu_read_pmcr(vcpu)
>  		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
>  		p->regval = val;
>  	}
> @@ -860,7 +860,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
>  {
>  	u64 pmcr, val;
>  
> -	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
> +	pmcr = kvm_vcpu_read_pmcr(vcpu);
>  	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
>  	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
>  		kvm_inject_undefined(vcpu);
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 858ed9ce828a..cd980d78b86b 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -103,6 +103,7 @@ void kvm_vcpu_pmu_resync_el0(void);
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>  int kvm_arm_set_default_pmu(struct kvm *kvm);
>  
> +u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
>  #else
>  struct kvm_pmu {
>  };
> @@ -180,6 +181,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
>  	return -ENODEV;
>  }
>  
> +static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  #endif

