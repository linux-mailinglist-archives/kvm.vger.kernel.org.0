Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAE46E957
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhLINtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238160AbhLINtk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:40 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9CTFa0001571;
        Thu, 9 Dec 2021 13:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uZhwWxuk4hnC1OSfRyA8nTxyJ6ATd6+1HLh5BIsGbYI=;
 b=G37wXOFToY/gUzt0NyRuatpMgB5Ss+/hLZUItywvxraPOuDG/uz9XLS8qMq6EVFAclNu
 KHiHcvoj7j/izonFyhDj/ZR5XOoRKJiUz34f5rRWeOxr2voNHni7dElMCyE2T96vtJbp
 la2uY5OuQuXCu4GRtD6tnLlsV0hgrgCm23GmihhR4hCkoDoaZluSH65dC605+YUUS0Da
 hbcCDsGBFCaAcKQ4KOv2EblmUETskYVbmIHfehPMKIsmYdPUPmOU8FDiK+iVEc2OE4RC
 v4V0+Z4fYm8ti5+wotvb3pELF/a+9rVtR/hoYsybvBrwemNTF1gIErTLmrPr8U+qLJOR wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhuchmea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:46:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9CV3qC009524;
        Thu, 9 Dec 2021 13:46:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhuchmd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:46:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DbuxD010450;
        Thu, 9 Dec 2021 13:45:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3cqyya01wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9DjuaW29557094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:45:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30EDF11C069;
        Thu,  9 Dec 2021 13:45:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6356B11C04C;
        Thu,  9 Dec 2021 13:45:55 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 11/12] s390x: topology: implementing numa for the s390x topology
Date:   Thu,  9 Dec 2021 14:46:42 +0100
Message-Id: <20211209134643.143866-12-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K2p3v4xXLpkX6h2bYZUZ-KLU3ZoC82_G
X-Proofpoint-ORIG-GUID: yfLuIDe9YJ753H14iU6cjFCkGLjpDOQJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090075
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
index 0059070309..d65a91c607 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -684,6 +684,16 @@ void machine_set_cpu_numa_node(MachineState *machine,
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
@@ -701,6 +711,14 @@ void machine_set_cpu_numa_node(MachineState *machine,
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
index cd27b4c3af..dcd6a1cf19 100644
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

