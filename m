Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4E7302FF
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343553AbjFNPK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343712AbjFNPKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 11:10:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2188268C
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 08:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686755342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuejhHkuMs2BYAezkmA+FR0lumlW7Hh8wezW2u/1WfA=;
        b=dZOSOkNUWpHKO8nKHf8JXP5ZkC7jtRr3ZbpaCh84sTQasyMNrQUxfB3l9UttILIpK0QHxI
        8xnXeWi82QW06t4SqfjnuBKpucrrrA51UhwxyCLP9ZOMEUHMywqMe33xb22my8MbRFxqRi
        j9tLb2ZSyPPA/A7Dr7Tcq+7v16g2ZWE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-HZ5bSI7kM5C7tw6VoRHPWQ-1; Wed, 14 Jun 2023 11:08:59 -0400
X-MC-Unique: HZ5bSI7kM5C7tw6VoRHPWQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7e8c24a92so5166365e9.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 08:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686755338; x=1689347338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TuejhHkuMs2BYAezkmA+FR0lumlW7Hh8wezW2u/1WfA=;
        b=VT99pOtLd2NbfcAifBcTaCio+L2RWyrN7xDVyKREft/yUPq4/cSTeyI6F4JDINUzxc
         S9fauHTHaqszliPD7r/Gvcxr27JAHCwz6sd3O/D0VIwjQeATTXj9Iuk5mF4GvesCzirr
         MGG4WEik1gVzZCJDfbzRYr/5k6xKqrWp1Rb+prMcxmWJ/ehfXMl2Nw10GCmwkFsdNM+0
         xSXh0ypj32FkPOPPd9zsrTC+AF3APk2sI7BcphdHn+qK/3c4KOUP6Kmhf5TKtDiwMDgy
         cXuSun7uicDXTxQi5oXHAmj/mwRI8vKPkol2ow6Xzd3QxC7wShvdbzk4fwSQngO5FiyW
         IeUA==
X-Gm-Message-State: AC+VfDy6BskBZoeoWqlaK0+N1ZT33nVWd+mDgADMRBMrRGwENuNY5M3A
        LDJ/KH1ZOhO8a30sMsOU6feVkM3CydfVy47AjjkX2S/+nla9xBdC37SsBXLmKXrbWKPkizYmCqy
        0+25BKEad6Cus
X-Received: by 2002:a05:600c:224d:b0:3f8:1110:60c2 with SMTP id a13-20020a05600c224d00b003f8111060c2mr9388007wmm.33.1686755338164;
        Wed, 14 Jun 2023 08:08:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7LqWE4g1m/b7l2zoM2EPzsm0Q2bvMJUIV8OqbGlfeguVVZ0y8q/N9qL3YHwPr6OhHbWkRfJA==
X-Received: by 2002:a05:600c:224d:b0:3f8:1110:60c2 with SMTP id a13-20020a05600c224d00b003f8111060c2mr9387987wmm.33.1686755337860;
        Wed, 14 Jun 2023 08:08:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b003f4283f5c1bsm7897431wmq.2.2023.06.14.08.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 08:08:57 -0700 (PDT)
Message-ID: <56657425-d28f-9eb1-8ca2-3fa9bf568add@redhat.com>
Date:   Wed, 14 Jun 2023 17:08:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 08/59] KVM: arm64: Add missing HCR_EL2 trap bits
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-9-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-9-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/15/23 19:30, Marc Zyngier wrote:
> We're still missing a handfull of HCR_EL2 trap bits. Add them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 209a4fba5d2a..4b3e55abb30f 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -17,9 +17,19 @@
>  #define HCR_DCT		(UL(1) << 57)
>  #define HCR_ATA_SHIFT	56
>  #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
> +#define HCR_TTLBOS	(UL(1) << 55)
> +#define HCR_TTLBIS	(UL(1) << 54)
> +#define HCR_ENSCXT	(UL(1) << 53)
> +#define HCR_TOCU	(UL(1) << 52)
>  #define HCR_AMVOFFEN	(UL(1) << 51)
> +#define HCR_TICAB	(UL(1) << 50)
> +#define HCR_TID4	(UL(1) << 49)
>  #define HCR_FIEN	(UL(1) << 47)
>  #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV2		(UL(1) << 45)
> +#define HCR_AT		(UL(1) << 44)
> +#define HCR_NV1		(UL(1) << 43)
> +#define HCR_NV		(UL(1) << 42)
>  #define HCR_API		(UL(1) << 41)
>  #define HCR_APK		(UL(1) << 40)
>  #define HCR_TEA		(UL(1) << 37)
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

