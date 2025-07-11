Return-Path: <kvm+bounces-52120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7825DB0190F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEBA33B2E26
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30FA27F00B;
	Fri, 11 Jul 2025 10:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTXgT93Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F1527EC76
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228032; cv=none; b=A5R7HYyE0wZ0MNAZLj5C1mWn6p0NLQJlA2PdH9EQywkBAXCnjHW01TSTH8ka7Lsl/v6+J99DvchMguoyaXKhwzYbs/Bfoepp8FriFGRx4Gp7/ZcvaOpD5qNLMe4lSjv2oEn6vAikX8k99C533w4uaQr1a5vpF50ed3SvYMsPtVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228032; c=relaxed/simple;
	bh=ROoVRKY7dce0T2TAcHTZK8KJkdKbNMAzZALpbA8p8yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pb68GJkzrDTY0pipBEFL9/ThlsJhJkDwuHygwyc9CkUwQa5HfCuxgduN0xeMGpsxVkHaRcS3y9fG1PLINC6KTjyBO679gnOXDUyCtQmh2JxGs85CQy81BClEVeCspgbTTmTLwMOPEgySGey9AnWxpL8Q368uRVJ2CZAOZNLXIK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTXgT93Q; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228031; x=1783764031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ROoVRKY7dce0T2TAcHTZK8KJkdKbNMAzZALpbA8p8yk=;
  b=cTXgT93QBF54MP3d3lNJSt0dhgyJ8fSR4rlrj3i8nAyhyLQ2hgITKHPK
   8d1SPaSAPedkeYNgVh8mZpot5yPSNS7OWDW2o0jaw+h7y7FUohQ+FfMhf
   ghdqAEjqgU2wXc8UKnYshpQ3WSC9Xj95v6AKMfK++e+/NHXbXY1eyq9om
   oPA5t9Ug2sJ+rK34cNNU+QFzMPITBMI56Fi/hfoGNWVX1MFWYE8hfd2mn
   GVGyyFQaxSZuW2fyA90zwQqjS5PE/6UDUi5iIg76t4J6QapWlfqHCZWBi
   5bQ35iYyN61W+62WMFuWp+oNMbIR+cma80MvO6VMOLh+eJaBgryL6uwgr
   Q==;
X-CSE-ConnectionGUID: Fqc+lZy6QP+lOQU70WRsVw==
X-CSE-MsgGUID: nC2dx10ZSbGdWB0XmLhm6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496214"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496214"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:31 -0700
X-CSE-ConnectionGUID: kEwFLIVOTGajOgISGLQ+zg==
X-CSE-MsgGUID: I/V0E3r4RNuATUyrQCZTfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662034"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:26 -0700
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
Subject: [PATCH v2 02/18] i386/cpu: Add descriptor 0x49 for CPUID 0x2 encoding
Date: Fri, 11 Jul 2025 18:21:27 +0800
Message-Id: <20250711102143.1622339-3-zhao1.liu@intel.com>
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

The legacy_l2_cache (2nd-level cache: 4 MByte, 16-way set associative,
64 byte line size) corresponds to descriptor 0x49, but at present
cpuid2_cache_descriptors doesn't support descriptor 0x49 because it has
multiple meanings.

The 0x49 is necessary when CPUID 0x2 and 0x4 leaves have the consistent
cache model, and use legacy_l2_cache as the default L2 cache.

Therefore, add descriptor 0x49 to represent general L2 cache.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v2:
 * Fix the typo in comment. (Dapeng)
---
 target/i386/cpu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6983b5f70457..75932579542a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -127,7 +127,18 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
                .associativity = 8,  .line_size = 64, },
     [0x48] = { .level = 2, .type = UNIFIED_CACHE,     .size =   3 * MiB,
                .associativity = 12, .line_size = 64, },
-    /* Descriptor 0x49 depends on CPU family/model, so it is not included */
+    /*
+     * Descriptor 0x49 has 2 cases:
+     *  - 2nd-level cache: 4 MByte, 16-way set associative, 64 byte line size.
+     *  - 3rd-level cache: 4MB, 16-way set associative, 64-byte line size
+     *    (Intel Xeon processor MP, Family 0FH, Model 06H).
+     *
+     * When it represents L3, then it depends on CPU family/model. Fortunately,
+     * the legacy cache/CPU models don't have such special L3. So, just add it
+     * to represent the general L2 case.
+     */
+    [0x49] = { .level = 2, .type = UNIFIED_CACHE,     .size =   4 * MiB,
+               .associativity = 16, .line_size = 64, },
     [0x4A] = { .level = 3, .type = UNIFIED_CACHE,     .size =   6 * MiB,
                .associativity = 12, .line_size = 64, },
     [0x4B] = { .level = 3, .type = UNIFIED_CACHE,     .size =   8 * MiB,
-- 
2.34.1


