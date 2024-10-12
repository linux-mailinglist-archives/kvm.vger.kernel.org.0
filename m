Return-Path: <kvm+bounces-28684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCF099B2FC
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 12:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB32AB2190B
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 10:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BA51547D8;
	Sat, 12 Oct 2024 10:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9nvO42u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F252154434
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728728935; cv=none; b=EpsL8LiACHKsyhAuLLzF5+2qjrBTUIyPQ6B3HTjVPbcWlUGm4UIFT+c7oK6djRD7h274JSwGd088IqxhJc05AMXLflpr/rsIN8Afdx3ggqwJveq55KCugFYoz5pPpZPVoBeVg2S08YzmIzrX8MZcLV7EDIEM2KMwGU/P6BNEFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728728935; c=relaxed/simple;
	bh=eGq2BnytsrQRn74+62hETUgMwOQV0zS4jkHL1KP2Mqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YRBh5UaJwGfzge8a7AaIjiQgR6W8yOrlVhF+bcpvtL4h6eeYUxsB+apM763tD4mTYyFFcH1AWUN2tMyyopNxhniweWwlc3AAvsvHAZJ1OJG2JsqpBFyYHO5qyQnvLRsJnILcihILdce+ZkDw+duxthtMrms6jEjMnVn89r5Qbrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9nvO42u; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728728934; x=1760264934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eGq2BnytsrQRn74+62hETUgMwOQV0zS4jkHL1KP2Mqs=;
  b=F9nvO42ug6Df7HsOQQeqH6cc/XqK8up1d+D64ALlN1LYFxPiKXN/1woe
   42LN5T3Y5y70gFuJ0L34zZAMwOryU3yYryS6mlojxuBc/8bN0hDRqQJS9
   5jxTT20VvNOjk44j56kdDYr0H1RpiDQ2YJGXog1KbJAl/HH6GsFlfzYMn
   WqcnIX9txCQQx2wXAFNIXPMvFBu2k8tkb5CtVnXTqAff+hRkrX88QIjCI
   fpixn37fHPXfZ1HNbYM7fJoVZt10Xq3vkcsPd1Xye8bxKB8rbRV2CLa/N
   tYj2EkBzEIffujRSZWOZm+FafIxM/tn+soR7cucONT9AsfdsK5c6xGiY6
   Q==;
X-CSE-ConnectionGUID: bwhNUGqtQbamC8ik5TCX6w==
X-CSE-MsgGUID: 8NrsglOxQQyttLov9CJ6OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="45634897"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="45634897"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 03:28:54 -0700
X-CSE-ConnectionGUID: rjQu1VD/RciFLAyVibtHAw==
X-CSE-MsgGUID: 5zW56g5hQ6mxOXFo7Uwd5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="77050851"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 12 Oct 2024 03:28:49 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v3 4/7] i386/cpu: Support thread and module level cache topology
Date: Sat, 12 Oct 2024 18:44:26 +0800
Message-Id: <20241012104429.1048908-5-zhao1.liu@intel.com>
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

Allow cache to be defined at the thread and module level. This
increases flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 target/i386/cpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c84e32c9c303..202bfe5086be 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -241,9 +241,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     uint32_t num_ids = 0;
 
     switch (share_level) {
+    case CPU_TOPOLOGY_LEVEL_THREAD:
+        num_ids = 1;
+        break;
     case CPU_TOPOLOGY_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPOLOGY_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPOLOGY_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -251,10 +257,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
-        /*
-         * Currently there is no use case for THREAD and MODULE, so use
-         * assert directly to facilitate debugging.
-         */
         g_assert_not_reached();
     }
 
-- 
2.34.1


