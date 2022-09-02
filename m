Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB495AB783
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiIBR2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiIBR17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:27:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775406DAF1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:27:58 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282H2DAZ025756;
        Fri, 2 Sep 2022 17:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=42lqiXmc8OHpJYGIcOpi1qlDB3VALI3G+v4Utk5q9G4=;
 b=NxZnY3+Zv0L3AoEEWvoQxtYjsc8DXjoDa8er4mj08FoJvUVBsERjcwe7kzzAF5QvBuLJ
 V23mtPstDXhiQCEgWnWV/KafrIIxX0Cv1DLymv4BA1YcxGDNKc+eXLogc7at1Ml1bmP7
 8Kz0JadAEIdmPBZiW8234B6w1cxcbojeo2w0bALN3Q/zkl0stcg7gh2rjP+C5pB0X70V
 z1C5SJFhcpSQY6JHu0VFlNHkOiiqcJP6k1s3f5GXZwVDcFbzdZru3JDxK/Z+uZgrB/Y6
 t/masBQDar9mudmpl1CKe90lMspe6ETyHQhHYnl/CBfz5nUcJyLIwTO7movyDb2mbkvv Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnvarkv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:54 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 282H35ij028544;
        Fri, 2 Sep 2022 17:27:54 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnvarkun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:53 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 282HLDRv025821;
        Fri, 2 Sep 2022 17:27:52 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3j7awa1cpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 282HRptE40436262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 17:27:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 543586E050;
        Fri,  2 Sep 2022 17:27:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AFBF6E04E;
        Fri,  2 Sep 2022 17:27:50 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.86.252])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 17:27:49 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v8 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine property
Date:   Fri,  2 Sep 2022 13:27:37 -0400
Message-Id: <20220902172737.170349-9-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902172737.170349-1-mjrosato@linux.ibm.com>
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KpNU8MXO4yR83BO7wh2c2Ml6lv7SjDKi
X-Proofpoint-GUID: 7pVLAk-8F4zNoTtCQWzoxsBP4GIrS3VF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_04,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zpcii-disable machine property can be used to force-disable the use
of zPCI interpretation facilities for a VM.  By default, this setting
will be off for machine 7.2 and newer.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-kvm.c            |  4 +++-
 hw/s390x/s390-virtio-ccw.c         | 25 +++++++++++++++++++++++++
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 qemu-options.hx                    |  8 +++++++-
 util/qemu-config.c                 |  4 ++++
 5 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
index 9134fe185f..5eb7fd12e2 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -22,7 +22,9 @@
 
 bool s390_pci_kvm_interp_allowed(void)
 {
-    return kvm_s390_get_zpci_op() && !s390_is_pv();
+    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
+            !object_property_get_bool(OBJECT(qdev_get_machine()),
+                                      "zpcii-disable", NULL));
 }
 
 int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 9a2467c889..f8ecb6172c 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -645,6 +645,21 @@ static inline void machine_set_dea_key_wrap(Object *obj, bool value,
     ms->dea_key_wrap = value;
 }
 
+static inline bool machine_get_zpcii_disable(Object *obj, Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    return ms->zpcii_disable;
+}
+
+static inline void machine_set_zpcii_disable(Object *obj, bool value,
+                                             Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    ms->zpcii_disable = value;
+}
+
 static S390CcwMachineClass *current_mc;
 
 /*
@@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object *obj)
             "Up to 8 chars in set of [A-Za-z0-9. ] (lower case chars converted"
             " to upper case) to pass to machine loader, boot manager,"
             " and guest kernel");
+
+    object_property_add_bool(obj, "zpcii-disable",
+                             machine_get_zpcii_disable,
+                             machine_set_zpcii_disable);
+    object_property_set_description(obj, "zpcii-disable",
+            "disable zPCI interpretation facilties");
+    object_property_set_bool(obj, "zpcii-disable", false, NULL);
 }
 
 static const TypeInfo ccw_machine_info = {
@@ -803,8 +825,11 @@ DEFINE_CCW_MACHINE(7_2, "7.2", true);
 
 static void ccw_machine_7_1_instance_options(MachineState *machine)
 {
+    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
+
     ccw_machine_7_2_instance_options(machine);
     s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
+    ms->zpcii_disable = true;
 }
 
 static void ccw_machine_7_1_class_options(MachineClass *mc)
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 3331990e02..8a0090a071 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -27,6 +27,7 @@ struct S390CcwMachineState {
     bool aes_key_wrap;
     bool dea_key_wrap;
     bool pv;
+    bool zpcii_disable;
     uint8_t loadparm[8];
 };
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 31c04f7eea..7427dd1ed5 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -37,7 +37,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
     "                hmat=on|off controls ACPI HMAT support (default=off)\n"
     "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
-    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
+    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
+    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
     QEMU_ARCH_ALL)
 SRST
 ``-machine [type=]name[,prop=value[,...]]``
@@ -157,6 +158,11 @@ SRST
         ::
 
             -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512k
+
+    ``zpcii-disable=on|off``
+        Disables zPCI interpretation facilties on s390-ccw hosts.
+        This feature can be used to disable hardware virtual assists
+        related to zPCI devices. The default is off.
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
diff --git a/util/qemu-config.c b/util/qemu-config.c
index 433488aa56..5325f6bf80 100644
--- a/util/qemu-config.c
+++ b/util/qemu-config.c
@@ -236,6 +236,10 @@ static QemuOptsList machine_opts = {
             .help = "Up to 8 chars in set of [A-Za-z0-9. ](lower case chars"
                     " converted to upper case) to pass to machine"
                     " loader, boot manager, and guest kernel",
+        },{
+            .name = "zpcii-disable",
+            .type = QEMU_OPT_BOOL,
+            .help = "disable zPCI interpretation facilities",
         },
         { /* End of list */ }
     }
-- 
2.37.2

