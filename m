Return-Path: <kvm+bounces-66824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BDBCE8EE2
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 08:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F30203027CC9
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 07:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF792BD5A7;
	Tue, 30 Dec 2025 07:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NdZrNBaI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B542FDC3C
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767081332; cv=none; b=RBKr9+fpVNR8J37YO952jIdpZ0QwLOXZqStZqDf4Kw9mIFXkqiuUr4tcCDnp1nBEQ3ZZiA8Rx7dO9SjgeR58TZRbwt/CAYLdGmeT9aTpsre2qE7V8OFbB3BwOT39FDUIQcNzpEvz37tktZMZt14rdFt/CG6tsr9Yg3VA+K4X1ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767081332; c=relaxed/simple;
	bh=R3AgU4dotGgssZ6TlFyN5HNZdNXgV57weZddvFXLVVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5BpS+TtjR5H0huNHS794r4LPwo5QmnVMsU82KDnFKkxg9Wn6ZDmi75wM7UAuodFnlW2xDBAgBmxn7iVZi6XNStJwaL0Uuv2m52neexCQhL3xio1VatXNfgFlP3JgHi6GL0ukyu1PDsslq+GRTCmcLjlktZsCqRd7SjW2IB+EO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NdZrNBaI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU4KR2I3185393;
	Tue, 30 Dec 2025 07:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=LB2Vj
	/MWHUNtV6h54DkHNSWb4nqk6QJBlJZJjtacKdo=; b=NdZrNBaIhMqN0GvNZajfT
	bsTF6IuKhBkS1eyCq0cY1y1CrvJr3rmoAJfsFKgWhlxGF1gn9C+Vq7EwZCkifYbJ
	eFO85/gkdC8pqL4CPgpIU0lqW3Ri7FGmiGb5Ikqrv6a6qpVnG0iy4QJDRr8RYDjv
	V1FsfEK1mP6lw5UKCUBPmj/AfxRZa3MaE9JocZCk1qeRCTOo0AqH/2JIjr3pDWmm
	zPHcV2vzUz5zVgn9TKn6k69pQp5/Oqz4L6Rns+58LkRRE59uBXXF6p4lnmBlfnwW
	3uLEsGpl8Eie0vD4kHTQeoPabsqNbWGO6WrWJgb1WbvCjdMHErX5vksVJjCFmHw8
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba61waack-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BU2s4PB017352;
	Tue, 30 Dec 2025 07:54:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wbp6ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:53 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BU7smZn005421;
	Tue, 30 Dec 2025 07:54:52 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ba5wbp6aa-3;
	Tue, 30 Dec 2025 07:54:52 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v8 2/7] target/i386/kvm: extract unrelated code out of kvm_x86_build_cpuid()
Date: Mon, 29 Dec 2025 23:42:41 -0800
Message-ID: <20251230074354.88958-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251230074354.88958-1-dongli.zhang@oracle.com>
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512300070
X-Authority-Analysis: v=2.4 cv=LL1rgZW9 c=1 sm=1 tr=0 ts=6953854e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=PfVMnciqd94fTzcZrM0A:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: zxtJd8cAKdm-OzWedISRPmOXbRYJWTmw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA3MCBTYWx0ZWRfX5zH5fBQcojQk
 mGWW9unXcTBiINMoRNjw/d3DjPCyh3198oHoPIzH7OcaLk661jorIllD5T8PmuzBq6VBHw4Ou+s
 IEwHVcJteTbkTLJTWmAi1HROGIm9khiFR/XHdFQmihfILmUfq4pN9oWO7tpW4ZuBrPC/dhLaLrC
 zPePPjASO0vKjpIm/w9rFvWGpzfYMsOHZCClCKkZTYc9667Nktxox+wdGGSjomjUevUjHgrPOwW
 NXPPoRU4p7D8eqHjhzaruTJk8CrbPD7+o3ETsrQEUJsb5649FgBYRyxHaRFNEr3GeJb2TCbJXyc
 kp1WqFkFssKTZcnCj0NGGHHmgP5doComK/gHaRHlzE+Num9lx12ww8RyRl04Q85y8YvqB4s50IO
 SvKATbYvAup5KeQjrw+lO8iXYGHNu+3n93bYPrXiuRomvwHZPQsJLsDeGJmKX1GBubcLGS4ZGX6
 UwyndJvJVhNjjdTLwjjvJoUD0yf8Vis0fhRdSQrY=
X-Proofpoint-GUID: zxtJd8cAKdm-OzWedISRPmOXbRYJWTmw

The initialization of 'has_architectural_pmu_version',
'num_architectural_pmu_gp_counters', and
'num_architectural_pmu_fixed_counters' is unrelated to the process of
building the CPUID.

Extract them out of kvm_x86_build_cpuid().

In addition, use cpuid_find_entry() instead of cpu_x86_cpuid(), because
CPUID has already been filled at this stage.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
Changed since v1:
  - Still extract the code, but call them for all CPUs.
Changed since v2:
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Didn't add Reviewed-by from Dapeng as the change isn't minor.
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/kvm/kvm.c | 62 ++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c98832f423..08d80ff677 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1986,33 +1986,6 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
         }
     }
 
-    if (limit >= 0x0a) {
-        uint32_t eax, edx;
-
-        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
-
-        has_architectural_pmu_version = eax & 0xff;
-        if (has_architectural_pmu_version > 0) {
-            num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
-
-            /* Shouldn't be more than 32, since that's the number of bits
-             * available in EBX to tell us _which_ counters are available.
-             * Play it safe.
-             */
-            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
-                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
-            }
-
-            if (has_architectural_pmu_version > 1) {
-                num_architectural_pmu_fixed_counters = edx & 0x1f;
-
-                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
-                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
-                }
-            }
-        }
-    }
-
     cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
 
     for (i = 0x80000000; i <= limit; i++) {
@@ -2116,6 +2089,39 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
+static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
+{
+    struct kvm_cpuid_entry2 *c;
+
+    c = cpuid_find_entry(cpuid, 0xa, 0);
+
+    if (!c) {
+        return;
+    }
+
+    has_architectural_pmu_version = c->eax & 0xff;
+    if (has_architectural_pmu_version > 0) {
+        num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
+
+        /*
+         * Shouldn't be more than 32, since that's the number of bits
+         * available in EBX to tell us _which_ counters are available.
+         * Play it safe.
+         */
+        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
+            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
+        }
+
+        if (has_architectural_pmu_version > 1) {
+            num_architectural_pmu_fixed_counters = c->edx & 0x1f;
+
+            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
+                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+            }
+        }
+    }
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -2306,6 +2312,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
+    kvm_init_pmu_info(&cpuid_data.cpuid);
+
     if (x86_cpu_family(env->cpuid_version) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
            (CPUID_MCE | CPUID_MCA)) {
-- 
2.39.3


