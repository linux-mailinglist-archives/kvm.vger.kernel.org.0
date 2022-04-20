Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD433508772
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378343AbiDTL5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378299AbiDTL5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D641442493
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:45 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KBMgBS002640;
        Wed, 20 Apr 2022 11:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=imINbElea77xLviKi46JHLOv3Lzd5rYxdnRsI1pmBYY=;
 b=B0ZycaIcrcNrnCuU/FAC6/33a5AshtDa1xEWEhbz48QLCnTtMG8hf/sgliIO6ApTFpwy
 rn1FYJ1Eb9HNbuBo7seBHcaiIjezj1dewBYqWlmedxyc3S49cZvFFK/n9M5Bw7WSfY+/
 +4AjnacJGAZ1uwA+YZvp/cF5p1hXbX9PNs+/uaQEt6p5a43jFo9o2ags3vnF0j/mbMm6
 01wQCnHU+2t8cBt1sUOaeUjT0tW+cM7ZQCpUqbK4Rop5iUTrv1WNCD25K7XL+0oAxQnr
 G6ZCEeFi6O+ets1yfgX0uiwCCizRI0RoKzG0nKKvfr4l6r/qbEmdX6C4VPmmWjOSOpxu rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79xx4fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:40 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBe2AV003268;
        Wed, 20 Apr 2022 11:54:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79xx4f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBr9OE023291;
        Wed, 20 Apr 2022 11:54:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8p7wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBsXMO49742286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:54:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B85BAE051;
        Wed, 20 Apr 2022 11:54:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64667AE045;
        Wed, 20 Apr 2022 11:54:32 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 04/13] s390x: topology: implementating Store Topology System Information
Date:   Wed, 20 Apr 2022 13:57:36 +0200
Message-Id: <20220420115745.13696-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X4EJ5luF6HohfX6a-Ntxqy9jP13c1WfM
X-Proofpoint-ORIG-GUID: zITeL7YC7AueYCDXhjhh39jud9GYRUGV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index f6969b76c5..a617c943ff 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -889,4 +889,5 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
 
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
index 6acf14d5ec..27b3fbfa09 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -52,6 +52,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/cpu-topology.h"
 
 #ifndef DEBUG_KVM
 #define DEBUG_KVM  0
@@ -1910,6 +1911,10 @@ static int handle_stsi(S390CPU *cpu)
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

