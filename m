Return-Path: <kvm+bounces-43502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8B2A90E22
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 23:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60073B782A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD9B24887F;
	Wed, 16 Apr 2025 21:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GS8Gtmb0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0FC236446
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840699; cv=none; b=CFNHnT9N3LVwXdXfefxQG+DRHJ7yvuM/7MyT5dZMqRbVaKr1ltgGrFfHPNDuQkYzsGsGxQ/KyJGD5a7+l3bmT3jeLPHltfBJK5D2usCrC2H+bteeDGIpBwkqXncwMS4QxlwGwvHbiylQVYiTNJFfK0TkpNnAOFuu7GCHqBin3/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840699; c=relaxed/simple;
	bh=HCttM1nr+9olvVcd2XfJS3GIHE4/ZPVUy8feZUyhsho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p407/xwGsvnIHyCIYjReyJdBZroQKcZhqQ8KZocyVCiZGH0hcqPYwVH9ENlDxw8s46GIV8FPZHb9oDRGlknaBzGRW+/Hh8pgH8utD45fil2EsvRqXV5cllhldrc/cqTP8HnWBkVDSGNAfBoW7ZumlrqSUeYBwgPJzfwoTS1IPZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GS8Gtmb0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLNVAK028204;
	Wed, 16 Apr 2025 21:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=F3wjK
	kv2qszSaswqpIW5YlUT/6njtssY4KRJiIJDg18=; b=GS8Gtmb07GFRPuigKe7sW
	37XGLGPE8IwTnkVW4HFFsjjvH+vXVEcf4ccouR2ApJO5oEUshQ7wVkE2ij72eYzk
	1uecKl6GbwqjRJI94raikE+IGR/Vdh9CZsAwBynlkHOq1w/7m3yzxzN4DogFBduk
	YCF6rVPvfkxKhhMwgaC7LbsGD9QhTUWK9tV/Mj02Qt5cEcdRR7vZxI2AVkFYWuGf
	dQLapCZDfkQedxq00BCCoSICkuqyimtui1q/dYfttJsaRfsSlugthTYr4kBa2VO0
	megEKkCv2efUCMFJFZ19Bto6YwYTcsPdb/ksNqqHxmgun7qTL3H7LR1PZoK1lBTx
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617jud6js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53GK51Uq005725;
	Wed, 16 Apr 2025 21:57:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5xhvtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:27 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53GLv1qi036583;
	Wed, 16 Apr 2025 21:57:26 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 460d5xhvcp-11;
	Wed, 16 Apr 2025 21:57:26 +0000
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
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, kraxel@redhat.com,
        berrange@redhat.com
Subject: [PATCH v4 10/11] target/i386/kvm: support perfmon-v2 for reset
Date: Wed, 16 Apr 2025 14:52:35 -0700
Message-ID: <20250416215306.32426-11-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250416215306.32426-1-dongli.zhang@oracle.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_08,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160177
X-Proofpoint-GUID: w8TncpsJRtOBHFWFDn9BFYQj7kstJFZ4
X-Proofpoint-ORIG-GUID: w8TncpsJRtOBHFWFDn9BFYQj7kstJFZ4

Since perfmon-v2, the AMD PMU supports additional registers. This update
includes get/put functionality for these extra registers.

Similar to the implementation in KVM:

- MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
use env->msr_global_status.
- MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
env->msr_global_ctrl.
- MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
both use env->msr_global_ovf_ctrl.

No changes are needed for vmstate_msr_architectural_pmu or
pmu_enable_needed().

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changed since v1:
  - Use "has_pmu_version > 1", not "has_pmu_version == 2".
Changed since v2:
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Change has_pmu_version to pmu_version.
  - Cap num_pmu_gp_counters with MAX_GP_COUNTERS.

 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 48 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5d5266f89e..210a80950e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -490,6 +490,10 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS       0xc0000300
+#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL          0xc0000301
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR   0xc0000302
+
 #define MSR_K7_EVNTSEL0                 0xc0010000
 #define MSR_K7_PERFCTR0                 0xc0010004
 #define MSR_F15H_PERF_CTL0              0xc0010200
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b8926bd4cb..13ad7de690 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2138,6 +2138,16 @@ static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
     }
 
     num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
+
+    c = cpuid_find_entry(cpuid, 0x80000022, 0);
+    if (c && (c->eax & CPUID_8000_0022_EAX_PERFMON_V2)) {
+        pmu_version = 2;
+        num_pmu_gp_counters = c->ebx & 0xf;
+
+        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
+            num_pmu_gp_counters = MAX_GP_COUNTERS;
+        }
+    }
 }
 
 static bool is_host_compat_vendor(CPUX86State *env)
@@ -4204,13 +4214,14 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             uint32_t step = 1;
 
             /*
-             * When PERFCORE is enabled, AMD PMU uses a separate set of
-             * addresses for the selector and counter registers.
-             * Additionally, the address of the next selector or counter
-             * register is determined by incrementing the address of the
-             * current register by two.
+             * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a
+             * separate set of addresses for the selector and counter
+             * registers. Additionally, the address of the next selector or
+             * counter register is determined by incrementing the address
+             * of the current register by two.
              */
-            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
+                pmu_version > 1) {
                 sel_base = MSR_F15H_PERF_CTL0;
                 ctr_base = MSR_F15H_PERF_CTR0;
                 step = 2;
@@ -4222,6 +4233,15 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                 kvm_msr_entry_add(cpu, sel_base + i * step,
                                   env->msr_gp_evtsel[i]);
             }
+
+            if (pmu_version > 1) {
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+                                  env->msr_global_status);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+                                  env->msr_global_ovf_ctrl);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+                                  env->msr_global_ctrl);
+            }
         }
 
         /*
@@ -4699,13 +4719,14 @@ static int kvm_get_msrs(X86CPU *cpu)
         uint32_t step = 1;
 
         /*
-         * When PERFCORE is enabled, AMD PMU uses a separate set of
-         * addresses for the selector and counter registers.
+         * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a separate
+         * set of addresses for the selector and counter registers.
          * Additionally, the address of the next selector or counter
          * register is determined by incrementing the address of the
          * current register by two.
          */
-        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
+            pmu_version > 1) {
             sel_base = MSR_F15H_PERF_CTL0;
             ctr_base = MSR_F15H_PERF_CTR0;
             step = 2;
@@ -4715,6 +4736,12 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
             kvm_msr_entry_add(cpu, sel_base + i * step, 0);
         }
+
+        if (pmu_version > 1) {
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0);
+        }
     }
 
     if (env->mcg_cap) {
@@ -5011,12 +5038,15 @@ static int kvm_get_msrs(X86CPU *cpu)
             env->msr_fixed_ctr_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_CTRL:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
             env->msr_global_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_STATUS:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
             env->msr_global_status = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
             env->msr_global_ovf_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
-- 
2.39.3


