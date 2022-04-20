Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB750877C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378309AbiDTL54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378329AbiDTL5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391E619C0A
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:57 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KAGppw003094;
        Wed, 20 Apr 2022 11:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uHpvuv2lnH6LB5X1L3ZgQ/KaGVnUnhq24y8rWrsIO/4=;
 b=lWp188EIselole2Hth86NwBXBefus38tL+7EQ/H/WCxI4SjRDM2wXcYDAkicVCpEhLRu
 yr1LyRrfXWqMrtzn4fJN4nyO0mhxxBDhHjPKdtoHZueSl2FRH/QfC6g/GIEVv1eK1E2+
 jyRXeLkZAAuin3gbuhQvqFes86c7AWRAS7DOzsS00OmD8aN3D0TuRNxPIpAEo/fBwiyv
 kuGw+4g8p+RXh6FhJQWtG1tiUK9UJYMTpr5dM28rGsP/PyrdeURHSCYXMHlXe/8iA/ek
 /FF68BGoSOil/JAX6qrG+2GFnbC83BeSRjg5tVJ16FCkafngTn62RgKDR953rx5rJdSd sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdxama-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBTTaU019398;
        Wed, 20 Apr 2022 11:54:47 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdxakw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBr2KL011939;
        Wed, 20 Apr 2022 11:54:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne968gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBsfBp51904782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:54:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE306AE059;
        Wed, 20 Apr 2022 11:54:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC66AE045;
        Wed, 20 Apr 2022 11:54:40 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:40 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 12/13] s390x: CPU topology: CPU topology migration
Date:   Wed, 20 Apr 2022 13:57:44 +0200
Message-Id: <20220420115745.13696-13-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fahDvqmfAXM7WQ-bAVMZh5BdgVXEcN6m
X-Proofpoint-ORIG-GUID: 61nZhb9qFutBObeSOxHZhUnShaW_xJsQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 hw/s390x/cpu-topology.c         | 42 ++++++++++++++++++++++++++++++++
 include/hw/s390x/cpu-topology.h |  2 ++
 target/s390x/cpu.h              |  2 ++
 target/s390x/cpu_models.c       |  1 +
 target/s390x/kvm/kvm.c          | 43 ++++++++++++++++++++++++++++++---
 5 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index a4e9840cc0..4626af7f81 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,8 @@
 #include "qemu/typedefs.h"
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
+#include "migration/vmstate.h"
+#include "qemu/error-report.h"
 
 static S390TopologyCores *s390_create_cores(S390TopologySocket *socket,
                                             int origin)
@@ -566,6 +568,45 @@ static void s390_topology_reset(DeviceState *dev)
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
+    return s390_cpu_topology_mtcr_get(&node->mtcr);
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
+        VMSTATE_UINT16(mtcr, S390TopologyNode),
+        VMSTATE_BOOL(topology_needed, S390TopologyNode),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static void node_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
@@ -576,6 +617,7 @@ static void node_class_init(ObjectClass *oc, void *data)
     dc->realize = s390_node_device_realize;
     dc->desc = "topology node";
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo node_info = {
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 10e4bd754f..49e4bd3a8d 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -84,6 +84,8 @@ struct S390TopologyNode {
     BusState *bus;
     uint8_t node_id;
     int cnt;
+    uint16_t mtcr;
+    bool topology_needed;
 };
 typedef struct S390TopologyNode S390TopologyNode;
 OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyNode, S390_TOPOLOGY_NODE)
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 61a71a7807..fe731783a0 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -826,6 +826,8 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_mtr_reset(void);
+int s390_cpu_topology_mtcr_set(uint16_t mtcr);
+int s390_cpu_topology_mtcr_get(uint16_t *mtcr);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 6d71428056..4947196bcb 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -254,6 +254,7 @@ bool s390_has_feat(S390Feat feat)
         case S390_FEAT_SIE_CMMA:
         case S390_FEAT_SIE_PFMFI:
         case S390_FEAT_SIE_IBS:
+        case S390_FEAT_CONFIGURATION_TOPOLOGY:
             return false;
             break;
         default:
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index f3924633c6..17f426864b 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -64,6 +64,8 @@
     }                                         \
 } while (0)
 
+#include "qemu/error-report.h"
+
 #define kvm_vm_check_mem_attr(s, attr) \
     kvm_vm_check_attr(s, KVM_S390_VM_MEM_CTRL, attr)
 
@@ -2592,22 +2594,57 @@ static void kvm_s390_set_mtr(uint64_t attr)
         .group = KVM_S390_VM_CPU_TOPOLOGY,
         .attr  = attr,
     };
+    int ret;
 
-    int ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
-
+    ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
     if (ret) {
         error_report("Failed to set cpu topology attribute %lu: %s",
                      attr, strerror(-ret));
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
+int s390_cpu_topology_mtcr_get(uint16_t *mtcr)
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
+        return ret;
+    }
+    *mtcr = topology.mtcr;
+    return 0;
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
2.27.0

