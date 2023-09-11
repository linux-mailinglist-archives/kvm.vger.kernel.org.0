Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6558C79A4EB
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 09:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjIKHsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 03:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjIKHsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 03:48:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0549CCEA
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 00:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694418310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTNboWzDSc3SGx5JuRnXDvHj3ZoRhFQ2X/sj22olGCQ=;
        b=cmzHwKT8hoNPKXlbTIfcNY2eEZTinKI/0E9PKEC9sMAnw1/HTdKfpfFgZI7w4WiHEp0iiT
        nl2c1ihKuhYCNhkG+lMXpv99BXtPRsaLEohL1dlEZDBmkbcKuyphX8NiOUxnC4V5qBUaoP
        W+Kr2kzImjmxULiy9Q7mRCSxdWJHZ5w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-np3-OoY-N1eH7k7kFIh51A-1; Mon, 11 Sep 2023 03:45:08 -0400
X-MC-Unique: np3-OoY-N1eH7k7kFIh51A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31aea5cf0f5so2988895f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 00:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694418308; x=1695023108;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTNboWzDSc3SGx5JuRnXDvHj3ZoRhFQ2X/sj22olGCQ=;
        b=QQvVQofAHdwXd/GQqM2Wiye9bwkeJcCYooitcc9xy49j5f+Kh9rvj2SFgif7Xg7gJN
         5OVCeqFqIBfynaLi9xRIL4NR85Mr4XtOf0LIvad92tNZUBMycPiN4f0HkvEGhWC63Udk
         exgAV2dXYRJjvKOn37GBKHZ8jJZJbpzg/KW7omSuox80IbA018S5hIZqxsV3EE2J4T3/
         Hal7pLq/rXWTauogkDl/O4xxfcIXPW6NuShV3hTBPfT7+mhSu2oniNmxv47dL/xp/1fX
         G82IEN58xEttG4X5ZDPTeeC025r4o3N88mrmqNBFqOF3h0B6K+bUeDdOcKiqv5nutlbq
         F6Ug==
X-Gm-Message-State: AOJu0YyLtD/BgSm1SdVKV1SzeI/CNyi4Z2lA5f5gBseGfCcoArBbeD3J
        uLP+gGnAJ8Wwp0E+Dd7EKSFqTQDwWH2shoKMeEH2jOq3+DXfA0x6pCs6nmGzjJfJToBy+bTlrTo
        IIoKG+Ja/Mh/0
X-Received: by 2002:a05:6000:c8:b0:315:9676:c360 with SMTP id q8-20020a05600000c800b003159676c360mr8281533wrx.25.1694418307714;
        Mon, 11 Sep 2023 00:45:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExRTlPsuAf683s4wEsyig2hE4gOZSAYx9axC23udpLmqDw4/KJjfRkTvEUNgRB6pC+C1Ucmw==
X-Received: by 2002:a05:6000:c8:b0:315:9676:c360 with SMTP id q8-20020a05600000c800b003159676c360mr8281499wrx.25.1694418307306;
        Mon, 11 Sep 2023 00:45:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c743:5500:a9bd:94ab:74e9:782f? (p200300cbc7435500a9bd94ab74e9782f.dip0.t-ipconnect.de. [2003:cb:c743:5500:a9bd:94ab:74e9:782f])
        by smtp.gmail.com with ESMTPSA id j12-20020adfe50c000000b003176aa612b1sm9230677wrm.38.2023.09.11.00.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 00:45:06 -0700 (PDT)
Message-ID: <87e38689-c99b-0c92-3567-589cd9a2bc4c@redhat.com>
Date:   Mon, 11 Sep 2023 09:45:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/16] virtio-mem: Expose device memory through
 multiple memslots
Content-Language: en-US
To:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
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
References: <20230908142136.403541-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230908142136.403541-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

@MST, any comment on the vhost bits (mostly uncontroversial and only in 
the memslot domain)?

