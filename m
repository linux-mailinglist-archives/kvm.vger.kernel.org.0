Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9756A3E4C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 10:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjB0J1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 04:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjB0J1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 04:27:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AB74EDD
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 01:27:41 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31R81gXA018017;
        Mon, 27 Feb 2023 08:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5YVzVlwODytShxUg9rR03xiXKcAqp/zotPfkL6R8oYY=;
 b=CEPte2GIzWkvAHnqxDPj/tDXVUQE5smkvgFpM9m7MqC/Po0qs14IZoEuikEDWtMpfse5
 1jk0w2KS3xPbV2/Wb8wNk7/bm4D6sAKUVnp4gAkJtDwMFl5N9c3cOqdkeBuRRsg5lshS
 9M3VkAuBAgmbUFFPN1/wp9K8gQ78Npl1en+A8zfEv+06K7W3tvMBqWnmkU5QtU/5L0RN
 F0uZaCzNc9dh2UZcCC+YQnvGfyc7M+eFEzC4a6n2mCigtnCVZA8WoUIAwhY4QhmHMalg
 se9a3aSMMAwvA6W+93BImZEPU9PhLnSezf2NoBW6pv/Gzr0tHII8nozd2KasCcLOfCLg iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0rn0s9tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:53:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31R81S9o016251;
        Mon, 27 Feb 2023 08:53:01 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0rn0s9sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:53:01 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31QI0PNO019401;
        Mon, 27 Feb 2023 08:52:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nybdbh9gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:52:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31R8qtwV42205494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 08:52:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E112B2004D;
        Mon, 27 Feb 2023 08:52:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B204120043;
        Mon, 27 Feb 2023 08:52:53 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.37.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 08:52:53 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v17 08/12] qapi/s390x/cpu topology: set-cpu-topology monitor command
Date:   Mon, 27 Feb 2023 09:52:46 +0100
Message-Id: <20230227085247.11502-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <c80290f87e2c8377dc33584ec33ce77e1f58f091.camel@linux.ibm.com>
References: <c80290f87e2c8377dc33584ec33ce77e1f58f091.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D6bGE8HCYLlcp1kRMUdukepyJxZ6J6JV
X-Proofpoint-ORIG-GUID: yJ_7IWOJ6XUpj0jFn42qV-wo0oF8KMnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-26_22,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The modification of the CPU attributes are done through a monitor
command.

It allows to move the core inside the topology tree to optimize
the cache usage in the case the host's hypervisor previously
moved the CPU.

The same command allows to modify the CPU attributes modifiers
like polarization entitlement and the dedicated attribute to notify
the guest if the host admin modified scheduling or dedication of a vCPU.

With this knowledge the guest has the possibility to optimize the
usage of the vCPUs.

The command has a feature unstable for the moment.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json |  35 +++++++++
 include/monitor/hmp.h    |   1 +
 hw/s390x/cpu-topology.c  | 154 +++++++++++++++++++++++++++++++++++++++
 hmp-commands.hx          |  17 +++++
 4 files changed, 207 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index a52cc32f09..baa9d273cf 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -354,3 +354,38 @@
 { 'enum': 'CpuS390Polarization',
   'prefix': 'S390_CPU_POLARIZATION',
   'data': [ 'horizontal', 'vertical' ] }
+
+##
+# @set-cpu-topology:
+#
+# @core-id: the vCPU ID to be moved
+# @socket-id: optional destination socket where to move the vCPU
+# @book-id: optional destination book where to move the vCPU
+# @drawer-id: optional destination drawer where to move the vCPU
+# @entitlement: optional entitlement
+# @dedicated: optional, if the vCPU is dedicated to a real CPU
+#
+# Features:
+# @unstable: This command may still be modified.
+#
+# Modifies the topology by moving the CPU inside the topology
+# tree or by changing a modifier attribute of a CPU.
+# Default value for optional parameter is the current value
+# used by the CPU.
+#
+# Returns: Nothing on success, the reason on failure.
+#
+# Since: 8.0
+##
+{ 'command': 'set-cpu-topology',
+  'data': {
+      'core-id': 'uint16',
+      '*socket-id': 'uint16',
+      '*book-id': 'uint16',
+      '*drawer-id': 'uint16',
+      '*entitlement': 'str',
+      '*dedicated': 'bool'
+  },
+  'features': [ 'unstable' ],
+  'if': { 'all': [ 'TARGET_S390X' ] }
+}
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 2220f14fc9..4e65e6d08e 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -178,5 +178,6 @@ void hmp_ioport_read(Monitor *mon, const QDict *qdict);
 void hmp_ioport_write(Monitor *mon, const QDict *qdict);
 void hmp_boot_set(Monitor *mon, const QDict *qdict);
 void hmp_info_mtree(Monitor *mon, const QDict *qdict);
