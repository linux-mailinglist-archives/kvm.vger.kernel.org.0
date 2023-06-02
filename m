Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDCF71FDB5
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 11:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjFBJXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 05:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjFBJW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 05:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCFE1BB
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 02:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685697627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iyR4b7qVUKjcdPNYm3WXxs3lGfl5xurwb+jr3GBXDeg=;
        b=FwNWWgNu4zqlDaARay4kldkmI8E5o2Q1pfpaSS8ndryIGcgfE5oFiaO1yw3gfEMyDevyfC
        zk+JBWUencLcoR+FLElbb6d/Mih2dfHkmDyAbwdIQo54rG760NLAjejGHlAb5xREz6o+Qc
        IoLNX1X5kHnDNUNDMRWUzALASHOTN1E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-feN1j98qN7-hhvt4lJzSBg-1; Fri, 02 Jun 2023 05:20:25 -0400
X-MC-Unique: feN1j98qN7-hhvt4lJzSBg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso10351685e9.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 02:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685697625; x=1688289625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyR4b7qVUKjcdPNYm3WXxs3lGfl5xurwb+jr3GBXDeg=;
        b=XPGJItOUqw11do7ASsXLL4DhcA3QNLPOJO4snutvtsCrI0TgZ7byLGT9bYQ5qW/EUY
         pIaC9KvhUF1wEAEXPi+l8vauxaHAd8OkvCd2zoUoPTNexU8Hmfmv5iBiGqQuRMxMMGOU
         gqWVWsnd5V6olvhrfhL8uI9k3KjrznFN9PVTCq8ePZo8hw2OLYwsorbOYEEbTzOXqQg8
         2WGtCX7IFcAC38KUGT0gNTjVhIh4hcel+r0IDQBlj6YOF1qe48Gb8nb1mU0PH5byu3C/
         4YB+8X8sNe62mvG3czCUsy6ueCQVXFA2xmZMg2+tRors2lwjuX3AhJ5lgQjN/L7FEIUz
         8LIw==
X-Gm-Message-State: AC+VfDxUa2+NghpElKXJ87CAYyDuSWPzYtv0MpXk2FLTIyZb1exwHU0n
        L5XwwBpCeDf4x0rB77dwfVEQjIY+WuP1Suppc3NDK194WMcesiKNIX0xMSjnTGs9auA7O/H6YcX
        iZ6GiuxfPFH3G
X-Received: by 2002:a1c:6a07:0:b0:3f7:28d8:4326 with SMTP id f7-20020a1c6a07000000b003f728d84326mr185557wmc.31.1685697624877;
        Fri, 02 Jun 2023 02:20:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ51/jsDzx9y2w14I8Dw1pW7tSM3jEUEPvw2oGPPnUXh5G+L2EcZ9xn1y+iUpRHbkwsD3iLQ0g==
X-Received: by 2002:a1c:6a07:0:b0:3f7:28d8:4326 with SMTP id f7-20020a1c6a07000000b003f728d84326mr185546wmc.31.1685697624660;
        Fri, 02 Jun 2023 02:20:24 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-14.web.vodafone.de. [109.43.176.14])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c248400b003f604793989sm4886360wms.18.2023.06.02.02.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 02:20:24 -0700 (PDT)
Message-ID: <308278c8-aae2-52ba-15f0-7dffa312b200@redhat.com>
Date:   Fri, 2 Jun 2023 11:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     kvm@vger.kernel.org, imbrenda@linux.ibm.com, david@redhat.com,
        nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
 <168569490681.252746.1049350277526238686@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <168569490681.252746.1049350277526238686@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/2023 10.35, Nico Boehr wrote:
> Quoting Janosch Frank (2023-06-01 11:38:37)
> [...]
>>>    [topology]
>>>    file = topology.elf
>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
>>> +# 1 CPU on socket 2
>>> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
>>> +
>>> +[topology-2]
>>> +file = topology.elf
>>> +extra_params = -smp 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on
>>
>> Pardon my ignorance but I see z14 in there, will this work if we run on
>> a z13?
> 
> It causes a skip, I reproduced this on a z14 by changing to z15:
> SKIP topology (qemu-system-s390x: unable to find CPU model 'z15')
> 
> If we can make this more generic so the tests run on older machines it would be
> good, but if we can't it wouldn't break (i.e. FAIL) on older machines.

Can't we simply use "-cpu max,ctop=on" ?

  Thomas

