Return-Path: <kvm+bounces-35049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A7BBA09386
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 830683A7FCF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224B7211285;
	Fri, 10 Jan 2025 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AlnnWZ2K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D02211269
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519572; cv=none; b=Nfzs3UUgypOvfq2ZU/qn2Ih+rn59f87mORQgkP6w824OJG4shbarpghMzM+R9Y+RGFc/zxEfTtQ1tkSK5YzHi5b1ZHVahm1GfZODRJJdDLZh1bivjTG+QGJxYFOoMh5L6sMbFJhZUFpFyfJDI5C/qVoQLSV2MB+5+8nkXTxciAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519572; c=relaxed/simple;
	bh=wQakl14sIa/TQlT+I/DKr4worOCNT8tEroVig3IR2oY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d66GUSiwW76UtADVsYCIt2BnFWdRpFV6tejVwSWfaD02Tbt+sF3PrZvoWvJiexZcvfJ4Ccp79ElIs1wxThyBLkPQDwQdj/puo1+79pX2kCXSoc8r9aPBMGVq9xU0odhVRGBnH6NndiW1LUyRoPGpPrj4HZkpfXojB97j8qlQ2OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AlnnWZ2K; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736519570; x=1768055570;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wQakl14sIa/TQlT+I/DKr4worOCNT8tEroVig3IR2oY=;
  b=AlnnWZ2K05VYUSy3/332f1r2sDqpJlHEzZHAFiM+8/sbn6QXWGA4cIrD
   22rtvqhiMrDUdBaLLb9XFSfuopj/Ni2DqvnXifcK/Df9CtJUKz3Rr/psu
   1dFnVimldE/VvMAbMxN3XgCRKUyBMgmfV0ehcp6yUyJnoUYuKeXN+YEue
   Y1FcytikqiViA7FYlTnBHs9wKLaAMUE078kCQAJSiYMJiJ3vjMT+G21X3
   CDUbI1afjRaYioSaxaZJR7lUqebMd44Uuc/j9+3b/iriC2R8LWLeOY8fa
   vT7STmls6co4km92scSWKlVCBoQj9ySxF+RLvuqk9ikvByAugFNsLdVDp
   A==;
X-CSE-ConnectionGUID: dx4NRdqiSkiqqcITWMiwuQ==
X-CSE-MsgGUID: ptml8DJFQ26u4WKEnFwQrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="62185483"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="62185483"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:32:49 -0800
X-CSE-ConnectionGUID: 1NZVCdmoSluNKfvaeEt6Dg==
X-CSE-MsgGUID: +ATDI3lWQk+/tDoMUiKj2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108790792"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 10 Jan 2025 06:32:45 -0800
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
Subject: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
Date: Fri, 10 Jan 2025 22:51:10 +0800
Message-Id: <20250110145115.1574345-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is my v7 resend version (updated the commit message of origin
v7's Patch 1).

Compared with v6 [1], v7 dropped the "thread" level cache topology
(cache per thread):

 - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
 - Ptach 2 dropped cache per thread support.
 (Others remain unchanged.)

There're several reasons:

 * Currently, neither i386 nor ARM have real hardware support for per-
   thread cache.
 * ARM can't support thread level cache in device tree. [2].

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
[2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/20250110114100.00002296@huawei.com/T/#m50c37fa5d372feac8e607c279cd446da3e22a12c
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


