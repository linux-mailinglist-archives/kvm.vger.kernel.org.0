Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E83D6EE55F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjDYQPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjDYQPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:15:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB55161A7
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:15:34 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PG9CQO031197;
        Tue, 25 Apr 2023 16:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Y4oYvJ95akSkpjDkxMfPjXVaLGITAU86Lnb3U6xaIBQ=;
 b=EN2hXJTPEoNk9bGAsHObsDKOHp1pdTKzIKvcbjaFVPH9K04j4b1JCU1nGVk301ugMnoD
 sjeGiEyzosq8RHK2bYzn035Y6vK0f+9LciENGwyUtynrx6aHVwHR/J436wzTAwLNWSO/
 pU3s1cnpviSMUQOO4FFRgQDjzceRfPeu+HwBHV1gezslJkScMNLt+BeEtumx6MH1gvGH
 mCcziJDs1O/APF+kFe6RtCEMiu4ja8ElaL+0spgqJc7zTd+AnvV2s8oMoij3pD10tRkh
 e40OD+XR3jg3vNjm62WSkxTgc7fnFT/ysSXP1xxX7tgN7lYr7NYoXczYqAkYAHx0mu0a HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6hr416ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:10 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PG9KZJ032112;
        Tue, 25 Apr 2023 16:15:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6hr416cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P4bdEO020390;
        Tue, 25 Apr 2023 16:15:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47771uku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PGExK429622730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 16:14:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79D7820071;
        Tue, 25 Apr 2023 16:14:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B579B20079;
        Tue, 25 Apr 2023 16:14:58 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 16:14:58 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15) and build the SYSIB
Date:   Tue, 25 Apr 2023 18:14:38 +0200
Message-Id: <20230425161456.21031-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230425161456.21031-1-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8kWenbhnHsnHZu74xac0SXjIX-ys14A3
X-Proofpoint-GUID: epcJT3Nx91B9n6MaJsTDE8mlMinitMIQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_07,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304250144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On interception of STSI(15.1.x) the System Information Block
(SYSIB) is built from the list of pre-ordered topology entries.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 MAINTAINERS                     |   1 +
 include/hw/s390x/cpu-topology.h |  24 +++
 include/hw/s390x/sclp.h         |   1 +
 target/s390x/cpu.h              |  72 ++++++++
 hw/s390x/cpu-topology.c         |  13 +-
 target/s390x/kvm/cpu_topology.c | 308 ++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c          |   5 +-
 target/s390x/kvm/meson.build    |   3 +-
 8 files changed, 424 insertions(+), 3 deletions(-)
 create mode 100644 target/s390x/kvm/cpu_topology.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bb7b34d0d8..de9052f753 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
 S: Supported
 F: include/hw/s390x/cpu-topology.h
 F: hw/s390x/cpu-topology.c
+F: target/s390x/kvm/cpu_topology.c
 
 X86 Machines
 ------------
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index af36f634e0..87bfeb631e 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -15,9 +15,33 @@
 #include "hw/boards.h"
 #include "qapi/qapi-types-machine-target.h"
 
+#define S390_TOPOLOGY_CPU_IFL   0x03
+
+typedef union s390_topology_id {
+    uint64_t id;
+    struct {
+        uint8_t sentinel;
+        uint8_t drawer;
+        uint8_t book;
+        uint8_t socket;
+        uint8_t dedicated;
+        uint8_t entitlement;
+        uint8_t type;
+        uint8_t origin;
+    };
+} s390_topology_id;
+
+typedef struct S390TopologyEntry {
+    QTAILQ_ENTRY(S390TopologyEntry) next;
+    s390_topology_id id;
+    uint64_t mask;
+} S390TopologyEntry;
+
 typedef struct S390Topology {
     uint8_t *cores_per_socket;
+    QTAILQ_HEAD(, S390TopologyEntry) list;
     CpuTopology *smp;
+    bool vertical_polarization;
 } S390Topology;
 
 #ifdef CONFIG_KVM
diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index d3ade40a5a..712fd68123 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -112,6 +112,7 @@ typedef struct CPUEntry {
 } QEMU_PACKED CPUEntry;
 
 #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
+#define SCLP_READ_SCP_INFO_MNEST                2
 typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index bb7cfb0cab..9f97989bd7 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -561,6 +561,25 @@ typedef struct SysIB_322 {
 } SysIB_322;
 QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
 
