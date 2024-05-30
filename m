Return-Path: <kvm+bounces-18387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA478D4917
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FF69283B9E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21D6176195;
	Thu, 30 May 2024 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SEnRcd1h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25926F2E6
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063266; cv=none; b=GydcRALoWY3oSlyajVaskJuRZtbVpVeTs+SnM5+2Fzlcsi6rynHXuyIaVfwUt8pV1+gVSjjeIzbOeMSmYpYyZSvvecE8PN4AVIMCWbLS5xsOUlDAlLZalGmccHOaT4xyItSvnmz696UnlyOkBTgc+HXoKUUdbzqMgWA1LJDTBYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063266; c=relaxed/simple;
	bh=kd8Iqz6IxYjau87nIpOYyMS3R+5juiDyGSjeB2FuXwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YzBsfejl4xsJM8FEzJ7v5NOQJzPgfSDuaML2eByPrI5ViaxdnyMQ6NW05uHnJ/RHFyvuwCQM8Rz6wUfVyQ5/YY6DDUtbg+fupq/+Z5ggMya11vyGYSEZHtjFEb0z7RQfFzNj6zk9O+Nr7HeY+mycUes0RnZuhyzGP9v8fw4DxxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SEnRcd1h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063264; x=1748599264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kd8Iqz6IxYjau87nIpOYyMS3R+5juiDyGSjeB2FuXwE=;
  b=SEnRcd1hqUHNdT6aSEyj7j8KIYEEtEPZSHVoSBXobY3Xovo2sROBkIPH
   Ek3Ox21ZyuNVFvKkkZoCx9+ZCR/dkdf7ZV4LId3I3YIhQ4iej9CJEX6de
   wMLLacM9O7vIb5BZ9jmr9EXvRUaIXfyzLl4TfruZlkPqPcCnEBoKK1fzV
   Byicw4bkcHAkug/ueS/f2Iap4IxZL3yUNv8Ew8lwMwstPYbg55TaIZxxi
   KZWXTnoYnd8ep+Di20jClZ7N5AFGGl8bog5gIEku+VyM3BdmMKKUU6c8J
   DAlheBvlPUcqHbOEJq6mKzlES6uBfKaWDzsKr5W9D00zV1f1pct26tWqr
   Q==;
X-CSE-ConnectionGUID: ULvn4H3IQbWDOtpLi9OxAQ==
X-CSE-MsgGUID: R01b5odOQFy9fhOQaLbI1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032641"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032641"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:01:04 -0700
X-CSE-ConnectionGUID: SyRY+RB0TV6YokdKL/13XA==
X-CSE-MsgGUID: aFRS7jt6QPWbeEZPIX3Qmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705172"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:58 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 7/7] qemu-options: Add the cache topology description of -smp
Date: Thu, 30 May 2024 18:15:39 +0800
Message-Id: <20240530101539.768484-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Use "*_cache=topo_level" as -smp example as the original "level"
   term for a cache has a totally different meaning. (Jonathan)
---
 qemu-options.hx | 50 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/qemu-options.hx b/qemu-options.hx
index 8ca7f34ef0c8..29d8a4b9b68b 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -282,7 +282,8 @@ ERST
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
     "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
-    "               [,threads=threads]\n"
+    "               [,threads=threads][,l1d-cache=topo_level][,l1i-cache=topo_level]\n"
+    "               [,l2-cache=topo_level][,l3-cache=topo_level]\n"
     "                set the number of initial CPUs to 'n' [default=1]\n"
     "                maxcpus= maximum number of total CPUs, including\n"
     "                offline CPUs for hotplug, etc\n"
@@ -294,7 +295,11 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "                modules= number of modules in one cluster\n"
     "                cores= number of cores in one module\n"
     "                threads= number of threads in one core\n"
