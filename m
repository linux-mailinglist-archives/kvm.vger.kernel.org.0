Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE72F75FA1F
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjGXOqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjGXOq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 10:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B20CD2
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690209942;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3cSu1CPZmkSkG2RrSPYOjkXMISXZKOQHcqgGwJVWls=;
        b=Vx9IJ0X8np2tY2tX1y/RfrrNbNZOy9O91ElLKunk6Ax7XYxo6fdmCoXBhkvvQDkq4Cze1n
        TKqqYnT5d+eT3UK84UIYSHi9+Aez3XBxACcSBziRx/lzvXZwyMwHpjMQgCiJaVgSJe9Oh1
        aItFbBN1NlwzTjM8W43VUVvJ9Zan5HQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-OCP3cFPdOoKFv0hx9OUvnQ-1; Mon, 24 Jul 2023 10:45:41 -0400
X-MC-Unique: OCP3cFPdOoKFv0hx9OUvnQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fd2e59bc53so8849125e9.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690209940; x=1690814740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P3cSu1CPZmkSkG2RrSPYOjkXMISXZKOQHcqgGwJVWls=;
        b=GmU+NYwzx+XeSqfSpk/FvSZG9/PHR9d0Tdr3xfQkYRvEX2KbE4CIzoxwuA+GPSBajn
         ORCFZW+E/wyEdnUt4NSKFoytCKDtSAgpsXB7o29PmU1CF/LKG2TInA4FCuAiFhRrMGr7
         Ev+GXerew9r0pjcOxx4S6HSRQDEtlnaUXbTlYL27ZyFAdNIyfumRR1Pa/ocl9+iHRxqX
         HIhB/n8qMlqSGboxWrsA70hSTbzCtezZwqEv6iMKB8IeTNpC7B6k6Xc3z/4FOCbsTGV0
         kxzoGXYgI5dtdNn+s6NTJOIeopWq4i/pQnOXNXjGJNvustDr1q+PVii7kQKn8rzeg4Gd
         k0HA==
X-Gm-Message-State: ABy/qLaqGmxbd/Eu5U1rAFC/weEP4dIJZ1lDJ8YUTnp49H6ge/dr6QKL
        HYJ3Cn+C2OidwG5RfxtVYNBTWAfAFb2+k3+HB+QbyaI4jhutQGoXdkQ8TVhZArIjOoSInZVB5ZX
        a2nT/oN5umbj/u48TYtsI
X-Received: by 2002:a05:600c:ca:b0:3fc:8a:7c08 with SMTP id u10-20020a05600c00ca00b003fc008a7c08mr6189348wmm.35.1690209940353;
        Mon, 24 Jul 2023 07:45:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFU13e7JgcAvxxCyZrO9RkA/paTPyvMP1hCPitlW4xzc1kx49CQ/0gLWOB7TPwUbHUV7KIsHg==
X-Received: by 2002:a05:600c:ca:b0:3fc:8a:7c08 with SMTP id u10-20020a05600c00ca00b003fc008a7c08mr6189317wmm.35.1690209939969;
        Mon, 24 Jul 2023 07:45:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b003fbe561f6a3sm13332762wmq.37.2023.07.24.07.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 07:45:39 -0700 (PDT)
Message-ID: <7614f672-989e-6acf-651f-806a3d96846b@redhat.com>
Date:   Mon, 24 Jul 2023 16:45:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 13/27] KVM: arm64: nv: Add FGT registers
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
 <20230712145810.3864793-14-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-14-maz@kernel.org>
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

On 7/12/23 16:57, Marc Zyngier wrote:
> Add the 5 registers covering FEAT_FGT. The AMU-related registers
> are currently left out as we don't have a plan for them. Yet.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  arch/arm64/kvm/sys_regs.c         | 5 +++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740..1200f29282ba 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -400,6 +400,11 @@ enum vcpu_sysreg {
>  	TPIDR_EL2,	/* EL2 Software Thread ID Register */
>  	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
>  	SP_EL2,		/* EL2 Stack Pointer */
> +	HFGRTR_EL2,
> +	HFGWTR_EL2,
> +	HFGITR_EL2,
> +	HDFGRTR_EL2,
> +	HDFGWTR_EL2,
>  	CNTHP_CTL_EL2,
>  	CNTHP_CVAL_EL2,
>  	CNTHV_CTL_EL2,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3a6f678ca67d..f88cd1390998 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2367,6 +2367,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
>  	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HFGRTR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HFGWTR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
>  
>  	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
> @@ -2376,6 +2379,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>  
>  	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>  	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric

