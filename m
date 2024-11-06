Return-Path: <kvm+bounces-30839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 234C39BDD37
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84258B238CF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1871917DB;
	Wed,  6 Nov 2024 02:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwE37OhL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212EE18B47E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861415; cv=none; b=qabGUCIiwALd1Yjl6PLY9LWh3te8AC7eCx1Z8tvGVQHgZjejtAO/SpiYcATzRhurZWqPpWrowk/dvEDcGO/QHN0UAS3o982e1SptEORVi0dCH8QqRXdZhHZLaSsMs8y8gi21o6fkyXU6yYFqTiOfoWCnPvZ6mQ84EOcTDAPajsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861415; c=relaxed/simple;
	bh=jFWGnz+suDCZpSQMmtwVwuQ2yns3DjY1J2pGL1AK0/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qioy7F4/X0vr7y81kCCJv1A2dJcbPlMBQlL02ncsxKncFnS1EduMRUZbJb/yFzHkB4ynWwJEjX1ZV4WhBR6s1x/Whby85/uZ7Z/30D4TSH6mTjNNV5Qp1eDhizcH5vcnVDVPqu47HH82wb+kCxuM68JFeQlH5SBMBcxjSTRR2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iwE37OhL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861414; x=1762397414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jFWGnz+suDCZpSQMmtwVwuQ2yns3DjY1J2pGL1AK0/Y=;
  b=iwE37OhLGRrGZ8aj2/N6/wYrdtbbfHm3ZO+i2GDH02KD/KxdZTJ3LUiQ
   XPVN0238rmBFXr/OKRIU5revLLoc4TGbMLh+F1Jx+HlIJSVyr1y3yn6lt
   A86wAWDAdkgIZ1zj2zaf7vb75Fq+ysYUzL9AIeh1YniJAxq2nG1VM8Dwp
   uD+W+krHYozbEeQspFzcbrGyc4qyJJbLpsPAlnnD73qjCQzstfoq9sMmS
   r+UrtlNSxh2h2fQhj8d4zv++gCYpfhb5XHq7XmR1jACZiwUUt5cARl4Hr
   aqkLTiSows7Xv+IARslRlNLWhRuyOeBluUGoBwmkP5yQp5ZlLMLg4oQwo
   Q==;
X-CSE-ConnectionGUID: SDkFoRFcRBmmpY2sYZoAPw==
X-CSE-MsgGUID: ZgMk9iUXSvqguqXCkLKdoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492300"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492300"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:14 -0800
X-CSE-ConnectionGUID: BHcOIsNZSFyg2LleDmVUXA==
X-CSE-MsgGUID: 0Rm8CO5uTTevGQiWAwOa4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078022"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:11 -0800
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
Subject: [PATCH v5 08/11] target/i386/kvm: Clean up return values of MSR filter related functions
Date: Wed,  6 Nov 2024 11:07:25 +0800
Message-Id: <20241106030728.553238-9-zhao1.liu@intel.com>
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

Before commit 0cc42e63bb54 ("kvm/i386: refactor kvm_arch_init and split
it into smaller functions"), error_report() attempts to print the error
code from kvm_filter_msr(). However, printing error code does not work
due to kvm_filter_msr() returns bool instead int.

0cc42e63bb54 fixed the error by removing error code printing, but this
lost useful error messages. Bring it back by making kvm_filter_msr()
return int.

This also makes the function call chain processing clearer, allowing for
better handling of error result propagation from kvm_filter_msr() to
kvm_arch_init(), preparing for the subsequent cleanup work of error
handling in kvm_arch_init().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
v5: Rebased and cleaned up kvm_vm_enable_energy_msrs() as well.
v4: Returned kvm_vm_ioctl() directly. (Zide)
v3: new commit.
---
 target/i386/kvm/kvm.c | 87 ++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 1fb4bd19fcf7..9993382fb40e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -108,8 +108,8 @@ typedef struct {
 } KVMMSRHandlers;
 
 static void kvm_init_msrs(X86CPU *cpu);
-static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                           QEMUWRMSRHandler *wrmsr);
+static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                          QEMUWRMSRHandler *wrmsr);
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -3135,17 +3135,21 @@ static int kvm_vm_enable_notify_vmexit(KVMState *s)
 
 static int kvm_vm_enable_userspace_msr(KVMState *s)
 {
-    int ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
-                                KVM_MSR_EXIT_REASON_FILTER);
+    int ret;
+
+    ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
+                            KVM_MSR_EXIT_REASON_FILTER);
     if (ret < 0) {
         error_report("Could not enable user space MSRs: %s",
                      strerror(-ret));
         exit(1);
     }
 
