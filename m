Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33E3551F26
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343691AbiFTOkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245178AbiFTOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1AB9585
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:50 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KDueTE002836;
        Mon, 20 Jun 2022 13:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pmruLiCT7e8VOWqJPP9lMjJ9ScQTZQpfnWgo06cTogw=;
 b=owC/d4mgXYdduYZlY2J73DRe6FE0bbh16LphUmoBzzkTKJNJUwPdjQY9wK3fPP3V2rwH
 lwpTKEy8QPYrZH6LJZgDuMe4VE1ia8q03bXCPqUhqV1S7ELzyJVnJeeobleRoLwGvxzo
 qiZF/IdCu6QFRiDZzQ9lzy9m2aIuITgY5+OWsGXv0mhDS0jhsXNYhqko4UQkehsdJ3P9
 WfNasJ0wH09YKRenN59VDqj+LePKOOOg2NBFAdgY+GIwKS/oUKaSzwwjyxoXawf2Ccma
 DazPljCN6OVV/poa06fSB/BKe/G2LRsAwxIjmXOpAQLxNhV7dzZwv70x4J/rl9LY2eKL aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr1asbrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KDwSlI017287;
        Mon, 20 Jun 2022 13:59:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr1asbqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpOOL023580;
        Mon, 20 Jun 2022 13:59:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gs6b8tkng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxdAc12190176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B74CB11C04C;
        Mon, 20 Jun 2022 13:59:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8C0211C050;
        Mon, 20 Jun 2022 13:59:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 10/12] s390x/cpu_topology: resetting the Topology-Change-Report
Date:   Mon, 20 Jun 2022 16:03:50 +0200
Message-Id: <20220620140352.39398-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y5Vj8XfE-XM3jQNlf46rBM7gnkVyCeuE
X-Proofpoint-GUID: aFl9gLy3VL9XraGjz1YC7R0K3g_oFggg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During a subsystem reset the Topology-Change-Report is cleared.
Let's ask KVM to clear the MTCR in the case of a subsystem reset.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c      |  6 ++++++
 hw/s390x/s390-virtio-ccw.c   |  1 +
 target/s390x/cpu-sysemu.c    |  7 +++++++
 target/s390x/cpu.h           |  1 +
 target/s390x/kvm/kvm.c       | 30 ++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm_s390x.h |  2 ++
 6 files changed, 47 insertions(+)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 2dbb42ee2b..ba12cafaf7 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -667,6 +667,11 @@ static void s390_node_device_realize(DeviceState *dev, Error **errp)
     qbus_set_hotplug_handler(bus, OBJECT(dev));
 }
 
+static void s390_topology_reset(DeviceState *dev)
+{
+    s390_cpu_topology_mtr_reset();
+}
+
 static void node_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
@@ -676,6 +681,7 @@ static void node_class_init(ObjectClass *oc, void *data)
     set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
     dc->realize = s390_node_device_realize;
     dc->desc = "topology node";
+    dc->reset = s390_topology_reset;
 }
 
 static const TypeInfo node_info = {
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 5c0dbff6fd..0b30633ed5 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -122,6 +122,7 @@ static const char *const reset_dev_types[] = {
     "s390-flic",
     "diag288",
     TYPE_S390_PCI_HOST_BRIDGE,
+    TYPE_S390_TOPOLOGY_NODE,
 };
 
 static void subsystem_reset(void)
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 948e4bd3e0..11d0d87301 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -306,3 +306,10 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg)
         kvm_s390_set_diag318(cs, arg.host_ulong);
     }
 }
+
+void s390_cpu_topology_mtr_reset(void)
+{
+    if (kvm_enabled()) {
+        kvm_s390_cpu_topology_reset();
+    }
+}
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 9d48087b71..793e72c81a 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -826,6 +826,7 @@ void s390_enable_css_support(S390CPU *cpu);
 void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
+void s390_cpu_topology_mtr_reset(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index c664c45e8a..277f8d37cf 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2592,3 +2592,33 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+static void kvm_s390_set_mtr(uint64_t attr)
+{
+    struct kvm_device_attr attribute = {
+        .group = KVM_S390_VM_CPU_TOPOLOGY,
+        .attr  = attr,
+    };
+    int ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
+
+    if (ret) {
+        error_report("Failed to set cpu topology attribute %lu: %s",
+                     attr, strerror(-ret));
+    }
+}
+
+static void kvm_s390_reset_mtr(void)
+{
+    uint64_t attr = KVM_S390_VM_CPU_TOPO_MTR_CLEAR;
+
+    if (kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, attr)) {
+            kvm_s390_set_mtr(attr);
+    }
+}
+
+void kvm_s390_cpu_topology_reset(void)
+{
+    if (s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        kvm_s390_reset_mtr();
+    }
+}
diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
index 05a5e1e6f4..d717c05827 100644
--- a/target/s390x/kvm/kvm_s390x.h
+++ b/target/s390x/kvm/kvm_s390x.h
@@ -46,4 +46,6 @@ void kvm_s390_restart_interrupt(S390CPU *cpu);
 void kvm_s390_stop_interrupt(S390CPU *cpu);
 void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
 
+void kvm_s390_cpu_topology_reset(void);
+
 #endif /* KVM_S390X_H */
-- 
2.31.1

