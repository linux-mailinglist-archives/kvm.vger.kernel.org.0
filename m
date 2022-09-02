Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61725AA936
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbiIBH4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiIBH4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA255E65E
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:54 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827TA1x012542;
        Fri, 2 Sep 2022 07:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aZQ3LWyfk7i98cqZwj3iOzCQEqcgQcxObVsUX9FiE2w=;
 b=YERVMXndzQ/MqwEYkSZnKlHeCYklPi5s1msU8Evj30qGzHhbHTCyyZgfJlxfQHzA+Jnb
 SdWWBSp5HStxd3Shn/SLPXoegNA28CND6YBfAWAdRPOZdUAzunGdQb3SiG2/PC2TIbU4
 0WkwgDgDRkGt7zpk9lo35EFLk/4CNA2tOXSKrYBd93EFPjh2VgbLdISnNq/jvIba6bz2
 VjdS2bs75vpIgIJr067FYGe3lkvsDMgyyh8PfsxsXoov6D6jvsdRws6PB7AL0QhtOpac
 1061nXqL8A2J1wvz70RWShhqnFRXFSaR7eQxDqYTlFs55yv+Ws7W8QODqzk3B5hF0QSR DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmuux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:43 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2827r7GQ025173;
        Fri, 2 Sep 2022 07:55:43 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmuu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:43 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827q4uj017382;
        Fri, 2 Sep 2022 07:55:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3j7aw9drnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827tchl39190882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:55:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3B6D11C04A;
        Fri,  2 Sep 2022 07:55:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E54C811C04C;
        Fri,  2 Sep 2022 07:55:36 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:36 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 05/10] s390x/cpu: reporting drawers and books topology to the guest
Date:   Fri,  2 Sep 2022 09:55:26 +0200
Message-Id: <20220902075531.188916-6-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ABOE33HbwsckvklSabHo4jqbHjkuwZC_
X-Proofpoint-ORIG-GUID: CZvVaql7Ks0jOJW4EaEjjSiW9g7oXnYB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest can ask for a topology report on drawer's or book's
level.
Let's implement the STSI instruction's handling for the corresponding
selector values.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 19 +++++++---
 hw/s390x/s390-virtio-ccw.c      |  2 ++
 include/hw/s390x/cpu-topology.h |  7 +++-
 target/s390x/cpu_topology.c     | 64 +++++++++++++++++++++++++++------
 4 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index e2fd5c7e44..bb9ae63483 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -46,7 +46,7 @@ S390Topology *s390_get_topology(void)
 void s390_topology_new_cpu(int core_id)
 {
     S390Topology *topo = s390_get_topology();
-    int socket_id;
+    int socket_id, book_id, drawer_id;
     int bit, origin;
 
     /* In the case no Topology is used nothing is to be done here */
@@ -55,6 +55,8 @@ void s390_topology_new_cpu(int core_id)
     }
 
     socket_id = core_id / topo->cores;
+    book_id = socket_id / topo->sockets;
+    drawer_id = book_id / topo->books;
 
     bit = core_id;
     origin = bit / 64;
@@ -77,6 +79,8 @@ void s390_topology_new_cpu(int core_id)
      * CPU inside several CPU containers inside the socket container.
      */
     qemu_mutex_lock(&topo->topo_mutex);
+    topo->drawer[drawer_id].active_count++;
+    topo->book[book_id].active_count++;
     topo->socket[socket_id].active_count++;
     topo->tle[socket_id].active_count++;
     set_bit(bit, &topo->tle[socket_id].mask[origin]);
@@ -99,13 +103,20 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
     S390Topology *topo = S390_CPU_TOPOLOGY(dev);
     int n;
 
+    topo->drawers = ms->smp.drawers;
+    topo->books = ms->smp.books;
+    topo->total_books = topo->books * topo->drawers;
     topo->sockets = ms->smp.sockets;
+    topo->total_sockets = topo->sockets * topo->books * topo->drawers;
     topo->cores = ms->smp.cores;
-    topo->tles = ms->smp.max_cpus;
 
-    n = topo->sockets;
+    n = topo->drawers;
+    topo->drawer = g_malloc0(n * sizeof(S390TopoContainer));
+    n *= topo->books;
+    topo->book = g_malloc0(n * sizeof(S390TopoContainer));
+    n *= topo->sockets;
     topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
-    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
+    topo->tle = g_malloc0(n * sizeof(S390TopoTLE));
 
     qemu_mutex_init(&topo->topo_mutex);
 }
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 15cefd104b..3f28e28d47 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -626,6 +626,8 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     hc->unplug_request = s390_machine_device_unplug_request;
     nc->nmi_monitor_handler = s390_nmi;
     mc->default_ram_id = "s390.ram";
