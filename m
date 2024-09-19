Return-Path: <kvm+bounces-27102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 070CA97C280
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B839428546B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8796618E11;
	Thu, 19 Sep 2024 01:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0C8hKyF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BCA12E75
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726709988; cv=none; b=Tifse0NhatiOs8NUaNdObs4J4DA9gjmdERbwqdp9I8qjEpp4PPea0Uz6oYDU/V1/LJ1wyk5b0sXpYAl34mHWaVo6vkI/FV6G9OLa/YA//W8pt+arcHs6vi+rkpknETkdooR7GpjiYyvv4EIP48O5gydLXmAWd8+VW5lX8gvTCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726709988; c=relaxed/simple;
	bh=K7k8zT2pC2Ua/GM9HyO6OV2PCDkPiDON6WM4+oMcQIY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QN5y1y0NpNQrktCrByz75kKESa0D9x/Nze3h/iTPJIfJfCj01BRUQtAN8UUv7JjWryRxC67SaCocuLvarvsIEXZzlzgT61T9fnJe/67cntS2BJ6zJTgaI13uMQIE13F18YcYbTsddAqiqlnTgMSJC/K791dj2gP/iYjOlVwvW/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0C8hKyF; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726709986; x=1758245986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K7k8zT2pC2Ua/GM9HyO6OV2PCDkPiDON6WM4+oMcQIY=;
  b=T0C8hKyFEso6AuGfkFtmkSq+OnyOut++mJP5GtPounvhiuRc4wfiBtE5
   8y1Lrc8f00MJPcHT3tfLvlCd9W625+X1rLyl++G3LN7K99zDD8Rw+rT+v
   FPBY1eCMGFEIARiWPO5NcLXGSKNX/pfF3uNtFEbYOUOqclDZ1gU7aEN4C
   1PwLa+43NwrBlxPmk3Y3Pjt6S8HUVEyhrQL3hUVKFvhpPbznzoQ7dQk3m
   y4MtocBAkzyEzJO3khOL8zWWioigIXBlTTgh2z+UOUYDLeB7pFWmQ6wqH
   0UQbU9NWVQLVq1UBhf5icGp9+/ba7PNUIVHlXu0FYHYYkYECsqZK3DoIR
   g==;
X-CSE-ConnectionGUID: R8sE5I5ISgWN2B0esFfDug==
X-CSE-MsgGUID: 4SKvGWtjTPe7DvT5y+ms+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797792"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797792"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:39:45 -0700
X-CSE-ConnectionGUID: y6jal28nTNeMFfqn5T21WQ==
X-CSE-MsgGUID: ey6y18zkRiG4+rnv5jrt3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058463"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:39:38 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 00/15] qom-topo: Abstract CPU Topology Level to Topology Device
Date: Thu, 19 Sep 2024 09:55:18 +0800
Message-Id: <20240919015533.766754-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

After ten months, now I bring our 2nd attempt on CPU topology device
back to mail list.

This series is still a practical implementation of Daniel’s idea
[0] from early last year on how to achieve hybrid topology based on QOM
abstraction.

And this series is a preliminary step for introducing hybrid (aka,
heterogeneous) CPU topology to QEMU. With the QOM topology support
introduced in this series, for future hybrid CPU topology, QEMU will
allow users to customize the topology tree via CLI using the -device
command.

Compared to v1 [1], the goals of v2 stay the same:
1. Abstract a special class of device - "CPU topology device' - to
   handle CPU topology relationship.
2. Derive all CPU topology related devices, including existing CPU/core
   devices, as well as newly added module/die/socket devices, from "CPU
   topology device".
3. Build a CPU topology device tree based on the topology relationships
   represented by the CPU topology devices.

The main difference between v1 and v2 is that v2 introduces the special
CPU bus to manage topology. The current QEMU Bus abstraction effectively
manages the topology between devices, so applying it to CPU topology can
avoid introducing an additional set of logic to handle topology
relationships. Therefore, compared to v1, the code in v2 can be
significantly reduced. (About why we made this change, pls refer the
last two paragraphs in Section 3. "History of QOM (CPU) Topology".)

In addition, v2 removes the support about user custom topology creation
from CLI. Since this part has more opens, the subsequent hybrid (CPU)
topology v2 will discuss this.

