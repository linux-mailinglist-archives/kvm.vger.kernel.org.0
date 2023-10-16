Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA117CACB2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbjJPO66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjJPO65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C63B4
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697468290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zp4vUunKfHhqsgxWB38XGElijdQA95U7BhovNf/a+1w=;
        b=eKRY4GfkJDSOdnMG/JSErq7HBr4V60cNaOJoVF6QzSl4x4gy4V1OmQZbT6SllYhe8tLkI5
        aXwfa1SmWmjrhyqOdLZDxsV1A+Ppm4iNeouZFk2LK0MP47FvI/1Sygl9LWVmMcyuPlM4Gv
        6hjq7JtTy6TBnhMxzDQw8W7oTxSsZuI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-YJJj6LfENUyEdS3qZGeqhg-1; Mon, 16 Oct 2023 10:58:09 -0400
X-MC-Unique: YJJj6LfENUyEdS3qZGeqhg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7742eeceeacso587372085a.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697468289; x=1698073089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zp4vUunKfHhqsgxWB38XGElijdQA95U7BhovNf/a+1w=;
        b=IPAAwJBeuyEPsa0nL9voYnkq4OucAFSAqX4ZYliebrp1JVQCsPkJB00StV8a2Dkplu
         MHxFsjkUOynOwbs9kvgnos0+U5AwLL0lm6jhqTxd13iQgHT8zQyUtM+mcv9+bFMWE/NZ
         cnH8VRx6d1yfD9nez/Fn9HnfwkzJ/67s7l/JVEIieDqiYxt9z00cR5OiLT4ztB36NjAI
         nyq5QmlWbIlrYHAv+/dRszEebaw3wGbBpD/phXD2Ig08Fwfk5mpB7qeg0rXmaihhWfPw
         gSZngldqgre4K6OsvW5UaaXO0dec4ifxBwVEt+w9deYeWSoIWYYp1JooyxE4m/uWecK1
         ihFQ==
X-Gm-Message-State: AOJu0Yx9KPm3X5hPD4c48zj8pQlO9DGpQqSPdqGIqW4xcczetH9He1qI
        DVznwehC1zvafNd2AoLrCj97K+U8iwvaR0pj996CSfTNzG7/5hXygKdj1VCGph38ei25EZ3qXpP
        mMp1NIVIG4Kzu
X-Received: by 2002:a05:620a:2443:b0:775:6cf8:8da8 with SMTP id h3-20020a05620a244300b007756cf88da8mr43237639qkn.32.1697468288995;
        Mon, 16 Oct 2023 07:58:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH1XUPIq/8zsNJ+zGr1DyiPdmgqD5oy4QXhwY1W2dDZ9ifLTBchtdNCC4MzTOvWKif9UHV6Q==
X-Received: by 2002:a05:620a:2443:b0:775:6cf8:8da8 with SMTP id h3-20020a05620a244300b007756cf88da8mr43237619qkn.32.1697468288730;
        Mon, 16 Oct 2023 07:58:08 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id o23-20020a05620a111700b007671cfe8a18sm3051684qkk.13.2023.10.16.07.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 07:58:07 -0700 (PDT)
Message-ID: <75297f46-d1d7-2519-cd76-8b6c2246dbb5@redhat.com>
Date:   Mon, 16 Oct 2023 16:58:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2
 sysregs
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20231013223311.3950585-1-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231013223311.3950585-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/14/23 00:33, Marc Zyngier wrote:
> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
> UNDEF when AArch32 isn't implemented, which is definitely the case when
> running NV.
> 
> Given that this is the only case where these registers can trap,
> unconditionally inject an UNDEF exception.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arch/arm64/kvm/sys_regs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0afd6136e275..0071ccccaf00 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	// DBGDTR[TR]X_EL0 share the same encoding
>  	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
>  
> -	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
> +	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
>  
>  	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>  
> @@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>  
> -	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
>  	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>  	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
>  
> -	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> +	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
>  	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
>  	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
> -	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> +	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
>  
>  	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),