+    mc->smp_props.books_supported = true;
+    mc->smp_props.drawers_supported = true;
 }
 
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 0b7f3d10b2..4f8ac39ca0 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -29,9 +29,14 @@ typedef struct S390TopoTLE {
 
 struct S390Topology {
     SysBusDevice parent_obj;
+    int total_books;
+    int total_sockets;
+    int drawers;
+    int books;
     int sockets;
     int cores;
-    int tles;
+    S390TopoContainer *drawer;
+    S390TopoContainer *book;
     S390TopoContainer *socket;
     S390TopoTLE *tle;
     QemuMutex topo_mutex;
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
index 56865dafc6..305fbb9734 100644
--- a/target/s390x/cpu_topology.c
+++ b/target/s390x/cpu_topology.c
@@ -37,19 +37,18 @@ static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
     return p + sizeof(*tle);
 }
 
-static char *s390_top_set_level2(S390Topology *topo, char *p)
+static char *s390_top_set_level2(S390Topology *topo, char *p, int fs, int ns)
 {
-    int i, origin;
+    int socket, origin;
+    uint64_t mask;
 
-    for (i = 0; i < topo->sockets; i++) {
-        if (!topo->socket[i].active_count) {
+    for (socket = fs; socket < fs + ns; socket++) {
+        if (!topo->socket[socket].active_count) {
             continue;
         }
-        p = fill_container(p, 1, i);
+        p = fill_container(p, 1, socket);
         for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
-            uint64_t mask = 0L;
-
-            mask = be64_to_cpu(topo->tle[i].mask[origin]);
+            mask = be64_to_cpu(topo->tle[socket].mask[origin]);
             if (mask) {
                 p = fill_tle_cpu(p, mask, origin);
             }
@@ -58,19 +57,63 @@ static char *s390_top_set_level2(S390Topology *topo, char *p)
     return p;
 }
 
+static char *s390_top_set_level3(S390Topology *topo, char *p, int fb, int nb)
+{
+    int book, fs = 0;
+
+    for (book = fb; book < fb + nb; book++, fs += topo->sockets) {
+        if (!topo->book[book].active_count) {
+            continue;
+        }
+        p = fill_container(p, 2, book);
+    p = s390_top_set_level2(topo, p, fs, topo->sockets);
+    }
+    return p;
+}
+
+static char *s390_top_set_level4(S390Topology *topo, char *p)
+{
+    int drawer, fb = 0;
+
+    for (drawer = 0; drawer < topo->drawers; drawer++, fb += topo->books) {
+        if (!topo->drawer[drawer].active_count) {
+            continue;
+        }
+        p = fill_container(p, 3, drawer);
+        p = s390_top_set_level3(topo, p, fb, topo->books);
+    }
+    return p;
+}
+
 static int setup_stsi(SysIB_151x *sysib, int level)
 {
     S390Topology *topo = s390_get_topology();
     char *p = (char *)sysib->tle;
+    int max_containers;
 
     qemu_mutex_lock(&topo->topo_mutex);
 
     sysib->mnest = level;
     switch (level) {
     case 2:
+        max_containers = topo->sockets * topo->books * topo->drawers;
+        sysib->mag[TOPOLOGY_NR_MAG2] = max_containers;
+        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
+        p = s390_top_set_level2(topo, p, 0, max_containers);
+        break;
+    case 3:
+        max_containers = topo->books * topo->drawers;
+        sysib->mag[TOPOLOGY_NR_MAG3] = max_containers;
         sysib->mag[TOPOLOGY_NR_MAG2] = topo->sockets;
         sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
-        p = s390_top_set_level2(topo, p);
+        p = s390_top_set_level3(topo, p, 0, max_containers);
+        break;
+    case 4:
+        sysib->mag[TOPOLOGY_NR_MAG4] = topo->drawers;
+        sysib->mag[TOPOLOGY_NR_MAG3] = topo->books;
+        sysib->mag[TOPOLOGY_NR_MAG2] = topo->sockets;
+        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
+        p = s390_top_set_level4(topo, p);
         break;
     }
 
@@ -79,7 +122,7 @@ static int setup_stsi(SysIB_151x *sysib, int level)
     return p - (char *)sysib->tle;
 }
 
-#define S390_TOPOLOGY_MAX_MNEST 2
+#define S390_TOPOLOGY_MAX_MNEST 4
 void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
 {
     SysIB_151x *sysib;
@@ -105,4 +148,3 @@ void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
 out_free:
     g_free(sysib);
 }
-
-- 
2.31.1

