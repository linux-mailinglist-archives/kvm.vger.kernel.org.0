Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DB55FC910
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJLQVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJLQVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:21:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6862E68D
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:21:30 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CEupfK009149;
        Wed, 12 Oct 2022 16:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z+GPgkJu3FJBOjk5mugbRfyw0V55UQC9bEF1ch6NwOs=;
 b=Me8JBacg6PYWH8XNt4aslEfYN4ei79Z8bivCnrTzQZcRNckrUw6USQgNLzEUM0ShXdFN
 u9krNb/P6rgtVTqRHmntN/lbZaMmtB1mDM9b8eGmepovI3yRjE5Y8UcGcOln0Bp2ge8b
 nmruqj+iT2YmH17f8k3oSS0EWAcEFnwIZAaL8Ocs0Wd807Ozk34vA5MI3IcmsrCAdww2
 AjW58LY3b7w168l1VJ6HedFBJ3VSonW5MIn37WE97hrjm6jP+ebbDTOyRr9biYr2mqDu
 0aMkiJouoEL3OgGxFLPRPLLYh5N8UToN6mLfWIkGg+7PgP8QODgNKB06FHgeDfRiJT+9 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ysv2s7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CEwTXB018132;
        Wed, 12 Oct 2022 16:21:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ysv2s6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CGLMQ1026224;
        Wed, 12 Oct 2022 16:21:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3k30u9mqua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CGLIex60752288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 16:21:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F35A4060;
        Wed, 12 Oct 2022 16:21:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C998BA4054;
        Wed, 12 Oct 2022 16:21:17 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.34.168])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 16:21:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: [PATCH v10 6/9] s390x/cpu topology: add topology-disable machine property
