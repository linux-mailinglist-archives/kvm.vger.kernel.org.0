Return-Path: <kvm+bounces-30841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C58359BDD40
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E77B1F22B89
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18AFC19007E;
	Wed,  6 Nov 2024 02:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bUFWUO+q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB290190462
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861422; cv=none; b=HJF5/pA2coCnpAZlV2IsJ/iBEySvEdYEb3QulE9phr7byRSPHed84QIABxIUv+o+0pSMDFp6yP+aTBsQCjNS4pUx8XtDJkIsA4MCIPBNGHb9AG1qGtPPO2wJW6FEMVZzM2tdj5PSat/wW6YdaMvWgkaMtJqRgCkD8Vzt0CQxAzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861422; c=relaxed/simple;
	bh=cDyoHsWzKph1fodDMEJqXgXb9rXZ334jDEhsYTPjqKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lhIZHPhCK4m+ix0Wz5PrNjFqtcu9vbywba+ymo0A6BedFx5mPt2oiuU4dS5DF5VQPU5X5VgWoDyDbjCG/+eFB7LdJEs3FPFTsbwlBYkEE04Jqt2xWDMeLsggmWMPBORUtlLq+lUbV5Je1FSMe2E4weJXVJSp5uOIPItSV5CdsZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bUFWUO+q; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861421; x=1762397421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cDyoHsWzKph1fodDMEJqXgXb9rXZ334jDEhsYTPjqKQ=;
  b=bUFWUO+qyaX9INMW92NwMiGpYIEiN3icGFrR3HnABmpkzlUPV85Ug5q+
   2ss3HDThgR7XpTd8DtwW8ToC4/B8bOuqE15uM7tnTwO9f0T39en46P/zN
   kYIf/kH+q0mGmVXWD2nyIbO0yq0Q112pLmq6N5FFd5URHzJNqaKyCrKUu
   RXYvynr5s7V5rlfCeyA5rn/+AZpFdhMHapkoXn8l7KYsfA0N7ZgwIJwpp
   7pSvF03oH0wR+KLKN10VeeINBMbQCY0P2LADrvVxouOvw1ci0vu1sXbGd
   cm1XtqEmVcvexjpbNXXMNP/Eu72P8Cc0QPc/RkmWmvQcfR99cViZpv4FK
   Q==;
X-CSE-ConnectionGUID: SwVwo+pqTrmJJ7/LJRSvPw==
X-CSE-MsgGUID: Y1uUnWMBQA+8DrhQ3yWU7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492320"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492320"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:21 -0800
X-CSE-ConnectionGUID: BgQ7aLUUSJ+cgTv2Y4xQFA==
X-CSE-MsgGUID: OQfoaMsiS52eotCldTU9ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078033"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:17 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 10/11] target/i386/kvm: Clean up error handling in kvm_arch_init()
Date: Wed,  6 Nov 2024 11:07:27 +0800
Message-Id: <20241106030728.553238-11-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, there're following incorrect error handling cases in
kvm_arch_init():
* Missed to handle failure of kvm_get_supported_feature_msrs().
* Missed to return when kvm_vm_enable_disable_exits() fails.
* MSR filter related cases called exit() directly instead of returning
  to kvm_init(). (The caller of kvm_arch_init() - kvm_init() - needs to
  know if kvm_arch_init() fails in order to perform cleanup).

Fix the above cases.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
v5: cleaned up kvm_vm_enable_energy_msrs().
v3: new commit.
---
 target/i386/kvm/kvm.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 69825b53b6da..013c0359acbe 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3147,7 +3147,7 @@ static int kvm_vm_enable_userspace_msr(KVMState *s)
     return 0;
 }
 
-static void kvm_vm_enable_energy_msrs(KVMState *s)
+static int kvm_vm_enable_energy_msrs(KVMState *s)
 {
     int ret;
 
@@ -3157,7 +3157,7 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
         if (ret < 0) {
             error_report("Could not install MSR_RAPL_POWER_UNIT handler: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
 
         ret = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
@@ -3165,7 +3165,7 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
         if (ret < 0) {
             error_report("Could not install MSR_PKG_POWER_LIMIT handler: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
 
         ret = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
@@ -3173,17 +3173,17 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
         if (ret < 0) {
             error_report("Could not install MSR_PKG_POWER_INFO handler: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
         ret = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
                              kvm_rdmsr_pkg_energy_status, NULL);
         if (ret < 0) {
             error_report("Could not install MSR_PKG_ENERGY_STATUS handler: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
     }
-    return;
+    return 0;
 }
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3250,7 +3250,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
-    kvm_get_supported_feature_msrs(s);
+    ret = kvm_get_supported_feature_msrs(s);
+    if (ret < 0) {
+        return ret;
+    }
 
     uname(&utsname);
     lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
@@ -3286,6 +3289,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         if (ret < 0) {
             error_report("kvm: guest stopping CPU not supported: %s",
                          strerror(-ret));
+            return ret;
         }
     }
 
@@ -3317,12 +3321,15 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
 
         if (s->msr_energy.enable == true) {
-            kvm_vm_enable_energy_msrs(s);
+            ret = kvm_vm_enable_energy_msrs(s);
+            if (ret < 0) {
+                return ret;
+            }
 
             ret = kvm_msr_energy_thread_init(s, ms);
             if (ret < 0) {
                 error_report("kvm : error RAPL feature requirement not met");
-                exit(1);
+                return ret;
             }
         }
     }
-- 
2.34.1


