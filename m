Return-Path: <kvm+bounces-29405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9893D9AA343
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AD2F1F21DBE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0752B19DFA2;
	Tue, 22 Oct 2024 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDzYQ6Y8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD11D2FB
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604167; cv=none; b=mDFZIerY1s9MC0HQVs+itj9qpHb0rEG5b+edjBhMfjxgU/DqPKet3Dy3IQTVPjWhJik6HU0AiepuNCc/46opjz8DiIREUUqNzvJn5xuFpWwY3upc1lKQnyEFEXyXg+g0GlUAIhnjYDRxFLsCyqeBUFSYM98ctm1xJu//Dp815vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604167; c=relaxed/simple;
	bh=IMS/RVXZZpKiVSsba011nnusTI1R0H8RgF+np2LvyU8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HUFT9Km8waJDl38CvdAEnaKs3ayuO74wl74Fp3IF5xsYdA6JIR5kMukMGByfezwKiaupyX0woBEz/2jnq+oK6Y0G3vMYOPisMsz8swhvNex6zuwxyACtHZ25NQ35t2BWTxzGoRtfzXtnLD+II7uKECGqgDLWWm7JZ1JGJSBj/XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDzYQ6Y8; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729604164; x=1761140164;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IMS/RVXZZpKiVSsba011nnusTI1R0H8RgF+np2LvyU8=;
  b=DDzYQ6Y8W3twxdzzpd1UaMCC3ZO/zW/Js78pWiQGNa4ld9ppXy9pVXTb
   l+ZxAakK3nr1Yckj5aDkDOiGgElvTrX1qXQR3PYkAoyKyyfIIK/3sCcp3
   kNguALID/LPMhQwfAyb5SSDfw9AtnmAkpFNEaAFQIL6PkefmJQj4/pnZy
   +wCqFn/p67zeFSdrhkVYh2eqwreP6kej0iPiY9UUnQHitTujb5wl/FnoW
   UToO5hM5JrUR0iGbpaYdr7AD/skaCw8TT3/+sr58kEIpimI0WSnUX7Myb
   uc1MxZQR4d8MLWYqKrFgPneYZkbSDHmFbh2kv1YxHjzYpndKbR2qTU3Bo
   A==;
X-CSE-ConnectionGUID: HBtLzW9LQdWbvmD8c1ek2g==
X-CSE-MsgGUID: dN9R/ul/SzuyVDk2Ia6QqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46603582"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46603582"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:36:03 -0700
X-CSE-ConnectionGUID: I9f+t04WTYKni3/RchTGxg==
X-CSE-MsgGUID: qbS7s9nSTJ2xp8XPbE+DuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79782206"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 22 Oct 2024 06:35:58 -0700
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
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 0/9] Introduce SMP Cache Topology
Date: Tue, 22 Oct 2024 21:51:42 +0800
Message-Id: <20241022135151.2052198-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Compared with v3 [1], the v4 mainly changes these places:

 * Don't expose "invalid" enumeration in QAPI and define it by a
   macro instead. (new patch 1, and updated patch 2)

 * Check cache topology after the arch machine loads the user-
   configured cache model from MachineState.smp_cache and consumes
   the special "default" level by replacing it with the specific level.
   (new patch 5, and updated patch 7)

 * Describ the omitting cache will use "default" level and describ
   the default cache topology model of i386 PC machine. (updated
   patch 8)

All the above changes are tested and the interface design has remained
stable.

Meanwhile, ARM side has also worked a lot on the smp-cache based on
this series [2].

This series is based on the commit cc5adbbd50d8 ("Merge tag
'pull-tpm-2024-10-18-1' of https://github.com/stefanberger/qemu-tpm into
staging").

Welcome your feedback, and I appreciate your reviews. Hope our series
can catch up with the 9.2 cycle. :)


Background
==========

The x86 and ARM (RISCV) need to allow user to configure cache properties
(current only topology):
 * For x86, the default cache topology model (of max/host CPU) does not
   always match the Host's real physical cache topology. Performance can
   increase when the configured virtual topology is closer to the
   physical topology than a default topology would be.
 * For ARM, QEMU can't get the cache topology information from the CPU
   registers, then user configuration is necessary. Additionally, the
   cache information is also needed for MPAM emulation (for TCG) to
   build the right PPTT. (Originally from Jonathan)


About smp-cache
===============

The API design has been discussed heavily in [3].

Now, smp-cache is implemented as a array integrated in -machine. Though
-machine currently can't support JSON format, this is the one of the
directions of future.

An example is as follows:

smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die

"cache" specifies the cache that the properties will be applied on. This
field is the combination of cache level and cache type. Now it supports
"l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
cache) and "l3" (L3 unified cache).

"topology" field accepts CPU topology levels including "thread", "core",
"module", "cluster", "die", "socket", "book", "drawer" and a special
value "default".

The "default" is introduced to make it easier for libvirt to set a
default parameter value without having to care about the specific
machine (because currently there is no proper way for machine to
expose supported topology levels and caches).

