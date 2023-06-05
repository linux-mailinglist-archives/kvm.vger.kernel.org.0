Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003CA722DDC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbjFERsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjFERsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:48:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE23C7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685987231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5iLi3jtMH3pv25shVoS1M19DqH5czvIVbGKZ38f9SgI=;
        b=Iqa2timHTmmt1Uc2bswQnP9YuWpDGeCnlVx98cHpXTJLNwXxp+0zdFe/JoKay0MXxVBjuY
        wz9XaNT1D6GNAvP7l0Bo7W8mZzjeZ4sJ+uCc7ZJuCCNFQUfV5H+mML3DmcQX+Hmn+Ykma3
        /pcdGzRoLiP/LgakU6g/JocHf1DtUZs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-KkpAUDaaN_6QJKCuKOsuvQ-1; Mon, 05 Jun 2023 13:47:06 -0400
X-MC-Unique: KkpAUDaaN_6QJKCuKOsuvQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso24848385e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987225; x=1688579225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5iLi3jtMH3pv25shVoS1M19DqH5czvIVbGKZ38f9SgI=;
        b=gFF6A5/fkskSN9rIa5duA7DaQeCuniw1c/iVEYtoXDnwVLVJYEjG0O1FHb45PNuU/l
         ociaQmt40Dng4BSK+Hk2sGPB2Teb5EXqTgl1AxIXec0sHLAlcIMo0LvZJ0Rfocv387Of
         JmX0+8XRm+syRGUlDXmtv/BV0NxrEgRR9mLNaa0wynnqimDxd+RYnjs/mCgoNXUD+wov
         /eMyD/NZIxQqEGguOWa5AL2kz3ucDCGrmeZssiTvW3I5+L3IF/4juivCIQrY7Fy0GIAy
         2upDI7HgerI8ygKaHuasJcZ+hmbLVjlpLu1xHVN3j08ahbIouotBOFqmPpzND5W9nohR
         jRkQ==
X-Gm-Message-State: AC+VfDwI2Rf1G0v73g4fAJbeFyEN/TpnhwWasmZzAbp1vG/T1vvADn+N
        UVlBdO3Bfi4S3jBQ8aflKC1Y+lRam7dIiNYhXHJp3IxDiKxe0ljjhO0ZZUsrZR0bG5DI4+WiPzm
        swM5gwpdjr9vo
X-Received: by 2002:a7b:c393:0:b0:3f1:bb10:c865 with SMTP id s19-20020a7bc393000000b003f1bb10c865mr7533771wmj.38.1685987225217;
        Mon, 05 Jun 2023 10:47:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6B0Cs6zzo6oIgwlLySYoIkjk+orU3QvOqFyuJdQOvJSP4BCdq/9MS6Cxk79w18ygpPeTKjZg==
X-Received: by 2002:a7b:c393:0:b0:3f1:bb10:c865 with SMTP id s19-20020a7bc393000000b003f1bb10c865mr7533750wmj.38.1685987224927;
        Mon, 05 Jun 2023 10:47:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600c4fc700b003f71ad792f2sm20825874wmq.1.2023.06.05.10.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:47:04 -0700 (PDT)
Message-ID: <80471a31-8b91-de37-f368-b50bdb6eb7c0@redhat.com>
Date:   Mon, 5 Jun 2023 19:47:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 04/59] arm64: Add missing ERXMISCx_EL1 encodings
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
 <20230515173103.1017669-5-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-5-maz@kernel.org>
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
> We only describe ERXMISC{0,1}_EL1. Add ERXMISC{2,3}_EL1 for a good measure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 071cc8545fbe..71305f7425db 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -239,6 +239,8 @@
>  #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
>  #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
>  #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
> +#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
> +#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)

>  #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
>  #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

