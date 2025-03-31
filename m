Return-Path: <kvm+bounces-42226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0314A75DA3
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 03:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF149188A49E
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 01:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D4B14D428;
	Mon, 31 Mar 2025 01:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iOCveRkn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FD26F073
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 01:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384953; cv=none; b=q3cBKTul9QNjseAGYB+WekNVCJNs3fuUrftPqL1JxPJb34uQAlfshn1W9SgEWFp52lhPOzy+S6rQ/Np5N4bQ2PJ5PCVQBnbNzx88nCDHlmHbao1QtK27OLUuyXBxNtDmhRbK/RbVDv75Eshaj0cvOIeTBtyXrMgntzuR/c5suJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384953; c=relaxed/simple;
	bh=Mg88Ek3A0Dwn0K00ozR63wePvHB1D4rMRm81bRB4MA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojEEqMpzYkmlL4beugZg8IU4XflWz7zygw/5gtJNmFRZicRWtzl9nfxKciNkx5fl5Yjua/SPTlN6B1hFRjY7smsSjAZFCAr73/WtpGUp2eKDfwkIuAup7IptC+5WUNeP4/5UNMBZFjjD6/sXYu8/fJmh9s0Ph7jEVQI4QeCjKoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iOCveRkn; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNrDD9009451;
	Mon, 31 Mar 2025 01:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=F+QHF
	Jtjx+28JGhYXKrFILOpFgt9z1RkF42hhyzkpYU=; b=iOCveRkn3JgJJcxxBqOwN
	6EOFPVD9um8rZLULSgYSwLBtJjfdueLboxG5hGWxqmwV778CW1bRR4DPDzj8azxC
	2w/XI34639Nr1tefliNRm+2rFOLvB/6jwLsHtnO7Wa9NjR/ZzBj7RWBgGnpAEzwA
	oGuuNyOp2BSKfDamVTan05VN+eNMGM/EDPiV8sroQmk+XXq61mqtcj7pdArRvrB7
	WVaA09ajWTSC6aK1s7D7viz4LcVIYVnUmBkVH8KY6gnVjdyvpQgjzxl1c8eTA3UE
	VH7SKbhxX8OG7YNMi6XxcN3seRMYmpSD+DbTcxqEDXXVYVhyttq6fsy5U75xk94F
	g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n22fhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52V0ELda033698;
	Mon, 31 Mar 2025 01:34:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7ddsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52V1YfxR015214;
	Mon, 31 Mar 2025 01:34:54 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45p7a7ddms-7;
	Mon, 31 Mar 2025 01:34:54 +0000
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
Subject: [PATCH v3 06/10] target/i386/kvm: rename architectural PMU variables
Date: Sun, 30 Mar 2025 18:32:25 -0700
Message-ID: <20250331013307.11937-7-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: 9Ae6CC4bg6JV-j75qY7lfgliBnoQ10gA
X-Proofpoint-GUID: 9Ae6CC4bg6JV-j75qY7lfgliBnoQ10gA

AMD does not have what is commonly referred to as an architectural PMU.
Therefore, we need to rename the following variables to be applicable for
both Intel and AMD:

- has_architectural_pmu_version
- num_architectural_pmu_gp_counters
- num_architectural_pmu_fixed_counters

For Intel processors, the meaning of pmu_version remains unchanged.

For AMD processors:

pmu_version == 1 corresponds to versions before AMD PerfMonV2.
pmu_version == 2 corresponds to AMD PerfMonV2.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changed since v2:
  - Change has_pmu_version to pmu_version.
  - Add Reviewed-by since the change is minor.
  - As a reminder, there are some contextual change due to PATCH 05,
    i.e., c->edx vs. edx.

 target/i386/kvm/kvm.c | 49 ++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4d86c08c6c..6b49549f1b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -164,9 +164,16 @@ static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
 static bool has_msr_hwcr;
 
-static uint32_t has_architectural_pmu_version;
-static uint32_t num_architectural_pmu_gp_counters;
-static uint32_t num_architectural_pmu_fixed_counters;
+/*
+ * For Intel processors, the meaning is the architectural PMU version
+ * number.
+ *
+ * For AMD processors: 1 corresponds to the prior versions, and 2
+ * corresponds to AMD PerfMonV2.
+ */
+static uint32_t pmu_version;
+static uint32_t num_pmu_gp_counters;
+static uint32_t num_pmu_fixed_counters;
 
 static int has_xsave2;
 static int has_xcrs;
@@ -2068,24 +2075,24 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
         return;
     }
 
-    has_architectural_pmu_version = c->eax & 0xff;
-    if (has_architectural_pmu_version > 0) {
-        num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
+    pmu_version = c->eax & 0xff;
+    if (pmu_version > 0) {
+        num_pmu_gp_counters = (c->eax & 0xff00) >> 8;
 
         /*
          * Shouldn't be more than 32, since that's the number of bits
          * available in EBX to tell us _which_ counters are available.
          * Play it safe.
          */
-        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
-            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
+        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
+            num_pmu_gp_counters = MAX_GP_COUNTERS;
         }
 
-        if (has_architectural_pmu_version > 1) {
-            num_architectural_pmu_fixed_counters = c->edx & 0x1f;
+        if (pmu_version > 1) {
+            num_pmu_fixed_counters = c->edx & 0x1f;
 
-            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
-                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+            if (num_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
+                num_pmu_fixed_counters = MAX_FIXED_COUNTERS;
             }
         }
     }
@@ -4037,25 +4044,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (has_architectural_pmu_version > 0) {
-            if (has_architectural_pmu_version > 1) {
+        if (pmu_version > 0) {
+            if (pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
             }
 
             /* Set the counter values.  */
-            for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
+            for (i = 0; i < num_pmu_fixed_counters; i++) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
                                   env->msr_fixed_counters[i]);
             }
-            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+            for (i = 0; i < num_pmu_gp_counters; i++) {
                 kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
                                   env->msr_gp_counters[i]);
                 kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
                                   env->msr_gp_evtsel[i]);
             }
-            if (has_architectural_pmu_version > 1) {
+            if (pmu_version > 1) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
                                   env->msr_global_status);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
@@ -4515,17 +4522,17 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (has_architectural_pmu_version > 0) {
-        if (has_architectural_pmu_version > 1) {
+    if (pmu_version > 0) {
+        if (pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0);
         }
-        for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
+        for (i = 0; i < num_pmu_fixed_counters; i++) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
         }
-        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+        for (i = 0; i < num_pmu_gp_counters; i++) {
             kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
             kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
         }
-- 
2.39.3


