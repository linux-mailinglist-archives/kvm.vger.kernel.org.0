Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6745E81FF
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 20:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiIWSs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 14:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWSs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 14:48:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA2912059B
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663958901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcZj4oAakw7NzxFLR63X5HiohQDppY+RAJFyDkVYdTw=;
        b=hH3LjRfV6r/Oz8MNdQQnwpSs9MekaRTjolSWUJNwUCfhDot85QL5teA5L4Agw0KD3Yej9P
        Lz4JckgroAD6aCqVdS/vl1nIFXl6vBu+wLRUcn6+8dlZ/R3Qszz2uFGQkXX8R2KEz/FOp+
        7JeMBXg5SxO1iHrS0dlmYrQtjjSBqAM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-SN5VDZypM5eiAkjpSvGaIQ-1; Fri, 23 Sep 2022 14:48:17 -0400
X-MC-Unique: SN5VDZypM5eiAkjpSvGaIQ-1
Received: by mail-wm1-f72.google.com with SMTP id y15-20020a1c4b0f000000b003b47578405aso255081wma.5
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xcZj4oAakw7NzxFLR63X5HiohQDppY+RAJFyDkVYdTw=;
        b=cVUBrzdcUdlSshEDQ8yRhlTUDnxVaPBKBxNnp1qeD/F5zyaXJjUM52XXbFXkznXeqr
         gtPpJl2xMBbQA58A7i825I4iT0e23ztbO1owmPGpWnVPm02yAGo1y8/7qELToDe5Sckj
         U4pwRDbNX5h/Fvvo3/6UNjHUR50HO1l7EGwV3IhvVI0l/oSJMd/JWaI0e/CCQJSMhBqZ
         9X6TsJ+R9e2fN0HJlOSxeyf1AOFlfkXr25cZyjfK2gAq3p2P8wh0cqISVYa1FMUsn76X
         lKEM7qqiHQcGIRxPhaTxvAIxxA1qCUku5PfdJ1zv0o50mXJuWLOaUEaJ1ily2D+fd7sg
         wSqA==
X-Gm-Message-State: ACrzQf21hUMrzVRFGJ3zEqcfC+i+gWsk/dFTZLvNuWAfbqe4OnljpPnB
        4twlTj/jD48rx+IoPS/M4CzJNPDaJSdR0V/LXs+hOQdHNITN4SeEqqEp+osD/qqygei3NDprrKp
        PDJ6QBTY2Es1P
X-Received: by 2002:a05:600c:1547:b0:3b4:c56b:a3a6 with SMTP id f7-20020a05600c154700b003b4c56ba3a6mr6986518wmg.29.1663958896299;
        Fri, 23 Sep 2022 11:48:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7irMkZxkdU8OCZVuJM0rWKucA/Fj9+No5vqIKRBnloTbi+o1+yq3smZTbJ0wW++24DZlmgrA==
X-Received: by 2002:a05:600c:1547:b0:3b4:c56b:a3a6 with SMTP id f7-20020a05600c154700b003b4c56ba3a6mr6986505wmg.29.1663958896093;
        Fri, 23 Sep 2022 11:48:16 -0700 (PDT)
Received: from [192.168.8.103] (tmo-097-189.customers.d1-online.com. [80.187.97.189])
        by smtp.gmail.com with ESMTPSA id f10-20020a05600c154a00b003b339438733sm3497293wmg.19.2022.09.23.11.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:48:15 -0700 (PDT)
Message-ID: <4927fe8e-724d-a6d0-063b-dfad0730cb61@redhat.com>
Date:   Fri, 23 Sep 2022 20:48:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 5/8] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-6-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220902172737.170349-6-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 19.27, Matthew Rosato wrote:
> Use the associated kvm ioctl operation to enable adapter event notification
> and forwarding for devices when requested.  This feature will be set up
> with or without firmware assist based upon the 'forwarding_assist' setting.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 816d17af99..e66a0dfbef 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
...
> @@ -1428,6 +1440,8 @@ static Property s390_pci_device_properties[] = {
>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
>       DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
> +    DEFINE_PROP_BOOL("forwarding_assist", S390PCIBusDevice, forwarding_assist,
> +                     true),
>       DEFINE_PROP_END_OF_LIST(),
>   };

It seems to be more common to use "-" as separator in property names than to 
use "_" :

$ grep -r DEFINE_PROP_BOOL * | sed -e 's/^.*("//' -e 's/".*//' | grep _ | wc -l
39
$ grep -r DEFINE_PROP_BOOL * | sed -e 's/^.*("//' -e 's/".*//' | grep - | wc -l
169

... so maybe rename "forwarding_assist" to "forwarding-assist" ?

  Thomas

