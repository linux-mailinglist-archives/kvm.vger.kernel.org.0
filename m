Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87461551F25
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiFTOkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245153AbiFTOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC6A767D
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:49 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KDUNwx023758;
        Mon, 20 Jun 2022 13:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WA6U8UJzN4BVznmx1Tk3X7vRSNImIwx9No2tEjPGN9M=;
 b=lHiWRjmT5BEixNhwaGbn2cqfVN5bxpJLUrKPPmlc5aAIB4oQ6r74hbwUldklx1LySzPA
 4lIxiIRfvb2BprjTSwR8DqIJ9lwNqs/FD2jCrYwhois8AMAgme2ut8TsrXvbtED6ibrI
 LDwFWMTzx/mE5sfiqb4XNlKBsTpjFsmyMHJYjgFrm0x1aOVhBrNraoUxgsOqVKuBMO4u
 O5xZtjAlVu/zBJjJuubNL3T0n059L4dw+qz2CD1WLCuP8MWMba94wRUFIOAyslcZdT3V
 DAnvN3ZHDoDJWKMpDUrcRxUurl8chyULx5u1wthDDn/YzEKqIFjdSPbfGG1NJ/2vU1jU +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrcjtspn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:46 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KCEcZe024566;
        Mon, 20 Jun 2022 13:59:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrcjtsp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpBAb010890;
        Mon, 20 Jun 2022 13:59:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gs6b8j2mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxeJc11338232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9915211C04A;
        Mon, 20 Jun 2022 13:59:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C961711C050;
        Mon, 20 Jun 2022 13:59:39 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 11/12] s390x/cpu_topology: CPU topology migration
Date:   Mon, 20 Jun 2022 16:03:51 +0200
Message-Id: <20220620140352.39398-12-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6dkzbLFkrfTSPzT6VYPirK1cCZkBFauu
X-Proofpoint-GUID: pTOUFJnJvVCgxsUN-J4PuVwEGZ6l3SLf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To migrate the Multiple Topology Change report, MTCR, we
get it from KVM and save its state in the topology VM State
Description during the presave and restore it to KVM on the
destination during the postload.

The migration state is needed whenever the CPU topology
feature is activated.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 43 +++++++++++++++++++++++++++++++++
 include/hw/s390x/cpu-topology.h |  2 ++
 target/s390x/cpu.h              |  2 ++
 target/s390x/cpu_models.c       |  1 +
 target/s390x/kvm/kvm.c          | 38 ++++++++++++++++++++++++++++-
 5 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index ba12cafaf7..8fba2c8144 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,8 @@
 #include "qemu/typedefs.h"
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
+#include "migration/vmstate.h"
+#include "qemu/error-report.h"
 
 /*
  * s390_handle_ptf:
@@ -672,6 +674,46 @@ static void s390_topology_reset(DeviceState *dev)
     s390_cpu_topology_mtr_reset();
 }
 
+static int cpu_topology_postload(void *opaque, int version_id)
+{
+    S390TopologyNode *node = opaque;
+
+    if (node->topology_needed != s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        return -EINVAL;
+    }
+
+    return s390_cpu_topology_mtcr_set(node->mtcr);
+}
+
+static int cpu_topology_presave(void *opaque)
+{
+    S390TopologyNode *node = opaque;
+
+    node->topology_needed = s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
+    node->mtcr =  s390_cpu_topology_mtcr_get();
+    return 1;
+}
+
+static bool cpu_topology_needed(void *opaque)
+{
+    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
+}
+
+
+const VMStateDescription vmstate_cpu_topology = {
+    .name = "cpu_topology",
+    .version_id = 1,
+    .pre_save = cpu_topology_presave,
+    .post_load = cpu_topology_postload,
+    .minimum_version_id = 1,
+    .needed = cpu_topology_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_BOOL(mtcr, S390TopologyNode),
+        VMSTATE_BOOL(topology_needed, S390TopologyNode),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static void node_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
@@ -682,6 +724,7 @@ static void node_class_init(ObjectClass *oc, void *data)
     dc->realize = s390_node_device_realize;
     dc->desc = "topology node";
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo node_info = {
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index ba0b1c1d7a..bd94a41135 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -84,6 +84,8 @@ struct S390TopologyNode {
     BusState *bus;
     uint8_t node_id;
     int cnt;
+    bool mtcr;
+    bool topology_needed;
 };
 typedef struct S390TopologyNode S390TopologyNode;
 OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyNode, S390_TOPOLOGY_NODE)
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 793e72c81a..0b697f3021 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -827,6 +827,8 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_mtr_reset(void);
+int s390_cpu_topology_mtcr_set(uint16_t mtcr);
+bool s390_cpu_topology_mtcr_get(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 1a562d2801..adf001debb 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -253,6 +253,7 @@ bool s390_has_feat(S390Feat feat)
         case S390_FEAT_SIE_CMMA:
         case S390_FEAT_SIE_PFMFI:
         case S390_FEAT_SIE_IBS:
+        case S390_FEAT_CONFIGURATION_TOPOLOGY:
             return false;
             break;
         default:
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 277f8d37cf..e9aa689da7 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -63,6 +63,8 @@
     }                                         \
 } while (0)
 
+#include "qemu/error-report.h"
+
 #define kvm_vm_check_mem_attr(s, attr) \
     kvm_vm_check_attr(s, KVM_S390_VM_MEM_CTRL, attr)
 
@@ -2607,13 +2609,47 @@ static void kvm_s390_set_mtr(uint64_t attr)
     }
 }
 
-static void kvm_s390_reset_mtr(void)
+int s390_cpu_topology_mtcr_set(uint16_t mtcr)
 {
     uint64_t attr = KVM_S390_VM_CPU_TOPO_MTR_CLEAR;
 
+    attr = mtcr ? KVM_S390_VM_CPU_TOPO_MTR_SET :
+                  KVM_S390_VM_CPU_TOPO_MTR_CLEAR;
+
     if (kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, attr)) {
             kvm_s390_set_mtr(attr);
     }
+
+    return 0;
+}
+
+bool s390_cpu_topology_mtcr_get(void)
+{
+    struct kvm_s390_cpu_topology topology;
+    struct kvm_device_attr attribute = {
+        .group = KVM_S390_VM_CPU_TOPOLOGY,
+        .addr = (uint64_t)&topology,
+    };
+    int ret;
+
+    if (!kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, 0)) {
+        return -ENODEV;
+    }
+
+    ret = kvm_vm_ioctl(kvm_state, KVM_GET_DEVICE_ATTR, &attribute);
+    if (ret) {
+        error_report("Failed to get cpu topology");
+        return false;
+    }
+    return !!topology.mtcr;
+}
+
+static void kvm_s390_reset_mtr(void)
+{
+    if (kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY,
+                          KVM_S390_VM_CPU_TOPO_MTR_CLEAR)) {
+            kvm_s390_set_mtr(KVM_S390_VM_CPU_TOPO_MTR_CLEAR);
+    }
 }
 
 void kvm_s390_cpu_topology_reset(void)
-- 
2.31.1

