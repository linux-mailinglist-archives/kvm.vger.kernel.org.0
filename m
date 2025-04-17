Return-Path: <kvm+bounces-43561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C783A91A87
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 13:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AD134474CA
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0AC23A998;
	Thu, 17 Apr 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T5ygU6wf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F41239592
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744888780; cv=none; b=KZlkD96c0QK+r9dBwOdJqu6WnV+yBzTh/nBMXTDVuapAcUBYc7FV9Fwcgs5Vna8Dph5rlci7oKDiA3Fa8aRo7BE2RpzcmWrMU7UwL+cPR+5F+Y+dScEdoh7q6QPnNt2xruAJSxjov8gXKV9v7kOraH4pEELYLMOC3FLhTUFJgHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744888780; c=relaxed/simple;
	bh=n7yAvIhNMMoVVeoUjYc+AoM9iaRYa8XWQFqQq28jTGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q//pg4PcLE0pz5vLsxMmcERk+70MwtbqAunuhYwgk68ixov5RNdwXHoF8CH/YfSizzhH8QdbV1r0+bU1r7EVhOv9Ambmxh6aQ8uq6pucGbotcwuwGe7JYRewGALJzAATd6jR2Q6AWE3zrlx6Mtcftaw0srI4Y9txmMFk6uqxRWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T5ygU6wf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H9YV3k017611;
	Thu, 17 Apr 2025 11:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Yezzv0pZeIyWHSKf3BEz3UFe19N90TLZsvxQ4zxMv
	Zk=; b=T5ygU6wfq7Tjtt+ibueJbGPqMVeD6UlCbJ0kpxgPnm0J9u5KhbKgY+fHQ
	vkt5959WL5ZsDEvhMbIwRRgRdm45q4Ml27Wlk1yYWWekZekC1GzGQWPlVje79Q7H
	zP4v3471ecuX87ST1MkFa3EE/exBjPpkS4B/sc0LdnlRQuIQ57qQqeMbZd4iC1cO
	A+GL5dAjeKjsZVQDl65Nke4A2v2s5QQafYQvlKVhZBmKNllwYbDp1YXiRPdhF0Ck
	QOr7xCvPdNbgmKgidNmfUTIMjfWS8BD7qRS6tMAk7cXhVr93XQgiyI4Dp8Ch/3rh
	F3QkqH9G0fdag5sObQBLCuEpCrbxQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 462mpv30gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 11:19:27 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53HBFgvR023174;
	Thu, 17 Apr 2025 11:19:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 462mpv30gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 11:19:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53H7SoQx016722;
	Thu, 17 Apr 2025 11:19:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 460572d0hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 11:19:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53HBJNg948628218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Apr 2025 11:19:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E46B720043;
	Thu, 17 Apr 2025 11:19:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AB1220040;
	Thu, 17 Apr 2025 11:19:21 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Apr 2025 11:19:20 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: npiggin@gmail.com, danielhb413@gmail.com, harshpb@linux.ibm.com,
        pbonzini@redhat.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, vaibhav@linux.ibm.com
Subject: [PATCH v2] hw/ppc/spapr_hcall: Return host mitigation characteristics in KVM mode
Date: Thu, 17 Apr 2025 16:49:03 +0530
Message-ID: <20250417111907.258723-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KJVaDEFo c=1 sm=1 tr=0 ts=6800e3c0 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=XR8D0OoHHMoA:10 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8 a=3kwgc6Q8V27WDnC-VUoA:9 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-GUID: aCjsieM87y1ErwI5XJvhlo31VVZnHbM-
X-Proofpoint-ORIG-GUID: Nm001CVr7WdtHJBJMHYoUivQB8_iZ-C9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504170082

Currently, on a P10 KVM guest, the mitigations seen in the output of
"lscpu" command are different from the host. The reason for this
behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
hcall, QEMU does not consider the data it received from the host via the
KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
spapr->eff.caps[], which in turn just contain the default values set in
spapr_machine_class_init().

Fix this behaviour by making sure that h_get_cpu_characteristics()
returns the data received from the KVM ioctl for a KVM guest.

Perf impact:
With null syscall benchmark[1], ~45% improvement is observed.

1. Vanilla QEMU
$ ./null_syscall
132.19 ns     456.54 cycles

2. With this patch
$ ./null_syscall
91.18 ns     314.57 cycles

[1]: https://ozlabs.org/~anton/junkcode/null_syscall.c

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v1 -> v2:
Handle the case where KVM_PPC_GET_CPU_CHAR ioctl fails

 hw/ppc/spapr_hcall.c   |  6 ++++++
 include/hw/ppc/spapr.h |  1 +
 target/ppc/kvm.c       | 13 ++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 5e1d020e3d..d6db1bdab8 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1402,6 +1402,12 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
     uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
                                                      SPAPR_CAP_CCF_ASSIST);
 
+    if (kvm_enabled() && spapr->chars.character) {
+        args[0] = spapr->chars.character;
+        args[1] = spapr->chars.behaviour;
+        return H_SUCCESS;
+    }
+
     switch (safe_cache) {
     case SPAPR_CAP_WORKAROUND:
         characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index af4aa1cb0f..c41da8cb82 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -280,6 +280,7 @@ struct SpaprMachineState {
     Error *fwnmi_migration_blocker;
 
     SpaprWatchdog wds[WDT_MAX_WATCHDOGS];
+    struct kvm_ppc_cpu_char chars;
 };
 
 #define H_SUCCESS         0
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 3efc28f18b..fec7bcc347 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2499,7 +2499,8 @@ bool kvmppc_has_cap_xive(void)
 
 static void kvmppc_get_cpu_characteristics(KVMState *s)
 {
-    struct kvm_ppc_cpu_char c;
+    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
+    struct kvm_ppc_cpu_char c = {0};
     int ret;
 
     /* Assume broken */
@@ -2509,18 +2510,24 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
 
     ret = kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR);
     if (!ret) {
-        return;
+        goto err;
     }
     ret = kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &c);
     if (ret < 0) {
-        return;
+        goto err;
     }
 
+    spapr->chars = c;
     cap_ppc_safe_cache = parse_cap_ppc_safe_cache(c);
     cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(c);
     cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);
     cap_ppc_count_cache_flush_assist =
         parse_cap_ppc_count_cache_flush_assist(c);
+
+    return;
+
+err:
+    memset(&(spapr->chars), 0, sizeof(struct kvm_ppc_cpu_char));
 }
 
 int kvmppc_get_cap_safe_cache(void)
-- 
2.49.0


