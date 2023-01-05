Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39D165EF6D
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbjAEOyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjAEOyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD2C5BA01
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:05 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305EKf0f009627;
        Thu, 5 Jan 2023 14:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ethdufynlW1MEixRs+2AXSiySCmWBFk8ra2McLsJN2w=;
 b=QiWszAf4qE3F3ntXCbwv+wpRdhHbAhLOhfw75gqCfd8Ytvt+F8kafwxBULRF/p0kGpDy
 u9KwQSq/L7MNjE0mYFv3qDhFJ3L6JvR1j6p6G3ZiL+1oHxNbAkpPBGZ22skhmCGqvsgI
 UV9EbcbJqIDLax/DJvkQPw3vFp3w5B638Vn6q471UbVgmTM1OtBOlnPfUe6p09DWcB0U
 iTj4vZt20Ztld5jmrzumx56+EJyViSLJrDFUljoeooCUzHDYq4MuE90EgbfOpWNthzup
 tFEnVUJKpxGtI9tM14cB4pZYNgL8N/HEZYIZrwvYTtthb1afOSxBYU98brtxlH8oAzDg zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx07wrsd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305EL1p0011135;
        Thu, 5 Jan 2023 14:53:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx07wrscg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3052VGxW010510;
        Thu, 5 Jan 2023 14:53:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6d2b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErOVg49414634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2598120040;
        Thu,  5 Jan 2023 14:53:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 217BA20049;
        Thu,  5 Jan 2023 14:53:23 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 08/11] qapi/s390/cpu topology:  change-topology monitor command
Date:   Thu,  5 Jan 2023 15:53:10 +0100
Message-Id: <20230105145313.168489-9-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kaN2e_OFZoK6BbQPjgAzMn5S4LU9B7Im
X-Proofpoint-ORIG-GUID: xefNCUmSMyiOBuSaxryUHpmIPiDQcEqm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The modification of the CPU attributes are done through a monitor
commands.

It allows to move the core inside the topology tree to optimise
the cache usage in the case the host's hypervizor previously
moved the CPU.

The same command allows to modifiy the CPU attributes modifiers
like polarization entitlement and the dedicated attribute to notify
the guest if the host admin modified scheduling or dedication of a vCPU.

With this knowledge the guest has the possibility to optimize the
usage of the vCPUs.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json |  29 ++++++++
 include/monitor/hmp.h    |   1 +
 hw/s390x/cpu-topology.c  | 141 +++++++++++++++++++++++++++++++++++++++
 hmp-commands.hx          |  16 +++++
 4 files changed, 187 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 2e267fa458..75b0aa254d 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -342,3 +342,32 @@
                    'TARGET_S390X',
                    'TARGET_MIPS',
                    'TARGET_LOONGARCH64' ] } }
+
+##
+# @change-topology:
+#
+# @core: the vCPU ID to be moved
+# @socket: the destination socket where to move the vCPU
+# @book: the destination book where to move the vCPU
+# @drawer: the destination drawer where to move the vCPU
+# @polarity: optional polarity, default is last polarity set by the guest
+# @dedicated: optional, if the vCPU is dedicated to a real CPU
+#
+# Modifies the topology by moving the CPU inside the topology
+# tree or by changing a modifier attribute of a CPU.
+#
+# Returns: Nothing on success, the reason on failure.
+#
+# Since: <next qemu stable release, eg. 1.0>
+##
+{ 'command': 'change-topology',
+  'data': {
+      'core': 'int',
+      'socket': 'int',
+      'book': 'int',
+      'drawer': 'int',
+      '*polarity': 'int',
+      '*dedicated': 'bool'
+  },
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 27f86399f7..15c36bf549 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -144,5 +144,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
                                     HumanReadableText *(*qmp_handler)(Error **));
 void hmp_info_stats(Monitor *mon, const QDict *qdict);
 void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
