Return-Path: <kvm+bounces-30479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE489BB000
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20A5CB24783
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE9B1AF0AC;
	Mon,  4 Nov 2024 09:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d4AdwlHN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAF31AE009
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713363; cv=none; b=R99T4Faz4frVEIemqEYqAeyDfGqXql7GyqyKDU5KwiytdMq1syO5UWX/1ET+2A3mPwhY+5n8mzkZaG1vaJBCoALC8kqD7elsky+Gw1tjQTu6lJzM9sl9pqbO75/5/QFeh1fyir3IkR3Let5EobdSCSY2JU1Vm5TtY49mDse5aHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713363; c=relaxed/simple;
	bh=FaA23FPZtXnlFMOmMSac5PVY9+TGZG1Uuum22/rBL1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgSBKEEFcHksB9c49zU+hX16lpjjVut652qkzA0HZYNq660pzIQXBpDQJYHZ0U0CMUSb38FQOU384yMKDbTrOXL4g9bDeu+yM03UgRb4jAOAdPLYgjbPpyHhMX7V4X1xl4N2a34bmm8PmM388q9TIrWTadYmDvankRwKrfP7SEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d4AdwlHN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48feVg012731;
	Mon, 4 Nov 2024 09:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=iByb0
	xSBywgeMzBO1BPHrpu5g4pFiXx4tglO6zRirAE=; b=d4AdwlHNEss5xFlavlNK3
	wXUowNkTIInE0Le83Wpgd/XDY9pwNf72p5uLncYOUh9a2+BhGG3gAanYaCDHeH+/
	PIKmVKMzFdP4cVkFX3IZmlQiyqCL5oiel8woZVLq4KMGJYmhBk7JPXsR5hI/nMMR
	QQiCn1QyWtVHWuP5dldTefFiceevvOKbhPD7kvyYL9uOiYp+LRAdSqqLaQcR66f5
	rSla0MNDgfsphrxLspmVQQgE3TPO+5gGBRSncyvqWCfjXjaDzoffkl+pl67T3jHn
	T3f9BD40WW2iVy9v3E0A2r7+wMsmoQmHmYasm2cJPE4VAD5ld4vxt5Zan1H0pkXb
	w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nanytbxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:42:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A47XMQq009856;
	Mon, 4 Nov 2024 09:42:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt0ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:42:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfo018519;
	Mon, 4 Nov 2024 09:42:03 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-7;
	Mon, 04 Nov 2024 09:42:03 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 6/7] target/i386/kvm: support perfmon-v2 for reset
Date: Mon,  4 Nov 2024 01:40:21 -0800
Message-ID: <20241104094119.4131-7-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: nmP97gL8Vk16FKAIIa4yfRAMlu4iMFBe
X-Proofpoint-GUID: nmP97gL8Vk16FKAIIa4yfRAMlu4iMFBe

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
---
 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 47 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0505eb3b08..68ed798808 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -488,6 +488,10 @@ typedef enum X86Seg {
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
index 83ec85a9b9..918dcb61fe 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2074,6 +2074,8 @@ static void kvm_init_pmu_info_intel(CPUX86State *env)
 
 static void kvm_init_pmu_info_amd(CPUX86State *env)
 {
+    uint32_t eax, ebx;
+    uint32_t unused;
     int64_t family;
 
     has_pmu_version = 0;
@@ -2102,6 +2104,13 @@ static void kvm_init_pmu_info_amd(CPUX86State *env)
     }
 
     num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
+
+    cpu_x86_cpuid(env, 0x80000022, 0, &eax, &ebx, &unused, &unused);
+
+    if (eax & CPUID_8000_0022_EAX_PERFMON_V2) {
+        has_pmu_version = 2;
+        num_pmu_gp_counters = ebx & 0xf;
+    }
 }
 
 static bool is_same_vendor(CPUX86State *env)
@@ -4144,13 +4153,14 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
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
+                has_pmu_version == 2) {
                 sel_base = MSR_F15H_PERF_CTL0;
                 ctr_base = MSR_F15H_PERF_CTR0;
                 step = 2;
@@ -4162,6 +4172,15 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                 kvm_msr_entry_add(cpu, sel_base + i * step,
                                   env->msr_gp_evtsel[i]);
             }
+
+            if (has_pmu_version == 2) {
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+                                  env->msr_global_status);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+                                  env->msr_global_ovf_ctrl);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+                                  env->msr_global_ctrl);
+            }
         }
 
         /*
@@ -4637,13 +4656,14 @@ static int kvm_get_msrs(X86CPU *cpu)
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
+            has_pmu_version == 2) {
             sel_base = MSR_F15H_PERF_CTL0;
             ctr_base = MSR_F15H_PERF_CTR0;
             step = 2;
@@ -4653,6 +4673,12 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
             kvm_msr_entry_add(cpu, sel_base + i * step, 0);
         }
+
+        if (has_pmu_version == 2) {
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0);
+        }
     }
 
     if (env->mcg_cap) {
@@ -4949,12 +4975,15 @@ static int kvm_get_msrs(X86CPU *cpu)
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


