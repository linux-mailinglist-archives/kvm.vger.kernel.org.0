Return-Path: <kvm+bounces-62714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AC5C4BA3B
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466E93B8B76
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60802D6407;
	Tue, 11 Nov 2025 06:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TNDGBe0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B192D0C62
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842023; cv=none; b=t8MbJibDbU74yncOkoyL4eIYOh3Dsdwjf/FH6C5ymcw7FqYYqHek1a2jHrQInw3yFVDwAE6q8zlIVPkI5uaqkMX1ZJgBD2aEGpAzPkQxHW/uTS3GgRxEiZCnSq+hV6YegW6DkjwjFNDcuW72kcr27/IvD4YoNe+gEQ0mnfIsb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842023; c=relaxed/simple;
	bh=/Ipa2/v+grRgVLOg99qIzyoAOPi3UkYbuaKtOVUvaJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD4mEcHIZFwRESnBcQOgq1asOOJv81Cifnj+RPTh1KQWWbi5Jz8UWQ6S151V5uyPhXioui6mHizQY8BqjbGoRde41rnYCq/swbx3rM63cmtAZftr6l+5oCXshIKt+cej2TqokeTt2mqcrtslez/SqGZgf28DDfkahnPHmKly03U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TNDGBe0Q; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB6FniC002285;
	Tue, 11 Nov 2025 06:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=INa8J
	V9KTRBvQGaLmoIfs+xGcyNJ4M9v7NAdEw/bc7A=; b=TNDGBe0Q18+JUbLAZyw41
	yesV+b9+Ifzda5STLfcGP4JGAtX2VILcu2Lf2k9G3AxFkxIjy+Z8eVvpyGfnlF+d
	Q0UBvO1fygItcclUf5FBz2qwuvXGEjxAlXP6FyKzrP21n98GBYYDZM6R21c5PM83
	Z7WxaGMW7JK8ab3G+5pDP4zemQaDwK8TXQr207U3nBMXClz6JZgj4ynWjAUAAoia
	pmIrN3nIde0npNCIetAOnGYPM0ksNGtROvx5G49JW0xZseUl1Vm2GVNiAYBmRvij
	heo/ikbUMoDc5/HjQAZnRblMNCecBAaYDt4v2AOhW8vRcil5TFOC0H1u0zcCfcrv
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abw9wg67m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5i3Sl007655;
	Tue, 11 Nov 2025 06:19:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mkcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:19:59 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6qt029277;
	Tue, 11 Nov 2025 06:19:58 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-7;
	Tue, 11 Nov 2025 06:19:58 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 6/9] target/i386/kvm: query kvm.enable_pmu parameter
Date: Mon, 10 Nov 2025 22:14:55 -0800
Message-ID: <20251111061532.36702-7-dongli.zhang@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAyNCBTYWx0ZWRfX84KBCRd8pBeo
 AztAo8pzOH/ZPN1vnSZc7EgLZ0vqui/0D3tpMTAA290PBLVwoLaiB25Vr+bexSwupRJ4p/CDgEh
 9bTRB30hbzBnC04to+8g5Oz2k1RDKEMSND6p5ku34OiwepiTsWMlNYrBXhNc+lUAqSqto4VI/N8
 WBslFP/E58e6x8tkfi2g2tflX3gQx24bIZ0+E1kXyc9ITdDyO4LuqIRmOwqZzY5VzwyKBreH508
 jLIDJGVzJ+LCBwnTvqSh833IHk4mdEDTgCwuIn10+B0qZlwIdDXF+stpdn/JkEFgM9cWEEuEJuQ
 Rtx0buKt7QJjrPrRWeRyLcgS0sJBoX4Z4xYLK91p8wb2US1ZZ6853Q1rO7GjKTHOrUW/pxYqFZj
 /f6GdtXbtf2nnL3ljyaKII+Pjbo9GQ==
X-Proofpoint-GUID: IqmlbeLA03mv4tv8dKGCvfKAdwU6MBrZ
X-Authority-Analysis: v=2.4 cv=M49A6iws c=1 sm=1 tr=0 ts=6912d590 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=nU8S68INVtu7FNaSrVIA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: IqmlbeLA03mv4tv8dKGCvfKAdwU6MBrZ

When PMU is enabled in QEMU, there is a chance that PMU virtualization is
completely disabled by the KVM module parameter kvm.enable_pmu=N.

The kvm.enable_pmu parameter is introduced since Linux v5.17.
Its permission is 0444. It does not change until a reload of the KVM
module.

Read the kvm.enable_pmu value from the module sysfs to give a chance to
provide more information about vPMU enablement.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
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
Changed since v4:
  - Add Reviewed-by from Zhao.
Changed since v5:
  - Rebase on top of most recent QEMU.
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 577326537e..97782ce070 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -186,6 +186,10 @@ static int has_triple_fault_event;
 static bool has_msr_mcg_ext_ctl;
 
 static int pmu_cap;
+/*
+ * Read from /sys/module/kvm/parameters/enable_pmu.
+ */
+static bool kvm_pmu_disabled;
 
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
@@ -2067,23 +2071,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
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
@@ -3301,6 +3312,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    g_autofree char *kvm_enable_pmu;
 
     /*
      * Initialize confidential guest (SEV/TDX) context, if required
@@ -3436,6 +3448,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
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


