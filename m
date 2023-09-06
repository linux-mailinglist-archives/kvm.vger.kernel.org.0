Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB25E793F0F
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbjIFOi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 10:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjIFOiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 10:38:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65CC8F
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 07:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694011059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lg2fMO06PnQXvtf+z6WSmsHkPqrM9ZYU8QTTgt0YWXQ=;
        b=ERKRAldWV71Crxd7M/NHhpJUzk0VS8YnWPA76b/rO9+FyNw9zk1ohVsD8cIPt/yU5H/lXt
        RBIA1KaKNQ0x2vM9nNEGR0IW8RHJKfKdgI+YL3AcXNq0E9XtUTrgVFnyZIU8ExSbB3TpBC
        xaTmVExdPRWkwLjsVhTCwcA/FVrp2H0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-JsMCZvvBP1mNqcCruV_DCA-1; Wed, 06 Sep 2023 10:37:37 -0400
X-MC-Unique: JsMCZvvBP1mNqcCruV_DCA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31f49c34d1fso1695008f8f.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 07:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694011056; x=1694615856;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lg2fMO06PnQXvtf+z6WSmsHkPqrM9ZYU8QTTgt0YWXQ=;
        b=Kb7Gde1dJN2QAS4h+h6H6ZWFVYetl4ZY1pI9ZnQaEA1R6PMS9FfF4dJYt4S2QppOEI
         +xbqbxjmfB1JwDvjWWdVDKt4A54raJt9Zcwz3+ZvZiDDnUCyx3vownk+6uPP+MOSyTTy
         YCP54ztG21RyNkcKpJ9M9V4A4gNVH/beVH5aDRGVYfAmgOLbqtnBB/V7i2o2KVKqZpcq
         aKxGRyIeydsSDmcHWjfWUcQtyhMje0ec7MqNt0a7n7od5cxG4Fa02MdWyiuihh9/yA7H
         1kHZjieqcW8OmM6jJ8xTwmFo6BL+dH1ceJ3UGWqhSxC3GOM4kgwcblUa5BsJf9J4S1Qv
         XlgQ==
X-Gm-Message-State: AOJu0Ywv3W9PIzsYFlzOA0OR1IiwQQyLOLOaySZMXs5dfJ/7gqRj8pBF
        oyJAmBWwsDltGpgFTQbbaTnVrX6+o4yHVh1FZkeHicWWKA5uahFsbnFU/A0h9I/K+SbMgjyfFpj
        vo3iBRNA42b56
X-Received: by 2002:adf:dc8c:0:b0:317:5351:e428 with SMTP id r12-20020adfdc8c000000b003175351e428mr2259902wrj.4.1694011056323;
        Wed, 06 Sep 2023 07:37:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6FP2trIpa9SyMRqQVDHpkv6KR2bWRmBHizszpCaWuoC2c7TXCDXjhpfQSjz/N58+wSW/0iw==
X-Received: by 2002:adf:dc8c:0:b0:317:5351:e428 with SMTP id r12-20020adfdc8c000000b003175351e428mr2259886wrj.4.1694011055968;
        Wed, 06 Sep 2023 07:37:35 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:6c00:92a4:6f8:ff7e:6853? (p200300cbc70c6c0092a406f8ff7e6853.dip0.t-ipconnect.de. [2003:cb:c70c:6c00:92a4:6f8:ff7e:6853])
        by smtp.gmail.com with ESMTPSA id j17-20020a5d5651000000b003197efd1e7bsm20671464wrw.114.2023.09.06.07.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 07:37:35 -0700 (PDT)
Message-ID: <de45c2d4-13b6-d022-e32a-ea5296e04b1d@redhat.com>
Date:   Wed, 6 Sep 2023 16:37:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 04/16] kvm: Return number of free memslots
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230825132149.366064-1-david@redhat.com>
 <20230825132149.366064-5-david@redhat.com>
 <1d68ca74-ce92-ca5f-2c8b-e4567265e2fc@linaro.org>
 <ee1bbc2b-3180-ab79-4f0d-6159577b2164@redhat.com>
Organization: Red Hat
In-Reply-To: <ee1bbc2b-3180-ab79-4f0d-6159577b2164@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.09.23 16:14, David Hildenbrand wrote:
> On 29.08.23 00:26, Philippe Mathieu-Daudé wrote:
>> On 25/8/23 15:21, David Hildenbrand wrote:
>>> Let's return the number of free slots instead of only checking if there
>>> is a free slot. While at it, check all address spaces, which will also
>>> consider SMM under x86 correctly.
>>>
>>> Make the stub return UINT_MAX, such that we can call the function
>>> unconditionally.
>>>
>>> This is a preparation for memory devices that consume multiple memslots.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>     accel/kvm/kvm-all.c      | 33 ++++++++++++++++++++-------------
>>>     accel/stubs/kvm-stub.c   |  4 ++--
>>>     hw/mem/memory-device.c   |  2 +-
>>>     include/sysemu/kvm.h     |  2 +-
>>>     include/sysemu/kvm_int.h |  1 +
>>>     5 files changed, 25 insertions(+), 17 deletions(-)
>>
>>
>>> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
>>> index 235dc661bc..f39997d86e 100644
>>> --- a/accel/stubs/kvm-stub.c
>>> +++ b/accel/stubs/kvm-stub.c
>>> @@ -109,9 +109,9 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
>>>         return -ENOSYS;
>>>     }
>>>     
>>> -bool kvm_has_free_slot(MachineState *ms)
>>> +unsigned int kvm_get_free_memslots(void)
>>>     {
>>> -    return false;
>>> +    return UINT_MAX;
>>
>> Isn't it clearer returning 0 here and keeping kvm_enabled() below?
> 
> I tried doing it similarly to vhost_has_free_slot().
> 

I'll leave the kvm_enabled() check in place, looks cleaner.

-- 
Cheers,

David / dhildenb

