Return-Path: <kvm+bounces-1916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4977EECBB
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80E80B20AFF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFC9DF63;
	Fri, 17 Nov 2023 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRgczKrO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B4109
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206766; x=1731742766;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YLHi6GRYPIUMX2jYGDwwXL31+PV0KAFU5NzaOOjNqB8=;
  b=kRgczKrOuKx3veRGw4cVbkTGX+uEtu+zufG4HGjSQXWuz3ik4Ye+KtzS
   V8PGh0KrU/oEitOgWg86avRnQNFPib1hS7WuKLCWTb/G8kZT79w4oFwh9
   br0ABAHMUqm8cv0etcS6GzwHd14VWng8AHTOizHDWqKYNPBkYV3QAfXZO
   w6HGmEvOh6vaL8ewOQmWpH5YG0Z84I94IyAJQbTDlt87Aw70JxH9NRJqT
   wmhM2lAab1Sq304l8832C05ulLvjy93d/ZpVeDNtbddtvOowwFQbBuJHM
   78uq2+pl56NfgpMFKksXHaLypGlYUuza02XswP9wnrx/k9+XabHs9aBd9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180251"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180251"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:39:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042535"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042535"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:39:21 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 00/16] Support smp.clusters for x86 in QEMU
Date: Fri, 17 Nov 2023 15:50:50 +0800
Message-Id: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
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

This is the our v6 patch series, rebased on the master branch at the
commit 34a5cb6d8434 (Merge tag 'pull-tcg-20231114' of
https://gitlab.com/rth7680/qemu into staging).

Because the first four patches of v5 [1] have been merged, v6 contains
the remaining patches and reabse on the latest master.

No more change since v5 exclude the comment update about QEMU version
(see Changelog).

Welcome your comments!


PS: About the idea to implement generic smp cache topology, we're
considerring to port the original x-l2-cache-topo option to smp [2].
Just like:

-smp cpus=4,sockets=2,cores=2,threads=1, \
     l3-cache=socket,l2-cache=core,l1-i-cache=core,l1-d-cache=core

Any feedback about this direction is also welcomed! ;-)


---
# Introduction

This series adds the cluster support for x86 PC machine, which allows
x86 can use smp.clusters to configure the module level CPU topology
of x86.

This series also is the preparation to help x86 to define the more
flexible cache topology, such as having multiple cores share the
same L2 cache at cluster level. (That was what x-l2-cache-topo did,
and we will explore a generic way.)

About why we don't share L2 cache at cluster and need a configuration
way, pls see section: ## Why not share L2 cache in cluster directly.


# Background

The "clusters" parameter in "smp" is introduced by ARM [3], but x86
hasn't supported it.

At present, x86 defaults L2 cache is shared in one core, but this is
not enough. There're some platforms that multiple cores share the
same L2 cache, e.g., Alder Lake-P shares L2 cache for one module of
Atom cores [4], that is, every four Atom cores shares one L2 cache.
Therefore, we need the new CPU topology level (cluster/module).

Another reason is for hybrid architecture. cluster support not only
provides another level of topology definition in x86, but would also
provide required code change for future our hybrid topology support.


# Overview

## Introduction of module level for x86

"cluster" in smp is the CPU topology level which is between "core" and
die.

For x86, the "cluster" in smp is corresponding to the module level [4],
which is above the core level. So use the "module" other than "cluster"
in x86 code.

And please note that x86 already has a cpu topology level also named
"cluster" [5], this level is at the upper level of the package. Here,
the cluster in x86 cpu topology is completely different from the
"clusters" as the smp parameter. After the module level is introduced,
the cluster as the smp parameter will actually refer to the module level
of x86.


## Why not share L2 cache in cluster directly

Though "clusters" was introduced to help define L2 cache topology
[3], using cluster to define x86's L2 cache topology will cause the
compatibility problem:

Currently, x86 defaults that the L2 cache is shared in one core, which
actually implies a default setting "cores per L2 cache is 1" and
therefore implicitly defaults to having as many L2 caches as cores.

For example (i386 PC machine):
-smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16 (*)

Considering the topology of the L2 cache, this (*) implicitly means "1
core per L2 cache" and "2 L2 caches per die".

If we use cluster to configure L2 cache topology with the new default
setting "clusters per L2 cache is 1", the above semantics will change
to "2 cores per cluster" and "1 cluster per L2 cache", that is, "2
cores per L2 cache".

So the same command (*) will cause changes in the L2 cache topology,
further affecting the performance of the virtual machine.

Therefore, x86 should only treat cluster as a cpu topology level and
avoid using it to change L2 cache by default for compatibility.


## module level in CPUID

Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
erroneous smp_num_siblings on Intel Hybrid platforms") is able to
handle platforms with Module level enumerated via CPUID.1F.

