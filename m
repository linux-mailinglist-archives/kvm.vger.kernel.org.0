Return-Path: <kvm+bounces-35050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFA4A09387
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 137C5188BFB9
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AF2211295;
	Fri, 10 Jan 2025 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XcpbFtCy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1730211269
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519575; cv=none; b=GYyHLLtJhLLc25lypOw9w9WUT1em+NxxUy2P4TA5e4r6iEW6H7Z0ezjcl5/FF/qxA84TgYSXbApNeiKyQLr82F9jl5rxbss91xSrOeZ0MR6hT4emy9oZ3ICFxWqZ925X54DDkulw7RODeH03O8itzeCTFAoR0o6vC8cqwNMdZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519575; c=relaxed/simple;
	bh=XxcawsJjwt0uXtrUPQPiiDtVrQo5u15mRughzFtF3CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDEH9ypL38KZPb9KwUYxxKjqLW8z6JL1Lk4PjO0ZsKqHUJpV4gCDxBnw78K49wGRYNPAAg4Um8Z1/3hxd5YHx1DydkS4v6UDlz3SEYX/nzVUTFp3t5M8JiydoqNv8U71slU04jr7guz0ai735Iv96ISFhqIqYXEVwwHVNNuCiY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XcpbFtCy; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736519573; x=1768055573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XxcawsJjwt0uXtrUPQPiiDtVrQo5u15mRughzFtF3CA=;
  b=XcpbFtCy+eDcp0FO7vhOanV3bZIA2kgiXz0pjL2e+oGrKWqc25AWybSO
   +yNlYIOnYAPBd8CiAnV/uQitmh1P7XUAcaDnl3pDHZMxsyv0nIeXsmz/e
   xrx3E1BenKCyHIHQ9xx00o3IGQZsEwSB/07sSWpXbo216N8b/sIkT4qhp
   PUL4XrWl9K8MQSUSMe/naozdb9GsDdXcuAAE+PBRQ4qyZmkfeVXddzb5e
   Eyc5+b77e9XrgoaXC265ntmLd0LDE1614D8YjN59NVCh8P2tYBNDYR1AQ
   ORPSJGKRxO2S0Bi0OxGt+bvWUpNccRp970+QFrfxTgxNcoKN1pWLo/kjP
   A==;
X-CSE-ConnectionGUID: pXWzxg+ISCOAr8zJ5DUBSQ==
X-CSE-MsgGUID: iMgBLPUIQ1KUmKEMZYK6qA==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="62185495"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="62185495"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:32:53 -0800
X-CSE-ConnectionGUID: PR4HNW4MTkajG7vPAYKR3A==
X-CSE-MsgGUID: /U+Vy3fNTjKRlYyQ4MXoEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108790809"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 10 Jan 2025 06:32:50 -0800
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
Subject: [PATCH v7 RESEND 1/5] hw/core/machine: Reject thread level cache
Date: Fri, 10 Jan 2025 22:51:11 +0800
Message-Id: <20250110145115.1574345-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
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

Additionally, since ARM even can't support this special cache topology
in device tree, it is unnecessary to support it at this moment, even
though per-thread cache might have potential scheduling benefits for
VMs without CPU affinity.

Therefore, disable thread-level cache topology in the general machine
part. At present, i386 has not enabled SMP cache, so disabling the
thread parameter does not pose compatibility issues.

In the future, if there is a clear demand for this feature, the correct
approach would be to add a new control field in MachineClass.smp_props
and enable it only for the machines that require it.

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


