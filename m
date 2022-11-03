Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CD2618594
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiKCRCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiKCRCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8401B1143
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:09 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FcVWa028024;
        Thu, 3 Nov 2022 17:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5uxNJYFVYByC09/7G1cT9qi/4LLn9gAL2GEO1aJwUtI=;
 b=cK2+3Qo5VNngqv51OFniZ4wK1yJklv8jmDmMwO4Twdlhf4hIf2UGl110FbdvgPvZbPC3
 Z+M3P7+itmEPffT/YOEVcEB8zfgXc+gJIcHw2PAh0HMksE/KMkwUNEsMwYHSotrwVjrt
 ommnsrJWIBngSF+7QJ1YmWAunj+YulSNF/G6xLBLeCBFeLrl4RD/9501cKzu2bKMDdrY
 CCJdw+AH6A6aZclm+MVngD+pagY5bzALRnjpUbQ4xdblPQNInQouGFAi61IerHpG5Owu
 8t4SQtQZLaWiWtwVjGN3FH6mfNRl3CDr9+bK/A9F4NOOWCyEO4lkaaOu1Aur7J8AzWTs 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmeuwfx0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3FeRXw005114;
        Thu, 3 Nov 2022 17:01:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmeuwfwxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:59 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3Gvfni015784;
        Thu, 3 Nov 2022 17:01:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3kme3487u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3H1rAg918172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 17:01:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E423B5204E;
        Thu,  3 Nov 2022 17:01:52 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B3595204F;
        Thu,  3 Nov 2022 17:01:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v11 03/11] s390x/cpu topology: core_id sets s390x CPU topology
Date:   Thu,  3 Nov 2022 18:01:42 +0100
Message-Id: <20221103170150.20789-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c39kduDR8uRjKwGWa_844uTDViw3xhKo
X-Proofpoint-ORIG-GUID: ET3IS1p7cCgne1tSSKRAzxBootTVKE_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the S390x CPU topology the core_id specifies the CPU address
and the position of the core withing the topology.

Let's build the topology based on the core_id.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h    |  41 ++++++++++
 include/hw/s390x/s390-virtio-ccw.h |   1 +
 target/s390x/cpu.h                 |   2 +
 hw/s390x/cpu-topology.c            | 125 +++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         |  23 ++++++
 hw/s390x/meson.build               |   1 +
 6 files changed, 193 insertions(+)
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..4e16a2153d
--- /dev/null
+++ b/include/hw/s390x/cpu-topology.h
@@ -0,0 +1,41 @@
+/*
+ * CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+#ifndef HW_S390X_CPU_TOPOLOGY_H
+#define HW_S390X_CPU_TOPOLOGY_H
+
+#include "hw/qdev-core.h"
+#include "qom/object.h"
+
+#define S390_TOPOLOGY_CPU_IFL 0x03
+#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
+
+typedef struct S390TopoSocket {
+    int active_count;
+    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
+} S390TopoSocket;
+
+struct S390Topology {
+    SysBusDevice parent_obj;
+    uint32_t nr_cpus;
+    uint32_t nr_sockets;
+    S390TopoSocket *socket;
+};
+
+#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
+OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
+
+void s390_topology_new_cpu(S390CPU *cpu);
+
+static inline bool s390_has_topology(void)
+{
+    return false;
+}
+
+#endif
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 4f8a39abda..23b472708d 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -29,6 +29,7 @@ struct S390CcwMachineState {
     bool pv;
     bool zpcii_disable;
     uint8_t loadparm[8];
+    void *topology;
 };
 
 struct S390CcwMachineClass {
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 7d6d01325b..c9066b2496 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -175,6 +175,8 @@ struct ArchCPU {
     /* needed for live migration */
     void *irqstate;
     uint32_t irqstate_saved_size;
