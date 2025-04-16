Return-Path: <kvm+bounces-43499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A222AA90E20
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 23:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EF007A94A0
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A433424BCEA;
	Wed, 16 Apr 2025 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KJMmpWuA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208FB24A06B
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840685; cv=none; b=Y1YyUfFz1w379NqqaFkTM0YtXPvewx37Pr5eIQzmwNq6+axfspmzME++zM2JXQrcFgOWtJehYv+phHdLps8caG5YXPg+IT0JdaqMh3fIriT4TU+xbDsMDoX7BBRqmAHu/lssMBLZZZBbElx+s3ucoAUQW2pXNEBXsgL1rQDh3tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840685; c=relaxed/simple;
	bh=Ha1HYW+QDKRp4+1K8FFoi1cUlZ04tUeg74xEpo+5gv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6/vjWde40/j9t3RSgBfrxg7i4Cnm7GDieUuR9DpSjAfDwsipWzlhOMY82FgAo85Bct2GpVK5cwylkVp10BpEZecaMPyKQIiAhRavi/QSojBLMdZZ/voziex8YB7Vu86dqxQb5luc5NqnxO9mOXzk/4aGJFxLy7ZMSdlosakp4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KJMmpWuA; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLNiUT028808;
	Wed, 16 Apr 2025 21:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=zrsW9
	B0Kw+566H0LzTSEW67Xu8nF2NC7lmctRBkvIos=; b=KJMmpWuAepLM76Lsi3SHm
	qVU8FSs1+8B1j82MQqiz4myRjQKx6VwDb3n8trKy5++7u2E9Dy9dCUN/b8ZO9AAy
	IFY6AwzmlINVTfDG21p7dzEchusgYdbo6Hrqjz28xKteK/kVnP6QmaUbvDsyTI06
	9Vx65D6GTQkav3gWknaWaf1KdXEPnNeeBqNLDgj9k9u6wLp2Vl140hIpPG/sTySh
	flFlBSPGKjGdAHV7cuKmTAGbCrE2Pi00fNVboPvQUX+6Vw1FeHTw5oezDEHFmr/S
	DWT/CgDZNYrJCeiv5BBn80L+JkP1rC1Qz7Z5l1KFHBrLsbQkSErFGSVEbGUR5ZYW
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617jud6jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53GKVvPX005651;
	Wed, 16 Apr 2025 21:57:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5xhvq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53GLv1qe036583;
	Wed, 16 Apr 2025 21:57:21 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 460d5xhvcp-9;
	Wed, 16 Apr 2025 21:57:21 +0000
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
Subject: [PATCH v4 08/11] target/i386/kvm: query kvm.enable_pmu parameter
Date: Wed, 16 Apr 2025 14:52:33 -0700
Message-ID: <20250416215306.32426-9-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: 1bGCwNLmTZdfXa36pPFKeM7BYF21nKgx
X-Proofpoint-ORIG-GUID: 1bGCwNLmTZdfXa36pPFKeM7BYF21nKgx

When PMU is enabled in QEMU, there is a chance that PMU virtualization is
completely disabled by the KVM module parameter kvm.enable_pmu=N.

The kvm.enable_pmu parameter is introduced since Linux v5.17.
Its permission is 0444. It does not change until a reload of the KVM
module.

Read the kvm.enable_pmu value from the module sysfs to give a chance to
provide more information about vPMU enablement.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v2:
  - Rework the code flow following Zhao's suggestion.
  - Return error when:
    (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu)
Changed since v3:
  - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
    suggestion.
  - Rework the commit messages.
  - Bring back global static variable 'kvm_pmu_disabled' from v2.

 target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6b49549f1b..38cc1a5f43 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -184,6 +184,10 @@ static int has_triple_fault_event;
 static bool has_msr_mcg_ext_ctl;
 
 static int pmu_cap;
+/*
+ * Read from /sys/module/kvm/parameters/enable_pmu.
+ */
+static bool kvm_pmu_disabled;
 
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
@@ -2041,23 +2045,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     if (first) {
         first = false;
 
-        /*
-         * Since Linux v5.18, KVM provides a VM-level capability to easily
-         * disable PMUs; however, QEMU has been providing PMU property per
-         * CPU since v1.6. In order to accommodate both, have to configure
-         * the VM-level capability here.
-         *
-         * KVM_PMU_CAP_DISABLE doesn't change the PMU
-         * behavior on Intel platform because current "pmu" property works
-         * as expected.
-         */
-        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
-            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
-                                    KVM_PMU_CAP_DISABLE);
-            if (ret < 0) {
-                error_setg_errno(errp, -ret,
-                                 "Failed to set KVM_PMU_CAP_DISABLE");
-                return ret;
+        if (X86_CPU(cpu)->enable_pmu) {
+            if (kvm_pmu_disabled) {
+                warn_report("Failed to enable PMU since "
+                            "KVM's enable_pmu parameter is disabled");
+            }
+        } else {
+            /*
+             * Since Linux v5.18, KVM provides a VM-level capability to easily
+             * disable PMUs; however, QEMU has been providing PMU property per
+             * CPU since v1.6. In order to accommodate both, have to configure
+             * the VM-level capability here.
+             *
+             * KVM_PMU_CAP_DISABLE doesn't change the PMU
+             * behavior on Intel platform because current "pmu" property works
+             * as expected.
+             */
+            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
+                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                        KVM_PMU_CAP_DISABLE);
+                if (ret < 0) {
+                    error_setg_errno(errp, -ret,
+                                     "Failed to set KVM_PMU_CAP_DISABLE");
+                    return ret;
+                }
             }
         }
     }
@@ -3252,6 +3263,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    g_autofree char *kvm_enable_pmu;
 
     /*
      * Initialize SEV context, if required
@@ -3397,6 +3409,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
 
+    /*
+     * The enable_pmu parameter is introduced since Linux v5.17,
+     * give a chance to provide more information about vPMU
+     * enablement.
+     *
+     * The kvm.enable_pmu's permission is 0444. It does not change
+     * until a reload of the KVM module.
+     */
+    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
+                            &kvm_enable_pmu, NULL, NULL)) {
+        if (*kvm_enable_pmu == 'N') {
+            kvm_pmu_disabled = true;
+        }
+    }
+
     return 0;
 }
 
-- 
2.39.3


