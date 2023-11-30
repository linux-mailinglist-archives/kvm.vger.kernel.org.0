Return-Path: <kvm+bounces-2962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB227FF224
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 252A21F20F31
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33FB51016;
	Thu, 30 Nov 2023 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3oP/Eiu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CAB93
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354997; x=1732890997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xvYlraOGB3zayUrWIK0PscKH2Ic2SrgqXJLGzTM1XXI=;
  b=R3oP/EiuHLp4tWWidcKn/6eBcTXuVo5EV8QyR6kyBn+veonJlETWYukN
   eRk/NZbaNxkYREgeR1lyL21m9mAlP2swg3uqgUFuvAWNxFTrWaDZcrZ8t
   VMfQmyOcZKR6C9ZX0YKsuahsKka9YCNODQt1jGaSpuyaQPY5OL4d7zbN7
   sNMN9aV2qMfKgFZxkolSbe/zpv7UpdL8bE9/e7+DsP1JEfEV6AbvT1TZc
   qybuzT/y+bpgAwkPayF/7BxUjm47acDCV05vi8rktjSPSGEte1BRFLu6z
   ldK/+kYpXvCw5JUL/mTX/7wzOUxOdTpQgaZnUq24tnc47ZU3W7mSlQvC5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532645"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532645"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:36:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730473"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730473"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:03 -0800
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
Subject: [RFC 36/41] hw/i386: Allow x86_cpu_new() to specify parent for new CPU
Date: Thu, 30 Nov 2023 22:41:58 +0800
Message-Id: <20231130144203.2307629-37-zhao1.liu@linux.intel.com>
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

For QOM topology, CPU should be inserted under its parent core.

Extend x86_cpu_new() to allow caller to specify topology parent.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index d9293846db64..3c99f4c3ab51 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -94,15 +94,22 @@ uint32_t x86_cpu_apic_id_from_index(X86MachineState *x86ms,
     return x86_apicid_from_cpu_idx(&topo_info, cpu_index);
 }
 
-
 static void x86_cpu_new(X86MachineState *x86ms, int64_t apic_id,
-                        Error **errp)
+                        Object *parent, int index, Error **errp)
 {
-    Object *cpu = object_new(MACHINE(x86ms)->cpu_type);
+    const char *cpu_type = MACHINE(x86ms)->cpu_type;
+    Object *cpu = object_new(cpu_type);
 
     if (!object_property_set_uint(cpu, "apic-id", apic_id, errp)) {
         goto out;
     }
+
+    if (parent) {
+        char *name = g_strdup_printf("%s[%d]", cpu_type, index);
+        object_property_add_child(parent, name, cpu);
+        g_free(name);
+    }
+
     qdev_realize(DEVICE(cpu), NULL, errp);
 
 out:
@@ -146,7 +153,8 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
-        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
+        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id,
+                    NULL, i, &error_fatal);
     }
 }
 
-- 
2.34.1


