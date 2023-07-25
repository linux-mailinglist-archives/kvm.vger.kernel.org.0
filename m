Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEEE762054
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjGYRiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjGYRiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3A41BD5
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690306634;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5L2q7c9oU0+boxm9QA+HwbxhhMCIqRyTv6FR1XEv67U=;
        b=R9s6cGmmmM+zvBfXcvm1UVQuRhJGPcaPgA0Vorv2l5YgaSfBBP1LPTuFY1P+i2hQZ75A3p
        fqbydjkBzyInpfv2DQCNUOvTYpoIoQ0gTNFUil9t2Gw8H663Om6AedkKPo2EKSnK85mhOw
        vnsQYKnqpAZx1mD4DzNsQqb7Z/vfNpY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-E-Rmr-m7MSekcjlIaNtF6Q-1; Tue, 25 Jul 2023 13:37:13 -0400
X-MC-Unique: E-Rmr-m7MSekcjlIaNtF6Q-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-63cfe46bbb6so30316046d6.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:37:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690306632; x=1690911432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5L2q7c9oU0+boxm9QA+HwbxhhMCIqRyTv6FR1XEv67U=;
        b=BhjYm8dx7Mv8i2B+2fWote5K3vl7mARYEGvHqMRTml5jxf49eBBrbZ2fw1ObuFbZQt
         F0dhxS5sf7MrYV0ZX4xDc6zCofVw76tfN027LH0bK3dUKvs1Y16rtgxi7E/cPXh9EXKX
         ykGcNanjG4uuBwzEumkx3ffd2Bx9JLSA4IEsUJ44DCHC0nsTXF1/W96WEMtMB2Ax3tPE
         0stezxwpDVNQJqtPdiq0mpBpsWeUWQfQkIWBoHzFrWL+myDKsBJnVIEiZcJFIMjrZp4n
         CqCJw8wBPid1+4W9ndHl4IU1iuksfYDJQuakQDZBM0kIXUDuW4vMZpc91yxi3dYZ4oSY
         HkMQ==
X-Gm-Message-State: ABy/qLYGt9NGDZBKkuZZMYCNcrHSiU/vaz+8un6JsTAfXbf1C6PdKZVp
        EfJztnY31unVTjMUzYX/Eq2C+yPv8ZiGo2q2+mbEUn/KXZRyQPN2ORoJvJMYyU2sFF1KMN5J1bh
        O1qi7hAmbyPsn
X-Received: by 2002:a05:6214:1631:b0:626:1fe8:bba4 with SMTP id e17-20020a056214163100b006261fe8bba4mr2787863qvw.10.1690306632776;
        Tue, 25 Jul 2023 10:37:12 -0700 (PDT)
X-Google-Smtp-Source: APBJJlElrjGoC9TMBus9hMJ9Xc8AYoEJxm5MhSIGHQadsTQRKyHVviSuNuhFx2v5MSJ/lSZHeq+CHA==
X-Received: by 2002:a05:6214:1631:b0:626:1fe8:bba4 with SMTP id e17-20020a056214163100b006261fe8bba4mr2787848qvw.10.1690306632495;
        Tue, 25 Jul 2023 10:37:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id e17-20020a0caa51000000b0063ce736180bsm3135199qvb.112.2023.07.25.10.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 10:37:11 -0700 (PDT)
Message-ID: <9739cab9-c058-ec5f-ac15-7d708aef4e85@redhat.com>
Date:   Tue, 25 Jul 2023 19:37:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 19/27] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
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
 <20230712145810.3864793-20-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-20-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/12/23 16:58, Marc Zyngier wrote:
> Describe the CNTHCTL_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 37 ++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 25e4842ac334..c07c0f3361d7 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -98,9 +98,11 @@ enum coarse_grain_trap_id {
>  
>  	/*
>  	 * Anything after this point requires a callback evaluating a
> -	 * complex trap condition. Hopefully we'll never need this...
> +	 * complex trap condition. Ugly stuff.
>  	 */
>  	__COMPLEX_CONDITIONS__,
> +	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
> +	CGT_CNTHCTL_EL1PTEN,
>  };
>  
>  static const struct trap_bits coarse_trap_bits[] = {
> @@ -358,9 +360,37 @@ static const enum coarse_grain_trap_id *coarse_control_combo[] = {
>  
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
>  
> +static u64 get_sanitized_cnthctl(struct kvm_vcpu *vcpu)
> +{
> +	u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
> +
> +	if (!vcpu_el2_e2h_is_set(vcpu))
> +		val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
> +
> +	return val;
don't you want to return only bits 10 & 11 to match the other condition?

I would add a comment saying that When FEAT_VHE is implemented and
HCR_EL2.E2H == 1:

sanitized_cnthctl[11:10] = [EL1PTEN, EL1PCTEN]
otherwise
sanitized_cnthctl[11:10] = [EL1PCEN, EL1PCTEN]

> +}
> +
> +static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu *vcpu)
> +{
> +	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
> +		return BEHAVE_HANDLE_LOCALLY;
> +
> +	return BEHAVE_FORWARD_ANY;
> +}
> +
> +static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
or pcen. This is a bit confusing to see EL1PCEN below. But this is due
to above sanitized CNTHCTL. Worth a comment to me.
> +{
> +	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
> +		return BEHAVE_HANDLE_LOCALLY;
> +
> +	return BEHAVE_FORWARD_ANY;
> +}
> +
>  #define CCC(id, fn)	[id - __COMPLEX_CONDITIONS__] = fn
>  
>  static const complex_condition_check ccc[] = {
> +	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
> +	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
>  };
>  
>  /*
> @@ -855,6 +885,11 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
>  	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
>  	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
>  	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
> +	SR_TRAP(SYS_CNTP_TVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
> +	SR_TRAP(SYS_CNTP_CVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
> +	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
> +	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
> +	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
>  };
>  
>  static DEFINE_XARRAY(sr_forward_xa);
Otherwise looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric


