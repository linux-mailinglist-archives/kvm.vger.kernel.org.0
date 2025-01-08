Return-Path: <kvm+bounces-34782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C689A05F34
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89C47165CCA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08321FF1D5;
	Wed,  8 Jan 2025 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoffBv/p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369811FCFE3
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347399; cv=none; b=dmMbdbi9tH4g8C1K/oa4CXeYNrLlRxvFzj2RpWs0QtdMz+7xcFMcduDW0xxz8WTs7Dxb4Mfg9cdo3sedcFjD7D54ckD203k9Q7YeA+4STvXfl5kazcDvWdwz8W4HncDg/DId1DiQADzcn77tsQENygaISGaxm78E4XGsy2GMjyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347399; c=relaxed/simple;
	bh=roMx6NLgvG1w2UZlck/tSjXRrw4hdWLyk6vWSzvqPQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z3Qh06nPxjip4Ldahjfkt86ghotB8tEEtQUFe96u0nR0zGdwMUG8fy+7AQYN97hNVjdHRiaw6ZVD3bCaEua53DvFbCoxGNC+AVji3/8OaCvYBILUhppNeGFXcYq95jluQaAegPS+2/S12TbNWASmp7dpQAVph7/IN2fXX+i1oMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoffBv/p; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736347397; x=1767883397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=roMx6NLgvG1w2UZlck/tSjXRrw4hdWLyk6vWSzvqPQI=;
  b=eoffBv/p7mLejb9m1oG16/DZTgPPCGH+XleDI7D1pGW0/ttHoK8GPOYr
   IW1LmQC473wAWALQRkAJbGtVOEWl6PKFUXSxbEWlndvFO1BuSuqPujL2I
   841WROmcS3k8fOekXwaC+FweIRW9i2uJ+/QcruwKYxQQYEyhojmUsLAhe
   nZeLUcj8HXkOr7dTlAHtiMewYehRM2mRuJm3a9H/oaoAK27idkOhB3BQr
   yJ67sqqNVEVx8hN7V9hzDqGtmTiFklwMVBz2ScJ/MM7cxzETudag8Jold
   dW7t6Pw1ea5w+LF/54byGe2JMQ8rpAAZc2efdpb0m+yEOi0uAkK9H25pb
   A==;
X-CSE-ConnectionGUID: Am4t4oafSq620rr8omJgbQ==
X-CSE-MsgGUID: 5WZs7MdkQUGQgvsLIHKDiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36737347"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36737347"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 06:43:17 -0800
X-CSE-ConnectionGUID: 2i5G/sg9RIKwJW2uz0Nc0A==
X-CSE-MsgGUID: 59Xo8U8iTim5ohGRbQs+ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103969389"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 08 Jan 2025 06:43:13 -0800
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
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v7 1/5] hw/core/machine: Reject thread level cache
Date: Wed,  8 Jan 2025 23:01:46 +0800
Message-Id: <20250108150150.1258529-2-zhao1.liu@intel.com>
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

Currently, neither i386 nor ARM have real hardware support for per-
thread cache, and there is no clear demand for this specific cache
topology.

Additionally, since supporting this special cache topology on ARM
requires extra effort [1], it is unnecessary to support it at this
moment, even though per-thread cache might have potential scheduling
benefits for VMs without CPU affinity.

Therefore, disable thread-level cache topology in the general machine
part. At present, i386 has not enabled SMP cache, so disabling the
thread parameter does not pose compatibility issues.

In the future, if there is a clear demand for this feature, the correct
approach would be to add a new control field in MachineClass.smp_props
and enable it only for the machines that require it.

[1]: https://lore.kernel.org/qemu-devel/Z3efFsigJ6SxhqMf@intel.com/#t

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since Patch v6:
 * New commit to reject "thread" parameter when parse smp-cache.
---
 hw/core/machine-smp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index b954eb849027..4e020c358b66 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -321,6 +321,13 @@ bool machine_parse_smp_cache(MachineState *ms,
             return false;
         }
 
+        if (props->topology == CPU_TOPOLOGY_LEVEL_THREAD) {
+            error_setg(errp,
+                       "%s level cache not supported by this machine",
+                       CpuTopologyLevel_str(props->topology));
+            return false;
+        }
+
         if (!machine_check_topo_support(ms, props->topology, errp)) {
             return false;
         }
-- 
2.34.1