+void hmp_change_topology(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index b69955a1cd..0faffe657e 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -18,6 +18,10 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "qapi/qapi-commands-machine-target.h"
+#include "qapi/qmp/qdict.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
 
 /*
  * s390_topology is used to keep the topology information.
@@ -203,6 +207,21 @@ static void s390_topology_set_entry(S390TopologyEntry *entry,
     s390_topology.sockets[s390_socket_nb(id)]++;
 }
 
+/**
+ * s390_topology_clear_entry:
+ * @entry: Topology entry to setup
+ * @id: topology id to use for the setup
+ *
+ * Clear the core bit inside the topology mask and
+ * decrements the number of cores for the socket.
+ */
+static void s390_topology_clear_entry(S390TopologyEntry *entry,
+                                      s390_topology_id id)
+{
+    clear_bit(63 - id.core, &entry->mask);
+    s390_topology.sockets[s390_socket_nb(id)]--;
+}
+
 /**
  * s390_topology_new_entry:
  * @id: s390_topology_id to add
@@ -383,3 +402,125 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
 
     s390_topology_insert(id);
 }
+
+/*
+ * qmp and hmp implementations
+ */
+
+static S390TopologyEntry *s390_topology_core_to_entry(int core)
+{
+    S390TopologyEntry *entry;
+
+    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
+        if (entry->mask & (1UL << (63 - core))) {
+            return entry;
+        }
+    }
+    return NULL;
+}
+
+static void s390_change_topology(Error **errp, int64_t core, int64_t socket,
+                                 int64_t book, int64_t drawer,
+                                 int64_t polarity, bool dedicated)
+{
+    S390TopologyEntry *entry;
+    s390_topology_id new_id;
+    s390_topology_id old_id;
+    Error *local_error = NULL;
+
+    /* Get the old entry */
+    entry = s390_topology_core_to_entry(core);
+    if (!entry) {
+        error_setg(errp, "No core %ld", core);
+        return;
+    }
+
+    /* Compute old topology id */
+    old_id = entry->id;
+    old_id.core = core;
+
+    /* Compute new topology id */
+    new_id = entry->id;
+    new_id.core = core;
+    new_id.socket = socket;
+    new_id.book = book;
+    new_id.drawer = drawer;
+    new_id.p = polarity;
+    new_id.d = dedicated;
+    new_id.type = S390_TOPOLOGY_CPU_IFL;
+
+    /* Same topology entry, nothing to do */
+    if (entry->id.id == new_id.id) {
+        return;
+    }
+
+    /* Check for space on the socket if ids are different */
+    if ((s390_socket_nb(old_id) != s390_socket_nb(new_id)) &&
+        (s390_topology.sockets[s390_socket_nb(new_id)] >=
+         s390_topology.smp->sockets)) {
+        error_setg(errp, "No more space on this socket");
+        return;
+    }
+
+    /* Verify the new topology */
+    s390_topology_check(&local_error, new_id);
+    if (local_error) {
+        error_propagate(errp, local_error);
+        return;
+    }
+
+    /* Clear the old topology */
+    s390_topology_clear_entry(entry, old_id);
+
+    /* Insert the new topology */
+    s390_topology_insert(new_id);
+
+    /* Remove unused entry */
+    if (!entry->mask) {
+        QTAILQ_REMOVE(&s390_topology.list, entry, next);
+        g_free(entry);
+    }
+
+    /* Advertise the topology change */
+    s390_cpu_topology_set();
+}
+
+void qmp_change_topology(int64_t core, int64_t socket,
+                         int64_t book, int64_t drawer,
+                         bool has_polarity, int64_t polarity,
+                         bool has_dedicated, bool dedicated,
+                         Error **errp)
+{
+    Error *local_err = NULL;
+
+    if (!s390_has_topology()) {
+        error_setg(&local_err, "This machine doesn't support topology");
+        return;
+    }
+    s390_change_topology(&local_err, core, socket, book, drawer,
+                         polarity, dedicated);
+    if (local_err) {
+        error_propagate(errp, local_err);
+    }
+}
+
+void hmp_change_topology(Monitor *mon, const QDict *qdict)
+{
+    const int64_t core = qdict_get_int(qdict, "core");
+    const int64_t socket = qdict_get_int(qdict, "socket");
+    const int64_t book = qdict_get_int(qdict, "book");
+    const int64_t drawer = qdict_get_int(qdict, "drawer");
+    bool has_polarity    = qdict_haskey(qdict, "polarity");
+    const int64_t polarity = qdict_get_try_int(qdict, "polarity", 0);
+    bool has_dedicated    = qdict_haskey(qdict, "dedicated");
+    const bool dedicated = qdict_get_try_bool(qdict, "dedicated", false);
+    Error *local_err = NULL;
+
+    qmp_change_topology(core, socket, book, drawer,
+                        has_polarity, polarity,
+                        has_dedicated, dedicated,
+                        &local_err);
+    if (hmp_handle_error(mon, local_err)) {
+        return;
+    }
+}
diff --git a/hmp-commands.hx b/hmp-commands.hx
index 673e39a697..a617cfed0d 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1815,3 +1815,19 @@ SRST
   Dump the FDT in dtb format to *filename*.
 ERST
 #endif
+
+#if defined(TARGET_S390X) && defined(CONFIG_KVM)
+    {
+        .name       = "change-topology",
+        .args_type  = "core:l,socket:l,book:l,drawer:l,polarity:l?,dedicated:b?",
+        .params     = "core socket book drawer [polarity] [dedicated]",
+        .help       = "Move CPU 'core' to 'socket/book/drawer' "
+                      "optionaly modifies polarity and dedication",
+        .cmd        = hmp_change_topology,
+    },
+
+SRST
+``change-topology`` *core* *socket* *book* *drawer* *polarity* *dedicated*
+  Moves the CPU  *core* to *socket* *book* *drawer* with *polarity* *dedicated*.
+ERST
+#endif
-- 
2.31.1

