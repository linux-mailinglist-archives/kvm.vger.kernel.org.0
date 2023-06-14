Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1306D7302FE
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343548AbjFNPK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343702AbjFNPKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 11:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F351E213F
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 08:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686755330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ij857rNE7UlsoT4a+p1OsxNn3WWx5lolIITLzhEvclQ=;
        b=bYtglVIo3zZpZqn2GAjCozO1r0mhEBm8XnVWXTcfjE3Na+Ovb7U8wSV855IwtL49ceCzhQ
        aRWkPfr2ZxfbwmEl6Im7fXuj033lcbrHfN0OraUzfCGhREkfHa+ZeRX43hXeAd3yxPKCMo
        njU0zZcuHUohwYf+Jfeb3KrafnukY5Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-B_WRo7AKMKGYSkMmTBIdfg-1; Wed, 14 Jun 2023 11:08:49 -0400
X-MC-Unique: B_WRo7AKMKGYSkMmTBIdfg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7eb414fcbso4239125e9.2
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 08:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686755328; x=1689347328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ij857rNE7UlsoT4a+p1OsxNn3WWx5lolIITLzhEvclQ=;
        b=KgvbbN/stgR9qDUQVJFJxyBnJSzUoSuZ/JrM1kNbDBwt8Xs6YHrmrZRw1leglsO5+R
         CZxZY2vA/Sy/DQQS8wwSfzgNfK9syeuA3TMp7nOAKJx022p4v4JVya3Iq1vF2YprOWkd
         A1Qz/UCQUSQlKCjPvkNCDJCYcis6/Fxci+6t+k8xXSYTFEEwUwAWt/pQwUineYxtBFBx
         Z6/QVCS5mcBuG7YFnSP7jxsttshbecEBtam06eHi8UI4t3dux/hlxZKG9pb26CJ/8gBR
         ocJ5LlD3t3SzxBaBMRssQE3spbED6p1f2wL/SLud1vMsawWMYbg/QxG2+LmdXr7ZNuc5
         IdGw==
X-Gm-Message-State: AC+VfDxviRO2kemWTjA+n3fzQIHre0aiBFTJ3LSHbDUnOM8Lv8gAV7Tc
        Ua6sTC/dwlx2kE1FlEWQgpOBpD63kUSQKFtEPlgqhEyGB1RcErbFO5eOjjbZM3eCpEJGI7sUhMw
        JW38oR/Vo9u//
X-Received: by 2002:a05:600c:2190:b0:3f7:395a:c9fa with SMTP id e16-20020a05600c219000b003f7395ac9famr11759545wme.4.1686755327420;
        Wed, 14 Jun 2023 08:08:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ50Y8gb9C9uZgb6Ff1fqPb2W2Yf/POCAD8enM3+pHFHPYkIxo9RSGh+vk7TxFeOZpNysKHwOg==
X-Received: by 2002:a05:600c:2190:b0:3f7:395a:c9fa with SMTP id e16-20020a05600c219000b003f7395ac9famr11759530wme.4.1686755327093;
        Wed, 14 Jun 2023 08:08:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p11-20020a1c740b000000b003f733c1129fsm17728056wmc.33.2023.06.14.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 08:08:46 -0700 (PDT)
Message-ID: <c2f52cb0-aa0c-4344-e20d-64564cf597fb@redhat.com>
Date:   Wed, 14 Jun 2023 17:08:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 07/59] arm64: Add AT operation encodings
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
 <20230515173103.1017669-8-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-8-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/15/23 19:30, Marc Zyngier wrote:
> Add the encodings for the AT operation that are usable from NS.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 2727e68dd65b..8be78a9b9b3b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -568,6 +568,23 @@
>  
>  #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
>  
> +/* AT instructions */
> +#define AT_Op0 1
> +#define AT_CRn 7
> +
> +#define OP_AT_S1E1R	sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
> +#define OP_AT_S1E1W	sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
> +#define OP_AT_S1E0R	sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
> +#define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
> +#define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
> +#define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
> +#define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
> +#define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
> +#define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
> +#define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
> +#define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
> +#define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
> +
>  /* TLBI instructions */
>  #define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
>  #define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

