Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775546D4DB3
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjDCQ3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjDCQ3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07E19B3
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:34 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333G8POM030453;
        Mon, 3 Apr 2023 16:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=753PPr3lyc9UCjnOgtp5rvQqchddC5LVjxnPyR91I60=;
 b=JOREyljxFPod0kzupCxjm7h/arXr8oChqKThiuClxlwoafDpGJShYuXK6fu4IJ0/RLOz
 VmIPnkoA5IHkL2pGRmvlKPJGO4xk97Uj8r+e8CAntq75dA2M1AlTdkdakQt1fnuaNa/E
 LyrC5IJBQKifTP4oeXeomF7iMMCgPYXE6/6NZPfkMgP9eqWAe8SQ+1cLBcMseV2V3N08
 xH5UgdTY4jr8zEhpfdF/YxpklpyE6ivCnAAOtlyA+CCr5PLczVuQc51vYBT1jdeoc4sQ
 /R8KMO69ryv7UnA9Pzbr7lSgRdqz1m6+KQ1N4bmNr6r8T+2MUU4ptzN5wK9JHEFSE1kO sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxerm006-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333G83vH029518;
        Mon, 3 Apr 2023 16:29:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxerkyy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3336KgFs017625;
        Mon, 3 Apr 2023 16:29:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ppc871d7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTJWp18481668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AF5D20040;
        Mon,  3 Apr 2023 16:29:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FDC62004B;
        Mon,  3 Apr 2023 16:29:18 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:18 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 02/21] s390x/cpu topology: add topology entries on CPU hotplug
Date:   Mon,  3 Apr 2023 18:28:46 +0200
Message-Id: <20230403162905.17703-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R8a7uwWS1q7JQjeJ5dUn0nt8GQai9Q19
X-Proofpoint-GUID: 1Jsf6ujZVUVEVCSvEmq1ZfppaIIrDlbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030118
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The topology information are attributes of the CPU and are
specified during the CPU device creation.

On hot plug we:
- calculate the default values for the topology for drawers,
  books and sockets in the case they are not specified.
- verify the CPU attributes
- check that we have still room on the desired socket

The possibility to insert a CPU in a mask is dependent on the
number of cores allowed in a socket, a book or a drawer, the
checking is done during the hot plug of the CPU to have an
immediate answer.

If the complete topology is not specified, the core is added
in the physical topology based on its core ID and it gets
defaults values for the modifier attributes.

This way, starting QEMU without specifying the topology can
still get some advantage of the CPU topology.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 MAINTAINERS                        |   1 +
 include/hw/s390x/cpu-topology.h    |  44 +++++
 include/hw/s390x/s390-virtio-ccw.h |   1 +
 hw/s390x/cpu-topology.c            | 282 +++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         |  22 ++-
 hw/s390x/meson.build               |   1 +
 6 files changed, 349 insertions(+), 2 deletions(-)
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9b1f80739e..bb7b34d0d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1658,6 +1658,7 @@ S390 CPU topology
 M: Pierre Morel <pmorel@linux.ibm.com>
 S: Supported
 F: include/hw/s390x/cpu-topology.h
+F: hw/s390x/cpu-topology.c
 
 X86 Machines
 ------------
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 83f31604cc..6326cfeff8 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -10,6 +10,50 @@
 #ifndef HW_S390X_CPU_TOPOLOGY_H
 #define HW_S390X_CPU_TOPOLOGY_H
 
+#ifndef CONFIG_USER_ONLY
+
+#include "qemu/queue.h"
+#include "hw/boards.h"
+#include "qapi/qapi-types-machine-target.h"
+
 #define S390_TOPOLOGY_CPU_IFL   0x03
 
