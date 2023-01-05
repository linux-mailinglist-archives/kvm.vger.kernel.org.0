Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D965EF64
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbjAEOyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjAEOxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:53:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1F5AC57
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:53:33 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Dsupi008123;
        Thu, 5 Jan 2023 14:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tuIPbZSeNUotYslDIY1M1kwHksA4aozwFbUiiQWbRh8=;
 b=ZNfuZXwqhZE7qyvTNZKKHHecg6rZcd1BHY6P+ZUipg9bFaBpKA3s59NO4r+jcUbhGIN3
 BPM6dIUTxQtBj0Ozc0iG6w3P2/epc5tmexVJDYXCWv5smaE3gHlWNfoytRUPktZ9dsnL
 TuXj6jhLWYC9PPErW7lTRq83Nthuq6SyGbQT6APEQU0ig8fTXKY9H5QVUuOFI2Y3Meuu
 5yWdEsaba9HWS+OgO02vLLdybS/xJ4/8bNXleX8Uo1U2SaJDDAshxATwO4DYg6HFsMPz
 971+g/yurXVRW0vmO6DVdPt7ef55P38lSaFX2H3ySbtkV6x+xs5mvqoBG4tqkjCfC2Ru vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwyuq9gxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:24 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305Ekb9A030966;
        Thu, 5 Jan 2023 14:53:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwyuq9gwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3054vfuD020172;
        Thu, 5 Jan 2023 14:53:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6ewa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:21 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErHwU48759176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D524520049;
        Thu,  5 Jan 2023 14:53:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E71BE20040;
        Thu,  5 Jan 2023 14:53:16 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 02/11] s390x/cpu topology: add topology entries on CPU hotplug
Date:   Thu,  5 Jan 2023 15:53:04 +0100
Message-Id: <20230105145313.168489-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DV6_PXItAycBkssK5t_mWhdSIadoEnCZ
X-Proofpoint-GUID: Wnt4p6K5KUBdI6HqFstKSVO_dIuYGIa-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The topology information are attributes of the CPU and are
specified during the CPU device creation.

On hot plug, we gather the topology information on the core,
creates a list of topology entries, each entry contains a single
core mask of each core with identical topology and finaly we
orders the list in topological order.
The topological order is, from higher to lower priority:
- physical topology
    - drawer
    - book
    - socket
    - core origin, offset in 64bit increment from core 0.
- modifier attributes
    - CPU type
    - polarization entitlement
    - dedication

The possibility to insert a CPU in a mask is dependent on the
number of cores allowed in a socket, a book or a drawer, the
checking is done during the hot plug of the CPU to have an
immediate answer.

If the complete topology is not specified, the core is added
in the physical topology based on its core ID and it gets
defaults values for the modifier attributes.

This way, starting QEMU without specifying the topology can
still get some adventage of the CPU topology.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h |  48 ++++++
 hw/s390x/cpu-topology.c         | 293 ++++++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c      |  10 ++
 hw/s390x/meson.build            |   1 +
 4 files changed, 352 insertions(+)
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index d945b57fc3..b3fd752d8d 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -10,7 +10,11 @@
 #ifndef HW_S390X_CPU_TOPOLOGY_H
 #define HW_S390X_CPU_TOPOLOGY_H
 
+#include "qemu/queue.h"
+#include "hw/boards.h"
+
 #define S390_TOPOLOGY_CPU_IFL   0x03
+#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
 
 #define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
 #define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
@@ -20,4 +24,48 @@
 #define S390_TOPOLOGY_SHARED    0x00
 #define S390_TOPOLOGY_DEDICATED 0x01
 