-    "Note: Different machines may have different subsets of the CPU topology\n"
+    "                l1d-cache= topology level of L1 D-cache\n"
+    "                l1i-cache= topology level of L1 I-cache\n"
+    "                l2-cache= topology level of L2 cache\n"
+    "                l3-cache= topology level of L3 cache\n"
+    "Note: Different machines may have different subsets of the CPU and cache topology\n"
     "      parameters supported, so the actual meaning of the supported parameters\n"
     "      will vary accordingly. For example, for a machine type that supports a\n"
     "      three-level CPU hierarchy of sockets/cores/threads, the parameters will\n"
@@ -308,7 +313,7 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
     "      must be set as 1 in the purpose of correct parsing.\n",
     QEMU_ARCH_ALL)
 SRST
-``-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,modules=modules][,cores=cores][,threads=threads]``
+``-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,modules=modules][,cores=cores][,threads=threads][,l1d-cache=topo_level][,l1i-cache=topo_level][,l2-cache=topo_level][,l3-cache=topo_level]``
     Simulate a SMP system with '\ ``n``\ ' CPUs initially present on
     the machine type board. On boards supporting CPU hotplug, the optional
     '\ ``maxcpus``\ ' parameter can be set to enable further CPUs to be
@@ -322,15 +327,34 @@ SRST
     Both parameters are subject to an upper limit that is determined by
     the specific machine type chosen.
 
+    CPU topology parameters include '\ ``drawers``\ ', '\ ``books``\ ',
+    '\ ``sockets``\ ', '\ ``dies``\ ', '\ ``clusters``\ ', '\ ``modules``\ ',
+    '\ ``cores``\ ' and '\ ``threads``\ '. These CPU parameters accept only
+    integers and are used to specify the number of specific topology domains
+    under the corresponding topology level.
+
     To control reporting of CPU topology information, values of the topology
     parameters can be specified. Machines may only support a subset of the
-    parameters and different machines may have different subsets supported
-    which vary depending on capacity of the corresponding CPU targets. So
-    for a particular machine type board, an expected topology hierarchy can
+    CPU topology parameters and different machines may have different subsets
+    supported which vary depending on capacity of the corresponding CPU targets.
+    So for a particular machine type board, an expected topology hierarchy can
     be defined through the supported sub-option. Unsupported parameters can
     also be provided in addition to the sub-option, but their values must be
     set as 1 in the purpose of correct parsing.
 
+    Cache topology parameters include '\ ``l1d-cache``\ ', '\ ``l1i-cache``\ ',
+    '\ ``l2-cache``\ ' and '\ ``l3-cache``\ '. These cache topology parameters
+    accept the strings of CPU topology levels (such as '\ ``drawer``\ ', '\ ``book``\ ',
+    '\ ``socket``\ ', '\ ``die``\ ', '\ ``cluster``\ ', '\ ``module``\ ',
+    '\ ``core``\ ' or '\ ``thread``\ '). Exactly which topology level strings
+    could be accepted as the parameter depends on the machine's support for the
+    corresponding CPU topology level.
+
+    Machines may also only support a subset of the cache topology parameters.
+    Unsupported cache topology parameters will be omitted, and correspondingly,
+    the target CPU's cache topology will use the its default cache topology
+    setting.
+
     Either the initial CPU count, or at least one of the topology parameters
     must be specified. The specified parameters must be greater than zero,
     explicit configuration like "cpus=0" is not allowed. Values for any
@@ -356,6 +380,20 @@ SRST
 
         -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32
 
+    The following sub-option defines a CPU topology hierarchy (2 sockets
+    totally on the machine, 2 dies per socket, 2 modules per die, 2 cores per
+    module, 2 threads per core) with 3-level cache topology hierarchy (L1
+    D-cache per core, L1 I-cache per core, L2 cache per core and L3 cache per
+    die) for PC machines which support sockets/dies/modules/cores/threads.
+    Some members of the CPU topology option can be omitted but their values
+    will be automatically computed. Some members of the cache topology
+    option can also be omitted and target CPU will use the default topology.:
+
+    ::
+
+        -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
+             l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
+
     The following sub-option defines a CPU topology hierarchy (2 sockets
     totally on the machine, 2 clusters per socket, 2 cores per cluster,
     2 threads per core) for ARM virt machines which support sockets/clusters
-- 
2.34.1


