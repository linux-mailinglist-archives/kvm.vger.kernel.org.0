Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F7743804
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjF3JSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjF3JSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:18:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7423585
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 02:18:23 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35U9Bvrc026979;
        Fri, 30 Jun 2023 09:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Vrj/chRDxqKSDXW1NCX8tnjWSS/L7F/mrOfx4Hgu83E=;
 b=IAPeVMrYXwmXjKa3P88Z9DGAOIONEEZBTXhmkjfFsYZgjJ4xHd1BEGy+fWpbhbq3YHyh
 5R2WXsfzp4+fwyiKVUlKyJ9vi0WjJzxMjPU7n3E/rIy4lvUNB/n9HJ6waHYKEQByWgLO
 6yI/IrVPp9w7fg9MITrVzn8YYQSZnD1XkltPBbU5HYolyIEpJtrTddRp2fb08wns/hq/
 FR1HhetFWbi/idVLYljpslMTJ4M4M75W3xx5+Yg2HiTrgnraeUMmtqYshY2t414ik7iG
 4ZtUhZ35//bH0MJxKHcGKOgpTrBK6pTyM6UoMCLzCfvgAGVkKDr/FgcdC0JVui7tjcpP 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g85u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:12 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35U9C4b0027627;
        Fri, 30 Jun 2023 09:18:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g84j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U3tFEn014982;
        Fri, 30 Jun 2023 09:18:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rdqre42tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35U9I3hE38404676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 09:18:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 471E820049;
        Fri, 30 Jun 2023 09:18:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1D4020040;
        Fri, 30 Jun 2023 09:18:01 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.38.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 09:18:01 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v21 06/20] s390x/cpu topology: interception of PTF instruction
Date:   Fri, 30 Jun 2023 11:17:38 +0200
Message-Id: <20230630091752.67190-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WvNYis-_uA304xEN0hqQsurLofPAyPT-
X-Proofpoint-GUID: gmadX3tYug1dVVYsLFdkpjZuhSYAgQto
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 include/hw/s390x/s390-virtio-ccw.h |  6 ++++
 hw/s390x/cpu-topology.c            | 54 ++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c             | 11 ++++++
 3 files changed, 71 insertions(+)

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
index 764ff92573..8c1a82bd71 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -92,6 +92,59 @@ static void s390_topology_init(MachineState *ms)
                                             smp->books * smp->drawers);
 }
 
+/*
+ * s390_handle_ptf:
+ *
+ * @register 1: contains the function code
+ *
+ * Function codes 0 (horizontal) and 1 (vertical) define the CPU
+ * polarization requested by the guest.
+ *
+ * Function code 2 is handling topology changes and is interpreted
+ * by the SIE.
+ */
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
+{
+    CpuS390Polarization polarization = S390_CPU_POLARIZATION_HORIZONTAL;
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
+        polarization = S390_CPU_POLARIZATION_VERTICAL;
+        /* fallthrough */
+    case S390_CPU_POLARIZATION_HORIZONTAL:
+        if (s390_topology.polarization == polarization) {
+            env->regs[r1] |= S390_PTF_REASON_DONE;
+            setcc(cpu, 2);
+        } else {
+            s390_topology.polarization = polarization;
+            s390_cpu_topology_set_changed(true);
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
@@ -101,6 +154,7 @@ static void s390_topology_init(MachineState *ms)
 void s390_topology_reset(void)
 {
     s390_cpu_topology_set_changed(false);
+    s390_topology.polarization = S390_CPU_POLARIZATION_HORIZONTAL;
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

