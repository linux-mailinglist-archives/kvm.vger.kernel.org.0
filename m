Return-Path: <kvm+bounces-29411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 526B19AA349
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14083284207
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD2819E810;
	Tue, 22 Oct 2024 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Is6D/ysw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BF19D8A8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604202; cv=none; b=q5GTkoi2tnohao3cMpfs9DwDX0aZtKHnViyucIEVVwE73XvOl4CgCjMwNsMRYggyggMR/o42hYE9nJ6Iqun6JdHs+Q3StMvYi+7NDgUkLVcH/qSRD9a2M9xv2TFEd8YjDhU6mI8SNkp53IwNMutMhsfRLBmAwsuutFwskajdMFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604202; c=relaxed/simple;
	bh=QiNSK6DAQM/vMK0hhZySRePzcs3gJqhWvw2eEAcE7DQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MEdNX1PvPzGOxfnGrIBrOvymMFJqw0/9kOS0/fDtMtLrxXknpP19spGb0Xc3kvv8+xh7kpg7K94lP4s0SmVQA+IxX83cZCUPyl8MnnjMg9S+NJcZUxdHjvvtZyeS6l2mDkqO8P2k+eTyw0EroVDl7kD4lDzcgMZbp01JcbXhzqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Is6D/ysw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729604200; x=1761140200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QiNSK6DAQM/vMK0hhZySRePzcs3gJqhWvw2eEAcE7DQ=;
  b=Is6D/yswGjxIBi+PNACxKoagi1H4gYBloX5kIvcrEHK7TfHP1Dbg+2hZ
   SG1TCx3lcEgL9V348LjIrrWxp2xTraBBrkDa3R/Jg3g9HaUDBPi4Zt+pv
   OOV33RwHmxuXP6AV4WIV02jpD3dCvYMezfIMIivF5QImIGaonfaPRAfRX
   IG7DCv/aUq7E1Mwg08zxPtaIGFLjA8DNyt/rrdmvVm+ebUZGu0WKdGPIB
   2czlnu1W59tU+wy6CtBlll2WUPWFEeAljNNFQ5svlDM8Ar1/3blofAp27
   Vc7t7Wtd8uXGx4c3BTH0RAQj/q7wfcrAdtI5ddcxP4/3QSQ/d5JIcG1Ei
   Q==;
X-CSE-ConnectionGUID: yR3Ti4+ySEekUxFDHjxQIA==
X-CSE-MsgGUID: NwE6jbDmQf2LA091K7ggKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46603723"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46603723"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:36:40 -0700
X-CSE-ConnectionGUID: PDm5F9Q+Rs6pChB6l5swYQ==
X-CSE-MsgGUID: opfRim5ZRSuIaDccgRUNrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79782413"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 22 Oct 2024 06:36:35 -0700
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
Subject: [PATCH v4 6/9] i386/cpu: Support thread and module level cache topology
Date: Tue, 22 Oct 2024 21:51:48 +0800
Message-Id: <20241022135151.2052198-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241022135151.2052198-1-zhao1.liu@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
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
index f1cbcaf9f4ad..3a5b5557f74b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -240,9 +240,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
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
@@ -250,10 +256,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
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


