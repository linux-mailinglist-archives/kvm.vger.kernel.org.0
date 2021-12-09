Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F23646E955
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhLINtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238157AbhLINtj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:39 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DbMBl016112;
        Thu, 9 Dec 2021 13:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B/IjLrsiM8t6NInZdyXLPGkI+tFJ9jcLKNg7OY22Eqw=;
 b=MTCyRAcm7Lkavk8r+4HdKKbtZMr+Wunc62o7F2/Y3ol6/XOXn69leO1eRt2WPgo5Ig+j
 hoYNAGYNB1P7HVe2Xl4Et1ux7vytC5jgK0uSXPrvdG0O5H1hRKdTFWmi5Cb7lhxH8dzG
 VBvHgQpH7RLNtQtPLaPQiM9k+VslQx9w+zJSn7Hr7W6Io7ZBNDXZW00/rz653pgQMpWW
 DzLGPPw3lostM2jvg2dJ+/YN91gmW+PyKLIEx2mir8CfIf1KAyYTN2cIdVmyXNsZvUEX
 uICcTaBrX7HxumuyNSBDlaVDRChKvaTc077G6PdnBd9HPFt9GLHSFje4rtl47QIRgqqJ LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhd4264b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:46:01 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DdgEm021849;
        Thu, 9 Dec 2021 13:46:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhd42634-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:46:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DjZ7N025079;
        Thu, 9 Dec 2021 13:45:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb9x8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9DjsND19005882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:45:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7154E11C050;
        Thu,  9 Dec 2021 13:45:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA44911C04C;
        Thu,  9 Dec 2021 13:45:53 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:53 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 09/12] s390: topology: Adding drawers to CPU topology
Date:   Thu,  9 Dec 2021 14:46:40 +0100
Message-Id: <20211209134643.143866-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8a_U--OVCr39D_l7Dzxy1knFl4J6mhvA
X-Proofpoint-GUID: VqCyLunvLalUjqiUqhUFZkkHcheKx4Uw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090075
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
 hw/core/machine-smp.c      | 28 +++++++++++++++++++++-------
 hw/core/machine.c          |  2 ++
 hw/s390x/s390-virtio-ccw.c |  1 +
 include/hw/boards.h        |  4 ++++
 qapi/machine.json          |  7 ++++++-
 softmmu/vl.c               |  3 +++
 6 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 4848f546cf..b80a7785b4 100644
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
@@ -71,6 +75,7 @@ void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     unsigned cpus    = config->has_cpus ? config->cpus : 0;
+    unsigned drawers = config->has_drawers ? config->drawers : 0;
     unsigned books   = config->has_books ? config->books : 0;
     unsigned sockets = config->has_sockets ? config->sockets : 0;
     unsigned dies    = config->has_dies ? config->dies : 0;
@@ -83,6 +88,7 @@ void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
      * explicit configuration like "cpus=0" is not allowed.
      */
     if ((config->has_cpus && config->cpus == 0) ||
+        (config->has_drawers && config->drawers == 0) ||
         (config->has_books && config->books == 0) ||
         (config->has_sockets && config->sockets == 0) ||
         (config->has_dies && config->dies == 0) ||
@@ -111,6 +117,13 @@ void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
 
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
@@ -124,33 +137,34 @@ void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
             if (sockets == 0) {
                 cores = cores > 0 ? cores : 1;
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (books * dies * cores * threads);
+                sockets = maxcpus / (drawers * books * dies * cores * threads);
             } else if (cores == 0) {
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (books * sockets * dies * threads);
+                cores = maxcpus / (drawers * books * sockets * dies * threads);
             }
         } else {
             /* prefer cores over sockets since 6.2 */
             if (cores == 0) {
                 sockets = sockets > 0 ? sockets : 1;
                 threads = threads > 0 ? threads : 1;
-                cores = maxcpus / (books * sockets * dies * threads);
+                cores = maxcpus / (drawers * books * sockets * dies * threads);
             } else if (sockets == 0) {
                 threads = threads > 0 ? threads : 1;
-                sockets = maxcpus / (books * dies * cores * threads);
+                sockets = maxcpus / (drawers * books * dies * cores * threads);
             }
         }
 
         /* try to calculate omitted threads at last */
         if (threads == 0) {
-            threads = maxcpus / (books * sockets * dies * cores);
+            threads = maxcpus / (drawers * books * sockets * dies * cores);
         }
     }
 
-    maxcpus = maxcpus > 0 ? maxcpus : books * sockets * dies * cores * threads;
+    maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies * cores * threads;
     cpus = cpus > 0 ? cpus : maxcpus;
 
     ms->smp.cpus = cpus;
