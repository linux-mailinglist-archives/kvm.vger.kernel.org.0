Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8F117B45F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCFCVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:21:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:19708 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgCFCVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:21:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 18:21:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413742185"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 18:21:39 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mst@redhat.com, marcel.apfelbaum@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 1/3] i386: Add "pebs" parameter to enable PEBS feature
Date:   Fri,  6 Mar 2020 18:20:03 +0800
Message-Id: <1583490005-27761-2-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
References: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PEBS virtualization enabling in KVM guest will be supported start from
IceLake hardware. This patch introduce a new CPU parameter "pebs" to enable
PEBS feature. The paramter of "pebs" is false by default.

PDCM,DTES64,DTS are needed by PEBS feature. Expose these feature bits to
KVM guest when the KVM support PEBS virtualization and the "pebs" parameter
is true.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 hw/i386/pc.c      |  1 +
 target/i386/cpu.c | 14 ++++++++++++++
 target/i386/cpu.h |  7 +++++++
 3 files changed, 22 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 96715f8..aeb9fb9 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -316,6 +316,7 @@ GlobalProperty pc_compat_1_5[] = {
     { "Nehalem-" TYPE_X86_CPU, "min-level", "2" },
     { "virtio-net-pci", "any_layout", "off" },
     { TYPE_X86_CPU, "pmu", "on" },
+    { TYPE_X86_CPU, "pebs", "on" },
     { "i440FX-pcihost", "short_root_bus", "0" },
     { "q35-pcihost", "short_root_bus", "0" },
 };
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cc586dc..1ca56de 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -3306,6 +3306,7 @@ static void max_x86_cpu_initfn(Object *obj)
     }
 
     object_property_set_bool(OBJECT(cpu), true, "pmu", &error_abort);
+    object_property_set_bool(OBJECT(cpu), true, "pebs", &error_abort);
 }
 
 static const TypeInfo max_x86_cpu_type_info = {
@@ -4511,11 +4512,23 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if ((*ecx & CPUID_EXT_XSAVE) && (env->cr[4] & CR4_OSXSAVE_MASK)) {
             *ecx |= CPUID_EXT_OSXSAVE;
         }
+        if (kvm_enabled() && cpu->enable_pmu && cpu->enable_pebs) {
+            *ecx |= kvm_arch_get_supported_cpuid(cs->kvm_state, 0x1, 0, R_ECX) &
+                                            (CPUID_EXT_PDCM | CPUID_EXT_DTES64);
+        } else {
+            *ecx &= ~(CPUID_EXT_PDCM | CPUID_EXT_DTES64);
+        }
         *edx = env->features[FEAT_1_EDX];
         if (cs->nr_cores * cs->nr_threads > 1) {
             *ebx |= (cs->nr_cores * cs->nr_threads) << 16;
             *edx |= CPUID_HT;
         }
+        if (kvm_enabled() && cpu->enable_pmu && cpu->enable_pebs) {
+            *edx |= kvm_arch_get_supported_cpuid(cs->kvm_state, 0x1, 0, R_EDX) &
+                                            CPUID_DTS;
+        } else {
+            *edx &= ~CPUID_DTS;
+        }
         break;
     case 2:
         /* cache info: needed for Pentium Pro compatibility */
@@ -6129,6 +6142,7 @@ static Property x86_cpu_properties[] = {
 #endif
     DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
+    DEFINE_PROP_BOOL("pebs", X86CPU, enable_pebs, false),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
                        HYPERV_SPINLOCK_NEVER_RETRY),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5352c9f..398810f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1664,6 +1664,13 @@ struct X86CPU {
      */
     bool enable_pmu;
 
+    /* Enable PEBS CPUID bits. This can't be enabled by default yet because
+     * it doesn't have ABI stability guarantees, as it passes all PEBS CPUID
+     * bits returned by GET_SUPPORTED_CPUID (that depend on host CPU and kernel
+     * capabilities) directly to the guest.
+     */
+    bool enable_pebs;
+
     /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
      * disabled by default to avoid breaking migration between QEMU with
      * different LMCE configurations.
-- 
1.8.3.1

