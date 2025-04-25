Return-Path: <kvm+bounces-44353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D751AA9D423
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF1FB1BC637F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 21:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199822577D;
	Fri, 25 Apr 2025 21:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFRmjVnw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D11A224AF9
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 21:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745616783; cv=none; b=U0WfzmlcFwpzDaGJXT9S2f+OQPaVoG6zICqMfXFthUsayCvtzRbNDNeuSgarXeVOL1k570mDzm2xUwkIwzM/3UHbM1t2dseO2Lzn5C5bLyWgaQ9otTnS5FWu5uYRn6+SkvzH8gumAFq8eb6Z3tdmdhZgrLuqq3LH3loZ9zoNJ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745616783; c=relaxed/simple;
	bh=otPHBbWCfQRw6e+W22z3L8ZUnf/w2nYcBEnHep6Il3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIfDU5Z7ok4/1Q8TJPF45vUt7nlvP2euw4TKe3+8c5sWQtrp+qKHC2nta/Y9sI+G+FTYKaNf5GvQG0SuQ47X55ITWPcaRkf4xbWFNTI14tjIyiHX7vE20rrLKt1fofFIpZIYUgIrR6ST49U7QJ4X7XX9uYZs0oNgZUXdBk0WA1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NFRmjVnw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PL20Ar004930;
	Fri, 25 Apr 2025 21:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Bzrco
	Lj3FUauGhRuhMvObRQGR8wTepMgICT5j9/wAts=; b=NFRmjVnwpFibpFuPcFshy
	Farh4MtNW6jQ3cnbifFmkAFjzwTqczoQqgyJOHk3nSew1gnAE1ZQcLaSWisj7/Oj
	sE9SWa6JM3/o3tBHQeZMQyTqbZX2Qu9BD99ipQieqKjXXnXYQzWTueSkVPJW+z+z
	uFe7bQwRYuNlD7LDq4vRHFmHr4qDXJ/tqvXaXDqK8ZRbPTIeq4IZ2Y09ZSjN9ZGK
	6hWAkTnSquTwxKF8AuO2UG3moCF31mAYBkULqZrzvRUeigBW/Q8P8YoqJ0gGuiNg
	2i0YvTpBlQF114TXHZ69Xor9s5hGhOVI9FvgsDiW0cKmn0RV6dH3ubmwCFYByv5M
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 468hxvg90t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 21:32:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53PK1hSd031089;
	Fri, 25 Apr 2025 21:31:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466k095v7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 21:31:50 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53PLVdAd039597;
	Fri, 25 Apr 2025 21:31:49 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 466k095v2d-5;
	Fri, 25 Apr 2025 21:31:49 +0000
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
Subject: [PATCH v5 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
Date: Fri, 25 Apr 2025 14:30:01 -0700
Message-ID: <20250425213037.8137-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250425213037.8137-1-dongli.zhang@oracle.com>
References: <20250425213037.8137-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_07,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504250154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDE1NSBTYWx0ZWRfX5vDDqGKO5nIi bphCY+xvfJRF2TZqFG3EKt1I1C88AuNqJiyMmjajwp1kACZ5+pBDpCkoIvdXzU744zNyxgvXWrA K3r710GKjnjEgprxPFTIgWIYsKI3or5G5cIrWdo7buyhZkeqdjoq4cbFATA3XOUd/iG/CvAPhpf
 PjbfLDQ4ItI0f/ryL5FmuDZjD8L0OO9fEVLZgPWSLQmKxIUcT7ChdUJwBhyyH+GFVcryIz6KYjY rIYH41JNWOpbt7KPLctkX+o21DaJpTKDai4m54yLPDDMuPaqjf6KZaFCTRkafZJC1xvv3wncGSX 3xEfsFI7DhXV/n6Sk8YRs0L7kuy2kH6S/kDkbTBpzHSyRCn3p3kltLBIyY4Zxg2ClKVSzsy6C8t MN/jAARp
X-Proofpoint-GUID: 4O9KCc7eBOdUWtAAQCFtcOGAJGxDs8oO
X-Proofpoint-ORIG-GUID: 4O9KCc7eBOdUWtAAQCFtcOGAJGxDs8oO

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
index 7cd418b59d..96d87821a3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -177,6 +177,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -2054,6 +2056,33 @@ full:
 
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
 
@@ -3352,6 +3381,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     return 0;
 }
 
-- 
2.39.3


