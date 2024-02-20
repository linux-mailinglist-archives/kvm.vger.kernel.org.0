Return-Path: <kvm+bounces-9153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AAC385B6ED
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EC2D281C1A
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB115FB99;
	Tue, 20 Feb 2024 09:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S6XahKdw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F4557333
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420307; cv=none; b=Sq/xRmFT6D0Igc1gaPgvLxtk5wAB9TosOWODvvUGM48DOBteiYJdheShXJ4m8nQyN3Bg6Z69kaNGqC9u6FBqwcDLFyJwtjWFYRX/WwDGIvJT24yorb0WxuBUCXG4Q2SjnTGhVuTh+15a8oNSCH1rZ3OiftXSw1c2MokgrFZ1LZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420307; c=relaxed/simple;
	bh=brs8Wc8MtqC+jD4fj4w5YcCZt8grPE7rypv1O7XbwgM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hHk+k00CNYVNxwYPK2ToKZ0He/f6Id/NX/lvlLc2DdY7RXZM3tNxF45Y9y9Bf5cbfOSvf/oeH3dc8gHoC5m9OnbG1X8L7t5UNsY7vn87HVLqrrZeLuK+ivGKNaHkCLiDRrgpXw8YMFQKOB14aIPpkqf5Q0kvWHUTpG1thJ8xFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S6XahKdw; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420306; x=1739956306;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=brs8Wc8MtqC+jD4fj4w5YcCZt8grPE7rypv1O7XbwgM=;
  b=S6XahKdwsWV6GdriUc6BinfWQGgaqHG2BMtNzU5AcIHo7k5i/+qdxgVY
   gD2cU3yzRH+7lB2xhUJVRZKVOzRC5ptgIDuGjRmkdC8KJsgquaqy21/Vj
   ZLc8+7CIFHeUOutjxOW2CsCHwIbQ3OPiIES/sL4opIwaUdO4puENW/Z61
   ehNw7gkov+Oy+T7S+IneSgk5pQ7FBsYP6ZW/eiNBhHD5nuQn5nHYfXqJD
   X8LvWyWAC06/aLDpSvGBKsgRO/KTKAj/Ci6szqCElmIx+a4OxgUTr9Vlx
   WbI1CLYSRRH631YNxukmi9uaF/+1ccXXYClSXWTDBV5d1hQvh97Uee6AP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2374955"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2374955"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5012799"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:11:39 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 0/8] Introduce SMP Cache Topology
Date: Tue, 20 Feb 2024 17:24:56 +0800
Message-Id: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Hi list,

This's our proposal for supporting (SMP) cache topology in -smp as
the following example:

-smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
     l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die

With the new cache topology options ("l1d-cache", "l1i-cache",
"l2-cache" and "l3-cache"), we could adjust the cache topology via -smp.

This patch set is rebased on our i386 module series:
https://lore.kernel.org/qemu-devel/20240131101350.109512-1-zhao1.liu@linux.intel.com/

Since the ARM [1] and RISC-V [2] folks have similar needs for the cache
topology, I also cc'd the ARM and RISC-V folks and lists.


Welcome your feedback!


Introduction
============

Background
----------

Intel client platforms (ADL/RPL/MTL) and E core server platforms (SRF)
share the L2 cache domain among multiple E cores (in the same module).

Thus we need a way to adjust the cache topology so that users could
create the cache topology for Guest that is nearly identical to Host.

This is necessary in cases where there are bound vCPUs, especially
considering that Guest scheduling often takes into account the cache
topology as well (e.g. Linux cluster aware scheduling, i.e. L2 cache
scheduling).

Previously, we introduced a x86 specific option to adjust the cache
topology:

-cpu x-l2-cache-topo=[core|module] [3]

However, considering the needs of other arches, we re-implemented the
generic cache topology (aslo in response to Michael's [4] and Daniel's
comment [5]) in this series.


Cache Topology Representation
-----------------------------

We consider to define the cache topology based on CPU topology level for
two reasons:

1. In practice, a cache will always be bound to the CPU container -
   "CPU container" indicates to a set of CPUs that refer to a certain
   level of CPU topology - where the cache is either private in that
   CPU container or shared among multiple containers.

2. The x86's cache-related CPUIDs encode cache topology based on APIC
   ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
   relies on also requires CPU containers (CPU topology) to help
   indicate the private shared hierarchy of the cache.

