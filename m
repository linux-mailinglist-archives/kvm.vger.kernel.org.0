Return-Path: <kvm+bounces-39829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CA0A4B52D
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D30A23B0D49
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 22:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5221EFF9F;
	Sun,  2 Mar 2025 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WUg/2nMx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38CB1EF094
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 22:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953070; cv=none; b=skfswbXoySzvxQu+AvukC9gf5W1RGCSzXLyWUWGfQ4VNWL/VWUI+XmmBZZPSodBQoST58PTzPY0pDtHG2VmStOyj1RrkqkgmM5krk/3aOjWpvw86IP2s9wVowMzk1g5r+BENwaTk0gBt1Wl+GQ/JyDpz/ndKuP1v9hPfUrlPNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953070; c=relaxed/simple;
	bh=tDtv37iQy95Au+rTHGNp2V14CEyEQMB6911+Ji52+DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1Kr9kJJPkeUWoUbpDnlZMUPfmdXYPEjSYJecxPuMmFe+y4OqYXM4DaRsSChFgdJQv9ZV9EfvIQZ/N7w5NusYSdHfO/4NJJ6ZFx/4uZ2bTKLYQqQ5zn93TTGLATWHP/5VhTlbhcsN42KKCI6y1DGVAuTuvWQJE7JjUdcKidl8SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WUg/2nMx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 522FmJec003472;
	Sun, 2 Mar 2025 22:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Vlvw8
	wDA8mDkrBl1J9BwwuBOT22lF2//P8VTfZHSVb0=; b=WUg/2nMxpnRDAhaKB5aBx
	Q8zC5qLnU0Ly7hMTvuBfjiGEFcjl4g6/CJFRRaEhzQsSwwxt/qQEMUk8LdSz8qOn
	OzpAoc/2O8GCdQteb29JBWuhqyznEDYgHchyvLx3W1C9CutF8/aH/KgaK0yYwzZx
	uhvzxzf5E4eZ7mrx+56Xvkzg/a4uOPCMIAqLbfQ4YQso0gEzDKsLTDnfOGY04sR3
	mPETpXTciCG7W8kqnkjfqJWPbSnxs93ERqZX9o8tAwNpezUVQPhVc4TnpTLj0zRF
	Q6qXah4VHK/EdGDCTtNL2TYId7hmjRL+2Tkj68rlXJS/FNPng0ktT/QBSlRLtSAu
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8whkmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 522JuM0U015740;
	Sun, 2 Mar 2025 22:03:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp803dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 522M3Qob040088;
	Sun, 2 Mar 2025 22:03:31 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp80353-7;
	Sun, 02 Mar 2025 22:03:31 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH v2 06/10] target/i386/kvm: rename architectural PMU variables
Date: Sun,  2 Mar 2025 14:00:14 -0800
Message-ID: <20250302220112.17653-7-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250302220112.17653-1-dongli.zhang@oracle.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-02_06,2025-02-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503020180
X-Proofpoint-ORIG-GUID: b18lWFHrHOqYcJo8Xs-Qi7vSvHA8AnS8
X-Proofpoint-GUID: b18lWFHrHOqYcJo8Xs-Qi7vSvHA8AnS8

AMD does not have what is commonly referred to as an architectural PMU.
Therefore, we need to rename the following variables to be applicable for
both Intel and AMD:

- has_architectural_pmu_version
- num_architectural_pmu_gp_counters
- num_architectural_pmu_fixed_counters

For Intel processors, the meaning of has_pmu_version remains unchanged.

For AMD processors:

has_pmu_version == 1 corresponds to versions before AMD PerfMonV2.
has_pmu_version == 2 corresponds to AMD PerfMonV2.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/kvm/kvm.c | 49 ++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8f293ffd61..e895d22f94 100644
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
+static uint32_t has_pmu_version;
+static uint32_t num_pmu_gp_counters;
+static uint32_t num_pmu_fixed_counters;
 
 static int has_xsave2;
 static int has_xcrs;
@@ -2072,24 +2079,24 @@ static void kvm_init_pmu_info(CPUX86State *env)
 
     cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
 
-    has_architectural_pmu_version = eax & 0xff;
-    if (has_architectural_pmu_version > 0) {
-        num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
+    has_pmu_version = eax & 0xff;
+    if (has_pmu_version > 0) {
+        num_pmu_gp_counters = (eax & 0xff00) >> 8;
 
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
-            num_architectural_pmu_fixed_counters = edx & 0x1f;
+        if (has_pmu_version > 1) {
+            num_pmu_fixed_counters = edx & 0x1f;
 
-            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
-                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+            if (num_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
+                num_pmu_fixed_counters = MAX_FIXED_COUNTERS;
             }
         }
     }
@@ -4041,25 +4048,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (has_architectural_pmu_version > 0) {
-            if (has_architectural_pmu_version > 1) {
+        if (has_pmu_version > 0) {
+            if (has_pmu_version > 1) {
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
+            if (has_pmu_version > 1) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
                                   env->msr_global_status);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
@@ -4519,17 +4526,17 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (has_architectural_pmu_version > 0) {
-        if (has_architectural_pmu_version > 1) {
+    if (has_pmu_version > 0) {
+        if (has_pmu_version > 1) {
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
2.43.5


