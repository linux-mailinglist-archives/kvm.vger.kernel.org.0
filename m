Return-Path: <kvm+bounces-12382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2B6885AA4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F2081C20E92
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBC98527B;
	Thu, 21 Mar 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A34sGgKB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906D784A5A
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031234; cv=none; b=Iav5zEGET7sbljskvUsW/4yMadDYXKiG3t2PZkgcN/MAAfT+cDV+u+C4JqW8JLO2+1YBcIHbSpIdEURUsUzhiETyrAJlrEa5fIyOAYYvbiMffqTBRCkVXMBY+d8G3RkRyAG1WxYt0SE8PAH4CiuxFh2R9dMHM2Ig5T+mny/xOQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031234; c=relaxed/simple;
	bh=wrUYmHOjqxV9bo1ZKF/zzxRxWvXNlgpZQCU3yzV1rN4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=h7TRGx94vg8A8pD0HPHG3PehSWyXtC4Xjaj6Tvw6qWs5eH38isWpgdF02Cil8A+8SVW7ck0ibP4+oqOIWdySC6NaSxwa6ONfg/mmS9BbrGkllP5V4Qfk+BlR0DHDj455IDxH9socE9u3L75Kb2vzCgwRnNMUfOpUop6ezx/X2Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A34sGgKB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031233; x=1742567233;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wrUYmHOjqxV9bo1ZKF/zzxRxWvXNlgpZQCU3yzV1rN4=;
  b=A34sGgKBTnQRUfguI/unA+gmFeMOFz3/qRl2mA2utB4cPuXLXsW5d2H9
   5pQpQrQQS/xQ55F7lHJB2LHfrmjKQn8sKBQ7ttto9s/NEu1Z8L+lz0mKw
   DV9Z0yWkuEvoIV+OCCnMWngf31U9IpeSNjD4BlPZA2fvjcdtoZkGIBzIZ
   yFJ4kgvL53SL6Pxs+DMNh+TP8dSwUprJK661RMYBSOBMiBA4duh6LNkem
   o2FWtbtNSFM+ZP0aYDdlidon6fliES+FgIeuTY0KLT0MNhrsDpsTBkOu1
   UT6X6zeVBnZOXlg00LL/sAHlHD7Q1uN/3foE95LX+t/OsgR4t2rbq0cwL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806327"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806327"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527786"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:07 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 00/21] i386: Introduce smp.modules and clean up cache topology
Date: Thu, 21 Mar 2024 22:40:27 +0800
Message-Id: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
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

Hi,

