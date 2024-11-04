Return-Path: <kvm+bounces-30475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE429BAFF7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6100E1F212C6
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E34F1AF0C7;
	Mon,  4 Nov 2024 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KQzh8vUi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15221AE01C
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713351; cv=none; b=snZXVjtvSdvVS5ejJEyfCeHlLKDrpRA7BUb71fd7HRXvg27ORH0m0Za5Iyo4RpkPq17A1lVvx81CBULQqMEFxzDHFWW3SXmnc0TTFJnDR8sPNNj4siwsSNmh8gxhuT8YajmSE7EaDFifXNMi2A5G0AmuZyQPvDo0/qhqwwRTbt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713351; c=relaxed/simple;
	bh=8vwYhnUKihN5m27fdY1zRUKjhlncdkTCEBRCwKLYZb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsSV1caQ6JGDi8j/AJjR8dWeY8E5KoFmnf7bXQgetR9O3wW0woBncjIJF3chpt2JCZWFy757ZVuFo0W/W18XwicYWkdlOA4SjCemZYIJ8J1Rbs3YXjGPS10hINpRVMT1iC9M+kNmybJwXiOyeVCl7XxSNCuWPMQQzIJkzCQ4vQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KQzh8vUi; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48ferU019278;
	Mon, 4 Nov 2024 09:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=aw8Da
	KbTFy541Imzo6l3juUlheHXjuaW/lcnjuRi9i8=; b=KQzh8vUimbrwlWWWRQ0bQ
	Wr2Sa1pd+x5EDv7de0eGJmN7gJ84M+8+oNTQQ5MC9fxVf98M1mmD9zPZPCJ3dP4v
	zwW4NhdTk1KM36Ijw1ykS6CG51DDB3fXtGGF495iX9SRayQKVZTDLUslP6r9QUL7
	qrLW0BRjBSuXIVz1oQnZFaHSPnz3pHExOwX1Ohate/CpqE4UJdjHo1N1qhKil2rs
	CXf4uU05SabHWvc2Puu5cc7ocxU/d8FHq2DsjTJNVTlntLk8811hKK4QAGqKXNaZ
	/+/BiNBIddJ4GedmqsF4nsXtQUUBwEW2Eof5oFuGp4LyW0e0ePO2AWhOQfJmWGUO
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc2a5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:42:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A49GxM0009703;
	Mon, 4 Nov 2024 09:42:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt0bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:42:00 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfk018519;
	Mon, 4 Nov 2024 09:41:59 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-5;
	Mon, 04 Nov 2024 09:41:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 4/7] target/i386/kvm: rename architectural PMU variables
Date: Mon,  4 Nov 2024 01:40:19 -0800
Message-ID: <20241104094119.4131-5-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: G2G7tkFTicVLrnW9tFGXNacg0DRyZo-U
X-Proofpoint-GUID: G2G7tkFTicVLrnW9tFGXNacg0DRyZo-U

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
index 5c0276f889..ca2b644e2c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -168,9 +168,16 @@ static bool has_msr_pkrs;
 static bool has_msr_hwcr;
 static bool has_pmu_cap;
 
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
@@ -2042,24 +2049,24 @@ static void kvm_init_pmu_info(CPUX86State *env)
 
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
@@ -4020,25 +4027,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
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
@@ -4496,17 +4503,17 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
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
2.39.3