If "default" is set, then the cache topology will follow the
architecture's default cache topology model. If other CPU topology level
is set, the cache will be shared at corresponding CPU topology level.

Welcome your feedback and review!

[1]: Patch v3: https://lore.kernel.org/qemu-devel/20241012104429.1048908-1-zhao1.liu@intel.com/
[2]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20241010111822.345-1-alireza.sanaee@huawei.com/
[3]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/

Thanks and Best Regards,
Zhao
---
Changelog:

Main changes since Patch v3:
 * Stopped exposing "invalid" enumeration in QAPI and define it by a
   macro instead. (Dainel)
 * Checked cache topology after the arch machine loads the
   user-configured cache model from MachineState.smp_cache and consumes
   the special "default" level by replacing it with the specific level.
   (Daniel)
 * Described the omitting cache will use "default" level and described
   the default cache topology model of i386 PC machine. (Daniel)

Main changes since Patch v2:
 * Updated version of new QAPI structures to v9.2. (Jonathan)
 * Merged the QAPI change and smp-cache property support of machine
   into one commit. (Jonathan)
 * Picked Alireza's patch to add a has_caches flag.
 * Polished english and coding style. (Jonathan)

Main changes since Patch v1:
 * Dropped handwriten smp-cache object and integrated cache properties
   list into MachineState and used -machine to configure SMP cache
   properties. (Markus)
 * Dropped prefix of CpuTopologyLevel enumeration. (Markus)
 * Rename CPU_TOPO_LEVEL_* to CPU_TOPOLOGY_LEVEL_* to match the QAPI's
   generated code. (Markus)
 * Renamed SMPCacheProperty/SMPCacheProperties (QAPI structures) to
   SmpCacheProperties/SmpCachePropertiesWrapper. (Markus)
 * Renamed SMPCacheName (QAPI structure) to SmpCacheLevelAndType and
   dropped prefix. (Markus)
 * Renamed 'name' field in SmpCacheProperties to 'cache', since the
   type and level of the cache in SMP system could be able to specify
   all of these kinds of cache explicitly enough.
 * Renamed 'topo' field in SmpCacheProperties to 'topology'. (Markus)
 * Returned error information when user repeats setting cache
   properties. (Markus)
 * Renamed SmpCacheLevelAndType to CacheLevelAndType, since this
   representation is general across SMP or hybrid system.
 * Dropped machine_check_smp_cache_support() and did the check when
   -machine parses smp-cache in machine_parse_smp_cache().

Main changes since RFC v2:
 * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
   (CpuTopologyLevel_str) to convert enum to string. (Markus)
 * Fixed text format in machine.json (CpuTopologyLevel naming, 2 spaces
   between sentences). (Markus)
 * Added a new level "default" to de-compatibilize some arch-specific
   topo settings. (Daniel)
 * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
   cache enumeration and smp-cache object would be added.
   - If smp-cache object is defined in qapi/machine.json, storage-daemon
     will complain about the qmp cmds in qapi/machine.json during
     compiling.
 * Referred to Daniel's suggestion to introduce cache JSON list, though
   as a standalone object since -smp/-machine can't support JSON.
 * Linked machine's smp_cache to smp-cache object instead of a builtin
   structure. This is to get around the fact that the keyval format of
   -machine can't support JSON.
 * Wrapped the cache topology level access into a helper.
 * Split as a separate commit to just include compatibility checking and
   topology checking.
 * Allow setting "default" topology level even though the cache
   isn't supported by machine. (Daniel)
 * Rewrote the document of smp-cache object.

Main changes since RFC v1:
 * Split CpuTopology renaimg out of this RFC.
 * Use QAPI to enumerate CPU topology levels.
 * Drop string_to_cpu_topo() since QAPI will help to parse the topo
   levels.
 * Set has_*_cache field in machine_get_smp(). (JeeHeng)
 * Use "*_cache=topo_level" as -smp example as the original "level"
   term for a cache has a totally different meaning. (Jonathan)
---
Alireza Sanaee (1):
  i386/cpu: add has_caches flag to check smp_cache configuration

Zhao Liu (8):
  i386/cpu: Don't enumerate the "invalid" CPU topology level
  hw/core: Make CPU topology enumeration arch-agnostic
  qapi/qom: Define cache enumeration and properties for machine
  hw/core: Check smp cache topology support for machine
  hw/core: Add a helper to check the cache topology level
  i386/cpu: Support thread and module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -machine for PC machine

 hw/core/machine-smp.c      | 128 +++++++++++++++++++++
 hw/core/machine.c          |  44 ++++++++
 hw/i386/pc.c               |   4 +
 hw/i386/x86-common.c       |   4 +-
 include/hw/boards.h        |  19 ++++
 include/hw/i386/topology.h |  22 +---
 qapi/machine-common.json   |  94 +++++++++++++++-
 qemu-options.hx            |  31 ++++-
 target/i386/cpu.c          | 225 ++++++++++++++++++++++++-------------
 target/i386/cpu.h          |   4 +-
 10 files changed, 474 insertions(+), 101 deletions(-)

-- 
2.34.1


