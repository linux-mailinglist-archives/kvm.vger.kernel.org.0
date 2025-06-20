Return-Path: <kvm+bounces-50030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 175F4AE16FB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F4F719E44C3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37A227FB18;
	Fri, 20 Jun 2025 09:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EiHSVc3S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EFF2356C7
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410392; cv=none; b=iBB3tkQ2DQsPzmNwGochnGQv7bZ9mCiURy5qVLvClp/H/xuN/OphgzIceNd4YuFy59Fv5agFF02LB1d2PheYIVOdDEcpg13hBDMCVIKlgGuHGERmsBhFr6oFOQM+c32vafqOYRQnAWyc9paBayDdJcPLNcBYAXxOHFhMTuZIwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410392; c=relaxed/simple;
	bh=rP+3yIcVeLITlIOtxWUE53+6FM+a8wwBuKQISSU42FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qtOareRa0g35boRtXtkQdwlw6puwZN/0DLTQeZx4vlxHqPpzJr7GnpGszPXz+J3L4OYELKvPpB72PcGiJkY/T5frCw/sTOezWqSoF4pn+H041bgfLoASVTvrSx2GCQw3XzyQhcz6fTz7p6/tUoeyLKK5+U4veX+4mnh899GMaxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EiHSVc3S; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410390; x=1781946390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rP+3yIcVeLITlIOtxWUE53+6FM+a8wwBuKQISSU42FQ=;
  b=EiHSVc3SB+G1PFT5da2NaH0/0WHun8WQhxutvAKqpfuUTncTKe9GWP82
   pwqbikOy5yxMiR27G7/VHt+p1YUMnZ4myDq1qXMzdHrFPU4IETJd5/iLQ
   t5zYMMhc4gxYBm+lDnuMcNPZ7MYS8drZW3QS80xKtEcqMt4EAyS41VU0f
   NUUUEVQUAcVDp5grlczv//8O+huQYVAOaMq1V7PgyvTS7OPrzNEHSbroJ
   2M1OexKZp6uEt7DZLVhNsOAs9bNTlY1llN4bTtdjOfri094lGAA1WkL7n
   TBJbjUBmE9mKO3ailkVwr6PEx4fzVqqvQwLDoe+uiyOK6W70FGftfVbH3
   w==;
X-CSE-ConnectionGUID: fyjvAG75Qr6iAw5MUhPmQg==
X-CSE-MsgGUID: q/T/gA+HSCeF+bs+AaLqiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466540"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466540"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:06:30 -0700
X-CSE-ConnectionGUID: QlVPWsGrQ9KlMS6Oe37+hQ==
X-CSE-MsgGUID: dwkM4O6vRBqtU+YqP+El+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156669847"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:26 -0700
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
Subject: [PATCH 02/16] i386/cpu: Add descriptor 0x49 for CPUID 0x2 encoding
Date: Fri, 20 Jun 2025 17:27:20 +0800
Message-Id: <20250620092734.1576677-3-zhao1.liu@intel.com>
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

The legacy_l2_cache (2nd-level cache: 4 MByte, 16-way set associative,
64 byte line size) corresponds to descriptor 0x49, but at present
cpuid2_cache_descriptors doesn't support descriptor 0x49 because it has
multiple meanings.

The 0x49 is necessary when CPUID 0x2 and 0x4 leaves have the consistent
cache model, and use legacy_l2_cache as the default l2 cache.

Therefore, add descriptor 0x49 to represent general l2 cache.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e398868a3f8d..995766c9d74c 100644
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
+     * When it represents l3, then it depends on CPU family/model. Fortunately,
+     * the legacy cache/CPU models don't have such special l3. So, just add it
+     * to represent the general l2 case.
+     */
+    [0x49] = { .level = 2, .type = UNIFIED_CACHE,     .size =   4 * MiB,
+               .associativity = 16, .line_size = 64, },
     [0x4A] = { .level = 3, .type = UNIFIED_CACHE,     .size =   6 * MiB,
                .associativity = 12, .line_size = 64, },
     [0x4B] = { .level = 3, .type = UNIFIED_CACHE,     .size =   8 * MiB,
-- 
2.34.1


