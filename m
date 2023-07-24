Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C342775F933
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 16:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjGXODh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjGXODg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 10:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0527890
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690207369;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfEEe087gtJ8bomRCouViQMVQyYh61kHLnxItw8U/fw=;
        b=MbrqTUgUCRHMTE2SHfpYKpvpaGtJcEoVj11FUDVDW9RsbUvsVWUM6mJErF7Dw9GZ2zTDth
        b+4vvNJEpdg8pURRlanGMSdkpENIWt2wVn8jgrdEvRaXUQIbZQgmkhrqtADJtEBDG0rqAY
        jKnLWtQbi+JR2Gr6ouWsCnMUoypES6k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-WA8xi850OBGLSZueTpQgmA-1; Mon, 24 Jul 2023 10:02:45 -0400
X-MC-Unique: WA8xi850OBGLSZueTpQgmA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-63cea95ad65so29917636d6.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 07:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690207364; x=1690812164;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfEEe087gtJ8bomRCouViQMVQyYh61kHLnxItw8U/fw=;
        b=ffzOYluNIeDjl3UIIuHveJ8qHvbKD4OBCgUe8QgLE7RDo/JKmA0MLSkkzJ3bkqy2Ck
         TQb9WqcjVZlT6mev3xi68LZy7GPNe2Qxzv2VGrebgpgpSpa0pUeXOMmQkWBzMbJP01Jf
         iTK0YJrCAqZhAqh5rPMc/PGEXD0yL0nhdMYpklWRww7e91bdIy3zN46cUrf0gR+sC5nl
         IG3hLdBbXKLUc5CsVXcq1I5dTcGPQQBA2DfVMplqKs6hZmgW9YI4eEx8dvevKpfLptLT
         VTdxDFYUuZLzhWapVt25rSC+rppW7BjyGvZ2sJC4R4IwOdn4U0br68EGhl1K2F4MfPZK
         QINg==
X-Gm-Message-State: ABy/qLYhzDn9TPXh5Me32YaJoMQXqJlltwTZxx0lA2YVksIXkonn28bA
        dN0lpkY8YxieAh0qB3Hkmr6UZ/0KaX3j9fxdSrQVPlp/4giX3fYSSKbjPQ1NEABsf2xP4KiNkY5
        ARd4HTHlMv1Tu
X-Received: by 2002:a0c:8d02:0:b0:635:e303:ed6d with SMTP id r2-20020a0c8d02000000b00635e303ed6dmr7596821qvb.52.1690207364605;
        Mon, 24 Jul 2023 07:02:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEfGkjGXUcAxCWvO7NKJ5m00gD9bKWkJjrfhgjQcGMYWoRWaQoOiSOhwac92zPeZAQSWVik4w==
X-Received: by 2002:a0c:8d02:0:b0:635:e303:ed6d with SMTP id r2-20020a0c8d02000000b00635e303ed6dmr7596791qvb.52.1690207364158;
        Mon, 24 Jul 2023 07:02:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id j16-20020a0ce010000000b0062ff179a538sm3544041qvk.123.2023.07.24.07.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 07:02:43 -0700 (PDT)
Message-ID: <15693147-5361-b94f-9785-542d6d5bf19e@redhat.com>
Date:   Mon, 24 Jul 2023 16:02:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 08/27] arm64: Fix HFGxTR_EL2 field naming
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
 <20230712145810.3864793-9-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-9-maz@kernel.org>
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



On 7/12/23 16:57, Marc Zyngier wrote:
> The HFGxTR_EL2 fields do not always follow the naming described
> in the spec, nor do they match the name of the register they trap
> in the rest of the kernel.
>
> It is a bit sad that they were written by hand despite the availability
> of a machine readable version...
>
> Fixes: cc077e7facbe ("arm64/sysreg: Convert HFG[RW]TR_EL2 to automatic generation")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/tools/sysreg | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1ea4a3dc68f8..65866bf819c3 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2017,7 +2017,7 @@ Field	0	SM
>  EndSysreg
>  
>  SysregFields	HFGxTR_EL2
> -Field	63	nAMIAIR2_EL1
> +Field	63	nAMAIR2_EL1
>  Field	62	nMAIR2_EL1
>  Field	61	nS2POR_EL1
>  Field	60	nPOR_EL1
> @@ -2032,9 +2032,9 @@ Field	52	nGCS_EL0
>  Res0	51
>  Field	50	nACCDATA_EL1
>  Field	49	ERXADDR_EL1
> -Field	48	EXRPFGCDN_EL1
> -Field	47	EXPFGCTL_EL1
> -Field	46	EXPFGF_EL1
> +Field	48	ERXPFGCDN_EL1
> +Field	47	ERXPFGCTL_EL1
> +Field	46	ERXPFGF_EL1
>  Field	45	ERXMISCn_EL1
>  Field	44	ERXSTATUS_EL1
>  Field	43	ERXCTLR_EL1
> @@ -2049,8 +2049,8 @@ Field	35	TPIDR_EL0
>  Field	34	TPIDRRO_EL0
>  Field	33	TPIDR_EL1
>  Field	32	TCR_EL1
> -Field	31	SCTXNUM_EL0
> -Field	30	SCTXNUM_EL1
> +Field	31	SCXTNUM_EL0
> +Field	30	SCXTNUM_EL1
>  Field	29	SCTLR_EL1
>  Field	28	REVIDR_EL1
>  Field	27	PAR_EL1
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

