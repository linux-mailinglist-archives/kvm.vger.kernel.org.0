Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16E6866AC
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjBANVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBANVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:21:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494EE1E29D
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:21:19 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311Cmn2d016436;
        Wed, 1 Feb 2023 13:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=m6kEUNgOMiCoc4olUf64ZQBKhmiWrd0cl9q3qLoru5Q=;
 b=jugprLDzfz0wW/8HVZVR+Z/3kMoE9VRWmQCYop5zTzJfLS3KE31D7G7tGHKZD+zM5lEe
 ZaoaiisrQva8weG0QH/wpDKfvF+VYzSK+X55YG22DzZ3FE/RlUSvYBNrwO+HYq9A9Ihg
 sIYCEGfg/mYf9eVUr3l5p57k8nBdxGzWIXMFxvyAub7kgxqFFjrHn/Pms6OnjHCNQkZP
 wHaFng1qcgskbZG1cCHar61iyZQB4P/Ibs5xcuULdR7dKU+w1mIcg04V3oLd3auFrE4e
 rRvU+L7qqS4Ui9AFPY2p31hBujq7Gl9DwZgur51WIeXC0Nl/wowJAKVzBtRPzdTsWk8x LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrdugryc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:05 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311CpQWU028295;
        Wed, 1 Feb 2023 13:21:05 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrdugrxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:05 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3111nv5B023655;
        Wed, 1 Feb 2023 13:21:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ncvugkggd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311DKxNh50463088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 13:20:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0805320043;
        Wed,  1 Feb 2023 13:20:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A903620040;
        Wed,  1 Feb 2023 13:20:57 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.4.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 13:20:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v15 02/11] s390x/cpu topology: add topology entries on CPU hotplug
Date:   Wed,  1 Feb 2023 14:20:42 +0100
Message-Id: <20230201132051.126868-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ab5-zZDtWUhGYC8r29lyLt4sHyu-1pLz
X-Proofpoint-ORIG-GUID: JCU93Gcfy7W-EqAM9YCmiaIqFBRFmTtl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010112
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
 include/hw/s390x/cpu-topology.h |  24 +++
 hw/s390x/cpu-topology.c         | 256 ++++++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c      |  23 ++-
 hw/s390x/meson.build            |   1 +
 4 files changed, 302 insertions(+), 2 deletions(-)
 create mode 100644 hw/s390x/cpu-topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 7a84b30a21..9b6f889ad4 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -10,6 +10,9 @@
 #ifndef HW_S390X_CPU_TOPOLOGY_H
 #define HW_S390X_CPU_TOPOLOGY_H
 
+#include "qemu/queue.h"
+#include "hw/boards.h"
+
 #define S390_TOPOLOGY_CPU_IFL   0x03
 
 enum s390_topology_polarity {
@@ -21,4 +24,25 @@ enum s390_topology_polarity {
     POLARITY_MAX,
 };
 
+typedef struct S390Topology {
+    uint8_t *cores_per_socket;
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
+
+extern S390Topology s390_topology;
+int s390_socket_nb(S390CPU *cpu);
+
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..12df4eca6c
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,256 @@
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
+ * .socket: tracks information on the count of cores per socket.
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
+ * Setup the default topology for unset attributes.
+ *
+ * The function accept only all all default values or all set values
+ * for the geometry topology.
+ *
+ * The function calculates the (drawer_id, book_id, socket_id)
+ * topology by filling the cores starting from the first socket
+ * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
+ *
+ * CPU type, polarity and dedication have defaults values set in the
+ * s390x_cpu_properties.
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
+ * s390_topology_check:
+ * @cpu: s390x CPU to be verified
+ * @errp: Error pointer
+ *
+ * The function first setup default values and then checks if the cpu
+ * fits inside the system topology.
+ */
+static void s390_topology_check(S390CPU *cpu, Error **errp)
+{
+    CpuTopology *smp = s390_topology.smp;
+    ERRP_GUARD();
+
+    s390_topology_cpu_default(cpu, errp);
+    if (*errp) {
+        return;
+    }
+
+    if (cpu->env.socket_id > smp->sockets) {
+        error_setg(errp, "Unavailable socket: %d", cpu->env.socket_id);
+        return;
+    }
+    if (cpu->env.book_id > smp->books) {
+        error_setg(errp, "Unavailable book: %d", cpu->env.book_id);
+        return;
+    }
+    if (cpu->env.drawer_id > smp->drawers) {
+        error_setg(errp, "Unavailable drawer: %d", cpu->env.drawer_id);
+        return;
+    }
+    if (cpu->env.entitlement >= POLARITY_MAX) {
+        error_setg(errp, "Unknown polarity: %d", cpu->env.entitlement);
+        return;
+    }
+
+    /* Dedication, boolean, can not be wrong. */
+}
+
+/**
+ * s390_set_core_in_socket:
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
+static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id, int book_id,
+                                    int socket_id, bool creation, Error **errp)
+{
+    int old_socket = s390_socket_nb(cpu);
+    int new_socket;
+
+    if (creation) {
+        new_socket = old_socket;
+    } else {
+        new_socket = drawer_id * s390_topology.smp->books +
+                     book_id * s390_topology.smp->sockets +
+                     socket_id;
+    }
+
+    /* Check for space on new socket */
+    if ((new_socket != old_socket) &&
+        (s390_topology.cores_per_socket[new_socket] >=
+         s390_topology.smp->cores)) {
+        error_setg(errp, "No more space on this socket");
+        return;
+    }
+
+    /* Update the count of cores in sockets */
+    s390_topology.cores_per_socket[new_socket] += 1;
+    if (!creation) {
+        s390_topology.cores_per_socket[old_socket] -= 1;
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
+    ERRP_GUARD();
+
+    /*
+     * We do not want to initialize the topology if the cpu model
+     * does not support topology consequently, we have to wait for
+     * the first CPU to be realized, which realizes the CPU model
+     * to initialize the topology structures.
+     *
+     * s390_topology_set_cpu() is called from the cpu hotplug.
+     */
+    if (!s390_topology.cores_per_socket) {
+        s390_topology_init(ms);
+    }
+
+    s390_topology_check(cpu, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Set the CPU inside the socket */
+    s390_set_core_in_socket(cpu, 0, 0, 0, true, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* topology tree is reflected in props */
+    s390_update_cpu_props(ms, cpu);
+}
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index f3cc845d3b..9bc51a83f4 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -44,6 +44,7 @@
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -310,10 +311,18 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
 {
     MachineState *ms = MACHINE(hotplug_dev);
     S390CPU *cpu = S390_CPU(dev);
+    ERRP_GUARD();
 
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    if (s390_has_topology()) {
+        s390_topology_set_cpu(ms, cpu, errp);
+        if (*errp) {
+            return;
+        }
+    }
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
@@ -551,11 +560,21 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
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
+        props->socket_id = i / ms->smp.cores;
+        props->has_book_id = true;
+        props->book_id = i / (ms->smp.cores * ms->smp.sockets);
+        props->has_drawer_id = true;
+        props->drawer_id = i /
+                           (ms->smp.cores * ms->smp.sockets * ms->smp.books);
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

