Return-Path: <kvm+bounces-21619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5842B930D40
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CD6D2812DD
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2C21836D8;
	Mon, 15 Jul 2024 04:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hU/RvBB0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE5139CF7
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018081; cv=none; b=r/OT5s+IBNnPjT5OZ6Kr25JP45B71Q5fPfJ18gmmTiQXOdLzNaOwlyjUwzEim8CsKq95hneldHLP1LcANWm63+sKC8ZzhihDY3bppVlomF8EcFijmn87D+vlzTDCD+leG4XIXE7s7E12HnKjE/jWA8Z6kv0jcqJkDa8iT/V9chw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018081; c=relaxed/simple;
	bh=yLNWhHrtOyoeQooeafFrZVJbCO/Btc3+xL/n3wetEgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bclXdwraPdRM3lEg+gCgXCvR9Ii+TYx8FET/JKmMlcfK4F0vO5zpR1pxCR6uXdjAPatKb+gdNNqzWCzBTpKvnbBNyMGIGO9MGashMG6oPAPBjupDgbtcwVK8h6wKoSqXi6j9Kgw4qhhlszUuEtyGKOoi2qfh8MuD+X1xB58+KKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hU/RvBB0; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018080; x=1752554080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yLNWhHrtOyoeQooeafFrZVJbCO/Btc3+xL/n3wetEgs=;
  b=hU/RvBB0D48QmKyGQCQE7GGw8XRtYHt/hT+W2Ww3kha1FeIFQcI5eg8R
   Dvvfj0nbsAAURngupVsBQevcumeQIWCXXAr4N936kMQHr8Fwc4qLK/SE4
   vrKxg2k6sUmbLaLkvnwR2hO1ySUB0Jw73Z1MYOBUaaY2z2mCobehCQDTs
   aUrImMGrCQ/3RWkVIE7FeVpodUSgZif2KauD5MG6xO7rE//H/+RpemrnF
   0aYIsXR2ZGS1DLBlg6TcPcoMpNSagOVrY3EK5+j1HwpuYuy1T0+ANAUl0
   uz9EVBi1Tj7aQyDI+xnRDJM+pjgJ2NN4tZRHl9AxFuOwEqX/vpnCMr0IY
   Q==;
X-CSE-ConnectionGUID: 3dy+P2qfQXGLgeQp2al5vQ==
X-CSE-MsgGUID: WzWSuiVARkm5i7EKAtQqyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809858"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809858"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:40 -0700
X-CSE-ConnectionGUID: VWjhGhwBQdCqLgABca1ilg==
X-CSE-MsgGUID: 6DEZMmFoTTOlfpcrOYp8jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043137"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:36 -0700
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
Subject: [PATCH v3 7/8] target/i386/kvm: Clean up return values of MSR filter related functions
Date: Mon, 15 Jul 2024 12:49:54 +0800
Message-Id: <20240715044955.3954304-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240715044955.3954304-1-zhao1.liu@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At present, the error code of MSR filter enablement is attempted to be
printed in error_report().

Unfortunately, this behavior doesn't work because the MSR filter-related
functions return the boolean and current error_report() use the wrong
return value.

So fix this by making MSR filter related functions return int type and
printing such returned value in error_report().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c      | 35 +++++++++++++++++------------------
 target/i386/kvm/kvm_i386.h |  4 ++--
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4aae4ffc9ccd..0fd1d099ae4c 100644
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
+    int ret, i, j = 0;
 
     for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
@@ -5304,18 +5302,18 @@ static bool kvm_install_msr_filters(KVMState *s)
         }
     }
 
-    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
-    if (r) {
-        return false;
+    ret = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
+    if (ret) {
+        return ret;
     }
 
-    return true;
+    return 0;
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
@@ -5325,16 +5323,17 @@ bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
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


