Return-Path: <kvm+bounces-15822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C558B0E99
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E772285DFA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D8A16D4D1;
	Wed, 24 Apr 2024 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H/VMCJEA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CF515FA6A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713972978; cv=none; b=HLDQEGOQv/ElGcb3qMPw5d/D6v6ba33+vJtIGCh6cOUalxUN+gvgr/J8aoHLMLUu9pifF2OxPGA2iyBgPNFrCl8yyk0djCLbaGZuxAHZZBjwe1qZ8qbGj3M90IqOOgN9zUkqKKPWLj5fyxmefIYuheFGfEfvruaEQSnewQvcF7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713972978; c=relaxed/simple;
	bh=OcaGvBTqko2FWPtpMgMPh5cbkqFxJE/4lZyHG11ypss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CeJQTHRkyOtEqVnKmMd+LdVXs+qmKQMrx/Jrf4NQHfx1V2wQvfe0kZtFseVR4m7F7kdK9zI2mmfXwYnyia65LP0Y0f0nSZiyCkUNT95hHr+2vyAVXRzh319rtkjoouJTpHOyWs4kALzNTdI0zcM31s9DvaOOPJhriTRl98XEYXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H/VMCJEA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713972977; x=1745508977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OcaGvBTqko2FWPtpMgMPh5cbkqFxJE/4lZyHG11ypss=;
  b=H/VMCJEAcP+nUmn4aW9pO5QzPtCBLs+F+9my9kz1jF2JEilaiLk6jBAt
   5HNRmJDO65RZ14ptUzdeDC83/B45gavEMRtDi0F2Yijs11seBMXc2dwV8
   bkyP9EYLfmxVYpgBeZkDM4US92NdTt4wsuLju5k4iL+AX6YVE2A64Cdxy
   /4sZHxlxsqTo141DxICnWvgiGr0yForg0nJ9SNXfYLnvH2ob5uvUbwqeE
   8qJqepKh60gwGVFpSMD3gu2xcM0t9b7fWAn0uyRUVgjgZZwj7o8IqATIh
   BR4a3gvOtQkIIgnhU4LL4elgHiOcKixFM+cP914XwHk+qX2YiOzAM6WAu
   A==;
X-CSE-ConnectionGUID: OZk34kDCQhqT29/B499xXA==
X-CSE-MsgGUID: GY2hV0BoTVqaNr8Vy/JwGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545617"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545617"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:36:17 -0700
X-CSE-ConnectionGUID: yf8H39wFS2uFzsQlHY0Wwg==
X-CSE-MsgGUID: UHlSoaLoR2uloqFelLnsGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363061"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:36:13 -0700
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
Subject: [PATCH v11 04/21] hw/core: Support module-id in numa configuration
Date: Wed, 24 Apr 2024 23:49:12 +0800
Message-Id: <20240424154929.1487382-5-zhao1.liu@intel.com>
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

Module is a level above the core, thereby supporting numa
configuration on the module level can bring user more numa flexibility.

This is the natural further support for module level.

Add module level support in numa configuration.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v7:
 * New commit to support module level.
---
 hw/core/machine.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 494b712a7638..0dec48e8021a 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -800,6 +800,11 @@ void machine_set_cpu_numa_node(MachineState *machine,
             return;
         }
 
+        if (props->has_module_id && !slot->props.has_module_id) {
+            error_setg(errp, "module-id is not supported");
+            return;
+        }
+
         if (props->has_cluster_id && !slot->props.has_cluster_id) {
             error_setg(errp, "cluster-id is not supported");
             return;
@@ -824,6 +829,11 @@ void machine_set_cpu_numa_node(MachineState *machine,
                 continue;
         }
 
+        if (props->has_module_id &&
+            props->module_id != slot->props.module_id) {
+                continue;
+        }
+
         if (props->has_cluster_id &&
             props->cluster_id != slot->props.cluster_id) {
                 continue;
@@ -1226,6 +1236,12 @@ static char *cpu_slot_to_string(const CPUArchId *cpu)
         }
         g_string_append_printf(s, "cluster-id: %"PRId64, cpu->props.cluster_id);
     }
+    if (cpu->props.has_module_id) {
+        if (s->len) {
+            g_string_append_printf(s, ", ");
+        }
+        g_string_append_printf(s, "module-id: %"PRId64, cpu->props.module_id);
+    }
     if (cpu->props.has_core_id) {
         if (s->len) {
             g_string_append_printf(s, ", ");
-- 
2.34.1


