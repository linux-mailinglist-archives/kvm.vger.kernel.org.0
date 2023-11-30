Return-Path: <kvm+bounces-2963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A9F7FF225
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73124283F8D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18BD51C3B;
	Thu, 30 Nov 2023 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="exK3TbKc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5778F85
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354999; x=1732890999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lndGadsp6lchipVix45sBuugJYcXf54DoIQPmPepLjo=;
  b=exK3TbKcCs0owewPv/WFz2vsMLYUmyYVEKIyhJFkeGt/8DTAJjQbAF6I
   +8fJzfd+eyeCnnZWxFgCNDG9Fhppf5tOhm1Jww6p18kB9kZ15sfx3f3za
   hOJ5J+0y5FisNJttHJe9/zPrOmMBMz4l7wmzVVM01QH6hIx+uUEHQ8B1k
   Jw229EED8E8JwdApsUkp1OU3vAUH5W6YdJuNjb9ymwC6yHxrdT3+6r89p
   ca9EgBOe2CLTnHse9nnPKp3BmVHXzOGQtmMg4YdgL1B6rvzyH7Vy+UBnY
   K3N+TPkK9ZzLTBWtvmra3oFnYSH1qxGhfof1mB3JaygykfeowSEHkGuez
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532681"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532681"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:36:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730506"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730506"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:14 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 37/41] hw/i386: Allow i386 to create new CPUs from QOM topology
Date: Thu, 30 Nov 2023 22:41:59 +0800
Message-Id: <20231130144203.2307629-38-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

For QOM topology, maximum number of CPUs and the number of plugged CPUs
are configured in core level.

Iterate through all the cpu-cores to determine how many CPUs should be
created in each cpu-core.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 3c99f4c3ab51..febffed92a83 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -152,9 +152,35 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
     }
 
     possible_cpus = mc->possible_cpu_arch_ids(ms);
-    for (i = 0; i < ms->smp.cpus; i++) {
-        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id,
-                    NULL, i, &error_fatal);
+
+    /*
+     * possible_cpus_qom_granu means the QOM topology support.
+     *
+     * TODO: Drop the "!mc->smp_props.possible_cpus_qom_granu" case when
+     * i386 completes QOM topology support.
+     */
+    if (mc->smp_props.possible_cpus_qom_granu) {
+        CPUCore *core;
+        int cpu_index = 0;
+        int core_idx = 0;
+
+        MACHINE_CORE_FOREACH(ms, core) {
+            for (i = 0; i < core->plugged_threads; i++) {
+                x86_cpu_new(x86ms, possible_cpus->cpus[cpu_index].arch_id,
+                            OBJECT(core), cpu_index, &error_fatal);
+                cpu_index++;
+            }
+
+            if (core->plugged_threads < core->nr_threads) {
+                cpu_index += core->nr_threads - core->plugged_threads;
+            }
+            core_idx++;
+        }
+    } else {
+        for (i = 0; i < ms->smp.cpus; i++) {
+            x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id,
+                        NULL, i, &error_fatal);
+        }
     }
 }
 
-- 
2.34.1


