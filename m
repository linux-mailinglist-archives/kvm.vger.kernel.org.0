Return-Path: <kvm+bounces-30289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E419B8CC8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36220286BFE
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D6F156C70;
	Fri,  1 Nov 2024 08:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bR/1lfUr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2B4839F4
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730448994; cv=none; b=OQE57F8FCZwMOkYSa9RHAUcSljazb5P44bz+7we7jwVRNYdyl/OVAkJz/eEnoMIPuxvUGRzflguHT9JYsI5rjRgEajW5qU3rFaR1wpI1mMd6KDKUJAZ9+izlzVXrpfhfXIKxCPcCzwKUsiwoUaGOVlWe4KnbcchDPot/Ex9j0Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730448994; c=relaxed/simple;
	bh=EGbj8vANOciytGjaNrt6k0e5IUuBc6pcu0CAwcWWiBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZuCeJiDEIN4ykk11JivSVU6c7JqToEHcUU9uX2SeY4LyLI0BjflB0E3wM05wCgtTiLQHNt964CW2gvgj61tyUvsYNjNHLskgDoWQVYSfK4qv5B7g1FDpLF+sKG3+dgWekc7hV5StMV3b41eUcMztIuf74KEjoze4wtdgBt1DAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bR/1lfUr; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730448993; x=1761984993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EGbj8vANOciytGjaNrt6k0e5IUuBc6pcu0CAwcWWiBE=;
  b=bR/1lfUrzGED17znPKbfUj4PV0h7Fw7LXaLJz9pg+DhaxWo+WV91Szi0
   0o8OOnzYiXfYJnjfnSRIbESo5puIn6+01FOt6hslqqtCR7W2cCwJOnzuP
   3Ib8vxGlIBFtfdRyHNwCs7A4ofg+ylje84SEKJWS/MQYYi94tOderu8zk
   SnrlJyC1AwSozPP4Ub0cLne7QfQ9GB0/l+rXX5x4nu9I8hR21+WdaVFLc
   BXy+ErE2WTxmIqS/URpo9YXWtwlCj/EjaD27pApOMYbBoB5DjJhR1jMo4
   WSuLWut1kbJpZjBRZT9ch3EXB9H5f4D9UMXlwkxhgQa2GvzW9AVN5THH4
   w==;
X-CSE-ConnectionGUID: qlHFwpBLTgOU7nVl87A4hw==
X-CSE-MsgGUID: dbde14oEToqWKev1Wg5EMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17846066"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="17846066"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:16:33 -0700
X-CSE-ConnectionGUID: dcN29vuBQH2Be9GsJjYitw==
X-CSE-MsgGUID: uZqiM3dqRvOYw1MHcf0HIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="86834642"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 01 Nov 2024 01:16:27 -0700
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
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v5 6/9] i386/cpu: Support thread and module level cache topology
Date: Fri,  1 Nov 2024 16:33:28 +0800
Message-Id: <20241101083331.340178-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241101083331.340178-1-zhao1.liu@intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
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
index d46710a4030f..09aaed95a856 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -243,9 +243,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
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
@@ -253,10 +259,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
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


