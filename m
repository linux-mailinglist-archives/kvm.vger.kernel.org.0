Return-Path: <kvm+bounces-42227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 054CBA75DA4
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 03:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E052188A4E4
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 01:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2DE78F5D;
	Mon, 31 Mar 2025 01:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oKH9EpZc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C772A14A62B
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 01:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384954; cv=none; b=CLQ7ff2H5Sh+NQOopw0CbgR4ejRQp8SRX/dQCaAvM2lCsFh9DpxnbvNls3X4VeT2gJOvNSTFgZuFBePptKKdUmPzMcsGYOO9HoO+jagOPLTTqV6EgC2P34yvy060bq2NpmBFwSk/ysVx4lD8CW4zfZRX8oGb3TRVmSmKQRrmmLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384954; c=relaxed/simple;
	bh=xAm2YY9D6PwcyH57kyJhBAAKNeO7ORsoVvbbW031qSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gP7NeNsFmESn7PesGKU517t/I0Rx2VGwyos9/uZTJ6O1CYGOVGDabsFvBkVbWSiRR8xidhbrIsIQv7aW7AnklBHGE7ifDgGR+NdOPOqyZ+R+n3OEYqoug8zHQAOOcvoWcR5zNvEXQslodvyDoOeMIkF26q7/G2yaodnYLS+YzEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oKH9EpZc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNTZ8v011031;
	Mon, 31 Mar 2025 01:35:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=gNfYS
	YSHGyIGq/t7Lz0FEYItLc7Lb8bLr9w9ZxOVhYE=; b=oKH9EpZcsyJNv61ayHX3P
	e1UVT7K27INuVBef3lqvuYhsCDY6jgtKUX5V0zSr90GgeoL/gBuoezqtpTVeqnJV
	egLIHzVFVkE13xmfqA1RHXdIfxWjmobepoLyHqTQKoLroae2KLe2kjjeA35afP9+
	nmu1I/IMwpi2rXBpkUCYImGeK3Y+2S3ciH8+IEpGPJ5tVF1pH7t5J9mvG6Jbg0PN
	z7LMC+/Vz1E5xe0Nf7bcF0B39zb0Gt96qgfm72pzcqVQyFY4GvVZXrLuydEUgTqN
	+veFY8/HzIC0mrf5fL8ELzYv9F1dcG7aP+u7FXwBd+WIZKIxdyFyNLKRzJMXjK+e
	Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n22fhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:35:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52V0ELdb033698;
	Mon, 31 Mar 2025 01:35:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7ddtu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:35:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52V1YfxV015214;
	Mon, 31 Mar 2025 01:34:59 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45p7a7ddms-9;
	Mon, 31 Mar 2025 01:34:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: [PATCH v3 08/10] target/i386/kvm: reset AMD PMU registers during VM reset
Date: Sun, 30 Mar 2025 18:32:27 -0700
Message-ID: <20250331013307.11937-9-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250331013307.11937-1-dongli.zhang@oracle.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-30_11,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503310009
X-Proofpoint-ORIG-GUID: Daysmjvhe9B-tHRatqi5Iu1B5f6rRSzq
X-Proofpoint-GUID: Daysmjvhe9B-tHRatqi5Iu1B5f6rRSzq

QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
and kvm_put_msrs() to restore them to KVM. However, there is no support for
AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
initialized based on cpuid(0xa), which does not apply to AMD processors.
For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
is determined based on the CPU version.

To address this issue, we need to add support for AMD PMU registers.
Without this support, the following problems can arise:

1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
running "perf top", the PMU registers are not disabled properly.

2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
does not handle AMD PMU registers, causing some PMU events to remain
enabled in KVM.

3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
preventing the reclamation of these events. Consequently, the
kvm_pmc->perf_event remains active.

4. After a reboot, the VM kernel may report the following error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

5. In the worst case, the active kvm_pmc->perf_event may inject unknown
NMIs randomly into the VM kernel:

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

To resolve these issues, we propose resetting AMD PMU registers during the
VM reset process.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
    AMD64_NUM_COUNTERS (suggested by Sandipan Das).
  - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
    (suggested by Sandipan Das).
  - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
  - Don't initialize PMU info if kvm.enable_pmu=N.
Changed since v2:
  - Remove 'static' from host_cpuid_vendorX.
  - Change has_pmu_version to pmu_version.
  - Use object_property_get_int() to get CPU family.
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Send error log when host and guest are from different vendors.
  - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
    reminder developers.
  - Add support to Zhaoxin. Change is_same_vendor() to
    is_host_compat_vendor().
  - Didn't add Reviewed-by from Sandipan because the change isn't minor.

TODO:
  - This patch adds is_host_compat_vendor(), while there are something
    like is_host_cpu_intel() from target/i386/kvm/vmsr_energy.c. A rework
    may help move those helpers to target/i386/cpu*.

 target/i386/cpu.h     |   8 ++
 target/i386/kvm/kvm.c | 176 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 76f24446a5..84e497f5d3 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -490,6 +490,14 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_K7_EVNTSEL0                 0xc0010000
+#define MSR_K7_PERFCTR0                 0xc0010004
+#define MSR_F15H_PERF_CTL0              0xc0010200
+#define MSR_F15H_PERF_CTR0              0xc0010201
+
+#define AMD64_NUM_COUNTERS              4
+#define AMD64_NUM_COUNTERS_CORE         6
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f68d5a0578..3a35fd741d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2087,7 +2087,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
+static void kvm_init_pmu_info_intel(struct kvm_cpuid2 *cpuid)
 {
     struct kvm_cpuid_entry2 *c;
 
@@ -2120,6 +2120,97 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
     }
 }
 
