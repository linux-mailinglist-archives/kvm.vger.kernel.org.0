Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09743C9F0
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbhJ0MsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241974AbhJ0MsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5+XAIdua7MG7o3bhLobabkAcWcpI1CyQ1WeqS4OsnIM=;
        b=I9oJD1OFWDYKYCz356Xl5wZwOARjhe2awVu59OKZFjsB1IifgKMlMTRsDUC4Gfa5BOb3/Q
        jEcG/iM7YS3MoqoJVG8ecQ6FtHO/cD00hFPeiHjvuz4VvgckgzIna/QveJHAx0LShgde/C
        eg8HAscUuQqpx5Gd216vU4iXrjLRjXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-vBf2Vft2PNSEj9o7dFuq5w-1; Wed, 27 Oct 2021 08:45:38 -0400
X-MC-Unique: vBf2Vft2PNSEj9o7dFuq5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 235CB19200C3;
        Wed, 27 Oct 2021 12:45:37 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FE0819724;
        Wed, 27 Oct 2021 12:45:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple memslots
Date:   Wed, 27 Oct 2021 14:45:19 +0200
Message-Id: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the follow-up of [1], dropping auto-detection and vhost-user
changes from the initial RFC.

Based-on: 20211011175346.15499-1-david@redhat.com

A virtio-mem device is represented by a single large RAM memory region
backed by a single large mmap.

Right now, we map that complete memory region into guest physical addres
space, resulting in a very large memory mapping, KVM memory slot, ...
although only a small amount of memory might actually be exposed to the VM.

For example, when starting a VM with a 1 TiB virtio-mem device that only
exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
in order to hotplug more memory later, we waste a lot of memory on metadata
for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
optimizations in KVM are being worked on to reduce this metadata overhead
on x86-64 in some cases, it remains a problem with nested VMs and there are
other reasons why we would want to reduce the total memory slot to a
reasonable minimum.

We want to:
a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
   inside QEMU KVM code where possible.
b) Not always expose all device-memory to the VM, to reduce the attack
   surface of malicious VMs without using userfaultfd.

So instead, expose the RAM memory region not by a single large mapping
(consuming one memslot) but instead by multiple mappings, each consuming
one memslot. To do that, we divide the RAM memory region via aliases into
separate parts and only map the aliases into a device container we actually
need. We have to make sure that QEMU won't silently merge the memory
sections corresponding to the aliases (and thereby also memslots),
otherwise we lose atomic updates with KVM and vhost-user, which we deeply
care about when adding/removing memory. Further, to get memslot accounting
right, such merging is better avoided.

Within the memslots, virtio-mem can (un)plug memory in smaller granularity
dynamically. So memslots are a pure optimization to tackle a) and b) above.

The user configures how many memslots a virtio-mem device should use, the
default is "1" -- essentially corresponding to the old behavior.

Memslots are right now mapped once they fall into the usable device region
(which grows/shrinks on demand right now either when requesting to
 hotplug more memory or during/after reboots). In the future, with
VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to (un)map aliases even
more dynamically when (un)plugging device blocks.


Adding a 500GiB virtio-mem device with "memslots=500" and not hotplugging
any memory results in:
    0000000140000000-000001047fffffff (prio 0, i/o): device-memory
      0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots

Requesting the VM to consume 2 GiB results in (note: the usable region size
is bigger than 2 GiB, so 3 * 1 GiB memslots are required):
    0000000140000000-000001047fffffff (prio 0, i/o): device-memory
      0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
        0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
        0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
        00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff

Requesting the VM to consume 20 GiB results in:
    0000000140000000-000001047fffffff (prio 0, i/o): device-memory
      0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
        0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
        0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
        00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff
        0000000200000000-000000023fffffff (prio 0, ram): alias virtio-mem-memslot-3 @mem0 00000000c0000000-00000000ffffffff
        0000000240000000-000000027fffffff (prio 0, ram): alias virtio-mem-memslot-4 @mem0 0000000100000000-000000013fffffff
        0000000280000000-00000002bfffffff (prio 0, ram): alias virtio-mem-memslot-5 @mem0 0000000140000000-000000017fffffff
        00000002c0000000-00000002ffffffff (prio 0, ram): alias virtio-mem-memslot-6 @mem0 0000000180000000-00000001bfffffff
        0000000300000000-000000033fffffff (prio 0, ram): alias virtio-mem-memslot-7 @mem0 00000001c0000000-00000001ffffffff
        0000000340000000-000000037fffffff (prio 0, ram): alias virtio-mem-memslot-8 @mem0 0000000200000000-000000023fffffff
        0000000380000000-00000003bfffffff (prio 0, ram): alias virtio-mem-memslot-9 @mem0 0000000240000000-000000027fffffff
        00000003c0000000-00000003ffffffff (prio 0, ram): alias virtio-mem-memslot-10 @mem0 0000000280000000-00000002bfffffff
        0000000400000000-000000043fffffff (prio 0, ram): alias virtio-mem-memslot-11 @mem0 00000002c0000000-00000002ffffffff
        0000000440000000-000000047fffffff (prio 0, ram): alias virtio-mem-memslot-12 @mem0 0000000300000000-000000033fffffff
        0000000480000000-00000004bfffffff (prio 0, ram): alias virtio-mem-memslot-13 @mem0 0000000340000000-000000037fffffff
        00000004c0000000-00000004ffffffff (prio 0, ram): alias virtio-mem-memslot-14 @mem0 0000000380000000-00000003bfffffff
        0000000500000000-000000053fffffff (prio 0, ram): alias virtio-mem-memslot-15 @mem0 00000003c0000000-00000003ffffffff
        0000000540000000-000000057fffffff (prio 0, ram): alias virtio-mem-memslot-16 @mem0 0000000400000000-000000043fffffff
        0000000580000000-00000005bfffffff (prio 0, ram): alias virtio-mem-memslot-17 @mem0 0000000440000000-000000047fffffff
        00000005c0000000-00000005ffffffff (prio 0, ram): alias virtio-mem-memslot-18 @mem0 0000000480000000-00000004bfffffff
        0000000600000000-000000063fffffff (prio 0, ram): alias virtio-mem-memslot-19 @mem0 00000004c0000000-00000004ffffffff
        0000000640000000-000000067fffffff (prio 0, ram): alias virtio-mem-memslot-20 @mem0 0000000500000000-000000053fffffff