+#define S390_TOPOLOGY_MAG  6
+#define S390_TOPOLOGY_MAG6 0
+#define S390_TOPOLOGY_MAG5 1
+#define S390_TOPOLOGY_MAG4 2
+#define S390_TOPOLOGY_MAG3 3
+#define S390_TOPOLOGY_MAG2 4
+#define S390_TOPOLOGY_MAG1 5
+/* Configuration topology */
+typedef struct SysIB_151x {
+    uint8_t  reserved0[2];
+    uint16_t length;
+    uint8_t  mag[S390_TOPOLOGY_MAG];
+    uint8_t  reserved1;
+    uint8_t  mnest;
+    uint32_t reserved2;
+    char tle[];
+} SysIB_151x;
+QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
+
 typedef union SysIB {
     SysIB_111 sysib_111;
     SysIB_121 sysib_121;
@@ -568,9 +587,62 @@ typedef union SysIB {
     SysIB_221 sysib_221;
     SysIB_222 sysib_222;
     SysIB_322 sysib_322;
+    SysIB_151x sysib_151x;
 } SysIB;
 QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
 
+/*
+ * CPU Topology List provided by STSI with fc=15 provides a list
+ * of two different Topology List Entries (TLE) types to specify
+ * the topology hierarchy.
+ *
+ * - Container Topology List Entry
+ *   Defines a container to contain other Topology List Entries
+ *   of any type, nested containers or CPU.
+ * - CPU Topology List Entry
+ *   Specifies the CPUs position, type, entitlement and polarization
+ *   of the CPUs contained in the last Container TLE.
+ *
+ * There can be theoretically up to five levels of containers, QEMU
+ * uses only three levels, the drawer's, book's and socket's level.
+ *
+ * A container with a nesting level (NL) greater than 1 can only
+ * contain another container of nesting level NL-1.
+ *
+ * A container of nesting level 1 (socket), contains as many CPU TLE
+ * as needed to describe the position and qualities of all CPUs inside
+ * the container.
+ * The qualities of a CPU are polarization, entitlement and type.
+ *
+ * The CPU TLE defines the position of the CPUs of identical qualities
+ * using a 64bits mask which first bit has its offset defined by
+ * the CPU address orgin field of the CPU TLE like in:
+ * CPU address = origin * 64 + bit position within the mask
+ *
+ */
+/* Container type Topology List Entry */
+typedef struct SysIBTl_container {
+        uint8_t nl;
+        uint8_t reserved[6];
+        uint8_t id;
+} SysIBTl_container;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
+
+/* CPU type Topology List Entry */
+typedef struct SysIBTl_cpu {
+        uint8_t nl;
+        uint8_t reserved0[3];
+#define SYSIB_TLE_POLARITY_MASK 0x03
+#define SYSIB_TLE_DEDICATED     0x04
+        uint8_t flags;
+        uint8_t type;
+        uint16_t origin;
+        uint64_t mask;
+} SysIBTl_cpu;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, uint64_t addr, uint8_t ar);
+
 /* MMU defines */
 #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
 #define ASCE_SUBSPACE         0x200       /* subspace group control           */
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 471e0e7292..76d0c0fe46 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -22,12 +22,15 @@
  * .cores_per_socket: tracks information on the count of cores
  *                    per socket.
  * .smp: keeps track of the machine topology.