+    /* Topology this CPU belongs too */
+    void *topology;
 };
 
 
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..6af41d3d7b
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,125 @@
+/*
+ * CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "hw/sysbus.h"
+#include "hw/qdev-properties.h"
+#include "hw/boards.h"
+#include "qemu/typedefs.h"
+#include "target/s390x/cpu.h"
+#include "hw/s390x/s390-virtio-ccw.h"
+#include "hw/s390x/cpu-topology.h"
+
+/*
+ * s390_topology_new_cpu:
+ * @cpu: a pointer to the new CPU
+ *
+ * The topology pointed by S390CPU, gives us the CPU topology
+ * established by the -smp QEMU aruments.
+ * The core-id is used to calculate the position of the CPU inside
+ * the topology:
+ *  - the socket, container TLE, containing the CPU, we have one socket
+ *    for every nr_cpus (nr_cpus = smp.cores * smp.threads)
+ *  - the CPU TLE inside the socket, we have potentionly up to 4 CPU TLE
+ *    in a container TLE with the assumption that all CPU are identical
+ *    with the same polarity and entitlement because we have maximum 256
+ *    CPUs and each TLE can hold up to 64 identical CPUs.
+ *  - the bit in the 64 bit CPU TLE core mask
+ */
+void s390_topology_new_cpu(S390CPU *cpu)
+{
+    S390Topology *topo = (S390Topology *)cpu->topology;
+    int core_id = cpu->env.core_id;
+    int bit, origin;
+    int socket_id;
+
+    socket_id = core_id / topo->nr_cpus;
+
+    /*
+     * At the core level, each CPU is represented by a bit in a 64bit
+     * uint64_t which represent the presence of a CPU.
+     * The firmware assume that all CPU in a CPU TLE have the same
+     * type, polarization and are all dedicated or shared.
+     * In that case the origin variable represents the offset of the first
+     * CPU in the CPU container.
+     * More than 64 CPUs per socket are represented in several CPU containers
+     * inside the socket container.
+     * The only reason to have several S390TopologyCores inside a socket is
+     * to have more than 64 CPUs.
+     * In that case the origin variable represents the offset of the first CPU
+     * in the CPU container. More than 64 CPUs per socket are represented in
+     * several CPU containers inside the socket container.
+     */
+    bit = core_id;
+    origin = bit / 64;
+    bit %= 64;
+    bit = 63 - bit;
+
+    topo->socket[socket_id].active_count++;
+    set_bit(bit, &topo->socket[socket_id].mask[origin]);
+}
+
+/**
+ * s390_topology_realize:
+ * @dev: the device state
+ * @errp: the error pointer (not used)
+ *
+ * During realize the machine CPU topology is initialized with the
+ * QEMU -smp parameters.
+ * The maximum count of CPU TLE in the all Topology can not be greater
+ * than the maximum CPUs.
+ */
+static void s390_topology_realize(DeviceState *dev, Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
+
+    topo->nr_cpus = ms->smp.cores * ms->smp.threads;
+    topo->nr_sockets = ms->smp.sockets;
+    topo->socket = g_new0(S390TopoSocket, topo->nr_sockets);
+}
+
+static Property s390_topology_properties[] = {
+    DEFINE_PROP_UINT32("nr_cpus", S390Topology, nr_cpus, 1),
+    DEFINE_PROP_UINT32("nr_sockets", S390Topology, nr_sockets, 1),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+/**
+ * topology_class_init:
+ * @oc: Object class
+ * @data: (not used)
+ *
+ * A very simple object we will need for reset and migration.
+ */
+static void topology_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+
+    dc->realize = s390_topology_realize;
+    device_class_set_props(dc, s390_topology_properties);
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+}
+
+static const TypeInfo cpu_topology_info = {
+    .name          = TYPE_S390_CPU_TOPOLOGY,
+    .parent        = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(S390Topology),
+    .class_init    = topology_class_init,
+};
+
+static void topology_register(void)
+{
+    type_register_static(&cpu_topology_info);
+}
+type_init(topology_register);
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 9ab91df5b1..5776d3e58f 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -44,6 +44,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -102,6 +103,19 @@ static void s390_init_cpus(MachineState *machine)
     }
 }
 
+static void s390_init_topology(MachineState *machine)
+{
+    DeviceState *dev;
+
+    if (s390_has_topology()) {
+        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
+        object_property_add_child(&machine->parent_obj,
+                                  TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+        S390_CCW_MACHINE(machine)->topology = dev;
+    }
+}
+
 static const char *const reset_dev_types[] = {
     TYPE_VIRTUAL_CSS_BRIDGE,
     "s390-sclp-event-facility",
@@ -252,6 +266,9 @@ static void ccw_init(MachineState *machine)
     /* init memory + setup max page size. Required for the CPU model */
     s390_memory_init(machine->ram);
 
+    /* Adding the topology must be done before CPU initialization */
+    s390_init_topology(machine);
+
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
 
@@ -314,6 +331,12 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    /* Inserting the CPU in the Topology can not fail */
+    if (S390_CCW_MACHINE(ms)->topology) {
+        cpu->topology = S390_CCW_MACHINE(ms)->topology;
+        s390_topology_new_cpu(cpu);
+    }
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index f291016fee..653f6ab488 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -2,6 +2,7 @@ s390x_ss = ss.source_set()
 s390x_ss.add(files(
   'ap-bridge.c',
   'ap-device.c',
+  'cpu-topology.c',
   'ccw-device.c',
   'css-bridge.c',
   'css.c',
-- 
2.31.1