Requesting the VM to consume 5 GiB and rebooting (note: usable region size
will change during reboots) results in:
    0000000140000000-000001047fffffff (prio 0, i/o): device-memory
      0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
        0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
        0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
        00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff
        0000000200000000-000000023fffffff (prio 0, ram): alias virtio-mem-memslot-3 @mem0 00000000c0000000-00000000ffffffff
        0000000240000000-000000027fffffff (prio 0, ram): alias virtio-mem-memslot-4 @mem0 0000000100000000-000000013fffffff
        0000000280000000-00000002bfffffff (prio 0, ram): alias virtio-mem-memslot-5 @mem0 0000000140000000-000000017fffffff


In addition to other factors (e.g., device block size), we limit the number
of memslots to 1024 per devices and the size of one memslot to at least
128 MiB. Further, we make sure internally to align the memslot size to at
least 128 MiB. For now, we limit the total number of memslots that can
be used by memory devices to 2048, to no go crazy on individual RAM
mappings in our address spaces.

Future work:
- vhost-user and libvhost-user/vhost-user-backend changes to support more than
  32 memslots.
- "memslots=0" mode to allow for auto-determining the number of memslots to
  use.
- Eventually have an interface to query the memslot limit for a QEMU
  instance. But vhost-* devices complicate that matter.

RCF -> v1:
- Dropped "max-memslots=" parameter and converted to "memslots=" parameter
- Dropped auto-determining the number of memslots to use
- Dropped vhost* memslot changes
- Improved error messages regarding memory slot limits
- Reshuffled, cleaned up patches, rewrote patch descriptions

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Ani Sinha <ani@anisinha.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Philippe Mathieu-Daudé <f4bug@amsat.org>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: kvm@vger.kernel.org

[1] https://lkml.kernel.org/r/20211013103330.26869-1-david@redhat.com

David Hildenbrand (12):
  kvm: Return number of free memslots
  vhost: Return number of free memslots
  memory: Allow for marking memory region aliases unmergeable
  vhost: Don't merge unmergeable memory sections
  memory-device: Move memory_device_check_addable() directly into
    memory_device_pre_plug()
  memory-device: Generalize memory_device_used_region_size()
  memory-device: Support memory devices that dynamically consume
    multiple memslots
  vhost: Respect reserved memslots for memory devices when realizing a
    vhost device
  memory: Drop mapping check from
    memory_region_get_ram_discard_manager()
  virtio-mem: Fix typo in virito_mem_intersect_memory_section() function
    name
  virtio-mem: Set the RamDiscardManager for the RAM memory region
    earlier
  virtio-mem: Expose device memory via multiple memslots

 accel/kvm/kvm-all.c            |  24 ++--
 accel/stubs/kvm-stub.c         |   4 +-
 hw/mem/memory-device.c         | 115 ++++++++++++++----
 hw/virtio/vhost-stub.c         |   2 +-
 hw/virtio/vhost.c              |  21 ++--
 hw/virtio/virtio-mem-pci.c     |  23 ++++
 hw/virtio/virtio-mem.c         | 212 +++++++++++++++++++++++++++++----
 include/exec/memory.h          |  23 ++++
 include/hw/mem/memory-device.h |  33 +++++
 include/hw/virtio/vhost.h      |   2 +-
 include/hw/virtio/virtio-mem.h |  25 +++-
 include/sysemu/kvm.h           |   2 +-
 softmmu/memory.c               |  35 ++++--
 stubs/qmp_memory_device.c      |   5 +
 14 files changed, 449 insertions(+), 77 deletions(-)

-- 
2.31.1

