Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE805AA931
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiIBH4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiIBH4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8F75E57B
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827C1Ax012108;
        Fri, 2 Sep 2022 07:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dIj7/NWLQjTOw/2fKUtwwGaplkwLrVJjfmTjOSLYbIM=;
 b=n9ClvyULfjBvKM7P5E5mYYvBvztG+fdzJXQ1QXNHd1wWxCDMVm2nbpbPbfj++bdYcGmB
 JPZzMBGijfyAxFdDXxAvFl1bfTMgty+w9kkz6xX4uDphHIqLZzfRmRT29y5avVc7Ivlt
 ILdzfIcdpEeZn4mIYqDF/CRMp6MXXDmqCz6SLCt1DFcm0Bj+qHMVLasos3XeDK522CZt
 KMroWfi8DyhePnXtR7QZFqJi3w4R28sTA9SSKXOnYmdLzkp36zIjEwvj5zReqDkceqZw
 ABqVo9CTei5Ygw05pVywUj+nwaC9UrYnm+yak84YmkFgl3o6DvlLIO1X4JTnSlKaf1dN kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbd7p1c0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2827D2dB017454;
        Fri, 2 Sep 2022 07:55:47 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbd7p1byj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:47 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827oM03030468;
        Fri, 2 Sep 2022 07:55:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3j7aw8wr3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827tffH41615724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:55:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8712A11C058;
        Fri,  2 Sep 2022 07:55:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD5D911C04C;
        Fri,  2 Sep 2022 07:55:40 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:40 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 09/10] s390x/cpu_topology: activating CPU topology
Date:   Fri,  2 Sep 2022 09:55:30 +0200
Message-Id: <20220902075531.188916-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ynlcCBh7AFSgXb8LuuqijXm-82dDIZ9V
X-Proofpoint-ORIG-GUID: JWn7NTNa1gpzQuIc8QbFcldRzodEwPxX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with a new machine, s390-virtio-ccw-7.2, the machine
property topology-disable is set to false while it is kept to
true for older machine.
This allows migrating older machine without disabling the ctop
CPU feature for older machine, thus keeping existing start scripts.

The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
the topology facility for the guest in the case the topology
is not disabled.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/core/machine.c                  |  5 +++
 hw/s390x/s390-virtio-ccw.c         | 55 ++++++++++++++++++++++++++----
 include/hw/boards.h                |  3 ++
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 target/s390x/kvm/kvm.c             | 14 ++++++++
 5 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 4c5c8d1655..cbcdd40763 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -40,6 +40,11 @@
 #include "hw/virtio/virtio-pci.h"
 #include "qom/object_interfaces.h"
 
+GlobalProperty hw_compat_7_1[] = {
+    { "s390x-cpu", "ctop", "off"},
+};
+const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
+
 GlobalProperty hw_compat_7_0[] = {
     { "arm-gicv3-common", "force-8-bit-prio", "on" },
     { "nvme-ns", "eui64-default", "on"},
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 1fa98740de..3078e68df7 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -249,11 +249,16 @@ static void ccw_init(MachineState *machine)
     /* init memory + setup max page size. Required for the CPU model */
     s390_memory_init(machine->ram);
 
-    /* Adding the topology must be done before CPU intialization*/
-    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
-    object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,
-                              OBJECT(dev));
-    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    /*
+     * Adding the topology must be done before CPU intialization but
+     * only in the case it is not disabled for migration purpose.
+     */
+    if (!S390_CCW_MACHINE(machine)->topology_disable) {
+        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
+        object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,
+                                  OBJECT(dev));
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    }
 
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
@@ -676,6 +681,21 @@ static inline void machine_set_zpcii_disable(Object *obj, bool value,
     ms->zpcii_disable = value;
 }
 
+static inline bool machine_get_topology_disable(Object *obj, Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    return ms->topology_disable;
+}
+
+static inline void machine_set_topology_disable(Object *obj, bool value,
+                                                Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    ms->topology_disable = value;
+}
+
 static S390CcwMachineClass *current_mc;
 
 /*
@@ -778,6 +798,13 @@ static inline void s390_machine_initfn(Object *obj)
     object_property_set_description(obj, "zpcii-disable",
             "disable zPCI interpretation facilties");
     object_property_set_bool(obj, "zpcii-disable", false, NULL);
+
+    object_property_add_bool(obj, "topology-disable",
+                             machine_get_topology_disable,
+                             machine_set_topology_disable);
+    object_property_set_description(obj, "topology-disable",
+            "disable zPCI interpretation facilties");
+    object_property_set_bool(obj, "topology-disable", false, NULL);
 }
 
 static const TypeInfo ccw_machine_info = {
@@ -830,14 +857,29 @@ bool css_migration_enabled(void)
     }                                                                         \
     type_init(ccw_machine_register_##suffix)
 
+static void ccw_machine_7_2_instance_options(MachineState *machine)
+{
+}
+
+static void ccw_machine_7_2_class_options(MachineClass *mc)
+{
+}
+DEFINE_CCW_MACHINE(7_2, "7.2", true);
+
 static void ccw_machine_7_1_instance_options(MachineState *machine)
 {
+    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
+
+    ccw_machine_7_2_instance_options(machine);
+    ms->topology_disable = true;
 }
 
 static void ccw_machine_7_1_class_options(MachineClass *mc)
 {
+    ccw_machine_7_2_class_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
 }
-DEFINE_CCW_MACHINE(7_1, "7.1", true);
+DEFINE_CCW_MACHINE(7_1, "7.1", false);
 
 static void ccw_machine_7_0_instance_options(MachineState *machine)
 {
@@ -847,6 +889,7 @@ static void ccw_machine_7_0_instance_options(MachineState *machine)
     ccw_machine_7_1_instance_options(machine);
     s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
     ms->zpcii_disable = true;
+
 }
 
 static void ccw_machine_7_0_class_options(MachineClass *mc)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 69e20c1252..6e9803aa2d 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -387,6 +387,9 @@ struct MachineState {
     } \
     type_init(machine_initfn##_register_types)
 
+extern GlobalProperty hw_compat_7_1[];
+extern const size_t hw_compat_7_1_len;
+
 extern GlobalProperty hw_compat_7_0[];
 extern const size_t hw_compat_7_0_len;
 
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 9e7a0d75bc..b14660eecb 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -28,6 +28,7 @@ struct S390CcwMachineState {
     bool dea_key_wrap;
     bool pv;
     bool zpcii_disable;
+    bool topology_disable;
     uint8_t loadparm[8];
 };
 
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index cb14bcc012..6b7efee511 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2385,6 +2385,7 @@ bool kvm_s390_cpu_models_supported(void)
 
 void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
 {
+    S390CcwMachineState *ms = S390_CCW_MACHINE(qdev_get_machine());
     struct kvm_s390_vm_cpu_machine prop = {};
     struct kvm_device_attr attr = {
         .group = KVM_S390_VM_CPU_MODEL,
@@ -2466,6 +2467,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         set_bit(S390_FEAT_UNPACK, model->features);
     }
 
+    /*
+     * If we have the CPU Topology implemented in KVM activate
+     * the CPU TOPOLOGY feature.
+     */
+    if ((!ms->topology_disable) &&
+        kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
+        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
+            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
+            return;
+        }
+        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
+    }
+
     /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
     set_bit(S390_FEAT_ZPCI, model->features);
     set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
-- 
2.31.1

