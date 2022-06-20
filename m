Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66162551F34
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346889AbiFTOkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245121AbiFTOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCF065AD
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:47 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KCMKRH009951;
        Mon, 20 Jun 2022 13:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DwYIKfy6fpv2hjmSUuo2KjthR7ZfIXTCdnja0yTYkg0=;
 b=E+lJM0WHB7eOl0xqqJS6SPLREi4gG8QOEd4yppWpt8aDEiHnRZgWSt02RjETBEPHlNUj
 1XJGBV0vTlx7BBFxJfB96pKAmIeWoq95ZiDOl3p7skp9EXvcGwRrj1aEiCbub8vI8VC0
 0Kd8UYF1vWsjCjd5ExrlXrxZ4fC1ddTkSNaWjLK7viijgkkR3017GjvRr2oH8Z07MwgM
 DwQCT08WqUWGmue5UGQFquZPewPyvhjuSLwR/i6kVOPd+sopzWWFgBCuFvSz4y5+6p+T
 8VEH8WUW/fNqA6Qv3GRWCdN43DuwMV9Yf98eFKf1yff77baJRXZsx00mgAFx8ShI1B75 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrs7js2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:41 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KCJBTs019993;
        Mon, 20 Jun 2022 13:59:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrs7js1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDq55R006811;
        Mon, 20 Jun 2022 13:59:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gs6b8t267-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxar317957192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3983011C050;
        Mon, 20 Jun 2022 13:59:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6569911C052;
        Mon, 20 Jun 2022 13:59:35 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:35 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 06/12] s390x/cpu_topology: Adding drawers to CPU topology
Date:   Mon, 20 Jun 2022 16:03:46 +0200
Message-Id: <20220620140352.39398-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JP_IuQJkJPaVx27AVlCPCavxSFGPxGY1
X-Proofpoint-ORIG-GUID: Jmu1z-Q0vzPzkQYUP-qpr1ko40rVsAZl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390 CPU topology may have up to 5 topology containers.
The first container above the cores is level 2, the sockets,
and the level 3, containing sockets are the books.

We introduce here the drawers, drawers is the level containing books.

Let's add drawers, level4, containers to the CPU topology.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/core/machine-smp.c      | 33 ++++++++++++++++++++++++++-------
 hw/core/machine.c          |  2 ++
 hw/s390x/s390-virtio-ccw.c |  1 +
 include/hw/boards.h        |  4 ++++
 qapi/machine.json          |  9 +++++++--
 qemu-options.hx            |  5 +++--
 softmmu/vl.c               |  3 +++
 7 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index d7aa39d540..26150c748f 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -31,6 +31,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     GString *s = g_string_new(NULL);
 
+    if (mc->smp_props.drawers_supported) {
+        g_string_append_printf(s, " * drawers (%u)", ms->smp.drawers);
+    }
+
     if (mc->smp_props.books_supported) {
         g_string_append_printf(s, " * books (%u)", ms->smp.books);
     }
