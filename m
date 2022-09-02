Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4452A5AA934
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiIBH4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbiIBH4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3A32D97
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:53 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827Q4PR011602;
        Fri, 2 Sep 2022 07:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yPEMz3crbtUbslnZwBMiyYIfghDJekErggppLjsR4B4=;
 b=hExj/0dFDtN0YXyvAFcYWmEkymcV5aYC4g2QK1kVShaVuET7Sy23Ey8rbuRcCJBfL7r5
 Qo/K0tjBIMkf6X8NgrAGTAdBEfg0CVbY3Zmos8guuLGbzWrdG4wQsNXTKCqilpImQODt
 Hs42BbSwc7RKkAs4WiH5oPxfF/o47ElH0bQFPXsrqo8X2Ec3T1WgryQijRUG6P/0/p6g
 Ym3owVyTEtfnB0bTqtLGKXLAP/YnZhP2XfPPXbQba/lUWnBher2uf5zazDfsM4SljKyj
 F+/AtHbhP+0HFBYiair2OtuAlTwqwe45D2oORl6hkjZLInxx60qOcUD6dcU5k7Hf06+i jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmuth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2827kt8h027722;
        Fri, 2 Sep 2022 07:55:40 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmusm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:40 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827pxfF017369;
        Fri, 2 Sep 2022 07:55:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3j7aw9drnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827tvN145220124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:55:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CA5E11C04C;
        Fri,  2 Sep 2022 07:55:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3443411C04A;
        Fri,  2 Sep 2022 07:55:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU topology
Date:   Fri,  2 Sep 2022 09:55:23 +0200
Message-Id: <20220902075531.188916-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J7_nZLbxsVM6RbRAUVNaDipQVoPoW57O
X-Proofpoint-ORIG-GUID: L_m3vNDPGzygN8GDplqOmLLMYyJIDMWb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 hw/s390x/cpu-topology.c         | 135 ++++++++++++++++++++++++++++++++
 hw/s390x/meson.build            |   1 +
 hw/s390x/s390-virtio-ccw.c      |  10 +++
 include/hw/s390x/cpu-topology.h |  42 ++++++++++
 4 files changed, 188 insertions(+)
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..a6ca006ec5
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,135 @@
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
+S390Topology *s390_get_topology(void)
+{
+    static S390Topology *s390Topology;
+
+    if (!s390Topology) {
+        s390Topology = S390_CPU_TOPOLOGY(
+            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
+    }
+
+    return s390Topology;
+}
+
+/*
+ * s390_topology_new_cpu:
+ * @core_id: the core ID is machine wide
+ *
+ * The topology returned by s390_get_topology(), gives us the CPU
+ * topology established by the -smp QEMU aruments.
+ * The core-id gives:
+ *  - the Container TLE (Topology List Entry) containing the CPU TLE.
+ *  - in the CPU TLE the origin, or offset of the first bit in the core mask
+ *  - the bit in the CPU TLE core mask
+ */
+void s390_topology_new_cpu(int core_id)
+{
+    S390Topology *topo = s390_get_topology();
+    int socket_id;
+    int bit, origin;
+
+    /* In the case no Topology is used nothing is to be done here */
+    if (!topo) {
+        return;
+    }
+
+    socket_id = core_id / topo->cores;
+
+    bit = core_id;
+    origin = bit / 64;
+    bit %= 64;
+    bit = 63 - bit;
+
+    /*
+     * At the core level, each CPU is represented by a bit in a 64bit
+     * unsigned long. Set on plug and clear on unplug of a CPU.
+     * The firmware assume that all CPU in a CPU TLE have the same
+     * type, polarization and are all dedicated or shared.
+     * In the case a socket contains CPU with different type, polarization
+     * or entitlement then they will be defined in different CPU containers.
+     * Currently we assume all CPU are identical IFL CPUs and that they are
+     * all dedicated CPUs.
+     * The only reason to have several S390TopologyCores inside a socket is
+     * to have more than 64 CPUs.
+     * In that case the origin field, representing the offset of the first CPU
+     * in the CPU container allows to represent up to the maximal number of
+     * CPU inside several CPU containers inside the socket container.
+     */
+    topo->socket[socket_id].active_count++;
+    topo->tle[socket_id].active_count++;
+    set_bit(bit, &topo->tle[socket_id].mask[origin]);
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
+    int n;
+
+    topo->sockets = ms->smp.sockets;
+    topo->cores = ms->smp.cores;
+    topo->tles = ms->smp.max_cpus;
+
+    n = topo->sockets;
+    topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
+    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
+}
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
diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index de28a90a57..96d7d7d231 100644
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
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index b5ca154e2f..15cefd104b 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -43,6 +43,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -247,6 +248,12 @@ static void ccw_init(MachineState *machine)
     /* init memory + setup max page size. Required for the CPU model */
     s390_memory_init(machine->ram);
 
+    /* Adding the topology must be done before CPU intialization*/
+    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
+    object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,
+                              OBJECT(dev));
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
 
@@ -309,6 +316,9 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    /* Inserting the CPU in the Topology can not fail */
+    s390_topology_new_cpu(cpu->env.core_id);
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..6911f975f4
--- /dev/null
+++ b/include/hw/s390x/cpu-topology.h
@@ -0,0 +1,42 @@
+/*
+ * CPU Topology
+ *
+ * Copyright 2022 IBM Corp.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+#ifndef HW_S390X_CPU_TOPOLOGY_H
+#define HW_S390X_CPU_TOPOLOGY_H
+
+typedef struct S390TopoContainer {
+    int active_count;
+} S390TopoContainer;
+
+#define S390_TOPOLOGY_MAX_ORIGIN (1 + S390_MAX_CPUS / 64)
+typedef struct S390TopoTLE {
+    int active_count;
+    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
+} S390TopoTLE;
+
+#include "hw/qdev-core.h"
+#include "qom/object.h"
+
+struct S390Topology {
+    SysBusDevice parent_obj;
+    int sockets;
+    int cores;
+    int tles;
+    S390TopoContainer *socket;
+    S390TopoTLE *tle;
+};
+typedef struct S390Topology S390Topology;
+
+#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
+OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
+
+S390Topology *s390_get_topology(void);
+void s390_topology_new_cpu(int core_id);
+
+#endif
-- 
2.31.1

