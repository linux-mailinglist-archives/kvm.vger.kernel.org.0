Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D03DB61E
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 11:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbhG3JhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 05:37:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:57977 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238156AbhG3JhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 05:37:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="212792022"
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208,223";a="212792022"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:36:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208,223";a="518877153"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.173.176]) ([10.249.173.176])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:36:50 -0700
Subject: Re: [PATCH V9 16/18] KVM: x86/pmu: Add kvm_pmu_cap to optimize
 perf_get_x86_pmu_capability
To:     Zhu Lingshan <lingshan.zhu@intel.com>, peterz@infradead.org,
        pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>
References: <20210722054159.4459-1-lingshan.zhu@intel.com>
 <20210722054159.4459-17-lingshan.zhu@intel.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <273440d2-4740-d2c1-198b-e8b8c1551fd7@linux.intel.com>
Date:   Fri, 30 Jul 2021 17:36:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722054159.4459-17-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From d0f334ff3e5c585893f0a341c7bdc65fd570bd06 Mon Sep 17 00:00:00 2001
From: Like Xu <like.xu@linux.intel.com>
Date: Wed, 14 Apr 2021 19:40:46 +0800
Subject: [PATCH V9 16/18] KVM: x86/pmu: Add kvm_pmu_cap to optimize
  perf_get_x86_pmu_capability

The information obtained from the interface perf_get_x86_pmu_capability()
doesn't change, so an exported "struct x86_pmu_capability" is introduced
for all guests in the KVM, and it's initialized before hardware_setup().

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
  arch/x86/kvm/cpuid.c         | 26 ++++++++------------------
  arch/x86/kvm/pmu.c           |  3 +++
  arch/x86/kvm/pmu.h           | 20 ++++++++++++++++++++
  arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++---------
  arch/x86/kvm/x86.c           |  9 ++++-----
  5 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..647bff490c0d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -745,33 +745,23 @@ static inline int __do_cpuid_func(struct 
kvm_cpuid_array *array, u32 function)
      case 9:
          break;
      case 0xa: { /* Architectural Performance Monitoring */
-        struct x86_pmu_capability cap;
          union cpuid10_eax eax;
          union cpuid10_edx edx;

-        perf_get_x86_pmu_capability(&cap);
+        eax.split.version_id = kvm_pmu_cap.version;
+        eax.split.num_counters = kvm_pmu_cap.num_counters_gp;
+        eax.split.bit_width = kvm_pmu_cap.bit_width_gp;
+        eax.split.mask_length = kvm_pmu_cap.events_mask_len;
+        edx.split.num_counters_fixed = kvm_pmu_cap.num_counters_fixed;
+        edx.split.bit_width_fixed = kvm_pmu_cap.bit_width_fixed;

-        /*
-         * Only support guest architectural pmu on a host
-         * with architectural pmu.
-         */
-        if (!cap.version)
-            memset(&cap, 0, sizeof(cap));
-
-        eax.split.version_id = min(cap.version, 2);
-        eax.split.num_counters = cap.num_counters_gp;
-        eax.split.bit_width = cap.bit_width_gp;
-        eax.split.mask_length = cap.events_mask_len;
-
-        edx.split.num_counters_fixed = min(cap.num_counters_fixed, 
MAX_FIXED_COUNTERS);
-        edx.split.bit_width_fixed = cap.bit_width_fixed;
-        if (cap.version)
+        if (kvm_pmu_cap.version)
              edx.split.anythread_deprecated = 1;
          edx.split.reserved1 = 0;
          edx.split.reserved2 = 0;

          entry->eax = eax.full;
-        entry->ebx = cap.events_mask;
+        entry->ebx = kvm_pmu_cap.events_mask;
          entry->ecx = 0;
          entry->edx = edx.full;
          break;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d957c1e83ec9..ec10a635b057 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,9 @@
  #include "lapic.h"
  #include "pmu.h"

+struct x86_pmu_capability __read_mostly kvm_pmu_cap;
+EXPORT_SYMBOL_GPL(kvm_pmu_cap);
+
  /* This is enough to filter the vast majority of currently defined 
events. */
  #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5795bb113e76..1903c0fe01ca 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -160,6 +160,24 @@ static inline bool pmc_speculative_in_use(struct 
kvm_pmc *pmc)
      return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
  }

