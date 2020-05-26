Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12761DB33C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgETMcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37454 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETMcP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 08:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vL+qjecBZP5AC3zOCUzsS8QgtP22+S85mI62PeHV/qk=;
        b=a04jdOBzMpSzmy2dO6oAbjM9+rE0DoVvi4po1K35o/imEwhaGv+fkEsPhoHIrgb65ysygm
        lnNbRqkJJeqjnL3epNN1BOBVSANI15GMIEQmAY67d0ljx8/vUVM5tgw1uFLofxufkc60dH
        ZyH98iPWCBFX8SYbVkFoYWXhUofoctU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-MZxo64u-MJGFGd615jCGwg-1; Wed, 20 May 2020 08:32:10 -0400
X-MC-Unique: MZxo64u-MJGFGd615jCGwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 018B08014D7;
        Wed, 20 May 2020 12:32:08 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 726B062B10;
        Wed, 20 May 2020 12:31:53 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 00/19] virtio-mem: Paravirtualized memory hot(un)plug
Date:   Wed, 20 May 2020 14:31:33 +0200
Message-Id: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the very basic, initial version of virtio-mem. More info on
virtio-mem in general can be found in the Linux kernel driver posting [1]
and in patch #10.

The patches can be found at:
https://github.com/davidhildenbrand/qemu.git virtio-mem-v2

"The basic idea of virtio-mem is to provide a flexible,
cross-architecture memory hot(un)plug solution that avoids many limitations
imposed by existing technologies, architectures, and interfaces."

There are a lot of addons in the works (esp. protection of unplugged
memory, better hugepage support (esp. when reading unplugged memory),
resizeable memory backends, migration optimizations, support for more
architectures, ...), this is the very basic version to get the ball
rolling.

The first 8 patches make sure we don't have any sudden surprises e.g., if
somebody tries to pin all memory in RAM blocks, resulting in a higher
memory consumption than desired. The remaining patches add basic virtio-mem
along with support for x86-64.

[1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com

Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

v1 -> v2:
- Rebased to object_property_*() changes
- "exec: Introduce ram_block_discard_(disable|require)()"
-- Change the function names and rephrase/add comments
- "virtio-balloon: Rip out qemu_balloon_inhibit()"
-- Add and use "migration_in_incoming_postcopy()"
- "migration/rdma: Use ram_block_discard_disable()"
-- Add a comment regarding pin_all vs. !pin_all
- "virtio-mem: Paravirtualized memory hot(un)plug"
-- Replace virtio_mem_discard_inhibited() by
   migration_in_incoming_postcopy()
-- Drop some asserts
-- Drop virtio_mem_bad_request(), use virtio_error() directly, printing
   more information
-- Replace "Note: Discarding should never fail ..." comments by
   error_report()
-- Replace virtio_stw_p() by cpu_to_le16()
-- Drop migration_addr and migration_block_size
-- Minor cleanups
- "linux-headers: update to contain virtio-mem"
-- Updated to latest v4 in Linux
- General changes
-- Fixup the users of the renamed ram_block_discard_(disable|require)
-- Use "X: cannot disable RAM discard"-styled error messages
- Added
-- "virtio-mem: Migration sanity checks"
-- "virtio-mem: Add trace events"

David Hildenbrand (19):
  exec: Introduce ram_block_discard_(disable|require)()
  vfio: Convert to ram_block_discard_disable()
  accel/kvm: Convert to ram_block_discard_disable()
  s390x/pv: Convert to ram_block_discard_disable()
  virtio-balloon: Rip out qemu_balloon_inhibit()
  target/i386: sev: Use ram_block_discard_disable()
  migration/rdma: Use ram_block_discard_disable()
  migration/colo: Use ram_block_discard_disable()
  linux-headers: update to contain virtio-mem
  virtio-mem: Paravirtualized memory hot(un)plug
  virtio-pci: Proxy for virtio-mem
  MAINTAINERS: Add myself as virtio-mem maintainer
  hmp: Handle virtio-mem when printing memory device info
  numa: Handle virtio-mem in NUMA stats
  pc: Support for virtio-mem-pci
  virtio-mem: Allow notifiers for size changes
  virtio-pci: Send qapi events when the virtio-mem size changes
  virtio-mem: Migration sanity checks
  virtio-mem: Add trace events

 MAINTAINERS                                 |   8 +
 accel/kvm/kvm-all.c                         |   3 +-
 balloon.c                                   |  17 -
 exec.c                                      |  52 ++
 hw/core/numa.c                              |   6 +
 hw/i386/Kconfig                             |   1 +
 hw/i386/pc.c                                |  49 +-
 hw/s390x/s390-virtio-ccw.c                  |  22 +-
 hw/vfio/ap.c                                |  10 +-
 hw/vfio/ccw.c                               |  11 +-
 hw/vfio/common.c                            |  53 +-
 hw/vfio/pci.c                               |   6 +-
 hw/virtio/Kconfig                           |  11 +
 hw/virtio/Makefile.objs                     |   2 +
 hw/virtio/trace-events                      |  10 +
 hw/virtio/virtio-balloon.c                  |   8 +-
 hw/virtio/virtio-mem-pci.c                  | 157 ++++
 hw/virtio/virtio-mem-pci.h                  |  34 +
 hw/virtio/virtio-mem.c                      | 816 ++++++++++++++++++++
 include/exec/memory.h                       |  41 +
 include/hw/pci/pci.h                        |   1 +
 include/hw/vfio/vfio-common.h               |   4 +-
 include/hw/virtio/virtio-mem.h              |  83 ++
 include/migration/colo.h                    |   2 +-
 include/migration/misc.h                    |   2 +
 include/standard-headers/linux/virtio_ids.h |   1 +
 include/standard-headers/linux/virtio_mem.h | 211 +++++
 include/sysemu/balloon.h                    |   2 -
 migration/migration.c                       |  15 +-
 migration/postcopy-ram.c                    |  23 -
 migration/rdma.c                            |  18 +-
 migration/savevm.c                          |  11 +-
 monitor/hmp-cmds.c                          |  16 +
 monitor/monitor.c                           |   1 +
 qapi/misc.json                              |  64 +-
 target/i386/sev.c                           |   1 +
 36 files changed, 1651 insertions(+), 121 deletions(-)
 create mode 100644 hw/virtio/virtio-mem-pci.c
 create mode 100644 hw/virtio/virtio-mem-pci.h
 create mode 100644 hw/virtio/virtio-mem.c
 create mode 100644 include/hw/virtio/virtio-mem.h
 create mode 100644 include/standard-headers/linux/virtio_mem.h

-- 
2.25.4