+typedef struct S390Topology {
+    uint8_t *cores_per_socket;
+    CpuTopology *smp;
+} S390Topology;
+
+#ifdef CONFIG_KVM
+bool s390_has_topology(void);
+void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
+#else
+static inline bool s390_has_topology(void)
+{
+       return false;
+}
+static inline void s390_topology_setup_cpu(MachineState *ms,
+                                           S390CPU *cpu,
+                                           Error **errp) {}
+#endif
+
+extern S390Topology s390_topology;
+int s390_socket_nb(S390CPU *cpu);
+
+static inline int s390_std_socket(int n, CpuTopology *smp)
+{
+    return (n / smp->cores) % smp->sockets;
+}
+
+static inline int s390_std_book(int n, CpuTopology *smp)
+{
+    return (n / (smp->cores * smp->sockets)) % smp->books;
+}
+
+static inline int s390_std_drawer(int n, CpuTopology *smp)
+{
+    return (n / (smp->cores * smp->sockets * smp->books)) % smp->drawers;
+}
+
+#endif /* CONFIG_USER_ONLY */
+
 #endif
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 9bba21a916..ea10a6c6e1 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -28,6 +28,7 @@ struct S390CcwMachineState {
     bool dea_key_wrap;
     bool pv;
     uint8_t loadparm[8];
+    bool vertical_polarization;
 };
 
 struct S390CcwMachineClass {
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..96da67bd7e
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,282 @@
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
+/*
+ * s390_topology is used to keep the topology information.
+ * .cores_per_socket: tracks information on the count of cores
+ *                    per socket.
+ * .smp: keeps track of the machine topology.
+ *
+ */
+S390Topology s390_topology = {
+    /* will be initialized after the cpu model is realized */
+    .cores_per_socket = NULL,
+    .smp = NULL,
+};
+
+/**
+ * s390_socket_nb:
+ * @cpu: s390x CPU
+ *
+ * Returns the socket number used inside the cores_per_socket array
+ * for a cpu.
+ */
+int s390_socket_nb(S390CPU *cpu)
+{
+    return (cpu->env.drawer_id * s390_topology.smp->books + cpu->env.book_id) *
+           s390_topology.smp->sockets + cpu->env.socket_id;
+}
+
+/**
+ * s390_has_topology:
+ *
+ * Return value: if the topology is supported by the machine.
+ */
+bool s390_has_topology(void)
+{
+    return false;
+}
+
+/**
+ * s390_topology_init:
+ * @ms: the machine state where the machine topology is defined
+ *
+ * Keep track of the machine topology.
+ *
+ * Allocate an array to keep the count of cores per socket.
+ * The index of the array starts at socket 0 from book 0 and
+ * drawer 0 up to the maximum allowed by the machine topology.
+ */
+static void s390_topology_init(MachineState *ms)
+{
+    CpuTopology *smp = &ms->smp;
+
+    s390_topology.smp = smp;
+    s390_topology.cores_per_socket = g_new0(uint8_t, smp->sockets *
+                                            smp->books * smp->drawers);
+}
+
+/**
+ * s390_topology_cpu_default:
+ * @cpu: pointer to a S390CPU
+ * @errp: Error pointer
+ *
+ * Setup the default topology if no attributes are already set.
+ * Passing a CPU with some, but not all, attributes set is considered
+ * an error.
+ *
+ * The function calculates the (drawer_id, book_id, socket_id)
+ * topology by filling the cores starting from the first socket
+ * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
+ *
+ * CPU type and dedication have defaults values set in the
+ * s390x_cpu_properties, entitlement must be adjust depending on the
+ * dedication.
+ */
+static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
+{
+    CpuTopology *smp = s390_topology.smp;
+    CPUS390XState *env = &cpu->env;
+
+    /* All geometry topology attributes must be set or all unset */
+    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
+        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
+        error_setg(errp,
+                   "Please define all or none of the topology geometry attributes");
+        return;
+    }
+
+    /* Check if one of the geometry topology is unset */
+    if (env->socket_id < 0) {
+        /* Calculate default geometry topology attributes */
+        env->socket_id = s390_std_socket(env->core_id, smp);
+        env->book_id = s390_std_book(env->core_id, smp);
+        env->drawer_id = s390_std_drawer(env->core_id, smp);
+    }
+
+    /*
+     * Even the user can specify the entitlement as horizontal on the
+     * command line, qemu will only use env->entitlement during vertical
+     * polarization.
+     * Medium entitlement is chosen as the default entitlement when the CPU
+     * is not dedicated.
+     * A dedicated CPU always receives a high entitlement.
+     */
+    if (env->entitlement >= S390_CPU_ENTITLEMENT__MAX ||
+        env->entitlement == S390_CPU_ENTITLEMENT_HORIZONTAL) {
+        if (env->dedicated) {
+            env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
+        } else {
+            env->entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
+        }
+    }
+}
+
+/**
+ * s390_topology_check:
+ * @socket_id: socket to check
+ * @book_id: book to check
+ * @drawer_id: drawer to check
+ * @entitlement: entitlement to check
+ * @dedicated: dedication to check
+ * @errp: Error pointer
+ *
+ * The function checks if the topology
+ * attributes fits inside the system topology.
+ */
+static void s390_topology_check(uint16_t socket_id, uint16_t book_id,
+                                uint16_t drawer_id, uint16_t entitlement,
+                                bool dedicated, Error **errp)
+{
+    CpuTopology *smp = s390_topology.smp;
+    ERRP_GUARD();
+
+    if (socket_id >= smp->sockets) {
+        error_setg(errp, "Unavailable socket: %d", socket_id);
+        return;
+    }
+    if (book_id >= smp->books) {
+        error_setg(errp, "Unavailable book: %d", book_id);
+        return;
+    }
+    if (drawer_id >= smp->drawers) {
+        error_setg(errp, "Unavailable drawer: %d", drawer_id);
+        return;
+    }
+    if (entitlement >= S390_CPU_ENTITLEMENT__MAX) {
+        error_setg(errp, "Unknown entitlement: %d", entitlement);
+        return;
+    }
+    if (dedicated && (entitlement == S390_CPU_ENTITLEMENT_LOW ||
+                      entitlement == S390_CPU_ENTITLEMENT_MEDIUM)) {
+        error_setg(errp, "A dedicated cpu implies high entitlement");
+        return;
+    }
+}
+
+/**
+ * s390_topology_add_core_to_socket:
+ * @cpu: the new S390CPU to insert in the topology structure
+ * @drawer_id: new drawer_id
+ * @book_id: new book_id
+ * @socket_id: new socket_id
+ * @creation: if is true the CPU is a new CPU and there is no old socket
+ *            to handle.
+ *            if is false, this is a moving the CPU and old socket count
+ *            must be decremented.
+ * @errp: the error pointer
+ *
+ */
+static void s390_topology_add_core_to_socket(S390CPU *cpu, int drawer_id,
+                                             int book_id, int socket_id,
+                                             bool creation, Error **errp)
+{
+    int old_socket_entry = s390_socket_nb(cpu);
+    int new_socket_entry;
+
+    if (creation) {
+        new_socket_entry = old_socket_entry;
+    } else {
+        new_socket_entry = (drawer_id * s390_topology.smp->books + book_id) *
+                            s390_topology.smp->sockets + socket_id;
+    }
+
+    /* Check for space on new socket */
+    if ((new_socket_entry != old_socket_entry) &&
+        (s390_topology.cores_per_socket[new_socket_entry] >=
+         s390_topology.smp->cores)) {
+        error_setg(errp, "No more space on this socket");
+        return;
+    }
+
+    /* Update the count of cores in sockets */
+    s390_topology.cores_per_socket[new_socket_entry] += 1;
+    if (!creation) {
+        s390_topology.cores_per_socket[old_socket_entry] -= 1;
+    }
+}
+
+/**
+ * s390_update_cpu_props:
+ * @ms: the machine state
+ * @cpu: the CPU for which to update the properties from the environment.
+ *
+ */
+static void s390_update_cpu_props(MachineState *ms, S390CPU *cpu)
+{
+    CpuInstanceProperties *props;
+
+    props = &ms->possible_cpus->cpus[cpu->env.core_id].props;
+
+    props->socket_id = cpu->env.socket_id;
+    props->book_id = cpu->env.book_id;
+    props->drawer_id = cpu->env.drawer_id;
+}
+
+/**
+ * s390_topology_setup_cpu:
+ * @ms: MachineState used to initialize the topology structure on
+ *      first call.
+ * @cpu: the new S390CPU to insert in the topology structure
+ * @errp: the error pointer
+ *
+ * Called from CPU Hotplug to check and setup the CPU attributes
+ * before to insert the CPU in the topology.
+ * There is no use to update the MTCR explicitely here because it
+ * will be updated by KVM on creation of the new vCPU.
+ */
+void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
+{
+    ERRP_GUARD();
+
+    /*
+     * We do not want to initialize the topology if the cpu model
+     * does not support topology, consequently, we have to wait for
+     * the first CPU to be realized, which realizes the CPU model
+     * to initialize the topology structures.
+     *
+     * s390_topology_setup_cpu() is called from the cpu hotplug.
+     */
+    if (!s390_topology.cores_per_socket) {
+        s390_topology_init(ms);
+    }
+
+    s390_topology_cpu_default(cpu, errp);
+    if (*errp) {
+        return;
+    }
+
+    s390_topology_check(cpu->env.socket_id, cpu->env.book_id,
+                        cpu->env.drawer_id, cpu->env.entitlement,
+                        cpu->env.dedicated, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Set the CPU inside the socket */
+    s390_topology_add_core_to_socket(cpu, 0, 0, 0, true, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* topology tree is reflected in props */
+    s390_update_cpu_props(ms, cpu);
+}
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 1a9bcda8b6..9df60ac447 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -45,6 +45,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -311,10 +312,18 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
 {
     MachineState *ms = MACHINE(hotplug_dev);
     S390CPU *cpu = S390_CPU(dev);
+    ERRP_GUARD();
 
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    if (s390_has_topology()) {
+        s390_topology_setup_cpu(ms, cpu, errp);
+        if (*errp) {
+            return;
+        }
+    }
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
@@ -554,11 +563,20 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
                                   sizeof(CPUArchId) * max_cpus);
     ms->possible_cpus->len = max_cpus;
     for (i = 0; i < ms->possible_cpus->len; i++) {
+        CpuInstanceProperties *props = &ms->possible_cpus->cpus[i].props;
+
         ms->possible_cpus->cpus[i].type = ms->cpu_type;
         ms->possible_cpus->cpus[i].vcpus_count = 1;
         ms->possible_cpus->cpus[i].arch_id = i;
-        ms->possible_cpus->cpus[i].props.has_core_id = true;
-        ms->possible_cpus->cpus[i].props.core_id = i;
+
+        props->has_core_id = true;
+        props->core_id = i;
+        props->has_socket_id = true;
+        props->socket_id = s390_std_socket(i, &ms->smp);
+        props->has_book_id = true;
+        props->book_id = s390_std_book(i, &ms->smp);
+        props->has_drawer_id = true;
+        props->drawer_id = s390_std_drawer(i, &ms->smp);
     }
 
     return ms->possible_cpus;
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

