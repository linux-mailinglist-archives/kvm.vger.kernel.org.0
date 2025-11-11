Return-Path: <kvm+bounces-62717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E90C4BA4C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3F41834E891
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8202D77EA;
	Tue, 11 Nov 2025 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qs+d1aKP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F24E2D0C7B
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842025; cv=none; b=FMPBKQkmIymm+G0GM3+RmCABYInRmZeQ914NA1Sfbe0XM32+moMEW5HqjYoISWETjcCQ55/JnVERfLpJ8qvLbs6nOV5GQLRzHLbn0eT6zEQZDBmMRFZjDn9YVI6rADtLGiguWO1DVuESC5JmEGwE666EHs/5pe8b5Zcd2pUGPhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842025; c=relaxed/simple;
	bh=ygM2obPLheAOVGEolItZzUv71Vg95oSe9Qb4N07/ePY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo1SmwnE6bqBOi3ccL13xA5vJWfdNe9V88iNllH23L9HgGgWn4xYsKpcfgCSFEP2bnkoTjxVdCFad/E0aJLRCnMV91I8msLQKY8crFORR2pwzJQC/HL+iRf4xerxebxTy6yPwOPsJ+9zfwUuR+OlWsgG7jhCUpvP621KhHDgaBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qs+d1aKP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5iJ95024030;
	Tue, 11 Nov 2025 06:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=dqeBn
	+DGOWHoOBhTMA7DSempm+vOL6bTkXO0nOyHuW4=; b=qs+d1aKP82S0MqBUU3Cou
	UWtxAksNvCFDwn1IhmJZDkXw/r0rgvs8yBeH7FsLAkr8w3gtFxz4SYBdCsEoD91y
	Mp2f3l+iX7BA3iAQYDfkXFs/G6f2wdQNnBCU8CB8SfqNqtzAKyhmx+hwqQgEisJ8
	cDlK6wq30hTAjH4vtrZhawaaJpIN6CGh/urIaty8dFURI7SKeA65pI3O/TH2LviL
	FxgzHTnFwZmqHkg5u9aLsOxOcUE24+S35KSaV2i5ROy4hRXormx/+KuC9B/Tim/H
	ne4w2ucp+SnX03MxaLrAGcpSLFA6+j/AqorFSbYvZTU5npPTmxV1XhsXPQ4sh4XF
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abwkar58h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB6B7DB007431;
	Tue, 11 Nov 2025 06:20:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mkd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6qv029277;
	Tue, 11 Nov 2025 06:19:59 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-8;
	Tue, 11 Nov 2025 06:19:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 7/9] target/i386/kvm: reset AMD PMU registers during VM reset
Date: Mon, 10 Nov 2025 22:14:56 -0800
Message-ID: <20251111061532.36702-8-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251111061532.36702-1-dongli.zhang@oracle.com>
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110047
X-Proofpoint-GUID: nrtueYnAyo7AXJBMcCYX7VPgz-52RYre
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAyNiBTYWx0ZWRfX9X9KqTJV+wVB
 aTI/TqXWsdRStwteHqgWY0B0RoBiIFyOA7rJilkCYa9KuwXJylm5gZp8oY5nhk2ECFt4F46D0hi
 pA59qkJJmNFccZ/mli1csUimLQ/TQMoIdDiDT+fS31lgkNYem5z2XMeh20eHqqoGtOSvf4YQo6/
 McRKZbXweAUKlZhuT05fwKGoE5eEwcZ+5b6d61F+TC8f7lTF17q/Oq5GJJaO89sYP68zJg2m545
 sJXIf3bsImFb6MwMIpP3H+X227bCA1nG7h+J02FXNQJXu80iKWf23QQMgSeTJocpORY9tcngF8N
 qjgo1JpbHfrIMd4WADXNYt4+BOiScdeRDBrwbjAsGMBSE2EGy/YDvfqd51F4r46OkvpJTiSs5w+
 wAgx9Nk2kwxyl44Krxf83XC3UnC7pw==
X-Proofpoint-ORIG-GUID: nrtueYnAyo7AXJBMcCYX7VPgz-52RYre
X-Authority-Analysis: v=2.4 cv=BMu+bVQG c=1 sm=1 tr=0 ts=6912d591 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=zd2uoN0lAAAA:8 a=z8CyqhYIDdzzOy9ts9wA:9 a=cPQSjfK2_nFv0Q5t_7PE:22

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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
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
Changed since v3:
  - Use host_cpu_vendor_fms() from Zhao's patch.
  - Check AMD directly makes the "compat" rule clear.
  - Add comment to MAX_GP_COUNTERS.
  - Skip PMU info initialization if !kvm_pmu_disabled.
Changed since v4:
  - Add Reviewed-by from Zhao and Sandipan.
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/cpu.h     |  12 +++
 target/i386/kvm/kvm.c | 175 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 183 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cee1f692a1..ed4d0c375b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -489,6 +489,14 @@ typedef enum X86Seg {
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
@@ -1648,6 +1656,10 @@ typedef struct {
 #endif
 
 #define MAX_FIXED_COUNTERS 3
+/*
+ * This formula is based on Intel's MSR. The current size also meets AMD's
+ * needs.
+ */
 #define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
 
 #define NB_OPMASK_REGS 8
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 97782ce070..cbdd797be3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2106,7 +2106,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
+static void kvm_init_pmu_info_intel(struct kvm_cpuid2 *cpuid)
 {
     struct kvm_cpuid_entry2 *c;
 
@@ -2139,6 +2139,96 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
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
+
+    host_cpu_vendor_fms(host_vendor, NULL, NULL, NULL);
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
+    return g_str_equal(host_vendor, CPUID_VENDOR_AMD) &&
+           IS_AMD_CPU(env);
+}
+
+static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+
+    /*
+     * The PMU virtualization is disabled by kvm.enable_pmu=N.
+     */
+    if (kvm_pmu_disabled) {
+        return;
+    }
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
@@ -2329,7 +2419,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
-    kvm_init_pmu_info(&cpuid_data.cpuid);
+    kvm_init_pmu_info(&cpuid_data.cpuid, cpu);
 
     if (x86_cpu_family(env->cpuid_version) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
@@ -4112,7 +4202,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (pmu_version > 0) {
+        if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
             if (pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -4143,6 +4233,38 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
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
@@ -4590,7 +4712,8 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (pmu_version > 0) {
+
+    if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
         if (pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -4606,6 +4729,35 @@ static int kvm_get_msrs(X86CPU *cpu)
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
@@ -4917,6 +5069,21 @@ static int kvm_get_msrs(X86CPU *cpu)
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