Expose the module level in CPUID[0x1F] (for Intel CPUs) if the machine
has more than 1 modules since v3.


## New cache topology info in CPUCacheInfo

(This is in preparation for users being able to configure cache topology
from the cli later on.)

Currently, by default, the cache topology is encoded as:
1. i/d cache is shared in one core.
2. L2 cache is shared in one core.
3. L3 cache is shared in one die.

This default general setting has caused a misunderstanding, that is, the
cache topology is completely equated with a specific cpu topology, such
as the connection between L2 cache and core level, and the connection
between L3 cache and die level.

In fact, the settings of these topologies depend on the specific
platform and are not static. For example, on Alder Lake-P, every
four Atom cores share the same L2 cache [3].

Thus, in this patch set, we explicitly define the corresponding cache
topology for different cpu models and this has two benefits:
1. Easy to expand to new CPU models in the future, which has different
   cache topology.
2. It can easily support custom cache topology by some command.


# Patch description

patch 1 Fixes about x86 topology and Intel l1 cache topology.

patch 2-3 Cleanups about topology related CPUID encoding and QEMU
          topology variables.

patch 4-5 Refactor CPUID[0x1F] encoding to prepare to introduce module
          level.

patch 6-12 Add the module as the new CPU topology level in x86, and it
            is corresponding to the cluster level in generic code.

patch 13,14,16 Add cache topology information in cache models.

patch 15 Update AMD CPUs' cache topology encoding.


[1]: https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg08233.html
[2]: https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg01954.html
[3]: https://patchew.org/QEMU/20211228092221.21068-1-wangyanan55@huawei.com/
[4]: https://www.intel.com/content/www/us/en/products/platforms/details/alder-lake-p.html
[5]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.

Best Regards,
Zhao
---
Changelog:

Changes since v5:
 * The first four patches of v5 [1] have been merged, v6 contains
   the remaining patches.
 * Reabse on the latest master.
 * Update the comment when check cluster-id. Since current QEMU is
   v8.2, the cluster-id support should at least start from v8.3.

Changes since v4:
 * Drop the "x-l2-cache-topo" option. (Michael)
 * Add A/R/T tags.

Changes since v3 (main changes):
 * Expose module level in CPUID[0x1F].
 * Fix compile warnings. (Babu)
 * Fixes cache topology uninitialization bugs for some AMD CPUs. (Babu)

Changes since v2:
 * Add "Tested-by", "Reviewed-by" and "ACKed-by" tags.
 * Use newly added wrapped helper to get cores per socket in
   qemu_init_vcpu().

Changes since v1:
 * Reordered patches. (Yanan)
 * Deprecated the patch to fix comment of machine_parse_smp_config().
   (Yanan)
 * Rename test-x86-cpuid.c to test-x86-topo.c. (Yanan)
 * Split the intel's l1 cache topology fix into a new separate patch.
   (Yanan)
 * Combined module_id and APIC ID for module level support into one
   patch. (Yanan)
 * Make cache_into_passthrough case of cpuid 0x04 leaf in
 * cpu_x86_cpuid() use max_processor_ids_for_cache() and
   max_core_ids_in_package() to encode CPUID[4]. (Yanan)
 * Add the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
   (Yanan)

---
Zhao Liu (10):
  i386/cpu: Fix i/d-cache topology to core level for Intel CPU
  i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
  i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
  i386: Split topology types of CPUID[0x1F] from the definitions of
    CPUID[0xB]
  i386: Decouple CPUID[0x1F] subleaf with specific topology level
  i386: Expose module level in CPUID[0x1F]
  i386: Add cache topology info in CPUCacheInfo
  i386: Use CPUCacheInfo.share_level to encode CPUID[4]
  i386: Use offsets get NumSharingCache for CPUID[0x8000001D].EAX[bits
    25:14]
  i386: Use CPUCacheInfo.share_level to encode
    CPUID[0x8000001D].EAX[bits 25:14]

Zhuocheng Ding (6):
  i386: Introduce module-level cpu topology to CPUX86State
  i386: Support modules_per_die in X86CPUTopoInfo
  i386: Support module_id in X86CPUTopoIDs
  i386/cpu: Introduce cluster-id to X86CPU
  tests: Add test case of APIC ID for module level parsing
  hw/i386/pc: Support smp.clusters for x86 PC machine

 hw/i386/pc.c               |   1 +
 hw/i386/x86.c              |  49 ++++++-
 include/hw/i386/topology.h |  35 ++++-
 qemu-options.hx            |  10 +-
 target/i386/cpu.c          | 289 +++++++++++++++++++++++++++++--------
 target/i386/cpu.h          |  43 +++++-
 target/i386/kvm/kvm.c      |   2 +-
 tests/unit/test-x86-topo.c |  56 ++++---
 8 files changed, 379 insertions(+), 106 deletions(-)

-- 
2.34.1


