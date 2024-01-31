Return-Path: <kvm+bounces-7557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBC1843B9F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 299001F28511
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02EF6996E;
	Wed, 31 Jan 2024 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4eFqYfh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140569946
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695246; cv=none; b=ULE8BmK3VRv3KaA9XM7HJQQNVhOlos5PjYuZL2Yj2ZPcfNPKI3waot9K6yP/9+zEKSD/iAz+1mcgMNdVX8/iNOl54259TVGapqD10aXv12YBMmFp682rns3JlZ+d8fnTP0aB6iueQvAx1GpfkgXwjkLeUP2GQ780Aih7OVRlCQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695246; c=relaxed/simple;
	bh=edjwyrH7raJUreOhASlq4LPbPj6mZMQCL6Im+WYiA3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UnKWN5otRiJufg8urORwwA94HkDaFBLwzXIS6aup7WCVMbJz6uxs7SWTF7KOmzXI749DXw6m1twQ1RG91EQF2b0NyqmXUAO8ceXeiwP4Zxa92wS9jPDbqKKUn8ip4k9ls5EsmyzkfWUKdCeWe7SVdZTxSNcTogcW08ndzzzL8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4eFqYfh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706695244; x=1738231244;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=edjwyrH7raJUreOhASlq4LPbPj6mZMQCL6Im+WYiA3o=;
  b=Y4eFqYfh5XhiAIOeyEvLBss9r1id5aFLZv8BcM9tDT02vcNpHhhSSipb
   EZhAk7NEbz9TOh+GsO6LBAMlyG3gLgKjVhvoQN/hPgr/r0fdxm7lda/p5
   SGBUkSGUzUPHsqkABMl77US/Ej69atdFt7H3QI0BpX4xRIy9vfxdckI4a
   yX657BvMLhGPusFf76eeapsDUlOqtRaog552R/sZloxRDrb40OxxT7Qgk
   fQhXQv/itMqFnInDiAIsMXpUJJBzgRaMShHFe4EzJoVgB98vLfuwU2vUI
   HMgaBfBuk9k7yXP0G168FMLmmo5ng8iPmba3l1TTBYA6/R9JXzEZn1Ms7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="25032461"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="25032461"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 02:00:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4035919"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 02:00:37 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
Date: Wed, 31 Jan 2024 18:13:29 +0800
Message-Id: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
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

This is the our v8 patch series, rebased on the master branch at the
commit 11be70677c70 ("Merge tag 'pull-vfio-20240129' of
https://github.com/legoater/qemu into staging").

Compared with v7 [1], v8 mainly has the following changes:
  * Introduced smp.modules for x86 instead of reusing current
    smp.clusters.
  * Reworte the CPUID[0x1F] encoding.

Given the code change, I dropped the most previously gotten tags
(Acked-by/Reviewed-by/Tested-by from Michael & Babu, thanks for your
previous reviews and tests!) in v8.

With the description of the new modules added to x86 arch code in v7 [1]
cover letter, the following sections are mainly the description of
the newly added smp.modules (since v8) as supplement.

Welcome your comments!


Why We Need a New CPU Topology Level
====================================

For the discussion in v7 about whether we should reuse current
smp.clusters for x86 module, the core point is what's the essential
differences between x86 module and general cluster.

Since, cluster (for ARM/riscv) lacks a comprehensive and rigorous
hardware definition, and judging from the description of smp.clusters
[2] when it was introduced by QEMU, x86 module is very similar to
general smp.clusters: they are all a layer above existing core level
to organize the physical cores and share L2 cache.

However, after digging deeper into the description and use cases of
cluster in the device tree [3], I realized that the essential
difference between clusters and modules is that cluster is an extremely
abstract concept:
  * Cluster supports nesting though currently QEMU doesn't support
    nested cluster topology. However, modules will not support nesting.
  * Also due to nesting, there is great flexibility in sharing resources
    on clusters, rather than narrowing cluster down to sharing L2 (and
    L3 tags) as the lowest topology level that contains cores.
  * Flexible nesting of cluster allows it to correspond to any level
    between the x86 package and core.

Based on the above considerations, and in order to eliminate the naming
confusion caused by the mapping between general cluster and x86 module
in v7, we now formally introduce smp.modules as the new topology level.


Where to Place Module in Existing Topology Levels
=================================================

The module is, in existing hardware practice, the lowest layer that
contains the core, while the cluster is able to have a higher topological
scope than the module due to its nesting.

Thereby, we place the module between the cluster and the core, viz:

    drawer/book/socket/die/cluster/module/core/thread


Additional Consideration on CPU Topology
========================================

Beyond this patchset, nowadays, different arches have different topology
requirements, and maintaining arch-agnostic general topology in SMP
becomes to be an increasingly difficult thing due to differences in
sharing resources and special flexibility (e.g., nesting):
  * It becomes difficult to put together all CPU topology hierarchies of
    different arches to define complete topology order.
  * It also becomes complex to ensure the correctness of the topology
    calculations.
      - Now the max_cpus is calculated by multiplying all topology
        levels, and too many topology levels can easily cause omissions.

Maybe we should consider implementing arch-specfic topology hierarchies.


[1]: https://lore.kernel.org/qemu-devel/20240108082727.420817-1-zhao1.liu@linux.intel.com/
[2]: https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
[3]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt

---
Changelog:

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
 hw/core/machine-smp.c      |  41 +++--
 hw/core/machine.c          |  18 +++
 hw/i386/pc.c               |   1 +
 hw/i386/x86.c              |  67 ++++++--
 include/hw/boards.h        |   4 +
 include/hw/i386/topology.h |  60 +++++++-
 qapi/machine.json          |   7 +
 qemu-options.hx            |  10 +-
 target/i386/cpu.c          | 304 +++++++++++++++++++++++++++++--------
 target/i386/cpu.h          |  29 +++-
 target/i386/kvm/kvm.c      |   3 +-
 tests/unit/test-x86-topo.c |  56 ++++---
 13 files changed, 481 insertions(+), 123 deletions(-)

-- 
2.34.1


