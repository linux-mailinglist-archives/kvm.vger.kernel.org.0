Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D554BA16A
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241034AbiBQNju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:39:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbiBQNjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:39:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1B92AF919
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:30 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HClaMJ004623;
        Thu, 17 Feb 2022 13:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NSa7P5yVwD8RzYd6vipEB2AcNnr8bIBH3mfVJotJens=;
 b=OaHeVc6/3p/5Wy4LHWRmIELGIjsl9bDuBjXlqUpxNlO6KBJjIvc8ZPvZrdP0qUg+MggY
 O/tM7InKVkydDU3Xz6xEpAtgtFGFDVPEEwhJ//oJOi4Z0NYPkNfSGJ8Nl9k6EEVs9TQT
 w3vB7dKxVurXjEUCvApOI424DEPeC/UHYSjFigtcRhytadyT74ORMROHlDVFqvx9ARkG
 GesR13h3vTvU6iKcqocxtpbAg3Jaj8izUz4hB7pkIn1soS0TdQeDpSkkUCF8SBBsEa5Y
 Kh2Ox61t9GOvKxtzaxQzfOhfOyASwA8H8eNxA3ELSJOT8Qt2QXRpwK4mh2HRLOhez2Bt fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9h6td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HCpr91017124;
        Thu, 17 Feb 2022 13:39:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9h6s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDbbUI004071;
        Thu, 17 Feb 2022 13:39:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3e64ha8gm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdGVl33030638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DC9B4C046;
        Thu, 17 Feb 2022 13:39:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6E24C05A;
        Thu, 17 Feb 2022 13:39:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 05/11] s390x: kvm: topology: interception of PTF instruction
Date:   Thu, 17 Feb 2022 14:41:19 +0100
Message-Id: <20220217134125.132150-6-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IVcYyT9utXCL1ARZxvhP-wiG4QWukU2j
X-Proofpoint-ORIG-GUID: 7eCPrBuz4LMYyT69ubROfePdL4aY_9X5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170061
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
provided that the userland hypervizor activates the interpretation
by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.

The PTF instructions with function code 0 and 1 are intercepted
and must be emulated by the userland hypervizor.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/s390-virtio-ccw.c         | 50 ++++++++++++++++++++++++++++++
 include/hw/s390x/s390-virtio-ccw.h |  6 ++++
 target/s390x/kvm/kvm.c             | 15 +++++++++
 3 files changed, 71 insertions(+)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index ae8e99d0b0..12903eb2af 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -408,6 +408,56 @@ static void s390_pv_prepare_reset(S390CcwMachineState *ms)
     s390_pv_prep_reset();
 }
 
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
+int s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
+{
+    CPUS390XState *env = &cpu->env;
+    uint64_t reg = env->regs[r1];
+    uint8_t fc = reg & S390_TOPO_FC_MASK;
+
+    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        s390_program_interrupt(env, PGM_OPERATION, ra);
+        return 0;
+    }
+
+    if (env->psw.mask & PSW_MASK_PSTATE) {
+        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
+        return 0;
+    }
+
+    if (reg & ~S390_TOPO_FC_MASK) {
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+        return 0;
+    }
+
+    switch (fc) {
+    case 0:    /* Horizontal polarization is already set */
+        env->regs[r1] |= S390_PTF_REASON_DONE;
+        return 2;
+    case 1:    /* Vertical polarization is not supported */
+        env->regs[r1] |= S390_PTF_REASON_NONE;
+        return 2;
+    default:
+        /* Note that fc == 2 is interpreted by the SIE */
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+    }
+
+    return 0;
+}
+
 static void s390_machine_reset(MachineState *machine)
 {
     S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 3331990e02..ac4b4a92e7 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -30,6 +30,12 @@ struct S390CcwMachineState {
     uint8_t loadparm[8];
 };
 
+#define S390_PTF_REASON_NONE (0x00 << 8)
+#define S390_PTF_REASON_DONE (0x01 << 8)
+#define S390_PTF_REASON_BUSY (0x02 << 8)
+#define S390_TOPO_FC_MASK 0xffUL
+int s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
+
 struct S390CcwMachineClass {
     /*< private >*/
     MachineClass parent_class;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 7504cbd21b..3106654445 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -98,6 +98,7 @@
 
 #define PRIV_B9_EQBS                    0x9c
 #define PRIV_B9_CLP                     0xa0
+#define PRIV_B9_PTF                     0xa2
 #define PRIV_B9_PCISTG                  0xd0
 #define PRIV_B9_PCILG                   0xd2
 #define PRIV_B9_RPCIT                   0xd3
@@ -363,6 +364,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_STSI, 0);
+    kvm_vm_enable_cap(s, KVM_CAP_S390_CPU_TOPOLOGY, 0);
     if (ri_allowed()) {
         if (kvm_vm_enable_cap(s, KVM_CAP_S390_RI, 0) == 0) {
             cap_ri = 1;
@@ -1454,6 +1456,16 @@ static int kvm_mpcifc_service_call(S390CPU *cpu, struct kvm_run *run)
     }
 }
 
+static int kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
+{
+    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
+    int ret;
+
+    ret = s390_handle_ptf(cpu, r1, RA_IGNORED);
+    setcc(cpu, ret);
+    return 0;
+}
+
 static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
 {
     int r = 0;
@@ -1471,6 +1483,9 @@ static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
     case PRIV_B9_RPCIT:
         r = kvm_rpcit_service_call(cpu, run);
         break;
+    case PRIV_B9_PTF:
+        r = kvm_handle_ptf(cpu, run);
+        break;
     case PRIV_B9_EQBS:
         /* just inject exception */
         r = -1;
-- 
2.27.0

