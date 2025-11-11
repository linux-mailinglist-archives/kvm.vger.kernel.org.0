Return-Path: <kvm+bounces-62721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A079C4BA76
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 109FE4F2144
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116322D1932;
	Tue, 11 Nov 2025 06:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nFiz51ja"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E2F2D12EB
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842039; cv=none; b=bPicSuhODWTEVebHy60N/KIV2q3ZKPAFBUYQwYm2+WNoE+ZT2naML6T817mYwvfE34AvX6GPWiDj8jS1Nxlwz5H1xyAOF0YZukqHV5XqCZqaBsEgirlTiDClb/3E/+G8V+wqXAHPQzFMM8YWiS9lsCQ2zdg3l8+jfQLWMF7vBGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842039; c=relaxed/simple;
	bh=XhSHGyaw0a2GMfmpdcyrZW5f3DLEK4AUDDFMpySw/zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ+izefdbymn+LDokZnEAgxr+PT4OzK7lveQ3QSMS90BB3XfMgiQxFzahXm2ne3DF6SOf57CKRggpice1wb9vA4fQG8LRaq3ly2dHZPLjwF05TKvEicx/JqfEBpwldGRnAgGkh7LoISjlYJUYyhKx1Vc3xGC1bEU81INSMIcfk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nFiz51ja; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5lJdh010849;
	Tue, 11 Nov 2025 06:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=8ly7t
	h6oTvgKc3yXOLprltNtCZ1sYCyUUXv1O4Hg4ok=; b=nFiz51jaoeQfYEC0H7FN8
	iZD1z35uFmPXs0N12ofj3HThl3DWcH+thlCfxzOYU3L8Qu5UCFZ0Ox1jpyrIiNDS
	b7V05tY38Qzdp9gHCeSUYuayg7C/pukfH6MZrwBSBXnEcXHs+2fsz2pOjt2HJg8a
	6iZkFjSFsOtZw//bNkP0qtR+lOpPmDiDQyfUElbDv5RQIw765ZpiH2vjQWchgShM
	tUM2cJ5hrfu0PJ5EY1aHr2rJKlTcqXoREdxBKYXP66gm4ojjf56a6XoJvd01LEIA
	ar73LC8vFWzTaJFvnL9f9C1mjIRoGZRg8tM5ixHJH8LwFB2jrFF7EltnY/WRvxl+
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abwn7r5q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB50WrO007447;
	Tue, 11 Nov 2025 06:20:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mke2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:01 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6qx029277;
	Tue, 11 Nov 2025 06:20:01 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-9;
	Tue, 11 Nov 2025 06:20:00 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 8/9] target/i386/kvm: support perfmon-v2 for reset
Date: Mon, 10 Nov 2025 22:14:57 -0800
Message-ID: <20251111061532.36702-9-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: eiWBr5_sXT_NY-yrQ7vEmsDD8O7gvf8b
X-Proofpoint-GUID: eiWBr5_sXT_NY-yrQ7vEmsDD8O7gvf8b
X-Authority-Analysis: v=2.4 cv=YIGSCBGx c=1 sm=1 tr=0 ts=6912d592 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=zd2uoN0lAAAA:8 a=YKGenqcJedeHRtipQB0A:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAyNiBTYWx0ZWRfX0f8k7YikQscS
 Oxjn2LX6nsC15VcUwRG1TWtcCSJX2oPVxZuqP8DUpBvqUCnn5MoLwcrQ2i0YlwB9Xq4S1UutlXj
 ZbZ8rawIWacUV5jIRtiPUnmejVJ7LiENqc3ybfIuDYDzmQ+HF6l2k3fd0lB6IDICwX8PFm9K0mR
 M2OfKVM0XifjdfDzBD0TaPrCa6b0KAVO003S/pOQRB2l9XDfto8BkeWVDLU1HehIQqGJ6eWAoL4
 gvLzV5mv72CmarQz1UKrOhvG8A+L4PizRzgktg66LvkReWBRiTbj9x2+FqTi5cbb7q6Ig2f21I5
 88nzaNrf4SRA/sgGj2/Vl8TYwVIyYSzCNBZe/I6zG+uz8aneV/YKs531AfO2oyH2Eb4uQ5CInJo
 QOTVLwjfokkJVzigaaMu4iyCoojbTA==

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
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
Changed since v1:
  - Use "has_pmu_version > 1", not "has_pmu_version == 2".
Changed since v2:
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Change has_pmu_version to pmu_version.
  - Cap num_pmu_gp_counters with MAX_GP_COUNTERS.
Changed since v4:
  - Add Reviewed-by from Sandipan.

 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 48 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index ed4d0c375b..6d78f3995b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -489,6 +489,10 @@ typedef enum X86Seg {
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
index cbdd797be3..5258023fe7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2168,6 +2168,16 @@ static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
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
@@ -4245,13 +4255,14 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
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
@@ -4263,6 +4274,15 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
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
@@ -4740,13 +4760,14 @@ static int kvm_get_msrs(X86CPU *cpu)
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
@@ -4756,6 +4777,12 @@ static int kvm_get_msrs(X86CPU *cpu)
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
@@ -5052,12 +5079,15 @@ static int kvm_get_msrs(X86CPU *cpu)
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


