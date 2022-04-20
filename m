Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500AA508778
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378303AbiDTL5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378316AbiDTL5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD79510C7
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:47 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KBkdAA017128;
        Wed, 20 Apr 2022 11:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3R2SkwVYuAx37IyjubP80dsK6NGgHKH3SNnyQYbOdzw=;
 b=W3omiEnppv6Si4Yy9y3IBjjWd3DwLl4o2Jyng6SEN3y916k298z2NQNruPb93M0GDw4n
 Ii9oEfbmuXJ8eiw2drcAfO0kQdkstaV2+5LDP20QyIWj88wqn+7lAaVkmDp0qoX2Ppgg
 D6oT7/i6ONoUaBsJDerJbs/ukL3Pc4/m1AJjufRzoTRpvVDqhAIfmkEbe6jbCZEHBeLv
 6LoaVgLN+KVe5y9gKc3lHW3FJXQcKApyCMofsXJaBOet8E5yN+a0Z9IY2rLPnBIC4lAy
 SJ/qUFzje/U55KEmU57q0bvFa8oFc0pEf3YIO3Zd95jOgNO7LBbxCoWbKDzG705TWHQg eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fhsx95nuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:43 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBp4Kx032542;
        Wed, 20 Apr 2022 11:54:43 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fhsx95nu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBrB03021340;
        Wed, 20 Apr 2022 11:54:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8vx4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBfoYb53936390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:41:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22D20AE059;
        Wed, 20 Apr 2022 11:54:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A2A7AE045;
        Wed, 20 Apr 2022 11:54:37 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 09/13] s390x: topology: implementing numa for the s390x topology
Date:   Wed, 20 Apr 2022 13:57:41 +0200
Message-Id: <20220420115745.13696-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2T9JX2Q5DguUQYtMboUEr4pszlXYxCLN
X-Proofpoint-ORIG-GUID: hXMMHF8IYjMoWqQNwKHL5zJLfTD09_V4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390x CPU Topology allows a non uniform repartition of the CPU
inside the topology containers, sockets, books and drawers.

We use numa to place the CPU inside the right topology container
and report the non uniform topology to the guest.

Note that s390x needs CPU0 to belong to the topology and consequently
all topology must include CPU0.

We accept a partial QEMU numa definition, in that case undefined CPUs
are added to free slots in the topology starting with slot 0 and going
up.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/core/machine.c          | 18 ++++++++++
 hw/s390x/s390-virtio-ccw.c | 68 ++++++++++++++++++++++++++++++++++----
 2 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index b67f213654..e9847693f0 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -689,6 +689,16 @@ void machine_set_cpu_numa_node(MachineState *machine,
             return;
         }
 
