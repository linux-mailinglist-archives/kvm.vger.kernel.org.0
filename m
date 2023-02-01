Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B26866B4
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjBANVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBANVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:21:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F03EFEA
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:21:27 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311Ctj1V030275;
        Wed, 1 Feb 2023 13:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0rQpBWnSCSg+hTCpttVtfiOSflMJCbv1cXL8T/yBGQQ=;
 b=ak53fYxXSNZLvnsr2TrNmICxht2b4muywYB6GMGhnY9fRlYEUKyZtOcnZ7r/EjWCk3Ez
 dzeAEdkjzq8A0xaxnjY1FgnfEN9qxBvCV5pdv+2zH+Qz0tQyzktXo/efZqSqjFmgaavE
 w48eL+D+uLeSOqqNPuj8HCqbJg2RuZ6RdPTRzxf1QnAEdefTmk1CnXM2wx9GLdIbp/Gf
 /lzyabhgolsnvxWpNTSHAZsoMV4v7xQekUMFgrFr3TJmwTpCsO2qGe0l9qF6t5C5b4Hk
 9HdqdyhUq+tnFxLLZHrxZ8uhpENpcK1e3tc8l3wLVCfjxO1NqAjq7+5E6LTf8EVuqQkY IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrh3grnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:11 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311CujbN003850;
        Wed, 1 Feb 2023 13:21:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrh3grm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3116ieXO014744;
        Wed, 1 Feb 2023 13:21:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ncvttvvw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311DL4lo44302624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 13:21:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF42D2004B;
        Wed,  1 Feb 2023 13:21:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87C7220040;
        Wed,  1 Feb 2023 13:21:03 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.4.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 13:21:03 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v15 06/11] s390x/cpu topology: interception of PTF instruction
Date:   Wed,  1 Feb 2023 14:20:46 +0100
Message-Id: <20230201132051.126868-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bxH3NQmoaBKQ-m6YCkbZHWIK7Zmnr86i
X-Proofpoint-GUID: swzgAWBcr_vMJg3TubiYflSJI92SJi-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the host supports the CPU topology facility, the PTF
instruction with function code 2 is interpreted by the SIE,
provided that the userland hypervizor activates the interpretation
by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.

The PTF instructions with function code 0 and 1 are intercepted
and must be emulated by the userland hypervizor.

During RESET all CPU of the configuration are placed in
horizontal polarity.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/s390-virtio-ccw.h |   6 ++
 target/s390x/cpu.h                 |   1 +
 hw/s390x/cpu-topology.c            | 103 +++++++++++++++++++++++++++++
 target/s390x/cpu-sysemu.c          |  14 ++++
 target/s390x/kvm/kvm.c             |  11 +++
 5 files changed, 135 insertions(+)

diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 9bba21a916..c1d46e78af 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -30,6 +30,12 @@ struct S390CcwMachineState {
     uint8_t loadparm[8];
 };
 
