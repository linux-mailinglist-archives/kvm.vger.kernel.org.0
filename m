Return-Path: <kvm+bounces-50029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9D2AE16FA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A3CC5A10F8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BAD27FD4F;
	Fri, 20 Jun 2025 09:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SjZRLiFL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819F2356C7
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410387; cv=none; b=n6HmsSKE+XJFYohZtVIlqnEcqbcQUwTykcbdX3YifuDJizdNvIA0cm2sTc56z5RstxT54JjCjygLB2Tz03FkgOm5OeXUsrigkc5eVy9Si+MrrLWZInPgEMZtKJNC4xaSf83Yf4nebHgOYhsMwBuYbwFew1HOdWjnOZFuNWJM7m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410387; c=relaxed/simple;
	bh=f7u0fAdjZivukx2yOZWHoGvHXSLSvSk4BLW4LAo7h8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8xN9cwFlEBhaFI9CFiTp9ZGVgWrMSnFxvZ4V2roQG8j390wBnd5XO7INNij/QCth6MEPgxuoYDOgx/BRqHMno/uPwSVcPHz6B2wzaoV6t/3u2U0watLZ9BG+Nv32xNcgAguVwYDDDXQE4uFk1BMSCN2rLOkGMaMLEW+0qm0uog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SjZRLiFL; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410386; x=1781946386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f7u0fAdjZivukx2yOZWHoGvHXSLSvSk4BLW4LAo7h8s=;
  b=SjZRLiFLv1ff7V+9DHkozA+CBMoOt0bJ+a2CCgSwUmkLhoLQGKTeX+ty
   0r867lrKA+AlL8wSU2MqcCLBHuh61AN8UppFePZiNs4Jhhkta/ZErBaKB
   T0bKJJRGUmPCWJ7wrq2sjonRKXUVY6zXAYdi0ypdx7z7B2pJcIyV9woEr
   4JHneiKkb3L2H1lIEJPNdrwb9u+S3vLO6kwfJlvtqULmtEMquMvVfghDL
   tN4D9944Y+AycCie9k/dXV0Klok2BTxJADba797SjF3mHFPNbMmg0TfLI
   XfRGT1oSe1C/UME+Jvzi6hgomWdDY7IpUQKPK+L4vLpMaYj8LPC9S2C1B
   A==;
X-CSE-ConnectionGUID: KdYAiK7dS3uC2Pb+D9TOSA==
X-CSE-MsgGUID: 5+R2b7VNTqqO5Ca/aKGdrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466524"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466524"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:06:26 -0700
X-CSE-ConnectionGUID: 6WY3sepyRWarjz00DPUjdg==
X-CSE-MsgGUID: jFb76fb9R0i+7QDm3tLisQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156669805"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:22 -0700
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
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 01/16] i386/cpu: Refine comment of CPUID2CacheDescriptorInfo
Date: Fri, 20 Jun 2025 17:27:19 +0800
Message-Id: <20250620092734.1576677-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250620092734.1576677-1-zhao1.liu@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refer to SDM vol.3 table 1-21, add the notes about the missing
descriptor, and fix the typo and comment format.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 40aefb38f6da..e398868a3f8d 100644
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
+     * to just ignore l3's code if there's no l3.
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


