Return-Path: <kvm+bounces-10052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EB3868D3D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:20:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDC5A1F276F6
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62CD139568;
	Tue, 27 Feb 2024 10:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i5LkO0yx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D11386CF
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029161; cv=none; b=UjHUWHENEWQwT9wB6n55e4LKTA7dLUX85U79uhLXxQ0ztOh++97VxnSphzviLdzpTdmrUQ7g24nP3f+pA1v4S7uavHDn2pOyLQ87suDLgHOz+9gO5Tw62tQ2ozCZffh4EEq8SSiP3JQMIjj8oWlxm+fLfHlfkR28y5IKaHnhI+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029161; c=relaxed/simple;
	bh=+D0kFbwk/6uu2utuPjUeCfJFwddDsRc/EgoeBeVWwmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWzwDfzU1lH0RLI/8NnNfwnIfjD9iOEi7MgRMxRtvPmcGTsjjpjbVHxo4lp1jKSiW5ak3FFQd07JFQJCxYJSrl65YPuRU81zOEaLCAKy96B2l/C9mqKr66yk0EhWNrb1Z4jLUuKo1Hce9/aBy5EXbEXQ6ILLI3BXh3Ia4b2pWuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i5LkO0yx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029159; x=1740565159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+D0kFbwk/6uu2utuPjUeCfJFwddDsRc/EgoeBeVWwmA=;
  b=i5LkO0yxr+po52mjFxFs9iIrN7lWj4ccs5VcWiZd8kK6YgfSSjJyEfre
   sZlCBsqpcMnS1ZU6COsMJADpIJ2fbeB8M4WDUbfqM5a7dIri7+y70G1oy
   DHJ6qjgfe7cIPeSIlLy0RZ+WqM0OSNPi7Ty2V9N7iUf29RtZyLxxiq0if
   vP+e6W2C9UwE3nSDo81HjQkVoSCbImjhAsVagjZOwmt6U5FwRmSppnoO/
   7c33gPQASOzugcRcksKsfSrd0yvKyhH4zKPqSmrV28HBNGcln+9LtkRvp
   t127kuny0YinO4QwnnIuwnzwobeupwsmsu2J7suWNs+Ke1r3HUR3T3LBV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310246"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310246"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954774"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:19:14 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v9 05/21] i386/cpu: Fix i/d-cache topology to core level for Intel CPU
Date: Tue, 27 Feb 2024 18:32:15 +0800
Message-Id: <20240227103231.1556302-6-zhao1.liu@linux.intel.com>
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

For i-cache and d-cache, current QEMU hardcodes the maximum IDs for CPUs
sharing cache (CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits
25:14]) to 0, and this means i-cache and d-cache are shared in the SMT
level.

This is correct if there's single thread per core, but is wrong for the
hyper threading case (one core contains multiple threads) since the
i-cache and d-cache are shared in the core level other than SMT level.

For AMD CPU, commit 8f4202fb1080 ("i386: Populate AMD Processor Cache
Information for cpuid 0x8000001D") has already introduced i/d cache
topology as core level by default.

Therefore, in order to be compatible with both multi-threaded and
single-threaded situations, we should set i-cache and d-cache be shared
at the core level by default.

This fix changes the default i/d cache topology from per-thread to
per-core. Potentially, this change in L1 cache topology may affect the
performance of the VM if the user does not specifically specify the
topology or bind the vCPU. However, the way to achieve optimal
performance should be to create a reasonable topology and set the
appropriate vCPU affinity without relying on QEMU's default topology
structure.

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Changed the description of current i/d cache encoding status to avoid
   misleading to "architectural rules". (Xiaoyao)

Changes since v1:
 * Split this fix from the patch named "i386/cpu: Fix number of
   addressable IDs in CPUID.04H".
 * Added the explanation of the impact on performance. (Xiaoyao)
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7f9082367672..81d9046167e8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6113,12 +6113,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             switch (count) {
             case 0: /* L1 dcache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
-- 
2.34.1


