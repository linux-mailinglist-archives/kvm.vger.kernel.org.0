Return-Path: <kvm+bounces-50457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3AB9AE5E56
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B57E1B64334
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AC5254AF0;
	Tue, 24 Jun 2025 07:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fc9SHOOo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086D2228CB0
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751372; cv=none; b=NhuurWvyQr80EWk/rnSzYdP8wTfaQwrw3MST88M6WQR83JVcHeKn6WogduxDgH6xNs+ivU4CDKQGQn5EP4B/jOs3cY941C0FVQQIaur9A/5uthxL7j1VtsVc9B1YMbZA83jugToLF1EeDwLMuM5mswKGLtZD/xTrhKFV0ps3SqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751372; c=relaxed/simple;
	bh=9maWEE47B197uv1k1HJu+jqWWJd+8HkNZKvM/C2tqHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fViuaV+w+EpAWBD/tf4455fFNBB33hU02DhXAIas+5NEfjFCIUfOPUmwGxn+wY5ejw6LrwSiocERxeSOjHck7N2EGi+WHwb1oVCwihF/1BlJEq4MGiZvjBXuOe2xlheuLqLiOsTqsdxMTr6FiNNWAE8S2j/HtVnmOUMvV2Vn/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fc9SHOOo; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7faOw012638;
	Tue, 24 Jun 2025 07:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=TdOFz
	eg03yh7RYA0ahddfwHEDYxsvqDbPFgmikDSa7w=; b=Fc9SHOOotl7reGW/PwNgf
	FdEg9FxxlIU9RegMA0saSrYnzmUR7qqCMVXhluYCb5DVIm/YSUN1csaKY5u1qaKl
	JxI4RFNzxB6mfbRjUClahsxqA2V46N3ls8QnkXBkwvzsYij8feixFZ0ZTf5ji3+M
	gj8lxbCeLocwGe5obhp8DGq+qzNx2HyDGCmVR249RRs8nC5w+t/tEWcgSSNThVCv
	FUFjYUw5DNtgeHk19W6SFVp43RxwEWT9u97xJLEbFFzp4M1Ae1l49soYHoa8pnJ6
	tybEF++0KuNKAA2Bb5WACayahnGh0ipDeZacDi0Yo9YY3bVqEbAhn3WfRH2tGr7I
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egumkerj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O62kZK005022;
	Tue, 24 Jun 2025 07:49:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3ar3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55O7n5Xm006279;
	Tue, 24 Jun 2025 07:49:08 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq3ar1g-4;
	Tue, 24 Jun 2025 07:49:08 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v6 3/9] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
Date: Tue, 24 Jun 2025 00:43:22 -0700
Message-ID: <20250624074421.40429-4-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: 6Q-B-AnECegMEeBTIztdGgyKPrEoTSF7
X-Proofpoint-GUID: 6Q-B-AnECegMEeBTIztdGgyKPrEoTSF7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA2NiBTYWx0ZWRfX04ka/NQyy1UV isRy754fGEX03I3EXW8wGoM61wqGpqQxFAgo8r8DJFilxojED6IgVvO4+nbJGKIgsV1hf9SfUDU BdxyHUR6u7xzOppFiy2HyuDYF/K1tfU16dKTc6G0k846dX/X9PNxulkGvIL4UJ/HHPUbt338yrs
 RSefLVZnSP8dD4J73FNepGClB1aXZIFBo3IekBDnao+10dN/+dmUW4z8JwCqTPE1aKEC2IfWph1 lWZtGcwpeCWbuc0sePO7S5ojcyb7ChFR1BDtbmEBze1J+zq/WaRtNfuhS0ZytnYThY5bguwYwaI YLd1cMJRGPkJ+bcLjpBwaVJDbQY4576uatkySezAcMRgATzxmoUJkbF/q/PNV4NsX1R2Fe+kTDT
 1as/1ECpl/g9Br+39y6go/W6S1d2v6GsLocdufVKrepiFpapp9d1PcWKefHyqLAl1ivvRXz0
X-Authority-Analysis: v=2.4 cv=S5rZwJsP c=1 sm=1 tr=0 ts=685a5876 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=I5TUGnRYk-IH75UTjikA:9

Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
there is no way to fully disable KVM AMD PMU virtualization. Neither
"-cpu host,-pmu" nor "-cpu EPYC" achieves this.

As a result, the following message still appears in the VM dmesg:

[    0.263615] Performance Events: AMD PMU driver.

However, the expected output should be:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This occurs because AMD does not use any CPUID bit to indicate PMU
availability.

To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
when "-pmu" is configured.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changed since v1:
  - Switch back to the initial implementation with "-pmu".
https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com
  - Mention that "KVM_PMU_CAP_DISABLE doesn't change the PMU behavior on
    Intel platform because current "pmu" property works as expected."
Changed since v2:
  - Change has_pmu_cap to pmu_cap.
  - Use (pmu_cap & KVM_PMU_CAP_DISABLE) instead of only pmu_cap in if
    statement.
  - Add Reviewed-by from Xiaoyao and Zhao as the change is minor.
Changed since v5:
  - Re-base on top of most recent mainline QEMU.
  - To resolve conflicts, move the PMU related code before the
    call site of is_tdx_vm().

 target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 234878c613..15155b79b5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -178,6 +178,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -2062,6 +2064,33 @@ full:
 
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
+    static bool first = true;
+    int ret;
+
+    if (first) {
+        first = false;
+
+        /*
+         * Since Linux v5.18, KVM provides a VM-level capability to easily
+         * disable PMUs; however, QEMU has been providing PMU property per
+         * CPU since v1.6. In order to accommodate both, have to configure
+         * the VM-level capability here.
+         *
+         * KVM_PMU_CAP_DISABLE doesn't change the PMU
+         * behavior on Intel platform because current "pmu" property works
+         * as expected.
+         */
+        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
+            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                error_setg_errno(errp, -ret,
+                                 "Failed to set KVM_PMU_CAP_DISABLE");
+                return ret;
+            }
+        }
+    }
+
     if (is_tdx_vm()) {
         return tdx_pre_create_vcpu(cpu, errp);
     }
@@ -3363,6 +3392,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     return 0;
 }
 
-- 
2.43.5


