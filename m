Return-Path: <kvm+bounces-67531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8F3D07B7F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E71553064C19
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2102F6921;
	Fri,  9 Jan 2026 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UsA0SHcb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4212F6910
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946078; cv=none; b=XHxwJkwS8owNT2FT0lOL5slihDO30OLwEEuujPIfXdWMajPWSzLT/AMBPqm1z9j/UNUcQwNBfcmaFmDg7MHfLx5BJIQlAtGLOnqgzPijwP+Z3cIqzcJckUWz788i+GMaHTs+gSEgpSSWcsgv5v4fvN6smy7vHEsu1f9zAUG1mV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946078; c=relaxed/simple;
	bh=3XFIa8tOeIaqlDhE+p1t5AGSLFc//NBXEO9XJLZrtwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdobgl3vgxcMueOhBgNgnLt6cSftGfRrWV4bKtEHl/egeDTrhcb++iCTPZ+lVbM3WO6wJO+XEJBV6pzLf4Dr0roOcx81tvGtMI8kgj4qZL9B4CruMGWaB4PLVHfCiU3S47WpLphT0R4Il2cZJiN/WmZwiKGld+7Hy5UlpfSK8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UsA0SHcb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6097D83Z2534479;
	Fri, 9 Jan 2026 08:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=tpPav
	dggv2O1glzHNzXI7DRBmdp4jZbNXxlXCPnuRAc=; b=UsA0SHcbc/hY44hm2dfuU
	WvIyOzky3qdQnpIU9rGbtXuabr1ijGsfPYi6obaKAhD5/hMFVcbqJZ/mOHf5IBtT
	iz03BfWZVyl8rjv5GAcx8z3G2yPnITxDxzJpSKcoRCRmL7d3YVygGKp0gQxocgJ9
	jAaQn2tGX+VaAlzbQ7GqlCWOACA/VIinwYB54Yq4vYdn1Vfj9sNiujF6CGeHzG2V
	v0ZQv1ZlN3PIw5kmLvptGXHxeIWHjg09Xbakuafhaods1g0POxgmdUWOfqljesG6
	kKdryqxEnFDv0kwMkata4JJ/0JRhLVteFqvvl+XpkDTvJv+a+VTjS4Rx184Nrlki
	w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjw3bg1hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 08:07:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6095BESM026338;
	Fri, 9 Jan 2026 08:07:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjpcbps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 08:07:27 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60987KrT009653;
	Fri, 9 Jan 2026 08:07:26 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjpcbj1-4;
	Fri, 09 Jan 2026 08:07:26 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com, zide.chen@intel.com
Subject: [PATCH v9 3/5] target/i386/kvm: rename architectural PMU variables
Date: Thu,  8 Jan 2026 23:53:58 -0800
Message-ID: <20260109075508.113097-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260109075508.113097-1-dongli.zhang@oracle.com>
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_02,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090056
X-Authority-Analysis: v=2.4 cv=KIJXzVFo c=1 sm=1 tr=0 ts=6960b740 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=zd2uoN0lAAAA:8 a=S5E2BveMG4f1x5cqP1kA:9 cc=ntf awl=host:12110
X-Proofpoint-GUID: PPuQkefkVb2xEYSzUmsl5jkYjr6D8uGO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDA1NiBTYWx0ZWRfX15FqqgwgNq8c
 VBf2w9xpmjTWY4Q8HJuFyrL2LXmemGwpnSFImj+/Z9iqBONqEif6NTkBWbeCzvPyFXRxME7ntU2
 lv4j2GhnM42sTV8YmAK3OYyKnaz2SMn4vR6HXGSwxtPzVwdrNfdDmJ/ujYCLCGkZ0AV9W1ofTzT
 /wJ58AZ7+HUUAKtbfYfRVU+mUfR7yQOJKxl3f28Vd+DNA02sijpA/r7jb4Y63lJ94QrpZ6bclGJ
 dtKRWc5G9BK5jX6q4c5ObL4o0f0NrVMosaSWujOkVynG77k1cq2xfsElnx7yED+pUU1lmEupILq
 IpXOA0xe1XUR4AqdbzR9l/TV0MbN5wO/rScZfkeO8BT+vLWU0gikQHoiUEhpur5dTgKsIhSHTx8
 5E5d8sIRjuDpLfmNrfMwePavZX9n9NT3idFCY0A4IL3YcuBEkUAPcZyrvvV6EZSLqVMA9rBtkXH
 Z+x7K2tea1CaZlgNgCTgCeJIxuRPw5yigvcXucuk=
X-Proofpoint-ORIG-GUID: PPuQkefkVb2xEYSzUmsl5jkYjr6D8uGO

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
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
Changed since v2:
  - Change has_pmu_version to pmu_version.
  - Add Reviewed-by since the change is minor.
  - As a reminder, there are some contextual change due to PATCH 05,
    i.e., c->edx vs. edx.
Changed since v6:
  - Add Reviewed-by from Sandipan.

 target/i386/kvm/kvm.c | 49 ++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 08d80ff677..3b803c662d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -167,9 +167,16 @@ static bool has_msr_perf_capabs;
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
@@ -2099,24 +2106,24 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
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
@@ -4087,25 +4094,25 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
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
@@ -4622,17 +4629,17 @@ static int kvm_get_msrs(X86CPU *cpu)
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


