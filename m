Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511A47A49C6
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbjIRMeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241546AbjIRMeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:34:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5BDC7
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695040393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=coBfqFpb/wyZXdS6QqkGdg1gDXZjIlpUGhl0nSH9DK0=;
        b=TAo9R1l40xTdmMI/VQyFkEYCCGfIKoTkjD0WqFugho3e3fsf9zYqPzFHgjsFH80j/QCMhh
        D9ksRkvTxmsFsH67oXciQbUr4RsbrSyirsH4t1aN7TTQo6GtTI7mnFg1dih8A1oOcziqC9
        reKOO0gJHS7aMKxxqmLnnzfLsvqgsIk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-UnnEcBtJMw-I7Y9zQEeh-g-1; Mon, 18 Sep 2023 08:33:11 -0400
X-MC-Unique: UnnEcBtJMw-I7Y9zQEeh-g-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-320004980a2so1298171f8f.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695040390; x=1695645190;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=coBfqFpb/wyZXdS6QqkGdg1gDXZjIlpUGhl0nSH9DK0=;
        b=laA10q5EptYAyDMk/ZUzsWBJSauxu1QXukM4gy7nQse0kjW8DUm3HsgjZixgetSUoV
         esNC+bl3OEpfHPcesVq5r8URqidyPE1GFFbI++Z9dNB3mXH77mxXh/HdF0uAGj0IFTCP
         r2+s5tP7Bj4LEmWwTMpKqljp+CSeIttLA8pLnU3RHfe6ujmeqok45MpOMDbs+7QtEVEN
         mFbrHm0flb/YcsZxQx3GIsQ47C+HnnlW1bCD7azvxcsE2Fh4XbLOvSUXBEkSjicNFckr
         R34ZL9kgpIOMYb4Y9/fIH75W20JoLuPpq/yUYoQDsXDOOfJEfQSX7GZ3D6y+doP1EOj5
         CFlQ==
X-Gm-Message-State: AOJu0YzZac7qkUpd/H31TW7jExxMrb1eUydOyt0OMS6HYo12nOw4ozvo
        85GpwZDCtxVHPjP4ouhxeEt6ey3HiKgL8sih1jYYXJAMLXajgLDPmTzUZtPxgQRJrxFz8KeXn/2
        uhv6ufamzttGv
X-Received: by 2002:a5d:62c6:0:b0:31c:6420:fff with SMTP id o6-20020a5d62c6000000b0031c64200fffmr7396195wrv.62.1695040390261;
        Mon, 18 Sep 2023 05:33:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD2P2BOV8swT5NqgKUM7ukPnqT6Lw5yhuc2qSplvEKAcB1ptTGcysHmpiONsvPY8kCubbpcQ==
X-Received: by 2002:a5d:62c6:0:b0:31c:6420:fff with SMTP id o6-20020a5d62c6000000b0031c64200fffmr7396166wrv.62.1695040389872;
        Mon, 18 Sep 2023 05:33:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:3400:ec51:7a3a:274e:cbee? (p200300cbc74b3400ec517a3a274ecbee.dip0.t-ipconnect.de. [2003:cb:c74b:3400:ec51:7a3a:274e:cbee])
        by smtp.gmail.com with ESMTPSA id w4-20020a5d5444000000b0031f3b04e7cdsm12367500wrv.109.2023.09.18.05.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:33:09 -0700 (PDT)
Message-ID: <43d310b6-e4aa-da33-c845-49e606a947fe@redhat.com>
Date:   Mon, 18 Sep 2023 14:33:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20230908142136.403541-1-david@redhat.com>
 <20230908142136.403541-13-david@redhat.com>
 <75866f2e-13c3-220e-cea8-bebc983b8cf7@maciej.szmigiero.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 12/16] memory-device,vhost: Support automatic decision
 on the number of memslots
In-Reply-To: <75866f2e-13c3-220e-cea8-bebc983b8cf7@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.09.23 12:46, Maciej S. Szmigiero wrote:
> On 8.09.2023 16:21, David Hildenbrand wrote:
>> We want to support memory devices that can automatically decide how many
>> memslots they will use. In the worst case, they have to use a single
>> memslot.
>>
>> The target use cases are virtio-mem and the hyper-v balloon.
>>
>> Let's calculate a reasonable limit such a memory device may use, and
>> instruct the device to make a decision based on that limit. Use a simple
>> heuristic that considers:
>> * A memslot soft-limit for all memory devices of 256; also, to not
>>     consume too many memslots -- which could harm performance.
>> * Actually still free and unreserved memslots
>> * The percentage of the remaining device memory region that memory device
>>     will occupy.
>>
>> Further, while we properly check before plugging a memory device whether
>> there still is are free memslots, we have other memslot consumers (such as
>> boot memory, PCI BARs) that don't perform any checks and might dynamically
>> consume memslots without any prior reservation. So we might succeed in
>> plugging a memory device, but once we dynamically map a PCI BAR we would
>> be in trouble. Doing accounting / reservation / checks for all such
>> users is problematic (e.g., sometimes we might temporarily split boot
>> memory into two memslots, triggered by the BIOS).
>>
>> We use the historic magic memslot number of 509 as orientation to when
>> supporting 256 memory devices -> memslots (leaving 253 for boot memory and
>> other devices) has been proven to work reliable. We'll fallback to
>> suggesting a single memslot if we don't have at least 509 total memslots.
>>
>> Plugging vhost devices with less than 509 memslots available while we
>> have memory devices plugged that consume multiple memslots due to
>> automatic decisions can be problematic. Most configurations might just fail
>> due to "limit < used + reserved", however, it can also happen that these
>> memory devices would suddenly consume memslots that would actually be
>> required by other memslot consumers (boot, PCI BARs) later. Note that this
>> has always been sketchy with vhost devices that support only a small number
>> of memslots; but we don't want to make it any worse.So let's keep it simple
>> and simply reject plugging such vhost devices in such a configuration.
>>
>> Eventually, all vhost devices that want to be fully compatible with such
>> memory devices should support a decent number of memslots (>= 509).
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
> 
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks!

> 
> I would be nice to ultimately allow raising the 509 memslot limit,
> considering that KVM had supported 32k memslots for more than two years
> now and had a much more scalable implementation since early 2022.

It's all tricky due to vhost (and hotplug of such devices) and the QEMU 
internal address translation (which isn't that scalable).

I was thinking about having a parameter to configure the number of 
memslots for memory devices, such that one could manually raise the 
"256" limit for memory devices.

But for now I kept it simple, because it all turned out to become way to 
complicated.

-- 
Cheers,

David / dhildenb

