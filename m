Return-Path: <kvm+bounces-2253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD20D7F3EE5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F358AB20EA5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 07:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0F01F611;
	Wed, 22 Nov 2023 07:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="emq+3Edw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14696F4
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 23:33:20 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM7Fsd8028973;
	Wed, 22 Nov 2023 07:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=j7rZ6L1xOjVepaCQDzk+cZzIQAYd/LGMxlEZyrmaybQ=;
 b=emq+3EdwYad2RjVOcAGgnmTsN27D4/rW5bYR5v7EWxjergAPh/W/FkGK9z2IEH3KxQHF
 70KxheGkt00lxfNbWDyf3ZA4P9R5B2zgRFdkX2S/sNHdIIQp7UrHdmtP8cALfWUGu7Xa
 0mhVQ8XkywqZr3QxQ1CAcJSsIHCkjoTekDMO6bckEUo/otsiK05mKBp3gdGl68Nx/j2g
 AUw3TJJsZ3TYliVFC96EIF1K5B6obxNaZymbyfnY5jIB+smbOhuw9x5MFTY8kkehkFsr
 Twsj/WsjcHp6jWTSnPxHpUDidzGpGp1NwUD8QEGeED3etap1o9ts9i+ne7OOdGZDVhHo 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uhcyj8pn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 07:32:59 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AM7GemR032691;
	Wed, 22 Nov 2023 07:32:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uhcyj8pmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 07:32:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM7G07f029376;
	Wed, 22 Nov 2023 07:32:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uf7yypgp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 07:32:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AM7Wspr7537368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Nov 2023 07:32:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BBB52004B;
	Wed, 22 Nov 2023 07:32:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94F8A20043;
	Wed, 22 Nov 2023 07:32:52 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglab.ibm.com (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Nov 2023 07:32:52 +0000 (GMT)
Subject: [RFC PATCH v7] ppc: Enable 2nd DAWR support on p10
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: npiggin@gmail.com, danielhb413@gmail.com, clg@kaod.org,
        david@gibson.dropbear.id.au, harshpb@linux.ibm.com,
        pbonzini@redhat.com, qemu-ppc@nongnu.org, kvm@vger.kernel.org
Cc: qemu-devel@nongnu.org, sbhat@linux.ibm.com
Date: Wed, 22 Nov 2023 01:32:51 -0600
Message-ID: 
 <170063834599.621665.9541440879278084501.stgit@ltcd48-lp2.aus.stglab.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FYe__x39s5pt-Cpj4_ELHnLwFuQQi-DW
X-Proofpoint-ORIG-GUID: K060L0gYYONWpMYHmv41iJ36zLIfH-wB
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_05,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220053

Extend the existing watchpoint facility from TCG DAWR0 emulation
to DAWR1 on POWER10.

As per the PAPR, bit 0 of byte 64 in pa-features property
indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
whether kvm supports 2nd DAWR or not. If it's supported, allow user to set
the pa-feature bit in guest DT using cap-dawr1 machine capability.

Signed-off-by: Ravi Bangoria <ravi.bangoria at linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat at linux.ibm.com>
---
Changelog:
v6: https://lore.kernel.org/qemu-devel/168871963321.58984.15628382614621248470.stgit@ltcd89-lp2/
v6->v7:
  - Sorry about the delay in sending out this version, I have dropped the
    Reviewed-bys as suggested and converted the patch to RFC back again.
  - Added the TCG support. Basically, converted the existing DAWR0 support
    routines into macros for reuse by the DAWR1. Let me know if the macro
    conversions should be moved to a separate independent patch.
  - As the dawr1 works on TCG, the checks in cap_dawr1_apply() report a warning
    now only for P9 or P9 compat modes for both KVM and TCG use cases.
  - 'make test' passes for caps checks. Also, as suggested by Greg Kurz, the
    'make test' after making the DAWR1 default 'on' and updating defaut cpu
    to Power10, shows no failures.

v5: https://lore.kernel.org/all/20210412114433.129702-1-ravi.bangoria@linux.ibm.com/
v5->v6:
  - The other patches in the original series already merged.
  - Rebased to the top of the tree. So, the gen_spr_book3s_310_dbg() is renamed
    to register_book3s_310_dbg_sprs() and moved to cpu_init.c accordingly.
  - No functional changes.

v4: https://lore.kernel.org/r/20210406053833.282907-1-ravi.bangoria@linux.ibm.com
v3->v4:
  - Make error message more proper.

v3: https://lore.kernel.org/r/20210330095350.36309-1-ravi.bangoria@linux.ibm.com
v3->v4:
  - spapr_dt_pa_features(): POWER10 processor is compatible with 3.0
    (PCR_COMPAT_3_00). No need to ppc_check_compat(3_10) for now as
    ppc_check_compati(3_00) will also be true. ppc_check_compat(3_10)
    can be added while introducing pa_features_310 in future.
  - Use error_append_hint() for hints. Also add ERRP_GUARD().
  - Add kvmppc_set_cap_dawr1() stub function for CONFIG_KVM=n.

v2: https://lore.kernel.org/r/20210329041906.213991-1-ravi.bangoria@linux.ibm.com
v2->v3:
  - Don't introduce pa_features_310[], instead, reuse pa_features_300[]
    for 3.1 guests, as there is no difference between initial values of
    them atm.
  - Call gen_spr_book3s_310_dbg() from init_proc_POWER10() instead of
    init_proc_POWER8(). Also, Don't call gen_spr_book3s_207_dbg() from
    gen_spr_book3s_310_dbg() as init_proc_POWER10() already calls it.

v1: https://lore.kernel.org/r/20200723104220.314671-1-ravi.bangoria@linux.ibm.com
v1->v2:
  - Introduce machine capability cap-dawr1 to enable/disable
    the feature. By default, 2nd DAWR is OFF for guests even
    when host kvm supports it. User has to manually enable it
    with -machine cap-dawr1=on if he wishes to use it.
  - Split the header file changes into separate patch. (Sync
    headers from v5.12-rc3)

 hw/ppc/spapr.c           |    7 ++-
 hw/ppc/spapr_caps.c      |   35 ++++++++++++++
 hw/ppc/spapr_hcall.c     |   50 ++++++++++++--------
 include/hw/ppc/spapr.h   |    6 ++
 target/ppc/cpu.c         |  114 +++++++++++++++++++++++++---------------------
 target/ppc/cpu.h         |    6 ++
 target/ppc/cpu_init.c    |   15 ++++++
 target/ppc/excp_helper.c |   61 ++++++++++++++-----------
 target/ppc/helper.h      |    2 +
 target/ppc/kvm.c         |   12 +++++
 target/ppc/kvm_ppc.h     |   12 +++++
 target/ppc/machine.c     |    1
 target/ppc/misc_helper.c |   20 ++++++--
 target/ppc/spr_common.h  |    2 +
 target/ppc/translate.c   |   25 +++++++---
 15 files changed, 253 insertions(+), 115 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index df09aa9d6a..c1cb47464b 100644
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
index 5a0755d34f..e265b56711 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -655,6 +655,31 @@ static void cap_ail_mode_3_apply(SpaprMachineState *spapr,
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
+    if (!ppc_type_check_compat(MACHINE(spapr)->cpu_type, CPU_POWERPC_LOGICAL_3_10,
+                               0, spapr->max_compat_pvr)) {
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
@@ -781,6 +806,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
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
@@ -923,6 +957,7 @@ SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
 SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
 SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
 SPAPR_CAP_MIG_STATE(rpt_invalidate, SPAPR_CAP_RPT_INVALIDATE);
+SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);

 void spapr_caps_init(SpaprMachineState *spapr)
 {
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 522a2396c7..50bb305917 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -815,29 +815,33 @@ static target_ulong h_set_mode_resource_set_ciabr(PowerPCCPU *cpu,
     return H_SUCCESS;
 }

-static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
-                                                  SpaprMachineState *spapr,
-                                                  target_ulong mflags,
-                                                  target_ulong value1,
-                                                  target_ulong value2)
-{
-    CPUPPCState *env = &cpu->env;
-
-    assert(tcg_enabled()); /* KVM will have handled this */
-
-    if (mflags) {
-        return H_UNSUPPORTED_FLAG;
-    }
-    if (value2 & PPC_BIT(61)) {
-        return H_P4;
-    }
-
-    ppc_store_dawr0(env, value1);
-    ppc_store_dawrx0(env, value2);
-
-    return H_SUCCESS;
+#define DEF_H_SET_MODE_RESOURCE_SET_DAWR(id)                                  \
+static target_ulong h_set_mode_resource_set_dawr##id(PowerPCCPU *cpu,         \
+                                                     SpaprMachineState *spapr,\
+                                                     target_ulong mflags,     \
+                                                     target_ulong value1,     \
+                                                     target_ulong value2)     \
+{                                                                             \
+    CPUPPCState *env = &cpu->env;                                             \
+                                                                              \
+    assert(tcg_enabled()); /* KVM will have handled this */                   \
+                                                                              \
+    if (mflags) {                                                             \
+        return H_UNSUPPORTED_FLAG;                                            \
+    }                                                                         \
+    if (value2 & PPC_BIT(61)) {                                               \
+        return H_P4;                                                          \
+    }                                                                         \
+                                                                              \
+    ppc_store_dawr##id(env, value1);                                          \
+    ppc_store_dawrx##id(env, value2);                                         \
+                                                                              \
+    return H_SUCCESS;                                                         \
 }

+DEF_H_SET_MODE_RESOURCE_SET_DAWR(0)
+DEF_H_SET_MODE_RESOURCE_SET_DAWR(1)
+
 static target_ulong h_set_mode_resource_le(PowerPCCPU *cpu,
                                            SpaprMachineState *spapr,
                                            target_ulong mflags,
@@ -915,6 +919,10 @@ static target_ulong h_set_mode(PowerPCCPU *cpu, SpaprMachineState *spapr,
         ret = h_set_mode_resource_set_dawr0(cpu, spapr, args[0], args[2],
                                             args[3]);
         break;
+    case H_SET_MODE_RESOURCE_SET_DAWR1:
+        ret = h_set_mode_resource_set_dawr1(cpu, spapr, args[0], args[2],
+                                            args[3]);
+        break;
     case H_SET_MODE_RESOURCE_LE:
         ret = h_set_mode_resource_le(cpu, spapr, args[0], args[2], args[3]);
         break;
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
diff --git a/target/ppc/cpu.c b/target/ppc/cpu.c
index e3ad8e0c27..3e2fe93074 100644
--- a/target/ppc/cpu.c
+++ b/target/ppc/cpu.c
@@ -130,64 +130,76 @@ void ppc_store_ciabr(CPUPPCState *env, target_ulong val)
     ppc_update_ciabr(env);
 }

-void ppc_update_daw0(CPUPPCState *env)
-{
-    CPUState *cs = env_cpu(env);
-    target_ulong deaw = env->spr[SPR_DAWR0] & PPC_BITMASK(0, 60);
-    uint32_t dawrx = env->spr[SPR_DAWRX0];
-    int mrd = extract32(dawrx, PPC_BIT_NR(48), 54 - 48);
-    bool dw = extract32(dawrx, PPC_BIT_NR(57), 1);
-    bool dr = extract32(dawrx, PPC_BIT_NR(58), 1);
-    bool hv = extract32(dawrx, PPC_BIT_NR(61), 1);
-    bool sv = extract32(dawrx, PPC_BIT_NR(62), 1);
-    bool pr = extract32(dawrx, PPC_BIT_NR(62), 1);
-    vaddr len;
-    int flags;
-
-    if (env->dawr0_watchpoint) {
-        cpu_watchpoint_remove_by_ref(cs, env->dawr0_watchpoint);
-        env->dawr0_watchpoint = NULL;
-    }
-
-    if (!dr && !dw) {
-        return;
-    }
-
-    if (!hv && !sv && !pr) {
-        return;
-    }
-
-    len = (mrd + 1) * 8;
-    flags = BP_CPU | BP_STOP_BEFORE_ACCESS;
-    if (dr) {
-        flags |= BP_MEM_READ;
-    }
-    if (dw) {
-        flags |= BP_MEM_WRITE;
-    }
+#define DEF_PPC_UPDATE_DAW(id)                                                \
+void ppc_update_daw##id(CPUPPCState *env)                                     \
+{                                                                             \
+    CPUState *cs = env_cpu(env);                                              \
+    target_ulong deaw = env->spr[SPR_DAWR##id] & PPC_BITMASK(0, 60);          \
+    uint32_t dawrx = env->spr[SPR_DAWRX##id];                                 \
+    int mrd = extract32(dawrx, PPC_BIT_NR(48), 54 - 48);                      \
+    bool dw = extract32(dawrx, PPC_BIT_NR(57), 1);                            \
+    bool dr = extract32(dawrx, PPC_BIT_NR(58), 1);                            \
+    bool hv = extract32(dawrx, PPC_BIT_NR(61), 1);                            \
+    bool sv = extract32(dawrx, PPC_BIT_NR(62), 1);                            \
+    bool pr = extract32(dawrx, PPC_BIT_NR(62), 1);                            \
+    vaddr len;                                                                \
+    int flags;                                                                \
+                                                                              \
+    if (env->dawr##id##_watchpoint) {                                         \
+        cpu_watchpoint_remove_by_ref(cs, env->dawr##id##_watchpoint);         \
+        env->dawr##id##_watchpoint = NULL;                                    \
+    }                                                                         \
+                                                                              \
+    if (!dr && !dw) {                                                         \
+        return;                                                               \
+    }                                                                         \
+                                                                              \
+    if (!hv && !sv && !pr) {                                                  \
+        return;                                                               \
+    }                                                                         \
+                                                                              \
+    len = (mrd + 1) * 8;                                                      \
+    flags = BP_CPU | BP_STOP_BEFORE_ACCESS;                                   \
+    if (dr) {                                                                 \
+        flags |= BP_MEM_READ;                                                 \
+    }                                                                         \
+    if (dw) {                                                                 \
+        flags |= BP_MEM_WRITE;                                                \
+    }                                                                         \
+                                                                              \
+    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr##id##_watchpoint); \
+}

-    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr0_watchpoint);
+#define DEF_PPC_STORE_DAWR(id)                                                \
+void ppc_store_dawr##id(CPUPPCState *env, target_ulong val)                   \
+{                                                                             \
+    env->spr[SPR_DAWR##id] = val;                                             \
+    ppc_update_daw##id(env);                                                  \
 }

-void ppc_store_dawr0(CPUPPCState *env, target_ulong val)
-{
-    env->spr[SPR_DAWR0] = val;
-    ppc_update_daw0(env);
+#define DEF_PPC_STORE_DAWRX(id)                                               \
+void ppc_store_dawrx##id(CPUPPCState *env, uint32_t val)                      \
+{                                                                             \
+    int hrammc = extract32(val, PPC_BIT_NR(56), 1);                           \
+                                                                              \
+    if (hrammc) {                                                             \
+        /* This might be done with a 2nd watchpoint at the xor of DEAW[0] */  \
+        qemu_log_mask(LOG_UNIMP, "%s: DAWRX##id[HRAMMC] is unimplemented\n",  \
+                      __func__);                                              \
+    }                                                                         \
+                                                                              \
+    env->spr[SPR_DAWRX##id] = val;                                            \
+    ppc_update_daw##id(env);                                                  \
 }

-void ppc_store_dawrx0(CPUPPCState *env, uint32_t val)
-{
-    int hrammc = extract32(val, PPC_BIT_NR(56), 1);
+DEF_PPC_UPDATE_DAW(0)
+DEF_PPC_STORE_DAWR(0)
+DEF_PPC_STORE_DAWRX(0)

-    if (hrammc) {
-        /* This might be done with a second watchpoint at the xor of DEAW[0] */
-        qemu_log_mask(LOG_UNIMP, "%s: DAWRX0[HRAMMC] is unimplemented\n",
-                      __func__);
-    }
+DEF_PPC_UPDATE_DAW(1)
+DEF_PPC_STORE_DAWR(1)
+DEF_PPC_STORE_DAWRX(1)

-    env->spr[SPR_DAWRX0] = val;
-    ppc_update_daw0(env);
-}
 #endif
 #endif

diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index f8101ffa29..ab34fc7b72 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1237,6 +1237,7 @@ struct CPUArchState {
     ppc_slb_t slb[MAX_SLB_ENTRIES]; /* PowerPC 64 SLB area */
     struct CPUBreakpoint *ciabr_breakpoint;
     struct CPUWatchpoint *dawr0_watchpoint;
+    struct CPUWatchpoint *dawr1_watchpoint;
 #endif
     target_ulong sr[32];   /* segment registers */
     uint32_t nb_BATs;      /* number of BATs */
@@ -1552,6 +1553,9 @@ void ppc_store_ciabr(CPUPPCState *env, target_ulong value);
 void ppc_update_daw0(CPUPPCState *env);
 void ppc_store_dawr0(CPUPPCState *env, target_ulong value);
 void ppc_store_dawrx0(CPUPPCState *env, uint32_t value);
+void ppc_update_daw1(CPUPPCState *env);
+void ppc_store_dawr1(CPUPPCState *env, target_ulong value);
+void ppc_store_dawrx1(CPUPPCState *env, uint32_t value);
 #endif /* !defined(CONFIG_USER_ONLY) */
 void ppc_store_msr(CPUPPCState *env, target_ulong value);

@@ -1737,9 +1741,11 @@ void ppc_compat_add_property(Object *obj, const char *name,
 #define SPR_PSPB              (0x09F)
 #define SPR_DPDES             (0x0B0)
 #define SPR_DAWR0             (0x0B4)
+#define SPR_DAWR1             (0x0B5)
 #define SPR_RPR               (0x0BA)
 #define SPR_CIABR             (0x0BB)
 #define SPR_DAWRX0            (0x0BC)
+#define SPR_DAWRX1            (0x0BD)
 #define SPR_HFSCR             (0x0BE)
 #define SPR_VRSAVE            (0x100)
 #define SPR_USPRG0            (0x100)
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 40fe14a6c2..27a73bc7be 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -5131,6 +5131,20 @@ static void register_book3s_207_dbg_sprs(CPUPPCState *env)
                         KVM_REG_PPC_CIABR, 0x00000000);
 }

+static void register_book3s_310_dbg_sprs(CPUPPCState *env)
+{
+    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_dawr1,
+                        KVM_REG_PPC_DAWR1, 0x00000000);
+    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_dawrx1,
+                        KVM_REG_PPC_DAWRX1, 0x00000000);
+}
+
 static void register_970_dbg_sprs(CPUPPCState *env)
 {
     /* Breakpoints */
@@ -6473,6 +6487,7 @@ static void init_proc_POWER10(CPUPPCState *env)
     /* Common Registers */
     init_proc_book3s_common(env);
     register_book3s_207_dbg_sprs(env);
+    register_book3s_310_dbg_sprs(env);

     /* Common TCG PMU */
     init_tcg_pmu_power8(env);
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index a42743a3e0..484abb672d 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -3314,39 +3314,46 @@ bool ppc_cpu_debug_check_watchpoint(CPUState *cs, CPUWatchpoint *wp)
 {
 #if defined(TARGET_PPC64)
     CPUPPCState *env = cpu_env(cs);
+    bool wt, wti, hv, sv, pr;
+    uint32_t dawrx;
+
+    if ((env->insns_flags2 & PPC2_ISA207S) &&
+        (wp == env->dawr0_watchpoint)) {
+        dawrx = env->spr[SPR_DAWRX0];
+    } else if ((env->insns_flags2 & PPC2_ISA310) &&
+               (wp == env->dawr1_watchpoint)) {
+        dawrx = env->spr[SPR_DAWRX1];
+    } else {
+        return false;
+    }

-    if (env->insns_flags2 & PPC2_ISA207S) {
-        if (wp == env->dawr0_watchpoint) {
-            uint32_t dawrx = env->spr[SPR_DAWRX0];
-            bool wt = extract32(dawrx, PPC_BIT_NR(59), 1);
-            bool wti = extract32(dawrx, PPC_BIT_NR(60), 1);
-            bool hv = extract32(dawrx, PPC_BIT_NR(61), 1);
-            bool sv = extract32(dawrx, PPC_BIT_NR(62), 1);
-            bool pr = extract32(dawrx, PPC_BIT_NR(62), 1);
-
-            if ((env->msr & ((target_ulong)1 << MSR_PR)) && !pr) {
-                return false;
-            } else if ((env->msr & ((target_ulong)1 << MSR_HV)) && !hv) {
-                return false;
-            } else if (!sv) {
+    wt = extract32(dawrx, PPC_BIT_NR(59), 1);
+    wti = extract32(dawrx, PPC_BIT_NR(60), 1);
+    hv = extract32(dawrx, PPC_BIT_NR(61), 1);
+    sv = extract32(dawrx, PPC_BIT_NR(62), 1);
+    pr = extract32(dawrx, PPC_BIT_NR(62), 1);
+
+    if ((env->msr & ((target_ulong)1 << MSR_PR)) && !pr) {
+        return false;
+    } else if ((env->msr & ((target_ulong)1 << MSR_HV)) && !hv) {
+        return false;
+    } else if (!sv) {
+        return false;
+    }
+
+    if (!wti) {
+        if (env->msr & ((target_ulong)1 << MSR_DR)) {
+            if (!wt) {
                 return false;
             }
-
-            if (!wti) {
-                if (env->msr & ((target_ulong)1 << MSR_DR)) {
-                    if (!wt) {
-                        return false;
-                    }
-                } else {
-                    if (wt) {
-                        return false;
-                    }
-                }
+        } else {
+            if (wt) {
+                return false;
             }
-
-            return true;
         }
     }
+
+    return true;
 #endif

     return false;
diff --git a/target/ppc/helper.h b/target/ppc/helper.h
index 86f97ee1e7..0c008bb725 100644
--- a/target/ppc/helper.h
+++ b/target/ppc/helper.h
@@ -28,6 +28,8 @@ DEF_HELPER_2(store_pcr, void, env, tl)
 DEF_HELPER_2(store_ciabr, void, env, tl)
 DEF_HELPER_2(store_dawr0, void, env, tl)
 DEF_HELPER_2(store_dawrx0, void, env, tl)
+DEF_HELPER_2(store_dawr1, void, env, tl)
+DEF_HELPER_2(store_dawrx1, void, env, tl)
 DEF_HELPER_2(store_mmcr0, void, env, tl)
 DEF_HELPER_2(store_mmcr1, void, env, tl)
 DEF_HELPER_3(store_pmc, void, env, i32, i64)
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 9b1abe2fc4..09a8115380 100644
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
diff --git a/target/ppc/machine.c b/target/ppc/machine.c
index 68cbdffecd..eef596dbdc 100644
--- a/target/ppc/machine.c
+++ b/target/ppc/machine.c
@@ -326,6 +326,7 @@ static int cpu_post_load(void *opaque, int version_id)
 #if defined(TARGET_PPC64)
         ppc_update_ciabr(env);
         ppc_update_daw0(env);
+        ppc_update_daw1(env);
 #endif
         /*
          * TCG needs to re-start the decrementer timer and/or raise the
diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
index a05bdf78c9..022b984e00 100644
--- a/target/ppc/misc_helper.c
+++ b/target/ppc/misc_helper.c
@@ -204,16 +204,24 @@ void helper_store_ciabr(CPUPPCState *env, target_ulong value)
     ppc_store_ciabr(env, value);
 }

-void helper_store_dawr0(CPUPPCState *env, target_ulong value)
-{
-    ppc_store_dawr0(env, value);
+#define HELPER_STORE_DAWR(id)                                                 \
+void helper_store_dawr##id(CPUPPCState *env, target_ulong value)              \
+{                                                                             \
+    env->spr[SPR_DAWR##id] = value;                                           \
 }

-void helper_store_dawrx0(CPUPPCState *env, target_ulong value)
-{
-    ppc_store_dawrx0(env, value);
+#define HELPER_STORE_DAWRX(id)                                                \
+void helper_store_dawrx##id(CPUPPCState *env, target_ulong value)             \
+{                                                                             \
+    env->spr[SPR_DAWRX##id] = value;                                          \
 }

+HELPER_STORE_DAWR(0)
+HELPER_STORE_DAWRX(0)
+
+HELPER_STORE_DAWR(1)
+HELPER_STORE_DAWRX(1)
+
 /*
  * DPDES register is shared. Each bit reflects the state of the
  * doorbell interrupt of a thread of the same core.
diff --git a/target/ppc/spr_common.h b/target/ppc/spr_common.h
index 8a9d6cd994..c987a50809 100644
--- a/target/ppc/spr_common.h
+++ b/target/ppc/spr_common.h
@@ -162,6 +162,8 @@ void spr_write_cfar(DisasContext *ctx, int sprn, int gprn);
 void spr_write_ciabr(DisasContext *ctx, int sprn, int gprn);
 void spr_write_dawr0(DisasContext *ctx, int sprn, int gprn);
 void spr_write_dawrx0(DisasContext *ctx, int sprn, int gprn);
+void spr_write_dawr1(DisasContext *ctx, int sprn, int gprn);
+void spr_write_dawrx1(DisasContext *ctx, int sprn, int gprn);
 void spr_write_ureg(DisasContext *ctx, int sprn, int gprn);
 void spr_read_purr(DisasContext *ctx, int gprn, int sprn);
 void spr_write_purr(DisasContext *ctx, int sprn, int gprn);
diff --git a/target/ppc/translate.c b/target/ppc/translate.c
index 329da4d518..4d41628c04 100644
--- a/target/ppc/translate.c
+++ b/target/ppc/translate.c
@@ -582,17 +582,26 @@ void spr_write_ciabr(DisasContext *ctx, int sprn, int gprn)
 }

 /* Watchpoint */
-void spr_write_dawr0(DisasContext *ctx, int sprn, int gprn)
-{
-    translator_io_start(&ctx->base);
-    gen_helper_store_dawr0(tcg_env, cpu_gpr[gprn]);
+#define SPR_WRITE_DAWR(id)                                        \
+void spr_write_dawr##id(DisasContext *ctx, int sprn, int gprn)    \
+{                                                                 \
+    translator_io_start(&ctx->base);                              \
+    gen_helper_store_dawr##id(tcg_env, cpu_gpr[gprn]);            \
 }

-void spr_write_dawrx0(DisasContext *ctx, int sprn, int gprn)
-{
-    translator_io_start(&ctx->base);
-    gen_helper_store_dawrx0(tcg_env, cpu_gpr[gprn]);
+#define SPR_WRITE_DAWRX(id)                                       \
+void spr_write_dawrx##id(DisasContext *ctx, int sprn, int gprn)   \
+{                                                                 \
+    translator_io_start(&ctx->base);                              \
+    gen_helper_store_dawrx##id(tcg_env, cpu_gpr[gprn]);           \
 }
+
+SPR_WRITE_DAWR(0)
+SPR_WRITE_DAWRX(0)
+
+SPR_WRITE_DAWR(1)
+SPR_WRITE_DAWRX(1)
+
 #endif /* defined(TARGET_PPC64) && !defined(CONFIG_USER_ONLY) */

 /* CTR */



