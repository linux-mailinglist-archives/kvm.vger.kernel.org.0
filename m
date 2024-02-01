Return-Path: <kvm+bounces-7718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C57845A90
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87C901C27FF5
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5E25F490;
	Thu,  1 Feb 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PU5zC4f4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414C5F493
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706798909; cv=none; b=jyA9XnaapK4ebeXIF/Yu6tXmox3yLRjFbsONwMIUh6M/mhAcc1q3a1L/BtJU+NCgMjslXHuu5IK4GItzSrWq49q6xA8BtW7kfCLJXLAjPky50HKZwNTv31ibvMT7GdV0+Qs3HbpSkNV7dlixXx9YnbEmwB8B15YlJOPQ+QpxYC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706798909; c=relaxed/simple;
	bh=QqmkW+1hOphJSQmDav+gxbBxJLUFdzFW9I6X0MteRF4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5NdhQeSwmVI6hNknk/vBWxMc+pl6koet5oDkLLePviqqFNJVc/fCWeKxfwjB83fMEYWh6MqyjLGi+CIhyKJXFh0EckxzKE0mctCDf6pFAu8Jt/wrAyKMkMP2rnAAP4RC2dNNMg5z3pM/gbDtDKG+mXaQMzpARXwVsyonCEE5ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PU5zC4f4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411EYK0P023680;
	Thu, 1 Feb 2024 14:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Leqba0Wk9P5GGbwUCd+rQ2YN2BcrPM5njL6io32kLFk=;
 b=PU5zC4f4SdWVXm4eiQroy9P0TtgpeDN8nux3FE9x6PFVatmxyOv7gmg8PdpFTi6rjBm5
 EOJZFOuENoBrI0gpmEWtFGqIv//74YCWRxeUIAdqK6OVo64V4OuXe9n+hEn/ad7X2ZqT
 0TPg8YclTIGndxXnnpXY0dBUOulqJoaQzrt6Lyfl/kcObawLq11jSgQfBlgzluCOnMKa
 2ucMv5g4CbbYKtUPTJn0bjWQK4g2NrodLQDuQkJHbGng/z7lUqjcHDPqF8cuH31Mv/Hj
 ik9X2gPLcw6aJHVoxINUV7xLfDo3mbnBNDAtohlU8EOtQBLXCS92r0S21o7EGV6BW2iq hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0bfbkrxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:48:11 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411DswXp004403;
	Thu, 1 Feb 2024 14:48:11 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0bfbkrv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:48:10 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411Do4oW008359;
	Thu, 1 Feb 2024 14:46:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwdnmckc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:46:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411EkcRC10093224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:46:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E56A2004B;
	Thu,  1 Feb 2024 14:46:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B6AC20040;
	Thu,  1 Feb 2024 14:46:36 +0000 (GMT)
Received: from ltc-boston1.aus.stglabs.ibm.com (unknown [9.40.193.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 14:46:36 +0000 (GMT)
Subject: [PATCH v8 2/2] ppc: spapr: Enable 2nd DAWR on Power10 pSeries machine
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: danielhb413@gmail.com, qemu-ppc@nongnu.org, david@gibson.dropbear.id.au,
        harshpb@linux.ibm.com, clg@kaod.org, npiggin@gmail.com, groug@kaod.org
Cc: sbhat@linux.ibm.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Date: Thu, 01 Feb 2024 09:46:35 -0500
Message-ID: 
 <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>
In-Reply-To: 
 <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
References: 
 <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 62Qv25RKOvaahl6JNHYKjHIx940YlQgA
X-Proofpoint-ORIG-GUID: 465ySTv3rh7mTY3YOTBDU8FesB_CH-MN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=416 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010117

As per the PAPR, bit 0 of byte 64 in pa-features property
indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
whether kvm supports 2nd DAWR or not. If it's supported, allow user to set
the pa-feature bit in guest DT using cap-dawr1 machine capability.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr.c         |    7 ++++++-
 hw/ppc/spapr_caps.c    |   36 ++++++++++++++++++++++++++++++++++++
 hw/ppc/spapr_hcall.c   |   25 ++++++++++++++++---------
 include/hw/ppc/spapr.h |    6 +++++-
 target/ppc/kvm.c       |   12 ++++++++++++
 target/ppc/kvm_ppc.h   |   12 ++++++++++++
 6 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index e8dabc8614..91a97d72e7 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -262,7 +262,7 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
         /* 54: DecFP, 56: DecI, 58: SHA */
         0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
-        /* 60: NM atomic, 62: RNG */
+        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
         0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
     };
     uint8_t *pa_features = NULL;
@@ -303,6 +303,9 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
          * in pa-features. So hide it from them. */
         pa_features[40 + 2] &= ~0x80; /* Radix MMU */
     }
