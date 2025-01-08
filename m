Return-Path: <kvm+bounces-34783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3916EA05F36
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F27F3A3055
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13E21FF5E3;
	Wed,  8 Jan 2025 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IaMhKVlB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75F1FCFE3
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347402; cv=none; b=Mf42m2w8+QmOCRvXRtilmdOvUuxPbI2HrLScbjvu6mRmdrd9jBLnJfZ6pVziwSoruZZTpT3BYyQy/+TtnzH/CuxhslHg0Eat6ShUtOKya6Fhi7tOjdZxEnDpT223Pkpym9FlZtDiy8ZR4qJJDMz60kws2HDzdcgyF32vHPnjkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347402; c=relaxed/simple;
	bh=shkMAuvJ+JiK4YmkroyLIrAGyT0tA05DVR9Yl2i03nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rN1squ0D/j27zftFKoBTUDmoaPSDvi3hflrVLb6xWElWJk0yzYlzARuDTcVP1KcuWzXenl6rtAb7z5RNb6LdBlLbe+4paE43lc6H6hVyiMvjwJ+Geub7MGSGQviEcHk67CkwmFyuW0BhKbQtn8c5N+DfMHcHRB8O5PzyShaCER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IaMhKVlB; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736347401; x=1767883401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=shkMAuvJ+JiK4YmkroyLIrAGyT0tA05DVR9Yl2i03nc=;
  b=IaMhKVlB51EfHHSgJrr03Byz3i/HZbNp+UQmXYZ1zuVYQWkyS7NBppib
   VliINBwIBLNg185F8t7VSFCm/B3EiDS4FgCkweLvD+B8YlItgYzDcrvzb
   9NkE4qKZuHTHAaOcCEJK+VBBLKgzLH9yxh4t2r6qIf3FP1ObLVwuQ4W6k
   2//HCsjAdAxIWpn4HDYotsqWALOS27FXHwGtSTobAF/Dgfacfer0V+nF9
   3I3ae7WyLw5OtLvXQKvAk+fdIc1OSjHgqKMHxBixK7WU1PDqe8nxGK3yG
   D7oH+hUv+sqyyLFP2BZ63Vxn1hf7l2qdQGhmKTBzlvWULIQVNh4XdSi5M
   A==;
X-CSE-ConnectionGUID: N9F4M68CRjyeokAcJR4Hzw==
X-CSE-MsgGUID: OPTjQCEqRWuTnipP7obTaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36737356"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36737356"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 06:43:21 -0800
X-CSE-ConnectionGUID: IK+/jtcHRViL2nJ9I7BNRA==
X-CSE-MsgGUID: QRk5frgmTCG2FQ9lUtPUQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103969393"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 08 Jan 2025 06:43:17 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 2/5] i386/cpu: Support module level cache topology
Date: Wed,  8 Jan 2025 23:01:47 +0800
Message-Id: <20250108150150.1258529-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250108150150.1258529-1-zhao1.liu@intel.com>
References: <20250108150150.1258529-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow cache to be defined at the module level. This increases
flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v6:
 * Dropped "thread" level cache topology support.
---
 target/i386/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 660ddafc28b5..4728373fdf03 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -247,6 +247,9 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     case CPU_TOPOLOGY_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPOLOGY_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPOLOGY_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -255,7 +258,7 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         break;
     default:
         /*
-         * Currently there is no use case for THREAD and MODULE, so use
+         * Currently there is no use case for THREAD, so use
          * assert directly to facilitate debugging.
          */
         g_assert_not_reached();
-- 
2.34.1


