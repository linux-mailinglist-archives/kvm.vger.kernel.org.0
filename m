Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D2A7AF36B
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 20:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbjIZS6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbjIZS6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 14:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9295E10A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 11:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695754676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TxpnUmsp7CDpOyOE4uRuAfPS1CYsQJrUqeNJWaRyC9g=;
        b=bFfraCmYyjfs2C4caPcH/xuvuum04D5TDZ24/ZQOWcG5ToyvQ54e++2CbNMIHRHKxSRW5s
        6LinGtOtWtfZ2q/0jrLemNSg3ybST+0R2hYlZlvD1Zjjoe+ZdyU2xeTttvB6qWFZ4appPB
        UShJOjjpc9/vhLUFb/ZKx9Tp1HExuZo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-g2fGDUOgNzKF-jPxEwneLg-1; Tue, 26 Sep 2023 14:57:55 -0400
X-MC-Unique: g2fGDUOgNzKF-jPxEwneLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFCA638116F9;
        Tue, 26 Sep 2023 18:57:54 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92F022026D4B;
        Tue, 26 Sep 2023 18:57:40 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v4 00/18] virtio-mem: Expose device memory through multiple memslots
Date:   Tue, 26 Sep 2023 20:57:20 +0200
Message-ID: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting from patch #16:

    Having large virtio-mem devices that only expose little memory to a VM
    is currently a problem: we map the whole sparse memory region into the
    guest using a single memslot, resulting in one gigantic memslot in KVM.
    KVM allocates metadata for the whole memslot, which can result in quite
    some memory waste.

    Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
    1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
    allocate metadata for that 1 TiB memslot: on x86, this implies allocating
    a significant amount of memory for metadata:

    (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
        -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)

        With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
        allocated lazily when required for nested VMs
    (2) gfn_track: 2 bytes per 4 KiB
        -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
    (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
        -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
    (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
        -> For 1 TiB: 536870912 = 64 MiB (0.006 %)

    So we primarily care about (1) and (2). The bad thing is, that the
    memory consumption doubles once SMM is enabled, because we create the
    memslot once for !SMM and once for SMM.

    Having a 1 TiB memslot without the TDP MMU consumes around:
    * With SMM: 5 GiB
    * Without SMM: 2.5 GiB
    Having a 1 TiB memslot with the TDP MMU consumes around:
    * With SMM: 1 GiB
    * Without SMM: 512 MiB

    ... and that's really something we want to optimize, to be able to just
    start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
    that can grow very large (e.g., 1 TiB).

    Consequently, using multiple memslots and only mapping the memslots we
    really need can significantly reduce memory waste and speed up
    memslot-related operations. Let's expose the sparse RAM memory region using
    multiple memslots, mapping only the memslots we currently need into our
    device memory region container.

The hyper-v balloon driver has similar demands [1].

For virtio-mem, this has to be turned manually on ("dynamic-memslots=on"),
due to the interaction with vhost (below).

If we have less than 509 memslots available, we always default to a single
memslot. Otherwise, we automatically decide how many memslots to use
based on a simple heuristic (see patch #12), and try not to use more than
256 memslots across all memory devices: our historical DIMM limit.

As soon as any memory devices automatically decided on using more than
one memslot, vhost devices that support less than 509 memslots (e.g.,
currently most vhost-user devices like with virtiofsd) can no longer be
plugged as a precaution.

Quoting from patch #12:

    Plugging vhost devices with less than 509 memslots available while we
    have memory devices plugged that consume multiple memslots due to
    automatic decisions can be problematic. Most configurations might just fail
    due to "limit < used + reserved", however, it can also happen that these
    memory devices would suddenly consume memslots that would actually be
    required by other memslot consumers (boot, PCI BARs) later. Note that this
    has always been sketchy with vhost devices that support only a small number
    of memslots; but we don't want to make it any worse.So let's keep it simple
    and simply reject plugging such vhost devices in such a configuration.

    Eventually, all vhost devices that want to be fully compatible with such
    memory devices should support a decent number of memslots (>= 509).


The recommendation is to plug such vhost devices before the virtio-mem
decides, or to not set "dynamic-memslots=on". As soon as these devices
support a reasonable number of memslots (>= 509), this will start working
automatically.

I run some tests on x86_64, now also including vfio and migration tests.
Seems to work as expected, even when multiple memslots are used.


Patch #1 -- #3 are from [2] that were not picked up yet.

Patch #4 -- #12 add handling of multiple memslots to memory devices

Patch #13 -- #16 add "dynamic-memslots=on" support to virtio-mem

Patch #15 -- #16 make sure that virtio-mem memslots can be enabled/disable
             atomically

v3 -> v4:
* "virtio-mem: Pass non-const VirtIOMEM via virtio_mem_range_cb"
 -> Cleanup patch added
* "virtio-mem: Update state to match bitmap as soon as it's been migrated"
 -> Cleanup patch added
* "virtio-mem: Expose device memory dynamically via multiple memslots if
   enabled"
 -> Parameter now called "dynamic-memslots"
 -> With "dynamic-memslots=off", don't use a memory region container and
    just use the old handling: always map the RAM memory region [thus the
    new parameter name]
 -> Require "unplugged-inaccessible=on" (default) with
    "dynamic-memslots=on" for simplicity
 -> Take care of proper migration handling
 -> Remove accidential additional busy check in virtio_mem_unplug_all()
 -> Minor comment cleanups
 -> Dropped RB because of changes

v2 -> v3:
* "kvm: Return number of free memslots"
 -> Return 0 in stub
* "kvm: Add stub for kvm_get_max_memslots()"
 -> Return 0 in stub
* Adjust other patches to check for kvm_enabled() before calling
  kvm_get_free_memslots()/kvm_get_max_memslots()
* Add RBs

v1 -> v2:
* Include patches from [1]
* A lot of code simplification and reorganization, too many to spell out
* don't add a general soft-limit on memslots, to avoid warning in sane
  setups
* Simplify handling of vhost devices with a small number of memslots:
  simply fail plugging them
* "virtio-mem: Expose device memory via multiple memslots if enabled"
 -> Fix one "is this the last memslot" check
* Much more testing


[1] https://lkml.kernel.org/r/cover.1689786474.git.maciej.szmigiero@oracle.com
[2] https://lkml.kernel.org/r/20230523185915.540373-1-david@redhat.com

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
Cc: Eduardo Habkost <eduardo@habkost.net>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Michal Privoznik <mprivozn@redhat.com>
Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Cc: kvm@vger.kernel.org

David Hildenbrand (18):
  vhost: Rework memslot filtering and fix "used_memslot" tracking
  vhost: Remove vhost_backend_can_merge() callback
  softmmu/physmem: Fixup qemu_ram_block_from_host() documentation
  kvm: Return number of free memslots
  vhost: Return number of free memslots
  memory-device: Support memory devices with multiple memslots
  stubs: Rename qmp_memory_device.c to memory_device.c
  memory-device: Track required and actually used memslots in
    DeviceMemoryState
  memory-device,vhost: Support memory devices that dynamically consume
    memslots
  kvm: Add stub for kvm_get_max_memslots()
  vhost: Add vhost_get_max_memslots()
  memory-device,vhost: Support automatic decision on the number of
    memslots
  memory: Clarify mapping requirements for RamDiscardManager
  virtio-mem: Pass non-const VirtIOMEM via virtio_mem_range_cb
  virtio-mem: Update state to match bitmap as soon as it's been migrated
  virtio-mem: Expose device memory dynamically via multiple memslots if
    enabled
  memory,vhost: Allow for marking memory device memory regions
    unmergeable
  virtio-mem: Mark memslot alias memory regions unmergeable

 MAINTAINERS                                   |   1 +
 accel/kvm/kvm-all.c                           |  35 +-
 accel/stubs/kvm-stub.c                        |   9 +-
 hw/mem/memory-device.c                        | 196 ++++++++++-
 hw/virtio/vhost-stub.c                        |   9 +-
 hw/virtio/vhost-user.c                        |  21 +-
 hw/virtio/vhost-vdpa.c                        |   1 -
 hw/virtio/vhost.c                             | 103 +++++-
 hw/virtio/virtio-mem-pci.c                    |  21 ++
 hw/virtio/virtio-mem.c                        | 330 +++++++++++++++++-
 include/exec/cpu-common.h                     |  15 +
 include/exec/memory.h                         |  27 +-
 include/hw/boards.h                           |  14 +-
 include/hw/mem/memory-device.h                |  57 +++
 include/hw/virtio/vhost-backend.h             |   9 +-
 include/hw/virtio/vhost.h                     |   3 +-
 include/hw/virtio/virtio-mem.h                |  32 +-
 include/sysemu/kvm.h                          |   4 +-
 include/sysemu/kvm_int.h                      |   1 +
 softmmu/memory.c                              |  35 +-
 softmmu/physmem.c                             |  17 -
 .../{qmp_memory_device.c => memory_device.c}  |  10 +
 stubs/meson.build                             |   2 +-
 23 files changed, 839 insertions(+), 113 deletions(-)
 rename stubs/{qmp_memory_device.c => memory_device.c} (56%)

-- 
2.41.0

