Return-Path: <kvm+bounces-42222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9A6A75D9F
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 03:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4583188A56D
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 01:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AA513A3ED;
	Mon, 31 Mar 2025 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9T8wdN7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963D7080D
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 01:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384948; cv=none; b=RFDPi873DoKpUVnPUzr1BO2nFNmNMnJ7GbyVqkITYjLoIBx29JDgl0oriUPe/yfcDppESDov3l95uQGQv3dmGvAVKA9297MtkqzT76//PjLRGObvAkp1GWWmTCoiZhPIVVnGOrc9Q30uiX9gB8iTgUiFzxGgGjXxotbeYLekFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384948; c=relaxed/simple;
	bh=95SXkpUOOnjWMwM8/kBh2Xw3APDrBpDvWLKRWrDjS7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjkLacwYiDWDLjhFSMhTFaxqzUvD/109o+5RG4rCKPe6aYBpiZgaCF4kG/xQKPozw15hrDBS2u3tIyfzdtB+Jq5wOUPaLFEjVjCn8CqdkJwK6Ft0k1js8xmoE6Chfp2XfaMtuqWdOe5lhDjcAKRPrvpiHBorsLjKKowBj9cdJ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y9T8wdN7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNrlYe027570;
	Mon, 31 Mar 2025 01:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=uKlqO
	dhnxF9XZFanemfUUs541QDubDS3SJU+AHnhLXQ=; b=Y9T8wdN7+S4CTFfg8JhrJ
	NtyZcs+XQWv2b8xGt0CI+sFN9s6ns5Zt1NfO7Ju+LNpWsRtyfTIQp88Y7sa0h2xo
	qWipMzKjZ1eeEPFuiKgVRDfn7M6H2XXNQF6guMX+ZS89WKwlRxVrHZj+YGGI/988
	yCeNy0K2vlceuFlu7KvWU2ar5J6fQnOHBDIRAHEErs3kkuOsIJ2UsPFkEMJUf3ud
	9JPtMEeg2mK5qJaVyqiyXDO6XpEBXAR/yIOUecavzrm0dEQ/+2026jtdFzuV+mPQ
	hVc+8Q5knGOm9DGd8VL8Yoz3ILMebaofzabJe1OYsi71wuz6YHAip/beoKZuq6r5
	w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79c2ery-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNQAtp032594;
	Mon, 31 Mar 2025 01:34:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7ddtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52V1YfxT015214;
	Mon, 31 Mar 2025 01:34:57 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45p7a7ddms-8;
	Mon, 31 Mar 2025 01:34:56 +0000
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
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: [PATCH v3 07/10] target/i386/kvm: query kvm.enable_pmu parameter
Date: Sun, 30 Mar 2025 18:32:26 -0700
Message-ID: <20250331013307.11937-8-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250331013307.11937-1-dongli.zhang@oracle.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-30_11,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503310009
X-Proofpoint-GUID: RJcy_F8DOBA9Y14oXQWwQkwHzR6F2YWj
X-Proofpoint-ORIG-GUID: RJcy_F8DOBA9Y14oXQWwQkwHzR6F2YWj

There is no way to distinguish between the following scenarios:

(1) KVM_CAP_PMU_CAPABILITY is not supported.
(2) KVM_CAP_PMU_CAPABILITY is supported but disabled via the module
parameter kvm.enable_pmu=N.

In scenario (1), there is no way to fully disable AMD PMU virtualization.

In scenario (2), PMU virtualization is completely disabled by the KVM
module.

To help determine the scenario, read the kvm.enable_pmu value from the
sysfs module parameter.

There isn't any requirement to initialize 'pmu_version',
'num_pmu_gp_counters' or 'num_pmu_fixed_counters', if kvm.enable_pmu=N.

In addition, return error when kvm.enable_pmu=N but the user wants to enable
vPMU.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v2:
  - Rework the code flow following Zhao's suggestion.
  - Return error when:
    (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu)

 target/i386/kvm/kvm.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6b49549f1b..f68d5a0578 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2051,13 +2051,35 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
          * behavior on Intel platform because current "pmu" property works
          * as expected.
          */
-        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
-            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
-                                    KVM_PMU_CAP_DISABLE);
-            if (ret < 0) {
-                error_setg_errno(errp, -ret,
-                                 "Failed to set KVM_PMU_CAP_DISABLE");
-                return ret;
+        if (pmu_cap) {
+            if ((pmu_cap & KVM_PMU_CAP_DISABLE) &&
+                !X86_CPU(cpu)->enable_pmu) {
+                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                        KVM_PMU_CAP_DISABLE);
+                if (ret < 0) {
+                    error_setg_errno(errp, -ret,
+                                     "Failed to set KVM_PMU_CAP_DISABLE");
+                    return ret;
+                }
+            }
+        } else {
+            /*
+             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old
+             * linux, we have to check enable_pmu parameter for vPMU support.
+             */
+            g_autofree char *kvm_enable_pmu;
+
+            /*
+             * The kvm.enable_pmu's permission is 0444. It does not change until
+             * a reload of the KVM module.
+             */
+            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
+                                    &kvm_enable_pmu, NULL, NULL)) {
+                if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {
+                    error_setg(errp, "Failed to enable PMU since "
+                               "KVM's enable_pmu parameter is disabled");
+                    return -EPERM;
+                }
             }
         }
     }
-- 
2.39.3


