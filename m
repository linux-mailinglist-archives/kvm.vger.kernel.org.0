Return-Path: <kvm+bounces-42220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96229A75D9D
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 03:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 519D0188A50F
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 01:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A56386359;
	Mon, 31 Mar 2025 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jzNav93C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800BD5A4D5
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 01:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384948; cv=none; b=WZtT6xYep4801toMxhyyAB5UhVs/S9Is34tjH3fStclJbOUJvHhZsmzoLQNOlwspH6zBraxDBnJFBt2HpoUFEEwTib1dDNjyonQy2rfCF5s7pmE01s2yXi1dt8eiCSECHmNXhJuydOOiYaVbJr7xpcq5+PKlHGHcp1TeEQqA/NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384948; c=relaxed/simple;
	bh=UD4tgXzcpc3zkiGYDeHk5HT09hYYWHq+VVF2eV/orKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adssGP23nDKgTe1waocUR5cIsPkUlFlzCHulW6GDbU3ym5NCj4BxksWA7QJP9OxJVsTZIUGMqs+AhfIG/W9zPbY/gtesiBVM+JQKuM/KB30xBInK4GQNVTd6Evwu5j4IvkDFHwuwndp/xF55RyfeM87l+VAj4lxS21z56wQpxfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jzNav93C; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNZ2UF002741;
	Mon, 31 Mar 2025 01:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=QEmFv
	iGAK3HVPMhByP1bT/49mKbRwqTnouSzcbyuEfk=; b=jzNav93CoUSl4bywu8s5E
	IdArw9Qr9mdgDLQiXyg8h7WzMuReKqSewNeH6DrNzl3xGXAeG6Zk2E1PHgdgzIoQ
	O9ggBt3+G/yP54RpWhZGTadVFsANvUWEp0LffwiAEplo/IIh6T76c3CqcAvEI2rB
	0Ag2hrFzh/cJYdkatwEfO1KvMRER7jMbQBuo16n2yz7QSZTIkEY5lDql2CgBckhD
	h6Ym9rqB1lLQIm2a0P641rSADUtKLo6loUjnSRDBGxy0ljaYOILsmu/2tbYV95w+
	0fFwNc7X41JfjH60NVxIl9x+1T4OEqQDy+1t6PBm1ByfWL3X1PFz39xnP4SjOILa
	A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79c2eru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52UN247e032670;
	Mon, 31 Mar 2025 01:34:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7ddrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 01:34:51 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52V1YfxN015214;
	Mon, 31 Mar 2025 01:34:50 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45p7a7ddms-5;
	Mon, 31 Mar 2025 01:34:50 +0000
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
Subject: [PATCH v3 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
Date: Sun, 30 Mar 2025 18:32:23 -0700
Message-ID: <20250331013307.11937-5-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: 1utXdqAG6eZnea9mOCSXfz-YhYY6YzKV
X-Proofpoint-ORIG-GUID: 1utXdqAG6eZnea9mOCSXfz-YhYY6YzKV

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

 target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f41e190fb8..579c0f7e0b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -176,6 +176,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -2053,6 +2055,33 @@ full:
 
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
     return 0;
 }
 
@@ -3351,6 +3380,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     return 0;
 }
 
-- 
2.39.3


