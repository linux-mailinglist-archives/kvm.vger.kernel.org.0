Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C47551F22
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345020AbiFTOkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244956AbiFTOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFF51158
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:45 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KDZikZ015934;
        Mon, 20 Jun 2022 13:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5SBG0RNux8jmuMRl37DWb4HK2j1MpzzrJ+IzkrpR87o=;
 b=G1fO7AruLCCSOQx9dW32lJM1ieYrTKQS03Q49gJAot2P+bj2fKj+CzGG4MRER+AM5fAN
 HWAf50Kma9XptKEgpglMnXy++Vz+mrFBR586R7Ko33GYbqGU4rBqGylAuYcsvXXiX2EZ
 mnKLbDMfO28gK9hQ6prbAoymXZFF8fbIZDcHCkvR2Osjwf9rQCh8HpCt0pY69SfKKZSX
 Kmh5SMMv+yIjxvmUCEGFDg/AXSRLlZYXla+ePIj5Wkh/xLCMsByw0jMVEOFag7WXe1Ab
 VXrSvzwP61t0lxNpA6DEITQS+zkRstch3yeF64bYtwptFQSlgZ6lBx85GsNktGbBrDpK sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrpfawsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:39 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KDWuOH033449;
        Mon, 20 Jun 2022 13:59:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrpfaws3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpOOK023580;
        Mon, 20 Jun 2022 13:59:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gs6b8tkne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxXra13304204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A70711C04A;
        Mon, 20 Jun 2022 13:59:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B363E11C04C;
        Mon, 20 Jun 2022 13:59:32 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 03/12] s390x/cpu_topology: implementating Store Topology System Information
Date:   Mon, 20 Jun 2022 16:03:43 +0200
Message-Id: <20220620140352.39398-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _nUs10jpSvAZ7WgCnLOZXxb2pzN3mJ0q
X-Proofpoint-GUID: Q8eHH5yIwEXFVvDdCzlsi9MkkjgCZvhP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of STSI is enhanced with the interception of the
function code 15 for storing CPU topology.

Using the objects built during the plugging of CPU, we build the
SYSIB 15_1_x structures.

With this patch the maximum MNEST level is 2, this is also
the only level allowed and only SYSIB 15_1_2 will be built.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 target/s390x/cpu.h          |   2 +
 target/s390x/cpu_topology.c | 112 ++++++++++++++++++++++++++++++++++++
 target/s390x/kvm/kvm.c      |   5 ++
 target/s390x/meson.build    |   1 +
 4 files changed, 120 insertions(+)
 create mode 100644 target/s390x/cpu_topology.c

diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 216adfde26..9d48087b71 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -890,4 +890,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
 
 #include "exec/cpu-all.h"
 
+void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
+
 #endif
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
new file mode 100644
index 0000000000..9f656d7e51
--- /dev/null
+++ b/target/s390x/cpu_topology.c
@@ -0,0 +1,112 @@
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
+    int ret;
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
+
+    setcc(cpu, ret ? 3 : 0);
+    g_free(p);
+}
+
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 7bd8db0e7b..563bf5ac60 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -51,6 +51,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/cpu-topology.h"
 
 #ifndef DEBUG_KVM
 #define DEBUG_KVM  0
@@ -1918,6 +1919,10 @@ static int handle_stsi(S390CPU *cpu)
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
2.31.1

