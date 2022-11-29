Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E418863C68D
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiK2Rmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiK2Rm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:42:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076B24A9FA
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:42:28 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATGx6xN007810;
        Tue, 29 Nov 2022 17:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NZma6QDvoIn7Ehk6HFkS1Dkzhlaf/5zDgGiklZB8KN0=;
 b=PAjPxC35HKnXzPoXJJOnW+/0Bm4cheulRUgfPrVzpNTTTk1EdZVXiEJ6OxQiinwrX4rJ
 cae9F6AKgfIMWkznvi3QOdkgG5WqX8SxOcGSwFu1RREfn+6hCXV99fgfiWyh3sjajxaT
 UvND1QYAndlLm8jIw3BZ+9l2+OcsmmJrcaGfBwnKL2zUq/E30s1vKmpDNfpYgRBvxH+A
 HOczuQsRXRxUnkjMNxGgSxN68aUtOHnytS/0aNqDKEwAB6oFOXAg4R0hykIXhifg6gPJ
 qxW5iM+PfpgRKnZ82qEagNlKl46Tm/Wkmd/MfQ/BzmBxyDvatKQfO9LmZ9xIhw0VW5b1 Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5nb3aswa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:15 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATGx5mR007637;
        Tue, 29 Nov 2022 17:42:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5nb3asvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATHaEsx012308;
        Tue, 29 Nov 2022 17:42:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hvfv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATHgqEs2491034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 17:42:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB4B8A404D;
        Tue, 29 Nov 2022 17:42:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A73D6A4040;
        Tue, 29 Nov 2022 17:42:08 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.89.107])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 17:42:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
Date:   Tue, 29 Nov 2022 18:42:00 +0100
Message-Id: <20221129174206.84882-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221129174206.84882-1-pmorel@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 876uLa8-CuKmeE2pyKbZ-YbwrMtzbFDm
X-Proofpoint-ORIG-GUID: 7IB82V2HkOTp2H3pDFcw-PLtIVUKl35B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_10,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1011 malwarescore=0 adultscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211290097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will need a Topology device to transfer the topology
during migration and to implement machine reset.

The device creation is fenced by s390_has_topology().

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 hw/s390x/cpu-topology.c            | 87 ++++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
 hw/s390x/meson.build               |  1 +
 5 files changed, 158 insertions(+)
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..e88059ccec
--- /dev/null
+++ b/include/hw/s390x/cpu-topology.h
@@ -0,0 +1,44 @@
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
+#define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
+#define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
+#define S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM 0x02
+#define S390_TOPOLOGY_POLARITY_VERTICAL_HIGH   0x03
+
+typedef struct S390TopoSocket {
+    int active_count;
+    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
+} S390TopoSocket;
+
+struct S390Topology {
+    SysBusDevice parent_obj;
+    uint32_t num_cores;
+    uint32_t num_sockets;
+    S390TopoSocket *socket;
+};
+
+#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
+OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
+
+static inline bool s390_has_topology(void)
+{
+    return false;
+}
+
+#endif
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 9bba21a916..47ce0aa6fa 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -28,6 +28,7 @@ struct S390CcwMachineState {
     bool dea_key_wrap;
     bool pv;
     uint8_t loadparm[8];
+    DeviceState *topology;
 };
 
 struct S390CcwMachineClass {
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..bbf97cd66a
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,87 @@
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
+/**
+ * s390_topology_realize:
+ * @dev: the device state
+ *
+ * We free the socket array allocated in realize.
+ */
+static void s390_topology_unrealize(DeviceState *dev)
+{
+    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
+
+    g_free(topo->socket);
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
+    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
+
+    topo->socket = g_new0(S390TopoSocket, topo->num_sockets);
+}
+
+static Property s390_topology_properties[] = {
+    DEFINE_PROP_UINT32("num-cores", S390Topology, num_cores, 1),
+    DEFINE_PROP_UINT32("num-sockets", S390Topology, num_sockets, 1),
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
+    dc->unrealize = s390_topology_unrealize;
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
index 2e64ffab45..973bbdd36e 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -44,6 +44,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -102,6 +103,24 @@ static void s390_init_cpus(MachineState *machine)
     }
 }
 
+static DeviceState *s390_init_topology(MachineState *machine, Error **errp)
+{
+    DeviceState *dev;
+
+    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
+
+    object_property_add_child(&machine->parent_obj,
+                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
+    object_property_set_int(OBJECT(dev), "num-cores",
+                            machine->smp.cores * machine->smp.threads, errp);
+    object_property_set_int(OBJECT(dev), "num-sockets",
+                            machine->smp.sockets, errp);
+
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
+
+    return dev;
+}
+
 static const char *const reset_dev_types[] = {
     TYPE_VIRTUAL_CSS_BRIDGE,
     "s390-sclp-event-facility",
@@ -255,6 +274,12 @@ static void ccw_init(MachineState *machine)
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
 
+    /* Need CPU model to be determined before we can set up topology */
+    if (s390_has_topology()) {
+        S390_CCW_MACHINE(machine)->topology = s390_init_topology(machine,
+                                                                 &error_fatal);
+    }
+
     /* Need CPU model to be determined before we can set up PV */
     s390_pv_init(machine->cgs, &error_fatal);
 
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