This is the our v10 patch series, rebased on the master branch at the
commit 54294b23e16d ("Merge tag 'ui-pull-request' of
https://gitlab.com/marcandre.lureau/qemu into staging").

Compared with v9 [1], v10 mainly contains minor cleanups, without
significant code changes.

Intel's hybrid Client platform and E core server platform introduce
module level and share L2 cache on the module level, in order to
configure the CPU/cache topology for the Guest to be consistent with
Host's, this series did the following work:
 * Add now "module" CPU topology level for x86 CPU.
 * Refacter cache topology encoding for x86 CPU (This is base to
   support the L2 per module).

So, this series is also necessary to support subsequent user
configurations of cache topology (via -smp, [2]) and Intel heterogeneous
CPU topology ([3] and [4]).


Background
==========

At present, x86 defaults L2 cache is shared in one core, but this is
not enough. There're some platforms that multiple cores share the
same L2 cache, e.g., Alder Lake-P shares L2 cache for one module of
Atom cores, that is, every four Atom cores shares one L2 cache. On
E core server platform, there's the similar L2 per module topology.
Therefore, we need the new CPU topology level.

Another reason is that Intel client hybrid architectures organize P
cores and E cores via module, so a new CPU topology level is necessary
to support hybrid CPU topology!


Why We Introduce Module Instead of Reusing Cluster
--------------------------------------------------

For the discussion in v7 about whether we should reuse current
smp.clusters for x86 module, the core point is what's the essential
differences between x86 module and general cluster.

Since, cluster (for ARM/riscv) lacks a comprehensive and rigorous
hardware definition, and judging from the description of smp.clusters
[5] when it was introduced by QEMU, x86 module is very similar to
general smp.clusters: they are all a layer above existing core level
to organize the physical cores and share L2 cache.

But there are following reasons that drive us to introduce the new
smp.modules:

  * As the CPU topology abstraction in device tree [6], cluster supports
    nesting (though currently QEMU hasn't support that). In contrast,
    (x86) module does not support nesting.

  * Due to nesting, there is great flexibility in sharing resources
    on cluster, rather than narrowing cluster down to sharing L2 (and
    L3 tags) as the lowest topology level that contains cores.

  * Flexible nesting of cluster allows it to correspond to any level
    between the x86 package and core.

  * In Linux kernel, x86's cluster only represents the L2 cache domain
    but QEMU's smp.clusters is the CPU topology level. Linux kernel will
    also expose module level topology information in sysfs for x86. To
    avoid cluster ambiguity and keep a consistent CPU topology naming
    style with the Linux kernel, we introduce module level for x86.

Based on the above considerations, and in order to eliminate the naming
confusion caused by the mapping between general cluster and x86 module,
we now formally introduce smp.modules as the new topology level.


Where to Place Module in Existing Topology Levels
-------------------------------------------------

The module is, in existing hardware practice, the lowest layer that
contains the core, while the cluster is able to have a higher topological
scope than the module due to its nesting.

Therefore, we place the module between the cluster and the core:

    drawer/book/socket/die/cluster/module/core/thread


Patch Series Overview
=====================

Introduction of Module Level in -smp
------------------------------------

First, a new module level is introduced in the -smp related code to
support the module topology in subsequent x86 parts.

Users can specify the number of modules (in one die) for a PC machine
with "-smp modules=*".


Why not Share L2 Cache in Module Directly
-----------------------------------------

Though one of module's goals is to implement L2 cache per module,
directly using module to define x86's L2 cache topology will cause the
compatibility problem:

Currently, x86 defaults that the L2 cache is shared in one core, which
actually implies a default setting "cores per L2 cache is 1" and
therefore implicitly defaults to having as many L2 caches as cores.

For example (i386 PC machine):
-smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16 (*)

Considering the topology of the L2 cache, this (*) implicitly means "1
core per L2 cache" and "2 L2 caches per die".

If we use module to configure L2 cache topology with the new default
setting "modules per L2 cache is 1", the above semantics will change
to "2 cores per module" and "1 module per L2 cache", that is, "2
cores per L2 cache".

So the same command (*) will cause changes in the L2 cache topology,
further affecting the performance of the virtual machine.

Therefore, x86 should only treat module as a cpu topology level and
avoid using it to change L2 cache by default for compatibility.

Thereby, we need another way to allow user to configure cache topology,
this is anther RFC [2].


Module Level in CPUID
---------------------

Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
erroneous smp_num_siblings on Intel Hybrid platforms") is able to
handle platforms with Module level enumerated via CPUID.1F.

Expose the module level in CPUID[0x1F] (for Intel CPUs) if the machine
has more than 1 modules since v3.


New Cache Topology Info in CPUCacheInfo
---------------------------------------

(This is in preparation for users being able to configure cache topology
from the command line later on.)

Currently, by default, the cache topology is encoded as:
1. i/d cache is shared in one core.
2. L2 cache is shared in one core.
3. L3 cache is shared in one die.

This default general setting has caused a misunderstanding, that is, the
cache topology is completely equated with a specific CPU topology, such
as the connection between L2 cache and core level, and the connection
between L3 cache and die level.

In fact, the settings of these topologies depend on the specific
platform and are not static. For example, on Alder Lake-P, every
four Atom cores share the same L2 cache [3].

Thus, in this patch set, we explicitly define the corresponding cache
topology for different cache models and this has two benefits:
1. Easy to expand to new cache models with different topology in the
   future.
2. It can easily support custom cache topology by some command.


Patch Description
=================

Patch 01-04: Add module support in -smp.

Patch    05: Fix Intel L1 cache topology.

Patch 06-08: Clean up cache topology related CPUID encoding and QEMU
             topology variables.

Patch 09-11: Refactor CPUID[0x1F] (CPU topology) encoding to prepare to
             introduce module level.

Patch 12-18: Add the module as the new CPU topology level in x86.

Patch 19-21: Refactor cache topology encoding for Intel and AMD.


Reference
=========

[1]: https://lore.kernel.org/qemu-devel/20240227103231.1556302-1-zhao1.liu@linux.intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240220092504.726064-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/20230213095035.158240-1-zhao1.liu@linux.intel.com/
[4]: https://lore.kernel.org/qemu-devel/20231130144203.2307629-1-zhao1.liu@linux.intel.com/


Thanks and Best Regards,
Zhao
---
Changelog:

Changes since v9:
 * Collected a/b, t/b and r/b tags.
 * Fixed typos.
 * Minor cleanup of code.
 * Added more comments and polished commit message.

Changes since v8:
 * Added the reason of why a new module level is needed in commit
   message. (Markus).
 * Added the description about how Linux kernel supports x86 module
   level in commit message. (Daniel)
 * Added module description in qemu_smp_opts.
 * Added missing "modules" parameter of -smp example in documentation.
 * Added Philippe's reviewed-by tag.

Changes since v7 (main changes):
 * Introduced smp.modules as a new CPU topology level. (Xiaoyao)
 * Fixed calculations of cache_info_passthrough case in the
   patch "i386/cpu: Use APIC ID info to encode cache topo in
   CPUID[4]". (Xiaoyao)
 * Moved the patch "i386/cpu: Use APIC ID info get NumSharingCache
   for CPUID[0x8000001D].EAX[bits 25:14]" after CPUID[4]'s similar
   change ("i386/cpu: Use APIC ID offset to encode cache topo in
   CPUID[4]"). (Xiaoyao)
 * Introduced a bitmap in CPUX86State to cache available CPU topology
   levels.
 * Refactored the encode_topo_cpuid1f() to use traversal to search the
   encoded level and avoid using static variables.
 * Mapped x86 module to smp module instead of cluster.
 * Dropped Michael/Babu's ACKed/Tested tags for most patches since the
   code change.

Changes since v6:
 * Updated the comment when check cluster-id. Since there's no
   v8.2, the cluster-id support should at least start from v9.0.
 * Rebased on commit d328fef93ae7 ("Merge tag 'pull-20231230' of
   https://gitlab.com/rth7680/qemu into staging").

Changes since v5:
 * The first four patches of v5 [1] have been merged, v6 contains
   the remaining patches.
 * Reabsed on the latest master.
 * Updated the comment when check cluster-id. Since current QEMU is
   v8.2, the cluster-id support should at least start from v8.3.

Changes since v4:
 * Dropped the "x-l2-cache-topo" option. (Michael)
 * Added A/R/T tags.

Changes since v3 (main changes):
 * Exposed module level in CPUID[0x1F].
 * Fixed compile warnings. (Babu)
 * Fixed cache topology uninitialization bugs for some AMD CPUs. (Babu)

Changes since v2:
 * Added "Tested-by", "Reviewed-by" and "ACKed-by" tags.
 * Used newly added wrapped helper to get cores per socket in
   qemu_init_vcpu().

Changes since v1:
 * Reordered patches. (Yanan)
 * Deprecated the patch to fix comment of machine_parse_smp_config().
   (Yanan)
 * Renamed test-x86-cpuid.c to test-x86-topo.c. (Yanan)
 * Split the intel's l1 cache topology fix into a new separate patch.
   (Yanan)
 * Combined module_id and APIC ID for module level support into one
   patch. (Yanan)
 * Made cache_into_passthrough case of cpuid 0x04 leaf in
 * cpu_x86_cpuid() used max_processor_ids_for_cache() and
   max_core_ids_in_package() to encode CPUID[4]. (Yanan)
 * Added the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
   (Yanan)
---
Zhao Liu (20):
  hw/core/machine: Introduce the module as a CPU topology level
  hw/core/machine: Support modules in -smp
  hw/core: Introduce module-id as the topology subindex
  hw/core: Support module-id in numa configuration
  i386/cpu: Fix i/d-cache topology to core level for Intel CPU
  i386/cpu: Use APIC ID info to encode cache topo in CPUID[4]
  i386/cpu: Use APIC ID info get NumSharingCache for
    CPUID[0x8000001D].EAX[bits 25:14]
  i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
  i386/cpu: Introduce bitmap to cache available CPU topology levels
  i386: Split topology types of CPUID[0x1F] from the definitions of
    CPUID[0xB]
  i386/cpu: Decouple CPUID[0x1F] subleaf with specific topology level
  i386: Introduce module level cpu topology to CPUX86State
  i386: Support modules_per_die in X86CPUTopoInfo
  i386: Expose module level in CPUID[0x1F]
  i386: Support module_id in X86CPUTopoIDs
  i386/cpu: Introduce module-id to X86CPU
  hw/i386/pc: Support smp.modules for x86 PC machine
  i386: Add cache topology info in CPUCacheInfo
  i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[4]
  i386/cpu: Use CPUCacheInfo.share_level to encode
    CPUID[0x8000001D].EAX[bits 25:14]

Zhuocheng Ding (1):
  tests: Add test case of APIC ID for module level parsing

 hw/core/machine-hmp-cmds.c |   4 +
 hw/core/machine-smp.c      |  41 ++++-
 hw/core/machine.c          |  18 +++
 hw/i386/pc.c               |   1 +
 hw/i386/x86.c              |  67 +++++++--
 include/hw/boards.h        |   4 +
 include/hw/i386/topology.h |  60 +++++++-
 qapi/machine.json          |   7 +
 qemu-options.hx            |  18 ++-
 system/vl.c                |   3 +
 target/i386/cpu.c          | 301 +++++++++++++++++++++++++++++--------
 target/i386/cpu.h          |  29 +++-
 target/i386/kvm/kvm.c      |   3 +-
 tests/unit/test-x86-topo.c |  56 ++++---
 14 files changed, 490 insertions(+), 122 deletions(-)

-- 
2.34.1


