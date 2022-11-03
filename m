Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603A56185A2
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiKCRDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiKCRCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F2213E27
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:36 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FhGdM029380;
        Thu, 3 Nov 2022 17:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kcy6rM/fvhJbpTFYSiVE0GBpc6I3jC+Y19ZPrc4elMY=;
 b=rMmZ8khxmFjD4+pgJ0TdWPLWLm8HB8MbAKN/XsvBMHQvFv0HGwmCDS/13gJjBGEJyfr/
 LbrNuS+pjm0QjD/DmcSVC+Tc6k2B6eWpb4KojTqmU4+a1R/e7WSGotMifptb9cygPwJ4
 vUvfoSIHZ3T68I5jJz8pg8V8ziw4u6rEB9wTbovms3Y3xDnNKMCzRaFi8oa60C8DXP7p
 XFpOtTgsB/vR3Ff74Z7N/Fshrkehtd/RI/6qZQOUI+FKrFUjJDbuADle7FUqAk5xNUvE
 0dwpXyMra2hHwe5chiKCcOhEWaAxPeFMgUkKjUmHqr/UmUcVsccENdinnF11O1hq22VM cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme7ygnkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:02:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3GxYcJ003089;
        Thu, 3 Nov 2022 17:02:03 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme7ygnhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:02:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3GaXUb001000;
        Thu, 3 Nov 2022 17:01:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3kjepeckyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3H1uqS63242528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 17:01:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EF0852050;
        Thu,  3 Nov 2022 17:01:56 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B906E52052;
        Thu,  3 Nov 2022 17:01:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v11 09/11] s390x/cpu topology: add topology machine property
Date:   Thu,  3 Nov 2022 18:01:48 +0100
Message-Id: <20221103170150.20789-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K-Gsl0GWnhWWNfbCY6UBTmH18p7a7T6h
X-Proofpoint-ORIG-GUID: xtPeVrG2aXlCpUxtH5oPmTglrTUu7p51
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We keep the possibility to switch on/off the topology on newer
machines with the property topology=[on|off].

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/boards.h                |  3 +++
 include/hw/s390x/cpu-topology.h    |  8 +++-----
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 hw/core/machine.c                  |  3 +++
 hw/s390x/cpu-topology.c            | 19 +++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c         | 28 ++++++++++++++++++++++++++++
 util/qemu-config.c                 |  4 ++++
 qemu-options.hx                    |  6 +++++-
 8 files changed, 66 insertions(+), 6 deletions(-)

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
index 6fec10e032..f566394302 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -12,6 +12,8 @@
 
 #include "hw/qdev-core.h"
 #include "qom/object.h"
+#include "cpu.h"
+#include "hw/s390x/s390-virtio-ccw.h"
 
 #define S390_TOPOLOGY_CPU_IFL 0x03
 #define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
@@ -38,10 +40,6 @@ struct S390Topology {
 OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
 
 void s390_topology_new_cpu(S390CPU *cpu);
-
-static inline bool s390_has_topology(void)
-{
-    return false;
-}
+bool s390_has_topology(void);
 
 #endif
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 89fca3f79f..d7602aedda 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -28,6 +28,7 @@ struct S390CcwMachineState {
     bool dea_key_wrap;
     bool pv;
     bool zpcii_disable;
+    bool cpu_topology;
     uint8_t loadparm[8];
     void *topology;
 };
diff --git a/hw/core/machine.c b/hw/core/machine.c
index aa520e74a8..4f46d4ef23 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -40,6 +40,9 @@
 #include "hw/virtio/virtio-pci.h"
 #include "qom/object_interfaces.h"
 
+GlobalProperty hw_compat_7_2[] = {};
+const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
+
 GlobalProperty hw_compat_7_1[] = {};
 const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
 
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index fc220bd8ac..c1550cc1e8 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -73,6 +73,25 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
     }
 }
 
+bool s390_has_topology(void)
+{
+    static S390CcwMachineState *ccw;
+    Object *obj;
+
+    if (ccw) {
+        return ccw->cpu_topology;
+    }
+
+    /* we have to bail out for the "none" machine */
+    obj = object_dynamic_cast(qdev_get_machine(),
+                              TYPE_S390_CCW_MACHINE);
+    if (!obj) {
+        return false;
+    }
+    ccw = S390_CCW_MACHINE(obj);
+    return ccw->cpu_topology;
+}
+
 /*
  * s390_topology_new_cpu:
  * @cpu: a pointer to the new CPU
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index f1a9d6e793..ebb5615337 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -710,6 +710,26 @@ bool hpage_1m_allowed(void)
     return get_machine_class()->hpage_1m_allowed;
 }
 
+static inline bool machine_get_topology(Object *obj, Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    return ms->cpu_topology;
+}
+
+static inline void machine_set_topology(Object *obj, bool value, Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    if (!get_machine_class()->topology_capable) {
+        error_setg(errp, "Property cpu-topology not available on machine %s",
+                   get_machine_class()->parent_class.name);
+        return;
+    }
+
+    ms->cpu_topology = value;
+}
+
 static void machine_get_loadparm(Object *obj, Visitor *v,
                                  const char *name, void *opaque,
                                  Error **errp)
@@ -809,6 +829,12 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
                                    machine_set_zpcii_disable);
     object_class_property_set_description(oc, "zpcii-disable",
             "disable zPCI interpretation facilties");
+
+    object_class_property_add_bool(oc, "topology",
+                                   machine_get_topology,
+                                   machine_set_topology);
+    object_class_property_set_description(oc, "topology",
+            "enable CPU topology");
 }
 
 static inline void s390_machine_initfn(Object *obj)
@@ -818,6 +844,7 @@ static inline void s390_machine_initfn(Object *obj)
     ms->aes_key_wrap = true;
     ms->dea_key_wrap = true;
     ms->zpcii_disable = false;
+    ms->cpu_topology = true;
 }
 
 static const TypeInfo ccw_machine_info = {
@@ -888,6 +915,7 @@ static void ccw_machine_7_1_instance_options(MachineState *machine)
     s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
     s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
     ms->zpcii_disable = true;
+    ms->cpu_topology = true;
 }
 
 static void ccw_machine_7_1_class_options(MachineClass *mc)
diff --git a/util/qemu-config.c b/util/qemu-config.c
index 5325f6bf80..0a040552bd 100644
--- a/util/qemu-config.c
+++ b/util/qemu-config.c
@@ -240,6 +240,10 @@ static QemuOptsList machine_opts = {
             .name = "zpcii-disable",
             .type = QEMU_OPT_BOOL,
             .help = "disable zPCI interpretation facilities",
+        },{
+            .name = "topology",
+            .type = QEMU_OPT_BOOL,
+            .help = "disable CPU topology",
         },
         { /* End of list */ }
     }
diff --git a/qemu-options.hx b/qemu-options.hx
index eb38e5dc40..ef59b28a03 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -38,7 +38,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                hmat=on|off controls ACPI HMAT support (default=off)\n"
     "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
     "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
-    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
+    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n"
+    "                topology=on|off disables CPU topology (default=off)\n",
     QEMU_ARCH_ALL)
 SRST
 ``-machine [type=]name[,prop=value[,...]]``
@@ -163,6 +164,9 @@ SRST
         Disables zPCI interpretation facilties on s390-ccw hosts.
         This feature can be used to disable hardware virtual assists
         related to zPCI devices. The default is off.
+
+    ``topology=on|off``
+        Disables CPU topology on for S390 machines starting with s390-ccw-virtio-7.3.
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
-- 
2.31.1

