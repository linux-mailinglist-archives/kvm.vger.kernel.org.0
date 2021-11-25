Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A49045E1A4
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357061AbhKYUfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:35:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349824AbhKYUdx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 15:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637872241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ShhUEy+E07PE6bTnG2bcJwf8K2GrtR8GlOvuCWDf3g=;
        b=N6DrpoWKxZV1Ofg2+KXPchcnyvdfBEc2qRphVMTWWdzExXD6U7kwz6XBL0+RJIZr+WXQyc
        UU66NuZw+no3+mWbHPYFNLQF2ou4rONw8jpIrU5jqyUZgnrMbYcBec0KY1FznoTiyQ/XtC
        c6wgu7LZWoNqkLbL4P7CrCbC6HzCQd8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-iGkC60mdPFWdBYMhfPLxUQ-1; Thu, 25 Nov 2021 15:30:40 -0500
X-MC-Unique: iGkC60mdPFWdBYMhfPLxUQ-1
Received: by mail-wm1-f71.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so4063658wms.7
        for <kvm@vger.kernel.org>; Thu, 25 Nov 2021 12:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ShhUEy+E07PE6bTnG2bcJwf8K2GrtR8GlOvuCWDf3g=;
        b=Fv/iFoz5UNaglLeKZdEP54fIpj/pKNQBqvNr5XEuvhWF9Ywl1fj+pqcy2hBcGNQ2nV
         MbRta/j7yXvxgJDqz5Ng1ZWYUjpwJ9bensc/JbOFbqxU91tNYjjh2qk48lULFRfAWpyY
         PdGMO6ZcpFOIwuYKzVTDN1g8+Tj7h/dlPVjEA64TU8Z0MeiD15Q0yCvnotK0pHTHy0Dl
         GqfpLbn4f3UKFEJZzDKp+9BP3bviDhDBfa9Pcwt6f8WIYqinMOZhCA27qGSROHEVkShl
         2YuQC7FhBDCEqsQ4tMTMeJ3YSgHG4aA66uujOmLOgPOFVkGA0kVQlqBKO5nE2mNys9gl
         uFcw==
X-Gm-Message-State: AOAM532fY8SHrHPA4pvAJYuA9fjvHivNGw5KhT+8VyiQAAYs+MX5PiZk
        pujjaQMb41mYB3pTgavNJoVoU2Ty84e/U10GvOLHt+101F4aTZdOEjge+O21kfjOdRDXEH8Qovm
        jwF/T7W1YFcA1
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr9806970wrm.60.1637872238918;
        Thu, 25 Nov 2021 12:30:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoQfLwsVNStdvgHx055e1d9E4GwQpVIsWLlaEilliddpDqSQaqHalFf+ziOP3Fem0ERY7sCw==
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr9806937wrm.60.1637872238693;
        Thu, 25 Nov 2021 12:30:38 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d8sm3719945wrm.76.2021.11.25.12.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 12:30:38 -0800 (PST)
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-13-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
Date:   Thu, 25 Nov 2021 21:30:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-13-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
> by userspace.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fbd335ac5e6b..dda7001959f6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
>  	.get_reset_val = get_reset_id_dfr0_el1,
>  };
>  
> +static struct id_reg_info id_dfr1_el1_info = {
> +	.sys_reg = SYS_ID_DFR1_EL1,
> +	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
what about the 0xF value which indicates the MTPMU is not implemented?

Eric
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
>  #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>  	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
> +	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
> 

