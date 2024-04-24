Return-Path: <kvm+bounces-15836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 631868B0EAF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E20EC1F2B45A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7219916C87B;
	Wed, 24 Apr 2024 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvUTYMD5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF313D893
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973049; cv=none; b=W2mVpac0j4xYOpCI14eV6BKLnh1/quUfZ3K+6KNUfueD06pPYoQ4aHGD3bv5Xoai4/XT0UquZmIMGdGb06QtcPlinxvsuR9Trv81MxtlzREk3s7pfNx6WjuSxrtnGJRkJWoBu4bbv1UfR0aYRdTViXVjb17pEdgF0UxWTh/iBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973049; c=relaxed/simple;
	bh=7BZitRTZgHvSoVHH6B/n9vW2IiXDZrdhO0sh04YdlOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b1rShX3jnMlnXPF0UvIRXBKnOnCXj9XWji7UHovEtj84X9BjeyJBhveQroKCRdJ7yqJxtSkuhnJ9Kqn9bHDk3QgmGt/adRFmj2pNj4Cwx6rHgVNCproKVSIwJcc2+l+N+HaVEonLZ1rKhqAluA9FrIdxDMJMDDNxQv1XsFyFGwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvUTYMD5; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973048; x=1745509048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7BZitRTZgHvSoVHH6B/n9vW2IiXDZrdhO0sh04YdlOI=;
  b=hvUTYMD5z1JBwLHxZ4Oe9tkSlE73XSITwyLlIco/rHwbGjcjyWU1dYj1
   Qyj9JIu9WcM471HS0uE6luFmh1kcLDg9KtkPRBoaAU+x5hFt0m0C9hKMg
   oOQNahI26kU66uTkrFS+mOxUcB2UUGA/dtIU7YQa7McGwtZvxWPMcDL2p
   TDSRUg2NXmZ5IRoU1hoFL3QaWQeM13Bm6j0IkmP0JXsdM+58JAVsyfijr
   g0G8atZurOYTCgFoqgk4MK0sSE+Zn5lXcHH6bYba6u3oCm6T5LRBEgYEx
   o4ePVLqfsLiFNXDGDYmNDN0kwCelU1lk8mVqSVAwRrO7RA6u0td0NFnP5
   g==;
X-CSE-ConnectionGUID: y8nqCB9gTVC80RcDIqUvFw==
X-CSE-MsgGUID: gbGcuMYRR0KrsbmcHvSvkA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545819"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545819"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:37:25 -0700
X-CSE-ConnectionGUID: 1qityOk/TbenJ6PscERgVQ==
X-CSE-MsgGUID: miNxteewQtO+tFPR/C48sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363337"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:37:21 -0700
From: Zhao Liu <zhao1.liu@intel.com>
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
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v11 18/21] hw/i386/pc: Support smp.modules for x86 PC machine
Date: Wed, 24 Apr 2024 23:49:26 +0800
Message-Id: <20240424154929.1487382-19-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As module-level topology support is added to X86CPU, now we can enable
the support for the modules parameter on PC machines. With this support,
we can define a 5-level x86 CPU topology with "-smp":

-smp cpus=*,maxcpus=*,sockets=*,dies=*,modules=*,cores=*,threads=*.

So, add the 5-level topology example in description of "-smp".

Additionally, add the missed drawers and books options in previous
example.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
---
Changes since v9:
 * Mentioned the change about adding missed drawers and books. (Babu)

Changes since v8:
 * Added missing "modules" parameter in -smp example.

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
index 08c7de416fda..6d2ad5d663d2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1839,6 +1839,7 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->default_cpu_type = TARGET_DEFAULT_CPU_TYPE;
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
+    mc->smp_props.modules_supported = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_AUTO;
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 8ce85d45598d..eddd3595c7b9 100644
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


