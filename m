Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBEE46E94B
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhLINtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238123AbhLINtf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:35 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9BwD4C005858;
        Thu, 9 Dec 2021 13:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VX31h8tAplud7bvV21dLZBwzw+lIAiHXhp17i3jqy98=;
 b=stH5p60iSoAeO2m28OvAFzYzkHaHsMOYnvAmlgYuUJOFd8CYnJQjGG44P36GBiJL80iH
 5LXL3bg6tkqwCPPz6C498up4NzRCHNunZAPCersJ9GSsHemowgWdwYWSaq1DVMRcOMaa
 TwgBpzTt6iSsox8i4mZkvgmIx1/nOCBNHIAexLwbUeaB5qbIrA2BMXbaEQF2PHUJVej8
 9Nu08n6b2RORv1Qt901YQP+WAXpoWtJWgD+Pze+BTFu76GolbCLSeRf88SQ+X0YJVLBH
 NZho19L8tLhD9Xt8PjehmmAjOLW44PqqHuiuOUqbJ/e1I0mUec1JXITxaOoHlMZI0qNg rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhd4t80e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:56 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DD4V1019493;
        Thu, 9 Dec 2021 13:45:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhd4t7yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Dj9jd026080;
        Thu, 9 Dec 2021 13:45:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykjt0k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9Djoe621561684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:45:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01E3A11C054;
        Thu,  9 Dec 2021 13:45:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F2EF11C04A;
        Thu,  9 Dec 2021 13:45:49 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:49 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 04/12] s390x: topology: implementating Store Topology System Information
Date:   Thu,  9 Dec 2021 14:46:35 +0100
Message-Id: <20211209134643.143866-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vaHwwj21J_I07GrwWf4ZsQEkKDqCWlLo
X-Proofpoint-ORIG-GUID: CbNdk9LqNOPZGSwpFWAmjmssHwwNKWPO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 phishscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of STSI is enhanced with the interception of the
function code 15 for storing CPU topology.

Using the objects built during the pluging of CPU, we build the
SYSIB 15_1_x structures.

With this patch the maximum MNEST level is 2, this is also
the only level allowed and only SYSIB 15_1_2 will be built.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c     |  12 ++--
 target/s390x/cpu.h          |   1 +
 target/s390x/cpu_topology.c | 112 ++++++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c      |   5 ++
 target/s390x/meson.build    |   1 +
 5 files changed, 124 insertions(+), 7 deletions(-)
 create mode 100644 target/s390x/cpu_topology.c

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index b7131b4ac3..74e04fd68e 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -127,15 +127,14 @@ void s390_topology_new_cpu(int core_id)
     S390TopologyBook *book;
     S390TopologySocket *socket;
     S390TopologyCores *cores;
-    int cores_per_socket, sock_idx;
     int origin, bit;
+    int nb_cores_per_socket;
 
     book = s390_get_topology();
 
-    cores_per_socket = ms->smp.max_cpus / ms->smp.sockets;
-
-    sock_idx = (core_id / cores_per_socket);
-    socket = s390_get_socket(book, sock_idx);
+    /* Cores for the S390 topology are cores and threads of the QEMU topology */
+    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
+    socket = s390_get_socket(book, core_id / nb_cores_per_socket);
 
     /*
      * At the core level, each CPU is represented by a bit in a 64bit
@@ -151,12 +150,11 @@ void s390_topology_new_cpu(int core_id)
      * CPU inside several CPU containers inside the socket container.
      */
     origin = 64 * (core_id / 64);
-
     cores = s390_get_cores(socket, origin);
+    cores->origin = origin;
 
     bit = 63 - (core_id - origin);
     set_bit(bit, &cores->mask);
