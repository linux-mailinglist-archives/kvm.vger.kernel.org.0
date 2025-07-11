Return-Path: <kvm+bounces-52119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D17B01927
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82688B6076A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A7D27EFF9;
	Fri, 11 Jul 2025 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHwEdd5r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540FC27EC76
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228028; cv=none; b=s4Grt3yhzB6n9QjkQ0JPTCtJJtQ98OmMTT455G7PE1dK76FqRJcuxDepVT2m9Fus9gHKlOrEdtJ4jqLKeZAY5HTLcbE+cGNEKHr70JGVMpBxH1HP1NLLSUxSM+nVa0Km53VdGyPBmZPS8BHqD9pjoJpSOh1owlETLPI78lU2dSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228028; c=relaxed/simple;
	bh=Q8vxlSp8vNdf+rAvGc2M8Yga/kO4BDydluyykj+THNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lCkwHUtU3YgMMGjsnDqOqmPSIwm1QuFCrDd1dMMtat9koFoqALYsf+p5VZtoOuGO8cmXR+/pNwSWMwMw/VKjW6AVSZyO7zMjIjv9cBR5WDBBnXNZElvpjmzYBmc/rGg5ES+xnTpUfLGewVAnqKXitzUhMsmpGEue0n1f56crVsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RHwEdd5r; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228026; x=1783764026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q8vxlSp8vNdf+rAvGc2M8Yga/kO4BDydluyykj+THNg=;
  b=RHwEdd5rdwNL87np9k4VD8TTbsSqdUemw9s36mI2tP4hFnKy7Khvqzyi
   NuRjPCKDDXa/Apn9f+8gC8/gaRrsB8aSWTbwA7grHID4ee2+4HBYyCqOF
   l27wWZdPK57mjVs0En/hPgDHIdxlN1BqKcQ6VqnBlW3xy74MeSnVw145Q
   +7eIGmTwIHawUcjslEYYphnfNPXdZAq1b/ZVtLBSi0wS5SghQhkAjIxQF
   JQt4Md3lY09t/FVY1BiypeMb3fARbl2FUcfQNL/MDqDRfDsBHMxhwgrlX
   YHndP31OyInaS+Futctmx7KP0M4pj2FVNcx7i00spVvGUtHa1GVScWr0w
   Q==;
X-CSE-ConnectionGUID: uNR+BKrRSeaqoKdLvqAaAw==
X-CSE-MsgGUID: SGLuTtJwRLqMTjcVBTaA2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496189"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496189"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:26 -0700
X-CSE-ConnectionGUID: onw+2bYBQkuhQgZOe42X2w==
X-CSE-MsgGUID: KuWsCJSDR7WF/8+CEpZN8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662006"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:21 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 01/18] i386/cpu: Refine comment of CPUID2CacheDescriptorInfo
Date: Fri, 11 Jul 2025 18:21:26 +0800
Message-Id: <20250711102143.1622339-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refer to SDM vol.3 table 1-21, add the notes about the missing
descriptor, and fix the typo and comment format.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Fix the typo in comment. (Dapeng)
---
 target/i386/cpu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0d35e95430fe..6983b5f70457 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -66,6 +66,7 @@ struct CPUID2CacheDescriptorInfo {
 
 /*
  * Known CPUID 2 cache descriptors.
+ * TLB, prefetch and sectored cache related descriptors are not included.
  * From Intel SDM Volume 2A, CPUID instruction
  */
 struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
@@ -87,18 +88,29 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
                .associativity = 2,  .line_size = 64, },
     [0x21] = { .level = 2, .type = UNIFIED_CACHE,     .size = 256 * KiB,
                .associativity = 8,  .line_size = 64, },
-    /* lines per sector is not supported cpuid2_cache_descriptor(),
-    * so descriptors 0x22, 0x23 are not included
-    */
+    /*
+     * lines per sector is not supported cpuid2_cache_descriptor(),
+     * so descriptors 0x22, 0x23 are not included
+     */
     [0x24] = { .level = 2, .type = UNIFIED_CACHE,     .size =   1 * MiB,
                .associativity = 16, .line_size = 64, },
-    /* lines per sector is not supported cpuid2_cache_descriptor(),
-    * so descriptors 0x25, 0x20 are not included
-    */
+    /*
+     * lines per sector is not supported cpuid2_cache_descriptor(),
+     * so descriptors 0x25, 0x29 are not included
+     */
     [0x2C] = { .level = 1, .type = DATA_CACHE,        .size =  32 * KiB,
                .associativity = 8,  .line_size = 64, },
     [0x30] = { .level = 1, .type = INSTRUCTION_CACHE, .size =  32 * KiB,
                .associativity = 8,  .line_size = 64, },
+    /*
+     * Newer Intel CPUs (having the cores without L3, e.g., Intel MTL, ARL)
+     * use CPUID 0x4 leaf to describe cache topology, by encoding CPUID 0x2
+     * leaf with 0xFF. For older CPUs (without 0x4 leaf), it's also valid
+     * to just ignore L3's code if there's no L3.
+     *
+     * This already covers all the cases in QEMU, so code 0x40 is not
+     * included.
+     */
     [0x41] = { .level = 2, .type = UNIFIED_CACHE,     .size = 128 * KiB,
                .associativity = 4,  .line_size = 32, },
     [0x42] = { .level = 2, .type = UNIFIED_CACHE,     .size = 256 * KiB,
@@ -136,9 +148,10 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
                .associativity = 4,  .line_size = 64, },
     [0x78] = { .level = 2, .type = UNIFIED_CACHE,     .size =   1 * MiB,
                .associativity = 4,  .line_size = 64, },
-    /* lines per sector is not supported cpuid2_cache_descriptor(),
-    * so descriptors 0x79, 0x7A, 0x7B, 0x7C are not included.
-    */
+    /*
+     * lines per sector is not supported cpuid2_cache_descriptor(),
+     * so descriptors 0x79, 0x7A, 0x7B, 0x7C are not included.
+     */
     [0x7D] = { .level = 2, .type = UNIFIED_CACHE,     .size =   2 * MiB,
                .associativity = 8,  .line_size = 64, },
     [0x7F] = { .level = 2, .type = UNIFIED_CACHE,     .size = 512 * KiB,
-- 
2.34.1


