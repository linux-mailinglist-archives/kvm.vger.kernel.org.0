Return-Path: <kvm+bounces-57325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42937B5359F
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A154018813AC
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 14:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F873451A5;
	Thu, 11 Sep 2025 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h2yNeXdJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FD233EB13
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601225; cv=none; b=WVijzQ4D0lTrpd5O6FbEFL8PoCj+BUv3JDOwigHN8CHP5ZMTM8Q06O8AhgYghUbeLKTSCuJBIyV5eK3Ns1DiukBWk80BFBTCPE7OMgSi7KEAc1MTyuSqnS0K3Eqlv3XLkKzGTEKsB7ON9wko3y6xsyW9eBGCNJ4B5cu7bkSqRXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601225; c=relaxed/simple;
	bh=G9/Ufw5ySu5zuqFv5uU34fSFsBAPmeIlcg5nc/EEi0A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pOfagvgV1iDrPIcqTj+Mjb4KSFrVyf/kY46NgDjWbArIa1y6T2/7U9LICndHjMdksFzF8ILrpCjxz1P8/X37U+hpk4kgBKlm0KYlfwreosavsx5MZbXWsNkN3CInJ7JG1C6TID6Rn/WaN5YKi2+NfgUrO14y79Z8AYE6xLcCPg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h2yNeXdJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B63BE6024821;
	Thu, 11 Sep 2025 14:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=JCZEM+W/7YMGUhHjvYWtqcAniVYI3VzWeo2tV+Dky
	hM=; b=h2yNeXdJOzhZVHkhd3suuEGH3tqNAGte9svVV6eHwhZ2I1yQZN2aU4Dks
	AHiASpqDtaOZdh+G9+dE2j4DIfSapFVTU4taQampEopUfzdtrSqvStdynW8TZbCv
	tCHBdXZx9HnlCTw3dg3VAZuuNfv97z/FXjXEUZKHdpbQy6Yv8DscbOYE8c79ukVO
	x2l8svqUtIbtoJl8a/OOtQeLYs3waU550Eg0kmvB2Q/SuIR2dLF5MJB+delPQ7GD
	Fj7e1/mJqjt8EnkL3Ws8Scpt+vp3EKddX/WwAuOgkdKIpv4fXlzXWzmnFgulKVSd
	LN2ScUAKcFEE8bqh45gHmeyfq0ycA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx59dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 14:33:27 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BEVlEC026422;
	Thu, 11 Sep 2025 14:33:27 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx59dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 14:33:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDPZtH010671;
	Thu, 11 Sep 2025 14:33:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn66mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 14:33:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BEXMfn49217992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 14:33:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 204C920040;
	Thu, 11 Sep 2025 14:33:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4EE72004B;
	Thu, 11 Sep 2025 14:33:19 +0000 (GMT)
Received: from mac.in.ibm.com (unknown [9.109.215.107])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 14:33:19 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: harshpb@linux.ibm.com, nicholas@linux.ibm.com, npiggin@gmail.com,
        rathc@linux.ibm.com, pbonzini@redhat.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH v3] hw/ppc/spapr_hcall: Return host mitigation characteristics in KVM mode
Date: Thu, 11 Sep 2025 20:02:42 +0530
Message-Id: <20250911143242.50274-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JaWqkUSOyZhFewTa0aXDHvbe7ly5M428
X-Proofpoint-ORIG-GUID: gOEMF88e9tCDW77VKpfetdWoLEg5CM7y
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c2ddb7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8 a=-q3l6OvWyFqWqzZG4aIA:9
 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX/crDOqp4cG8w
 IUDXKvI9JC7SH2czRyco1Ps4GKQ9j869ILHu0hyMf3xedfNkeXuABJ00bsZMCNk4yoFIwxTYl8J
 QMDtlP/tcQTOd0yixproRLtzRMTJpJ0sqczVx0PDDXmmqm0ZPc6uMwswTg47l6Gvw3brXqMK0M/
 omefF+H1f/r3+QAJVYd5UK2Q2tc4TE4+a4IwfzIwgkefnGw9JbCCybRy2Xc9dx8w7TIin/U4KBw
 Fk6e9kc9Qc/gohL3ImphhYUNpsLDoUqwTTgo6n7QplVXHnxjU+XGFV6SCAscq9IuDM4yXf/cxSi
 TQrE5ZuFdJkNqMEMiCcze3vZQyvr4sl0gSO3GraiCc7ZA7JVQdBCTCNYA9PckmyGLi92XTjD5yB
 8n13orAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

Currently, on a P10 KVM guest, the mitigations seen in the output of
"lscpu" command are different from the host. The reason for this
behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
hcall, QEMU does not consider the data it received from the host via the
KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
spapr->eff.caps[], which in turn just contain the default values set in
spapr_machine_class_init().

Fix this behaviour by making sure that h_get_cpu_characteristics()
returns the data received from the KVM ioctl for a KVM guest.

Mitigation status seen in lscpu output:
1. P10 LPAR (host)
$ lscpu | grep -i mitigation
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

2. KVM guest on P10 LPAR with upstream QEMU
$ lscpu | grep -i mitig
Vulnerability L1tf:                   Mitigation; RFI Flush, L1D private per thread
Vulnerability Meltdown:               Mitigation; RFI Flush, L1D private per thread
Vulnerability Spec store bypass:      Mitigation; Kernel entry/exit barrier (eieio)
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

3. KVM guest on P10 LPAR (this patch applied)
$ lscpu | grep -i mitigation
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

Perf impact:
With null syscall benchmark[1], ~45% improvement is observed.

1. Vanilla QEMU
$ ./null_syscall
132.19 ns     456.54 cycles

2. With this patch
$ ./null_syscall
91.18 ns     314.57 cycles

[1]: https://ozlabs.org/~anton/junkcode/null_syscall.c

Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v1 -> v2:
Handle the case where KVM_PPC_GET_CPU_CHAR ioctl fails

v2 -> v3:
Add the lscpu output in the patch description

 hw/ppc/spapr_hcall.c   |  6 ++++++
 include/hw/ppc/spapr.h |  1 +
 target/ppc/kvm.c       | 13 ++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 1e936f35e4..d617245849 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1415,6 +1415,12 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
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
index 015658049e..70e84408a3 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2515,7 +2515,8 @@ bool kvmppc_has_cap_xive(void)
 
 static void kvmppc_get_cpu_characteristics(KVMState *s)
 {
-    struct kvm_ppc_cpu_char c;
+    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
+    struct kvm_ppc_cpu_char c = {0};
     int ret;
 
     /* Assume broken */
@@ -2525,18 +2526,24 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
 
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
2.39.5 (Apple Git-154)


