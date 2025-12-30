Return-Path: <kvm+bounces-66820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2AACE8ED3
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 08:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 74DB23003114
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 07:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7B22FE057;
	Tue, 30 Dec 2025 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hmEGrfnG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4B2FDC28
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 07:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767081324; cv=none; b=kwCwDqWYs2dQIDJADHCdWg+jzZaiOvYOtIzhJiQCL/7rInku7zN+EmIbchWb1u1Ab6RAoUzB9a+WGAVJp1RLZuZ9F9FfagACPRqZBPqoBW1hKi/DqU0Fz+BZjO6u38L4eG9+n7pow7sXsdPDBG8kRqkHMoPCJphPy36IWzs+T9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767081324; c=relaxed/simple;
	bh=HqWHOD1/sRewHQvmvEgl6Gm70RXP2cY4D7p1ExHpYNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbcQWtSYCHEMz55rATI2ISXptRqaSQPAUY53pHa4HbxYlkp0v9cX9W8u9W2qE80AOagVBsF3Fr6M9/EVIX2Ked8iFKw9w2t9/X7CDWTLCNvQ9EHT16SEh662c9D3bfVRoGJO1qE8dKgpNuCjeU1B4uImPu0rN0fujdZJytM+ugM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hmEGrfnG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU2pZV43280009;
	Tue, 30 Dec 2025 07:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=lNOII
	rFODQaNC2ZDsVuxvf9P0BIuEF8bFyedc9e5vws=; b=hmEGrfnGxsvy+DjWCDOmM
	XEaReUNE1lwNlaN9looZ7Z7M2Kz4O7b4XaepTsT1UOuWLZFlNeZ04JPqF+6Bx3lG
	3IT8at+Ufo03DBkrfHOP2awmY5bmGoRYtW4abLHOqjFFyjh4uAMdvem6I/GQ8s2W
	N6h9kHpV2XWe7Tl/TtS3XR6FV2wlcmdr78Z6MT5pM8ByX8ftcVEYZdnv+Jc8dCCm
	jjl4fHoOQl+hYPUhdCDIhb/9wt8TGFoFQddxYybmshB4DnCG3pzQ8iNyS8No/l2i
	Xp1xUj+20AJ57mTUMP0l4rrHhEHid4OsQfAPTh8aWvBYnIjeADkI/2im1Wa4miCa
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba72qjaxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BU7cOHV017396;
	Tue, 30 Dec 2025 07:54:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wbp6ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:54:51 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BU7smZl005421;
	Tue, 30 Dec 2025 07:54:50 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ba5wbp6aa-2;
	Tue, 30 Dec 2025 07:54:50 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v8 1/7] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
Date: Mon, 29 Dec 2025 23:42:40 -0800
Message-ID: <20251230074354.88958-2-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: 6DarUFJtg_exhWwXPKITIWkfhTuhNnwc
X-Authority-Analysis: v=2.4 cv=MqBfKmae c=1 sm=1 tr=0 ts=6953854c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=QyXUC8HyAAAA:8 a=I5TUGnRYk-IH75UTjikA:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: 6DarUFJtg_exhWwXPKITIWkfhTuhNnwc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA3MCBTYWx0ZWRfX8D3rL44OW0xB
 RGn8Qp1e7VwAxYJMN89McamVqyTcgLfsWfLIB639m+YaTaBc4V2Uj8OFXN5of4Q5skZXhKarfdI
 0/f0fWBPUbaHJJwCMtwWC8sRUNx0hZSdco9hgC2pXjJGRt+ZQUNdio7X4LbgfOwt7V1pe58iJiX
 PqEnpCt/1bi3tTRvnyk8l7CgYR3al9F5vWIlPkZjR539hulutsTkIuc4OdittKLOuVsNJ12VNvg
 ZHwQaI2gGEg8bkdDC6KAqQWxe3P/1wxE32E+vQl7fznZ4KTznvuy+UIRAi5FVKPZMaBm2oZd6so
 demf6Z8HUnhDM/b7KZLoFZjVzvtTBfJsdQGL2ShmRi6rMGlvAQTEWliEJcP6Zn+/T6jn2CGUt0/
 4o8cVpCPavdphMFO4n3uDxwweN+CaaczYHNZOgXuWp6naPv2qbEghLPNEAu/GVUBgGUk5tCX7WA
 dx16wUozP2p6P6xRp/YK4NsQH8Xm4IPknRCQM4yU=

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
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
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
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e..c98832f423 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -179,6 +179,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -2080,6 +2082,33 @@ full:
 
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
@@ -3391,6 +3420,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     return 0;
 }
 
-- 
2.39.3