+void hmp_set_cpu_topology(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 3a2dcc67a5..daec896fbf 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,12 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
 #include "qapi/qapi-types-machine-target.h"
+#include "qapi/qapi-types-machine.h"
+#include "qapi/qapi-commands-machine-target.h"
+#include "qapi/qmp/qdict.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+
 /*
  * s390_topology is used to keep the topology information.
  * .cores_per_socket: tracks information on the count of cores
@@ -310,6 +316,26 @@ static void s390_topology_add_core_to_socket(S390CPU *cpu, int drawer_id,
     }
 }
 
+/**
+ * s390_topology_need_report
+ * @cpu: Current cpu
+ * @drawer_id: future drawer ID
+ * @book_id: future book ID
+ * @socket_id: future socket ID
+ *
+ * A modified topology change report is needed if the
+ */
+static int s390_topology_need_report(S390CPU *cpu, int drawer_id,
+                                   int book_id, int socket_id,
+                                   uint16_t entitlement, bool dedicated)
+{
+    return cpu->env.drawer_id != drawer_id ||
+           cpu->env.book_id != book_id ||
+           cpu->env.socket_id != socket_id ||
+           cpu->env.entitlement != entitlement ||
+           cpu->env.dedicated != dedicated;
+}
+
 /**
  * s390_update_cpu_props:
  * @ms: the machine state
@@ -376,3 +402,131 @@ void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
     /* topology tree is reflected in props */
     s390_update_cpu_props(ms, cpu);
 }
