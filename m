Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DF56BB623
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjCOOfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCOOfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:35:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B3950FAA
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:35:28 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FEWSOS000897;
        Wed, 15 Mar 2023 14:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+2K1AZzN0GIH6OPjFRaxlzLpszFQBi7LdUEfkX9QPcQ=;
 b=jj5JTk5CRB2FEFAe345it5ZzvPVBtcUOynmCpPK/fHuHvdl9hZpDYnrugfygvxrEDnQr
 1yTJAtC0FL7zyAdiKeTo9My85tbZewuA9C5Ibe1MJs/p1LHVbxWc8v4HLdI99RRIdMVB
 CurSMryMJ1nZ0AQlgch4gryV2xYxwtc+rJOlFFOIPqm72mXCvma5r7kSrxefJBO/u99e
 au27SDxxbWdMywKt4Xcs5MxUdX2z6JSbcCbiHPotOhqUTksA7JZm4WdxQ96IJ4HopJN9
 /G61WyevgX0KgghIscLM/i2GEhhrj+KWuhqLNVjp4/w1kOE4D/uJKuiFGH9yTeovEGPc kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbed8ucsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:14 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FDaJIJ024479;
        Wed, 15 Mar 2023 14:35:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbed8ucr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FE0SQF032232;
        Wed, 15 Mar 2023 14:35:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pb29u8wps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FEZ7oM26477250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:35:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E942004D;
        Wed, 15 Mar 2023 14:35:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDCF22004F;
        Wed, 15 Mar 2023 14:35:05 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.95.209])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 14:35:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v18 01/17] s390x/cpu topology: add s390 specifics to CPU topology
Date:   Wed, 15 Mar 2023 15:34:46 +0100
Message-Id: <20230315143502.135750-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230315143502.135750-1-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dwYqQI5AlSpYZAJVSz1OT_EUtTHFWJYu
X-Proofpoint-ORIG-GUID: ZdV6BdxTQ_j5rtXZ0QcDqYjbfKhDfLot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390 adds two new SMP levels, drawers and books to the CPU
topology.
The S390 CPU have specific topology features like dedication
and entitlement to give to the guest indications on the host
vCPUs scheduling and help the guest take the best decisions
on the scheduling of threads on the vCPUs.

Let us provide the SMP properties with books and drawers levels
and S390 CPU with dedication and entitlement,

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 qapi/machine-common.json        | 22 +++++++++++++++
 qapi/machine-target.json        | 12 +++++++++
 qapi/machine.json               | 17 +++++++++---
 include/hw/boards.h             | 10 ++++++-
 include/hw/s390x/cpu-topology.h | 15 +++++++++++
 target/s390x/cpu.h              |  6 +++++
 hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
 hw/core/machine.c               |  4 +++
 hw/s390x/s390-virtio-ccw.c      |  2 ++
 softmmu/vl.c                    |  6 +++++
 target/s390x/cpu.c              |  7 +++++
 qapi/meson.build                |  1 +
 qemu-options.hx                 |  7 +++--
 13 files changed, 144 insertions(+), 13 deletions(-)
 create mode 100644 qapi/machine-common.json
 create mode 100644 include/hw/s390x/cpu-topology.h

diff --git a/qapi/machine-common.json b/qapi/machine-common.json
new file mode 100644
index 0000000000..73ea38d976
--- /dev/null
+++ b/qapi/machine-common.json
@@ -0,0 +1,22 @@
+# -*- Mode: Python -*-
+# vim: filetype=python
+#
+# This work is licensed under the terms of the GNU GPL, version 2 or later.
+# See the COPYING file in the top-level directory.
+
+##
+# = Machines S390 data types
+##
+
+##
+# @CpuS390Entitlement:
+#
+# An enumeration of cpu entitlements that can be assumed by a virtual
+# S390 CPU
+#
+# Since: 8.1
+##
+{ 'enum': 'CpuS390Entitlement',
+  'prefix': 'S390_CPU_ENTITLEMENT',
+  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
+
diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 2e267fa458..42a6a40333 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -342,3 +342,15 @@
                    'TARGET_S390X',
                    'TARGET_MIPS',
                    'TARGET_LOONGARCH64' ] } }
