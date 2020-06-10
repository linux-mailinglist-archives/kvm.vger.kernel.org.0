Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ADB1F53E6
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgFJLyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:54:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728497AbgFJLyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591790083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5GKw6maa7B1hSULtMqvkZqZPAWdNHZFJSoWS3golo7w=;
        b=bK4ZZmHJ3Ngbplf506BdrAIJVRYXRb+zBpAlN81JSNmkC1cqriuYjd4wgpPTu0/mfXVLdu
        HU3sApGx44QHKaDc6ltv+ffa3P4KgRYPUmRNNq4Pp2WHfvQ3/OwJqvPwdKAK5Qg//e4rkp
        VZN27/c8m5SWJIkaISxvWzXsaB3i+x8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-2gkK6RQTM4eSzxW0-G2CwQ-1; Wed, 10 Jun 2020 07:54:40 -0400
X-MC-Unique: 2gkK6RQTM4eSzxW0-G2CwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C6D2800053;
        Wed, 10 Jun 2020 11:54:37 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-42.ams2.redhat.com [10.36.114.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A38615D9D3;
        Wed, 10 Jun 2020 11:54:20 +0000 (UTC)
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
        Alex Shi <alex.shi@linux.alibaba.com>,
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
        Lukas Straub <lukasstraub2@web.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Sergio Lopez <slp@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 00/21] virtio-mem: Paravirtualized memory hot(un)plug
Date:   Wed, 10 Jun 2020 13:53:58 +0200
Message-Id: <20200610115419.51688-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the very basic, initial version of virtio-mem. More info on
virtio-mem in general can be found in the Linux kernel driver v2 posting
[1] and in patch #10. The Linux driver is currently on its way upstream.

This series is based on [3]:
    "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
     buses"
And [4]:
    "[PATCH v2] hmp: Make json format optional for qom-set"

The patches can be found at:
    https://github.com/davidhildenbrand/qemu.git virtio-mem-v4

"The basic idea of virtio-mem is to provide a flexible,
cross-architecture memory hot(un)plug solution that avoids many limitations
imposed by existing technologies, architectures, and interfaces."

There are a lot of addons in the works (esp. protection of unplugged
memory, better hugepage support (esp. when reading unplugged memory),
resizeable memory backends, support for more architectures, ...), this is
the very basic version to get the ball rolling.

The first 8 patches make sure we don't have any sudden surprises e.g., if
somebody tries to pin all memory in RAM blocks, resulting in a higher
memory consumption than desired. The remaining patches add basic virtio-mem
along with support for x86-64. The last patch indicates to the guest OS
the maximum possible PFN using ACPI SRAT, such that Linux can properly
enable the swiotlb when booting only with DMA memory.

[1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
[2] https://lkml.kernel.org/r/20200507140139.17083-1-david@redhat.com
[3] https://lkml.kernel.org/r/20200525084511.51379-1-david@redhat.com
[3] https://lkml.kernel.org/r/20200610075153.33892-1-david@redhat.com

Based-on: <20200525084511.51379-1-david@redhat.com>
Based-on: <20200610075153.33892-1-david@redhat.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

v3 -> v4
- Adapt to virtio-mem config layout change (block size now is 64bit)
- Added "numa: Auto-enable NUMA when any memory devices are possible"

v2 -> v3:
- Rebased on upstream/[3]
- "virtio-mem: Exclude unplugged memory during migration"
-- Added
- "virtio-mem: Paravirtualized memory hot(un)plug"
-- Simplify bitmap operations, find consecutive areas
-- Tweak error messages
-- Reshuffle some checks
-- Minor cleanups
- "accel/kvm: Convert to ram_block_discard_disable()"
- "target/i386: sev: Use ram_block_discard_disable()"
-- Keep asserts clean of functional things

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

David Hildenbrand (21):
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
  virtio-mem: Exclude unplugged memory during migration
  numa: Auto-enable NUMA when any memory devices are possible

 MAINTAINERS                                 |   8 +
 accel/kvm/kvm-all.c                         |   4 +-
 balloon.c                                   |  17 -
 exec.c                                      |  52 ++
 hw/arm/virt.c                               |   2 +
 hw/core/numa.c                              |  17 +-
 hw/i386/Kconfig                             |   1 +
 hw/i386/microvm.c                           |   1 +
 hw/i386/pc.c                                |  50 +-
 hw/i386/pc_piix.c                           |   1 +
 hw/i386/pc_q35.c                            |   1 +
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
 hw/virtio/virtio-mem.c                      | 872 ++++++++++++++++++++
 include/exec/memory.h                       |  41 +
 include/hw/boards.h                         |   1 +
 include/hw/pci/pci.h                        |   1 +
 include/hw/vfio/vfio-common.h               |   4 +-
 include/hw/virtio/virtio-mem.h              |  86 ++
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
 target/i386/sev.c                           |   7 +
 41 files changed, 1730 insertions(+), 126 deletions(-)
 create mode 100644 hw/virtio/virtio-mem-pci.c
 create mode 100644 hw/virtio/virtio-mem-pci.h
 create mode 100644 hw/virtio/virtio-mem.c
 create mode 100644 include/hw/virtio/virtio-mem.h
 create mode 100644 include/standard-headers/linux/virtio_mem.h

-- 
2.26.2