+
+/*
+ * qmp and hmp implementations
+ */
+
+#define TOPOLOGY_SET(n) do {                                \
+                            if (has_ ## n) {                \
+                                calc_ ## n = n;             \
+                            } else {                        \
+                                calc_ ## n = cpu->env.n;    \
+                            }                               \
+                        } while (0)
+
+static void s390_change_topology(uint16_t core_id,
+                                 bool has_socket_id, uint16_t socket_id,
+                                 bool has_book_id, uint16_t book_id,
+                                 bool has_drawer_id, uint16_t drawer_id,
+                                 bool has_entitlement, uint16_t entitlement,
+                                 bool has_dedicated, bool dedicated,
+                                 Error **errp)
+{
+    MachineState *ms = current_machine;
+    uint16_t calc_dedicated, calc_entitlement;
+    uint16_t calc_socket_id, calc_book_id, calc_drawer_id;
+    S390CPU *cpu;
+    int report_needed;
+    ERRP_GUARD();
+
+    if (core_id >= ms->smp.max_cpus) {
+        error_setg(errp, "Core-id %d out of range!", core_id);
+        return;
+    }
+
+    cpu = (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
+    if (!cpu) {
+        error_setg(errp, "Core-id %d does not exist!", core_id);
+        return;
+    }
+
+    /* Get unprovided attributes from cpu and verify the new topology */
+    TOPOLOGY_SET(entitlement);
+    TOPOLOGY_SET(dedicated);
+    TOPOLOGY_SET(socket_id);
+    TOPOLOGY_SET(book_id);
+    TOPOLOGY_SET(drawer_id);
+
+    s390_topology_check(calc_socket_id, calc_book_id, calc_drawer_id,
+                        calc_entitlement, calc_dedicated, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Move the CPU into its new socket */
+    s390_topology_add_core_to_socket(cpu, calc_drawer_id, calc_book_id,
+                                     calc_socket_id, false, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Check if we need to report the modified topology */
+    report_needed = s390_topology_need_report(cpu, calc_drawer_id, calc_book_id,
+                                              calc_socket_id, calc_entitlement,
+                                              calc_dedicated);
+
+    /* All checks done, report new topology into the vCPU */
+    cpu->env.drawer_id = calc_drawer_id;
+    cpu->env.book_id = calc_book_id;
+    cpu->env.socket_id = calc_socket_id;
+    cpu->env.dedicated = calc_dedicated;
+    cpu->env.entitlement = calc_entitlement;
+
+    /* topology tree is reflected in props */
+    s390_update_cpu_props(ms, cpu);
+
+    /* Advertise the topology change */
+    if (report_needed) {
+        s390_cpu_topology_set_changed(true);
+    }
+}
+
+void qmp_set_cpu_topology(uint16_t core,
+                         bool has_socket, uint16_t socket,
+                         bool has_book, uint16_t book,
+                         bool has_drawer, uint16_t drawer,
+                         const char *entitlement_str,
+                         bool has_dedicated, bool dedicated,
+                         Error **errp)
+{
+    bool has_entitlement = false;
+    int entitlement;
+    ERRP_GUARD();
+
+    if (!s390_has_topology()) {
+        error_setg(errp, "This machine doesn't support topology");
+        return;
+    }
+
+    entitlement = qapi_enum_parse(&CpuS390Entitlement_lookup, entitlement_str,
+                                  -1, errp);
+    if (*errp) {
+        return;
+    }
+    has_entitlement = entitlement >= 0;
+
+    s390_change_topology(core, has_socket, socket, has_book, book,
+                         has_drawer, drawer, has_entitlement, entitlement,
+                         has_dedicated, dedicated, errp);
+}
+
+void hmp_set_cpu_topology(Monitor *mon, const QDict *qdict)
+{
+    const uint16_t core = qdict_get_int(qdict, "core-id");
+    bool has_socket    = qdict_haskey(qdict, "socket-id");
+    const uint16_t socket = qdict_get_try_int(qdict, "socket-id", 0);
+    bool has_book    = qdict_haskey(qdict, "book-id");
+    const uint16_t book = qdict_get_try_int(qdict, "book-id", 0);
+    bool has_drawer    = qdict_haskey(qdict, "drawer-id");
+    const uint16_t drawer = qdict_get_try_int(qdict, "drawer-id", 0);
+    const char *entitlement = qdict_get_try_str(qdict, "entitlement");
+    bool has_dedicated    = qdict_haskey(qdict, "dedicated");
+    const bool dedicated = qdict_get_try_bool(qdict, "dedicated", false);
+    Error *local_err = NULL;
+
+    qmp_set_cpu_topology(core, has_socket, socket, has_book, book,
+                           has_drawer, drawer, entitlement,
+                           has_dedicated, dedicated, &local_err);
+    hmp_handle_error(mon, local_err);
+}
diff --git a/hmp-commands.hx b/hmp-commands.hx
index fbb5daf09b..328522abda 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1815,3 +1815,20 @@ SRST
   Dump the FDT in dtb format to *filename*.
 ERST
 #endif
+
+#if defined(TARGET_S390X)
+    {
+        .name       = "set-cpu-topology",
+        .args_type  = "core-id:l,socket-id:l?,book-id:l?,drawer-id:l?,entitlement:s?,dedicated:b?",
+        .params     = "core-id [socket-id] [book-id] [drawer-id] [entitlement] [dedicated]",
+        .help       = "Move CPU 'core' to 'socket/book/drawer' "
+                      "optionally modifies entitlement and dedication",
+        .cmd        = hmp_set_cpu_topology,
+    },
+
+SRST
+``set-cpu-topology`` *core-id* *socket-id* *book-id* *drawer-id* *entitlement* *dedicated*
+  Modify CPU topology for the CPU *core-id* to move on *socket-id* *book-id* *drawer-id*
+  with topology attributes *entitlement* *dedicated*.
+ERST
+#endif
-- 
2.31.1

