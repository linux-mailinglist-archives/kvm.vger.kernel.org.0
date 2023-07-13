Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EC27529E7
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 19:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjGMRfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjGMRfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 13:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED44126A1
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 10:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689269688;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8/ResZwPvuv4tGVhWF3Aj+P0gkju6yAs+IwBrPVVMI=;
        b=H3VmKcNytCQr7LQhYMV1Lwozk8cohjgk0oCeWmK9bhWbuMnpm6Bc4g31wv/3h87cYJI7mA
        xTEDbevvRJBuCfaMVbfE19/E5TBHYPLl1Ua5stUvgO1v2XaWe5SJC9kAeVsRXRJoUtg6yY
        je+pSNyvpW8WDEWJPC+r+XstctPq0/Y=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-Zk5Tthb9PDiuBp0SZAv7ww-1; Thu, 13 Jul 2023 13:34:45 -0400
X-MC-Unique: Zk5Tthb9PDiuBp0SZAv7ww-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-40327302341so9106681cf.3
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 10:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689269685; x=1689874485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8/ResZwPvuv4tGVhWF3Aj+P0gkju6yAs+IwBrPVVMI=;
        b=UADCz+5Dmhl5/lMc1zgmh6YdYan1fqbatFBPM6CK2WJ/U19cz2NZ1aQzPndc7Zp9GB
         dEFmTUE/uN43otNb5r7M+3U56oc2pDSS+YEU14yZD3X0+Sk3YBtk0xxHqYDC9vNECQDK
         mpdtZ+HVdm6aGZBXhdB0/Oy3WCrHf42mBgVy5yaNat1+KWgj30lQDihFx7qbDb2y/JyO
         QTNdVLR3xwwWf9tq27DRc4qUNHRh7gEjWsWS2tLINkaX9EfqAmlib/BGr3WH69t5gzyL
         bxN7n1xN2SW7uYyfFi8zSmlK9LJLgqNy6iuVZ3GqsMOGMW3v087OHeKWJ+xrfOoSFZuR
         EAUQ==
X-Gm-Message-State: ABy/qLZTmFoVc/mwOzzj4lISKYQJzlR3fXeP77xvlP2a3lJI10eX0a7o
        MP7/p98GQXkrVJcWC7Hcw00Col8HsMPp6HkTdZ7B2d0cDTcDqSxTlYFy5COkDiGhjca7JZOM22r
        6DTlonZBRolvN
X-Received: by 2002:a05:622a:18e:b0:403:b0f5:fcbc with SMTP id s14-20020a05622a018e00b00403b0f5fcbcmr1898239qtw.36.1689269685109;
        Thu, 13 Jul 2023 10:34:45 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHgY87S1RWJK0LiAT9ThKEK/1QQ73ITZ8AoXT1ea09hJK3I7V4Wl5EMPuWRKI0BJncdjcCVkA==
X-Received: by 2002:a05:622a:18e:b0:403:b0f5:fcbc with SMTP id s14-20020a05622a018e00b00403b0f5fcbcmr1898221qtw.36.1689269684742;
        Thu, 13 Jul 2023 10:34:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d4-20020ac851c4000000b00403ad6ec2e8sm3258550qtn.26.2023.07.13.10.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 10:34:44 -0700 (PDT)
