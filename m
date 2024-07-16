Return-Path: <kvm+bounces-21724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D35932C76
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FB381C20BA4
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823B819FA9F;
	Tue, 16 Jul 2024 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VZFExEmq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89919F477
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145315; cv=none; b=eW/AqcNQB10a9vqXoHhoQP2z+1aG5ma75/JPaAoj2RnE7p9Ue985IVTuef86FNAcV+hcR+IdWk3c1XTfybIMo0lgEaFscpJhQxSqtvxik0I77qHh3pZCLXlptqqXuwHYdpR2+y9UvhdkeauskXUE3WGSYdi+PskL6r3GV5ylkKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145315; c=relaxed/simple;
	bh=o17ZIKIksTITRMcAguc7dJOs/NSuZsgFkBWTlPrKm8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jajKgIJYNWxm8xilYBYJpdGxJQ23iPgqS+P874OO9+S6dNy/oGCvXvIlZI+B10yJqpJpKvHNsleb9QDR683MjMMsMj9tooJXIjW/3qBFZtV88irMwpzc9EESicZUUPuZ5Y1TlslZM54l255v6xLTqStHCh/QYtqYqjv3Pb24oKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VZFExEmq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145314; x=1752681314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o17ZIKIksTITRMcAguc7dJOs/NSuZsgFkBWTlPrKm8w=;
  b=VZFExEmqlg+bKtRV1xkO1OvpSqzS0tyWpFrXTAnzGOSybDIndpuu2RC9
   GASyFdt+SeKUo/G4SpOoRhLd5zdGJ1a1iulYwTS1YDqbqQKgmg7pd1M4U
   Kg5ggAPcNGiH1Lq2Y5DvBs84wHbWSypy4zpfsN7bQi//As1hQA3IlZpkQ
   bGrbZdDm6YAxb2h4YJBjU9yDITKpkIsd5iAJuWVFQOLhMSVoYN8gxiAZO
   9tgUyj2cn4WT6qjI3FZ1suvytT5EccpnlXYZXky2p6ItJfnG+AZxFPSXZ
   /KwR0/ldJcdyAm3nU77nuyi/9pAyh+BAblnU9xsi1wPxLN2qRgX2W0K74
   g==;
X-CSE-ConnectionGUID: sEg0R3KRQ32exk8cjPZPoQ==
X-CSE-MsgGUID: c3XjDW0PTumIC39j9Z+Ccg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743773"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743773"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:55:07 -0700
X-CSE-ConnectionGUID: s2dEqft1QrKII9T29SAtSg==
X-CSE-MsgGUID: MX4+2bZTRHqNYc+Y7yZYCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788416"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:55:04 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 7/9] target/i386/kvm: Clean up return values of MSR filter related functions
Date: Wed, 17 Jul 2024 00:10:13 +0800
Message-Id: <20240716161015.263031-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At present, the error code of MSR filter enablement attempts to print in
error_report().

Unfortunately, this behavior doesn't work because the MSR filter-related
functions return the boolean and current error_report() use the wrong
return value.

So fix this by making MSR filter related functions return int type and
printing such returned value in error_report().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
v4: Returned kvm_vm_ioctl() directly. (Zide)
v3: new commit.
---
 target/i386/kvm/kvm.c      | 34 ++++++++++++++--------------------
 target/i386/kvm/kvm_i386.h |  4 ++--
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4aae4ffc9ccd..f68be68eb411 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2780,8 +2780,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             }
     }
     if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
-        bool r;
-
         ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
                                 KVM_MSR_EXIT_REASON_FILTER);
         if (ret) {
@@ -2790,9 +2788,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             exit(1);
         }
 
-        r = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
-                           kvm_rdmsr_core_thread_count, NULL);
-        if (!r) {
+        ret = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
+                             kvm_rdmsr_core_thread_count, NULL);
+        if (ret) {
             error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
                          strerror(-ret));
             exit(1);
@@ -5274,13 +5272,13 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
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
@@ -5304,18 +5302,13 @@ static bool kvm_install_msr_filters(KVMState *s)
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
 
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                    QEMUWRMSRHandler *wrmsr)
+int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                   QEMUWRMSRHandler *wrmsr)
 {
-    int i;
+    int i, ret;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
         if (!msr_handlers[i].msr) {
@@ -5325,16 +5318,17 @@ bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
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
+    return 0;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 34fc60774b86..91c2d6e69163 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -74,8 +74,8 @@ typedef struct kvm_msr_handlers {
     QEMUWRMSRHandler *wrmsr;
 } KVMMSRHandlers;
 
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                    QEMUWRMSRHandler *wrmsr);
+int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                   QEMUWRMSRHandler *wrmsr);
 
 #endif /* CONFIG_KVM */
 
-- 
2.34.1