+    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
+        pa_features[66] |= 0x80;
+    }
 
     _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
 }
@@ -2138,6 +2141,7 @@ static const VMStateDescription vmstate_spapr = {
         &vmstate_spapr_cap_fwnmi,
         &vmstate_spapr_fwnmi,
         &vmstate_spapr_cap_rpt_invalidate,
+        &vmstate_spapr_cap_dawr1,
         NULL
     }
 };
@@ -4717,6 +4721,7 @@ static void spapr_machine_class_init(ObjectClass *oc, void *data)
     smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_ON;
     smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_ON;
     smc->default_caps.caps[SPAPR_CAP_RPT_INVALIDATE] = SPAPR_CAP_OFF;
+    smc->default_caps.caps[SPAPR_CAP_DAWR1] = SPAPR_CAP_OFF;
 
     /*
      * This cap specifies whether the AIL 3 mode for
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index e889244e52..677f17cea6 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -655,6 +655,32 @@ static void cap_ail_mode_3_apply(SpaprMachineState *spapr,
     }
 }
 
+static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
+                               Error **errp)
+{
+    ERRP_GUARD();
+
+    if (!val) {
+        return; /* Disable by default */
+    }
+
+    if (!ppc_type_check_compat(MACHINE(spapr)->cpu_type,
+                               CPU_POWERPC_LOGICAL_3_10, 0,
+                               spapr->max_compat_pvr)) {
+        warn_report("DAWR1 supported only on POWER10 and later CPUs");
+    }
+
+    if (kvm_enabled()) {
+        if (!kvmppc_has_cap_dawr1()) {
+            error_setg(errp, "DAWR1 not supported by KVM.");
+            error_append_hint(errp, "Try appending -machine cap-dawr1=off");
+        } else if (kvmppc_set_cap_dawr1(val) < 0) {
+            error_setg(errp, "Error enabling cap-dawr1 with KVM.");
+            error_append_hint(errp, "Try appending -machine cap-dawr1=off");
+        }
+    }
+}
+
 SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
     [SPAPR_CAP_HTM] = {
         .name = "htm",
@@ -781,6 +807,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
         .type = "bool",
         .apply = cap_ail_mode_3_apply,
     },
+    [SPAPR_CAP_DAWR1] = {
+        .name = "dawr1",
+        .description = "Allow 2nd Data Address Watchpoint Register (DAWR1)",
+        .index = SPAPR_CAP_DAWR1,
+        .get = spapr_cap_get_bool,
+        .set = spapr_cap_set_bool,
+        .type = "bool",
+        .apply = cap_dawr1_apply,
+    },
 };
 
 static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
@@ -923,6 +958,7 @@ SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
 SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
 SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
 SPAPR_CAP_MIG_STATE(rpt_invalidate, SPAPR_CAP_RPT_INVALIDATE);
+SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
 
 void spapr_caps_init(SpaprMachineState *spapr)
 {
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index fcefd1d1c7..34c1c77c95 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -814,11 +814,12 @@ static target_ulong h_set_mode_resource_set_ciabr(PowerPCCPU *cpu,
     return H_SUCCESS;
 }
 
-static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
-                                                  SpaprMachineState *spapr,
-                                                  target_ulong mflags,
-                                                  target_ulong value1,
-                                                  target_ulong value2)
+static target_ulong h_set_mode_resource_set_dawr(PowerPCCPU *cpu,
+                                                     SpaprMachineState *spapr,
+                                                     target_ulong mflags,
+                                                     target_ulong resource,
+                                                     target_ulong value1,
+                                                     target_ulong value2)
 {
     CPUPPCState *env = &cpu->env;
 
@@ -831,8 +832,13 @@ static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
         return H_P4;
     }
 
