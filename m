Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E364575AD69
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 13:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjGTLvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjGTLvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 07:51:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9160273D
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 04:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689853832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jx6EOdcX24MLWgGqV3iDS/42+N7tAZafpHq9oSuqr7A=;
        b=HaZ5aY7Iq3izQkuOQ3AuEubik10KUg4UBR6JC1y3Gcr/hDLxRLwQzeQIFWQRi1xS6KGos/
        YLeYyE7h83Xawq5r50C0YZQ/Ox2vUya12eEJcQWhwqKgni49VSKkqoMntmxXBDMjqpAjZx
        ZKeZLBouZ1S9m8NTfiJlZqhYu+4g5ow=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-5c6w-5A6P7WXBaCXcsBnhw-1; Thu, 20 Jul 2023 07:50:31 -0400
X-MC-Unique: 5c6w-5A6P7WXBaCXcsBnhw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-51b5133ad4dso195876a12.0
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 04:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689853830; x=1690458630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jx6EOdcX24MLWgGqV3iDS/42+N7tAZafpHq9oSuqr7A=;
        b=OvWbbMgtYJRWzmYDHXZwj5m6ZmQc9pnDCCpDgr8GM2hs/tKHc16qkMc6scibBrxzeW
         8wdG0qn7zLbDZ9ucZUiq26tWvhovoDY/uN2NIxPpDHfkb6yzu3wQ13YZsL7F0Ee8hBY/
         B16+g4G/K7b9Kn/F86EkwA3/TF9CA7sr+IEX/S9oQVhu/UylLH81izYl7McI7tWqCDiN
         C4A9lAPmJJo7kMHlMzVC+RhvqXQTEFyst7tjM5CNfDqxX/od4F8HCCM/yfTeK/YE/PtM
         ezpKmR4uNWyooCqlAA8LT5cueQJQ8JJM/Rs2gudH4nNYdGsFnkSZF7WWoBcX9Bh9OAAx
         qAPA==
X-Gm-Message-State: ABy/qLYaaqYOJasJ/m1iw/KtRmTo5yDnISAZccrPOcyx8W7zdiQF4fv7
        8Ob1+rCB0imZxEjxSrfXFC1xQf/k4Zo79pXj5Ea1Ch7wTn11ES1aiK+sh9s1lQBcGpZdhueMS5U
        xHsbxR6DOstzf
X-Received: by 2002:a05:6a00:e0a:b0:668:834d:4bd with SMTP id bq10-20020a056a000e0a00b00668834d04bdmr19093087pfb.0.1689853830475;
        Thu, 20 Jul 2023 04:50:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF9Wgu02vzYI9FbSDeIx6hVxfo5aA65r/vOCyVZENjPU/Zny8BpXYCD3cH6jyOuUBZMtdMbKg==
X-Received: by 2002:a05:6a00:e0a:b0:668:834d:4bd with SMTP id bq10-20020a056a000e0a00b00668834d04bdmr19093070pfb.0.1689853830141;
        Thu, 20 Jul 2023 04:50:30 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78486000000b00682af82a9desm1016820pfn.98.2023.07.20.04.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 04:50:29 -0700 (PDT)
Message-ID: <41643570-a927-87de-ef1e-f0ec375edff9@redhat.com>
Date:   Thu, 20 Jul 2023 19:50:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm64: Replace the SCTLR_EL1 filed
 definition by _BITUL()
To:     eric.auger@redhat.com, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-2-shahuang@redhat.com>
 <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 7/20/23 01:46, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 7/19/23 05:19, Shaoqin Huang wrote:
>> Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
>> replaced by the _BITUL() macro to make the format consistent with the
>> SCTLR_EL1_RES1 definition.
> 
> I would rephrase the commit title into arm64: Use _BITUL() to define
> SCTLR_EL1 bit fields
> 
This would be good. I will change the title to it.

> Besides, since SCTLR_EL1 is 64b shouldn't we have _BITULL() everywhere
> instead?
Yeah. Although the _BITUL() can cover the 64 bit value, it would be 
clear to use the _BITULL(), let me change it in next version.

Thanks,
Shaoqin
> 
> Eric
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   lib/arm64/asm/sysreg.h | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index 18c4ed3..c7f529d 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -80,14 +80,14 @@ asm(
>>   #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>>   
>>   /* System Control Register (SCTLR_EL1) bits */
>> -#define SCTLR_EL1_EE	(1 << 25)
>> -#define SCTLR_EL1_WXN	(1 << 19)
>> -#define SCTLR_EL1_I	(1 << 12)
>> -#define SCTLR_EL1_SA0	(1 << 4)
>> -#define SCTLR_EL1_SA	(1 << 3)
>> -#define SCTLR_EL1_C	(1 << 2)
>> -#define SCTLR_EL1_A	(1 << 1)
>> -#define SCTLR_EL1_M	(1 << 0)
>> +#define SCTLR_EL1_EE		_BITUL(25)
>> +#define SCTLR_EL1_WXN		_BITUL(19)
>> +#define SCTLR_EL1_I		_BITUL(12)
>> +#define SCTLR_EL1_SA0		_BITUL(4)
>> +#define SCTLR_EL1_SA		_BITUL(3)
>> +#define SCTLR_EL1_C		_BITUL(2)
>> +#define SCTLR_EL1_A		_BITUL(1)
>> +#define SCTLR_EL1_M		_BITUL(0)
>>   
>>   #define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>>   			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> 

-- 
Shaoqin