This series make x86 support the topology tree as the example. I also
hope that eventually all architectures and machines in QEMU will accept
QOM topology.

Patches are based on my previous SMP cache topology series [2] (in fact,
I rebase both them at the commit 2b81c046252f ("Merge tag 'block-pull-
request' of https://gitlab.com/stefanha/qemu into staging")).

As ARM may has potential need for hybrid topology, I also add ARM folks
in this thread.

This is a huge cover letter and a huge series, thank you for your
patience and time! And welcome your feedback and comments!


1. Summary about What We Did?
=============================

Before introducing the background, please allow me to briefly outline
the main work of this series. This will help relate it to the
continuous efforts and discussions of the past decade.


* Implement CPU topology device/bus abstraction and topology tree.

This series implements a topology tree for (x86) machine like the
following:

                                        
              ┌────────────────┐        
              │                │        
              │  MachineState  │        
              │                │        
              └───────┬────────┘        
                      │                 
                ┌─────┼─────┐           
                │  CPU Slot │           
                └─────┬─────┘           
                  ┌───┼───┐             
                  │CPU Bus│             
                  └───┬───┘             
                      │                 
                ┌─────▼─────┐           
                │ CPU Socket│           
                └─────┬─────┘           
                  ┌───┼───┐             
                  │CPU Bus│             
                  └───┬───┘             
                      │                 
                ┌─────▼─────┐           
                │  CPU Die  │           
                └─────┬─────┘           
                  ┌───┼───┐             
                  │CPU Bus│             
                  └───┬───┘             
                      │                 
                ┌─────▼─────┐           
                │  CPU Die  │           
                └─────┬─────┘           
                  ┌───┼───┐             
                  │CPU Bus│             
                  └───┬───┘             
               ┌──────┴──────┐          
         ┌─────▼─────┐ ┌─────▼─────┐    
         │ CPU Module│ │ CPU Module│    
         └─────┬─────┘ └─────┬─────┘    
           ┌───┼───┐     ┌───┼───┐      
           │CPU Bus│     │CPU Bus│      
           └───┬───┘     └───┬───┘      
               │             │          
         ┌─────▼─────┐ ┌─────▼─────┐    
         │  CPU Core │ │  CPU Core │    
         └─────┬─────┘ └─────┬─────┘    
           ┌───┼───┐     ┌───┼───┐      
           │CPU Bus│     │CPU Bus│      
           └──┬────┘     └────┬──┘      
          ┌───┴───┐       ┌───┴───┐     
       ┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐  
       │ CPU │ │ CPU │ │ CPU │ │ CPU │  
       └─────┘ └─────┘ └─────┘ └─────┘  
                                        
The Socket/Die/Module/Core/CPU are all the devices derived from CPU
topology device ("CPUTopoState") and are connected through the "CPU
bus", hierarchy by hierarchy.

The root of above topology tree is a CPU bus bridge named "CPU Slot",
which is plugged in MachineState. The CPU Slot is designed to replace
the current MachineState.smp to manage all CPU topologies. It will
listen to the realize() and unrealize() of the CPU topology device
and update the topology information to monitor topology tree updates
and the plug/unplug event of topology devices.


* Based on topology tree, make qom-path match topology relationship.

This is implemented by re-parenting the topology device to its actual
topological parent in the tree. This is an CPU example:

  {
      "props": {
          "core-id": 0,
          "die-id": 0,
          "module-id": 0,
          "socket-id": 0,
          "thread-id": 0
      },
      "qom-path": "/machine/peripheral/cpu-slot/sock0/die0/core0/host-x86_64-cpu[0]",
      "type": "host-x86_64-cpu",
      "vcpus-count": 1
  }


* Introduce "bus-finder" to convert CPU's topology ID properties
  (thread-id/core-id, etc) to specific "CPU bus".

At present, topology ID properties are used to find free slot in
possible_cpus[]. Once there's the CPU bus, it's necessary to use such
properties to locate the proper parent CPU bus when adding the CPU from
CLI. The "bus-finder" is an "INTERFACE" to help qdev search parent bus
with device's properties.


2. What's the Problem?
======================

As computer architectures continue to innovate, the need for hybrid
(aka, heterogeneous) topology of virtual machine in QEMU is growing.

Hybrid topology includes hybrid CPU topology and hybrid cache topology:

- Hybrid CPU topology:

Hybrid CPU topology refers to systems that use more than one kind of
processor or cores [3] with the same ISA. The typical example is intel
hybrid architecture with 2 core types [4], which will even have hybrid
die topology [5]. And we can see that not only Intel, but also ARM and
AMD's heterogeneous platforms will have the ability to support
virtualization.

- Hybrid cache topology:

Not only Intel's hybrid platforms introduced complex hybrid cache
topology, but more platforms have also seen the strong demand for hybrid
cache topology definition (e.g. ARM [6]). Although cache topology is
strictly speaking a separate topology from CPU topology, in terms of the
actual processor build process and the current QEMU's way to define
cache topology (e.g., i386 [7] & ARM [8]), cache topology is and should
be dependent on CPU topology to be defined. Even for the SMP CPU case,
the hyrbid cache topology is also useful to define different caches at
same level (e.g., AMD x3D). The hybrid cache topology will depend on the
implementation of the hybrid CPU topology, which is our future work.


The benefits of introducing hybrid topology for QEMU include:
 * Allow QEMU to emulate complex heterogeneous CPU hardware.
 * Hybrid topology information in Guest can help Guest improve
   performance and achieve better power efficiency based on Host's
   hardware difference.
 * Enable hybrid features in Guest, for example, Intel's hybrid PMU.

Obviously, -smp is not enough. And though QEMU could define different
properties for CPUs (like S390s [9]), it's not enough to handle or
express complicated topology replationship.

Therefore, we're trying to figure out a proper way to define hybrid
topology in QEMU.

This series, implementing QOM (CPU) topology, is the foundation of our
hybrid topology support.


3. History of QOM (CPU) Topology
================================

The intent of QOM topology is not to stop at QOM CPUs, but to abstract
more CPU topology levels.

In fact, it's not a new term.

Back in 2014, Fan proposed [10] a hierarchical tree based on QOM node,
QOM sockets, QOM cores and QOM cpu. Andreas also propsed [11] socket/
core/thread QOM model to create hierarchical topology in place. From
the discussion at that time, the hierarchy topology tree representation
was what people (Igor said [12]) wanted. However, this work was not
continued.

Then Bharata proposed to "CPU group" concept to handle CPU hotplug, but
eventually matintainers accepted the cpu-core abstraction [13] to
support core granularity hotplug for SPAPR. Until now, the only user of
cpu-core is still PPC (PNV core and SPAPR core).

Cpu-cluster was introduced by Luc [14] to organize CPUs in different
containers to support GDB for TCG case. Though this abstraction was
descripted as: "mainly an internal QEMU representation and does not
necessarily match with the notion of clusters on the real hardware",
its name and function actually make it easy to correspond to the
physical cluster/smp cluster (the difference, of course, is that TCG
cluster collects CPUs directly, while the cluster as a CPU topology
level collect cores, but this difference is not the impediment gap to
convert "TCG " cluster to "general" cluster).

As CPU architectures evolve, QEMU has supported more topology levels
(module, cluster, die, book and drawer), while the existing cpu-core
and cpu-cluster abstractions become fragmented.

And now, the need for defining hybrid topology has prompted us to
rethink the QOM topology.

Daniel suggested [0] to use -object interfaces to define CPU topology,
and we absorbed his design idea. But in practice we found that -device
looked like a better approach to take advantage of the current QOM CPU
device, cpu-core device and cpu-cluster device. Therefore, this is this
RFC to enhance CPU topology related devices.

The v1 RFC [1] has implemented the CPU topology device abstraction.
However, the parent topology device and child topology device were not
connected via a bus. Instead, a bus-like topology management mechanism
was implemented separately for topology devices. Additionally, since the
topology device in v1 was busless, adding devices via CLI does not
support child<> connections. v1 faced significant difficulties to
support child<> creation in the CLI.

Therefore, v2 learned from v1’s lessons and directly abstracted the
"virtual" CPU bus (however, strictly speaking, there are prototypes in
reality, such as the interconnect bus/ring bus) to utilize the existing
bus mechanism for topology management. This also reduces the burden for
subsequent hybrid topology series to create the topology tree via CLI.


4. Design Overview
==================

4.1. General CPU Topology Device
================================

We introduce a new topology device type as the basic abstraction, then
all levels of the CPU topology are derived from this general CPU
topology device type.

This topology device is the basic unit for building the topology tree.
Children topology devices are inserted into the queue of the parent, and
the child<> property is created between the children and their parent so
that the qom-path could reflect topology relationship.

At the same time, to manage the topology relationship between parent
device and child device, we introduce CPU bus to utilize existing
device topology management ability of Qbus.

Additionally, as the root of the topology tree, we introduce a special
"cpu-slot". It is created by the machine at machine's initialization and
collects the topology devices created for the machine, and builds the
CPU topology tree.

The cpu-slot is also responsible for statistics on global topology
information, and whenever there is a new topology child, the cpu-slot as
root is notified to update topology informantion. In addition, different
architectures have different requirements for topology (e.g., support
for different levels), and such limitations/properties are applied to
cpu-slot, which is checked when adding the new child topology unit in
topology tree.


4.2. Derived QOM Topology Devices
=================================

Based on the new general topology device type, (currently for x86) we
convert CPU and cpu-core from general devices to topology devices.

And we also abstract cpu-module, cpu-die and cpu-socket as topology
devices for x86's use.


4.3. "bus-finder" Interface to Convert Topology IDs to Topology Bus
===================================================================

Currently CPUs (across arches) use topology IDs to find the free slot
in possible_cpus[].

For x86 CPU, the related properties include "thread-id"/"core-id"/
"module-id"/"die-id"/"socket-id", and "apicid". But actually, APIC ID
is the combanition of topology IDs.

Those topology IDs implicitly maps the CPU to a (non-existent) topology
tree. Now, we have the real topology tree. Then it's natural to use
such topology IDs to search the proper topology parent in the tree.

In particular, when we transform the CPU into a CPU topology device with
the bus_type, then this transformation is necessary to help find the
correct parent bus (on parent topology device).

Therefore, we introduce the "bus-finder" interface, which provides the
hook in qdev_device_add_from_qdict(), allowing arch CPU to use topology
ID properties to find the parent bus.


4.4. Topology Tree building
===========================

At present, possible_cpus[] provides the CPU level (for PPC, core level)
topology.

It's difficult to completely discard possible_cpus[] and build the
topology tree entirely from scratch. 

In v2, we take a compromise: after the -smp parsing is done, machine
creates a topology tree, but only contains the hierarchies from the
highest level up to the level higher than posssible_cpus[]. For x86,
possible_cpus[] contains CPUs, so that the initial topology tree will
have the hierarchies from socket level to core level.

Then when arch machine initialize CPUs,
MachineClass.possible_cpu_arch_ids() will creates CPUs in
possible_cpus[], and the CPU topology abstraction under the CPU device
will insert the created CPUs into the topology tree based on the topology
ID properties, so that a topology tree is completed.


5. Future TODOs
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
...


6. Patch Summary
================

Patch 01-02: Necessary change for qdev to support CPU topology via bus.
Ptach 03-06: Introduce CPU topology device abstraction and CPU slot in
             machine.
Patch 07-09: Abstract all topology levels to topology devices (for x86).
Patch 10-11: Build topology tree for machine.
Patch 12-15: Enable topology tree for x86 machine.


7. Reference
============

[0]:  Daniel's suggestion about QOM topology:
      https://lore.kernel.org/qemu-devel/Y+o9VIV64mjXTcpF@redhat.com/
[1]:  [RFC 00/41] qom-topo: Abstract Everything about CPU Topology
      https://lore.kernel.org/qemu-devel/20231130144203.2307629-1-zhao1.liu@linux.intel.com/
[2]:  [PATCH v2 0/7] Introduce SMP Cache Topology
      https://lore.kernel.org/qemu-devel/20240908125920.1160236-1-zhao1.liu@intel.com/
[3]:  Heterogeneous computing:
      https://en.wikipedia.org/wiki/Heterogeneous_computing
[4]:  12th gen’s Intel hybrid technology:
      https://www.intel.com/content/www/us/en/support/articles/000091896/processors.html
[5]:  Intel Meteor Lake (14th gen) architecture overview:
      https://www.intel.com/content/www/us/en/content-details/788851/meteor-lake-architecture-overview.html
[6]:  Need of ARM heterogeneous cache topology (by Yanan):
      https://mail.gnu.org/archive/html/qemu-devel/2023-02/msg05139.html
[7]:  Cache topology implementation for i386:
      https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg08251.html
[8]:  Cluster for ARM to define shared L2 cache and L3 tag (by Yanan):
      https://lore.kernel.org/all/20211228092221.21068-1-wangyanan55@huawei.com/
[9]:  S390x topology document (by Nina):
      https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg04842.html
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
Zhao Liu (15):
  qdev: Add pointer to BusChild in DeviceState
  qdev: Add the interface to reparent the device
  hw/cpu: Introduce CPU topology device and CPU bus
  hw/cpu: Introduce CPU slot to manage CPU topology
  qdev: Add method in BusClass to customize device index
  hw/core: Create CPU slot in MachineState to manage CPU topology tree
  hw/core/cpu: Convert CPU from general device to topology device
  hw/cpu/core: Convert cpu-core from general device to topology device
  hw/cpu: Abstract module/die/socket levels as topology devices
  hw/machine: Build smp topology tree from -smp
  hw/core: Support topology tree in none machine for compatibility
  hw/i386: Allow i386 to create new CPUs in topology tree
  system/qdev-monitor: Introduce bus-finder interface for compatibility
    with bus-less plug behavior
  i386/cpu: Support CPU plugged in topology tree via bus-finder
  i386: Support topology device tree

 MAINTAINERS                     |  12 ++
 accel/kvm/kvm-all.c             |   4 +-
 hw/core/cpu-common.c            |  42 +++-
 hw/core/machine.c               |   7 +
 hw/core/null-machine.c          |   5 +
 hw/core/qdev.c                  |  89 +++++++--
 hw/cpu/core.c                   |   9 +-
 hw/cpu/cpu-slot.c               | 327 ++++++++++++++++++++++++++++++++
 hw/cpu/cpu-topology.c           | 216 +++++++++++++++++++++
 hw/cpu/die.c                    |  34 ++++
 hw/cpu/meson.build              |   6 +
 hw/cpu/module.c                 |  34 ++++
 hw/cpu/socket.c                 |  34 ++++
 hw/i386/microvm.c               |  13 +-
 hw/i386/x86-common.c            | 226 +++++++++++++++-------
 hw/i386/x86.c                   |   2 +
 hw/pci-host/pnv_phb.c           |  59 ++----
 hw/ppc/pnv_core.c               |  11 +-
 hw/ppc/spapr_cpu_core.c         |  12 +-
 include/hw/boards.h             |  11 ++
 include/hw/core/cpu.h           |   7 +-
 include/hw/cpu/core.h           |   3 +-
 include/hw/cpu/cpu-slot.h       |  79 ++++++++
 include/hw/cpu/cpu-topology.h   |  69 +++++++
 include/hw/cpu/die.h            |  29 +++
 include/hw/cpu/module.h         |  29 +++
 include/hw/cpu/socket.h         |  29 +++
 include/hw/i386/x86.h           |   2 +
 include/hw/ppc/pnv_core.h       |   3 +-
 include/hw/ppc/spapr_cpu_core.h |   4 +-
 include/hw/qdev-core.h          |   9 +
 include/monitor/bus-finder.h    |  41 ++++
 include/qemu/bitops.h           |   5 +
 include/qemu/typedefs.h         |   3 +
 stubs/hotplug-stubs.c           |   5 +
 system/bus-finder.c             |  46 +++++
 system/meson.build              |   1 +
 system/qdev-monitor.c           |  41 +++-
 system/vl.c                     |   4 +
 target/i386/cpu.c               |  13 ++
 target/ppc/kvm.c                |   2 +-
 41 files changed, 1417 insertions(+), 160 deletions(-)
 create mode 100644 hw/cpu/cpu-slot.c
 create mode 100644 hw/cpu/cpu-topology.c
 create mode 100644 hw/cpu/die.c
 create mode 100644 hw/cpu/module.c
 create mode 100644 hw/cpu/socket.c
 create mode 100644 include/hw/cpu/cpu-slot.h
 create mode 100644 include/hw/cpu/cpu-topology.h
 create mode 100644 include/hw/cpu/die.h
 create mode 100644 include/hw/cpu/module.h
 create mode 100644 include/hw/cpu/socket.h
 create mode 100644 include/monitor/bus-finder.h
 create mode 100644 system/bus-finder.c

-- 
2.34.1


