Return-Path: <kvm+bounces-50462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F63AE5E5B
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E90FA3A4C22
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725D0257AF0;
	Tue, 24 Jun 2025 07:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hy8+29iY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCA1257424
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751377; cv=none; b=V3ykp0jEhM76+e7WtD22MFlSjGs1w9YmP29RTwNaSt4uB8zdhUIToAubjUQNpfIbsBC5iVmh6iNU48Wz89mOOLU8LrdDeKS7IJwLe1ZRAWXxIZ61lNYC2TswMiAupteModUxjM5nQKL3MvxQuZ5Xx1zQOjwHW4xvKopT2l0tu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751377; c=relaxed/simple;
	bh=nwr3U24pPk6AzFgoof4ezInzZ4jRsTORZCzmJQpgsiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKqqh3zi+C6O1pH9a0RyYEKfLMQ2PLLn4KgerzN0JUlyhHy4F2O96KPCeo1GbPDzr6Y/dN0BOVLNOKtCdzei2q5SeG0TpdLLKlt+zwk+dGKsFdnhSmABypRe8XoRx01vexqP3HtexR1xFt7JSDwzytlLI+GHJwzhzSpXNjsCxc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hy8+29iY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7fcw1012645;
	Tue, 24 Jun 2025 07:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=AJ8nS
	eLDSZQwJn0AugdtCyJ7p5KTw4bhLrSLqx1WB0E=; b=Hy8+29iY75PMpDlyXWZhO
	x6nk7fpCI/04Q92Gj3nQ+8awoGYpGIblqlVD33ucFC3qyeVDMyph4SyvhcFZUvx3
	6GxmVI3mcH/WrYQSsfqVArjjH7k/Kt4IKiqoUzieRaat30Ng2ucRDIZ2F9CACO9p
	lfjd6Y1WrkAWOzXibCiMH53yFKbzczQH+im3JWInPZ3KT02q4K8sHSOn4fCAep3g
	9/kWwv638IVsadlfEGfX0CSLkIhBTNgyrQN9CZdr9BLXy7hNj3KmusiKZiemIACI
	TwmZ1S8Kx7trNLxTwrdujawKacANuzde9vDaMC+tSVNc2Hdfyv55fdHMNLsOVsEI
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egumkern-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7W8HY005631;
	Tue, 24 Jun 2025 07:49:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3ar5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55O7n5Xs006279;
	Tue, 24 Jun 2025 07:49:11 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq3ar1g-7;
	Tue, 24 Jun 2025 07:49:11 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v6 6/9] target/i386/kvm: query kvm.enable_pmu parameter
Date: Tue, 24 Jun 2025 00:43:25 -0700
Message-ID: <20250624074421.40429-7-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250624074421.40429-1-dongli.zhang@oracle.com>
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_02,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240066
X-Proofpoint-ORIG-GUID: H0PDEmEB5QZUzfHtlXVPLdIcvPOl6B-Z
X-Proofpoint-GUID: H0PDEmEB5QZUzfHtlXVPLdIcvPOl6B-Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA2NiBTYWx0ZWRfX8AQbDnU/P9fE VZWmTy0QZ7Ewgec+JFBUGbefuRUHKvFCwmFHRQNLvjx88YK4hgufBkXFmkiHAZLCrwX1UpYSRPD vbKrcPTPTIdE5TvfqGEdHMlXLBy2usvKy75og8rzTnpsTChQG+FozfXkrpP+FWNcMWX7kJuIJ8x
 bcqtlp8gNezkoCihqWrwIRQGB0z51BmV2O1/UMdO32hEVuv4WtVb2C3P8RTeCM/2KqGMrGdHBge 9fli7nbrGkaihGSh5I3ZTD2W+YwYK+N8gjy2SWKPGx0Aa5gjTDXWESEehKXTfuRxLkhJvoAGdm3 ctS/hS3dLUxkeP8cYBE9pXlCCgyof2/vSvDl1nQBaOoQa2iaZvREWoPh8SMrmmA211v5Q4nq2So
 U6oYDM+rVGmxTF6jbHUQXmGuJpDelCVZfS9iaC1tPyW2ru73aM8l7HO1Tu8Ek/taznL02H2U
X-Authority-Analysis: v=2.4 cv=S5rZwJsP c=1 sm=1 tr=0 ts=685a5879 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=nU8S68INVtu7FNaSrVIA:9

When PMU is enabled in QEMU, there is a chance that PMU virtualization is
completely disabled by the KVM module parameter kvm.enable_pmu=N.

The kvm.enable_pmu parameter is introduced since Linux v5.17.
Its permission is 0444. It does not change until a reload of the KVM
module.

Read the kvm.enable_pmu value from the module sysfs to give a chance to
provide more information about vPMU enablement.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
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

 target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 824148688d..d191dd1da3 100644
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
@@ -2050,23 +2054,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
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
@@ -3273,6 +3284,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    g_autofree char *kvm_enable_pmu;
 
     /*
      * Initialize confidential guest (SEV/TDX) context, if required
@@ -3409,6 +3421,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
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
2.43.5