-    ppc_store_dawr0(env, value1);
-    ppc_store_dawrx0(env, value2);
+    if (resource == H_SET_MODE_RESOURCE_SET_DAWR0) {
+        ppc_store_dawr0(env, value1);
+        ppc_store_dawrx0(env, value2);
+    } else {
+        ppc_store_dawr1(env, value1);
+        ppc_store_dawrx1(env, value2);
+    }
 
     return H_SUCCESS;
 }
@@ -911,8 +917,9 @@ static target_ulong h_set_mode(PowerPCCPU *cpu, SpaprMachineState *spapr,
                                             args[3]);
         break;
     case H_SET_MODE_RESOURCE_SET_DAWR0:
-        ret = h_set_mode_resource_set_dawr0(cpu, spapr, args[0], args[2],
-                                            args[3]);
+    case H_SET_MODE_RESOURCE_SET_DAWR1:
+        ret = h_set_mode_resource_set_dawr(cpu, spapr, args[0], args[1],
+                                           args[2], args[3]);
         break;
     case H_SET_MODE_RESOURCE_LE:
         ret = h_set_mode_resource_le(cpu, spapr, args[0], args[2], args[3]);
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index e91791a1a9..2b13c9a00e 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -80,8 +80,10 @@ typedef enum {
 #define SPAPR_CAP_RPT_INVALIDATE        0x0B
 /* Support for AIL modes */
 #define SPAPR_CAP_AIL_MODE_3            0x0C
+/* DAWR1 */
+#define SPAPR_CAP_DAWR1                 0x0D
 /* Num Caps */
-#define SPAPR_CAP_NUM                   (SPAPR_CAP_AIL_MODE_3 + 1)
+#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
 
 /*
  * Capability Values
@@ -403,6 +405,7 @@ struct SpaprMachineState {
 #define H_SET_MODE_RESOURCE_SET_DAWR0           2
 #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
 #define H_SET_MODE_RESOURCE_LE                  4
+#define H_SET_MODE_RESOURCE_SET_DAWR1           5
 
 /* Flags for H_SET_MODE_RESOURCE_LE */
 #define H_SET_MODE_ENDIAN_BIG    0
@@ -986,6 +989,7 @@ extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
 extern const VMStateDescription vmstate_spapr_cap_fwnmi;
 extern const VMStateDescription vmstate_spapr_cap_rpt_invalidate;
 extern const VMStateDescription vmstate_spapr_wdt;
+extern const VMStateDescription vmstate_spapr_cap_dawr1;
 
 static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
 {
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 26fa9d0575..3d8a8f35b6 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -89,6 +89,7 @@ static int cap_large_decr;
 static int cap_fwnmi;
 static int cap_rpt_invalidate;
 static int cap_ail_mode_3;
+static int cap_dawr1;
 
 static uint32_t debug_inst_opcode;
 
@@ -143,6 +144,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
     cap_large_decr = kvmppc_get_dec_bits();
     cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
+    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
     /*
      * Note: setting it to false because there is not such capability
      * in KVM at this moment.
@@ -2109,6 +2111,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
     return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
 }
 
+bool kvmppc_has_cap_dawr1(void)
+{
+    return !!cap_dawr1;
+}
+
+int kvmppc_set_cap_dawr1(int enable)
+{
+    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
+}
+
 int kvmppc_smt_threads(void)
 {
     return cap_ppc_smt ? cap_ppc_smt : 1;
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 1975fb5ee6..493d6bb477 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -68,6 +68,8 @@ bool kvmppc_has_cap_htm(void);
 bool kvmppc_has_cap_mmu_radix(void);
 bool kvmppc_has_cap_mmu_hash_v3(void);
 bool kvmppc_has_cap_xive(void);
+bool kvmppc_has_cap_dawr1(void);
+int kvmppc_set_cap_dawr1(int enable);
 int kvmppc_get_cap_safe_cache(void);
 int kvmppc_get_cap_safe_bounds_check(void);
 int kvmppc_get_cap_safe_indirect_branch(void);
@@ -377,6 +379,16 @@ static inline bool kvmppc_has_cap_xive(void)
     return false;
 }
 
+static inline bool kvmppc_has_cap_dawr1(void)
+{
+    return false;
+}
+
+static inline int kvmppc_set_cap_dawr1(int enable)
+{
+    abort();
+}
+
 static inline int kvmppc_get_cap_safe_cache(void)
 {
     return 0;



