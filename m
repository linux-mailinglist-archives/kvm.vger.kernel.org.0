Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D57B4E68
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 10:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbjJBI71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 04:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbjJBI7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 04:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8808CD9
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 01:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696237079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVukFMHb4sPlTBNho7wcg3FCMW675wzniIBiQO49dIQ=;
        b=iX7p3mPFUJ7aOZmu0rQpdGNb0JWjNX6BpqKA4rFJvhOJAVnbNhee5SOPRL4//ht0hkgc4v
        wrva/g9p2N0gCghBvzLCE2E1XRR1rRobr7AgwPen0byOfOj+VFQzWiClJlC2LdJg1K0982
        5PqnhLXfAEKelI34uGjJEkprVz54s8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-D16UaTFjMrqvvgbwcKc22g-1; Mon, 02 Oct 2023 04:57:43 -0400
X-MC-Unique: D16UaTFjMrqvvgbwcKc22g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fd0fa4d08cso134062695e9.1
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 01:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696237062; x=1696841862;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fVukFMHb4sPlTBNho7wcg3FCMW675wzniIBiQO49dIQ=;
        b=bzlKlacqjdCgWskq6ODAdQ3Yat4PoD6XEwu+TbCDMKQ9+z7POiL1+jiMUxUhO0MN8B
         eHMnY3I9Kh2I1LnY6vU4RYY/ny4thKzc4Hn+LX+SymKnv96PPNIVssjjkRVBqZIjEHkG
         qd74+jIDfqoHevHXTp9uEdWClDNecfUyha8+cMP9MM29SD4KxGNFqWEUobutaf2Q+pk6
         mNE9+N02gNaMHTA6bMePu7GsckuQw+mDSTH2BDU5qxt+lJuv/bcLipMug45oJOL1Jhto
         Aotz/u7c/YxFP6Fx6qTMQ5Yw9dkeXJB8MiotCAi3tAwXkbZJYYo1RP6Sh68lPzksrqlB
         OIPg==
X-Gm-Message-State: AOJu0YxBLZWAg+iQNzkOhus6CQPiwbuPMofCQnHeUXTCWXb5dCBwGoBp
        GgcXnoz4HEc2+1+tvHWnOb9Ta15NWsXI0yjb8WkgJZmUa4j0CTd8OLlgaaD+JqG0gQ4EuAEcsED
        jH6XuIE884JpT
X-Received: by 2002:a5d:56ca:0:b0:31f:d8b3:e9f5 with SMTP id m10-20020a5d56ca000000b0031fd8b3e9f5mr9146164wrw.34.1696237062442;
        Mon, 02 Oct 2023 01:57:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrzNVxIOfJOk15r++VqOXoeT1XnIyZuejaeShvDOTKPjy99A5uUDFfqMClE2pthwX0F/cLPg==
X-Received: by 2002:a5d:56ca:0:b0:31f:d8b3:e9f5 with SMTP id m10-20020a5d56ca000000b0031fd8b3e9f5mr9146156wrw.34.1696237062088;
        Mon, 02 Oct 2023 01:57:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c735:f200:cb49:cb8f:88fc:9446? (p200300cbc735f200cb49cb8f88fc9446.dip0.t-ipconnect.de. [2003:cb:c735:f200:cb49:cb8f:88fc:9446])
        by smtp.gmail.com with ESMTPSA id n3-20020adff083000000b003143867d2ebsm27577613wro.63.2023.10.02.01.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 01:57:41 -0700 (PDT)
Message-ID: <56cec8a9-f4bb-5e9e-a1c4-223359f8b491@redhat.com>
Date:   Mon, 2 Oct 2023 10:57:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 16/18] virtio-mem: Expose device memory dynamically via
 multiple memslots if enabled
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
References: <20230926185738.277351-1-david@redhat.com>
 <20230926185738.277351-17-david@redhat.com>
 <11c6efbd-b794-4a05-9c51-4928fb545db4@maciej.szmigiero.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <11c6efbd-b794-4a05-9c51-4928fb545db4@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.09.23 19:31, Maciej S. Szmigiero wrote:
> On 26.09.2023 20:57, David Hildenbrand wrote:
>> Having large virtio-mem devices that only expose little memory to a VM
>> is currently a problem: we map the whole sparse memory region into the
>> guest using a single memslot, resulting in one gigantic memslot in KVM.
>> KVM allocates metadata for the whole memslot, which can result in quite
>> some memory waste.
>>
>> Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
>> 1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
>> allocate metadata for that 1 TiB memslot: on x86, this implies allocating
>> a significant amount of memory for metadata:
>>
>> (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>>       -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
>>
>>       With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>>       allocated lazily when required for nested VMs
>> (2) gfn_track: 2 bytes per 4 KiB
>>       -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
>> (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>>       -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
>> (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>>       -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
>>
>> So we primarily care about (1) and (2). The bad thing is, that the
>> memory consumption *doubles* once SMM is enabled, because we create the
>> memslot once for !SMM and once for SMM.
>>
>> Having a 1 TiB memslot without the TDP MMU consumes around:
>> * With SMM: 5 GiB
>> * Without SMM: 2.5 GiB
>> Having a 1 TiB memslot with the TDP MMU consumes around:
>> * With SMM: 1 GiB
>> * Without SMM: 512 MiB
>>
>> ... and that's really something we want to optimize, to be able to just
>> start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
>> that can grow very large (e.g., 1 TiB).
>>
>> Consequently, using multiple memslots and only mapping the memslots we
>> really need can significantly reduce memory waste and speed up
>> memslot-related operations. Let's expose the sparse RAM memory region using
>> multiple memslots, mapping only the memslots we currently need into our
>> device memory region container.
>>
>> The feature can be enabled using "dynamic-memslots=on" and requires
>> "unplugged-inaccessible=on", which is nowadays the default.
>>
>> Once enabled, we'll auto-detect the number of memslots to use based on the
>> memslot limit provided by the core. We'll use at most 1 memslot per
>> gigabyte. Note that our global limit of memslots accross all memory devices
>> is currently set to 256: even with multiple large virtio-mem devices,
>> we'd still have a sane limit on the number of memslots used.
>>
>> The default is to not dynamically map memslot for now
>> ("dynamic-memslots=off"). The optimization must be enabled manually,
>> because some vhost setups (e.g., hotplug of vhost-user devices) might be
>> problematic until we support more memslots especially in vhost-user backends.
>>
>> Note that "dynamic-memslots=on" is just a hint that multiple memslots
>> *may* be used for internal optimizations, not that multiple memslots
>> *must* be used. The actual number of memslots that are used is an
>> internal detail: for example, once memslot metadata is no longer an
>> issue, we could simply stop optimizing for that. Migration source and
>> destination can differ on the setting of "dynamic-memslots".
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
> 
> The changes seem reasonable, so:
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>


Thanks Maciej!

-- 
Cheers,

David / dhildenb

