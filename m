Return-Path: <kvm+bounces-15830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C205E8B0EA8
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79A3228D204
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EC816190B;
	Wed, 24 Apr 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XD3P2zi7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AE015FD07
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973034; cv=none; b=bl/TmbCC5NQpjYTWYWTCtxaS0QKZiMaDGqEm4oGYx4wDXylK5mzdwa93+7faiyb4P8xAJULkLKuw2DPoniVt9lLYg1tQCtUZnKSsrfe126iWSvqzWq9oSYsuNigwZ+Pnpkp66rjlsu9mHllil9mEBKfUVV3uWRaVJ3kY+eonCTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973034; c=relaxed/simple;
	bh=lS2Q3aIy/l8MzrROqyj1dCcQs09BZjEA1LjJ1XbG+sY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V7OYGUgjqqq7jkWhUfvdL2vje2ToW3KFdDQEfse8PVLJizWcD46/UBC2ntbJGt7FY03pzmYZv2UEE9LikvwLQSfogWWGivBijM9zrUxp+YI4MZ4mqPFviwVc/WG/jiG+1lZT0/vT2GJjFrjrwln47T9aqqdctCPIXN1Ov9cAcsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XD3P2zi7; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973033; x=1745509033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lS2Q3aIy/l8MzrROqyj1dCcQs09BZjEA1LjJ1XbG+sY=;
  b=XD3P2zi7ZfRJeXAVTVsYWOWIQuunAQClkowhnzVQrLV7mQjQj6xiE7DU
   q94Q3TKsw1zEZJninxCPpjUz4AhiuE2BT1P7D3syjbz48cML/6PtVpv9O
   BHahO/ecYzm8pq6QXlcqPszpPZVQB1p723VL+k8Gf5nbMOJU27iINlu5K
   nlmE3trCdr2AEF7djUqxPyuAAIUzY3W6KfMvFgq2EW5ERDseV09TQwhkO
   k9xFzOKwu1RBipBja5ijLb0Q1jB2URqlVmv0hk5AdEA9lmhHClwyBEgf9
   w1QuNMuiQ/qZh61PCwE1BlmUMvpCye6GpEF3V2x8DDiur8xL1kNj8uST/
   w==;
X-CSE-ConnectionGUID: vXm/aDLAS92dCQOd+heY8Q==
X-CSE-MsgGUID: WNYgup24TsS+iUoKc0bRuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545761"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545761"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:36:57 -0700
X-CSE-ConnectionGUID: KnWFnh9CSnWa6F3Zp6NdOQ==
X-CSE-MsgGUID: z78Fm+TdTOKRxdJ4ynTXAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363287"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:36:52 -0700
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
Subject: [PATCH v11 12/21] i386: Introduce module level cpu topology to CPUX86State
Date: Wed, 24 Apr 2024 23:49:20 +0800
Message-Id: <20240424154929.1487382-13-zhao1.liu@intel.com>
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
index 004627fa8985..3b5cf75d5bf3 100644
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
index 504ec569e0b2..8f34a5b8d726 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7871,6 +7871,7 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
 
+    env->nr_modules = 1;
     env->nr_dies = 1;
 
     /* SMT, core and package levels are set by default. */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index fa9b6679387e..630129838c08 100644
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