Message-ID: <a2efafbe-bdde-1853-007a-8dd97a9b919f@redhat.com>
Date:   Thu, 13 Jul 2023 19:34:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 18/27] KVM: arm64: nv: Add trap forwarding for MDCR_EL2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-19-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-19-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_75_100 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/12/23 16:58, Marc Zyngier wrote:
> Describe the MDCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 262 ++++++++++++++++++++++++++++++++
>  1 file changed, 262 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 51901e85e43d..25e4842ac334 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -65,6 +65,18 @@ enum coarse_grain_trap_id {
>  	CGT_HCR_TTLBIS,
>  	CGT_HCR_TTLBOS,
>  
> +	CGT_MDCR_TPMCR,
> +	CGT_MDCR_TPM,
> +	CGT_MDCR_TDE,
> +	CGT_MDCR_TDA,
> +	CGT_MDCR_TDOSA,
> +	CGT_MDCR_TDRA,
> +	CGT_MDCR_E2PB,
> +	CGT_MDCR_TPMS,
> +	CGT_MDCR_TTRF,
> +	CGT_MDCR_E2TB,
> +	CGT_MDCR_TDCC,
> +
>  	/*
>  	 * Anything after this point is a combination of trap controls,
>  	 * which all must be evaluated to decide what to do.
> @@ -78,6 +90,11 @@ enum coarse_grain_trap_id {
>  	CGT_HCR_TPU_TICAB,
>  	CGT_HCR_TPU_TOCU,
>  	CGT_HCR_NV1_ENSCXT,
> +	CGT_MDCR_TPM_TPMCR,
> +	CGT_MDCR_TDE_TDA,
> +	CGT_MDCR_TDE_TDOSA,
> +	CGT_MDCR_TDE_TDRA,
> +	CGT_MDCR_TDCC_TDE_TDA,
>  
>  	/*
>  	 * Anything after this point requires a callback evaluating a
> @@ -249,6 +266,72 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		.mask		= HCR_TTLBOS,
>  		.behaviour	= BEHAVE_FORWARD_ANY,
>  	},
> +	[CGT_MDCR_TPMCR] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TPMCR,
> +		.mask		= MDCR_EL2_TPMCR,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TPM] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TPM,
> +		.mask		= MDCR_EL2_TPM,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TDE] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TDE,
> +		.mask		= MDCR_EL2_TDE,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TDA] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TDA,
> +		.mask		= MDCR_EL2_TDA,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TDOSA] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TDOSA,
> +		.mask		= MDCR_EL2_TDOSA,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TDRA] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TDRA,
> +		.mask		= MDCR_EL2_TDRA,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_E2PB] = {
> +		.index		= MDCR_EL2,
> +		.value		= 0,
> +		.mask		= BIT(MDCR_EL2_E2PB_SHIFT),
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TPMS] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TPMS,
> +		.mask		= MDCR_EL2_TPMS,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TTRF] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TTRF,
> +		.mask		= MDCR_EL2_TTRF,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_E2TB] = {
> +		.index		= MDCR_EL2,
> +		.value		= 0,
> +		.mask		= BIT(MDCR_EL2_E2TB_SHIFT),
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_MDCR_TDCC] = {
> +		.index		= MDCR_EL2,
> +		.value		= MDCR_EL2_TDCC,
> +		.mask		= MDCR_EL2_TDCC,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
>  };
>  
>  #define MCB(id, ...)					\
> @@ -266,6 +349,11 @@ static const enum coarse_grain_trap_id *coarse_control_combo[] = {
>  	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
>  	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
>  	MCB(CGT_HCR_NV1_ENSCXT,		CGT_HCR_NV1, CGT_HCR_ENSCXT),
> +	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
> +	MCB(CGT_MDCR_TDE_TDA,		CGT_MDCR_TDE, CGT_MDCR_TDA),
> +	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
> +	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
> +	MCB(CGT_MDCR_TDCC_TDE_TDA,	CGT_MDCR_TDCC, CGT_MDCR_TDE_TDA),
>  };
>  
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
> @@ -593,6 +681,180 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
>  	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_FIEN),
>  	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_FIEN),
>  	SR_TRAP(SYS_SCXTNUM_EL0,	CGT_HCR_ENSCXT),
> +	SR_TRAP(SYS_PMCR_EL0,		CGT_MDCR_TPM_TPMCR), *
> +	SR_TRAP(SYS_PMCNTENSET_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMCNTENCLR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMOVSSET_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMOVSCLR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMCEID0_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMCEID1_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMXEVTYPER_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMSWINC_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMSELR_EL0,		CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMXEVCNTR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMCCNTR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMUSERENR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMINTENSET_EL1,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMINTENCLR_EL1,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMMIR_EL1,		CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(0),	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(1),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(2),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(3),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(4),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(5),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(6),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(7),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(8),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(9),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(10),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(11),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(12),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(13),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(14),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(15),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(16),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(17),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(18),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(19),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(20),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(21),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(22),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(23),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(24),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(25),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(26),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(27),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(28),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(29),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVCNTRn_EL0(30),	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(0),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(1),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(2),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(3),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(4),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(5),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(6),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(7),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(8),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(9),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(10),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(11),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(12),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(13),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(14),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(15),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(16),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(17),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(18),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(19),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(20),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(21),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(22),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(23),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(24),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(25),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(26),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(27),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(28),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(29),	CGT_MDCR_TPM),
> +	SR_TRAP(SYS_PMEVTYPERn_EL0(30),	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_PMCCFILTR_EL0,	CGT_MDCR_TPM),*
> +	SR_TRAP(SYS_MDCCSR_EL0,		CGT_MDCR_TDCC_TDE_TDA),*
> +	SR_TRAP(SYS_MDCCINT_EL1,	CGT_MDCR_TDCC_TDE_TDA),*
> +	SR_TRAP(SYS_OSDTRRX_EL1,	CGT_MDCR_TDCC_TDE_TDA),*
> +	SR_TRAP(SYS_OSDTRTX_EL1,	CGT_MDCR_TDCC_TDE_TDA),*
Please also double check DBGDTR_EL0, DBGDTRRX/TX_EL0. I understand from
the spec they may end up in CGT_MDCR_TDCC_TDE_TDA too
> +	SR_TRAP(SYS_MDSCR_EL1,		CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_OSECCR_EL1,		CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGBVRn_EL1(0),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGBVRn_EL1(1),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(2),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(3),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(4),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(5),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(6),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(7),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(8),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(9),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(10),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(11),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(12),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(13),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(14),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBVRn_EL1(15),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGBCRn_EL1(0),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGBCRn_EL1(1),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(2),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(3),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(4),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(5),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(6),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(7),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(8),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(9),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(10),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(11),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(12),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(13),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(14),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGBCRn_EL1(15),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWVRn_EL1(0),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWVRn_EL1(1),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWVRn_EL1(2),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(3),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(4),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(5),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(6),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(7),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(8),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(9),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(10),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(11),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(12),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(13),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWVRn_EL1(14),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWVRn_EL1(15),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWCRn_EL1(0),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGWCRn_EL1(1),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(2),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(3),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(4),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(5),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(6),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(7),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(8),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(9),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(10),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(11),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(12),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(13),	CGT_MDCR_TDE_TDA),
> +	SR_TRAP(SYS_DBGWCRn_EL1(14),	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGCLAIMSET_EL1,	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGCLAIMCLR_EL1,	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_DBGAUTHSTATUS_EL1,	CGT_MDCR_TDE_TDA),*
> +	SR_TRAP(SYS_OSLAR_EL1,		CGT_MDCR_TDE_TDOSA),*
> +	SR_TRAP(SYS_OSLSR_EL1,		CGT_MDCR_TDE_TDOSA),*
> +	SR_TRAP(SYS_OSDLR_EL1,		CGT_MDCR_TDE_TDOSA),*
> +	SR_TRAP(SYS_DBGPRCR_EL1,	CGT_MDCR_TDE_TDOSA),*
> +	SR_TRAP(SYS_MDRAR_EL1,		CGT_MDCR_TDE_TDRA),*
> +	SR_TRAP(SYS_PMBLIMITR_EL1,	CGT_MDCR_E2PB),*
> +	SR_TRAP(SYS_PMBPTR_EL1,		CGT_MDCR_E2PB),*
> +	SR_TRAP(SYS_PMBSR_EL1,		CGT_MDCR_E2PB),*
> +	SR_TRAP(SYS_PMSCR_EL1,		CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSEVFR_EL1,	CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSFCR_EL1,		CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSICR_EL1,		CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSIDR_EL1,		CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),*
> +	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),*
> +	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),*
> +	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),*
> +	SR_TRAP(SYS_TRBMAR_EL1, 	CGT_MDCR_E2TB),*
> +	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),*
> +	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),*
> +	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),*
>  };
>  
>  static DEFINE_XARRAY(sr_forward_xa);
Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

