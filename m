Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95CE793E7C
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 16:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjIFOO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 10:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjIFOO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 10:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAAE4C
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 07:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694009648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lzHtwompDH4ot0mG0goaqF7vDhNcRl6a7TGwlvNbsco=;
        b=aDuNRNIR8/fbbsi6YFD/h6FlbC4DyK0PjQsjbKLTXYbBp1cPp+i/pjo8YN+MvCkmbZZ77T
        J0bijqMc8oEAnI1APYdl/hYb92FmSKEctYbd521HYQPPfStC3w27smBkFa0d50JEcGk6eD
        f5zGcBrWMXmlte7zQ/X7gYriGAvsEII=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-_nb2yQPjMOOeUS3M_Acsiw-1; Wed, 06 Sep 2023 10:14:07 -0400
X-MC-Unique: _nb2yQPjMOOeUS3M_Acsiw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31aca0c0d63so1925128f8f.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 07:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694009646; x=1694614446;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzHtwompDH4ot0mG0goaqF7vDhNcRl6a7TGwlvNbsco=;
        b=hVsHY6oGm+XLPONn5e07FLlWMl0adiZowVjaJa4QfiVsqXOnlrGgPgR8lpSanOUjkp
         mb9cHvk2oSx2zuokdmpdHYLWwyfnQOcMK2jl4tgfvU61+7KAlF4SKNrVgQ0/KbCqEokR
         f+TXax/8z4AW6t80gvuBFy94YuUkIeNMSzJgg/QJroJjdElIeCj5eiFcH+c0plqsH4yc
         vEkFGiEDOjPAvCr9QxlR2+ixTkumf8MgfyUdePLFXVbTvdC9ptU5jOM8vPiG8bxTozLb
         6ejaGXUAa+magHp2o9yZUnVPb3XNSIP7q9dJTkU/nuzWJtwUyLdEbMaf+h85+p4arPnv
         kI6A==
X-Gm-Message-State: AOJu0YzuN0s9e7QZHEg/koeR4oehAy75cvrRaIxeyU+bk07R9IgGWMYz
        6rFUb+Ox+Uufqj5YB6d6f7Qiv/mMGCl1pBI6opbV88uF4Zhk0+ZQl5PZNX1N35+No5FisnejSCp
        nUpI0d/dea1p6
X-Received: by 2002:a5d:474e:0:b0:314:4c1d:1c0a with SMTP id o14-20020a5d474e000000b003144c1d1c0amr2348497wrs.46.1694009645904;
        Wed, 06 Sep 2023 07:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXHV85Qfrs1ZUl+gwI9DJTy3NJogPF2+CGxYJqLMVvXxXZdS0EA3zezyOq4W7Ai8SGu21k1g==
X-Received: by 2002:a5d:474e:0:b0:314:4c1d:1c0a with SMTP id o14-20020a5d474e000000b003144c1d1c0amr2348478wrs.46.1694009645490;
        Wed, 06 Sep 2023 07:14:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:6c00:92a4:6f8:ff7e:6853? (p200300cbc70c6c0092a406f8ff7e6853.dip0.t-ipconnect.de. [2003:cb:c70c:6c00:92a4:6f8:ff7e:6853])
        by smtp.gmail.com with ESMTPSA id e18-20020a5d5012000000b00317b063590fsm20537277wrt.55.2023.09.06.07.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 07:14:05 -0700 (PDT)
Message-ID: <ee1bbc2b-3180-ab79-4f0d-6159577b2164@redhat.com>
Date:   Wed, 6 Sep 2023 16:14:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 04/16] kvm: Return number of free memslots
Content-Language: en-US
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <1d68ca74-ce92-ca5f-2c8b-e4567265e2fc@linaro.org>
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

On 29.08.23 00:26, Philippe Mathieu-Daudé wrote:
> On 25/8/23 15:21, David Hildenbrand wrote:
>> Let's return the number of free slots instead of only checking if there
>> is a free slot. While at it, check all address spaces, which will also
>> consider SMM under x86 correctly.
>>
>> Make the stub return UINT_MAX, such that we can call the function
>> unconditionally.
>>
>> This is a preparation for memory devices that consume multiple memslots.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    accel/kvm/kvm-all.c      | 33 ++++++++++++++++++++-------------
>>    accel/stubs/kvm-stub.c   |  4 ++--
>>    hw/mem/memory-device.c   |  2 +-
>>    include/sysemu/kvm.h     |  2 +-
>>    include/sysemu/kvm_int.h |  1 +
>>    5 files changed, 25 insertions(+), 17 deletions(-)
> 
> 
>> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
>> index 235dc661bc..f39997d86e 100644
>> --- a/accel/stubs/kvm-stub.c
>> +++ b/accel/stubs/kvm-stub.c
>> @@ -109,9 +109,9 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
>>        return -ENOSYS;
>>    }
>>    
>> -bool kvm_has_free_slot(MachineState *ms)
>> +unsigned int kvm_get_free_memslots(void)
>>    {
>> -    return false;
>> +    return UINT_MAX;
> 
> Isn't it clearer returning 0 here and keeping kvm_enabled() below?

I tried doing it similarly to vhost_has_free_slot().

Also simplifies patch #12 :)

No strong opinion, though.

> 
> 
>> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
>> index 511b42bde5..8b09e78b12 100644
>> --- a/include/sysemu/kvm_int.h
>> +++ b/include/sysemu/kvm_int.h
>> @@ -40,6 +40,7 @@ typedef struct KVMMemoryUpdate {
>>    typedef struct KVMMemoryListener {
>>        MemoryListener listener;
>>        KVMSlot *slots;
>> +    int nr_used_slots;
> 
> Preferably using 'unsigned' here:

Sure, that should work.

> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Thanks!

-- 
Cheers,

David / dhildenb