- *
+ * .list: queue the topology entries inside which
+ *        we keep the information on the CPU topology.
  */
 S390Topology s390_topology = {
     /* will be initialized after the cpu model is realized */
     .cores_per_socket = NULL,
     .smp = NULL,
+    .list = QTAILQ_HEAD_INITIALIZER(s390_topology.list),
+    .vertical_polarization = false,
 };
 
 /**
@@ -75,14 +78,22 @@ bool s390_has_topology(void)
  * Allocate an array to keep the count of cores per socket.
  * The index of the array starts at socket 0 from book 0 and
  * drawer 0 up to the maximum allowed by the machine topology.
+ *
+ * Insert a sentinel entry with a non null value.
+ * This entry will never be free.
  */
 static void s390_topology_init(MachineState *ms)
 {
     CpuTopology *smp = &ms->smp;
+    S390TopologyEntry *entry;
 
     s390_topology.smp = smp;
     s390_topology.cores_per_socket = g_new0(uint8_t, smp->sockets *
                                             smp->books * smp->drawers);
+
+    entry = g_malloc0(sizeof(S390TopologyEntry));
+    entry->id.sentinel = 0xff;
+    QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
 }
 
 /**
diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_topology.c
new file mode 100644
index 0000000000..86a286afe2
--- /dev/null
+++ b/target/s390x/kvm/cpu_topology.c
@@ -0,0 +1,308 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * QEMU S390x CPU Topology
+ *
+ * Copyright IBM Corp. 2022,2023
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "hw/s390x/pv.h"
+#include "hw/sysbus.h"
+#include "hw/s390x/sclp.h"
+#include "hw/s390x/cpu-topology.h"
+
+/**
+ * fill_container:
+ * @p: The address of the container TLE to fill
+ * @level: The level of nesting for this container
+ * @id: The container receives a uniq ID inside its own container
+ *
+ * Returns the next free TLE entry.
+ */
+static char *fill_container(char *p, int level, int id)
+{
+    SysIBTl_container *tle = (SysIBTl_container *)p;
+
+    tle->nl = level;
+    tle->id = id;
+    return p + sizeof(*tle);
+}
+
+/**
+ * fill_tle_cpu:
+ * @p: The address of the CPU TLE to fill
+ * @entry: a pointer to the S390TopologyEntry defining this
+ *         CPU container.
+ *
+ * Returns the next free TLE entry.
+ */
+static char *fill_tle_cpu(char *p, S390TopologyEntry *entry)
+{
+    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
+    s390_topology_id topology_id = entry->id;
+
+    tle->nl = 0;
+    if (topology_id.dedicated) {
+        tle->flags = SYSIB_TLE_DEDICATED;
+    }
+    tle->flags |= topology_id.entitlement;
+    tle->type = topology_id.type;
+    tle->origin = cpu_to_be16(topology_id.origin * 64);
+    tle->mask = cpu_to_be64(entry->mask);
+    return p + sizeof(*tle);
+}
+
+/*
+ * Macro to check that the size of data after increment
+ * will not get bigger than the size of the SysIB.
+ */
+#define SYSIB_GUARD(data, x) do {       \
+        data += x;                      \
+        if (data  > sizeof(SysIB)) {    \
+            return 0;                   \
+        }                               \
+    } while (0)
+
+/**
+ * stsi_topology_fill_sysib:
+ * @p: A pointer to the position of the first TLE
+ * @level: The nested level wanted by the guest
+ *
+ * Fill the SYSIB with the topology information as described in
+ * the PoP, nesting containers as appropriate, with the maximum
+ * nesting limited by @level.
+ *
+ * Return value:
+ * On success: the size of the SysIB_15x after being filled with TLE.
+ * On error: 0 in the case we would overrun the end of the SysIB.
+ */
+static int stsi_topology_fill_sysib(char *p, int level)
+{
+    S390TopologyEntry *entry;
+    int last_drawer = -1;
+    int last_book = -1;
+    int last_socket = -1;
+    int drawer_id = 0;
+    int book_id = 0;
+    int socket_id = 0;
+    int n = sizeof(SysIB_151x);
+
+    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
+        bool drawer_change = last_drawer != entry->id.drawer;
+        bool book_change = drawer_change || last_book != entry->id.book;
+        bool socket_change = book_change || last_socket != entry->id.socket;
+
+        /* If we reach the sentinel get out */
+        if (entry->id.sentinel) {
+            break;
+        }
+
+        if (level > 3 && drawer_change) {
+            SYSIB_GUARD(n, sizeof(SysIBTl_container));
+            p = fill_container(p, 3, drawer_id++);
+            book_id = 0;
+        }
+        if (level > 2 && book_change) {
+            SYSIB_GUARD(n, sizeof(SysIBTl_container));
+            p = fill_container(p, 2, book_id++);
+            socket_id = 0;
+        }
+        if (socket_change) {
+            SYSIB_GUARD(n, sizeof(SysIBTl_container));
+            p = fill_container(p, 1, socket_id++);
+        }
+
+        SYSIB_GUARD(n, sizeof(SysIBTl_cpu));
+        p = fill_tle_cpu(p, entry);
+        last_drawer = entry->id.drawer;
+        last_book = entry->id.book;
+        last_socket = entry->id.socket;
+    }
+
+    return n;
+}
+
+/**
+ * setup_stsi:
+ * sysib: pointer to a SysIB to be filled with SysIB_151x data
+ * level: Nested level specified by the guest
+ *
+ * Setup the SYSIB for STSI 15.1, the header as well as the description
+ * of the topology.
+ */
+static int setup_stsi(SysIB_151x *sysib, int level)
+{
+    sysib->mnest = level;
+    switch (level) {
+    case 4:
+        sysib->mag[S390_TOPOLOGY_MAG4] = current_machine->smp.drawers;
+        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.books;
+        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
+        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
+        break;
+    case 3:
+        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.drawers *
+                                         current_machine->smp.books;
+        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
+        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
+        break;
+    case 2:
+        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.drawers *
+                                         current_machine->smp.books *
+                                         current_machine->smp.sockets;
+        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
+        break;
+    }
+
+    return stsi_topology_fill_sysib(sysib->tle, level);
+}
+
+/**
+ * s390_topology_add_cpu_to_entry:
+ * @entry: Topology entry to setup
+ * @cpu: the S390CPU to add
+ *
+ * Set the core bit inside the topology mask and
+ * increments the number of cores for the socket.
+ */
+static void s390_topology_add_cpu_to_entry(S390TopologyEntry *entry,
+                                           S390CPU *cpu)
+{
+    set_bit(63 - (cpu->env.core_id % 64), &entry->mask);
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
+    s390_topology_id topology_id = {0};
+
+    topology_id.drawer = cpu->env.drawer_id;
+    topology_id.book = cpu->env.book_id;
+    topology_id.socket = cpu->env.socket_id;
+    topology_id.origin = cpu->env.core_id / 64;
+    topology_id.type = S390_TOPOLOGY_CPU_IFL;
+    topology_id.dedicated = cpu->env.dedicated;
+
+    if (s390_topology.vertical_polarization) {
+        /*
+         * Vertical polarization with dedicated CPU implies
+         * vertical high entitlement.
+         */
+        if (topology_id.dedicated) {
+            topology_id.entitlement = S390_CPU_ENTITLEMENT_HIGH;
+        } else {
+            topology_id.entitlement = cpu->env.entitlement;
+        }
+    }
+
+    return topology_id;
+}
+
+/**
+ * s390_topology_insert:
+ * @cpu: s390CPU insert.
+ *
+ * Parse the topology list to find if the entry already
+ * exist and add the core in it.
+ * If it does not exist, allocate a new entry and insert
+ * it in the queue from lower id to greater id.
+ */
+static void s390_topology_insert(S390CPU *cpu)
+{
+    s390_topology_id id = s390_topology_from_cpu(cpu);
+    S390TopologyEntry *entry = NULL;
+    S390TopologyEntry *tmp = NULL;
+
+    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
+        if (id.id == tmp->id.id) {
+            s390_topology_add_cpu_to_entry(tmp, cpu);
+            return;
+        } else if (id.id < tmp->id.id) {
+            entry = g_malloc0(sizeof(S390TopologyEntry));
+            entry->id.id = id.id;
+            s390_topology_add_cpu_to_entry(entry, cpu);
+            QTAILQ_INSERT_BEFORE(tmp, entry, next);
+            return;
+        }
+    }
+}
+
+/**
+ * s390_topology_fill_list_sorted:
+ *
+ * Loop over all CPU and insert it at the right place
+ * inside the TLE entry list.
+ * Fill the S390Topology list with entries according to the order
+ * specified by the PoP.
+ */
+static void s390_topology_fill_list_sorted(void)
+{
+    CPUState *cs;
+
+    CPU_FOREACH(cs) {
+        s390_topology_insert(S390_CPU(cs));
+    }
+}
+
+/**
+ * s390_topology_empty_list:
+ *
+ * Clear all entries in the S390Topology list except the sentinel.
+ */
+static void s390_topology_empty_list(void)
+{
+    S390TopologyEntry *entry = NULL;
+    S390TopologyEntry *tmp = NULL;
+
+    QTAILQ_FOREACH_SAFE(entry, &s390_topology.list, next, tmp) {
+        if (!entry->id.sentinel) {
+            QTAILQ_REMOVE(&s390_topology.list, entry, next);
+            g_free(entry);
+        }
+    }
+}
+
+/**
+ * insert_stsi_15_1_x:
+ * cpu: the CPU doing the call for which we set CC
+ * sel2: the selector 2, containing the nested level
+ * addr: Guest logical address of the guest SysIB
+ * ar: the access register number
+ *
+ * Emulate STSI 15.1.x, that is, perform all necessary checks and
+ * fill the SYSIB.
+ * In case the topology description is too long to fit into the SYSIB,
+ * set CC=3 and abort without writing the SYSIB.
+ */
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, uint64_t addr, uint8_t ar)
+{
+    SysIB sysib = {0};
+    int length;
+
+    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    s390_topology_fill_list_sorted();
+
+    length = setup_stsi(&sysib.sysib_151x, sel2);
+
+    if (!length) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    sysib.sysib_151x.length = cpu_to_be16(length);
+    s390_cpu_virt_mem_write(cpu, addr, ar, &sysib, length);
+    setcc(cpu, 0);
+
+    s390_topology_empty_list();
+}
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 3ac7ec9acf..5ea358cbb0 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -1919,9 +1919,12 @@ static int handle_stsi(S390CPU *cpu)
         if (run->s390_stsi.sel1 != 2 || run->s390_stsi.sel2 != 2) {
             return 0;
         }
-        /* Only sysib 3.2.2 needs post-handling for now. */
         insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar);
         return 0;
+    case 15:
+        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, run->s390_stsi.addr,
+                           run->s390_stsi.ar);
+        return 0;
     default:
         return 0;
     }
diff --git a/target/s390x/kvm/meson.build b/target/s390x/kvm/meson.build
index aef52b6686..5daa5c6033 100644
--- a/target/s390x/kvm/meson.build
+++ b/target/s390x/kvm/meson.build
@@ -1,6 +1,7 @@
 
 s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
-  'kvm.c'
+  'kvm.c',
+  'cpu_topology.c'
 ), if_false: files(
   'stubs.c'
 ))
-- 
2.31.1

