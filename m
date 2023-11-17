Return-Path: <kvm+bounces-1922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3867EECC2
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F06241F224D4
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B921118D;
	Fri, 17 Nov 2023 07:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BprgpTGC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31094D51
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206788; x=1731742788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ru+xsMo5O18Ysv5/OaA6hVZFHETPTpuNOeacSlFbQ4A=;
  b=BprgpTGCpneAK4z/htulso8bewaatHw7aGFCT6030Jn52Zw1hibCGQ5F
   A+zyWHfNHebink1MS6JMQFoPBaDrGYnAR8Ijsc85SFlL5vdJ0qofz26ko
   ew3PDfbTBAx3aJ1SNYLs+JRktNhSn415IOa2lbi3pR+J4CystQU+NeLZY
   4m0cK3kbZpcXvH1MFUUc5mUeo+2+FK5t785onNx5EoBBTLxqCfJToxvU5
   k79SlAWfKmH+pfGLjhNZmjad0cJLIIw7wTF9gnrXsibIZr1upO/fReUO4
   L1mXg2SeTqLsHOGxFEpruD0YhhY1Zcm2OPnCTOkxLS1uRQPRLrcnD+cE1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180332"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180332"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:39:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042711"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042711"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:39:43 -0800
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
Subject: [PATCH v6 06/16] i386: Introduce module-level cpu topology to CPUX86State
Date: Fri, 17 Nov 2023 15:50:56 +0800
Message-Id: <20231117075106.432499-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
References: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
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
index b3d054889bba..24628c1d2f73 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -306,6 +306,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     init_topo_info(&topo_info, x86ms);
 
     env->nr_dies = ms->smp.dies;
+    env->nr_modules = ms->smp.clusters;
 
     /*
      * If APIC ID is not set,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1713499c44cd..f600c0ee9df1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7698,6 +7698,7 @@ static void x86_cpu_initfn(Object *obj)
     CPUX86State *env = &cpu->env;
 
     env->nr_dies = 1;
+    env->nr_modules = 1;
 
     object_property_add(obj, "feature-words", "X86CPUFeatureWordInfo",
                         x86_cpu_get_feature_words,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a214d056ac4b..da58d41c9969 100644
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


