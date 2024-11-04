Return-Path: <kvm+bounces-30474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B05FC9BAFF8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07DC4B244B1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D521AF0C3;
	Mon,  4 Nov 2024 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CqpSVp6t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7021AE017
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713351; cv=none; b=U1al/wkynHSzqEKEx5B3076mNPhT9BdJHbX7/DFMc/qEDNr3IeP0pNQhT9vF2xi5kpItoKNTRlqLMT0goSjW51UcGBVIX+oejbrO0UCJnAmu3G/JX/witBplCGJYd+rxhJ/I8JvXsGESRA4t3cywxA41o/VfS4Ce00fZUaks3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713351; c=relaxed/simple;
	bh=cP3hPbh0eg5lw3xRcV8DHZCqvDMferY/cH6tH1xgM9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ts1nBWqOe4ZaAEFFfvcDK/V0jvq5Q0aZ59PDsIgjJgNUKyxvBkwu86srUlm+8c6bcM4pQfAWeIp1NKVA7uZaAIZnHNTtUmDFcZfWzDXmCB0WOYrrmLdIXw+S8NJenJQIY53T0WVdFrSANhEjZENA39bbjiSFG15l0FJXNS4ccyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CqpSVp6t; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48g0Op009185;
	Mon, 4 Nov 2024 09:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=c/gUe
	N/1UHuvwH/MPvRLZ4qA0zjIgO5JFJ7PpI3xCiU=; b=CqpSVp6tJFzhiySQe760a
	LJaRs9dfROgHmYpwwrbC5S4f3gSLEQCT3NkXb57FoIdlW6fsYGG81AtZ/07fBlAm
	ljObIvQGrN3ZLwTVJRf0YYNB44iJGGmLchgu7vcGrH0tan46yZCDHXR9tBQ7Ivg4
	zUDy9BtaESA0ybFIEcCDiW2rvP4Nejm1/8zG00BeG4fZEMKxg0OeU9rPQ23EnJ3E
	rb6J8P8eDQR/4GtYN+6v6EzspfANE5W/S7h10oglG7YePdyVTerFA8Q8etI4ramX
	Kufg0irESMwtCrOBqgwn81elzinqxR6bQxm25yX1YFrns5gM+TdDidtAEIoDwsQ9
	w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nbpsj98e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A49YcLD009089;
	Mon, 4 Nov 2024 09:41:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt0ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:58 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfi018519;
	Mon, 4 Nov 2024 09:41:57 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-4;
	Mon, 04 Nov 2024 09:41:57 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 3/7] target/i386/kvm: init PMU information only once
Date: Mon,  4 Nov 2024 01:40:18 -0800
Message-ID: <20241104094119.4131-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241104094119.4131-1-dongli.zhang@oracle.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_07,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411040085
X-Proofpoint-ORIG-GUID: pqWGiGQkLfgBDNyXutvfFe4Epf2g77F1
X-Proofpoint-GUID: pqWGiGQkLfgBDNyXutvfFe4Epf2g77F1

Currently, the 'has_architectural_pmu_version',
'num_architectural_pmu_gp_counters', and
'num_architectural_pmu_fixed_counters' are shared globally across all vCPUs
and are initialized during the setup of each vCPU.

To optimize, initialize PMU information only once for the first vCPU.

Additionally, the code extracted from kvm_x86_build_cpuid() is unrelated to
the process of building the CPUID.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/kvm/kvm.c | 71 +++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ed73b1e7e0..5c0276f889 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1961,33 +1961,6 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
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
@@ -2055,6 +2028,43 @@ full:
     abort();
 }
 
+static void kvm_init_pmu_info(CPUX86State *env)
+{
+    uint32_t eax, edx;
+    uint32_t unused;
+    uint32_t limit;
+
+    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
+
+    if (limit < 0x0a) {
+        return;
+    }
+
+    cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
+
+    has_architectural_pmu_version = eax & 0xff;
+    if (has_architectural_pmu_version > 0) {
+        num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
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
+            num_architectural_pmu_fixed_counters = edx & 0x1f;
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
@@ -2237,6 +2247,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
+    /*
+     * Initialize PMU information only once for the first vCPU.
+     */
+    if (cs == first_cpu) {
+        kvm_init_pmu_info(env);
+    }
+
     if (((env->cpuid_version >> 8)&0xF) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
            (CPUID_MCE | CPUID_MCA)) {
-- 
2.39.3