+        if (props->has_book_id && !slot->props.has_book_id) {
+            error_setg(errp, "book-id is not supported");
+            return;
+        }
+
+        if (props->has_drawer_id && !slot->props.has_drawer_id) {
+            error_setg(errp, "drawer-id is not supported");
+            return;
+        }
+
         /* skip slots with explicit mismatch */
         if (props->has_thread_id && props->thread_id != slot->props.thread_id) {
                 continue;
@@ -706,6 +716,14 @@ void machine_set_cpu_numa_node(MachineState *machine,
                 continue;
         }
 
+        if (props->has_book_id && props->book_id != slot->props.book_id) {
+                continue;
+        }
+
+        if (props->has_drawer_id && props->drawer_id != slot->props.drawer_id) {
+                continue;
+        }
+
         /* reject assignment if slot is already assigned, for compatibility
          * of legacy cpu_index mapping with SPAPR core based mapping do not
          * error out if cpu thread and matched core have the same node-id */
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 2839c24833..93d1a43583 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -84,14 +84,34 @@ out:
 static void s390_init_cpus(MachineState *machine)
 {
     MachineClass *mc = MACHINE_GET_CLASS(machine);
-    int i;
+    CPUArchId *slot;
+    int i, n = 0;
 
     /* initialize possible_cpus */
     mc->possible_cpu_arch_ids(machine);
 
     s390_topology_setup(machine);
-    for (i = 0; i < machine->smp.cpus; i++) {
+
+    /* For NUMA configuration create defined nodes */
+    if (machine->numa_state->num_nodes) {
+        for (i = 0; i < machine->smp.max_cpus; i++) {
+            slot = &machine->possible_cpus->cpus[i];
+            if (slot->arch_id != -1 && n < machine->smp.cpus) {
+                s390x_new_cpu(machine->cpu_type, i, &error_fatal);
+                n++;
+            }
+        }
+    }
+
+    /* create all remaining CPUs */
+    for (i = 0; n < machine->smp.cpus && i < machine->smp.max_cpus; i++) {
+        slot = &machine->possible_cpus->cpus[i];
+        /* For NUMA configuration skip defined nodes */
+        if (machine->numa_state->num_nodes && slot->arch_id != -1) {
+            continue;
+        }
         s390x_new_cpu(machine->cpu_type, i, &error_fatal);
+        n++;
     }
 }
 
@@ -274,6 +294,11 @@ static void ccw_init(MachineState *machine)
     /* register hypercalls */
     virtio_ccw_register_hcalls();
 
+    /* CPU0 must exist on S390x */
+    if (!s390_cpu_addr2state(0)) {
+        error_printf("Core_id 0 must be defined in the CPU configuration\n");
+        exit(1);
+    }
     s390_enable_css_support(s390_cpu_addr2state(0));
 
     ret = css_create_css_image(VIRTUAL_CSSID, true);
@@ -306,6 +331,7 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
 
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
+    ms->possible_cpus->cpus[cpu->env.core_id].arch_id = cpu->env.core_id;
 
     s390_topology_new_cpu(cpu->env.core_id);
 
@@ -529,7 +555,9 @@ static CpuInstanceProperties s390_cpu_index_to_props(MachineState *ms,
 static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
 {
     int i;
+    int drawer_id, book_id, socket_id;
     unsigned int max_cpus = ms->smp.max_cpus;
+    CPUArchId *slot;
 
     if (ms->possible_cpus) {
         g_assert(ms->possible_cpus && ms->possible_cpus->len == max_cpus);
@@ -540,11 +568,25 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
                                   sizeof(CPUArchId) * max_cpus);
     ms->possible_cpus->len = max_cpus;
     for (i = 0; i < ms->possible_cpus->len; i++) {
-        ms->possible_cpus->cpus[i].type = ms->cpu_type;
-        ms->possible_cpus->cpus[i].vcpus_count = 1;
-        ms->possible_cpus->cpus[i].arch_id = i;
-        ms->possible_cpus->cpus[i].props.has_core_id = true;
-        ms->possible_cpus->cpus[i].props.core_id = i;
+        slot = &ms->possible_cpus->cpus[i];
+
+        slot->type = ms->cpu_type;
+        slot->vcpus_count = 1;
+        slot->arch_id = i;
+        slot->props.has_core_id = true;
+        slot->props.core_id = i;
+
+        socket_id = i / ms->smp.cores;
+        slot->props.socket_id = socket_id;
+        slot->props.has_socket_id = true;
+
+        book_id = socket_id / ms->smp.sockets;
+        slot->props.book_id = book_id;
+        slot->props.has_book_id = true;
+
+        drawer_id = book_id / ms->smp.books;
+        slot->props.drawer_id = drawer_id;
+        slot->props.has_drawer_id = true;
     }
 
     return ms->possible_cpus;
@@ -586,6 +628,17 @@ static ram_addr_t s390_fixup_ram_size(ram_addr_t sz)
     return newsz;
 }
 
+/*
+ * S390 defines CPU topology level 2 as the level for which a change in topology
+ * is worth being taking care of.
+ * Let use level 2, socket, as the numa node.
+ */
+static int64_t s390_get_default_cpu_node_id(const MachineState *ms, int idx)
+{
+    ms->possible_cpus->cpus[idx].arch_id = -1;
+    return idx / ms->smp.cores;
+}
+
 static void ccw_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -618,6 +671,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     mc->default_ram_id = "s390.ram";
     mc->smp_props.books_supported = true;
     mc->smp_props.drawers_supported = true;
+    mc->get_default_cpu_node_id = s390_get_default_cpu_node_id;
 }
 
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
-- 
2.27.0