+
+##
+# @CpuS390Polarization:
+#
+# An enumeration of cpu polarization that can be assumed by a virtual
+# S390 CPU
+#
+# Since: 8.1
+##
+{ 'enum': 'CpuS390Polarization',
+  'prefix': 'S390_CPU_POLARIZATION',
+  'data': [ 'horizontal', 'vertical' ] }
diff --git a/qapi/machine.json b/qapi/machine.json
index 604b686e59..1cdd83f3fd 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -9,6 +9,7 @@
 ##
 
 { 'include': 'common.json' }
+{ 'include': 'machine-common.json' }
 
 ##
 # @SysEmuTarget:
@@ -70,7 +71,7 @@
 #
 # @thread-id: ID of the underlying host thread
 #
-# @props: properties describing to which node/socket/core/thread
+# @props: properties describing to which node/drawer/book/socket/core/thread
 #         virtual CPU belongs to, provided if supported by board
 #
 # @target: the QEMU system emulation target, which determines which
@@ -902,13 +903,15 @@
 # a CPU is being hotplugged.
 #
 # @node-id: NUMA node ID the CPU belongs to
-# @socket-id: socket number within node/board the CPU belongs to
+# @drawer-id: drawer number within node/board the CPU belongs to (since 8.1)
+# @book-id: book number within drawer/node/board the CPU belongs to (since 8.1)
+# @socket-id: socket number within book/node/board the CPU belongs to
 # @die-id: die number within socket the CPU belongs to (since 4.1)
 # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
 # @core-id: core number within cluster the CPU belongs to
 # @thread-id: thread number within core the CPU belongs to
 #
-# Note: currently there are 6 properties that could be present
+# Note: currently there are 8 properties that could be present
 #       but management should be prepared to pass through other
 #       properties with device_add command to allow for future
 #       interface extension. This also requires the filed names to be kept in
