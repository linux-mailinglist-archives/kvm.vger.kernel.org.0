Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB961911F
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiKDGdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKDGdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC9E29817
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667543531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dX8cYlxJwzDZfvXPmozCJZLGXUiHzZ12cOvdwmDkv18=;
        b=Okgc4r60sjAhhYZhgoBprR9QTNmG/rX6fk0KTFgpL76ZciKUcP7hH6dwnes84KxdDmIs3s
        oZTAIj9Wlq6u0z0x9o67qejqbtp/Y/ktTW+J/PYtc3C/SFI50pILm4zUgP8jAGv5QbSP+d
        YhrrivYZz04desYTnVXrdt8cLQw9tOg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-s1WezUHBPhqhUBXgeKBiNA-1; Fri, 04 Nov 2022 02:32:09 -0400
X-MC-Unique: s1WezUHBPhqhUBXgeKBiNA-1
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a05600c420a00b003cf4dbff2e4so3779638wmh.8
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dX8cYlxJwzDZfvXPmozCJZLGXUiHzZ12cOvdwmDkv18=;
        b=Dm6RN08RlBLMn+3Mhs5L3ggfasii4ajcpgPbw+nKAQlPxVnYaOpzXqaN4lykdmQp1u
         bAKu8tcuH+Ddng7IqN3F+t9G30L0sCpSpuluNeMrXoxUWNDKUHVLiWQpfUbv1BuQO+Bd
         imBzP9L2SVXQFNxVvNOcqhwq4QTLg7EXM4VXiMyHzokY1lyi6d/JYuiJBiCap9Zch8At
         4hEUfRZn1FcnGimFXbD/LvHu+S87a0rHCcYwsW5FeGpxWoHwgjqESpxLfujIjJPzKYkG
         9qSDB6bi1cu0ZukXIyiN2qa/BlTTxjZQ87nf9ums7Qjso8qcXKvxlc04iGJmd+XA4lW6
         1Dag==
X-Gm-Message-State: ACrzQf0HkGW7/3s2e0HUWG+3rbDbpFnImSRM2gCFB5u8EJVS3fHkZdbg
        aBt9I0SeBJWrtgpd0Ep0LSK7UCqJHFc635efTS+83yPLzlXIcGSX9nkfldjtRV2eATWnTtZeaGy
        NIdlc8ZUs3CjM
X-Received: by 2002:a5d:66c3:0:b0:236:aa03:aa3c with SMTP id k3-20020a5d66c3000000b00236aa03aa3cmr20211274wrw.243.1667543528553;
        Thu, 03 Nov 2022 23:32:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6/B0giTptju8b2+QSdvxuySWuyQWqrYA8qov43OG4E4ougW5ZycKL2COPdW0bIpu1zXYwbpw==
X-Received: by 2002:a5d:66c3:0:b0:236:aa03:aa3c with SMTP id k3-20020a5d66c3000000b00236aa03aa3cmr20211248wrw.243.1667543528367;
        Thu, 03 Nov 2022 23:32:08 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-201.web.vodafone.de. [109.43.177.201])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d4307000000b00236883f2f5csm2509259wrq.94.2022.11.03.23.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 23:32:07 -0700 (PDT)
Message-ID: <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
Date:   Fri, 4 Nov 2022 07:32:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221103170150.20789-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2022 18.01, Pierre Morel wrote:
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
>   1 file changed, 72 insertions(+), 55 deletions(-)

-EMISSINGPATCHDESCRIPTION

... please add some words *why* this is a good idea / necessary.

  Thanks,
   Thomas


