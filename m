Return-Path: <kvm+bounces-2926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDA67FF1C5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2CBA28209E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6103251032;
	Thu, 30 Nov 2023 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TvCI2TKI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173C393
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354635; x=1732890635;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dbkW+mzg7wi+t2zOtELgoOvpG3MhaJxxgWBJ/5CG6Iw=;
  b=TvCI2TKI5RY97q2DCu5mVy/e+LufeuVPbR+LEsT7hfvlgwxbRJnlT+3P
   8jcIpYhq+u3tBQv2Wfs29jbWVaNtNSiSrcGX8lhUuPkjPWSkEAojvzxOv
   IYs475MhKHZEllN/d2WFizxGpZh+8Ypl7r4Ho5+0GDX7uFTxwAmyAho2n
   xQKEVnnIMc3FPHcgqfspQ08Pnnpa9nNF8tOjmpeRfa0EzJltxLJ95n5Qk
   NshbyMoQvVfpp5eP8iMZ62nFt5cl1m7IU5LYc4PMvVen3gFMuN098SPJE
   LHx7soqSNHg3JBWDiVgRmyPT5CRElodv8yuDeXtZvliUHFedYLwSSx0Ta
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479530811"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479530811"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729586"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729586"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:30:23 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 00/41] qom-topo: Abstract Everything about CPU Topology
Date: Thu, 30 Nov 2023 22:41:22 +0800
Message-Id: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Hi list,

