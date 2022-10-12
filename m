Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46A85FC911
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJLQVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJLQVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:21:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E39220E6
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:21:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CEupIX009172;
        Wed, 12 Oct 2022 16:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tsg/X5hgwsCr9HQFn4TFLUdGIOkKZKMHnQSpR6Q1p9k=;
 b=YkMmqy2zTBBlBY30hTP/7AGt9GA6D5zp1n3l8IShudEZGNtzTklaA1b4R65ceAnpLrou
 7J1u8UapxmEPfJOrmv5xh0K+qQlQeTrQ3rAlcHPL6mGbCs3is3dRdO6XmGynDUjZjzOL
 yG9wq+uAU2HKdSX/EVNaeTvZ3knytOv+L9c+lYopiIjXDpM6eHoUkSz6cNgjN6IB9TDB
 vj3YVe5CfDhq6KG8+j1IvUUsJHrLXxFbXmRRz3wrHmmxeCqL3EZedkq6S997EMmoeszJ
 uZhy7OFEQ8qsYmllr6uePOk5XcYcnDsj38Y2dPv5uqN3tOgvYFY7LjpMCRRXuNnKwd83 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ysv2s5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CFnF35026819;
        Wed, 12 Oct 2022 16:21:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ysv2s4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CGKp5f015183;
        Wed, 12 Oct 2022 16:21:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u9696p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CGLk1e51315000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 16:21:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2654A405B;
        Wed, 12 Oct 2022 16:21:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2F4A4054;
        Wed, 12 Oct 2022 16:21:13 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.34.168])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 16:21:13 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: [PATCH v10 2/9] s390x/cpu topology: reporting the CPU topology to the guest
Date:   Wed, 12 Oct 2022 18:21:00 +0200
Message-Id: <20221012162107.91734-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221012162107.91734-1-pmorel@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8xoGG8Kvv5xApYj849P8nGCRxWNyYCwf
X-Proofpoint-GUID: 3t6DAut6_oN-8VRKv4a1Zgcokq8wwotC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120106
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
 include/hw/s390x/cpu-topology.h |   3 +
 target/s390x/cpu.h              |  48 ++++++++++++++
 hw/s390x/cpu-topology.c         |   8 ++-
 target/s390x/cpu_topology.c     | 109 ++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c          |   6 +-
 target/s390x/meson.build        |   1 +
 6 files changed, 172 insertions(+), 3 deletions(-)
 create mode 100644 target/s390x/cpu_topology.c

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 66c171d0bc..61c11db017 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -13,6 +13,8 @@
 #include "hw/qdev-core.h"
 #include "qom/object.h"
 
+#define S390_TOPOLOGY_POLARITY_H  0x00
+
 typedef struct S390TopoContainer {
     int active_count;
 } S390TopoContainer;
@@ -29,6 +31,7 @@ struct S390Topology {
     S390TopoContainer *socket;
     S390TopoTLE *tle;
     MachineState *ms;
+    QemuMutex topo_mutex;
 };
 
 #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 7d6d01325b..d604aa9c78 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -565,6 +565,52 @@ typedef union SysIB {
 } SysIB;
 QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
 
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
+/* Container type Topology List Entry */
+typedef struct SysIBTl_container {
+        uint8_t nl;
+        uint8_t reserved[6];
+        uint8_t id;
+} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
+
+#define TOPOLOGY_NR_MAG  6
+#define TOPOLOGY_NR_MAG6 0
+#define TOPOLOGY_NR_MAG5 1
+#define TOPOLOGY_NR_MAG4 2
+#define TOPOLOGY_NR_MAG3 3
+#define TOPOLOGY_NR_MAG2 4
+#define TOPOLOGY_NR_MAG1 5
+/* Configuration topology */
+typedef struct SysIB_151x {
+    uint8_t  reserved0[2];
+    uint16_t length;
+    uint8_t  mag[TOPOLOGY_NR_MAG];
+    uint8_t  reserved1;
+    uint8_t  mnest;
+    uint32_t reserved2;
+    char tle[0];
+} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
+QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
+
+/* Maxi size of a SYSIB structure is when all CPU are alone in a container */
+#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
+                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
+                                                   sizeof(SysIBTl_cpu)))
+
+
 /* MMU defines */
 #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
 #define ASCE_SUBSPACE         0x200       /* subspace group control           */