+static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
+{
+    struct kvm_cpuid_entry2 *c;
+    int64_t family;
+
+    family = object_property_get_int(OBJECT(cpu), "family", NULL);
+    if (family < 0) {
+        return;
+    }
+
+    if (family < 6) {
+        error_report("AMD performance-monitoring is supported from "
+                     "K7 and later");
+        return;
+    }
+
+    pmu_version = 1;
+    num_pmu_gp_counters = AMD64_NUM_COUNTERS;
+
+    c = cpuid_find_entry(cpuid, 0x80000001, 0);
+    if (!c) {
+        return;
+    }
+
+    if (!(c->ecx & CPUID_EXT3_PERFCORE)) {
+        return;
+    }
+
+    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
+}
+
+static bool is_host_compat_vendor(CPUX86State *env)
+{
+    char host_vendor[CPUID_VENDOR_SZ + 1];
+    uint32_t host_cpuid_vendor1;
+    uint32_t host_cpuid_vendor2;
+    uint32_t host_cpuid_vendor3;
+
+    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
+               &host_cpuid_vendor2);
+
+    x86_cpu_vendor_words2str(host_vendor, host_cpuid_vendor1,
+                             host_cpuid_vendor2, host_cpuid_vendor3);
+
+    /*
+     * Intel and Zhaoxin are compatible.
+     */
+    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
+         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
+         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
+        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
+        return true;
+    }
+
+    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
+           env->cpuid_vendor2 == host_cpuid_vendor2 &&
+           env->cpuid_vendor3 == host_cpuid_vendor3;
+}
+
+static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+
+    /*
+     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
+     * disable the AMD PMU virtualization.
+     *
+     * Assume the user is aware of this when !cpu->enable_pmu. AMD PMU
+     * registers are not going to reset, even they are still available to
+     * guest VM.
+     */
+    if (!cpu->enable_pmu) {
+        return;
+    }
+
+    /*
+     * It is not supported to virtualize AMD PMU registers on Intel
+     * processors, nor to virtualize Intel PMU registers on AMD processors.
+     */
+    if (!is_host_compat_vendor(env)) {
+        error_report("host doesn't support requested feature: vPMU");
+        return;
+    }
+
+    if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) {
+        kvm_init_pmu_info_intel(cpuid);
+    } else if (IS_AMD_CPU(env)) {
+        kvm_init_pmu_info_amd(cpuid, cpu);
+    }
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -2302,7 +2393,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
-    kvm_init_pmu_info(&cpuid_data.cpuid);
+    kvm_init_pmu_info(&cpuid_data.cpuid, cpu);
 
     if (((env->cpuid_version >> 8)&0xF) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
@@ -4066,7 +4157,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (pmu_version > 0) {
+        if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
             if (pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -4097,6 +4188,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                                   env->msr_global_ctrl);
             }
         }
+
+        if (IS_AMD_CPU(env) && pmu_version > 0) {
+            uint32_t sel_base = MSR_K7_EVNTSEL0;
+            uint32_t ctr_base = MSR_K7_PERFCTR0;
+            /*
+             * The address of the next selector or counter register is
+             * obtained by incrementing the address of the current selector
+             * or counter register by one.
+             */
+            uint32_t step = 1;
+
+            /*
+             * When PERFCORE is enabled, AMD PMU uses a separate set of
+             * addresses for the selector and counter registers.
+             * Additionally, the address of the next selector or counter
+             * register is determined by incrementing the address of the
+             * current register by two.
+             */
+            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+                sel_base = MSR_F15H_PERF_CTL0;
+                ctr_base = MSR_F15H_PERF_CTR0;
+                step = 2;
+            }
+
+            for (i = 0; i < num_pmu_gp_counters; i++) {
+                kvm_msr_entry_add(cpu, ctr_base + i * step,
+                                  env->msr_gp_counters[i]);
+                kvm_msr_entry_add(cpu, sel_base + i * step,
+                                  env->msr_gp_evtsel[i]);
+            }
+        }
+
         /*
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
@@ -4544,7 +4667,8 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (pmu_version > 0) {
+
+    if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
         if (pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -4560,6 +4684,35 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (IS_AMD_CPU(env) && pmu_version > 0) {
+        uint32_t sel_base = MSR_K7_EVNTSEL0;
+        uint32_t ctr_base = MSR_K7_PERFCTR0;
+        /*
+         * The address of the next selector or counter register is
+         * obtained by incrementing the address of the current selector
+         * or counter register by one.
+         */
+        uint32_t step = 1;
+
+        /*
+         * When PERFCORE is enabled, AMD PMU uses a separate set of
+         * addresses for the selector and counter registers.
+         * Additionally, the address of the next selector or counter
+         * register is determined by incrementing the address of the
+         * current register by two.
+         */
+        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+            sel_base = MSR_F15H_PERF_CTL0;
+            ctr_base = MSR_F15H_PERF_CTR0;
+            step = 2;
+        }
+
+        for (i = 0; i < num_pmu_gp_counters; i++) {
+            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
+            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
+        }
+    }
+
     if (env->mcg_cap) {
         kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
         kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
@@ -4871,6 +5024,21 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
+        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
+            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
+            break;
+        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
+            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
+            break;
+        case MSR_F15H_PERF_CTL0 ...
+             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
+            index = index - MSR_F15H_PERF_CTL0;
+            if (index & 0x1) {
+                env->msr_gp_counters[index] = msrs[i].data;
+            } else {
+                env->msr_gp_evtsel[index] = msrs[i].data;
+            }
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
-- 
2.39.3


