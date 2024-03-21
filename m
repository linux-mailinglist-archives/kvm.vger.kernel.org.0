Return-Path: <kvm+bounces-12394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CD6885AB8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9192EB232AA
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CEE86255;
	Thu, 21 Mar 2024 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nopo0el1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CA557315
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031294; cv=none; b=K097DQBlW7N1pDZ8G7OJz/7rzDsREHcTM4UOXwicGEk0WLz8wx4cU2PikmUOfb3eEKYiCEXdR+6ORNMAp0U8eBtu5vNn1FwyiLIFpnbDNzt70dgUgpaqLiKjOPsXXRv3SKKMKJatmyhLtcddtu7c6gPG2g7WhvrAK7c07/vDgww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031294; c=relaxed/simple;
	bh=lnijkzk6Qfg24tQGPl1L9Sow5hvow7RxZfOVxF2Uz0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pY96eW1gILxvZTz+mC2ITKQljT4HQWtjp0m34Y7dZeGkp5TS/FgE8h6Si6FDoCPs6FrlnoSlNEPh5ShsvPU30IwO5hq6/0FdvBu1DpuZkGpOhgwgQFfwnf1KA5GVzGn5V2oh2++PCqIu9P6cX2hsZUyis63rzd+3D4M+kQFMqMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nopo0el1; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031294; x=1742567294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lnijkzk6Qfg24tQGPl1L9Sow5hvow7RxZfOVxF2Uz0k=;
  b=nopo0el1cXsZYvTVmmtsZnD379SpecqErGRyXBSpY00ie1qND3QHAaq7
   RumwkzkUdwjT9L42J9bUi5gvQOHG7zKwPb4FZOL7aWvrIGDkExhNXv8LF
   rdHylMbps/jbWzop9rfqlVquyOgC+s6mYGyDtznGW1FU6KaZNE7VZdUUz
   AyQLXWqzwGHWRF3SGPZnCkVr8apKEVwTb/xROuJubkDAdyvBQA2ZnpNgB
   xcGvtN1SCF82OKNRrANsyj92H+wiwzidcwJ9QuSVwY3KI4Wfd3EubbjrD
   nAUAUrkFBpaISIpudyH7FPknCGH8xDqvMtlOtTFNIFOMi4hhJvbnnVlEj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806526"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806526"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:28:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14528152"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:28:08 -0700
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
Subject: [PATCH v10 12/21] i386: Introduce module level cpu topology to CPUX86State
Date: Thu, 21 Mar 2024 22:40:39 +0800
Message-Id: <20240321144048.3699388-13-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Intel CPUs implement module level on hybrid client products (e.g.,
ADL-N, MTL, etc) and E-core server products.

A module contains a set of cores that share certain resources (in
current products, the resource usually includes L2 cache, as well as
module scoped features and MSRs).

Module level support is the prerequisite for L2 cache topology on
module level. With module level, we can implement the Guest's CPU
topology and future cache topology to be consistent with the Host's on
Intel hybrid client/E-core server platforms.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v7:
 * Mapped x86 module to smp module instead of cluster.
 * Re-wrote the commit message to explain the reason why we needs module
   level.
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v1:
 * The background of the introduction of the "cluster" parameter and its
   exact meaning were revised according to Yanan's explanation. (Yanan)
---
 hw/i386/x86.c     | 5 +++++
 target/i386/cpu.c | 1 +
 target/i386/cpu.h | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 0a6c59c724f1..7c94d366af03 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -313,6 +313,11 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     init_topo_info(&topo_info, x86ms);
 
+    if (ms->smp.modules > 1) {
+        env->nr_modules = ms->smp.modules;
+        /* TODO: Expose module level in CPUID[0x1F]. */
+    }
+
     if (ms->smp.dies > 1) {
         env->nr_dies = ms->smp.dies;
         set_bit(CPU_TOPO_LEVEL_DIE, env->avail_cpu_topo);
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 92d85e920015..b8917c412175 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7717,6 +7717,7 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
 
+    env->nr_modules = 1;
     env->nr_dies = 1;
 
     /* SMT, core and package levels are set by default. */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 2e24f457468d..095540e58f7a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1899,6 +1899,9 @@ typedef struct CPUArchState {
     /* Number of dies within this CPU package. */
     unsigned nr_dies;
 
+    /* Number of modules within one die. */
+    unsigned nr_modules;
+
     /* Bitmap of available CPU topology levels for this CPU. */
     DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL_MAX);
 } CPUX86State;
-- 
2.34.1


