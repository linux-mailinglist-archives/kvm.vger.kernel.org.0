Return-Path: <kvm+bounces-5780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3846682692C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50E451C20951
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 08:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CC8B661;
	Mon,  8 Jan 2024 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8a6fdbH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629010A2C
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704701698; x=1736237698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xMM9uHYzZgcNWhqwDNJq2lnGBNKGHDs1fTg/xiT5xz4=;
  b=Q8a6fdbHEVHtPkRTZFzESwwUwrwOS6Q9N/mC1aaecL0JKoEmU/PDzTZo
   I1K/5EWZONgWglsJYtUluKEsA+2SkdhuQotBIwqxwAaaise+eTRTXZ9Pz
   DYIgV8VTp7c/SlcGu+/Uwa7HyyPcc2qFVArty26rWWpJbPrm38wFbadHs
   0gd3+eOsJnEmp9LpWDOHksqVn+7RdKBp1lWTSZf8tVwSE0JVXAO9khRhU
   xCkHJFgEV0tYb36DN7Y1Hp+gleZqfJtwtCcFhWmbwIj31uvWIKUPIDsu+
   cuwvKvYPutRPtw7kyugza43ScCY779whWShiwJEvJpUW02igxFIB8eeSQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="16419968"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="16419968"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:14:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="15850187"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jan 2024 00:14:54 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 06/16] i386: Introduce module-level cpu topology to CPUX86State
Date: Mon,  8 Jan 2024 16:27:17 +0800
Message-Id: <20240108082727.420817-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

smp command has the "clusters" parameter but x86 hasn't supported that
level. "cluster" is a CPU topology level concept above cores, in which
the cores may share some resources (L2 cache or some others like L3
cache tags, depending on the Archs) [1][2]. For x86, the resource shared
by cores at the cluster level is mainly the L2 cache.

However, using cluster to define x86's L2 cache topology will cause the
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

"cluster" in smp is the CPU topology level which is between "core" and
die.

For x86, the "cluster" in smp is corresponding to the module level [2],
which is above the core level. So use the "module" other than "cluster"
in i386 code.

And please note that x86 already has a cpu topology level also named
"cluster" [3], this level is at the upper level of the package. Here,
the cluster in x86 cpu topology is completely different from the
"clusters" as the smp parameter. After the module level is introduced,
the cluster as the smp parameter will actually refer to the module level
of x86.

[1]: 864c3b5c32f0 ("hw/core/machine: Introduce CPU cluster topology support")
[2]: Yanan's comment about "cluster",
     https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
[3]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.

Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v1:
 * The background of the introduction of the "cluster" parameter and its
   exact meaning were revised according to Yanan's explanation. (Yanan)
---
 hw/i386/x86.c     | 1 +
 target/i386/cpu.c | 1 +
 target/i386/cpu.h | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 2b6291ad8d5f..1d19a8c609b1 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -310,6 +310,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     init_topo_info(&topo_info, x86ms);
 
     env->nr_dies = ms->smp.dies;
+    env->nr_modules = ms->smp.clusters;
 
     /*
      * If APIC ID is not set,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5c295c9a9e2d..0a2ce9b92b1f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7699,6 +7699,7 @@ static void x86_cpu_initfn(Object *obj)
     CPUX86State *env = &cpu->env;
 
     env->nr_dies = 1;
+    env->nr_modules = 1;
 
     object_property_add(obj, "feature-words", "X86CPUFeatureWordInfo",
                         x86_cpu_get_feature_words,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9c78cfc3f322..eecd30bde92b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1904,6 +1904,11 @@ typedef struct CPUArchState {
 
     /* Number of dies within this CPU package. */
     unsigned nr_dies;
+    /*
+     * Number of modules within this CPU package.
+     * Module level in x86 cpu topology is corresponding to smp.clusters.
+     */
+    unsigned nr_modules;
 } CPUX86State;
 
 struct kvm_msrs;
-- 
2.34.1


