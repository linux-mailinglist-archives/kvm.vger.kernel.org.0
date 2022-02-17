Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B174BA176
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241039AbiBQNjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:39:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241024AbiBQNjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:39:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8982AF91F
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:30 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HClu7v004858;
        Thu, 17 Feb 2022 13:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1uRx7eaMt/rq3iXfLXNxdyNAjQrj1YDxEMg4kbAOaG8=;
 b=n0/wfoZECalh+plfk6DVdeQES4BujkBPKxgId1LdNieBSIy/yaTJymFYK0GyBwUCkTqN
 QKOwnwE/dYXvrop9EGQa8nbpspongP/BgJWBYpFWCBGhyboIZHLsg/H3MTJCDIZg8vmY
 HOLpjf4sH5dGSuUGU9MZgtnZbFxSV5JN5CpSfM0NQhCNkch6jr1MHmPZeLunQDUKjB5Y
 hSacmIaJdBkoq2C197Nzb1q2F3AM6/kyLrwGnh2Gn5OPH0lkF1HyAA+SzmCQGnvT1hj6
 NcQzr2Bn/+L3DWQaj2AkLDr6BG0eefn+7eacp743BJQ+017ELbOsKPK1svFVB6X/62nS mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9h6tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HDVoeu015015;
        Thu, 17 Feb 2022 13:39:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9h6sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDbbkR005925;
        Thu, 17 Feb 2022 13:39:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64hajpns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdJ8M41091562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0462D4C04A;
        Thu, 17 Feb 2022 13:39:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 355774C050;
        Thu, 17 Feb 2022 13:39:18 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:18 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 08/11] s390x: topology: Adding drawers to CPU topology
Date:   Thu, 17 Feb 2022 14:41:22 +0100
Message-Id: <20220217134125.132150-9-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4KKvB9rlSgEEDIyrLFcDew-qa4Y03ePP
X-Proofpoint-ORIG-GUID: kYVCi434abXOs4csHQRpGpQg1phae-gV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 qapi/machine.json          |  7 ++++++-
 softmmu/vl.c               |  3 +++
 6 files changed, 42 insertions(+), 8 deletions(-)

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
index b8c624d2bf..1db55e36c8 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -743,6 +743,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
     MachineState *ms = MACHINE(obj);
     SMPConfiguration *config = &(SMPConfiguration){
         .has_cpus = true, .cpus = ms->smp.cpus,
+        .has_drawers = true, .drawers = ms->smp.drawers,
         .has_books = true, .books = ms->smp.books,
         .has_sockets = true, .sockets = ms->smp.sockets,
         .has_dies = true, .dies = ms->smp.dies,
@@ -936,6 +937,7 @@ static void machine_initfn(Object *obj)
     /* default to mc->default_cpus */
     ms->smp.cpus = mc->default_cpus;
     ms->smp.max_cpus = mc->default_cpus;
+    ms->smp.drawers = 1;
     ms->smp.books = 1;
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 193883fba3..03829e90b3 100644
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
index bc0f7f22dc..abc5556c50 100644
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
index 73206f811a..fa6bde5617 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -866,13 +866,14 @@
 # a CPU is being hotplugged.
 #
 # @node-id: NUMA node ID the CPU belongs to
+# @drawer-id: drawer number within node/board the CPU belongs to
 # @book-id: book number within node/board the CPU belongs to
 # @socket-id: socket number within node/board the CPU belongs to
 # @die-id: die number within socket the CPU belongs to (since 4.1)
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
@@ -1402,6 +1404,8 @@
 #
 # @cpus: number of virtual CPUs in the virtual machine
 #
+# @drawers: number of drawers in the CPU topology
+#
 # @books: number of books in the CPU topology
 #
 # @sockets: number of sockets in the CPU topology
@@ -1420,6 +1424,7 @@
 ##
 { 'struct': 'SMPConfiguration', 'data': {
      '*cpus': 'int',
+     '*drawers': 'int',
      '*books': 'int',
      '*sockets': 'int',
      '*dies': 'int',
diff --git a/softmmu/vl.c b/softmmu/vl.c
index a680fb12d4..f4c9f3a536 100644
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