+typedef union s390_topology_id {
+    uint64_t id;
+    struct {
+        uint64_t level_6:8; /* byte 0 BE */
+        uint64_t level_5:8; /* byte 1 BE */
+        uint64_t drawer:8;  /* byte 2 BE */
+        uint64_t book:8;    /* byte 3 BE */
+        uint64_t socket:8;  /* byte 4 BE */
+        uint64_t rsrv:5;
+        uint64_t d:1;
+        uint64_t p:2;       /* byte 5 BE */
+        uint64_t type:8;    /* byte 6 BE */
+        uint64_t origin:2;
+        uint64_t core:6;    /* byte 7 BE */
+    };
+} s390_topology_id;
+#define TOPO_CPU_MASK       0x000000000000003fUL
+
+typedef struct S390TopologyEntry {
+    s390_topology_id id;
+    QTAILQ_ENTRY(S390TopologyEntry) next;
+    uint64_t mask;
+} S390TopologyEntry;
+
+typedef struct S390Topology {
+    QTAILQ_HEAD(, S390TopologyEntry) list;
+    uint8_t *sockets;
+    CpuTopology *smp;
+} S390Topology;
+
+#ifdef CONFIG_KVM
+bool s390_has_topology(void);
+void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
+#else
+static inline bool s390_has_topology(void)
+{
+       return false;
+}
+static inline void s390_topology_set_cpu(MachineState *ms,
+                                         S390CPU *cpu,
+                                         Error **errp) {}
+#endif
+extern S390Topology s390_topology;
+
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..438055c612
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,293 @@
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
+ * .list: queue the topology entries inside which
+ *        we keep the information on the CPU topology.
+ *
+ * .smp: keeps track of the machine topology.
+ *
+ * .socket: tracks information on the count of cores per socket.
+ *
+ */
+S390Topology s390_topology = {
+    .list = QTAILQ_HEAD_INITIALIZER(s390_topology.list),
+    .sockets = NULL, /* will be initialized after the cpu model is realized */
+};
+
+/**
+ * s390_socket_nb:
+ * @id: s390_topology_id
+ *
+ * Returns the socket number used inside the socket array.
+ */
+static int s390_socket_nb(s390_topology_id id)
+{
+    return (id.socket + 1) * (id.book + 1) * (id.drawer + 1);
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
+ * Allocate an array to keep the count of cores per socket.
+ * The index of the array starts at socket 0 from book 0 and
+ * drawer 0 up to the maximum allowed by the machine topology.
+ */
+static void s390_topology_init(MachineState *ms)
+{
+    CpuTopology *smp = &ms->smp;
+
+    s390_topology.smp = smp;
+    if (!s390_topology.sockets) {
+        s390_topology.sockets = g_new0(uint8_t, smp->sockets *
+                                       smp->books * smp->drawers);
+    }
+}
+
+/**
+ * s390_topology_from_cpu:
+ * @cpu: The S390CPU
+ *
+ * Initialize the topology id from the CPU environment.
+ */
+static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
+{
+    s390_topology_id topology_id;
+
+    topology_id.core = cpu->env.core_id;
+    topology_id.type = cpu->env.cpu_type;
+    topology_id.p = cpu->env.polarity;
+    topology_id.d = cpu->env.dedicated;
+    topology_id.socket = cpu->env.socket_id;
+    topology_id.book = cpu->env.book_id;
+    topology_id.drawer = cpu->env.drawer_id;
+
+    return topology_id;
+}
+
+/**
+ * s390_topology_set_entry:
+ * @entry: Topology entry to setup
+ * @id: topology id to use for the setup
+ *
+ * Set the core bit inside the topology mask and
+ * increments the number of cores for the socket.
+ */
+static void s390_topology_set_entry(S390TopologyEntry *entry,
+                                    s390_topology_id id)
+{
+    set_bit(63 - id.core, &entry->mask);
+    s390_topology.sockets[s390_socket_nb(id)]++;
+}
+
+/**
+ * s390_topology_new_entry:
+ * @id: s390_topology_id to add
+ *
+ * Allocate a new entry and initialize it.
+ *
+ * returns the newly allocated entry.
+ */
+static S390TopologyEntry *s390_topology_new_entry(s390_topology_id id)
+{
+    S390TopologyEntry *entry;
+
+    entry = g_malloc0(sizeof(S390TopologyEntry));
+    entry->id.id = id.id & ~TOPO_CPU_MASK;
+    s390_topology_set_entry(entry, id);
+
+    return entry;
+}
+
+/**
+ * s390_topology_insert:
+ *
+ * @id: s390_topology_id to insert.
+ *
+ * Parse the topology list to find if the entry already
+ * exist and add the core in it.
+ * If it does not exist, allocate a new entry and insert
+ * it in the queue from lower id to greater id.
+ */
+static void s390_topology_insert(s390_topology_id id)
+{
+    S390TopologyEntry *entry;
+    S390TopologyEntry *tmp = NULL;
+    uint64_t new_id;
+
+    new_id = id.id & ~TOPO_CPU_MASK;
+
+    /* First CPU to add to an entry */
+    if (QTAILQ_EMPTY(&s390_topology.list)) {
+        entry = s390_topology_new_entry(id);
+        QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
+        return;
+    }
+
+    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
+        if (new_id == tmp->id.id) {
+            s390_topology_set_entry(tmp, id);
+            return;
+        } else if (new_id < tmp->id.id) {
+            entry = s390_topology_new_entry(id);
+            QTAILQ_INSERT_BEFORE(tmp, entry, next);
+            return;
+        }
+    }
+
+    entry = s390_topology_new_entry(id);
+    QTAILQ_INSERT_TAIL(&s390_topology.list, entry, next);
+}
+
+/**
+ * s390_topology_check:
+ * @errp: Error pointer
+ * id: s390_topology_id to be verified
+ *
+ * The function checks if the topology id fits inside the
+ * system topology.
+ */
+static void s390_topology_check(Error **errp, s390_topology_id id)
+{
+    CpuTopology *smp = s390_topology.smp;
+
+    if (id.socket > smp->sockets) {
+            error_setg(errp, "Unavailable socket: %d", id.socket);
+            return;
+    }
+    if (id.book > smp->books) {
+            error_setg(errp, "Unavailable book: %d", id.book);
+            return;
+    }
+    if (id.drawer > smp->drawers) {
+            error_setg(errp, "Unavailable drawer: %d", id.drawer);
+            return;
+    }
+    if (id.type != S390_TOPOLOGY_CPU_IFL) {
+            error_setg(errp, "Unknown cpu type: %d", id.type);
+            return;
+    }
+    /* Polarity and dedication can never be wrong */
+}
+
+/**
+ * s390_topology_cpu_default:
+ * @errp: Error pointer
+ * @cpu: pointer to a S390CPU
+ *
+ * Setup the default topology for unset attributes.
+ *
+ * The function accept only all all default values or all set values
+ * for the geometry topology.
+ *
+ * The function calculates the (drawer_id, book_id, socket_id)
+ * topology by filling the cores starting from the first socket
+ * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
+ *
+ */
+static void s390_topology_cpu_default(Error **errp, S390CPU *cpu)
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
+        env->socket_id = (env->core_id / smp->cores) % smp->sockets;
+        env->book_id = (env->core_id / (smp->sockets * smp->cores)) %
+                       smp->books;
+        env->drawer_id = (env->core_id /
+                          (smp->books * smp->sockets * smp->cores)) %
+                         smp->drawers;
+    }
+}
+
+/**
+ * s390_topology_set_cpu:
+ * @ms: MachineState used to initialize the topology structure on
+ *      first call.
+ * @cpu: the new S390CPU to insert in the topology structure
+ * @errp: the error pointer
+ *
+ * Called from CPU Hotplug to check and setup the CPU attributes
+ * before to insert the CPU in the topology.
+ */
+void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
+{
+    Error *local_error = NULL;
+    s390_topology_id id;
+
+    /*
+     * We do not want to initialize the topology if the cpu model
+     * does not support topology consequently, we have to wait for
+     * the first CPU to be realized, which realizes the CPU model
+     * to initialize the topology structures.
+     *
+     * s390_topology_set_cpu() is called from the cpu hotplug.
+     */
+    if (!s390_topology.sockets) {
+        s390_topology_init(ms);
+    }
+
+    s390_topology_cpu_default(&local_error, cpu);
+    if (local_error) {
+        error_propagate(errp, local_error);
+        return;
+    }
+
+    id = s390_topology_from_cpu(cpu);
+
+    /* Check for space on the socket */
+    if (s390_topology.sockets[s390_socket_nb(id)] >=
+        s390_topology.smp->sockets) {
+        error_setg(&local_error, "No more space on socket");
+        return;
+    }
+
+    s390_topology_check(&local_error, id);
+    if (local_error) {
+        error_propagate(errp, local_error);
+        return;
+    }
+
+    s390_topology_insert(id);
+}
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index f3cc845d3b..c98b93a15f 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -44,6 +44,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -310,10 +311,19 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
 {
     MachineState *ms = MACHINE(hotplug_dev);
     S390CPU *cpu = S390_CPU(dev);
+    Error *local_err = NULL;
 
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    if (s390_has_topology()) {
+        s390_topology_set_cpu(ms, cpu, &local_err);
+        if (local_err) {
+            error_propagate(errp, local_err);
+            return;
+        }
+    }
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
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

