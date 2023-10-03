Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8987B6ABC
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjJCNkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 09:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjJCNkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 09:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508AA6
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 06:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696340383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DW9sDr4AfG6o1aJcxuQdohehi94/uh5JiXo4Eu6EULk=;
        b=Aj0Rpx9e2jNS0T9ixJUNdUAiS5y6edUQyAoV8gWu127nsvip189cyyotE/qSdh5aCivsn9
        x/E2LuL6JfRx5p0xoyCn5TbPxtl02toMi8tBhgQw+xJwEwj7xZ0EcpaObDAI1dEhhUfxdr
        dMQDpx0C+XrjRxm3Xyc3a/NsPRgz5nA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-4mvh566CONaIPHfSm5Wj4g-1; Tue, 03 Oct 2023 09:39:42 -0400
X-MC-Unique: 4mvh566CONaIPHfSm5Wj4g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40647c6f71dso6835025e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 06:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696340380; x=1696945180;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DW9sDr4AfG6o1aJcxuQdohehi94/uh5JiXo4Eu6EULk=;
        b=NAubYRJXtQXZtkaslohyD+Wcesr6moSC9ASOOEJOAzDxpnqmjT5xeTk2QmBT+6YOUh
         xJV7tgOz+T0MBu+XaZz7PSztjGHVJPW5JxvjVqZz/QxtBnYK21mLT6w5yvgPei1B+QF3
         HjK2fCF1UBKmzjtR95dG6K9e4/fI6M9WvUHZXdYYZMR920k7WOruhJpgtuZCUbsRjq76
         4nVWuwI88dqVh79I8ploqgGUvTM2wpb8lrpsXuhvawu661p0ipLWnrLvtR1seulQSv+M
         Hn0D7ng2XQQrcM1dvmNTqCUQG19D0x+qmt/slDZN9mWkeHttLKmNI1dKwJRlalTGtSdl
         NhQg==
X-Gm-Message-State: AOJu0Yyb79m+fTQkluEiEIyl5akblBfJLVGakjGDAtDSOiC398wvgsO/
        Vbk2FhWmsj4aCMG+ygk7g9YKMakFGC9CQkzf00sPqobAo5JnCuxbSADsdx+vA8zfsz0mbZYkA9N
        5rXUOAF6Yoac4
X-Received: by 2002:a1c:7219:0:b0:403:8fb9:8d69 with SMTP id n25-20020a1c7219000000b004038fb98d69mr13161709wmc.25.1696340380246;
        Tue, 03 Oct 2023 06:39:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUIPZu0O4hosGfJflZrf+cQcIl9r+aoinChQFjA8XZ2y385NWR8ehQfVAFw5O2EQgQHqKXMg==
X-Received: by 2002:a1c:7219:0:b0:403:8fb9:8d69 with SMTP id n25-20020a1c7219000000b004038fb98d69mr13161669wmc.25.1696340379137;
        Tue, 03 Oct 2023 06:39:39 -0700 (PDT)
Received: from redhat.com ([2.52.132.27])
        by smtp.gmail.com with ESMTPSA id i12-20020a5d438c000000b0031fe0576460sm1629648wrq.11.2023.10.03.06.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 06:39:38 -0700 (PDT)
Date:   Tue, 3 Oct 2023 09:39:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 00/18] virtio-mem: Expose device memory through
 multiple memslots
