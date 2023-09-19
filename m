Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2887A5BFB
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 10:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjISIJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 04:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjISIJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 04:09:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AD3FB
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 01:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695110917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BveVHYYbO9DMBCSLkgW/QuwL2eKkh2hmhggCOlIxrUs=;
        b=eITbfNFhmWFMxltzFvOS/lewy3Gx6s7OAwy9rM5bMKtmMT3d3C+QF2kh3EZJBb8qeg2zv3
        Q/Xw5NCQaz3j4iUEq5055VPAjFN+vBr79oER70JEjPoJMXp+7AprzXgXvPjZT0AIxQyeb6
        Jv27/kOqkl1ej7gcfsjDEXiVCQCW/Fc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-Y-KnYZB4On6qqwYNG_yZuw-1; Tue, 19 Sep 2023 04:08:35 -0400
X-MC-Unique: Y-KnYZB4On6qqwYNG_yZuw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-321596eef3cso1018042f8f.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 01:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695110914; x=1695715714;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BveVHYYbO9DMBCSLkgW/QuwL2eKkh2hmhggCOlIxrUs=;
        b=fExBzFSw1gLetgA6Nn0rENqmOZa9ms6Z+tPptgfqs4HD3uHV5LNzAw8iX3yGw4exHh
         Z7V2t2TN9VpuNQo7oEflI7A1rij7u0O7ACeM1ri+AfWkpsmYJH7WdODmagJ7OSXxwURq
         pwI5nPW36DjQSXNnLKPrJg+aIb0pz9HuDarFUfETGejPPLiIJQffqaKY3G4az2jqGngP
         hQMWZ6lYcChHNFyfm7oWbOkeR26mDEib3IA8SkIDdxv8aEZNZahjOZSOiP07tENYkg9n
         lNPBmnIyqxAKdHAtkKiugSyHhbpSijC8bRPGof1QUS7XmGPHKyGDOTYYhOmvPnRoks4Y
         lzJQ==
X-Gm-Message-State: AOJu0YyYxxeaPoDMtYd8hWvTyy551RWu2/HWE4I4CN6gUxOsuhwB+yBy
        IJY/nySi2lOGdoI9urWUwXaUvnExtrN85S12nCIe3xLKHGel03XMUw0c8sbx0s8rqAJUSbF6Le4
        sUfFCc08NnNiv
X-Received: by 2002:a5d:6485:0:b0:320:9e7:d525 with SMTP id o5-20020a5d6485000000b0032009e7d525mr8214187wri.46.1695110914492;
        Tue, 19 Sep 2023 01:08:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjoEewH4/J/mLuuTmhBrNBs5PW3xkGMnD88BecOO/HJMuXnEDilXTe1ru1ao2gMAWWe5aq6w==
X-Received: by 2002:a5d:6485:0:b0:320:9e7:d525 with SMTP id o5-20020a5d6485000000b0032009e7d525mr8214154wri.46.1695110914048;
        Tue, 19 Sep 2023 01:08:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1300:c409:8b33:c793:108e? (p200300cbc7021300c4098b33c793108e.dip0.t-ipconnect.de. [2003:cb:c702:1300:c409:8b33:c793:108e])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d5052000000b0031ad5470f89sm10076490wrt.18.2023.09.19.01.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 01:08:33 -0700 (PDT)
Message-ID: <0ad650b9-2420-8715-bddf-1e5cf1f05797@redhat.com>
Date:   Tue, 19 Sep 2023 10:08:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 14/16] virtio-mem: Expose device memory via multiple
 memslots if enabled
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
 <20230908142136.403541-15-david@redhat.com>
 <e9cdf797-1497-ae65-9ac9-da0effb303d6@maciej.szmigiero.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <e9cdf797-1497-ae65-9ac9-da0effb303d6@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.09.23 13:47, Maciej S. Szmigiero wrote:
> On 8.09.2023 16:21, David Hildenbrand wrote:
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
>> * With VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we only map the memslots that
>>     actually have memory plugged, and dynamically (un)map when
>>     (un)plugging memory blocks.
>>
>> * Without VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we always map the memslots
>>     covered by the usable region, and dynamically (un)map when resizing the
>>     usable region.
>>
>> We'll auto-detect the number of memslots to use based on the memslot limit
>> provided by the core. We'll use at most 1 memslot per gigabyte. Note that
>> our global limit of memslots accross all memory devices is currently set to
>> 256: even with multiple large virtio-mem devices, we'd still have a sane
>> limit on the number of memslots used.
>>
>> The default is a single memslot for now ("multiple-memslots=off"). The
>> optimization must be enabled manually using "multiple-memslots=on", because
>> some vhost setups (e.g., hotplug of vhost-user devices) might be
>> problematic until we support more memslots especially in vhost-user
>> backends.
>>
>> Note that "multiple-memslots=on" is just a hint that multiple memslots
>> *may* be used for internal optimizations, not that multiple memslots
>> *must* be used. The actual number of memslots that are used is an
>> internal detail: for example, once memslot metadata is no longer an
>> issue, we could simply stop optimizing for that. Migration source and
>> destination can differ on the setting of "multiple-memslots".
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
> 
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Hope this patch was well-tested, especially on corner cases, since
> it's very easy to make an off-by-one somewhere (like v1 had) and
> much harder to spot it when doing a static code review.

I did test this series reasonably well indeed. Especially, also 
exercising the corner case of the last memslot having a different size.

Thanks for all the review!

-- 
Cheers,

David / dhildenb

