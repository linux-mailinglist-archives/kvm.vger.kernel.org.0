Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6B74BA172
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241056AbiBQNkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:40:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241055AbiBQNkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:40:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68052AF91B
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:52 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HD78ND017142;
        Thu, 17 Feb 2022 13:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XlfUbGKIXyjLkCOXuSaAyixMwb3GLQHjhtWdw5btViY=;
 b=Rrk9CmlJ/dJ6iG1TbMYqOME8vMJ5N5z/2ujf8Of5G7HgQHs4GrQ06/MTLzSx+oZrWt55
 0rAuxck8Dge7TJ7YHRdF3M617czfWPrKWNfyEmUImIF5TpzMSPWIy9csbCEaREGW7WwZ
 A7fI1gjpiZbVHt57cKsYVATMsEcaiF1GRmy7wnaN0IAYfAf+4pCNErViTqtRfjEBtRcj
 o9YBppMbw4mVcJc5xoLmR/qOKjGICnIWvE3/oztQ2heCHOl7B9eJpkqRGylcUXGsKCMf
 izJjvcpmxe4paGcBi4zpevVs73O95NZCpoqcQY82/OOVtbx7MYJRcGBjtS6vWUmnXC1Z tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pnn926a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:31 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HD7CuH017555;
        Thu, 17 Feb 2022 13:39:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pnn925b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDaJw2006493;
        Thu, 17 Feb 2022 13:39:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3e64ha8h7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdKDM26476834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C30294C040;
        Thu, 17 Feb 2022 13:39:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06BDA4C050;
        Thu, 17 Feb 2022 13:39:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 10/11] s390x: topology: implementing numa for the s390x topology
Date:   Thu, 17 Feb 2022 14:41:24 +0100
Message-Id: <20220217134125.132150-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0IKO_m6LnnH4I17xvEutESH45vr5C-m5
X-Proofpoint-ORIG-GUID: Nt7AYThFzzFjl_8NJG3bOFdPaT8YX4uR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1db55e36c8..ee719965f7 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -687,6 +687,16 @@ void machine_set_cpu_numa_node(MachineState *machine,
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
@@ -704,6 +714,14 @@ void machine_set_cpu_numa_node(MachineState *machine,
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
index 03829e90b3..b50c304796 100644
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
 
@@ -579,7 +605,9 @@ static CpuInstanceProperties s390_cpu_index_to_props(MachineState *ms,
 static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
 {
     int i;
+    int drawer_id, book_id, socket_id;
     unsigned int max_cpus = ms->smp.max_cpus;
+    CPUArchId *slot;
 
     if (ms->possible_cpus) {
         g_assert(ms->possible_cpus && ms->possible_cpus->len == max_cpus);
@@ -590,11 +618,25 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
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
@@ -636,6 +678,17 @@ static ram_addr_t s390_fixup_ram_size(ram_addr_t sz)
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
@@ -668,6 +721,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     mc->default_ram_id = "s390.ram";
     mc->smp_props.books_supported = true;
     mc->smp_props.drawers_supported = true;
+    mc->get_default_cpu_node_id = s390_get_default_cpu_node_id;
 }
 
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
-- 
2.27.0

