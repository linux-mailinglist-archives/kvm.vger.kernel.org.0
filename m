Return-Path: <kvm+bounces-34781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12105A05F37
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA26D1889072
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAD319B586;
	Wed,  8 Jan 2025 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GgZig/2L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4AF1FCCF6
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347395; cv=none; b=i7HxA5MLfgKC67dD32PZCf12I5g1WeXDglJzc7TA5lUe/ZWdBzSjQoZX3Lr0otN+FvgXTVP4XQz//qE1rXaSLKnAmjd6ZfabF2ywVzqvhjKYyuNw91jOkoWvGtzUdDsDcUirOdydGxQnoxXypOMyNdWhe/xaC9AkigyE+f6tYz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347395; c=relaxed/simple;
	bh=8HbL3R0maWyTV35bsO/QEjd/9N1bmV+pEYCDDGAK5iA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N6d1gQFFxi27QhfiDiWddum/G6ktdgy54/6mw5OMv5J96fpSrn+3a5RE7VjqVwcKRztAYIOVM5m9R6IOCfgENa6DP7vW4BGX/aAaxPzHbtrmgOXwD5SKWTv2dPFJxfLo1eJ4SI+DcGycQ/1VAUWXQ2S2WYNFT3sVF1OdFl+36tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GgZig/2L; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736347394; x=1767883394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8HbL3R0maWyTV35bsO/QEjd/9N1bmV+pEYCDDGAK5iA=;
  b=GgZig/2LreakVxcdX4Grmrbi/JcLnK0k09Ss0rR3d8bPyCEi4LoU+Clr
   KDzCXmhFTwb9XkkIMsJShxe31X+2Q3EzH7hwVm+5n5zrE7Hj4nIW7gP0Q
   dAG0YiFMveERAuV6/mldPnxdwjpRhP3gd7//L2UfhK4j2ZX+ytiZ5GX0E
   prAmD9PKeZchvU82KOmc4JBMTiSM/8FJasb0z2HZRZJ00evCTo7rOqvq5
   a6WVl6PFKumfy5htQ1ATiSlH8uTvEnC2nC1uYjwmS9tOkob9cDckTMR8r
   Ux0KCyP8Husy8+scTvv3Hh9X1CkNqWF0zY0soqEZRuKUTLIBnvbpJIdzF
   w==;
X-CSE-ConnectionGUID: sjkDJEaaQtWlPuERyUjuUA==
X-CSE-MsgGUID: 39M4sf9pQNaYZ3HjarqfDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36737331"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36737331"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 06:43:13 -0800
X-CSE-ConnectionGUID: gEa0wccwQR23jwx9YNum2Q==
X-CSE-MsgGUID: QmPF3t3GQnSNNwgQ+iEEkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103969384"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 08 Jan 2025 06:43:09 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v7 0/5] i386: Support SMP Cache Topology
Date: Wed,  8 Jan 2025 23:01:45 +0800
Message-Id: <20250108150150.1258529-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is my v7.

Compared with v6 [1], v7 dropped the "thread" level cache topology
(cache per thread):

 - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
 - Ptach 2 dropped cache per thread support.
 (Others remain unchanged.)

There're several reasons:

 * Currently, neither i386 nor ARM have real hardware support for per-
   thread cache.
 * Supporting this special cache topology on ARM requires extra effort
   [2].

So it is unnecessary to support it at this moment, even though per-
thread cache might have potential scheduling benefits for VMs without
CPU affinity.

In the future, if there is a clear demand for this feature, the correct
approach would be to add a new control field in MachineClass.smp_props
and enable it only for the machines that require it.


This series is based on the master branch at commit aa3a285b5bc5 ("Merge
tag 'mem-2024-12-21' of https://github.com/davidhildenbrand/qemu into
staging").

Smp-cache support of ARM side can be found at [3].


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

The API design has been discussed heavily in [4].

Now, smp-cache is implemented as a array integrated in -machine. Though
-machine currently can't support JSON format, this is the one of the
directions of future.

An example is as follows:

smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die

"cache" specifies the cache that the properties will be applied on. This
field is the combination of cache level and cache type. Now it supports
"l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
cache) and "l3" (L3 unified cache).

"topology" field accepts CPU topology levels including "core", "module",
"cluster", "die", "socket", "book", "drawer" and a special value
"default". (Note, now, in v7, smp-cache doesn't support "thread".)

The "default" is introduced to make it easier for libvirt to set a
default parameter value without having to care about the specific
machine (because currently there is no proper way for machine to
expose supported topology levels and caches).

If "default" is set, then the cache topology will follow the
architecture's default cache topology model. If other CPU topology level
is set, the cache will be shared at corresponding CPU topology level.


[1]: Patch v6: https://lore.kernel.org/qemu-devel/20241219083237.265419-1-zhao1.liu@intel.com/
[2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/Z3efFsigJ6SxhqMf@intel.com/#t
[3]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20250102152012.1049-1-alireza.sanaee@huawei.com/
[4]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/

Thanks and Best Regards,
Zhao
---
Alireza Sanaee (1):
  i386/cpu: add has_caches flag to check smp_cache configuration

Zhao Liu (4):
  hw/core/machine: Reject thread level cache
  i386/cpu: Support module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -machine for PC machine

 hw/core/machine-smp.c |  9 ++++++
 hw/i386/pc.c          |  4 +++
 include/hw/boards.h   |  3 ++
 qemu-options.hx       | 30 +++++++++++++++++-
 target/i386/cpu.c     | 71 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 115 insertions(+), 2 deletions(-)

-- 
2.34.1


