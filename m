Return-Path: <kvm+bounces-41783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7336A6D498
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 08:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06FAF3ABCE6
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 07:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE512505DA;
	Mon, 24 Mar 2025 07:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoGwIImQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CED2505C3
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 07:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800128; cv=none; b=RctTmOY2bRSLXj72l8kSrFxuZvC5swDkiR2685GynBRr046f0Yh0ars98NNTgD+6xwri1Pv/haBK+VNO1fk6r0Vj8xQne4eLYe3msHR2wepCGBZ75HwOV1bmerOc4HZBXWvR1HYA20w1PMCud3N+uE/WTKJhQMV8niB+kI9KSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800128; c=relaxed/simple;
	bh=RSPvGIZxsfM4bA/IY36Wq0EbC6TmhSvPF08yfS2Nt4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AYVxAGxQty2283MOA6eb+ud+HvkjRn/QnY4+04IzKdZOZvInEw4cHAxn2noIQBnnzQ1n60V2B4hqVZiwYTxOnPs9eVwCx8gvlB9/gJ2teuyKCw6m/y2FW2ortHluNxKlopbt4D1kUKh+YDY8hRoE7nxZsc0BXb+DkfimEmAthCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoGwIImQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742800127; x=1774336127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RSPvGIZxsfM4bA/IY36Wq0EbC6TmhSvPF08yfS2Nt4k=;
  b=MoGwIImQ0XhFl5lW6cjo7ROm0Pufu0daxxxsgaT6o1DE+l536+CIbq/o
   pAbfbsHpN6OLuHuvfQkGbOHoJzW6OeZNttsVbqYnHtHge6k3NE+H50D7D
   Pkfk1uSW9ogsqb0jxwpzqb6nDXOixR0JWU6qB5+cgpVWXQU3/F0dvlU23
   YFhBEUheGMlgL3kdJRfznOYe9BFs9RGiEJZEOPPm+MXY2W2aAAhsWVtxb
   +hEo7KbLgBuABUtJmTwMN8nEDUKrPIS1xyH3cYT5G4VXvIBqC/uMFBaN0
   m8olmH0CrCh5i/7G+22mQWvb2YDvEy+OCPnhr1k6TDXKStajlDeRphM39
   w==;
X-CSE-ConnectionGUID: Q+prNaCwQUmu9enr+fEsmA==
X-CSE-MsgGUID: nLcm9R4TRwyGsrgag9NtVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="31588465"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="31588465"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 00:08:47 -0700
X-CSE-ConnectionGUID: h7j1ukYCQSqoT6dryF50Bw==
X-CSE-MsgGUID: 6xu+B54JQaiEpUbobTY1pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="123944393"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa007.fm.intel.com with ESMTP; 24 Mar 2025 00:08:44 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Mingwei Zhang <mizhang@google.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 2/3] target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to enable/disable PMU
Date: Mon, 24 Mar 2025 12:37:11 +0000
Message-Id: <20250324123712.34096-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After introducing mediated vPMU, mediated vPMU must be enabled by
explicitly calling KVM_CAP_PMU_CAPABILITY to enable. Thus call
KVM_CAP_PMU_CAPABILITY to enable/disable PMU base on user configuration.

Suggested-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 target/i386/kvm/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f41e190fb8..d3e6984844 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2051,8 +2051,25 @@ full:
     abort();
 }
 
+static bool pmu_cap_set = false;
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
+    KVMState *s = kvm_state;
+    X86CPU *x86_cpu = X86_CPU(cpu);
+
+    if (!pmu_cap_set && kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
+        int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                  KVM_PMU_CAP_DISABLE & !x86_cpu->enable_pmu);
+        if (r < 0) {
+            error_report("kvm: Failed to %s pmu cap: %s",
+                         x86_cpu->enable_pmu ? "enable" : "disable",
+                         strerror(-r));
+            return r;
+        }
+
+        pmu_cap_set = true;
+    }
+
     return 0;
 }
 
-- 
2.40.1