+    ms->smp.drawers = drawers;
     ms->smp.books = books;
     ms->smp.sockets = sockets;
     ms->smp.dies = dies;
@@ -159,7 +173,7 @@ void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
     ms->smp.max_cpus = maxcpus;
 
     /* sanity-check of the computed topology */
-    if (books * sockets * dies * cores * threads != maxcpus) {
+    if (drawers * books * sockets * dies * cores * threads != maxcpus) {
         g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
         error_setg(errp, "Invalid CPU topology: "
                    "product of the hierarchy must match maxcpus: "
diff --git a/hw/core/machine.c b/hw/core/machine.c
index d98c9105f7..0059070309 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -740,6 +740,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
     MachineState *ms = MACHINE(obj);
     SMPConfiguration *config = &(SMPConfiguration){
         .has_cpus = true, .cpus = ms->smp.cpus,
+        .has_drawers = true, .drawers = ms->smp.drawers,
         .has_books = true, .books = ms->smp.books,
         .has_sockets = true, .sockets = ms->smp.sockets,
         .has_dies = true, .dies = ms->smp.dies,
@@ -931,6 +932,7 @@ static void machine_initfn(Object *obj)
     /* default to mc->default_cpus */
     ms->smp.cpus = mc->default_cpus;
     ms->smp.max_cpus = mc->default_cpus;
+    ms->smp.drawers = 1;
     ms->smp.books = 1;
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index b3c405b4d0..cd27b4c3af 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -667,6 +667,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     nc->nmi_monitor_handler = s390_nmi;
     mc->default_ram_id = "s390.ram";
     mc->smp_props.books_supported = true;
+    mc->smp_props.drawers_supported = true;
 }
 
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 68c58b4b4a..5754a59215 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -129,11 +129,13 @@ typedef struct {
  * @prefer_sockets - whether sockets are preferred over cores in smp parsing
  * @dies_supported - whether dies are supported by the machine
  * @books_supported - whether books are supported by the machine
+ * @drawers_supported - whether drawers are supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
     bool dies_supported;
     bool books_supported;
+    bool drawers_supported;
 } SMPCompatProps;
 
 /**
@@ -298,6 +300,7 @@ typedef struct DeviceMemoryState {
 /**
  * CpuTopology:
  * @cpus: the number of present logical processors on the machine
+ * @drawers: the number of drawers on the machine
  * @books: the number of books on the machine
  * @sockets: the number of sockets on the machine
  * @dies: the number of dies in one socket
@@ -307,6 +310,7 @@ typedef struct DeviceMemoryState {
  */
 typedef struct CpuTopology {
     unsigned int cpus;
+    unsigned int drawers;
     unsigned int books;
     unsigned int sockets;
     unsigned int dies;
diff --git a/qapi/machine.json b/qapi/machine.json
index 5761c02070..3e0666d95e 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -866,13 +866,14 @@
 # a CPU is being hotplugged.
 #
 # @node-id: NUMA node ID the CPU belongs to
+# @drawer-id: drawer number within node/board the CPU belongs to
 # @book-id: book number within node/board the CPU belongs to
 # @socket-id: socket number within node/board the CPU belongs to
 # @die-id: die number within node/board the CPU belongs to (Since 4.1)
 # @core-id: core number within die the CPU belongs to
 # @thread-id: thread number within core the CPU belongs to
 #
-# Note: currently there are 6 properties that could be present
+# Note: currently there are 7 properties that could be present
 #       but management should be prepared to pass through other
 #       properties with device_add command to allow for future
 #       interface extension. This also requires the filed names to be kept in
@@ -882,6 +883,7 @@
 ##
 { 'struct': 'CpuInstanceProperties',
   'data': { '*node-id': 'int',
+            '*drawer-id': 'int',
             '*book-id': 'int',
             '*socket-id': 'int',
             '*die-id': 'int',
@@ -1394,6 +1396,8 @@
 #
 # @cpus: number of virtual CPUs in the virtual machine
 #
+# @drawers: number of drawers in the CPU topology
+#
 # @books: number of books in the CPU topology
 #
 # @sockets: number of sockets in the CPU topology
@@ -1410,6 +1414,7 @@
 ##
 { 'struct': 'SMPConfiguration', 'data': {
      '*cpus': 'int',
+     '*drawers': 'int',
      '*books': 'int',
      '*sockets': 'int',
      '*dies': 'int',
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 764403d0b3..73d2428da1 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -720,6 +720,9 @@ static QemuOptsList qemu_smp_opts = {
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
2.27.0

