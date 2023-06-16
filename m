Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5245732BB5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbjFPJa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344291AbjFPJ3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:29:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4771B4489
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sl3/QLeGJaY8BoyaG/bUFRZ9MbEZGlLKStLHrswAEAI=;
        b=QkWmOzEolob5wPZ8R/h8tNNDSdAEDD3Nky2hZL4TsYYMQ/extFNlFlEKsj1hsbBRK+IReJ
        ND2vWKWXMNdHjdsB4ZeshiuA75qAN2qG25o3FQN9KIzN/2gMFfDnDse0HIxU0CEnUrNx3v
        qOCmb54nA8BPJIdJVlMRnQHIqMYE00g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-W4J3JMR-PuWeRSpAjccIlA-1; Fri, 16 Jun 2023 05:27:09 -0400
X-MC-Unique: W4J3JMR-PuWeRSpAjccIlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9865800193;
        Fri, 16 Jun 2023 09:27:08 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D82E71121314;
        Fri, 16 Jun 2023 09:27:05 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH v1 00/15] virtio-mem: Expose device memory through multiple memslots
Date:   Fri, 16 Jun 2023 11:26:39 +0200
Message-Id: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the follow-up on [1] that took longer than expected because
vhost-user and other careless memslot consumers are just a pain. It's
essentially a complete rewrite now that we have
VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE (and I understood some nasty memslot
details better), so no changelog.

It's based on some cleanups [2, 3, 4] that are on the list.

Quoting from patch #13:

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
    memory consumption *doubles* once SMM is enabled, because we create the
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

The feature has to be turned manually on ("multiple-memslots=on") for now.
As virtio-mem will auto-detect the number of memslots to use based on the
current memslot configuration (max 256 for all memory devices), it's
suggested to:

(1) Define vhost device before memory devices on the QEMU cmdline. This
    primarily applies to vhost-user devices.
(2) Not hotplug vhost (especially vhost-user) devices that impose further
    memslot retsrictions. For example, hotplugging a vhost-user device
    might now fail because more memslots are getting ised.

Once vhost-user supports more memslots (i.e., ~512 instead of 32) these
restrictions no longer apply.

I run some tests on x86_64, but have to do some more testing with vfio.


Patch #1-#4 add a soft limit for memslots, based on the maximum number of
memslots around.

Patch #5-#7 add support for memory devices that statically consome multiple
memslots.

Patch #8-#9 add support for memory devices that dynamically consume
memslots on demand.

Patch #10-#11 adds support for memory devices that can auto-detect the
number of memslots to use.

Patch #12-#13 adds "multiple-memslots=on" support to virtio-mem

Patch #14-#15 make sure that virtio-mem memslots can be enabled/disable
atomically

[1] https://lkml.kernel.org/r/20211013103330.26869-1-david@redhat.com
[2] https://lkml.kernel.org/r/20230523185915.540373-1-david@redhat.com
[3] https://lkml.kernel.org/r/20230530113838.257755-1-david@redhat.com
[4] https://lkml.kernel.org/r/20230523183036.517957-1-david@redhat.com

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
Cc: kvm@vger.kernel.org

David Hildenbrand (15):
  memory-device: Track the required memslots in DeviceMemoryState
  kvm: Add stub for kvm_get_max_memslots()
  vhost: Add vhost_get_max_memslots()
  memory-device,vhost: Add a memslot soft limit for memory devices
  kvm: Return number of free memslots
  vhost: Return number of free memslots
  memory-device: Support memory devices that statically consume multiple
    memslots
  memory-device: Track the actually used memslots in DeviceMemoryState
  memory-device,vhost: Support memory devices that dynamically consume
    multiple memslots
  pc-dimm: Provide pc_dimm_get_free_slots() to query free ram slots
  memory-device: Support memory-devices with auto-detection of the
    number of memslots
  memory: Clarify mapping requirements for RamDiscardManager
  virtio-mem: Expose device memory via multiple memslots if enabled
  memory,vhost: Allow for marking memory device memory regions
    unmergeable
  virtio-mem: Mark memslot alias memory regions unmergeable

 accel/kvm/kvm-all.c            |  35 +++--
 accel/stubs/kvm-stub.c         |   9 +-
 hw/mem/memory-device.c         | 263 ++++++++++++++++++++++++++++++--
 hw/mem/pc-dimm.c               |  27 ++++
 hw/virtio/vhost-stub.c         |   9 +-
 hw/virtio/vhost.c              |  41 ++++-
 hw/virtio/virtio-mem-pci.c     |  21 +++
 hw/virtio/virtio-mem.c         | 271 ++++++++++++++++++++++++++++++++-
 include/exec/memory.h          |  27 +++-
 include/hw/boards.h            |  10 +-
 include/hw/mem/memory-device.h |  37 +++++
 include/hw/mem/pc-dimm.h       |   1 +
 include/hw/virtio/vhost.h      |   3 +-
 include/hw/virtio/virtio-mem.h |  23 ++-
 include/sysemu/kvm.h           |   4 +-
 include/sysemu/kvm_int.h       |   1 +
 softmmu/memory.c               |  35 ++++-
 stubs/qmp_memory_device.c      |  15 ++
 18 files changed, 777 insertions(+), 55 deletions(-)

-- 
2.40.1

