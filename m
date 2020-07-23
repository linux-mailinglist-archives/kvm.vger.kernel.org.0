Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C622ACC8
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgGWKnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 06:43:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728428AbgGWKnP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 06:43:15 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NAVnCv143337;
        Thu, 23 Jul 2020 06:42:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32f1vm2nkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:42:41 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06NAVpSp143562;
        Thu, 23 Jul 2020 06:42:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32f1vm2njt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:42:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NAgIVS025629;
        Thu, 23 Jul 2020 10:42:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 32brbh5ye3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 10:42:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NAgYdm50856218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 10:42:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA11511C04C;
        Thu, 23 Jul 2020 10:42:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5ADB11C04A;
        Thu, 23 Jul 2020 10:42:30 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.40.160])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 10:42:30 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     mpe@ellerman.id.au, paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mikey@neuling.org, npiggin@gmail.com,
        pbonzini@redhat.com, christophe.leroy@c-s.fr, jniethe5@gmail.com,
        pedromfc@br.ibm.com, rogealve@br.ibm.com, cohuck@redhat.com,
        mst@redhat.com, clg@kaod.org, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] ppc: Enable 2nd DAWR support on p10
Date:   Thu, 23 Jul 2020 16:12:20 +0530
Message-Id: <20200723104220.314671-3-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
References: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_03:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 mlxlogscore=985 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per the PAPR, bit 0 of byte 64 in pa-features property indicates
availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
find whether kvm supports 2nd DAWR or nor. If it's supported, set
the pa-feature bit in guest DT so the guest kernel can support 2nd
DAWR.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 hw/ppc/spapr.c                  | 33 +++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h          |  1 +
 linux-headers/asm-powerpc/kvm.h |  4 ++++
 linux-headers/linux/kvm.h       |  1 +
 target/ppc/cpu.h                |  2 ++
 target/ppc/kvm.c                |  7 +++++++
 target/ppc/kvm_ppc.h            |  6 ++++++
 target/ppc/translate_init.inc.c | 17 ++++++++++++++++-
 8 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 0ae293ec94..4416319363 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -252,6 +252,31 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         /* 60: NM atomic, 62: RNG */
         0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
     };
+    uint8_t pa_features_310[] = { 66, 0,
+        /* 0: MMU|FPU|SLB|RUN|DABR|NX, 1: fri[nzpm]|DABRX|SPRG3|SLB0|PP110 */
+        /* 2: VPM|DS205|PPR|DS202|DS206, 3: LSD|URG, SSO, 5: LE|CFAR|EB|LSQ */
+        0xf6, 0x1f, 0xc7, 0xc0, 0x80, 0xf0, /* 0 - 5 */
+        /* 6: DS207 */
+        0x80, 0x00, 0x00, 0x00, 0x00, 0x00, /* 6 - 11 */
+        /* 16: Vector */
+        0x00, 0x00, 0x00, 0x00, 0x80, 0x00, /* 12 - 17 */
+        /* 18: Vec. Scalar, 20: Vec. XOR, 22: HTM */
+        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 18 - 23 */
+        /* 24: Ext. Dec, 26: 64 bit ftrs, 28: PM ftrs */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 24 - 29 */
+        /* 30: MMR, 32: LE atomic, 34: EBB + ext EBB */
+        0x80, 0x00, 0x80, 0x00, 0xC0, 0x00, /* 30 - 35 */
+        /* 36: SPR SO, 38: Copy/Paste, 40: Radix MMU */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 36 - 41 */
+        /* 42: PM, 44: PC RA, 46: SC vec'd */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 42 - 47 */
+        /* 48: SIMD, 50: QP BFP, 52: String */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
+        /* 54: DecFP, 56: DecI, 58: SHA */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
+        /* 60: NM atomic, 62: RNG, 64: DAWR1 */
+        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
+    };
     uint8_t *pa_features = NULL;
     size_t pa_size;
 
@@ -267,6 +292,10 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         pa_features = pa_features_300;
         pa_size = sizeof(pa_features_300);
     }
+    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat_pvr)) {
+        pa_features = pa_features_310;
+        pa_size = sizeof(pa_features_310);
+    }
     if (!pa_features) {
         return;
     }
