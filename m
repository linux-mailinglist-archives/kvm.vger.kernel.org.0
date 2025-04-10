Return-Path: <kvm+bounces-43082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C664A8410C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 12:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D4F4176372
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393B228134D;
	Thu, 10 Apr 2025 10:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fvmXeU0z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE521C170
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744281861; cv=none; b=g6X7taPp9ZfcPhhPeyRO7gPj01XMVRCVk/UrVJY5qa5A5GKVzzwWxhWeT/7nrC/0qWyRl1eC4hQl4zLSkX83Ci26dkBuLidi6jXl7gzvjl1siIJsyaNzam22QVRwN2YExTr5Vuhx6NwzeAt5TU2mioU2DV4mKZ4mX5w0kzf6Hos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744281861; c=relaxed/simple;
	bh=E01+iQA94cvXi0qgpJr8aB1sxoNSlv+odisgnLSKWIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hCgfwmJ3oeckFrpYnDr7yFc4i06EQizdrshB6mrw/7OQM7KEFVPNM9ynJEAFt78cIPXtXkXPmKluJZCI9fOCOl9fVZ93qnfCF/faKu5iP34c3M2Z/JRBLvjkZx/u6k3eKlmheRayyGw3PWYcPFR9gk1bpxXRVNUyjDr3LCDwURk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fvmXeU0z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53A6FWlR005759;
	Thu, 10 Apr 2025 10:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=W6Pp1nN0u9VE3yPMozkRTu3XvxoLdIIkl0GkyuAcR
	cs=; b=fvmXeU0ztvg5yviGcshgccyWho8bwAHEoULBMUiQ8jSE3YFoe6AYcLub+
	ZjUXjFEE+4pbmrE36+xxcgyuwRcn1KjlRAVMoe7Wvp5JI6C7aXqMGWcEHcWpf2QB
	NwT/HNSdwR7Isc0oolrGiwktK43BbjxZ3QIjONbEPmBI9HNgjGi8Qs3jfqvgdWKk
	qSPr+ZR1cgoIYFRdvVFEHQO5E26XDya166+wwDBZX4c0nRtTygek6pIoJ7R6UVaH
	OLRDkaf9fNN9QZZcSSCDgdRptxXkT4kDPVgmFQ9FGiLX0+pVIKmi+877lI708/78
	oAik5kK7TFK24mqdP3QQZBJ5zCy1A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45x04044b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 10:44:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53AAf3O5017516;
	Thu, 10 Apr 2025 10:44:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45x04044b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 10:44:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53A8eTiI011069;
	Thu, 10 Apr 2025 10:44:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45uf7ywsbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 10:44:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53AAi3V049152284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 10:44:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FCB82004B;
	Thu, 10 Apr 2025 10:44:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D73EF20040;
	Thu, 10 Apr 2025 10:44:01 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Apr 2025 10:44:01 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: npiggin@gmail.com, danielhb413@gmail.com, harshpb@linux.ibm.com,
        pbonzini@redhat.com, vaibhav@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH] hw/ppc/spapr_hcall: Return host mitigation characteristics in KVM mode
Date: Thu, 10 Apr 2025 16:13:53 +0530
Message-ID: <20250410104354.308714-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CgcgQ5YApJANyeB-7xQW7X-XT38F0tWN
X-Proofpoint-GUID: fwPwKQWeCdSrbVJnezC8KjNSbrYNL1zd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_02,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504100078

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
 hw/ppc/spapr_hcall.c   | 6 ++++++
 include/hw/ppc/spapr.h | 1 +
 target/ppc/kvm.c       | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 406aea4ecb..6aec4e22fc 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1415,6 +1415,12 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
     uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
                                                      SPAPR_CAP_CCF_ASSIST);
 
+    if (kvm_enabled()) {
+        args[0] = spapr->chars.character;
+        args[1] = spapr->chars.behaviour;
+        return H_SUCCESS;
+    }
+
     switch (safe_cache) {
     case SPAPR_CAP_WORKAROUND:
         characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 39bd5bd5ed..b1e3ee1ae2 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -283,6 +283,7 @@ struct SpaprMachineState {
     Error *fwnmi_migration_blocker;
 
     SpaprWatchdog wds[WDT_MAX_WATCHDOGS];
+    struct kvm_ppc_cpu_char chars;
 };
 
 #define H_SUCCESS         0
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 992356cb75..fee6c5d131 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2511,6 +2511,7 @@ bool kvmppc_has_cap_xive(void)
 
 static void kvmppc_get_cpu_characteristics(KVMState *s)
 {
+    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
     struct kvm_ppc_cpu_char c;
     int ret;
 
@@ -2528,6 +2529,7 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
         return;
     }
 
+    spapr->chars = c;
     cap_ppc_safe_cache = parse_cap_ppc_safe_cache(c);
     cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(c);
     cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);
-- 
2.49.0