-    if (!kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
-                        kvm_rdmsr_core_thread_count, NULL)) {
-        error_report("Could not install MSR_CORE_THREAD_COUNT handler!");
+    ret = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
+                         kvm_rdmsr_core_thread_count, NULL);
+    if (ret < 0) {
+        error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
+                     strerror(-ret));
         exit(1);
     }
 
@@ -3154,36 +3158,37 @@ static int kvm_vm_enable_userspace_msr(KVMState *s)
 
 static void kvm_vm_enable_energy_msrs(KVMState *s)
 {
-    bool r;
+    int ret;
+
     if (s->msr_energy.enable == true) {
-        r = kvm_filter_msr(s, MSR_RAPL_POWER_UNIT,
-                           kvm_rdmsr_rapl_power_unit, NULL);
-        if (!r) {
-            error_report("Could not install MSR_RAPL_POWER_UNIT \
-                                handler");
+        ret = kvm_filter_msr(s, MSR_RAPL_POWER_UNIT,
+                             kvm_rdmsr_rapl_power_unit, NULL);
+        if (ret < 0) {
+            error_report("Could not install MSR_RAPL_POWER_UNIT handler: %s",
+                         strerror(-ret));
             exit(1);
         }
 
-        r = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
-                           kvm_rdmsr_pkg_power_limit, NULL);
-        if (!r) {
-            error_report("Could not install MSR_PKG_POWER_LIMIT \
-                                handler");
+        ret = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
+                             kvm_rdmsr_pkg_power_limit, NULL);
+        if (ret < 0) {
+            error_report("Could not install MSR_PKG_POWER_LIMIT handler: %s",
+                         strerror(-ret));
             exit(1);
         }
 
-        r = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
-                           kvm_rdmsr_pkg_power_info, NULL);
-        if (!r) {
-            error_report("Could not install MSR_PKG_POWER_INFO \
-                                handler");
+        ret = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
+                             kvm_rdmsr_pkg_power_info, NULL);
+        if (ret < 0) {
+            error_report("Could not install MSR_PKG_POWER_INFO handler: %s",
+                         strerror(-ret));
             exit(1);
         }
-        r = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
-                           kvm_rdmsr_pkg_energy_status, NULL);
-        if (!r) {
-            error_report("Could not install MSR_PKG_ENERGY_STATUS \
-                                handler");
+        ret = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
+                             kvm_rdmsr_pkg_energy_status, NULL);
+        if (ret < 0) {
+            error_report("Could not install MSR_PKG_ENERGY_STATUS handler: %s",
+                         strerror(-ret));
             exit(1);
         }
     }
@@ -5842,13 +5847,13 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
     }
 }
 
-static bool kvm_install_msr_filters(KVMState *s)
+static int kvm_install_msr_filters(KVMState *s)
 {
     uint64_t zero = 0;
     struct kvm_msr_filter filter = {
         .flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
     };
-    int r, i, j = 0;
+    int i, j = 0;
 
     for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
@@ -5872,18 +5877,13 @@ static bool kvm_install_msr_filters(KVMState *s)
         }
     }
 
-    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
-    if (r) {
-        return false;
-    }
-
-    return true;
+    return kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
 }
 
-static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                    QEMUWRMSRHandler *wrmsr)
+static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                          QEMUWRMSRHandler *wrmsr)
 {
-    int i;
+    int i, ret;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
         if (!msr_handlers[i].msr) {
@@ -5893,16 +5893,17 @@ static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                 .wrmsr = wrmsr,
             };
 
-            if (!kvm_install_msr_filters(s)) {
+            ret = kvm_install_msr_filters(s);
+            if (ret) {
                 msr_handlers[i] = (KVMMSRHandlers) { };
-                return false;
+                return ret;
             }
 
-            return true;
+            return 0;
         }
     }
 
-    return false;
+    return -EINVAL;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.34.1