@@ -77,6 +81,7 @@ void machine_parse_smp_config(MachineState *ms,
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     unsigned cpus    = config->has_cpus ? config->cpus : 0;
+    unsigned drawers = config->has_drawers ? config->drawers : 0;
     unsigned books   = config->has_books ? config->books : 0;
     unsigned sockets = config->has_sockets ? config->sockets : 0;
     unsigned dies    = config->has_dies ? config->dies : 0;
@@ -90,6 +95,7 @@ void machine_parse_smp_config(MachineState *ms,
      * explicit configuration like "cpus=0" is not allowed.
      */
     if ((config->has_cpus && config->cpus == 0) ||
+        (config->has_drawers && config->drawers == 0) ||
         (config->has_books && config->books == 0) ||
         (config->has_sockets && config->sockets == 0) ||
         (config->has_dies && config->dies == 0) ||
@@ -124,6 +130,13 @@ void machine_parse_smp_config(MachineState *ms,
 
     books = books > 0 ? books : 1;
 
+    if (!mc->smp_props.drawers_supported && drawers > 1) {
+        error_setg(errp, "drawers not supported by this machine's CPU topology");
+        return;
+    }
+
+    drawers = drawers > 0 ? drawers : 1;
+
     /* compute missing values based on the provided ones */
     if (cpus == 0 && maxcpus == 0) {
         sockets = sockets > 0 ? sockets : 1;
@@ -137,34 +150,40 @@ void machine_parse_smp_config(MachineState *ms,
             if (sockets == 0) {
                 cores = cores > 0 ? cores : 1;
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (books * dies * clusters * cores * threads);
+                sockets = maxcpus /
+                          (drawers * books * dies * clusters * cores * threads);
             } else if (cores == 0) {
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (books * sockets * dies * clusters * threads);
+                cores = maxcpus /
+                        (drawers * books * sockets * dies * clusters * threads);
             }
         } else {
             /* prefer cores over sockets since 6.2 */
             if (cores == 0) {
                 sockets = sockets > 0 ? sockets : 1;
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (books * sockets * dies * clusters * threads);
+                cores = maxcpus /
+                        (drawers * books * sockets * dies * clusters * threads);
             } else if (sockets == 0) {
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (books * dies * clusters * cores * threads);
+                sockets = maxcpus /
+                         (drawers * books * dies * clusters * cores * threads);
             }
         }
 
         /* try to calculate omitted threads at last */
         if (threads == 0) {
-            threads = maxcpus / (books * sockets * dies * clusters * cores);
+            threads = maxcpus /
+                      (drawers * books * sockets * dies * clusters * cores);
         }
     }
 
-    maxcpus = maxcpus > 0 ? maxcpus : books * sockets * dies *
+    maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies *
                                       clusters * cores * threads;
     cpus = cpus > 0 ? cpus : maxcpus;
 
     ms->smp.cpus = cpus;
+    ms->smp.drawers = drawers;
     ms->smp.books = books;
     ms->smp.sockets = sockets;
     ms->smp.dies = dies;
@@ -174,7 +193,7 @@ void machine_parse_smp_config(MachineState *ms,
     ms->smp.max_cpus = maxcpus;
 
     /* sanity-check of the computed topology */
-    if (books * sockets * dies * clusters * cores * threads != maxcpus) {
+    if (drawers * books * sockets * dies * clusters * cores * threads != maxcpus) {
         g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
         error_setg(errp, "Invalid CPU topology: "
                    "product of the hierarchy must match maxcpus: "
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 8861f58d23..4c5c8d1655 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -821,6 +821,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
     MachineState *ms = MACHINE(obj);
     SMPConfiguration *config = &(SMPConfiguration){
         .has_cpus = true, .cpus = ms->smp.cpus,
+        .has_drawers = true, .drawers = ms->smp.drawers,
         .has_books = true, .books = ms->smp.books,
         .has_sockets = true, .sockets = ms->smp.sockets,
         .has_dies = true, .dies = ms->smp.dies,
@@ -1088,6 +1089,7 @@ static void machine_initfn(Object *obj)
     /* default to mc->default_cpus */
     ms->smp.cpus = mc->default_cpus;
     ms->smp.max_cpus = mc->default_cpus;
+    ms->smp.drawers = 1;
     ms->smp.books = 1;
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index ace65164d8..3b2a1f2729 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -620,6 +620,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     nc->nmi_monitor_handler = s390_nmi;
     mc->default_ram_id = "s390.ram";
     mc->smp_props.books_supported = true;
+    mc->smp_props.drawers_supported = true;
 }
 
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 2b44f50b6e..53014275b2 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -131,12 +131,14 @@ typedef struct {
  * @dies_supported - whether dies are supported by the machine
  * @clusters_supported - whether clusters are supported by the machine
  * @books_supported - whether books are supported by the machine
+ * @drawers_supported - whether drawers are supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
     bool dies_supported;
     bool clusters_supported;
     bool books_supported;
+    bool drawers_supported;
 } SMPCompatProps;
 
 /**
@@ -301,6 +303,7 @@ typedef struct DeviceMemoryState {
 /**
  * CpuTopology:
  * @cpus: the number of present logical processors on the machine
+ * @drawers: the number of drawers on the machine
  * @books: the number of books on the machine
  * @sockets: the number of sockets on the machine
  * @dies: the number of dies in one socket
@@ -311,6 +314,7 @@ typedef struct DeviceMemoryState {
  */
 typedef struct CpuTopology {
     unsigned int cpus;
+    unsigned int drawers;
     unsigned int books;
     unsigned int sockets;
     unsigned int dies;
diff --git a/qapi/machine.json b/qapi/machine.json
index f838b0c51f..bdd92e3cb1 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -900,14 +900,15 @@
 # a CPU is being hotplugged.
 #
 # @node-id: NUMA node ID the CPU belongs to
-# @book-id: book number within node/board the CPU belongs to
+# @drawer-id: drawer number within node/board the CPU belongs to
+# @book-id: book number within drawer/node/board the CPU belongs to
 # @socket-id: socket number within book/node/board the CPU belongs to
 # @die-id: die number within socket the CPU belongs to (since 4.1)
 # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
 # @core-id: core number within cluster the CPU belongs to
 # @thread-id: thread number within core the CPU belongs to
 #
-# Note: currently there are 6 properties that could be present
+# Note: currently there are 7 properties that could be present
 #       but management should be prepared to pass through other
 #       properties with device_add command to allow for future
 #       interface extension. This also requires the filed names to be kept in
@@ -917,6 +918,7 @@
 ##
 { 'struct': 'CpuInstanceProperties',
   'data': { '*node-id': 'int',
+            '*drawer-id': 'int',
             '*book-id': 'int',
             '*socket-id': 'int',
             '*die-id': 'int',
@@ -1467,6 +1469,8 @@
 #
 # @cpus: number of virtual CPUs in the virtual machine
 #
+# @drawers: number of drawers in the CPU topology
+#
 # @books: number of books in the CPU topology
 #
 # @sockets: number of sockets in the CPU topology
@@ -1485,6 +1489,7 @@
 ##
 { 'struct': 'SMPConfiguration', 'data': {
      '*cpus': 'int',
+     '*drawers': 'int',
      '*books': 'int',
      '*sockets': 'int',
      '*dies': 'int',
diff --git a/qemu-options.hx b/qemu-options.hx
index 9d72208f50..46aa79ee26 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -239,11 +239,12 @@ SRST
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
-    "-smp [[cpus=]n][,maxcpus=maxcpus][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
+    "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
     "                set the number of initial CPUs to 'n' [default=1]\n"
     "                maxcpus= maximum number of total CPUs, including\n"
     "                offline CPUs for hotplug, etc\n"
-    "                books= number of books on the machine board\n"
+    "                drawers= number of drawers on the machine board\n"
+    "                books= number of books in one drawer\n"
     "                sockets= number of sockets in one book\n"
     "                dies= number of dies in one socket\n"
     "                clusters= number of clusters in one die\n"
diff --git a/softmmu/vl.c b/softmmu/vl.c
index c13edd6948..299a85a97a 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -726,6 +726,9 @@ static QemuOptsList qemu_smp_opts = {
         {
             .name = "cpus",
             .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "drawers",
+            .type = QEMU_OPT_NUMBER,
         }, {
             .name = "books",
             .type = QEMU_OPT_NUMBER,
-- 
2.31.1

