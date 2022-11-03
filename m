Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0F461858F
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiKCRCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiKCRCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DC11143
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:15 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FcX2v030597;
        Thu, 3 Nov 2022 17:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RqoyS1dzKQvN0aFh2NTMMr8csXIFNOQq5NAq7IrkBLw=;
 b=C9o6RkcQ/oWaFXDpAnXMvzkzs2USD4NuUqGuYAlOCAX8kVl2ewz5XtmaXAeUmPVnhuI4
 XbVmaP4+VH3h6n/MqKe6pgpE0jxrLqFtmFWhVLDGO99HhIoz786aJbxlvlbp0M67l277
 MQN6zDVapaXQggf0JDp2A20W23GqXQ5Pp80dJoKXpRsHWfIUdp2XoSXKpQbr7ta2xtHF
 uq09e/OroIEUn8XAoj5x5SuS3f3EIDr7Uh+A7fM4lsbWCwqCPq6E8vIHza3fEJyPPXgl
 G0078BrnS9fE4eoxe+QxeGXBVZVqvjx6/1YWM8EfGehjO7wBfI/3CG9mn35tarmBqRWy uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmcabwnx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:02:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3FdBH7002517;
        Thu, 3 Nov 2022 17:01:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmcabwnvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3H1b0a020627;
        Thu, 3 Nov 2022 17:01:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3kguejeuhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3H1rGX918174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 17:01:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78EFE5204F;
        Thu,  3 Nov 2022 17:01:53 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E5A2252050;
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
Subject: [PATCH v11 04/11] s390x/cpu topology: reporting the CPU topology to the guest
Date:   Thu,  3 Nov 2022 18:01:43 +0100
Message-Id: <20221103170150.20789-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cRZc3tFxyCiP2QXL9C1KHomj_4D8CI2r
X-Proofpoint-GUID: dp1X3NxQIqRAPRNZz3aHTk_y9jv3XOQT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest can use the STSI instruction to get a buffer filled
with the CPU topology description.

Let us implement the STSI instruction for the basis CPU topology
level, level 2.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h |   6 ++
 target/s390x/cpu.h              |  77 ++++++++++++++++++++++++
 hw/s390x/cpu-topology.c         |   1 -
 target/s390x/cpu_topology.c     | 100 ++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c          |   6 +-
 target/s390x/meson.build        |   1 +
 6 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 target/s390x/cpu_topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 4e16a2153d..6fec10e032 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -16,6 +16,11 @@
 #define S390_TOPOLOGY_CPU_IFL 0x03
 #define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
 
+#define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
+#define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
+#define S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM 0x02
+#define S390_TOPOLOGY_POLARITY_VERTICAL_HIGH   0x03
+
 typedef struct S390TopoSocket {
     int active_count;
     uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
@@ -26,6 +31,7 @@ struct S390Topology {
     uint32_t nr_cpus;
     uint32_t nr_sockets;
     S390TopoSocket *socket;
+    bool topology_needed;
 };
 
 #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index c9066b2496..69a7523146 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -567,6 +567,81 @@ typedef union SysIB {
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
+    char tle[0];
+} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
+QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
+
+/* Max size of a SYSIB structure is when all CPU are alone in a container */
+#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
+                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
+                                                   sizeof(SysIBTl_cpu)))
+
+
 /* MMU defines */
 #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
 #define ASCE_SUBSPACE         0x200       /* subspace group control           */
@@ -845,4 +920,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
 
 #include "exec/cpu-all.h"
 
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
+
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 6af41d3d7b..9fa8ca1261 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -44,7 +44,6 @@ void s390_topology_new_cpu(S390CPU *cpu)
     int socket_id;
 
     socket_id = core_id / topo->nr_cpus;
-
     /*
      * At the core level, each CPU is represented by a bit in a 64bit
      * uint64_t which represent the presence of a CPU.
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
new file mode 100644
index 0000000000..a1179d8e95
--- /dev/null
+++ b/target/s390x/cpu_topology.c
@@ -0,0 +1,100 @@
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
+#include "hw/s390x/cpu-topology.h"
+#include "hw/s390x/sclp.h"
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
+static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
+{
+    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
+
+    tle->nl = 0;
+    tle->dedicated = 1;
+    tle->polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
+    tle->type = S390_TOPOLOGY_CPU_IFL;
+    tle->origin = cpu_to_be64(origin * 64);
+    tle->mask = cpu_to_be64(mask);
+    return p + sizeof(*tle);
+}
+
+static char *s390_top_set_level2(S390Topology *topo, char *p)
+{
+    int i, origin;
+
+    for (i = 0; i < topo->nr_sockets; i++) {
+        if (!topo->socket[i].active_count) {
+            continue;
+        }
+        p = fill_container(p, 1, i);
+        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
+            uint64_t mask = 0L;
+
+            mask = topo->socket[i].mask[origin];
+            if (mask) {
+                p = fill_tle_cpu(p, mask, origin);
+            }
+        }
+    }
+    return p;
+}
+
+static int setup_stsi(S390CPU *cpu, SysIB_151x *sysib, int level)
+{
+    S390Topology *topo = (S390Topology *)cpu->topology;
+    char *p = sysib->tle;
+
+    sysib->mnest = level;
+    switch (level) {
+    case 2:
+        sysib->mag[S390_TOPOLOGY_MAG2] = topo->nr_sockets;
+        sysib->mag[S390_TOPOLOGY_MAG1] = topo->nr_cpus;
+        p = s390_top_set_level2(topo, p);
+        break;
+    }
+
+    return p - (char *)sysib;
+}
+
+#define S390_TOPOLOGY_MAX_MNEST 2
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
+{
+    union {
+        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
+        SysIB_151x sysib;
+    } buffer QEMU_ALIGNED(8);
+    int len;
+
+    if (s390_is_pv() || !s390_has_topology() ||
+        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    len = setup_stsi(cpu, &buffer.sysib, sel2);
+
+    buffer.sysib.length = cpu_to_be16(len);
+    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
+    setcc(cpu, 0);
+}
+
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 3ac7ec9acf..7dc96f3663 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -51,6 +51,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/cpu-topology.h"
 
 #ifndef DEBUG_KVM
 #define DEBUG_KVM  0
@@ -1919,9 +1920,12 @@ static int handle_stsi(S390CPU *cpu)
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
diff --git a/target/s390x/meson.build b/target/s390x/meson.build
index 84c1402a6a..890ccfa789 100644
--- a/target/s390x/meson.build
+++ b/target/s390x/meson.build
@@ -29,6 +29,7 @@ s390x_softmmu_ss.add(files(
   'sigp.c',
   'cpu-sysemu.c',
   'cpu_models_sysemu.c',
+  'cpu_topology.c',
 ))
 
 s390x_user_ss = ss.source_set()
-- 
2.31.1