-    cores->origin = origin;
 }
 
 /*
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 071b3badf4..b97efe85a5 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -892,4 +892,5 @@ typedef S390CPU ArchCPU;
 
 #include "exec/cpu-all.h"
 
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
 #endif
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
new file mode 100644
index 0000000000..7f6db18829
--- /dev/null
+++ b/target/s390x/cpu_topology.c
@@ -0,0 +1,112 @@
+/*
+ * QEMU S390x CPU Topology
+ *
+ * Copyright IBM Corp. 2021
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "hw/s390x/pv.h"
+#include "hw/sysbus.h"
+#include "hw/s390x/cpu-topology.h"
+
+static int stsi_15_container(void *p, int nl, int id)
+{
+    SysIBTl_container *tle = (SysIBTl_container *)p;
+
+    tle->nl = nl;
+    tle->id = id;
+
+    return sizeof(*tle);
+}
+
+static int stsi_15_cpus(void *p, S390TopologyCores *cd)
+{
+    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
+
+    tle->nl = 0;
+    tle->dedicated = cd->dedicated;
+    tle->polarity = cd->polarity;
+    tle->type = cd->cputype;
+    tle->origin = be16_to_cpu(cd->origin);
+    tle->mask = be64_to_cpu(cd->mask);
+
+    return sizeof(*tle);
+}
+
+static int set_socket(const MachineState *ms, void *p,
+                      S390TopologySocket *socket)
+{
+    BusChild *kid;
+    int l, len = 0;
+
+    len += stsi_15_container(p, 1, socket->socket_id);
+    p += len;
+
+    QTAILQ_FOREACH_REVERSE(kid, &socket->bus->children, sibling) {
+        l = stsi_15_cpus(p, S390_TOPOLOGY_CORES(kid->child));
+        p += l;
+        len += l;
+    }
+    return len;
+}
+
+static void setup_stsi(const MachineState *ms, void *p, int level)
+{
+    S390TopologyBook *book;
+    SysIB_151x *sysib;
+    BusChild *kid;
+    int len, l;
+
+    sysib = (SysIB_151x *)p;
+    sysib->mnest = level;
+    sysib->mag[TOPOLOGY_NR_MAG2] = ms->smp.sockets;
+    sysib->mag[TOPOLOGY_NR_MAG1] = ms->smp.cores * ms->smp.threads;
+
+    book = s390_get_topology();
+    len = sizeof(SysIB_151x);
+    p += len;
+
+    QTAILQ_FOREACH_REVERSE(kid, &book->bus->children, sibling) {
+        l = set_socket(ms, p, S390_TOPOLOGY_SOCKET(kid->child));
+        p += l;
+        len += l;
+    }
+
+    sysib->length = be16_to_cpu(len);
+}
+
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
+{
+    const MachineState *machine = MACHINE(qdev_get_machine());
+    void *p;
+    int ret, cc;
+
+    /*
+     * Until the SCLP STSI Facility reporting the MNEST value is used,
+     * a sel2 value of 2 is the only value allowed in STSI 15.1.x.
+     */
+    if (sel2 != 2) {
+        setcc(cpu, 3);
+        return;
+    }
+
+    p = g_malloc0(TARGET_PAGE_SIZE);
+
+    setup_stsi(machine, p, 2);
+
+    if (s390_is_pv()) {
+        ret = s390_cpu_pv_mem_write(cpu, 0, p, TARGET_PAGE_SIZE);
+    } else {
+        ret = s390_cpu_virt_mem_write(cpu, addr, ar, p, TARGET_PAGE_SIZE);
+    }
+    cc = ret ? 3 : 0;
+    setcc(cpu, cc);
+    g_free(p);
+}
+
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 5b1fdb55c4..c17e92fc9c 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -52,6 +52,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/cpu-topology.h"
 
 #ifndef DEBUG_KVM
 #define DEBUG_KVM  0
@@ -1906,6 +1907,10 @@ static int handle_stsi(S390CPU *cpu)
         /* Only sysib 3.2.2 needs post-handling for now. */
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
2.27.0

