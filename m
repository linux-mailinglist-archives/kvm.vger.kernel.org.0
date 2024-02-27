Return-Path: <kvm+bounces-10064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31753868D58
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550421C24DCF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F0C139594;
	Tue, 27 Feb 2024 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBFmhuN4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E8139566
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029229; cv=none; b=ECKZRKeScaxNAwSbY7zcm74vUZgZM6wlRQTiOv0Q858z+7an5S43o1JhfkfuMsjZy9+yibrQWLKajKPVWoLjzamb8RCesRyW98yvT2r8QNPkDAu4vzpD+PIKEP+OXICSsqN/AfyuaaTZ+k0ganS3QdqTq+YFzIcIsr8m/Dlsdgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029229; c=relaxed/simple;
	bh=8+96PePSRKtenIK/x5fCLFSm4clWmWTXdDfDGZmt7YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wsxpf1Zq0C7/N1iIPKoh0JIiV82gnoUo5WRc1dVXtNi0ITF/CME89eG+b5iwFCEo0rwOUC1A9xS9mv0MnYw8SZ7rgCe2EfN5IO1Pch8N2kgiuuD/DUCX//+4yLLZZgPNibagISnciCcloC0hVQzYeecvdgMOqK1VK0rzqErYRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBFmhuN4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029228; x=1740565228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+96PePSRKtenIK/x5fCLFSm4clWmWTXdDfDGZmt7YE=;
  b=bBFmhuN4bYMSUX+SBwj3PfUbQO4itkLfP1xrU4mozmVTGbf1U0SLcrKQ
   xYxBlCZL0cRmGJ2kXcx9muYhSj9oNDOOsA2oWtmlHkoads19YXcCiCpUT
   gfZsXptJ0y6SCoEIZV+8mlOWqb3COWvBhuwdrlB9wen1kODabu6DQjkQT
   eaSoKTwA8klMpxkXV5h/sTAVz0ITblasTYFmRHhCFAuRTGBv54fIZ+7pe
   UgS/ZiAzF8aC9n4guun2ksD7n0cwSVmmXUiQEBLLIWJaQWqJT19TOl0Yx
   LZ4adozCftn+ryQb8Hjwip49lcv/8ubcoaBtf6aCA8zWP7VODMBBdiGKj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310463"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310463"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:20:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6955175"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:20:17 -0800
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
Subject: [PATCH v9 18/21] hw/i386/pc: Support smp.modules for x86 PC machine
Date: Tue, 27 Feb 2024 18:32:28 +0800
Message-Id: <20240227103231.1556302-19-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

As module-level topology support is added to X86CPU, now we can enable
the support for the modules parameter on PC machines. With this support,
we can define a 5-level x86 CPU topology with "-smp":

-smp cpus=*,maxcpus=*,sockets=*,dies=*,modules=*,cores=*,threads=*.

Additionally, add the 5-level topology example in description of "-smp".

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v8:
 * Add missing "modules" parameter in -smp example.

Changes since v7:
 * Supported modules instead of clusters for PC.
 * Dropped Michael/Babu/Yanan's ACKed/Tested/Reviewed tags since the
   code change.
 * Re-added Yongwei's Tested tag For his re-testing.
---
 hw/i386/pc.c    |  1 +
 qemu-options.hx | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f8eb684a4926..b270a66605fc 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1830,6 +1830,7 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->default_cpu_type = TARGET_DEFAULT_CPU_TYPE;
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
+    mc->smp_props.modules_supported = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_64;
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 9be1e5817c7d..b5784fda32cb 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -281,7 +281,8 @@ ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
-    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
+    "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
+    "               [,threads=threads]\n"
     "                set the number of initial CPUs to 'n' [default=1]\n"
     "                maxcpus= maximum number of total CPUs, including\n"
     "                offline CPUs for hotplug, etc\n"
@@ -290,7 +291,8 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "                sockets= number of sockets in one book\n"
     "                dies= number of dies in one socket\n"
     "                clusters= number of clusters in one die\n"
-    "                cores= number of cores in one cluster\n"
+    "                modules= number of modules in one cluster\n"
+    "                cores= number of cores in one module\n"
     "                threads= number of threads in one core\n"
     "Note: Different machines may have different subsets of the CPU topology\n"
     "      parameters supported, so the actual meaning of the supported parameters\n"
@@ -306,7 +308,7 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "      must be set as 1 in the purpose of correct parsing.\n",
     QEMU_ARCH_ALL)
 SRST
-``-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]``
+``-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,modules=modules][,cores=cores][,threads=threads]``
     Simulate a SMP system with '\ ``n``\ ' CPUs initially present on
     the machine type board. On boards supporting CPU hotplug, the optional
     '\ ``maxcpus``\ ' parameter can be set to enable further CPUs to be
@@ -345,14 +347,14 @@ SRST
         -smp 8,sockets=2,cores=2,threads=2,maxcpus=8
 
     The following sub-option defines a CPU topology hierarchy (2 sockets
-    totally on the machine, 2 dies per socket, 2 cores per die, 2 threads
-    per core) for PC machines which support sockets/dies/cores/threads.
-    Some members of the option can be omitted but their values will be
-    automatically computed:
+    totally on the machine, 2 dies per socket, 2 modules per die, 2 cores per
+    module, 2 threads per core) for PC machines which support sockets/dies
+    /modules/cores/threads. Some members of the option can be omitted but
+    their values will be automatically computed:
 
     ::
 
-        -smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16
+        -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32
 
     The following sub-option defines a CPU topology hierarchy (2 sockets
     totally on the machine, 2 clusters per socket, 2 cores per cluster,
-- 
2.34.1


