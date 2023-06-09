Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA82A729F8F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbjFIQDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjFIQDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF15595
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686326533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zqq6TXcNzUIr6gmA9O2Hp7RVUAeh6ZnKXAVrt6616tA=;
        b=Au2KwfxbPSJPmBcunk61agJR/OATfJkDqubtPpWHvxa8q/2KfjPIayLexi0l+rGpySzyUT
        0+Mqc0oRrYBmZJKN1ilcMMx5Z6/3EWGuAFB5lqHfCcst7W6aVzbNMovt0tVv7GJ2zxqpTs
        gLzTHyEZG1XVrwYDi4ax8jl9bBeZdCw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-gJxOBBJTM2S8odmQkVkC2Q-1; Fri, 09 Jun 2023 12:02:12 -0400
X-MC-Unique: gJxOBBJTM2S8odmQkVkC2Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30fa3ea38bcso280614f8f.1
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 09:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686326531; x=1688918531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zqq6TXcNzUIr6gmA9O2Hp7RVUAeh6ZnKXAVrt6616tA=;
        b=Fe8qKb6lcK35nKo7uFlDWOHnEVfQyobaJNKd3QKv0DMeG6RnIW+6MeHaRAA4JAAY4s
         sby4hQ40btLUacM2VELI7c+5LAByX+pSbg3+cXMYONDGyAvTSt6R5Dgltc/NgzZvyzm1
         3Yra2ubg7dYjJTyxoGrjAkaUWVfTE+tY+r2s9MNzfeYR1w+HueMaAb8DZdDTnv1x3fkI
         8xmbR30scC5ugT9xqQ3vPkegIY3ytb/gRMB2H3P3wCoaLFakl8eBi607f9IO3zUUKG6R
         rdoorQZQhUykH043r74EGZ3ILZxlGvjx7eeUp8Ap8a1rgSxP5D+1R3mPRIoFLzGmhdUl
         tkMQ==
X-Gm-Message-State: AC+VfDz04FfAT25J4cboNIVGMZ0IyGrOi3Zev7LirR8UULkVFbFyNIF3
        G5dHjaKR00Ig2zaXEdrNX9vmT81Yf2uu1UzG8ndj+Es95DPQCZn5sgKeyCAipVZxdOFDY5qxyzD
        /0FvA+8iRBfmr
X-Received: by 2002:a05:600c:2181:b0:3f7:28d8:4317 with SMTP id e1-20020a05600c218100b003f728d84317mr1426611wme.15.1686326530885;
        Fri, 09 Jun 2023 09:02:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4xIHc2MuaVVsqgCU+w5OGENjLh4n0xh/aMCu3a++BJXhJ6rj2GOjEBR4VQoSGP+XTG3BErdw==
X-Received: by 2002:a05:600c:2181:b0:3f7:28d8:4317 with SMTP id e1-20020a05600c218100b003f728d84317mr1426597wme.15.1686326530583;
        Fri, 09 Jun 2023 09:02:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:9e2:9000:9283:b79f:cbb3:327a? ([2a01:e0a:9e2:9000:9283:b79f:cbb3:327a])
        by smtp.gmail.com with ESMTPSA id t10-20020a1c770a000000b003f8009be6c0sm3114640wmi.3.2023.06.09.09.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 09:02:09 -0700 (PDT)
Message-ID: <8e81500b-2afc-bc17-bd84-56339e4ff28f@redhat.com>
Date:   Fri, 9 Jun 2023 18:02:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/3] vfio/fsl: Create Kconfig sub-menu
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, jgg@nvidia.com, eric.auger@redhat.com,
        diana.craciun@oss.nxp.com
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
 <20230607230918.3157757-4-alex.williamson@redhat.com>
 <d1722794-c0d3-1f7f-4195-334608165ff9@redhat.com>
 <20230608075835.4c7359bf.alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230608075835.4c7359bf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 6/8/23 15:58, Alex Williamson wrote:
> On Thu, 8 Jun 2023 09:25:26 +0200
> Cédric Le Goater <clg@redhat.com> wrote:
> 
>> On 6/8/23 01:09, Alex Williamson wrote:
>>> For consistency with pci and platform, push the vfio-fsl-mc option into a
>>> sub-menu.
>>>
>>> Reviewed-by: Cédric Le Goater <clg@redhat.com>
>>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>    drivers/vfio/fsl-mc/Kconfig | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
>>> index 597d338c5c8a..d2757a1114aa 100644
>>> --- a/drivers/vfio/fsl-mc/Kconfig
>>> +++ b/drivers/vfio/fsl-mc/Kconfig
>>> @@ -1,3 +1,5 @@
>>> +menu "VFIO support for FSL_MC bus devices"
>>> +
>>
>> The menu entry can be empty on arches not supporting the FSL-MC bus.
>> I think this needs an extra :
>>
>> 	depends on ARM64 || COMPILE_TEST
> 
> Good catch, but shouldn't we just move up the FSL_MC_BUS depends to the
> menu level?  Thanks,

Yes. This is better than adding a new depends on the arch.

Thanks,

C.

> 
> Alex
> 
>>>    config VFIO_FSL_MC
>>>    	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>>>    	depends on FSL_MC_BUS
>>> @@ -8,3 +10,5 @@ config VFIO_FSL_MC
>>>    	  fsl-mc bus devices using the VFIO framework.
>>>    
>>>    	  If you don't know what to do here, say N.
>>> +
>>> +endmenu
>>
> 

