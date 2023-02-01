Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD16866AD
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjBANV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjBANVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:21:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97563D0BD
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:21:20 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311CHQx3014738;
        Wed, 1 Feb 2023 13:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Z31FhKDemu6fYZ6eIL5PKE2UxCO1+PQcrRdfmfgn4U8=;
 b=T6J53/Of2xIvwMFEat5t4hC27Yo4yp3oYY4ndDNFDPwD0XwRe21a6J2lWc3bniM9qay1
 DqRkqtpW+OZy6o/GANfeNwh7ZxsBAcTfV1/wMba9O8UabpVfTy3ElEbKe/Qn+CjHtYJx
 5eA2qxIRo/jA3AlXTtpU7icMtYmlJdrpaiKDm4ISwFXTZBONK7lIODBGC2dhaKPr6EDt
 lwrRrp3Dconk3LRWmBUSAK5HiI5PHI1ypJfvVgY8o77qIeT7q1WrFwBLyJontRulNdBZ
 8qJg9eJ8+FAMyqr23dbO4J0AbWsalploB7bd8Ocjdp/trs1c42S6KUnUK5btxcpE9VXS eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfqy4hkft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:14 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311DAnaN014011;
        Wed, 1 Feb 2023 13:21:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfqy4hkf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VM5qZR009107;
        Wed, 1 Feb 2023 13:21:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ncvshbga5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311DL7EQ50266458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 13:21:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF26620043;
        Wed,  1 Feb 2023 13:21:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63CFA20040;
        Wed,  1 Feb 2023 13:21:06 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.4.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 13:21:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v15 08/11] qapi/s390x/cpu topology: x-set-cpu-topology monitor command
Date:   Wed,  1 Feb 2023 14:20:48 +0100
Message-Id: <20230201132051.126868-9-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YJKhyzWMUnffALxAzbaz_gK9MFs-8ovw
X-Proofpoint-GUID: 2Etup9bQOnZMsjDkWCESr5oypRblYULm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The modification of the CPU attributes are done through a monitor
command.

It allows to move the core inside the topology tree to optimise
the cache usage in the case the host's hypervisor previously
moved the CPU.

The same command allows to modify the CPU attributes modifiers
like polarization entitlement and the dedicated attribute to notify
the guest if the host admin modified scheduling or dedication of a vCPU.

With this knowledge the guest has the possibility to optimize the
usage of the vCPUs.

The command is made experimental for the moment.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 29 +++++++++++++
 include/monitor/hmp.h    |  1 +
 hw/s390x/cpu-topology.c  | 88 ++++++++++++++++++++++++++++++++++++++++
 hmp-commands.hx          | 16 ++++++++
 4 files changed, 134 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 2e267fa458..58df0f5061 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -342,3 +342,32 @@
                    'TARGET_S390X',
                    'TARGET_MIPS',
                    'TARGET_LOONGARCH64' ] } }
+
+##
+# @x-set-cpu-topology:
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
+{ 'command': 'x-set-cpu-topology',
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
index 1b3bdcb446..12827479cf 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -151,5 +151,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
                                     HumanReadableText *(*qmp_handler)(Error **));
 void hmp_info_stats(Monitor *mon, const QDict *qdict);
 void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
+void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index c33378577b..6c50050991 100644
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
@@ -379,3 +383,87 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
     /* topology tree is reflected in props */
     s390_update_cpu_props(ms, cpu);
 }
+
+/*
+ * qmp and hmp implementations
+ */
+
+static void s390_change_topology(int64_t core_id, int64_t socket_id,
+                                 int64_t book_id, int64_t drawer_id,
+                                 int64_t polarity, bool dedicated,
+                                 Error **errp)
+{
+    MachineState *ms = current_machine;
+    S390CPU *cpu;
+    ERRP_GUARD();
+
+    cpu = (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
+    if (!cpu) {
+        error_setg(errp, "Core-id %ld does not exist!", core_id);
+        return;
+    }
+
+    /* Verify the new topology */
+    s390_topology_check(cpu, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Move the CPU into its new socket */
+    s390_set_core_in_socket(cpu, drawer_id, book_id, socket_id, true, errp);
+
+    /* All checks done, report topology in environment */
+    cpu->env.drawer_id = drawer_id;
+    cpu->env.book_id = book_id;
+    cpu->env.socket_id = socket_id;
+    cpu->env.dedicated = dedicated;
+    cpu->env.entitlement = polarity;
+
+    /* topology tree is reflected in props */
+    s390_update_cpu_props(ms, cpu);
+
+    /* Advertise the topology change */
+    s390_cpu_topology_set_modified();
+}
+
+void qmp_x_set_cpu_topology(int64_t core, int64_t socket,
+                         int64_t book, int64_t drawer,
+                         bool has_polarity, int64_t polarity,
+                         bool has_dedicated, bool dedicated,
+                         Error **errp)
+{
+    ERRP_GUARD();
+
+    if (!s390_has_topology()) {
+        error_setg(errp, "This machine doesn't support topology");
+        return;
+    }
+    if (!has_polarity) {
+        polarity = POLARITY_VERTICAL_MEDIUM;
+    }
+    if (!has_dedicated) {
+        dedicated = false;
+    }
+    s390_change_topology(core, socket, book, drawer, polarity, dedicated, errp);
+}
+
+void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict)
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
+    qmp_x_set_cpu_topology(core, socket, book, drawer,
+                           has_polarity, polarity,
+                           has_dedicated, dedicated,
+                           &local_err);
+    if (hmp_handle_error(mon, local_err)) {
+        return;
+    }
+}
diff --git a/hmp-commands.hx b/hmp-commands.hx
index 673e39a697..bb3c908356 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1815,3 +1815,19 @@ SRST
   Dump the FDT in dtb format to *filename*.
 ERST
 #endif
+
+#if defined(TARGET_S390X) && defined(CONFIG_KVM)
+    {
+        .name       = "x-set-cpu-topology",
+        .args_type  = "core:l,socket:l,book:l,drawer:l,polarity:l?,dedicated:b?",
+        .params     = "core socket book drawer [polarity] [dedicated]",
+        .help       = "Move CPU 'core' to 'socket/book/drawer' "
+                      "optionaly modifies polarity and dedication",
+        .cmd        = hmp_x_set_cpu_topology,
+    },
+
+SRST
+``x-set-cpu-topology`` *core* *socket* *book* *drawer* *polarity* *dedicated*
+  Moves the CPU  *core* to *socket* *book* *drawer* with *polarity* *dedicated*.
+ERST
+#endif
-- 
2.31.1

