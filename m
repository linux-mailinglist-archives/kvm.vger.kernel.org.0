Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA65E8239
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiIWS7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 14:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWS7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 14:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A659425C43
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663959586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkp9uIojDcvTz1WAjdwqm+62cYEBiOSYUQ5dsx6Xy3c=;
        b=XPhuzPbKLWwRy6Ul7iyMPJSmqzftxDTe0lTJE2W87AgZVPr3fBwk9rYg8YyGFLup/ZOoFI
        2n9HVQ5wzPqT+NZ+spDBfE4DcSHJewHSGKGgtP80bSwIwRP31YIBZGbo8a+HI1l+P0UQVF
        2JZ8ajlZyuBRJXpId0FdTElIIXUWeq8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-GdhNEeqrOTKWlyeWNfszUA-1; Fri, 23 Sep 2022 14:59:45 -0400
X-MC-Unique: GdhNEeqrOTKWlyeWNfszUA-1
Received: by mail-wr1-f70.google.com with SMTP id h20-20020adfaa94000000b0022af8c26b72so210897wrc.7
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jkp9uIojDcvTz1WAjdwqm+62cYEBiOSYUQ5dsx6Xy3c=;
        b=zRu7yMSHnalQH8qf51zcG4AlJRv+DvTc/5lW1dQ3idDKJnzU+espnZ82FmsPGDpyVC
         1KuZttT7JZXql/nVj/knvP0oxOjeuACU5ZNbQNeys4LlIemupNdPBoxQF+wXd77YHwD9
         hSstyAUuWFbqV4xvVdv6xuG1ii6pEpu5YPsVTlmRPQPUOICtWMJ8n+5Li3hhq527IvZg
         FNQt/Hsq2kmrHADlIVkHv7EL3eUTx6YpYAa/M/dMOMyqpHACmUfN4bRFDbt5xyzlT1Dp
         FQutntjp5f7HzJxbEifGQLaK6EV/ZXEc26eBVotiL4BhQSeZ7Vkdenm3Apqnfxoc7bms
         vxbA==
X-Gm-Message-State: ACrzQf31LFliPZLXv7PdVHfanT6LiY6s7mOVnv/AgstF0uaRqGIRz3SY
        38szmMWSyYtm7ycdIqBbO3j049+rsHzX6DP2iI1gJ8bYbrYpbWYTmBn8V7hBj5as+19XlyQLyQT
        QPdwy1KJ8yn0j
X-Received: by 2002:a5d:550c:0:b0:22b:1942:4bf6 with SMTP id b12-20020a5d550c000000b0022b19424bf6mr5901931wrv.520.1663959583273;
        Fri, 23 Sep 2022 11:59:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4CXt1Gmz2l63VsV0kLrMAmo+b3zf+Ph2eH6nv8EPj6XWnMUJUXHIU039mANC4WKldL8KEvYQ==
X-Received: by 2002:a5d:550c:0:b0:22b:1942:4bf6 with SMTP id b12-20020a5d550c000000b0022b19424bf6mr5901917wrv.520.1663959583071;
        Fri, 23 Sep 2022 11:59:43 -0700 (PDT)
Received: from [192.168.8.103] (tmo-097-189.customers.d1-online.com. [80.187.97.189])
        by smtp.gmail.com with ESMTPSA id g16-20020adfe410000000b0022ac13aa98fsm7849175wrm.97.2022.09.23.11.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:59:42 -0700 (PDT)
Message-ID: <c783fe07-4f4c-a52b-0445-0a4df057ffa6@redhat.com>
Date:   Fri, 23 Sep 2022 20:59:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 0/8] s390x/pci: zPCI interpretation support
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220902172737.170349-1-mjrosato@linux.ibm.com>
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
> Now that the kernel series [1] is merged and the freeze is over, here is a
> refresh of the zPCI interpretation series.
>                                                             
> For QEMU, the majority of the work in enabling instruction interpretation
> is handled via SHM bit settings (to indicate to firmware whether or not
> interpretive execution facilities are to be used) + a new KVM ioctl is
> used to setup firmware-interpreted forwarding of Adapter Event
> Notifications.
> 
> This series also adds a new, optional 'interpret' parameter to zpci which
> can be used to disable interpretation support (interpret=off) as well as
> an 'forwarding_assist' parameter to determine whether or not the firmware
> assist will be used for adapter event delivery (default when
> interpretation is in use) or whether the host will be responsible for
> delivering all adapter event notifications (forwarding_assist=off).
> 
> The zpcii-disable machine property is added to allow disabling use of
> zPCI interpretation facilities for a guest. This property is set to on
> for older (pre-7.2 compat machines), but defaults to off for 7.2 and
> newer. This allows newer machines to use interpretation by default if
> the necessary kernel interfaces and hardware facilities are available,
> but also provides a mechanism for disabling interpretation completely
> for debug purposes.
> 
> As a consequence of implementing zPCI interpretation, ISM devices now
> become eligible for passthrough (but only when zPCI interpretation is
> available).
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Changelog v7->v8:
> - Rebase onto 7.1.0
> - Move compat machine changes for patch 8
> - Refresh kernel header sync to 6.0-rc3
> 
> [1] https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/
> 
> Matthew Rosato (8):
>    linux-headers: update to 6.0-rc3
>    s390x/pci: add routine to get host function handle from CLP info
>    s390x/pci: enable for load/store intepretation

Typo in that subject, should be "interpretation" instead of "intepretation".

>    s390x/pci: don't fence interpreted devices without MSI-X
>    s390x/pci: enable adapter event notification for interpreted devices
>    s390x/pci: let intercept devices have separate PCI groups
>    s390x/pci: reflect proper maxstbl for groups of interpreted devices
>    s390x/s390-virtio-ccw: add zpcii-disable machine property

Thanks, patch series looks basically fine to me now. Some nits here and 
there, so if you could still fix those up and send a v9, that would be 
great! (If you are completely out of spare time for that, let me know, then 
I can also try to fix those up on my own when picking up the patches)

  Thomas

