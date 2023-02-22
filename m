Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9A69F664
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 15:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjBVOVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 09:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjBVOVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 09:21:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E21E3B661
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:21:28 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MDnuvQ014137;
        Wed, 22 Feb 2023 14:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yViX2rhtI5LHGRtWQh3hoTCbRrE8+MMEmYwn+xuLf6E=;
 b=eVwyKWnxg3S8RdV5u+Tqhn5Jn4BMBH3QRAIgUHa+40X03RLvz7SMCYSxTaLjRGzV4v46
 Yw4tElWCVVRALhH/EZqAfN/+NpfAqdEe3t0BgbuRjy+2pPYxSSIiGBE6QUX402Qz1Lvu
 dp7/S4zeGdLVA1eL01fwmGpI0lqG4lYDbZuAL4QrhlyVasT/41JKt+vdUb90urqkhkN3
 YnulGX38X8EFkyimDpMiGU6Z0LT7pQHH93vlWV5ksxINTT0xuBbPUGf13CYRZ9Va8xCX
 Z3UwkCg9YcyQfwAbg1XMzqeF2lej5vX5PMSE6nKcONi2bAfK8ozGQHsbsFcset4GlSXG sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm9ggwdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:15 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ME385H008151;
        Wed, 22 Feb 2023 14:21:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm9ggwby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LNuOwg007299;
        Wed, 22 Feb 2023 14:21:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6dfdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MEL8G046203376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 14:21:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99D9A20043;
        Wed, 22 Feb 2023 14:21:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34B8720049;
        Wed, 22 Feb 2023 14:21:08 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 14:21:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v16 06/11] s390x/cpu topology: interception of PTF instruction
Date:   Wed, 22 Feb 2023 15:21:00 +0100
Message-Id: <20230222142105.84700-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230222142105.84700-1-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5Q_iuvA55M1wJyA9__JDKwS6bvv5rFG4
X-Proofpoint-GUID: nUYA_yZQzHUN4zEtNRtnroPNPJl-25-z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220122
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
provided that the userland hypervisor activates the interpretation
by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.

The PTF instructions with function code 0 and 1 are intercepted
and must be emulated by the userland hypervisor.

During RESET all CPU of the configuration are placed in
horizontal polarity.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/s390-virtio-ccw.h |  6 +++
 hw/s390x/cpu-topology.c            | 85 ++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c             | 11 ++++
 3 files changed, 102 insertions(+)

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
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 08642e0e04..40253a2444 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -87,6 +87,89 @@ static void s390_topology_init(MachineState *ms)
     QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
 }
 
+/**
+ * s390_topology_set_cpus_entitlement:
+ * @polarization: polarization requested by the caller
+ *
+ * Set all CPU entitlement according to polarization and
+ * dedication.
+ * Default vertical entitlement is S390_CPU_ENTITLEMENT_MEDIUM as
+ * it does not require host modification of the CPU provisioning
+ * until the host decide to modify individual CPU provisioning
+ * using QAPI interface.
+ * However a dedicated vCPU will have a S390_CPU_ENTITLEMENT_HIGH
+ * entitlement.
+ */
+static void s390_topology_set_cpus_entitlement(int polarization)
+{
+    CPUState *cs;
+
+    CPU_FOREACH(cs) {
+        if (polarization == S390_CPU_POLARIZATION_HORIZONTAL) {
+            S390_CPU(cs)->env.entitlement = 0;
+        } else if (S390_CPU(cs)->env.dedicated) {
+            S390_CPU(cs)->env.entitlement = S390_CPU_ENTITLEMENT_HIGH;
+        } else {
+            S390_CPU(cs)->env.entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
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
+ * s390_topology_set_cpus_entitlement() specifying the requested polarization
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
+    case S390_CPU_POLARIZATION_VERTICAL:
+    case S390_CPU_POLARIZATION_HORIZONTAL:
+        if (s390_topology.polarization == fc) {
+            env->regs[r1] |= S390_PTF_REASON_DONE;
+            setcc(cpu, 2);
+        } else {
+            s390_topology.polarization = fc;
+            s390_cpu_topology_set_changed(true);
+            s390_topology_set_cpus_entitlement(fc);
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
@@ -96,6 +179,8 @@ static void s390_topology_init(MachineState *ms)
 void s390_topology_reset(void)
 {
     s390_cpu_topology_set_changed(false);
+    s390_topology.polarization = S390_CPU_POLARIZATION_HORIZONTAL;
+    s390_topology_set_cpus_entitlement(S390_CPU_POLARIZATION_HORIZONTAL);
 }
 
 /**
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