+extern struct x86_pmu_capability kvm_pmu_cap;
+
+static inline void kvm_init_pmu_capability(void)
+{
+    perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+    /*
+     * Only support guest architectural pmu on
+     * a host with architectural pmu.
+     */
+    if (!kvm_pmu_cap.version)
+        memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+
+    kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+    kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
+                         MAX_FIXED_COUNTERS);
+}
+
  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
  void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
  void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
@@ -177,9 +195,11 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
  void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
  void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_init_pmu_capability(void);

  bool is_vmware_backdoor_pmc(u32 pmc_idx);

  extern struct kvm_pmu_ops intel_pmu_ops;
  extern struct kvm_pmu_ops amd_pmu_ops;
+
  #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index afdc9796fe4e..05bc218c08df 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -504,8 +504,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
  {
      struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
      struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
-
-    struct x86_pmu_capability x86_pmu;
      struct kvm_cpuid_entry2 *entry;
      union cpuid10_eax eax;
      union cpuid10_edx edx;
@@ -532,13 +530,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
          return;

      vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
-    perf_get_x86_pmu_capability(&x86_pmu);

      pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
-                     x86_pmu.num_counters_gp);
-    eax.split.bit_width = min_t(int, eax.split.bit_width, 
x86_pmu.bit_width_gp);
+                     kvm_pmu_cap.num_counters_gp);
+    eax.split.bit_width = min_t(int, eax.split.bit_width,
+                    kvm_pmu_cap.bit_width_gp);
      pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) 
- 1;
-    eax.split.mask_length = min_t(int, eax.split.mask_length, 
x86_pmu.events_mask_len);
+    eax.split.mask_length = min_t(int, eax.split.mask_length,
+                      kvm_pmu_cap.events_mask_len);
      pmu->available_event_types = ~entry->ebx &
                      ((1ull << eax.split.mask_length) - 1);

@@ -547,9 +546,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
      } else {
          pmu->nr_arch_fixed_counters =
              min_t(int, edx.split.num_counters_fixed,
-                  x86_pmu.num_counters_fixed);
-        edx.split.bit_width_fixed = min_t(int,
-            edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
+                  kvm_pmu_cap.num_counters_fixed);
+        edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
+                          kvm_pmu_cap.bit_width_fixed);
          pmu->counter_bitmask[KVM_PMC_FIXED] =
              ((u64)1 << edx.split.bit_width_fixed) - 1;
      }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aff745f819f5..9ea250e8afb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6176,15 +6176,12 @@ long kvm_arch_vm_ioctl(struct file *filp,

  static void kvm_init_msr_list(void)
  {
-    struct x86_pmu_capability x86_pmu;
      u32 dummy[2];
      unsigned i;

      BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
               "Please update the fixed PMCs in msrs_to_saved_all[]");

-    perf_get_x86_pmu_capability(&x86_pmu);
-
      num_msrs_to_save = 0;
      num_emulated_msrs = 0;
      num_msr_based_features = 0;
@@ -6236,12 +6233,12 @@ static void kvm_init_msr_list(void)
              break;
          case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
              if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-                min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+                min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
                  continue;
              break;
          case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 
+ 17:
              if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-                min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+                min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
                  continue;
              break;
          default:
@@ -11055,6 +11052,8 @@ int kvm_arch_hardware_setup(void *opaque)
      if (boot_cpu_has(X86_FEATURE_XSAVES))
          rdmsrl(MSR_IA32_XSS, host_xss);

+    kvm_init_pmu_capability();
+
      r = ops->hardware_setup();
      if (r != 0)
          return r;
-- 
2.27.0


