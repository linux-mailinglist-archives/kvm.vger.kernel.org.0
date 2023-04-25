Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7D6EE595
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbjDYQUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbjDYQUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:20:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3712915471
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:20:17 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PGHEle032434;
        Tue, 25 Apr 2023 16:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J1G4F0EHENxoYut5+ynoXKuKVyTyrmMnAL+HNA9Ljjk=;
 b=p6GcUU2+OTqvc5tkehBRtzY8rXhDGChBUQZCuWDI3qPf/aBkkfYcZfgmNt5+6cBBOIuI
 aH1BgmUMgkeIwSE5/ckiTwrBqEN3wSQkuYEDOiNrhavdp/WKnmxL02Qy2llRC2p6EhHT
 9bMetIWELD6JipMyGhyJp6QbSdn44pSt/rDvum+yjw8/iOt9XJbNeZQh/7XG/EpVlt/v
 MuNylNahBYs85ssTGgdRh9EgpKZIVp5MTnV5OvUE3FO6irD+QTuSWbsKFmnqHN9PrJcF
 RR6dMZ1FjxxmBsRDEQ/ius+VtibzLTaBIrcStuyhgMth7znl+Bi5T1i5S8Ut3P1uYay9 sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6j8g01mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:19:58 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PG4LUq010183;
        Tue, 25 Apr 2023 16:15:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6hxgrxf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P0X0Jr017663;
        Tue, 25 Apr 2023 16:15:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47771ukw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PGF33V26018520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 16:15:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D28920071;
        Tue, 25 Apr 2023 16:15:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E66E20079;
        Tue, 25 Apr 2023 16:15:02 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 16:15:02 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v20 08/21] qapi/s390x/cpu topology: set-cpu-topology qmp command
Date:   Tue, 25 Apr 2023 18:14:43 +0200
Message-Id: <20230425161456.21031-9-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230425161456.21031-1-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZVedD8UrPaC0yQRDLMvTKYx_GuM6rHoV
X-Proofpoint-GUID: UBmLGczEh3lPqqjboqNTpMKX6XlRv_QG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_07,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 qapi/machine-target.json |  37 +++++++++++
 hw/s390x/cpu-topology.c  | 136 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 42a6a40333..3b7a0b77f4 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -4,6 +4,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or later.
 # See the COPYING file in the top-level directory.
 
+{ 'include': 'machine-common.json' }
+
 ##
 # @CpuModelInfo:
 #
@@ -354,3 +356,38 @@
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
+# Since: 8.1
+##
+{ 'command': 'set-cpu-topology',
+  'data': {
+      'core-id': 'uint16',
+      '*socket-id': 'uint16',
+      '*book-id': 'uint16',
+      '*drawer-id': 'uint16',
+      '*entitlement': 'CpuS390Entitlement',
+      '*dedicated': 'bool'
+  },
+  'features': [ 'unstable' ],
+  'if': { 'all': [ 'TARGET_S390X' , 'CONFIG_KVM' ] }
+}
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index d9cd3dc3ce..e5fb976594 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -16,6 +16,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 /*
  * s390_topology is used to keep the topology information.
@@ -261,6 +262,27 @@ static bool s390_topology_check(uint16_t socket_id, uint16_t book_id,
     return true;
 }
 
+/**
+ * s390_topology_need_report
+ * @cpu: Current cpu
+ * @drawer_id: future drawer ID
+ * @book_id: future book ID
+ * @socket_id: future socket ID
+ *
+ * A modified topology change report is needed if the topology
+ * tree or the topology attributes change.
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
@@ -330,3 +352,117 @@ void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
     /* topology tree is reflected in props */
     s390_update_cpu_props(ms, cpu);
 }
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
+    int old_socket_entry;
+    int new_socket_entry;
+    int report_needed;
+    S390CPU *cpu;
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
+    /* Get attributes not provided from cpu and verify the new topology */
+    if (!has_socket_id) {
+        socket_id = cpu->env.socket_id;
+    }
+    if (!has_book_id) {
+        book_id = cpu->env.book_id;
+    }
+    if (!has_drawer_id) {
+        drawer_id = cpu->env.drawer_id;
+    }
+    if (!has_dedicated) {
+        dedicated = cpu->env.dedicated;
+    }
+
+    /*
+     * When the user specifies the entitlement as 'auto' on the command line,
+     * qemu will set the entitlement as:
+     * Medium when the CPU is not dedicated.
+     * High when dedicated is true.
+     */
+    if (!has_entitlement || (entitlement == S390_CPU_ENTITLEMENT_AUTO)) {
+        if (dedicated) {
+            entitlement = S390_CPU_ENTITLEMENT_HIGH;
+        } else {
+            entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
+        }
+    }
+
+    if (!s390_topology_check(socket_id, book_id, drawer_id,
+                             entitlement, dedicated, errp))
+        return;
+
+    /* Check for space on new socket */
+    old_socket_entry = s390_socket_nb(cpu);
+    new_socket_entry = __s390_socket_nb(drawer_id, book_id, socket_id);
+
+    if (new_socket_entry != old_socket_entry) {
+        if (s390_topology.cores_per_socket[new_socket_entry] >=
+            s390_topology.smp->cores) {
+            error_setg(errp, "No more space on this socket");
+            return;
+        }
+        /* Update the count of cores in sockets */
+        s390_topology.cores_per_socket[new_socket_entry] += 1;
+        s390_topology.cores_per_socket[old_socket_entry] -= 1;
+    }
+
+    /* Check if we will need to report the modified topology */
+    report_needed = s390_topology_need_report(cpu, drawer_id, book_id,
+                                              socket_id, entitlement,
+                                              dedicated);
+
+    /* All checks done, report new topology into the vCPU */
+    cpu->env.drawer_id = drawer_id;
+    cpu->env.book_id = book_id;
+    cpu->env.socket_id = socket_id;
+    cpu->env.dedicated = dedicated;
+    cpu->env.entitlement = entitlement;
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
+                         bool has_entitlement, CpuS390Entitlement entitlement,
+                         bool has_dedicated, bool dedicated,
+                         Error **errp)
+{
+    ERRP_GUARD();
+
+    if (!s390_has_topology()) {
+        error_setg(errp, "This machine doesn't support topology");
+        return;
+    }
+
+    s390_change_topology(core, has_socket, socket, has_book, book,
+                         has_drawer, drawer, has_entitlement, entitlement,
+                         has_dedicated, dedicated, errp);
+}
-- 
2.31.1