Date:   Wed, 12 Oct 2022 18:21:04 +0200
Message-Id: <20221012162107.91734-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221012162107.91734-1-pmorel@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8KXMZl68l2hlQol48vcLLXe5kD5wFIE6
X-Proofpoint-GUID: gX9ncgjI2Si_7Jntpugil_9zh-hBYc5W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390 CPU topology is only allowed for s390-virtio-ccw-7.3 and
newer S390 machines.
We keep the possibility to disable the topology on these newer
machines with the property topology-disable.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/boards.h                |  3 ++
 include/hw/s390x/cpu-topology.h    | 18 +++++++++-
 include/hw/s390x/s390-virtio-ccw.h |  2 ++
 hw/core/machine.c                  |  5 +++
 hw/s390x/s390-virtio-ccw.c         | 53 +++++++++++++++++++++++++++++-
 util/qemu-config.c                 |  4 +++
 qemu-options.hx                    |  6 +++-
 7 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 311ed17e18..67147c47bf 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -379,6 +379,9 @@ struct MachineState {
     } \
     type_init(machine_initfn##_register_types)
 
+extern GlobalProperty hw_compat_7_2[];
+extern const size_t hw_compat_7_2_len;
+
 extern GlobalProperty hw_compat_7_1[];
 extern const size_t hw_compat_7_1_len;
 
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 35a8a981ec..747c9ab4c6 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -12,6 +12,8 @@
 
 #include "hw/qdev-core.h"
 #include "qom/object.h"
+#include "cpu.h"
+#include "hw/s390x/s390-virtio-ccw.h"
 
 #define S390_TOPOLOGY_POLARITY_H  0x00
 
@@ -43,7 +45,21 @@ void s390_topology_new_cpu(int core_id);
 
 static inline bool s390_has_topology(void)
 {
-    return false;
+    static S390CcwMachineState *ccw;
+    Object *obj;
+
+    if (ccw) {
+        return !ccw->topology_disable;
+    }
+
+    /* we have to bail out for the "none" machine */
+    obj = object_dynamic_cast(qdev_get_machine(),
+                              TYPE_S390_CCW_MACHINE);
+    if (!obj) {
+        return false;
+    }
+    ccw = S390_CCW_MACHINE(obj);
+    return !ccw->topology_disable;
 }
 
 #endif
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 9e7a0d75bc..6c4b4645fc 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -28,6 +28,7 @@ struct S390CcwMachineState {
     bool dea_key_wrap;
     bool pv;
     bool zpcii_disable;
+    bool topology_disable;
     uint8_t loadparm[8];
 };
 
@@ -46,6 +47,7 @@ struct S390CcwMachineClass {
     bool cpu_model_allowed;
     bool css_migration_enabled;
     bool hpage_1m_allowed;
+    bool topology_allowed;
 };
 
 /* runtime-instrumentation allowed by the machine */
diff --git a/hw/core/machine.c b/hw/core/machine.c
index aa520e74a8..93c497655e 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -40,6 +40,11 @@
 #include "hw/virtio/virtio-pci.h"
 #include "qom/object_interfaces.h"
 
+GlobalProperty hw_compat_7_2[] = {
+    { "s390-topology", "topology-disable", "true" },
+};
+const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
+
 GlobalProperty hw_compat_7_1[] = {};
 const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
 
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 362378454a..3a13fad4df 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -616,6 +616,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     s390mc->cpu_model_allowed = true;
     s390mc->css_migration_enabled = true;
     s390mc->hpage_1m_allowed = true;
+    s390mc->topology_allowed = true;
     mc->init = ccw_init;
     mc->reset = s390_machine_reset;
     mc->block_default_type = IF_VIRTIO;
@@ -726,6 +727,27 @@ bool hpage_1m_allowed(void)
     return get_machine_class()->hpage_1m_allowed;
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
+    if (!get_machine_class()->topology_allowed) {
+        error_setg(errp, "Property topology-disable not available on machine %s",
+                   get_machine_class()->parent_class.name);
+        return;
+    }
+
+    ms->topology_disable = value;
+}
+
 static char *machine_get_loadparm(Object *obj, Error **errp)
 {
     S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
@@ -784,6 +806,13 @@ static inline void s390_machine_initfn(Object *obj)
     object_property_set_description(obj, "zpcii-disable",
             "disable zPCI interpretation facilties");
     object_property_set_bool(obj, "zpcii-disable", false, NULL);
+
+    object_property_add_bool(obj, "topology-disable",
+                             machine_get_topology_disable,
+                             machine_set_topology_disable);
+    object_property_set_description(obj, "topology-disable",
+            "disable CPU topology");
+    object_property_set_bool(obj, "topology-disable", false, NULL);
 }
 
 static const TypeInfo ccw_machine_info = {
@@ -836,14 +865,36 @@ bool css_migration_enabled(void)
     }                                                                         \
     type_init(ccw_machine_register_##suffix)
 
+static void ccw_machine_7_3_instance_options(MachineState *machine)
+{
+}
+
+static void ccw_machine_7_3_class_options(MachineClass *mc)
+{
+}
+DEFINE_CCW_MACHINE(7_3, "7.3", true);
+
 static void ccw_machine_7_2_instance_options(MachineState *machine)
 {
+    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
+
+    ccw_machine_7_3_instance_options(machine);
+    ms->topology_disable = true;
 }
 
 static void ccw_machine_7_2_class_options(MachineClass *mc)
 {
+    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
+    static GlobalProperty compat[] = {
+        { TYPE_S390_CPU_TOPOLOGY, "topology-allowed", "off", },
+    };
+
+    ccw_machine_7_3_class_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_7_2, hw_compat_7_2_len);
+    compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
+    s390mc->topology_allowed = false;
 }
-DEFINE_CCW_MACHINE(7_2, "7.2", true);
+DEFINE_CCW_MACHINE(7_2, "7.2", false);
 
 static void ccw_machine_7_1_instance_options(MachineState *machine)
 {
diff --git a/util/qemu-config.c b/util/qemu-config.c
index 5325f6bf80..c19e8bc8f3 100644
--- a/util/qemu-config.c
+++ b/util/qemu-config.c
@@ -240,6 +240,10 @@ static QemuOptsList machine_opts = {
             .name = "zpcii-disable",
             .type = QEMU_OPT_BOOL,
             .help = "disable zPCI interpretation facilities",
+        },{
+            .name = "topology-disable",
+            .type = QEMU_OPT_BOOL,
+            .help = "disable CPU topology",
         },
         { /* End of list */ }
     }
diff --git a/qemu-options.hx b/qemu-options.hx
index 95b998a13b..c804b0f899 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -38,7 +38,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                hmat=on|off controls ACPI HMAT support (default=off)\n"
     "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
     "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
-    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
+    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n"
+    "                topology-disable=on|off disables CPU topology (default=off)\n",
     QEMU_ARCH_ALL)
 SRST
 ``-machine [type=]name[,prop=value[,...]]``
@@ -163,6 +164,9 @@ SRST
         Disables zPCI interpretation facilties on s390-ccw hosts.
         This feature can be used to disable hardware virtual assists
         related to zPCI devices. The default is off.
+
+    ``topology-disable=on|off``
+        Disables CPU topology on for S390 machines starting with s390-ccw-virtio-7.3.
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
-- 
2.31.1

