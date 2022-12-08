Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A819B646C23
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiLHJpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiLHJo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:44:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564997061A
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 01:44:55 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B89h8hT030168;
        Thu, 8 Dec 2022 09:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S9MtH+bP97hDKsTxBpwY7AWGyysFbg1Gj9dPqllDCj8=;
 b=KNONbU4SbsJxCOG91z8ckrY5EXdC4t8Uh2ppkeTfMS15EgLX6LK4v04dNfbGwW0IZoGO
 jn9uYEBTHce6NOAiu7cv8mpYqubt7ykHCD/Fbzmikuu/T1XBv2YXR1xN+f760gbeT/jU
 MUPdMlvs/hbTGptdpiNMPEJ/8niY6g4b3oLVAIkGCH3c0SFWjVGnWlVXD58cXEAcbE01
 XlHOjQTOIcS55kxCiVTJbDdVHbbIIKXBMjB7An+mje1mH0FFGrpZ7wrKxBR3FRav3Ykl
 gG3FTa86IBmoQNOOlg/GFERs6uV+3WUOujfZ6JOLZmA1cGbNpkYBxrSTwg7LfNeysREo ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhq00nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B89iedt002642;
        Thu, 8 Dec 2022 09:44:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhq00mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B88tiMB016423;
        Thu, 8 Dec 2022 09:44:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y46aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B89iY0Y23986502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 09:44:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFE1720040;
        Thu,  8 Dec 2022 09:44:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB122004B;
        Thu,  8 Dec 2022 09:44:33 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 09:44:33 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v13 1/7] s390x/cpu topology: Creating CPU topology device
Date:   Thu,  8 Dec 2022 10:44:26 +0100
Message-Id: <20221208094432.9732-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Le--2uoos67mM5RlHsMcnf2bR3RjxhuZ
X-Proofpoint-GUID: RGNKwkKQ-ueYWbo8vv3z_xswdbKSS3WF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080077
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
 include/hw/s390x/cpu-topology.h |  44 ++++++++++
 hw/s390x/cpu-topology.c         | 149 ++++++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c      |   6 ++
 hw/s390x/meson.build            |   1 +
 4 files changed, 200 insertions(+)
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..6c3d2d080f
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
+#include "hw/sysbus.h"
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
+void s390_init_topology(MachineState *machine, Error **errp);
+bool s390_has_topology(void);
+S390Topology *s390_get_topology(void);
+
+#endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..b3e59873f6
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,149 @@
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
+#include "hw/qdev-properties.h"
+#include "hw/boards.h"
+#include "qemu/typedefs.h"
+#include "target/s390x/cpu.h"
+#include "hw/s390x/s390-virtio-ccw.h"
+#include "hw/s390x/cpu-topology.h"
+
+/**
+ * s390_has_topology
+ *
+ * Return false until the commit activating the topology is
+ * commited.
+ */
+bool s390_has_topology(void)
+{
+    return false;
+}
+
+/**
+ * s390_get_topology
+ *
+ * Returns a pointer to the topology.
+ *
+ * This function is called when we know the topology exist.
+ * Testing if the topology exist is done with s390_has_topology()
+ */
+S390Topology *s390_get_topology(void)
+{
+    static S390Topology *s390Topology;
+
+    if (!s390Topology) {
+        s390Topology = S390_CPU_TOPOLOGY(
+            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
+    }
+
+    assert(s390Topology);
+
+    return s390Topology;
+}
+
+/**
+ * s390_init_topology
+ * @machine: The Machine state, used to retrieve the SMP parameters
+ * @errp: the error pointer in case of problem
+ *
+ * This function creates and initialize the S390Topology with
+ * the QEMU -smp parameters we will use during adding cores to the
+ * topology.
+ */
+void s390_init_topology(MachineState *machine, Error **errp)
+{
+    DeviceState *dev;
+
+    if (machine->smp.threads > 1) {
+        error_setg(errp, "CPU Topology do not support multithreading");
+        return;
+    }
+
+    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
+
+    object_property_add_child(&machine->parent_obj,
+                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
+    object_property_set_int(OBJECT(dev), "num-cores",
+                            machine->smp.cores, errp);
+    object_property_set_int(OBJECT(dev), "num-sockets",
+                            machine->smp.sockets, errp);
+
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
+}
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
index 2e64ffab45..8971ffb871 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -44,6 +44,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -255,6 +256,11 @@ static void ccw_init(MachineState *machine)
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
 
+    /* Need CPU model to be determined before we can set up topology */
+    if (s390_has_topology()) {
+        s390_init_topology(machine, &error_fatal);
+    }
+
     /* Need CPU model to be determined before we can set up PV */
     s390_pv_init(machine->cgs, &error_fatal);
 
diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index f291016fee..58dfbdff4f 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -24,6 +24,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
   's390-stattrib-kvm.c',
   'pv.c',
   's390-pci-kvm.c',
+  'cpu-topology.c',
 ))
 s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
   'tod-tcg.c',
-- 
2.31.1

