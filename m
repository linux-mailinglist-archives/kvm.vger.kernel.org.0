Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5378F65EF5C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbjAEOxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbjAEOxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:53:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CED5AC63
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:53:32 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305EBWdP028051;
        Thu, 5 Jan 2023 14:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wr11b4bT864+Aocj/J0rZ2emjh5kRsQlacctMQpZ7gk=;
 b=ZIUaJ0rRFwNewMbApH81OUScY9TklkaoWNRNmjrRN9Lht/rr51P0bNULD2kg/bQBlypA
 gKvDIBOP2z5gV3Wya5Fn44BLXobv3QJgCto3akxCPlKwOgT3B29N5ZjxvWvPUSmDPdhA
 VFpZBGYggC1DHMXP9Pf3R44Ojx6iOMa5fkLAkV6ze3ROSyQdFdw9bsgc/lnv5cap8fiP
 KthFEkKHE6L9bhxP8Ew8qdelEP6rKO9taCgtlCT0pUKLd/qtZl+D4qEXUgqqIFMXkMqo
 WtdovR5M2/x3ayks3ChsWzA6LtnyvvoFNe35RiCMfKOQApEwvh0eDIqjMQ6KulFFA6PB Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx03hh1k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305EDCle000923;
        Thu, 5 Jan 2023 14:53:25 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx03hh1jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:25 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 304NvbRu000998;
        Thu, 5 Jan 2023 14:53:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mtcbfn3bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:22 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErJed30933248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB0C720043;
        Thu,  5 Jan 2023 14:53:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2B2420040;
        Thu,  5 Jan 2023 14:53:17 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and build the SYSIB
Date:   Thu,  5 Jan 2023 15:53:05 +0100
Message-Id: <20230105145313.168489-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kyCSphRxz0LpBe9cIgPgNyDroZfkSnkS
X-Proofpoint-GUID: aMD1ISyO6SYnc8UUi1shdIS7a-flQb6a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On interception of STSI(15.1.x) the System Information Block
(SYSIB) is built from the list of pre-ordered topology entries.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h |   3 +
 include/hw/s390x/sclp.h         |   1 +
 target/s390x/cpu.h              |  78 ++++++++++++++++++
 target/s390x/kvm/cpu_topology.c | 136 ++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c          |   5 +-
 target/s390x/kvm/meson.build    |   3 +-
 6 files changed, 224 insertions(+), 2 deletions(-)
 create mode 100644 target/s390x/kvm/cpu_topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index b3fd752d8d..9571aa70e5 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -41,6 +41,9 @@ typedef union s390_topology_id {
     };
 } s390_topology_id;
 #define TOPO_CPU_MASK       0x000000000000003fUL
+#define TOPO_SOCKET_MASK    0x0000ffffff000000UL
+#define TOPO_BOOK_MASK      0x0000ffff00000000UL
+#define TOPO_DRAWER_MASK    0x0000ff0000000000UL
 
 typedef struct S390TopologyEntry {
     s390_topology_id id;
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
index 39ea63a416..78988048dd 100644
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
+} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
+QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
+
 typedef union SysIB {
     SysIB_111 sysib_111;
     SysIB_121 sysib_121;
@@ -568,9 +587,68 @@ typedef union SysIB {
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
+ * uses only one level, the socket level.
+ *
+ * A container of with a nesting level (NL) greater than 1 can only
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
+/* Container type Topology List Entry */
+typedef struct SysIBTl_container {
+        uint8_t nl;
+        uint8_t reserved[6];
+        uint8_t id;
+} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
+
+/* CPU type Topology List Entry */
+typedef struct SysIBTl_cpu {
+        uint8_t nl;
+        uint8_t reserved0[3];
+        uint8_t reserved1:5;
+        uint8_t dedicated:1;
+        uint8_t polarity:2;
+        uint8_t type;
+        uint16_t origin;
+        uint64_t mask;
+} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
+
+/* Max size of a SYSIB structure is when all CPU are alone in a container */
+#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
+                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
+                                                   sizeof(SysIBTl_cpu)))
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
+
 /* MMU defines */
 #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
 #define ASCE_SUBSPACE         0x200       /* subspace group control           */
diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_topology.c
new file mode 100644
index 0000000000..3831a3264c
--- /dev/null
+++ b/target/s390x/kvm/cpu_topology.c
@@ -0,0 +1,136 @@
+/*
+ * QEMU S390x CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "hw/s390x/pv.h"
+#include "hw/sysbus.h"
+#include "hw/s390x/sclp.h"
+#include "hw/s390x/cpu-topology.h"
+
+static char *fill_container(char *p, int level, int id)
+{
+    SysIBTl_container *tle = (SysIBTl_container *)p;
+
+    tle->nl = level;
+    tle->id = id;
+    return p + sizeof(*tle);
+}
+
+static char *fill_tle_cpu(char *p, S390TopologyEntry *entry)
+{
+    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
+    s390_topology_id topology_id = entry->id;
+
+    tle->nl = 0;
+    tle->dedicated = topology_id.d;
+    tle->polarity = topology_id.p;
+    tle->type = topology_id.type;
+    tle->origin = topology_id.origin;
+    tle->mask = cpu_to_be64(entry->mask);
+    return p + sizeof(*tle);
+}
+
+static char *s390_top_set_level(char *p, int level)
+{
+    S390TopologyEntry *entry;
+    uint64_t last_socket = -1UL;
+    uint64_t last_book = -1UL;
+    uint64_t last_drawer = -1UL;
+    int drawer_cnt = 0;
+    int book_cnt = 0;
+    int socket_cnt = 0;
+
+    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
+
+        if (level > 3 && (last_drawer != entry->id.drawer)) {
+            book_cnt = 0;
+            socket_cnt = 0;
+            p = fill_container(p, 3, drawer_cnt++);
+            last_drawer = entry->id.id & TOPO_DRAWER_MASK;
+            p = fill_container(p, 2, book_cnt++);
+            last_book = entry->id.id & TOPO_BOOK_MASK;
+            p = fill_container(p, 1, socket_cnt++);
+            last_socket = entry->id.id & TOPO_SOCKET_MASK;
+            p = fill_tle_cpu(p, entry);
+        } else if (level > 2 && (last_book !=
+                                 (entry->id.id & TOPO_BOOK_MASK))) {
+            socket_cnt = 0;
+            p = fill_container(p, 2, book_cnt++);
+            last_book = entry->id.id & TOPO_BOOK_MASK;
+            p = fill_container(p, 1, socket_cnt++);
+            last_socket = entry->id.id & TOPO_SOCKET_MASK;
+            p = fill_tle_cpu(p, entry);
+        } else if (last_socket != (entry->id.id & TOPO_SOCKET_MASK)) {
+            p = fill_container(p, 1, socket_cnt++);
+            last_socket = entry->id.id & TOPO_SOCKET_MASK;
+            p = fill_tle_cpu(p, entry);
+        } else {
+            p = fill_tle_cpu(p, entry);
+        }
+    }
+
+    return p;
+}
+
+static int setup_stsi(S390CPU *cpu, SysIB_151x *sysib, int level)
+{
+    char *p = sysib->tle;
+
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
+    p = s390_top_set_level(p, level);
+
+    return p - (char *)sysib;
+}
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
+{
+    union {
+        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
+        SysIB_151x sysib;
+    } buffer QEMU_ALIGNED(8) = {};
+    int len;
+
+    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    len = setup_stsi(cpu, &buffer.sysib, sel2);
+
+    if (len > 4096) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    buffer.sysib.length = cpu_to_be16(len);
+    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
+    setcc(cpu, 0);
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

