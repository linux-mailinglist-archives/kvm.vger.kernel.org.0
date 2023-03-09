Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6466B23D7
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 13:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCIMP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 07:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCIMPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 07:15:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EC0EA029
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 04:15:47 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329C29Ta014070;
        Thu, 9 Mar 2023 12:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hv+xKSDnh1fRqt0RwCiK4xmWraLU+eRQkONMRkvXNzo=;
 b=Q57Ow778R8yAQphjSHbnmhuHq+UpFJGqYU85FcVWSnW29TqmGKEjMStnBFl9TfBKnxP9
 gRDUcI5T1iCWlzK1f+8qSAlWq8y9mJv0o7Ok5zBaogR6Ujc39xMVqDN9rFwudZJe+mLI
 uH0n0DGVW+Lbpc53GI71o+ByaqrvZfsUJAcRwyCk19KunpTgiOei9R/X7ysH4Rnp3g63
 h+9b9SfKRzOB2VnHazP0rLZBL641IrN4tTV0gFKphNjy6H49w8YApV9v9in6j+BN9Roh
 iwgC+wU2iCPRJVxfQceBj8n27nO53s6U5Xr8JIASUOZmoj2gFXDtWuboCLafHsq0S24v AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6rh435ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:15:35 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 329C0Of1020011;
        Thu, 9 Mar 2023 12:15:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6rh435a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:15:34 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328HfSPZ032318;
        Thu, 9 Mar 2023 12:15:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3p6g039qaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:15:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 329CFSrD20775642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Mar 2023 12:15:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D789120079;
        Thu,  9 Mar 2023 12:15:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C042007A;
        Thu,  9 Mar 2023 12:15:23 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.28.223])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Mar 2023 12:15:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v17 08/12] qapi/s390x/cpu topology: set-cpu-topology qmp command
Date:   Thu,  9 Mar 2023 13:15:07 +0100
Message-Id: <20230309121511.139152-9-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230309121511.139152-1-pmorel@linux.ibm.com>
References: <20230309121511.139152-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uAnARKPUnnKo9g5xZwpZQHm66tjYpSCf
X-Proofpoint-ORIG-GUID: WwyYq1_JwENIetxC5IGKpAlHhammUuFN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_06,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090097
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
 qapi/machine-target.json |  37 ++++++++++++
 hw/s390x/cpu-topology.c  | 119 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 156 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index a52cc32f09..43e82cf071 100644
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
+# Since: 8.0
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
index 9aa2baf45b..0bf0a3d36f 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -18,6 +18,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 /*
  * s390_topology is used to keep the topology information.
@@ -301,6 +302,26 @@ static void s390_topology_add_core_to_socket(S390CPU *cpu, int drawer_id,
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
@@ -401,3 +422,101 @@ void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
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
+    /* Get attributes not provided from cpu and verify the new topology */
+    if (!has_entitlement) {
+        entitlement = cpu->env.entitlement;
+    }
+    if (!has_dedicated) {
+        dedicated = cpu->env.dedicated;
+    }
+    if (!has_socket_id) {
+        socket_id = cpu->env.socket_id;
+    }
+    if (!has_book_id) {
+        book_id = cpu->env.book_id;
+    }
+    if (!has_drawer_id) {
+        drawer_id = cpu->env.drawer_id;
+    }
+
+    s390_topology_check(socket_id, book_id, drawer_id,
+                        entitlement, dedicated, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Move the CPU into its new socket */
+    s390_topology_add_core_to_socket(cpu, drawer_id, book_id,
+                                     socket_id, false, errp);
+    if (*errp) {
+        return;
+    }
+
+    /* Check if we need to report the modified topology */
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
+    /* Setup shadow and effective entitlement */
+    s390_normalize_entitlement(cpu);
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

