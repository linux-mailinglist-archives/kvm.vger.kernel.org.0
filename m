Return-Path: <kvm+bounces-18384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6488D4914
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54081C219EE
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD87176AC5;
	Thu, 30 May 2024 10:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lx+aizFs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE46F2FB
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063248; cv=none; b=lwB/cmGxqHHvVvHbpBOv2KPKCsUosOBFArzVJB2BYfZzE1dHXoofwieF7tgcxfz6GWpAy9WoXP5H4s4kE9SRHQTZlhxPpiCF1I+IOicbZMvYh+RN4BOH2LDlGlzk0r+vsOFkE7VYAeMTa8BQCZJxEEqR+cN7+qWy3b3IogqWmDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063248; c=relaxed/simple;
	bh=iUVuwDv8IlCBNKOZ1ofL/GWf0HNwQI4LTyFUGM4Cs7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=btt3SRSrCWo1Z12tX7cEj5OYSzgtUpNB+jzg+C0jn6vuopZzj+JAB1o8vo/SUSkMCFcTlIssOsmGUG6PaVXE0wdMUDoQuTmS1mw40HG5CftEIPi+k17b7dYVQit+t6zhB+aWCthMfJ3IFWisDCdqYkdPlonFW0Z/96hoZRPitM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lx+aizFs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063247; x=1748599247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iUVuwDv8IlCBNKOZ1ofL/GWf0HNwQI4LTyFUGM4Cs7g=;
  b=Lx+aizFs8WI99xcR0QfELw3tldteGxOrJIjnepDsk+XJk/9EOAdwlvVz
   riKNb/uiktfLP1sYxxch5NPu4Ra+zgFk9HgeFsd5tnZb6bybpgZtZc7m5
   lCdmAK0tD5vruQsFpyW+xaG9PFg9FBT+tcFZb4yCy7anVAIMRHpGbqyoM
   pDl3HA4YA7ZmkXHIDzkaoiqyj4LrNgy8OGrSsK36ZNSHWd0MAQbgft11o
   Hec018Yzu32kcVyVISUlF4jnXUoViGJW5L6cHWi5RGbHykbjxtw2jCXNe
   SSCFRf0nvFgIcndaQ4V/QhLAAOUV2Pv8s7nSp6UkHXbud3AgIJ+4N/pte
   g==;
X-CSE-ConnectionGUID: vBIEqF1+TPanKFkKLBNjRQ==
X-CSE-MsgGUID: RzklqnwcSLaJ6PABT8gt/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032540"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032540"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:47 -0700
X-CSE-ConnectionGUID: 9uWka8WTQZqxrJEPByh1OA==
X-CSE-MsgGUID: 5Q3UyZ3qRfeH+DYgEY/FpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705073"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:42 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 4/7] i386/cpu: Support thread and module level cache topology
Date: Thu, 30 May 2024 18:15:36 +0800
Message-Id: <20240530101539.768484-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows cache to be defined at the thread and module level. This
increases flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b11097b5bafd..3a2dadb4bce0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -241,9 +241,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     uint32_t num_ids = 0;
 
     switch (share_level) {
+    case CPU_TOPO_LEVEL_THREAD:
+        num_ids = 1;
+        break;
     case CPU_TOPO_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPO_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPO_LEVEL_DIE:
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


