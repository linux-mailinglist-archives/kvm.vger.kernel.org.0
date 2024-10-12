Return-Path: <kvm+bounces-28688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5AD99B305
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 12:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5695C1F2345C
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 10:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F6515C13F;
	Sat, 12 Oct 2024 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXHqmzEe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2730915624C
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728728952; cv=none; b=EaDy7nBbBsYJ1IpDCwRmxn5XUVZcEhdf+qd7F5qvBmMGXB9pRh6FPLV3dfiDei4fIOR+FywSj0cxJolPgkNKkzVTbB/bE2p2d3s84AXmRorfZbMlOfFbH9R9zYDtokAxoNb/AUZSXtk1jsCMiEwchAM0do2uxt0kP/zK4rsY9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728728952; c=relaxed/simple;
	bh=i+35KcqWfRxigU2EIhaJxKdHSfXUSTicv5fw/oXO2lw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KnawF9ti0VEmWYqr6hnk5RGXK3ZaPi8qN+PUlns4MHZPkrusvTWR6fL89rw7JmXDc3JdBkguVd2t/67kbo8V1TbsFLB3i/6Cbi4EQkhkt/X8lyXTwogB6V61IzDpbQNkY8F6ZQ7iuBiMyDB79eZjcSBxSo+c5JqgMU3w9WJIHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXHqmzEe; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728728951; x=1760264951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i+35KcqWfRxigU2EIhaJxKdHSfXUSTicv5fw/oXO2lw=;
  b=jXHqmzEexQrcfXYK5v2MeqsA3FcvWgMoqM5LzXqaFLN6IHQ79Wbc/aip
   twQ016IQD5sA/U65+2ze4WqdoiRdHulM/qw8zyn3COcwol22ToIYnQjML
   Pn93Imzl9zdeEX0ZMQ5FSOLNr68xtPyb1kJViZu+BKs4QNjOaewgfVmEf
   3VOc2ihjw9pVfMPC53XmAGeJpnxp076lRihMPAx1Q7ZMesRp3cyi5Ro+l
   PFbrZ62Pu+chvGwyuI4NQoMR7NbfPX3jDWl3HMnjLg4qDrnhMlxAWfKnG
   Vjp5z8rltdGD+P23i9nkUigtRgxoDBiM4BwzeRSCYVpQNbxkZa86KccAp
   g==;
X-CSE-ConnectionGUID: 17aBQ27jRyKZhmUeS32cMQ==
X-CSE-MsgGUID: ew+AaXpcR66kCieSI802ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="45634958"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="45634958"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 03:29:11 -0700
X-CSE-ConnectionGUID: iSUSYFKcSyyEaLI1013xMA==
X-CSE-MsgGUID: WLmQSF1tQ+WlPwsdfAOydQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="77050877"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 12 Oct 2024 03:29:05 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 7/7] i386/cpu: add has_caches flag to check smp_cache configuration
Date: Sat, 12 Oct 2024 18:44:29 +0800
Message-Id: <20241012104429.1048908-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241012104429.1048908-1-zhao1.liu@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alireza Sanaee <alireza.sanaee@huawei.com>

Add has_caches flag to SMPCompatProps, which helps in avoiding
extra checks for every single layer of caches in x86 (and ARM in
future).

Signed-off-by: Alireza Sanaee <alireza.sanaee@huawei.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note: Picked from Alireza's series with the changes:
 * Moved the flag to SMPCompatProps with a new name "has_caches".
   This way, it remains consistent with the function and style of
   "has_clusters" in SMPCompatProps.
 * Dropped my previous TODO with the new flag.
---
Changes since Patch v2:
 * Picked a new patch frome Alireza's ARM smp-cache series.
---
 hw/core/machine-smp.c | 2 ++
 include/hw/boards.h   | 3 +++
 target/i386/cpu.c     | 9 ++++-----
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index f3edbded2e7b..16e456678cb6 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -367,6 +367,8 @@ bool machine_parse_smp_cache(MachineState *ms,
         return false;
     }
 
+    mc->smp_props.has_caches = true;
+
     return true;
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index e4a1035e3fa1..af62b09c89d1 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -153,6 +153,8 @@ typedef struct {
  * @modules_supported - whether modules are supported by the machine
  * @cache_supported - whether cache (l1d, l1i, l2 and l3) configuration are
  *                    supported by the machine
+ * @has_caches - whether cache properties are explicitly specified in the
+ *               user provided smp-cache configuration
  */
 typedef struct {
     bool prefer_sockets;
@@ -163,6 +165,7 @@ typedef struct {
     bool drawers_supported;
     bool modules_supported;
     bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
+    bool has_caches;
 } SMPCompatProps;
 
 /**
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c8a04faf3764..6f711e98b527 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7853,12 +7853,11 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
 
-    /*
-     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless Updates
-     * if user didn't set smp_cache.
-     */
-    x86_cpu_update_smp_cache_topo(ms, cpu);
+    if (mc->smp_props.has_caches) {
+        x86_cpu_update_smp_cache_topo(ms, cpu);
+    }
 
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
-- 
2.34.1