@@ -918,6 +921,8 @@
 ##
 { 'struct': 'CpuInstanceProperties',
   'data': { '*node-id': 'int',
+            '*drawer-id': 'int',
+            '*book-id': 'int',
             '*socket-id': 'int',
             '*die-id': 'int',
             '*cluster-id': 'int',
@@ -1467,6 +1472,10 @@
 #
 # @cpus: number of virtual CPUs in the virtual machine
 #
+# @drawers: number of drawers in the CPU topology (since 8.1)
+#
+# @books: number of books in the CPU topology (since 8.1)
+#
 # @sockets: number of sockets in the CPU topology
 #
 # @dies: number of dies per socket in the CPU topology
@@ -1483,6 +1492,8 @@
 ##
 { 'struct': 'SMPConfiguration', 'data': {
      '*cpus': 'int',
+     '*drawers': 'int',
+     '*books': 'int',
      '*sockets': 'int',
      '*dies': 'int',
      '*clusters': 'int',
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 6fbbfd56c8..9ef0bb76cf 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -131,12 +131,16 @@ typedef struct {
  * @clusters_supported - whether clusters are supported by the machine
  * @has_clusters - whether clusters are explicitly specified in the user
  *                 provided SMP configuration
+ * @books_supported - whether books are supported by the machine
+ * @drawers_supported - whether drawers are supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
     bool dies_supported;
     bool clusters_supported;
     bool has_clusters;
+    bool books_supported;
+    bool drawers_supported;
 } SMPCompatProps;
 
 /**
@@ -301,7 +305,9 @@ typedef struct DeviceMemoryState {
 /**
  * CpuTopology:
  * @cpus: the number of present logical processors on the machine
- * @sockets: the number of sockets on the machine
+ * @drawers: the number of drawers on the machine
+ * @books: the number of books in one drawer
+ * @sockets: the number of sockets in one book
  * @dies: the number of dies in one socket
  * @clusters: the number of clusters in one die
  * @cores: the number of cores in one cluster
@@ -310,6 +316,8 @@ typedef struct DeviceMemoryState {
  */
 typedef struct CpuTopology {
     unsigned int cpus;
+    unsigned int drawers;
+    unsigned int books;
     unsigned int sockets;
     unsigned int dies;
     unsigned int clusters;
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..83f31604cc
--- /dev/null
+++ b/include/hw/s390x/cpu-topology.h
@@ -0,0 +1,15 @@
+/*
+ * CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+#ifndef HW_S390X_CPU_TOPOLOGY_H
+#define HW_S390X_CPU_TOPOLOGY_H
+
+#define S390_TOPOLOGY_CPU_IFL   0x03
+
+#endif
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 7d6d01325b..f7b4cd78d1 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -131,6 +131,12 @@ struct CPUArchState {
 
 #if !defined(CONFIG_USER_ONLY)
     uint32_t core_id; /* PoP "CPU address", same as cpu_index */
+    int32_t socket_id;
+    int32_t book_id;
+    int32_t drawer_id;
+    bool dedicated;
+    uint8_t entitlement;        /* Used only for vertical polarization */
+    uint8_t shadow_entitlement; /* Shadow during horizontal polarization */
     uint64_t cpuid;
 #endif
 
diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index c3dab007da..b8233df5a9 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -31,6 +31,14 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     GString *s = g_string_new(NULL);
 
+    if (mc->smp_props.drawers_supported) {
+        g_string_append_printf(s, " * drawers (%u)", ms->smp.drawers);
+    }
+
+    if (mc->smp_props.books_supported) {
+        g_string_append_printf(s, " * books (%u)", ms->smp.books);
+    }
+
     g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
 
     if (mc->smp_props.dies_supported) {
@@ -73,6 +81,8 @@ void machine_parse_smp_config(MachineState *ms,
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     unsigned cpus    = config->has_cpus ? config->cpus : 0;
+    unsigned drawers = config->has_drawers ? config->drawers : 0;
+    unsigned books   = config->has_books ? config->books : 0;
     unsigned sockets = config->has_sockets ? config->sockets : 0;
     unsigned dies    = config->has_dies ? config->dies : 0;
     unsigned clusters = config->has_clusters ? config->clusters : 0;
@@ -85,6 +95,8 @@ void machine_parse_smp_config(MachineState *ms,
      * explicit configuration like "cpus=0" is not allowed.
      */
     if ((config->has_cpus && config->cpus == 0) ||
+        (config->has_drawers && config->drawers == 0) ||
+        (config->has_books && config->books == 0) ||
         (config->has_sockets && config->sockets == 0) ||
         (config->has_dies && config->dies == 0) ||
         (config->has_clusters && config->clusters == 0) ||
@@ -111,6 +123,19 @@ void machine_parse_smp_config(MachineState *ms,
     dies = dies > 0 ? dies : 1;
     clusters = clusters > 0 ? clusters : 1;
 
+    if (!mc->smp_props.books_supported && books > 1) {
+        error_setg(errp, "books not supported by this machine's CPU topology");
+        return;
+    }
+    books = books > 0 ? books : 1;
+
+    if (!mc->smp_props.drawers_supported && drawers > 1) {
+        error_setg(errp,
+                   "drawers not supported by this machine's CPU topology");
+        return;
+    }
+    drawers = drawers > 0 ? drawers : 1;
+
     /* compute missing values based on the provided ones */
     if (cpus == 0 && maxcpus == 0) {
         sockets = sockets > 0 ? sockets : 1;
@@ -124,33 +149,41 @@ void machine_parse_smp_config(MachineState *ms,
             if (sockets == 0) {
                 cores = cores > 0 ? cores : 1;
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (dies * clusters * cores * threads);
+                sockets = maxcpus /
+                          (drawers * books * dies * clusters * cores * threads);
             } else if (cores == 0) {
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (sockets * dies * clusters * threads);
+                cores = maxcpus /
+                        (drawers * books * sockets * dies * clusters * threads);
             }
         } else {
             /* prefer cores over sockets since 6.2 */
             if (cores == 0) {
                 sockets = sockets > 0 ? sockets : 1;
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (sockets * dies * clusters * threads);
+                cores = maxcpus /
+                        (drawers * books * sockets * dies * clusters * threads);
             } else if (sockets == 0) {
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (dies * clusters * cores * threads);
+                sockets = maxcpus /
+                          (drawers * books * dies * clusters * cores * threads);
             }
         }
 
         /* try to calculate omitted threads at last */
         if (threads == 0) {
-            threads = maxcpus / (sockets * dies * clusters * cores);
+            threads = maxcpus /
+                      (drawers * books * sockets * dies * clusters * cores);
         }
     }
 
-    maxcpus = maxcpus > 0 ? maxcpus : sockets * dies * clusters * cores * threads;
+    maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies *
+                                      clusters * cores * threads;
     cpus = cpus > 0 ? cpus : maxcpus;
 
     ms->smp.cpus = cpus;
+    ms->smp.drawers = drawers;
+    ms->smp.books = books;
     ms->smp.sockets = sockets;
     ms->smp.dies = dies;
     ms->smp.clusters = clusters;
@@ -161,7 +194,8 @@ void machine_parse_smp_config(MachineState *ms,
     mc->smp_props.has_clusters = config->has_clusters;
 
     /* sanity-check of the computed topology */
-    if (sockets * dies * clusters * cores * threads != maxcpus) {
+    if (drawers * books * sockets * dies * clusters * cores * threads !=
+        maxcpus) {
         g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
         error_setg(errp, "Invalid CPU topology: "
                    "product of the hierarchy must match maxcpus: "
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 1cf6822e06..41c7ba7027 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -831,6 +831,8 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
     MachineState *ms = MACHINE(obj);
     SMPConfiguration *config = &(SMPConfiguration){
         .has_cpus = true, .cpus = ms->smp.cpus,
+        .has_drawers = true, .drawers = ms->smp.drawers,
+        .has_books = true, .books = ms->smp.books,
         .has_sockets = true, .sockets = ms->smp.sockets,
         .has_dies = true, .dies = ms->smp.dies,
         .has_clusters = true, .clusters = ms->smp.clusters,
@@ -1096,6 +1098,8 @@ static void machine_initfn(Object *obj)
     /* default to mc->default_cpus */
     ms->smp.cpus = mc->default_cpus;
     ms->smp.max_cpus = mc->default_cpus;
+    ms->smp.drawers = 1;
+    ms->smp.books = 1;
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
     ms->smp.clusters = 1;
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 503f212a31..1a9bcda8b6 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -736,6 +736,8 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     mc->no_sdcard = 1;
     mc->max_cpus = S390_MAX_CPUS;
     mc->has_hotpluggable_cpus = true;
+    mc->smp_props.books_supported = true;
+    mc->smp_props.drawers_supported = true;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = s390_get_hotplug_handler;
     mc->cpu_index_to_instance_props = s390_cpu_index_to_props;
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 3340f63c37..bc293f8100 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -724,6 +724,12 @@ static QemuOptsList qemu_smp_opts = {
         {
             .name = "cpus",
             .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "drawers",
+            .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "books",
+            .type = QEMU_OPT_NUMBER,
         }, {
             .name = "sockets",
             .type = QEMU_OPT_NUMBER,
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index b10a8541ff..b80c617c53 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -37,6 +37,7 @@
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/reset.h"
 #endif
+#include "hw/s390x/cpu-topology.h"
 
 #define CR0_RESET       0xE0UL
 #define CR14_RESET      0xC2000000UL;
@@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
 static Property s390x_cpu_properties[] = {
 #if !defined(CONFIG_USER_ONLY)
     DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
+    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
+    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
+    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
+    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
+    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
+                      S390_CPU_ENTITLEMENT_MEDIUM),
 #endif
     DEFINE_PROP_END_OF_LIST()
 };
diff --git a/qapi/meson.build b/qapi/meson.build
index fbdb442fdf..b5b01fb7b5 100644
--- a/qapi/meson.build
+++ b/qapi/meson.build
@@ -35,6 +35,7 @@ qapi_all_modules = [
   'error',
   'introspect',
   'job',
+  'machine-common',
   'machine',
   'machine-target',
   'migration',
diff --git a/qemu-options.hx b/qemu-options.hx
index d42f60fb91..4c79e153fb 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -250,11 +250,14 @@ SRST
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
-    "-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
+    "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
+    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
     "                set the number of initial CPUs to 'n' [default=1]\n"
     "                maxcpus= maximum number of total CPUs, including\n"
     "                offline CPUs for hotplug, etc\n"
-    "                sockets= number of sockets on the machine board\n"
+    "                drawers= number of drawers on the machine board\n"
+    "                books= number of books in one drawer\n"
+    "                sockets= number of sockets in one book\n"
     "                dies= number of dies in one socket\n"
     "                clusters= number of clusters in one die\n"
     "                cores= number of cores in one cluster\n"
-- 
2.31.1