This series is our latest attempt after the previous RFC [1] about
hybrid topology support, which is based on the commit 4705fc0c8511
("Merge tag 'pull-for-8.2-fixes-231123-1' of https://gitlab.com/
stsquad/qemu into staging") with our previous cleanup (patches link:
https://lore.kernel.org/all/20231127145611.925817-1-zhao1.liu@linux.intel.com/).

In the previous RFC, Daniel suggested [2] us to use the modern QOM
approach to define CPU topology, and based on this way, defining hybrid
topology through cli is natural. (Thanks Daniel!)

About why we chose -device other than -object, please see the chapter.3
"History of QOM Topology".

In fact, S390x already implements heterogeneity at the CPU level with
QOM CPUs, i.e., different CPUs have different entitlements [3]. However,
for more thorough heterogeneity, i.e., heterogeneous cores, clusters,
dies, caches and even more, we still need to go farther in the QOM
direction.

With these background, we propose this series to implement QOM "smp"
topology in QEMU, and it's also the first step towards the heterogeneous
topology (including CPU & cache topology) for virtualization case.

The overall goal is to both use QOM "smp" topology to be compatible with
current -smp behavior, and to take into account different architectural
setups/requirements for CPU topology (even including different designs
for CPU hotplug and possible_cpus[] implementation), and ultimately to
extend QEMU's ability to define CPU topology via -device even without
-smp.

The current remining issue, mainly related to PPC, as it chose to build
the pssible_cpus[] list at core granularity. Please see chapter.5 "Open
Questions" for more thoughts on this issue.

For other architectures that build possible_cpus[] at CPU granularity,
the transition to QOM topology will be similar to what was done for i386
in this patchset (please feel free to point out any issues I've missed).

There's a lot of work, and the devil is in the details.


Welcome your feedbacks!


1. Summary about What We Did?
=============================

This series implements the basics of QOM topology and supports QOM
topology for the i386 as the example:

* Introduce the general topology device and abstract all CPU topology
  levels to topology devices:

    - including "cpu", "cpu-core", "cpu-cluster", "cpu-die",
      "cpu-socket", "cpu-book", "cpu-drawer", and a special topology
      root "cpu-slot" to manage topology tree.

* Allow user to create "smp" CPU topology via "-device", for example:

    The topology with 8 CPUs:

    -accel kvm -cpu host \
    -device cpu-socket,id=sock0 \
    -device cpu-die,id=die0,parent=sock0 \
    -device cpu-core,id=core0,parent=die0,nr-threads=2 \
    -device cpu-core,id=core1,parent=die0,nr-threads=2,plugged-threads=1 \
    -device cpu-core,id=core2,parent=die0,nr-threads=2,plugged-threads=2 \
    -device cpu-core,id=core3,parent=die0,nr-threads=2 \
    -device host-x86_64-cpu,socket-id=0,die-id=0,core-id=1,thread-id=1 \

* Build a topology tree under machine, for example:

    One of the above CPUs:

    {
        "props": {
            "core-id": 0,
            "socket-id": 0,
            "thread-id": 0
        },
        "qom-path": "/machine/peripheral/cpu-slot/sock0/die0/core0/host-x86_64-cpu[0]",
        "type": "host-x86_64-cpu",
        "vcpus-count": 1
    }

* Convert topology information configured via -smp into a QOM "smp"
  topology tree (if the arch supports QOM topology).


2. What's the Problem?
======================

As computer architectures continue to innovate, the need for
heterogeneous topology of virtual machine in QEMU is growing.

On the one hand, there is the need for heterogeneous CPU topology
support. Heterogeneous CPU topology refers to systems that use more than
one kind of processor or cores [4], the typical example is intel hybrid
architecture with 2 core types [5], which will even have heterogeneous
die topology [6]. And we can see that not only Intel, but also ARM and
AMD's heterogeneous platforms will have the ability to support
virtualization.

On the other hand, there is also a growing need for heterogeneous cache
topology in QEMU. Not only will Intel's hybrid platforms introduce
complex heterogeneous cache topology, but more platforms have aslo seen
the strong demand for heterogeneous cache topology definition (e.g. ARM
[7]). Although cache topology is strictly speaking a separate topology
from CPU topology, in terms of the actual processor build process and
the current QEMU's way to define cache topology (e.g., i386 [8] & ARM
[9]), cache topology is and should be dependent on CPU topology to be
defined.

With this background of increasing interest in heterogeneous computing,
we need a flexible way (for accel) to define a wide variety of CPU
topologies in QEMU.

Obviously, -smp is not enough, so here we propose a way to define CPU
topology based on -device, in the hope that this will greatly expand the
flexibility of QEMU's CPU topology definition.


3. History of QOM Topology
==========================

The intent of QOM topology is not to stop at QOM CPUs, but to abstract
more CPU topology levels.

In fact, it's not a new term.

Back in 2014, Fan proposed [10] a hierarchical tree based on QOM node,
QOM sockets, QOM cores and QOM cpu. Andreas also propsed [11] socket/
core/thread QOM model to create hierarchical topology in place. From
the discussion at that time, the hierarchy topology tree representation
was what people (Igor said [12]) wanted. However, this work was not
continued.

Then Bharata abstracted [13] the cpu-core to support core granularity
hotplug in spapr. Until now, the only user of cpu-core is still spapr.

Cpu-cluster was introduced by Luc [14] to organize CPUs in different
containers to support GDB for TCG case. Though this abstraction was
descripted as: "mainly an internal QEMU representation and does not
necessarily match with the notion of clusters on the real hardware",
its name and function actually make it easy to correspond to the
physical cluster/smp cluster (the difference, of course, is that TCG
cluster collects CPUs directly, while the cluster as a CPU topology
level collect cores, but this difference is not the impediment gap to
converting "TCG " cluster to "general" cluster).

As CPU architectures evolve, QEMU has supported more topology levels
(clusters, die, book and drawer) for virtualization case, while the
existing cpu-core and cpu-cluster abstractions become fragmented.

And now, the need for defining hybrid topology has prompted us to
rethink the QOM topology.

Daniel suggested [2] to use -object interfaces to define CPU topology,
and we absorbed his design idea. But in practice we found that -device
looked like a better approach to take advantage of the current QOM CPU
device, cpu-core device and cpu-cluster device.


4. Design Overview
==================

4.1. General Topology Device
============================

We introduce a new topology device as the basic abstraction, then all
levels of the CPU topology are derived from this general topology device
type.

This topology device is the basic unit for building the topology tree.
Children topology devices are inserted into the queue of the parent, and
the child<> property is created between the children and their parent.

As the root of the topology tree, we introduce a special topology device
"cpu-slot". It is created by the machine at machine's initialization and
collects the topology devices created by the user from the cli, and thus
builds the topology tree.

The cpu-slot is also responsible for statistics on global topology
information, and whenever there is a new topology child, the cpu-slot as
root is notified to update topology informantion. In addition, different
architectures have different requirements for topology (e.g., support
for different levels), and such limitations/properties are applied to
cpu-slot, which is checked when adding the new child topology unit in
topology tree.


4.2. Derived QOM Topology Devices
=================================

Based on the new general topology device type, we convert CPU, cpu-core
and cpu-cluster from general devices to topology devices.

And we also abstract cpu-die, cpu-socket, cpu-book and cpu-drawer as
topology devices.


4.3. New Device Category "DEVICE_CATEGORY_CPU_DEF"
==================================================

The topology devices can be divided into two general categories:

* One, as the basic topology components, should be created before board
  initialization, to predefine the basic topology structure for the
  system, and is used to initialize MachineState.possible_cpus at
  machine's initialization. This category doesn't support hotplug, such
  as:

    cpu-core (non-PPC core), cpu-cluster, cpu-die, cpu-socket, cpu-book
    and cpu-drawer.

  Thus, we introduce the new device category "DEVICE_CATEGORY_CPU_DEF"
  to mark these devices and create them from cli before board
  initialization.

* The other are CPU and PPC core, which are the granularity of
  MachineState.possible_cpus.

  They're created from MachineState.possible_cpus in place during
  machine initialization or are plugged into MachineState.possible_cpus
  through hotplug way.

  For these devices, they could be created from cli only after board
  initialization.


4.4. User-child Interface to Build Child<> from Cli
===================================================

Topology device is bus-less device, and needs child<> to build topology
hierarchical relationship like:

/machine/peripheral/cpu-slot/sock*/die*/core*/cpu*

Therefore, we introduce a new user-child interface to insert hooks into
device_add path to get/specify object parent for topology devices.

If a topology device specify "parent" option in -device, it will be add
to the corresponding topology parent with child<> property.

If no "parent" option, the topology device will have the default parent
"cpu-slot". This ensures cpu-slot could collect all topology units to
build complete topology tree.


5. Open Questions
=================

There's a special case, user could define topology via -device without
-smp (that's the future hybrid topology case!).

In the design of current QOM topology, the numbers of maximum CPUs and
pre plugged CPUs could be collected during core devices realize.

For the (non-PPC) architectures which build possible_cpus[] at CPU
granularity, the cores will be created before possible_cpus[]
initialization and then CPU slot could know how many maximum CPUs will
be supported to fill possible_cpus[].

But for PPC, the possible_cpus[] is at core granularity and PPC core
could only be created after possible_cpus[] initialization, so that
CPU slot cannot know the the numbers of maximum CPUs (PPC cores) and pre
plugged CPUs (PPC cores). So for PPC, the "-smp" is necessary and cannot
be omitted.

For PPC this potential impact, i.e., even though QOM topology is
supported in PPC, it is not possible to omit -smp to create the topology
only via -device as for i386, and since PPC does not currently support
heterogeneous topology, this potential impact might be acceptable?


6. Future TODOs
===============

The current QOM topology RFC is only the very first step to introduce
the most basic QOM support, and it tries to be as compatible as possible
with existing SMP facilities.

The ultimate goal is to completely replace the current smp-related
topology structures with cpu-slot.

There are many TODOs:

* Add unit tests.
* Support QOM topology for all architectures.
* Get rid of MachineState.smp and MachineClass.smp_props with cpu-slot.
* Extend QOM topology to hybrid topology.
* Introduce "-device-set" which is derived from Daniel's "-object-set"
  idea [2] to create multiple duplicate devices.
...


7. Patch Summary
================

Patch  1- 3: Create DEVICE_CATEGORY_CPU_DEF devices before board
             initialization.
Patch  4- 7: Support child<> creation from cli.
Ptach  8-12: Introduce general topology device.
Patch 13-26: Abstract all topology levels to topology devices.
Patch 27-34: Introduce cpu-slot to manage the CPU topology of machine.
Patch 35-41: Convert i386's CPU creation & hotplug to be based on QOM
             topology.


8. Reference
============

[1]:  Hybrid topology RFC:
      https://mail.gnu.org/archive/html/qemu-devel/2023-02/msg03205.html
[2]:  Daniel's suggestion about QOM topology:
      https://mail.gnu.org/archive/html/qemu-devel/2023-02/msg03320.html
[3]:  S390x topology document (by Nina):
      https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg04842.html
[4]:  Heterogeneous computing:
      https://en.wikipedia.org/wiki/Heterogeneous_computing
[5]:  12th gen’s Intel hybrid technology:
      https://www.intel.com/content/www/us/en/support/articles/000091896/processors.html
[6]:  Intel Meteor Lake (14th gen) architecture overview:
      https://www.intel.com/content/www/us/en/content-details/788851/meteor-lake-architecture-overview.html
[7]:  Need of ARM heterogeneous cache topology (by Yanan):
      https://mail.gnu.org/archive/html/qemu-devel/2023-02/msg05139.html
[8]:  Cache topology implementation for i386:
      https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg08251.html
[9]:  Cluster for ARM to define shared L2 cache and L3 tag (by Yanan):
      https://lore.kernel.org/all/20211228092221.21068-1-wangyanan55@huawei.com/
[10]: [PATCH v1 0/4] prebuild cpu QOM tree /machine/node/socket/core
      ->link-cpu (by Fan):
      https://lore.kernel.org/all/cover.1395217538.git.chen.fan.fnst@cn.fujitsu.com/
[11]: [PATCH RFC 0/4] target-i386: PC socket/core/thread modeling,
      part 1 (by Andreas):
      https://lore.kernel.org/all/1427131923-4670-1-git-send-email-afaerber@suse.de/
[12]: "Now we want to have similar QOM tree for introspection which
      helps express topology as well" (by Igor):
      https://lore.kernel.org/all/20150407170734.51faac90@igors-macbook-pro.local/
[13]: [for-2.7 PATCH v3 06/15] cpu: Abstract CPU core type (by Bharata)
      https://lore.kernel.org/all/1463024905-28401-7-git-send-email-bharata@linux.vnet.ibm.com/
[14]: [PATCH v8 01/16] hw/cpu: introduce CPU clusters (by Luc):
      https://lore.kernel.org/all/20181207090135.7651-2-luc.michel@greensocs.com/

Thanks and Best Regards,
Zhao

---
Zhao Liu (41):
  qdev: Introduce new device category to cover basic topology device
  qdev: Allow qdev_device_add() to add specific category device
  system: Create base category devices from cli before board
    initialization
  qom/object: Introduce helper to resolve path from non-direct parent
  qdev: Set device parent and id after setting properties
  qdev: Introduce user-child interface to collect devices from -device
  qdev: Introduce parent option in -device
  hw/core/topo: Introduce CPU topology device abstraction
  hw/core/topo: Support topology index for topology device
  hw/core/topo: Add virtual method to update topology info for parent
  hw/core/topo: Add virtual method to check topology child
  hw/core/topo: Add helpers to traverse the CPU topology tree
  hw/core/cpu: Convert CPU from general device to topology device
  PPC/ppc-core: Offload core-id to PPC specific core abstarction
  hw/cpu/core: Allow to configure plugged threads for cpu-core
  PPC/ppc-core: Limit plugged-threads and nr-threads to be equal
  hw/cpu/core: Convert cpu-core from general device to topology device
  hw/cpu/cluster: Rename CPUClusterState to CPUCluster
  hw/cpu/cluster: Wrap TCG related ops and props into CONFIG_TCG
  hw/cpu/cluster: Descript cluster is not only used for TCG in comment
  hw/cpu/cluster: Allow cpu-cluster to be created by -device
  hw/cpu/cluster: Convert cpu-cluster from general device to topology
    device
  hw/cpu/die: Abstract cpu-die level as topology device
  hw/cpu/socket: Abstract cpu-socket level as topology device
  hw/cpu/book: Abstract cpu-book level as topology device
  hw/cpu/drawer: Abstract cpu-drawer level as topology device
  hw/core/slot: Introduce CPU slot as the root of CPU topology
  hw/core/slot: Maintain the core queue in CPU slot
  hw/core/slot: Statistics topology information in CPU slot
  hw/core/slot: Check topology child to be added under CPU slot
  hw/machine: Plug cpu-slot into machine to maintain topology tree
  hw/machine: Build smp topology tree from -smp
  hw/machine: Validate smp topology tree without -smp
  hw/core/topo: Implement user-child to collect topology device from cli
  hw/i386: Make x86_cpu_new() private in x86.c
  hw/i386: Allow x86_cpu_new() to specify parent for new CPU
  hw/i386: Allow i386 to create new CPUs from QOM topology
  hw/i386: Wrap apic id and topology sub ids assigning as helpers
  hw/i386: Add the interface to search parent for QOM topology
  hw/i386: Support QOM topology
  hw/i386: Cleanup non-QOM topology support

 MAINTAINERS                        |  16 +
 accel/kvm/kvm-all.c                |   4 +-
 gdbstub/system.c                   |   2 +-
 hw/core/cpu-common.c               |  25 +-
 hw/core/cpu-slot.c                 | 605 +++++++++++++++++++++++++++++
 hw/core/cpu-topo.c                 | 399 +++++++++++++++++++
 hw/core/machine-smp.c              |   9 +
 hw/core/machine.c                  |  10 +
 hw/core/meson.build                |   2 +
 hw/cpu/book.c                      |  46 +++
 hw/cpu/cluster.c                   |  50 ++-
 hw/cpu/core.c                      |  72 ++--
 hw/cpu/die.c                       |  46 +++
 hw/cpu/drawer.c                    |  46 +++
 hw/cpu/meson.build                 |   2 +-
 hw/cpu/socket.c                    |  46 +++
 hw/i386/x86.c                      | 319 ++++++++++-----
 hw/net/virtio-net.c                |   2 +-
 hw/ppc/meson.build                 |   1 +
 hw/ppc/pnv.c                       |   6 +-
 hw/ppc/pnv_core.c                  |  17 +-
 hw/ppc/ppc_core.c                  | 102 +++++
 hw/ppc/spapr.c                     |  28 +-
 hw/ppc/spapr_cpu_core.c            |  19 +-
 hw/usb/xen-usb.c                   |   3 +-
 hw/xen/xen-legacy-backend.c        |   2 +-
 include/hw/arm/armsse.h            |   2 +-
 include/hw/arm/xlnx-versal.h       |   4 +-
 include/hw/arm/xlnx-zynqmp.h       |   4 +-
 include/hw/boards.h                |  13 +
 include/hw/core/cpu-slot.h         | 108 +++++
 include/hw/core/cpu-topo.h         | 111 ++++++
 include/hw/core/cpu.h              |   8 +-
 include/hw/cpu/book.h              |  38 ++
 include/hw/cpu/cluster.h           |  51 ++-
 include/hw/cpu/core.h              |  26 +-
 include/hw/cpu/die.h               |  38 ++
 include/hw/cpu/drawer.h            |  38 ++
 include/hw/cpu/socket.h            |  38 ++
 include/hw/i386/x86.h              |   5 +-
 include/hw/ppc/pnv_core.h          |  11 +-
 include/hw/ppc/ppc_core.h          |  58 +++
 include/hw/ppc/spapr_cpu_core.h    |  12 +-
 include/hw/qdev-core.h             |   1 +
 include/hw/riscv/microchip_pfsoc.h |   4 +-
 include/hw/riscv/sifive_u.h        |   4 +-
 include/monitor/qdev.h             |   7 +-
 include/monitor/user-child.h       |  57 +++
 include/qom/object.h               |  26 ++
 qom/object.c                       |  31 ++
 system/meson.build                 |   1 +
 system/qdev-monitor.c              | 141 ++++++-
 system/user-child.c                |  72 ++++
 system/vl.c                        |  53 ++-
 target/i386/cpu.c                  |   4 +
 tests/unit/meson.build             |   5 +-
 56 files changed, 2607 insertions(+), 243 deletions(-)
 create mode 100644 hw/core/cpu-slot.c
 create mode 100644 hw/core/cpu-topo.c
 create mode 100644 hw/cpu/book.c
 create mode 100644 hw/cpu/die.c
 create mode 100644 hw/cpu/drawer.c
 create mode 100644 hw/cpu/socket.c
 create mode 100644 hw/ppc/ppc_core.c
 create mode 100644 include/hw/core/cpu-slot.h
 create mode 100644 include/hw/core/cpu-topo.h
 create mode 100644 include/hw/cpu/book.h
 create mode 100644 include/hw/cpu/die.h
 create mode 100644 include/hw/cpu/drawer.h
 create mode 100644 include/hw/cpu/socket.h
 create mode 100644 include/hw/ppc/ppc_core.h
 create mode 100644 include/monitor/user-child.h
 create mode 100644 system/user-child.c

-- 
2.34.1