Message-ID: <20231003093802-mutt-send-email-mst@kernel.org>
References: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 08:57:20PM +0200, David Hildenbrand wrote:
> Quoting from patch #16:
> 
>     Having large virtio-mem devices that only expose little memory to a VM
>     is currently a problem: we map the whole sparse memory region into the
>     guest using a single memslot, resulting in one gigantic memslot in KVM.
>     KVM allocates metadata for the whole memslot, which can result in quite
>     some memory waste.
> 
>     Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
>     1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
>     allocate metadata for that 1 TiB memslot: on x86, this implies allocating
>     a significant amount of memory for metadata:
> 
>     (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>         -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
> 
>         With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>         allocated lazily when required for nested VMs
>     (2) gfn_track: 2 bytes per 4 KiB
>         -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
>     (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>         -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
>     (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>         -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
> 
>     So we primarily care about (1) and (2). The bad thing is, that the
>     memory consumption doubles once SMM is enabled, because we create the
>     memslot once for !SMM and once for SMM.
> 
>     Having a 1 TiB memslot without the TDP MMU consumes around:
>     * With SMM: 5 GiB
>     * Without SMM: 2.5 GiB
>     Having a 1 TiB memslot with the TDP MMU consumes around:
>     * With SMM: 1 GiB
>     * Without SMM: 512 MiB
> 
>     ... and that's really something we want to optimize, to be able to just
>     start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
>     that can grow very large (e.g., 1 TiB).
> 
>     Consequently, using multiple memslots and only mapping the memslots we
>     really need can significantly reduce memory waste and speed up
>     memslot-related operations. Let's expose the sparse RAM memory region using
>     multiple memslots, mapping only the memslots we currently need into our
>     device memory region container.
> 
> The hyper-v balloon driver has similar demands [1].
> 
> For virtio-mem, this has to be turned manually on ("dynamic-memslots=on"),
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
>     Plugging vhost devices with less than 509 memslots available while we
>     have memory devices plugged that consume multiple memslots due to
>     automatic decisions can be problematic. Most configurations might just fail
>     due to "limit < used + reserved", however, it can also happen that these
>     memory devices would suddenly consume memslots that would actually be
>     required by other memslot consumers (boot, PCI BARs) later. Note that this
>     has always been sketchy with vhost devices that support only a small number
>     of memslots; but we don't want to make it any worse.So let's keep it simple
>     and simply reject plugging such vhost devices in such a configuration.
> 
>     Eventually, all vhost devices that want to be fully compatible with such
>     memory devices should support a decent number of memslots (>= 509).
> 
> 
> The recommendation is to plug such vhost devices before the virtio-mem
> decides, or to not set "dynamic-memslots=on". As soon as these devices
> support a reasonable number of memslots (>= 509), this will start working
> automatically.
> 
> I run some tests on x86_64, now also including vfio and migration tests.
> Seems to work as expected, even when multiple memslots are used.
> 
> 
> Patch #1 -- #3 are from [2] that were not picked up yet.
> 
> Patch #4 -- #12 add handling of multiple memslots to memory devices
> 
> Patch #13 -- #16 add "dynamic-memslots=on" support to virtio-mem
> 
> Patch #15 -- #16 make sure that virtio-mem memslots can be enabled/disable
>              atomically


Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

pls feel free to merge.


> v3 -> v4:
> * "virtio-mem: Pass non-const VirtIOMEM via virtio_mem_range_cb"
>  -> Cleanup patch added
> * "virtio-mem: Update state to match bitmap as soon as it's been migrated"
>  -> Cleanup patch added
> * "virtio-mem: Expose device memory dynamically via multiple memslots if
>    enabled"
>  -> Parameter now called "dynamic-memslots"
>  -> With "dynamic-memslots=off", don't use a memory region container and
>     just use the old handling: always map the RAM memory region [thus the
>     new parameter name]
>  -> Require "unplugged-inaccessible=on" (default) with
>     "dynamic-memslots=on" for simplicity
>  -> Take care of proper migration handling
>  -> Remove accidential additional busy check in virtio_mem_unplug_all()
>  -> Minor comment cleanups
>  -> Dropped RB because of changes
> 
> v2 -> v3:
> * "kvm: Return number of free memslots"
>  -> Return 0 in stub
> * "kvm: Add stub for kvm_get_max_memslots()"
>  -> Return 0 in stub
> * Adjust other patches to check for kvm_enabled() before calling
>   kvm_get_free_memslots()/kvm_get_max_memslots()
> * Add RBs
> 
> v1 -> v2:
> * Include patches from [1]
> * A lot of code simplification and reorganization, too many to spell out
> * don't add a general soft-limit on memslots, to avoid warning in sane
>   setups
> * Simplify handling of vhost devices with a small number of memslots:
>   simply fail plugging them
> * "virtio-mem: Expose device memory via multiple memslots if enabled"
>  -> Fix one "is this the last memslot" check
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
> David Hildenbrand (18):
>   vhost: Rework memslot filtering and fix "used_memslot" tracking
>   vhost: Remove vhost_backend_can_merge() callback
>   softmmu/physmem: Fixup qemu_ram_block_from_host() documentation
>   kvm: Return number of free memslots
>   vhost: Return number of free memslots
>   memory-device: Support memory devices with multiple memslots
>   stubs: Rename qmp_memory_device.c to memory_device.c
>   memory-device: Track required and actually used memslots in
>     DeviceMemoryState
>   memory-device,vhost: Support memory devices that dynamically consume
>     memslots
>   kvm: Add stub for kvm_get_max_memslots()
>   vhost: Add vhost_get_max_memslots()
>   memory-device,vhost: Support automatic decision on the number of
>     memslots
>   memory: Clarify mapping requirements for RamDiscardManager
>   virtio-mem: Pass non-const VirtIOMEM via virtio_mem_range_cb
>   virtio-mem: Update state to match bitmap as soon as it's been migrated
>   virtio-mem: Expose device memory dynamically via multiple memslots if
>     enabled
>   memory,vhost: Allow for marking memory device memory regions
>     unmergeable
>   virtio-mem: Mark memslot alias memory regions unmergeable
> 
>  MAINTAINERS                                   |   1 +
>  accel/kvm/kvm-all.c                           |  35 +-
>  accel/stubs/kvm-stub.c                        |   9 +-
>  hw/mem/memory-device.c                        | 196 ++++++++++-
>  hw/virtio/vhost-stub.c                        |   9 +-
>  hw/virtio/vhost-user.c                        |  21 +-
>  hw/virtio/vhost-vdpa.c                        |   1 -
>  hw/virtio/vhost.c                             | 103 +++++-
>  hw/virtio/virtio-mem-pci.c                    |  21 ++
>  hw/virtio/virtio-mem.c                        | 330 +++++++++++++++++-
>  include/exec/cpu-common.h                     |  15 +
>  include/exec/memory.h                         |  27 +-
>  include/hw/boards.h                           |  14 +-
>  include/hw/mem/memory-device.h                |  57 +++
>  include/hw/virtio/vhost-backend.h             |   9 +-
>  include/hw/virtio/vhost.h                     |   3 +-
>  include/hw/virtio/virtio-mem.h                |  32 +-
>  include/sysemu/kvm.h                          |   4 +-
>  include/sysemu/kvm_int.h                      |   1 +
>  softmmu/memory.c                              |  35 +-
>  softmmu/physmem.c                             |  17 -
>  .../{qmp_memory_device.c => memory_device.c}  |  10 +
>  stubs/meson.build                             |   2 +-
>  23 files changed, 839 insertions(+), 113 deletions(-)
>  rename stubs/{qmp_memory_device.c => memory_device.c} (56%)
> 
> -- 
> 2.41.0