+#define S390_PTF_REASON_NONE (0x00 << 8)
+#define S390_PTF_REASON_DONE (0x01 << 8)
+#define S390_PTF_REASON_BUSY (0x02 << 8)
+#define S390_TOPO_FC_MASK 0xffUL
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
+
 struct S390CcwMachineClass {
     /*< private >*/
     MachineClass parent_class;
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 848314d2a9..f6e207afde 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -857,6 +857,7 @@ void s390_enable_css_support(S390CPU *cpu);
 void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
+void s390_cpu_topology_set_modified(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index cf63f3dd01..1028bf4476 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -85,16 +85,104 @@ static void s390_topology_init(MachineState *ms)
     QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
 }
 
+/**
+ * s390_topology_set_cpus_polarity:
+ * @polarity: polarity requested by the caller
+ *
+ * Set all CPU entitlement according to polarity and
+ * dedication.
+ * Default vertical entitlement is POLARITY_VERTICAL_MEDIUM as
+ * it does not require host modification of the CPU provisioning
+ * until the host decide to modify individual CPU provisioning
+ * using QAPI interface.
+ * However a dedicated vCPU will have a POLARITY_VERTICAL_HIGH
+ * entitlement.
+ */
+static void s390_topology_set_cpus_polarity(int polarity)
+{
+    CPUState *cs;
+
+    CPU_FOREACH(cs) {
+        if (polarity == POLARITY_HORIZONTAL) {
+            S390_CPU(cs)->env.entitlement = 0;
+        } else if (S390_CPU(cs)->env.dedicated) {
+            S390_CPU(cs)->env.entitlement = POLARITY_VERTICAL_HIGH;
+        } else {
+            S390_CPU(cs)->env.entitlement = POLARITY_VERTICAL_MEDIUM;
+        }
+    }
+}
+
+/*
+ * s390_handle_ptf:
+ *
+ * @register 1: contains the function code
+ *
+ * Function codes 0 (horizontal) and 1 (vertical) define the CPU
+ * polarization requested by the guest.
+ *
+ * Verify that the polarization really need to change and call
+ * s390_topology_set_cpus_polarity() specifying the requested polarity
+ * to set for all CPUs.
+ *
+ * Function code 2 is handling topology changes and is interpreted
+ * by the SIE.
+ */
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
+{
+    CPUS390XState *env = &cpu->env;
+    uint64_t reg = env->regs[r1];
+    int fc = reg & S390_TOPO_FC_MASK;
+
+    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        s390_program_interrupt(env, PGM_OPERATION, ra);
+        return;
+    }
+
+    if (env->psw.mask & PSW_MASK_PSTATE) {
+        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
+        return;
+    }
+
+    if (reg & ~S390_TOPO_FC_MASK) {
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+        return;
+    }
+
+    switch (fc) {
+    case POLARITY_VERTICAL:
+    case POLARITY_HORIZONTAL:
+        if (s390_topology.polarity == fc) {
+            env->regs[r1] |= S390_PTF_REASON_DONE;
+            setcc(cpu, 2);
+        } else {
+            s390_topology.polarity = fc;
+            s390_cpu_topology_set_modified();
+            s390_topology_set_cpus_polarity(fc);
+            setcc(cpu, 0);
+        }
+        break;
+    default:
+        /* Note that fc == 2 is interpreted by the SIE */
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+    }
+}
+
 /**
  * s390_topology_reset:
  *
  * Generic reset for CPU topology, calls s390_topology_reset()
  * s390_topology_reset() to reset the kernel Modified Topology
  * change record.
+ * Then set global and all CPUs polarity to POLARITY_HORIZONTAL.
  */
 void s390_topology_reset(void)
 {
     s390_cpu_topology_reset();
+    /* Set global polarity to POLARITY_HORIZONTAL */
+    s390_topology.polarity = POLARITY_HORIZONTAL;
+    /* Set all CPU polarity to POLARITY_HORIZONTAL */
+    s390_topology_set_cpus_polarity(POLARITY_HORIZONTAL);
 }
 
 /**
@@ -137,6 +225,21 @@ static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
                           (smp->books * smp->sockets * smp->cores)) %
                          smp->drawers;
     }
+
+    /*
+     * Machine polarity is set inside the global s390_topology structure.
+     * In the case the polarity is set as horizontal set the entitlement
+     * to POLARITY_VERTICAL_MEDIUM which is the better equivalent when
+     * machine polarity is set to vertical or POLARITY_VERTICAL_HIGH if
+     * the vCPU is dedicated.
+     */
+    if (s390_topology.polarity && !env->entitlement) {
+        if (env->dedicated) {
+            env->entitlement = POLARITY_VERTICAL_HIGH;
+        } else {
+            env->entitlement = POLARITY_VERTICAL_MEDIUM;
+        }
+    }
 }
 
 /**
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index e27864c5f5..82e3f3891e 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -37,6 +37,7 @@
 #include "sysemu/sysemu.h"
 #include "sysemu/tcg.h"
 #include "hw/core/sysemu-cpu-ops.h"
+#include "hw/s390x/cpu-topology.h"
 
 /* S390CPUClass::load_normal() */
 static void s390_cpu_load_normal(CPUState *s)
@@ -319,3 +320,16 @@ void s390_cpu_topology_reset(void)
         }
     }
 }
+
+void s390_cpu_topology_set_modified(void)
+{
+    int ret;
+
+    if (kvm_enabled()) {
+        ret = kvm_s390_topology_set_mtcr(1);
+        if (ret) {
+            error_report("Failed to set Modified Topology Change Report: %s",
+                         strerror(-ret));
+        }
+    }
+}
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index bc953151ce..fb63be41b7 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -96,6 +96,7 @@
 
 #define PRIV_B9_EQBS                    0x9c
 #define PRIV_B9_CLP                     0xa0
+#define PRIV_B9_PTF                     0xa2
 #define PRIV_B9_PCISTG                  0xd0
 #define PRIV_B9_PCILG                   0xd2
 #define PRIV_B9_RPCIT                   0xd3
@@ -1464,6 +1465,13 @@ static int kvm_mpcifc_service_call(S390CPU *cpu, struct kvm_run *run)
     }
 }
 
+static void kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
+{
+    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
+
+    s390_handle_ptf(cpu, r1, RA_IGNORED);
+}
+
 static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
 {
     int r = 0;
@@ -1481,6 +1489,9 @@ static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
     case PRIV_B9_RPCIT:
         r = kvm_rpcit_service_call(cpu, run);
         break;
+    case PRIV_B9_PTF:
+        kvm_handle_ptf(cpu, run);
+        break;
     case PRIV_B9_EQBS:
         /* just inject exception */
         r = -1;
-- 
2.31.1