@@ -291,6 +320,10 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         pa_features[40 + 2] &= ~0x80; /* Radix MMU */
     }
 
+    if (kvm_enabled() && kvmppc_has_cap_dawr1()) {
+        pa_features[66] |= 0x80;
+    }
+
     _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
 }
 
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 6ba43bc9b8..2f2beb4571 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -352,6 +352,7 @@ struct SpaprMachineState {
 #define H_SET_MODE_RESOURCE_SET_DAWR0           2
 #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
 #define H_SET_MODE_RESOURCE_LE                  4
+#define H_SET_MODE_RESOURCE_SET_DAWR1           5
 
 /* Flags for H_SET_MODE_RESOURCE_LE */
 #define H_SET_MODE_ENDIAN_BIG    0
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index 38d61b73f5..c5c0f128b4 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -640,6 +640,10 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
 #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
 
+/* POWER10 registers. */
+#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
+#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index a28c366737..015fa4b44b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_PPC_DAWR1 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 0f641becf7..52e17ef013 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1465,9 +1465,11 @@ typedef PowerPCCPU ArchCPU;
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
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 2692f76130..cbcf9990be 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -89,6 +89,7 @@ static int cap_ppc_count_cache_flush_assist;
 static int cap_ppc_nested_kvm_hv;
 static int cap_large_decr;
 static int cap_fwnmi;
+static int cap_dawr1;
 
 static uint32_t debug_inst_opcode;
 
@@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
     cap_large_decr = kvmppc_get_dec_bits();
     cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
+    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
     /*
      * Note: setting it to false because there is not such capability
      * in KVM at this moment.
@@ -2079,6 +2081,11 @@ int kvmppc_set_fwnmi(void)
     return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
 }
 
+bool kvmppc_has_cap_dawr1(void)
+{
+    return cap_dawr1;
+}
+
 int kvmppc_smt_threads(void)
 {
     return cap_ppc_smt ? cap_ppc_smt : 1;
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 701c0c262b..5db14e7096 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -64,6 +64,7 @@ bool kvmppc_has_cap_htm(void);
 bool kvmppc_has_cap_mmu_radix(void);
 bool kvmppc_has_cap_mmu_hash_v3(void);
 bool kvmppc_has_cap_xive(void);
+bool kvmppc_has_cap_dawr1(void);
 int kvmppc_get_cap_safe_cache(void);
 int kvmppc_get_cap_safe_bounds_check(void);
 int kvmppc_get_cap_safe_indirect_branch(void);
@@ -346,6 +347,11 @@ static inline bool kvmppc_has_cap_xive(void)
     return false;
 }
 
+static inline bool kvmppc_has_cap_dawr1(void)
+{
+    return false;
+}
+
 static inline int kvmppc_get_cap_safe_cache(void)
 {
     return 0;
diff --git a/target/ppc/translate_init.inc.c b/target/ppc/translate_init.inc.c
index 143adf27c0..dcd4fe0cb1 100644
--- a/target/ppc/translate_init.inc.c
+++ b/target/ppc/translate_init.inc.c
@@ -7684,6 +7684,21 @@ static void gen_spr_book3s_207_dbg(CPUPPCState *env)
                         KVM_REG_PPC_CIABR, 0x00000000);
 }
 
+static void gen_spr_book3s_310_dbg(CPUPPCState *env)
+{
+    gen_spr_book3s_207_dbg(env);
+    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_generic,
+                        KVM_REG_PPC_DAWR1, 0x00000000);
+    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_generic,
+                        KVM_REG_PPC_DAWRX1, 0x00000000);
+}
+
 static void gen_spr_970_dbg(CPUPPCState *env)
 {
     /* Breakpoints */
@@ -9060,7 +9075,7 @@ static void init_proc_POWER10(CPUPPCState *env)
 {
     /* Common Registers */
     init_proc_book3s_common(env);
-    gen_spr_book3s_207_dbg(env);
+    gen_spr_book3s_310_dbg(env);
 
     /* POWER8 Specific Registers */
     gen_spr_book3s_ids(env);
-- 
2.17.1