Therefore, for SMP systems, it is natural to use the CPU topology
hierarchy directly in QEMU to define the cache topology.

And currently, separated L1 cache (L1 data cache and L1 instruction
cache) with unified higher-level caches (e.g., unified L2 and L3
caches), is the most common cache architectures.

Thus, we define the topology for L1 D-cache, L1 I-cache, L2 cache and L3
cache in MachineState as the basic cache topology support:

typedef struct CacheTopology {
    CPUTopoLevel l1d;
    CPUTopoLevel l1i;
    CPUTopoLevel l2;
    CPUTopoLevel l3;
} CacheTopology;

Machines may also only support a subset of the cache topology
to be configured in -smp by setting the SMP property of MachineClass:

typedef struct {
    ...
    bool l1_separated_cache_supported;
    bool l2_unified_cache_supported;
    bool l3_unified_cache_supported;
} SMPCompatProps;


Cache Topology Configuration in -smp
------------------------------------

Further, we add new parameters to -smp:
* l1d-cache=level
* l1i-cache=level
* l2-cache=level
* l3-cache=level

These cache topology parameters accept the strings of CPU topology
levels (such as "drawer", "book", "socket", "die", "cluster", "module",
"core" or "thread"). Exactly which topology level strings could be
accepted as the parameter depends on the machine's support for the
corresponding CPU topology level.

Unsupported cache topology parameters will be omitted, and
correspondingly, the target CPU's cache topology will use the its
default cache topology setting.

In this series, we add the cache topology support in -smp for x86 PC
machine.

The following example defines a 3-level cache topology hierarchy (L1
D-cache per core, L1 I-cache per core, L2 cache per core and L3 cache per
die) for PC machine.

-smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
     l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die


Reference
---------

[1]: [ARM] Jonathan's proposal to adjust cache topology:
     https://lore.kernel.org/qemu-devel/20230808115713.2613-2-Jonathan.Cameron@huawei.com/
[2]: [RISC-V] Discussion between JeeHeng and Jonathan about cache
     topology:
     https://lore.kernel.org/qemu-devel/20240131155336.000068d1@Huawei.com/
[3]: Previous x86 specific cache topology option:
     https://lore.kernel.org/qemu-devel/20230914072159.1177582-22-zhao1.liu@linux.intel.com/
[4]: Michael's comment about generic cache topology support:
     https://lore.kernel.org/qemu-devel/20231003085516-mutt-send-email-mst@kernel.org/
[5]: Daniel's question about how x86 support L2 cache domain (cluster)
     configuration:
     https://lore.kernel.org/qemu-devel/ZcUG0Uc8KylEQhUW@redhat.com/

Thanks and Best Regards,
Zhao

---
Zhao Liu (8):
  hw/core: Rename CpuTopology to CPUTopology
  hw/core: Move CPU topology enumeration into arch-agnostic file
  hw/core: Define cache topology for machine
  hw/core: Add cache topology options in -smp
  i386/cpu: Support thread and module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -smp for PC machine
  qemu-options: Add the cache topology description of -smp

 MAINTAINERS                     |   2 +
 hw/core/cpu-topology.c          |  56 ++++++++++++++
 hw/core/machine-smp.c           | 128 ++++++++++++++++++++++++++++++++
 hw/core/machine.c               |   9 +++
 hw/core/meson.build             |   1 +
 hw/i386/pc.c                    |   3 +
 hw/s390x/cpu-topology.c         |   6 +-
 include/hw/boards.h             |  33 +++++++-
 include/hw/core/cpu-topology.h  |  40 ++++++++++
 include/hw/i386/topology.h      |  18 +----
 include/hw/s390x/cpu-topology.h |   6 +-
 qapi/machine.json               |  14 +++-
 qemu-options.hx                 |  54 ++++++++++++--
 system/vl.c                     |  15 ++++
 target/i386/cpu.c               |  55 ++++++++++----
 target/i386/cpu.h               |   2 +-
 tests/unit/meson.build          |   3 +-
 tests/unit/test-smp-parse.c     |  14 ++--
 18 files changed, 399 insertions(+), 60 deletions(-)
 create mode 100644 hw/core/cpu-topology.c
 create mode 100644 include/hw/core/cpu-topology.h

-- 
2.34.1


