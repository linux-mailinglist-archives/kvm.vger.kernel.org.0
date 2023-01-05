Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30065EF69
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbjAEOyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjAEOyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6285AC57
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:02 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305EBVqt027992;
        Thu, 5 Jan 2023 14:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xOnc2dhPoENldXYuGgZw2NckHDZA7uyD6qOXKhsbNiY=;
 b=nQo+Q7FxBgOoma3YOXEG0cxWCcGPDp5VPO9s0LYPjQn/UXSmChamPVd6QglrV2N7JoU5
 ZcmmAYs6yRZE3+mxHWjlmX2HsKpNBZr+64jSFOZbiOaTRKPYDsgQoUnu7cacBOdPY6gx
 uZmtp9LpqqKVylfQE2KLr/TpmYBGtg0YYqPbvgM9ECb/FCarjiMpj3BHF0ShaAuH9eD6
 QFLiXChokjfRujyTOTPHgeK4BHwW9n/YhraKI59a3TfOdAY2jMyuXOHbq6wQuzUirrBE
 HHnrlB5rhEAvwVqVnR2AOIPkK0N9g4PGNf6teYDBqPEDCOpS9KvLx7ksG8biVa4enJOi fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx03hh1ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:28 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305EEak5011559;
        Thu, 5 Jan 2023 14:53:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx03hh1kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30545tiK021071;
        Thu, 5 Jan 2023 14:53:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6ewa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:25 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErM5045678928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CEDE20043;
        Thu,  5 Jan 2023 14:53:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1392F20040;
        Thu,  5 Jan 2023 14:53:21 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 06/11] s390x/cpu topology: interception of PTF instruction
Date:   Thu,  5 Jan 2023 15:53:08 +0100
Message-Id: <20230105145313.168489-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: My3thOFCQpxrJmTR1GOUTfD3fggHOe-7
X-Proofpoint-GUID: Wr7CgBCJMUwZ0pCRnpLYdrgZhi2Ts90u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050114
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
 include/hw/s390x/cpu-topology.h    |  3 +
 include/hw/s390x/s390-virtio-ccw.h |  6 ++
 target/s390x/cpu.h                 |  1 +
 hw/s390x/cpu-topology.c            | 92 ++++++++++++++++++++++++++++++
 target/s390x/cpu-sysemu.c          | 16 ++++++
 target/s390x/kvm/kvm.c             | 11 ++++
 6 files changed, 129 insertions(+)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 9571aa70e5..33e23d78b9 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -55,11 +55,13 @@ typedef struct S390Topology {
     QTAILQ_HEAD(, S390TopologyEntry) list;
     uint8_t *sockets;
     CpuTopology *smp;
+    int polarity;
 } S390Topology;
 
 #ifdef CONFIG_KVM
 bool s390_has_topology(void);
 void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
+void s390_topology_set_polarity(int polarity);
 #else
 static inline bool s390_has_topology(void)
 {
@@ -68,6 +70,7 @@ static inline bool s390_has_topology(void)
 static inline void s390_topology_set_cpu(MachineState *ms,
                                          S390CPU *cpu,
                                          Error **errp) {}
+static inline void s390_topology_set_polarity(int polarity) {}
 #endif
 extern S390Topology s390_topology;
 
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
index 01ade07009..5da4041576 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -864,6 +864,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_reset(void);
+void s390_cpu_topology_set(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 438055c612..e6b4692581 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -97,6 +97,98 @@ static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
 }
 
 /**
+ * s390_topology_set_polarity
+ * @polarity: horizontal or vertical
+ *
+ * Changes the polarity of all the CPU in the configuration.
+ *
+ * If the dedicated CPU modifier attribute is set a vertical
+ * polarization is always high (Architecture).
+ * Otherwise we decide to set it as medium.
+ *
+ * Once done, advertise a topology change.
+ */
+void s390_topology_set_polarity(int polarity)
+{
+    S390TopologyEntry *entry;
+
+    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
+        if (polarity == S390_TOPOLOGY_POLARITY_HORIZONTAL) {
+            entry->id.p = polarity;
+        } else {
+            if (entry->id.d) {
+                entry->id.p = S390_TOPOLOGY_POLARITY_VERTICAL_HIGH;
+            } else {
+                entry->id.p = S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM;
+            }
+        }
+    }
+    s390_cpu_topology_set();
+}
+
+/*
+ * s390_handle_ptf:
+ *
+ * @register 1: contains the function code
+ *
+ * Function codes 0 and 1 handle the CPU polarization.
+ * We assume an horizontal topology, the only one supported currently
+ * by Linux, consequently we answer to function code 0, requesting
+ * horizontal polarization that it is already the current polarization
+ * and reject vertical polarization request without further explanation.
+ *
+ * Function code 2 is handling topology changes and is interpreted
+ * by the SIE.
+ */
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
+{
+    CPUS390XState *env = &cpu->env;
+    uint64_t reg = env->regs[r1];
+    uint8_t fc = reg & S390_TOPO_FC_MASK;
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
+    case 0:    /* Horizontal polarization is already set */
+        if (s390_topology.polarity == S390_TOPOLOGY_POLARITY_HORIZONTAL) {
+            env->regs[r1] |= S390_PTF_REASON_DONE;
+            setcc(cpu, 2);
+        } else {
+            s390_topology_set_polarity(S390_TOPOLOGY_POLARITY_HORIZONTAL);
+            s390_topology.polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
+            setcc(cpu, 0);
+        }
+        break;
+    case 1:    /* Vertical polarization is not supported */
+        if (s390_topology.polarity != S390_TOPOLOGY_POLARITY_HORIZONTAL) {
+            env->regs[r1] |= S390_PTF_REASON_DONE;
+            setcc(cpu, 2);
+        } else {
+            s390_topology_set_polarity(S390_TOPOLOGY_POLARITY_VERTICAL_LOW);
+            s390_topology.polarity = S390_TOPOLOGY_POLARITY_VERTICAL_LOW;
+            setcc(cpu, 0);
+        }
+        break;
+    default:
+        /* Note that fc == 2 is interpreted by the SIE */
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+    }
+}
+
+ /**
  * s390_topology_set_entry:
  * @entry: Topology entry to setup
  * @id: topology id to use for the setup
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index e27864c5f5..8643320947 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -37,6 +37,7 @@
 #include "sysemu/sysemu.h"
 #include "sysemu/tcg.h"
 #include "hw/core/sysemu-cpu-ops.h"
+#include "hw/s390x/cpu-topology.h"
 
 /* S390CPUClass::load_normal() */
 static void s390_cpu_load_normal(CPUState *s)
@@ -311,6 +312,8 @@ void s390_cpu_topology_reset(void)
 {
     int ret;
 
+    s390_topology_set_polarity(S390_TOPOLOGY_POLARITY_HORIZONTAL);
+
     if (kvm_enabled()) {
         ret = kvm_s390_topology_set_mtcr(0);
         if (ret) {
@@ -319,3 +322,16 @@ void s390_cpu_topology_reset(void)
         }
     }
 }
+
+void s390_cpu_topology_set(void)
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

