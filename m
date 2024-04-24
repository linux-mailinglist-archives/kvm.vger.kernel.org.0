Return-Path: <kvm+bounces-15821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5398B0ED4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D1ABB2885E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F8016D33F;
	Wed, 24 Apr 2024 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YX0krJnb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7A165FA6
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713972974; cv=none; b=HcQB47THcnJj4CDaAZXVF9FeYL1R9YalghtcXAVdPix787SeVY4rfuftUlsfTprviTjodwgXA7WalYfC/98WROcmAG8yZEwslcKfhriiCPArLyRl9+r4LMyPn9PzbwvNSfB+VK+dGRmjQwlPmcZOWsUTgUNvLHjngqQMG2KBh2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713972974; c=relaxed/simple;
	bh=BiJJ9m2Z798dp/rwix1jX6MrBGu6ttObgcUJOtU28V0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n8H20YO5rHBfX6cz1VM3ykR56iCFrZpGpQbveRsTQVTWhVrMJ2O7Savu4g7nK8uqTmeb9crIdTOFXieWFkDjombllF58Whzp9GpgbvhDsPaoEBvJuQOQWhZDPEt+TDZEwOE+squQAVu5OWr/LMFmistIcGHS9xCojeQvPZM8Ueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YX0krJnb; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713972973; x=1745508973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BiJJ9m2Z798dp/rwix1jX6MrBGu6ttObgcUJOtU28V0=;
  b=YX0krJnbJb5jCLr3KolSaK6Y3ielfMtegqrNQWCWyrxNhTmXsziPKblB
   Wnvn2/0u2Vh85AMRPNHMfIORlyt/lmOmTP4UlvtZ6rWSfNUSRsxdUQcdv
   N5EDTPdi7IbAi7ppmVQEpOkWxvpX+wlQHU/V0bGbugaMZqeqYwwk7ghh8
   b/n6RUWgaQ0U6CBqpFhdXfx2v4faKgvUpKIyEYe3fcyBicvqgNDZQWeJ6
   PaKPEijVhKlRhlgGXyevl+Nq1g57rWINA73CWhaXj54KB6LUnYWrtSb5R
   WKa2Hk7VENNsEu5wIDIeXYZKao7a4LRJPdlvl74R3kqPpIceD+32QRGsv
   A==;
X-CSE-ConnectionGUID: 4f8B87h9QFOdDeEarXerLw==
X-CSE-MsgGUID: ZBCjMxXJREOUa+DQmK/tlg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545602"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545602"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:36:12 -0700
X-CSE-ConnectionGUID: 5NvLG1l4SPaJ5E1lnMOltQ==
X-CSE-MsgGUID: 6wVQvm77QwmgE3zPCkP1Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363058"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:36:08 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v11 03/21] hw/core: Introduce module-id as the topology subindex
Date: Wed, 24 Apr 2024 23:49:11 +0800
Message-Id: <20240424154929.1487382-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add module-id in CpuInstanceProperties, to locate the CPU with module
level.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes since v10:
 * Rebased on commit 88daa112d4eda.

Changes since v7:
 * New commit to introduce module_id to locate the CPU with module
   level.
---
 hw/core/machine-hmp-cmds.c | 4 ++++
 qapi/machine.json          | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index a6ff6a487583..8701f00cc7cc 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -87,6 +87,10 @@ void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict)
             monitor_printf(mon, "    cluster-id: \"%" PRIu64 "\"\n",
                            c->cluster_id);
         }
+        if (c->has_module_id) {
+            monitor_printf(mon, "    module-id: \"%" PRIu64 "\"\n",
+                           c->module_id);
+        }
         if (c->has_core_id) {
             monitor_printf(mon, "    core-id: \"%" PRIu64 "\"\n", c->core_id);
         }
diff --git a/qapi/machine.json b/qapi/machine.json
index 252cd019f62e..577e514e3b9d 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -925,6 +925,9 @@
 # @cluster-id: cluster number within the parent container the CPU
 #     belongs to (since 7.1)
 #
+# @module-id: module number within the parent container the CPU belongs
+#     to (since 9.1)
+#
 # @core-id: core number within the parent container the CPU belongs to
 #
 # @thread-id: thread number within the core the CPU  belongs to
@@ -942,6 +945,7 @@
             '*socket-id': 'int',
             '*die-id': 'int',
             '*cluster-id': 'int',
+            '*module-id': 'int',
             '*core-id': 'int',
             '*thread-id': 'int'
   }
-- 
2.34.1