I'm planning on queuing this myself (but will wait a bit more), unless 
you want to take it.


On 08.09.23 16:21, David Hildenbrand wrote:
> Quoting from patch #14:
> 
>      Having large virtio-mem devices that only expose little memory to a VM
>      is currently a problem: we map the whole sparse memory region into the
>      guest using a single memslot, resulting in one gigantic memslot in KVM.
>      KVM allocates metadata for the whole memslot, which can result in quite
>      some memory waste.
> 
>      Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
>      1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
>      allocate metadata for that 1 TiB memslot: on x86, this implies allocating
>      a significant amount of memory for metadata:
> 
>      (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>          -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
> 
>          With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>          allocated lazily when required for nested VMs
>      (2) gfn_track: 2 bytes per 4 KiB
>          -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
>      (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>          -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
>      (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>          -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
> 
>      So we primarily care about (1) and (2). The bad thing is, that the
>      memory consumption doubles once SMM is enabled, because we create the
>      memslot once for !SMM and once for SMM.
> 
>      Having a 1 TiB memslot without the TDP MMU consumes around:
>      * With SMM: 5 GiB
>      * Without SMM: 2.5 GiB
>      Having a 1 TiB memslot with the TDP MMU consumes around:
>      * With SMM: 1 GiB
>      * Without SMM: 512 MiB
> 
>      ... and that's really something we want to optimize, to be able to just
>      start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
>      that can grow very large (e.g., 1 TiB).
> 
>      Consequently, using multiple memslots and only mapping the memslots we
>      really need can significantly reduce memory waste and speed up
>      memslot-related operations. Let's expose the sparse RAM memory region using
>      multiple memslots, mapping only the memslots we currently need into our
>      device memory region container.
> 
> The hyper-v balloon driver has similar demands [1].
> 
> For virtio-mem, this has to be turned manually on ("multiple-memslots=on"),
> due to the interaction with vhost (below).
> 
> If we have less than 509 memslots available, we always default to a single
> memslot. Otherwise, we automatically decide how many memslots to use
> based on a simple heuristic (see patch #12), and try not to use more than
> 256 memslots across all memory devices: our historical DIMM limit.
> 
> As soon as any memory devices automatically decided on using more than
> one memslot, vhost devices that support less than 509 memslots (e.g.,
> currently most vhost-user devices like with virtiofsd) can no longer be
> plugged as a precaution.
> 
> Quoting from patch #12:
> 
>      Plugging vhost devices with less than 509 memslots available while we
>      have memory devices plugged that consume multiple memslots due to
>      automatic decisions can be problematic. Most configurations might just fail
>      due to "limit < used + reserved", however, it can also happen that these
>      memory devices would suddenly consume memslots that would actually be
>      required by other memslot consumers (boot, PCI BARs) later. Note that this
>      has always been sketchy with vhost devices that support only a small number
>      of memslots; but we don't want to make it any worse.So let's keep it simple
>      and simply reject plugging such vhost devices in such a configuration.
> 
>      Eventually, all vhost devices that want to be fully compatible with such
>      memory devices should support a decent number of memslots (>= 509).
> 
> 
> The recommendation is to plug such vhost devices before the virtio-mem
> decides, or to not set "multiple-memslots=on". As soon as these devices
> support a reasonable number of memslots (>= 509), this will start working
> automatically.
> 
> I run some tests on x86_64, now also including vfio tests. Seems to work
> as expected, even when multiple memslots are used.
> 
> 
> Patch #1 -- #3 are from [2] that were not picked up yet.
> 
> Patch #4 -- #12 add handling of multiple memslots to memory devices
> 
> Patch #13 -- #14 add "multiple-memslots=on" support to virtio-mem
> 
> Patch #15 -- #16 make sure that virtio-mem memslots can be enabled/disable
>               atomically
> 
> v2 -> v3:
> * "kvm: Return number of free memslots"
>   -> Return 0 in stub
> * "kvm: Add stub for kvm_get_max_memslots()"
>   -> Return 0 in stub
> * Adjust other patches to check for kvm_enabled() before calling
>    kvm_get_free_memslots()/kvm_get_max_memslots()
> * Add RBs
> 
> v1 -> v2:
> * Include patches from [1]
> * A lot of code simplification and reorganization, too many to spell out
> * don't add a general soft-limit on memslots, to avoid warning in sane
>    setups
> * Simplify handling of vhost devices with a small number of memslots:
>    simply fail plugging them
> * "virtio-mem: Expose device memory via multiple memslots if enabled"
>   -> Fix one "is this the last memslot" check
> * Much more testing
> 
> 
> [1] https://lkml.kernel.org/r/cover.1689786474.git.maciej.szmigiero@oracle.com
> [2] https://lkml.kernel.org/r/20230523185915.540373-1-david@redhat.com
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
> Cc: Eduardo Habkost <eduardo@habkost.net>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Michal Privoznik <mprivozn@redhat.com>
> Cc: Daniel P. Berrangé <berrange@redhat.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> Cc: kvm@vger.kernel.org
> 
> David Hildenbrand (16):
>    vhost: Rework memslot filtering and fix "used_memslot" tracking
>    vhost: Remove vhost_backend_can_merge() callback
>    softmmu/physmem: Fixup qemu_ram_block_from_host() documentation
>    kvm: Return number of free memslots
>    vhost: Return number of free memslots
>    memory-device: Support memory devices with multiple memslots
>    stubs: Rename qmp_memory_device.c to memory_device.c
>    memory-device: Track required and actually used memslots in
>      DeviceMemoryState
>    memory-device,vhost: Support memory devices that dynamically consume
>      memslots
>    kvm: Add stub for kvm_get_max_memslots()
>    vhost: Add vhost_get_max_memslots()
>    memory-device,vhost: Support automatic decision on the number of
>      memslots
>    memory: Clarify mapping requirements for RamDiscardManager
>    virtio-mem: Expose device memory via multiple memslots if enabled
>    memory,vhost: Allow for marking memory device memory regions
>      unmergeable
>    virtio-mem: Mark memslot alias memory regions unmergeable
> 
>   MAINTAINERS                                   |   1 +
>   accel/kvm/kvm-all.c                           |  35 ++-
>   accel/stubs/kvm-stub.c                        |   9 +-
>   hw/mem/memory-device.c                        | 196 ++++++++++++-
>   hw/virtio/vhost-stub.c                        |   9 +-
>   hw/virtio/vhost-user.c                        |  21 +-
>   hw/virtio/vhost-vdpa.c                        |   1 -
>   hw/virtio/vhost.c                             | 103 +++++--
>   hw/virtio/virtio-mem-pci.c                    |  21 ++
>   hw/virtio/virtio-mem.c                        | 272 +++++++++++++++++-
>   include/exec/cpu-common.h                     |  15 +
>   include/exec/memory.h                         |  27 +-
>   include/hw/boards.h                           |  14 +-
>   include/hw/mem/memory-device.h                |  57 ++++
>   include/hw/virtio/vhost-backend.h             |   9 +-
>   include/hw/virtio/vhost.h                     |   3 +-
>   include/hw/virtio/virtio-mem.h                |  23 +-
>   include/sysemu/kvm.h                          |   4 +-
>   include/sysemu/kvm_int.h                      |   1 +
>   softmmu/memory.c                              |  35 ++-
>   softmmu/physmem.c                             |  17 --
>   .../{qmp_memory_device.c => memory_device.c}  |  10 +
>   stubs/meson.build                             |   2 +-
>   23 files changed, 779 insertions(+), 106 deletions(-)
>   rename stubs/{qmp_memory_device.c => memory_device.c} (56%)
> 

-- 
Cheers,

David / dhildenb

