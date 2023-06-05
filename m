Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AFC722DDD
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbjFERsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjFERsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:48:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120BCA7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685987247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLdXseVvogL1t+8Q/CY9+/t9PCx7FNGeBdzXRWCRuUA=;
        b=MLPkDn2bUAJzNpoD9IerUQqqUpWNVytCY+sgBhyZijkcTk2W+I97PU3pJlU91awMYtmxVF
        DXKhUnVr2CBPjxJDzfL2HyfZsWTeYa6lJV8KqGYjPRX6MuD+1qgOiXAJMW1BMq8tTmMDQn
        WzSv8BU38TtTtSwRMUTcaqwkl/RCBtE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-KAVhY2xuMkyF85oPjwKA9g-1; Mon, 05 Jun 2023 13:47:25 -0400
X-MC-Unique: KAVhY2xuMkyF85oPjwKA9g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f5ec8aac77so30069345e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987244; x=1688579244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WLdXseVvogL1t+8Q/CY9+/t9PCx7FNGeBdzXRWCRuUA=;
        b=JqDghKKRbtEhooUabNtoNzZqZPKmRe0wbz9dbVD/vxiUqL5QwS1lzW09SB/SkGaI6k
         jsB0Hlt7mbrpnGZZD9OJJ49T4H26BHzdiF3G9dmTqj85PwylcoCf/omnVbkWBZT1kKrZ
         vFiPfV3j7QA2BOTnNOM7FBASY8eVNLu/NWaABOjVdehpOqLcdNiEMJc+p7QI0T0CU9cb
         XB2F6aqvuVKphkvMR7QGMwpjql0MFIHaz7A/cn+9LfqH+VhpKVFANsxV+jTuflvecxz9
         IDpPHpBmoci1PlGcHft2sJssLW5qFnnVulPkvLRB10E0H7zP6kZ5TBp/FsQOP5TV7wq5
         2wAg==
X-Gm-Message-State: AC+VfDzT9m/skSZPNd3YY0ZyDT4Cbf5Zmf7c4q6M/K8W5IPWfUxNZNFd
        +RJDj2KEg17ft9J30aAFwv22i6TNrmguVzs8PKjiL37DK7p5Kg7GFygaGOodlaXF2DBc4/m6mk+
        QM7Up42ISNgUM
X-Received: by 2002:a7b:cd94:0:b0:3f6:ea4:a667 with SMTP id y20-20020a7bcd94000000b003f60ea4a667mr7632975wmj.39.1685987244718;
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5H56pUKlF8Pr1TrIFrMedoqttFVtZKKklavoHiUMEZfUjl0DxW7CAypMZGNy02Ep8+5arhtA==
X-Received: by 2002:a7b:cd94:0:b0:3f6:ea4:a667 with SMTP id y20-20020a7bcd94000000b003f60ea4a667mr7632967wmj.39.1685987244553;
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d24-20020a1c7318000000b003f18b942338sm11544991wmb.3.2023.06.05.10.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
Message-ID: <372506ec-2717-7ed1-e5f1-617b42c73935@redhat.com>
Date:   Mon, 5 Jun 2023 19:47:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 05/59] arm64: Add missing DC ZVA/GVA/GZVA encodings
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
 <20230515173103.1017669-6-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-6-maz@kernel.org>
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



On 5/15/23 19:30, Marc Zyngier wrote:
> Add the missing DC *VA encodings.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 71305f7425db..28ccc379a172 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -150,6 +150,11 @@
>  #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
>  #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
>  
> +/* Data cache zero operations */
> +#define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
> +#define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
> +#define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
> +
>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

