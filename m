Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB793BF300
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGHA6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhGHA6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696067"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696067"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770024"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:54 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 11/44] i386/tdx: Implement user specified tsc frequency
Date:   Wed,  7 Jul 2021 17:54:41 -0700
Message-Id: <564e6ae089c30aaba9443294ecca72da9ee7b7c4.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Reuse -cpu,tsc-frequency= to get user wanted tsc frequency and pass it
to KVM_TDX_INIT_VM.

Besides, sanity check the tsc frequency to be in the legal range and
legal granularity (required by SEAM module).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/kvm.c |  8 ++++++++
 target/i386/kvm/tdx.c | 16 ++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ecb1714920..be0b96b120 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -763,6 +763,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
     int r, cur_freq;
     bool set_ioctl = false;
 
+    /*
+     * TD guest's TSC is immutable, it cannot be set/changed via
+     * KVM_SET_TSC_KHZ, but only be initialized via KVM_TDX_INIT_VM
+     */
+    if (vm_type == KVM_X86_TDX_VM) {
+        return 0;
+    }
+
     if (!env->tsc_khz) {
         return 0;
     }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e8c70f241d..c50a0dcf11 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -29,6 +29,8 @@
 
 #define TDX1_TD_ATTRIBUTE_DEBUG BIT_ULL(0)
 #define TDX1_TD_ATTRIBUTE_PERFMON BIT_ULL(63)
+#define TDX1_MIN_TSC_FREQUENCY_KHZ (100 * 1000)
+#define TDX1_MAX_TSC_FREQUENCY_KHZ (10 * 1000 * 1000)
 
 bool kvm_has_tdx(KVMState *s)
 {
@@ -91,6 +93,19 @@ void tdx_pre_create_vcpu(CPUState *cpu)
         exit(1);
     }
 
+    if (env->tsc_khz && (env->tsc_khz < TDX1_MIN_TSC_FREQUENCY_KHZ ||
+                         env->tsc_khz > TDX1_MAX_TSC_FREQUENCY_KHZ)) {
+        error_report("Invalid TSC %ld KHz, must specify cpu_frequecy between [%d, %d] kHz\n",
+                      env->tsc_khz, TDX1_MIN_TSC_FREQUENCY_KHZ,
+                      TDX1_MAX_TSC_FREQUENCY_KHZ);
+        exit(1);
+    }
+
+    if (env->tsc_khz % (25 * 1000)) {
+        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz\n", env->tsc_khz);
+        exit(1);
+    }
+
     qemu_mutex_lock(&tdx->lock);
     if (tdx->initialized) {
         goto out;
@@ -103,6 +118,7 @@ void tdx_pre_create_vcpu(CPUState *cpu)
     cpuid_data.cpuid.padding = 0;
 
     init_vm.max_vcpus = ms->smp.cpus;
+    init_vm.tsc_khz = env->tsc_khz;
     init_vm.attributes = 0;
     init_vm.attributes |= tdx->debug ? TDX1_TD_ATTRIBUTE_DEBUG : 0;
     init_vm.attributes |= x86cpu->enable_pmu ? TDX1_TD_ATTRIBUTE_PERFMON : 0;
-- 
2.25.1

