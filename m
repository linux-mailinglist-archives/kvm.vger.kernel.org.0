Return-Path: <kvm+bounces-10046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE2E868D30
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 131302878E8
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA0A138493;
	Tue, 27 Feb 2024 10:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBw0glVD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F381384BA
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029139; cv=none; b=Gq43A6vCMPfFEkTIYi2vnuA/2KkzWygCZxBQIuUu0hvuk2cOubjE2P0VMy42aDQgYprQB5BCS3EBq++M98FJgTZiz1qYt9exlw+G0LCZVOh4ObgZO/xwEoKfvkbrmw7JN/YDilgQORf/evr1jAUsKKNi8mBInQKgIZwbEjIEoJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029139; c=relaxed/simple;
	bh=CegDiQCuDflnw5EfhaP8t6vKadYhecx20VlSVm3W5B0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZNSMl0DEO47iVZPzckOgF2r4cWw1YQMmTYIxrb1s3IOJUDkkfqN5Qw87IIRHIsBCeKeBV/Tg9o234pXbR3HbOhB0//y/sYVDvWAcBeP+rrx4IR22t3IHKvFEcTzzleiRZVxwYUDvLMtIz0ZssbETIWOMbpJd+t+aEB1q1W8HCDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBw0glVD; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029137; x=1740565137;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CegDiQCuDflnw5EfhaP8t6vKadYhecx20VlSVm3W5B0=;
  b=WBw0glVDI6eDjXNNHpeYGmG0hCAGH55OnJGbt2TRyZDF77yZ/al3IxFp
   VZEkmNlxxBpJLyjCJw4LuJewFyz1IYozpNjMNqblDvS1DJlMU4uPRcgvV
   Re802M9RFr0mHvixqF6z7o7CZic/7mQjw5Ljsltcf1RA1AoR2EZJnyZGe
   v8en1EvAczSvAY49zDbUdT7/BEpINi3RBiNBmyi33i3kSGLNZxw72/Npp
   Dk7bHETYo/FCEYAYVBZA3Vg74gjQ8Oge8nRj5EbSIZplnJJb0S0uO2OFs
   aMbxboVgO2+28D9fv+XppiT2bEADjmDGoCLExZJQr0CErRi6IKAZxdSXL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310194"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310194"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:18:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954736"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:18:51 -0800
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
Subject: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Date: Tue, 27 Feb 2024 18:32:10 +0800
Message-Id: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
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

This is the our v9 patch series, rebased on the master branch at the
commit 03d496a992d9 ("Merge tag 'pull-qapi-2024-02-26' of
https://repo.or.cz/qemu/armbru into staging").

Compared with v8 [1], v9 mainly added more module description in commit
message and added missing smp.modules description/documentation.

With the general introduction (with origial cluster level) of this
secries in v7 [2] cover letter, the following sections are mainly about
the description of the newly added smp.modules (since v8, changed x86
cluster support to module) as supplement.

Since v4 [3], we've dropped the original L2 cache command line option
(to configure L2 cache topology) and now we have the new RFC [4] to
support the general cache topology configuration (as the supplement to
this series).

Welcome your comments!


Why We Need a New CPU Topology Level
====================================

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
=================================================

The module is, in existing hardware practice, the lowest layer that
contains the core, while the cluster is able to have a higher topological
scope than the module due to its nesting.

Therefore, we place the module between the cluster and the core:

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


[1]: https://lore.kernel.org/qemu-devel/20240131101350.109512-1-zhao1.liu@linux.intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240108082727.420817-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/20231003085516-mutt-send-email-mst@kernel.org/
[4]: https://lore.kernel.org/qemu-devel/20240220092504.726064-1-zhao1.liu@linux.intel.com/
[5]: https://lore.kernel.org/qemu-devel/c3d68005-54e0-b8fe-8dc1-5989fe3c7e69@huawei.com/
[6]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt

Thanks and Best Regards,
Zhao
---
Changelog:

Changes since v8:
 * Add the reason of why a new module level is needed in commit message.
   (Markus).
 * Add the description about how Linux kernel supports x86 module level
   in commit message. (Daniel)
 * Add module description in qemu_smp_opts.
 * Add missing "modules" parameter of -smp example in documentation.
 * Add Philippe's reviewed-by tag.

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
 qemu-options.hx            |  18 ++-
 system/vl.c                |   3 +
 target/i386/cpu.c          | 304 +++++++++++++++++++++++++++++--------
 target/i386/cpu.h          |  29 +++-
 target/i386/kvm/kvm.c      |   3 +-
 tests/unit/test-x86-topo.c |  56 ++++---
 14 files changed, 489 insertions(+), 126 deletions(-)

-- 
2.34.1