@@ -843,4 +889,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
 
 #include "exec/cpu-all.h"
 
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
+
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 42b22a1831..c73cebfe6f 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -54,8 +54,6 @@ void s390_topology_new_cpu(int core_id)
         return;
     }
 
-    socket_id = core_id / topo->cpus;
-
     /*
      * At the core level, each CPU is represented by a bit in a 64bit
      * unsigned long which represent the presence of a CPU.
@@ -76,8 +74,13 @@ void s390_topology_new_cpu(int core_id)
     bit %= 64;
     bit = 63 - bit;
 
+    qemu_mutex_lock(&topo->topo_mutex);
+
+    socket_id = core_id / topo->cpus;
     topo->socket[socket_id].active_count++;
     set_bit(bit, &topo->tle[socket_id].mask[origin]);
+
+    qemu_mutex_unlock(&topo->topo_mutex);
 }
 
 /**
@@ -101,6 +104,7 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
     topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);
 
     topo->ms = ms;
+    qemu_mutex_init(&topo->topo_mutex);
 }
 
 /**
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
new file mode 100644
index 0000000000..df86a98f23
--- /dev/null
+++ b/target/s390x/cpu_topology.c
@@ -0,0 +1,109 @@
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
+#define S390_TOPOLOGY_MAX_STSI_SIZE (S390_MAX_CPUS *              \
+                                     (sizeof(SysIB_151x) +        \
+                                      sizeof(SysIBTl_container) + \
+                                      sizeof(SysIBTl_cpu)))
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
+    tle->polarity = S390_TOPOLOGY_POLARITY_H;
+    tle->type = S390_TOPOLOGY_CPU_IFL;
+    tle->origin = cpu_to_be64(origin * 64);
+    tle->mask = cpu_to_be64(mask);
+    return p + sizeof(*tle);
+}
+
+static char *s390_top_set_level2(S390Topology *topo, char *p)
+{
+    MachineState *ms = topo->ms;
+    int i, origin;
+
+    for (i = 0; i < ms->smp.sockets; i++) {
+        if (!topo->socket[i].active_count) {
+            continue;
+        }
+        p = fill_container(p, 1, i);
+        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
+            uint64_t mask = 0L;
+
+            mask = topo->tle[i].mask[origin];
+            if (mask) {
+                p = fill_tle_cpu(p, mask, origin);
+            }
+        }
+    }
+    return p;
+}
+
+static int setup_stsi(SysIB_151x *sysib, int level)
+{
+    S390Topology *topo = s390_get_topology();
+    MachineState *ms = topo->ms;
+    char *p = sysib->tle;
+
+    qemu_mutex_lock(&topo->topo_mutex);
+
+    sysib->mnest = level;
+    switch (level) {
+    case 2:
+        sysib->mag[TOPOLOGY_NR_MAG2] = ms->smp.sockets;
+        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cpus;
+        p = s390_top_set_level2(topo, p);
+        break;
+    }
+
+    qemu_mutex_unlock(&topo->topo_mutex);
+
+    return p - (char *) sysib;
+}
+
+#define S390_TOPOLOGY_MAX_MNEST 2
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
+{
+    uint64_t page[S390_TOPOLOGY_SYSIB_SIZE / sizeof(uint64_t)] = {};
+    SysIB_151x *sysib = (SysIB_151x *) page;
+    int len;
+
+    if (s390_is_pv() || !s390_has_topology() ||
+        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    len = setup_stsi(sysib, sel2);
+
+    sysib->length = cpu_to_be16(len);
+    s390_cpu_virt_mem_write(cpu, addr, ar, sysib, len);
+    setcc(cpu, 0);
+}
+
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 6a8dbadf7e..f96630440b 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -51,6 +51,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/cpu-topology.h"
 
 #ifndef DEBUG_KVM
 #define DEBUG_KVM  0
@@ -1917,9 +1918,12 @@ static int handle_stsi(S390CPU *cpu)
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

